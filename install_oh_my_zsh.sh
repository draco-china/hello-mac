#! /bin/bash

echo -e "安装 sourcecodepro 字体"
brew tap homebrew/cask-fonts
brew cask install font-sourcecodepro-nerd-font-mono --cask
# brew install font-sourcecodepro-nerd-font --cask

echo -e "安装 oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo -e "安装 zsh-autosuggestions 自动提示插件"
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo -e "安装 zsh-syntax-highlighting 语法高亮插件"
git clone git://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# echo "安装 zsh-completions 自动补全插件"
# git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions

echo -e "安装 spaceship-prompt 主题"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo -e "复制 .zshrc 配置"
cp .zshrc ~/.zshrc

echo -e "查看安装的 shell"
cat /etc/shells

echo -e "切换默认 shell 为 zsh"
chsh -s /bin/zsh

echo -e "更新配置"
source ~/.zshrc
