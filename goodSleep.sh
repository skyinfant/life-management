#!/bin/bash
#睡得好

cd `dirname $0`
source ./funcs.sh

baseDir=./data/note/life/$year

#今天已经更新过睡眠质量的话不能再更新
exit_script2 sleep_record_flag 2

goodSleep()
{
		# 睡眠质量好
        changeParams YES today_good_sleep

        addOrSub +1 mon_good_sleep_days year_good_sleep_days total_good_sleep_days 

    	#计算收益
		income=`mul $1 100 0`
		compute_income +$income today_good_sleep

		#睡眠质量好的天数折合为年
		years=`divide $total_good_sleep_days 365 2`
		changeParams $years total_good_sleep_days_to_year

		#计算平均值和百分比
		ave_all 1 ave_year_mon_good_sleep_days
		rate_all 2 rate_mon_good_sleep_days

        #更改编辑标志
        changeParams 2 sleep_record_flag

}


compute_energy(){

    #记录今天能量
    changeParams $1 today_energy

    #年度，月度，总能量
    doubleAddOrSub 2 $1 add year_energy mon_energy total_energy

    if [ `compare $1 '<' 8` ]
    then
        addOrSub +1 mon_low_energy_days year_low_energy_days total_low_energy_days

    else
        addOrSub +1 year_high_energy_days mon_high_energy_days total_high_energy_days

		rate_all 2 rate_mon_high_energy_days
		

    fi

	changeParams 2 high_energy_days_count_flag

    ave_all 2 ave_mon_day_energy

}



speak(){

	clear
	echo -ne "\n\n请对今天的自己说一句话："
	read word

	if [ "$word" ] ;then

		printSeparatorByDate 3 $baseDir/selfWord.txt
		echo -e "$today2     $word\n\n" >> $baseDir/selfWord.txt 2> /dev/null

		clear
		echo -ne "\n\n请输入今天的目标："
		read goal

		if [ "$goal" ] ;then

			printSeparatorByDate 3 $baseDir/dailyGoals.txt
			echo -e "$today2     $goal\n\n" >> $baseDir/dailyGoals.txt 2> /dev/null
			changeParams "'$goal'" today_goal
			
			goodSleep $1
			compute_energy $1			
			
		fi

	fi


}


tput cnorm
clear
echo -ne "\n\n请输入今天的能量值(0-10)："
read energy

if [ "$energy" ] ;then

        if [ `isNum $energy` ];then
				if [ `compare $energy '<' 8` ];then
                        clear
						echo -ne "\n\n请输入睡不好的原因："
						read reason

                        if [ "$reason" ] ;then
							
							printSeparatorByDate 3 $baseDir/badSleepReason.txt
					        echo -e "$today2     $reason\n\n" >> $baseDir/badSleepReason.txt 2> /dev/null

							speak $energy
                        fi

                else

                	clear
					echo -ne "\n\n请输入睡得好的原因："
                    read reason

                    if [ "$reason" ] ;then

						printSeparatorByDate 3 $baseDir/goodSleepReason.txt
                    	echo -e "$today2     $reason\n\n" >> $baseDir/goodSleepReason.txt 2> /dev/null
							
                        speak $energy
                    fi
                fi

        fi 

fi


showConsole


