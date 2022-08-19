#!/bin/bash


KDIR=$(pwd)/..
SRC=$(pwd)


#echo -e ""
#read -n1 -p "Do you want to kill all processes? [A-ALL,T-Test]" doit


function IS_ACTIVE(){

    file=$1
    echo $1
    if [ -f "$file" ]
	echo "This is a file"
        then
        PID=`cat ${file}`
                if ps -e -p "$PID" > /dev/null
                then
                echo "${1} IS ACTIVE"
                 ps -Fw -e -p  ${PID}
        else
                echo "${1} IS NOT ACTIVE"
                fi
    fi
}



echo -e "Please enter a two letter word for the process you would like to test \n ie for tp -tp \n for filehandler- fh\n for rdb1- r1 \n for rdb2- r2\n for cep-ce "
read -n2 -ep " " s1

echo "Checking $KDIR/logs/pids/"


case $s1 in
        tp) IS_ACTIVE "${KDIR}/logs/pids/tp.pid";;
        fh) IS_ACTIVE "${KDIR}/logs/pids/feed.pid";;
        r1) IS_ACTIVE "${KDIR}/logs/pids/rdb1.pid";;
        r2) IS_ACTIVE "${KDIR}/logs/pids/rdb2.pid";;
        ce) IS_ACTIVE "${KDIR}/logs/pids/tp.pid";;
        **) echo "No input detected, please try again";;
esac
