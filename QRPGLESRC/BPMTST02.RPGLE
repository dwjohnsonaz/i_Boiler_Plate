       //* ----------------------------------------------------------------- *//
       //* To create the module BPMTST02:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMTST02) DBGVIEW(*SOURCE)                 *//
       //* To create the BPRTST02 program:                                   *//
       //*  1) Create the BPMLB02 module                                     *//
       //*  2) CRTPGM PGM(BPLIB/BPRTST02)                                    *//
       //*            MODULE(BPLIB/BPMTST02 BPLIB/BPMLB02) ACTGRP(BPAG)      *//
       //* ----------------------------------------------------------------- *//
       CTL-OPT DFTNAME(BPMTST02);
       CTL-OPT DEBUG OPTION(*NODEBUGIO: *SRCSTMT);
       CTL-OPT CCSID(*CHAR:*JOBRUN) ALWNULL(*USRCTL);
       CTL-OPT COPYRIGHT('SHandB, LLC 2017/1024');
      // Test Boiler Plate List Box 02 - w/position to
     D/Copy QRPGLESRC,BPT001
       Dcl-S  EOJ        Char(2) ;
       BPMLB02DS = BPMLB02();
       *INLR = *ON ;
