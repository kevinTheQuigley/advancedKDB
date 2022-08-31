# Advanced KDB - Kevin Quigley

Hello and welcome to my repo generating solutions to the Advanced KDB exam from First Derivatives

Q Common libraries taken from https://github.com/BuaBook/kdb-common/tree/master/src

Q Tick libraries taken from https://github.com/KxSystems/kdb-tick


Before Reading responses below, a dry run can be completed by running 
bash ./src/START.sh






Q1 - Tickerplant   

Tickerplant is defined in /src/tick.q. The schema for all other tables is defined in sym.q. During startup, the ports are set in env.sh. 

Q2 - RDB 

The RDBs are defined in src/rdb.q and src/rdb2.q 

Q3 Feed handler 

Feedhandler is defined in fh.q 

Q 4 CEP 

CEP is defined in src/cep.q 

For TP logging every minute .logs/data/tp.log  

Q5 Logging   

Location - /kdb-common/log.q  

Output location - /adv_kdb/logs/connections/tick.log   

The logger is loaded into the tickerplant as an example – can be loaded into any component.  

Q6 Startup Shutdown scripts   

Start, stop and test scripts are divided into three separate scripts  

Upon starting a process, the pid for the process will be stored in /adv_kdb/logs/pids  

Run commands: 

 .cd src/ 

Bash START.sh -> input y to start all process, input n with any combination of two letter prompt to start a different process, ie tp starts the tickerplant. The instructions are mentioned in the prompts 

Bash STOP.sh -> input y to stop all process, input n with any combination of two letter prompt to stop a different process, ie tp starts the tickerplant. The instructions are mentioned in the prompts 

Bash TEST.sh -> input n with any combination of two letter prompt to test a different process, ie tp starts the tickerplant. The instructions are mentioned in the prompts 
