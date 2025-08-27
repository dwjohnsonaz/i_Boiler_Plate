**FREE
       //* ----------------------------------------------------------------- *//
       //* To create the module BPMSORTA:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMSORTA) SRCFILE(BPLIB/QRPGLESRC)         *//
       //*           DBGVIEW(*SOURCE)
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMSORTA) ALWNULL(*USRCTL)
               DEBUG
               OPTION(*NODEBUGIO: *SRCSTMT)
               COPYRIGHT('SHandB, LLC 2017/2024');
       // Boiler Plate for Sort Array processing (Descending)
       // Global variables
       Dcl-C MULT_F                    Const( 20000 );
       // Array containing fetched data set
       Dcl-DS PgmData                  qualified  Dim( Mult_F );
          Order                    Char(7) Inz;                             //   Order Number
          OrStat                   Char(1) Inz;                             //   Order Status
          Or#Dsp                   Char(2) Inz;                             //   Order Curr Disp
          OrTen                    Char(1) Inz;                             //   Order Hi Val
          DiUnit                   Char(6) Inz;                             //   Load - Unit
          DiTrlr                   Char(7) Inz;                             //   Load - Trailer
          DiDr1                    Char(6) Inz;                             //   Load - Driver 1
          DiDr2                    Char(6) Inz;                             //   Load - Driver 2
          OETRLR                   Char(14) Inz;                            // Opequip - Trailer
          CNLOC                    Char(6) Inz;                             // Contact - Loc.
          A1UNIT                   Char(1) Inz;                             // Scrn Attr #1UNIT
          A1TRLR                   Char(1) Inz;                             // Scrn Attr #1TRLR
          A1LCALL                  Char(1) Inz;                             // Scrn Attr #1LCALL
          A1SPCLC                  Char(1) Inz;                             // Scrn Attr #1SPCLC
          A1MFSHPR                 Char(1) Inz;                             // Scrn Attr #1MFSHP
          A1M2FNL                  Char(1) Inz;                             // Scrn Attr #1M2FNL
          A1HVL                    Char(1) Inz;                             // Scrn Attr #1HVL
          A1HTA                    Char(1) Inz;                             // Scrn Attr #1HTA
          A1DISC                   Char(1) Inz;                             // Scrn Attr #1DISC
          A1D2ADDR                 Char(1) Inz;                             // Scrn Attr #1D2AD
          A1D2HOME                 Char(1) Inz;                             // Scrn Attr #1D2HM
          A1IGNON                  Char(1) Inz;                             // Scrn Attr #1IGON
          A1LSTMOV                 Char(1) Inz;                             // Scrn Attr #1LSTMV
          A1MSGACT                 Char(1) Inz;                             // Scrn Attr #1MSGAC
          A1OOR                    Char(1) Inz;                             // Scrn Attr #1OOR
          A1ATTMNL                 Char(1) Inz;                             // Scrn Attr #1ATMN
          A1TRKYN                  Char(1) Inz;                             // Scrn Attr #1TRKYN
          A1TCL                    Char(1) Inz;                             // Scrn Attr #1TCL
          HTA                      Char(1) Inz;                             // High Theft Area
          Disc                     Char(1) Inz;                             // Disconnected
          FromMiles               Zoned(4:0) Inz;                           // Miles from shipper
          ToMiles                 Zoned(4:0) Inz;                           // Miles To Destination
          AddrMiles               Zoned(4:0) Inz;                           // Dist To Address
          HomeMiles               Zoned(4:0) Inz;                           // Dist To Home Time
          IgnHrMin                 Char(10) Inz;                            // Ignition Off H/M
          Special                  Char(10) Inz;                            // Special Track Cust
          MovHrMn                  Char(10) Inz;                            // Last Moved H/M
          MsgHrMn                  Char(10) Inz;                            // Last Msg. H/M
          NoteHrMn                 Char(10) Inz;                            // Last Msg. H/M
          OORP                     Char(7) Inz;                             // Out of Route %
          LCall                    Char(1) Inz;                             // Order Status
          ATTmnl                   Char(6) Inz;                             // Terminal load is at
          Weight                  Zoned(7:0) Inz;                           // Sequence No.
       End-DS ;
       // Stand Alone Fields
       Dcl-S Tot_Read               Int(10:0) Inz;                          // No of Rec from Fetch

          SortA(D)  %Subarr(PgmData(*).Weight:1:Tot_Read) ;

        *INLR = *ON ;
