/* Drop the Unit of Meausre Table (old method) */
   DROP TABLE BPLIB.POPUOM ;

/* Create/Replace the Unit of Measure table */
CREATE OR REPLACE TABLE BPLIB.POPUOM (
        PUOMINDEX INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 ,
        INCREMENT BY 1) NOT NULL ,
        UOMID CHAR(3) CCSID 37 NOT NULL DEFAULT '' ,
        UOMDESC CHAR(15) CCSID 37 NOT NULL DEFAULT '' ,
        PRIMARY KEY( PUOMINDEX ) ) ;

LABEL ON TABLE BPLIB.POPUOM
        IS 'Product U.O.M. Table' ;

LABEL ON COLUMN BPLIB.POPUOM
( PUOMINDEX TEXT IS 'UNIQUE KEY/INDEX' ,
        UOMID TEXT IS 'UNIT OF MEASURE' ,
        UOMDESC TEXT IS 'DESCRIPTION'  ) ;

LABEL ON COLUMN BPLIB.POPUOM
( PUOMINDEX IS 'Unique Key' ,
        UOMID IS 'UOM' ,
        UOMDESC IS 'U.O.M  Description' ) ;

/* Creating index BPLIB.POXUOMU */
CREATE UNIQUE INDEX BPLIB.POXUOMU ON BPLIB.POPUOM (UOMID ASC );

/* Setting comment text for BPLIB.POXUOMU */
COMMENT ON INDEX BPLIB.POXUOMU IS 'Unique Index by UOM ID';
