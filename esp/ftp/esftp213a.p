DEFINE INPUT PARAM r-ped-item AS ROWID.

DEFINE VARIABLE dt-ini-mes-seg AS DATE        NO-UNDO.
DEFINE VARIABLE l-pd4000       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE dt-ini         LIKE int-pv-canal.dt-ini-meta        NO-UNDO.
DEFINE VARIABLE dt-fim         LIKE int-pv-canal.dt-ini-meta        NO-UNDO.
DEFINE VARIABLE l-espdp079     AS LOG         NO-UNDO.


DEFINE VARIABLE dt-ini-year    AS CHAR        NO-UNDO .
DEFINE VARIABLE dt-ini-month   AS CHAR        NO-UNDO .
DEFINE VARIABLE dt-ini-day     AS CHAR        NO-UNDO .

/*Inicio Defini‡äes LOG*/
DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
{esp/es0018.i}
{utp/ut-glob.i}
/*Fim Defini‡äes LOG*/

DEFINE NEW GLOBAL SHARED VARIABLE l-mantem-data-espdp079 AS LOG   NO-UNDO.

FIND FIRST ped-item NO-LOCK
     WHERE ROWID(ped-item) = r-ped-item NO-ERROR.

FIND FIRST ped-venda OF ped-item NO-LOCK NO-ERROR.

FIND FIRST int-ped-venda2 NO-LOCK
     WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

ASSIGN dt-ini = ped-item.dt-entrega.


IF DAY(dt-ini) <= 20 THEN DO:
   ASSIGN dt-ini = ADD-INTERVAL(dt-ini, -1, 'months') .

   ASSIGN dt-ini-year  = STRING(YEAR(dt-ini)).
   ASSIGN dt-ini-month = STRING(MONTH(dt-ini)).
   ASSIGN dt-ini-day   = "21" .


   ASSIGN dt-ini = DATE(dt-ini-day + "/" + dt-ini-month + "/" + dt-ini-year ) .
END.
ELSE DO:
  ASSIGN dt-ini-year  = STRING(YEAR(dt-ini)).  
  ASSIGN dt-ini-month = STRING(MONTH(dt-ini)).
  ASSIGN dt-ini-day   = "21" .

  ASSIGN dt-ini = DATE(dt-ini-day + "/" + dt-ini-month + "/" + dt-ini-year ) .

END.

ASSIGN dt-fim = ADD-INTERVAL(dt-ini, 1, 'months') - 1  .

FIND FIRST int-pv-canal NO-LOCK
     WHERE int-pv-canal.cod-canal   = int-ped-venda2.int-1
       AND int-pv-canal.it-codigo   = ped-item.it-codigo
       AND int-pv-canal.dt-ini-meta = dt-ini
       AND int-pv-canal.dt-fim-meta = dt-fim NO-ERROR.

IF  PROGRAM-NAME(1)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(2)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(3)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(4)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(5)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(6)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(7)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(8)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(9)  MATCHES "*pd4000*"
OR  PROGRAM-NAME(10) MATCHES "*pd4000*"
OR  PROGRAM-NAME(11) MATCHES "*pd4000*"
OR  PROGRAM-NAME(1)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(2)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(3)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(4)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(5)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(6)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(7)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(8)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(9)  MATCHES "*espdp056*"
OR  PROGRAM-NAME(10) MATCHES "*espdp056*"
OR  PROGRAM-NAME(11) MATCHES "*espdp056*"  THEN
    ASSIGN l-pd4000 = YES.

ASSIGN l-espdp079 = NO.
IF  PROGRAM-NAME(1)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(2)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(3)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(4)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(5)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(6)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(7)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(8)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(9)  MATCHES "*espdp079*"
OR  PROGRAM-NAME(10) MATCHES "*espdp079*"
OR  PROGRAM-NAME(11) MATCHES "*espdp079*"  THEN
    ASSIGN l-espdp079 = YES.


/*considerar somente os pedidos que geram titulo*/
FIND FIRST natur-oper NO-LOCK
     WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

IF  AVAIL int-pv-canal 
AND ped-venda.cod-priori <> 44 /* orcamento */     
AND natur-oper.emite-duplic THEN DO:

    /*Sempre soma na meta em que o pedido foi implantado, caso esteja acima da meta ao alterar a dt-entrega a trigger da ped-item vai mover a quantidade para nova data*/
    //FIND CURRENT int-pv-canal EXCLUSIVE-LOCK.
    //ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
    //FIND CURRENT int-pv-canal NO-LOCK.

    /*Acima da Meta, procura pr¢xima meta, a menos que seja implantado pelo pd4000*/
    IF int-pv-canal.qt-faturada + int-pv-canal.qt-carteira > int-pv-canal.qt-meta 
    AND NOT l-pd4000 THEN DO:

        IF l-espdp079 AND l-mantem-data-espdp079 THEN DO: //pedido vindo do espdp079 e marcado assume data da planilha 
            ASSIGN dt-ini-mes-seg = ped-item.dt-entrega.
        END.
        ELSE DO:
          IF int-pv-canal.dt-entrega-item <> ? THEN DO:
             IF ped-item.dt-entrega > int-pv-canal.dt-entrega-item THEN
                ASSIGN dt-ini-mes-seg = ped-item.dt-entrega.
             ELSE
                ASSIGN dt-ini-mes-seg = int-pv-canal.dt-entrega-item.
          END.
          ELSE
             ASSIGN dt-ini-mes-seg = ped-item.dt-entrega
                    dt-ini-mes-seg = ADD-INTERVAL(dt-ini-mes-seg, 1, 'months')
                    dt-ini-mes-seg = DATE("21/" + string(MONTH(dt-ini-mes-seg)) + "/" + string(YEAR(dt-ini-mes-seg))).  //BHJ IDBA -> Alterado para dia 21 
        END.
    
          

