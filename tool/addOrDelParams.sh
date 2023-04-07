#!/bin/bash
#增加或删除参数

#====================================================脚本使用示例
#按块加参数

#days  添加到最后
#基本参数
# sh addOrDelParams.sh 1 1 1 0 1 dance 跳舞
#基本参数+rate
# sh addOrDelParams.sh 1 1 1 0 1 dance 跳舞 1
#基本参数+ave
# sh addOrDelParams.sh 1 1 1 0 1 dance 跳舞 2
#基本参数+rate+ave
# sh addOrDelParams.sh 1 1 1 0 1 dance 跳舞 1 2


#times   添加到最后
#基本参数
# sh addOrDelParams.sh 1 1 2 0 1 look_girl 看美女
#基本参数+ave
# sh addOrDelParams.sh 1 1 2 0 1 look_girl 看美女 2
#基本参数+high
# sh addOrDelParams.sh 1 1 2 0 1 look_girl 看美女 3
#基本参数+ave+high
# sh addOrDelParams.sh 1 1 2 0 1 look_girl 看美女 2 3


#无后缀   添加到最后
#基本参数
# sh addOrDelParams.sh 1 1 3 0 1 play_cat_time 撸猫时间 
#基本参数+ave
# sh addOrDelParams.sh 1 1 3 0 1 play_cat_time 撸猫时间 2
#基本参数+high
# sh addOrDelParams.sh 1 1 3 0 1 play_cat_time 撸猫时间 3
#基本参数+ave+high
# sh addOrDelParams.sh 1 1 3 0 1 play_cat_time 撸猫时间 2 3


# 添加到sport前面
# sh addOrDelParams.sh 1 1 1 sport 2 dance 跳舞

# 添加到sport后面
# sh addOrDelParams.sh 1 1 1 sport 3 dance 跳舞

#--------------------------------------------------------

#按参数名加参数

# 添加到 des_today_safe_space 之前
# sh addOrDelParams.sh 1 2 des_today_safe_space 1 today_test 测试 today_get=2399 赚钱 today_play 玩耍

# 添加到 today_safe_space 之后
# sh addOrDelParams.sh 1 2 today_safe_space 2 today_test 测试 today_get=2399 赚钱 today_play 玩耍

#--------------------------------------------------------
#删除参数

#按块标识删除参数   sh addOrDelParams.sh  2  1  english reading wushui

#按参数名删除参数   sh addOrDelParams.sh  2  2  today_englist today_reading today_wushui

#====================================================脚本使用示例

command_path=`pwd`
result=`echo "$command_path" | grep -w tool$`
[ ! $result ] && echo '请进入脚本目录下执行！' && exit 1


cd ..
source ./funcs.sh

