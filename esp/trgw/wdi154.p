/********************************************************************************
 ** UPC........: wdi154.p- UPC WRITE ped-item    
 ** Data.......: outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos itens do pedido de venda 
 **              para o CRM
 ********************************************************************************/

CREATE WIDGET-POOL.

DEF PARAM BUFFER b-ped-item      FOR ped-item.
DEF PARAM BUFFER b-old-ped-item  FOR ped-item.

define temp-table tt-ped-venda no-undo like ped-venda.
define temp-table tt-ped-item  no-undo like ped-item.

DEFINE VARIABLE i-sequencia    AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-dir          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-ini-mes-seg AS DATE      NO-UNDO.
DEFINE VARIABLE dt-ini         AS DATE      NO-UNDO.
DEFINE VARIABLE dt-fim         AS DATE      NO-UNDO.

DEFINE VARIABLE c-email-destino AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNom_from       AS CHARACTER NO-UNDO.

DEFINE BUFFER b-int-pv-canal FOR int-pv-canal.

{esp/es0018.i}
{utp/ut-glob.i}
{esp/wso/out/wso0004.i} /*Include Vtex*/
{utp/utapi019.i}


/** TRATATIVA DE LOG - ALTERA€ÇO PRE€O UNITµRIO **/
EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

/* Projeto Moderniza‡Æo Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos */
IF  NOT NEW b-ped-item THEN DO:
    FIND FIRST ped-venda OF b-ped-item NO-LOCK NO-ERROR.

    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    /*considerar somente os pedidos que geram titulo*/
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = b-ped-item.nat-operacao NO-ERROR.

    /*
    /*Deduz carteira no cancelamento do item*/
    IF  b-ped-item.cod-sit-item <> b-old-ped-item.cod-sit-item
    AND b-ped-item.cod-sit-item  = 6 
    AND ped-venda.cod-priori <> 44 
    AND natur-oper.emite-duplic
    AND (b-old-ped-item.cod-sit-item <= 2 OR b-old-ped-item.cod-sit-item = 5)  THEN DO:

        FIND FIRST int-pv-canal EXCLUSIVE-LOCK
             WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
               AND int-pv-canal.it-codigo = b-ped-item.it-codigo
               AND int-pv-canal.mes-meta  = MONTH(b-old-ped-item.dt-entrega)
               AND int-pv-canal.ano-meta  = YEAR(b-old-ped-item.dt-entrega) NO-ERROR.

        IF AVAIL int-pv-canal THEN DO:
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira - (b-ped-item.qt-pedida - b-ped-item.qt-atendida).
            FIND CURRENT int-pv-canal NO-LOCK NO-ERROR.
        END.
    END.

    IF  b-ped-item.qt-pedida <> b-old-ped-item.qt-pedida
    AND ped-venda.cod-priori <> 44 
    AND natur-oper.emite-duplic 
    AND (b-ped-item.cod-sit-item <= 2 OR b-ped-item.cod-sit-item = 5) THEN DO:

        FIND FIRST int-pv-canal EXCLUSIVE-LOCK
             WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
               AND int-pv-canal.it-codigo = b-ped-item.it-codigo
               AND int-pv-canal.mes-meta  = MONTH(b-old-ped-item.dt-entrega)
               AND int-pv-canal.ano-meta  = YEAR(b-old-ped-item.dt-entrega) NO-ERROR.

        IF AVAIL int-pv-canal THEN DO:
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira - (b-old-ped-item.qt-pedida - b-old-ped-item.qt-atendida)
                   int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (b-ped-item.qt-pedida - b-ped-item.qt-atendida).
            FIND CURRENT int-pv-canal NO-LOCK NO-ERROR.
        END.
    END.

    IF  b-ped-item.dt-entrega <> b-old-ped-item.dt-entrega
    AND MONTH(b-ped-item.dt-entrega) <> MONTH(b-old-ped-item.dt-entrega)
    AND ped-venda.cod-priori <> 44 
    AND natur-oper.emite-duplic 
    AND (b-ped-item.cod-sit-item <= 2 OR b-ped-item.cod-sit-item = 5) THEN DO:
        /*Busca a meta da data antiga*/
        FIND FIRST b-int-pv-canal EXCLUSIVE-LOCK
             WHERE b-int-pv-canal.cod-canal = int-ped-venda2.int-1
               AND b-int-pv-canal.it-codigo = b-old-ped-item.it-codigo
               AND b-int-pv-canal.mes-meta  = MONTH(b-old-ped-item.dt-entrega)
               AND b-int-pv-canal.ano-meta  = YEAR(b-old-ped-item.dt-entrega) NO-ERROR.

        IF AVAIL b-int-pv-canal THEN DO:
            /*Deduz a quantia da meta com a data antiga*/
            ASSIGN b-int-pv-canal.qt-carteira = b-int-pv-canal.qt-carteira - (b-ped-item.qt-pedida - b-ped-item.qt-atendida).
            FIND CURRENT b-int-pv-canal NO-LOCK NO-ERROR.
        END.
        
        /*Busca a meta da nova data*/
        FIND FIRST int-pv-canal EXCLUSIVE-LOCK
             WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
               AND int-pv-canal.it-codigo = b-ped-item.it-codigo
               AND int-pv-canal.mes-meta  = MONTH(b-ped-item.dt-entrega)
               AND int-pv-canal.ano-meta  = YEAR(b-ped-item.dt-entrega) NO-ERROR.

        IF AVAIL int-pv-canal THEN DO:
            /*Soma a quantidade da meta com a data nova*/
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (b-ped-item.qt-pedida - b-ped-item.qt-atendida).
            FIND CURRENT int-pv-canal NO-LOCK NO-ERROR.
        END.
    END.
    */

   /* IF  b-ped-item.qt-log-aloca <> b-old-ped-item.qt-log-aloca
    THEN DO:
        FIND int-evento-monitorado NO-LOCK
            WHERE int-evento-monitorado.cod-evento = 3 /* Aloca‡Æo do item do pedido */
              AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
        IF AVAIL int-evento-monitorado
        THEN
            RUN pi-cria-historico-evento.
    END. /* IF  b-ped-item.qt-log-aloca <> b-old-ped-item.qt-log-aloca */
    */

    IF  b-ped-item.cod-sit-item = 6 AND /* Cancelamento */
        b-ped-item.cod-sit-item <> b-old-ped-item.cod-sit-item
    THEN DO:
        FIND int-evento-monitorado NO-LOCK
            WHERE int-evento-monitorado.cod-evento = 5 /* Cancelamento do item do pedido */
              AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
        IF AVAIL int-evento-monitorado
        THEN
            RUN pi-cria-historico-evento.
    END. /* b-ped-item.cod-sit-item = 6 AND */

    IF  b-ped-item.qt-pedida <> b-old-ped-item.qt-pedida
    THEN DO:
        FIND int-evento-monitorado NO-LOCK
            WHERE int-evento-monitorado.cod-evento = 10 /*Quantidade Pedida */
              AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
        IF AVAIL int-evento-monitorado
        THEN
            RUN pi-cria-historico-evento.
    END. /* IF  b-ped-item.qt-log-aloca <> b-old-ped-item.qt-log-aloca */


    IF  b-ped-item.dt-entrega <> b-old-ped-item.dt-entrega
    THEN DO:
        FIND int-evento-monitorado NO-LOCK
            WHERE int-evento-monitorado.cod-evento = 11 /* Aloca‡Æo do item do pedido */
              AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
        IF AVAIL int-evento-monitorado THEN
            RUN pi-cria-historico-evento.
    END. /* IF  b-ped-item.qt-log-aloca <> b-old-ped-item.qt-log-aloca */


