#!/bin/bash
#统计db各个参数值，可传入时间条件
# sh sum.sh 
# sh sum.sh 2023
# sh sum.sh 2023.5
# sh sum.sh 2023.5.2


command_path=$(pwd)
result=$(echo "$command_path" | grep -w tool$)
[ $result ] && cd ..

source ./funcs.sh

#时间条件
condition=$1

#参数序列
paramSeq=$(sed -n "1p" $dailyData)
paramSeq=$(echo $paramSeq | sed 's/)//g' | sed 's/(/-/g')

row_count=$(wc -l <$dailyData)

#参数数组
paramName_arr=(${paramSeq//,/ })
len=${#paramName_arr[*]}
let count=len-1


#初始化指定日统计变量
initDayNum() {
    for n in $(seq 1 $count); do
        eval $(echo Dnum$n=0)
    done
}


#初始化月度统计变量
initMonSum() {
	for n in $(seq 1 $count); do
		eval $(echo Msum$n=0)
	done
}

#初始化年度统计变量
initYearSum() {
	for n in $(seq 1 $count); do
		eval $(echo Ysum$n=0)
	done
}

#初始化总计统计变量
initTotalSum() {
	for n in $(seq 1 $count); do
		eval $(echo Tsum$n=0)
	done
}

offset=3
end=$row_count
if [ "$condition" ]; then
	offset=$(grep -nw "^$condition" $dailyData | head -1 | cut -d ':' -f 1)
	end=$(grep -nw "^$condition" $dailyData | tail -1 | cut -d ':' -f 1)
fi

[ ! $offset ] && echo '没有符合条件的数据！' && exit 1

sum() {

	#要统计的月份
	year=$1
	mon=$2
	year_mon="$year.$mon"
	
	initDayNum
	initMonSum

	[ $mon -eq 1 ] && initYearSum

	index=$offset
	#遍历每一行
	for row in $(seq $index $end); do
		all_params=$(sed -n "${row}p" $dailyData)

		ymd=$(echo $all_params | cut -d ',' -f 1)
		if [[ $ymd != $year_mon* ]]; then
			break
		fi
		#遍历每一列
		for n in $(seq 1 $count); do
			#参数列
			let paramCol=n+1

			value=$(echo $all_params | cut -d ',' -f $paramCol)

			#指定日的数据
			[ $condition ] && [[ $condition = *.*.* ]] && eval $(echo Dnum$n=$value)

			#统计月数据
			if [ ! $condition ] || [[ $condition != *.*.* ]];then
				MomSum=$(eval echo "$"{Msum$n})
				MomSum=$(echo $value | awk -v a=$MomSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g')
				eval $(echo Msum$n=$MomSum)
			fi

			#统计年数据
			if [ ! $condition ] || [[ $condition != *.* ]];then
				YearSum=$(eval echo "$"{Ysum$n})
				YearSum=$(echo $value | awk -v a=$YearSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g')
				eval $(echo Ysum$n=$YearSum)
			fi

			#统计总体数据
			if [ ! $condition ];then
				TotalSum=$(eval echo "$"{Tsum$n})
				TotalSum=$(echo $value | awk -v a=$TotalSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g')
				eval $(echo Tsum$n=$TotalSum)
			fi
		done

		let offset=offset+1

	done

	#输出指定日数据
	if [ $condition ] && [[ $condition = *.*.* ]];then
        for n in $(seq 1 $count); do
            paramName=$(eval echo "$"{paramName$n})
            DayNum=$(eval echo "$"{Dnum$n})

            [ $n -eq 1 ] && echo "----------------------------" && echo -e "$condition\n"
            echo $paramName $DayNum
            [ $n -eq $count ] && echo "----------------------------"
        done
	fi

	#输出月数据
	 if [ ! $condition ] || [[ $condition != *.*.* ]];then
		for n in $(seq 1 $count); do
			paramName=$(eval echo "$"{paramName$n})
			MomSum=$(eval echo "$"{Msum$n})

			[ $n -eq 1 ] && echo "----------------------------" && echo -e "$year.$mon\n"
			echo $paramName $MomSum
			[ $n -eq $count ] && echo "----------------------------"
		done
	fi

	#输出年数据
	if ([ ! $condition ] || [[ $condition != *.* ]]) && ([ $mon -eq 12 ] || [ $offset -gt $end ]); then
		for n in $(seq 1 $count); do
			[ $n -eq 1 ] && echo "==================================" && echo -e "$year\n"
			paramName=$(eval echo "$"{paramName$n})
			YearSum=$(eval echo "$"{Ysum$n})
			echo $paramName $YearSum
			[ $n -eq $count ] && echo "=================================="
		done
	fi

	#输出总计数据
	if [ ! $condition ] && [ $offset -gt $end ]; then
		for n in $(seq 1 $count); do
			[ $n -eq 1 ] && echo "##################################" && echo -e "总计：\n"
			paramName=$(eval echo "$"{paramName$n})
			TotalSum=$(eval echo "$"{Tsum$n})
			echo $paramName $TotalSum
			[ $n -eq $count ] && echo "##################################"
		done
	fi

}

#初始化总计统计变量
initTotalSum

year_arr=(2023 2024 2025 2026 2027 2028 2029 2030)
mon_arr=(1 2 3 4 5 6 7 8 9 10 11 12)

len1=${#year_arr[*]}
len2=${#mon_arr[*]}

for n in $(seq 1 $count); do
	let n2=n+1
	paramName=$(echo $paramSeq | cut -d ',' -f $n2)
	eval $(echo paramName$n="$paramName")
done

begin=$(date '+%s')

flag=1
first_row_time=$(getRow $dailyData 3 | cut -d ',' -f 1)
for ((i = 0; i < $len1; i++)); do

	y="${year_arr[$i]}"
	[ $flag -eq 1 ] && [ ! $condition ] && [[ "$first_row_time" != $y* ]] && continue
	[ $flag -eq 1 ] && [ $condition ] && [[ $condition != $y* ]] && continue

	for ((j = 0; j < $len2; j++)); do

		[ $offset -gt $end ] && break

		m="${mon_arr[$j]}"

		if [ $flag -eq 1 ] && [ ! $condition ];then
 			[[ "$first_row_time" != $y.$m* ]] && continue
 			[[ "$first_row_time" = $y.$m* ]] && flag=2
		fi

        if [ $flag -eq 1 ] && [ $condition ];then
			[[ $condition = *.* ]] && [[ "$condition" != $y.$m* ]] && continue
			[[ "$condition" == $y.$m* ]] || [ "$condition" == $y ] && flag=2

		fi

		sum $y $m
	done

done

finish=$(date '+%s')

let time=finish-begin

time=$(echo $time | awk '{printf "%.1f", $0 / 60}')

echo 耗时：$time分钟

