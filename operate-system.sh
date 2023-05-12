#!/bin/bash
#系统功能操作

cd `dirname $0`
source ./funcs.sh

tput cnorm

while [ 1 ]
do

clear

cat <<list
******************************************************

   1、增加参数

   2、删除参数
   
   3、调整参数位置

   4、同步数据

   5、任务管理(设置新任务/暂停任务/开启任务/终止任务)

   6、初始化management系统 

******************************************************
list

read -n 1 -p "请输入你的选项(q退出)：" key

#加参数
if [ $key = 1 ];then
	
	clear
	echo -ne "\n\n添加方式  1--按块加(可批量)   2--按参数名加(可批量)："
	read a1
	#按块加
	if [ `isNum "$a1"` ] && [ "$a1" = 1 ];then

		echo -ne "\n\n参数类型  1--按天数计   2--按次数计   3--普通参数(比如时间，数额等)："
		read a2
		if [ `isNum "$a2"` ];then
		
			echo -ne "\n\n用于定位的块名称(比如sport)，添加到参数文件最后的话就输入 0 ："
			read a3
			if [ "$a3" ] ;then
				
				if [ "$a3" != 0 ];then
				
					echo -ne "\n\n参数插入位置  2--放到块 $a3 前面   3--放到块 $a3 后面："
					read a4	
				
				else
					a4=1
				fi

				if [ `isNum "$a4"` ] ;then
				
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

						[ "$a2" = 1 ] && tip_str="\n\n参数模板  1--百分比   2--平均值  可以选1个或两个，以空格分隔，使用默认模板就输入 0 ："					
						[ "$a2" = 2 ] || [ "$a2" = 3 ] && tip_str="\n\n参数模板  2--平均值   3--high，可以选1个或两个，以空格分隔，使用默认模板就输入 0 ："					
						echo -ne "$tip_str"
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
							    cd ./tool
								sh ./addOrDelParams.sh 1 1 "$a2" "$a3" $a4 "$add_param" "$des_add_param" "$a6"									
								cd ../
							done

							echo -ne "\n是否立即同步数据？y/n："
							read -n 1 a8
							if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]);then	
								echo -e "\n\n正在同步......\n"
								cd ./tool
								sh ./sync.sh	
								cd ../								
								echo -ne "\n同步完成，按任意键返回操作界面："
								read -n 1 a9
								
							fi
							
						
						fi
					
					
					fi
				
				fi
			
			fi
		
		
		fi
		
	elif [ `isNum "$a1"` ] && [ "$a1" = 2 ];then  #按参数名加
        echo -ne "\n\n请输入用于定位的参数英文名称(添加到该参数之前或之后)："
        read a2
        if [ "$a2" ] ;then
            if [[ $a2 = des_* ]];then
                a3=1
            else
                a3=2
            fi
		
			echo -ne "\n\n请输入要增加参数的英文名和中文名，可以填多对，可以带默认值，也可以不带\n比如：today_sport 运动 mon_shop_times=20 本月购物次数 year_movie_times 今年看电影次数 : "
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
				cd ./tool					
				sh ./addOrDelParams.sh 1 2 "$a2" $a3 $a4
				cd ../
				
				echo -ne "\n是否立即同步数据？y/n："
				read -n 1 a8
				if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]) ;then	
					echo -e "\n\n正在同步......\n"
					cd ./tool
					sh ./sync.sh
					cd ../
					echo -ne "\n同步完成，按任意键返回操作界面："
					read -n 1 a9
					
				fi			
			
			
			fi

		fi
	fi

fi