END. /* IF  NOT NEW b-ped-item */

FIND FIRST ped-venda OF b-ped-item NO-LOCK NO-ERROR.

FIND FIRST int-ped-venda NO-LOCK
     WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
       AND int-ped-venda.cod-estabel = ped-venda.cod-estabel  NO-ERROR.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                   INPUT 1,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FIND FIRST tt-prog-ponto 
     WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

/*Marca para envio batch*/
IF  AVAIL int-ped-venda
AND NOT AVAIL tt-prog-ponto THEN DO:
    
    IF  (INDEX(PROGRAM-NAME(1),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(1),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(2),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(2),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(3),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(3),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(4),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(4),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(5),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(5),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(6),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(6),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(7),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(7),'espdp006') <> ?) OR  
        (INDEX(PROGRAM-NAME(8),'espdp006') <> 0 AND INDEX(PROGRAM-NAME(8),'espdp006') <> ?) THEN DO:
    END.
    ELSE DO:
        FIND CURRENT int-ped-venda EXCLUSIVE-LOCK NO-ERROR.
        OVERLAY(int-ped-venda.char-1,76,1) = "1" .
        RELEASE int-ped-venda.
    END.
        
END.

IF  ped-venda.completo
AND (ped-venda.cod-sit-ped = 2 OR ped-venda.cod-sit-ped = 3) THEN DO:

    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

    IF NOT AVAIL int-ped-venda2 THEN DO:
        CREATE int-ped-venda2.
        ASSIGN int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
               int-ped-venda2.cod-estabel = ped-venda.cod-estabel.
    END.

    ASSIGN int-ped-venda2.dec-2 = b-old-ped-item.vl-liq-abe.

    FIND CURRENT int-ped-venda2 NO-LOCK NO-ERROR.
    RELEASE int-ped-venda2.
