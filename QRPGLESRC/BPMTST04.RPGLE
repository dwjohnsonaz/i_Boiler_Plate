**FREE
       //* ----------------------------------------------------------------- *//
       //* To create the module BPMTST04:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMTST04) DBGVIEW(*SOURCE)                 *//
       //* To create the BPRTST04 program:                                   *//
       //*  1) Create the BPMLB04 module                                     *//
       //*  2) CRTPGM PGM(BPLIB/BPRTST04)                                    *//
       //*            MODULE(BPLIB/BPMTST04 BPLIB/BPMLB04) ACTGRP(BPAG)      *//
       //* ----------------------------------------------------------------- *//
       CTL-OPT DFTNAME(BPMTST04);
       CTL-OPT DEBUG OPTION(*NODEBUGIO: *SRCSTMT);
       CTL-OPT CCSID(*CHAR:*JOBRUN) ALWNULL(*USRCTL);
       CTL-OPT COPYRIGHT('SHandB, LLC 2017/1024');
      // Test Boiler Plate List Box 03
      /Copy QRPGLESRC,BPT001
       Dcl-S  EOJ        Char(2) ;
       BPMLB04DS = BPMLB04();
       *INLR = *ON ;
