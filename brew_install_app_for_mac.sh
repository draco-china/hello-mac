#! /bin/bash

cat << -EOF
############################################################
# 当前脚本用于在运行OS X的电脑上安装应用程序
# 使用Homebrew作为OS X的包管理器来安装应用程序
############################################################
-EOF

# 安装Homebrew
install_homebrew(){
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# 添加软件仓库
brew_tap_list(){
	brew tap caskroom/versions
	brew tap caskroom/cask
}

# GUI软件包清单
# 在这里添加或者删除你需要的GUI软件包名称

brew_cask_app_list=(
aliwangwang
folx
microsoft-office
typora
battle-net
google-chrome
shadowsocksx-ng
visual-studio-code
cleanmymac
iina-beta
sketch
vmware-fusion
dash
iterm2
teamviewer
webstorm
docker
java8
thunder
wechatwebdevtools
navicat-premium
)

# CLI软件包清单
brew_cli_app_list=(
mysql
node
tomcat
)

# 安装GUI软件包
install_cask_app(){
	for app in ${brew_cask_app_list[@]}; do
		brew cask install $app
	done
}

# 安装CLI软件包
install_cli_app(){
	for app in ${brew_cli_app_list[@]}; do
		brew install $app
	done
}


# 这里只是用于提示用户，使用Ctrl C退出
read -t 5 -p "按下任意键继续，如需退出，请按Ctrl C，倒计时5秒" user_command
if command -v brew > /dev/null 2>&1; then
	echo -e '您的Mac已经安装了Homebrew，即将为您安装列表中的软件包🍻  \n'
else
	echo -e '您的Mac OS尚未安装Homebrew，正准备为您安装🍻  \n'
	install_homebrew
	brew update
fi

# 添加软件仓库
brew_tap_list

# CLI软件包清单
install_cli_app

# 安装GUI软件包
install_cask_app

# 清理历史版本的包缓存
brew cleanup

