{include/i-prgvrs.i ESWMAPI005 2.00.00.000}  /*** 010000 ***/
{include/i_dbvers.i}  /* versao das bases e bases instaladas */
/********************************************************************************
**  Programa: ESWMAPI005
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para buscar etiqueta do endere‡o de picking automaticamente.
**            Usada nas transa‡äes de picking no coletor.
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

FIND FIRST wm-box-picking NO-LOCK
    WHERE wm-box-picking.cod-estabel = wm-box.cod-estabel
      AND wm-box-picking.cod-local   = wm-box.cod-local
      AND wm-box-picking.id-box-comp = wm-box.id-box NO-ERROR.

IF NOT AVAIL wm-box-picking THEN 
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

IF NOT AVAIL wm-box-saldo-etiqueta THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "NÆo encontrado saldo v lido neste endere‡o.",
                       INPUT "EMS",
                       INPUT "ERROR").
    RETURN "NOK".
END.
ELSE 
    ASSIGN pIdEtiqueta = wm-box-saldo-etiqueta.id-etiqueta.

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



