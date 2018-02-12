export LANG=ja_JP.eucJP

service="serivicename"
domain="domain"
user_id="id"
user_pass="pass"
event="centos"

#wgetが最新版でないとインストールできない？可能性があるので
yum install -y wget

wget http://www.hi-ho.ne.jp/cgi-bin/user/yoshihiro_e/download.cgi?p=diced019


#なぜかdownload.cgi?p=diced019って名前で保存される

tar zxvf download.cgi?p=diced019

rm -f download.cgi?p=diced019

mv DiCE /usr/local

cd /usr/local/DiCE/

#ここで失敗する場合、CPUが32bitの可能性がある
#32bit用のyum install ld-linux.so.2でインストールしておく

yum install -y expect
yum install -y ld-linux.so.2

expect -c "
  set timeout 1
  spawn setarch `uname -m` /usr/local/DiCE/diced
  expect \"Copyright(c) 2001 sarad\"
  send -- \"setup\n\"
  expect \"(P)戻る\"
  send -- \"n\n\"
  expect \"(P)戻る\"
  send -- \"n\n\"
  expect \"(P)戻る\"
  send -- \"y\n\"
  expect \"(P)戻る\"
  send -- \"n\n\" 
  expect \"(P)戻る\"
  send -- \"n\n\"
  expect \"(P)戻る\"
  send -- \"30\n\"
  expect \"(P)戻る\"
  send -- \"y\n\"
  expect \"=================\"
  send -- \"add\n\"
  expect \"(P)戻る\"
  send -- \"${service}\n\"
  expect \"(P)戻る\"
  send -- \"${domain}\n\"
  expect \"(P)戻る\"
  send -- \"$\n\"
  expect \"(P)戻る\"
  send -- \"${user_id}\n\"
  expect \"(P)戻る\"
  send -- \"${user_pass}\n\"
  expect \"(P)戻る\"
  send -- \"$\n\"
  expect \"(P)戻る\"
  send -- \"${event}\n\"
  expect \"(P)戻る\"
  send -- \"5\n\"
  expect \"(P)戻る\"
  send -- \"0\n\"
  expect \"イベントの有効\"
  send -- \"y\n\"
  expect \"イベントを保存しますか? (Y/N)\"
  send -- \"y\n\"
  send -- \"exit\n\"
"

setarch `uname -m` /usr/local/DiCE/diced -d -l
echo "setarch `uname -m` /usr/local/DiCE/diced -d -l" >> /etc/rc.local

export LANG=ja_JP.UTF-8