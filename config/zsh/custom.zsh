# Loaded immediately before Oh My Zsh. The surrounding .zshrc stays intact.
# Load Homebrew on Apple Silicon and Intel when it is not already on PATH.
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

ZSH_THEME="spaceship"
# Keep Spaceship's default two-line layout, async rendering, environment detection,
# and directory shortening. Show the time without seconds.
SPACESHIP_TIME_SHOW="true"
SPACESHIP_TIME_FORMAT='%D{%H:%M}'
# The default user visibility shows SSH, root, and switched-user sessions.
SPACESHIP_USER_COLOR="212"
# Only show execution time for commands that take at least five seconds.
SPACESHIP_EXEC_TIME_ELAPSED=5

# Preserve existing plugins; keep syntax highlighting last and avoid duplicates.
typeset -U plugins
plugins=("${plugins[@]:#zsh-syntax-highlighting}" zsh-autosuggestions zsh-syntax-highlighting)

# NVM 配置
export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null 2>&1; then
  _hellomac_nvm_prefix="$(brew --prefix)/opt/nvm"
  [ ! -s "$_hellomac_nvm_prefix/nvm.sh" ] || \. "$_hellomac_nvm_prefix/nvm.sh"  # This loads nvm
  [ ! -s "$_hellomac_nvm_prefix/etc/bash_completion.d/nvm" ] || \. "$_hellomac_nvm_prefix/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  unset _hellomac_nvm_prefix
fi
