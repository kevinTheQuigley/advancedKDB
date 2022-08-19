#!/bin/bash


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
	kill `cat ${DATADIR}/logs/pids/tp.pid`
        rm ${DATADIR}/logs/pids/tp.pid
	echo -e "Stopping the TP \n"
}


function stopFH() {
	kill `cat ${DATADIR}/logs/pids/feed.pid`
        rm ${DATADIR}/logs/pids/feed.pid
	echo -e "Stopping the Feedhandler \n"
}

function stopRDB() {
	kill `cat ${DATADIR}/logs/pids/rdb1.pid`
        rm ${DATADIR}/logs/pids/rdb1.pid
	echo -e "Stopping the rdb\n"
}

function stopRDB2() {
	kill `cat ${DATADIR}/logs/pids/rdb2.pid`
        rm ${DATADIR}/logs/pids/rdb2.pid
	echo -e "Stopping the rdb2\n"
}

function stopCEP() {
	kill `cat ${DATADIR}/logs/pids/cep.pid`
        rm ${DATADIR}/logs/pids/cep.pid
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


read -n1 -p "Do you want to kill all processes? [y - yes| n - no]" doit


case $doit in
    Y|y)
    STOP_ALL| echo -e "Killing all processes"
    ;;
    *)
	    echo -e "\n Not stopping all processes \n"
    ;;
  * )
  esac

if [ $doit == "n" ]
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
