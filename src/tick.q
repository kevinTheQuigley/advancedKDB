//cdir:-4_ first (system "pwd")
//cdir:"/home/ubuntu/KQKDB";
cdir:-4_first (system "pwd")
//Some very very extremely strange non-replay-ability going on. Resolved by resetting the value of cdir
system "l ",cdir,"/src/sym.q";
system "l ",cdir,"/kdb-tick-master/tick/u.q"; 
system "l ",cdir,"/log4q-master/log4q.q";
//Below may be tricky, watch .cron jobs
system "l ",cdir,"/kdb-common/src/type.q";
system "l ",cdir,"/kdb-common/src/time.q";
system "l ",cdir,"/kdb-common/src/util.q";
system "l ",cdir,"/kdb-common/src/ns.q";
system "l ",cdir,"/kdb-common/src/convert.q";
system "l ",cdir,"/kdb-common/src/cron.q";
system "l ",cdir,"/kdb-common/src/cargs.q";
system "l ",cdir,"/kdb-common/src/log.q";
system "l ",cdir,"/kdb-common/src/time.util.q";

symFile: "sym";
logDir : cdir,"/logs";
rawDir : logDir,"/raw";

//if[not system"p";system"p 6800"]

\d .u

tbl_counter:()!();

ld:{[date]
     if[not type key L :: `$(-10_string L),string date;
        .[L;();:;()]
       ];
       i::j::-11!(-2;L);
     if[0<=type i;
        -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
        exit 1
       ];
     hopen L
  };

tick:{[symFile;rawDir]
     init[];
    / if[not min(`time~ first 1#key flip value@)each t;
    /    '`time
    /    ];
     @[;`sym;`g#]each t;
     d::.z.D;
     if[l::count rawDir;
        L::`$":",rawDir,"/",symFile,10#".";
        l::ld d
       ]
  };

endOfDay:{
     end d;
     d+:1;
     if[l;
        hclose l;
        l::0(`.u.ld;d)
       ]
  };

ts:{
     if[d<x;
        if[d<x-1;
           system"t 0";
           '"more than one day?"
          ];
        endOfDay[]
       ]
  };

logger:{
        
        {
 		 .log4q.INFO("current subscribers for ",(string x),": ",("" sv {"%",(string x)} each 1+ til (count .u.w[x]));.u.w[x]);
         .log4q.INFO("current messages processed by table ",(string x),": ",(string (tbl_counter[x])));
        }each tables[]
  
  };


set_tick:1; 

//if[set_tick;
tp_tick:{
   .u.pub'[t;value each t];
   @[`.;t;@[;`sym;`g#]0#];
   i::j;
   .u.ts .z.D;
   };
upd:{[t;x]
  if[not -16=type first first x;
     if[d<"d"$a:.z.P;
        .z.ts[]
       ];
     a:"n"$a;
     x:$[0>type first x;
         a,x;
         (enlist(count first x)#a),x]
    ];
  t insert x;
  tbl_counter[t]+:1;
  if[l;
     l enlist (`upd;t;x);
     j+:1];
 }


if[not system"t";
    system"t 1000";
    .z.ts:{ts .z.D};
    upd:{[t;x]
         .u.ts"d"$a:.z.P;
         if[not -16=type first first x;
            a:"n"$a;
            x:$[0>type first x;
                a,x;
                (enlist(count first x)#a),x]
            ];
         f:key flip value t;
	 .u.pub[t;$[0>type first x;
             enlist f!x;
             flip f!x]
            ];
         if[l;
            l enlist (`upd;t;x);
            i+:1];
         }
    ];


pub:{[t;x]{[t;x;w]if[count x:.u.sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each .u.w .u.t}

init:{w::t!(count t::tables`.)#()}

del:{w[x]_:w[x;;0]?y};.z.pc:{del[;x]each t};

sel:{$[`~y;x;select from x where sym in y]}

pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each w t}

add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])}

sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}

end:{(neg union/[w[;;0]])@\:(`.u.end;x)}


\d .
upd:.u.upd
.u.tick[symFile;rawDir];

//setting smallest cron timer interval
//.cron.cfg.timerInterval:59;

echoFunc:{[]show"CronJob Added"}

//.cron.add[	`.u.tp_tick	;(::);`repeat;.z.p;0Np;`timespan$`minute$1];
.cron.add[	`.u.tp_tick	;(::);`repeat;.z.p;0Np;`timespan$`second$1];
.cron.add[	`echoFunc	;(::);`repeat;.z.p;0Np;`timespan$`second$1];

//.cron.add[	`.u.logger	;(::);`repeat;.z.p;0Np;`timespan$`minute$1];
.cron.add[	`.u.logger	;(::);`repeat;.z.p;0Np;`timespan$`second$1];
