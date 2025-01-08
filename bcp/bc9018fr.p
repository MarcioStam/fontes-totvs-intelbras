{include/i-prgvrs.i BC9018FR 2.00.00.000}  /*** 010000 ***/
{include/i_dbvers.i}  /* versao das bases e bases instaladas */
/********************************************************************************
**  Programa: BC9018FR.P                                    
**  Data....: AGOSTO / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para buscar etiqueta do endere‡o de picking automaticamente.
**            Usada nas transa‡äes de picking no coletor nas  reas de flow rack.
********************************************************************************/
{utp/ut-glob.i}                
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pCodEstabel AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCodLocal   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pIdBox      AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER pCodItem    AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER pIdEtiqueta LIKE wm-etiqueta.id-etiqueta  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

FIND FIRST wm-box NO-LOCK
    WHERE wm-box.cod-estabel = pCodEstabel
      AND wm-box.cod-local   = pCodLocal
      AND wm-box.id-box      = pIdbox NO-ERROR.

IF NOT AVAIL wm-box THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Endere‡o WMS.",
                       INPUT "EMS",
                       INPUT "ERROR").
    RETURN "NOK".
END.

FOR FIRST wm-box-picking NO-LOCK
    WHERE wm-box-picking.cod-estabel = wm-box.cod-estabel
      AND wm-box-picking.cod-local   = wm-box.cod-local
      AND wm-box-picking.id-box-comp = wm-box.id-box:
END.

IF NOT AVAIL wm-box-picking THEN
    RETURN "OK".

/* verifica se o box pertence a picking de flow rack */
FOR FIRST ext-wm-picking NO-LOCK
    WHERE ext-wm-picking.cod-estabel = wm-box-picking.cod-estabel
      AND ext-wm-picking.cod-local   = wm-box-picking.cod-local
      AND ext-wm-picking.cod-picking = wm-box-picking.cod-picking
      AND ext-wm-picking.log-flow-rack = YES:
END.

IF NOT AVAIL ext-wm-picking THEN 
    RETURN "OK".

FIND FIRST wm-box-saldo-etiqueta NO-LOCK
    WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box.cod-estabel
      AND wm-box-saldo-etiqueta.cod-local   = wm-box.cod-local
      AND wm-box-saldo-etiqueta.id-box      = wm-box.id-box
      AND CAN-FIND(FIRST wm-box-saldo NO-LOCK
                   WHERE wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
                     AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local
                     AND wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo
                     AND wm-box-saldo.cod-item    = pCodItem) NO-ERROR.

IF AVAIL wm-box-saldo-etiqueta THEN DO:
    ASSIGN pIdEtiqueta = wm-box-saldo-etiqueta.id-etiqueta.
END.
ELSE DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "NÆo encontrada etiqueta no endere‡o de Flow Rack para retirada.",
                       INPUT "EMS",
                       INPUT "ERROR").
    RETURN "NOK".
END.

RETURN "OK".
/*******************************************************************/
PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    END.

    RETURN "OK":U.    

END PROCEDURE.




