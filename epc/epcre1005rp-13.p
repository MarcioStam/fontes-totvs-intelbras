/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i EPCRE1005RP 2.00.00.001}  /*** 020001 ***/
/***********************************************************************
************************************************************************/
{include/i-epc200.i1}

DEF VAR c-referencia AS CHAR NO-UNDO.

def input param  p-ind-event  as char          no-undo.
def input-output param table for tt-epc.

CASE p-ind-event:
    WHEN "fim-atualizacao" then do: 
        for each tt-epc no-lock
            where tt-epc.cod-event = p-ind-event:
            
            find docum-est where rowid(docum-est) = to-rowid(tt-epc.val-parameter) 
                no-lock no-error.
            if  not avail docum-est THEN
                RETURN "OK":U.
            
            /* ACESSO AOS ITENS DA NOTA FISCAL */
            for each item-doc-est of docum-est EXCLUSIVE-LOCK:
                ASSIGN c-referencia = "matriz".

                IF item-doc-est.numero-ordem = 0 THEN DO:
                    FIND FIRST rat-ordem 
                         WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                           AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                           AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                           AND rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                           AND rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.
                    IF AVAIL rat-ordem THEN DO:
                        FIND ordem-compra WHERE
                             ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.
                        IF AVAIL ordem-compra
                             AND ordem-compra.nr-contrato > 0 THEN
                            ASSIGN c-referencia = "Contrato".
                    END.
                END.
                ELSE DO:
                    FIND ordem-compra WHERE
                         ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
                    IF AVAIL ordem-compra
                         AND ordem-compra.nr-contrato > 0 THEN
                        ASSIGN c-referencia = "Contrato".
                END.

                /* Elimina registros duplicados em movto-estoq para movtos criados pela matriz de rateio */
                IF CAN-FIND (FIRST movto-estoq
                             WHERE movto-estoq.serie-docto  = item-doc-est.serie-docto
                               AND movto-estoq.nro-docto    = item-doc-est.nro-docto
                               AND movto-estoq.cod-emitente = item-doc-est.cod-emitente
                               AND movto-estoq.nat-operacao = item-doc-est.nat-operacao
                               AND movto-estoq.sequen-nf    = item-doc-est.sequencia 
                               AND movto-estoq.tipo-trans   = 1 
                               AND movto-estoq.referencia   = c-referencia NO-LOCK) THEN DO:

                    FOR each movto-estoq
                       where movto-estoq.serie-docto  = item-doc-est.serie-docto
                         and movto-estoq.nro-docto    = item-doc-est.nro-docto
                         and movto-estoq.cod-emitente = item-doc-est.cod-emitente
                         and movto-estoq.nat-operacao = item-doc-est.nat-operacao
                         and movto-estoq.sequen-nf    = item-doc-est.sequencia 
                         and movto-estoq.tipo-trans   = 1 
                         AND movto-estoq.referencia   = c-referencia EXCLUSIVE-LOCK:
                        DELETE movto-estoq.
                    END.

                    FOR EACH movto-estoq
                         where movto-estoq.serie-docto  = item-doc-est.serie-docto
                           and movto-estoq.nro-docto    = item-doc-est.nro-docto
                           and movto-estoq.cod-emitente = item-doc-est.cod-emitente
                           and movto-estoq.nat-operacao = item-doc-est.nat-operacao
                           and movto-estoq.sequen-nf    = item-doc-est.sequencia 
                           and movto-estoq.tipo-trans   = 2 EXCLUSIVE-LOCK:
                         IF movto-estoq.referencia <> "matriz" THEN
                            DELETE movto-estoq.
                    END.
                END. /* IF CAN-FIND (FIRST movto-estoq */
            end.  /* for each item-doc-est */
        end.
    end.
END CASE.
RETURN "OK":U.
