&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-ped-item-astec NO-UNDO LIKE int-ped-item-astec
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESAPI018.P
    Purpose     : API do relacionamento Pedido cliente X Ocorràncias ASTEC
    Syntax      : <none>
    Description : <none>

    Created     : Maio de 2013
    Notes       : 001 - 28/05/2013 - Primeira vers∆o func ional (Fabiano
                  Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE ttTable      tt-int-ped-item-astec
&GLOBAL-DEFINE hDBOTable    hBoes643
&GLOBAL-DEFINE DBOTable     int-ped-item-astec

/* Include Definitions ---                                              */

/* Definiá∆o da RowErrors */
{method/dbotterr.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-int-ped-item-astec-aux NO-UNDO LIKE {&ttTable}.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

DEFINE TEMP-TABLE ttOSAlocarDesalocar NO-UNDO
    FIELD sequencia        AS INTEGER
    FIELD r-ped-item-astec LIKE {&ttTable}.r-Rowid
    INDEX ch-primario IS PRIMARY UNIQUE
        sequencia
    INDEX ch-ped-item-astec
        r-ped-item-astec.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE {&hDBOTable} AS HANDLE      NO-UNDO.

/* Buffer Definitions ---                                               */

DEFINE BUFFER b{&ttTable} FOR {&ttTable}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-int-ped-item-astec T "?" NO-UNDO mgesp int-ped-item-astec
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.63
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF NOT THIS-PROCEDURE:PERSISTENT THEN
    RETURN "NOK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-alocarDesalocarPedItemAstec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocarDesalocarPedItemAstec Procedure 
PROCEDURE alocarDesalocarPedItemAstec :
/*------------------------------------------------------------------------------
  Purpose:     Alocar ou desalocar a OS do item do pedido.
  Parameters:  Entrada: pNomeAbrev, pNrPedcli, pNrSequencia, pItCodigo,
                        pAlocarDesalocar e pQtdAlocarDesalocar.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNomeAbrev          LIKE {&DBOTable}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedcli           LIKE {&DBOTable}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrSequencia        LIKE {&DBOTable}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo           LIKE {&DBOTable}.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pAlocarDesalocar    AS INTEGER                    NO-UNDO. /* 1- Alocar e 2- Desalocar */
    DEFINE INPUT  PARAMETER pQtdAlocarDesalocar AS DECIMAL                    NO-UNDO.

/*     MESSAGE 'pNomeAbrev             ' pNomeAbrev           SKIP */
/*             'pNrPedcli              ' pNrPedcli            SKIP */
/*             'pNrSequencia           ' pNrSequencia         SKIP */
/*             'pItCodigo              ' pItCodigo            SKIP */
/*             'pAlocarDesalocar       ' pAlocarDesalocar     SKIP */
/*             'pQtdAlocarDesalocar    ' pQtdAlocarDesalocar       */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                      */


    DEFINE VARIABLE iRowsReturned          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE qtdAAlocarDesalocar    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE seqTtOSAlocarDesalocar AS INTEGER     NO-UNDO.

    DEFINE VARIABLE iErrorSequence LIKE RowErrors.ErrorSequence NO-UNDO.

    RUN initializeDBO IN THIS-PROCEDURE.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    RUN emptyRowErrors       IN {&hDBOTable}.
    RUN setConstraintPedItem IN {&hDBOTable} (INPUT pNomeAbrev,
                                              INPUT pNrPedcli,
                                              INPUT pNrSequencia,
                                              INPUT pItCodigo).

    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "PedItem":U).
    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN getBatchRecords IN {&hDBOTable} (INPUT  ?,
                                         INPUT  ?,
                                         INPUT  ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE {&ttTable}).

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    ASSIGN qtdAAlocarDesalocar = 0.

    EMPTY TEMP-TABLE ttOSAlocarDesalocar.

    IF pAlocarDesalocar = 1 THEN
        FOR EACH {&ttTable}
            WHERE {&ttTable}.qt-alocada  = 0
              AND {&ttTable}.cod-estabel = "":U
              AND {&ttTable}.serie       = "":U
              AND {&ttTable}.nr-nota-fis = "":U
            BY {&ttTable}.qt-pedida DESC
            BY {&ttTable}.nr-sequencia:

/*         MESSAGE 'qtdAAlocarDesalocar + {&ttTable}.qt-pedida <= pQtdAlocarDesalocar' SKIP                       */
/*                 'qtdAAlocarDesalocar + {&ttTable}.qt-pedida ' qtdAAlocarDesalocar + {&ttTable}.qt-pedida  SKIP */
/*                 'pQtdAlocarDesalocar                        ' pQtdAlocarDesalocar                              */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                 */
            IF qtdAAlocarDesalocar + {&ttTable}.qt-pedida <= pQtdAlocarDesalocar THEN DO:

                FIND LAST ttOSAlocarDesalocar NO-ERROR.
                ASSIGN seqTtOSAlocarDesalocar = IF AVAILABLE ttOSAlocarDesalocar THEN ttOSAlocarDesalocar.sequencia + 1 ELSE 1.
    
                CREATE ttOSAlocarDesalocar.
                ASSIGN ttOSAlocarDesalocar.sequencia        = seqTtOSAlocarDesalocar
                       ttOSAlocarDesalocar.r-ped-item-astec = {&ttTable}.r-Rowid.
    
                ASSIGN qtdAAlocarDesalocar = qtdAAlocarDesalocar + {&ttTable}.qt-pedida.
            END.
            ELSE DO:

                FIND LAST ttOSAlocarDesalocar NO-ERROR.
                IF AVAILABLE ttOSAlocarDesalocar THEN DO:

                    FIND FIRST b{&ttTable}
                        WHERE b{&ttTable}.r-Rowid = ttOSAlocarDesalocar.r-ped-item-astec NO-ERROR.
    
                    IF AVAILABLE b{&ttTable} THEN
                        ASSIGN qtdAAlocarDesalocar = qtdAAlocarDesalocar - b{&ttTable}.qt-pedida.

                    DELETE ttOSAlocarDesalocar.
                END.
            END.

            IF qtdAAlocarDesalocar = pQtdAlocarDesalocar THEN
                LEAVE.
        END.
    ELSE
        FOR EACH {&ttTable}
            WHERE {&ttTable}.qt-alocada <> 0
              AND {&ttTable}.cod-estabel = "":U
              AND {&ttTable}.serie       = "":U
              AND {&ttTable}.nr-nota-fis = "":U
            BY {&ttTable}.qt-pedida DESC
            BY {&ttTable}.nr-sequencia
            BY {&ttTable}.nr-os DESC:

            IF qtdAAlocarDesalocar + {&ttTable}.qt-alocada <= pQtdAlocarDesalocar THEN DO:

                FIND LAST ttOSAlocarDesalocar NO-ERROR.
    
                ASSIGN seqTtOSAlocarDesalocar = IF AVAILABLE ttOSAlocarDesalocar THEN ttOSAlocarDesalocar.sequencia + 1 ELSE 1.
                CREATE ttOSAlocarDesalocar.
                ASSIGN ttOSAlocarDesalocar.sequencia        = seqTtOSAlocarDesalocar
                       ttOSAlocarDesalocar.r-ped-item-astec = {&ttTable}.r-Rowid.
    
                ASSIGN qtdAAlocarDesalocar = qtdAAlocarDesalocar + {&ttTable}.qt-pedida.
            END.
            ELSE DO:
                FIND LAST ttOSAlocarDesalocar NO-ERROR.
    
                IF AVAILABLE ttOSAlocarDesalocar THEN DO:

                    FIND FIRST b{&ttTable}
                        WHERE b{&ttTable}.r-Rowid = ttOSAlocarDesalocar.r-ped-item-astec NO-ERROR.
    
                    IF AVAILABLE b{&ttTable} THEN
                        ASSIGN qtdAAlocarDesalocar = qtdAAlocarDesalocar - b{&ttTable}.qt-pedida.
    
                    DELETE ttOSAlocarDesalocar.
                END.
            END.

            IF qtdAAlocarDesalocar = pQtdAlocarDesalocar THEN
                LEAVE.
        END.

    IF qtdAAlocarDesalocar <> pQtdAlocarDesalocar THEN DO:

        IF pAlocarDesalocar = 1 THEN
            RUN createRowErrors (INPUT 17006,
                                 INPUT "Quantidade inv†lida para alocaá∆o.":U +
                                       "~~":U +
                                       "Quantidade Ö alocar inv†lida, pois para alocar a OS de um item do pedido, Ç necess†rio que o mesmo seja totalmente alocado.":U + CHR(10) +
                                       "Consulte no programa ~"ESPDP078~" as alocaá‰es das OSs do item do pedido.":U + CHR(10) +
                                       "Nome Abrev.: ":U + pNomeAbrev + " / Ped. Cliente: ":U + pNrPedcli + " / Nr. Seq.: ":U + TRIM(STRING(pNrSequencia)) + " / Item: ":U + pItCodigo).
/*         ELSE                                                                                                                                                                             */
/*             RUN createRowErrors (INPUT 17006,                                                                                                                                            */
/*                                  INPUT "Quantidade inv†lida para desalocaá∆o.":U +                                                                                                       */
/*                                        "~~":U +                                                                                                                                          */
/*                                        "Quantidade Ö alocar inv†lida, pois para desalocar a OS de um item do pedido, Ç necess†rio que o mesmo seja totalmente desalocado.":U + CHR(10) + */
/*                                        "Consulte no programa ~"ESPDP078~" as alocaá‰es das OSs do item do pedido.":U + CHR(10) +                                                         */
/*                                        "Nome Abrev.: ":U + pNomeAbrev + " / Ped. Cliente: ":U + pNrPedcli + " / Nr. Seq.: ":U + TRIM(STRING(pNrSequencia)) + " / Item: ":U + pItCodigo). */

        RETURN "NOK":U.
    END.

    FOR EACH ttOSAlocarDesalocar:

        RUN emptyRowErrors   IN {&hDBOTable}.
        RUN openQueryStatic  IN {&hDBOTable} (INPUT "Main":U).
        RUN emptyRowErrors   IN {&hDBOTable}.
        RUN repositionRecord IN {&hDBOTable} (INPUT ttOSAlocarDesalocar.r-ped-item-astec).
        RUN getRowErrors     IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors  IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.

        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN getRecord       IN {&hDBOTable} (OUTPUT TABLE {&ttTable}).
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.

        FIND FIRST {&ttTable} NO-ERROR.
        IF NOT AVAILABLE {&ttTable} THEN DO:
            RUN createRowErrors (INPUT 2,
                                 INPUT "Item do Pedido ASTEC":U +
                                       "~~":U +
                                       "Nome Abrev.: ":U + pNomeAbrev + " / Ped. Cliente: ":U + pNrPedcli + " / Nr. Seq.: ":U + TRIM(STRING(pNrSequencia)) + " / Item: ":U + pItCodigo).

            NEXT.
        END.

/*         MESSAGE 16 ' - ' pQtdAlocarDesalocar                   SKIP */
/*                 'pNomeAbrev             ' pNomeAbrev           SKIP */
/*                 'pNrPedcli              ' pNrPedcli            SKIP */
/*                 'pNrSequencia           ' pNrSequencia         SKIP */
/*                 'pItCodigo              ' pItCodigo            SKIP */
/*                 'pAlocarDesalocar       ' pAlocarDesalocar     SKIP */
/*                 'pQtdAlocarDesalocar    ' pQtdAlocarDesalocar       */
/*            VIEW-AS ALERT-BOX INFO BUTTONS OK.                       */

        FOR EACH {&ttTable}
            WHERE {&ttTable}.cod-estabel = "":U
              AND {&ttTable}.serie       = "":U
              AND {&ttTable}.nr-nota-fis = "":U
            BY {&ttTable}.qt-pedida DESC
            BY {&ttTable}.nr-sequencia
            BY {&ttTable}.nr-os DESC:

            IF pAlocarDesalocar <> 1 THEN
                ASSIGN {&ttTable}.qt-alocada = 0.
            ELSE DO:
                FIND FIRST ped-item
                    WHERE ped-item.nome-abrev   = {&ttTable}.nome-abrev
                      AND ped-item.nr-pedcli    = {&ttTable}.nr-pedcli
                      AND ped-item.nr-sequencia = {&ttTable}.nr-sequencia
                      AND ped-item.it-codigo    = {&ttTable}.it-codigo
                    NO-LOCK NO-ERROR.
                IF AVAIL ped-item THEN DO:
    
                    IF {&ttTable}.qt-alocada = 0 THEN DO:
                        IF ped-item.qt-log-aloca <> 0 THEN
                            ASSIGN {&ttTable}.qt-alocada = {&ttTable}.qt-pedida.

                        IF ped-item.qt-alocada   <> 0 THEN
                            ASSIGN {&ttTable}.qt-alocada = {&ttTable}.qt-pedida.

                    END. /* IF {&ttTable}.qt-alocada = 0 THEN DO: */
                    
                END. /* IF AVAIL ped-item THEN DO: */

            END. /* IF pAlocarDesalocar = 1 THEN */

        END. /* FOR EACH {&ttTable} */

        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN setRecord       IN {&hDBOTable} (INPUT TABLE {&ttTable}).
        RUN updateRecord    IN {&hDBOTable}.
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-alocarItemNotaFiscal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocarItemNotaFiscal Procedure 
PROCEDURE alocarItemNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNomeAbrev   LIKE ped-item.nome-abrev         NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedcli    LIKE ped-item.nr-pedcli          NO-UNDO.
    DEFINE INPUT  PARAMETER pNrSequencia LIKE ped-item.nr-sequencia       NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo    LIKE ped-item.it-codigo          NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstabel  LIKE nota-fiscal.cod-estabel     NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie       LIKE nota-fiscal.serie           NO-UNDO.
    DEFINE INPUT  PARAMETER pNrNotaFis   LIKE nota-fiscal.nr-nota-fis     NO-UNDO.
    DEFINE INPUT  PARAMETER pQtFaturada  LIKE it-nota-fisc.qt-faturada[1] NO-UNDO.

    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.
    DEFINE VARIABLE qtdAAlocar    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE seqTtOSAlocar AS INTEGER     NO-UNDO.

    DEFINE VARIABLE iErrorSequence LIKE RowErrors.ErrorSequence NO-UNDO.

    RUN initializeDBO IN THIS-PROCEDURE.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    RUN emptyRowErrors       IN {&hDBOTable}.
    RUN setConstraintPedItem IN {&hDBOTable} (INPUT pNomeAbrev,
                                              INPUT pNrPedcli,
                                              INPUT pNrSequencia,
                                              INPUT pItCodigo).

    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "PedItem":U).
    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN getBatchRecords IN {&hDBOTable} (INPUT  ?,
                                         INPUT  ?,
                                         INPUT  ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE {&ttTable}).

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    ASSIGN qtdAAlocar = 0.

    EMPTY TEMP-TABLE ttOSAlocarDesalocar.

    FOR EACH {&ttTable}
        WHERE {&ttTable}.cod-estabel = "":U
          AND {&ttTable}.serie       = "":U
          AND {&ttTable}.nr-nota-fis = "":U,
        FIRST ped-item
            WHERE ped-item.nome-abrev   = {&ttTable}.nome-abrev
              AND ped-item.nr-pedcli    = {&ttTable}.nr-pedcli
              AND ped-item.nr-sequencia = {&ttTable}.nr-sequencia
              AND ped-item.it-codigo    = {&ttTable}.it-codigo NO-LOCK :

        IF {&ttTable}.qt-alocada = 0 THEN DO:

            IF ped-item.qt-log-aloca <> 0 THEN
                ASSIGN {&ttTable}.qt-alocada = {&ttTable}.qt-pedida.

            IF ped-item.qt-alocada   <> 0 THEN
                ASSIGN {&ttTable}.qt-alocada = {&ttTable}.qt-pedida.

        END. /* IF AVAIL {&ttTable}.qt-alocada = 0 THEN DO: */

    END. /* FOR EACH {&ttTable} */

    FOR EACH {&ttTable}
        WHERE {&ttTable}.cod-estabel = "":U
          AND {&ttTable}.serie       = "":U
          AND {&ttTable}.nr-nota-fis = "":U
          AND {&ttTable}.qt-alocada <> 0
        BY {&ttTable}.qt-pedida DESC
        BY {&ttTable}.nr-sequencia:

        IF qtdAAlocar + {&ttTable}.qt-alocada <= pQtFaturada THEN DO:
            FIND LAST ttOSAlocarDesalocar NO-ERROR.

            ASSIGN seqTtOSAlocar = IF AVAILABLE ttOSAlocarDesalocar THEN ttOSAlocarDesalocar.sequencia + 1 ELSE 1.

            CREATE ttOSAlocarDesalocar.
            ASSIGN ttOSAlocarDesalocar.sequencia        = seqTtOSAlocar
                   ttOSAlocarDesalocar.r-ped-item-astec = {&ttTable}.r-Rowid.

            ASSIGN qtdAAlocar = qtdAAlocar + {&ttTable}.qt-alocada.
        END.
        ELSE DO:
            FIND LAST ttOSAlocarDesalocar NO-ERROR.

            IF AVAILABLE ttOSAlocarDesalocar THEN DO:
                FIND FIRST b{&ttTable}
                    WHERE b{&ttTable}.r-Rowid = ttOSAlocarDesalocar.r-ped-item-astec NO-ERROR.

                IF AVAILABLE b{&ttTable} THEN
                    ASSIGN qtdAAlocar = qtdAAlocar - b{&ttTable}.qt-alocada.

                DELETE ttOSAlocarDesalocar.
            END.
        END.
    END.

    IF qtdAAlocar <> pQtFaturada THEN DO:
        RUN createRowErrors (INPUT 17006,
                             INPUT "Quantidade inv†lida para faturar para as OSs.":U +
                                   "~~":U +
                                   "Quantidade inv†lida, pois para faturar a OS de um item da Nota Fiscal, Ç necess†rio que o mesmo seja totalmente alocado.":U + CHR(10) +
                                   "Consulte no programa ~"ESPDP078~" as alocaá‰es das OSs do item do pedido.":U + CHR(10) +
                                   "Nome Abrev.: ":U + pNomeAbrev + " / Ped. Cliente: ":U + pNrPedcli + " / Nr. Seq.: ":U + TRIM(STRING(pNrSequencia)) + " / Item: ":U + pItCodigo).

        RETURN "NOK":U.
    END.

    FOR EACH ttOSAlocarDesalocar:
        RUN emptyRowErrors   IN {&hDBOTable}.
        RUN openQueryStatic  IN {&hDBOTable} (INPUT "Main":U).
        RUN emptyRowErrors   IN {&hDBOTable}.
        RUN repositionRecord IN {&hDBOTable} (INPUT ttOSAlocarDesalocar.r-ped-item-astec).
        RUN getRowErrors     IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors  IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.

        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN getRecord       IN {&hDBOTable} (OUTPUT TABLE {&ttTable}).
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.

        FIND FIRST {&ttTable} NO-ERROR.

        IF NOT AVAILABLE {&ttTable} THEN DO:
            RUN createRowErrors (INPUT 2,
                                 INPUT "Item do Pedido ASTEC":U +
                                       "~~":U +
                                       "Nome Abrev.: ":U + pNomeAbrev + " / Ped. Cliente: ":U + pNrPedcli + " / Nr. Seq.: ":U + TRIM(STRING(pNrSequencia)) + " / Item: ":U + pItCodigo).

            NEXT.
        END.

        ASSIGN {&ttTable}.cod-estabel = pCodEstabel
               {&ttTable}.serie       = pSerie
               {&ttTable}.nr-nota-fis = pNrNotaFis.

        IF  {&ttTable}.qt-alocada   = 0 
        AND {&ttTable}.cod-estabel <> '' 
        AND {&ttTable}.serie       <> ''  
        AND {&ttTable}.nr-nota-fis <> ''  THEN
            ASSIGN {&ttTable}.qt-alocada = {&ttTable}.qt-pedida.

        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN setRecord       IN {&hDBOTable} (INPUT TABLE {&ttTable}).
        RUN updateRecord    IN {&hDBOTable}.
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
        RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            NEXT.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelarNotaFiscal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelarNotaFiscal Procedure 
