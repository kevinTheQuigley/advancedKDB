

tph: hopen`$"::",getenv`PORT_TP;

upd:insert; 

.z.ts:{  
  
	Aggretation: 0!((select min_price:min price,max_price:max price,vol:sum size by sym from trade) lj
  (select max_bid: max bid, min_ask: min ask by sym from Quote));

  tph(".u.upd";`Aggregation;value flip Aggregation); 
   }; 

sub_tbls:(`Trade`Quote);

setter:{[x]
    d:tph(`.u.sub;x;`);
    d[0] set d[1];
    } each sub_tbls;

\t 2000