       //* ----------------------------------------------------------------- *//
       //* After creating the POPUOM table and the BPDLB01 display file!     *//
       //* To create the module BPMLB02:                                     *//
       //* CRTSQLRPGI OBJ(BPLIB/BPMLB02) SRCFILE(BPLIB/QRPGLESRC)            *//
       //*            OBJTYPE(*MODULE) DBGVIEW(*SOURCE)                      *//
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMLB02) NOMAIN
               Debug
               Option(*NoDebugIO: *SrcStmt)
               COPYRIGHT('SHandB, LLC 2017/2024');
       //  Boiler Plate List Box
       Dcl-F BPDLB02  WORKSTN SFILE(SFL01:XRRNS1) USROPN;
       //  Prototypes
      /Copy QRPGLESRC,BPT001
       Dcl-PR CloseLB2  End-PR ;
       Dcl-PR FetchMultLB2 Ind End-PR;
       Dcl-PR OpenLB2 End-PR ;
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
       Dcl-S Sf1Last                Int(5:0);
       Dcl-S SflPg                  Int(5:0) inz(5);
       Dcl-S SflPgx2                Int(5:0) inz(10);
       Dcl-S Sfl1B                  Int(5:0) inz;
       Dcl-S Sfl1T                  Int(5:0) inz;
       Dcl-S Sfl1Ind                Ind;
       Dcl-S Tot_Read               Int(10:0) Inz;
       // ---------------------------------------------------------------------
       Dcl-Proc BPMLB02 EXPORT;

         Dcl-PI BPMLB02              Char(11);
         End-PI;
         //  Stand Alone Fields
         Dcl-S EOJ                   Char(2);
         Dcl-S NDXUOM               Zoned(9:0);
         Dcl-S OpenUOM                Ind;
         Dcl-S Rc                     Ind  Inz('0') ;
         // ---------------------------------------------------------------------
            If NOT %Open(BPDLB02);
               Open BPDLB02;
            EndIf;
            // Set the SQL cursor
            Exsr CrtCursor;
            // Open the SQL Cursor
            CallP OpenLB2();
            // Get the UOM Data
            Rc = FetchMultLB2();
            // Close the SQL Cursor
            CallP CloseLB2();
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
                  When RELREC <> *Zero;
                     Chain RELREC SFL01;
                     If %Found() and SF1H01 > *Zero and SF1SEL <> *Blank;
                        EOJ = '**' ;
                        NDXUOM = SF1H01;
                        SFL1ind = *OFF;
                        If SF1SEL <> *Blank;
                           Clear SF1SEL;
                           Update SFL01;
                        EndIf;
                     EndIf;
               EndSl;
             EndDo;
           EndIf;
           // Close the display file
           Close BPDLB02;

           If EOJ <> '**' ;
              LB02NDX = *Zeros;
           Else;
              LB02NDX = NDXUOM;
           EndIf;
           LB02EOJ = EOJ;

          Return BPMLB02DS;
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
       //  closeLB2 - Close the cursor
       //--------------------------------------------------------
       Dcl-Proc closeLB2;
         Dcl-PI closeLB2;
         End-PI;

         Exec SQL close Cursor;

       End-Proc closeLB2;
       //--------------------------------------------------------
       //  fetchMultLB2 - read the entire table
       //--------------------------------------------------------
       Dcl-Proc fetchMultLB2;

         Dcl-PI fetchMultLB2 Ind End-PI;

         Exec SQL
             fetch next from Cursor
             For :Mult_Row rows
             into :PgmData;
         //
         Exec SQL Get Diagnostics :Tot_Read = ROW_COUNT ;
         //
         If SQLSTT < '020000';
            Return *ON;
         Else;
            Return *OFF;
         EndIf;
            //
       End-Proc fetchMultLB2;
       //---------------------------------------------------------------------
       //  openCustLB2  - Open a cursor for the selected table
       //---------------------------------------------------------------------
       Dcl-Proc openLB2;

         Dcl-PI OpenLB2 End-PI;

            Exec SQL prepare wkStatement from :CsrSel ;
            // *
            Exec SQL declare Cursor scroll cursor for wkStatement ;
            // *
            Exec SQL open Cursor ;
            // *
       End-Proc openLB2;
       //---------------------------------------------------------------------
