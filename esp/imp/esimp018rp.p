{include/i-prgvrs.i esftp213rp 2.00.00.001}
{esp/es0018.i}
{esp/imp/esimp000.i1} /*tt-emb*/
{method/dbotterr.i}
{utp/ut-glob.i}

DEFINE BUFFER b-historico-embarque FOR historico-embarque. /*Ponto de Entrega (Despacho)*/
DEFINE BUFFER b-ordem-compra       FOR ordem-compra.
DEFINE BUFFER b1-historico-embarque FOR historico-embarque.

DEFINE VARIABLE c-arquivo-csv    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE dt-ini           AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim           AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-entrega     AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-entrega-aux AS DATE        NO-UNDO.
DEFINE VARIABLE l-achou          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-embarque       LIKE embarque-imp.embarque     NO-UNDO.

DEFINE VARIABLE h-bocx225 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404 AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-rowid   AS ROWID       NO-UNDO.
DEFINE VARIABLE l-integra-di AS LOGICAL     NO-UNDO.

DEFINE STREAM str-excel.
DEFINE BUFFER empresa FOR emscad.empresa.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

define temp-table tt-digita no-undo
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD dt-entrega   AS DATE COLUMN-LABEL "Entrega"
    FIELD dt-chegada   AS DATE COLUMN-LABEL "Chegada"
    FIELD acao         AS CHAR.
   
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esimp018_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    RUN pi-executa.

    PUT STREAM str-excel UNFORMATTED "Pedido;Ordem Compra;Parcela;Dt Entrega;Dt Chegada;Aá∆o" SKIP.

    FOR EACH tt-digita:
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.num-pedido) + ";". 
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.numero-ordem)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.parcela)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.dt-entrega)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.dt-chegada)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.acao) SKIP.
    END.
    
    OUTPUT STREAM str-excel CLOSE.
    
    RUN pi-finalizar IN h-acomp.
    
    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-executa:
    DEFINE VARIABLE l-ped AS LOGICAL     NO-UNDO.

    blk_dig:
    FOR EACH tt-digita:

        RUN pi-acompanhar in h-acomp (input "Processando Ordem: " + string(tt-digita.numero-ordem)).

        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.numero-ordem = tt-digita.numero-ordem
               AND ordens-embarque.parcela      = tt-digita.parcela NO-ERROR.

        ASSIGN l-ped = NO.
        IF NOT AVAIL ordens-embarque THEN DO:
            ASSIGN l-ped = YES.
        END.

        FIND FIRST ordem-compra NO-LOCK 
             WHERE ordem-compra.numero-ordem = tt-digita.numero-ordem NO-ERROR.

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque = ordens-embarque.embarque NO-ERROR.

        IF AVAIL embarque-imp THEN
            RUN pi-busca-data-entrega (INPUT embarque-imp.cod-estabel,
                                       INPUT embarque-imp.embarque,
                                       OUTPUT d-dt-entrega).

        IF tt-digita.dt-entrega <> d-dt-entrega
        OR l-ped THEN DO:

            RUN pi-situacao.

            IF (AVAIL tt-emb AND tt-emb.situacao = 1) /*Prev*/ 
            OR l-ped THEN DO:

                IF AVAIL embarque-imp THEN DO:
                    RUN desembarca-parcela (INPUT tt-digita.numero-ordem,
                                            INPUT tt-digita.parcela).    
    
                    IF RETURN-VALUE <> "OK" THEN
                        NEXT blk_dig.
                END.

                /*Procura outro embarque*/
                ASSIGN l-achou = NO.
                
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
                    OR tt-emb.situacao = 99 /*Agt*/
                    OR tt-emb.situacao = 96 /*Inst*/
                    OR tt-emb.situacao = 97 /*Manut*/ THEN DO:

                        RUN pi-busca-data-entrega (INPUT embarque-imp.cod-estabel,
                                                   INPUT embarque-imp.embarque,
                                                   OUTPUT d-dt-entrega-aux).

                        IF  d-dt-entrega-aux <= tt-digita.dt-entrega + 2
                        AND d-dt-entrega-aux >= tt-digita.dt-entrega - 2 THEN DO:

                            RUN embarca-parcela (INPUT embarque-imp.embarque,
                                                 INPUT tt-digita.numero-ordem, 
                                                 INPUT tt-digita.parcela).

                            IF RETURN-VALUE <> "OK" THEN
                                NEXT blk_dig.

                            ASSIGN l-achou = YES.
                            LEAVE blk_emb.
                        END.
                    END.
                END.
                /*Se n∆o encontrou embarque cria um novo*/
                IF l-achou = NO THEN DO:

                    RUN pi-altera-parcela (INPUT tt-digita.numero-ordem, 
                                           INPUT tt-digita.parcela,
                                           INPUT tt-digita.dt-chegada).

                    RUN pi-cria-embarque (INPUT tt-digita.numero-ordem, 
                                          INPUT tt-digita.parcela,
                                          OUTPUT v-embarque).

                    IF RETURN-VALUE <> "OK" THEN
                        NEXT blk_dig.

                    RUN embarca-parcela (INPUT v-embarque,
                                         INPUT tt-digita.numero-ordem, 
                                         INPUT tt-digita.parcela).

                    IF RETURN-VALUE <> "OK" THEN
                        NEXT blk_dig.
                END.
            END.
            ELSE DO:
                ASSIGN tt-digita.acao = "Situaá∆o do pedido diferente de 'Prev'/'Ped'.".
            END.
        END.
        ELSE DO:
            ASSIGN tt-digita.acao = "N∆o alterado por ser mesma data.".
        END.
    END.
