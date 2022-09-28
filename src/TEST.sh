#!/bin/bash
dirName=${PWD##*/}

#Check location of directory

if [ $dirName == "advancedKDB" ]; then
  cd ./src
  echo "Changing to source directory..."
elif
  [$dirname == "src"]; then
  echo "Executing in source directory"
else
  echo -e "\n"
  #echo "Directory not correctly set, please move to either the src advancedKDB directory"
fi


KDIR=$(pwd)/..
SRC=$(pwd)


#echo -e ""
#read -n1 -p "Do you want to kill all processes? [A-ALL,T-Test]" doit


function RUN_ALL(){
        IS_ACTIVE "${KDIR}/logs/pids/tp.pid"
        sleep 2
        IS_ACTIVE "${KDIR}/logs/pids/feed.pid"
        sleep 2
        IS_ACTIVE "${KDIR}/logs/pids/rdb1.pid"
        sleep 2
        IS_ACTIVE "${KDIR}/logs/pids/rdb2.pid"
        sleep 2
	IS_ACTIVE "${KDIR}/logs/pids/cep.pid"
}


function IS_ACTIVE(){

    file=$1
    echo -e "\n"
    #echo $1
    if [ -f "$file" ]
        then
        PID=`cat ${file}`
	#echo -e "\n The PID for this process exists and is $PID \n"
	port=" "
                if ps -e -p "$PID" > /dev/null
                then
			port=`netstat -taunp  2>/dev/null | grep $PID -m 1 |awk -F ':' '{print $2}'|awk '{print $1}'`
			fName=`echo ${file}|sed 's#.*/##'| sed 's/.pid//'`
			if [[ "$port" != " " && "$port" != "" ]]
			then 
				echo $"The $fName process is active on port $port with pid $PID"
			else
				echo $"The pid is stored for $fName as $PID, but the process is unavailable and so port is blank"
			fi
                #echo "${1} IS ACTIVE"
                #ps -Fw -e -p  ${PID}| grep ${PID##*/} 
        else
                echo -e "${1} The PID for this process is not stored. Please start via the bash script\n"
                fi
	port=" "
    fi
}

read -n1 -p "Do you want to test all processes? [y,n]" doit
echo -e "/n"
case $doit in
  y|Y) echo -e "yes \n" |RUN_ALL;;
  n|N) echo no ;;
  *) echo dont know ;;
esac

if [ $doit == "n" ]
then

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
fi
