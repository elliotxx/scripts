#!/bin/sh
# 如果任何语句的执行结果不是 true 则应该退出，防止问题扩大
set -e
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
echo "${YELLOW}creating user [yym]...${RESET}"
useradd -s /bin/bash yym            # 创建用户 yym
passwd yym                          # 设置用户 yym 的密码

# 添加用户 yym 使用 sudo 的权限
echo 'yym     ALL=(ALL:ALL) ALL' >> /etc/sudoers
mkdir /home/yym          # 创建 yym 用户目录
chown yym:yym -R /home/yym

# 切换到普通用户
echo "${YELLOW}change to user [yym]${RESET}"
su - yym <<EOF
cd ~

# git 初始化
echo "${YELLOW}initializing git...${RESET}"
git config --global user.email 951376975@qq.com
git config --global user.name elliotxx
echo '[core]\n\teditor=vim' >> ~/.gitconfig
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa -C 951376975@qq.com

# 安装 ohmyzsh
echo "${YELLOW}install ohmyzsh...${RESET}"
echo y | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
usermod -s /usr/bin/zsh yym         # 更改用户 yym 的终端为 zsh

# 安装 Golang
echo "${YELLOW}install golang...${RESET}"
wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
tar zxvf go1.13.4.linux-amd64.tar.gz
sudo mv go /usr/local
echo '# golang env
export GOPATH=~/go
export GOROOT=/usr/local/go
export GOARCH=amd64
export GOOS=linux
export GOBIN=$GOROOT/bin/
export GOTOOLS=$GOROOT/pkg/tool/
export PATH=$PATH:$GOBIN:$GOTOOLS' >> ~/.zshrc
source ~/.zshrc
go version

# 安装 Docker
echo "${YELLOW}install docker...${RESET}"
# 1. 卸载旧版本
sudo apt-get remove docker docker-engine docker.io
# 2. 安装最新版本的 Docker
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# 3. 设置apt仓库地址
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
     "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
# 4. 安装最新版的 Docker 软件
sudo apt-get update
sudo apt-get install -y docker-ce

echo "${YELLOW}OK${RESET}"
EOF
zsh
