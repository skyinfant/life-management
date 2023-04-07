#!/bin/bash

cd $(dirname $0)
source ./funcs.sh

start1=`tstamp_s`

hour=`date "+%H"`
minute=`date "+%M"`
if [ $hour -eq 23 ] && [ $minute -eq 50 ];
then

	#如果今天未统计能量，证明未手动统计睡眠情况，则直接记为低能量和睡眠质量差
	if [ $high_energy_days_count_flag -eq 1 ];
	then
		addOrSub +1 mon_low_energy_days year_low_energy_days total_low_energy_days
		changeParams 2 high_energy_days_count_flag

		addOrSub +1 mon_no_good_sleep_days year_no_good_sleep_days total_no_good_sleep_days
		changeParams 2 sleep_record_flag
	fi


	#统计收益8000以上天数 因为有可能扣分的，所以要晚上统计
	if [ $high_income_days_count_flag -eq 1 ] && [ $today_income -ge 8000 ];
	then
    	addOrSub +1 mon_high_income_days year_high_income_days total_high_income_days

    	changeParams 2 high_income_days_count_flag
		#奖励	
		compute_income +500 high_income_days

	fi
	
	
	#统计百分比和平均值
	init_rate_ave 1	


    #生成报表
    sh ./generateMonStatement.sh
    sh ./generateYearStatement.sh

    now=`now`
    changeParams "'$now'" last_compute_cron_time

    #结束计时
    end1=`tstamp_s`
    let time=end1-start1

    msg="执行成功     耗时：$time秒"
    [ $? -ne 0 ] && msg="执行失败     耗时：$time秒"
    changeParams "'$msg'" compute_execute_result

fi


#保存数据，加载页面
sh ./saveDataAndLoadPage.sh 1


