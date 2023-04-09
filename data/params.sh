#!/bin/bash
#参数文件


#system-1============================================== management系统参数
des_today='当前日期'
today=2023.4.7

des_today2='当前日期'
today2=2023-04-07

des_management_start_day='management系统开始运行日期'
management_start_day=2023-04-07

des_management_days='management系统已运行天数'
management_days=1

des_management_mons='management系统已运行月数'
management_mons=1

des_management_years='management系统已运行年数'
management_years=1


des_year='当前年份'
year=2023

des_mon_of_year='当前月份'
mon_of_year=4

des_day_of_mon='今日是几号'
day_of_mon=7

des_day_of_year='今日是今年的第几天'
day_of_year=97


des_write_params_to_daily_file_flag='标记是否第一次将参数写入daily文件 1--是 2--否'
write_params_to_daily_file_flag=2

des_write_params_to_mon_file_flag='标记是否第一次将参数写入mon文件 1--是 2--否'
write_params_to_mon_file_flag=2

des_write_params_to_year_file_flag='标记是否第一次将参数写入year文件 1--是 2--否'
write_params_to_year_file_flag=2


des_last_init_cron_time='最近一次初始化定时任务执行时间'
last_init_cron_time='2023-04-05 00:00:06'

des_init_execute_result='执行结果'
init_execute_result='初始化成功     耗时：5秒'


des_last_compute_cron_time='最近一次计算任务执行时间'
last_compute_cron_time='2023-04-04 23:50:03'

des_compute_execute_result='执行结果'
compute_execute_result='执行成功     耗时：2秒'

des_current_version='当前management版本'
current_version=1.0

des_today_goal='今日目标'
today_goal=''
#system-2============================================== management系统参数


#good_sleep-1============================================== 睡眠质量
des_today_good_sleep='睡眠质量好'
today_good_sleep=NO

des_mon_good_sleep_days='本月睡眠质量好的天数'
mon_good_sleep_days=0

des_year_good_sleep_days='今年睡眠质量好的天数'
year_good_sleep_days=0

des_total_good_sleep_days='总计睡眠质量好的天数'
total_good_sleep_days=0

des_total_good_sleep_days_to_year='总天数折合为年 总睡眠质量好的天数/365'
total_good_sleep_days_to_year=0

des_rate_mon_good_sleep_days='本月睡眠质量好的比例'
rate_mon_good_sleep_days=0

des_rate_year_good_sleep_days='今年睡眠质量好的比例'
rate_year_good_sleep_days=0

des_rate_total_good_sleep_days='总计睡眠质量好的比例'
rate_total_good_sleep_days=0


des_ave_year_mon_good_sleep_days='今年平均每月睡眠质量好的天数'
ave_year_mon_good_sleep_days=0

des_ave_total_mon_good_sleep_days='总计平均每月睡眠质量好的天数'
ave_total_mon_good_sleep_days=0

des_ave_total_year_good_sleep_days='总计平均每年睡眠质量好的天数'
ave_total_year_good_sleep_days=0


des_mon_bad_sleep_days='本月睡眠质量差的天数'
mon_bad_sleep_days=0

des_year_bad_sleep_days='今年睡眠质量差的天数'
year_bad_sleep_days=0

des_total_bad_sleep_days='总计睡眠质量差的天数'
total_bad_sleep_days=0

des_sleep_record_flag='睡眠记录标志（1--未记录，2--已记录 以避免忘记做睡眠记录）'
sleep_record_flag=1
#good_sleep-2============================================== 睡眠质量


#energy-1============================================== energy
des_today_energy='今日能量值'
today_energy=0

des_mon_energy='本月能量值'
mon_energy=0

des_year_energy='今年能量值'
year_energy=0

des_total_energy='总能量值'
total_energy=0


des_mon_high_energy_days='本月能量值达到8以上天数'
mon_high_energy_days=0

des_year_high_energy_days='今年能量值达到8以上天数'
year_high_energy_days=0

des_total_high_energy_days='总计能量值达到8以上天数'
total_high_energy_days=0


des_rate_mon_high_energy_days='本月能量值达到8以上比例'
rate_mon_high_energy_days=0

des_rate_year_high_energy_days='今年能量值达到8以上比例'
rate_year_high_energy_days=0

des_rate_total_high_energy_days='总计能量值达到8以上比例'
rate_total_high_energy_days=0

des_high_energy_days_count_flag='高energy统计标记，1--未统计 2--已统计'
high_energy_days_count_flag=1


des_mon_low_energy_days='本月能量值小于8的天数'
mon_low_energy_days=0

des_year_low_energy_days='今年能量值小于8的天数'
year_low_energy_days=0

des_total_low_energy_days='总计能量值小于8的天数'
total_low_energy_days=0


des_ave_year_day_energy='今年每日平均能量值'
ave_year_day_energy=0

des_ave_mon_day_energy='本月每日平均能量值'
ave_mon_day_energy=0

des_ave_year_mon_energy='今年每月平均能量值'
ave_year_mon_energy=0

