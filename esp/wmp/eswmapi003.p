/********************************************************************************
**  Programa: ESWMAPI003.P
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para gera‡Æo de etiqueta e saldo para ressuprimento de flow rack.
********************************************************************************/
{include/i-prgvrs.i ESWMAPI003 2.00.00.001}  /*** 010001 ***/
{include/i_dbvers.i}
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pRowid      AS ROWID       NO-UNDO.
DEFINE INPUT  PARAMETER pIdEtiqueta AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER pIdEtiqNova AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE TEMP-TABLE ttWm-Etiqueta NO-UNDO LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttSerial NO-UNDO
       FIELD de-serial AS DECIMAL.

DEFINE BUFFER bf-box-saldo FOR wm-box-saldo.
DEFINE BUFFER bf-box-saldo-etiqueta FOR wm-box-saldo-etiqueta.
DEFINE BUFFER bf-etiqueta FOR wm-etiqueta.
DEFINE BUFFER bf-box-sdo-alocad FOR wms-box-sdo-alocad.

DEFINE VARIABLE h-bosc074 AS HANDLE      NO-UNDO.

FOR FIRST wm-box-movto NO-LOCK
    WHERE ROWID(wm-box-movto) = pRowid:
END.

IF NOT AVAIL wm-box-movto THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Movimento de Sa¡da").
    RETURN "NOK".
END.

IF wm-box-movto.ind-tipo-movto <> 2 THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Movimento deve ser de Sa¡da").
    RETURN "NOK".
END.

IF wm-box-movto.ind-status-movto = 3 THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Movimento j  concluido").
    RETURN "NOK".
END.

FOR FIRST wm-etiqueta NO-LOCK
    WHERE wm-etiqueta.id-etiqueta = pIdEtiqueta:
END.

IF NOT AVAIL wm-etiqueta THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Etiqueta").
    RETURN "NOK".
END.

IF wm-etiqueta.cod-item <> wm-box-movto.cod-item THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Item da etiqueta difere do movimento").
    RETURN "NOK".
END.

IF wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado < wm-box-movto.qti-embalagem * wm-box-movto.qtd-item THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Etiqueta sem saldo suficiente").
    RETURN "NOK".
END.

FOR FIRST wm-box-saldo-etiqueta NO-LOCK
    WHERE wm-box-saldo-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta:
END.

IF NOT AVAIL wm-box-saldo-etiqueta THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Saldo da Etiqueta").
    RETURN "NOK".
END.

IF wm-box-saldo-etiqueta.id-box <> wm-box-movto.id-box THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Etiqueta armazenada em endere‡o diferente do solicitado").
    RETURN "NOK".
END.

FOR FIRST wm-box-saldo NO-LOCK
    WHERE wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
      AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local
      AND wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo:
END.

IF NOT AVAIL wm-box-saldo THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Saldo da Etiqueta").
    RETURN "NOK".
END.

IF wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq < wm-box-movto.qti-embalagem * wm-box-movto.qtd-item THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Saldo insuficiente para movimenta‡Æo").
    RETURN "NOK".
END.

FOR FIRST wm-item NO-LOCK
    WHERE wm-item.cod-item = wm-etiqueta.cod-item:
END.

