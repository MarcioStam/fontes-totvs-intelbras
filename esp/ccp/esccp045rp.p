{esp/es0018.i}
DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura
    FIELD num-pedido LIKE pedido-compr.num-pedido
    FIELD lido       AS LOG.

DEFINE VARIABLE i-seq          AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE qt-tot-estru  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vl-med        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-indice     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-cotacao    AS DECIMAL     NO-UNDO.

DEFINE STREAM str-excel.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)"
    FIELD usuario           AS CHAR FORMAT "x(12)"
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD classifica        AS INTEGER
    FIELD desc-classifica   AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf        AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf     AS LOG
    FIELD cod-estabel-ini   LIKE embarque-imp.cod-estabel
    FIELD cod-estabel-fim   LIKE embarque-imp.cod-estabel
    FIELD embarque-ini      LIKE embarque-imp.embarque
    FIELD embarque-fim      LIKE embarque-imp.embarque
    FIELD cod-emitente-ini  LIKE pedido-compr.cod-emitente
    FIELD cod-emitente-fim  LIKE pedido-compr.cod-emitente
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD it-codigo-ini AS CHAR
    FIELD it-codigo-fim AS CHAR
    .

DEFINE TEMP-TABLE tt-conferencia NO-UNDO
    FIELD cod-estabel     LIKE embarque-imp.cod-estabel
    FIELD embarque        LIKE embarque-imp.embarque
    FIELD num-pedido      LIKE pedido-compr.num-pedido
    FIELD numero-ordem    LIKE ordem-compra.numero-ordem
    FIELD qt-solic        LIKE ordem-compra.qt-solic
    FIELD it-codigo       LIKE ordem-compra.it-codigo
    FIELD cod-produto-ckd LIKE int-pedido-compr.cod-produto-ckd
    FIELD qtd-pedido-ckd  LIKE int-pedido-compr.qtd-pedido-ckd
    INDEX ch-emb IS PRIMARY cod-estabel embarque
    .

