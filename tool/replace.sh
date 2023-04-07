#!/bin/bash
#替换目录下全部文件中的指定字符串

command_path=`pwd`
result=`echo "$command_path" | grep -w tool$`
[ ! $result ] && echo '请进入脚本目录下执行！' && exit 1

[ -e ./life-management.zip ] && echo '请先处理旧压缩包！' && exit 1


[ $# -lt 3 ] && echo '参数不足！'  && exit 1


#旧字符串
old=$1

#新的字符串
new=$2

#1--严格   2--宽松
mode=$3

#先备份
[ $mode ] && zip -ry ./life-management.zip ../../life-management -x=*.mp3 &> /dev/null

[ $mode -eq 1 ] && grep -rlw $old ../ | xargs sed -i "s/\<$old\>/$new/g"

[ $mode -eq 2 ] && grep -rl $old ../ | xargs sed -i "s/$old/$new/g"



