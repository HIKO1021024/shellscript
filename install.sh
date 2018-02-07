#!/bin/bash
#opemstackŠÂ‹«‚ðì‚é

yum -y update
dd if=/dev/zero of=swapadd bs=1M count=10240
chmod 600 swapadd
mkswap swapadd
swapon swapadd
yum -y install ld-linux.so.2
yum -y install wget
yum -y install epel-release
yum -y install git
yum -y install wireless-tools
iwconfig wls34 essid "hiko" key "s:hikohiko"
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl stop firewalld
systemctl disable firewalld
sed -i "s/\(^SELINUX=\).*/\1disabled/" /etc/selinux/config

echo /usr/local/bin/DiCE/diced -d -l >> /etc/rc.d/rc.local
echo swapon swapadd >> /etc/rc.d/rc.local

wget http://www.hi-ho.ne.jp/cgi-bin/user/yoshihiro_e/download.cgi?p=diced019
tar xzvf download.cgi?p=diced019
mv DiCE /usr/local/bin
setarch `uname -m` /usr/local/bin/DiCE/diced