#删参数
if [ $key = 2 ];then
	
	clear
	echo -ne "\n\n删除方式  1--按块删(可批量)   2--按参数名删(可批量)："
	read a1
	#按块删
	if [ `isNum "$a1"` ] && [ "$a1" = 1 ];then

		echo -ne "\n\n请输入要删除的块名称(英文)，多个的话以空格分隔："
		read a2
		if [ "$a2" ];then
		
			echo -e "-----------------------------------------------\n"   
			cd ./tool			
			sh ./addOrDelParams.sh 2 1 $a2
			cd ../
			
			echo -ne "\n是否立即同步数据？y/n："
			read -n 1 a8
			if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]) ;then	
				echo -e "\n\n正在同步......\n"
				cd ./tool
				sh ./sync.sh
				cd ../
				echo -ne "\n同步完成，按任意键返回操作界面："
				read -n 1 a9
				
			fi	
		
		fi

	elif [ `isNum "$a1"` ] && [ "$a1" = 2 ];then #按参数名删
	
		echo -ne "\n\n请输入要删除参数的英文名称，多个的话以空格分隔："
		read a2
		if [ "$a2" ];then

			echo -e "-----------------------------------------------\n"   	
			cd ./tool			
			sh ./addOrDelParams.sh 2 2 $a2
			cd ../
			
			echo -ne "\n是否立即同步数据？y/n："
			read -n 1 a8
			if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]) ;then	
				echo -e "\n\n正在同步......\n"
				cd ./tool
				sh ./sync.sh
				cd ../
				echo -ne "\n同步完成，按任意键返回操作界面："
				read -n 1 a9
				
			fi
				

		fi
	fi

fi


