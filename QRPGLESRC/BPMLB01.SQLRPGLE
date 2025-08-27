**FREE
         //* ----------------------------------------------------------------- *//
         //* After creating the POPUOM table and the BPDLB01 display file!     *//
         //* To create the module BPMLB01:                                     *//
         //* CRTSQLRPGI OBJ(BPLIB/BPMLB01) SRCFILE(BPLIB/QRPGLESRC)            *//
         //*            OBJTYPE(*MODULE) DBGVIEW(*SOURCE)                      *//
         //* ----------------------------------------------------------------- *//
         Ctl-Opt DFTNAME(BPMLB01) NOMAIN
               Debug
               Option(*NoDebugIO: *SrcStmt: *NoUnref)
               COPYRIGHT('SHandB, LLC 2025/2032');
         //  Boiler Plate List Box
         Dcl-F BPDLB01  WORKSTN SFILE(SFL01:XRRNS1) USROPN;
         //  Prototypes
         /Copy '/i_Boiler_Plate/QRPGLESRC,BPT001'
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
         Dcl-S Sfl01P                 Int(5:0);
         Dcl-S Sfl01Pg                Int(5:0) inz(5);
         Dcl-S Sfl01Pgx2              Int(5:0) inz(10);
         Dcl-S SFL01B                 Int(5:0) inz;
         Dcl-S SFL01T                 Int(5:0) inz;
         Dcl-S SFL01Ind               Ind;
         Dcl-S Tot_Read               Int(10:0) Inz;
         // ---------------------------------------------------------------------
         Dcl-Proc BPMLB01 EXPORT;
           // 
           Dcl-PI BPMLB01              Char(11);
           End-PI;
           //  Stand Alone Fields
           Dcl-S EOJ                   Char(2);
           Dcl-S NDXUOM               Zoned(9:0);
           Dcl-S OpenUOM                Ind;
           Dcl-S Rc                     Ind  Inz('0') ;
           // ---------------------------------------------------------------------
           // Get the data
           GetData();
           //
           If Tot_Read > *Zero;
             If NOT %Open(BPDLB01);
               Open BPDLB01;
             EndIf;
             //
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
                      P = P - (SFL01pg + SFL01B);
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
           // Close the display file
           Close BPDLB01;
         EndIf;
         //
         If EOJ <> '**' ;
           LB01NDX = *Zeros;
         Else;
           LB01NDX = NDXUOM;
         EndIf;
         LB01EOJ = EOJ;
         //
           Return BPMLB01DS;
         End-Proc BPMLB01;
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
         For O = 1 to SFL01PG;
           If P < Tot_Read;
             P += 1;
             If PgmData(P).PUOMIndex <> *Zeros;
               SF1H01 = PgmData(P).PUOMIndex;
               SF1UOM = PgmData(P).UOMID ;
               SF1DSC = PgmData(P).UOMDESC ;
               XRRNS1 += 1;
               SFL01P = P;
               SFL01B = O;
               Write SFL01 ;
             EndIf;
           EndIf;
         EndFor;
         //
         If SFL01P >= Tot_Read;
           *IN30 = *ON;
         Else;
           *IN30 = *OFF;
         EndIf;
         //
       End-Proc LoadSFL01;
       //*--------------------------------------------------------
       // Get the Data
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
       Exec SQL declare Cursor scroll cursor for wkStatement ;
       // *
       Exec SQL open Cursor ;
       //
       Exec SQL fetch next from Cursor For :Mult_Row rows into :PgmData;
       //
       Exec SQL Get Diagnostics :Tot_Read = ROW_COUNT ;
       //
       Exec SQL close Cursor;
       //
       End-Proc GetData;
       //-----------------------------------------------------------------