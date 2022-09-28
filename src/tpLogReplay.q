if[(symfile:.z.x 0)~();
  "The log file should be passed as  symXXX.XX.XX as arg";
  //exit 0;
 ];

cdir:-4_first (system "pwd")

logLocation : cdir,"/logs/raw";
system "l ",cdir,"/src/sym.q";


newGeneratedSym:{[directory;fileName] 
	
    new_file : fileName,"_IBM";
    new_file : (hsym `$(directory,"/",new_file)) set (); 
    h::hopen new_file;
	
    -11!(hsym `$(directory,"/",fileName));
    hclose h;
   };


upd:{[t;x]
  if[t in (`Trade`Quote);
	{if[`IBM.n ~ (first 1_2#(x));
           h enlist(`upd;y;x)]  }[;t]each flip x
      ]
   };

newGeneratedSym[logLocation;symfile]
