export LANG=ja_JP.eucJP

service="serivicename"
domain="domain"
user_id="id"
user_pass="pass"
event="centos"

#wget���ǿ��ǤǤʤ��ȥ��󥹥ȡ���Ǥ��ʤ�����ǽ��������Τ�
yum install -y wget

wget http://www.hi-ho.ne.jp/cgi-bin/user/yoshihiro_e/download.cgi?p=diced019


#�ʤ���download.cgi?p=diced019�ä�̾������¸�����

tar zxvf download.cgi?p=diced019

rm -f download.cgi?p=diced019

mv DiCE /usr/local

cd /usr/local/DiCE/

#�����Ǽ��Ԥ����硢CPU��32bit�β�ǽ��������
#32bit�Ѥ�yum install ld-linux.so.2�ǥ��󥹥ȡ��뤷�Ƥ���

yum install -y expect
yum install -y ld-linux.so.2

expect -c "
  set timeout 1
  spawn setarch `uname -m` /usr/local/DiCE/diced
  expect \"Copyright(c) 2001 sarad\"
  send -- \"setup\n\"
  expect \"(P)���\"
  send -- \"n\n\"
  expect \"(P)���\"
  send -- \"n\n\"
  expect \"(P)���\"
  send -- \"y\n\"
  expect \"(P)���\"
  send -- \"n\n\" 
  expect \"(P)���\"
  send -- \"n\n\"
  expect \"(P)���\"
  send -- \"30\n\"
  expect \"(P)���\"
  send -- \"y\n\"
  expect \"=================\"
  send -- \"add\n\"
  expect \"(P)���\"
  send -- \"${service}\n\"
  expect \"(P)���\"
  send -- \"${domain}\n\"
  expect \"(P)���\"
  send -- \"$\n\"
  expect \"(P)���\"
  send -- \"${user_id}\n\"
  expect \"(P)���\"
  send -- \"${user_pass}\n\"
  expect \"(P)���\"
  send -- \"$\n\"
  expect \"(P)���\"
  send -- \"${event}\n\"
  expect \"(P)���\"
  send -- \"5\n\"
  expect \"(P)���\"
  send -- \"0\n\"
  expect \"���٥�Ȥ�ͭ��\"
  send -- \"y\n\"
  expect \"���٥�Ȥ���¸���ޤ���? (Y/N)\"
  send -- \"y\n\"
  send -- \"exit\n\"
"

setarch `uname -m` /usr/local/DiCE/diced -d -l
echo "setarch `uname -m` /usr/local/DiCE/diced -d -l" >> /etc/rc.local

export LANG=ja_JP.UTF-8