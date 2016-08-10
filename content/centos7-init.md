centos7 服务器初始化脚本：
```shell
# time
timedatectl set-timezone Asia/Shanghai
# yum cache
yum makecache
# git install
yum install git wget vim-enhanced -y
# vim
echo 'alias vi=vim' > /etc/profile.d/vi-vim.sh
source /etc/profile
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc
# python env
wget https://bootstrap.pypa.io/get-pip.py -O - | python
pip install virtualenv
# node env
```