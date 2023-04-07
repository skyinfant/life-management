#!/bin/bash

source ./funcs.sh

#把数据保存到db
saveDataToDb


#更新页面数据
updatePage()
{

	#页面
	page=$1
	#开始标记
	flag_start=$2
	#结束标记
	flag_end=$3
	#更新内容
	content=$4
	
	row_start=`getRowNum $page "$flag_start" 1`
    row_end=`getRowNum $page "$flag_end" 1`

    let num=row_end-row_start
    if [ $num -gt 1 ];then

        let row_start=row_start+1
        let row_end=row_end-1

        sed -i "$row_start,$row_end c $content" $page

    else

        sed -i "$row_end i $content" $page

    fi


}


if [ $1 -eq 1 ];then

	#----------------------------------------------------------------------把今天数据写入每日页面
	flush
	
	 param1="var goodSleep = $year_good_sleep_days\n"
	 param2="var badSleep = $year_no_good_sleep_days\n"
	 param3="var energyTitle = '$year平均能量值：$ave_year_day_energy'\n"
	 param4="var highEnergy = $year_high_energy_days\n"
	 param5="var lowEnergy = $year_low_energy_days\n"
	 param6="var completed = $total_income\n"
	 param7="var uncompleted = $asset_gap\n"
	 param8="var zonghezichan = '综合资产\\\n\\\n$total_income元\\\n\\\n$total_focus_time小时'\n"
	 param9="var date_today = '$mon_of_year.$day_of_mon'\n"
	 param10="var income_today = $today_income\n"
	 param11="var taskNum_today = $today_task_num_A1\n"
	 param12="var focusTime_today = $today_focus_time\n"
	 param13="var energy_today = $today_energy\n"
	 param14="var bg_music = '$daily_page_music'"

	all_params_str="$param1$param2$param3$param4$param5$param6$param7$param8$param9$param10$param11$param12$param13$param14"
	updatePage $dailyHtml new_params_start new_params_end "$all_params_str"
	#----------------------------------------------------------------------

	if [ $mons_and_years_page_flag -eq 1 ];then
		#----------------------------------------------------------------------把本月数据写入月度页面
		new_mon=`echo $year.$mon_of_year | cut -c 3-`
		
		param1="var new_mon = $new_mon\n"
		param2="var new_param1 = `getVal $mon_param1`\n" 
		param3="var new_param2 = `getVal $mon_param2`\n" 
		param4="var new_param3 = `getVal $mon_param3`\n" 
		param5="var new_param4 = `getVal $mon_param4`\n" 
		param6="var new_param5 = `getVal $mon_param5`\n" 
		param7="var new_param6 = `getVal $mon_param6`\n" 
		param8="var new_param7 = `getVal $mon_param7`\n" 
		param9="var new_param8 = `getVal $mon_param8`\n" 
		param10="var bg_music = '$mons_page_music'"
		 
		all_params_str="$param1$param2$param3$param4$param5$param6$param7$param8$param9$param10"
		
		updatePage $monsHtml new_params_start new_params_end "$all_params_str"
		#----------------------------------------------------------------------


		#----------------------------------------------------------------------把今年数据写入年度页面
		param1="var new_year = $year\n"
		param2="var new_param1 = `getVal $year_param1`\n" 
		param3="var new_param2 = `getVal $year_param2`\n" 
		param4="var new_param3 = `getVal $year_param3`\n" 
		param5="var new_param4 = `getVal $year_param4`\n" 
		param6="var new_param5 = `getVal $year_param5`\n" 
		param7="var new_param6 = `getVal $year_param6`\n" 
		param8="var new_param7 = `getVal $year_param7`\n" 
		param9="var new_param8 = `getVal $year_param8`\n" 
		param10="var bg_music = '$years_page_music'"
		
		all_params_str="$param1$param2$param3$param4$param5$param6$param7$param8$param9$param10"
		
		updatePage $yearsHtml new_params_start new_params_end "$all_params_str"	
		#----------------------------------------------------------------------
		
	fi

