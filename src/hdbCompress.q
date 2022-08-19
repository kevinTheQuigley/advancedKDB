cdir:-4_first (system "pwd")


system "l ", cdir,"/src/sym.q"
hdbLoc    : cdir,"/hdb/";
symfileLoc: cdir,"/logs/raw/";

upd:insert; 


-11!hsym `$(symfileLoc,"sym",.z.x 0); 

dir:hsym `$hdbLoc;

date:"D"$ .z.x 0;
.Q.dpft[dir;date;`sym]each tables`;

splay:raze ` sv/:' ((dir,`$string date),/:tables`),/:'(cols each tables`)except\: `time`sym;

{-19!(x;x;12;1;0)}each splay;

exit 0; 

// In order to replace the above functionality, I have a feeling 
//.compress.splay[hdbLoc;symfileLoc;`gzip;``inplace!(`;1b)]
