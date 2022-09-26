
cdir:-4_first (system "pwd");
logDir : cdir,"/logs";
system "l ",cdir,"/kdb-common/log4q.q";
.log4q.a[hopen `$(":",logDir, "/data/rdb1.log");`DEBUG`INFO`SILENT`WARN`ERROR`FATAL ]

if[not "w"=first string .z.o;system "sleep 1"];

upd:{[t;x] if[t in tables[];t insert x]};


.u.x:.z.x ,(count .z.x)_(.z.x[0];.z.x[2]);

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
	system "cd ",1_-10_string first reverse y
    };


/ connect to ticker plant for (schema;(logcount;log))

.u.rep .(hopen `$("::", .u.x[1]))"((.u.sub[`Trade;`];.u.sub[`Quote;`]);`.u `i`L)";

