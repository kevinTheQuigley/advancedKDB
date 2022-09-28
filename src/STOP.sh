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

#cd $SRC

include () {
    if [[ ! -f "$1" ]] ; then
        echo "config "$1" not found, exit"
        exit 1
    fi
    source $1
}

include ${SRC}/"/env.sh"


function stopTP() {
	kill `cat ${KDIR}/logs/pids/tp.pid`
        rm ${KDIR}/logs/pids/tp.pid
	echo -e "Stopping the TP \n"
}


function stopFH() {
	kill `cat ${KDIR}/logs/pids/feed.pid`
        rm ${KDIR}/logs/pids/feed.pid
	echo -e "Stopping the Feedhandler \n"
}

function stopRDB() {
	kill `cat ${KDIR}/logs/pids/rdb1.pid`
        rm ${KDIR}/logs/pids/rdb1.pid
	echo -e "Stopping the rdb\n"
}

function stopRDB2() {
	kill `cat ${KDIR}/logs/pids/rdb2.pid`
        rm ${KDIR}/logs/pids/rdb2.pid
	echo -e "Stopping the rdb2\n"
}

function stopCEP() {
	kill `cat ${KDIR}/logs/pids/cep.pid`
        rm ${KDIR}/logs/pids/cep.pid
	echo -e "Stopping the cep\n"
}





function IS_ACTIVE(){
 
    file="$2"
    if [ -f "$file" ] 
	then 
        PID=`cat ${file}`
		if ps -p "$PID" > /dev/null 
 		then 
        	echo "${1} IS ACTIVE"
       		 ps -Fw -p ${PID}
    	else 
       		echo "${1} IS NOT ACTIVE"
		fi
    fi

}



function STOP_ALL(){
        stopTP
        sleep 2
        stopFH
        sleep 2
        stopRDB
        sleep 2
        stopRDB2
        sleep 2
        stopCEP
}

echo -e "\n Do you want to stop all processes, or one specific process?"
echo -e "\n y - Yes, stop all processes"
echo -e "\n n - No, stop no processes"
echo -e "\n o - One, stop one specific process\n"

read -n1 -p " " doit
echo -e "\n"

case $doit in
    Y|y) echo -e "\n\n Killing all processes \n" | STOP_ALL ;;
    O|o) echo -e "\n\n Selecting one specific process \n" ;;
    N|n) echo -e "\n\n Stopping no processes \n" ;;

    *) echo -e "\n Unkown input, please select one of the three options above \n" ;;
  * )
  esac

if [ $doit == "o" ]
then
        echo -e "Please enter a two letter word if you would like to stop a specific process\n ie for tp -tp \n for filehandler- fh\n for rdb1- r1 \n for rdb2- r2\n for cep-ce "
        read -n2 -ep " " s1

        case $s1 in
                tp) stopTP ;;
                fh) stopFH ;;
                r1) stopRDB ;;
                r2) stopRDB2 ;;
                ce) stopCEP ;;
                *) echo "No input detected, please try again";;
        esac
fi

exit 0
