
cdir:-4_ first (system "pwd")

system "l ",cdir,"/src/sym.q";
system "l ",cdir,"/kdb-tick-master/tick/u.q"; 
system "l ",cdir,"/log4q-master/log4q.q";
//Below may be tricky, watch .cron jobs
system "l ",cdir,"/kdb-common/src/cron.q";
system "l ",cdir,"/kdb-common/src/log.q";

symFile     : "sym";
logDir : cdir,"/logs";
rawDir : logDir,"/raw";

if[not system"p";system"p 6868"]

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

.u.tick[symFile;rawDir];
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

if[set_tick;
    tp_tick:{
       pub'[t;value each t];
       @[`.;t;@[;`sym;`g#]0#];
       i::j;
       ts .z.D;
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
   ];


if[not system"t";
    system"t 1000";
    .z.ts:{ts .z.D};
    upd:{[t;x]
         ts"d"$a:.z.P;
         if[not -16=type first first x;
            a:"n"$a;
            x:$[0>type first x;
                a,x;
                (enlist(count first x)#a),x]
            ];
         f:key flip value t;
         pub[t;$[0>type first x;
             enlist f!x;
             flip f!x]
            ];
         if[l;
            l enlist (`upd;t;x);
            i+:1];
         }
    ];

\d .
.u.tick[symFile;rawDir];
.cron.add[".u.tp_tick[]";0;`repeat;`long$1];
.cron.add[".u.logger[]";5;`repeat;`long$60];
