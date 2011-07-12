#!/bin/bash
#	bashサンプル集

# 変数が未定義のとき、デフォルト値を返す
echo "\$V1=${V1-default}"
V2=
echo "\$V2=${V2-default}"
# $V1=default
# $V2=

# 変数が未定義か空文字列のとき、デフォルト値を返す
echo "\$V3=${V3:-default}"
V4=
echo "\$V4=${V4:-default}"	
# $V3=default
# $V4=default

# 変数が未定義のとき、デフォルト値をセットして返す
echo "\$V5=${V5=default}"	
V6=
echo "\$V6=${V6=default}"	
# $V5=default
# $V6=
echo "\$V5=${V5}" 
echo "\$V6=${V6}" 
# $V5=default
# $V6=

# 変数が未定義か空文字列のとき、デフォルト値をセットして返す
echo "\$V7=${V7:=default}"	
V8=
echo "\$V8=${V8:=default}"	
# $V7=default
# $V8=default
echo "\$V7=${V7}"	
echo "\$V8=${V8}"	
# $V7=default
# $V8=default

# 変数にセットされている文字数を返す
V9=123456789
echo "count=${#V9}"	
# count=9

# 部分文字列抽出
echo "${V9:0:1},${V9:4}"
# 1,56789

# パターンに一致する文字列を置換(最短一致)して返す
V10='a:b:c'
V11='/var/log/messages'
echo "${V10/:/#}"
# a#b:c
echo "${V11/\//\\}"
# \var/log/messages

# パターンに一致する文字列を置換(最長一致)して返す
echo "${V10//:/#}"
# a#b#c
echo "${V11//\//\\}"
# \var\log\messages

# 先頭からパターンに最短一致した部分までを取り除いて返す
echo "${V11#*/}"
# var/log/messages

# 先頭からパターンに最長一致した部分までを取り除いて返す(ファイル名抽出)
echo "${V11##*/}"
# messages

# 末尾からパターンに最短一致した部分までを取り除いて返す(ディレクトリ名抽出)
echo "${V11%/*}"
# /var/log

# 末尾からパターンに最長一致した部分までを取り除いて返す
echo "${V11%%/*}"
# (空)

# LINENOは予約変数なので注意
echo "LineNo=$LINENO"

# ブレース展開
echo /var/log/messages{,.1,.2}
# /var/log/messages /var/log/messages.1 /var/log/messages.2

# 配列展開
V12=(A B 'C D' E)

# 配列の特定要素を取得
echo "${V12[2]}"
# C D

# 配列の要素数を返す
echo "${#V12[@]}"
# 4

# CSVを簡易配列展開(フィールドセパレータを変更)
V13='a,b,c,d,e'
_IFS=$IFS
IFS=,
CSV=($V13)
IFS="$_IFS"
echo "${CSV[2]}"
echo "${#CSV[*]}"
# c
# 5

# ヒアドキュメント
cat <<__EOD__
----1
$V9
`date +%Y%m%d`
__EOD__

# ヒアドキュメント(変数展開なし)
cat <<'__EOD__'
----2
$V9
`date +%Y%m%d`
__EOD__

# ヒアドキュメント(先頭タブ無視)
cat <<-__EOD__
	----3
	$V9
	`date +%Y%m%d`
	  $V10
__EOD__

# 行頭の#でブロックコメントの切替(ヒアドキュメントの応用)
#: <<'#__COMMENT__'
V14=bar
#__COMMENT__
echo "\$V14=${V14-default}"

# クォート効果の違い(複数行記述)
V15='Hello, 
world!'
echo $V15
echo "$V15"
V16="Hello, \
world!"
echo $V16
echo "$V16"
