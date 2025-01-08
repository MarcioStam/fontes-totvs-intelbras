/********************************************************************************
**  Programa: WM2010RP-UPC.P 
**  Data....: AGOSTO / 2022
**  Autor...: STOUT / SCM Concept 
**  Objetivo: UPC Atualizaá∆o Inventario WMS
**            Gravar embalagem e ocupacao do endereáo corretamente nos endereáos
**            de flow rack, devido Ö falha no sistema padr∆o.
********************************************************************************/

{include/i-epc200.i1}

DEFINE INPUT PARAM p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

MESSAGE p-ind-event
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

IF p-ind-event = "AfterCreateWM-BOX-SALDO" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "rowid(wm-box-saldo)":

        FIND FIRST wm-box-saldo NO-LOCK
            WHERE ROWID(wm-box-saldo) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
    END.

    IF NOT AVAIL wm-box-saldo THEN
        RETURN "OK".

    FOR FIRST wm-box-picking NO-LOCK
        WHERE wm-box-picking.cod-estabel = wm-box-saldo.cod-estabel
          AND wm-box-picking.cod-local   = wm-box-saldo.cod-local
          AND wm-box-picking.id-box-comp = wm-box-saldo.id-box:
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

    IF AVAIL ext-wm-picking THEN 
        RUN piTrataFlowRack.

    RETURN "OK".

END.

/*********************************************************************/
PROCEDURE piTrataFlowRack:
    DEFINE VARIABLE l-embal AS LOGICAL     NO-UNDO.
    
    FOR FIRST wm-item-picking NO-LOCK
        WHERE wm-item-picking.cod-estabel = wm-box-picking.cod-estabel
          AND wm-item-picking.cod-local   = wm-box-picking.cod-local  
          AND wm-item-picking.cod-picking = wm-box-picking.cod-picking
          AND wm-item-picking.cod-item    = wm-box-saldo.cod-item:
    END.

    IF AVAIL wm-item-picking
    AND wm-item-picking.cod-emb-area <> wm-box-saldo.cod-embalagem THEN DO:
        FIND CURRENT wm-box-saldo EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN wm-box-saldo.cod-embalagem = wm-item-picking.cod-emb-area.
        ASSIGN l-embal = YES.
    END.

    IF l-embal THEN 
        RUN calculaCapacidadeEndereco.

    RETURN "OK".
END PROCEDURE.


PROCEDURE calculaCapacidadeEndereco:
    DEF BUFFER bf-box-saldo FOR wm-box-saldo.

    DEF VAR de-qtd-capacidade-ua    LIKE wm-box.qtd-capacidade-ua-util  NO-UNDO.
    DEF VAR de-qtd-capacidade-peso  LIKE wm-box.qtd-capacidade-peso-util NO-UNDO.

    FOR EACH bf-box-saldo
        WHERE bf-box-saldo.cod-estabel = wm-box-saldo.cod-estabel 
          AND bf-box-saldo.cod-local   = wm-box-saldo.cod-local 
          AND bf-box-saldo.id-box      = wm-box-saldo.id-box NO-LOCK,
        FIRST wm-item NO-LOCK
          WHERE wm-item.cod-item = bf-box-saldo.cod-item:

        FOR FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = bf-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local     = bf-box-saldo.cod-local
               AND wm-item-embalagem-local.cod-item      = bf-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-embalagem = bf-box-saldo.cod-embalagem:
        END.

        IF AVAIL wm-item-embalagem-local THEN DO:
            ASSIGN de-qtd-capacidade-ua = de-qtd-capacidade-ua + wm-item-embalagem-local.qtd-volume
                   de-qtd-capacidade-peso = de-qtd-capacidade-peso
                                          + wm-item-embalagem-local.qtd-peso
                                          + (( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq + wm-box-saldo.qtd-pendente ) * wm-item.qtd-peso ).
        END.
        ELSE DO:
            FOR FIRST wm-item-embalagem-local NO-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel   = bf-box-saldo.cod-estabel
                   AND wm-item-embalagem-local.cod-local     = bf-box-saldo.cod-local
                   AND wm-item-embalagem-local.cod-item      = bf-box-saldo.cod-item
                   AND wm-item-embalagem-local.cod-emb-item  = bf-box-saldo.cod-embalagem:
                ASSIGN de-qtd-capacidade-ua = de-qtd-capacidade-ua + wm-item-embalagem-local.qtd-volume-item
                       de-qtd-capacidade-peso = de-qtd-capacidade-peso
                                              + wm-item-embalagem-local.qtd-peso-item
                                              + (( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq + wm-box-saldo.qtd-pendente ) * wm-item.qtd-peso ).
            END.
        END.
    END.

    FOR FIRST wm-box EXCLUSIVE-LOCK
        WHERE wm-box.cod-estabel = wm-box-saldo.cod-estabel
          AND wm-box.cod-local   = wm-box-saldo.cod-local
          AND wm-box.id-box      = wm-box-saldo.id-box:
        ASSIGN wm-box.qtd-capacidade-ua-util = de-qtd-capacidade-ua
               wm-box.qtd-capacidade-peso-util = de-qtd-capacidade-peso.
    END.

    RETURN "OK".

END PROCEDURE.

