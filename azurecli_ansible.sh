# �A���V�u���R�}���h���s# ���t�@�����X�͂�����i���̒��Ɂj
# https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest
# �T�u�X�N���v�V������json����擾
username=$(az account list | jq '.[].name')
# �_�u���R�[�e�[�V�����ň͂܂�Ă���̂ō폜
username=${username//\"/}
# �T�u�X�N���v�V�����ݒ�
az account set --subscription $username
# ���\�[�X�O���[�v�쐬
az group create -l japaneast -n ansible_test
# NW�쐬
# �Ȃ񂩎�����������邩�炢����

#hostfile�쐬
echo "[all]" > hosts
# VM�쐬

# Ansiblemain�쐬
test=$(az vm create -n AnsibleMain -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser)
ansiblemain=$(echo $test | jq '.publicIpAddress')
ansiblemain=${ansiblemain//\"/}
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}

echo $ansiblemain

### target1�쐬
test=$(az vm create -n target1 -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --nsg AnsibleMainNSG)
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}
echo $test >> hosts

# target2�쐬
test=$(az vm create -n target2 -g ansible_test --image CentOS --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --nsg AnsibleMainNSG)
test=$(echo $test | jq '.privateIpAddress')
test=${test//\"/}
echo $test >> hosts

# winserver�쐬s
#test=$(az vm create -n win -g ansible_test --image Win2016Datacenter --generate-ssh-keys --size Standard_B1s --admin-username ansibleuser --admin-password pass --nsg AnsibleMainNSG)

# ansible�C���X�g�[��
ssh -n -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa "sudo yum -y install ansible"

#�����̃z�X�g�t�@�C���̖��O�ς���
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /etc/ansible/hosts /etc/ansible/hosts.org

# �z�X�g�t�@�C����������
scp -i ~/.ssh/id_rsa hosts ansibleuser@$ansiblemain:/home/ansibleuser

# ������������
scp -i ~/.ssh/id_rsa ~/.ssh/id_rsa 
ansibleuser@$ansiblemain:/home/ansibleuser


# �t�@�C���ړ�������
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /home/ansibleuser/hosts /etc/ansible

# �����ړ�������
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa sudo mv /home/ansibleuser/id_rsa /home/ansibleuser/.ssh

#�ݒ�ύX
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa 'sudo sed -i -e  '/ssh_connection/a'"ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /etc/ansible/ansible.cfg'

# �ݒ�̈Ӗ�
# �f�t�H���g�ݒ�
# ControlMaster,ControlPersist�̓f�t�H���g�̐ݒ�̂܂܂Ȃ̂Ŋ����B
# StrictHostKeyChecking=no
# 
�z�X�g�̃f�[�^�x�[�X�t�@�C���i�f�t�H���g�ł�~/.ssh/known_hosts�j�ɑ��݂��Ȃ��Ƃ��Ɋm�F�Ȃ��ɐڑ�����B
# fingerprint�͊m�F�Ȃ��Ƀz�X�g�̃f�[�^�x�[�X�t�@�C���ɋL�^����Ă����B
#
# UserKnownHostsFile=/dev/null

# �z�X�g�̃f�[�^�x�[�X�t�@�C���B�i�f�t�H���g�ł�~/.ssh/known_hosts�j
# �f�[�^�x�[�X�t�@�C������ɋ�(/dev/null)�ɂ��邱�ƂŁAManaged 
Node�̃T�[�o�X�����ȂǁAfingerprint���ς�������ɁA�f�[�^�x�[�X�t�@�C���𐮍�������ꂸ�G���[�ƂȂ��Ă��܂��̂��������B

#�ݒ�ς�������ȁH
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa cat /etc/ansible/ansible.cfg

sudo passwd

adminpassword

echo $ansiblemain

#�A���V�u���R�}���h���s
ssh -n  -oStrictHostKeyChecking=no ansibleuser@$ansiblemain -i ~/.ssh/id_rsa ansible all -m ping

#���m�点���b�Z�[�W
echo "AnsibleMain�̃A�h���X��"$ansiblemain