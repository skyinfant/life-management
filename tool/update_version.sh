#!/bin/bash
#改动后记录当前版本

tput cnorm
cd `dirname $0`
cd ../
source ./funcs.sh

updateVersion()
{

    doubleAddOrSub 1 0.1 add current_version

    printSeparatorByDate 2 ./data/note/versions.txt
    echo -e "`now`     V$current_version     $str\n\n" >> ./data/note/versions.txt 2> /dev/null

}

str="$1"

if [ ! "$str" ];then
	clear
	echo -ne "\n\n请输入改动内容："
	read str

	if [ "$str" ] ;then

    	updateVersion

	fi

else

	updateVersion

fi




