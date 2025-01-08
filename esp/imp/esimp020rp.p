{include/i-prgvrs.i esimp020rp 2.00.00.001}
{method/dbotterr.i}
{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.

DEFINE STREAM str-excel.
DEFINE BUFFER empresa FOR emscad.empresa.

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)":U
    field usuario            as char format "x(12)":U
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)":U
    field modelo             AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf      as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD c-estab-ini        AS CHAR
    FIELD c-estab-fim        AS CHAR
    FIELD c-embarque-ini     AS CHAR
    FIELD c-embarque-fim     AS CHAR
    FIELD i-despachante-ini  AS INT
    FIELD i-despachante-fim  AS INT                                  
    FIELD dt-prev-emb-ini    AS DATE
    FIELD dt-prev-emb-fim    AS DATE
    FIELD cb-status          AS INT    
    FIELD tg-prev            AS LOGICAL
    FIELD tg-embarq          AS LOGICAL                                 
    FIELD tg-desp            AS LOGICAL
    FIELD tg-nf              AS LOGICAL
    FIELD tg-inst            AS LOGICAL
    FIELD tg-manu            AS LOGICAL
    FIELD tg-di              AS LOGICAL
    FIELD tg-agt             AS LOGICAL
    FIELD tg-rodoviario      AS LOGICAL
    FIELD tg-aeroviario      AS LOGICAL
    FIELD tg-maritimo        AS LOGICAL
    FIELD tg-ferroviario     AS LOGICAL
    FIELD tg-rodoferroviario AS LOGICAL
    FIELD tg-rodofluvial     AS LOGICAL
    FIELD tg-rodoaeroviario  AS LOGICAL
    FIELD tg-outros          AS LOGICAL.

DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO
    LIKE embarque-imp
    FIELD status-embarque     AS CHAR
    FIELD situacao-esp        AS INT
    FIELD situacao-esp-desc   AS CHAR
    FIELD desc-via-transp     AS CHAR
    FIELD cod-fornecedor      AS INT
    FIELD nome-fornecedor     AS CHAR
    FIELD nome-transp         AS CHAR
    FIELD nome-despachante    AS CHAR
    FIELD responsavel         AS CHAR
    FIELD nome-responsavel    AS CHAR
    FIELD dt-ult-pto-contr    AS DATE
    FIELD des-ult-pto-contr   AS CHAR
    FIELD dt-embarque         AS DATE
    FIELD dt-prev-embarque    AS DATE
    FIELD dt-chegada1         AS DATE
    FIELD dt-prev-chegada1    AS DATE
    FIELD dt-chegada2         AS DATE
    FIELD dt-prev-chegada2    AS DATE
    FIELD dt-desembarque      AS DATE
    FIELD dt-prev-desembarque AS DATE
    FIELD des-itinerario      AS CHAR
    FIELD id-meio-transp-ult  LIKE historico-embarque.id-meio-transp
    FIELD valor-embarque      AS DEC
    FIELD mo-descricao        AS CHAR
    FIELD cod-cond-pag        AS INT
    FIELD des-cond-pag        AS CHAR
    FIELD tipo-conteiner      AS INT
    FIELD tipo-conteiner-desc AS CHAR
    FIELD qt-conteiner        AS INT
    FIELD qt-conteiner2       AS INT
    FIELD possuiCIpagto       AS LOG
    FIELD CIrecebida          AS LOG    
    FIELD dt-emis-nf          AS DATE.
   
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}
{esp/imp/esimp000.i1} /*tt-emb*/

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esimp020_" + STRING(TIME) + ".csv":U.

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



RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Integrando ...").

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

RUN pi-executa.

PUT STREAM str-excel UNFORMATTED "Situa‡Æo;Embarque;Estab;Via Transporte(Modal);C¢d Fornec;Nome;C¢d Transportadora;Nome Abreviado;Cod Despachante;Nome;Respons vel;Nome;Data (Ultimo PC Efetivado);Ponto de Controle;"
                                 "PrevisÆo Embarque;Data de Embarque;PrevisÆo Chegada;Data de Chegada;PrevisÆo Chegada (Entrada);Data de Chegada (Entrada;PrevisÆo Data de Registro;Data de Registro;Itiner rio;"
                                 "Ve¡culo Transporte;Valor;Moeda;Condi‡Æo de Pagamento;Tipo Container;Quantidade Container;Master;House;Status;Possui CI Pgto;CI Recebida;DI Siscomex;Incoterm;Data EmissÆo de NF" SKIP.