else
	#----------------------------------------------------------------------把往日数据写入每日页面
	flush
	row_count=`getRowCount $dailyData`

	#如果有2条以上有效数据(开头2条是字段名)
	#1条有效数据代表一天
	if [ $row_count -ge 4 ];
	then

		if [ $row_count -ge 32 ];
		then
		
			#有30条以上有效数据，则从倒数第30条读到倒数第2条
			let row_start=row_count-29
			let row_end=row_count-1
		
		else
		
			#没有30条以上有效数据，则从第1条有效数据读到倒数第2条
			let row_start=3
			let row_end=row_count-1
		
		fi

		today_col=`getParamCol today $dailyData`
		income_col=`getParamCol today_income $dailyData`
		task_col=`getParamCol today_task_num_A1 $dailyData`
		focus_col=`getParamCol today_focus_time $dailyData`
		energy_col=`getParamCol today_energy $dailyData`

		for row in $(seq $row_start $row_end); do
			all_params=$(sed -n "${row}p" $dailyData)

			date=$(echo $all_params | cut -d ',' -f $today_col | cut -d '.' -f 2,3)
			income=$(echo $all_params | cut -d ',' -f $income_col)
			taskNum=$(echo $all_params | cut -d ',' -f $task_col)
			focusTime=$(echo $all_params | cut -d ',' -f $focus_col)
			energy=$(echo $all_params | cut -d ',' -f $energy_col)

			dateArr="$dateArr'$date',"
			incomeArr="$incomeArr$income,"
			taskNumArr="$taskNumArr$taskNum,"
			focusTimeArr="$focusTimeArr$focusTime,"
			energyArr="$energyArr$energy,"
		done

	fi

	param1="var dateArr = [${dateArr}date_today]\n"
	param2="var incomeArr = [${incomeArr}income_today]\n"
	param3="var taskNumArr = [${taskNumArr}taskNum_today]\n"
	param4="var focusTimeArr = [${focusTimeArr}focusTime_today]\n"
	param5="var energyArr = [${energyArr}energy_today]\n"
	param6="var sleepTitle = '$year年度睡眠质量'"
	
	all_params_str="$param1$param2$param3$param4$param5$param6"
	updatePage $dailyHtml params_start params_end "$all_params_str"	
	#----------------------------------------------------------------------

	if [ $mons_and_years_page_flag -eq 1 ];then
	
		#----------------------------------------------------------------------把已过去的月度数据写入月度页面
		flush
		row_count=`getRowCount $monsData`

		arr1=''
		arr2=''
		arr3=''
		arr4=''
		arr5=''
		arr6=''
		arr7=''
		arr8=''

		#如果有2条以上有效数据(开头2条是字段名)
		#1条有效数据代表一个月
		if [ $row_count -ge 4 ];
		then

			if [ $row_count -ge 26 ];
			then

				#有24条以上有效数据，则从倒数第24个条读到倒数第2条
				let row_start=row_count-23
				let row_end=row_count-1
				
			else
			
				#没有24条以上有效数据，则从第1条有效数据读到倒数第2条
				let row_start=3
				let row_end=row_count-1

			fi
			
			mon_col=`getParamCol mon $monsData`
			
			col1=`getParamCol $mon_param1 $monsData`
			col2=`getParamCol $mon_param2 $monsData`
			col3=`getParamCol $mon_param3 $monsData`
			col4=`getParamCol $mon_param4 $monsData`
			col5=`getParamCol $mon_param5 $monsData`
			col6=`getParamCol $mon_param6 $monsData`
			col7=`getParamCol $mon_param7 $monsData`
			col8=`getParamCol $mon_param8 $monsData`
			
			for row in $(seq $row_start $row_end); do

				all_params=$(sed -n "${row}p" $monsData)

				mon=`echo $all_params | cut -d ',' -f $mon_col`
				mon=`echo $mon | cut -c 3-`
				
				param1=`echo $all_params | cut -d ',' -f $col1`
				param2=`echo $all_params | cut -d ',' -f $col2`
				param3=`echo $all_params | cut -d ',' -f $col3`
				param4=`echo $all_params | cut -d ',' -f $col4`
				param5=`echo $all_params | cut -d ',' -f $col5`
				param6=`echo $all_params | cut -d ',' -f $col6`
				param7=`echo $all_params | cut -d ',' -f $col7`
				param8=`echo $all_params | cut -d ',' -f $col8`

				monArr="$monArr'$mon',"
				
				arr1="$arr1$param1,"
				arr2="$arr2$param2,"
				arr3="$arr3$param3,"
				arr4="$arr4$param4,"
				arr5="$arr5$param5,"
				arr6="$arr6$param6,"
				arr7="$arr7$param7,"
				arr8="$arr8$param8,"
			done

		fi
		
		param_name1=`getVal des_$mon_param1 | sed "s/本月//g"`
		param_name2=`getVal des_$mon_param2 | sed "s/本月//g"`
		param_name3=`getVal des_$mon_param3 | sed "s/本月//g"`
		param_name4=`getVal des_$mon_param4 | sed "s/本月//g"`
		param_name5=`getVal des_$mon_param5 | sed "s/本月//g"`
		param_name6=`getVal des_$mon_param6 | sed "s/本月//g"`
		param_name7=`getVal des_$mon_param7 | sed "s/本月//g"`
		param_name8=`getVal des_$mon_param8 | sed "s/本月//g"`
		
		param_name_arr="['$param_name1','$param_name2','$param_name3','$param_name4','$param_name5','$param_name6','$param_name7','$param_name8']"	
		color_arr="['$line_chart_color1','$line_chart_color2','$line_chart_color3','$line_chart_color4','$line_chart_color5','$line_chart_color6','$line_chart_color7','$line_chart_color8']"

		param1="var monArr = [${monArr}new_mon]\n"
		param2="var arr1 = [${arr1}new_param1]\n"
		param3="var arr2 = [${arr2}new_param2]\n"
		param4="var arr3 = [${arr3}new_param3]\n"
		param5="var arr4 = [${arr4}new_param4]\n"
		param6="var arr5 = [${arr5}new_param5]\n"
		param7="var arr6 = [${arr6}new_param6]\n"
		param8="var arr7 = [${arr7}new_param7]\n"
		param9="var arr8 = [${arr8}new_param8]\n\n"
		
		param10="var param_name_arr = $param_name_arr\n"
		param11="var color_arr = $color_arr"
		
		all_params_str="$param1$param2$param3$param4$param5$param6$param7$param8$param9$param10$param11"
		
		updatePage $monsHtml params_start params_end "$all_params_str"
		#----------------------------------------------------------------------


		#----------------------------------------------------------------------把已过去的年度数据写入年度页面 
		flush
		row_count=`getRowCount $yearsData`
		
		arr1=''
		arr2=''
		arr3=''
		arr4=''
		arr5=''
		arr6=''
		arr7=''
		arr8=''

		#如果有2条以上有效数据(开头2条是字段名)
		#1条有效数据代表一年
		if [ $row_count -ge 4 ];
		then

			#从第1条有效数据读到倒数第2条
			let row_start=3
			let row_end=row_count-1

			year_col=`getParamCol year $yearsData`
			
			col1=`getParamCol $year_param1 $yearsData`
			col2=`getParamCol $year_param2 $yearsData`
			col3=`getParamCol $year_param3 $yearsData`
			col4=`getParamCol $year_param4 $yearsData`
			col5=`getParamCol $year_param5 $yearsData`
			col6=`getParamCol $year_param6 $yearsData`
			col7=`getParamCol $year_param7 $yearsData`
			col8=`getParamCol $year_param8 $yearsData`
				
			for row in $(seq $row_start $row_end); do

				all_params=$(sed -n "${row}p" $yearsData)

				y=`echo $all_params | cut -d ',' -f $year_col`
				
				param1=`echo $all_params | cut -d ',' -f $col1`
				param2=`echo $all_params | cut -d ',' -f $col2`
				param3=`echo $all_params | cut -d ',' -f $col3`
				param4=`echo $all_params | cut -d ',' -f $col4`
				param5=`echo $all_params | cut -d ',' -f $col5`
				param6=`echo $all_params | cut -d ',' -f $col6`
				param7=`echo $all_params | cut -d ',' -f $col7`
				param8=`echo $all_params | cut -d ',' -f $col8`

				yearArr="$yearArr'$y',"
				
				arr1="$arr1$param1,"
				arr2="$arr2$param2,"
				arr3="$arr3$param3,"
				arr4="$arr4$param4,"
				arr5="$arr5$param5,"
				arr6="$arr6$param6,"
				arr7="$arr7$param7,"
				arr8="$arr8$param8,"
			done

		fi

		param_name1=`getVal des_$year_param1 | sed "s/今年//g"`
		param_name2=`getVal des_$year_param2 | sed "s/今年//g"`
		param_name3=`getVal des_$year_param3 | sed "s/今年//g"`
		param_name4=`getVal des_$year_param4 | sed "s/今年//g"`
		param_name5=`getVal des_$year_param5 | sed "s/今年//g"`
		param_name6=`getVal des_$year_param6 | sed "s/今年//g"`
		param_name7=`getVal des_$year_param7 | sed "s/今年//g"`
		param_name8=`getVal des_$year_param8 | sed "s/今年//g"`
		
		param_name_arr="['$param_name1','$param_name2','$param_name3','$param_name4','$param_name5','$param_name6','$param_name7','$param_name8']"
		color_arr="['$line_chart_color1','$line_chart_color2','$line_chart_color3','$line_chart_color4','$line_chart_color5','$line_chart_color6','$line_chart_color7','$line_chart_color8']"

		param1="var yearArr = [${yearArr}new_year]\n"
		param2="var arr1 = [${arr1}new_param1]\n"
		param3="var arr2 = [${arr2}new_param2]\n"
		param4="var arr3 = [${arr3}new_param3]\n"
		param5="var arr4 = [${arr4}new_param4]\n"
		param6="var arr5 = [${arr5}new_param5]\n"
		param7="var arr6 = [${arr6}new_param6]\n"
		param8="var arr7 = [${arr7}new_param7]\n"
		param9="var arr8 = [${arr8}new_param8]\n\n"
		
		param10="var param_name_arr = $param_name_arr\n"
		param11="var color_arr = $color_arr"
		
		all_params_str="$param1$param2$param3$param4$param5$param6$param7$param8$param9$param10$param11"
		updatePage $yearsHtml params_start params_end "$all_params_str"	
		#----------------------------------------------------------------------
	fi
	
fi


#-------------------------------------------------------------------------------
#本月数据页面
sh ./makeMonSumPage.sh
#今年数据页面
sh ./makeYearSumPage.sh
#汇总数据页面
sh ./makeSumPage.sh
#-------------------------------------------------------------------------------




