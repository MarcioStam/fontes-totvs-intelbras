/* Definiá∆o da vari†veis */
def var h-bodi317pr                   as handle no-undo.
def var h-bodi317sd                   as handle no-undo.
def var h-bodi317im1bra               as handle no-undo.
def var h-bodi317va                   as handle no-undo.
def var h-bodi317in                   as handle no-undo.
def var h-bodi317ef                   as handle no-undo.
def var l-proc-ok-aux                 as log    no-undo.
def var c-ultimo-metodo-exec          as char   no-undo.
def var c-cod-estabel                 as char   no-undo.
def var c-serie                       as char   no-undo.
def var da-dt-emis-nota               as date   no-undo.
def var da-dt-base-dup                as date   no-undo.
def var da-dt-prvenc                  as date   no-undo.
def var c-nome-abrev                  as char   no-undo.   
def var c-nr-pedcli                   as char   no-undo.
def var c-nat-operacao                as char   no-undo.
def var c-cod-canal-venda             as char   no-undo.
def var i-seq-wt-docto                as int    no-undo.
def var i-seq-wt-it-docto             as int    no-undo.
def var i-cont-itens                  as int    no-undo.
def var c-it-codigo                   as char   no-undo.
def var c-cod-refer                   as char   no-undo.
def var de-quantidade                 as dec    no-undo.
def var de-vl-preori-ped              as dec    no-undo.
def var de-val-pct-desconto-tab-preco as dec    no-undo.
def var de-per-des-item               as dec    no-undo.
DEFINE VARIABLE l-item-total AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-pedido-total AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-char-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-bodi149 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-cod-localizExp AS CHARACTER   NO-UNDO.
DEF VAR qt-alocada LIKE ped-item.qt-aloca.
def new global shared var v_cod-deposESPDP006 like deposito.cod-depos   no-undo.
DEF NEW GLOBAL SHARED TEMP-TABLE tt-PedSaldoShared NO-UNDO LIKE ped-saldo.
DEFINE BUFFER b-ped-item FOR ped-item.

