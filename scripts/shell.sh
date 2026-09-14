# shellcheck shell=bash
clone_missing() {
    if [[ -e $2 || -L $2 ]]; then
        [[ -d $2/.git ]] || die "Destination exists but is not a Git repository: $2"
        printf 'Keeping existing repository: %s\n' "$2"
    else
        run git clone --depth=1 "$1" "$2"
    fi
}
install_shell() {
    local zsh_dir custom_dir zshrc backup existed=0 base staged block
    local begin="# >>> Hello Mac >>>" end="# <<< Hello Mac <<<"
    zsh_dir=${ZSH:-$HOME/.oh-my-zsh}
    custom_dir=${ZSH_CUSTOM:-$zsh_dir/custom}
    zshrc=${ZDOTDIR:-$HOME}/.zshrc
    [[ ! -e $zshrc && ! -L $zshrc ]] || existed=1
    run brew install --cask font-sauce-code-pro-nerd-font
    if [[ ! -f $zsh_dir/oh-my-zsh.sh ]]; then
        [[ ! -e $zsh_dir && ! -L $zsh_dir ]] || die "Oh My Zsh directory exists but is incomplete: $zsh_dir"
        if [[ $DRY_RUN == 1 ]]; then
            printf '[dry-run] Install Oh My Zsh at %s with the official installer; keep config and default shell.\n' "$zsh_dir"
        else
            ZSH="$zsh_dir" KEEP_ZSHRC=yes CHSH=no RUNZSH=no install_remote \
                https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh /bin/sh
        fi
    fi
    run mkdir -p "$custom_dir/plugins" "$custom_dir/themes"
    clone_missing https://github.com/zsh-users/zsh-autosuggestions.git "$custom_dir/plugins/zsh-autosuggestions"
    clone_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_dir/plugins/zsh-syntax-highlighting"
    clone_missing https://github.com/spaceship-prompt/spaceship-prompt.git "$custom_dir/themes/spaceship-prompt"
    if [[ ! -e $custom_dir/themes/spaceship.zsh-theme && ! -L $custom_dir/themes/spaceship.zsh-theme ]]; then
        run ln -s "$custom_dir/themes/spaceship-prompt/spaceship.zsh-theme" "$custom_dir/themes/spaceship.zsh-theme"
    fi
    if [[ $existed == 1 && $CONFIGURE_ZSHRC == 0 ]]; then
        printf 'Keeping %s. Use --configure-zshrc to back up and apply the additional settings.\n' "$zshrc"
    elif [[ $DRY_RUN == 1 ]]; then
        printf '[dry-run] Add a configuration block before Oh My Zsh loads, using the official or existing .zshrc. Back up existing files first.\n'
    else
        base=$zshrc
        # An existing Oh My Zsh installation may not have a user .zshrc yet.
        [[ -f $base ]] || base="$zsh_dir/templates/zshrc.zsh-template"
        [[ -f $base ]] || die "Official Zsh template not found: $base"
        mkdir -p "$(dirname -- "$zshrc")"
        staged=$(mktemp "${zshrc}.hello-mac-stage.XXXXXX")
        block=$(mktemp)
        {
            printf '%s\n' "$begin"
            printf 'export ZSH=%q\nexport ZSH_CUSTOM=%q\n' "$zsh_dir" "$custom_dir"
            cat "$ROOT_DIR/config/zsh/custom.zsh"
            printf '%s\n' "$end"
        } > "$block"
        # Keep the official/user file verbatim outside our block, including comments.
        # Refuse nonstandard loading layouts instead of guessing where to insert.
        if ! awk -v block="$block" -v begin="$begin" -v end="$end" '
            $0 == begin { skip=1; next }
            $0 == end { skip=0; next }
            skip { next }
            /^[[:space:]]*source[[:space:]]/ && index($0, "$ZSH/oh-my-zsh.sh") {
                count++
                while ((getline line < block) > 0) print line
                close(block)
            }
            { print }
            END { if (count != 1 || skip) exit 1 }
        ' "$base" > "$staged"; then
            rm -f "$staged" "$block"
            die 'Expected one standard Oh My Zsh source line. File unchanged; merge config/zsh/custom.zsh manually.'
        fi
        rm -f "$block"
        if [[ -e $zshrc || -L $zshrc ]]; then
            backup=$(mktemp "${zshrc}.hello-mac-backup.XXXXXX")
            cp -p "$zshrc" "$backup"
            printf 'Configuration backed up to: %s\n' "$backup"
        fi
        mv -f "$staged" "$zshrc"
    fi
    printf 'Open a new terminal after setup. To change your default shell, run: chsh -s /bin/zsh\n'
}
