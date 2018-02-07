#ファイル名を定義(※ファイル名で日付がわかるようにしておきます)
mydate=`date +%y%m%d%H%M%S`
#echo $mydate

#バックアップフォルダおよびファイル名指定

#ここで指定したパスに保存する
bkuppath="/home/backup/redmine/"
dbuser="user_redmine"
dbname="db_redmine"
pass="DBpass"

#echo $bkuppath

bkupname="dump_${mydate}.sql"

#echo $bkupname

#dumpファイル作成

mysqldump --single-transaction -u $dbuser -p$pass $dbname > 
$bkuppath$bkupname
#できたログを元ファイルを残さないで圧縮
tar --remove-files -zcvf $bkuppath$bkupname.tar.gz $bkuppath$bkupname

# パーミッション変更
#chmod 700 "${bkuppath}${bkupname}.tar.gz"

period="+7"

# 古いバックアップファイルを削除
find ${bkuppath}*.tar.gz -type f -daystart -mtime $period  -exec rm {} \;

#ver2