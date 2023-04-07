#!/bin/bash
#统计db

command_path=`pwd`
result=`echo "$command_path" | grep -w tool$`
[ $result ] && cd ..


source ./funcs.sh

#参数序列
paramSeq=$(sed -n "1p" $dailyData)
paramSeq=`echo $paramSeq | sed 's/)//g' | sed 's/(/-/g'`

row_count=`wc -l < $dailyData`

#偏移量  第3行开始读
offset=3

#参数数组
paramName_arr=(${paramSeq//,/ })
len=${#paramName_arr[*]}
let count=len-1

#初始化月度统计变量
initMonSum(){
        for n in $(seq 1 $count); do
                eval `echo Msum$n=0`
        done
}

#初始化年度统计变量
initYearSum(){
    for n in $(seq 1 $count); do
        eval `echo Ysum$n=0`
    done
}

#初始化总计统计变量
initTotalSum(){
    for n in $(seq 1 $count); do
        eval `echo Tsum$n=0`
    done
}



sum() {

        #要统计的月份
        year=$1
        mon=$2
        year_mon="$year.$mon"

        initMonSum

        [ $mon -eq 1 ] && initYearSum

        index=$offset
        #遍历每一行
        for row in $(seq $index $row_count); do
                all_params=$(sed -n "${row}p" $dailyData)

                ymd=`echo $all_params | cut -d ',' -f 1`
                if [[ $ymd != $year_mon* ]]; then
                        break
                fi
            #遍历每一列
                    for n in $(seq 1 $count); do
                            #参数列
                            let paramCol=n+1

                value=$(echo $all_params | cut -d ',' -f $paramCol)


                                #统计月数据
                                MomSum=`eval echo "$"{Msum$n}`
                        MomSum=$(echo $value | awk -v a=$MomSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g') 
                                eval `echo Msum$n=$MomSum`

                                #统计年数据
                YearSum=`eval echo "$"{Ysum$n}`
                YearSum=$(echo $value | awk -v a=$YearSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g')
                eval `echo Ysum$n=$YearSum`

                #统计总体数据
                TotalSum=`eval echo "$"{Tsum$n}`
                TotalSum=$(echo $value | awk -v a=$TotalSum '{printf "%.2f",$0 + a}' | sed 's/\.00//g')
                eval `echo Tsum$n=$TotalSum`
                done


                let offset=offset+1 

        done

    for n in $(seq 1 $count); do
                paramName=`eval echo "$"{paramName$n}`
                MomSum=`eval echo "$"{Msum$n}`

                [ $n -eq 1 ] && echo "----------------------------" && echo $year.$mon
                echo $paramName  $MomSum
                [ $n -eq $count ] && echo "----------------------------"
    done

        if [ $mon -eq 12 ] || [ $offset -gt $row_count ];then
                for n in $(seq 1 $count); do
            [ $n -eq 1 ] && echo "==================================" && echo $year
                        paramName=`eval echo "$"{paramName$n}`
                        YearSum=`eval echo "$"{Ysum$n}`
            echo $paramName  $YearSum
            [ $n -eq $count ] && echo "=================================="
                done       
        fi

    if [ $offset -gt $row_count ];then
        for n in $(seq 1 $count); do
            [ $n -eq 1 ] && echo "##################################" && echo 总计：
            paramName=`eval echo "$"{paramName$n}`
            TotalSum=`eval echo "$"{Tsum$n}`
            echo $paramName  $TotalSum
            [ $n -eq $count ] && echo "##################################"
        done      
    fi

}



#初始化总计统计变量
initTotalSum

year_arr=(2023 2024 2025 2026 2027 2028 2029 2030)
mon_arr=(1 2 3 4 5 6 7 8 9 10 11 12)

len1=${#year_arr[*]}
len2=${#mon_arr[*]}

for n in $(seq 1 $count); do
        let n2=n+1
    paramName=`echo $paramSeq | cut -d ',' -f $n2`
    eval `echo paramName$n="$paramName"`
done

begin=$(date '+%s')

flag=1
first_row_time=`getRow $dailyData 3 | cut -d ',' -f 1`
for ((i = 0; i < $len1; i++)); do

                y="${year_arr[$i]}" 
                [ $flag -eq 1 ] && [[ "$first_row_time" != $y* ]] && continue

        for ((j = 0; j < $len2; j++)); do
                m="${mon_arr[$j]}"

                [ $flag -eq 1 ] && [[ "$first_row_time" != $y.$m* ]] && continue
                [[ "$first_row_time" = $y.$m* ]] && flag=2

                [ $offset -gt $row_count ] && break

                sum  $y $m
        done

done

finish=$(date '+%s')

let time=finish-begin

time=$(echo $time | awk '{printf "%.1f", $0 / 60}')

echo 耗时：$time分钟
