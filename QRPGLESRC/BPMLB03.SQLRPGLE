**FREE
       //* ----------------------------------------------------------------- *//
       //* After creating the POPUOM table and the BPDLB03 display file!     *//
       //* To create the module BPMLB03:                                     *//
       //* CRTSQLRPGI OBJ(BPLIB/BPMLB03) SRCFILE(BPLIB/QRPGLESRC)            *//
       //*            OBJTYPE(*MODULE) DBGVIEW(*SOURCE)                      *//
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMLB03) NOMAIN
               Debug
               Option(*NoDebugIO: *SrcStmt: *NoUnref)
               COPYRIGHT('SHandB, LLC 2017/2024');
       //  Boiler Plate List Box
       Dcl-F BPDLB03  WORKSTN SFILE(SFL01:XRRNS1) USROPN;
       //  Prototypes
       //Copy QRPGLESRC,BPT001
       //====  BPMLB03 - List Box w/Multi Select (10)  ===
       Dcl-PR BPMLB03    Char(92) End-PR;
       Dcl-DS BPMLB03DS;
         LB03NDX         Zoned(9) Pos(1) Dim(10) ;
         LB03EOJ         Char(2) Pos(91);
       End-DS;
       // Program data
       Dcl-DS PgmData                  qualified  Dim(50) ;
          PUOMIndex               Zoned(9:0) Inz;
          UOMID                    Char(3) Inz;
          UOMDESC                  Char(15) Inz;
          SEL01                    Char(1) Inz;
       End-DS;
       // Global Stand Alone Fields
       Dcl-S CsrSel                Char(256);
       Dcl-S End                    Int(5:0) Inz;
       Dcl-S Limit                  Int(3:0) Inz(10);
       Dcl-S Mult_Row               Int(5:0) Inz(50);
       Dcl-S NDX10                Zoned(9:0) Dim(10);
       Dcl-S O                      Int(5:0);
       Dcl-S P                      Int(5:0);
       Dcl-S S                      Int(5:0);
       Dcl-S SFL01P                 Int(5:0);
       Dcl-S SFL01Pg                Int(5:0) inz(5);
       Dcl-S SFL01Pgx2              Int(5:0) inz(10);
       Dcl-S SFL01B                 Int(5:0) inz;
       Dcl-S SFL01T                 Int(5:0) inz;
       Dcl-S SFL01Ind               Ind;
       Dcl-S SF1P                 Zoned(5:0) Inz;
       Dcl-S Tot_Read               Int(10:0) Inz;
       // ---------------------------------------------------------------------
       Dcl-Proc BPMLB03 EXPORT;
         Dcl-PI BPMLB03              Char(92);
         End-PI;
         //  Stand Alone Fields
         Dcl-S EOJ                   Char(2);
         Dcl-S NDXUOM               Zoned(9:0);
         Dcl-S OpenUOM                Ind;
         Dcl-S Rc                     Ind  Inz('0') ;
         // ---------------------------------------------------------------------
         GetData();
         //
         If Tot_Read > *Zero;
           If NOT %Open(BPDLB03);
             Open BPDLB03;
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
             *IN27 = *ON;
             *IN28 = *ON;
             Write WIN01;
             Exfmt CTL01;
             *IN28 = *OFF;
             *IN27 = *OFF;
             UPDSEL();
             Select;
               When *IN05 = *ON;
                 P = *Zero ;
                 For S = 1 to Tot_Read;
                   If PgmData(S).SEL01  <> *Blanks;
                     If P < Limit ;
                       P += 1;
                       LB03NDX(P) = PgmData(S).PUOMIndex ;
                     EndIf ;
                   EndIf ;
                 EndFor;
                 SFL01IND = *OFF ;
                 If P > *Zero;
                   EOJ = '**' ;
                 Else ;
                   EOJ = 'NS' ;
                 EndIf;
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
                      If SFL01P > SFL01pgX2;
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
               EndSl;
             EndDo;
           EndIf;
           // Close the display file
           If %Open(BPDLB03);
             Close BPDLB03;
           EndIf;
           If EOJ <> '**' ;
              LB03NDX = *Zeros;
           EndIf;
           LB03EOJ = EOJ;
           Return BPMLB03DS;
          End-Proc BPMLB03;
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
            If P < Tot_Read;
               For O = 1 to SFL01Pg ;
                 P += 1;
                 If PgmData(P).PUOMIndex <> *Zeros;
                   SF1H01 = PgmData(P).PUOMIndex;
                   SF1UOM = PgmData(P).UOMID ;
                   SF1DSC = PgmData(P).UOMDESC ;
                   SF1SEL = PgmData(P).SEL01 ;
                   XRRNS1 += 1;
                   SF1P = P;                   
                   SFL01B = O;
                   Write SFL01 ;
                 EndIf;
               EndFor;
            EndIf;
            If P >= Tot_Read;
             *IN30 = *ON;
            Else; 
              *IN30 = *OFF;
            EndIf;  
         End-Proc LoadSFL01;
         //*----------------------------------------------------------
         // Update The Select Field
         //*----------------------------------------------------------
         Dcl-Proc UpdSel ;
           //
           For O = 1 to SFL01B;
             Chain O SFL01 ;
             If %Found();
               PgmData(SF1P).SEL01 = SF1SEL ;
             EndIf;
           EndFor;
          End-Proc UpdSel ;
          //*--------------------------------------------------------
          // GetData - Get the data
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
            Exec SQL declare CurBP03 cursor for wkStatement ;
            // *
            Exec SQL open CurBP03 ;
            // *
            Exec SQL fetch next from CurBP03 For :Mult_Row rows into :PgmData;  
            //
            Exec SQL Get Diagnostics :Tot_Read = ROW_COUNT ;
            //
            Exec SQL close CurBP03;
            //
          End-Proc GetData;
          //------------------------------------------------------------