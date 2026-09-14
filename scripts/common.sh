# shellcheck shell=bash
# Shared Bash 3.2-compatible helpers, sourced by setup.sh.
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
run() {
    if [[ $DRY_RUN == 1 ]]; then
        printf '[dry-run]'; printf ' %q' "$@"; printf '\n'
    else
        "$@"
    fi
}
# Download first: a failed curl must never look like a successful empty installer.
install_remote() (
    local installer
    installer=$(mktemp)
    trap 'rm -f "$installer"' EXIT
    curl --fail --silent --show-error --location "$1" -o "$installer" || exit $?
    shift
    "$@" "$installer"
)
ensure_homebrew() {
    if [[ $DRY_RUN == 1 ]]; then
        printf '[dry-run] Find Homebrew or install it with the official installer; load brew shellenv.\n'
        return
    fi
    if ! command -v brew >/dev/null 2>&1; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            install_remote https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh /bin/bash
            if [[ -x /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -x /usr/local/bin/brew ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
    fi
    command -v brew >/dev/null 2>&1 || die 'Homebrew is not available.'
}
