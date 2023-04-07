#!/bin/bash
#选择数字，运行相应脚本，实现相应功能

cd `dirname $0`
source ./funcs.sh


#今天还没更新过睡眠质量的话不能操作
exit_script2 sleep_record_flag 1

tput cnorm
while [ 1 ]
do


setColor2 today_sport today_english today_reading \
          today_study_times today_play_game_times

setColor3 1 36m mon_sport_days year_sport_days mon_english_days \
year_english_days mon_reading_days year_reading_days \
mon_study_times year_study_times mon_play_game_times year_play_game_times


setColor3 1 33m today_income mon_income year_income


clear


cat <<list
   $today_income                $mon_income                $year_income
*******************************************************

   1、运动               $today_sport      $mon_sport_days         $year_sport_days              

   2、英语               $today_english      $mon_english_days         $year_english_days              

   3、读书               $today_reading      $mon_reading_days         $year_reading_days              

   4、学习               $today_study_times      $mon_study_times         $year_study_times

   5、玩游戏             $today_play_game_times      $mon_play_game_times         $year_play_game_times

*******************************************************
list

read -n 1 -p "请输入你的选项(q退出)：" key

flush
hour=`date "+%H"`

#按天数计算的用operate1
[ $key = 1 ]  && operate1 today_sport +300
[ $key = 2 ]  && operate1 today_english +85
[ $key = 3 ]  && operate1 today_reading +300

#按次数计算的用operate2
[ $key = 4 ]  && operate2 today_study_times +300
[ $key = 5 ]  && operate2 today_play_game_times -100

[ $key = q ]  && break

done


showConsole