{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda.
DEFINE TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item.
DEFINE TEMP-TABLE tt-ped-saldo                 NO-UNDO LIKE ped-saldo.

DEFINE STREAM s-wt-fat-ser.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tipo AS INT
    FIELD cod-estabel  LIKE ped-venda.cod-estabel
    FIELD nr-pedcli    LIKE ped-venda.nr-pedcli
    FIELD cod-priori   LIKE ped-venda.cod-priori
    FIELD cod-emitente LIKE ped-venda.cod-emitente
    FIELD nome-emit   LIKE emitente.nome-emit
    FIELD tp-pedido    LIKE ped-venda.tp-pedido
    FIELD mensagem AS CHAR.
/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
def temp-table tt-notas-geradas no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis
    field seq-wt-docto   like wt-docto.seq-wt-docto.

/* Definiá∆o de um buffer para tt-notas-geradas */
def buffer b-tt-notas-geradas for tt-notas-geradas.

DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-ped-saldo   AS LOGICAL     NO-UNDO.

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
    FIELD ped-parc         AS LOG
    FIELD item-parc        AS LOG
    FIELD somente-integral AS LOG.

define temp-table tt-digita no-undo
    field it-codigo LIKE ped-item.it-codigo
    index id it-codigo.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-int-1     AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

DEFINE VARIABLE qtd-total-disponivel AS DECIMAL     NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "espdp094_" + STRING(TIME) + ".csv":U.

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

DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    /*Seleciona itens*/
    DO i = 1 TO NUM-ENTRIES(tt-param.prioridade,";"):
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.cod-sit-ped  <= 2
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
             AND ped-venda.int-1        <= tt-param.grp-canais-fim,
            FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente  = ped-venda.cod-emitente
              AND (emitente.ind-lib-estoq = YES 
               OR  ped-venda.cod-sit-aval = 3   
               OR  ped-venda.mo-codigo   <> 0),
            EACH ped-item OF ped-venda NO-LOCK
           WHERE ped-item.cod-unid-neg  >= tt-param.cod-unid-neg-ini
             AND ped-item.cod-unid-neg  <= tt-param.cod-unid-neg-fim
             AND ped-item.cod-sit-item  <= 2
             AND ped-item.dt-entrega    >= tt-param.dt-entrega-ini
             AND ped-item.dt-entrega    <= tt-param.dt-entrega-fim
             AND ped-item.qt-log-aloca <> 0
        BREAK BY ped-item.nr-pedcli
              BY ped-venda.nr-pedcli:

            /*Salva a quantidade alocada pois vai desfazer a alocaá∆o*/
            ASSIGN qt-alocada = ped-item.qt-log-aloca.

            IF ped-item.qt-pedida - ped-item.qt-atendida = ped-item.qt-log-aloca THEN
                ASSIGN l-item-total = YES.

            IF NOT CAN-FIND (FIRST b-ped-item OF ped-venda
                             WHERE b-ped-item.qt-pedida - ped-item.qt-atendida <> ped-item.qt-log-aloca
                               AND b-ped-item.cod-sit-item  <= 2) THEN
                ASSIGN l-pedido-total = YES.

            IF NOT tt-param.somente-integral THEN DO:
                IF  NOT tt-param.ped-parc 
                AND l-item-total THEN
                    NEXT.
    
                IF NOT tt-param.item-parc 
                AND NOT l-item-total THEN
                    NEXT.
            END.

            IF  tt-param.somente-integral
            AND NOT l-pedido-total THEN
                NEXT.

            RUN pi-acompanhar in h-acomp (input "Selecionando Pedido: " + string(ped-venda.nr-pedido)).

            IF NOT CAN-FIND(FIRST tt-ped-venda
                            WHERE tt-ped-venda.nr-pedido = ped-venda.nr-pedido) THEN DO:

                CREATE tt-ped-venda.
                BUFFER-COPY ped-venda TO tt-ped-venda.
            END.

            CREATE tt-ped-item.
            BUFFER-COPY ped-item TO tt-ped-item.
        END.
    END.

    FOR EACH tt-ped-venda:
        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

        RUN pi-acompanhar in h-acomp (input "Faturando Pedido: " + string(ped-venda.nr-pedido)).

        EMPTY TEMP-TABLE tt-ped-saldo.
        EMPTY TEMP-TABLE tt-PedSaldoShared.
        
        FOR EACH ped-saldo NO-LOCK     
           WHERE ped-saldo.nome-abrev    = ped-venda.nome-abrev       
             AND ped-saldo.nr-pedcli     = ped-venda.nr-pedcli .

            
           IF ped-saldo.qt-aloc-ped   > 0 THEN DO:
               ASSIGN v_cod-deposESPDP006 = ped-saldo.cod-depos.

               IF NOT CAN-FIND (FIRST tt-ped-saldo OF ped-saldo) THEN DO:
                   CREATE tt-ped-saldo.
                   BUFFER-COPY ped-saldo TO tt-ped-saldo.
                   ASSIGN tt-ped-saldo.cod-depos   = v_cod-deposESPDP006.

                   CREATE tt-PedSaldoShared.
                   BUFFER-COPY ped-saldo TO tt-PedSaldoShared.
               END. /* IF NOT AVAIL tt-ped-saldo THEN DO: */
           END. /* IF ped-saldo.qt-aloc-ped   > 0 THEN DO: */
        END. /* FOR EACH ped-saldo no-lock */
        
        bloco-cria-ped:
        DO TRANS:
            /*cria o cabeáalho da nota*/
            for each ped-ent of ped-venda
                where ped-ent.qt-log-aloca <> 0 no-lock:

                if  not valid-handle(h-bodi149) then
                    run dibo/bodi149.p persistent set h-bodi149.

                run unallocateDelivery in h-bodi149(input rowid(ped-ent),
                                                    input ped-ent.qt-log-aloca).

                IF VALID-HANDLE(h-bodi149) THEN DO:
                   run destroyBO in h-bodi149.
                   run destroy   in h-bodi149.
                   ASSIGN h-bodi149 = ?.
                END.  /* if  valid-handle(h-bodi149) then do */

            end. /*  for each ped-ent of tt-PedidosFaturaveis */

            FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
                ASSIGN ped-item.qt-log-aloca = 0.
            END.

            /* Inicializaá∆o das BOS para C†lculo */
            run dibo/bodi317in.p persistent set h-bodi317in.
            run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                             output h-bodi317sd,     
                                             output h-bodi317im1bra,
                                             output h-bodi317va).

            run leaveCodEstabel in h-bodi317sd (input  ped-venda.cod-estabel,
                                                input  no,
                                                output c-char-aux).
            
            /* Informaá‰es do embarque para c†lculo */
            assign c-cod-estabel     = ped-venda.cod-estabel    /* Estabelecimento do pedido  */
                   c-serie           = c-char-aux                /* SÇrie das notas            */
                   c-nome-abrev      = ped-venda.nome-abrev     /* Nome abreviado do cliente  */
                   c-nr-pedcli       = ped-venda.nr-pedcli      /* Nr pedido do cliente       */
                   da-dt-emis-nota   = TODAY                    /* Data de emiss∆o da nota    */
                   c-nat-operacao    = ped-venda.nat-operacao   /* Quando Ç ? busca do pedido */
                   c-cod-canal-venda = ?.                       /* Quando Ç ? busca do pedido */
            
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
            
            run criaWtDocto in h-bodi317sd (input  c-seg-usuario,
                                            input  c-cod-estabel,
                                            input  c-serie,
                                            input  "1",
                                            input  c-nome-abrev,
                                            input  c-nr-pedcli,
                                            input  1,
                                            input  9999,
                                            input  da-dt-emis-nota,
                                            input  0,
                                            input  c-nat-operacao,
                                            input  c-cod-canal-venda,
                                            output i-seq-wt-docto,
                                            output l-proc-ok-aux).
        
            /* Busca poss°veis erros que ocorreram nas validaá‰es */
            run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                                     output table RowErrors).
        
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors no-lock no-error.
            
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                    where rowErrors.errorSubtype = "ERROR":U:
                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                RUN pi-finaliza.
                undo, leave.
            END.

            /* Bloco a ser repetido para cada item da nota */
            bloco-cria-item:
            FOR EACH tt-ped-item OF tt-ped-venda:
                FIND FIRST ped-item OF tt-ped-item EXCLUSIVE-LOCK.

                ASSIGN ped-item.qt-log-aloca = tt-ped-item.qt-log-aloca.

                FIND CURRENT ped-item NO-LOCK.

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                assign c-it-codigo                   = ped-item.it-codigo  /* C¢digo do item     */
                       c-cod-refer                   = ped-item.cod-refer  /* Referància do item */
