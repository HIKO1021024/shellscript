##ファイル名を定義 ファイル名で日付がわかるようにしておきます
mydate=`date +%y%m%d%H%M%S`
#echo $mydate

redminepath="/var/lib/redmine-3.4.2/"

#バックアップフォルダおよびファイル名指定

#ここで指定したパスに保存する
bkuppath="/home/backup/redmine/"

#echo $bkuppath

bkupname="files_${mydate}"

#echo $bkupname

#できたログを元ファイルを残して圧縮
tar  -zcvf $bkuppath$bkupname.tar.gz $redminepath

# パーミッション変更
#chmod 700 "${bkuppath}${bkupname}.tar.gz"

period="+7"

# 古いバックアップファイルを削除
find ${bkuppath}*.tar.gz -type f -daystart -mtime $period  -exec rm {} \;