BLOCO:
DO TRANSACTION ON ERROR UNDO BLOCO, RETURN "NOK":

    EMPTY TEMP-TABLE ttWm-etiqueta.

    CREATE ttWm-etiqueta.
    ASSIGN ttWm-etiqueta.cod-estabel         = wm-etiqueta.cod-estabel
           ttWm-etiqueta.cod-item            = wm-etiqueta.cod-item
           ttWm-etiqueta.cod-refer           = wm-etiqueta.cod-refer
           ttWm-etiqueta.cod-lote            = wm-etiqueta.cod-lote
           ttWm-etiqueta.qtd-item            = wm-box-movto.qti-embalagem * wm-box-movto.qtd-item
           ttWm-etiqueta.cod-embalagem       = wm-etiqueta.cod-embalagem
           ttWm-etiqueta.cod-usuario         = c-seg-usuario
           ttWm-etiqueta.dt-validade-lote    = wm-etiqueta.dt-validade-lote
           ttWm-etiqueta.nr-ord-prod         = wm-etiqueta.nr-ord-prod
           ttWm-etiqueta.dt-geracao          = TODAY
           ttWm-etiqueta.hr-geracao          = TIME
           ttWm-etiqueta.ind-sit-agrupador   = wm-etiqueta.ind-sit-agrupador
           ttWm-etiqueta.log-impressa        = YES
           ttwm-etiqueta.id-carga            = 0
           ttwm-etiqueta.qtd-peso            = ttWm-etiqueta.qtd-item * wm-item.qtd-peso
           .

    IF NOT VALID-HANDLE(h-bosc074) THEN 
        RUN scbo/bosc074.p PERSISTENT SET h-bosc074.

    RUN openQueryStatic IN h-bosc074 (INPUT "Main").
    RUN emptyRowErrors IN h-bosc074.
    RUN geraEtiquetas IN h-bosc074 (INPUT TABLE ttWm-etiqueta,
                                    INPUT 1,
                                    OUTPUT TABLE ttSerial).

    IF  RETURN-VALUE <> "OK":U THEN
        RUN getRowErrors IN h-bosc074 (OUTPUT TABLE RowErrors).

    RUN destroy IN h-bosc074.
    ASSIGN h-bosc074 = ?.

    IF CAN-FIND(FIRST RowErrors) THEN
        UNDO BLOCO, RETURN "NOK".

    FIND FIRST ttSerial NO-LOCK NO-ERROR.
    FIND FIRST bf-etiqueta EXCLUSIVE-LOCK
        WHERE bf-etiqueta.id-etiqueta = ttSerial.de-serial NO-ERROR.

    IF NOT AVAIL bf-etiqueta THEN DO:
        RUN piCreateError (INPUT 17006,
                           INPUT "NÆo foi poss¡vel gerar etiqueta. Verifique parametriza‡Æo.",
                           INPUT "EMS",
                           INPUT "ERROR").  
        UNDO BLOCO, RETURN "NOK".
    END.

    ASSIGN bf-etiqueta.log-reportada        = YES
           bf-etiqueta.ind-leitura-etiqueta = 2
           bf-etiqueta.cod-embalagem        = wm-box-movto.cod-embalagem.

    FIND CURRENT bf-etiqueta NO-LOCK NO-ERROR.

    CREATE bf-box-saldo.
    ASSIGN bf-box-saldo.cod-estabel      = wm-box-movto.cod-estabel
           bf-box-saldo.cod-local        = wm-box-movto.cod-local
           bf-box-saldo.id-docto         = wm-box-movto.id-docto
           bf-box-saldo.num-seq-item     = wm-box-movto.num-seq-item
           bf-box-saldo.cod-cliente      = wm-box-saldo.cod-cliente
           bf-box-saldo.cod-embalagem    = bf-etiqueta.cod-embalagem
           bf-box-saldo.cod-item         = wm-box-saldo.cod-item
           bf-box-saldo.cod-refer        = wm-box-saldo.cod-refer
           bf-box-saldo.cod-lote         = wm-box-saldo.cod-lote
           bf-box-saldo.dt-atua-saldo    = TODAY
           bf-box-saldo.dt-transacao     = TODAY
           bf-box-saldo.id-box           = wm-box-saldo.id-box
           bf-box-saldo.id-saldo         = NEXT-VALUE(id-saldo-wms)
           bf-box-saldo.ind-status-box   = 1
           bf-box-saldo.ind-status-saldo = 3
           bf-box-saldo.qtd-item         = bf-etiqueta.qtd-item
           bf-box-saldo.qtd-item-bloq    = 0
           bf-box-saldo.qtd-original     = bf-box-saldo.qtd-item
           bf-box-saldo.id-movto         = wm-box-movto.id-movto.

    CREATE bf-box-saldo-etiqueta.
    ASSIGN bf-box-saldo-etiqueta.cod-estabel = bf-box-saldo.cod-estabel
           bf-box-saldo-etiqueta.cod-local   = bf-box-saldo.cod-local
           bf-box-saldo-etiqueta.id-saldo    = bf-box-saldo.id-saldo
           bf-box-saldo-etiqueta.id-box      = bf-box-saldo.id-box
           bf-box-saldo-etiqueta.id-etiqueta = bf-etiqueta.id-etiqueta
           bf-box-saldo-etiqueta.dt-ent-saldo = TODAY
           bf-box-saldo-etiqueta.id-docto     = wm-box-movto.id-docto
           bf-box-saldo-etiqueta.num-seq-item = wm-box-movto.num-seq-item.

    /* ajuste original */
    FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item-retirado + bf-etiqueta.qtd-item.

    FIND CURRENT wm-box-saldo EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN wm-box-saldo.qtd-item-bloq = wm-box-saldo.qtd-item-bloq + bf-etiqueta.qtd-item.

    /* ajuste aloca‡Æo original */
    FOR FIRST wms-box-sdo-alocad EXCLUSIVE-LOCK
         WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel
           AND wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local
           AND wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente
           AND wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box
           AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto           
           AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
           AND wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item
           AND wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer
           AND wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote
           AND wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem:

        ASSIGN wms-box-sdo-alocad.qtd-alocada = wms-box-sdo-alocad.qtd-alocada - bf-etiqueta.qtd-item.
        
        IF wms-box-sdo-alocad.qtd-alocada <= wms-box-sdo-alocad.qtd-item-retir THEN
            DELETE wms-box-sdo-alocad.
    END.

    /* ajuste aloca‡Æo nova */
    FOR FIRST bf-box-sdo-alocad EXCLUSIVE-LOCK
         WHERE bf-box-sdo-alocad.cod-estabel   = bf-box-saldo.cod-estabel
           AND bf-box-sdo-alocad.cod-local     = bf-box-saldo.cod-local
           AND bf-box-sdo-alocad.cod-cliente   = bf-box-saldo.cod-cliente
           AND bf-box-sdo-alocad.id-box        = bf-box-saldo.id-box
           AND bf-box-sdo-alocad.id-docto      = wm-box-movto.id-docto           
           AND bf-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
           AND bf-box-sdo-alocad.cod-item      = bf-box-saldo.cod-item
           AND bf-box-sdo-alocad.cod-refer     = bf-box-saldo.cod-refer
           AND bf-box-sdo-alocad.cod-lote      = bf-box-saldo.cod-lote
           AND bf-box-sdo-alocad.cod-embalagem = bf-box-saldo.cod-embalagem:
    END.

    IF NOT AVAIL bf-box-sdo-alocad THEN DO:
        CREATE bf-box-sdo-alocad.
        ASSIGN bf-box-sdo-alocad.cod-estabel   = bf-box-saldo.cod-estabel
               bf-box-sdo-alocad.cod-local     = bf-box-saldo.cod-local
               bf-box-sdo-alocad.cod-cliente   = bf-box-saldo.cod-cliente 
               bf-box-sdo-alocad.id-box        = bf-box-saldo.id-box
               bf-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
               bf-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
               bf-box-sdo-alocad.cod-item      = bf-box-saldo.cod-item
               bf-box-sdo-alocad.cod-refer     = bf-box-saldo.cod-refer
               bf-box-sdo-alocad.cod-lote      = bf-box-saldo.cod-lote
               bf-box-sdo-alocad.cod-embalagem = bf-box-saldo.cod-embalagem.
    END.

    ASSIGN bf-box-sdo-alocad.qtd-alocada = bf-box-sdo-alocad.qtd-alocada + bf-etiqueta.qtd-item.

    IF wm-box-saldo.qtd-item-bloq >= wm-box-saldo.qtd-item THEN DO: /* elimina saldo se retirada zerar */
        DELETE wm-box-saldo.
        FIND CURRENT wm-box-saldo-etiqueta EXCLUSIVE-LOCK NO-ERROR.
        DELETE wm-box-saldo-etiqueta.
    END.

    ASSIGN pIdEtiqNova = bf-etiqueta.id-etiqueta.

    RELEASE wm-etiqueta NO-ERROR.
    RELEASE wm-box-saldo NO-ERROR.
    RELEASE wms-box-sdo-alocad NO-ERROR.

END. /* bloco / TRANS */


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







