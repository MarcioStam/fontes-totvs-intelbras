DEFINE VARIABLE vDtFatur AS DATE       NO-UNDO.
DEFINE BUFFER b-estabelec FOR estabelec.

FOR FIRST b-estabelec NO-LOCK 
   WHERE b-estabelec.cod-estabel = {1},
   FIRST ser-estab NO-LOCK
      WHERE ser-estab.cod-estabel = b-estabelec.cod-estabel
        AND ser-estab.serie       = b-estabelec.serie:
   ASSIGN vDtFatur = ser-estab.dt-ult-fat.
END.

/*vDtFatur*/
