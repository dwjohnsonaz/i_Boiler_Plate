       //* ----------------------------------------------------------------- *//
       //* To create the module BPMTST03:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMTST03) DBGVIEW(*SOURCE)                 *//
       //* To create the BPRTST03 program:                                   *//
       //*  1) Create the BPMLB03 module                                     *//
       //*  2) CRTPGM PGM(BPLIB/BPRTST03)                                    *//
       //*            MODULE(BPLIB/BPMTST03 BPLIB/BPMLB03) ACTGRP(BPAG)      *//
       //* ----------------------------------------------------------------- *//
       CTL-OPT DFTNAME(BPMTST03);
       CTL-OPT DEBUG OPTION(*NODEBUGIO: *SRCSTMT);
       CTL-OPT CCSID(*CHAR:*JOBRUN) ALWNULL(*USRCTL);
       CTL-OPT COPYRIGHT('SHandB, LLC 2017/1024');
      // Test Boiler Plate List Box 03
     D/Copy QRPGLESRC,BPT001
       Dcl-S  EOJ        Char(2) ;
       BPMLB03DS = BPMLB03();
       *INLR = *ON ;
