#! /bin/bash

cat << -EOF
############################################################
# 当前脚本用于在运行OS X的电脑上安装应用程序
# 使用Homebrew作为OS X的包管理器来安装应用程序
############################################################
-EOF

# 安装 Homebrew
install_homebrew(){
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# 添加软件仓库
brew_tap_list(){
	brew tap homebrew/cask-versions
	brew tap homebrew/cask-fonts
	# brew tap homebrew/services
	# brew tap mongodb/brew
}

# GUI软件包清单
# 在这里添加或者删除你需要的GUI软件包名称

brew_cask_app_list=(
	# Adobe
	adobe-creative-cloud
	# 暴雪战网
	battle-net
	# ssh工具客户端
	electerm
	# 抓包神器 / Mock工具
	# charles
	# 应用快捷键提示
	cheatsheet
	# clashx
	clashx-pro
	# Mac专属的文档管理工具
	dash
	# 钉钉
	dingtalk
	# Fira Code字体
	font-fira-code
	# Google 浏览器
	google-chrome
	# 视频播放器
	iina
	# 终端
	iterm2
	# 飞书
	lark
	# 网易云音乐
	neteasemusic
	# 一款全能的下载工具
	# motrix
	# 虚拟机
	parallels
	# 血小板
	# platelet
	# Touchbar 自定义
	pock
	# API 请求测试
	# postman
	# qq
	qq
	# qq音乐
	qqmusic
	# ssh工具客户端
	# royal-tsx
	# 远程工具
	teamviewer
	# 腾讯柠檬清理
	tencent-lemon
	# 腾讯会议
	# tencent-meetin
	# OpenVPN Client 的一个 GUI 版本
	# tunnelblick
	# idea
	visual-studio-code
	# 虚拟机
	vmware-fusion
	# 微信
	wechat
	# 微信开发者工具
	wechatwebdevtools
	# 远程会议
	# zoom
)

# CLI软件包清单
brew_cli_app_list=(
	# nginx
	# node
	nvm
	# yarn
	# mongodb-community
	bat
)

# 安装GUI软件包
install_cask_app(){
	for app in ${brew_cask_app_list[@]}; do
		brew install $app --cask 
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
