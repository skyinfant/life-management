#!/bin/bash
#输出db文件的列

#输出daily文件的1、2、3列： sh cut.sh 1 1,2,3
#输出mons文件的1至20列： sh cut.sh 2 1-20

db_file=$1
[ $db_file = 1 ] && db_file=./dailyData.db
[ $db_file = 2 ] && db_file=./monsData.db
[ $db_file = 3 ] && db_file=./yearsData.db

cols=$2


if [[ $cols = *,* ]];then
	arr1=(${cols//,/ })
	start=0
	end=${#arr1[*]i}
	flag=1
else

	start=`echo $cols | cut -d '-' -f 1`
	end=`echo $cols | cut -d '-' -f 2`
	let end=end+1
	flag=2
fi

str1=''
str2=''
for ((j = $start; j < $end; j++)); do

		[ $flag -eq 1 ] && param1=${arr1[$j]}
		[ $flag -eq 2 ] && param1=$j

		[ "$str1" ] && str1="$str1   %s"
		[ ! "$str1" ] && str1="%s"

		[ "$str2" ] && str2="$str2,\$$param1"
		[ ! "$str2" ] && str2="\$$param1"

done




work="awk -F ',' '{printf(\"$str1\\n\",$str2)}' $db_file"


eval "$work"










