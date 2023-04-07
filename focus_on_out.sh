#!/bin/bash

cd `dirname $0`
source ./funcs.sh

#今天还没更新过睡眠质量的话不能操作
exit_script2 sleep_record_flag 1


#当前时间戳   秒
now=`tstamp_s`

if [ $focus_on_out = ON ]
then

    #本次持续时间
	let seconds=now-start_focus_timestamp
	#转为小时
	duration_m=`divide $seconds 60 0`
	duration_h=`divide $duration_m 60 1`
	#累加
	doubleAddOrSub 1 $duration_h add today_focus_time mon_focus_time year_focus_time total_focus_time
		
	if [ $high_focus_days_count_flag -eq 1 ] && [ `compare $today_focus_time '>=' 10` ]
	then
		addOrSub +1 year_high_focus_days mon_high_focus_days total_high_focus_days

		rate_all 2 rate_mon_high_focus_days

		changeParams 2 high_focus_days_count_flag
		#奖励	
		compute_income +500	high_focus_days
	fi


    #focus out
	changeParams OUT focus_on_out

else
    #更新时间戳
    changeParams $now start_focus_timestamp

    #focus on
    changeParams ON focus_on_out
fi

#计算平均值
ave_all 1 ave_mon_day_focus_time


showConsole