FOR EACH tt-embarque-imp.

    PUT STREAM str-excel UNFORMATTED
        tt-embarque-imp.situacao-esp-desc ";"
        tt-embarque-imp.embarque ";"
        tt-embarque-imp.cod-estabel ";"
        tt-embarque-imp.desc-via-transp ";"
        tt-embarque-imp.cod-fornecedor ";"
        tt-embarque-imp.nome-fornecedor ";"
        tt-embarque-imp.cod-transportador ";"
        tt-embarque-imp.nome-transp ";"
        tt-embarque-imp.cod-despachante ";"
        tt-embarque-imp.nome-despachante ";"
        tt-embarque-imp.responsavel ";"
        tt-embarque-imp.nome-responsavel ";"
        IF tt-embarque-imp.dt-ult-pto-contr = ? THEN "" ELSE string(tt-embarque-imp.dt-ult-pto-contr) ";"
        IF tt-embarque-imp.des-ult-pto-contr = ? THEN "" ELSE STRING(tt-embarque-imp.des-ult-pto-contr) ";"
        IF tt-embarque-imp.dt-prev-embarque = ? THEN "" ELSE string(tt-embarque-imp.dt-prev-embarque) ";"
        IF tt-embarque-imp.dt-embarque = ? THEN "" ELSE string(tt-embarque-imp.dt-embarque) ";"
        IF tt-embarque-imp.dt-prev-chegada1 = ? THEN "" ELSE string(tt-embarque-imp.dt-prev-chegada1) ";"
        IF tt-embarque-imp.dt-chegada1 = ? THEN "" ELSE string(tt-embarque-imp.dt-chegada1) ";"
        IF tt-embarque-imp.dt-prev-chegada2 = ? THEN "" ELSE string(tt-embarque-imp.dt-prev-chegada2) ";"
        IF tt-embarque-imp.dt-chegada2 = ? THEN "" ELSE string(tt-embarque-imp.dt-chegada2) ";"
        IF tt-embarque-imp.dt-prev-desembarque = ? THEN "" ELSE string(tt-embarque-imp.dt-prev-desembarque) ";"
        IF tt-embarque-imp.dt-desembarque = ? THEN "" ELSE string(tt-embarque-imp.dt-desembarque) ";"
        tt-embarque-imp.des-itinerario ";"
        tt-embarque-imp.id-meio-transp-ult ";"
        tt-embarque-imp.valor-embarque ";"
        tt-embarque-imp.mo-descricao ";"
        tt-embarque-imp.des-cond-pag ";"
        tt-embarque-imp.tipo-conteiner-desc ";"
        IF tt-embarque-imp.qt-conteiner = ? THEN "0" ELSE string(tt-embarque-imp.qt-conteiner) ";"
        tt-embarque-imp.cod-conhecto-master ";"
        tt-embarque-imp.cod-conhecto-house ";"
        tt-embarque-imp.status-embarque ";"
        tt-embarque-imp.possuiCIpagto FORMAT "Sim/NÆo" ";"
        tt-embarque-imp.CIRecebida FORMAT "Sim/NÆo" ";"
        tt-embarque-imp.declaracao-import ";"
        tt-embarque-imp.cod-incoterm ";"
        IF tt-embarque-imp.dt-emis-nf = ? THEN "" ELSE string(tt-embarque-imp.dt-emis-nf)
    SKIP.
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

RETURN "OK".