/*                            de-quantidade                 = */
                       de-vl-preori-ped              = ped-item.vl-preori  /* Preáo unit†rio     */
                       de-val-pct-desconto-tab-preco = ped-item.val-pct-desconto-tab-preco   /* Desconto de tabela */
                       de-per-des-item               = ped-item.per-des-item .  /* Desconto do item   */

                IF ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO THEN
                    ASSIGN de-quantidade = ped-item.qt-pedida - ped-item.qt-atendida.
                ELSE 
                    ASSIGN de-quantidade = tt-ped-item.qt-log-aloca.
                    
                /* Disponibilizar o registro WT-DOCTO na bodi317sd */
                run localizaWtDocto in h-bodi317sd(input  i-seq-wt-docto,
                                                   output l-proc-ok-aux). 
            
                run emptyRowErrors        in h-bodi317in.
                /* Cria um item para nota fiscal. */
                run criaWtItDocto in h-bodi317sd  (input  rowid(ped-item),
                                                   input  "ped-item":U,
                                                   input  0,
                                                   input  "",
                                                   input  "",
                                                   input  ?,
                                                   output i-seq-wt-it-docto,
                                                   output l-proc-ok-aux).

                /* Busca poss°veis erros que ocorreram nas validaá‰es */
                run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                                         output table RowErrors).
            
                /* Pesquisa algum erro ou advertància que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro ou advertància, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors
                       where rowErrors.errorSubtype = "ERROR":U:

                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.
                
                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
            
                /* Grava informaá‰es gerais para o item da nota */
                run gravaInfGeraisWtItDocto in h-bodi317sd (input i-seq-wt-docto,
                                                            input i-seq-wt-it-docto,
                                                            input de-quantidade,
                                                            input de-vl-preori-ped,
                                                            input de-val-pct-desconto-tab-preco,
                                                            input de-per-des-item).

                run emptyRowErrors        in h-bodi317in.

                FOR EACH tt-ped-saldo NO-LOCK:
                    IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                  AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto
                                  AND wt-fat-ser-lote.cod-depos         <> tt-ped-saldo.cod-depos) THEN DO:
        
                        ASSIGN l-ped-saldo = YES.
                    END. /* IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK */
                    IF l-ped-saldo = YES THEN DO: 
                        LEAVE.
                    END.
                END. /* FOR EACH tt-ped-saldo NO-LOCK: */
        
                IF l-ped-saldo = NO THEN DO:
                    IF NOT CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                    WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                      AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto) THEN
                        ASSIGN l-ped-saldo = YES.
                END. /* IF l-ped-saldo = NO THEN DO: */
        
        
                IF l-ped-saldo = YES THEN DO:
                    RUN esp/es0018p.p (INPUT "spool-unix":U,
                                       INPUT 1,
                                       INPUT 0,
                                       INPUT "":U,
                                       OUTPUT TABLE tt-prog-ponto).
                     
                    FIND FIRST tt-prog-ponto NO-ERROR.
                    
                    //OUTPUT STREAM s-wt-fat-ser TO VALUE (tt-prog-ponto.conteudo + "/an046325/esftp016rp-wt-fat-ser-lote.txt") APPEND.
        
                    FOR EACH wt-fat-ser-lote EXCLUSIVE-LOCK
                       WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                         AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                         AND wt-fat-ser-lote.it-codigo         = ped-item.it-codigo:
        
