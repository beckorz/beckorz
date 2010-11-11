#!/bin/sh
#	MXレコードチェックスクリプト
#	標準入力からメールアドレス一覧を読み込み、
#	nslookupコマンドで見つからなかったドメインを標準エラー出力に出力します。
#	参考：http://oshiete.goo.ne.jp/qa/1385177.html
trap 'rm -f $TMPFILE' 0 1 2 3 15
TMPFILE=`mktemp`

# メールアドレス一覧からドメイン名部分を抽出
while read; do
	DOMAIN=${REPLY#*@}
	if [ -n "$DOMAIN" ]; then
		echo "$DOMAIN" >> "$TMPFILE"
	fi
done

# nslookupで存在チェック
/bin/sort -u "$TMPFILE" | while read; do
	if nslookup -type=mx $REPLY 2>&1 | grep "server can't find" > /dev/null; then
		echo "Not found: $REPLY" 1>&2
	fi
done
