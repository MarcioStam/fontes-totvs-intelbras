/********************************************************************************
 ** UPC........: wad043.p - UPC WRITE cont-emit
 ** Data.......: fevereiro / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes de emitente para a Base Oracle
 ********************************************************************************/
DEF PARAM BUFFER b-cont-emit      FOR cont-emit.
DEF PARAM BUFFER b-old-cont-emit  FOR cont-emit.

DEFINE BUFFER bf-emitente FOR emitente.

DEFINE TEMP-TABLE tt-emitente LIKE emitente.

DEFINE VARIABLE c-action AS CHARACTER NO-UNDO.

ASSIGN c-action = IF NEW b-cont-emit THEN "I":U ELSE "A":U.

{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

run esp/es0669.p (input "yes", 
                  "emitente", 
                  string(b-cont-emit.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "", "").

/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - In¡cio */
/* se algum destes campos sofreu altera‡Æo, dispara a API de integra‡Æo */

IF  b-cont-emit.nome     <> b-old-cont-emit.nome
OR  b-cont-emit.telefone <> b-old-cont-emit.telefone
OR  b-cont-emit.ramal    <> b-old-cont-emit.ramal
OR  b-cont-emit.telefax  <> b-old-cont-emit.telefax
OR  b-cont-emit.e-mail   <> b-old-cont-emit.e-mail THEN DO:

    IF  (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
        (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:

        {esp/sdcv/essdcv001api.i} /* Defini‡Æo da temp-table "ttRawTabela" */
        {method/dbotterr.i} /* Defini‡Æo da temp-table "RowErrors" */

        EMPTY TEMP-TABLE tt-emitente NO-ERROR.

        FOR FIRST bf-emitente NO-LOCK
            WHERE bf-emitente.cod-emitente = b-cont-emit.cod-emitente:

            CREATE tt-emitente.
            BUFFER-COPY bf-emitente EXCEPT telefone telefax e-mail TO tt-emitente
                ASSIGN tt-emitente.telefone[1] = b-cont-emit.telefone
                       tt-emitente.telefax     = b-cont-emit.telefax
                       tt-emitente.e-mail      = b-cont-emit.e-mail.

            CREATE ttRawTabela.
            RAW-TRANSFER tt-emitente TO ttRawTabela.rawTabela.

            RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                         INPUT  c-action,
                                         INPUT  TABLE ttRawTabela,
                                         OUTPUT TABLE RowErrors).
        END. /* FOR FIRST bf-emitente NO-LOCK */

    END. /* IF  (SEARCH("esp/sdcv/essdcv001api.p":U) */

END. /* IF  b-cont-emit */

/* Chamada da API ESSDCV001API de integra‡Æo com o OutBuyCenter (SDCV) - Final */