DEFINE BUFFER b-tt-conferencia FOR tt-conferencia.
DEFINE BUFFER b-item           FOR ITEM.
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESCCP045_" + STRING(TIME) + ".csv":U.

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


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.cod-estabel >= tt-param.cod-estabel-ini
         AND embarque-imp.cod-estabel <= tt-param.cod-estabel-fim
         AND embarque-imp.embarque    >= tt-param.embarque-ini
         AND embarque-imp.embarque    <= tt-param.embarque-fim:

        FOR EACH ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
             AND ordens-embarque.embarque    = embarque-imp.embarque:

            /*Primeiro ponto de controle do embarque*/
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                   AND historico-embarque.embarque    = embarque-imp.embarque NO-ERROR.
    
            /*Itinerario do embarque*/
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

            /*Ponto de Chegada*/ 
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                   AND historico-embarque.embarque      = embarque-imp.embarque
                   AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                   AND historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.

            IF AVAIL historico-embarque THEN DO:
                IF historico-embarque.dt-efetiva <> ? THEN DO:
                    IF tt-param.data-ini > historico-embarque.dt-efetiva 
                    OR tt-param.data-fim < historico-embarque.dt-efetiva  THEN
                        NEXT.
                END.
                ELSE DO:
                    IF tt-param.data-ini > historico-embarque.dt-prev
                    OR tt-param.data-fim < historico-embarque.dt-prev THEN
                        NEXT.
                END.
            END.

            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:

                IF tt-param.cod-emitente-ini > ordem-compra.cod-emitente
                OR tt-param.cod-emitente-fim < ordem-compra.cod-emitente THEN
                    NEXT.

                FIND FIRST int-pedido-compr NO-LOCK
                     WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

                IF  AVAIL int-pedido-compr
                AND int-pedido-compr.log-ckd 
                AND int-pedido-compr.cod-produto-ckd <> "" THEN DO:

                    IF tt-param.it-codigo-ini > int-pedido-compr.cod-produto-ckd
                    OR tt-param.it-codigo-fim < int-pedido-compr.cod-produto-ckd THEN
                        NEXT.

                    FIND FIRST tt-conferencia
                         WHERE tt-conferencia.num-pedido = ordem-compra.num-pedido 
                           AND tt-conferencia.it-codigo  = ordem-compra.it-codigo NO-ERROR.

                    IF NOT AVAIL tt-conferencia THEN DO:
                        CREATE tt-conferencia.
                        ASSIGN tt-conferencia.cod-estabel     = embarque-imp.cod-estabel
                               tt-conferencia.embarque        = embarque-imp.embarque 
                               tt-conferencia.num-pedido      = ordem-compra.num-pedido
                               tt-conferencia.numero-ordem    = ordem-compra.numero-ordem
                               tt-conferencia.qt-solic        = ordem-compra.qt-solic
                               tt-conferencia.it-codigo       = ordem-compra.it-codigo
                               tt-conferencia.cod-produto-ckd = int-pedido-compr.cod-produto-ckd
                               tt-conferencia.qtd-pedido-ckd  = int-pedido-compr.qtd-pedido-ckd.
                    END.
                    ELSE DO:
                        ASSIGN tt-conferencia.qt-solic = tt-conferencia.qt-solic + ordem-compra.qt-solic.
                    END.
                END.
            END.
        END.
    END.

    FOR EACH tt-conferencia
        , FIRST item-uni-estab NO-LOCK                                 
           WHERE item-uni-estab.cod-estabel     = tt-conferencia.cod-estabel
             AND item-uni-estab.it-codigo       = tt-conferencia.it-codigo 
             AND item-uni-estab.tp-desp-padrao = 2 /* Importa‡Æo */
        BREAK BY tt-conferencia.cod-estabel
              BY tt-conferencia.embarque:
        /*
        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = tt-conferencia.cod-estabel
               AND item-uni-estab.it-codigo   = tt-conferencia.it-codigo NO-ERROR.

        IF  AVAIL item-uni-estab AND
                  item-uni-estab.tp-desp-padrao <> 2 THEN 
            NEXT.
        */
        IF FIRST-OF (tt-conferencia.embarque) THEN DO:

            PUT STREAM str-excel UNFORMATTED "Estabelecimento: " + ";" + tt-conferencia.cod-estabel SKIP.
            PUT STREAM str-excel UNFORMATTED "Embarque: " + ";" + tt-conferencia.embarque SKIP.
            PUT STREAM str-excel UNFORMATTED "Produto;Quantidade;PO" SKIP.

            EMPTY TEMP-TABLE tt-estrutura.
            FOR EACH b-tt-conferencia
               WHERE b-tt-conferencia.cod-estabel = tt-conferencia.cod-estabel
                 AND b-tt-conferencia.embarque    = tt-conferencia.embarque
                BREAK BY b-tt-conferencia.num-pedido:
            
                IF FIRST-OF (b-tt-conferencia.num-pedido) THEN DO:
                    RUN pi-carrega-estrutura (INPUT b-tt-conferencia.cod-produto-ckd,
                                              INPUT b-tt-conferencia.num-pedido).
                    PUT STREAM str-excel UNFORMATTED b-tt-conferencia.cod-produto-ckd + ";" STRING(b-tt-conferencia.qtd-pedido-ckd) + ";" + STRING(b-tt-conferencia.num-pedido) SKIP.
                END.
            END.

            PUT SKIP.
            PUT STREAM str-excel UNFORMATTED "Item;Descri‡Æo;Qtde Embarque;Qtde total Estrutura;Varia‡Æo;Pedido;Qtd CKD;C¢digo do Produto;Descri‡Æo do produto;R$ M‚dio;R$ Varia‡Æo" SKIP.
        END.

        ASSIGN qt-tot-estru = 0.
        FOR EACH tt-estrutura
             WHERE tt-estrutura.es-codigo  = tt-conferencia.it-codigo
               AND tt-estrutura.num-pedido = tt-conferencia.num-pedido:

            ASSIGN qt-tot-estru = qt-tot-estru + IF AVAIL tt-estrutura THEN tt-conferencia.qtd-pedido-ckd * tt-estrutura.quant-usada ELSE 0
                   tt-estrutura.lido = YES.
        END.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-conferencia.it-codigo NO-ERROR.

        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = tt-conferencia.cod-produto-ckd NO-ERROR.

        FIND FIRST item-estab NO-LOCK
             WHERE item-estab.cod-estabel = tt-conferencia.cod-estabel
               AND item-estab.it-codigo   = tt-conferencia.it-codigo NO-ERROR.

        ASSIGN vl-med = 0.
        IF AVAIL item-estab THEN
            ASSIGN vl-med = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].

        /**Busca do pedido**/
        IF vl-med = 0 THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = tt-conferencia.num-pedido NO-ERROR.

            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = tt-conferencia.numero-ordem NO-ERROR.

            FIND FIRST prazo-compra NO-LOCK
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                   AND cotacao-item.it-codigo    = tt-conferencia.it-codigo
                   AND cotacao-item.cot-aprovada = YES NO-ERROR.

            RUN calcula-indice (INPUT  prazo-compra.numero-ordem,
                                INPUT  prazo-compra.parcela,     
                                INPUT  ordem-compra.it-codigo,   
                                INPUT  ordem-compra.cod-emitente,
                                OUTPUT de-indice).

            ASSIGN de-cotacao = 1.

            IF cotacao-item.mo-codigo <> 0 THEN DO:
                FIND FIRST cotacao NO-LOCK
                     WHERE cotacao.mo-codigo   = cotacao-item.mo-codigo
                       AND cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99") NO-ERROR.
                
                    ASSIGN de-cotacao = cotacao.cotacao[int(day(TODAY))].
                        
            END.

            ASSIGN vl-med = (cotacao-item.preco-fornec * de-indice) * de-cotacao. 
        END.
        
    
        PUT STREAM str-excel UNFORMATTED tt-conferencia.it-codigo + ";" +
                                         ITEM.desc-item + ";" +
                                         STRING(tt-conferencia.qt-solic) + ";" +
                                         STRING(qt-tot-estru) + ";" +
                                         STRING(tt-conferencia.qt-solic - (qt-tot-estru)) + ";" +
                                         STRING(tt-conferencia.num-pedido) + ";" +
                                         STRING(tt-conferencia.qtd-pedido-ckd) + ";" +
                                         STRING(tt-conferencia.cod-produto-ckd) + ";" +
                                         b-item.desc-item + ";" +
                                         STRING(vl-med) + ";" +
                                         STRING((tt-conferencia.qt-solic - (qt-tot-estru)) * (vl-med)) SKIP.
    END.

    /*Est  na estrutura mas n no pedido*/
    FOR EACH tt-estrutura
       WHERE NOT tt-estrutura.lido:

        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = tt-estrutura.num-pedido NO-ERROR.

        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = int-pedido-compr.cod-produto-ckd NO-ERROR.

        FIND FIRST pedido-compr NO-LOCK
             WHERE pedido-compr.num-pedido = tt-estrutura.num-pedido NO-ERROR.

        FIND FIRST item-estab NO-LOCK
             WHERE item-estab.cod-estabel = pedido-compr.cod-estabel
               AND item-estab.it-codigo   = tt-estrutura.es-codigo NO-ERROR.

        ASSIGN vl-med = 0.
        IF AVAIL item-estab THEN
            ASSIGN vl-med = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = pedido-compr.cod-estabel
               AND item-uni-estab.it-codigo   = tt-estrutura.es-codigo NO-ERROR.

        IF  AVAIL item-uni-estab AND
                  item-uni-estab.tp-desp-padrao <> 2 THEN /* Importa‡Æo */
            NEXT.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-estrutura.es-codigo NO-ERROR.

        IF ITEM.compr-fabric <> 1 THEN
            NEXT.

        ASSIGN qt-tot-estru = IF AVAIL int-pedido-compr THEN int-pedido-compr.qtd-pedido-ckd * tt-estrutura.quant-usada ELSE tt-estrutura.quant-usada.

        PUT STREAM str-excel UNFORMATTED tt-estrutura.es-codigo + ";" +
                                         ITEM.desc-item + ";" +
                                         "0" + ";" +
                                         STRING(qt-tot-estru) + ";" +
                                         STRING(0 - (qt-tot-estru)) + ";" +
                                         STRING(int-pedido-compr.num-pedido) + ";" +
                                         STRING(int-pedido-compr.qtd-pedido-ckd) + ";" +
                                         STRING(int-pedido-compr.cod-produto-ckd) + ";" +
                                         b-item.desc-item + ";" +
                                         STRING(vl-med) + ";" +
                                         STRING((0 - (qt-tot-estru)) * (vl-med)) SKIP.

    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.


