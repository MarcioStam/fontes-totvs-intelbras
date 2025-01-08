{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
    /*fnEstoque*/
{esp/pdp/espdp006fn.i}
DEFINE STREAM str-excel.


DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL     NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estabel-ini  LIKE ped-venda.cod-estabel
    FIELD cod-estabel-fim  LIKE ped-venda.cod-estabel
    FIELD tp-pedido-ini    LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim    LIKE ped-venda.tp-pedido
    FIELD dt-implanta-ini  LIKE ped-venda.dt-implant
    FIELD dt-implanta-fim  LIKE ped-venda.dt-implant
    FIELD dt-entrega-ini   LIKE ped-item.dt-entrega
    FIELD dt-entrega-fim   LIKE ped-item.dt-entrega
    FIELD nr-pedcli-ini    LIKE ped-venda.nr-pedcli
    FIELD nr-pedcli-fim    LIKE ped-venda.nr-pedcli
    FIELD cod-emitente-ini LIKE ped-venda.cod-emitente
    FIELD cod-emitente-fim LIKE ped-venda.cod-emitente
    FIELD no-ab-reppri-ini LIKE ped-venda.no-ab-reppri
    FIELD no-ab-reppri-fim LIKE ped-venda.no-ab-reppri
    FIELD cod-cond-pag-ini LIKE ped-venda.cod-cond-pag
    FIELD cod-cond-pag-fim LIKE ped-venda.cod-cond-pag
    FIELD grp-canais-ini   LIKE int-ped-venda2.int-1
    FIELD grp-canais-fim   LIKE int-ped-venda2.int-1
    FIELD cod-unid-neg-ini LIKE ped-item.cod-unid-neg
    FIELD cod-unid-neg-fim LIKE ped-item.cod-unid-neg
    FIELD prioridade       AS CHAR
    FIELD atendente-mestre AS CHAR
    FIELD deposito         AS CHAR
    FIELD it-codigo        AS CHAR
    FIELD avaliado         AS LOG
    FIELD aprovado         AS LOG
    FIELD nao-aprovado     AS LOG
    FIELD pend-info        AS LOG
    FIELD nao-avaliado     AS LOG
    FIELD ped-aberto       AS LOG
    FIELD ped-atend-parc   AS LOG
    FIELD it-aberto        AS LOG
    FIELD it-atend-parc    AS LOG
    FIELD acao             AS INT
    FIELD estado-ini       AS CHAR
    FIELD estado-fim       AS CHAR
    FIELD permite          AS LOG
    FIELD origem-mercad    AS INT
    FIELD tg-automatico    AS LOG
    FIELD desaloca-plan    AS LOG.

define temp-table tt-digita no-undo
    FIELD nr-pedido    LIKE ped-venda.nr-pedido
    FIELD nr-sequencia LIKE ped-item.nr-sequencia
    field it-codigo    LIKE ped-item.it-codigo
    index id it-codigo.

DEF TEMP-TABLE tt-prog-ponto-espdp090 LIKE tt-prog-ponto.

DEF TEMP-TABLE tt-usuarios-reserva NO-UNDO
    FIELD usuario AS CHAR.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-int-1     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-dir-import AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

DEFINE VARIABLE qtd-total-disponivel AS DECIMAL     NO-UNDO.
DEF VAR de-disponivel AS DECIMAL NO-UNDO.
DEFINE VAR l-desaloca-inadimplente AS LOG NO-UNDO.

DEFINE VAR d-data AS DATE.

DEFINE VAR c-ini AS CHAR.
DEFINE VAR c-fim AS CHAR.
DEFINE VAR l-achou-aloc AS LOG NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

IF tt-param.tg-automatico THEN DO:
    ASSIGN tt-param.dt-implanta-ini = TODAY - 365
           tt-param.dt-implanta-fim = TODAY
           tt-param.dt-entrega-ini  = TODAY - 365
           tt-param.dt-entrega-fim  = TODAY.
END.

ASSIGN c-ini = STRING(TIME,"HH:MM:SS").

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-inadimplencia NO-UNDO
       FIELD cd-status        AS CHAR
       FIELD cod-emitente     AS CHAR
       FIELD matriz-planilha  AS CHAR
       FIELD canal            AS CHAR
       FIELD vl-disp          AS CHAR
       FIELD vl-faturar       AS CHAR
       FIELD nome-repres      AS CHAR
       FIELD nome-matriz      AS CHAR.


IF tt-param.desaloca-plan THEN DO:

    EMPTY TEMP-TABLE tt-inadimplencia.
    
    RUN esp/es0018p.p (INPUT "espdp090":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
       ASSIGN c-dir-import = tt-prog-ponto.conteudo. //REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END. 
    
    INPUT FROM VALUE(c-dir-import).
       REPEAT:
           CREATE tt-inadimplencia.
           IMPORT DELIMITER ";" tt-inadimplencia .
       END.
    INPUT CLOSE. 

END.

FOR EACH tt-inadimplencia:
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int(tt-inadimplencia.cod-emitente) NO-ERROR.
    IF AVAIL emitente THEN
        ASSIGN tt-inadimplencia.nome-matriz = emitente.nome-matriz.
END.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESPDP090_" + tt-param.cod-estabel-ini + "_" + STRING(TIME,"HH:MM:SS") + ".csv":U
           c-arquivo-csv = REPLACE(c-arquivo-csv,":","").

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
PUT STREAM str-excel UNFORMATTED "Estabelecimento;Natur.Oper;Cliente;Pedido;Atendente;Prioridade;Grupo de Canal;Dt Entrega;Item;Descri‡Æo;Situa‡Æo Item;Qt Pedida;Qt Saldo;Qt Alocada;Pre‡o Total;Erro?;Descri‡Æo" SKIP.

DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "espdp090",                       
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).

    EMPTY TEMP-TABLE tt-prog-ponto-espdp090.

    FOR EACH tt-prog-ponto:
        CREATE tt-prog-ponto-espdp090.
        BUFFER-COPY tt-prog-ponto TO tt-prog-ponto-espdp090.

    END.

    FIND FIRST deposito WHERE deposito.cod-depos = tt-param.deposito NO-LOCK NO-ERROR.

    IF CAN-FIND(FIRST tt-digita) THEN
    DO:
       FOR EACH tt-digita,
           FIRST ped-venda 
           WHERE ped-venda.nr-pedido  = tt-digita.nr-pedido NO-LOCK,
           FIRST ped-item 
           WHERE ped-item.nome-abrev   = ped-venda.nome-abrev 
             AND ped-item.nr-pedcli    = ped-venda.nr-pedcli 
             AND ped-item.nr-sequencia = tt-digita.nr-sequencia 
             AND ped-item.it-codigo    = tt-digita.it-codigo NO-LOCK,
           FIRST emitente NO-LOCK 
           WHERE emitente.cod-emitente  = ped-venda.cod-emitente:

           FIND FIRST tt-prog-ponto-espdp090 
                WHERE tt-prog-ponto-espdp090.conteudo = ped-venda.nat-operacao NO-ERROR.
           
           //ESTAB INTELBRAS
           IF tt-param.origem-mercad = 1 THEN DO: 
              IF AVAIL tt-prog-ponto-espdp090 THEN 
                 NEXT.
           END.
           ELSE DO: //DEPOSITO ENTREPOSTO
              IF NOT AVAIL tt-prog-ponto-espdp090 THEN 
                 NEXT.
           END.       

           RUN pi-processamento.
       END.
    END.
    ELSE DO:
       DO i = 1 TO NUM-ENTRIES(tt-param.prioridade,";"):
             
           /* FOR EACH ped-venda NO-LOCK
                 WHERE (ped-venda.cod-sit-ped   = 1 OR ped-venda.cod-sit-ped   = 2)
                   AND ped-venda.completo
                   AND ped-venda.cod-priori   <> 44
                   AND ped-venda.cod-estabel  >= tt-param.cod-estabel-ini
                   AND ped-venda.cod-estabel  <= tt-param.cod-estabel-fim
                   AND ped-venda.nr-pedcli    >= tt-param.nr-pedcli-ini
                   AND ped-venda.nr-pedcli    <= tt-param.nr-pedcli-fim
                   AND ped-venda.cod-emitente >= tt-param.cod-emitente-ini
                   AND ped-venda.cod-emitente <= tt-param.cod-emitente-fim
                   AND ped-venda.cod-priori    = INT(ENTRY(i,tt-param.prioridade,";"))
                   AND ped-venda.no-ab-reppri >= tt-param.no-ab-reppri-ini
                   AND ped-venda.no-ab-reppri <= tt-param.no-ab-reppri-fim
                   AND ped-venda.tp-pedido    >= tt-param.tp-pedido-ini
                   AND ped-venda.tp-pedido    <= tt-param.tp-pedido-fim
                   AND ped-venda.dt-implant   >= tt-param.dt-implanta-ini
                   AND ped-venda.dt-implant   <= tt-param.dt-implanta-fim
                   AND ped-venda.dt-entrega   >= tt-param.dt-entrega-ini
                   AND ped-venda.dt-entrega   <= tt-param.dt-entrega-fim
                   AND ped-venda.cod-cond-pag >= tt-param.cod-cond-pag-ini
                   AND ped-venda.cod-cond-pag <= tt-param.cod-cond-pag-fim
                   AND ped-venda.int-1        >= tt-param.grp-canais-ini
                   AND ped-venda.int-1        <= tt-param.grp-canais-fim 
                   AND ped-venda.estado       >= tt-param.estado-ini
                   AND ped-venda.estado       <= tt-param.estado-fim ,
                  FIRST emitente NO-LOCK 
                  WHERE emitente.cod-emitente  = ped-venda.cod-emitente
                    AND (emitente.ind-lib-estoq = YES 
                     OR  ped-venda.cod-sit-aval = 3   
                     OR  ped-venda.mo-codigo   <> 0), 
                  EACH ped-item OF ped-venda NO-LOCK
                  WHERE  ped-item.cod-unid-neg  >= tt-param.cod-unid-neg-ini
                   AND ped-item.cod-unid-neg  <= tt-param.cod-unid-neg-fim
                   AND ped-item.cod-sit-item  <= 2
                   AND ped-item.dt-entrega    >= tt-param.dt-entrega-ini
                   AND ped-item.dt-entrega    <= tt-param.dt-entrega-fim 
                    BY ped-venda.nr-pedcli:   */

             
                FOR EACH ped-venda NO-LOCK USE-INDEX ch-implant
                   WHERE ped-venda.cod-sit-ped <= 2
                     AND ped-venda.cod-priori   = INT(ENTRY(i,tt-param.prioridade,";"))
                      BY ped-venda.dt-implant
                      BY ped-venda.nr-pedido:              
               
                      IF ped-venda.completo   <> YES THEN NEXT.
                      IF ped-venda.cod-priori = 44   THEN NEXT.
                     
                      IF ped-venda.cod-estabel < tt-param.cod-estabel-ini 
                      OR ped-venda.cod-estabel > tt-param.cod-estabel-fim  THEN NEXT.
               
                      IF ped-venda.nr-pedcli < tt-param.nr-pedcli-ini 
                      OR ped-venda.nr-pedcli > tt-param.nr-pedcli-fim THEN NEXT.
               
                      IF ped-venda.cod-emitente < tt-param.cod-emitente-ini
                      OR ped-venda.cod-emitente > tt-param.cod-emitente-fim THEN NEXT.
                      
                      IF ped-venda.no-ab-reppri < tt-param.no-ab-reppri-ini
                      OR ped-venda.no-ab-reppri > tt-param.no-ab-reppri-fim THEN NEXT.
               
                      IF ped-venda.tp-pedido    < tt-param.tp-pedido-ini
                      OR ped-venda.tp-pedido    > tt-param.tp-pedido-fim THEN NEXT.
               
                      IF ped-venda.dt-implant   < tt-param.dt-implanta-ini
                      OR ped-venda.dt-implant   > tt-param.dt-implanta-fim  THEN NEXT.
               
                      IF ped-venda.dt-entrega   < tt-param.dt-entrega-ini
                      OR ped-venda.dt-entrega   > tt-param.dt-entrega-fim THEN NEXT.
               
                      IF ped-venda.cod-cond-pag < tt-param.cod-cond-pag-ini
                      OR ped-venda.cod-cond-pag > tt-param.cod-cond-pag-fim THEN NEXT.
               
                      IF ped-venda.int-1 < tt-param.grp-canais-ini
                      OR ped-venda.int-1 > tt-param.grp-canais-fim  THEN NEXT.
               
                      IF ped-venda.estado < tt-param.estado-ini
                      OR ped-venda.estado > tt-param.estado-fim THEN NEXT.
               
                     FOR FIRST emitente NO-LOCK 
                         WHERE emitente.cod-emitente   = ped-venda.cod-emitente
                           AND (emitente.ind-lib-estoq = YES 
                            OR  ped-venda.cod-sit-aval = 3   
                            OR  ped-venda.mo-codigo   <> 0):                 
               
                            FOR EACH ped-item OF ped-venda NO-LOCK
                               WHERE ped-item.cod-unid-neg >= tt-param.cod-unid-neg-ini
                                 AND ped-item.cod-unid-neg <= tt-param.cod-unid-neg-fim
                                 AND ped-item.cod-sit-item <= 2
                                 AND ped-item.dt-entrega   >= tt-param.dt-entrega-ini
                                 AND ped-item.dt-entrega   <= tt-param.dt-entrega-fim 
                                  BY ped-venda.nr-pedido:    
                            
                                /*Executar somente para este item quando informado*/
                                IF  tt-param.it-codigo <> "" 
                                AND ped-item.it-codigo <> tt-param.it-codigo THEN
                                    NEXT.
                               
                                FIND FIRST tt-prog-ponto-espdp090 
                                     WHERE tt-prog-ponto-espdp090.conteudo = ped-venda.nat-operacao NO-ERROR.
                             
                                //ESTAB INTELBRAS
                                IF tt-param.origem-mercad = 1 THEN DO: 
                                   IF AVAIL tt-prog-ponto-espdp090 THEN 
                                      NEXT.
                                END.
                                ELSE DO: //DEPOSITO ENTREPOSTO
                                   IF NOT AVAIL tt-prog-ponto-espdp090 THEN 
                                      NEXT.
                                END.
                                RUN pi-processamento.
                            END. // for each ped-item
                     END. //for first emitente
                END. //for each ped-venda 
        END. // do i
    END. //else
END. // do trans

OUTPUT STREAM str-excel CLOSE.

ASSIGN c-fim = STRING(TIME,"HH:MM:SS").

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

/* fim */ 
RETURN "OK".   

PROCEDURE pi-processamento:


       //Desaloca somente cliente da planilha que estiver inadimplentes
   IF tt-param.desaloca-plan AND tt-param.acao = 3 THEN DO:
       ASSIGN l-desaloca-inadimplente = NO.

       IF emitente.cod-gr-cli = 51 THEN DO: //somente distribuicao
           FIND FIRST tt-inadimplencia //se estiver na planilha vai passar pela desalocacao
                WHERE tt-inadimplencia.nome-matriz = emitente.nome-matriz NO-ERROR.
           IF AVAIL tt-inadimplencia THEN 
              ASSIGN l-desaloca-inadimplente = YES.

       END.
       IF NOT l-desaloca-inadimplente THEN NEXT.
   END.

   ASSIGN l-achou-aloc = YES.

   
   ASSIGN de-saldo = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.

   IF  de-saldo <= 0 
   AND tt-param.acao = 2 THEN
       NEXT.
  
   /*Chamado C2102-0056*/
   IF tt-param.atendente-mestre <> "" THEN DO: 
      FIND FIRST atendente NO-LOCK
           WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
      IF AVAIL atendente THEN
          IF atendente.oper-mestre <> int(tt-param.atendente-mestre) THEN
              NEXT.
   END.
   
   RUN pi-acompanhar in h-acomp (input "Pedido: " + string(ped-venda.nr-pedido) + ' ' + ped-venda.nat-operacao).
   
   /*Aloca*/
   IF tt-param.acao = 2 THEN DO:

       /*Aloca‡Æo parcial*/
       IF /*ped-item.tipo-atend = 2 OR*/ tt-param.permite THEN DO:
           ASSIGN qtd-total-disponivel = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, tt-param.deposito, "", NO).

           IF  qtd-total-disponivel > 0
           AND qtd-total-disponivel < de-saldo THEN
               ASSIGN de-saldo = qtd-total-disponivel.

           RUN piEspd080.

       END.

       RUN esp/pdp/espdp006f.p (INPUT c-seg-usuario,
                                INPUT ROWID(ped-venda),
                                INPUT ROWID(ped-item),
                                INPUT tt-param.deposito,
                                INPUT "",
                                INPUT de-saldo,
                                INPUT ped-item.cod-unid-neg,
                                OUTPUT TABLE tt-erro).

       IF NOT CAN-FIND (FIRST tt-erro) THEN
           RUN pi-marca-pedido.
       
   END.
   /*Desaloca*/                                                                                               
   ELSE IF tt-param.acao = 3 THEN DO:                                                                         
       RUN esp/pdp/espdp006f1.p (INPUT ROWID(ped-item),
                                 INPUT tt-param.deposito,
                                 OUTPUT TABLE tt-erro).

       IF NOT CAN-FIND (FIRST tt-erro) THEN
           RUN pi-marca-pedido.
   END.

   FOR EACH ped-ent OF ped-item NO-LOCK :
       FOR EACH ped-saldo NO-LOCK
          WHERE ped-saldo.cod-depos   <> tt-param.deposito  
            AND ped-saldo.cod-estabel = ped-venda.cod-estabel 
            AND ped-saldo.nome-abrev  = ped-ent.nome-abrev      
            AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       
            AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia    
            AND ped-saldo.it-codigo   = ped-ent.it-codigo       
            AND ped-saldo.cod-refer   = ped-ent.cod-refer       
            AND ped-saldo.nr-entrega  = ped-ent.nr-entrega:

           ASSIGN l-achou-aloc = NO.
           LEAVE.
       END.

   END.

   IF NOT l-achou-aloc THEN NEXT. //nao lista itens alocados em depositos diferente do que foi informado em tela 
   
   RUN pi-imprime.