END.

IF NEW b-ped-item THEN DO:

    FOR EACH item-segmentos
        WHERE item-segmentos.it-codigo = b-ped-item.it-codigo NO-LOCK:

        FIND ped-item-segmentos
            WHERE ped-item-segmentos.nr-pedcli      = b-ped-item.nr-pedcli   
              AND ped-item-segmentos.nome-abrev     = b-ped-item.nome-abrev  
              AND ped-item-segmentos.nr-sequencia   = b-ped-item.nr-sequencia
              AND ped-item-segmentos.it-codigo      = b-ped-item.it-codigo   
              AND ped-item-segmentos.cod-segmento   = item-segmentos.cod-segmento NO-LOCK NO-ERROR.
        IF NOT AVAIL ped-item-segmentos THEN DO:
            CREATE ped-item-segmentos.
            ASSIGN ped-item-segmentos.nr-pedcli      = b-ped-item.nr-pedcli             
                   ped-item-segmentos.nome-abrev     = b-ped-item.nome-abrev            
                   ped-item-segmentos.nr-sequencia   = b-ped-item.nr-sequencia        
                   ped-item-segmentos.it-codigo      = b-ped-item.it-codigo           
                   ped-item-segmentos.cod-segmento   = item-segmentos.cod-segmento 
                   ped-item-segmentos.val-percentual = item-segmentos.val-percentual .

            RELEASE ped-item-segmentos.
        END. /* IF NOT AVAIL ped-item-segmentos THEN DO: */

    END. /* FOR EACH item-segmentos */

END.

