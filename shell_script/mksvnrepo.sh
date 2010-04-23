#!/bin/sh
# Subversionのリポジトリ初期化を行うシェルスクリプト
set -e

# 使用方法
Usage() {
	CMD=`basename $0`
	cat 1>&2 <<- __USAGE__
		Usage: $CMD [OPTION...] <dir>
		Options:
		  -g gid        グループ権限を付ける際にグループIDを指定します。
		  -m mode       -g オプション使用時に svnadmin create の際のumask値を指定します。デフォルトは0007です。
		  -o options    svnadmin create に付加するオプションを指定します。デフォルトは '--fs-type fsfs' です。
	__USAGE__
}

# 引数解析
UMASK='0007'
OPTS='--fs-type fsfs'
while getopts g:m:o: OPT; do
	case $OPT in
		g)	GID=$OPTARG;;
		m)	UMASK=$OPTARG;;
		o)	OPTS=$OPTARG;;
		\?)	Usage
			exit 1
			;;
	esac
done
shift `expr $OPTIND - 1`
if [ $# -eq 0 ]; then
	Usage
	exit 1
fi
DIR=${@+"$@"}

# リポジトリディレクトリ作成～初期化
if [ -n "$GID" ]; then
	umask $UMASK
	svnadmin create $OPTS "$DIR"
	chgrp -R "$GID" "$DIR"
else
	svnadmin create $OPTS "$DIR"
fi

echo Complete!
exit
