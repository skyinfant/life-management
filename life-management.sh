#!/bin/bash
#从2021年2月12日开始统计 

#隐藏光标
tput civis

cd `dirname $0`
source ./funcs.sh


check_syste_is_init

sleepText="\033[36;1m$mon_good_sleep_days\033[0m"
[ $sleep_record_flag -eq 1 ] && sleepText="\033[46;30m $mon_good_sleep_days \033[0m"


setColor1 33 1m 47 34m today_reading  today_sport  today_guitar today_english


total_focus_time_str="$total_focus_time 小时"
[ `compare $total_focus_time '<' 1` ] && total_focus_time_str="`mul $total_focus_time 60 0` 分钟"


today_focus_time_str="$today_focus_time 小时"
[ `compare $today_focus_time '<' 1` ] && today_focus_time_str="`mul $today_focus_time 60 0` 分钟"


color=39
[ $focus_on_out = OUT ] && color=37

text="All in management, then you'll find your real life."

[ -e ./data/logs/error.log ] && text="有错误！请检查日志文件：./data/logs/error.log"

[ $task_is_stop -eq 1 ] && [ $remaining_task_days -le 0 ] && text="任务 【$task_name_A1】 已到达最后期限！"

[ ! "$task_name_A1" ] && task_name_A1='未设置'

#===================================================================================================
clear
echo -e "\n"

echo -e "\033[1;$color;5m$text \033[0m"

echo -e "\n"

#当前时间
time=$(echo `date +%Y-%m-%d` | awk -F "-" '{printf("%d年%d月%d日\n",$1,$2,$3)}')
echo "              $time                    今日是今年的第 $day_of_year 天                    今日目标：$today_goal"
echo -e "----------------------------------------------------------------------------------------------------------------------------\n"

echo -e "  \033[33;1m今天是否睡得好: \033[0m \033[36;1m$today_good_sleep\033[0m                          \033[33;1m月度睡眠质量: $sleepText                        \033[33;1m年度睡眠质量：\033[0m\033[36;1m$year_good_sleep_days\033[0m\n"

echo -e "----------------------------------------------------------------------------------------------------------------------------\n"

echo -e "  \033[1;33m今日入账：\033[0m\033[36;1m$today_income 元\033[0m               \033[33;1m本月入账：\033[0m\033[36;1m$mon_income 元\033[0m               \033[33;1m今年入账：\033[0m\033[36;1m$year_income 元\033[0m              \033[33;1m完成率：\033[0m\033[36;1m$rate_asset_completed\033[0m\n"

echo -e "----------------------------------------------------------------------------------------------------------------------------\n"

echo -e "  \033[34;1m任务名称：\033[0m\033[32;1m$task_name_A1\033[0m\n"

echo -e "  \033[34;1m任务开始时间：\033[0m\033[32;1m$task_start_day_A1\033[0m                       \033[34;1m任务结束时间：\033[0m\033[32;1m$task_end_day_A1\033[0m                       \033[34;1m剩余时间：\033[0m\033[32;1m$remaining_task_days 天\033[0m\n"

echo -e "  \033[34;1m今日完成数：\033[0m\033[32;1m$today_task_num_A1\033[0m                                  \033[34;1m剩余任务数: \033[0m\033[32;1m$remaining_task_num_A1\033[0m                                  \033[34;1m每日速度: \033[0m\033[32;1m$ave_task_A1\033[0m\n"

echo -e "----------------------------------------------------------------------------------------------------------------------------\n"

echo -e "  \033[32;1m总共focus: \033[0m\033[33;1m$total_focus_time_str\033[0m             \033[32;1m今日focus: \033[0m\033[33;1m$today_focus_time_str\033[0m             \033[32;1mfocus-on/out: \033[0m\033[33;1m$focus_on_out\033[0m             \033[32;1m平均每日focus: \033[0m\033[33;1m$ave_total_day_focus_time 小时\033[0m\n"
echo "----------------------------------------------------------------------------------------------------------------------------"


#echo -e "\n"
#show_finish_task_time="本次完成任务时间：$task_finish_time"
#show_diff_time="耗时：$task_time_taken 分钟"
#[ $task_time_taken -ge 60 ] && int_diff_time=`divide $task_time_taken 60 1` && show_diff_time="耗时：$int_diff_time 小时"

#今日完成任务数大于0次才显示本次完成任务时间
#[ $today_task_num_A1 -eq 0 ] && show_finish_task_time=''
#今日完成任务数大于1次才显示耗时
#[ $today_task_num_A1 -le 1 ] && show_diff_time=''

#echo "$show_finish_task_time               $show_diff_time"

#===================================================================================================



#保存数据，加载页面
sh ./saveDataAndLoadPage.sh 1


