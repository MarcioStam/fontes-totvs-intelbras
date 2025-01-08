/********************************************************************************
 ** UPC........: wes739.p - WRITE int-gr-cli-catalogo
 ** Data.......: 29/12/2021
 ** Objetivo...: Integra as altera‡äes do portifolio de grupo de cliente
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF int-gr-cli-catalogo.

DEF TEMP-TABLE  tt-item 
    FIELD cod-gr-cli    LIKE int-gr-cli-catalogo.cod-gr-cli 
    FIELD it-codigo     LIKE int-gr-cli-catalogo.it-codigo
    FIELD cod-unid-neg  AS CHAR
    FIELD segmento      AS CHAR
    FIELD familia       AS CHAR
    FIELD rowiditem     AS ROWID.

def input-output parameter table for tt-item.

{utp/ut-glob.i}

DEFINE VARIABLE i-sequencia   AS INTEGER   NO-UNDO.

IF  AVAIL int-gr-cli-catalogo THEN DO:
   
   run esp/wso/eswso0012.p (INPUT ROWID(int-gr-cli-catalogo),
                            INPUT-OUTPUT TABLE tt-item,
                            INPUT 'POST').
END.



RETURN "OK".

