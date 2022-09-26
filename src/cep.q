cdir:-4_first (system "pwd");
logDir : cdir,"/logs";
system "l ",cdir,"/kdb-common/log4q.q";
.log4q.a[hopen `$(":",logDir, "/data/cep.log");`DEBUG`INFO`SILENT`WARN`ERROR`FATAL ]


system "l ",cdir,"/src/sym.q";




tph: hopen`$"::",.z.x[0];

tph(`.u.sub;`;`)

upd:{[x;y] $[x=`Trade;delete from `Trade;delete from `Quote]   ;x insert y}; 

.z.ts:{  
	//Trade:neg tph"Trade"
	//Quote:neg tph"Quote"
  
	AggregationData: 0!((select min_price:min price,max_price:max price,vol:sum size by sym from Trade) lj
  (select max_bid: max bid, min_ask: min ask by sym from Quote));

  tph(".u.upd";`Aggregation;value flip AggregationData); 
   }; 

sub_tbls:(`Trade`Quote);

setter:{[x]
    d:tph(`.u.sub;x;`);
    d[0] set d[1];
    } each sub_tbls;

\t 1000