PROCEDURE cancelarNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodEstabel LIKE {&DBOTable}.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie      LIKE {&DBOTable}.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER pNrNotaFis  LIKE {&DBOTable}.nr-nota-fis NO-UNDO.

    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    RUN initializeDBO  IN THIS-PROCEDURE.
    RUN emptyTtTable   IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.

    RUN emptyRowErrors          IN {&hDBOTable}.
    RUN setConstraintNotaFiscal IN {&hDBOTable} (INPUT pCodEstabel,
                                                 INPUT pSerie,
                                                 INPUT pNrNotaFis).

    RUN openQueryStatic IN {&hDBOTable} (INPUT "NotaFiscal":U).
    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN getBatchRecords IN {&hDBOTable} (INPUT  ?,
                                         INPUT  ?,
                                         INPUT  ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE {&ttTable}).

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    FOR EACH {&ttTable}:
        RUN emptyRowErrorsAux IN THIS-PROCEDURE.

        ASSIGN {&ttTable}.cod-estabel = ""
               {&ttTable}.serie       = ""
               {&ttTable}.nr-nota-fis = ""
               {&ttTable}.qt-alocada  = 0.

        EMPTY TEMP-TABLE tt-int-ped-item-astec-aux.

        CREATE tt-int-ped-item-astec-aux.
        BUFFER-COPY {&ttTable} TO tt-int-ped-item-astec-aux.

        RUN emptyRowErrors          IN {&hDBOTable}.
        RUN setConstraintNotaFiscal IN {&hDBOTable} (INPUT pCodEstabel,
                                                     INPUT pSerie,
                                                     INPUT pNrNotaFis).

        RUN openQueryStatic IN {&hDBOTable} (INPUT "NotaFiscal":U).
        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN setRecord       IN {&hDBOTable} (INPUT TABLE tt-int-ped-item-astec-aux).
        RUN updateRecord    IN {&hDBOTable}.
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN DO:
            FOR EACH RowErrorsAux:
                ASSIGN RowErrorsAux.ErrorDescription = RowErrorsAux.ErrorDescription + " - Item: ":U + {&ttTable}.it-codigo + " - Nr. OS: ":U + {&ttTable}.nr-os.
            END.

            RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).
        END.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    ELSE DO:

        FOR EACH int-ped-item-astec
            WHERE int-ped-item-astec.cod-estabel = pCodEstabel
              AND int-ped-item-astec.serie       = pSerie     
              AND int-ped-item-astec.nr-nota-fis = pNrNotaFis EXCLUSIVE-LOCK:

            ASSIGN int-ped-item-astec.cod-estabel = ""
                   int-ped-item-astec.serie       = ""
                   int-ped-item-astec.nr-nota-fis = ""
                   int-ped-item-astec.qt-alocada  = 0.

        END. /* FOR EACH int-ped-item-astec */

    END. /* IF NOT CAN-FIND(FIRST RowErrors) THEN */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyToRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyToRowErrors Procedure 