PROCEDURE pi-carrega-estrutura:
    DEF INPUT PARAM p-item-pai   LIKE estrutura.it-codigo     NO-UNDO.
    DEF INPUT PARAM p-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    for each estrutura no-lock
       where estrutura.it-codigo    = p-item-pai
         and estrutura.data-inicio <= today
         and estrutura.data-termino > today:

        run pi-acompanhar  in h-acomp (input "Item " + estrutura.es-codigo).

        FIND ITEM NO-LOCK
            WHERE item.it-codigo = estrutura.es-codigo NO-ERROR.

        IF NOT AVAIL ITEM THEN 
            NEXT.

        FIND FIRST tt-estrutura
             WHERE tt-estrutura.it-codigo  = estrutura.it-codigo
               AND tt-estrutura.es-codigo  = estrutura.es-codigo
               AND tt-estrutura.num-pedido = p-num-pedido NO-ERROR.

        IF NOT AVAIL tt-estrutura 
        THEN DO:
            CREATE tt-estrutura.
            ASSIGN tt-estrutura.it-codigo   = estrutura.it-codigo
                   tt-estrutura.es-codigo   = estrutura.es-codigo
                   tt-estrutura.qtd-compon  = estrutura.qtd-compon
                   i-seq                    = i-seq + 10
                   tt-estrutura.sequencia   = i-seq
                   tt-estrutura.num-pedido  = p-num-pedido
                   tt-estrutura.quant-usada = 0.
        END.

        ASSIGN tt-estrutura.quant-usada = tt-estrutura.quant-usada + estrutura.quant-usada  /*+ (estrutura.quant-usada * p-qtde)*/.

        RUN pi-carrega-estrutura (INPUT estrutura.es-codigo, p-num-pedido /*, INPUT p-qtde*/).
    END.