END.

PROCEDURE pi-situacao :

    {esp/imp/esimp000.i}
    
END PROCEDURE.

PROCEDURE desembarca-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.

    DEFINE VARIABLE h-bocx225 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-bocx404 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE r-rowid   AS ROWID       NO-UNDO.
    DEFINE VARIABLE l-integra-di AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    FIND FIRST ordens-embarque NO-LOCK
         WHERE ordens-embarque.numero-ordem = p-numero-ordem
           AND ordens-embarque.parcela      = p-parcela NO-ERROR.
    
    IF AVAIL ordens-embarque THEN DO:
        IF NOT VALID-HANDLE(h-bocx225) THEN
           RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
        
        IF NOT VALID-HANDLE(h-bocx404) THEN DO:
           RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.
           RUN openQueryStatic IN h-bocx404(INPUT "Main":U).
        END.

        ASSIGN r-rowid = ROWID(ordens-embarque).
        
        RUN validateDelete IN h-bocx225 (INPUT-OUTPUT r-rowid, 
                                         OUTPUT TABLE RowErrors).
    
        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                ASSIGN tt-digita.acao = tt-digita.acao + RowErrors.errorDescription + " ".
            END.

            RETURN "NOK".
        END. 
        ELSE DO:
            RUN verificaIntegraDI IN h-bocx404 (INPUT p-numero-ordem, 
                                                INPUT p-parcela, 
                                                OUTPUT l-integra-di).
    
            IF l-integra-di THEN DO:
                RUN desvinculaOrdem IN h-bocx404 (INPUT p-numero-ordem, 
                                                  INPUT p-parcela).
            END.
        END.

        DELETE PROCEDURE h-bocx225.
        DELETE PROCEDURE h-bocx404.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

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
           AND b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch NO-ERROR.

    ASSIGN p-dt-entrega = IF b-historico-embarque.dt-efetiva <> ? THEN b-historico-embarque.dt-efetiva ELSE b-historico-embarque.dt-ult-previsao.
END.

