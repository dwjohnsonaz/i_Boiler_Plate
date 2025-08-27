**FREE
       //* ----------------------------------------------------------------- *//
       //* After creating the POPUOM table and the BPDLB01 display file!     *//
       //* To create the module BPMLB02:                                     *//
       //* CRTSQLRPGI OBJ(BPLIB/BPMLB02) SRCFILE(BPLIB/QRPGLESRC)            *//
       //*            OBJTYPE(*MODULE) DBGVIEW(*SOURCE)                      *//
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMLB02) NOMAIN
               Debug
               Option(*NoDebugIO: *SrcStmt: *NoUnref)
               COPYRIGHT('SHandB, LLC 2025/2032');
       //  Boiler Plate List Box
       Dcl-F BPDLB02  WORKSTN SFILE(SFL01:XRRNS1) USROPN;
       //  Prototypes
       //Copy QRPGLESRC,BPT001
       //====  BPMLB02 - Simple List Box w/Position To  ====
       Dcl-PR BPMLB02    Char(11) End-PR;
       Dcl-DS BPMLB02DS;
         LB02NDX         Zoned(9);
         LB02EOJ         Char(2) Pos(10);
       End-DS;
       // Program data
       Dcl-DS PgmData                  qualified  Dim(50) ;
          PUOMIndex               Zoned(9:0) Inz;
          UOMID                    Char(3) Inz;
          UOMDESC                  Char(15) Inz;
       End-DS;
       // Global Stand Alone Fields
       Dcl-S CsrSel                Char(256);
       Dcl-S End                    Int(5:0) Inz;
       Dcl-S Mult_Row               Int(5:0) Inz(50);
       Dcl-S NDXUOM               Zoned(9:0) Inz;
       Dcl-S O                      Int(5:0);
       Dcl-S P                      Int(5:0);
       Dcl-S S                      Int(5:0);
       Dcl-S SFL01P                 Int(5:0);
       Dcl-S SFL01Pg                Int(5:0) inz(5);
       Dcl-S SFL01Pgx2              Int(5:0) inz(10);
       Dcl-S SFL01B                 Int(5:0) inz;
       Dcl-S SFL01T                 Int(5:0) inz;
       Dcl-S SFL01Ind               Ind;
       Dcl-S Tot_Read               Int(10:0) Inz;
       // ---------------------------------------------------------------------
       Dcl-Proc BPMLB02 EXPORT;
         //
         Dcl-PI BPMLB02              Char(11);
         End-PI;
         //  Stand Alone Fields
         Dcl-S EOJ                   Char(2);
         Dcl-S NDXUOM               Zoned(9:0);
         Dcl-S OpenUOM                Ind;
         Dcl-S Rc                     Ind  Inz('0') ;
         // ---------------------------------------------------------------------
         GetData();
         If Tot_Read > *Zero;
           If NOT %Open(BPDLB02);
             Open BPDLB02;
           EndIf;
           P = *Zero;
           LoadSFL01();
           //
           SFL01ind = *ON;
           //
           DoW SFL01Ind = *ON;
             // Start at the top of the list
             XRRNS1 = 1;
             // Display the subfile
             Write WIN01;
             *IN27 = *ON;
             *IN28 = *ON;
             Exfmt CTL01;
             *IN28 = *OFF;
             *IN27 = *OFF;
             Select;
               // If previous was selected
               When *IN12 = *ON;
                  EOJ = '12';
                  SFL01ind = *OFF;
                  // Execute roll up (page down)
               When *IN26 = *ON;
                  If P < Tot_Read;
                     LoadSFL01();
                  EndIf;
                  // Execute roll down (page up)
               When *IN25 = *ON;
                  Select;
                    When *IN30 = *ON;
                      P = P - (SFL01Pg + SFL01B);
                      LoadSFL01();
                    When SFL01P > SFL01Pg;
                     If SFL01P > SFL01PgX2;
                        P = P - SFL01PgX2 ;
                        LoadSFL01();
                        Else;   //* Go to the top
                        P = *Zero;
                        LoadSFL01();
                     EndIf;
                   Other;   //* Go to the top
                     P = *Zero;
                     LoadSFL01();
                  EndSl;
               When PositionTo <> *BLanks;
                 For S = 1 to Tot_Read;
                   If PgmData(S).UOMID >= PositionTo ;
                     P = S - 1;
                     LoadSFL01() ;
                     PositionTo = *Blanks ;
                     Leave;
                   EndIf;
                 EndFor;
               When RELREC <> *Zero;
                 Chain RELREC SFL01;
                 If %Found() and SF1H01 > *Zero and SF1SEL <> *Blank;
                   EOJ = '**' ;
                   NDXUOM = SF1H01;
                   SFL01ind = *OFF;
                   If SF1SEL <> *Blank;
                     Clear SF1SEL;
                     Update SFL01;
                   EndIf;
                 EndIf;
            EndSl;
          EndDo;
         EndIf;
         // Close the display file
         If %Open(BPDLB02);
           Close BPDLB02;
         EndIf;
         If EOJ <> '**' ;
           LB02NDX = *Zeros;
         Else;
           LB02NDX = NDXUOM;
         EndIf;
         LB02EOJ = EOJ;
         Return BPMLB02DS;
         End-Proc BPMLB02;
         //*----------------------------------------------------------
         // Load the subfile
         //*----------------------------------------------------------
         Dcl-Proc LoadSFL01;
            // Clear out the subfile
            *IN29 = *ON;
            Write CTL01;
            *IN29 = *OFF;
            XRRNS1 = *ZERO;
            // Build the window subfile
            For O = 1 to SFL01Pg ;
              If P < Tot_Read;
                P += 1;
                If PgmData(P).PUOMIndex <> *Zeros;
                  SF1H01 = PgmData(P).PUOMIndex;
                  SF1UOM = PgmData(P).UOMID ;
                  SF1DSC = PgmData(P).UOMDESC ;
                  XRRNS1 += 1;
                  Write SFL01 ;
                  SFL01B = O;
                  SFL01P = P;
                EndIf;
              EndIf;
            EndFor;
           //
           If SFL01P >= Tot_Read;
             *IN30 = *ON;
           Else; 
             *IN30 = *OFF;
           EndIf;
        End-Proc LoadSFL01;
        //*--------------------------------------------------------
        // GetData - Get the Data 
        //*--------------------------------------------------------
        Dcl-Proc GetData;
          //
          CsrSel = 'Select PUOMINDEX, UOMID, UOMDESC ' +
                   'From POPUOM ' +
                   'Order By UOMID ' +
                   'For Read Only' ;
          //
          Exec SQL prepare wkStatement from :CsrSel ;
          // *
          Exec SQL declare CsrBP02 cursor for wkStatement ;
          // *
          Exec SQL open CsrBP02 ;
          // *
          Exec SQL fetch next from CsrBP02 For :Mult_Row rows into :PgmData;
          //
          Exec SQL Get Diagnostics :Tot_Read = ROW_COUNT ;
          //
          Exec SQL close CsrBP02;
          //
      End-Proc GetData;
      //-----------------------------------------------------------------