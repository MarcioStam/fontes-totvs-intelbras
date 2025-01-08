/****************************************************************************
** Programa: CC0311RP-UPC.P
** Autor   : Hoepers
** Data    : 16/01/2013
** Objetivo: EPC deve ser cadastrada para cc0311rp.p
**           Gerar automaticamente os embarques de importaá∆o, associando as ordens de compra.
**
*****************************************************************************/
{include/i-prgvrs.i CC0311RP 2.06.00.000} 

{include/i-epc200.i1} /* Definicao da temp-table tt-epc */
/*{esp/imp/esimp000.i1} /*tt-emb*/ */

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

/*****************************************************************************/  

DEFINE NEW GLOBAL SHARED VARIABLE v-log-emb-cc0311        AS LOG              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-emb-cc0311        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-log-emb-cc0311-portal AS LOG              NO-UNDO.
/*DEFINE VARIABLE l-achou          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE d-dt-entrega-aux AS DATE        NO-UNDO.*/

/* DEFINE BUFFER b-historico-embarque  FOR historico-embarque. */
/* DEFINE BUFFER b1-historico-embarque FOR historico-embarque. */
/* DEFINE BUFFER b-ordem-compra FOR ordem-compra.              */
/* DEFINE BUFFER b-embarque-imp FOR embarque-imp.              */

DEFINE VARIABLE h-bocx225      AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-cod-retorno  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-seq-emb  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-num-seq-emb  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-embarque AS CHARACTER   NO-UNDO.

{method/dbotterr.i}

DEF NEW GLOBAL SHARED TEMP-TABLE tt-pedido-compr NO-UNDO
    FIELD row-ped-compr AS ROWID
    INDEX id-pedido
            row-ped-compr.

/*****************************************************************************/  

IF  p-ind-event = "create-record"
THEN DO:
    IF v-log-emb-cc0311-portal THEN
        ASSIGN v-log-emb-cc0311 = YES.
    ELSE IF VALID-HANDLE (wh-tg-emb-cc0311) THEN
        ASSIGN v-log-emb-cc0311 = wh-tg-emb-cc0311:CHECKED.

    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event     = p-ind-event 
          AND tt-epc.cod-parameter = "ROWID" NO-ERROR.

    IF  AVAIL tt-epc
    THEN DO:
        FIND tt-pedido-compr NO-LOCK
            WHERE tt-pedido-compr.row-ped-compr = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

        IF  NOT AVAIL tt-pedido-compr
        THEN DO:
            CREATE tt-pedido-compr.
            ASSIGN tt-pedido-compr.row-ped-compr = TO-ROWID(tt-epc.val-parameter).
        END.
    END.
END.


IF  p-ind-event = "delete"
THEN DO:
    
    FOR EACH tt-pedido-compr EXCLUSIVE-LOCK:
        FIND pedido-compr NO-LOCK 
            WHERE ROWID(pedido-compr) = tt-pedido-compr.row-ped-compr NO-ERROR.

        IF AVAIL pedido-compr 
        THEN DO:
            FIND processo-imp NO-LOCK
                WHERE processo-imp.cod-estabel = pedido-compr.cod-estabel
                  AND processo-imp.nr-proc-imp = STRING(pedido-compr.num-pedido) NO-ERROR.

            IF  AVAIL processo-imp
            THEN DO:
                FIND CURRENT pedido-compr EXCLUSIVE-LOCK NO-ERROR.

                ASSIGN pedido-compr.situacao = 1 /* Impresso */
                       v-cod-seq-emb         = ";a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z"
                       v-num-seq-emb         = 0.

                FIND CURRENT pedido-compr NO-LOCK NO-ERROR.

                IF  v-log-emb-cc0311 = YES 
                THEN DO:
                    RUN cxbo/bocx225.p  PERSISTENT SET h-bocx225.
                    RUN pi-cria-embarque.
                    DELETE PROCEDURE h-bocx225.
                END.
            END. /* IF  AVAIL processo-imp */
        END. /* IF AVAIL pedido-compr */

        DELETE tt-pedido-compr.

    END. /* FOR EACH  tt-pedido-compr NO-LOCK: */

    ASSIGN v-log-emb-cc0311 = NO.
END. /* IF  p-ind-event      = "create-record" AND */


RETURN "OK".

/************************************************************************/