END PROCEDURE.


PROCEDURE pi-imprime:
     FIND FIRST int-ped-venda2 NO-LOCK
          WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

     FIND FIRST ITEM NO-LOCK
          WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

    ASSIGN de-saldo = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca
           i-int-1  = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0.
    PUT STREAM str-excel UNFORMATTED ped-venda.cod-estabel         + ";" +
                                     ped-venda.nat-operacao        + ";" +
                                     ped-venda.nome-abrev          + ";" +
                                     ped-venda.nr-pedcli           + ";" +
                                     string(ped-venda.tp-pedido)   + ";" +
                                     string(ped-venda.cod-priori)  + ";" +
                                     string(i-int-1)               + ";" +
                                     string(ped-item.dt-entrega)   + ";" +
                                     ped-item.it-codigo            + ";" +
                                     item.desc-item                + ";" +
                                     {diinc/i03di149.i 04 ped-item.cod-sit-item} + ";" +
                                     string(ped-item.qt-pedida)    + ";" +
                                     string(de-saldo)              + ";" +
                                     string(ped-item.qt-log-aloca) + ";" +
                                     string(ped-item.vl-merc-abe)  + ";".

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        PUT STREAM str-excel UNFORMATTED "Sim;".

        FOR EACH tt-erro:
            PUT STREAM str-excel UNFORMATTED tt-erro.mensagem + " - ".
        END.
    END.
    ELSE 
        PUT STREAM str-excel UNFORMATTED "NÆo;".

    PUT STREAM str-excel SKIP.
