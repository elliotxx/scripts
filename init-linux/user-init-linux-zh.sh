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

cd ~

# git 初始化
echo "${YELLOW}initializing git...${RESET}"
git config --global user.email 951376975@qq.com
git config --global user.name elliotxx
echo '[core]\n\teditor=vim' >> ~/.gitconfig
if [ ! -d "$user_home_folder/.ssh" ]; then
  ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa -C 951376975@qq.com
fi

# 安装 ohmyzsh
echo "${YELLOW}install ohmyzsh...${RESET}"
sudo cp $script_folder/ohmyzsh-install-zh.sh ./ohmyzsh-install-zh.sh
sudo chown yym:yym ./ohmyzsh-install-zh.sh
sudo chmod +x ./ohmyzsh-install-zh.sh
echo y | sh -c ./ohmyzsh-install-zh.sh
sudo usermod -s /usr/bin/zsh $created_user         # 更改用户 的终端为 zsh

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

# pip 豆瓣加速
echo "${YELLOW}配置 pip 豆瓣加速...${RESET}"
mkdir ~/.pip
touch ~/.pip/pip.conf
echo '[global]
index-url = https://pypi.doubanio.com/simple
trusted-host = pypi.doubanio.com' | sudo tee -a ~/.pip/pip.conf

# 安装 Docker
echo "${YELLOW}install docker...${RESET}"
# 1. 卸载旧版本
sudo apt-get remove docker docker-engine docker.io > /dev/null 2>&1
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
# 5. 将当前用户添加到 docker 用户组，否则没有权限
sudo groupadd docker                    # 添加docker用户组
sudo gpasswd -a $created_user docker    # 将当前用户添加至docker用户组
# 6. docker 镜像加速
echo '{
  "registry-mirrors": ["http://hub-mirror.c.163.com","https://registry.docker-cn.com"]
}' | sudo tee -a /etc/docker/daemon.json

echo "${YELLOW}OK${RESET}"
/usr/bin/zsh
newgrp docker                           # 更新docker用户组