PROCEDURE copyToRowErrors PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Copiar as informaá‰es da temp-table RowErrorsAux para a RowErrors.
  Parameters:  Entrada: RowErrorsAux.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR RowErrorsAux.

    DEFINE VARIABLE iErrorSequence LIKE RowErrors.ErrorSequence NO-UNDO.

    FOR EACH RowErrorsAux:
        FIND LAST RowErrors NO-ERROR.

        ASSIGN iErrorSequence = IF AVAILABLE RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

        CREATE RowErrors.
        BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors.
        ASSIGN RowErrors.ErrorSequence = iErrorSequence.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createPedItemAstec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPedItemAstec Procedure 
PROCEDURE createPedItemAstec :
/*------------------------------------------------------------------------------
  Purpose:     Criar o registro do relacionamento Pedido Cliente X Ocorràncias
               ASTEC.
  Parameters:  Entrada: TABLE tt-int-ped-item-astec-aux.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-int-ped-item-astec-aux.

    RUN initializeDBO  IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.

    FOR EACH tt-int-ped-item-astec-aux:
        RUN emptyTtTable      IN THIS-PROCEDURE.
        RUN emptyRowErrorsAux IN THIS-PROCEDURE.

        CREATE {&ttTable}.
        BUFFER-COPY tt-int-ped-item-astec-aux TO {&ttTable}.

        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U).
        RUN emptyRowErrors  IN {&hDBOTable}.
        RUN setRecord       IN {&hDBOTable} (INPUT TABLE {&ttTable}).
        RUN createRecord    IN {&hDBOTable}.
        RUN getRowErrors    IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST RowErrorsAux) THEN DO:
            FOR EACH RowErrorsAux:
                ASSIGN RowErrorsAux.ErrorDescription = RowErrorsAux.ErrorDescription + " - Item: ":U + tt-int-ped-item-astec-aux.it-codigo + " - Nr. OS: ":U + tt-int-ped-item-astec-aux.nr-os.
            END.

            RUN copyToRowErrors IN THIS-PROCEDURE (INPUT TABLE RowErrorsAux).
        END.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowErrors Procedure 
PROCEDURE createRowErrors PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem na temp-table "RowErrors".
  Parameters:  Entrada: pErrorNumber e pErrorParameters.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pErrorNumber     LIKE RowErrors.ErrorNumber     NO-UNDO.
    DEFINE INPUT  PARAMETER pErrorParameters LIKE RowErrors.ErrorParameters NO-UNDO.

    DEFINE VARIABLE iErrorSequence LIKE RowErrors.ErrorSequence NO-UNDO.

    FIND LAST RowErrors NO-ERROR.

    ASSIGN iErrorSequence = IF AVAILABLE RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence   = iErrorSequence
           RowErrors.ErrorNumber     = pErrorNumber
           RowErrors.ErrorParameters = pErrorParameters
           RowErrors.ErrorType       = "EMS":U.

    RUN utp/ut-msgs.p (INPUT "CODTYPE":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).

    CASE RETURN-VALUE :
        WHEN "2":U THEN
            ASSIGN RowErrors.ErrorSubType = "WARNING":U.
        WHEN "3":U THEN
            ASSIGN RowErrors.ErrorSubType = "QUESTION":U.
        WHEN "4":U THEN
            ASSIGN RowErrors.ErrorSubType = "INFORMATION":U.
        OTHERWISE
            ASSIGN RowErrors.ErrorSubType = "ERROR":U.
    END CASE.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).
        
    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePedItemAstec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePedItemAstec Procedure 
PROCEDURE deletePedItemAstec :
/*------------------------------------------------------------------------------
  Purpose:     Excluir o registro do relacionamento Pedido Cliente X Ocorràncias
               ASTEC.
  Parameters:  Entrada: pNomeAbrev, pNrPedcli, pNrSequencia, pItCodigo e pNrOs.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNomeAbrev   LIKE {&DBOTable}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedcli    LIKE {&DBOTable}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrSequencia LIKE {&DBOTable}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo    LIKE {&DBOTable}.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrOs        LIKE {&DBOTable}.nr-os        NO-UNDO.

    RUN initializeDBO IN THIS-PROCEDURE.

    RUN emptyTtTable   IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.

    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U).
    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN goToKey         IN {&hDBOTable} (INPUT pNomeAbrev,
                                         INPUT pNrPedcli,
                                         INPUT pNrSequencia,
                                         INPUT pItCodigo,
                                         INPUT pNrOs).

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RUN emptyRowErrors IN {&hDBOTable}.
    RUN deleteRecord   IN {&hDBOTable}.
    RUN getRowErrors   IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy Procedure 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar o programa.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN destroyDBO IN THIS-PROCEDURE.

    IF THIS-PROCEDURE:PERSISTENT THEN
        DELETE PROCEDURE THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyDBO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyDBO Procedure 
PROCEDURE destroyDBO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar a handle da BO.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE({&hDBOTable}) THEN
        RUN destroy IN {&hDBOTable}.

    ASSIGN {&hDBOTable} = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowErrors Procedure 
PROCEDURE emptyRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     Limpar a temp-table "RowErrors".
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE RowErrors.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowErrorsAux) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowErrorsAux Procedure 
PROCEDURE emptyRowErrorsAux PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE RowErrorsAux.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyTtTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTtTable Procedure 
PROCEDURE emptyTtTable :
/*------------------------------------------------------------------------------
  Purpose:     Limpar a temp-table da BO.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE {&ttTable}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrors Procedure 
PROCEDURE getRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     Buscar a temp-table "RowErrors".
  Parameters:  Sa°da: RowErrors
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeDBO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBO Procedure 
PROCEDURE initializeDBO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar a handle da BO da tabela.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE({&hDBOTable})               OR
        {&hDBOTable}:TYPE      <> "PROCEDURE":U      OR
       ({&hDBOTable}:FILE-NAME <> "esbo/boes643.p":U   AND
        {&hDBOTable}:FILE-NAME <> "esbo/boes643.r":U) THEN
        RUN esbo/boes643.p PERSISTENT SET {&hDBOTable}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateNotaFiscal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateNotaFiscal Procedure 
PROCEDURE updateNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     Cadastrar nota fiscal no relacionamento Pedido Item X Ocorrància
               ASTEC.
  Parameters:  Entrada: pNomeAbrev, pNrPedcli, pNrSequencia, pItCodigo, pNrOs,
                        pCodEstabel, pSerie e pNrNotaFis.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNomeAbrev   LIKE {&DBOTable}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedcli    LIKE {&DBOTable}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrSequencia LIKE {&DBOTable}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo    LIKE {&DBOTable}.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrOs        LIKE {&DBOTable}.nr-os        NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstabel  LIKE {&DBOTable}.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie       LIKE {&DBOTable}.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER pNrNotaFis   LIKE {&DBOTable}.nr-nota-fis  NO-UNDO.

    RUN initializeDBO IN THIS-PROCEDURE.

    RUN emptyTtTable   IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.

    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U).
    RUN emptyRowErrors  IN {&hDBOTable}.
    RUN goToKey         IN {&hDBOTable} (INPUT pNomeAbrev,
                                         INPUT pNrPedcli,
                                         INPUT pNrSequencia,
                                         INPUT pItCodigo,
                                         INPUT pNrOs).

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE {&ttTable}).

    FIND FIRST {&ttTable} NO-ERROR.

    IF NOT AVAILABLE {&ttTable} THEN DO:
        RETURN "NOK":U.
    END.

    ASSIGN {&ttTable}.cod-estabel = pCodEstabel
           {&ttTable}.serie       = pSerie
           {&ttTable}.nr-nota-fis = pNrNotaFis.

    RUN setRecord      IN {&hDBOTable} (INPUT TABLE {&ttTable}).
    RUN emptyRowErrors IN {&hDBOTable}.
    RUN updateRecord   IN {&hDBOTable}.
    RUN getRowErrors   IN {&hDBOTable} (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

