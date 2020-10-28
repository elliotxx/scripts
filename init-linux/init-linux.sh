#!/bin/sh
# 初始化账号
sudo passwd root        # 设置用户 root 的密码
sudo useradd yym        # 创建用户 yym
sudo passwd yym         # 设置用户 yym 的密码

# 添加用户 yym 使用 sudo 的权限
echo 'yym     ALL=(ALL:ALL) ALL' >> /etc/sudoers

sudo mkdir /home/yym          # 创建 yym 用户目录
sudo chown yym:yym -R /home/yym

# 添加 apt-get 国内源
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list /etc/apt/sources.list

# 切换到普通用户
su yym
