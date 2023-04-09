#!/bin/bash
#完成总任务数中的一个

cd `dirname $0`

source ./funcs.sh


#今天还没更新过睡眠质量的话不能操作
exit_script2 sleep_record_flag 1
#如果任务状态不是进行中则退出脚本
[ $task_state_A1 -ne 2 ] && showConsole && exit 1


#计算收益
compute_income +100 today_task_num_A1

#各项完成任务数+1
addOrSub +1 today_task_num_A1 completed_task_num_A1 mon_task_completed_num year_task_completed_num total_task_completed_num

#剩余任务数-1
addOrSub -1 remaining_task_num_A1

#如果剩余任务为0，则把任务状态改为已完成   并且奖励5000金币
[ $remaining_task_num_A1 -eq 0 ] && changeParams 3 task_state_A1 && compute_income +5000 completed_all_tasks


#更新A1的速度
[ $task_days_A1 -eq 0 ] && task_days_A1=1
ave 0 completed_task_num_A1 task_days_A1 ave_task_A1

#统计其他各种速度
ave_all 0 ave_mon_day_task_completed_num


#更新A1任务完成率
rate 2 completed_task_num_A1 total_task_num_A1 rate_task_completed_A1

#统计完成任务量8以上的天数
if [ $high_task_days_count_flag -eq 1 ] && [ $today_task_num_A1 -ge 8 ];
then

	addOrSub +1 year_high_task_days mon_high_task_days total_high_task_days
	rate_all 2 rate_mon_high_task_days
	changeParams 2 high_task_days_count_flag
	#奖励
	compute_income +500 high_task_days

fi



#修改最新的完成任务时间
#task_finish_time2=$(date "+%H:%M:%S")
#changeParams $task_finish_time2 task_finish_time

#当前时间戳   秒
#now=`tstamp_s`

#本次任务耗时   分
#let seconds=now-last_task_finish_timestamp
#task_time_taken2=`divide $seconds 60 0`

#更新上次完成任务的时间戳
#changeParams $now last_task_finish_timestamp
#更新任务耗时
#changeParams $task_time_taken2 task_time_taken



showConsole

