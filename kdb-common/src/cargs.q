// Enhanced Command Line Argument Parser
// Copyright (c) 2019 Sport Trades Ltd

// Documentation: https://github.com/BuaBook/kdb-common/wiki/cargs.q

//.require.lib`type;


/ Cache of the command line arguments once they have been parsed once for improved performance on multiple calls
.cargs.cache:(`symbol$())!();
.cargs.cache[`get]:();
.cargs.cache[`getWithInternal]:();


/ This function provides additional parsing on top of the standard '.Q.opt' parsing for user-specified command line arguments
/  @returns (Dict) Argument parameter as keys with the argument values
/  @see .z.x
.cargs.get:{
    if[() ~ .cargs.cache`get;
        .cargs.cache[`get]:.cargs.i.parse .z.x;
    ];

    :.cargs.cache`get;
 };

/ This function provides addition parsing on top of the standard '.Q.opt' parsing for all command line arguments (including kdb
/ internal single-character arguments
/  @returns (Dict) Argument parameter as keys with the argument values
/  @see .z.X
.cargs.getWithInternal:{
    if[() ~ .cargs.cache`getWithInternal;
        .cargs.cache[`getWithInternal]:.cargs.i.parse .z.X;
    ];

    :.cargs.cache`getWithInternal;
 };


/ Command line argument parser with additional functionality on top of the standard '.Q.opt' parsing:
/  - Removes additional '-' when argument keys are specified in the more standard '--parameter' form
/  - All argument values are a string (10h) with multi-argument values joined with spaces between them
/  @returns (Dict) Argument parameter as keys with the argument values
/  @throws IllegalArgumentException If the input is not a mixed list of strings
/  @see .Q.opt
.cargs.i.parse:{[cmdArgsStr]
    if[not .type.isMixedList cmdArgsStr;
        '"IllegalArgumentException";
    ];

    cmdArgs:.Q.opt cmdArgsStr;
    cmdArgs:" " sv/: cmdArgs;

    cmdArgsK:key cmdArgs;
    cmdArgsK:@[cmdArgsK; where "-" = first each string cmdArgsK; { `$1_ string x }];

    :cmdArgsK!value cmdArgs;
 };
