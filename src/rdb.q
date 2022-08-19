 
if[not "w"=first string .z.o;system "sleep 1"];

upd:{[t;x] if[t in tables[];t insert x]};

//Need the location of the tickerplant and the other rdb port
/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":6800";":6806");

/ end of day: save, clear, hdb reload
.u.end:{
	t:tables`.;
	t@:where `g=attr each t@\:`sym;
        .Q.hdpf[`$";",.u.x 1;hsym `$getenv[`DATADIR],"/hdb";x;`sym];
	@[;`sym;`g#] each t
    };

.u.rep:{
        (.[;();:;].)each x;
        if[null first y;:()];
        -11!y;
        system "cd ",1_-10_string first reverse y}
    ;


/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$"::6800")"((.u.sub[`Trade;`];.u.sub[`Quote;`]);`.u `i`L)";

