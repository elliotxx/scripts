#!/bin/bash
# 如果任何语句的执行结果不是 true 则应该退出，防止问题扩大
# set -e

created_user=yym
user_home_folder=/home/$created_user
script_folder=$(pwd)

setup_color() {
	# Only use colors if connected to a terminal
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
}

# 初始化颜色
setup_color

# 添加 apt-get 国内源
# echo "${YELLOW}initializing apt-get...${RESET}"
# mv /etc/apt/sources.list /etc/apt/sources.list.bak
# cp ./sources.list /etc/apt/sources.list

# 更新 apt-get
echo "${YELLOW}update apt-get...${RESET}"
apt-get update

# 安装必要软件
echo "${YELLOW}install some software by apt-get...${RESET}"
apt-get install -y nginx htop git zsh

# 初始化账号
echo "initializing user..."
create_user() {
  id $created_user > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "${YELLOW}creating user [$created_user]...${RESET}"
    useradd -s /bin/bash $created_user	# 创建用户
    passwd $created_user			# 设置用户的密码
  fi
}
create_user

# 添加用户 使用 sudo 的权限
echo "$created_user     ALL=(ALL:ALL) ALL" >> /etc/sudoers
if [ ! -d $user_home_folder ]; then
  mkdir $user_home_folder	# 创建 用户目录
  chown $created_user:$created_user -R $user_home_folder
fi

# 切换到普通用户
# echo "${YELLOW}change to user [$created_user]${RESET}"
# su - $created_user -s /bin/bash $script_folder/user-init-linux.sh
# su yym
# zsh

echo "${YELLOW}OK${RESET}"