[ $# -lt 3 ] && echo '参数不足！' && exit 1


#避免误操作
#exit_script3


sync_flag=1


#======================================================== #按块加参数
#option=1   加参数
option=$1

#add_mode=1   按块加，一次只能加一个块
add_mode=$2

#参数类型  1--days，以天来计算     2--times ，以次来计算     3--无后缀，以具体数值来计算，例如时间等
add_param_type=$3

#用于定位的模块，添加到该块之前或之后
#如果添加到最后，传0即可
locate_block_name=$4

#1--把块添加到param文件最后    2--把块添加到某个块之前       3--把块添加到某个块之后
add_locate_mode=$5


#英文参数名(块名称)   eg：soprt
param_en=$6

#中文参数名   eg：运动
param_zh=$7


#装配模板 1--百分比   2--平均值   3--high    可以同时写多个，不写的话就只有日月年total四个数据维度
add_template=`echo $* | cut -d ' ' -f 8-`


#拼装参数
getParamStrs()
{


    p_strs=''
    for item in $(seq 1 $#); do


        paramStr=$(eval $gv)

                p_value=$(getVal $paramStr)

                #去重
                paramName=`echo "$p_value" | cut -d '=' -f 1`

                p_row=`getRowNum $paramFile "$paramName" 3` 

                #参数已存在则跳过
                [ "$p_row" ] && continue

                if [ "$p_strs" ];then
                        if [[ "$p_value" = des_* ]];then

                                if [[ "$p_value" = des_rate_mon_high_* ]] || [[ "$p_value" = *days_count_flag* ]];then

                                        p_strs="$p_strs\n\n\n$p_value"

                                else

                                        p_strs="$p_strs\n\n$p_value"
                                fi

                        else

                                p_strs="$p_strs\n$p_value"

                        fi

                else

                        p_strs="$p_value"

                fi


        done

        echo "$p_strs"

}



#按块加参数
if [ "$option" -eq 1 ] && [ $add_mode -eq 1 ];then


        [ $# -lt 7 ] && echo '至少要传入7个以上参数！' && exit 1

        row_check=`getRowNum $paramFile "\#$param_en-" 2`
        [ "$row_check" ] && echo "参数块 $param_en 已存在！" && exit 1

        if [ $add_locate_mode -ne 1 ];then
                row_locate1=`getRowNum $paramFile "\#$locate_block_name-1" 3`
                row_locate2=`getRowNum $paramFile "\#$locate_block_name-2" 3`

                [ ! "$row_locate1" ] && [ ! "$row_locate2" ] && echo "用于定位的参数块：$locate_block_name 不存在！" && exit 1

                [ ! "$row_locate1" ] || [ ! "$row_locate2" ] && echo "用于定位的参数块：$locate_block_name 不完整！" && exit 1

        fi


        #基本参数
        daily_param=""
        des_daily_param=""
        mon_param=""
        des_mon_param=""
        year_param=""
        des_year_param=""
        total_param=""
        des_total_param=""


        #百分比
        rate_mon_param=""
        des_rate_mon_param=""
        rate_year_param=""
        des_rate_year_param=""
        rate_total_param=""
        des_rate_total_param=""

        #平均值
        ave_mon_day_param=""
        des_ave_mon_day_param=""
        ave_year_day_param=""
        des_ave_year_day_param=""
        ave_year_mon_param=""
        des_ave_year_mon_param=""
        ave_total_day_param=""
        des_ave_total_day_param=""
        ave_total_mon_param=""
        des_ave_total_mon_param=""
        ave_total_year_param=""
        des_ave_total_year_param=""


        #high
        mon_high_param=""
        des_mon_high_param=""
        year_high_param=""
        des_year_high_param=""
        total_high_param=""
        des_total_high_param=""

        rate_mon_high_param=""
        des_rate_mon_high_param=""
        rate_year_high_param=""
        des_rate_year_high_param=""
        rate_total_high_param=""
        des_rate_total_high_param=""

        high_flag_param=""
        des_high_flag_param=""

        # days+rate
        inter_flag1=1

    # days+ave  3个ave变量
        inter_flag2=1

        # times + ave 或者 无后缀 + ave   6个ave变量
        inter_flag3=1

        # tiems + high 或者 无后缀 + high
        inter_flag4=1


        #后缀为 _days
        if [ $add_param_type -eq 1 ];then
                daily_param="today_$param_en=NO"
                des_daily_param="des_today_$param_en='今日是否$param_zh'"

                mon_param="mon_${param_en}_days=0"
                des_mon_param="des_mon_${param_en}_days='本月$param_zh天数'"

                year_param="year_${param_en}_days=0"
                des_year_param="des_year_${param_en}_days='今年$param_zh天数'"

                total_param="total_${param_en}_days=0"
                des_total_param="des_total_${param_en}_days='总计$param_zh天数'"

                # rate
                check=`echo "$add_template" | grep -w 1`
                if [ "$check" ];then

                        rate_mon_param="rate_mon_${param_en}_days=0"
                        des_rate_mon_param="des_rate_mon_${param_en}_days='本月$param_zh比例'"

                        rate_year_param="rate_year_${param_en}_days=0"
                        des_rate_year_param="des_rate_year_${param_en}_days='今年$param_zh比例'"

                        rate_total_param="rate_total_${param_en}_days=0"
                        des_rate_total_param="des_rate_total_${param_en}_days='总计$param_zh比例'"

                # days+rate
                        inter_flag1=2

                fi

                # ave
                check=`echo "$add_template" | grep -w 2`
                if [ "$check" ];then

                        ave_year_mon_param="ave_year_mon_${param_en}_days=0"
                        des_ave_year_mon_param="des_ave_year_mon_${param_en}_days='今年平均每月$param_zh天数'"

                        ave_total_mon_param="ave_total_mon_${param_en}_days=0"
                        des_ave_total_mon_param="des_ave_total_mon_${param_en}_days='总计平均每月$param_zh天数'"

                        ave_total_year_param="ave_total_year_${param_en}_days=0"
                        des_ave_total_year_param="des_ave_total_year_${param_en}_days='总计平均每年$param_zh天数'"

                        # days+ave  3个ave变量
                        inter_flag2=2

                fi


        fi

        #后缀为 _times
        if [ $add_param_type -eq 2 ];then
                daily_param="today_${param_en}_times=0"
                des_daily_param="des_today_${param_en}_times='今日$param_zh次数'"

                mon_param="mon_${param_en}_times=0"
                des_mon_param="des_mon_${param_en}_times='本月$param_zh次数'"

                year_param="year_${param_en}_times=0"
                des_year_param="des_year_${param_en}_times='今年$param_zh次数'"

                total_param="total_${param_en}_times=0"
                des_total_param="des_total_${param_en}_times='总计$param_zh次数'"

                # ave
                check=`echo "$add_template" | grep -w 2`
                if [ "$check" ];then

                        ave_mon_day_param="ave_mon_day_${param_en}_times=0"
                        des_ave_mon_day_param="des_ave_mon_day_${param_en}_times='本月平均每日$param_zh次数'"

                        ave_year_day_param="ave_year_day_${param_en}_times=0"
                        des_ave_year_day_param="des_ave_year_day_${param_en}_times='今年平均每日$param_zh次数'"

                        ave_year_mon_param="ave_year_mon_${param_en}_times=0"
                        des_ave_year_mon_param="des_ave_year_mon_${param_en}_times='今年平均每月$param_zh次数'"

                        ave_total_day_param="ave_total_day_${param_en}_times=0"
                        des_ave_total_day_param="des_ave_total_day_${param_en}_times='总计平均每日$param_zh次数'"

                        ave_total_mon_param="ave_total_mon_${param_en}_times=0"
                        des_ave_total_mon_param="des_ave_total_mon_${param_en}_times='总计平均每月$param_zh次数'"

                        ave_total_year_param="ave_total_year_${param_en}_times=0"
                        des_ave_total_year_param="des_ave_total_year_${param_en}_times='总计平均每年$param_zh次数'"

                        #times + ave 或者 无后缀+ave    6个ave变量
                        inter_flag3=2

                fi


                # high
                check=`echo "$add_template" | grep -w 3`
                if [ "$check" ];then
                        mon_high_param="mon_high_${param_en}_days=0"
                        des_mon_high_param="des_mon_high_${param_en}_days='本月大量$param_zh天数'"

                        year_high_param="year_high_${param_en}_days=0"
                        des_year_high_param="des_year_high_${param_en}_days='今年大量$param_zh天数'"

                        total_high_param="total_high_${param_en}_days=0"
                        des_total_high_param="des_total_high_${param_en}_days='总计大量$param_zh天数'"

                        rate_mon_high_param="rate_mon_high_${param_en}_days=0"
                        des_rate_mon_high_param="des_rate_mon_high_${param_en}_days='本月大量$param_zh比例'"

                        rate_year_high_param="rate_year_high_${param_en}_days=0"
                        des_rate_year_high_param="des_rate_year_high_${param_en}_days='今年大量$param_zh比例'"

                        rate_total_high_param="rate_total_high_${param_en}_days=0"
                        des_rate_total_high_param="des_rate_total_high_${param_en}_days='总计大量$param_zh比例'"

                        high_flag_param="high_${param_en}_days_count_flag=1"
                        des_high_flag_param="des_high_${param_en}_days_count_flag='大量$param_zh统计标记  1--未统计 2--已统计'"

                        # tiems + high 或者 无后缀 + high
                        inter_flag4=2

                fi

        fi

        #无后缀
        if [ $add_param_type -eq 3 ];then
                daily_param="today_${param_en}=0"
                des_daily_param="des_today_${param_en}='今日$param_zh'"

                mon_param="mon_${param_en}=0"
                des_mon_param="des_mon_${param_en}='本月$param_zh'"

                year_param="year_${param_en}=0"
                des_year_param="des_year_${param_en}='今年$param_zh'"

                total_param="total_${param_en}=0"
                des_total_param="des_total_${param_en}='总计$param_zh'"

                # ave
                check=`echo "$add_template" | grep -w 2`
                if [ "$check" ];then

                        ave_mon_day_param="ave_mon_day_${param_en}=0"
                        des_ave_mon_day_param="des_ave_mon_day_${param_en}='本月平均每日$param_zh'"

                        ave_year_day_param="ave_year_day_${param_en}=0"
                        des_ave_year_day_param="des_ave_year_day_${param_en}='今年平均每日$param_zh'"

                        ave_year_mon_param="ave_year_mon_${param_en}=0"
                        des_ave_year_mon_param="des_ave_year_mon_${param_en}='今年平均每月$param_zh'"

                        ave_total_day_param="ave_total_day_${param_en}=0"
                        des_ave_total_day_param="des_ave_total_day_${param_en}='总计平均每日$param_zh'"

                        ave_total_mon_param="ave_total_mon_${param_en}=0"
                        des_ave_total_mon_param="des_ave_total_mon_${param_en}='总计平均每月$param_zh'"

                        ave_total_year_param="ave_total_year_${param_en}=0"
                        des_ave_total_year_param="des_ave_total_year_${param_en}='总计平均每年$param_zh'"

                        #times + ave 或者 无后缀+ave    6个ave变量
                        inter_flag3=2

                fi


                # high
                check=`echo "$add_template" | grep -w 3`
                if [ "$check" ];then
                        mon_high_param="mon_high_${param_en}_days=0"
                        des_mon_high_param="des_mon_high_${param_en}_days='本月大量$param_zh天数'"

                        year_high_param="year_high_${param_en}_days=0"
                        des_year_high_param="des_year_high_${param_en}_days='今年大量$param_zh天数'"

                        total_high_param="total_high_${param_en}_days=0"
                        des_total_high_param="des_total_high_${param_en}_days='总计大量$param_zh天数'"

                        rate_mon_high_param="rate_mon_high_${param_en}_days=0"
                        des_rate_mon_high_param="des_rate_mon_high_${param_en}_days='本月大量$param_zh比例'"

                        rate_year_high_param="rate_year_high_${param_en}_days=0"
                        des_rate_year_high_param="des_rate_year_high_${param_en}_days='今年大量$param_zh比例'"

                        rate_total_high_param="rate_total_high_${param_en}_days=0"
                        des_rate_total_high_param="des_rate_total_high_${param_en}_days='总计大量$param_zh比例'"

                        high_flag_param="high_${param_en}_days_count_flag=1"
                        des_high_flag_param="des_high_${param_en}_days_count_flag='大量$param_zh统计标记  1--未统计 2--已统计'"

                        # tiems + high 或者 无后缀 + high
                        inter_flag4=2

                fi

        fi


        param_strs=`getParamStrs des_daily_param daily_param des_mon_param mon_param des_year_param year_param \
                    des_total_param total_param`

        # days+rate
        if [ $inter_flag1 -eq 2 ];then

                new_strs=`getParamStrs des_rate_mon_param rate_mon_param des_rate_year_param rate_year_param \
                          des_rate_total_param rate_total_param`
                                  
                [ "$new_strs" ] && param_strs="$param_strs\n\n\n$new_strs"           


        fi

        # days+ave      3个ave变量
        if [ $inter_flag2 -eq 2 ];then

                new_strs=`getParamStrs des_ave_year_mon_param ave_year_mon_param \
                                  des_ave_total_mon_param ave_total_mon_param des_ave_total_year_param ave_total_year_param`
                                  
                [ "$new_strs" ] && param_strs="$param_strs\n\n\n$new_strs"           

        fi

    # times + ave 或者 无后缀 + ave   6个ave变量
    if [ $inter_flag3 -eq 2 ];then

        new_strs=`getParamStrs des_ave_mon_day_param ave_mon_day_param des_ave_year_day_param ave_year_day_param \
                  des_ave_year_mon_param ave_year_mon_param des_ave_total_day_param ave_total_day_param \
                  des_ave_total_mon_param ave_total_mon_param des_ave_total_year_param ave_total_year_param`

        [ "$new_strs" ] && param_strs="$param_strs\n\n\n$new_strs"

    fi

        # tiems + high 或者 无后缀 + high
        if [ $inter_flag4 -eq 2 ];then

                new_strs=`getParamStrs des_mon_high_param mon_high_param des_year_high_param year_high_param \
                          des_total_high_param total_high_param des_rate_mon_high_param rate_mon_high_param \
                                  des_rate_year_high_param rate_year_high_param des_rate_total_high_param rate_total_high_param \
                                  des_high_flag_param high_flag_param`
                                  
                [ "$new_strs" ] && param_strs="$param_strs\n\n\n$new_strs"           

        fi


		[ ! "$param_strs" ]	&& echo 参数添加失败，因为要添加的参数已存在！ && exit 1
		

        backup_param_file
        sync_flag=2



        start_sep="\#$param_en-1============================================== $param_zh"
        end_sep="\#$param_en-2============================================== $param_zh"

        block="$start_sep\n$param_strs\n$end_sep"


        #把块添加到文件最后
        if [ $add_locate_mode -eq 1 ];then
                #最后一行
                row_count=`getRowCount $paramFile`
                row1=`getRow $paramFile $row_count | trim`

                #倒数第2行
                let last2=row_count-1
                row2=`getRow $paramFile $last2 | trim`

                [ "$row1" ] && block="\\\n\n$block"
                [ ! "$row1" ] && [ "$row2" ] && block="\\\n$block"


                sed -i "$row_count a $block\n\n" $paramFile

				echo 已把参数块 $param_en 添加到参数文件！

        fi

        #把块添加到指定块之前
        if [ $add_locate_mode -eq 2 ];then
                row_locate=`getRowNum $paramFile "\#$locate_block_name-1" 3`

                sed -i "$row_locate i $block\n\n" $paramFile

				echo 已把参数块 $param_en 添加到参数文件！

        fi

        #把块添加到指定块之后
        if [ $add_locate_mode -eq 3 ];then
                row_locate=`getRowNum $paramFile "\#$locate_block_name-2" 3`

                sed -i "$row_locate a \\\n\n$block" $paramFile

				echo 已把参数块 $param_en 添加到参数文件！

        fi


fi
#======================================================== #按块加参数


#======================================================== #按参数名加参数

# 添加到 des_today_safe_space 之前
# sh addOrDelParams.sh 1 2 des_today_safe_space 1 today_test 测试 today_get=2399 赚钱 today_play 玩耍

# 添加到 today_safe_space 之后
# sh addOrDelParams.sh 1 2 today_safe_space 2 today_test 测试 today_get=2399 赚钱 today_play 玩耍


#=1  加参数
option=$1

#add_mode=2   按传入参数名加，可以批量
add_mode=$2

#用于定位的参数，新参数添加到该参数之前或之后
locate_param=$3

#1--添加到定位参数之前     2--添加到定位参数之后
before_or_after=$4

#要添加的参数名列表                   today_sport=YES 运动  mon_movie_time=0 当月看定影次数
#如果不提供参数值将会赋予默认值0     today_sport 运动  mon_movie_time 当月看定影次数
add_param_list=`echo $* | cut -d ' ' -f 5-`

#按参数名加参数
if [ "$option" -eq 1 ] && [ $add_mode -eq 2 ];then

    let ys=$#%2
    [ $# -lt 6 ] || [ $ys -ne 0 ] && echo '请传入6个以上参数，并且要为偶数个！' && exit 1
	
	row_locate=`getRowNum $paramFile "$locate_param" 3`
	[ ! `isNum $row_locate` ] && echo "用于定位的参数 $locate_param 不存在！" && exit 1
	
	
	[ $before_or_after -eq 1 ] && [[ $locate_param != des_* ]] && echo "$locate_param不是描述参数，不能添加到非描述参数之前！" && exit 1
	[ $before_or_after -eq 2 ] && [[ $locate_param = des_* ]] && echo "$locate_param是描述参数，不能添加到描述参数之后！" && exit 1

	
	add_param_arr=(${add_param_list// / })
	len=${#add_param_arr[*]}
	
	let num=len/2
	
	param_str=''
	add_p_list=''
	for ((i = 0; i < $num; i++)); do
		
		let param_index=i*2
		let des_value_index=i*2+1
		
		#要添加的参数
		add_param=${add_param_arr[$param_index]}
		
		[[ "$add_param" = des_* ]] && echo "$add_param 是描述参数，不需要手动添加！" && continue
		
		#参数描述
		des_value=${add_param_arr[$des_value_index]}
		
		
		#没有提供默认值，则赋予0
		if [[ ! "$add_param" = *=* ]];then

			row_check=`getRowNum $paramFile "$add_param" 3`
			[ "$row_check" ] && echo "参数 $add_param 已存在！" && continue

			#备份
            if [ $sync_flag -eq 1 ];then
                backup_param_file
                sync_flag=2

            fi
			
			add_p_list="$add_p_list  $add_param"

			add_des_param=des_$add_param
			add_des_param="$add_des_param='$des_value'"
			add_param="$add_param=0"
			
		else  #如果提供了默认值
		
			add_param_name=`echo "$add_param" | cut -d '=' -f 1`
			
			row_check=`getRowNum $paramFile "$add_param_name" 3`
			[ "$row_check" ] && echo "参数 $add_param_name 已存在！" && continue

            #备份
            if [ $sync_flag -eq 1 ];then
                backup_param_file
                sync_flag=2

            fi
			
			add_p_list="$add_p_list  $add_param_name"			
			
			add_des_param=des_$add_param_name
			add_des_param="$add_des_param='$des_value'"
			
		fi
		
		p_str="$add_des_param\n$add_param"
		
		[ "$param_str" ] && param_str="$param_str\n\n$p_str"
		[ ! "$param_str" ] && param_str="$p_str"
		
	done
	
	#添加到定位参数之前
	if [ "$param_str" ] && [ $before_or_after -eq 1 ];then
		param_str="$param_str\n"
		
		sed -i "$row_locate i $param_str" $paramFile

		echo 已把参数"$add_p_list" 添加到参数文件！
	
	fi
	
	#添加到定位参数之后
	if [ "$param_str" ] && [ $before_or_after -eq 2 ];then
		param_str="\\\n$param_str"
		
		sed -i "$row_locate a $param_str" $paramFile

		echo 已把参数"$add_p_list" 添加到参数文件！

	fi

fi
#======================================================== #按参数名加参数


#======================================================== #删除参数

#按块标识删除参数   sh addOrDelParams.sh  2  1  english reading wushui
#按参数名删除参数   sh addOrDelParams.sh  2  2  today_englist today_reading today_wushui


# option=2  删参数
option=$1

#1--按块标识删除    2--按参数名删除
del_mode=$2

#要删除的块标识列表或者参数名列表
del_list=`echo $* | cut -d ' ' -f 3-`


#删除参数
if [ "$option" -eq 2 ];then

	del_arr=(${del_list// / })
	len=${#del_arr[*]}
	
	for ((i = 0; i < $len; i++)); do
		del_str=${del_arr[$i]}
		
		
		#按块标识删除
		if [ "$del_mode" -eq 1 ];then
		
			#上表示符
			b1="\#${del_str}-1"
			#下标识符
			b2="\#${del_str}-2"
			
			#上标识符位置
			row_num1=`getRowNum $paramFile "$b1" 3`
			#下标识符位置
			row_num2=`getRowNum $paramFile "$b2" 3`
			
			[ ! "$row_num1" ] && [ ! "$row_num2" ] && echo 参数块：$del_str 不存在！&& continue
			[ ! "$row_num1" ] || [ ! "$row_num2" ] && echo 参数块：$del_str 不完整，请检查！&& continue
			
			core_row=`getRowNum $paramFile "\#system_core_params" 3`
			[ $row_num1 -le $core_row ] && echo "不允许删除核心参数块 $del_str ！" && continue

			#备份
			if [ $sync_flag -eq 1 ];then
				backup_param_file
				sync_flag=2

			fi

			
			row_count=`getRowCount $paramFile`
			
			#分隔行上一行
			let a=row_num1-1
			row1=`getRow $paramFile $a | trim`
			
			#分隔行上2行
			let b=row_num1-2
			row2=`getRow $paramFile $b | trim`
			
			#分隔行下一行
			let c=row_num2+1
			row3=`getRow $paramFile $c | trim`
			
			#分隔行下2行
			let d=row_num2+2
			row4=`getRow $paramFile $d | trim`
			
			[ $c -le $row_count ] && [ $d -le $row_count ] && [ ! "$row1" ] && [ ! "$row2" ] && [ ! "$row3" ] && [ ! "$row4" ] && let row_num2=row_num2+2
			
			let del_count=row_num2-row_num1+1
			for ((j = 1; j <= $del_count; j++)); do
				
				#删除
				sed -i "$row_num1 d" $paramFile
			
			done
			
			
			echo 成功删除参数块：$del_str
			
		fi
		
		
		
		#按指定参数名删除
		if [ "$del_mode" -eq 2 ];then
		
			[[ "$del_str" = des_* ]] && del_str=`echo "$del_str" | cut -c 5-`
			
			row_num1=`getRowNum $paramFile "$del_str" 3`
			
			[ ! "$row_num1" ] && echo "要求删除的参数：$del_str 不存在！" && continue
			[ ! `isNum $row_num1` ] && echo "要求删除的参数：$del_str 在参数文件中有多个同名参数！" && continue
			
			core_row=`getRowNum $paramFile "\#system_core_params" 3`
			[ $row_num1 -le $core_row ] && echo "不允许删除核心参数 $del_str ！" && continue

            #备份
            if [ $sync_flag -eq 1 ];then
                backup_param_file
                sync_flag=2

            fi
			
			row_count=`getRowCount $paramFile`
			
			#描述行
			let des_row=row_num1-1

			#描述行上一行
			let a=row_num1-2
			row1=`getRow $paramFile $a | trim`
						
			#描述行上2行
			let b=row_num1-3
			row2=`getRow $paramFile $b | trim`
			
			#参数行下一行
			let c=row_num1+1
			row3=`getRow $paramFile $c | trim`
			
			#参数行下2行
			let d=row_num1+2
			row4=`getRow $paramFile $d | trim`
			
			#描述行上一行是分隔行，参数行下一行也是分隔行，则把整个块删除
			if [[ "$row1" = *=====* ]] && [[ "$row3" = *=====* ]];then
				#描述行上3行
				let e=row_num1-4
				row5=`getRow $paramFile $e | trim`
				
				#参数行下3行
				let f=row_num1+3
				row6=`getRow $paramFile $f | trim`
				
				if [ $d -le $row_count ] && [ $f -le $row_count ] && [ ! "$row2" ] && [ ! "$row5" ] && [ ! "$row4" ] && [ ! "$row6" ];then
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile	
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile					
				else
				
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile
					sed -i "$a d" $paramFile
				
				fi
			
				echo 成功删除参数：$del_str
				continue			
			
			fi
			
			
			#描述行上一行是分隔行
			if [[ "$row1" = *=====* ]];then
				sed -i "$des_row d" $paramFile
				sed -i "$des_row d" $paramFile

				[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
				[ $d -le $row_count ] && [ ! "$row3" ] && [ ! "$row4" ] && sed -i "$des_row d" $paramFile
				
				echo 成功删除参数：$del_str
				continue
			
			fi
			
			#参数行下一行是分隔行
			if [[ "$row3" = *=====* ]];then
				sed -i "$des_row d" $paramFile
				sed -i "$des_row d" $paramFile
				
				[ ! "$row1" ] && sed -i "$a d" $paramFile
				[ ! "$row1" ] && [ ! "$row2" ] && sed -i "$b d" $paramFile
				
				
				echo 成功删除参数：$del_str
				continue
				
			
			fi
			
			#描述行之上有2行空行
			if [ ! "$row1" ] && [ ! "$row2" ];then
				sed -i "$des_row d" $paramFile
				sed -i "$des_row d" $paramFile

				[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
				[ $d -le $row_count ] && [ ! "$row3" ] && [ ! "$row4" ] && sed -i "$des_row d" $paramFile
				
				echo 成功删除参数：$del_str
				continue
			
			
			fi
			
			
			#描述行之上有1行空行
			if [ ! "$row1" ] && [ "$row2" ];then
				sed -i "$des_row d" $paramFile
				sed -i "$des_row d" $paramFile

				[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
				
				echo 成功删除参数：$del_str
				continue
			
			
			fi
			
			
		fi
		          
		
	done
		
fi
#======================================================== #删除参数


if [ $sync_flag -eq 2 ];then

	#同步
#	cd ./tool
#	sh ./sync.sh

	#echo -e "\n操作完成！\n"

	echo -e "\n-----------------------------------------------"

fi


