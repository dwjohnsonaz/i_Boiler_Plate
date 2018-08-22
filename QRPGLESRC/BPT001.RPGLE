       // Boiler Plate Prototypes
       //====  BPMLB01 - Simple List Box  ====
       Dcl-PR BPMLB01    Char(11) End-PR;
       Dcl-DS BPMLB01DS;
         LB01NDX         Zoned(9);
         LB01EOJ         Char(2) Pos(10);
       End-DS;
       //====  BPMLB02 - Simple List Box w/Position To  ====
       Dcl-PR BPMLB02    Char(11) End-PR;
       Dcl-DS BPMLB02DS;
         LB02NDX         Zoned(9);
         LB02EOJ         Char(2) Pos(10);
       End-DS;
       //====  BPMLB03 - List Box w/Multi Select (10)  ===
       Dcl-PR BPMLB03    Char(92) End-PR;
       Dcl-DS BPMLB03DS;
         LB03NDX         Zoned(9) Pos(1) Dim(10) ;
         LB03EOJ         Char(2) Pos(91);
       End-DS;
       //====  BPMLB04 - List Box w/Multi Select (10)  ===
       Dcl-PR BPMLB04    Char(92) End-PR;
       Dcl-DS BPMLB04DS;
         LB04NDX         Zoned(9) Pos(1) Dim(10) ;
         LB04EOJ         Char(2) Pos(91);
       End-DS;
