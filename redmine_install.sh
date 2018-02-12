#root�Υѥ���ɤˤ�����
pw=adminpass

# ���󥷥֥륳�ޥ�ɼ¹�# ��ե���󥹤Ϥ�����ʤ�����ˡ�
# https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest
# ���֥�����ץ�����json�������
username=$(az account list | jq '.[].name')
# ���֥륳���ơ������ǰϤޤ�Ƥ���ΤǺ��
username=${username//\"/}
# ���֥�����ץ��������
az account set --subscription $username
# �꥽�������롼�׺���
az group create -l japaneast -n ansible_test
# NW����
# �ʤ󤫼�ư��������뤫�餤����

#hostfile����
echo "[all]" > hosts
# VM����

# Ansiblemain����
test=$(az vm create -n AnsibleMain -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser)
ansiblemain=$(echo $test | jq '.publicIpAddress')
ansiblemain=${ansiblemain//\"/}

ssh ansibleuser@$ansiblemain -i ~/.ssh/id_rsa

sudo yum install -y expect

expect -c "
  set timeout 5
  spawn sudo passwd
  expect \"New password:\"
  send -- \"${pass}\n\"
  expect \"Retype new password:\"
  send -- \"${pass}\n\"
expect \"passwd: all authentication tokens updated successfully.\"
send -- \"exit\n\"
"


export LANG=C
pw="addminpass"

expect -c "
spawn sudo passwd
expect \"New password:\"
send -- \"${pw}\n\" 
expect \"Retype new password:\"
send -- \"${pw}\n\"
expect \"passwd: all authentication tokens updated successfully.\"
send -- \"exit\n\"
"
expect -c "
spawn su -
expect \"Password:\"
send -- \"${pw}\n\"
expect \"Last login:\"
send -- \"exit\n\"
"

dd if=/dev/zero of=swapadd bs=1M count=4000
sudo chmod 600 swapadd
sudo mkswap swapadd
sudo swapon swapadd

sudo yum install -y epel-release
sudo yum install -y ansible git
sudo git clone https://github.com/farend/redmine-centos-ansible.git

ansible-playbook -i redmine-centos-ansible/hosts redmine-centos-ansible/site.yml