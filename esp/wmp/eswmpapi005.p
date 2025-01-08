&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{utp/ut-glob.i}

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piGravaEtiqPacking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaEtiqPacking Procedure 
PROCEDURE piGravaEtiqPacking :
/*------------------------------------------------------------------------------
  Purpose: Cria wms-etiq-packing
  Notes:   Carlos Daniel - 15/09/2016    
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-estabel    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-codigo     AS DECIMAL   NO-UNDO.

DEFINE VARIABLE c-aux AS CHARACTER NO-UNDO.

FIND LAST wms-etiq-packing NO-LOCK USE-INDEX wmstqpck-id 
    WHERE SUBSTRING(STRING(wms-etiq-packing.val-etiq-packing),1,8) =
    (STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99")) NO-ERROR.

IF AVAIL wms-etiq-packing THEN DO:
    ASSIGN c-aux = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") +
                   STRING(INTEGER(SUBSTRING(STRING(wms-etiq-packing.val-etiq-packing),9,7)) + 1,"9999999").
END.
ELSE 
    ASSIGN c-aux = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "0000001".

CREATE wms-etiq-packing.
ASSIGN wms-etiq-packing.val-etiq-packing = DECIMAL(c-aux)
       wms-etiq-packing.cod-estabel      = p-estabel
       wms-etiq-packing.dt-geracao       = TODAY
       wms-etiq-packing.hra-gerac        = REPLACE(STRING(TIME,"hh:mm:ss"),":","")
       wms-etiq-packing.cod-usuario      = c-seg-usuario
       wms-etiq-packing.log-impressa     = YES
       wms-etiq-packing.idi-tip-gerac    = 2
       wms-etiq-packing.cod-livre-1      = "eswmp013".

ASSIGN p-codigo = DECIMAL(c-aux).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piImpressao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao Procedure 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-estabel    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-quantidade AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-impressora AS CHARACTER NO-UNDO.

DEFINE VARIABLE d-codigo AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.

RUN piValidate(INPUT p-impressora).

IF RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

    {esapi/esapi016inic.i} /*inicializa parƒmetros impressora*/

    DO i-cont = 1 TO p-quantidade:

        RUN piGravaEtiqPacking(INPUT p-estabel,
                               OUTPUT d-codigo).

        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO90,50^BY2^BCN,177,N,N,N,N^FD" d-codigo "^FS" SKIP.
        PUT UNFORMATTED "^FO170,235^A0N,34,34^FD" d-codigo "^FS" SKIP.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.

OUTPUT CLOSE.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piReimpressao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReimpressao Procedure 
PROCEDURE piReimpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-estabel     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-packing-ini AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER p-packing-fim AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER p-impressora  AS CHARACTER NO-UNDO.

RUN piValidate(INPUT p-impressora).

IF RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

    {esapi/esapi016inic.i} /*inicializa parƒmetros impressora*/

    FOR EACH wms-etiq-packing
        WHERE wms-etiq-packing.val-etiq-packing >= p-packing-ini
        AND   wms-etiq-packing.val-etiq-packing <= p-packing-fim
        AND   wms-etiq-packing.cod-estabel       = p-estabel EXCLUSIVE-LOCK:

        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO90,50^BY2^BCN,177,N,N,N,N^FD" wms-etiq-packing.val-etiq-packing "^FS" SKIP.
        PUT UNFORMATTED "^FO170,235^A0N,34,34^FD" wms-etiq-packing.val-etiq-packing "^FS" SKIP.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        ASSIGN wms-etiq-packing.num-livre-1 = num-livre-1 + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate Procedure 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-impressora AS CHARACTER NO-UNDO.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.

IF p-impressora = "" THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 4306,
                       INPUT c-seg-usuario).
    RETURN "NOK".
END.
ELSE DO:
    IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:
        ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
               cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4306,
                               INPUT c-seg-usuario).
            RETURN "NOK".
        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora    = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4306,
                               INPUT c-seg-usuario).
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4306,
                               INPUT c-seg-usuario).
            RETURN "NOK".
        END.

        ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
               cLayout  = ENTRY(2, p-impressora, ":":U).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4306,
                               INPUT c-seg-usuario).
            RETURN "NOK".        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4306,
                               INPUT c-seg-usuario).
            RETURN "NOK".
        END.
    END.

    ASSIGN v_nom_disposit_so = "".

    IF AVAIL imprsor_usuar THEN
        ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

    IF v_nom_disposit_so = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Impressora inv lida.").
        RETURN "NOK".
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

