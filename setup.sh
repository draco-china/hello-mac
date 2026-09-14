#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "$ROOT_DIR/scripts/common.sh"

usage() {
    cat <<'HELP'
Usage: ./setup.sh [apps|shell|all] [options]
  apps                Install apps from the Brewfile (default)
  shell               Install Oh My Zsh, plugins, Spaceship, and font
  all                 Run apps, then shell
  --file PATH         Use a custom Brewfile (relative to current directory)
  --dry-run           Preview without downloading, installing, or changing config
  --configure-zshrc   Back up and configure an existing .zshrc
  -h, --help          Show this help
HELP
}
action=apps
if [[ $# -gt 0 && $1 != -* ]]; then action=$1; shift; fi
case "$action" in apps|shell|all) ;; *) die "Unknown command: $action" ;; esac
BREWFILE="$ROOT_DIR/Brewfile"
DRY_RUN=0
CONFIGURE_ZSHRC=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --file) [[ $# -ge 2 && -n $2 ]] || die '--file requires a path'; BREWFILE=$2; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        --configure-zshrc) CONFIGURE_ZSHRC=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option: $1" ;;
    esac
done
if [[ $action != shell ]]; then [[ -f $BREWFILE ]] || die "Brewfile not found: $BREWFILE"; fi
if [[ $DRY_RUN == 0 ]]; then
    [[ $(uname -s) == Darwin ]] || die 'Setup requires macOS. Use --dry-run to preview on other platforms.'
    [[ $EUID -ne 0 ]] || die 'Run as your normal user, without sudo.'
fi
ensure_homebrew
if [[ $action != shell ]]; then
    run brew bundle install --file="$BREWFILE" --no-upgrade
fi
if [[ $action != apps ]]; then
    # shellcheck source=scripts/shell.sh
    source "$ROOT_DIR/scripts/shell.sh"
    install_shell
fi
