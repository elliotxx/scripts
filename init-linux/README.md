## init-linux
> VPS 初始化脚本，自动创建普通用户、安装必要软件和配置 etc
> 适用于 Ubuntu 16.04 LTS

## Usage
install git by root
```
apt-get update
apt-get install -y git
```
run init-linux.sh by root
```
git clone https://github.com/elliotxx/scripts.git
cd scripts/init-linux
sh init-linux.sh
```
run user-init-linux.sh by user
```
su yym
cd ~
git clone https://github.com/elliotxx/scripts.git
cd scripts/init-linux
sh user-init-linux.sh
```