#!/bin/bash
#生成月度报表

source ./funcs.sh
db_file=$monsData

generateStatement()
{

#报表目录
baseDir="./data/statement/mons/$year"
#报表文件
file="$baseDir/$year年$mon_of_year月.txt"

[ ! -d $baseDir ] && mkdir -p $baseDir

cat > $file <<EOF


睡眠质量好的天数：$mon_good_sleep_days
睡眠质量好的比例：$rate_mon_good_sleep_days
睡眠质量差的天数：$mon_bad_sleep_days


能量值：$mon_energy
能量值达到8以上天数：$mon_high_energy_days
能量值达到8以上比例：$rate_mon_high_energy_days
能量值小于8的天数：$mon_low_energy_days
每日平均能量值：$ave_mon_day_energy


入账额：$mon_income
收益达到8000以上天数：$mon_high_income_days
收益达到8000以上比例：$rate_mon_high_income_days
平均每日入账额：$ave_mon_day_income


focus时间(小时)：$mon_focus_time
focus达到10h以上天数：$mon_high_focus_days
focus达到10h以上比例：$rate_mon_high_focus_days
平均每日focus时间：$ave_mon_day_focus_time


完成任务数：$mon_task_completed_num
完成任务日速度：$ave_mon_day_task_completed_num
完成任务8个以上天数：$mon_high_task_days
完成任务8个以上比例：$rate_mon_high_task_days


运动天数：$mon_sport_days
运动比例：$rate_mon_sport_days


读书天数：$mon_reading_days
读书比例：$rate_mon_reading_days


学英语天数：$mon_english_days
学英语比例：$rate_mon_english_days


学习次数：$mon_study_times


玩游戏次数：$mon_play_game_times


EOF

}


#有传参数则批量生成
if [ "$1" ];then

	params=$(sed -n "2p" $db_file)
	param_arr=(${params//,/ })
	len=${#param_arr[*]i}

	row_count=$(wc -l <$db_file)
	for row in $(seq 3 $row_count); do
		values=$(sed -n "${row}p" $db_file)
		value_arr=(${values//,/ })
		
		for ((i = 0; i < $len; i++)); do
			param=${param_arr[$i]}
			value=${value_arr[$i]}
			
			if [ $i -eq 0 ];then
				year=`echo $value | cut -d '.' -f 1`
				mon_of_year=`echo $value | cut -d '.' -f 2`
				
			else
			
				eval $param=$value
			
			fi
			
		done
		
		generateStatement

	done
	
else

	generateStatement

fi

