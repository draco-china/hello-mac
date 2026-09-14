#!/bin/bash
# Fixtures intentionally contain literal variables; mocks are invoked by sourced helpers.
# Subshell variables intentionally isolate the fixture.
# shellcheck disable=SC2016,SC2329,SC2030
set -euo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
bash -n "$ROOT_DIR/setup.sh" "$ROOT_DIR/scripts/common.sh" "$ROOT_DIR/scripts/shell.sh"
"$ROOT_DIR/setup.sh" --help >/dev/null
"$ROOT_DIR/setup.sh" all --dry-run > "$test_dir/plan"
grep -q 'brew bundle install' "$test_dir/plan"
if grep -q -- '--no-upgrade' "$test_dir/plan"; then exit 1; fi
if "$ROOT_DIR/setup.sh" --file "$test_dir/missing" --dry-run >/dev/null 2>&1; then exit 1; fi
if "$ROOT_DIR/setup.sh" --unknown >/dev/null 2>&1; then exit 1; fi
if "$ROOT_DIR/setup.sh" --file >/dev/null 2>&1; then exit 1; fi
(
    # All writes stay in the fixture; no real brew, git or installers execute.
    export HOME="$test_dir/home with spaces"
    export ZSH="$HOME/custom omz"
    export ZSH_CUSTOM="$HOME/custom plugins"
    export ZDOTDIR="$HOME/zsh config"
    mkdir -p "$ZSH" "$ZDOTDIR"
    touch "$ZSH/oh-my-zsh.sh"
    printf '# personal configuration\nplugins=(git)\nsource "$ZSH/oh-my-zsh.sh"\n' > "$ZDOTDIR/.zshrc"
    # shellcheck source=scripts/common.sh
    source "$ROOT_DIR/scripts/common.sh"
    # shellcheck source=scripts/shell.sh
    source "$ROOT_DIR/scripts/shell.sh"
    brew() { printf 'brew %s\n' "$*" >> "$test_dir/calls"; }
    git() {
        printf 'git %s\n' "$*" >> "$test_dir/calls"
        mkdir -p "$4/.git"
        if [[ $4 == */spaceship-prompt ]]; then touch "$4/spaceship.zsh-theme"; fi
    }
    install_remote() { echo 'Unexpected network call' >&2; exit 1; }
    DRY_RUN=1 CONFIGURE_ZSHRC=1
    install_shell >/dev/null
    [[ ! -e $test_dir/calls ]]
    [[ ! -e $ZSH_CUSTOM ]]
    grep -qx '# personal configuration' "$ZDOTDIR/.zshrc"
    DRY_RUN=0 CONFIGURE_ZSHRC=0
    install_shell >/dev/null
    grep -qx '# personal configuration' "$ZDOTDIR/.zshrc"
    [[ -L $ZSH_CUSTOM/themes/spaceship.zsh-theme ]]
    install_shell >/dev/null
    [[ $(grep -c '^git ' "$test_dir/calls") == 3 ]]
    CONFIGURE_ZSHRC=1
    install_shell >/dev/null
    grep -qx '# personal configuration' "$ZDOTDIR"/.zshrc.hello-mac-backup.*
    grep -q 'ZSH_THEME="spaceship"' "$ZDOTDIR/.zshrc"
    if command -v zsh >/dev/null; then zsh -n "$ZDOTDIR/.zshrc"; fi
    install_shell >/dev/null
    [[ $(grep -c '^# >>> Hello Mac >>>$' "$ZDOTDIR/.zshrc") == 1 ]]
    grep -qx '# personal configuration' "$ZDOTDIR/.zshrc"
    # Fresh config comes from the installed official template.
    mkdir -p "$ZSH/templates"
    printf '# upstream defaults\nplugins=(git)\nsource "$ZSH/oh-my-zsh.sh"\n' > "$ZSH/templates/zshrc.zsh-template"
    rm "$ZDOTDIR/.zshrc"
    install_shell >/dev/null
    grep -qx '# upstream defaults' "$ZDOTDIR/.zshrc"
    # An occupied, non-repository path must not silently pass as an installation.
    mkdir -p "$test_dir/not-a-repo"
    if (clone_missing example "$test_dir/not-a-repo") >/dev/null 2>&1; then exit 1; fi
)
(
    # shellcheck source=scripts/common.sh
    source "$ROOT_DIR/scripts/common.sh"
    curl() { return 22; }
    if (install_remote example /bin/bash); then exit 1; fi
)
printf 'Smoke tests passed.\n'
