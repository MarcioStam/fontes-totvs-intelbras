
/**  Programa..: reapi320-upc.p                                            **
 **  Autor.....: Carlos Valentini                                          **
 **  Data......: Janeiro/2017 - Desenvolvimento                            **
 **  Descricao.: Customizar o processo de geraÁ„o do documetno             **
 **              para Intelbras                                            **
 **  Vers„o....: 001 - 06/01/2016                                          **
 ***************************************************************************/

{include/i-prgvrs.i reapi320-upc 2.00.00.001 } /*** 010002 ***/ 

{include/i-epc200.i1}
{cdp/cdcfgmat.i}

DEFINE VARIABLE r-rowid-doc AS ROWID NO-UNDO.

DEFINE BUFFER bfitem-doc-orig-nfe FOR item-doc-orig-nfe.
DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

CASE p-ind-event:
     /*** Evento principal chamado pelo reapi320 ***/
    WHEN "fim-item":U THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event = p-ind-event
               AND tt-epc.cod-parameter = "item-doc-orig-nfe-rowid":U NO-ERROR.

        IF AVAIL tt-epc THEN DO:

            ASSIGN r-rowid-doc =  TO-ROWID(tt-epc.val-parameter) NO-ERROR.

            FIND FIRST item-doc-orig-nfe NO-LOCK
                 WHERE ROWID(item-doc-orig-nfe) = r-rowid-doc NO-ERROR.

            IF AVAIL item-doc-orig-nfe THEN DO:
                /*Remover l¢gica totvs chamado 95224*/
                /*/**L¢gica feita pela totvs**/
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
                /*ELSE DO: /* Se n∆o localizou ordem, ent∆o o numero Ç de um pedido de compra */
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
                END.*/*/
                /***************************/

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = item-doc-orig-nfe.it-codigo 
                       AND ITEM.tipo-contr <> 4 NO-ERROR.

                IF AVAIL ITEM THEN DO:
                    FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK.
                    ASSIGN item-doc-orig-nfe.class-fiscal = ITEM.class-fiscal.
                    FIND CURRENT item-doc-orig-nfe NO-LOCK.
                END.

                /* Zerar campo vl-outros para naturezas de devoluá∆o */
                FIND FIRST natur-oper NO-LOCK
                    WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao NO-ERROR.

                IF  AVAIL natur-oper
                AND natur-oper.especie-doc = "NFD" THEN DO:
                    FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.

                    IF  AVAIL item-doc-orig-nfe THEN 
                        ASSIGN item-doc-orig-nfe.vl-outros = 0.

                    FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.

                    FIND FIRST doc-orig-nfe OF item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL doc-orig-nfe THEN
                       ASSIGN doc-orig-nfe.valor-outros = 0.

                    RELEASE doc-orig-nfe.
                END.

            END.
        END.
    END.
END CASE.