/*         FIND FIRST int-pv-canal NO-LOCK                                    */
/*              WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1           */
/*                AND int-pv-canal.it-codigo = ped-item.it-codigo             */
/*                AND int-pv-canal.mes-meta  = MONTH(dt-ini-mes-seg)          */
/*                AND int-pv-canal.ano-meta  = YEAR(dt-ini-mes-seg) NO-ERROR. */

/*         IF NOT AVAIL int-pv-canal THEN DO:                         */
/*             CREATE int-pv-canal.                                   */
/*             ASSIGN int-pv-canal.cod-canal = int-ped-venda2.int-1   */
/*                    int-pv-canal.it-codigo = ped-item.it-codigo     */
/*                    int-pv-canal.mes-meta  = MONTH(dt-ini-mes-seg)  */
/*                    int-pv-canal.ano-meta  = YEAR(dt-ini-mes-seg).  */
/*                                                                    */
/*             /*Grava entrega com primeiro dia do mˆs seguinte*/     */
/*             ASSIGN int-pv-canal.dt-entrega-item = dt-ini-mes-seg.  */
/*                                                                    */
/*             ASSIGN int-pv-canal.qt-faturada = 0                    */
/*                    int-pv-canal.qt-carteira = 0                    */
/*                    int-pv-canal.qt-meta     = 0.                   */
/*                                                                    */
/*             /*Zera totais e inicial datas para totalizar*/         */
/*             ASSIGN dt-ini = dt-ini-mes-seg                         */
/*                    dt-fim = ADD-INTERVAL(dt-ini, 1, 'months') - 1. */
/*                                                                    */
/*             RUN pi-altera-dt-entrega.                              */
/*                                                                    */
/*             RUN pi-totaliza.                                       */
/*         END.                                                       */
/*         ELSE DO:                                                   */
            /*NÆo soma mais neste ponto pois vai somar na trigger ao alterar o dt-entrega*/

/*         IF MONTH(int-pv-canal.dt-entrega-item) = MONTH(ped-item.dt-entrega) THEN */
        RUN pi-altera-dt-entrega (INPUT dt-ini-mes-seg).
/*         END. */
    END.
END.

PROCEDURE pi-altera-dt-entrega:
    DEFINE INPUT PARAM p-data AS DATE.

    /*se foi implantado pelo pd4000 nao altera a data*/
    IF l-pd4000 THEN
        RETURN "OK".

    FIND CURRENT ped-item EXCLUSIVE-LOCK.
    ASSIGN ped-item.dt-entrega = p-data.
    FIND CURRENT ped-item NO-LOCK.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-totaliza:
    DEFINE VARIABLE dt-aux   AS DATE        NO-UNDO.
    DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.

    ASSIGN de-total = 0.
        
    DO dt-aux = dt-ini TO dt-fim:

        /*Totaliza Faturado*/
        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.it-codigo    = int-pv-canal.it-codigo
             AND it-nota-fisc.dt-emis-nota = dt-aux,
           FIRST nota-fiscal OF it-nota-fisc 
           WHERE nota-fiscal.idi-sit-nf-eletro = 3 NO-LOCK:

            IF nota-fiscal.emite-duplic = NO THEN 
                NEXT.
    
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli
                   AND ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.
            
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.
            
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
            
            IF AVAIL int-ped-venda2 THEN DO:
               ASSIGN de-total = de-total +  it-nota-fisc.qt-faturada[1].
            END.
        END.
       
        /* devolu‡äes */
        FOR EACH devol-cli
           WHERE devol-cli.dt-devol        = dt-aux
             AND devol-cli.it-codigo       = int-pv-canal.it-codigo,
           FIRST nota-fiscal        
           WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
             AND nota-fiscal.serie         = devol-cli.serie
             AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
             AND nota-fiscal.emite-duplic,
            EACH item-doc-est FIELDS OF devol-cli NO-LOCK:
    
            FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK 
                 WHERE it-nota-fisc.it-codigo  = item-doc-est.it-codigo 
                   AND it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp NO-ERROR.

            IF AVAIL it-nota-fisc THEN
               FIND FIRST ped-venda NO-LOCK 
                    WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                      AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
             
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
    
            IF NOT AVAIL int-ped-venda2 THEN  
                NEXT.

            ASSIGN de-total = de-total + (item-doc-est.quantidade * -1).
        END.

        ASSIGN int-pv-canal.qt-faturada = de-total.

        /*Totaliza Carteira*/
        FOR EACH ped-item NO-LOCK
           WHERE ped-item.it-codigo     = int-pv-canal.it-codigo
             AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) 
             AND ped-item.dt-entrega    = dt-aux
             /*NÆo soma o registro dele mesmo pois a trigger de altera‡Æo de data ir  somar*/
             AND rowid(ped-item) <> r-ped-item,
           FIRST ped-venda OF ped-item NO-LOCK,
           FIRST int-ped-venda2 
           WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido 
             AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-LOCK:

            /*considerar somente os pedidos que geram titulo*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            IF NOT natur-oper.emite-duplic THEN
                NEXT.

            IF ped-venda.cod-priori = 44 /* or‡amento */ THEN 
                NEXT.
            
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
        END.
    END.
END PROCEDURE.
