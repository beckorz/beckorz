#!/bin/sh
#
# .backupと最新のファイルのコピーと差分をとります。

# 保存ディレクトリを生成
#
SAVEDIR=$HOME/difflist
if [ -d $SAVEDIR ]; then
	echo -n "$SAVEDIR already exists! Remove now? (y/N): "
	read YESNO
	case $YESNO in
		[Yy]|[Yy][Ee][Ss])
			rm -fr $SAVEDIR
			;;
		*)
			exit 1
			;;
	esac
fi
mkdir $SAVEDIR

# .backupファイルを検索してリスト生成
#
TMPFILE=$SAVEDIR/difflist.txt
find / -name "*.backup" -or -name ".*.backup" > $TMPFILE 2>/dev/null

# リストからファイルをコピーして差分出力
#
while read BAKFILE; do
	BAKDIR=`dirname $BAKFILE`
	TMPDIR=$SAVEDIR/$BAKDIR
	BAKFILE=`basename $BAKFILE`
	ORGFILE=`basename $BAKFILE .backup`
	DIFFILE=$ORGFILE.diff
	if [ -f "$BAKDIR/$ORGFILE" ]; then
		# 保存ディレクトリ以下に同じディレクトリ構造を構築
		if [ ! -d "$TMPDIR" ]; then
			mkdir -p "$TMPDIR"
		fi
		# .backupと最新ファイルをコピーして差分出力
		cp -fp $BAKDIR/$BAKFILE $TMPDIR
		cp -fp $BAKDIR/$ORGFILE $TMPDIR
		diff -u $BAKDIR/$BAKFILE $BAKDIR/$ORGFILE > $TMPDIR/$DIFFILE
		# 差分が空なら削除
		if [ ! -s $TMPDIR/$DIFFILE ]; then
			rm -f $TMPDIR/$DIFFILE
			rm -f $TMPDIR/$ORGFILE
			rm -f $TMPDIR/$DIFFILE
		fi
	fi
done < $TMPFILE

exit