/*                         PUT STREAM s-wt-fat-ser UNFORMATTED SKIP(2).                                                                           */
/*                         PUT STREAM s-wt-fat-ser UNFORMATTED "REGISTRO DELETADO POR " + c-seg-usuario + " EM " + STRING(NOW)    SKIP            */
/*                                                                  "wt-fat-ser-lote.seq-wt-docto    " wt-fat-ser-lote.seq-wt-docto    SKIP       */
/*                                                                  "tt-ped-saldo.nr-pedcli             " tt-ped-saldo.nr-pedcli             SKIP */
/*                                                                  "wt-fat-ser-lote.seq-wt-it-docto " wt-fat-ser-lote.seq-wt-it-docto SKIP       */
/*                                                                  "wt-fat-ser-lote.it-codigo       " wt-fat-ser-lote.it-codigo       SKIP       */
/*                                                                  "wt-fat-ser-lote.cod-depos       " wt-fat-ser-lote.cod-depos       SKIP       */
/*                                                                  "wt-fat-ser-lote.cod-locali      " wt-fat-ser-lote.cod-locali      SKIP       */
/*                                                                  "wt-fat-ser-lote.lote            " wt-fat-ser-lote.lote            SKIP       */
/*                                                                  "wt-fat-ser-lote.quantidade[1]   " wt-fat-ser-lote.quantidade[1]   SKIP (2).  */
                       DELETE wt-fat-ser-lote.
                    END.
        
                    FOR EACH tt-ped-saldo NO-LOCK     
                       WHERE tt-ped-saldo.nome-abrev    = ped-item.nome-abrev       
                         AND tt-ped-saldo.nr-pedcli     = ped-item.nr-pedcli       
                         AND tt-ped-saldo.nr-seq-item   = ped-item.nr-sequencia       
                         AND tt-ped-saldo.it-codigo     = ped-item.it-codigo       
                         AND tt-ped-saldo.qt-aloc-ped   > 0:

                        FIND FIRST deposito NO-LOCK 
                             WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-ERROR.

                        IF AVAIL deposito THEN DO:
                            IF deposito.cod-depos     = 'EXP'
                            OR deposito.log-gera-wms  = YES THEN
                                ASSIGN c-cod-localizExp = ''.
                            ELSE 
                                ASSIGN c-cod-localizExp = tt-ped-saldo.cod-localiz.
                        END. 
        
                        FIND FIRST wt-fat-ser-lote NO-LOCK 
                             WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                               AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                               AND wt-fat-ser-lote.it-codigo         = c-it-codigo                                                            
                               AND wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos                                                 
                               AND wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                               AND wt-fat-ser-lote.lote              = "" NO-ERROR.

                        IF NOT AVAIL wt-fat-ser-lote THEN DO:
                            CREATE wt-fat-ser-lote.
                            ASSIGN wt-fat-ser-lote.lote              = ""
                                   wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos   
                                   wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                                   wt-fat-ser-lote.quantidade[1]     = tt-ped-saldo.qt-aloc-ped
                                   wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                                   wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                                   wt-fat-ser-lote.qtd-contada[1]    = tt-ped-saldo.qt-aloc-ped
                                   wt-fat-ser-lote.it-codigo         = c-it-codigo
                                   wt-fat-ser-lote.lote              = ped-item.cod-refer.
        
