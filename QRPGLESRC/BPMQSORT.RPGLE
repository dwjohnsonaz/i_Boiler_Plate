**FREE
       //* ----------------------------------------------------------------- *//
       //* To create the module BPMQSORT:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMQSORT) SRCFILE(BPLIB/QRPGLESRC)         *//
       //*           DBGVIEW(*SOURCE)
       //* ----------------------------------------------------------------- *//
       Ctl-Opt DFTNAME(BPMQSORT) ALWNULL(*USRCTL)
               DEBUG
               OPTION(*NODEBUGIO: *SRCSTMT)
               COPYRIGHT('SHandB, LLC 2017/2024');
       // Boiler Plate for Qsort processing
       Dcl-PR Qsort                  ExtProc('qsort');
          DataStart             Pointer Value;
          ElementCnt               Uns(10) Value;
          ElementSize              Uns(10) Value;
          CompareFunc           Pointer(*Proc) Value;
       End-PR;
       //  Driver data (from a Fetch-Mult into)
       Dcl-DS DrvData                  qualified  Dim( 2000 );
          ReportGrp                Char(10) Inz;                            //    Report Group
          Region                   Char(12) Inz;                            //    Safety Regio
          Terminal                 Char(6) Inz;                             //    Terminal
          FleetLDR                 Char(6) Inz;                             //    Fleet Leader
          DriveLDR                 Char(6) Inz;                             //    Driver Leade
          InUnitYN                 Char(1) Inz;                             //    In Unit Y/N
          OnHoldYN                 Char(1) Inz;                             //    On Hold Y/N
          SARSNC                   Char(6) Inz;                             //    Reason Code
          DRIVER                   Char(6) Inz;                             //    Driver
          UNIT                     Char(6) Inz;                             //    Unit
          EXPIRED                 Zoned(5:0) Inz;                           //    Expired
          Days05                  Zoned(5:0) Inz;                           //    1 - 5 Days
          Days14                  Zoned(5:0) Inz;                           //    6 - 14 Days
          Days21                  Zoned(5:0) Inz;                           //    15 - 21 Days
          Days30                  Zoned(5:0) Inz;                           //    22 - 30 Days
          TotQM                   Zoned(5:0) Inz;                           //    Total Counts
          TotDrv                  Zoned(5:0) Inz;                           //    No. Drivers
       End-DS;
       // Stand Alone fields
       Dcl-S SortCnt              Packed(5:0) Inz;

         Qsort(%Addr(DrvData):
               SortCnt:
               %Size(Drvdata):
               %Paddr(QSortArea));

         *INLR = *ON;
       //***********************************************************************
       // QSortArea: Sort by Area Array by Pass/Fail%
       //***********************************************************************
       Dcl-Proc QSortArea;
       Dcl-PI *N                    Int(10:0);
          DrElem1                      LikeDS(DRVDATA);
          DrElem2                      LikeDS(DRVDATA);
       End-PI;

          Select;
          When DrElem1.Region < DrElem2.Region;
             Return -1;
          When DrElem1.Region > DrElem2.Region;
             Return 1;
          When DrElem1.Terminal < DrElem2.Terminal;
             Return -1;
          When DrElem1.Terminal > DrElem2.Terminal;
             Return 1;
          When DrElem1.FleetLDR < DrElem2.FleetLDR;
             Return -1;
          When DrElem1.FleetLDR > DrElem2.FleetLDR;
             Return 1;
          When DrElem1.DriveLDR < DrElem2.DriveLDR;
             Return -1;
          When DrElem1.DriveLDR > DrElem2.DriveLDR;
             Return 1;
          When DrElem1.Driver < DrElem2.Driver;
             Return -1;
          When DrElem1.Driver > DrElem2.Driver;
             Return 1;
          Other;
             Return 0;
          EndSL;

        End-Proc;
