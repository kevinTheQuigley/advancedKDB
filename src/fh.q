
cdir:-4_first (system "pwd");
logDir : cdir,"/logs";
system "l ",cdir,"/kdb-common/log4q.q";
.log4q.a[hopen `$(":",logDir, "/data/fh.log");`DEBUG`INFO`SILENT`WARN`ERROR`FATAL`TEST ]
system "l ./sym.q"

.log.sendToStdOutErr:.log4q.INFO


//opening connection to TP

tp     : neg hopen `$("::",.z.x[0]) /connect to tickerplant

//Setting the syms
syms   : `FH.l`FEED.L`FDHNDLR.Y`GM.E`IBM.n /stocks

//Setting the starting prices of all syms (Extremelely accurately)
prices : syms!100.01 101.02 1.50 100280.04 420.69 

//Setting the number of rows
numRow : .u.tSize;

// Sets the ratio of trades to Quotes to 4:1
ratio   : 2;

/initiate a change in price from it's previous value

priceChamge:{[s] rand[0.1]*prices[s]} 

/generate Trade price
setNewPrice:{[s] prices[s]+:rand[1 -1]*priceChamge[s]; prices[s]}
setBidPrice:{[s] prices[s]-priceChamge[s]} /generate bid price
setAskPrice:{[s] prices[s]+priceChamge[s]} /generate ask price

/timer function
.z.ts:{
	s:numRow?syms;
	$[0<ratio mod 10;
	   tp(".u.upd";`Quote;(numRow#.z.N;s;setBidPrice'[s];setAskPrice'[s];numRow?1000;numRow?1000));
	   tp(".u.upd";`Trade;(numRow#.z.N;s;setNewPrice'[s];numRow?1000))
	];
        ratio+:1;
      };

/trigger should be active every 2 seconds
//\t 2000
/Can temporarily be set to 0
\t 1000
