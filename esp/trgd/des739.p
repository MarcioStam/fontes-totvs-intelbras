
/********************************************************************************/
/** UPC........: des739.p - Elimina catalogo do grupo de cliente                */
/********************************************************************************/
trigger procedure for DELETE of int-gr-cli-catalogo.                                
DEF TEMP-TABLE  tt-item 
    FIELD cod-gr-cli    LIKE int-gr-cli-catalogo.cod-gr-cli 
    FIELD it-codigo     LIKE int-gr-cli-catalogo.it-codigo
    FIELD cod-unid-neg  AS CHAR
    FIELD segmento      AS CHAR
    FIELD familia       AS CHAR
    FIELD rowiditem     AS ROWID.

def input-output parameter table for tt-item.

IF AVAIL int-gr-cli-catalogo THEN DO:
   
    CREATE tt-item.
    ASSIGN tt-item.cod-gr-cli     = int-gr-cli-catalogo.cod-gr-cli
           tt-item.it-codigo      = int-gr-cli-catalogo.it-codigo
           tt-item.cod-unid-neg   = int-gr-cli-catalogo.cod-unid-negoc
           tt-item.segmento       = int-gr-cli-catalogo.segmento
           tt-item.familia        = int-gr-cli-catalogo.fm-cod-com
           tt-item.rowiditem     =  ROWID(int-gr-cli-catalogo).

   run esp/wso/eswso0012.p (INPUT ROWID(int-gr-cli-catalogo),
                            INPUT-OUTPUT TABLE tt-item,
                            INPUT 'DELETE').
END.



RETURN "OK".