PROCEDURE embarca-parcela:
    DEFINE INPUT PARAM p-embarque     LIKE embarque-imp.embarque.
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.

    DEFINE VARIABLE i-moeda LIKE moeda.mo-codigo.

    EMPTY TEMP-TABLE RowErrors.

    IF NOT VALID-HANDLE(h-bocx225) THEN 
        RUN cxbo/bocx225.p persistent set h-bocx225.

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ordem-compra.cod-estabel
          AND embarque-imp.embarque    = p-embarque:

        /*Valida se embarque possui outra moeda*/
        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

        /*Moeda da parcela que ser† embarcada*/
        ASSIGN i-moeda = ordem-compra.mo-codigo.

        /*Là moedas ja ambarcadas*/
        FOR EACH ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
             AND ordens-embarque.embarque    = embarque-imp.embarque:
             FOR FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:

                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.cot-aprovada = YES NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    IF cotacao-item.mo-codigo <> i-moeda THEN DO:
                        ASSIGN tt-digita.acao = "Moeda " + STRING(i-moeda) + " diferente da moeda " + STRING(cotacao-item.mo-codigo) + " ja embarcada no embarque " + STRING(embarque-imp.embarque).
                        RETURN "NOK".
                    END.
                END.
             END.
        END.

        FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem
             WHERE prazo-compra.numero-ordem = p-numero-ordem
               AND prazo-compra.parcela      = p-parcela NO-ERROR.

        RUN setCreatehist IN h-bocx225.

        RUN validavinculacaoordens IN h-bocx225 (INPUT embarque-imp.embarque,    
                                                 INPUT embarque-imp.cod-estabel, 
                                                 INPUT p-numero-ordem,
                                                 INPUT p-parcela, 
                                                 OUTPUT TABLE RowErrors).

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
            /*Atualiza situaá∆o do precesso de importaá∆o, se foi alterada as quantidades das parcelas pode estar como embarcado total e dar erro no createOrdensEmbarquebyparcela*/
            RUN pi-atualizaSitProc IN h-bocx225 (INPUT ordem-compra.num-pedido).
            RUN createOrdensEmbarquebyparcela IN h-bocx225 (INPUT ROWID(embarque-imp),
                                                            INPUT p-numero-ordem,
                                                            INPUT p-parcela,
                                                            INPUT prazo-compra.quantidade,
                                                            OUTPUT TABLE RowErrors).
                
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                FOR EACH RowErrors:
                    ASSIGN tt-digita.acao = tt-digita.acao + RowErrors.errorDescription + " ".
                END.
                DELETE PROCEDURE h-bocx225.
                RETURN "NOK".
            END.
    
            
           IF (SEARCH("imp/im0045x.p") <> ? OR SEARCH("imp/im0045x.r") <> ?) THEN DO:
               IF AVAIL prazo-compra THEN 
                  RUN imp/im0045x.p (1, ROWID(prazo-compra)).

               IF RETURN-VALUE = "NOK":U THEN DO:
                   DELETE PROCEDURE h-bocx225.
                   RETURN "NOK".
               END.
           END.
        END.
        ELSE DO:
            FOR EACH RowErrors:
                ASSIGN tt-digita.acao = tt-digita.acao + RowErrors.errorDescription + " ".
            END.
            DELETE PROCEDURE h-bocx225.
            RETURN "NOK".
        END.

        ASSIGN tt-digita.acao = tt-digita.acao + "Vinculado ao Embarque " + STRING(p-embarque) + ". ".
    END.

    DELETE PROCEDURE h-bocx225.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-embarque:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE OUTPUT PARAM p-embarque     LIKE embarque-imp.embarque.

    DEFINE VARIABLE v-num-seq-emb  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-cod-seq-emb  AS CHARACTER   NO-UNDO.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

    FIND FIRST pedido-compr NO-LOCK 
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

    FIND FIRST processo-imp NO-LOCK
         WHERE processo-imp.cod-estabel = pedido-compr.cod-estabel
           AND processo-imp.num-pedido  = pedido-compr.num-pedido NO-ERROR.

    ASSIGN v-cod-seq-emb = "a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az;ba;bb;bc;bd;be;bf;bg;bh;bi;bj;bk;bl;bm;bn;bo;bp;bq;br;bs;bt;bu;bv;bw;bx;by;bz;ca;cb;cc;cd;ce;cf;cg;ch;ci;cj;ck;cl;cm;cn;co;cp;cq;cr;cs;ct;cu;cv;cw;cx;cy;cz;da;db;dc;dd;de;df;dg;dh;di;dj;dk;dl;dm;dn;do;dp;dq;dr;ds;dt;du;dv;dw;dx;dy;dz;"
           v-num-seq-emb = 0.
   
    /*Busca sequencia do embarque para definir a letra*/
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.cod-estabel = pedido-compr.cod-estabel 
         AND embarque-imp.embarque BEGINS STRING(pedido-compr.num-pedido):
        IF embarque-imp.embarque <> STRING(pedido-compr.num-pedido) THEN DO:
            IF v-num-seq-emb < LOOKUP(SUBSTRING(embarque-imp.embarque,LENGTH(STRING(pedido-compr.num-pedido)) + 1,LENGTH(embarque-imp.embarque) - LENGTH(STRING(pedido-compr.num-pedido))),v-cod-seq-emb,";") + 1 THEN
                ASSIGN v-num-seq-emb  = LOOKUP(SUBSTRING(embarque-imp.embarque,LENGTH(STRING(pedido-compr.num-pedido)) + 1,LENGTH(embarque-imp.embarque) - LENGTH(STRING(pedido-compr.num-pedido))),v-cod-seq-emb,";") + 1.
        END.
        ELSE 
            ASSIGN v-num-seq-emb = 1.
    END.

    IF v-num-seq-emb > 0 THEN
        ASSIGN p-embarque = STRING(pedido-compr.num-pedido) + ENTRY(v-num-seq-emb,v-cod-seq-emb,";").
    ELSE 
        ASSIGN p-embarque = STRING(pedido-compr.num-pedido).

    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem  
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente  
           AND cotacao-item.it-codigo    = ordem-compra.it-codigo
           AND cotacao-item.cot-aprov    = YES NO-ERROR.

    CREATE embarque-imp.
    ASSIGN embarque-imp.cod-estabel       = pedido-compr.cod-estabel
           embarque-imp.embarque          = p-embarque
           embarque-imp.situacao          = 1
           embarque-imp.cod-transportador = processo-imp.cod-transportador
           embarque-imp.cod-via-transp    = pedido-compr.via-transp
           embarque-imp.narrativa         = pedido-compr.comentarios
           embarque-imp.cod-incoterm      = SUBSTR(cotacao-item.char-1,21,3)
           embarque-imp.contabiliza       = NO.

    ASSIGN tt-digita.acao = tt-digita.acao + "Criado novo Embarque " + STRING(p-embarque) + ". ".

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-altera-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.
    DEFINE INPUT PARAM p-data-entrega LIKE prazo-compra.data-entrega.

    /*Busca a ordem das parcelas*/
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.
    
    FIND FIRST prazo-compra EXCLUSIVE-LOCK USE-INDEX ordem
         WHERE prazo-compra.numero-ordem = p-numero-ordem
           AND prazo-compra.parcela      = p-parcela NO-ERROR.

    IF  AVAIL prazo-compra 
    AND prazo-compra.data-entrega <> p-data-entrega THEN DO:

        ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
               prazo-compra.data-entrega     = p-data-entrega.
        
        CREATE alt-ped.
        ASSIGN alt-ped.num-pedido   = ordem-compra.num-pedido
               alt-ped.numero-ordem = ordem-compra.numero-ordem
               alt-ped.parcela      = prazo-compra.parcela
               alt-ped.data         = TODAY
               alt-ped.hora         = STRING(time,"hh:mm:ss")
               alt-ped.usuario      = c-seg-usuario
               alt-ped.data-entrega = prazo-compra.data-entrega
               alt-ped.observacao   = c-seg-usuario + ": " + "Alterado data de entrega esimp018."
               alt-ped.quantidade   = prazo-compra.quantidade
               alt-ped.cod-cond-pag = ?. 
    END.

    FIND CURRENT prazo-compra NO-LOCK NO-ERROR.

    RETURN "OK".

END PROCEDURE.
