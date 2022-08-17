#!/bin/bash

KDIR=$(pwd)/..

#KDIR="$( cd "$(dirname "$0")" ; pwd -P )/.."
cd $KDIR

include () {
    if [[ ! -f "$1" ]] ; then
        echo "config "$1" not found, exit"
        exit 1
    fi
    echo $1
    source $1
}

include ${KDIR}/"config/env.sh"

mkdir -p $DATADIR
mkdir -p $DATADIR/logs

function RUN_ALL(){ 
    main tp
    sleep 2
    main fh 
    sleep 2 
    main rdb1
    sleep 2 
    main rdb2
    sleep 2
    main cep 
}

function main(){
    case $1 in
        tp)
        nohup $Q src/tick.q ${SCHEMA} ${DATADIR}/raw -p ${PORT_TP} -t ${TPTIMER} >> ${DATADIR}/logs/data/tp.log 2>&1 &
            echo $! > ${DATADIR}/logs/pids/tp.pid
        ;;
        fh)
        nohup $Q src/fh.q -p ${PORT_FH} >> ${DATADIR}/logs/data/feed.log 2>&1 &
            echo $! > ${DATADIR}/logs/pids/feed.pid
        ;;
        rdb1)
        nohup $Q src/r1.q :${PORT_TP} -p ${PORT_RDB1} >> ${DATADIR}/logs/data/rdb1.log 2>&1 &
            echo $! > ${DATADIR}/logs/pids/rdb1.pid
        ;;
        rdb2)
        nohup $Q src/r2.q :${PORT_TP} -p ${PORT_RDB2} >> ${DATADIR}/logs/data/rdb2.log 2>&1 &
            echo $! > ${DATADIR}/logs/pids/rdb2.pid
        ;;
        cep)
        nohup $Q src/cep.q -p ${PORT_CEP} >> ${DATADIR}/logs/data/cep.log 2>&1 &
            echo $! > ${DATADIR}/logs/pids/cep.pid
        ;;
      *)
    esac
}


case $1 in 
    ALL)
    RUN_ALL
    ;;
    ONE) 
    main ${2}   
    ;;
  * ) 
  esac 
  
exit 0
