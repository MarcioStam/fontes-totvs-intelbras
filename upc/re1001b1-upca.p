/***********************************************************************
**  Programa..: upc\re1001b1-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/
DEF INPUT PARAM p-tipo AS INT NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-docum-est          AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-pedido-re1001b1         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-parcela            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-numero-ordem       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qt-do-forn         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-preco-unit         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-depos          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-deposito           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-narrativa-re1001b1 AS WIDGET-HANDLE NO-UNDO.

DEF VAR i-cont AS INT.

CASE p-tipo:
    WHEN 1 THEN DO:
        FIND FIRST docum-est NO-LOCK
            WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

        FIND ordem-compra WHERE
             ordem-compra.numero-ordem = INT(wh-numero-ordem:SCREEN-VALUE) NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            IF ordem-compra.num-pedido   <> 0 AND
               ordem-compra.numero-ordem <> 0 THEN
                ASSIGN wh-narrativa-re1001b1:SCREEN-VALUE = ordem-compra.narrativa.

            /*IF ordem-compra.nr-contrato > 0 THEN DO: /* ordem de compra relacioanda a contrato de compra  */
                FIND contrato-for WHERE
                     contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK NO-ERROR.
                IF AVAIL contrato-for
                     AND contrato-for.ind-control-rec = 1 THEN DO:  /* Controle = Total Nota */

                    IF wh-deposito:SCREEN-VALUE = "" THEN DO:
                        FOR FIRST item-contrat
                            WHERE item-contrat.nr-contrato = contrato-for.nr-contrato NO-LOCK:
                            ASSIGN wh-cod-depos:SCREEN-VALUE = STRING(item-contrat.cod-depos)
                                   wh-deposito:SCREEN-VALUE  = STRING(item-contrat.cod-depos)    .
                        END.
                    END.

                    IF dec(wh-preco-unit:SCREEN-VALUE) = 0 THEN DO:
                        FOR EACH cotacao-item
                           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                            ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(cotacao-item.preco-unit).
                        END.
                    END.

                    IF DEC(wh-qt-do-forn:SCREEN-VALUE) = 0 THEN DO:
                        FOR EACH medicao-contrat NO-LOCK  
                           WHERE medicao-contrat.numero-ordem = ordem-compra.numero-ordem
                             AND medicao-contrat.sld-val-medicao > 0
                             AND medicao-contrat.ind-sit-medicao = 2 :
                            ASSIGN wh-qt-do-forn:SCREEN-VALUE = STRING(medicao-contrat.qtd-medicao).
                        END.
                    END.
                END.
            END.
            ELSE DO:
                IF wh-parcela:SCREEN-VALUE = "0" THEN DO:
                    FOR FIRST prazo-compra NO-LOCK
                        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                        AND   prazo-compra.qtd-sal-forn  > 0:

                        ASSIGN wh-parcela:SCREEN-VALUE    = STRING(prazo-compra.parcela)
                               wh-qt-do-forn:SCREEN-VALUE = STRING(prazo-compra.qtd-sal-forn,">>>>,>>>,>>9.9999").
                        IF ordem-compra.mo-codigo <> 0 THEN DO:
                            FIND FIRST cotacao NO-LOCK
                                WHERE cotacao.mo-codigo   = ordem-compra.mo-codigo
                                AND   cotacao.ano-periodo = STRING(YEAR(docum-est.dt-emissao),"9999") + "/" + STRING(MONTH(docum-est.dt-emissao),"99") NO-ERROR.
                            IF AVAIL cotacao THEN                          
                                ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for * cotacao.cotacao[DAY(docum-est.dt-emissao)]).
                            ELSE
                                ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
                        END.
                        ELSE
                            ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
                        
                    END.
                END.
                ELSE DO:
                    FOR FIRST prazo-compra NO-LOCK
                        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                        AND   prazo-compra.parcela      = INT(wh-parcela:SCREEN-VALUE):
                        ASSIGN wh-parcela:SCREEN-VALUE    = STRING(prazo-compra.parcela)
                               wh-qt-do-forn:SCREEN-VALUE = STRING(prazo-compra.qtd-sal-forn,">>>>,>>>,>>9.9999").

                        IF ordem-compra.mo-codigo <> 0 THEN DO:
                            FIND FIRST cotacao NO-LOCK
                                WHERE cotacao.mo-codigo   = ordem-compra.mo-codigo
                                AND   cotacao.ano-periodo = STRING(YEAR(docum-est.dt-emissao),"9999") + "/" + STRING(MONTH(docum-est.dt-emissao),"99") NO-ERROR.
                            IF AVAIL cotacao THEN                          
                                ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for * cotacao.cotacao[DAY(docum-est.dt-emissao)]).
                            ELSE
                                ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
                        END.
                        ELSE
                            ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
                    END.
                END.
                ASSIGN wh-deposito:SCREEN-VALUE  = STRING(ordem-compra.dep-almoxar)
                       wh-cod-depos:SCREEN-VALUE = STRING(ordem-compra.dep-almoxar).
            END.*/
        END.
    END.
    WHEN 2 THEN DO:
        IF  wh-numero-ordem:SCREEN-VALUE = "0.00"
        AND wh-num-pedido-re1001b1:SCREEN-VALUE  <> "0" THEN DO:
            FIND FIRST docum-est NO-LOCK
                WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

            FOR EACH ordem-compra NO-LOCK USE-INDEX pedido-item
                WHERE ordem-compra.num-pedido = INT(wh-num-pedido-re1001b1:SCREEN-VALUE)
                AND   ordem-compra.it-codigo  = wh-it-codigo:SCREEN-VALUE
                AND   ordem-compra.situacao   = 2,
                FIRST prazo-compra NO-LOCK USE-INDEX ordem
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                AND   prazo-compra.qtd-sal-forn > 0
                BY    prazo-compra.data-entrega:

                FIND FIRST item-doc-est NO-LOCK
                    WHERE item-doc-est.serie-docto  = docum-est.serie-docto
                    AND   item-doc-est.nro-docto    = docum-est.nro-docto
                    AND   item-doc-est.cod-emitente = docum-est.cod-emitente
                    AND   item-doc-est.nat-operacao = docum-est.nat-operacao
                    AND   item-doc-est.numero-ordem = ordem-compra.numero-ordem NO-ERROR.
                IF AVAIL item-doc-est THEN NEXT.
                ELSE DO:
                    /*ASSIGN wh-parcela:SCREEN-VALUE            = STRING(prazo-compra.parcela)
                           wh-numero-ordem:SCREEN-VALUE       = STRING(ordem-compra.numero-ordem)
                           wh-qt-do-forn:SCREEN-VALUE         = STRING(prazo-compra.qtd-sal-forn,">>>>,>>>,>>9.9999").*/

                    IF ordem-compra.num-pedido   <> 0 AND
                       ordem-compra.numero-ordem <> 0 THEN
                        ASSIGN wh-narrativa-re1001b1:SCREEN-VALUE = ordem-compra.narrativa.

                    LEAVE.
                END.
            END.
        END.
    END.
    WHEN 3 THEN DO:
        APPLY 'LEAVE' TO wh-numero-ordem.
    END.
   /* WHEN 3 THEN DO: /* leave do pedido de compra */
        FOR FIRST ordem-compra
             WHERE ordem-compra.num-pedido = INT(wh-num-pedido-re1001b1:SCREEN-VALUE) NO-LOCK:

            IF ordem-compra.num-pedido   <> 0 AND
               ordem-compra.numero-ordem <> 0 THEN
                ASSIGN wh-narrativa-re1001b1:SCREEN-VALUE = ordem-compra.narrativa.

            IF ordem-compra.nr-contrato > 0 THEN DO:
                FIND contrato-for WHERE
                     contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK NO-ERROR.
                IF AVAIL contrato-for 
                     AND contrato-for.ind-control-rec = 1 THEN DO:  /* Controle = Total Nota */
                    ASSIGN wh-numero-ordem:SCREEN-VALUE = STRING(ordem-compra.numero-ordem).

                    FOR FIRST item-contrat
                         WHERE item-contrat.nr-contrato = contrato-for.nr-contrato NO-LOCK:
                        ASSIGN wh-cod-depos:SCREEN-VALUE = STRING(item-contrat.cod-depos)
                               wh-deposito:SCREEN-VALUE  = STRING(item-contrat.cod-depos)    .
                    END.

                    FOR EACH cotacao-item
                       WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                        ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(cotacao-item.preco-unit).
                    END.
    
                    FOR EACH  medicao-contrat NO-LOCK  
                       WHERE medicao-contrat.numero-ordem = ordem-compra.numero-ordem
                         AND medicao-contrat.sld-val-medicao > 0
                         AND medicao-contrat.ind-sit-medicao = 2 :
                        ASSIGN wh-qt-do-forn:SCREEN-VALUE = STRING(medicao-contrat.qtd-medicao).
                    END.
                END.
            END.
        END.
    END.*/
END CASE.

    
