#!/bin/sh
# 如果任何语句的执行结果不是 true 则应该退出，防止问题扩大
set -e
setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

# 初始化颜色
setup_color

# 初始化账号
echo '${YELLOW}initializing user [yym]...'
useradd yym        # 创建用户 yym
passwd yym         # 设置用户 yym 的密码

# 添加用户 yym 使用 sudo 的权限
echo 'yym     ALL=(ALL:ALL) ALL' >> /etc/sudoers

mkdir /home/yym          # 创建 yym 用户目录
chown yym:yym -R /home/yym

# 添加 apt-get 国内源
echo '${YELLOW}initializing apt-get...'
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list /etc/apt/sources.list

# 更新 apt-get
echo '${YELLOW}update apt-get...'
apt-get update

# 安装必要软件
echo '${YELLOW}install some software by apt-get...'
apt-get install -y nginx htop git zsh

# 切换到普通用户
echo '${YELLOW}change to user [yym]'
su yym

# git 初始化
echo '${YELLOW}initializing git...'
git config --global user.email 951376975@qq.com
git config --global user.name elliotxx
echo '[core]\n\teditor=vim' >> ~/.gitconfig
ssh-keygen -t rsa -C 951376975@qq.com

echo '${YELLOW}OK'