des_ave_total_day_energy='总计每日平均能量值'
ave_total_day_energy=0

des_ave_total_mon_energy='总计每月平均能量值'
ave_total_mon_energy=0

des_ave_total_year_energy='总计每年平均能量值'
ave_total_year_energy=0
#energy-2============================================== energy


#income-1============================================== 资产管理
des_my_asset_target='资产目标'
my_asset_target=1000000

des_today_income='今日入账额'
today_income=0

des_mon_income='本月入账额'
mon_income=0

des_year_income='今年入账额'
year_income=0

des_total_income='总入账额'
total_income=0

des_asset_gap='与资产目标差额'
asset_gap=1000000

des_rate_asset_completed='资产目标完成比例'
rate_asset_completed=0


des_mon_high_income_days='本月收益达到8000以上天数'
mon_high_income_days=0

des_year_high_income_days='今年收益达到8000以上天数'
year_high_income_days=0

des_total_high_income_days='总计收益达到8000以上天数'
total_high_income_days=0


des_rate_mon_high_income_days='本月收益达到8000以上比例'
rate_mon_high_income_days=0

des_rate_year_high_income_days='今年收益达到8000以上比例'
rate_year_high_income_days=0

des_rate_total_high_income_days='总计收益达到8000以上比例'
rate_total_high_income_days=0


des_high_income_days_count_flag='高income统计标记，1--未统计 2--已统计'
high_income_days_count_flag=1


des_ave_mon_day_income='本月平均每日入账额'
ave_mon_day_income=0

des_ave_year_day_income='今年平均每日入账额'
ave_year_day_income=0

des_ave_year_mon_income='今年平均每月入账额'
ave_year_mon_income=0


des_ave_total_day_income='总计平均每日入账额'
ave_total_day_income=0

des_ave_total_mon_income='总计平均每月入账额'
ave_total_mon_income=0

des_ave_total_year_income='总计平均每年入账额'
ave_total_year_income=0
#income-2============================================== 资产管理


#focus-1============================================== focus
des_focus_on_out='当前focus状态'
focus_on_out=OUT

des_start_focus_timestamp='开始统计的时间戳(秒)'
start_focus_timestamp=1680868440


des_today_focus_time='今日focus时间(小时)'
today_focus_time=0

des_mon_focus_time='本月focus时间(小时)'
mon_focus_time=0

des_year_focus_time='今年focus时间(小时)'
year_focus_time=0

des_total_focus_time='总计focus时间(小时)'
total_focus_time=0


des_mon_high_focus_days='本月focus达到10h以上天数'
mon_high_focus_days=0

des_year_high_focus_days='今年focus达到10h以上天数'
year_high_focus_days=0

des_total_high_focus_days='总计focus达到10h以上天数'
total_high_focus_days=0


des_rate_mon_high_focus_days='本月focus达到10h以上比例'
rate_mon_high_focus_days=0

des_rate_year_high_focus_days='今年focus达到10h以上比例'
rate_year_high_focus_days=0

des_rate_total_high_focus_days='总计focus达到10h以上比例'
rate_total_high_focus_days=0


des_high_focus_days_count_flag='高focus统计标记，1--未统计 2--已统计'
high_focus_days_count_flag=1


des_ave_mon_day_focus_time='本月平均每日focus时间'
ave_mon_day_focus_time=0

des_ave_year_day_focus_time='今年平均每日focus时间'
ave_year_day_focus_time=0

des_ave_year_mon_focus_time='今年平均每月focus时间'
ave_year_mon_focus_time=0

des_ave_total_day_focus_time='总计平均每日focus时间'
ave_total_day_focus_time=0

des_ave_total_mon_focus_time='总计平均每月focus时间'
ave_total_mon_focus_time=0

des_ave_total_year_focus_time='总计平均每年focus时间'
ave_total_year_focus_time=0
#focus-2============================================== focus


#task-1============================================== 任务管理
#任务编号：A1

des_task_name_A1='任务名称(A1)'
task_name_A1=''

des_task_deadline_days_A1='任务期限,以天为单位(A1)'
task_deadline_days_A1=0

des_task_start_day_A1='任务开始日期(A1)'
task_start_day_A1=0

des_task_end_day_A1='任务计划结束日期(A1)'
task_end_day_A1=0

des_task_state_A1='任务状态(A1) 1--未设置  2--进行中  3--已完成  4--已暂停  5--已终止  6--已逾期'
task_state_A1=1


des_total_task_num_A1='总任务数(A1)'
total_task_num_A1=0

des_today_task_num_A1='今日完成任务数(A1)'
today_task_num_A1=0

des_completed_task_num_A1='已完成任务数(A1)'
completed_task_num_A1=0

des_remaining_task_num_A1='剩余任务数(A1)'
remaining_task_num_A1=0

des_rate_task_completed_A1='任务完成率(A1)'
rate_task_completed_A1=0


des_task_days_A1='任务已进行的天数(A1) 从0开始'
task_days_A1=0

