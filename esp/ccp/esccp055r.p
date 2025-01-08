USING Progress.Json.ObjectModel.*.
/***********************************************************************************************************************************
**
**  Programa..............: esccp055r
**  Nome Externo..........: esp/ccp/esccp055r.p
**  Descricao.............: Executa a de Integraá∆o dos Pedidos de Compra Espec°fico
**  Criado por............: Henke - iDBA
**  Criado em.............: 10/02/2023
**
*************************************************************************************************************************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar        LIKE emsuni.empresa.cod_empresa NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren        AS CHAR NO-UNDO.

DEF VAR h-acomp   AS HANDLE NO-UNDO.

{esp/ccp/esccp055r.i}
{esp/esapi505b.i}

DEF VAR l-producao AS LOG NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF INPUT PARAM p-log-acomp        AS LOG NO-UNDO.
DEF INPUT PARAM p-num-pedido-compr AS INT NO-UNDO.
DEF INPUT PARAM p-acao             AS CHAR NO-UNDO. // "tt-int-ped-compr" ou "es-api-log"
DEF INPUT PARAM p-log-reenvio      AS LOG NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-int-ped-compr.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

IF p-acao = "tt-int-ped-compr" THEN
    RUN pi-cria-tt-int-ped-compr.

IF p-acao = "es-api-log" THEN
    RUN pi-cria-es-api-log.

PROCEDURE pi-cria-tt-int-ped-compr:

    FIND FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = p-num-pedido-compr NO-ERROR.
    FIND FIRST int-ped-compr OF pedido-compr NO-LOCK NO-ERROR.
    IF AVAIL int-ped-compr THEN DO:
        CREATE tt-int-ped-compr.
        ASSIGN tt-int-ped-compr.row-table     = ROWID (pedido-compr)
               tt-int-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
               tt-int-ped-compr.num-pedido    = int-ped-compr.num-pedido
               tt-int-ped-compr.cod-emitente  = pedido-compr.cod-emitente //int-ped-compr.cod-emitente                      
               tt-int-ped-compr.responsavel   = pedido-compr.responsavel  //int-ped-compr.responsavel
               tt-int-ped-compr.cod-estabel   = pedido-compr.cod-estabel  //int-ped-compr.cod-estabel
               tt-int-ped-compr.val-total     = 0                         //int-ped-compr.val-total
               tt-int-ped-compr.dat-criac     = int-ped-compr.dat-criac
               tt-int-ped-compr.hra-criac     = int-ped-compr.hra-criac           
               tt-int-ped-compr.dat-movto     = pedido-compr.dat-alter 
               tt-int-ped-compr.hra-movto     = pedido-compr.hra-alter.
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-int-ped-compr.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN tt-int-ped-compr.nome-abrev = emitente.nome-abrev.
        FIND LAST int-mov-ped-compr EXCLUSIVE-LOCK 
            WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
              AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
        IF AVAIL int-mov-ped-compr THEN DO:
            ASSIGN tt-int-ped-compr.des-situacao = int-mov-ped-compr.ind-tip-movto.
        END.
       //IF tt-int-ped-compr.val-total = 0
       //OR tt-int-ped-compr.val-total = ? THEN
            RUN pi-val-total.

        FIND CURRENT tt-int-ped-compr NO-ERROR.
        RELEASE tt-int-ped-compr.
    END.

END.

PROCEDURE pi-val-total:

    DEF VAR de-preco-unit AS DEC NO-UNDO.
    DEF VAR de-total      AS DEC NO-UNDO.

    FIND FIRST int-ped-compr EXCLUSIVE-LOCK
         WHERE int-ped-compr.num-pedido = tt-int-ped-compr.num-pedido NO-ERROR.
    IF AVAIL int-ped-compr THEN DO:
        ASSIGN de-preco-unit = 0.
        FOR EACH ordem-compra USE-INDEX pedido
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:
            ASSIGN de-preco-unit = ordem-compra.preco-unit.
            IF ordem-compra.mo-codigo <> 0 /* Real */ THEN DO:
                FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
                RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo,
                                  INPUT 0,
                                  INPUT de-preco-unit,
                                  INPUT IF AVAIL cotacao-item THEN cotacao-item.data-cotacao ELSE ordem-compra.data-pedido,
                                  OUTPUT de-preco-unit).
            END.
            FOR EACH prazo-compra USE-INDEX ordem NO-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                IF prazo-compra.situacao = 4 THEN
                    NEXT.
                ASSIGN de-total = de-total + (prazo-compra.quantidade * de-preco-unit).
            END.
        END.
        ASSIGN tt-int-ped-compr.val-total = ROUND (de-total, 2).
        RELEASE int-ped-compr.
    END.

