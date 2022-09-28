cdir:-4_first (system "pwd");
logDir : cdir,"/logs";
system "l ",cdir,"/kdb-common/log4q.q";
.log4q.a[hopen `$(":",logDir, "/data/cep.log");`DEBUG`INFO`SILENT`WARN`ERROR`FATAL`TEST ]


system "l ",cdir,"/src/sym.q";




tph: hopen`$"::",.z.x[0];

tph(`.u.sub;`;`)

//upd:{[x;y] $[x=`Trade;delete from `Trade;delete from `Quote]   ;x insert y}; 
.kq.lim:2;

upd:{[x;y] if[x = `Aggregation; 
		//show(x;y);
		data:{[input].kq.input:input; `.kq.Aggregation upsert enlist .kq.input} each y;
		//show("data is ";data);
		Agg :0! select time:max time, maxTradePrice:max maxTradePrice,minTradePrice:min minTradePrice,tradedVolume:sum tradedVolume,maxBid:max maxBid,minAsk:min minAsk by sym from Aggregation upsert .kq.Aggregation;
		//Agg :select from `Aggregation,.kq.Aggregation;
		delete from `Aggregation;
		`Aggregation upsert select time,sym,maxTradePrice ,minTradePrice ,tradedVolume   ,maxBid,minAsk from Agg;

		.kq.Aggregation:delete from .kq.Aggregation
		];
	if[(x in `Trade`Quote);x insert y];

	//if[(x in `Trade`Quote) && first value max value (d1:select Tot:count i by sym from x)>.kq.lim; 
	//if[(x in `Trade`Quote) & first value max value (d1:select Tot:count i by sym from x)>.kq.lim; 
	//	symS:first (select sym  from 0!d1 where Tot>.kq.lim)`sym;
	//	delete from x where sym = symS,i in (i[0],i[1])  
	//];
 }; 

.z.ts:{  
	//Trade:neg tph"Trade"
	//Quote:neg tph"Quote"
  
	AggregationData: 0!((select maxTradePrice:max price,minTradePrice:min price,tradedVolume:sum size by sym from Trade) lj
	(select maxBid: max bid, minAsk: min ask by sym from Quote));
	if[(count AggregationData) >1;1+1; delete from `Trade where sym in AggregationData`sym;delete from `Quote where sym in AggregationData`sym]

  tph(".u.upd";`Aggregation;value flip AggregationData); 
   }; 

sub_tbls:(`Trade`Quote);

setter:{[x]
    d:tph(`.u.sub;x;`);
    d[0] set d[1];
    } each sub_tbls;

\t 3000
.kq.Aggregation:Aggregation;
