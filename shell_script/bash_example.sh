#!/bin/bash
#	bashサンプル集

# 変数が未定義のとき、デフォルト値を返す
echo "\${V01-default}=${V01-default}"
V02=
echo "\${V02-default}=${V02-default}"
# ${V01-default}=default
# ${V02-default}=

# 変数が未定義か空文字列のとき、デフォルト値を返す
echo "\${V03:-default}=${V03:-default}"
V04=
echo "\${V04:-default}=${V04:-default}"
# ${V03:-default}=default
# ${V04:-default}=default

# 変数が未定義のとき、デフォルト値をセットして返す
echo "\${V05=default}=${V05=default}"
V06=
echo "\${V06=default}=${V06=default}"
echo "\$V05=${V05}"
echo "\$V06=${V06}"
# ${V05=default}=default
# ${V06=default}=
# $V05=default
# $V06=

# 変数が未定義か空文字列のとき、デフォルト値をセットして返す
echo "\${V07:=default}=${V07:=default}"
V08=
echo "\${V08:=default}=${V08:=default}"
echo "\$V07=${V07}"
echo "\$V08=${V08}"
# ${V07:=default}=default
# ${V08:=default}=default
# $V07=default
# $V08=default

# 変数に何らかの値(空文字列含む)が設定されているとき、指定値を返す
echo "\${V09+value}=${V09+value}"
V10=
echo "\${V10+value}=${V10+value}"
V11=sample
echo "\${V11+value}=${V11+value}"
# ${V09+value}=
# ${V10+value}=value
# ${V11+value}=value

# 変数に何らかの値(空文字列含まない)が設定されているとき、指定値を返す
echo "\${V12:+value}=${V12:+value}"
V13=
echo "\${V13:+value}=${V13:+value}"
V14=sample
echo "\${V14:+value}=${V14:+value}"
# ${V12:+value}=
# ${V13:+value}=
# ${V14:+value}=value

# 変数にセットされている文字数を返す
V15=123456789
echo "\$V15=$V15"
echo "\${#V15}=${#V15}"
# ${#V15}=9

# 部分文字列抽出
echo "\${V15:0:2}, \${V15:4}=${V15:0:2}, ${V15:4}"
# ${V15:0:2}, ${V15:4}=12, 56789

# パターンに一致する文字列を置換(最短一致)して返す
V16='a:b:c'
V17='/var/log/messages'
echo "\$V16=$V16"
echo "\$V17=$V17"
echo "\${V16/:/#}=${V16/:/#}"
echo "\${V17/\//\\}=${V17/\//\\}"
# ${V16/:/#}=a#b:c
# ${V17/\//\}=\var/log/messages

# パターンに一致する文字列を置換(最長一致)して返す
echo "\${V16//:/#}=${V16//:/#}"
echo "\${V17//\//\\}=${V17//\//\\}"
# ${V16//:/#}=a#b#c
# ${V17//\//\\}=\var\log\messages

# 先頭からパターンに最短一致した部分までを取り除いて返す
echo "\${V17#*/}=${V17#*/}"
# ${V17#*/}=var/log/messages

# 先頭からパターンに最長一致した部分までを取り除いて返す(ファイル名抽出)
echo "\${V17##*/}=${V17##*/}"
# ${V17##*/}=messages

# 末尾からパターンに最短一致した部分までを取り除いて返す(ディレクトリ名抽出)
echo "\${V17%/*}=${V17%/*}"
# ${V17%/*}=/var/log

# 末尾からパターンに最長一致した部分までを取り除いて返す
echo "\${V17%%/*}=${V17%%/*}"
# ${V17%%/*}=

# LINENOは予約変数なので注意
echo "\$LINENO=$LINENO"

# ブレース展開
echo /var/log/messages{,.1,.2}
# /var/log/messages /var/log/messages.1 /var/log/messages.2

# 配列展開
V18=(A B 'C D' E)

# 配列の特定要素を取得
echo "\${V18[2]}=${V18[2]}"
# ${V18[2]}=C D

# 配列の要素数を返す
echo "\${#V18[@]}=${#V18[@]}"
# ${#V18[@]}=4

# CSVを簡易配列展開(フィールドセパレータを変更)
V19='a,b,c,d,e'
_IFS="$IFS"
IFS=,
CSV=($V19)
IFS="$_IFS"
echo "\${CSV[2]}=${CSV[2]}"
echo "\${#CSV[*]}=${#CSV[*]}"
# ${CSV[2]}=c
# ${#CSV[*]}=5

# ヒアドキュメント
cat <<__EOD__
----1
$V15
`date +%Y%m%d`
__EOD__

# ヒアドキュメント(変数展開なし)
cat <<'__EOD__'
----2
$V15
`date +%Y%m%d`
__EOD__

# ヒアドキュメント(先頭タブ無視)
cat <<-__EOD__
	----3
	$V15
	`date +%Y%m%d%H%M%S`
	  indent
__EOD__

# 行頭の#でブロックコメントの切替(ヒアドキュメントの応用)
#: <<'#__COMMENT__'
V20=bar
#__COMMENT__
echo "\$V20=$V20"

# クォート効果の違い(複数行記述)
V21='Hello, 
world!'
echo $V21
echo "$V21"
V22="Hello, \
world!"
echo $V22
echo "$V22"
# Hello, world!
# Hello,
# world!
# Hello, world!
# Hello, world!

# 位置パラメータの展開
set -- sample1 'sample 2' sample3
for V23 in "$*"; do
	echo $V23
done
# sample1 sample 2 sample 3
for V23 in "$@"; do
	echo $V23
done
# sample1
# sample 2
# sample3

# 受け取った引数をそのまま別プログラムや関数に渡す場合、 ${@+"$@"}を使うことで
# 引数が指定されないのと空文字列が指定されたのを区別できる
set --
set -- ${@+"$@"}
echo "\$#=$#"
# $#=0
set -- ""
set -- ${@+"$@"}
echo "\$#=$#"
# $#=1

# 標準出力をファイルに出力しつつ、標準エラー出力を変数に取得する
TEMP=`mktemp -t ${0##*/}.XXXXXXXXXX`
trap 'rm -f $TEMP' 0 1 2 3 15
V24=`expr 1 / 0 3>&1 >$TEMP 2>&3`
echo "Error: $V24"