END PROCEDURE.

PROCEDURE pi-marca-pedido:
    /*Marca os pedidos que tiveram quantidades alocadas/desalocadas para integrar com programa de canais via msg0091.p*/
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    IF  AVAIL int-ped-venda
    AND AVAIL int-emitente 
    AND int-emitente.ind-participa-canais  = 993520001 THEN DO:
        OVERLAY(int-ped-venda.char-1,66,1) = "1".
    END.
    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE      int-ped-venda.
END PROCEDURE.

PROCEDURE piEspd080:

    DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    EMPTY TEMP-TABLE tt-usuarios-reserva.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-usuarios-reserva.
            ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
        END.
    END.

    FIND FIRST int-ped-venda2 NO-LOCK
        WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
          AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

    FOR EACH reservas-ast
        WHERE reservas-ast.cod-depos    = tt-param.deposito
        AND   reservas-ast.it-codigo    = ped-item.it-codigo
        AND   reservas-ast.cod-estabel  = ped-venda.cod-estabel 
        AND   reservas-ast.dt-reserva  <= TODAY NO-LOCK:

        IF  AVAIL int-ped-venda2
        AND int-ped-venda2.PedidoeCommerce <> "" THEN DO:
            /*Caso existam reservas mas os usu rio reservam para VTEX*/
            IF  CAN-FIND(FIRST tt-usuarios-reserva
                         WHERE tt-usuarios-reserva.usuario = reservas-ast.cd-usuario) THEN
                NEXT.
        END.

        IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
            ASSIGN d-qtde-reservas-ast         = d-qtde-reservas-ast + reservas-ast.qt-reserva.
        END.
    END.

    IF d-qtde-reservas-ast > 0 THEN DO:

        /* Se o saldo em estoque for maior que a reserva somada … qtde pedida */
        IF fnEstoque(ped-venda.cod-estabel,ped-item.it-codigo, tt-param.deposito, "*", NO) < (d-qtde-reservas-ast + de-saldo) THEN DO:
            
            /* se a qtde pedida for maios que o saldo em estoque subtraindo as reservas, aloca somente at‚ o limite disponivel */
            ASSIGN de-disponivel = fnEstoque(ped-venda.cod-estabel,ped-item.it-codigo, tt-param.deposito, "*", NO) - d-qtde-reservas-ast.
            
            IF de-disponivel < de-saldo THEN
                ASSIGN de-saldo = de-disponivel.

            ELSE 
                ASSIGN de-saldo = de-saldo - d-qtde-reservas-ast.

        END.
    END.

END PROCEDURE.


PROCEDURE pi-verif-natur-entreposto:

   /*
   IF AVAIL deposito THEN DO:
      FIND FIRST tt-prog-ponto-espdp090 WHERE tt-prog-ponto-espdp090.conteudo = ped-venda.nat-operacao NO-ERROR.

      //ESTAB INTELBRAS
      IF tt-param.origem-mercad = 1 THEN DO: 
         IF AVAIL tt-prog-ponto-espdp090 THEN 
            RETURN 'nok'.
      END.
      ELSE DO: //DEPOSITO ENTREPOSTO
         IF NOT AVAIL tt-prog-ponto-espdp090 THEN 
            RETURN 'nok'. 
      END. 
   END.

   RETURN 'ok'.
   */

END PROCEDURE.
