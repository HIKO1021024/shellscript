##�t�@�C�������` �t�@�C�����œ��t���킩��悤�ɂ��Ă����܂�
mydate=`date +%y%m%d%H%M%S`
#echo $mydate

redminepath="/var/lib/redmine-3.4.2/"

#�o�b�N�A�b�v�t�H���_����уt�@�C�����w��

#�����Ŏw�肵���p�X�ɕۑ�����
bkuppath="/home/backup/redmine/"

#echo $bkuppath

bkupname="files_${mydate}"

#echo $bkupname

#�ł������O�����t�@�C�����c���Ĉ��k
tar  -zcvf $bkuppath$bkupname.tar.gz $redminepath

# �p�[�~�b�V�����ύX
#chmod 700 "${bkuppath}${bkupname}.tar.gz"

period="+7"

# �Â��o�b�N�A�b�v�t�@�C�����폜
find ${bkuppath}*.tar.gz -type f -daystart -mtime $period  -exec rm {} \;