END PROCEDURE.

PROCEDURE calcula-indice:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE INPUT  PARAM p-it-codigo    LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-cod-emitente LIKE ordem-compra.cod-emitente.
    DEFINE OUTPUT PARAM p-indice       AS DEC.

    DEFINE BUFFER b-prazo-compra FOR prazo-compra.

    FIND FIRST b-prazo-compra NO-LOCK USE-INDEX ordem
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    ASSIGN p-indice = 1.

    IF AVAILABLE ITEM THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = ITEM.it-codigo
               AND item-fornec.cod-emitente = p-cod-emitente NO-ERROR.

        IF  (ITEM.tipo-contr = 4 
        AND NOT AVAILABLE item-fornec 
        OR  ITEM.it-codigo = "":U) THEN DO:

            IF  AVAILABLE cotacao-item            
            AND cotacao-item.un <> b-prazo-compra.un THEN DO:

                FIND FIRST tab-conv-un NO-LOCK
                     WHERE tab-conv-un.un           = b-prazo-compra.un
                       AND tab-conv-un.unid-med-for = cotacao-item.un NO-ERROR.

                IF AVAILABLE tab-conv-un THEN
                    ASSIGN p-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
            END.
        END.
        ELSE IF AVAILABLE item-fornec THEN
            ASSIGN p-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
    END.
END PROCEDURE.
