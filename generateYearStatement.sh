#!/bin/bash
#生成年度报表

source ./funcs.sh
db_file=$yearsData


generateStatement()
{

#报表目录
baseDir="./data/statement/years"
#报表文件
file="$baseDir/$year年.txt"

[ ! -d $baseDir ] && mkdir -p $baseDir

cat > $file <<EOF


睡眠质量好的天数：$year_good_sleep_days
睡眠质量好的比例：$rate_year_good_sleep_days
平均每月睡眠质量好的天数：$ave_year_mon_good_sleep_days
睡眠质量差的天数：$year_bad_sleep_days


能量值：$year_energy
能量值达到8以上天数：$year_high_energy_days
能量值达到8以上比例：$rate_year_high_energy_days
能量值小于8的天数：$year_low_energy_days
每日平均能量值：$ave_year_day_energy
每月平均能量值：$ave_year_mon_energy


入账额：$year_income
收益达到8000以上天数：$year_high_income_days
收益达到8000以上比例：$rate_year_high_income_days
平均每日入账额：$ave_year_day_income
平均每月入账额：$ave_year_mon_income


focus时间(小时)：$year_focus_time
focus达到10h以上天数：$year_high_focus_days
focus达到10h以上比例：$rate_year_high_focus_days
平均每日focus时间：$ave_year_day_focus_time
平均每月focus时间：$ave_year_mon_focus_time


完成任务数：$year_task_completed_num
完成任务日速度：$ave_year_day_task_completed_num
完成任务月速度：$ave_year_mon_task_completed_num
完成任务8个以上天数：$year_high_task_days
完成任务8个以上比例：$rate_year_high_task_days


运动天数：$year_sport_days
运动比例：$rate_year_sport_days


读书天数：$year_reading_days
读书比例：$rate_year_reading_days


学英语天数：$year_english_days
学英语比例：$rate_year_english_days


学习次数：$year_study_times


玩游戏次数：$year_play_game_times


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
			
			eval $param=$value

		done
		
		generateStatement

	done
	
else

	generateStatement

fi