/*                             PUT STREAM s-wt-fat-ser UNFORMATTED "REGISTRO CRIADO POR " + c-seg-usuario + " EM " + STRING(NOW)      SKIP            */
/*                                                                      "tt-ped-saldo.nr-pedcli             " tt-ped-saldo.nr-pedcli             SKIP */
/*                                                                      "wt-fat-ser-lote.seq-wt-docto    " wt-fat-ser-lote.seq-wt-docto    SKIP       */
/*                                                                      "wt-fat-ser-lote.seq-wt-it-docto " wt-fat-ser-lote.seq-wt-it-docto SKIP       */
/*                                                                      "wt-fat-ser-lote.it-codigo       " wt-fat-ser-lote.it-codigo       SKIP       */
/*                                                                      "wt-fat-ser-lote.cod-depos       " wt-fat-ser-lote.cod-depos       SKIP       */
/*                                                                      "wt-fat-ser-lote.cod-locali      " wt-fat-ser-lote.cod-locali      SKIP       */
/*                                                                      "wt-fat-ser-lote.lote            " wt-fat-ser-lote.lote            SKIP       */
/*                                                                      "wt-fat-ser-lote.quantidade[1]   " wt-fat-ser-lote.quantidade[1]   SKIP (2).  */
                        END. /* IF NOT avail wt-fat-ser-lote THEN DO: */
        
                    END. /* FOR EACH ped-saldo no-lock      */
                    //OUTPUT STREAM s-wt-fat-ser CLOSE.
                END. /* IF l-ped-saldo THEN DO: */
                ELSE DO:
                    FOR EACH wt-fat-ser-lote EXCLUSIVE-LOCK
                       WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                         AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto:
        
                        FIND FIRST deposito NO-LOCK
                             WHERE deposito.cod-depos = wt-fat-ser-lote.cod-depos NO-ERROR.

                        IF AVAIL deposito THEN DO:
                            IF deposito.cod-depos     = 'EXP'
                            OR deposito.log-gera-wms  = YES THEN
                                ASSIGN wt-fat-ser-lote.cod-locali = ''.
                        END. /* IF AVAIL deposito THEN DO: */
                    END.
                END.
                FIND CURRENT wt-fat-ser-lote NO-LOCK NO-ERROR.
                RELEASE wt-fat-ser-lote.
            
                /* Disp. registro WT-DOCTO, WT-IT-DOCTO e WT-IT-IMPOSTO na bodi317pr */
                run localizaWtDocto       in h-bodi317pr (input  i-seq-wt-docto,
                                                          output l-proc-ok-aux).
                run localizaWtItDocto     in h-bodi317pr (input  i-seq-wt-docto,
                                                          input  i-seq-wt-it-docto,
                                                          output l-proc-ok-aux).
                run localizaWtItImposto   in h-bodi317pr (input  i-seq-wt-docto,
                                                          input  i-seq-wt-it-docto,
                                                          output l-proc-ok-aux).
            
                /* Atualiza dados c†lculados do item */
                run atualizaDadosItemNota in h-bodi317pr (output l-proc-ok-aux).

                
                /* Busca poss°veis erros que ocorreram n as validaá‰es */
                run devolveErrosbodi317pr in h-bodi317pr (output c-ultimo-metodo-exec,
                                                          output table RowErrors).

                FIND FIRST deposito NO-LOCK 
                     WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-ERROR.

                IF  AVAIL deposito 
                AND deposito.log-gera-wms  = YES THEN DO:
                    for each RowErrors
                        where (RowErrors.ErrorNumber = 15178
                           OR  RowErrors.ErrorNumber = 15811
                           OR  RowErrors.ErrorNumber = 26082
                           OR  RowErrors.ErrorNumber = 27607
                           OR  RowErrors.ErrorNumber = 18168) :
                        delete RowErrors.
                    end.
                END.
            
                /* Pesquisa algum erro ou advertància que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro ou advertància, mostra em tela */
                if  avail RowErrors THEN DO:
                    for each RowErrors
                       where rowErrors.errorSubtype = "ERROR":U:

                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.
                END.

                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
                
                /* Valida informaá‰es do item */
                run validaItemDaNota      in h-bodi317va (input  i-seq-wt-docto,
                                                          input  i-seq-wt-it-docto,
                                                          output l-proc-ok-aux).
                
                /* Busca poss°veis erros que ocorreram nas validaá‰es */
                run devolveErrosbodi317va in h-bodi317va (output c-ultimo-metodo-exec,
                                                          output table RowErrors).

                /* Pesquisa algum erro ou advertància que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro ou advertància, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors
                       where rowErrors.errorSubtype = "ERROR":U:

                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.

                FIND FIRST ped-ent EXCLUSIVE-LOCK
                     WHERE ped-ent.nome-abrev   = ped-venda.nome-abrev
                       AND ped-ent.nr-pedcli    = ped-venda.nr-pedcli
                       AND ped-ent.nr-sequencia = ped-item.nr-sequencia
                       AND ped-ent.it-codigo    = ped-item.it-codigo
                       AND ped-ent.cod-refer    = ped-item.cod-refer NO-ERROR.

                IF AVAIL ped-ent THEN DO:
                    FOR EACH wt-it-docto EXCLUSIVE-LOCK
                        WHERE wt-it-docto.seq-wt-docto      = i-seq-wt-docto
                          AND wt-it-docto.seq-wt-it-docto   = i-seq-wt-it-docto
                          AND wt-it-docto.it-codigo         = ped-ent.it-codigo:

                        ASSIGN wt-it-docto.nr-entrega       = ped-ent.nr-entrega
                               wt-it-docto.quantidade[2]    = wt-it-docto.quantidade[1].
                    END. /* FOR EACH wt-it-docto */
                END. /* IF AVAIL ped-ent THEN DO: */
                
                
                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
            end.

            /* Finalizaªío das BOS utilizada no cˇlculo */
            RUN pi-finaliza.

            /* Reinicializaá∆o das BOS para C†lculo */
            run dibo/bodi317in.p persistent set h-bodi317in.
            run inicializaBOS in h-bodi317in (output h-bodi317pr,
                                              output h-bodi317sd,     
                                              output h-bodi317im1bra,
                                              output h-bodi317va).
        
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
        
            /* Calcula o pedido, com acompanhamento */
            run inicializaAcompanhamento in h-bodi317pr.
            run confirmaCalculo          in h-bodi317pr (input  i-seq-wt-docto,
                                                         output l-proc-ok-aux).
            run finalizaAcompanhamento   in h-bodi317pr.
        
            /* Busca poss°veis erros que ocorreram nas validaá‰es */
            run devolveErrosbodi317pr    in h-bodi317pr (output c-ultimo-metodo-exec,
                                                         output table RowErrors).
        
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors no-lock no-error.
            
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                   where rowErrors.errorSubtype = "ERROR":U:

                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                RUN pi-finaliza.
                UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
            END.
                
            /* Efetiva os pedidos e cria a nota */
            run dibo/bodi317ef.p persistent set h-bodi317ef.
            run emptyRowErrors           in h-bodi317in.
            run inicializaAcompanhamento in h-bodi317ef.
            run setaHandlesBOS           in h-bodi317ef (h-bodi317pr,     
                                                         h-bodi317sd, 
                                                         h-bodi317im1bra, 
                                                         h-bodi317va).
            run efetivaNota              in h-bodi317ef (input  i-seq-wt-docto,
                                                         input  yes,
                                                         output l-proc-ok-aux).
            run finalizaAcompanhamento   in h-bodi317ef.
        
            /* Busca poss°veis erros que ocorreram nas validaá‰es */
            run devolveErrosbodi317ef    in h-bodi317ef (output c-ultimo-metodo-exec,
                                                         output table RowErrors).
        
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors
                 where RowErrors.ErrorSubType = "ERROR":U no-error.
        
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                   where rowErrors.errorSubtype = "ERROR":U:

                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux then do:
                RUN pi-finaliza.
                UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
            end.
        
            /* Busca as notas fiscais geradas */
            run buscaTTNotasGeradas in h-bodi317ef (output l-proc-ok-aux,
                                                    output table tt-notas-geradas).
        
            RUN pi-finaliza.
            
            /* Mostrar as notas geradas */
            for first tt-notas-geradas no-lock:
                find last b-tt-notas-geradas no-error.
                for  first nota-fiscal
                    where rowid(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal no-lock:
                end.

                RUN pi-msg(INPUT 1, /**Error**/
                           INPUT "Nota gerada com sucesso! Estabelecimento: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis).
            end.
            /* Fim do programa que calcula uma nota complementar */
        END.
    END.
END.

PUT STREAM str-excel UNFORMATTED "Estab.;Cliente;Nome;Pedido;Atendente;Prioridade;Sucesso;Mensagem" SKIP.
FOR EACH tt-mensagem:
    PUT STREAM str-excel UNFORMATTED tt-mensagem.cod-estabel + ";" +
                                     STRING(tt-mensagem.cod-emitente) + ";" +
                                     tt-mensagem.nome-emit + ";" +
                                     tt-mensagem.nr-pedcli + ";" +
                                     STRING(tt-mensagem.tp-pedido) + ";" +
                                     STRING(tt-mensagem.cod-priori) + ";" +
                                     STRING(tt-mensagem.tipo = 1,"Sim/N∆o") + ";" +
                                     tt-mensagem.mensagem SKIP.
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

RETURN "OK". 

PROCEDURE pi-msg: 
    DEFINE INPUT PARAM p-tipo     AS INT. /*1- sucesso 2- erro*/
    DEFINE INPUT PARAM p-mensagem AS CHAR.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tipo         = p-tipo
           tt-mensagem.cod-estabel  = ped-venda.cod-estabel
           tt-mensagem.cod-emitente = ped-venda.cod-emitente
           tt-mensagem.nr-pedcli    = ped-venda.nr-pedcli
           tt-mensagem.cod-priori   = ped-venda.cod-priori
           tt-mensagem.nome-emit    = emitente.nome-emit
           tt-mensagem.tp-pedido    = ped-venda.tp-pedido
           tt-mensagem.mensagem     = p-mensagem.

END.

PROCEDURE pi-finaliza:

    IF  VALID-HANDLE (h-bodi317in) THEN DO:
        RUN finalizaBOS in h-bodi317in.
        ASSIGN h-bodi317in = ?.
    END.

    IF VALID-HANDLE(h-bodi317ef) THEN
        RUN destroy IN h-bodi317ef.
    
END PROCEDURE.
