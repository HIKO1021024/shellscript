#�t�@�C�������`(���t�@�C�����œ��t���킩��悤�ɂ��Ă����܂�)
mydate=`date +%y%m%d%H%M%S`
#echo $mydate

#�o�b�N�A�b�v�t�H���_����уt�@�C�����w��

#�����Ŏw�肵���p�X�ɕۑ�����
bkuppath="/home/backup/redmine/"
dbuser="user_redmine"
dbname="db_redmine"
pass="DBpass"

#echo $bkuppath

bkupname="dump_${mydate}.sql"

#echo $bkupname

#dump�t�@�C���쐬

mysqldump --single-transaction -u $dbuser -p$pass $dbname > 
$bkuppath$bkupname
#�ł������O�����t�@�C�����c���Ȃ��ň��k
tar --remove-files -zcvf $bkuppath$bkupname.tar.gz $bkuppath$bkupname

# �p�[�~�b�V�����ύX
#chmod 700 "${bkuppath}${bkupname}.tar.gz"

period="+7"

# �Â��o�b�N�A�b�v�t�@�C�����폜
find ${bkuppath}*.tar.gz -type f -daystart -mtime $period  -exec rm {} \;

#ver2