PROCEDURE pi-executa:

    DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
    DEF VAR h-bocx225            AS HANDLE      NO-UNDO.
    DEF VAR c-return-ordens-emb  AS CHARACTER   NO-UNDO.
    DEF VAR h-boin274            AS HANDLE      NO-UNDO.
    DEF VAR c-return-ordem-compr AS CHAR NO-UNDO.
    DEF VAR i-cod-emitente       LIKE ordem-compra.cod-emitente NO-UNDO.
    DEF VAR c-id-meio-transp     AS CHARACTER   NO-UNDO.
    DEF VAR h-bocx220            AS HANDLE      NO-UNDO.
    DEF VAR de-valor-embarque    AS DECIMAL     NO-UNDO.
    DEF VAR i-mo-codigo          AS INTEGER     NO-UNDO.
    DEF VAR de-unit              AS DECIMAL     NO-UNDO.
    DEF VAR v-cod-cond-pag       AS INTEGER     NO-UNDO.
        
    FOR EACH embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel     >= tt-param.c-estab-ini 
          AND embarque-imp.cod-estabel     <= tt-param.c-estab-fim
          AND embarque-imp.embarque        >= tt-param.c-embarque-ini
          AND embarque-imp.embarque        <= tt-param.c-embarque-fim
          AND embarque-imp.cod-despachante >= tt-param.i-despachante-ini
          AND embarque-imp.cod-despachante <= tt-param.i-despachante-fim.
    
        /* situacao */
        {esp/imp/esimp000.i}

        IF NOT AVAIL tt-emb THEN NEXT.

        IF NOT tt-param.tg-prev   AND tt-emb.situacao = 1 THEN NEXT.

        IF NOT tt-param.tg-embarq AND tt-emb.situacao = 2 THEN NEXT.

        IF NOT tt-param.tg-desp   AND tt-emb.situacao = 3 THEN NEXT.

        IF NOT tt-param.tg-nf     AND tt-emb.situacao = 4 THEN NEXT.

        IF NOT tt-param.tg-inst   AND tt-emb.situacao = 96 THEN NEXT.

        IF NOT tt-param.tg-manu   AND tt-emb.situacao = 97 THEN NEXT.

        IF NOT tt-param.tg-di     AND tt-emb.situacao = 98 THEN NEXT.

        IF NOT tt-param.tg-agt    AND tt-emb.situacao = 99 THEN NEXT.

        /* Status */
        IF tt-param.cb-status = 1 AND embarque-imp.situacao = 2 THEN NEXT.

        IF tt-param.cb-status = 2 AND embarque-imp.situacao = 1 THEN NEXT.

        /* Via Transp */
        IF NOT tt-param.tg-rodoviario AND embarque-imp.cod-via-transp = 1 THEN NEXT.

        IF NOT tt-param.tg-aeroviario AND embarque-imp.cod-via-transp = 2 THEN NEXT.

        IF NOT tt-param.tg-maritimo AND embarque-imp.cod-via-transp = 3 THEN NEXT.

        IF NOT tt-param.tg-ferroviario AND embarque-imp.cod-via-transp = 4 THEN NEXT.

        IF NOT tt-param.tg-rodoferroviario AND embarque-imp.cod-via-transp = 5 THEN NEXT.

        IF NOT tt-param.tg-rodofluvial AND embarque-imp.cod-via-transp = 6 THEN NEXT.

        IF NOT tt-param.tg-rodoaeroviario AND embarque-imp.cod-via-transp = 7 THEN NEXT.

        IF NOT tt-param.tg-outros AND embarque-imp.cod-via-transp = 8 THEN NEXT.        

        /* Filtrar da previsao de embarque */
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-ERROR.        
        IF AVAIL historico-embarque THEN DO:
            IF historico-embarque.dt-ult-prev >= tt-param.dt-prev-emb-ini AND
               historico-embarque.dt-ult-prev <= tt-param.dt-prev-emb-fim THEN.
            ELSE NEXT.
        END.        
        ELSE NEXT.

        RUN pi-acompanhar in h-acomp (input "Processando Embarque: " + embarque-imp.embarque).
        
        CREATE tt-embarque-imp.
        BUFFER-COPY embarque-imp TO tt-embarque-imp.

        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF AVAIL ext-embarque-imp THEN DO:            
            FIND FIRST historico-embarque OF embarque-imp NO-LOCK
                 WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-emissao-nf NO-ERROR.        
            IF AVAIL historico-embarque THEN
                ASSIGN tt-embarque-imp.dt-emis-nf      = historico-embarque.dt-efetiva.
        END.
            
        ASSIGN tt-embarque-imp.status-embarque = {cxinc/i01cx220.i 4 embarque-imp.situacao}.
               tt-embarque-imp.situacao-esp    = tt-emb.situacao.

        CASE tt-embarque-imp.situacao-esp:
            WHEN 1 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Prev".
            WHEN 2 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Embarq".
            WHEN 3 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Desp".            
            WHEN 4 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "NF".
            WHEN 96 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Inst".                    
            WHEN 97 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Manuten‡Æo".            
            WHEN 98 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "DI".            
            WHEN 99 THEN
                ASSIGN tt-embarque-imp.situacao-esp-desc = "Agt".            
        END CASE.
                    
        ASSIGN tt-embarque-imp.desc-via-transp = {adinc/i01ad268.i 4 embarque-imp.cod-via-transp}.

        ASSIGN i-cod-emitente = 0.

        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

        RUN findEmbarque IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                       INPUT tt-embarque-imp.embarque,
                                       OUTPUT c-return-ordens-emb).

        IF c-return-ordens-emb = "" THEN DO:

            RUN getintfield IN h-bocx225 ("numero-ordem", OUTPUT i-numero-ordem).
            
            IF NOT VALID-HANDLE(h-boin274) THEN
                RUN inbo/boin274.p PERSISTENT SET h-boin274.

            RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                        OUTPUT c-return-ordem-compr).

            IF c-return-ordem-compr = "" THEN
                RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).

            IF VALID-HANDLE(h-boin274) THEN DO:
                DELETE PROCEDURE h-boin274.
                ASSIGN h-boin274 = ?.
            END.                
            
        END.

        IF VALID-HANDLE(h-bocx225) THEN DO:
           DELETE PROCEDURE h-bocx225.
           ASSIGN h-bocx225 = ?.
        END.     

        ASSIGN tt-embarque-imp.cod-fornecedor = i-cod-emitente.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN tt-embarque-imp.nome-fornecedor = emitente.nome-abrev.
        ELSE
            ASSIGN tt-embarque-imp.nome-fornecedor = "".
        
        FIND FIRST transporte NO-LOCK
             WHERE transporte.cod-transp = embarque-imp.cod-transportador NO-ERROR.
        IF AVAIL transporte THEN
            ASSIGN tt-embarque-imp.nome-transp = transporte.nome-abrev.
        ELSE
            ASSIGN tt-embarque-imp.nome-transp = "".

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = embarque-imp.cod-despachante NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN tt-embarque-imp.nome-despachante = emitente.nome-abrev.
        ELSE
            ASSIGN tt-embarque-imp.nome-despachante = "".

        FIND FIRST ordens-embarque OF embarque-imp NO-LOCK NO-ERROR.

        FIND FIRST ordem-compra OF ordens-embarque NO-LOCK NO-ERROR.

        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF AVAIL ext-embarque-imp AND ext-embarque-imp.MatriculaResponsavel <> "" THEN
            ASSIGN tt-embarque-imp.responsavel = ext-embarque-imp.MatriculaResponsavel.
        ELSE
            ASSIGN tt-embarque-imp.responsavel = IF AVAIL ordem-compra THEN ordem-compra.cod-comprado ELSE ?.        
        
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = tt-embarque-imp.responsavel NO-ERROR.
        IF AVAIL usuar_mestre THEN
            ASSIGN tt-embarque-imp.nome-responsavel = usuar_mestre.nom_usuario.

        ASSIGN tt-embarque-imp.dt-ult-pto-contr  = tt-emb.dt-ult-pto-contr
               tt-embarque-imp.des-ult-pto-contr = tt-emb.des-ult-pto-contr.
                    
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-ERROR.        
        IF AVAIL historico-embarque THEN
            ASSIGN tt-embarque-imp.dt-embarque      = historico-embarque.dt-efetiva
                   tt-embarque-imp.dt-prev-embarque = historico-embarque.dt-ult-prev.        
        
        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF AVAIL ext-embarque-imp  THEN DO:

            ASSIGN tt-embarque-imp.tipo-conteiner = ext-embarque-imp.conteiner
                   tt-embarque-imp.qt-conteiner   = ext-embarque-imp.qtd-conteiner
                   tt-embarque-imp.qt-conteiner2  = ext-embarque-imp.qtd2-conteiner.

            ASSIGN tt-embarque-imp.tipo-conteiner-desc = IF tt-embarque-imp.tipo-conteiner > 0 AND tt-embarque-imp.tipo-conteiner <= 6 THEN
                                                            ENTRY(tt-embarque-imp.tipo-conteiner,"Container de 20 pes,Container de 40 pes,Container de 40 e 20 pes,Container NOR 20 pes,Container NOR 40 pes,Container do tipo LCL")
                                                         ELSE "".

            FIND FIRST historico-embarque OF embarque-imp NO-LOCK
                 WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada1 NO-ERROR.        
            IF AVAIL historico-embarque THEN DO:
                ASSIGN tt-embarque-imp.dt-chegada1      = historico-embarque.dt-efetiva
                       tt-embarque-imp.dt-prev-chegada1 = historico-embarque.dt-ult-prev.
            END.

            FIND FIRST historico-embarque OF embarque-imp NO-LOCK
                 WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada2 NO-ERROR.        
            IF AVAIL historico-embarque THEN DO:
                ASSIGN tt-embarque-imp.dt-chegada2      = historico-embarque.dt-efetiva
                       tt-embarque-imp.dt-prev-chegada2 = historico-embarque.dt-ult-prev.
            END.
        END.

        /* Ponto Nacionaliza‡Æo Registro DI */
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-ERROR.        
        IF AVAIL historico-embarque THEN
            ASSIGN tt-embarque-imp.dt-desembarque      = historico-embarque.dt-efetiva
                   tt-embarque-imp.dt-prev-desembarque = historico-embarque.dt-ult-prev.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
               AND historico-embarque.embarque    = embarque-imp.embarque NO-ERROR.
        IF AVAIL historico-embarque THEN DO:
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
            IF AVAIL itinerario THEN
                ASSIGN tt-embarque-imp.des-itinerario = itinerario.descricao.
        END.

        ASSIGN c-id-meio-transp = embarque-imp.id-meio-transp.
        FOR LAST historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
             AND historico-embarque.embarque    = embarque-imp.embarque
             AND historico-embarque.dt-efetiva <> ?
           BREAK BY historico-embarque.dt-efetiva:

            ASSIGN c-id-meio-transp = historico-embarque.id-meio-transp.
        END.
        ASSIGN tt-embarque-imp.id-meio-transp-ult = c-id-meio-transp.

        IF NOT VALID-HANDLE(h-bocx220) THEN
            RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

        RUN retornaMoedaValor IN h-bocx220 (INPUT  embarque-imp.embarque,
                                            INPUT  embarque-imp.cod-estabel,
                                            OUTPUT de-valor-embarque,
                                            OUTPUT i-mo-codigo).

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = i-mo-codigo NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN tt-embarque-imp.mo-descricao = moeda.descricao.

        /*Desconta valor das parcelas FOC*/
        FOR EACH  ordens-embarque OF embarque-imp NO-LOCK,
            FIRST ordem-compra OF ordens-embarque 
            WHERE ordem-compra.cod-cond-pag = 63 NO-LOCK:

            FIND FIRST cotacao-item no-lock 
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   AND cotacao-item.cot-aprovada no-error.

            ASSIGN de-unit = 0.
            IF AVAIL cotacao-item THEN
                ASSIGN de-unit = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).

            ASSIGN de-valor-embarque = de-valor-embarque - (ordens-embarque.qt-do-forn * de-unit).
        END.

        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.

        ASSIGN tt-embarque-imp.valor-embarque = de-valor-embarque.

        RUN esp/es0018p.p (INPUT "CondPagEmbar":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN v-cod-cond-pag = ?.
        blk_cond_pag:
        FOR EACH ordens-embarque OF embarque-imp NO-LOCK,
            EACH ordem-compra OF ordens-embarque 
           WHERE ordem-compra.cod-cond-pag <> 63 NO-LOCK:
            /*NÆo considera as condi‡äes de pagamento deste ponto*/
            IF NOT CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(ordem-compra.cod-cond-pag)) THEN DO:
                ASSIGN v-cod-cond-pag = ordem-compra.cod-cond-pag.
                LEAVE blk_cond_pag.
            END.
        END.               

        FOR FIRST ordens-embarque OF embarque-imp NO-LOCK,
            FIRST ordem-compra OF ordens-embarque NO-LOCK.                

            IF v-cod-cond-pag = ? THEN
                ASSIGN v-cod-cond-pag = ordem-compra.cod-cond-pag.
        END.

        ASSIGN tt-embarque-imp.cod-cond-pag = v-cod-cond-pag.

        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = v-cod-cond-pag NO-ERROR.
        IF AVAIL cond-pagto THEN
            ASSIGN tt-embarque-imp.des-cond-pag = cond-pagto.descricao.


        blk_invoices:
        FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
            FIND FIRST pagamento-invoice NO-LOCK
                 WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                   AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                   AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.

            IF AVAIL pagamento-invoice THEN DO:
                ASSIGN tt-embarque-imp.possuiCIpagto = YES.

                FIND FIRST pagamento NO-LOCK
                     WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-ERROR.

                IF  AVAIL pagamento
                AND pagamento.recebido-ap THEN DO:
                    ASSIGN tt-embarque-imp.CIrecebida = YES.
                    LEAVE blk_invoices.
                END.
            END.
        END.
    END.                

    RETURN "OK".
    
END.
