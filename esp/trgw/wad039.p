/********************************************************************************
 ** UPC........: wad039.p - UPC WRITE cond-pagto    
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de condi‡Æo de pagamento para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-cond-pagto      FOR cond-pagto.
DEF PARAM BUFFER b-old-cond-pagto  FOR cond-pagto.

DEFINE TEMP-TABLE tt-cond-pagto LIKE cond-pagto.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.
CREATE tt-cond-pagto.
BUFFER-COPY b-cond-pagto TO tt-cond-pagto.
RAW-TRANSFER tt-cond-pagto TO raw-param.
/* RAW-TRANSFER b-cond-pagto TO raw-param. */

{esp/esb/esesb006.i 'msg0004' 'wad039' 'cond-pagto'}

/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
   
run esp/es0669.p (input "yes", 
                  "cond-pagto", 
                  string(b-cond-pagto.cod-cond-pag,"999"),
                  "", "", "", "", "", "", "", "").

run esp/crm/escrm001a.p (input "Cond-pagto",
                         input "W",
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

    IF NEW b-cond-pagto THEN
        RUN esp/sdcv/essdcv001api.p (INPUT  "cond-pagto":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).
    ELSE 
        RUN esp/sdcv/essdcv001api.p (INPUT  "cond-pagto":U,
                                     INPUT  "A":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

END.