END.

PROCEDURE pi-cria-es-api-log:

    DEF VAR c-endereco      AS CHAR NO-UNDO.
    DEF VAR v-num-seq-movto AS INT NO-UNDO.    

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    IF p-log-acomp = YES THEN
        RUN pi-inicializar IN h-acomp ("Integraá∆o com o ARIBA"). 

    FIND FIRST tt-int-ped-compr 
        WHERE tt-int-ped-compr.num-pedido = p-num-pedido-compr NO-ERROR.
    IF AVAIL tt-int-ped-compr THEN DO:
        IF  tt-int-ped-compr.des-situacao <> "N∆o Integrado"
        and tt-int-ped-compr.des-situacao <> "Em Processamento"
        AND (tt-int-ped-compr.des-situacao = "Integrado" AND p-log-reenvio = NO)
        AND tt-int-ped-compr.des-situacao <> "Em Revis∆o"
        AND tt-int-ped-compr.des-situacao <> "Registro Exclu°do"
        AND tt-int-ped-compr.des-situacao <> "Erro Integraá∆o" THEN
            RETURN.

        IF not can-find(first int-mov-ped-compr where
                              int-mov-ped-compr.id-ped-compr  = tt-int-ped-compr.id-ped-compr
                          and int-mov-ped-compr.ind-tip-movto = "Integrado"
                              no-lock)
        THEN DO:
        //IF btt-int-ped-compr.des-situacao = "N∆o Integrado" THEN DO:
            /* POST */
            FIND FIRST es-api-URI NO-LOCK
                WHERE es-api-URI.id-URI = 'AribaPedComprNew' NO-ERROR.
            IF AVAIL es-api-URI THEN DO:
                IF l-producao = YES THEN 
                    ASSIGN c-endereco = es-api-URI.ent-PRD.
                ELSE 
                    ASSIGN c-endereco = es-api-URI.end-TST.

                IF p-log-acomp = YES THEN DO:
                    RUN pi-inicializar IN h-acomp ('ARI - AribaPedComprNew').
                    RUN pi-acompanhar IN h-acomp ("Gerando Pedidos").
                END.
                RUN pi-output-api-request  ("ARI",
                                            v_cod_empres_usuar,
                                            "AribaPedComprNew",
                                            "ESCCP055",
                                            STRING (p-num-pedido-compr),
                                            lcRequest).
            END.
        END.
        ELSE DO:
             /* PUT */
             FIND FIRST es-api-URI NO-LOCK
                 WHERE es-api-URI.id-URI = 'AribaPedComprUP' NO-ERROR.
             IF AVAIL es-api-URI THEN DO:
                 IF l-producao = YES THEN 
                     ASSIGN c-endereco = es-api-URI.ent-PRD.
                 ELSE 
                     ASSIGN c-endereco = es-api-URI.end-TST.

                 IF p-log-acomp = YES THEN DO:
                     RUN pi-inicializar IN h-acomp ('ARI - AribaPedComprUP').
                     RUN pi-acompanhar IN h-acomp ("Atualizando Pedidos").
                 END.
                 RUN pi-output-api-request  ("ARI",
                                             v_cod_empres_usuar,
                                             "AribaPedComprUP",
                                             "ESCCP055",
                                             STRING (p-num-pedido-compr),
                                             lcRequest).
             END.
        END.
    END.
    IF p-log-acomp = YES THEN
        RUN pi-finalizar IN h-acomp.

END.

