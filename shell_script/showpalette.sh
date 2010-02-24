#!/bin/sh
# ANSIカラーチェックスクリプト

# 属性名称
get_attr_name() {
	case "$1" in
	0) echo -n "標準";;
	1) echo -n "強調";;
	2) echo -n "垂線";;
	4) echo -n "下線";;
	5) echo -n "点滅";;
	7) echo -n "反転";;
	8) echo -n "非表示";;
	esac
}

# 一般的なカラーインデックス名称
get_color_name() {
	case "$1" in
	0) echo -n "Black   ";;
	1) echo -n "Red     ";;
	2) echo -n "Green   ";;
	3) echo -n "Yellow  ";;
	4) echo -n "Blue    ";;
	5) echo -n "Magenta ";;
	6) echo -n "Cyan    ";;
	7) echo -n "White   ";;
	esac
}

# 行セパレータ出力
print_separator() {
	for LOOP in `seq 0 8`; do
		echo -n "+--------"
	done
	echo
}

for ATTR in 0 1 4 5; do
	# ヘッダ出力
	echo `get_attr_name $ATTR`
	for FGCOL in `seq 0 7`; do
		echo -n "|"
		get_color_name ${FGCOL}
	done
	echo "|fg/bg"
	print_separator

	# 表生成
	for BGCOL in `seq 0 7`; do
		for FGCOL in `seq 0 7`; do
			echo -en "|\033[4${BGCOL}m\033[${ATTR};3${FGCOL}m Sample \033[m"
		done
		echo "|"`get_color_name $BGCOL`
		print_separator
	done
done
