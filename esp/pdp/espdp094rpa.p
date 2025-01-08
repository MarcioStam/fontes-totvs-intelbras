/* espdp094rpa.p */
{include/i-prgvrs.i ESPDP094RPA 1.00.00.000} 

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
    FIELD grp-canais-ini   AS INT
    FIELD grp-canais-fim   AS INT
    FIELD cod-unid-neg-ini LIKE ped-item.cod-unid-neg
    FIELD cod-unid-neg-fim LIKE ped-item.cod-unid-neg
    FIELD estado-ini       LIKE ped-venda.estado
    FIELD estado-fim       LIKE ped-venda.estado
    FIELD prioridade       AS CHAR
    FIELD atendente-mestre AS CHAR
    FIELD ped-parc         AS LOG
    FIELD item-parc        AS LOG
    FIELD somente-integral AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD nr-pedido AS INT.

DEF TEMP-TABLE tt-usuarios-reserva NO-UNDO
    FIELD usuario AS CHAR.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param     as raw                    no-undo.
def input param table for tt-raw-digita.

{utp/ut-glob.i}

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

/*
ASSIGN c-arquivo-log1 = '/mnt/spool/is055792/ESPDP094RPA.txt'.

RUN pi-gerar-dados-extrato (">> INICIO " + STRING(TODAY) + ' ' + STRING(TIME,'HH:MM:SS')).
*/

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* Defini»’o da variÿveis */
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

DEFINE VARIABLE c-saida-pedido AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-lista-cli AS LOGICAL     NO-UNDO.

DEFINE VAR i-cont-ped     AS INT NO-UNDO.
DEFINE VAR i-cont-ped-tot AS INT NO-UNDO.

