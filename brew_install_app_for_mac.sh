#! /bin/bash

cat << -EOF
############################################################
# 当前脚本用于在运行OS X的电脑上安装应用程序
# 使用Homebrew作为OS X的包管理器来安装应用程序
############################################################
-EOF

# 安装 Homebrew
install_homebrew(){
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_homebrew_ustc(){
	/usr/bin/ruby -e ./install_homebrew_ustc

	git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git

	git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

	git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
}

install_homebrew_tuna_tsinghua(){
	/usr/bin/ruby -e ./install_homebrew_tuna_tsinghua
	
	git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

	git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

	git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git

}


# 添加软件仓库
brew_tap_list(){
	brew tap homebrew/cask
	brew tap homebrew/cask-drivers
	brew tap homebrew/cask-fonts
	brew tap homebrew/cask-versions
	brew tap homebrew/core
	brew tap homebrew/services
	brew tap mongodb/brew
}

# GUI软件包清单
# 在这里添加或者删除你需要的GUI软件包名称

brew_cask_app_list=(
	adobe-creative-cloud	# Adobe
	aliworkbench		# 千牛卖家工作台
	battle-net		# 暴雪战网
	# charles		# 抓包神器 / Mock工具
	cheatsheet		# 应用快捷键提示
	clashx-pro		# clashx
	dash          		# Mac专属的文档管理工具
	google-chrome		# Google 浏览器
	iina			# 视频播放器
	iterm2			# 终端
	lark			# 飞书
	motrix			# 一款全能的下载工具
	# platelet		# 血小板
	pock			# Touchbar 自定义
	postman			# API 请求测试
	royal-tsx		# ssh工具客户端
	teamviewer		# 远程工具
	tencent-lemon		# 腾讯柠檬清理
	# tencent-meeting	# 腾讯会议
	# tunnelblick		# OpenVPN Client 的一个 GUI 版本
	typora     		# markdown 编辑器
	visual-studio-code	# idea
	vmware-fusion		# 虚拟机
	wechatwebdevtools	# 微信开发者工具
	# zoom			# 远程会议
)

# CLI软件包清单
brew_cli_app_list=(
	# nginx
	# node
	nvm
	yarn
	# mongodb-community
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
	if read -t 3 -sp "按下任意键选择安装源，倒计时3秒后选择默认源安装🍻" user_command;then
		PS3="请选择 Homebrew 安装源: "
		select oper in "默认源" "中科大" "清华大学"; do # 生成选择菜单
		case ${oper} in
			"默认源")
				echo -e '开始从 默认源 安装Homebrew🍻  \n'
				return install_homebrew
			;;
			"中科大")
				echo -e '开始从 中科大 安装Homebrew🍻  \n'
				return install_homebrew_mirrors_ustc
			;;
			"清华大学")
				echo -e '开始从 清华大学 安装Homebrew🍻  \n'
				return install_homebrew_tuna_tsinghua
			;;
			*)
				return install_homebrew
			;;
		esac
		break
		done
	else
		echo -e '开始从 默认源 安装Homebrew🍻  \n'
		install_homebrew
	fi
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
