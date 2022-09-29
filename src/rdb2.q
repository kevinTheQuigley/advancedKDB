cdir:-4_first (system "pwd");
logDir : cdir,"/logs";
system "l ",cdir,"/kdb-common/log4q.q";
system "l ",cdir,"/src/sym.q";
.kq.Aggregation:Aggregation;
.log4q.a[hopen `$(":",logDir, "/data/rdb2.log");`DEBUG`INFO`SILENT`WARN`ERROR`FATAL`TEST ];



if[not "w"=first string .z.o;system "sleep 1"];


//upd:{[t;x] if[t in tables[]; select max  x]};
upd:{[x;y] if[(x = `Aggregation) &  (0 <  count y 0);
		.kq.y:y;
		$[16h=type .kq.y[0];
			data:{[input].kq.input:input; `.kq.Aggregation insert .kq.input}  .kq.y;
			data:{[input].kq.input:input; `.kq.Aggregation upsert enlist .kq.input} each y
			];
		//show("data is ";data);
		if[1< count .kq.input;
			Agg :0! select time:max time, maxTradePrice:max maxTradePrice,minTradePrice:min minTradePrice,tradedVolume:sum tradedVolume,maxBid:max maxBid,minAsk:min minAsk by sym from Aggregation upsert .kq.Aggregation;
			//Agg :select from `Aggregation,.kq.Aggregation;
			delete from `Aggregation;
			`Aggregation upsert select time,sym,maxTradePrice ,minTradePrice ,tradedVolume   ,maxBid,minAsk from Agg;
			.kq.Aggregation:delete from .kq.Aggregation;
		  ]
                ];

 };




.u.x:.z.x,(count .z.x)_(.z.x[0];.z.x[2]);

/ end of day: save, clear, hdb reload

//Maybe new data shouldn't be saved, it should be loaded from day to day 
//.u.end:{
//        t:tables`.;
//        t@:where `g=attr each t@\:`sym;
//        .Q.hdpf[`$";",(.u.x 1);hsym `$getenv[`DATADIR],"/hdb";x;`sym];
//        @[;`sym;`g#] each t
//    };


.u.rep:{
        (.[;();:;].) x;
        if[null first y;:()];
        -11!y;
        system "cd ",1_-10_string first reverse y;
   }; 


.u.rep .(hopen `$("::",.z.x[1]))"((.u.sub[`Aggregation;`]);`.u `i`L)";

