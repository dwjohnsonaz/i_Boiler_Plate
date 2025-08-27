**FREE
       //* ----------------------------------------------------------------- *//
       //* To create the module BPMTST01:                                    *//
       //* CRTRPGMOD MODULE(BPLIB/BPMTST01) DBGVIEW(*SOURCE)                 *//
       //* To create the BPRTST01 program:                                   *//
       //*  1) Create the BPMLB01 module                                     *//
       //*  2) CRTPGM PGM(BPLIB/BPRTST01)                                    *//
       //*            MODULE(BPLIB/BPMTST01 BPLIB/BPMLB01) ACTGRP(BPAG)      *//
       //* ----------------------------------------------------------------- *//
       CTL-OPT DFTNAME(BPMTST01);
       CTL-OPT DEBUG OPTION(*NODEBUGIO: *SRCSTMT);
       CTL-OPT CCSID(*CHAR:*JOBRUN) ALWNULL(*USRCTL);
       CTL-OPT COPYRIGHT('SHandB, LLC 2017/1024');
       // Test Boiler Plate List Box 01
       /Copy QRPGLESRC,BPT001
       Dcl-S  EOJ        Char(2) ;
       BPMLB01DS = BPMLB01();
       *INLR = *ON ;
