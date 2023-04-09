#!/bin/bash
#睡不好

cd `dirname $0`
source ./funcs.sh

baseDir=./data/note/life/$year

#今天已经更新过睡眠质量的话不能再更新
exit_script2 sleep_record_flag 2

check_syste_is_init


badSleep()
{     

        #低能量天数+1
        addOrSub +1 mon_low_energy_days year_low_energy_days total_low_energy_days
        changeParams 2 high_energy_days_count_flag

        addOrSub +1 mon_bad_sleep_days year_bad_sleep_days total_bad_sleep_days

		#计算收益
		compute_income -3000 bad_sleep_days

        #更改编辑标志
        changeParams 2 sleep_record_flag


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
		read  goal

		if [ "$goal" ] ;then

			printSeparatorByDate 3 $baseDir/dailyGoals.txt
			echo -e "$today2     $goal\n\n" >> $baseDir/dailyGoals.txt 2> /dev/null
			changeParams "'$goal'" today_goal
			
			badSleep
		fi
		
	fi

}



tput cnorm
clear
echo -ne "\n\n请输入睡不好的原因："
read reason

if [ "$reason" ] ;then

	printSeparatorByDate 3 $baseDir/badSleepReason.txt
    echo -e "$today2     $reason\n\n" >> $baseDir/badSleepReason.txt 2> /dev/null
	
	speak
	
fi


showConsole


