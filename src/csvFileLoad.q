//cdir: "/" sv -2_ "/" vs $["/"=first fn:string .z.f;fn;raze (system "pwd"),"/", fn];
cdir:-4_first (system "pwd")

port:system"cat env.sh| grep PORT_TP | awk -F '=' '{print $2}'"

h1:hopen first -7h $port;
(neg h1)(".u.upd";`Quote;value flip("SFFII";enlist ",")0:hsym`$cdir,"/src/Quote.csv");


//I think this can be replaced by a one liner above
