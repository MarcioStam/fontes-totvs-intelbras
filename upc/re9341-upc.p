/***********************************************************************
**  Programa..: upc\re9341-upc.p
**  Autor.....: Gustavo Eduardo Tamanini - SQL WORKS
**  Data......: Abril/2010
**  Descricao.: 
**  Vers∆o....: 001 25/05/2010 - Gustavo Eduardo Tamanini
**                  Desenvolvimento Programa
************************************************************************/

{include/i-epc200.i1}  /* definicao tt-epc */
{esp/es0018.i}

DEF INPUT PARAMETER p-cod-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEFINE VARIABLE r-rowid      AS ROWID                     NO-UNDO.
DEFINE VARIABLE i-num-pedido LIKE item-doc-est.num-pedido NO-UNDO.
DEFINE VARIABLE de-fator AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-valor-parcela AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-total         AS DECIMAL     NO-UNDO.
IF p-cod-event = "After-Invoice-Generation":U THEN DO:
    FIND FIRST tt-epc WHERE
               tt-epc.cod-event     = "After-Invoice-Generation":U AND
               tt-epc.cod-parameter = "rowid(docum-est)"           NO-LOCK NO-ERROR.

    IF AVAIL tt-epc THEN DO:
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).
        
        FIND FIRST docum-est WHERE 
             ROWID(docum-est) = r-rowid NO-LOCK NO-ERROR.

        IF AVAIL docum-est THEN DO:

            FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
            IF NOT AVAIL item-doc-est THEN RETURN "NOK":U.

            ASSIGN i-num-pedido = item-doc-est.num-pedido.

            IF i-num-pedido = 0 THEN DO:
                FIND FIRST rat-ordem 
                     WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                       AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                       AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                       AND rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                       AND rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                IF AVAIL rat-ordem THEN
                    ASSIGN i-num-pedido = rat-ordem.num-pedido.
                ELSE
                    RETURN "NOK":U.
            END.

            FIND FIRST pedido-compr WHERE
                       pedido-compr.num-pedido = i-num-pedido NO-LOCK NO-ERROR.

            FIND FIRST cond-pagto WHERE
                       cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.

            IF AVAIL pedido-compr AND AVAIL cond-pagto THEN DO:
                ASSIGN d-total         = 0
                       d-valor-parcela = 0.

                IF cond-pagto.num-parcelas = 3 OR 
                   cond-pagto.num-parcelas = 6 THEN DO:
                    ASSIGN d-valor-parcela = truncate(docum-est.tot-valor / cond-pagto.num-parcelas, 2).
                    FOR EACH dupli-apagar EXCLUSIVE-LOCK 
                       WHERE dupli-apagar.serie-docto  = docum-est.serie-docto  
                         AND dupli-apagar.nro-docto    = docum-est.nro-docto    
                         AND dupli-apagar.cod-emitente = docum-est.cod-emitente 
                         AND dupli-apagar.nat-operacao = docum-est.nat-operacao
                       BREAK BY dupli-apagar.nr-duplic:
                          
                          IF LAST-OF(dupli-apagar.nr-duplic) THEN DO:
                             ASSIGN dupli-apagar.vl-a-pagar = docum-est.tot-valor - d-total.
                          END.
                          ELSE DO:
                             ASSIGN dupli-apagar.vl-a-pagar = d-valor-parcela
                                    d-total = d-total + d-valor-parcela.
                          END.
                    END.
                END.
            END.

            RUN esp/es0018p.p (INPUT  "re1001":U,
                               INPUT  2,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN DO:
            
                FIND FIRST dupli-apagar EXCLUSIVE-LOCK 
                     WHERE dupli-apagar.serie-docto  = docum-est.serie-docto  
                       AND dupli-apagar.nro-docto    = docum-est.nro-docto    
                       AND dupli-apagar.cod-emitente = docum-est.cod-emitente 
                       AND dupli-apagar.nat-operacao = docum-est.nat-operacao NO-ERROR. 
    
                IF  AVAIL dupli-apagar 
                AND AVAIL pedido-compr THEN DO:
    
                    FIND FIRST ordem-compra NO-LOCK
                         WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-ERROR.
    
                    FIND FIRST cotacao-item NO-LOCK
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                           AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                           AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
    
                    IF AVAIL cotacao-item THEN DO:
                        IF  cotacao-item.mo-codigo = 0 THEN DO:
                            ASSIGN de-fator = 1.
                        END.
                        ELSE DO:
                            FIND FIRST cotacao NO-LOCK
                                 WHERE cotacao.mo-codigo   = cotacao-item.mo-codigo
                                   AND cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                                   AND cotacao.cotacao[int(day(TODAY))] <> 0 NO-ERROR.
            
                            IF  AVAIL cotacao THEN
                                ASSIGN de-fator = cotacao.cotacao[int(day(TODAY))].
                        END.
    
                        OVERLAY(dupli-apagar.char-1,1,20) = string(cotacao-item.mo-codigo).
                        OVERLAY(dupli-apagar.char-1,21,20) = string(dupli-apagar.vl-a-pagar / de-fator).
                        OVERLAY(dupli-apagar.char-1,41,20) = string(dupli-apagar.vl-desconto / de-fator).
                    END.
                END.
            END.

            IF AVAIL cond-pagto THEN DO:
                FIND FIRST int-cond-pagto WHERE
                           int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.

                IF AVAIL int-cond-pagto THEN DO:
                    /** Carta Credito **/
                    IF SUBSTRING(int-cond-pagto.char-1,2,1) = "S" THEN DO:

                        FIND FIRST dupli-apagar WHERE 
                                   dupli-apagar.serie-docto  = docum-est.serie-docto  AND 
                                   dupli-apagar.nro-docto    = docum-est.nro-docto    AND 
                                   dupli-apagar.cod-emitente = docum-est.cod-emitente AND 
                                   dupli-apagar.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK NO-ERROR. 

                        IF AVAIL dupli-apagar THEN DO:
                            ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 2.

                            IF  WEEKDAY(dupli-apagar.dt-vencim) = 1 OR
                                WEEKDAY(dupli-apagar.dt-vencim) = 7 THEN
                                ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 2.
    
                            FIND FIRST param-estoq  NO-LOCK NO-ERROR.
                            FIND FIRST param-global NO-LOCK NO-ERROR.

                            REPEAT:
                                FIND FIRST calen-coml 
                                    WHERE  calen-coml.cod-estabel = param-estoq.estabel-pad
                                      AND  calen-coml.ep-codigo   = param-global.empresa-prin
                                      AND  calen-coml.data        = dupli-apagar.dt-vencim NO-LOCK NO-ERROR.
        
                                IF AVAIL calen-coml AND calen-coml.tipo-dia <> 1 THEN
                                    ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 1.
                                ELSE
                                    LEAVE.
                            END.                            
                        END.
                        RELEASE dupli-apagar.
                    END.
                END.
            END.
            
        END.
    END.
END.

