#!/bin/bash
#management系统每日初始化

cd $(dirname $0)
source ./funcs.sh


#防止误操作
hour=`date "+%H"`
[ $hour -ne 0 ] && exit_script3

#开始计时
start=`tstamp_s`

#今天日期  2023.1.1
today11=$(echo `date +%Y.%m.%d` | awk -F"." '{printf("%d.%d.%d\n",$1,$2,$3)}')
today22=`date "+%Y-%m-%d"`
#年 2023
year11=$(date "+%Y")
#月份  1
mon=`echo $today11 | cut -d '.' -f 2`
#几号  1
day=`echo $today11 | cut -d '.' -f 3`
# 1.1
mon_day=$mon.$day

#=========================================================================== management系统参数
changeParams "$today11" today
changeParams "$today22" today2

addOrSub +1 management_days day_of_year

changeParams $day day_of_mon

changeParams 1 write_params_to_daily_file_flag

changeParams "''" today_goal
#=========================================================================== management系统参数


#=========================================================================== 批量操作
#每月1号
if [ $day -eq 1 ]; then

	#management系统参数
	addOrSub +1 management_mons
	changeParams $mon mon_of_year

	changeParams 1 write_params_to_mon_file_flag	

fi


#每年1月1号
if [ "$mon_day" = "1.1" ]; then

	#management系统参数
	changeParams $year11 year
	addOrSub +1 management_years
	changeParams 1 day_of_year

	changeParams 1 write_params_to_year_file_flag

fi


#批量初始化参数
init_rate_ave 14369721 $day $mon_day

#=========================================================================== 批量操作


#=========================================================================== 任务管理
#通过任务状态标志控制是否继续统计
if [ $task_state_A1 -eq 2 ]; then

	#任务已进行天数+1
	addOrSub +1 task_days_A1

	#任务速度(A1)   已完成任务数/已进行的天数
	ave 0 completed_task_num_A1 task_days_A1 ave_task_A1

	#剩余天数-1
	addOrSub -1 remaining_task_days_A1

	#如果剩余天数小于等于0但是剩余任务数大于0，则把任务状态标记为逾期
	if [ $remaining_task_days_A1 -le 0 ] && [ $remaining_task_num_A1 -gt 0 ];then

		changeParams 6 task_state_A1
		printSeparatorByDate 2 data/note/event.txt
		echo -e "`now`     任务【$task_name_A1】已逾期\n\n" >> data/note/event.txt

	fi


fi
#=========================================================================== 任务管理


#=========================================================================== 睡眠质量

#初始化睡眠质量编辑标志为未编辑
changeParams 1 sleep_record_flag

#=========================================================================== 睡眠质量好


#=========================================================================== focus

changeParams OUT focus_on_out

#=========================================================================== focus


#保存数据，加载页面
sh ./saveDataAndLoadPage.sh 1
sh ./saveDataAndLoadPage.sh 2


now=`now`
changeParams "'$now'" last_init_cron_time


#结束计时
end=`tstamp_s`
let time=end-start

msg="初始化成功     耗时：$time秒"
[ $? -ne 0 ] && msg="执行失败     耗时：$time秒"
changeParams "'$msg'" init_execute_result


