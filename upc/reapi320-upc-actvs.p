/*******************************************************************************
#@# 
@programa: upc/reapi320-upc.p
@data:     29/03/2017
@autor:    Estevan KrÅger
@release:  DTS11
@objetivo: UPC para alimentar os campos traduzidos de Ordem Compras, Pedido Compra
           e Item, dos itens do documento que est† sendo gerado.
@vers∆o:   1.00 - Vers∆o Inicial
#@#
*******************************************************************************/




/*--- Definiá∆o dos ParÉmetros ---*/
{include/i-epc200.i1}
DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.




/*--- Definiá∆o das Vari†velis Locais ---*/
DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.




/*--- Bloco Principal ---*/
/*IF  p-ind-event = "fim-item" THEN DO:*/
IF  p-ind-event = "de_para_especifico" THEN DO:

    FIND FIRST tt-epc NO-LOCK
        WHERE  tt-epc.cod-event     = p-ind-event
        AND    tt-epc.cod-parameter = "item-doc-orig-nfe-rowid" NO-ERROR.
    IF  AVAIL  tt-epc THEN
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

    FIND FIRST item-doc-orig-nfe EXCLUSIVE-LOCK
        WHERE  ROWID(item-doc-orig-nfe) = r-rowid NO-ERROR.
    IF  AVAIL  item-doc-orig-nfe THEN DO:

        /* Busca a ordem de compra pelo campo do xPed do XML */
        FIND FIRST ordem-compra NO-LOCK
            WHERE  ordem-compra.numero-ordem = INT(item-doc-orig-nfe.num-ped-compr) NO-ERROR.
        IF  AVAIL  ordem-compra THEN DO:
            ASSIGN item-doc-orig-nfe.numero-ordem = ordem-compra.numero-ordem
                   item-doc-orig-nfe.num-pedido   = ordem-compra.num-pedido
                   item-doc-orig-nfe.it-codigo    = ordem-compra.it-codigo.

            FOR FIRST item NO-LOCK
                WHERE item.it-codigo    = item-doc-orig-nfe.it-codigo
                AND   item.tipo-con-est = 4, /* Referància */
                FIRST prazo-compra NO-LOCK
                WHERE prazo-compra.it-codigo    = item-doc-orig-nfe.it-codigo
                AND   prazo-compra.numero-ordem = item-doc-orig-nfe.numero-ordem:
                ASSIGN item-doc-orig-nfe.cod-refer = prazo-compra.cod-refer.
            END.

        END.
        ELSE DO: /* Se n∆o localizou ordem, ent∆o o numero Ç de um pedido de compra */
            FIND FIRST pedido-compr NO-LOCK
                WHERE  pedido-compr.num-pedido = INT(item-doc-orig-nfe.num-ped-compr) NO-ERROR.
            IF  AVAIL  pedido-compr THEN DO:
                FIND FIRST ordem-compra NO-LOCK
                    WHERE  ordem-compra.num-pedido = pedido-compr.num-pedido NO-ERROR.
                IF  AVAIL  ordem-compra THEN DO:
                    ASSIGN item-doc-orig-nfe.numero-ordem = ordem-compra.numero-ordem
                           item-doc-orig-nfe.num-pedido   = ordem-compra.num-pedido
                           item-doc-orig-nfe.it-codigo    = ordem-compra.it-codigo.
        
                    FOR FIRST item NO-LOCK
                        WHERE item.it-codigo    = item-doc-orig-nfe.it-codigo
                        AND   item.tipo-con-est = 4, /* Referància */
                        FIRST prazo-compra NO-LOCK
                        WHERE prazo-compra.it-codigo    = item-doc-orig-nfe.it-codigo
                        AND   prazo-compra.numero-ordem = item-doc-orig-nfe.numero-ordem:
                        ASSIGN item-doc-orig-nfe.cod-refer = prazo-compra.cod-refer.
                    END.
                END.
            END.
        END.
    END.

END.


RETURN "OK":U.

