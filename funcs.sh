#!/bin/bash
#定义各种函数

#参数文件
paramFile=./data/params.sh
source $paramFile

#配置文件
configFile=./config/config.sh
source $configFile

#每日数据文件
dailyData='./data/db/dailyData.db'
#月度数据文件
monsData='./data/db/monsData.db'
#年度数据文件
yearsData='./data/db/yearsData.db'

dailyHtml=./html/index.html
monsHtml=./html/mons.html
yearsHtml=./html/years.html

#收益流水文件
income_file=./data/note/income_flow/$year.txt

#退出脚本
exit_script() {
	showConsole
	exit 1
}

#参数等于指定值即退出脚本，第一个是参数名，第二个是期望值  如果参数的值等于期望值，则退出脚本
#exit_script2 sleep_record_flag 1      exit_script2 today_against_good_sleep YES
exit_script2() {
	num1=$(boolToNum $1)
	num2=$2
	[ $2 = YES ] && num2=1
	[ $2 = NO ] && num2=0

	[ $num1 -eq $num2 ] && exit_script

}

#退出脚本
exit_script3() {
	echo '非法操作，已退出脚本！'
	exit 1
}

#获取参数值     total_income=100    a=total_income  通过参数a获取100
#          num=`getVal $a`
#注意，此方法一般用来获取全局参数的值，且方法入参不能是数字，比如 getVal 1
getVal() {

	value=$(eval echo "$"$1)
	echo $value
}


#此变量用来获取某个方法入参的值，在遍历时使用,（遍历变量名必须叫item ！！！）
#paramName=`eval $gv`
gv='eval echo "$"{$item}'


