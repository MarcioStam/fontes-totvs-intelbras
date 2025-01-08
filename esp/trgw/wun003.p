/********************************************************************************
 ** UPC........: wun003.p - UPC WRITE cotacao    
 ** Data.......: Abril / 2015
 ** Objetivo...: Integrar cota‡äes ERP TOTVS -> OBC(SDCV) 
 ********************************************************************************/

DEF PARAM BUFFER b-cotacao      FOR cotacao.
DEF PARAM BUFFER b-old-cotacao  FOR cotacao.

/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - In¡cio 
IF (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
   (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:

    /* Defini‡Æo da temp-table "ttRawTabela" */
    {esp/sdcv/essdcv001api.i}

    /* Defini‡Æo da temp-table "RowErrors" */
    {method/dbotterr.i}

    CREATE ttRawTabela.
    RAW-TRANSFER b-cotacao TO ttRawTabela.rawTabela.

    IF NEW b-cotacao THEN
        RUN esp/sdcv/essdcv001api.p (INPUT  "cotacao":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).
    ELSE 
        RUN esp/sdcv/essdcv001api.p (INPUT  "cotacao":U,
                                     INPUT  "A":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

END.
Chamado: 45035  */

