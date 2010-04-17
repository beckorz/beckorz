#!/bin/sh
# ANSIカラーチェックスクリプト

# echoコマンドの違いを吸収する関数定義
case "`echo -e`" in
-e)
	ECHO() { echo "$@"; }
	;;
*)
	ECHO() { echo -e "$@"; }
	;;
esac

# 属性名称
get_attr_name() {
	case "$1" in
	0) ECHO "標準\c";;
	1) ECHO "強調\c";;
	2) ECHO "垂線\c";;
	4) ECHO "下線\c";;
	5) ECHO "点滅\c";;
	7) ECHO "反転\c";;
	8) ECHO "非表示\c";;
	esac
}

# 一般的なカラーインデックス名称
get_color_name() {
	case "$1" in
	0) ECHO "Black   \c";;
	1) ECHO "Red     \c";;
	2) ECHO "Green   \c";;
	3) ECHO "Yellow  \c";;
	4) ECHO "Blue    \c";;
	5) ECHO "Magenta \c";;
	6) ECHO "Cyan    \c";;
	7) ECHO "White   \c";;
	esac
}

# 行セパレータ出力
print_separator() {
	for LOOP in `seq 0 8`; do
		ECHO "+--------\c"
	done
	ECHO
}

for ATTR in 0 1 4 5; do
	# ヘッダ出力
	ECHO `get_attr_name $ATTR`
	for FGCOL in `seq 0 7`; do
		ECHO "|\c"
		get_color_name ${FGCOL}
	done
	ECHO "|fg/bg"
	print_separator

	# 表生成
	for BGCOL in `seq 0 7`; do
		for FGCOL in `seq 0 7`; do
			ECHO "|\033[4${BGCOL}m\033[${ATTR};3${FGCOL}m Sample \033[m\c"
		done
		ECHO "|"`get_color_name $BGCOL`
		print_separator
	done
done
