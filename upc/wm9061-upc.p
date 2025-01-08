/********************************************************************************
**  Programa: WM9061-UPC.P                                    
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: Juntar saldo no endereáo quando ressuprimento Flow Rack
********************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}

DEF INPUT        PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE        FOR tt-epc. 

DEFINE BUFFER bf-box-movto FOR wm-box-movto.

IF  p-ind-event = "Replenishment-Confirmation" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "wm-box-movto-rowid":
    END.

    IF NOT AVAIL tt-epc THEN
        RETURN "OK".

    FOR FIRST wm-box-movto NO-LOCK
        WHERE ROWID(wm-box-movto) = TO-ROWID(tt-epc.val-parameter):
    END.
    IF NOT AVAIL wm-box-movto THEN
        RETURN "OK".

// --> quando for usar a versao atualizada do wm9061 (e n∆o mais o eswm9061)
//     ser† necessario retirar o comentario abaixo */

/*    IF wm-box-movto.ind-tipo-movto = 2 THEN /* na confirmaá∆o da sa°da n∆o faz nada */
        RETURN "OK".
*/
    FOR FIRST bf-box-movto NO-LOCK 
         WHERE bf-box-movto.cod-estabel    = wm-box-movto.cod-estabel
           AND bf-box-movto.cod-local      = wm-box-movto.cod-local
           AND bf-box-movto.id-movto       = wm-box-movto.id-movto
           AND bf-box-movto.ind-tipo-movto = 1:
    END.

    FIND FIRST wm-box-movto OF bf-box-movto NO-ERROR.

    FOR FIRST wm-box-picking NO-LOCK
        WHERE wm-box-picking.cod-estabel = bf-box-movto.cod-estabel
          AND wm-box-picking.cod-local   = bf-box-movto.cod-local
          AND wm-box-picking.id-box-comp = bf-box-movto.id-box:
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

END.

RETURN "OK".

