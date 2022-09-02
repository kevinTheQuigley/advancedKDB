oldLog: get `:tplog 

newLog:oldLog[0+til 6],(enlist fixedRecord:oldLog[6],oldLog[7],oldLog[8]), enlist oldLog[9] 

newLog: {(`upd;`trade;@[ x;exec c from meta x where t ="c",c=`sym; {`$x } each ]) } each last each newLog 

newLog:{(`upd;`trade;@[ x; exec c from meta x where t = "f",c=`size;{"j"$x} each])} each last each newLog 

`:newLog set () 

h:hopen `:newLog 

h newLog 

Trade:([] sym:`$();price:"f"$();size:"j"$()) 

upd:insert 

-11!`:newLog 


