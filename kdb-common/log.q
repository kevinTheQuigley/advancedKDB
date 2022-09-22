proj.root: "/" sv -2_ "/" vs $["/"=first fn:string .z.f;fn;raze (system "pwd"),"/", fn];

system "l ",proj.root,"/common/uniq_log4q.q";

mem_usage:ssr[";" sv {"\n key: ",x," has value: ",(string y)} ' [string key .Q.w[];value .Q.w[]];";";" "];

.uniq_log4q.r[1;`INFO`DEBUG];
.uniq_log4q.a[hopen (hsym `$(proj.root,"/logs/connections/",(-2_(first -1#"/" vs string(.z.f))),".log"));`INFO`DEBUG];
 
.z.po: {
        .uniq_log4q.INFO("USER: %1; CONNECTION: %2; OPEN";(.z.u;.z.w));
        .uniq_log4q.INFO(mem_usage),"\n"};

.z.pc: {
        .uniq_log4q.INFO("USER: %1; CONNECTION: %2; CLOSED";(.z.u;x));
        .uniq_log4q.INFO(mem_usage),"\n"};

.log.sendToStdOutErr:{
    .uniq_log4q.a[1;`SILENT`DEBUG`INFO`WARN];
    .uniq_log4q.a[2;`ERROR`FATAL]};