/**********************************************************************/
PROCEDURE piTrataFlowRack:
    DEFINE BUFFER bf-box-saldo FOR wm-box-saldo.
    DEFINE BUFFER bf-box-saldo-etiqueta FOR wm-box-saldo-etiqueta.

    /* verifica se h† mais de um saldo no endereco */
    IF NOT CAN-FIND(FIRST wm-box-saldo NO-LOCK
                    WHERE wm-box-saldo.cod-estabel   = wm-box-movto.cod-estabel
                      AND wm-box-saldo.cod-local     = wm-box-movto.cod-local
                      AND wm-box-saldo.id-box        = wm-box-movto.id-box
                      AND wm-box-saldo.cod-item      = wm-box-movto.cod-item
                      AND wm-box-saldo.cod-embalagem = wm-box-movto.cod-embalagem
                      AND wm-box-saldo.id-movto     <> wm-box-movto.id-movto) THEN
        RETURN "OK".

    /* saldo que esta sendo armazenado */
    FIND FIRST wm-box-saldo USE-INDEX idx-box-saldo10 EXCLUSIVE-LOCK
        WHERE wm-box-saldo.cod-estabel = wm-box-movto.cod-estabel
          AND wm-box-saldo.cod-local   = wm-box-movto.cod-local  
          AND wm-box-saldo.id-movto    = wm-box-movto.id-movto NO-ERROR.

    /* saldo que j† estava no endereco */
    FIND FIRST bf-box-saldo EXCLUSIVE-LOCK
        WHERE bf-box-saldo.cod-estabel   = wm-box-saldo.cod-estabel
          AND bf-box-saldo.cod-local     = wm-box-saldo.cod-local
          AND bf-box-saldo.id-box        = wm-box-saldo.id-box
          AND bf-box-saldo.cod-item      = wm-box-saldo.cod-item
          AND bf-box-saldo.cod-embalagem = wm-box-saldo.cod-embalagem
          AND bf-box-saldo.id-saldo     <> wm-box-saldo.id-saldo
          AND bf-box-saldo.ind-status-saldo = 3 NO-ERROR.

    IF NOT AVAIL bf-box-saldo THEN
        RETURN "OK".

    ASSIGN bf-box-saldo.id-docto         = wm-box-movto.id-docto
           bf-box-saldo.num-seq-item     = wm-box-movto.num-seq-item
           bf-box-saldo.dt-atua-saldo    = TODAY
           bf-box-saldo.dt-transacao     = TODAY
           bf-box-saldo.ind-status-box   = 1
           bf-box-saldo.ind-status-saldo = 3
           bf-box-saldo.qtd-item         = (bf-box-saldo.qtd-item - bf-box-saldo.qtd-item-bloq) + wm-box-saldo.qtd-item
           bf-box-saldo.qtd-item-bloq    = 0
           bf-box-saldo.qtd-original     = bf-box-saldo.qtd-item
           bf-box-saldo.id-movto         = wm-box-movto.id-movto.

    FOR EACH wm-box-saldo-etiqueta EXCLUSIVE-LOCK
       WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-saldo.cod-estabel
         AND wm-box-saldo-etiqueta.cod-local   = wm-box-saldo.cod-local
         AND wm-box-saldo-etiqueta.id-saldo    = wm-box-saldo.id-saldo:
        FIND FIRST wm-etiqueta OF wm-box-saldo-etiqueta EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL wm-etiqueta THEN DO:
            ASSIGN wm-etiqueta.qtd-item-ret = wm-etiqueta.qtd-item. /* zera etiqueta */
            DELETE wm-box-saldo-etiqueta.
        END.

        FOR FIRST bf-box-saldo-etiqueta NO-LOCK
            WHERE bf-box-saldo-etiqueta.cod-estabel = bf-box-saldo.cod-estabel 
              AND bf-box-saldo-etiqueta.cod-local   = bf-box-saldo.cod-local
              AND bf-box-saldo-etiqueta.id-box      = bf-box-saldo.id-box,
            FIRST wm-etiqueta OF bf-box-saldo-etiqueta EXCLUSIVE-LOCK
                WHERE wm-etiqueta.cod-item  = bf-box-saldo.cod-item
                  AND wm-etiqueta.cod-refer = bf-box-saldo.cod-refer 
                  AND wm-etiqueta.cod-lote  = bf-box-saldo.cod-lote,
            FIRST wm-item NO-LOCK
                WHERE wm-item.cod-item = wm-etiqueta.cod-item:
            ASSIGN wm-etiqueta.qtd-item          = (wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado) + wm-box-saldo.qtd-item
                   wm-etiqueta.qtd-item-retirado = 0
                   wm-etiqueta.qtd-peso          = (wm-etiqueta.qtd-item * wm-item.qtd-peso).
        END.
    END.

    FIND FIRST wm-item-embalagem-local NO-LOCK
         WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
           AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
           AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item 
           AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.

    IF NOT AVAIL wm-item-embalagem-local THEN
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel  = wm-docto-itens.cod-estabel
               AND wm-item-embalagem-local.cod-local    = wm-docto-itens.cod-local
               AND wm-item-embalagem-local.cod-item     = wm-docto-itens.cod-item
               AND wm-item-embalagem-local.cod-emb-item = wm-box-saldo.cod-embalagem NO-ERROR.

    IF AVAIL wm-item-embalagem-local THEN DO:
        FOR FIRST wm-box EXCLUSIVE-LOCK
            WHERE wm-box.cod-estabel = wm-box-saldo.cod-estabel
              AND wm-box.cod-local   = wm-box-saldo.cod-local
              AND wm-box.id-box      = wm-box-saldo.id-box:
    
            IF wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem THEN
                ASSIGN wm-box.qtd-capacidade-ua-util   = wm-box.qtd-capacidade-ua-util - wm-item-embalagem-local.qtd-volume.
            ELSE
                ASSIGN wm-box.qtd-capacidade-ua-util   = wm-box.qtd-capacidade-ua-util - wm-item-embalagem-local.qtd-volume-item.
        END.
    END.

    DELETE wm-box-saldo.

    RETURN "OK".
END PROCEDURE.
