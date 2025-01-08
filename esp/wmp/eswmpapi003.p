/********************************************************************************
**
** PROAGRAMA: ESWMPAPI003 - API Especifica para Verificacao Saldo WMS (TOT e DISP)
** 
**
**
*******************************************************************************/
{include/i-prgvrs.i WM9055 2.00.00.000}  /*** 010000 ***/

{method/dbotterr.i}
{cdp/cd0666.i}

DEFINE INPUT PARAMETER p-cod-estabel    LIKE wms-box-sdo-alocad.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER p-cod-local      LIKE wms-box-sdo-alocad.cod-local   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-item       LIKE wms-box-sdo-alocad.cod-item    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-refer      LIKE wms-box-sdo-alocad.cod-refer   NO-UNDO.
DEFINE OUTPUT PARAMETER p-qtd-total     LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEFINE OUTPUT PARAMETER p-qtd-disp      LIKE wm-saldo-estoque.qtd-liberada  NO-UNDO.
DEFINE OUTPUT PARAMETER p-qtd-bloq      LIKE wm-saldo-estoque.qtd-liberada  NO-UNDO. 
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE BUFFER b-wms-item-fornec-embal FOR wms-item-fornec-embal.

FIND FIRST wm-local NO-LOCK
     WHERE wm-local.cod-estabel = p-cod-estabel
       AND wm-local.cod-local   = p-cod-local NO-ERROR.
IF NOT AVAIL wm-local THEN DO:
    RUN piCreateError IN THIS-PROCEDURE (INPUT 56,
                                         INPUT 'Dep¢sito no WMS',
                                         INPUT 'EMS':U,
                                         INPUT 'ERROR':U).
END.

FIND FIRST wm-item NO-LOCK
     WHERE wm-item.cod-item = p-cod-item NO-ERROR.
IF NOT AVAIL wm-item THEN DO:
    RUN piCreateError IN THIS-PROCEDURE (INPUT 56,
                                         INPUT "Item " + STRING(p-cod-item),
                                         INPUT 'EMS':U,
                                         INPUT 'ERROR':U).
END.
ELSE DO:
    IF wm-item.ind-tipo-contr-est = 4 THEN DO:
        FIND FIRST wm-ref-item NO-LOCK
             WHERE wm-ref-item.cod-item  = p-cod-item
               AND wm-ref-item.cod-refer = p-cod-refer NO-ERROR.
        IF NOT AVAIL wm-ref-item THEN
            RUN piCreateError (INPUT 56,
                               INPUT 'Referˆncia ' + p-cod-refer + ' do Item ' + p-cod-item,
                               INPUT 'EMS':U,
                               INPUT 'ERROR':U).
    END.
END.

IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:

    FOR EACH RowErrors:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = rowErrors.errorNumber
               tt-erro.mensagem = rowErrors.errorDescription. 
    END.

    RETURN 'NOK':U.
END.

ASSIGN p-qtd-total = 0
       p-qtd-disp  = 0
       p-qtd-bloq  = 0.

bloco:
FOR EACH wm-box-saldo NO-LOCK
   WHERE wm-box-saldo.cod-estabel       = p-cod-estabel
     AND wm-box-saldo.cod-local         = p-cod-local
     AND wm-box-saldo.cod-item          = p-cod-item
     AND wm-box-saldo.cod-refer         = p-cod-refer
     AND wm-box-saldo.ind-status-saldo  = 3:

    FIND FIRST wm-box NO-LOCK
         WHERE wm-box.cod-estabel = wm-box-saldo.cod-estabel
           AND wm-box.cod-local   = wm-box-saldo.cod-local
           AND wm-box.id-box      = wm-box-saldo.id-box NO-ERROR.

    ASSIGN p-qtd-total = p-qtd-total + (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq)
           p-qtd-disp  = p-qtd-disp  + (IF wm-box.log-bloq-ret = NO  THEN (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) ELSE 0)
           p-qtd-bloq  = p-qtd-bloq  + (IF wm-box.log-bloq-ret = YES THEN (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) ELSE 0).
END.


bloco:
FOR EACH wms-box-sdo-alocad NO-LOCK
   WHERE wms-box-sdo-alocad.cod-estabel = p-cod-estabel
     AND wms-box-sdo-alocad.cod-local   = p-cod-local
     AND wms-box-sdo-alocad.cod-cliente = 0
     AND wms-box-sdo-alocad.cod-item    = p-cod-item
     AND wms-box-sdo-alocad.cod-refer   = p-cod-refer:

    ASSIGN p-qtd-disp = p-qtd-disp - (wms-box-sdo-alocad.qtd-alocada - wms-box-sdo-alocad.qtd-item-retir).
END.

FIND FIRST wm-item-picking NO-LOCK
     WHERE wm-item-picking.cod-estabel  = p-cod-estabel
       AND wm-item-picking.cod-local    = p-cod-local
       AND wm-item-picking.cod-item     = p-cod-item
       AND (wm-item-picking.cod-refer    = p-cod-refer
        OR wm-item-picking.cod-refer    = '') NO-ERROR.
IF AVAIL wm-item-picking THEN DO:
    
    bloco:
    FOR EACH wm-aloca-saldo NO-LOCK
       WHERE wm-aloca-saldo.cod-estabel = p-cod-estabel
         AND wm-aloca-saldo.cod-local   = p-cod-local
         AND wm-aloca-saldo.cod-cliente = 0
         AND wm-aloca-saldo.cod-item    = p-cod-item
         AND wm-aloca-saldo.cod-refer   = p-cod-refer:

        FIND FIRST wm-box-picking NO-LOCK
             WHERE wm-box-picking.cod-estabel   = wm-item-picking.cod-estabel
               AND wm-box-picking.cod-local     = wm-item-picking.cod-local
               AND wm-box-picking.cod-picking   = wm-item-picking.cod-picking NO-ERROR.

        ASSIGN p-qtd-disp = p-qtd-disp - wm-aloca-saldo.qtd-item.

    END.

END.

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


