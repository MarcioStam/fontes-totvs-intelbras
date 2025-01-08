/********************************************************************************
 ** UPC........: dad229.p - UPC DELETE Repres
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das representantes para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-repres      FOR repres.

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-repres LIKE repres
     FIELD situacao AS INTEGER.

CREATE tt-repres.
BUFFER-COPY b-repres TO tt-repres.
ASSIGN tt-repres.situacao  = 1. /* Elimina‡Æo */

RAW-TRANSFER tt-repres TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0192", /* Nome Mensagem */
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.


/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-repres TO raw-param.
{esp/esb/esesb006.i 'msg0058' 'dad229' 'repres'}

run esp/es0669.p (input "no", 
                  "repres", 
                  string(b-repres.cod-rep,"99999"),
                  "", "", "", "", "", "", "", "").

create tt-repres-atu.
buffer-copy b-repres to tt-repres-atu.
create tt-raw-transfer.

raw-transfer tt-repres-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Repres",
                         input "D",
                         input rowid(b-repres),
                         input table tt-raw-transfer).
*/
