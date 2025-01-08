

DEF TEMP-TABLE  tt-item 
    FIELD cod-gr-cli    LIKE int-gr-cli-catalogo.cod-gr-cli 
    FIELD it-codigo     LIKE int-gr-cli-catalogo.it-codigo
    FIELD cod-unid-neg  AS CHAR
    FIELD segmento      AS CHAR
    FIELD familia       AS CHAR
    FIELD rowiditem     AS ROWID.


DEF INPUT PARAM row-table        AS ROWID.
def input-output parameter table for tt-item.


FIND FIRST int-gr-cli-catalogo
     WHERE rowid(int-gr-cli-catalogo) = row-table NO-LOCK NO-ERROR.

IF AVAIL int-gr-cli-catalogo THEN DO:
   RUN pi-monta-catalogo.
END.
ELSE DO:
   FIND FIRST tt-item NO-ERROR. 
   IF NOT AVAIL tt-item THEN 
   FOR EACH int-gr-cli-catalogo NO-LOCK:
     RUN pi-monta-catalogo.
   END.
END.


PROCEDURE pi-monta-catalogo.                                   

    CREATE tt-item.
    ASSIGN tt-item.cod-gr-cli     = int-gr-cli-catalogo.cod-gr-cli
           tt-item.it-codigo      = int-gr-cli-catalogo.it-codigo
           tt-item.cod-unid-neg   = int-gr-cli-catalogo.cod-unid-negoc
           tt-item.segmento       = int-gr-cli-catalogo.segmento
           tt-item.familia        = int-gr-cli-catalogo.fm-cod-com
           tt-item.rowiditem       = ROWID(int-gr-cli-catalogo).
    
END.
