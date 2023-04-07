#!/bin/bash
#同步param文件、db、statement和page

command_path=`pwd`
result=`echo "$command_path" | grep -w tool$`
[ ! $result ] && echo '请进入脚本目录下执行！' && exit 1

cd ..
source ./funcs.sh

time_start

row_count=$(wc -l < $paramFile)

daily_params=''
mons_params=''
mons_params2=''
years_params=''
years_params2=''
total_params=''
flag=1

system_row=`getRowNum $paramFile "\#system-2" 3`
let system_row=system_row+1

for row in $(seq $system_row $row_count); do
	row_str=$(sed -n "${row}p" $paramFile)
	row_str=`echo "$row_str" | grep -o "[^ ]\+\( \+[^ ]\+\)*"`

	if [[ "$row_str" = *=====* ]] && [ $flag -eq 1 ];then

		flag=2
		mons_params="$mons_params,0"
		years_params="$years_params,0"
		total_params="$total_params,0"
		continue

	fi

	[[ "$row_str" = *=====* ]] && flag=1 && continue

	[ ! "$row_str" ] || [[ "$row_str" = \#* ]] || [[ "$row_str" = des_* ]] && continue

    if [[ "$row_str" = today_* ]];then

        param=`echo $row_str | cut -d '=' -f 1`
        daily_params="$daily_params,$param"
		continue

    fi


	if [[ "$row_str" = mon_* ]] || [[ "$row_str" = rate_mon_* ]] || [[ "$row_str" = ave_mon_* ]];then

		param=`echo $row_str | cut -d '=' -f 1`
		mons_params="$mons_params,$param"
		mons_params2="$mons_params2,$param"
		continue

	fi

    if [[ "$row_str" = year_* ]] || [[ "$row_str" = rate_year_* ]] || [[ "$row_str" = ave_year_* ]];then

        param=`echo $row_str | cut -d '=' -f 1`
        years_params="$years_params,$param"
        years_params2="$years_params2,$param"
		continue

    fi

  if ([[ "$row_str" = total_* ]] || [[ "$row_str" = rate_total_* ]] || [[ "$row_str" = ave_total_* ]]) && [[ "$row_str" != *_to_year* ]] && [[ "$row_str" != *_A1 ]];then

        param=`echo $row_str | cut -d '=' -f 1`
        total_params="$total_params,$param"

    fi


done

daily_params="today$daily_params"
mons_params=`echo "$mons_params" | cut -d ',' -f 2- | sed 's/0,0/0/g'`
mons_params2="mon$mons_params2"
years_params=`echo "$years_params" | cut -d ',' -f 2- | sed 's/0,0/0/g'`
years_params2="year$years_params2"
total_params=`echo "$total_params" | cut -d ',' -f 2- | sed 's/0,0/0/g'`


writeToStatement()
{
    #要写入的参数
    params=$1
	#要写入的报表
	statement_file=$2
	
	arr=(${params//,/ })
	len=${#arr[*]i}

	content=''
	for ((i = 0; i < $len; i++)); do

		param=${arr[$i]}
		[ $i = 0 ] && content="\\\n" && continue
		[ $param = 0 ] && content="$content\n\n" && continue

		des_param=des_$param
		des_value="`getVal $des_param`"
		des_value=`echo "$des_value" | sed 's/本月//g' | sed 's/今年//g' | sed 's/总计//g'`

		content="$content\n$des_value：\$$param"

	done

	content="$content\n\n"


	row_start=$(cat -n $statement_file | grep '<<EOF' | awk '{print $1}')
	row_end=$(cat -n $statement_file | grep 'EOF' | grep -v 'cat' | awk '{print $1}')
	
	let num=row_end-row_start
	if [ $num -gt 1 ];then

		let row_start=row_start+1
		let row_end=row_end-1

		sed -i "$row_start,$row_end c $content" $statement_file 
		
	else
		
		sed -i "$row_end i $content" $statement_file 

	fi


}


writeToPage()
{
    #要写入的参数
    params=$1
	#要写入的页面
	page_file=$2
	
	arr=(${params//,/ })
	len=${#arr[*]i}

	content=''
	for ((i = 0; i < $len; i++)); do

		param=${arr[$i]}
		[ $i = 0 ] && content="\\\n\n<br><br>" && continue
		[ $param = 0 ] && content="$content\n<br><br>\n\n" && continue

		des_param=des_$param
		des_value="`getVal $des_param`"
		des_value=`echo "$des_value" | sed 's/本月//g' | sed 's/今年//g' | sed 's/总计//g'`

		content="$content\n\<p>$des_value：\$$param</p>"

	done

	content="$content\n<br><br>\n\n"

    row_start=`getRowNum $page_file 'flag_start' 1`
    row_end=`getRowNum $page_file 'flag_end' 1`

    let num=row_end-row_start
    if [ $num -gt 1 ];then

        let row_start=row_start+1
        let row_end=row_end-1

        sed -i "$row_start,$row_end c $content" $page_file

    else

        sed -i "$row_end i $content" $page_file

    fi

}



writeToPage $mons_params ./makeMonSumPage.sh
writeToPage $years_params ./makeYearSumPage.sh
writeToPage $total_params ./makeSumPage.sh


writeToStatement $mons_params ./generateMonStatement.sh
writeToStatement $years_params ./generateYearStatement.sh


echo --------------------------------------
all_params=$daily_params,$mons_params2,$years_params2
all_params_arr=(${all_params//,/ })
len_all_params=${#all_params_arr[*]i}


db_params1=`sed -n "2p" $dailyData`
db_params2=`sed -n "2p" $monsData`
db_params3=`sed -n "2p" $yearsData`
all_params_db="$db_params1,$db_params2,$db_params3"

all_params_db_arr=(${all_params_db//,/ })
len_all_params_db=${#all_params_db_arr[*]i}

#要新增到db的参数
new_params=''
for ((i = 0; i < $len_all_params; i++)); do
	param1=${all_params_arr[$i]}
	result=`echo $all_params_db | grep -w $param1`
	[ ! "$result" ] && new_params="$new_params  $param1"

done

bak_flag=1

new_params=`echo "$new_params" | trim`
if [ "$new_params" ];then

	new_params_arr=(${new_params//  / })
	new_params_len=${#new_params_arr[*]}

	sh ./tool/update_version.sh "向db新增$new_params_len个参数：$new_params" 

	echo -e "向db新增$new_params_len个参数：$new_params\n"

	bak_flag=2

else
	
	echo -e "没有向db新增参数\n"

fi


#要从db删除的参数
del_params=''
del_page_params=''
for ((i = 0; i < $len_all_params_db; i++)); do
	param1=${all_params_db_arr[$i]}
	result=`echo $all_params | grep -w $param1`
	if [ ! "$result" ];then
    
		del_params="$del_params  $param1"

		check=`cat ./config/config.sh | grep -w $param1`
		[ "$check" ] && del_page_params="$del_page_params  $param1"

	fi

done


del_params=`echo "$del_params" | trim`
del_page_params=`echo "$del_page_params" | trim`
if [ "$del_params" ];then

    del_params_arr=(${del_params//  / })
    del_params_len=${#del_params_arr[*]}

	sh ./tool/update_version.sh "从db删除$del_params_len个参数：$del_params"
   	echo -e "从db删除$del_params_len个参数：$del_params"

	[ "$del_page_params" ] && echo -e "\033[1;39m\n页面参数 $del_page_params 已经从db删除，无法再将其加载到页面，请修改配置文件 config.sh ！\033[0m" 
	#关闭页面开关
	[ "$del_page_params" ] && changeFile $configFile mons_and_years_page_flag 2

	bak_flag=2
else

    echo -e "没有从db删除参数"

fi


echo --------------------------------------

#按照param文件的参数顺序重新排列db文件的列顺序，如果param文件有但db文件没有，就添加，param文件没有但db文件有就删除
write_to_db()
{

	#参数列表
	params=$1
	#db文件
	db_file=$2

	arr1=(${params//,/ })
	len=${#arr1[*]i}

#	echo -e "len=$len\n"

	str1=''
	str2=''
	title_zh=''
	title_en=''
	for ((j = 0; j < $len; j++)); do

		param1=${arr1[$j]}
		
		title_en="$title_en,$param1"
		
		des_param=des_$param1
		des_value="`getVal $des_param`"
		let num=j+1
		des_value="$num-$des_value"
		title_zh="$title_zh,$des_value"
		
		
		col=`getParamCol $param1 $db_file`
		
		if [ "$col" ];then
		
			[ "$str1" ] && str1="$str1,%s"
			[ ! "$str1" ] && str1="%s"
			
			[ "$str2" ] && str2="$str2,\$$col"
			[ ! "$str2" ] && str2="\$$col"	

		else
		
			[ "$str1" ] && str1="$str1,%s"
			[ ! "$str1" ] && str1="%s"
			
			[ "$str2" ] && str2="$str2,0"
			[ ! "$str2" ] && str2="0"			
			
		fi


	done

	if [ $bak_flag -eq 2 ];then
		#备份
		suffix=`time_str`
		cp $db_file ${db_file}_bak_$suffix
		mv ${db_file}_bak_$suffix ./data/db/bak/

	fi
	
	work=`echo "awk -F '","' '{printf(\"$str1\\n\",$str2)}'  $db_file > ${db_file}_temp"`
	eval "$work"

	/usr/bin/rm -rf $db_file

	mv ${db_file}_temp $db_file
	
	
	title_zh=`echo "$title_zh" | cut -c 2-`
	title_zh=`echo "$title_zh" | sed 's/今日//g'`
	title_en=`echo "$title_en" | cut -c 2-`
	
	sed -i "1c $title_zh" $db_file
	sed -i "2c $title_en" $db_file
	

}

des_today='日期'
des_mon='月份'
des_year='年份'

#echo -e "daily_params:\n$daily_params"
write_to_db $daily_params $dailyData

#echo -e "mons_params:\n$mons_params2"
write_to_db $mons_params2 $monsData

#echo -e "years_params:\n$years_params2"
write_to_db $years_params2 $yearsData


#加载页面
sh ./saveDataAndLoadPage.sh 1
sh ./saveDataAndLoadPage.sh 2


echo '同步完成！'

time_end


