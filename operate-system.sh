#!/bin/bash
#系统功能操作

cd `dirname $0`
source ./funcs.sh

tput cnorm

while [ 1 ]
do

clear

cat <<list
**************************************
   1、增加参数

   2、删除参数
   
   3、调整参数块的位置

   4、同步数据

   5、设置新任务

   6、初始化management系统 
**************************************
list

read -n 1 -p "请输入你的选项(q退出)：" key

if [ $key = 1 ];then

	cd ./tool
	
	clear
	echo -ne "\n\n添加方式 1--按块加(可批量)   2--按参数名加(可批量)："
	read a1
	#按块加
	if [ "$a1" ];then
		if [ "$a1" = 1 ];then
	
			echo -ne "\n\n参数类型  1--按天数计   2--按次数计   3--普通参数(比如时间，数额等)："
			read a2
			if [ "$a2" ] ;then
			
				echo -ne "\n\n用于定位的块名称(比如sport)，添加到参数文件最后的话就输入0："
				read a3
				if [ "$a3" ] ;then
				    
					if [ "$a3" != 0 ];then
					
						echo -ne "\n\n参数插入位置 2--放到块 $a3 前面   3--放到块 $a3 后面："
						read a4	
					
					else
						a4=1
					fi

					if [ "$a4" ] ;then
					
						echo -ne "\n\n要添加的参数块的英文名和中文名，一定要成对填，比如 sport 运动 reading 读书 play_game 玩游戏 : "
						read a5

						add_param_arr=(${a5// / })
						len=${#add_param_arr[*]}
						let ys=len%2
						
						if [ ! "$a5" ] || [ $ys -ne 0 ];then

							echo -ne "\n\n请输入成对的块名称，比如 sport 运动 reading 读书 : "
							read a5
							add_param_arr=(${a5// / })
							len=${#add_param_arr[*]}
							
						fi
						
						if [ "$a5" ] ;then
						
							echo -ne "\n\n参数模板 1--百分比   2--平均值   3--high，可以填多个，以空格分隔，使用默认模板就输入0："
							read a6
							if [ "$a6" ] ;then	

								echo -e "-----------------------------------------------\n"	

								let num=len/2

								for ((i = 0; i < $num; i++)); do

									let param_index=i*2
									let des_value_index=i*2+1

									#要添加的参数块英文名
									add_param=${add_param_arr[$param_index]}
									#要添加的参数块中文名
									des_add_param=${add_param_arr[$des_value_index]}

									sh ./addOrDelParams.sh 1 1 "$a2" "$a3" $a4 "$add_param" "$des_add_param" "$a6"									
									
								done

								echo -ne "\n是否立即同步数据？y/n："
								read -n 1 a8
								if [ "$a8" ] && [ "$a8" = y ] ;then	
								    echo -e "\n\n正在同步......\n"
									sh ./sync.sh										
									echo -ne "\n同步完成，按任意键返回操作界面："
									read -n 1 a9
									
								fi
								
								cd ../
							
							fi
						
						
						fi
					
					fi
				
				fi
			
			
			fi
			
		else  #按参数名加
			echo -ne "\n\n用于定位的参数名称(英文)："
			read a2
			if [ "$a2" ] ;then	
			
				echo -ne "\n\n参数插入位置 1--放到定位参数 $a2 前   2--放到定位参数 $a2 后："
				read a3
				if [ "$a3" ] ;then
				
					echo -ne "\n\n要插入的参数，可以填多对，可以带默认值，也可以不带\n比如：today_sport 运动 mon_shop_times=20 本月购物次数 year_movie_times 今年看电影次数 : "
					read a4
					
					param_arr=(${a4// / })
					len=${#param_arr[*]}
					let ys=len%2
					
					if [ ! "$a4" ] || [ $ys -ne 0 ];then

						echo -ne "\n\n请输入成对的参数名称，比如 sport 运动 shopping 购物 : "
						read a4
						
					fi
						
					if [ "$a4" ] ;then

						echo -e "-----------------------------------------------\n"   			
						sh ./addOrDelParams.sh 1 2 "$a2" $a3 $a4
						
						echo -ne "\n是否立即同步数据？y/n："
						read -n 1 a8
						if [ "$a8" ] && [ "$a8" = y ] ;then	
						    echo -e "\n\n正在同步......\n"
							sh ./sync.sh
							echo -ne "\n同步完成，按任意键返回操作界面："
							read -n 1 a9
							
						fi
						
						cd ../
					
					fi					
				
				
				fi

			fi
		fi
	
	fi
	

fi


if [ $key = 2 ];then

	cd ./tool
	
	clear
	echo -ne "\n\n删除方式 1--按块删(可批量)   2--按参数名删(可批量)："
	read a1
	if [ "$a1" ];then
		#按块删
		if [ "$a1" = 1 ];then
	
			echo -ne "\n\n请输入要删除的块名称，多个的话以空格分隔："
			read a2
			if [ "$a2" ];then
			
				echo -e "-----------------------------------------------\n"   			
				sh ./addOrDelParams.sh 2 1 $a2
				
				echo -ne "\n是否立即同步数据？y/n："
				read -n 1 a8
				if [ "$a8" ] && [ "$a8" = y ] ;then	
				    echo -e "\n\n正在同步......\n"
					sh ./sync.sh
					echo -ne "\n同步完成，按任意键返回操作界面："
					read -n 1 a9
					
				fi
				
				cd ../			
			
			fi

		else #按参数名删
		
			echo -ne "\n\n请输入要删除参数的英文名称，多个的话以空格分隔："
			read a2
			if [ "$a2" ];then

				echo -e "-----------------------------------------------\n"   			
				sh ./addOrDelParams.sh 2 2 $a2
				
				echo -ne "\n是否立即同步数据？y/n："
				read -n 1 a8
				if [ "$a8" ] && [ "$a8" = y ] ;then	
				    echo -e "\n\n正在同步......\n"
					sh ./sync.sh
					echo -ne "\n同步完成，按任意键返回操作界面："
					read -n 1 a9
					
				fi
				
				cd ../		

			fi
		fi
	
	fi

fi


if [ $key = 3 ];then
    clear
	echo -ne "\n\n请输入要调整位置的参数块名称："
	read a1
	if [ "$a1" ];then
	
		echo -ne "\n\n请输入用于定位的参数块名称(调整到该块之前或之后)，调整到参数文件最后的话就输入0："
		read a2
		if [ "$a2" ];then
		
			if [ "$a2" != 0 ];then
				
				echo -ne "\n\n调整位置 1--把参数块 $a1 调到 $a2 之前   2--把参数块 $a1 调到 $a2 之后："
				read a3
				
			else
				
				a3=3
					
			fi
			
            if [ "$a3" ];then
                flag=1
				core_row=`getRowNum $paramFile "\#system_core_params" 3`
				row_count=`getRowCount $paramFile`
				
				#要调整的参数块位置
				row1=`getRowNum $paramFile "\#$a1-1" 3`
				row2=`getRowNum $paramFile "\#$a1-2" 3`
				
				#定位块位置
				row3=`getRowNum $paramFile "\#$a2-1" 3`
				row4=`getRowNum $paramFile "\#$a2-2" 3`
				
				[ ! "$row1" ] || [ ! "$row2" ] && echo  -e "\n参数块 $a1 不存在！" && flag=2
				[ "$a2" != 0 ] && ([ ! "$row3" ] || [ ! "$row4" ]) && echo -e "\n参数块 $a2 不存在！" && flag=2
				[ "$row1" ] && [ $row1 -le $core_row ] && echo -e "\n不允许调整核心参数块 $a1 的位置！" && flag=2

				if [ $flag = 1 ];then

					backup_param_file
					
					let n1=row1-1
					let n2=row1-2
					let n3=row2+1
					let n4=row2+2
					check1=`getRow $paramFile $n1 | trim`
					check2=`getRow $paramFile $n2 | trim`
					check3=`getRow $paramFile $n3 | trim`
					check4=`getRow $paramFile $n4 | trim`
					
					if [ "$a3" = 1 ];then
						
						if [ $n3 -le $row_count ] && [ $n4 -le $row_count ] && [ ! "$check1" ] && [ ! "$check2" ] && [ ! "$check3" ] && [ ! "$check4" ];then
							
							let row2=row2+2
							
						fi
						
						row_str=`sed -n "$row1,$row2 p" $paramFile`	
						#sed -n会自动忽略最后面的空行的，所以要加2个空行
						row_str="$row_str\n\n"
                        echo -e "$row_str" > temp.txt
							
						sed -i "$row1,$row2 d" $paramFile

						row3=`getRowNum $paramFile "\#$a2-1" 3`
						let row3=row3-1

						sed -i "$row3 r temp.txt" $paramFile

						/usr/bin/rm -rf  temp.txt 
						
					
					elif [ "$a3" = 2 ];then
					
						if [ $n3 -le $row_count ] && [ $n4 -le $row_count ] && [ ! "$check1" ] && [ ! "$check2" ] && [ ! "$check3" ] && [ ! "$check4" ];then
						
							let row1=row1-2
							row_str=`sed -n "$row1,$row2 p" $paramFile`	
							
						else
						
							row_str=`sed -n "$row1,$row2 p" $paramFile`	
							row_str="\\\n\n$row_str"
							
						fi
					
						echo -e "$row_str" > temp.txt
	
						sed -i "$row1,$row2 d" $paramFile

						row4=`getRowNum $paramFile "\#$a2-2" 3`
						
						sed -i "$row4 r temp.txt" $paramFile					
				
						/usr/bin/rm -rf  temp.txt	
						
					elif [ "$a3" = 3 ];then

						if [ $n3 -le $row_count ] && [ $n4 -le $row_count ] && [ ! "$check1" ] && [ ! "$check2" ] && [ ! "$check3" ] && [ ! "$check4" ];then
						
							let row1=row1-2
							row_str=`sed -n "$row1,$row2 p" $paramFile`	
							
						else
						
							row_str=`sed -n "$row1,$row2 p" $paramFile`	
							row_str="\\\n\n$row_str"
							
						fi
					
						echo -e "$row_str" > temp.txt
	
						sed -i "$row1,$row2 d" $paramFile

						a=`getRowCount $paramFile`
						let b=a-1
						let c=a-2
						row1=`getRow $paramFile $b`
						row2=`getRow $paramFile $c`
						
						row_end=$a
						[[ "$row1" = \#* ]] && row_end=$b
						[[ "$row2" = \#* ]] && row_end=$c
						
						sed -i "$row_end r temp.txt" $paramFile					
				
						/usr/bin/rm -rf  temp.txt					
					
					fi
					
					
					echo -ne "\n调整完成，是否立即同步数据？y/n："
					read -n 1 a8
					if [ "$a8" ] && [ "$a8" = y ] ;then	
						echo -e "\n\n正在同步......\n"
						cd ./tool
						sh ./sync.sh
						cd ..
						echo -ne "\n同步完成，按任意键返回操作界面："
						read -n 1 a9
						
					fi

				else

				    echo -ne "\n按任意键返回操作界面："
					read -n 1 a9	
				
				fi
			
			
			fi		
		
		fi	
	
	fi
	

fi


if [ $key = 4 ];then
	clear
	echo -e '\n\n正在同步......'
	cd ./tool
	echo -e "\n"
	sh ./sync.sh
	echo -ne "\n同步完成，按任意键返回操作界面："
	read -n 1 a9
	cd ../

fi


if [ $key = 5 ];then
	clear
	echo -ne "\n\n请输入任务名称："
	read a1
	if [ "$a1" ];then

		echo -ne "\n\n请输入任务期限(天)："
		read a2
		if [ "$a2" ];then
		
			echo -ne "\n\n请输入总任务数："
			read a3
			if [ "$a3" ];then
				
				changeParams 1 task_is_stop
				changeParams "'$a1'" task_name_A1
				changeParams "$a2" task_deadline_days_A1
				changeParams "$a3" total_task_num_A1
				changeParams "$today2" task_start_day_A1
				changeParams "`date -d "$a2 day" +%F`" task_end_day_A1
				changeParams 0 today_task_num_A1		
                changeParams 0 completed_task_num_A1
				changeParams $a3 remaining_task_num_A1
				changeParams 0 rate_task_completed_A1
				changeParams 0 task_days_A1
				changeParams $a2 remaining_task_days
				changeParams 0 ave_task_A1
				
				printSeparatorByDate 2 data/note/event.txt
				echo -e "`now`     设置新任务：$a1     任务期限：$a2天\n\n" >> data/note/event.txt
		
				echo -e "\n新任务设置完成！\n"
				
				sleep 3
			fi				

		fi		
	

	fi	

fi


if [ $key = 6 ];then

	clear
	echo -ne "\n\n确定清空全部系统数据？y/n："
	read a1
	if [ "$a1" ] && [ "$a1" = y ];then
	    if [ $current_version != 1.0 ];then
			echo -ne "\n\n请输入密钥(在config.sh中)："
			read a2
		else
			a2=$init_system_secret
		fi
		
		if [ "$a2" ] && [ "$a2" = $init_system_secret ];then	
		
			echo -e "\n正在初始化......\n"
		
			if [ $current_version != 1.0 ];then	
				#备份
				fuffix=`time_str`
				zip -ry ./life-management_$fuffix.zip ../life-management -x=*.mp3 &> /dev/null

			fi
			
			#清空收益流水
			echo '' > $income_file
			
			#关闭页面开关
			#changeFile $configFile mons_and_years_page_flag 2

			#干掉非核心参数
			#start_row=`getRowNum $paramFile \#system_core_params 3`
			#let start_row=start_row+3
			#row_count=`getRowCount $paramFile`
			
			#[ $row_count -ge $start_row ] && sed -i "$start_row,$row_count d" $paramFile
			
			#升级版本
			doubleAddOrSub 1 0.1 add current_version
            
			#创建存放今年日志的文件夹
            baseDir=./data/note/life/$year
            [ ! -d $baseDir ] && mkdir -p $baseDir

			
			#初始化非系统参数
			start_row=`getRowNum $paramFile \#system-2 3`
			let start_row=start_row+1
			row_count=`getRowCount $paramFile`
			
			for row in $(seq $start_row $row_count); do
				all_params=`getRow $paramFile $row | trim`
				[ ! "$all_params" ] || [[ "$all_params" = \#* ]] || [[ "$all_params" = des_* ]] && continue
				
				param=`echo "$all_params" | cut -d '=' -f 1`
				value=`echo "$all_params" | cut -d '=' -f 2`
				
				[ "$value" = NO ] && continue
				[ "$value" = 0 ] && continue
				
				[ "$param" = task_time_taken ] && continue
				[ "$param" = last_task_finish_timestamp ] && continue
				[ "$param" = task_finish_time ] && continue
				[ "$param" = start_focus_timestamp ] && continue

				[ "$value" = YES ] && changeParams NO $param && continue
				[[ "$value" = *% ]] && changeParams 0 $param && continue
				[ `isNum "$value"` ] && changeParams 0 $param && continue
				changeParams "''" $param
				
			done
			changeParams 1 sleep_record_flag high_energy_days_count_flag high_income_days_count_flag high_focus_days_count_flag high_task_days_count_flag
			changeParams 1000000 my_asset_target asset_gap
			changeParams OUT focus_on_out
			changeParams 2 task_is_stop
			
			
			
			#初始化system参数
			changeParams "''" today_goal
			changeParams 1 management_days management_mons management_years write_params_to_daily_file_flag write_params_to_mon_file_flag write_params_to_year_file_flag
			
			day_of_year=`date +%j`
			[[ "$day_of_year" = 0* ]] && day_of_year=`echo "$day_of_year" | cut -c 2-`
			changeParams $day_of_year day_of_year
			
			
			#今天日期  2023.1.1
			today11=$(echo `date +%Y.%m.%d` | awk -F"." '{printf("%d.%d.%d\n",$1,$2,$3)}')
			today22=`date "+%Y-%m-%d"`
			#年 2023
			year11=$(date "+%Y")
			#月份  1
			mon=`echo $today11 | cut -d '.' -f 2`
			#几号  1
			day=`echo $today11 | cut -d '.' -f 3`
			
			changeParams "$today11" today
			changeParams "$today22" today2
			changeParams $year11 year
			changeParams $mon mon_of_year
			changeParams $day day_of_mon
			changeParams $today2 management_start_day
			
			
			
			#清空db
			row_count=`getRowCount $dailyData`
			[ $row_count -ge 3 ] && sed -i "3,$row_count d" $dailyData
			
			row_count=`getRowCount $monsData`
			[ $row_count -ge 3 ] && sed -i "3,$row_count d" $monsData
			
			row_count=`getRowCount $yearsData`
			[ $row_count -ge 3 ] && sed -i "3,$row_count d" $yearsData
			
			
			#同步
			cd ./tool
			sh ./sync.sh
			cd ../

			#记录日志
			printSeparatorByDate 2 data/note/event.txt
			echo -e "`now`     初始化系统\n\n" >> data/note/event.txt
			echo -e "\n系统初始化完成！\n"
			sleep 3
			
		fi
	fi

fi


[ $key = q ]  && break


done


showConsole









