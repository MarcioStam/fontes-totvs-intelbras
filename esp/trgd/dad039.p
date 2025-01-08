/********************************************************************************
 ** UPC........: dad039.p - UPC DELETE cond-pagto    
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de condi‡Æo de pagamento para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-cond-pagto      FOR cond-pagto.
DEFINE TEMP-TABLE tt-cond-pagto LIKE cond-pagto.
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
DEF VAR raw-param   AS RAW  NO-UNDO.
CREATE tt-cond-pagto.
BUFFER-COPY b-cond-pagto TO tt-cond-pagto.
RAW-TRANSFER tt-cond-pagto TO raw-param.
/* RAW-TRANSFER b-cond-pagto TO raw-param. */
{esp/esb/esesb006.i 'msg0004' 'dad039' 'cond-pagto'}


/*
run esp/es0669.p (input "no", 
                  "cond-pagto", 
                  string(b-cond-pagto.cod-cond-pag,"999"),
                  "", "", "", "", "", "", "", "").

create tt-cond-pagto-atu.
buffer-copy b-cond-pagto to tt-cond-pagto-atu.
create tt-raw-transfer.

raw-transfer tt-cond-pagto-atu to tt-raw-transfer.record.
 
RUN esp/crm/escrm001a.p (input "Cond-Pagto",
                         input "D" ,
                         input rowid(b-cond-pagto),
                         input table tt-raw-transfer).
*/
/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - In¡cio */
IF (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
   (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:

    /* Defini‡Æo da temp-table "ttRawTabela" */
    {esp/sdcv/essdcv001api.i}

    /* Defini‡Æo da temp-table "RowErrors" */
    {method/dbotterr.i}

    CREATE ttRawTabela.
    RAW-TRANSFER tt-cond-pagto TO ttRawTabela.rawTabela.

/*     RAW-TRANSFER b-cond-pagto TO ttRawTabela.rawTabela. */

    RUN esp/sdcv/essdcv001api.p (INPUT  "cond-pagto":U,
                                 INPUT  "E":U,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).
END.
/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - Final */


