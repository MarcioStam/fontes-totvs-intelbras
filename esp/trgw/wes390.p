TRIGGER PROCEDURE FOR WRITE OF int-cond-pagto.

DEFINE BUFFER b-cond-pagto FOR cond-pagto.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

FIND FIRST cond-pagto NO-LOCK
    WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-ERROR.

IF AVAIL cond-pagto THEN DO:
    RAW-TRANSFER cond-pagto TO raw-param.
    {esp/esb/esesb006.i 'msg0004' 'wes390' 'int-cond-pagto'}
END.

/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
   
RUN esp/crm/escrm001a.p (input "Cond-pagto",
                         input "W",
                         input rowid(cond-pagto),
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
    RAW-TRANSFER cond-pagto TO ttRawTabela.rawTabela.

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