#调整参数位置
if [ $key = 3 ];then
    clear
	echo -ne "\n\n1--调整参数块的位置   2--调整参数的位置(块内调整)："
	read b
	
	#调整参数块的位置
	if [ $b ] && [ $b = 1 ];then
		echo -ne "\n\n请输入要调整位置的参数块名称(英文)："
		read a1
		if [ "$a1" ];then
		
			echo -ne "\n\n请输入用于定位的参数块名称(调整到该块之前或之后)，如果调整到参数文件最后的话就输入 0 ："
			read a2
			if [ "$a2" ];then
			
				if [ "$a2" != 0 ];then
					
					echo -ne "\n\n调整位置  1--把参数块 $a1 调到 $a2 之前   2--把参数块 $a1 调到 $a2 之后："
					read a3
					
				else
					
					a3=3
						
				fi
				
				if [ `isNum "$a3"` ];then
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
						#备份
						#backup_param_file
						
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
						if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]) ;then	
							echo -e "\n\n正在同步......\n"
							cd ./tool
							sh ./sync.sh
							cd ../
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
	
	#调整参数的位置(块内调整)
	elif [ $b ] && [ $b = 2 ];then
		echo -ne "\n\n请输入要调整位置的参数名称(英文),可填多个，必须是同一个块的，以空格分隔，不要填描述参数："
		read a1
		if [ "$a1" ];then	

			echo -ne "\n\n请输入用于定位的参数名称(调整到该参数之前或之后)，或者：1--调整到本参数块最前面   2--调整到本参数块最后面："
			read a2
			
			if [ "$a2" ];then
				flag_1=1
				#有定位参数
				if [ ! `isNum $a2` ];then
					if [ ! `getRowNum $paramFile $a2 3` ];then 
						echo -e "\n定位参数 $a2 不存在！"
						flag_1=2
						
						echo -ne "\n\n请输入用于定位的参数名称(调整到该参数之前或之后)，或者：1--调整到本块最前面   2--调整到本块最后面："
						read a2		

						if [ ! `getRowNum $paramFile $a2 3` ];then
							echo -e "\n定位参数 $a2 不存在！"
						else
							flag_1=1
						fi

					fi
					
					
					if [ $flag_1 = 1 ];then
						#定位参数所在的块的上分隔行行号
						block_start1=`getPositionOfBlock $a2 1`	
						temp=''
						
						arr=(${a1// / })
						len=${#arr[*]i}						
						for ((i = 0; i < $len; i++)); do
							param=${arr[$i]}
							
							#参数行位置
							row_num1=`getRowNum $paramFile $param 3`
							
							[ ! $row_num1 ] && echo -e "\n参数 $param 不存在！" && continue
							
							[[ $param = des_* ]] && echo -e "\n$param 是描述参数！" && continue
					
							[ `getPositionOfBlock $param 1` != $block_start1 ] && echo -e "\n参数 $param 与定位参数 $a2 不是处于同一个块！" && continue
							temp="$temp $param"					

						done	
						
						temp=`echo $temp | trim`
						a1=$temp					
					
					fi
					
				fi
				
				#有定位参数
				if [ $flag_1 = 1 ] && [ ! `isNum $a2` ];then
					echo -ne "\n\n调整位置  1--把参数 "$a1" 调到 $a2 之前   2--把参数块 "$a1" 调到 $a2 之后："
					read a3	
					
					flag2=1
					[ $a3 ] && [ $a3 = 1 ] && [[ $a2 != des_* ]] && echo -e "\n$a2 不是描述参数，不能移动到非描述参数之前！" && flag2=2 
					[ $a3 ] && [ $a3 = 2 ] && [[ $a2 = des_* ]] && echo -e "\n$a2 是描述参数，不能移动到描述参数之后！" && flag2=2 
					
					if [ $flag2 = 2 ];then
						echo -ne "\n\n调整位置  1--把参数 "$a1" 调到 $a2 之前   2--把参数块 "$a1" 调到 $a2 之后："
						read a3

						[ $a3 ] && [ $a3 = 1 ] && [[ $a2 != des_* ]] && echo -e "\n$a2 不是描述参数，不能移动到非描述参数之前！" && a3=''
						[ $a3 ] && [ $a3 = 2 ] && [[ $a2 = des_* ]] && echo -e "\n$a2 是描述参数，不能移动到描述参数之后！" && a3=''
					
					fi
					
				elif [ $flag_1 = 1 ];then
					#无定位参数
					a3=25
					
				else
					#定位参数不存在
					a3=''
			
				fi
				
				if [ `isNum "$a3"` ];then
					arr=(${a1// / })
					len=${#arr[*]i}
					
					#要移动的参数所在的块的前分隔行行号
					param_block_1=''	

					#无定位参数
					if [ $a3 = 25 ];then

						temp=''
						head_param=''
						for ((i = 0; i < $len; i++)); do
							param=${arr[$i]}
							
							#参数行位置
							row_num1=`getRowNum $paramFile $param 3`
							
							[ ! $row_num1 ] && echo -e "\n参数 $param 不存在！" && continue
							
							[[ $param = des_* ]] && echo -e "\n$param 是描述参数！" && continue
						
							if [ $param_block_1 ];then
								[ `getPositionOfBlock $param 1` != $param_block_1 ] && echo -e "\n参数 $param 与 $head_param 不是处于同一个块！" && continue
								temp="$temp $param"
							else
							
								param_block_1=`getPositionOfBlock $param 1`
								
								temp=$param
								head_param=$param
							
							fi							

						done	
						
						a1=$temp
					
					fi
					
					

					arr=(${a1// / })
					len=${#arr[*]i}
					#真实有效的参数串
					param_list=''
					#要移动的参数行
					move_str=''
					for ((i = 0; i < $len; i++)); do

						param=${arr[$i]}
						
						#参数行位置
						row_num1=`getRowNum $paramFile $param 3`
							
						#去重
						[ "`echo $param_list | grep -w $param`" ] && continue
						[ $a2 = $param ] && continue
						param_list="$param_list $param"
						
						#参数行内容
						p_row_str=`getRow $paramFile $row_num1 | trim`
						#描述行位置
						let des_row=row_num1-1
						#描述行内容
						des_row_str=`getRow $paramFile $des_row | trim`
						
						[ "$move_str" ] && move_str="$move_str\n\n$des_row_str\n$p_row_str"
						[ ! "$move_str" ] && move_str="$des_row_str\n$p_row_str"
						
						
						row_count=`getRowCount $paramFile`
						
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
						
						#描述行上一行是分隔行
						if [[ "$row1" = *=====* ]];then
							sed -i "$des_row d" $paramFile
							sed -i "$des_row d" $paramFile

							[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
							[ $d -le $row_count ] && [ ! "$row3" ] && [ ! "$row4" ] && sed -i "$des_row d" $paramFile
							
							continue
						
						fi
						
						#参数行下一行是分隔行
						if [[ "$row3" = *=====* ]];then
							sed -i "$des_row d" $paramFile
							sed -i "$des_row d" $paramFile
							
							[ ! "$row1" ] && sed -i "$a d" $paramFile
							[ ! "$row1" ] && [ ! "$row2" ] && sed -i "$b d" $paramFile
							
							continue
							
						
						fi
						
						#描述行之上有2行空行
						if [ ! "$row1" ] && [ ! "$row2" ];then
							sed -i "$des_row d" $paramFile
							sed -i "$des_row d" $paramFile

							[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
							[ $d -le $row_count ] && [ ! "$row3" ] && [ ! "$row4" ] && sed -i "$des_row d" $paramFile
							
							continue
						
						
						fi
						
						
						#描述行之上有1行空行
						if [ ! "$row1" ] && [ "$row2" ];then
							sed -i "$des_row d" $paramFile
							sed -i "$des_row d" $paramFile

							[ $c -le $row_count ] && [ ! "$row3" ] && sed -i "$des_row d" $paramFile
						
						fi

					done
					
					if [ "$move_str" ];then
					
						if [ $a3 = 1 ];then  #移到定位参数之前
							position_row=`getRowNum $paramFile $a2 3`
							sed -i "$position_row i $move_str\n" $paramFile

							echo -e "\n已把参数$param_list 移动到 $a2 之前！"								
						
						elif [ $a3 = 2 ];then #移到定位参数之后
							position_row=`getRowNum $paramFile $a2 3`
							sed -i "$position_row a \\\n$move_str" $paramFile

							echo -e "\n已把参数$param_list 移动到 $a2 之后！"								
						
						elif [ $a2 = 1 ];then #移到本参数块最前面
							
							sed -i "$param_block_1 a $move_str\n" $paramFile

							echo -e "\n已把参数$param_list 移动到参数块最前面！"	
							
						elif [ $a2 = 2 ];then #移到本参数块最后面
							blockName=`getRow $paramFile $param_block_1 | cut -d '-' -f 1 | sed 's/\#//g'`
							blockName="\#$blockName-2"
							param_block_2=`getRowNum $paramFile "$blockName" 3`
							
							sed -i "$param_block_2 i \\\n$move_str" $paramFile
							
							
							echo -e "\n已把参数$param_list 移动到参数块最后面！"	
											
						fi
						
						echo -ne "\n调整完成，是否立即同步数据？y/n："
						read -n 1 a8
						if [ "$a8" ] && ([ "$a8" = y ] || [ "$a8" = Y ]) ;then	
							echo -e "\n\n正在同步......\n"
							cd ./tool
							sh ./sync.sh
							cd ../
							echo -ne "\n同步完成，按任意键返回操作界面："
							read -n 1 a9
							
						fi							
					
					else
						echo -ne "\n按任意键返回操作界面："
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



#同步数据
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


#任务管理
if [ $key = 5 ];then
	clear
	
	echo -ne "\n\n1--设置新任务   2--暂停任务   3--开启任务   4--终止任务："
	read b
	if [ `isNum "$b"` ] && [ $b = 1 ];then
		echo -ne "\n\n请输入新任务的名称："
		read a1
		if [ "$a1" ];then

			echo -ne "\n\n请输入总任务数："
			read a2
			if [ `isNum "$a2"` ];then
			
				echo -ne "\n\n请输入任务期限(天)："
				read a3
				if [ `isNum "$a3"` ];then
					
					changeParams 2 task_state_A1
					changeParams "'$a1'" task_name_A1
					changeParams "$a3" task_deadline_days_A1
					changeParams "$a2" total_task_num_A1
					changeParams "$today2" task_start_day_A1
					changeParams "`date -d "$a3 day" +%F`" task_end_day_A1
					changeParams 0 today_task_num_A1		
					changeParams 0 completed_task_num_A1
					changeParams $a2 remaining_task_num_A1
					changeParams 0 rate_task_completed_A1
					changeParams 0 task_days_A1
					changeParams $a3 remaining_task_days_A1
					changeParams 0 ave_task_A1
					
					printSeparatorByDate 2 data/note/event.txt
					echo -e "`now`     设置新任务：$a1     总任务数：$a2个     任务期限：$a3天\n\n" >> data/note/event.txt
			
					echo -e "\n新任务设置完成！\n"
					
					sleep 3
				fi				

			fi		
		

		fi	
		
	elif [ `isNum "$b"` ] && [ $b = 2 ] && [ $task_state_A1 = 2 ];then
	
		echo -ne "\n\n确定暂停任务【$task_name_A1】? y/n "
		read c
		if [ "$c" ] && ([ "$c" = y ] || [ "$c" = Y ]);then
			changeParams 4 task_state_A1
			echo -e "\n\n任务【$task_name_A1】已暂停！"
			sleep 3
		fi
		
	elif [ `isNum "$b"` ] && [ $b = 3 ] && [ $task_state_A1 = 4 ];then

		changeParams 2 task_state_A1
		echo -e "\n\n任务【$task_name_A1】已开启！"	
		sleep 3	
	
	elif [ `isNum "$b"` ] && [ $b = 4 ] && ([ $task_state_A1 = 2 ] || [ $task_state_A1 = 4 ] || [ $task_state_A1 = 6 ]);then

		echo -ne "\n\n确定终止任务【$task_name_A1】? 终止后将不可恢复！ y/n "
		read c
		if [ "$c" ] && ([ "$c" = y ] || [ "$c" = Y ]);then
			changeParams 5 task_state_A1
			echo -e "\n\n任务【$task_name_A1】已终止！"

            printSeparatorByDate 2 data/note/event.txt
            echo -e "`now`     终止任务：$task_name_A1\n\n" >> data/note/event.txt

			sleep 3
		fi
		
	fi
		

fi


#初始化系统
if [ $key = 6 ];then

	clear
	echo -ne "\n\n确定初始化系统并清空全部数据？y/n："
	read a1
	if [ "$a1" ] && ([ "$a1" = y ] || [ "$a1" = Y ]);then
	    if [ $current_version != 1.0 ];then
			echo -ne "\n\n请输入密钥(在config.sh中)："
			read a2
		else
			a2=$init_system_secret
		fi
		
		if [ "$a2" ] && [ "$a2" = $init_system_secret ];then	

            crondir='/var/spool/cron/'"$USER"
            path="`pwd`"
            [ -e $crondir ] && checkCron=`getRowNum $crondir "$path\/initParams.sh" 1`
            if [ ! "$checkCron" ];then
                echo -ne "\n是否允许将定时任务加入crontab，本系统需要每日晚上进行两次定时统计任务，否则无法正常运行？y/n："
                read b
                if [ "$b" ] && ([ "$b" = y ] || [ "$b" = Y ]);then
                    echo -e "\n#life-management统计定时任务" >> ${crondir}
                    echo "50 23 * * * sh $path/compute.sh" >> ${crondir}
                    echo -e "#life-management初始化定时任务" >> ${crondir}
                    echo "0 0 * * * sh $path/initParams.sh" >> ${crondir}

                fi
            fi
		
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

			#标记为已进行系统初始化
			changeFile $configFile is_init_system 2
			
			#清空日志
			/usr/bin/rm -rf ./data/note/life/*
			
			#创建mp3文件夹
			musicDir=./html/static/mp3
			[ ! -d $musicDir ] && mkdir -p $musicDir
		
			#创建日志文件夹
			logDir=./data/logs
			[ ! -d $logDir ] && mkdir -p $logDir

			#干掉非核心参数
			#start_row=`getRowNum $paramFile \#system_core_params 3`
			#let start_row=start_row+3
			#row_count=`getRowCount $paramFile`
			#[ $row_count -ge $start_row ] && sed -i "$start_row,$row_count d" $paramFile
			
			#升级版本
			doubleAddOrSub 1 0.1 add current_version
            
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
			changeParams 1 task_state_A1			                
			
			
			
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




