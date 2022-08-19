#!/bin/bash

KDIR=$(pwd)/..
SRC=$(pwd)
#KDIR="$( cd "$(dirname "$0")" ; pwd -P )/.."
#cd $KDIR

include () {
    if [[ ! -f "$1" ]] ; then
        echo "config "$1" not found, exit"
        exit 1
    fi
    echo $1
    source $1
}

include $SRC"/env.sh"

mkdir -p $DATADIR
mkdir -p $DATADIR/logs
mkdir -p $DATADIR/logs/pids

#function RUN_ALL(){ 
#    main tp
#    sleep 2
#    main fh 
#    sleep 2 
#    main rdb1
#    sleep 2 
#    main rdb2
#    sleep 2
#    main cep 
#}


function RUN_ALL(){ 
	startTP
    	sleep 2
	startFH
    	sleep 2 
    	startRDB
    	sleep 2 
    	startRDB2
    	sleep 2
    	startCEP
}

function startTP() {
	nohup q ./tick.q ${SCHEMA} ${DATADIR}/raw -p ${PORT_TP} -t ${TPTIMER} >> ${DATADIR}/logs/data/tp.log 2>&1 &
        echo $! > ${DATADIR}/logs/pids/tp.pid
	echo -e "Starting the TP \n"
 }


function startFH() {
	nohup q ./fh.q -p ${PORT_FH} >> ${DATADIR}/logs/data/feed.log 2>&1 &
        echo $! > ${DATADIR}/logs/pids/feed.pid
	echo -e "Starting the FH \n"
 }

function startRDB() {
        nohup q ./rdb.q :${PORT_TP} -p ${PORT_RDB1} >> ${DATADIR}/logs/data/rdb1.log 2>&1 &
        echo $! > ${DATADIR}/logs/pids/rdb1.pid
	echo -e "Starting the RDB \n"
 }

function startRDB2() {
	nohup q ./rdb2.q :${PORT_TP} -p ${PORT_RDB2} >> ${DATADIR}/logs/data/rdb2.log 2>&1 &
        echo $! > ${DATADIR}/logs/pids/rdb2.pid
	echo -e "Starting the RDB2 \n"
 }

function startCEP() {
        nohup q ./cep.q -p ${PORT_CEP} >> ${DATADIR}/logs/data/cep.log 2>&1 &
        echo $! > ${DATADIR}/logs/pids/cep.pid
	echo -e "Starting the CEP \n"
 }


#function main(){
#    case $1 in
#        tp)
#        nohup q ./tick.q ${SCHEMA} ${DATADIR}/raw -p ${PORT_TP} -t ${TPTIMER} >> ${DATADIR}/logs/data/tp.log 2>&1 &
#      	echo $! > ${DATADIR}/logs/pids/tp.pid
#        ;;
#        fh)
#        nohup $Q ./fh.q -p ${PORT_FH} >> ${DATADIR}/logs/data/feed.log 2>&1 &
#            echo $! > ${DATADIR}/logs/pids/feed.pid
#        ;;
#        rdb1)
#        nohup $Q ./r1.q :${PORT_TP} -p ${PORT_RDB1} >> ${DATADIR}/logs/data/rdb1.log 2>&1 &
#            echo $! > ${DATADIR}/logs/pids/rdb1.pid
#        ;;
#        rdb2)
#        nohup $Q ./r2.q :${PORT_TP} -p ${PORT_RDB2} >> ${DATADIR}/logs/data/rdb2.log 2>&1 &
#            echo $! > ${DATADIR}/logs/pids/rdb2.pid
#        ;;
#        cep)
#        nohup $Q ./cep.q -p ${PORT_CEP} >> ${DATADIR}/logs/data/cep.log 2>&1 &
#            echo $! > ${DATADIR}/logs/pids/cep.pid
#        ;;
#      *)
#    esac
#}


#if $1==1:
#    ALL)
#    RUN_ALL
#    ;;
#    ONE) 
#    main ${2}   
#    ;;
#  * ) 
#  esac 

read -n1 -p "Do you want to start all processes? [y,n]" doit 
echo -e "/n"
case $doit in  
  y|Y) echo -e "yes \n" |RUN_ALL;; 
  n|N) echo no ;; 
  *) echo dont know ;; 
esac
exit 0
