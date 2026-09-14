#!/bin/bash
# Install the actual shell components without changing the user's .zshrc.
set -euo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$ROOT_DIR/scripts/common.sh"
# shellcheck source=scripts/shell.sh
source "$ROOT_DIR/scripts/shell.sh"
[[ -n ${HELLO_MAC_DEMO_DIR:-} ]] || die 'Set HELLO_MAC_DEMO_DIR to an empty temporary directory.'
[[ ! -e $HELLO_MAC_DEMO_DIR ]] || die 'Demo directory already exists; choose a fresh directory.'
mkdir -p "$HELLO_MAC_DEMO_DIR"
HELLO_MAC_DEMO_DIR="$(cd "$HELLO_MAC_DEMO_DIR" && pwd)"
export ZSH="$HELLO_MAC_DEMO_DIR/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export ZDOTDIR="$HELLO_MAC_DEMO_DIR/zsh"
mkdir -p "$ZDOTDIR" "$HELLO_MAC_DEMO_DIR/cache"
DRY_RUN=0
CONFIGURE_ZSHRC=1
configure_shell
{
    printf 'export ZSH_CACHE_DIR=%q\n' "$HELLO_MAC_DEMO_DIR/cache"
    printf 'export ZSH_COMPDUMP=%q\n' "$HELLO_MAC_DEMO_DIR/zcompdump"
    printf 'export HISTFILE=%q\n' "$HELLO_MAC_DEMO_DIR/history"
    printf "zstyle ':omz:update' mode disabled\n"
} > "$ZDOTDIR/.zshenv"
# Start with empty, isolated history. Commands recorded below populate it naturally.
: > "$HELLO_MAC_DEMO_DIR/history"
printf 'Prepared personalized Zsh environment at %s\n' "$ZDOTDIR"
