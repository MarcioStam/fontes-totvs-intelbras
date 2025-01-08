/********************************************************************************
 ** UPC........: wad229.p - UPC write Repres
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das representantes para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-repres      FOR repres.
DEF PARAM BUFFER b-old-repres  FOR repres.

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-repres LIKE repres
     FIELD situacao AS INTEGER.

CREATE tt-repres.
BUFFER-COPY b-repres TO tt-repres.
ASSIGN tt-repres.situacao  = 0. /* Manuten‡Æo */

RAW-TRANSFER tt-repres TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0192", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

/*
FIND repres
     WHERE ROWID(repres) = ROWID(b-repres) EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL repres and
    repres.cod-formula = "" THEN
    ASSIGN  repres.cod-formula = "F204".
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "yes", 
                  "repres", 
                  string(b-repres.cod-rep,"99999"),
                  "", "", "", "", "", "", "", "").


run esp/crm/escrm001a.p (input "Repres",
                         input "W",
                         input rowid(b-repres),
                         input table tt-raw-transfer).

*/