#批量读取参数   readParams aa bb cc   （此方法效率太低，不如用flush）
readParams() {

	#遍历所有传入参数
	for item in $(seq 1 $#); do

		#某个参数，eg：today_reading
		paramName=$(eval $gv)
		#获取参数所在的那一行并且化为表达式  eg：today_reading=YES
		eval $(cat $paramFile | grep -w "$paramName")

	done

}


#批量修改参数值  第1个参数是目标值，第2到最后一个参数是要改变值的变量名    changeParams 0 param1 param2
changeParams() {

	#遍历要改变值的参数
	for item in $(seq 2 $#); do

		#某个参数，eg：today_reading
		paramName_change=$(eval $gv)

		#要修改的参数所在的行
		row_num227=`getRowNum $paramFile "$paramName_change" 3`
		
		if [ "$row_num227" ];then

			sed -i "${row_num227}c $paramName_change=$1" $paramFile
			
			[ $? -ne 0 ] && echo -e "\n`now`    参数非法    changeParams    paramName_change=$paramName_change    row_num227=$row_num227" >> ./data/logs/error.log

		else

			echo -e "\n`now`    参数非法    changeParams    paramName_change=$paramName_change    row_num227=$row_num227" >> ./data/logs/error.log

		fi

	done

	flush

}


#根据参数所在的行数修改参数值 $1-文件编号 $2-参数名 $3-要改为的值 
# changeFile $configFile mons_and_years_page_flag 2
changeFile() {
	#要操作的文件
	file23=$1

	#要修改的参数所在的行
	row_num227=`getRowNum $file23 "$2" 1`
	#echo row_num227="$row_num227"
	value="$2=$3"
	
	if [ "$row_num227" ];then

		sed -i "${row_num227}c $value" $file23
		
		[ $? -ne 0 ] && echo -e "\n`now`    参数非法    changeFile    value=$value    row_num227=$row_num227" >> ./data/logs/error.log

	else
	
		echo -e "\n`now`    参数非法    changeFile    value=$value    row_num227=$row_num227" >> ./data/logs/error.log
		
	fi

}


#增加参数值或减少参数值  第1个参数是要增或减的数量，第2到最后一个参数是要操作的变量名   参数名后不要加等号
#适合整数加减，正数和负数都可以   addOrSub +100 param1 param2     addOrSub -100 param1 param2
addOrSub() {

	#遍历要改变值的参数
	for item in $(seq 2 $#); do

		#某个参数，eg：today_income
		paramName_aos=$(eval $gv)

		#要修改的参数所在的行
		row_str137=`getRowNum $paramFile "$paramName_aos" 3 1`
		row_num227=`echo "$row_str137" | cut -d ':' -f 1`
		
		if [ "$row_num227" ];then

			row45=`echo "$row_str137" | cut -d ':' -f 2`
			row_value36=`echo "$row45" | cut -d '=' -f 2`
			let newValue77=$row_value36$1
			sed -i "${row_num227}c $paramName_aos=$newValue77" $paramFile
			
			[ $? -ne 0 ] && echo -e "\n`now`    参数非法    addOrSub    paramName_aos=$paramName_aos    row_num227=$row_num227" >> ./data/logs/error.log

		else

			echo -e "\n`now`    参数非法    addOrSub    paramName_aos=$paramName_aos    row_num227=$row_num227" >> ./data/logs/error.log

		fi

	done

	flush

}


#增加参数值或减少参数值  第1个参数是要保留结果的小数点后位数，第2是要增或减的数量，第3是add或者sub 第4到最后一个参数是要操作的变量名
#适合整数和小数加减,正负皆可      doubleAddOrSub 1 3.15 add param1 param2
doubleAddOrSub() {

	#遍历要改变值的参数
	for item in $(seq 4 $#); do

		#某个参数名，eg：today_income
		paramName_double=$(eval $gv)
		
		
		#要修改的参数所在的行
		row_str137=`getRowNum $paramFile "$paramName_double" 3 1`
		row_num227=`echo "$row_str137" | cut -d ':' -f 1`
		
		if [ "$row_num227" ];then

			row45=`echo "$row_str137" | cut -d ':' -f 2`
			row_value36=`echo "$row45" | cut -d '=' -f 2`
			newValue77=`$3 $row_value36 $2 $1`
			sed -i "${row_num227}c $paramName_double=$newValue77" $paramFile
			
			[ $? -ne 0 ] && echo -e "\n`now`    参数非法    doubleAddOrSub    paramName_double=$paramName_double    row_num227=$row_num227" >> ./data/logs/error.log

		else

			echo -e "\n`now`    参数非法    doubleAddOrSub    paramName_double=$paramName_double    row_num227=$row_num227" >> ./data/logs/error.log

		fi

	done

	flush

}


#常规参数操作   每日参数的值类型为Boolean，统计天数，参数后缀为_days
# operate1 today_sport +300
operate1() {
	#要操作的参数  today_sport
	param=$1
	#要增加的或减少的income
	income=$2

	#参数值
	paramValue=$(getVal $param)

	#参数不存在或已操作则退出方法
	[ ! $paramValue ] && return 0
	[ $paramValue = YES ] && return 0

	#标记为已操作
	changeParams YES $param

	#计算收益
	compute_income $income $param

	#比如today_smile截取出smile
	str1=$(echo $param | cut -d '_' -f 2-)
	#本月天数  mon_smile_days
	mon=mon_${str1}_days
	#今年天数  year_smile_days
	y=year_${str1}_days
	#总计天数  total_smile_days
	total=total_${str1}_days
	#天数+1
	addOrSub +1 $mon $y $total

	#计算比例
	rate_all 2 ${str1}_days

	#折合为年
	if [ $str1 = 'reading' ] || [ $str1 = 'sport' ];then
		days=$(getVal $total)
		years=$(divide $days 365 2)
		paramName=total_${str1}_days_to_year
		changeParams $years $paramName
	fi


}


#常规参数操作   每日参数的值类型为number，统计次数，参数后缀为_times
# operate2 today_xxx_times -2000
operate2() {
	#要操作的参数  today_xxx_times
	param=$1
	#要增加的或减少的income
	income=$2

	#参数值
	paramValue=$(getVal $param)

	#参数不存在则退出方法
	[ ! $paramValue ] && return 0

	#计算收益
	compute_income $income $param

	#比如 today_xxx_times 截取出 xxx_times
	str1=$(echo $param | cut -d '_' -f 2-)
	#本月次数  mon_xxx_times
	mon=mon_${str1}
	#今年次数  year_xxx_times
	y=year_${str1}
	#总计次数  total_xxx_times
	total=total_${str1}
	#次数+1
	addOrSub +1 $param $mon $y $total

}


#--------------------------------------------------------------------四则运算
#两数相加，适合整数和小数运算,正负皆可   add 7.25 1.25 2
add() {
	num1=$1
	num2=$2
	#保留小数点后位数 0、1、2
	num3=$3

	[ $num3 -eq 0 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.0f\n",a+b}')
	[ $num3 -eq 1 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.1f\n",a+b}' | sed 's/\.0//g')
	[ $num3 -eq 2 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.2f\n",a+b}' | sed 's/\.00//g')

	echo $result

}


#两数相减，适合整数和小数运算,正负皆可   sub 7.25 1.25 2
sub() {
	num1=$1
	num2=$2
	#保留小数点后位数 0、1、2
	num3=$3

	[ $num3 -eq 0 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.0f\n",a-b}')
	[ $num3 -eq 1 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.1f\n",a-b}' | sed 's/\.0//g')
	[ $num3 -eq 2 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.2f\n",a-b}' | sed 's/\.00//g')

	echo $result

}


#两数相乘，适合整数和小数运算,正负皆可   mul 7.25 1.25 2
mul() {
	num1=$1
	num2=$2
	#保留小数点后位数 0、1、2
	num3=$3

	[ $num3 -eq 0 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.0f\n",a*b}')
	[ $num3 -eq 1 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.1f\n",a*b}' | sed 's/\.0//g')
	[ $num3 -eq 2 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.2f\n",a*b}' | sed 's/\.00//g')

	echo $result

}


#两数相除，适合整数和小数运算,正负皆可   divide 7.25 1.25 2
divide() {
	#被除数
	num1=$1
	#除数
	num2=$2
	#保留小数点后位数 0、1、2
	num3=$3

	[ $num3 -eq 0 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.0f\n",a/b}')
	[ $num3 -eq 1 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.1f\n",a/b}' | sed 's/\.0//g')
	[ $num3 -eq 2 ] && result=$(echo '' | awk -v a=$num1 -v b=$num2 '{printf "%.2f\n",a/b}' | sed 's/\.00//g')

	echo $result

}


#取余
mod()
{

    let result=$1%$2
    echo $result

}
#--------------------------------------------------------------------四则运算


#-------------------------------------------------------------------- rate
#计算百分比并更新参数  rate 1 paramName1 paramName2 paramName3
rate() {

	#保留小数点后位数 0、1、2
	k=$1
	#被除数的参数名
	paramName1=$2
	#除数的参数名
	paramName2=$3

	#要更新的参数名
	paramName3=$4

	#被除数
	value1=$(getVal $paramName1)
	#除数
	value2=$(getVal $paramName2)

	value3=$(getVal $paramName3)

	#三个参数都必须存在
	if [ $value1 ] && [ $value2 ] && [ $value3 ]; then

		[ $k -eq 0 ] && result=$(echo '' | awk -v a=$value1 -v b=$value2 '{printf "%.0f\n",a/b*100}')%
		[ $k -eq 1 ] && result=$(echo '' | awk -v a=$value1 -v b=$value2 '{printf "%.1f\n",a/b*100}' | sed 's/\.0//g')%
		[ $k -eq 2 ] && result=$(echo '' | awk -v a=$value1 -v b=$value2 '{printf "%.2f\n",a/b*100}' | sed 's/\.00//g')%

		[ "$result" = '0%' ] && result=0

		changeParams $result $paramName3

	fi

}


#批量计算百分比     rate_all 2 rate_mon_good_sleep_days  rate_mon_high_focus_days
#                    rate_all 2 good_sleep_days  high_focus_days
rate_all() {
	flush

	#保留小数点后位数 0、1、2   此处变量名不能叫item，会与外层混淆！
	k=$1

	for item in $(seq 2 $#); do

        #可能是百分比参数名，如rate_mon_good_sleep_days，也可能是百分比参数名后缀，如good_sleep_days
        str1236=$(eval $gv)

        #如果不是后缀则切割     rate_mon_good_sleep_days  --->  good_sleep_days
        [[ "$str1236" = rate_* ]] && str1236=`echo $str1236 | cut -d '_' -f 3-`

		#rate_mon
		#被除数参数名  mon_safe_space_days
		bcs=mon_$str1236
		#要计算的百收益对应参数名  rate_mon_safe_space_days
		rateName=rate_mon_$str1236
		rate $k $bcs day_of_mon $rateName
		
		
		#rate_year
		#被除数参数名  year_safe_space_days
		bcs=year_$str1236
		#要计算的百收益对应参数名  rate_year_safe_space_days
		rateName=rate_year_$str1236
		rate $k $bcs day_of_year $rateName
		
		
		#rate_total
		#被除数参数名  total_safe_space_days
		bcs=total_$str1236
		#要计算的百收益对应参数名  rate_total_safe_space_days
		rateName=rate_total_$str1236
		rate $k $bcs management_days $rateName

	done

}
#-------------------------------------------------------------------- rate


#-------------------------------------------------------------------- ave
#计算平均值并更新参数  ave 1 paramName1 paramName2 paramName3
ave() {

	#保留小数点后位数 0、1、2
	k=$1
	#被除数的参数名
	paramName1=$2
	#除数的参数名
	paramName2=$3
	#要更新的参数名
	paramName3=$4

	#被除数
	value1=$(getVal $paramName1)
	#除数
	value2=$(getVal $paramName2)

	value3=$(getVal $paramName3)

	#三个参数都必须存在
	if [ $value1 ] && [ $value2 ] && [ $value3 ]; then

		result=$(divide $value1 $value2 $k)

		changeParams $result $paramName3

	fi
}


#批量统计平均值     ave_all 1 ave_mon_day_focus_time ave_mon_day_energy
#                    ave_all 1 focus_time energy
ave_all() {
	flush

	#保留小数点后位数 0、1、2
	k=$1

	for item in $(seq 2 $#); do

        #可能是某个平均值参数名，也可能是平均值参数名后缀
        str1236=$(eval $gv)
        
        #如果不是后缀则切割     ave_mon_day_energy ---> energy
        [[ "$str1236" = ave_* ]] && str1236=`echo $str1236 | cut -d '_' -f 4-`
		
		#以 days 为后缀的参数不统计此项平均值
		if [[ $str1236 != *_days ]]; then
		
			#ave_mon_day
			#被除数 mon_energy
			am=mon_$str1236
			#计算的平均值对应参数名  ave_mon_day_energy
			amd=ave_mon_day_$str1236
			ave $k $am day_of_mon $amd
			
			#ave_year_day
			#被除数  year_energy
			ay=year_$str1236
			#计算的平均值对应参数名  ave_year_day_energy
			ayd=ave_year_day_$str1236
			ave $k $ay day_of_year $ayd
			
			#ave_total_day
			#被除数  total_energy
			at=total_$str1236
			#计算的平均值对应参数名  ave_total_day_energy
			atd=ave_total_day_$str1236
			ave $k $at management_days $atd
			
		fi
			
		#ave_year_mon
		#被除数  year_energy
		ay=year_$str1236
		#计算的平均值对应参数名  ave_year_mon_energy
		aym=ave_year_mon_$str1236
		ave $k $ay mon_of_year $aym
		
		#ave_total_mon
		#被除数  total_energy
		at=total_$str1236
		#计算的平均值对应参数名  ave_total_mon_energy
		atm=ave_total_mon_$str1236
		ave $k $at management_mons $atm
		
		#ave_total_year
		#被除数  total_energy
		at=total_$str1236
		#计算的平均值对应参数名  ave_total_year_energy
		aty=ave_total_year_$str1236
		ave $k $at management_years $aty

	done
	
}


#-------------------------------------------------------------------- ave
#初始化参数，计算百分比，平均值   init_rate_ave 1        init_rate_ave 14369721 $day $mon_day
init_rate_ave()
{      
	# 1--计算百分比和平均值     14369721--计算百分比和平均值+初始化参数
	mode=$1
    #几号 1
	day=$2	
	#月日  1.1
	mon_day=$3

	mons_param=`sed -n "2p" $monsData`
	years_param=`sed -n "2p" $yearsData`
	paramSeq23=$mons_param,$years_param

	if [ $mode -eq 14369721 ] && [ $day ] && [ $mon_day ];then

		daily_param=`sed -n "2p" $dailyData` 
		paramSeq23=$paramSeq23,$daily_param
		
		#初始化各种flag
		high_flag_list=`cat $paramFile | grep '_days_count_flag' | grep -v 'des_' | trim`

		flag_arr=(${high_flag_list// / })
		len=${#flag_arr[*]}
	
		for ((f = 0; f < $len; f++)); do
			flag_param=${flag_arr[$f]}
			flag_param=`echo $flag_param | cut -d '=' -f 1`

			changeParams 1 $flag_param

		done

    fi

	#参数数组
	paramName_arr15=(${paramSeq23//,/ })
	arr_len=${#paramName_arr15[*]i}

	rate_arr=()
	ave_arr=()
	for ((m1 = 0; m1 < $arr_len; m1++)); do
		#rate_mon_high_focus_days
		paramName17=${paramName_arr15[$m1]}

		if [ $mode -eq 14369721 ] && [ $day ] && [ $mon_day ];then

			#原值
			old_value=`getVal $paramName17`
			[ ! $old_value ] && continue

			[[ $paramName17 = today_* ]] && [ $old_value = YES ] && changeParams NO $paramName17 && continue
			[[ $paramName17 = today_* ]] && [ `isNum $old_value` ] && [ $old_value != 0 ] && changeParams 0 $paramName17 && continue

			#每月1号
			[ $day -eq 1 ] && [[ $paramName17 = mon_* ]] && [ $paramName17 != mon_of_year ] && [ $old_value != 0 ] && changeParams 0 $paramName17 && continue

			#每年1月1号
			[ "$mon_day" = "1.1" ] && [[ $paramName17 = year_* ]] && [ $old_value != 0 ] && changeParams 0 $paramName17 && continue


		fi


		# rate_mon_high_focus_days         high_focus_days
		[[ $paramName17 = rate_* ]] && suff=`echo $paramName17 | cut -d '_' -f 3-` && rate_arr+=($suff) && continue

	    # ave_mon_day_focus_time           focus_time
		[[ $paramName17 = ave_* ]] && suff=`echo $paramName17 | cut -d '_' -f 4-` && ave_arr+=($suff)

	done

	#去重
	rate_arr=($(awk -v RS=' ' '!a[$1]++' <<< ${rate_arr[@]}))
	ave_arr=($(awk -v RS=' ' '!a[$1]++' <<< ${ave_arr[@]}))

    rate_len=${#rate_arr[*]i}
    for ((m2 = 0; m2 < $rate_len; m2++)); do	

		paramName_rate=${rate_arr[$m2]}
		rate_all 2 $paramName_rate

	done

    ave_len=${#ave_arr[*]i}
    for ((m3 = 0; m3 < $ave_len; m3++)); do

        paramName_ave=${ave_arr[$m3]}
		
        scale=2
        [[ $paramName_ave = *task* ]] || [[ $paramName_ave = *income* ]] && scale=0
        [[ $paramName_ave = *good_sleep* ]] || [[ $paramName_ave = *focus* ]] && scale=1

        ave_all $scale $paramName_ave

    done

}


#计算收益   compute_income +100 today_sport   或者  compute_income -200 today_koufen
compute_income() {

	#要增加或减少的income   +300、-500
	income=$1

	#收益项目   today_sport
	param=$2

	#计算income
	addOrSub $income today_income total_income mon_income year_income

	#计算收益差额
	let gap=my_asset_target-total_income
	changeParams $gap asset_gap

	#计算完成比例
	rate 2 total_income my_asset_target rate_asset_completed

	#统计平均值
	ave_all 0 ave_mon_day_income

	#记录流水
	printSeparatorByDate2 1 $income_file
	echo -e "$(now)     $param     $income\n" >> $income_file 2>/dev/null

}


#重新加载参数
flush() {

	source $paramFile

}


#求绝对值
abs() { echo ${1#-}; }


#-------------------------------------------------------------------------------------
#如果是boolean值,则转成数字 YES--1  NO--0     num=`boolToNum today_sport`
#否则取原值
boolToNum() {
	#获取参数值
	value=$(getVal $1)

    [ $value ] && [ $value = 'YES' ] && value=1
    [ $value ] && [ $value = 'NO' ] && value=0

	echo $value

}


#获取参数串   str=`getParamStr $today today_sport today_income`
getParamStr() {
	paramStrs=$1
	for item in $(seq 2 $#); do

		#某个参数，eg：today_income
		paramName=$(eval $gv)

		val=$(boolToNum $paramName)
		paramStrs="$paramStrs,$val"
	done

	echo $paramStrs

}
#--------------------------------------------------------------------------------------------写入db文件
#将最新的参数值记录到daily文件
saveNewParamsToDailyFile() {
	flush

	params=$(sed -n "2p" $dailyData)	
	params=`echo $params | cut -d ',' -f 2- | sed 's/,/ /g'`

	paramStr=$(getParamStr $today $params)

	#第一次则插入一条新数据，否则只需替换为最新的数据
	if [ $write_params_to_daily_file_flag -eq 2 ]; then

		#更新
		row_count=$(wc -l <$dailyData)
		sed -i "${row_count}c $paramStr" $dailyData

	else
		#插入
		echo $paramStr >>$dailyData
		changeParams 2 write_params_to_daily_file_flag

	fi

}


#将最新的参数值记录到mon文件
saveNewParamsToMonFile() {
	flush

    params=$(sed -n "2p" $monsData)
    params=`echo $params | cut -d ',' -f 2- | sed 's/,/ /g'`

    paramStr=$(getParamStr $year.$mon_of_year $params)


	#第一次则插入一条新数据，否则只需替换为最新的数据
	if [ $write_params_to_mon_file_flag -eq 2 ]; then

		#更新
		row_count=$(wc -l <$monsData)
		sed -i "${row_count}c $paramStr" $monsData

	else
		#插入
		echo $paramStr >>$monsData
		changeParams 2 write_params_to_mon_file_flag

	fi

}


#将最新的参数值记录到year文件
saveNewParamsToYearFile() {
	flush

    params=$(sed -n "2p" $yearsData)
    params=`echo $params | cut -d ',' -f 2- | sed 's/,/ /g'`

    paramStr=$(getParamStr $year $params)


	#第一次则插入一条新数据，否则只需替换为最新的数据
	if [ $write_params_to_year_file_flag -eq 2 ]; then

		#更新
		row_count=$(wc -l <$yearsData)
		sed -i "${row_count}c $paramStr" $yearsData

	else
		#插入
		echo $paramStr >>$yearsData
		changeParams 2 write_params_to_year_file_flag

	fi

}


saveDataToDb()
{

	saveNewParamsToDailyFile
	saveNewParamsToMonFile
	saveNewParamsToYearFile

}
#--------------------------------------------------------------------------------------------写入db文件


#-------------------------------------------------------------------------------------------- color
#根据是否完成批量设置颜色   setColor1 33 1m 47 34m today_reading  today_sport
setColor1() {
	#遍历所有传入参数
	for item in $(seq 5 $#); do
		#颜色参数1
		c1=$1
		#颜色参数2
		c2=$2
		#颜色参数3
		c3=$3
		#颜色参数4
		c4=$4

		#某个参数，eg：today_reading
		param=$(eval $gv)

		value=$(getVal $param)

		[ ! "$value" ] && return 0

		if [ $value = YES ]; then
			eval $param=$(echo -e "\033[$c1\;$c2$value\033[0m")
		else
			eval $param=$(echo -e "\033[$c3\;$c4$value\033[0m")
		fi
	done
}


#根据参数值批量设置颜色  setColor2 today_sport today_english
setColor2() {

	#遍历所有传入参数
	for item in $(seq 1 $#); do

		#某个参数，eg：today_reading
		param=$(eval $gv)

		value=$(getVal $param)

		[ ! "$value" ] && return 0

		if [ $value = YES ]; then

			eval $param=$(echo -e "\033[1\;39m√\033[0m")

		elif [ $value = NO ]; then

			eval $param="' '"
		else
			#数字
			setColor3 1 36m $param
		fi

	done

}


#批量设置颜色  setColor3 1 36m mon_sport_days year_sport_days
setColor3() {
	#颜色参数1
	c1=$1
	#颜色参数2
	c2=$2
	#遍历所有传入参数
	for item in $(seq 3 $#); do
		#某个参数，eg：today_reading
		param=$(eval $gv)
		#参数值
		value=$(getVal $param)

		eval $param=$(echo -e "\033[$c1\;$c2$value\033[0m")
	done

}


#-------------------------------------------------------------------------------------------- color
#比较两个数的大小   [ `compare 2.13 '<=' 5` ] && echo 123     [ `compare 9.99 '==' 9.99` ] && echo 123
compare() {

	#第一个比较值  整数/小数/负数
	a=$1

	#比较符号  >、<、>=、<=
	b="$2"

	#第2个比较值  整数/小数/负数
	c=$3

	if [ $(echo "$a $b $c" | bc) -eq 1 ]; then
		echo 1
	else
		echo ''
	fi

}


#根据当前日期打印分隔符,行距为2个字符   printSeparatorByDate 1 ./aa.txt
printSeparatorByDate() {
	sep=""

	#模式 1--根据年和月   2--根据年   3--根据月
	mode=$1

	#要操作的文件
	file=$2

	#如果有一行以上有效内容   2 + 1 + 2 = 5
	if [ -e $file ] && [ $(wc -l <$file) -ge 5 ]; then
		#总行数
		row_count=$(wc -l <$file)
		#减去最后的两行空行
		let row_count=row_count-2

		#最后一行文字内容   2023-02-10     xxxxxxx
		row=$(sed -n "${row_count}p" $file)
		current_mon=$(echo $today2 | cut -d '-' -f 1,2)

		[ $mode -eq 1 ] || [ $mode -eq 3 ] && [[ $row != $current_mon* ]] && sep="----------------------------------------------------\n\n"
		[ $mode -eq 1 ] || [ $mode -eq 2 ] && [[ $row != $year* ]] && sep="==============================================================\n\n"

	fi

	 #创建存放今年日志的文件夹
     noteDir=./data/note/life/$year
     [ ! -d $noteDir ] && mkdir -p $noteDir


	[ $sep ] && echo -e $sep >>$file

	#如果该文件不存在，则创建并追加空行
	[ ! -e $file ] && echo -e "\n" >>$file

}


#根据当前日期打印分隔符,行距为1个字符   printSeparatorByDate2 1 ./aa.txt
printSeparatorByDate2() {
	sep=""

	#模式 1--根据日和月分割
	mode=$1

	#要操作的文件
	file=$2

	#如果有一行以上有效内容   1 + 1 + 1 = 3
	if [ -e $file ] && [ $(wc -l <$file) -ge 3 ]; then
		#总行数
		row_count=$(wc -l <$file)
		#减去最后的1个空行
		let row_count=row_count-1

		#最后一行文字内容   2023-03-02 20:30:32     xxxxx     xxxxx
		row="$(sed -n "${row_count}p" $file)"
		current_mon=$(echo $today2 | cut -d '-' -f 1,2)

		[ $mode -eq 1 ] && [[ $row != $today2* ]] && sep="----------------------------------------------------\n"
		[ $mode -eq 1 ] && [[ $row != $current_mon* ]] && sep="==============================================================\n"

	fi

	 #创建存放今年日志的文件夹
     noteDir=./data/note/life/$year
     [ ! -d $noteDir ] && mkdir -p $noteDir

	[ $sep ] && echo -e $sep >>$file

	#如果该文件不存在，则创建
	[ ! -e $file ] && echo '' >>$file

}


#显示控制台并执行计算
showConsole() {

	sh ./life-management.sh $1

}



#------------------------------------------------------ time
#返回当前时间   2023-02-23 18:00:31
now() {

	now=$(date "+%Y-%m-%d %H:%M:%S")
	echo $now

}


#获取当前时间戳(秒)    start=`tstamp_s` 
tstamp_s() {

	stamp=$(date '+%s')
	echo $stamp

}

#获取当前时间戳(毫秒)    start=`tstamp_ms`
tstamp_ms()
{

	echo $(date +%s.%N)

}


#计算时间间隔(毫秒)     diff_time $start $end
diff_time(){ 
    start=$1
    end=$2
  
    start_s=$(echo $start | cut -d '.' -f 1)
    start_ns=$(echo $start | cut -d '.' -f 2)
    end_s=$(echo $end | cut -d '.' -f 1)
    end_ns=$(echo $end | cut -d '.' -f 2)

    time=$(( ( 10#$end_s - 10#$start_s ) * 1000 + ( 10#$end_ns / 1000000 - 10#$start_ns / 1000000 ) ))

    echo "$time ms"
}


#计时开始
time_start()
{

	time_start=`tstamp_ms`

}


#计时结束
time_end()
{

	time_end=`tstamp_ms`
	diff_time=`diff_time $time_start $time_end`
	echo 耗时：$diff_time

}


#计算任务耗时   time_taken sh xx.sh
time_taken()
{

	time_start
	$*
	time_end

}


#返回一个时间串   2023-03-22_22.08.36
time_str()
{

	date "+%Y-%m-%d_%H.%M.%S"

} 
#------------------------------------------------------ time


#判断是否为数字  1--是   ''--否       isNum 1
isNum()
{

	if [ "$1" ];then

		str1523=`echo "$1" | sed  's/\.//g'`
		[[ "$str1523" = -* ]] && str1523=`echo "$str1523" | cut -c 2-`

	    if grep '^[[:digit:]]*$' <<< "$str1523" &> /dev/null;then
		
			echo 1
		else
	
			echo ''
		fi

	else
		echo ''
	fi


}


#通过参数名获取某个参数在db文件的列   col=`getParamCol paramName fileName`
getParamCol()
{
    if [ $1 ] && [ $2 ];then
        #参数序列  db文件第2行为参数名  
        paramSeq16=$(sed -n "2p" $2)

        #参数数组
        paramName_arr12=(${paramSeq16//,/ })
        len14=${#paramName_arr12[*]}

        for ((i = 0; i < $len14; i++)); do

            param9=${paramName_arr12[$i]}
            [ $1 = $param9 ] && let col=i+1 && echo $col && break

        done

    fi

}


#获取某个文件的总行数   getRowCount fileName
getRowCount()
{

	row_count118=`wc -l < "$1"`
	echo "$row_count118"

}


#获取某个字符串在指定文件中的行号或者行号+行内容      getRowNum fileName 'today_income' 1
#                                                     getRowNum fileName 'today_income' 1 1
getRowNum()
{
	#要查找的文件
	file195=$1
	#要匹配的字符串
	str171=$2
	#模式  1--严格   2--宽松   3--目标行必须以该字符串为开头,并且要完全匹配
	mode245=$3
	#返回内容  空---只要行号    1--返回行号和行内容
	result=$4

	if [ "$result" ];then

		[ $mode245 -eq 1 ] && row_num336=`grep -nw "$str171" "$file195"`		
		[ $mode245 -eq 2 ] && row_num336=`grep -n "$str171" "$file195"`	
		[ $mode245 -eq 3 ] && row_num336=`grep -nw "^$str171" "$file195"`	

	else

        [ $mode245 -eq 1 ] && row_num336=`grep -nw "$str171" "$file195" | cut -d ':' -f 1`  
        [ $mode245 -eq 2 ] && row_num336=`grep -n "$str171" "$file195" | cut -d ':' -f 1`
        [ $mode245 -eq 3 ] && row_num336=`grep -nw "^$str171" "$file195" | cut -d ':' -f 1`
		
	fi

	echo "$row_num336"

}


#获取指定文件的某一行内容     getRow fileName 20
getRow()
{

	row_content=$(sed -n "$2 p" $1)
	echo "$row_content"

}


#清除字符串左右两边的空格   trim2 " fajldfja "
trim2()
{

	trim_str=`echo "$1" | grep -o "[^ ]\+\( \+[^ ]\+\)*"`
	echo "$trim_str"

}


#清除字符串左右两边的空格   str=`echo " fajldfja " | trim`
trim()
{


    while read line
    do
        trim_str=`trim2 "$line"`
        echo "$trim_str"
    done

}


#备份参数文件
backup_param_file()
{
    suffix=`time_str`
    bak_file=${paramFile}_bak_$suffix

	baseDir=./data/bak/
    [ ! -d $baseDir ] && mkdir -p $baseDir
    cp $paramFile $bak_file && mv $bak_file $baseDir


}


#检查系统是否已初始化
check_syste_is_init()
{

	[ $is_init_system -eq 1 ] && echo  -e "\n\n请先运行目录中的 operate-system.sh 进行系统初始化！\n\n" && exit 1

}


#清除某个字符串中的某些子串   clearStrs "11 22 33 44 55" 22 33 44 ---> 11 55
clearStrs()
{
    originStr="$1"
    for item in $(seq 2 $#); do
        clearStr=$(eval $gv)
        originStr=`echo "$originStr" | sed "s/$clearStr//g"`

    done

    echo $originStr
}


#获取db中符合指定条件的记录的数量    ge、gt、le、lt、eq、ne
#不带时间条件： db_count today_income ge 500
#带时间条件：   db_count today_income ge 500 2023         db_count today_income ge 500 2023.2
db_count()
{

        col=`getParamCol $1 $dailyData`
        symbol=$2
        compareNum=$3
        condition=$4
	    des_param="`getVal des_$1 | sed 's/今日//g'`"
        str=''
        [ $condition ] && str="$condition    "
    count1=0
    count2=0
    
    output=''
        [ $symbol = ge ] && symbol='>=' && output="echo \"$str$des_param    大于等于 $compareNum 的天数：\$count1    小于 $compareNum 的天数：\$count2\""
        [ $symbol = gt ] && symbol='>' && output="echo \"$str$des_param    大于 $compareNum 的天数：\$count1    小于等于 $compareNum 的天数：\$count2\""
        [ $symbol = le ] && symbol='<=' && output="echo \"$str$des_param    小于等于 $compareNum 的天数：\$count1    大于 $compareNum 的天数：\$count2\""
        [ $symbol = lt ] && symbol='<' && output="echo \"$str$des_param    小于 $compareNum 的天数：\$count1    大于等于 $compareNum 的天数：\$count2\""
        [ $symbol = eq ] && symbol='==' && output="echo \"$str$des_param    等于 $compareNum 的天数：\$count1    不等于 $compareNum 的天数：\$count2\""
        [ $symbol = ne ] && symbol='!=' && output="echo \"$str$des_param    不等于 $compareNum 的天数：\$count1    等于 $compareNum 的天数：\$count2\""

        all=''
        if [ $col ];then
                if [ $condition ];then
                        begin=`grep -n "^$condition" $dailyData | head -1 | cut -d ':' -f 1`
                        end=`grep -n "^$condition" $dailyData | tail -1 | cut -d ':' -f 1`
                        [ $begin ] && cmd="awk -F ',' '(NR>=$begin && NR<=$end){print \$$col}' \$dailyData" && all=`eval $cmd`

                else
                        cmd="awk -F ',' '(NR>2){print \$$col}' \$dailyData"
                        all=`eval $cmd`
                fi

                if [ "$all" ];then

                    arr=(${all// / })
                    len=${#arr[*]i}

                for ((i = 0; i < $len; i++)); do

                        num=${arr[$i]}
                                if [ `compare $num "$symbol" $compareNum` ];then
                                        let count1=count1+1
                                else
                                        let count2=count2+1
                                fi

                        done

                eval "$output"

                else

                        echo '没有符合条件的记录！'
                fi

        else

                echo 参数 $1 不存在！

        fi


}


#输出所有的参数块名称
printBlock()
{

	aa=`cat params.sh | grep '^\\#' | grep '\\-1' | cut -c 2- | sed 's/=//g' | cut -d ' ' -f 1 | sed 's/-1//g'` && \
	echo -e '' && echo $aa |  awk '{for (i=1;i<=NF;i++)printf("%s    ", $i);print ""}'

}


#获取某个参数所在的块位置
# getPositionOfBlock paramName 1
getPositionOfBlock()
{

        param111=$1
        # 1--获取指定参数所在参数块的前分隔行行号    2--获取指定参数所在参数块的后分隔行行号   
        mode=$2   
        row_param222=`getRowNum $paramFile "$param111" 3`

        block_start=''
        block_end=''
        if [ $row_param222 ];then
                if [ $mode = 1 ];then
                        let row_param222=row_param222-1
                        for (( row=$row_param222; row>0; row-- )) do
                                row_str333=$(sed -n "${row}p" $paramFile)
                                [ "$row_str333" ] && [[ "$row_str333" = *=====* ]] && block_start=$row && break
                        done

                fi

                if [ $mode = 2 ];then
                        let row_param222=row_param222+1
                        for (( row=$row_param222; row<100000; row++ )) do
                                row_str333=$(sed -n "${row}p" $paramFile)
                                [ "$row_str333" ] && [[ "$row_str333" = *=====* ]] && block_end=$row && break
                        done

                fi

        fi

        [ $mode = 1 ] && echo $block_start
        [ $mode = 2 ] && echo $block_end


}