des_remaining_task_days_A1='任务期限剩余天数(A1)'
remaining_task_days_A1=0

des_ave_task_A1='任务速度(A1) 已完成任务数/已进行的天数'
ave_task_A1=0

#-------------------------------------------下面这些不针对某一编号任务，统计全体任务
des_mon_task_completed_num='本月完成任务数'
mon_task_completed_num=0

des_year_task_completed_num='今年完成任务数'
year_task_completed_num=0

des_total_task_completed_num='总完成任务数'
total_task_completed_num=0


des_ave_mon_day_task_completed_num='本月完成任务日速度'
ave_mon_day_task_completed_num=0

des_ave_year_day_task_completed_num='今年完成任务日速度'
ave_year_day_task_completed_num=0

des_ave_year_mon_task_completed_num='今年完成任务月速度'
ave_year_mon_task_completed_num=0


des_ave_total_day_task_completed_num='总计完成任务日速度'
ave_total_day_task_completed_num=0

des_ave_total_mon_task_completed_num='总计完成任务月速度'
ave_total_mon_task_completed_num=0

des_ave_total_year_task_completed_num='总计完成任务年速度'
ave_total_year_task_completed_num=0


des_mon_high_task_days='本月完成任务8个以上天数'
mon_high_task_days=0

des_year_high_task_days='今年完成任务8个以上天数'
year_high_task_days=0

des_total_high_task_days='总计完成任务8个以上天数'
total_high_task_days=0


des_high_task_days_count_flag='高task统计标记，1--未统计 2--已统计'
high_task_days_count_flag=1


des_rate_mon_high_task_days='本月完成任务8个以上比例'
rate_mon_high_task_days=0

des_rate_year_high_task_days='今年完成任务8个以上比例'
rate_year_high_task_days=0

des_rate_total_high_task_days='总计完成任务8个以上比例'
rate_total_high_task_days=0

#-------------------------------------------------------------
des_task_finish_time='本次完成任务的时间'
task_finish_time=19:54:18

des_last_task_finish_timestamp='上次完成任务的时间戳(秒)，下次完成任务时，减去此时间，即可得到耗时'
last_task_finish_timestamp=1680868458

des_task_time_taken='两次完成任务之间的时间间隔，即是耗时(分钟)'
task_time_taken=0
#task-2============================================== 任务管理


#system_core_params-------------------------------以上为核心参数，不允许删除！！！-----------------------------------------


#sport-1============================================== 运动
des_today_sport='运动'
today_sport=NO

des_mon_sport_days='本月运动天数'
mon_sport_days=0

des_year_sport_days='今年运动天数'
year_sport_days=0

des_total_sport_days='总计运动天数'
total_sport_days=0

des_total_sport_days_to_year='总运动天数折合为年 总天数/365'
total_sport_days_to_year=0


des_rate_mon_sport_days='本月运动比例'
rate_mon_sport_days=0

des_rate_year_sport_days='今年运动比例'
rate_year_sport_days=0

des_rate_total_sport_days='总计运动比例'
rate_total_sport_days=0
#sport-2============================================== 运动


#reading-1============================================== 读书
des_today_reading='读书'
today_reading=NO

des_mon_reading_days='本月读书天数'
mon_reading_days=0

des_year_reading_days='今年读书天数'
year_reading_days=0

des_total_reading_days='总计读书天数'
total_reading_days=0

des_total_reading_days_to_year='总读书天数折合为年 总天数/365'
total_reading_days_to_year=0


des_rate_mon_reading_days='本月读书比例'
rate_mon_reading_days=0

des_rate_year_reading_days='今年读书比例'
rate_year_reading_days=0

des_rate_total_reading_days='总计读书比例'
rate_total_reading_days=0
#reading-2============================================== 读书


#english-1============================================== 英语
des_today_english='学英语'
today_english=NO

des_mon_english_days='本月学英语天数'
mon_english_days=0

des_year_english_days='今年学英语天数'
year_english_days=0

des_total_english_days='总计学英语天数'
total_english_days=0


des_rate_mon_english_days='本月学英语比例'
rate_mon_english_days=0

des_rate_year_english_days='今年学英语比例'
rate_year_english_days=0

des_rate_total_english_days='总计学英语比例'
rate_total_english_days=0
#english-2============================================== 英语


#study-1============================================== 学习
des_today_study_times='今日学习次数'
today_study_times=0

des_mon_study_times='本月学习次数'
mon_study_times=0

des_year_study_times='今年学习次数'
year_study_times=0

des_total_study_times='总计学习次数'
total_study_times=0
#study-2============================================== 学习


#play_game-1============================================== 玩游戏
des_today_play_game_times='今日玩游戏次数'
today_play_game_times=0

des_mon_play_game_times='本月玩游戏次数'
mon_play_game_times=0

des_year_play_game_times='今年玩游戏次数'
year_play_game_times=0

des_total_play_game_times='总计玩游戏次数'
total_play_game_times=0
#play_game-2============================================== 玩游戏