PROCEDURE pi-cria-embarque:

    DO TRANS ON ERROR UNDO, LEAVE:
       FOR EACH  ordem-compra NO-LOCK
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
           EACH  prazo-compra OF ordem-compra NO-LOCK
           BREAK BY prazo-compra.data-entrega:
           
           IF  FIRST-OF(prazo-compra.data-entrega) THEN DO:
               FIND FIRST cotacao-item NO-LOCK 
                   WHERE  cotacao-item.numero-ordem = ordem-compra.numero-ordem  
                     AND  cotacao-item.cod-emitente = ordem-compra.cod-emitente  
                     AND  cotacao-item.it-codigo    = prazo-compra.it-codigo
                     AND  cotacao-item.cot-aprov    = YES NO-ERROR.

               /*Procura outro embarque*/
               /*ASSIGN l-achou = NO.
               
               blk_emb:
               FOR EACH embarque-imp NO-LOCK
                  WHERE embarque-imp.cod-estabel  = ordem-compra.cod-estabel
                    AND embarque-imp.cod-incoterm = substring(cotacao-item.char-1,21,20)
                    AND embarque-imp.situacao     = 1,
                  FIRST b1-historico-embarque OF embarque-imp NO-LOCK
                  WHERE b1-historico-embarque.cod-itiner = cotacao-item.int-1,
                  FIRST ordens-embarque OF embarque-imp  NO-LOCK,
                  FIRST b-ordem-compra  OF ordens-embarque NO-LOCK
                  WHERE b-ordem-compra.cod-emitente = ordem-compra.cod-emitente:
                   
                   RUN pi-situacao.
                   IF tt-emb.situacao = 1 /*Prev*/ 
                   OR tt-emb.situacao = 99 /*Agt*/ THEN DO:

                       RUN pi-busca-data-entrega (INPUT embarque-imp.cod-estabel,
                                                  INPUT embarque-imp.embarque,
                                                  OUTPUT d-dt-entrega-aux).

                       IF  d-dt-entrega-aux <= prazo-compra.data-entrega + 2
                       AND d-dt-entrega-aux >= prazo-compra.data-entrega - 2 THEN DO:

                           ASSIGN v-cod-embarque = embarque-imp.embarque.
                           ASSIGN l-achou = YES.
                           LEAVE blk_emb.
                       END.
                   END.
               END.*/

               
               /*Se n∆o achou embarque cria um nvo*/
/*                IF NOT l-achou THEN DO: */
                   ASSIGN v-num-seq-emb  = v-num-seq-emb + 1
                          v-cod-embarque = processo-imp.nr-proc-imp + ENTRY(v-num-seq-emb,v-cod-seq-emb,";").
    
                   FIND FIRST embarque-imp NO-LOCK 
                       WHERE  embarque-imp.cod-estabel = processo-imp.cod-estabel 
                         AND  embarque-imp.embarque    = v-cod-embarque NO-ERROR.
        
                   IF  NOT AVAIL embarque-imp AND
                           AVAIL cotacao-item
                   THEN DO:
                       CREATE embarque-imp.
                       ASSIGN embarque-imp.cod-estabel         = pedido-compr.cod-estabel
                              embarque-imp.embarque            = v-cod-embarque
                              embarque-imp.situacao            = 1
                              embarque-imp.cod-transportador   = processo-imp.cod-transportador
                              embarque-imp.cod-via-transp      = pedido-compr.via-transp
                              embarque-imp.narrativa           = pedido-compr.comentarios
                              embarque-imp.cod-incoterm        = SUBSTR(cotacao-item.char-1,21,3)
                              embarque-imp.contabiliza         = NO.
                   END. /* IF  NOT AVAIL embarque-imp AND */
/*                END.                                                               */
/*                /*Se achou posiciona nele*/                                        */
/*                ELSE DO:                                                           */
/*                    FIND FIRST embarque-imp NO-LOCK                                */
/*                         WHERE embarque-imp.cod-estabel = processo-imp.cod-estabel */
/*                           AND embarque-imp.embarque    = v-cod-embarque NO-ERROR. */
/*                END.                                                               */
           END. /* IF  FIRST-OF(prazo-compra.data-entrega) */
           ELSE
               FIND FIRST embarque-imp NO-LOCK 
                   WHERE  embarque-imp.cod-estabel = processo-imp.cod-estabel 
                     AND  embarque-imp.embarque    = v-cod-embarque NO-ERROR.

           IF  AVAIL embarque-imp
           THEN DO:
               FIND FIRST ordens-embarque NO-LOCK
                   WHERE  ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                     AND  ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

               IF  NOT AVAIL ordens-embarque
               THEN DO:
                   RUN setCreatehist IN h-bocx225.
                   RUN createOrdensEmbarquebyparcela IN h-bocx225 (INPUT ROWID(embarque-imp),
                                                                   INPUT prazo-compra.numero-ordem,
                                                                   INPUT prazo-compra.parcela,
                                                                   INPUT prazo-compra.quant-saldo,
                                                                   OUTPUT TABLE RowErrors).
               END.
           END. /* IF  AVAIL embarque-imp */
       END. /* FOR EACH ordem-compra */
    END. /* DO TRANS ON ERROR UNDO, LEAVE: */
END PROCEDURE.
/*
PROCEDURE pi-busca-data-entrega:
    DEFINE INPUT PARAM p-cod-estabel LIKE embarque-imp.cod-estabel.
    DEFINE INPUT PARAM p-embarque    LIKE embarque-imp.embarque.
    DEFINE OUTPUT PARAM p-dt-entrega AS DATE.
    /*Primeiro ponto de controle do embarque*/
    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel = p-cod-estabel
           AND historico-embarque.embarque    = p-embarque NO-ERROR.

    /*Itinerario do embarque*/
    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

    /*Ponto de Entrega (Despacho)*/
    FIND FIRST b-historico-embarque NO-LOCK
         WHERE b-historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
           AND b-historico-embarque.embarque      = embarque-imp.embarque    
           AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner    
           AND b-historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.

    ASSIGN p-dt-entrega = IF b-historico-embarque.dt-efetiva <> ? THEN b-historico-embarque.dt-efetiva ELSE b-historico-embarque.dt-ult-previsao.
END.

PROCEDURE pi-situacao :

    {esp/imp/esimp000.i}
    
END PROCEDURE.*/