/*Verificar data entrega maior que 2 anos e disparar email marcio*/
IF (NEW b-ped-item AND b-ped-item.dt-entrega > TODAY + 730) OR
    (b-ped-item.dt-entrega <> b-old-ped-item.dt-entrega AND b-ped-item.dt-entrega > TODAY + 730) THEN DO:

    RUN esp/es0018p.p (INPUT  "wdi154":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto  NO-ERROR.
    assign c-email-destino =  tt-prog-ponto.conteudo.

    RUN pi-manda-email-item-alterado.
END.


PROCEDURE pi-cria-historico-evento:

    FIND ped-venda OF b-ped-item NO-LOCK NO-ERROR.
    
    IF  AVAIL ped-venda
    THEN DO:
        ASSIGN i-sequencia = 1.
        FIND LAST int-historico-evento NO-LOCK NO-ERROR.
        IF  AVAIL int-historico-evento
        THEN
            ASSIGN i-sequencia = int-historico-evento.num-seq-historico + 1.

        RELEASE int-historico-evento.

        FIND FIRST int-historico-evento NO-LOCK
             WHERE int-historico-evento.num-seq-historico = i-sequencia NO-ERROR.
        IF NOT AVAIL int-historico-evento THEN DO:
           CREATE int-historico-evento.
           ASSIGN int-historico-evento.num-seq-historico  = i-sequencia
                  int-historico-evento.cod-emitente       = ped-venda.cod-emitente
                  int-historico-evento.nr-pedcli          = ped-venda.nr-pedcli
                  int-historico-evento.cod-estabel        = ped-venda.cod-estabel
                  int-historico-evento.cod-sit-item       = b-ped-item.cod-sit-item
                  int-historico-evento.it-codigo          = b-ped-item.it-codigo
                  int-historico-evento.nr-sequencia       = b-ped-item.nr-sequencia
                  int-historico-evento.qtd-pedida         = b-ped-item.qt-pedida
                  int-historico-evento.qt-anterior        = b-old-ped-item.qt-pedida
                  int-historico-evento.qtd-alocada-pedido = b-ped-item.qt-log-aloca
                  int-historico-evento.cod-motivo-cancela = b-ped-item.cod-mot-canc-cot
                  int-historico-evento.cod-evento         = int-evento-monitorado.cod-evento
                  int-historico-evento.dat-1              = b-ped-item.dt-entrega
                  int-historico-evento.cod-usuario        = c-seg-usuario
                  int-historico-evento.dat-historico      = NOW.
        END.
    END.
    FIND CURRENT int-historico-evento NO-LOCK NO-ERROR.
    RELEASE int-historico-evento.

END PROCEDURE.

PROCEDURE pi-totaliza:
    DEFINE VARIABLE dt-aux    AS DATE        NO-UNDO.
    DEFINE VARIABLE de-total  AS DECIMAL     NO-UNDO.
        
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
             AND devol-cli.it-codigo       = int-pv-canal.it-codigo
                 NO-LOCK,
           FIRST nota-fiscal        
           WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
             AND nota-fiscal.serie         = devol-cli.serie
             AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
             AND nota-fiscal.emite-duplic
                 NO-LOCK,
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

        FIND CURRENT int-pv-canal EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN int-pv-canal.qt-faturada = de-total.
        FIND CURRENT int-pv-canal NO-LOCK NO-ERROR.

        /*Totaliza Carteira*/
        FOR EACH ped-item NO-LOCK
           WHERE ped-item.it-codigo     = int-pv-canal.it-codigo
             AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) 
             AND ped-item.dt-entrega    = dt-aux,
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
            
            FIND CURRENT int-pv-canal EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
            FIND CURRENT int-pv-canal NO-LOCK NO-ERROR.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-manda-email-item-alterado.
    
    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.


    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     = c-email-destino
           tt-envio2.assunto     = "Altera‡Æo data prev do item do pedido :" + b-ped-item.it-codigo + " - " + b-ped-item.nr-pedcli
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".
    
    IF v_cod_usuar_corren = ? THEN
        ASSIGN v_cod_usuar_corren = "".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "        ALTERACAO DATA PREVISTA ITEM PEDIDO       " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Item: "             + b-ped-item.it-codigo              + CHR(13) +
                                      "Seq: "              + string(b-ped-item.nr-sequencia)   + CHR(13) +
                                      "Pedido: "           + b-ped-item.nr-pedcli              + CHR(13) +
                                      "Data Entrega: "     + string(b-ped-item.dt-entrega)     + CHR(13) +
                                      "Data Entrega Ant: " + string(b-old-ped-item.dt-entrega) + CHR(13) +
                                      "Usuario:  " + v_cod_usuar_corren                        + CHR(13) +
                                      "Programa: " + IF PROGRAM-NAME(1)  <> ? then PROGRAM-NAME(1)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(2)  <> ? then PROGRAM-NAME(2)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(3)  <> ? then PROGRAM-NAME(3)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(4)  <> ? then PROGRAM-NAME(4)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(5)  <> ? then PROGRAM-NAME(5)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(6)  <> ? then PROGRAM-NAME(6)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(7)  <> ? then PROGRAM-NAME(7)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(8)  <> ? then PROGRAM-NAME(8)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(9)  <> ? then PROGRAM-NAME(9)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(10) <> ? then PROGRAM-NAME(10) else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(11) <> ? then PROGRAM-NAME(11) else ""  + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, 
                                   INPUT TABLE tt-mensagem, 
                                   OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

/*procedure pi-integra-salesforce:
  empty temp-table tt-ped-venda.
  empty temp-table tt-ped-item.
  for first ped-venda of b-ped-item no-lock:
    create tt-ped-venda.
    buffer-copy ped-venda to tt-ped-venda.

    for each ped-item of ped-venda no-lock:
      create tt-ped-item.
      if rowid(ped-item) <> rowid(b-ped-item) then
        buffer-copy ped-item to tt-ped-item.
      else
        buffer-copy b-ped-item to tt-ped-item.
    end.
  end.

  IF AVAIL tt-ped-venda AND tt-ped-venda.cod-emitente <> 15035
     AND tt-ped-venda.cod-priori <> 44 THEN
  run esp/wso/eswso0011.p(input table tt-ped-venda,
                          input table tt-ped-item).
end procedure.
*/

DELETE WIDGET-POOL.

RETURN "ok".


