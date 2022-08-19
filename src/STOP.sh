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

#function main(){
#	case $1 in
#		tp)
#			kill `cat ${DATADIR}/logs/pids/tp.pid`
#			rm ${DATADIR}/logs/pids/tp.pid
#			;;
#		fh)
#			kill `cat ${DATADIR}/logs/pids/feed.pid`
#			rm ${DATADIR}/logs/pids/feed.pid
#			;;
#		rdb1)
#			kill `cat ${DATADIR}/logs/pids/rdb1.pid`
#			rm ${DATADIR}/logs/pids/rdb1.pid
#			;;
#		rdb2)
#			kill `cat ${DATADIR}/logs/pids/rdb2.pid`
#			rm ${DATADIR}/logs/pids/rdb2.pid
#			;;
#		cep)
#			kill `cat ${DATADIR}/logs/pids/cep.pid`
#			rm ${DATADIR}/logs/pids/cep.pid
#			;;
#    *)
#	esac
#}

read -n1 -p "Do you want to kill all processes? [A-ALL,T-Test]" doit


case $doit in
    A|a)
    STOP_ALL| echo -e "Killing all processes"
    ;;
    ONE)
    main $2
    ;;
    T)
    IS_ACTIVE TP ${DATADIR}/logs/pids/tp.pid
	sleep 1
	IS_ACTIVE FH ${DATADIR}/logs/pids/feed.pid
	sleep 1  
	IS_ACTIVE RDB1 ${DATADIR}/logs/pids/rdb1.pid
	sleep 1
	IS_ACTIVE RDB2 ${DATADIR}/logs/pids/rdb2.pid
	sleep 1 
	IS_ACTIVE CEP  ${DATADIR}/logs/pids/cep.pid
    ;;
  * )
  esac

exit 0
