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
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}

echo $ansiblemain

### target1作成
test=$(az vm create -n target1 -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --nsg AnsibleMainNSG)
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}
echo $test >> hosts

# target2作成
test=$(az vm create -n target2 -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --nsg AnsibleMainNSG)
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}
echo $test >> hosts

# winserver作成s
#test=$(az vm create -n win -g ansible_test --image Win2016Datacenter --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --admin-password pass --nsg AnsibleMainNSG)

# ansibleインストール
ssh -n -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa "sudo yum -y install ansible"

#既存のホストファイルの名前変える
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /etc/ansible/hosts /etc/ansible/hosts.org

# ホストファイルをおくる
scp -i ~/.ssh/id_rsa hosts ansibleuser@$ansiblemain:/home/ansibleuser

# 鍵ををおくる
scp -i ~/.ssh/id_rsa ~/.ssh/id_rsa 
ansibleuser@$ansiblemain:/home/ansibleuser


# ファイル移動させる
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /home/ansibleuser/hosts /etc/ansible

# 鍵を移動させる
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /home/ansibleuser/id_rsa /home/ansibleuser/.ssh

#設定変更
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa 'sudo sed -i -e  '/ssh_connection/a'"ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /etc/ansible/ansible.cfg'

# 設定の意味
# デフォルト設定
# ControlMaster,ControlPersistはデフォルトの設定のままなので割愛。
# StrictHostKeyChecking=no
# 
ホストのデータベースファイル（デフォルトでは~/.ssh/known_hosts）に存在しないときに確認なしに接続する。
# fingerprintは確認なしにホストのデータベースファイルに記録されていく。
#
# UserKnownHostsFile=/dev/null

# ホストのデータベースファイル。（デフォルトでは~/.ssh/known_hosts）
# データベースファイルを常に空(/dev/null)にすることで、Managed 
Nodeのサーバ更改時など、fingerprintが変わった時に、データベースファイルを整合性が取れずエラーとなってしまうのを回避する。

#設定変わったかな？
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa cat /etc/ansible/ansible.cfg

sudo passwd

adminpassword

echo $ansiblemain

#アンシブルコマンド実行
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa ansible all -m ping

#お知らせメッセージ
echo "AnsibleMainのアドレスは"$ansiblemain