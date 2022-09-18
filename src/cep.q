

tph: hopen`$"::",getenv`PORT_TP;

upd:insert; 

.z.ts:{  
  
	AggretationData: 0!((select min_price:min price,max_price:max price,vol:sum size by sym from Trade) lj
  (select max_bid: max bid, min_ask: min ask by sym from Quote));

  tph(".u.upd";`Aggregation;value flip AggregationData); 
   }; 

sub_tbls:(`Trade`Quote);

setter:{[x]
    d:tph(`.u.sub;x;`);
    d[0] set d[1];
    } each sub_tbls;

\t 2000