{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
{method/dbotterr.i}
{esp/pdp/espdp006fn.i} /* fnEstoque */

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda.
DEFINE TEMP-TABLE tt-ped-item  NO-UNDO LIKE ped-item.
DEFINE TEMP-TABLE tt-ped-saldo NO-UNDO LIKE ped-saldo.


DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tipo AS INT
    FIELD cod-estabel  LIKE ped-venda.cod-estabel
    FIELD nr-pedcli    LIKE ped-venda.nr-pedcli
    FIELD nome-abrev   LIKE ped-venda.nr-pedcli
    FIELD cod-priori   LIKE ped-venda.cod-priori
    FIELD cod-emitente LIKE ped-venda.cod-emitente
    FIELD nome-emit   LIKE emitente.nome-emit
    FIELD tp-pedido    LIKE ped-venda.tp-pedido
    FIELD mensagem AS CHAR
    INDEX idx nome-abrev nr-pedcli.
/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
def temp-table tt-notas-geradas no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis
    field seq-wt-docto   like wt-docto.seq-wt-docto.

/* Defini»’o de um buffer para tt-notas-geradas */
def buffer b-tt-notas-geradas for tt-notas-geradas.

DEFINE STREAM str-excel.    


DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i             AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-ped-saldo   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.


DEFINE VARIABLE l-erro AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-erro AS CHARACTER NO-UNDO.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "espdp094_" + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.

    IF  OPSYS = "unix" THEN 
    DO:
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
    ELSE 
    DO:
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

PUT STREAM str-excel UNFORMATTED "Estab.;Cliente;Nome;Pedido;Atendente;Prioridade;Sucesso;Mensagem;Total Pedido" SKIP.

DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    ASSIGN i-cont-ped-tot = 0
           i-cont-ped     = 0.

    /*Seleciona itens*/
    FOR EACH tt-digita:     

        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.nr-pedido     = tt-digita.nr-pedido
             AND ped-venda.cod-sit-ped  <= 2
             AND ped-venda.completo
             AND ped-venda.cod-priori   <> 44,
            FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente  = ped-venda.cod-emitente,
              /*AND (emitente.ind-lib-estoq = YES 
               OR  ped-venda.cod-sit-aval = 3   
               OR  ped-venda.mo-codigo   <> 0),*/
            EACH ped-item OF ped-venda NO-LOCK              
           WHERE ped-item.cod-sit-item   <= 2,                 
             /*AND ped-item.qt-log-aloca   <> 0,*/
            EACH ped-ent OF ped-item NO-LOCK
        BREAK BY ped-item.nr-pedcli
              BY ped-venda.nr-pedcli:

            ASSIGN l-lista-cli  = NO.

            IF emitente.ind-lib-estoq = YES OR 
               ped-venda.cod-sit-aval = 3   OR 
               ped-venda.mo-codigo   <> 0   THEN 
               ASSIGN l-lista-cli = YES.
    
            IF NOT l-lista-cli THEN NEXT.

            IF ped-item.cod-unid-neg < tt-param.cod-unid-neg-ini AND 
               ped-item.cod-unid-neg > tt-param.cod-unid-neg-fim THEN NEXT.

            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-oper = ped-item.nat-oper NO-ERROR.

            

            IF AVAIL natur-oper THEN DO:
               IF natur-oper.baixa-estoq THEN DO:
                  IF ped-item.qt-log-aloca = 0 THEN NEXT.
                   
                  FIND ped-saldo WHERE
                       ped-saldo.nome-abrev  = ped-ent.nome-abrev   AND
                       ped-saldo.nr-pedcli   = ped-ent.nr-pedcli    AND
                       ped-saldo.nr-seq-item = ped-ent.nr-sequencia AND
                       ped-saldo.it-codigo   = ped-ent.it-codigo    AND
                       ped-saldo.cod-refer   = ped-ent.cod-refer    AND
                       ped-saldo.nr-entrega  = ped-ent.nr-entrega NO-LOCK NO-ERROR.
    
                  IF NOT AVAIL ped-saldo THEN NEXT.
                   
                  /*Salva a quantidade alocada pois vai desfazer a alocacao*/
                  ASSIGN qt-alocada = ped-item.qt-log-aloca.
               END.
               ELSE
                 ASSIGN qt-alocada = ped-item.qt-pedida - ped-item.qt-atendida.
            END.

            /*
            find ped-saldo where
                 ped-saldo.nome-abrev  = ped-ent.nome-abrev      and
                 ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       and
                 ped-saldo.nr-seq-item = ped-ent.nr-sequencia    and
                 ped-saldo.it-codigo   = ped-ent.it-codigo       and
                 ped-saldo.cod-refer   = ped-ent.cod-refer       and
                 ped-saldo.nr-entrega  = ped-ent.nr-entrega no-lock no-error.
            if not avail ped-saldo then next.
            
            /*Salva a quantidade alocada pois vai desfazer a aloca¯Êo*/
            ASSIGN qt-alocada = ped-item.qt-log-aloca.*/

            ASSIGN l-item-total = NO.

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
                ASSIGN i-cont-ped-tot = i-cont-ped-tot + 1.
            END.

            CREATE tt-ped-item.
            BUFFER-COPY ped-item TO tt-ped-item.            
        END.
    END.
        
    FOR EACH tt-ped-venda:

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

        ASSIGN i-cont-ped = i-cont-ped + 1.

        RUN pi-acompanhar in h-acomp (input "Fat Ped: " + string(ped-venda.nr-pedido) + " " +  STRING(i-cont-ped) + "/" + STRING(i-cont-ped-tot)).
                                                                                                                       
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
            /*cria o cabe»alho da nota*/
            for each ped-ent fields(qt-log-aloca) of ped-venda
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
               
            
           /* FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
                ASSIGN ped-item.qt-log-aloca = 0.
            END. */
          

            /* Inicializa»’o das BOS para Cÿlculo */
            run dibo/bodi317in.p persistent set h-bodi317in.
            run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                             output h-bodi317sd,     
                                             output h-bodi317im1bra,
                                             output h-bodi317va).

            run leaveCodEstabel in h-bodi317sd (input  ped-venda.cod-estabel,
                                                input  no,
                                                output c-char-aux).

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "esftp016":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto 
                 WHERE entry(1,tt-prog-ponto.conteudo,";") = ped-venda.cod-estabel
                   AND entry(2,tt-prog-ponto.conteudo,";") = ped-venda.nat-operacao NO-ERROR.
            IF AVAIL tt-prog-ponto THEN
                ASSIGN c-char-aux = entry(3,tt-prog-ponto.conteudo,";").

            FIND FIRST int-natur-oper NO-LOCK // tratar serie de saida entreposto
                 WHERE int-natur-oper.nat-oper = ped-venda.nat-oper NO-ERROR.
            IF AVAIL int-natur-oper AND int-natur-oper.serie <> "" THEN
               ASSIGN c-char-aux = int-natur-oper.serie.

            
            /* Informa»„es do embarque para cÿlculo */
            assign c-cod-estabel     = ped-venda.cod-estabel    /* Estabelecimento do pedido  */
                   c-serie           = c-char-aux                /* S²rie das notas            */
                   c-nome-abrev      = ped-venda.nome-abrev     /* Nome abreviado do cliente  */
                   c-nr-pedcli       = ped-venda.nr-pedcli      /* Nr pedido do cliente       */
                   da-dt-emis-nota   = TODAY                    /* Data de emiss’o da nota    */
                   c-nat-operacao    = ped-venda.nat-operacao   /* Quando ² ? busca do pedido */
                   c-cod-canal-venda = ?.                       /* Quando ² ? busca do pedido */
            
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.

            run criaWtDocto in h-bodi317sd (input  c-seg-usuario,
                                            input  c-cod-estabel,
                                            input  c-serie,
                                            input  "1",
                                            input  c-nome-abrev,
                                            input  c-nr-pedcli,
                                            input  1,
                                            input  9998,
                                            input  da-dt-emis-nota,
                                            input  0,
                                            input  c-nat-operacao,
                                            input  c-cod-canal-venda,
                                            output i-seq-wt-docto,
                                            output l-proc-ok-aux).
        
            /* Busca poss­veis erros que ocorreram nas valida»„es */
            run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                                     output table RowErrors).
        
            /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
            find first RowErrors no-lock no-error.
            
            /* Caso tenha achado algum erro, mostra em tela */           
            if  avail RowErrors then
                for each RowErrors
                   WHERE RowErrors.ErrorSubType = "ERROR":
                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas valida»„es, n’o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                RUN pi-finaliza.
                undo, leave.
            END.

            
            /* Bloco a ser repetido para cada item da nota */
            bloco-cria-item:
            FOR EACH tt-ped-item OF tt-ped-venda:
                
                FIND FIRST ped-item OF tt-ped-item NO-LOCK NO-ERROR.

                FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-oper = ped-item.nat-oper NO-ERROR.

                IF NOT AVAIL natur-oper THEN NEXT.

                /*ASSIGN ped-item.qt-log-aloca = tt-ped-item.qt-log-aloca. marcio

                FIND CURRENT ped-item NO-LOCK. */

                IF ped-item.dt-entrega > TODAY THEN DO:
                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT "Item: " + ped-item.it-codigo + " com data futura: " + string(ped-item.dt-entrega)).
                    NEXT.
                END.
                

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                assign c-it-codigo                   = ped-item.it-codigo  /* C½digo do item     */
                       c-cod-refer                   = ped-item.cod-refer  /* Refer¼ncia do item */
