TRIGGER PROCEDURE FOR WRITE OF int-emitente.

/********************************************************************************
 ** UPC........: wes332 - tabela int-emitente
 ** Data.......: Maio / 2010
 ********************************************************************************/
DEFINE BUFFER bf-emitente FOR emitente.

DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente.

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "yes", 
                  "emitente", 
                  string(int-emitente.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "", "").
                  
IF  l-web-service = NO THEN DO:
    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    IF  AVAIL emitente AND emitente.identific <> 2 THEN DO:
        IF  int-emitente.vl-guid <> "" AND
            NEW int-emitente     = NO  THEN DO:
    
            RUN esp/crm/escrm001a.p (INPUT "Emitente",
                                     INPUT "W",
                                     INPUT ROWID(emitente),
                                     INPUT TABLE tt-raw-transfer).
        END.
    END.
END.
*/

/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - In¡cio */
/* se algum destes campos sofreu altera‡Æo, dispara a API de integra‡Æo */

/*IF  (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
    (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:

    {esp/sdcv/essdcv001api.i} /* Defini‡Æo da temp-table "ttRawTabela" */
    {method/dbotterr.i} /* Defini‡Æo da temp-table "RowErrors" */

    FOR FIRST bf-emitente NO-LOCK
        WHERE bf-emitente.cod-emitente = int-emitente.cod-emitente:

        EMPTY TEMP-TABLE tt-emitente.
        CREATE tt-emitente.
        BUFFER-COPY bf-emitente TO tt-emitente.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-emitente TO ttRawTabela.rawTabela.
        //RAW-TRANSFER bf-emitente TO ttRawTabela.rawTabela.

        RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).
    END. /* FOR FIRST bf-emitente NO-LOCK */

END. /* IF  (SEARCH("esp/sdcv/essdcv001api.p":U) */
*/

/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - Final */


