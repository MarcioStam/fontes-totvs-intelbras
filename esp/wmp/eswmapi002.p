/********************************************************************************
**  Programa: ESWMAPI002.P
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para ajuste da capacidade do endere‡o de flow rack de acordo
**            com a quantidade de caixas parametrizada no WM0210, permitindo
**            o correto ressuprimento.
********************************************************************************/
{include/i-prgvrs.i ESWMAPI002 2.00.00.001}  /*** 010001 ***/
{include/i_dbvers.i}
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pCodEstabel AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCodLocal   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCodPicking AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE VARIABLE de-qtd-item-embal AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtd-volume     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtd-peso       AS DECIMAL     NO-UNDO.

FOR FIRST wm-picking NO-LOCK
    WHERE wm-picking.cod-estabel = pCodEstabel
      AND wm-picking.cod-local   = pCodLocal
      AND wm-picking.cod-picking = pCodPicking:
END.

IF NOT AVAIL wm-picking THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "µrea de Picking").
    RETURN "NOK".
END.

FOR FIRST ext-wm-picking OF wm-picking NO-LOCK:
END.

IF NOT AVAIL ext-wm-picking
OR ext-wm-picking.log-flow-rack = NO THEN  /* somente para flow rack */
    RETURN "OK".

FOR FIRST wm-item-picking OF wm-picking NO-LOCK:
END.

IF NOT AVAIL wm-item-picking THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Item da  rea de Picking").
    RETURN "NOK".
END.

FOR FIRST wm-item-embalagem-local NO-LOCK
     WHERE wm-item-embalagem-local.cod-estabel   = wm-item-picking.cod-estabel
       AND wm-item-embalagem-local.cod-local     = wm-item-picking.cod-local
       AND wm-item-embalagem-local.cod-embalagem = wm-item-picking.cod-emb-area
       AND wm-item-embalagem-local.cod-item      = wm-item-picking.cod-item:
    ASSIGN de-qtd-item-embal = wm-item-embalagem-local.qtd-item-emb
           de-qtd-volume     = wm-item-embalagem-local.qtd-volume
           de-qtd-peso       = wm-item-embalagem-local.qtd-peso.
END.

IF NOT AVAIL wm-item-embalagem-local THEN DO: /* procura na embal filha */
    FOR FIRST wm-item-embalagem-local NO-LOCK
         WHERE wm-item-embalagem-local.cod-estabel   = wm-item-picking.cod-estabel
           AND wm-item-embalagem-local.cod-local     = wm-item-picking.cod-local
           AND wm-item-embalagem-local.cod-item      = wm-item-picking.cod-item
           AND wm-item-embalagem-local.cod-emb-item  = wm-item-picking.cod-emb-area:
        ASSIGN de-qtd-item-embal = wm-item-embalagem-local.qtd-emb-item
               de-qtd-volume     = wm-item-embalagem-local.qtd-volume-item
               de-qtd-peso       = wm-item-embalagem-local.qtd-peso-item.
    END.
END.

IF NOT AVAIL wm-item-embalagem-local THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Relacionamento Item X Embalagem da  rea de Picking").
    RETURN "NOK".
END.

FOR FIRST wm-item NO-LOCK
    WHERE wm-item.cod-item = wm-item-picking.cod-item:
END.

FOR EACH wm-box-picking OF wm-picking NO-LOCK,
    FIRST wm-box EXCLUSIVE-LOCK
        WHERE wm-box.cod-estabel = wm-box-picking.cod-estabel
          AND wm-box.cod-local   = wm-box-picking.cod-local
          AND wm-box.id-box      = wm-box-picking.id-box:

    ASSIGN wm-box.qtd-capacidade-peso = 999999999 /* (ext-wm-picking.qtd-max-pick * wm-item-embalagem-local.qtd-peso)
                                      + (ext-wm-picking.qtd-max-pick * de-qtd-item-embal) -> controla ressup pela UA */
            wm-box.qtd-capacidade-ua  = ext-wm-picking.qtd-max-pick * de-qtd-volume.
END.

RETURN "OK".

/************************************************************/

PROCEDURE piCreateError :
    DEFINE INPUT PARAMETER pErrorNumber     AS INTE NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHAR NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = i-sequencia
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorParameters  = pErrorParameters
           RowErrors.ErrorType        = "EMS":U
           RowErrors.ErrorSubType     = "ERROR":U
           RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "help",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    
    IF TRIM(RowErrors.ErrorHelp) = "" THEN
        ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorDescription.

    RETURN "OK":U.
END PROCEDURE.







