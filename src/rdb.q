 
if[not "w"=first string .z.o;system "sleep 1"];

upd:{[t;x] if[t in tables[];t insert x]};

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":6868";":5530");

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
.u.rep .(hopen `$"::6868")"((.u.sub[`trade;`];.u.sub[`quote;`]);`.u `i`L)";