/*                            de-quantidade                 = */
                       de-vl-preori-ped              = ped-item.vl-preori  /* Pre»o unitÿrio     */
                       de-val-pct-desconto-tab-preco = ped-item.val-pct-desconto-tab-preco   /* Desconto de tabela */
                       de-per-des-item               = ped-item.per-des-item .  /* Desconto do item   */

                IF (ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO) OR NOT natur-oper.baixa-estoq THEN
                    ASSIGN de-quantidade = ped-item.qt-pedida - ped-item.qt-atendida.
                ELSE 
                    ASSIGN de-quantidade = tt-ped-item.qt-log-aloca.


                ASSIGN l-erro = NO
                       c-erro = ''.

                /* M2111-037 - Valida Alocacoes j  reservadas */
                RUN pi-valida-aloc-reservas (INPUT de-quantidade,
                                             OUTPUT l-erro,
                                             OUTPUT c-erro).

                
                IF l-erro THEN DO:
                   RUN pi-msg(INPUT 2, /**Error**/
                              INPUT c-erro).
                   NEXT.  /* Vai para o proximo Item do pedido */
                END.

                    
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

                /* Busca poss­veis erros que ocorreram nas valida»„es */
                run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                                         output table RowErrors).
            
                /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":
                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.
                
                /* Caso ocorreu problema nas valida»„es, n’o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
            
                /* Grava informa»„es gerais para o item da nota */
                run gravaInfGeraisWtItDocto in h-bodi317sd (input i-seq-wt-docto,
                                                            input i-seq-wt-it-docto,
                                                            input de-quantidade,
                                                            input de-vl-preori-ped,
                                                            input de-val-pct-desconto-tab-preco,
                                                            input de-per-des-item).

                run emptyRowErrors        in h-bodi317in.

                 /* Busca poss­veis erros que ocorreram nas valida»„es */
                run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                                         output table RowErrors).
            
                /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":
                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.

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
                               AND wt-fat-ser-lote.lote              = IF item.tipo-con-est = 3 THEN tt-ped-saldo.lote ELSE "" NO-ERROR.

                        IF NOT AVAIL wt-fat-ser-lote THEN DO:
                            CREATE wt-fat-ser-lote.
                            ASSIGN wt-fat-ser-lote.lote              = IF item.tipo-con-est = 3 THEN tt-ped-saldo.lote ELSE ""
                                   wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos   
                                   wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                                   wt-fat-ser-lote.quantidade[1]     = tt-ped-saldo.qt-aloc-ped
                                   wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                                   wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                                   wt-fat-ser-lote.qtd-contada[1]    = tt-ped-saldo.qt-aloc-ped
                                   wt-fat-ser-lote.it-codigo         = c-it-codigo.
                                   //wt-fat-ser-lote.lote              = ped-item.cod-refer.
        
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
            
                /* Atualiza dados cÿlculados do item */
                run atualizaDadosItemNota in h-bodi317pr (output l-proc-ok-aux).

                
                /* Busca poss­veis erros que ocorreram n as valida»„es */
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
            
                /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro, mostra em tela */
                if  avail RowErrors THEN DO:
                    for each RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":
                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.
                END.

                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
                
                /* Valida informa»„es do item */
                run validaItemDaNota      in h-bodi317va (input  i-seq-wt-docto,
                                                          input  i-seq-wt-it-docto,
                                                          output l-proc-ok-aux).
                
                /* Busca poss­veis erros que ocorreram nas valida»„es */
                run devolveErrosbodi317va in h-bodi317va (output c-ultimo-metodo-exec,
                                                          output table RowErrors).

                /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
                find first RowErrors no-lock no-error.
                
                /* Caso tenha achado algum erro, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":
                        RUN pi-msg(INPUT 2, /**Error**/
                                   INPUT RowErrors.errorDescription).
                    end.

                FIND FIRST ped-ent NO-LOCK
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
                
                
                /* Caso ocorreu problema nas valida»„es, n’o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    RUN pi-finaliza.
                    UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
                END.
            end.

            /* Finaliza¯Êo das BOS utilizada no c˜lculo */
            RUN pi-finaliza.

            /* Reinicializa»’o das BOS para Cÿlculo */
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
        
            /* Busca poss­veis erros que ocorreram nas valida»„es */
            run devolveErrosbodi317pr    in h-bodi317pr (output c-ultimo-metodo-exec,
                                                         output table RowErrors).
        
            /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
            find first RowErrors no-lock no-error.
            
            /* Caso tenha achado algum erro, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                   WHERE RowErrors.ErrorSubType = "ERROR":
                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas valida»„es, n’o continua o processo */
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
        
            /* Busca poss­veis erros que ocorreram nas valida»„es */
            run devolveErrosbodi317ef    in h-bodi317ef (output c-ultimo-metodo-exec,
                                                         output table RowErrors).
        
            /* Pesquisa algum erro ou advert¼ncia que tenha ocorrido */
            find first RowErrors
                 where RowErrors.ErrorSubType = "ERROR":U no-error.
        
            /* Caso tenha achado algum erro, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                   WHERE RowErrors.ErrorSubType = "ERROR":
                    RUN pi-msg(INPUT 2, /**Error**/
                               INPUT RowErrors.errorDescription).
                end.
            
            /* Caso ocorreu problema nas valida»„es, n’o continua o processo */
            if  not l-proc-ok-aux then do:
                RUN pi-finaliza.
                UNDO bloco-cria-ped, LEAVE bloco-cria-ped.
            end.
        
            /* Busca as notas fiscais geradas */
            run buscaTTNotasGeradas in h-bodi317ef (output l-proc-ok-aux,
                                                    output table tt-notas-geradas).
        
            RUN pi-finaliza.

            /* M2111-037 - Liberacao futura, aguardando testes
            
            FIND FIRST int-pedido-fatur WHERE int-pedido-fatur.nr-pedido = tt-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL int-pedido-fatur THEN 
               ASSIGN int-pedido-fatur.dt-processa = TODAY
                      int-pedido-fatur.hr-processa = STRING(TIME,'HH:MM:SS').
            */          
            
            /* Mostrar as notas geradas */
            FOR FIRST tt-notas-geradas NO-LOCK:
                FIND LAST b-tt-notas-geradas NO-ERROR.
                FOR FIRST nota-fiscal
                    WHERE ROWID(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal NO-LOCK:

                    RUN pi-msg(INPUT 1, /**Error**/
                               INPUT "Nota gerada com sucesso! Estabelecimento: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis).

                    /*
                    IF AVAIL int-pedido-fatur THEN  
                       DELETE int-pedido-fatur.*/
                END.   
            END.

            /* Fim do programa que calcula uma nota complementar */
        END.
    END.    
    
END.

OUTPUT STREAM str-excel CLOSE.

/*
PUT STREAM str-excel UNFORMATTED "Estab.;Cliente;Nome;Pedido;Atendente;Prioridade;Sucesso;Mensagem" SKIP.
FOR EACH tt-mensagem
    BREAK BY tt-mensagem.nr-pedcli:
    PUT STREAM str-excel UNFORMATTED tt-mensagem.cod-estabel + ";" +
                                     STRING(tt-mensagem.cod-emitente) + ";" +
                                     tt-mensagem.nome-emit + ";" +
                                     tt-mensagem.nr-pedcli + ";" +
                                     STRING(tt-mensagem.tp-pedido) + ";" +
                                     STRING(tt-mensagem.cod-priori) + ";" +
                                     STRING(tt-mensagem.tipo = 1,"Sim/N’o") + ";" +
                                     tt-mensagem.mensagem SKIP.
END.

OUTPUT STREAM str-excel CLOSE.
*/

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

RETURN "OK". 

PROCEDURE pi-msg: 
    
    DEFINE INPUT PARAM p-tipo     AS INT. /*1- sucesso 2- erro*/
    DEFINE INPUT PARAM p-mensagem AS CHAR.

    DEFINE BUFFER b01-fat-comercial FOR fat-comercial.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tipo         = p-tipo
           tt-mensagem.cod-estabel  = ped-venda.cod-estabel
           tt-mensagem.cod-emitente = ped-venda.cod-emitente
           tt-mensagem.nr-pedcli    = ped-venda.nr-pedcli
           tt-mensagem.nome-abrev   = ped-venda.nome-abrev
           tt-mensagem.cod-priori   = ped-venda.cod-priori
           tt-mensagem.nome-emit    = emitente.nome-emit
           tt-mensagem.tp-pedido    = ped-venda.tp-pedido
           tt-mensagem.mensagem     = p-mensagem.

    // Gera Log
    PUT STREAM str-excel UNFORMATTED tt-mensagem.cod-estabel + ";" +
                                     STRING(tt-mensagem.cod-emitente) + ";" +
                                     tt-mensagem.nome-emit + ";" +
                                     tt-mensagem.nr-pedcli + ";" +
                                     STRING(tt-mensagem.tp-pedido) + ";" +
                                     STRING(tt-mensagem.cod-priori) + ";" +
                                     STRING(tt-mensagem.tipo = 1,"Sim/Nao") + ";" +
                                     tt-mensagem.mensagem + ";" + 
                                     string(i-cont-ped) + " de " + string(i-cont-ped-tot) SKIP.

    FIND LAST b01-fat-comercial USE-INDEX idx_faturaOkNok
        WHERE b01-fat-comercial.nome-abrev = ped-venda.nome-abrev
          AND b01-fat-comercial.nr-pedcli  = string(ped-venda.nr-pedido) 
    NO-LOCK NO-ERROR.

    CREATE fat-comercial.                          
    ASSIGN fat-comercial.nr-sequencia    = IF AVAIL b01-fat-comercial THEN b01-fat-comercial.nr-sequencia + 10 ELSE 10 
           fat-comercial.dt-fatura       = TODAY
           fat-comercial.hr-fatura       = TIME 
           fat-comercial.nome-abrev      = ped-venda.nome-abrev 
           fat-comercial.nr-pedcli       = string(ped-venda.nr-pedido)
           //fat-comercial.num-ped-exec    = 111
           fat-comercial.c-status        = '(Faturamento Automatico) ' + tt-mensagem.mensagem.
     
    IF p-tipo = 1 THEN // Nota gerada com Sucesso
    DO:
        IF NOT AVAIL nota-fiscal THEN 
           FIND FIRST nota-fiscal NO-LOCK  
                WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
                  AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli 
           NO-ERROR.    

        IF AVAIL nota-fiscal THEN 
           ASSIGN fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                  fat-comercial.serie       = nota-fiscal.serie  
                  fat-comercial.nr-nota-fis = nota-fiscal.nr-nota-fis.
    END.

END.


PROCEDURE pi-valida-aloc-reservas:

   DEF INPUT  PARAM p-de-qtde-reserva AS DEC  NO-UNDO.
   DEF OUTPUT PARAM p-log-erro        AS LOG  NO-UNDO.
   DEF OUTPUT PARAM p-desc-erro       AS CHAR NO-UNDO.

   DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE c-usuar-reservas    AS CHARACTER NO-UNDO.


   EMPTY TEMP-TABLE tt-prog-ponto.
   EMPTY TEMP-TABLE tt-usuarios-reserva.

   RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

   FIND FIRST tt-prog-ponto NO-ERROR.

   IF AVAIL tt-prog-ponto THEN DO:
      FOR EACH tt-prog-ponto:
          CREATE tt-usuarios-reserva.
          ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
      END.
   END.

   FIND FIRST int-ped-venda2 NO-LOCK
        WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
          AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

   FOR EACH ped-ent OF ped-item NO-LOCK,
       FIRST tt-ped-saldo NO-LOCK
       WHERE tt-ped-saldo.nome-abrev  = ped-ent.nome-abrev 
         AND tt-ped-saldo.nr-pedcli   = ped-ent.nr-pedcli  
         AND tt-ped-saldo.nr-seq-item = ped-ent.nr-sequencia
         AND tt-ped-saldo.it-codigo   = ped-ent.it-codigo  
         AND tt-ped-saldo.cod-refer   = ped-ent.cod-refer  
         AND tt-ped-saldo.nr-entrega  = ped-ent.nr-entrega:

       trans-reserva-ast:
       FOR EACH reservas-ast
           WHERE reservas-ast.cod-depos   = tt-ped-saldo.cod-depos
             AND reservas-ast.it-codigo   = ped-item.it-codigo
             AND reservas-ast.cod-estabel = ped-venda.cod-estabel
             AND reservas-ast.dt-reserva  <= TODAY NO-LOCK:

           IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:

               IF  AVAIL int-ped-venda2 THEN 
                   IF int-ped-venda2.PedidoeCommerce <> "" THEN DO:
                   /*Caso existam reservas mas os usu rio reservam para VTEX*/
                       IF  CAN-FIND(FIRST tt-usuarios-reserva
                                    WHERE tt-usuarios-reserva.usuario = reservas-ast.cd-usuario) THEN
                           NEXT trans-reserva-ast.
                   END.

               ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva
                      c-usuar-reservas    = c-usuar-reservas + (IF c-usuar-reservas = "" THEN "" ELSE ", ") + reservas-ast.cd-usuario.
           END.
       END.

       
       IF d-qtde-reservas-ast > 0 THEN DO:
           
           IF fnEstoque(ped-venda.cod-estabel,ped-item.it-codigo, tt-ped-saldo.cod-depos, "*", NO) < (d-qtde-reservas-ast + p-de-qtde-reserva ) THEN DO:
              ASSIGN p-desc-erro = "H  reservas de saldo. Entrar em contato com a pessoa que fez a reserva: " + c-usuar-reservas + "! ITEM: " + ped-item.it-codigo + " Dep." + tt-ped-saldo.cod-depos + " Estab. " + ped-venda.cod-estabel + "."
                     p-log-erro  = YES.
           END.
       END.

  END.                    

END PROCEDURE.



PROCEDURE pi-finaliza:

    IF  VALID-HANDLE (h-bodi317in) THEN DO:
        RUN finalizaBOS in h-bodi317in.
        ASSIGN h-bodi317in = ?.
    END.

    IF VALID-HANDLE(h-bodi317ef) THEN DO:
        RUN destroy IN h-bodi317ef.

        DELETE PROCEDURE h-bodi317ef.
        ASSIGN h-bodi317ef = ?.
    END.

END PROCEDURE.




PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string + " - " + STRING(DATETIME(TODAY, MTIME))  format "x(200)" skip.
        output close. 
    
    end.
END.

