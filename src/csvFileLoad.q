//cdir: "/" sv -2_ "/" vs $["/"=first fn:string .z.f;fn;raze (system "pwd"),"/", fn];
cdir:-4_first (system "pwd")


h1:hopen`::6800;
(neg h1)("upd";`Quote;value flip("SFFII";enlist ",")0:hsym`$cdir,"/src/Quote.csv");

exit 0; 

//I think this can be replaced by a one liner above
