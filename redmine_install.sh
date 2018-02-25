#!/bin/sh -x

#rootのパスワードにするやつ
pw=adminpass
dbpass=DB_pass


# アンシブルコマンド実行# リファレンスはこちら（この中に）
# https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest
# サブスクリプションをjsonから取得
username=$(az account list | jq '.[].name')
# ダブルコーテーションで囲まれているので削除
username=${username//\"/}
# サブスクリプション設定
az account set --subscription $username
# リソースグループ作成
az group create -l japaneast -n ansible_test
# NW作成
# なんか自動生成されるからいいや

#hostfile作成
echo "[all]" > hosts
# VM作成

# Ansiblemain作成
test=$(az vm create -n AnsibleMain -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser)
ansiblemain=$(echo $test | jq '.publicIpAddress')
ansiblemain=${ansiblemain//\"/}

az network nsg rule create --name port80_allow --resource-group ansible_test --nsg-name AnsibleMainNSG --priority 100 --destination-port-ranges 80 8080 --access Allow

cat ~/.ssh/id_rsa

ssh -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa

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
pw="adminpass"

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
send -- \"\n\"
"

dd if=/dev/zero of=swapadd bs=1M count=4000
sudo chmod 600 swapadd
sudo mkswap swapadd
sudo swapon swapadd

sudo yum install -y epel-release
sudo yum install -y ansible git
sudo git clone https://github.com/farend/redmine-centos-ansible.git

sed -e 's/Must_be_changed!/'$dbpass'/g' redmine-centos-ansible/group_vars/redmine-servers > redmine-centos-ansible/group_vars/redmine-servers

ansible-playbook -i redmine-centos-ansible/hosts redmine-centos-ansible/site.yml