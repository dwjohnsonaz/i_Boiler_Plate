       //* ----------------------------------------------------------------- *//
       //* After creating the POPUOM table and the BPDLB04 display file!     *//
       //* To create the module BPMLB04:                                     *//
       //* CRTSQLRPGI OBJ(BPLIB/BPMLB04) SRCFILE(BPLIB/QRPGLESRC)            *//
       //*            OBJTYPE(*MODULE) DBGVIEW(*SOURCE)                      *//
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMLB04) NOMAIN
               Debug
               Option(*NoDebugIO: *SrcStmt)
               COPYRIGHT('SHandB, LLC 2017/2024');
       //  Boiler Plate List Box with Multi Selects and Position To
       Dcl-F BPDLB04  WORKSTN SFILE(SFL01:XRRNS1) USROPN;
       //  Prototypes
      /Copy QRPGLESRC,BPT001
       Dcl-PR CloseLB4  End-PR ;
       Dcl-PR FetchMultLB4 Ind End-PR;
       Dcl-PR OpenLB4 End-PR ;
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
       Dcl-S Sf1Last                Int(5:0);
       Dcl-S SflPg                  Int(5:0) inz(5);
       Dcl-S SflPgx2                Int(5:0) inz(10);
       Dcl-S Sfl1B                  Int(5:0) inz;
       Dcl-S Sfl1T                  Int(5:0) inz;
       Dcl-S Sfl1Ind                Ind;
       Dcl-S Tot_Read               Int(10:0) Inz;
       // ---------------------------------------------------------------------
       Dcl-Proc BPMLB04 EXPORT;
         Dcl-PI BPMLB04              Char(92);
         End-PI;
         //  Stand Alone Fields
         Dcl-S EOJ                   Char(2);
         Dcl-S NDXUOM               Zoned(9:0);
         Dcl-S OpenUOM                Ind;
         Dcl-S Rc                     Ind  Inz('0') ;
         // ---------------------------------------------------------------------
            If NOT %Open(BPDLB04);
               Open BPDLB04;
            EndIf;
            // Set the SQL cursor
            Exsr CrtCursor;
            // Open the SQL Cursor
            CallP OpenLB4();
            // Get the UOM Data
            Rc = FetchMultLB4();
            // Close the SQL Cursor
            CallP CloseLB4();
            If Tot_Read > *Zero;
              P = *Zero;
              Exsr LoadSF1;
              //
              SFL1ind = *ON;
              //
              DoW SFL1Ind = *ON;
                // Start at the top of the list
                XRRNS1 = 1;
                // Display the subfile
                *IN27 = *ON;
                *IN28 = *ON;
                Write WIN01;
                Exfmt CTL01;
                *IN28 = *OFF;
                *IN27 = *OFF;
                ExSR UpdSel;
                Select;
                  When *IN05 = *ON;
                    P = *Zero ;
                    For S = 1 to Tot_Read;
                      If PgmData(S).SEL01  <> *Blanks;
                        If P < Limit ;
                          P += 1;
                          LB04NDX(P) = PgmData(S).PUOMIndex ;
                        EndIf ;
                      EndIf ;
                    EndFor;
                    SFL1IND = *OFF ;
                    If P > *Zero;
                      EOJ = '**' ;
                    Else ;
                      EOJ = 'NS' ;
                    EndIf;
                     // If previous was selected
                  When *IN12 = *ON;
                     EOJ = '12';
                     SFL1ind = *OFF;
                     // Execute roll up (page down)
                  When *IN26 = *ON;
                     If P < Tot_Read;
                        Exsr LoadSF1;
                     EndIf;
                     // Execute roll down (page up)
                  When *IN25 = *ON;
                     If SF1Last > SFLPg;
                        If SF1Last > SFLpgX2;
                           P = P - SflPgX2 ;
                           Exsr LoadSF1;
                           Else;   //* Go to the top
                           P = *Zero;
                           Exsr LoadSF1;
                        EndIf;
                        Else;   //* Go to the top
                        P = *Zero;
                        Exsr LoadSF1;
                     EndIf;
                  When PositionTo <> *BLanks;
                    For S = 1 to Tot_Read;
                      If PgmData(S).UOMID >= PositionTo ;
                        P = S - 1;
                        ExSR LoadSF1 ;
                        PositionTo = *Blanks ;
                        Leave;
                      EndIf;
                    EndFor;
               EndSl;
             EndDo;
           EndIf;
           // Close the display file
           Close BPDLB04;
           If EOJ <> '**' ;
              LB04NDX = *Zeros;
           EndIf;
           LB04EOJ = EOJ;
          Return BPMLB04DS;
          //*----------------------------------------------------------
          // Load the subfile
          //*----------------------------------------------------------
       BegSr LoadSF1;
          // Clear out the subfile
          *IN29 = *ON;
          Write CTL01;
          *IN29 = *OFF;
          XRRNS1 = *ZERO;
          // Build the window subfile
          If P < Tot_Read;
             For O = 1 to SFlPg ;
                P += 1;
                If PgmData(P).PUOMIndex <> *Zeros;
                   SF1H01 = PgmData(P).PUOMIndex;
                   SF1UOM = PgmData(P).UOMID ;
                   SF1DSC = PgmData(P).UOMDESC ;
                   SF1SEL = PgmData(P).SEL01 ;
                   XRRNS1 += 1;
                   If XRRNS1 = 1;
                      SFL1T = P;
                   EndIf;
                   SFL1B = P;
                   Write SFL01 ;
                EndIf;
             EndFor;
          EndIf;

       EndSr;
       //*----------------------------------------------------------
       // Update The Select Field
       //*----------------------------------------------------------
       BegSr UpdSel ;
         O = *Zeros;
         For S = SFL1T to SFL1B ;
           O += 1;
           Chain O SFL01 ;
           If %Found();
           PgmData(S).SEL01 = SF1SEL ;
           EndIf;
         EndFor;
       EndSR ;
       //*--------------------------------------------------------
       // Crtcursor - Create the SQL cursor
       //*--------------------------------------------------------
       BegSr crtcursor;
          //
          CsrSel = 'Select PUOMINDEX, UOMID, UOMDESC ' +
                   'From POPUOM ' +
                   'Order By UOMID ' +
                   'For Read Only' ;
          //
       EndSr;
       //*****************************************************
       End-Proc;
       //--------------------------------------------------------
       //  closeLB4 - Close the cursor
       //--------------------------------------------------------
       Dcl-Proc closeLB4;
         Dcl-PI closeLB4;
         End-PI;

         Exec SQL close Cursor;

       End-Proc closeLB4;
       //--------------------------------------------------------
       //  fetchMultLB4 - read the entire table
       //--------------------------------------------------------
       Dcl-Proc fetchMultLB4;

         Dcl-PI fetchMultLB4 Ind End-PI;

         Exec SQL
             fetch next from Cursor
             For :Mult_Row rows
             into :PgmData;
         //
         Exec SQL Get Diagnostics :Tot_Read = ROW_COUNT ;
         //
         If SQLSTT < '040000';
            Return *ON;
         Else;
            Return *OFF;
         EndIf;
            //
       End-Proc fetchMultLB4;
       //---------------------------------------------------------------------
       //  openCustLB4  - Open a cursor for the selected table
       //---------------------------------------------------------------------
       Dcl-Proc openLB4;

         Dcl-PI OpenLB4 End-PI;

            Exec SQL prepare wkStatement from :CsrSel ;
            // *
            Exec SQL declare Cursor scroll cursor for wkStatement ;
            // *
            Exec SQL open Cursor ;
            // *
       End-Proc openLB4;
       //---------------------------------------------------------------------
