{include/i-prgvrs.i ESFTP016rp 2.06.00.002}
/***********************************************************************
**  Programa..: ESP\PDP\ESFTP016RP.P
**  Autor.....: Rubia Oliveira
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{include/i-rpvar.i}
{method/dbotterr.i}
{utp/ut-glob.i}
{btb/btb008za.i0}
{esp/es0018.i}
{esp/trgw/wdi159.i}

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.

/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

def new global shared var v_cod-deposESPDP006 like deposito.cod-depos     no-undo.
DEF NEW GLOBAL SHARED VAR v_val_dec_1         LIKE int-ped-venda2.dec-2   NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_status_ped        AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_desc_bloq         AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_categ         AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_val_entrada       LIKE int-ped-venda2.dec-2 NO-UNDO.

/* In°cio do programa que calcula um pedido */
define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field nome-abrev    LIKE ped-venda.nome-abrev
    field nr-pedcli     LIKE ped-venda.nr-pedcli    
    field Cod-depos     LIKE deposito.cod-depos
    field Localizacao   LIKE saldo-estoq.cod-localiz .

define temp-table tt-digita NO-UNDO
    field nome-abrev     LIKE ped-venda.nome-abrev
    field nr-pedcli      LIKE ped-venda.nr-pedcli 
    field c-it-codigo    LIKE ped-item.it-codigo
    field c-cod-refer    LIKE ped-item.cod-refer
    field i-nr-sequencia LIKE ped-item.nr-sequencia
    .

DEFINE TEMP-TABLE tt-erros  NO-UNDO LIKE RowErrors.
DEF TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

DEFINE TEMP-TABLE tt-ft0910 NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli-ini   LIKE nota-fiscal.nome-ab-cli
    FIELD nome-ab-cli-fim   LIKE nota-fiscal.nome-ab-cli
    FIELD dt-emis-nota-ini  LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim  LIKE nota-fiscal.dt-emis-nota
    FIELD gera-nfe-n-gerada AS LOGICAL
    FIELD gera-nfe-gerada   AS LOGICAL
    FIELD exporta-est-txt   AS LOGICAL
    FIELD gera-nfe-cancel   AS LOGICAL
    FIELD gera-nfe-inut     AS LOGICAL
    FIELD c-motivo          AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-ft0910 NO-UNDO
    FIELD raw-digita AS RAW.


DEF TEMP-TABLE tt-itensPedido        NO-UNDO LIKE ped-item
    FIELD l-composto    AS LOGICAL
    FIELD qt-atendida-old LIKE ped-item.qt-atendida.

DEF TEMP-TABLE tt-itensPedidoBkp            NO-UNDO LIKE ped-item. 
DEF TEMP-TABLE tt-ped-saldo                 NO-UNDO LIKE ped-saldo.
DEF NEW GLOBAL SHARED TEMP-TABLE tt-PedSaldoShared NO-UNDO LIKE ped-saldo.
DEF TEMP-TABLE tt-fatCom                    NO-UNDO LIKE fat-comercial
    FIELD oldNota                           AS CHAR.
DEF TEMP-TABLE tt-composto                  NO-UNDO
    FIELD it-codigo                         LIKE ITEM.it-codigo
    FIELD qt-log-aloca                      LIKE ped-item.qt-log-aloca.

DEFINE VARIABLE l-ped-saldo                 AS LOGICAL INIT NO    NO-UNDO.

DEF BUFFER b-tt-itensPedido                 FOR tt-itensPedido.
DEFINE VARIABLE c-PaiMesmoFilho             AS CHARACTER   NO-UNDO.

DEF BUFFER bnota                            FOR nota-fiscal.
def frame f-docto
    ped-venda.nome-abrev
    ped-venda.nr-pedcli
    tt-erros.ErrorSubType                     column-label "Tipo"
    tt-erros.ErrorNumber                      column-label "Erro"
    tt-erros.ErrorDescription format "x(77)"  column-label "Mensagem"
    with stream-io width 132 down frame f-docto.

FOR EACH tt-param.
    DELETE tt-param.
END.

FOR EACH tt-digita.
    DELETE tt-digita.
END.

FOR EACH tt-ped-saldo.
    DELETE tt-ped-saldo.
END.

FOR EACH tt-PedSaldoShared.
    DELETE tt-PedSaldoShared.
END.

create tt-param.
raw-transfer raw-param to tt-param.

FOR each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
END.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-sistema            = "Espec°ficos Intelbras"
       c-titulo-relat       = "Faturamento Comercial"
       c-empresa            = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa           = "ESFTP016RP"
       c-versao             = "2.06"
       c-revisao            = "002"
       i-pais-impto-usuario = 1.

/* ***************************  Main Block  *************************** */

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


/* Definiá∆o da vari†veis */
def var h-bodi317pr                   as handle no-undo.
def var h-bodi317sd                   as handle no-undo.
def var h-bodi317im1bra               as handle no-undo.
def var h-bodi317va                   as handle no-undo.
def var h-bodi317in                   as handle no-undo.
def var h-bodi317ef                   as handle no-undo.
def var h-bodi149                     as handle no-undo.
def var l-proc-ok-aux                 as log    no-undo.
def var c-ultimo-metodo-exec          as char   no-undo.
def var c-cod-estabel                 as char   no-undo.
def var c-serie                       as char   no-undo.
def var da-dt-emis-nota               as date   no-undo.
def var da-dt-base-dup                as date   no-undo.
def var da-dt-prvenc                  as date   no-undo.
def var c-seg-usuario                 as char   no-undo.
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
def var de-old-quantidade             as dec    no-undo.
def var de-vl-preori-ped              as dec    no-undo.
def var de-val-pct-desconto-tab-preco as dec    no-undo.
def var de-per-des-item               as dec    no-undo.
DEF VAR c-cod-localizExp              AS CHAR   NO-UNDO.
def var c-char-aux           as char   no-undo.
def var hShowMsg             as handle no-undo.
def var l-unallocateDelivery as logical no-undo.
def var i-seq-erro           as int    no-undo INITIAL 0.
def var lcustomexecuted      as logical no-undo.
def var l-entregaFutura      as logical INIT NO no-undo.
def var qt-log-alocaComposto LIKE ped-item.qt-log-aloca NO-UNDO.
DEF VAR l-elimina-erro       AS LOG NO-UNDO.


/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
def temp-table tt-notas-geradas no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis
    field seq-wt-docto   like wt-docto.seq-wt-docto.

/* Definiá∆o de um buffer para tt-notas-geradas */

def buffer b-tt-notas-geradas for tt-notas-geradas.
def buffer b-fat-comercial    for fat-comercial.

def buffer b-PedItem          FOR ped-item.
def buffer b-int-ped-item-pai FOR int-ped-item-pai.

EMPTY TEMP-TABLE tt-prog-ponto2.
RUN esp/es0018p.p (INPUT "esftp016":U,
                   INPUT 4,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto2).

/* Inicializaá∆o das BOS para C†lculo */
run dibo/bodi317in.p persistent set h-bodi317in.
run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                 output h-bodi317sd,     
                                 output h-bodi317im1bra,
                                 output h-bodi317va).

FIND FIRST tt-param NO-LOCK NO-ERROR.
IF AVAIL tt-param THEN DO:

    FOR EACH tt-digita 
        WHERE tt-digita.nome-abrev  = tt-param.nome-abrev
          AND tt-digita.nr-pedcli   = tt-param.nr-pedcli  NO-LOCK:
    
        FIND FIRST ped-item
             where ped-item.nome-abrev    = tt-digita.nome-abrev  
               and ped-item.nr-pedcli     = tt-digita.nr-pedcli   
               and ped-item.nr-sequencia  = tt-digita.i-nr-sequencia
               and ped-item.it-codigo     = tt-digita.c-it-codigo   
               and ped-item.cod-refer     = tt-digita.c-cod-refer   NO-LOCK NO-ERROR.
        IF AVAIL ped-item THEN DO:

            IF ped-item.dt-entrega > TODAY THEN DO:
                CREATE tt-erros.
                ASSIGN l-entregaFutura           = YES
                       tt-erros.ErrorSubType     = "WARNING"
                       tt-erros.ErrorNumber      = 17006
                       tt-erros.ErrorDescription = 'ITEM '       + ped-item.it-codigo  + 
                                                   ' DO PEDIDO ' + ped-item.nr-pedcli  +  
                                                   ' Ç entrega futura. Data: ' + STRING(ped-item.dt-entrega,'99/99/9999').

                NEXT.

            END. /* IF ped-item.dt-entrega > TODAY THEN DO: */
            ELSE DO:

                FIND FIRST tt-itensPedido
                    WHERE tt-itensPedido.nome-abrev   = ped-item.nome-abrev   
                      AND tt-itensPedido.nr-pedcli    = ped-item.nr-pedcli    
                      AND tt-itensPedido.nr-sequencia = ped-item.nr-sequencia 
                      AND tt-itensPedido.it-codigo    = ped-item.it-codigo    
                      AND tt-itensPedido.cod-refer    = ped-item.cod-refer    NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-itensPedido THEN DO:

                    CREATE tt-itensPedido.
                    BUFFER-COPY ped-item TO tt-itensPedido.

                END. /* IF NOT AVAIL tt-itensPedido THEN DO: */
            END.

    
        END. /* IF AVAIL ped-item THEN DO: */
    
    END. /* FOR EACH tt-digita NO-LOCK: */

END. /* IF AVAIL tt-param THEN DO: */


DO TRANSACTION ON ERROR UNDO, LEAVE:
    
    FOR EACH tt-digita 
        WHERE tt-digita.nome-abrev  = tt-param.nome-abrev
          AND tt-digita.nr-pedcli   = tt-param.nr-pedcli  NO-LOCK:
    
        FIND FIRST ped-item 
             where ped-item.nome-abrev    = tt-digita.nome-abrev  
               and ped-item.nr-pedcli     = tt-digita.nr-pedcli   
               and ped-item.nr-sequencia  = tt-digita.i-nr-sequencia
               and ped-item.it-codigo     = tt-digita.c-it-codigo   
               and ped-item.cod-refer     = tt-digita.c-cod-refer   EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ped-item THEN DO:
            IF ped-item.dt-entrega > TODAY THEN NEXT.
            ASSIGN ped-item.qt-log-aloca = 0
                   /*ped-item.qt-alocada   = 0*/ .
        END. /* IF AVAIL ped-item THEN DO: */
        FIND CURRENT ped-item NO-LOCK NO-ERROR.
        RELEASE ped-item.
    
    END. /* FOR EACH tt-digita NO-LOCK: */
    

    IF AVAIL tt-param THEN DO:
    
        FIND FIRST ped-venda 
            WHERE ped-venda.nome-abrev = tt-param.nome-abrev 
              AND ped-venda.nr-pedcli  = tt-param.nr-pedcli   NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:

            //IDBA - Bruno Joaquim -> Chamado: C2302-2098 - 21/07/2023
            //Valida regras de bloqueio de faturamento
            RUN pi-valida-bloqueio-fat(ped-venda.cod-estabel, tt-param.usuario ) .
            IF RETURN-VALUE = "NOK" THEN DO:
                FOR LAST fat-comercial WHERE fat-comercial.nr-pedcli = ped-venda.nr-pedcli EXCLUSIVE-LOCK:
                ASSIGN fat-comercial.cod-estabel = ped-venda.cod-estabel
                       fat-comercial.dt-fatura   = TODAY
                       fat-comercial.hr-fatura   = TIME
                       fat-comercial.c-status    = "N∆o gerou nota - Faturamento bloqueado pelo ESFTP9002" .
                END.

                FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

               RETURN "NOK".
            END.
    
            FIND FIRST ped-antecip NO-LOCK
                WHERE ped-antecip.nr-pedido = ped-venda.nr-pedido NO-ERROR.

            ASSIGN v_val_entrada = IF AVAIL ped-antecip THEN ped-antecip.vl-antecip[1] ELSE 0.

            /* tratativa itens que n∆o ser∆o baixados e que foram tratados para n∆o considerar alocaá∆o */
            FOR EACH ped-item FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer dt-entrega qt-log-aloca) OF ped-venda EXCLUSIVE-LOCK:
    
                FIND FIRST tt-digita
                    where tt-digita.nome-abrev      = ped-item.nome-abrev  
                      and tt-digita.nr-pedcli       = ped-item.nr-pedcli   
                      and tt-digita.i-nr-sequencia  = ped-item.nr-sequencia
                      and tt-digita.c-it-codigo     = ped-item.it-codigo   
                      and tt-digita.c-cod-refer     = ped-item.cod-refer   EXCLUSIVE-LOCK NO-ERROR.
                
                IF ped-item.dt-entrega <= TODAY AND AVAIL tt-digita  THEN NEXT.
                    
                CREATE tt-itensPedidoBKP.
                BUFFER-COPY ped-item TO tt-itensPedidoBKP.

                ASSIGN ped-item.qt-log-aloca = 0
                       /*ped-item.qt-alocada   = 0*/ .
                
            END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */
            FIND CURRENT ped-item NO-LOCK NO-ERROR.
            RELEASE ped-item.
    
            run leaveCodEstabel in h-bodi317sd (input  ped-venda.cod-estabel,
                                                input  no,
                                                output c-char-aux).

            IF CAN-FIND(FIRST int-pedido-vtex NO-LOCK
                        WHERE int-pedido-vtex.nr-pedcli = ped-venda.nr-pedcli) THEN DO:
                FIND FIRST int-pedido-vtex NO-LOCK
                     WHERE int-pedido-vtex.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "esftp016":U,
                                   INPUT 3,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                IF CAN-FIND(FIRST tt-prog-ponto 
                            WHERE tt-prog-ponto.conteudo = int-pedido-vtex.marketplace) THEN
                    ASSIGN c-char-aux = "90".
            END.
            
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

            FIND FIRST ser-estab
                WHERE ser-estab.serie       = c-char-aux  
                  AND ser-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    
            /* Informaá‰es do embarque para c†lculo */
            assign c-cod-estabel     = ped-venda.cod-estabel    /* Estabelecimento do pedido  */
                   c-serie           = c-char-aux               /* SÇrie das notas            */
                   c-nome-abrev      = ped-venda.nome-abrev     /* Nome abreviado do cliente  */
                   c-nr-pedcli       = ped-venda.nr-pedcli      /* Nr pedido do cliente       */
                   da-dt-emis-nota   = IF AVAIL ser-estab THEN ser-estab.dt-ult-fat 
                                       ELSE TODAY               /* Data de emiss∆o da nota    */
                   c-nat-operacao    = ?                        /* Quando Ç ? busca do pedido */
                   c-cod-canal-venda = ?.                       /* Quando Ç ? busca do pedido */
    
            /************************************* ped-saldo */
            FOR EACH ped-saldo no-lock     
               where ped-saldo.nome-abrev    = ped-venda.nome-abrev       
                 and ped-saldo.nr-pedcli     = ped-venda.nr-pedcli .

                IF ped-saldo.qt-aloc-ped   > 0 THEN DO:

                    ASSIGN v_cod-deposESPDP006 = ped-saldo.cod-depos.

                    FIND FIRST tt-ped-saldo
                        where tt-ped-saldo.cod-depos   = v_cod-deposESPDP006   
                          and tt-ped-saldo.cod-estabel = ped-saldo.cod-estabel
                          and tt-ped-saldo.cod-localiz = ped-saldo.cod-localiz
                          and tt-ped-saldo.lote        = ped-saldo.lote       
                          and tt-ped-saldo.nome-abrev  = ped-saldo.nome-abrev 
                          and tt-ped-saldo.nr-pedcli   = ped-saldo.nr-pedcli  
                          and tt-ped-saldo.nr-seq-item = ped-saldo.nr-seq-item
                          and tt-ped-saldo.it-codigo   = ped-saldo.it-codigo  
                          and tt-ped-saldo.cod-refer   = ped-saldo.cod-refer  
                          and tt-ped-saldo.nr-entrega  = ped-saldo.nr-entrega NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-ped-saldo THEN DO:
                        CREATE tt-ped-saldo.
                        BUFFER-COPY ped-saldo TO tt-ped-saldo.
                        ASSIGN tt-ped-saldo.cod-depos   = v_cod-deposESPDP006.
                    
                        CREATE tt-PedSaldoShared.
                        BUFFER-COPY ped-saldo TO tt-PedSaldoShared.
                    END.
               END.
            END.

            for each ped-ent fields(qt-log-aloca) of ped-venda
                where ped-ent.qt-log-aloca <> 0 no-lock:

                assign l-unallocateDelivery = yes.
    
                if  not valid-handle(h-bodi149) or
                    h-bodi149:type      <> "PROCEDURE":U or
                    h-bodi149:file-name <> "dibo/bodi149.p":U then
                    run dibo/bodi149.p persistent set h-bodi149.
    
                run unallocateDelivery in h-bodi149(input  rowid(ped-ent),
                                                    input  ped-ent.qt-log-aloca).

                IF VALID-HANDLE(h-bodi149) THEN DO:
                   run destroy in h-bodi149.
                   ASSIGN h-bodi149 = ?.
                END.  /* if  valid-handle(h-bodi149) then do */                 
            end. /*  for each ped-ent of ped-venda */
    
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
            run criaWtDocto in h-bodi317sd(input  c-seg-usuario,
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
    
            /* tratativa itens que n∆o ser∆o baixados e que foram tratados para n∆o considerar alocaá∆o */
            FOR EACH tt-itensPedidoBKP,
                FIRST ped-item EXCLUSIVE-LOCK
                WHERE ped-item.nome-abrev    = tt-itensPedidoBKP.nome-abrev  
                  and ped-item.nr-pedcli     = tt-itensPedidoBKP.nr-pedcli   
                  and ped-item.nr-sequencia  = tt-itensPedidoBKP.nr-sequencia
                  and ped-item.it-codigo     = tt-itensPedidoBKP.it-codigo   
                  and ped-item.cod-refer     = tt-itensPedidoBKP.cod-refer :

                ASSIGN /*ped-item.qt-alocada   = tt-itensPedidoBKP.qt-alocada*/
                       ped-item.qt-log-aloca = tt-itensPedidoBKP.qt-log-aloca.
                DELETE tt-itensPedidoBKP.
            END. /* FOR EACH tt-itensPedidoBKP */
            FIND CURRENT ped-item NO-LOCK NO-ERROR.
            RELEASE ped-item.
    
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors no-lock no-error.
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK:
    /*                 PUT 'RowErrors.ErrorDescription ' RowErrors.ErrorDescription SKIP. */

                    RUN pi-valida-erro.
                    IF NOT l-elimina-erro THEN DO:
                       FIND FIRST tt-erros
                           WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                       IF NOT AVAIL tt-erros THEN DO:
                           CREATE tt-erros.
                           BUFFER-COPY RowErrors TO tt-erros.
                           ASSIGN tt-erros.ErrorDescription = 'CriaWtItDocto ' + tt-erros.ErrorDescription.
                       END. /* IF NOT AVAIL tt-erros THEN DO: */
                    END.
                end.
                
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                undo, leave.
            END.
                
            RUN pi-CRIA-ITENS.

            IF NOT CAN-FIND(FIRST tt-erros
                            WHERE tt-erros.ErrorSubType = "ERROR") THEN DO:

                run dibo/bodi317in.p persistent set h-bodi317in.
                run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                                 output h-bodi317sd,     
                                                 output h-bodi317im1bra,
                                                 output h-bodi317va).
        
                /* Limpar a tabela de erros em todas as BOS */
                run emptyRowErrors        in h-bodi317in.
        
                /* Calcula o pedido, com acompanhamento */
                run inicializaAcompanhamento in h-bodi317pr.
                run confirmaCalculo          in h-bodi317pr(input  i-seq-wt-docto,
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
                        WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK:
    
                        IF RowErrors.ErrorDescription MATCHES("*IPI*") THEN NEXT.

                        RUN pi-valida-erro.
                        IF NOT l-elimina-erro THEN DO:
                           FIND FIRST tt-erros
                               WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                           IF NOT AVAIL tt-erros THEN DO:
                               CREATE tt-erros.
                               BUFFER-COPY RowErrors TO tt-erros.
                               ASSIGN tt-erros.ErrorDescription = 'Depois PR ' + string(RowErrors.ErrorNumber) + " - " + tt-erros.ErrorDescription.
    /*                            ASSIGN tt-erros.ErrorDescription = tt-erros.ErrorDescription. */
                           END. /* IF NOT AVAIL tt-erros THEN DO: */
                        END.
                    end.
        
                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    undo, leave.
                END.
        
                /* Efetiva os pedidos e cria a nota */
                run dibo/bodi317ef.p persistent set h-bodi317ef.
                run emptyRowErrors           in h-bodi317in.
                run inicializaAcompanhamento in h-bodi317ef.
                run setaHandlesBOS           in h-bodi317ef(h-bodi317pr,     
                                                            h-bodi317sd, 
                                                            h-bodi317im1bra, 
                                                            h-bodi317va).
        
                run efetivaNota              in h-bodi317ef(input  i-seq-wt-docto,
                                                            input  yes,
                                                            output l-proc-ok-aux).

                run finalizaAcompanhamento   in h-bodi317ef.

                /* Busca poss°veis erros que ocorreram nas validaá‰es */
                run devolveErrosbodi317ef    in h-bodi317ef(output c-ultimo-metodo-exec,
                                                            output table RowErrors).
        
                /* Pesquisa algum erro ou advertància que tenha ocorrido */
                find first RowErrors
                     where RowErrors.ErrorSubType = "ERROR":U no-error.
        
                /* Caso tenha achado algum erro ou advertància, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors:
                        FIND FIRST tt-erros
                            WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt-erros THEN DO:
                            CREATE tt-erros.
                            BUFFER-COPY RowErrors TO tt-erros.
                            ASSIGN tt-erros.ErrorDescription = 'Devolve Erro ' + tt-erros.ErrorDescription.
    
                            IF tt-erros.ErrorDescription MATCHES("*ZFM*") THEN
                                ASSIGN tt-erros.ErrorSubType = "ERROR".
    
                        END. /* IF NOT AVAIL tt-erros THEN DO: */
                    end.
        
                /* Busca as notas fiscais geradas */
                run buscaTTNotasGeradas in h-bodi317ef(output l-proc-ok-aux,
                                                       output table tt-notas-geradas).

                DEF VAR l-permite-rollback AS LOG INIT YES NO-UNDO.
                FOR EACH tt-notas-geradas no-lock:

                    FIND FIRST nota-fiscal NO-LOCK
                        WHERE ROWID(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal NO-ERROR.

                    IF  AVAIL nota-fiscal THEN DO:
                        ASSIGN l-permite-rollback = NO.
                        LEAVE.
                    END.
                END.

                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux then do:
                    IF  l-permite-rollback THEN DO:
                        
                        delete procedure h-bodi317ef.
                        FOR EACH tt-itensPedido:
                            ASSIGN tt-itensPedido.qt-atendida = tt-itensPedido.qt-atendida-old.
                        END.
                        UNDO, LEAVE.
                    END.
                END.
        
                /* Elimina o handle do programa bodi317ef */
                delete procedure h-bodi317ef.
            END.
            ELSE /* ocorreu algum erro */
                FOR EACH tt-itensPedido:
                    ASSIGN tt-itensPedido.qt-atendida = tt-itensPedido.qt-atendida-old.
                END.
        END.
    
    END. /* IF AVAIL tt-param THEN DO: */
    
    /* Finalizaá∆o das BOS utilizada no c†lculo */
    IF  VALID-HANDLE (h-bodi317in) THEN
        RUN finalizaBOS in h-bodi317in.

    IF VALID-HANDLE(h-bodi317in) THEN DO:
       run destroy in h-bodi317in.
       ASSIGN h-bodi317in = ?.
    END.  /* if  valid-handle(h-bodi317in) then do */                 
    
    IF CAN-FIND(FIRST tt-erros
                WHERE tt-erros.ErrorSubType = "ERROR") THEN DO:
        
        IF  l-permite-rollback THEN DO:
            FOR EACH tt-itensPedido:
                ASSIGN tt-itensPedido.qt-atendida = tt-itensPedido.qt-atendida-old.
            END.
            UNDO, LEAVE.
        END.
    END.

   // RUN pi-move-xml-diretorio-neogrid.

END. /* DO TRANSACTION ON ERROR UNDO, LEAVE: */

IF  AVAIL tt-param THEN DO:
    FIND FIRST ped-venda 
         WHERE ped-venda.nome-abrev = tt-param.nome-abrev 
           AND ped-venda.nr-pedcli  = tt-param.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
    
    IF  AVAIL ped-venda THEN DO:
        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF  AVAIL int-ped-venda2 THEN 
            ASSIGN int-ped-venda2.dec-1  = v_val_dec_1
                   int-ped-venda2.char-3 = v_cod_categ /* categoria enviada ao deps */.

        IF  v_status_ped <> "" THEN DO:

            IF  v_status_ped = "Bloqueado1"
            OR  v_status_ped = "Bloqueado2" THEN DO:
                
                ASSIGN ped-venda.cod-sit-aval = 4
                       ped-venda.dt-apr-cred  = ?
                       ped-venda.quem-aprovou = ""
                       ped-venda.desc-bloq-cr = v_desc_bloq.
    
                ASSIGN v_status_ped = ""
                       v_desc_bloq  = "".
            END.

            IF  v_status_ped = "REAV" THEN
                ASSIGN ped-venda.cod-sit-aval = 1
                       ped-venda.dt-apr-cred  = ?
                       ped-venda.quem-aprovou = "".

            IF  v_status_ped = "REES" THEN
                ASSIGN ped-venda.desc-bloq-cr = v_desc_bloq
                       v_desc_bloq            = "".

        END.
    END.
END.


/* Finalizaá∆o das BOS utilizada no c†lculo */
IF  VALID-HANDLE (h-bodi317in) THEN
    RUN finalizaBOS in h-bodi317in. /* Finalizaá∆o das BOS utilizada no c†lculo */

IF VALID-HANDLE(h-bodi317in) THEN DO:
   run destroy in h-bodi317in.
   ASSIGN h-bodi317in = ?.
END.  /* if  valid-handle(h-bodi317in) then do */                 


/* Mostrar as notas geradas */
for EACH tt-notas-geradas no-lock:

    find last b-tt-notas-geradas no-error.

    for  first nota-fiscal 
        where rowid(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal no-lock:
    end.
    bell.

    /*IF tt-notas-geradas.nr-nota = b-tt-notas-geradas.nr-nota THEN DO:*/

        CREATE tt-erros.
        ASSIGN tt-erros.ErrorSubType     = "WARNING"
               tt-erros.ErrorNumber      = 17006
               tt-erros.ErrorDescription = 'Gerou Nota: Estab '  + 
                                            string(nota-fiscal.cod-estabel)   + ' Serie ' +  
                                            string(nota-fiscal.serie)         + ' Nota '  + string(tt-notas-geradas.nr-nota).
    /*END.
    ELSE DO:

        CREATE tt-erros.
        ASSIGN tt-erros.ErrorSubType     = "WARNING"
               tt-erros.ErrorNumber      = 17006
               tt-erros.ErrorDescription = 'Gerou Nota: Estab '  + 
                                            string(nota-fiscal.cod-estabel)   + ' Serie ' +  
                                            string(nota-fiscal.serie)         + ' Nota '  + 
                                            string(tt-notas-geradas.nr-nota)  + ' - '     + 
                                            string(b-tt-notas-geradas.nr-nota).
    END.*/

    FIND FIRST emitente where emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

        FOR LAST fat-comercial EXCLUSIVE-LOCK
           WHERE fat-comercial.nr-pedcli     = nota-fiscal.nr-pedcli:
            ASSIGN fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                   fat-comercial.serie       = nota-fiscal.serie
                   fat-comercial.nr-nota-fis = tt-notas-geradas.nr-nota 
                   fat-comercial.dt-fatura   = TODAY
                   fat-comercial.hr-fatura   = TIME
                   fat-comercial.c-status    = 'Gerou Nota: Estab '  + 
                                                string(nota-fiscal.cod-estabel)   + ' Serie ' +  
                                                string(nota-fiscal.serie)         + ' Nota '  + string(tt-notas-geradas.nr-nota).

        END. /* IF AVAIL fat-comercial THEN DO: */
        FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
        RELEASE fat-comercial.

    END. /* IF AVAIL emitente THEN DO: */

    EMPTY TEMP-TABLE tt-fatCom.

    /**  NOTAS COM NATUREZA VINCULADA **/
    FIND FIRST fat-comercial
        WHERE fat-comercial.cod-estabel  = nota-fiscal.cod-estabel 
          AND fat-comercial.serie        = nota-fiscal.serie       
          AND fat-comercial.nr-nota-fis  = nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
    IF AVAIL fat-comercial THEN DO:

        FIND FIRST bnota
            WHERE bnota.cod-estabel = nota-fiscal.cod-estabel
              AND bnota.serie       = nota-fiscal.serie      
              AND bnota.nr-nota-fis = string(int(nota-fiscal.nr-nota-fis) + 1,'9999999') NO-LOCK NO-ERROR.
        IF AVAIL bnota THEN DO:

            IF bnota.nr-pedcli = fat-comercial.nr-pedcli THEN DO:

                FIND FIRST tt-fatCom 
                    WHERE tt-fatCom.cod-estabel  = bnota.cod-estabel  
                      AND tt-fatCom.serie        = bnota.serie        
                      AND tt-fatCom.nr-nota-fis  = bnota.nr-nota-fis  NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-fatCom THEN DO:
                    CREATE tt-fatCom.
                    BUFFER-COPY fat-comercial TO tt-fatCom.
                    ASSIGN tt-fatCom.nr-sequencia = fat-comercial.nr-sequencia + 10
                           tt-fatCom.cod-estabel  = bnota.cod-estabel
                           tt-fatCom.serie        = bnota.serie
                           tt-fatCom.nr-nota-fis  = bnota.nr-nota-fis
                           tt-fatCom.dt-fatura    = TODAY 
                           tt-fatCom.hr-fatura    = TIME  
                           tt-fatCom.c-STATUS     = ''
                           tt-fatCom.oldNota      = fat-comercial.nr-nota-fis.
                END. /* IF NOT AVAIL tt-fatCom THEN DO: */

            END. /* IF bnota.nr-pedcli = fat-comercial.nr-pedcli THEN DO: */

        END. /* IF AVAIL bnota THEN DO: */

    END. /* IF AVAIL fat-comercial THEN DO: */
    FOR EACH tt-fatCom.

        IF tt-fatCom.nr-nota-fis = string(int(tt-fatCom.oldNota) + 1,'9999999') THEN DO:
            FIND FIRST fat-comercial 
                 WHERE fat-comercial.num-ped-exec = tt-fatCom.num-ped-exec
                   AND fat-comercial.nr-pedcli    = tt-fatCom.nr-pedcli
                   AND fat-comercial.nr-sequencia = tt-fatCom.nr-sequencia
                   AND fat-comercial.cod-estabel  = tt-fatCom.cod-estabel  
                   AND fat-comercial.serie        = tt-fatCom.serie        
                   AND fat-comercial.nr-nota-fis  = tt-fatCom.nr-nota-fis NO-LOCK NO-ERROR.
            IF NOT AVAIL fat-comercial THEN DO:
                CREATE fat-comercial.
                BUFFER-COPY tt-fatCom TO fat-comercial.
                ASSIGN fat-comercial.dt-fatura       = TODAY
                       fat-comercial.hr-fatura       = TIME. 
            END. /* IF NOT AVAIL fat-comercial THEN DO: */
            FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
            RELEASE fat-comercial.

        END. /* IF tt-fatCom.nr-nota-fis = string(int(tt-fatCom.oldNota) + 1,'9999999') THEN DO: */

    END. /* FOR EACH tt-fatCom. */
    
end. /* for each tt-notas-geradas no-lock: */
/* Fim do programa que calcula um pedido */


/* PUT "apos erro " SKIP.  */

DEF VAR l-ocorreu-erro AS LOG INIT NO NO-UNDO.
IF AVAIL tt-param THEN DO:
    FIND FIRST ped-venda 
        WHERE ped-venda.nome-abrev = tt-param.nome-abrev 
          AND ped-venda.nr-pedcli  = tt-param.nr-pedcli   EXCLUSIVE-LOCK NO-ERROR.

    FIND FIRST int-ped-venda NO-LOCK
        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    IF AVAIL ped-venda THEN DO:
    
        put '-----------------------------------------------------------------------------------------------' SKIP
            'Cliente ' ped-venda.nome-abrev     SKIP
            'Pedido  ' ped-venda.nr-pedcli      SKIP.
    
        for each tt-erros:

            PUT 'Erros ' tt-erros.ErrorSubType ' - ' tt-erros.ErrorDescription SKIP.
    

            IF  tt-erros.ErrorSubType = "ERROR" THEN DO:
                ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori-ori <> ? THEN 
                                                  int-ped-venda.cod-priori-ori /*Volta para a prioridade original do pedido*/
                                              ELSE 01.
                ASSIGN l-ocorreu-erro = YES.
            END. /* IF tt-erros.ErrorSubType = "ERROR" THEN DO: */
            ELSE DO:
                IF  CAN-FIND(FIRST tt-notas-geradas) THEN 
                    ASSIGN ped-venda.cod-priori = fnAlteraPrioridadeFaturamentoParcial (ped-venda.nr-pedido,   
                                                                                        ped-venda.cod-sit-ped, 
                                                                                        01).                   
            END. /* IF tt-erros.ErrorSubType <> "ERROR" THEN DO: */
    
            IF OPSYS <> "UNIX":U 
            THEN DO:
                FIND LAST fat-comercial
                    WHERE  fat-comercial.nome-abrev    = ped-venda.nome-abrev
                      AND  fat-comercial.nr-pedcli     = ped-venda.nr-pedcli   
                      AND  fat-comercial.num-ped-exec  = 999 EXCLUSIVE-LOCK NO-ERROR. 
                IF AVAIL fat-comercial 
                THEN ASSIGN fat-comercial.c-status    = fat-comercial.c-status + " " + tt-erros.ErrorDescription.

                FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
                RELEASE fat-comercial.
            END.
            ELSE DO:
                FIND LAST fat-comercial
                    WHERE  fat-comercial.nome-abrev    = ped-venda.nome-abrev
                      AND  fat-comercial.nr-pedcli     = ped-venda.nr-pedcli  NO-LOCK  NO-ERROR.
                IF AVAIL fat-comercial THEN DO: 
    
                    FIND LAST b-fat-comercial
                        WHERE b-fat-comercial.nome-abrev    = fat-comercial.nome-abrev
                          AND b-fat-comercial.nr-pedcli     = fat-comercial.nr-pedcli 
                          AND b-fat-comercial.num-ped-exec  = fat-comercial.num-ped-exec 
                              EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL b-fat-comercial 
                    THEN ASSIGN b-fat-comercial.c-status    = b-fat-comercial.c-status + " " + tt-erros.ErrorDescription.
                    
                    FIND CURRENT b-fat-comercial NO-LOCK NO-ERROR.
                    RELEASE b-fat-comercial.
                END. /* FOR EACH fat-comercial */

                RELEASE fat-comercial.
            END.
    
            delete tt-erros.
        end. 

        /* entrega futura */
        IF l-entregaFutura THEN 
            ASSIGN ped-venda.cod-priori = fnAlteraPrioridadeFaturamentoParcial (ped-venda.nr-pedido,   
                                                                                ped-venda.cod-sit-ped, 
                                                                                01).                   

        IF  l-ocorreu-erro 
        THEN DO:
            ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori-ori <> ? THEN 
                                              int-ped-venda.cod-priori-ori /*Volta para a prioridade original do pedido*/
                                          ELSE 01.
        END.
        ELSE DO:
            /* pedido aberto ou atendido parcial pode ser realocado */
            IF (ped-venda.cod-sit-ped = 1
            OR  ped-venda.cod-sit-ped = 2)  THEN ASSIGN ped-venda.cod-priori = fnAlteraPrioridadeFaturamentoParcial (ped-venda.nr-pedido,   
                                                                                                                     ped-venda.cod-sit-ped, 
                                                                                                                     01).

        END.
    END. /* IF AVAIL ped-venda THEN DO: */

    FIND CURRENT ped-venda NO-LOCK NO-ERROR.
    RELEASE ped-venda.
END.

{include/i-rpclo.i} 


PROCEDURE pi-composto:

    DEFINE INPUT  PARAMETER c-itComposto    LIKE ITEM.it-codigo         NO-UNDO.
    DEFINE OUTPUT PARAMETER de-qt-log-aloca LIKE ped-item.qt-log-aloca  NO-UNDO.

    DEFINE BUFFER bProd-composto FOR prod-composto.

    FOR EACH prod-composto WHERE prod-composto.it-codigo-filho = c-itComposto NO-LOCK.

        FOR EACH b-tt-itensPedido OF ped-venda NO-LOCK:

            IF b-tt-itensPedido.it-codigo = prod-composto.it-codigo-filho THEN NEXT.

            FOR EACH bprod-composto
                WHERE bprod-composto.it-codigo-pai   = prod-composto.it-codigo-pai 
                  AND bprod-composto.it-codigo-filho = b-tt-itensPedido.it-codigo NO-LOCK .

                FIND FIRST tt-composto
                    WHERE  tt-composto.it-codigo = bprod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-composto THEN DO:
                    CREATE tt-composto.
                    ASSIGN tt-composto.it-codigo    = bprod-composto.it-codigo-filho
                           tt-composto.qt-log-aloca = b-tt-itensPedido.qt-log-aloca.
                END. /* IF NOT AVAIL tt-composto THEN DO: */

            END. /* FIND FIRST bprod-composto */

        END. /* FOR EACH b-tt-itensPedido OF ped-venda NO-LOCK: */

    END. /* FOR EACH prod-composto WHERE prod-composto.it-codigo-filho = c-itComposto NO-LOCK. */

    FOR EACH tt-composto:
        ASSIGN de-qt-log-aloca = de-qt-log-aloca + tt-composto.qt-log-aloca.
        DELETE tt-composto.
    END.

END PROCEDURE.
/************************************************************************/

PROCEDURE pi-CRIA-ITENS:
     
    /* Grava a quantidade original, no caso de erro o undo n desfaz a temp-table com no-undo */
    FOR EACH tt-itensPedido:
        ASSIGN tt-itensPedido.qt-atendida-old = tt-itensPedido.qt-atendida.        
    END.

    /* Bloco a ser repetido para cada item da nota */
    bloco-cria-item:
    FOR EACH tt-itensPedido EXCLUSIVE-LOCK,
        FIRST ped-item NO-LOCK
        WHERE ped-item.nome-abrev    = tt-itensPedido.nome-abrev  
          and ped-item.nr-pedcli     = tt-itensPedido.nr-pedcli   
          and ped-item.nr-sequencia  = tt-itensPedido.nr-sequencia
          and ped-item.it-codigo     = tt-itensPedido.it-codigo   
          and ped-item.cod-refer     = tt-itensPedido.cod-refer :
        
        IF ped-item.qt-pedida = ped-item.qt-atendida THEN NEXT.

        FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM 
        THEN DO:
            assign c-it-codigo                   = ped-item.it-codigo                       /* C¢digo do item     */
                   c-cod-refer                   = ped-item.cod-refer                       /* Referància do item */
                   de-vl-preori-ped              = ped-item.vl-preori                       /* Preáo unit†rio     */
                   de-val-pct-desconto-tab-preco = ped-item.val-pct-desconto-tab-preco      /* Desconto de tabela */
                   de-per-des-item               = ped-item.per-des-item                    /* Desconto do item   */
                   l-ped-saldo                   = NO.

            /*
            IF ped-item.it-codigo = '4990709' 
            THEN DO:
                ASSIGN de-quantidade = 0.

                FOR EACH int-ped-item-pai
                    WHERE int-ped-item-pai.nome-abrev    = ped-item.nome-abrev  
                      AND int-ped-item-pai.nr-pedcli     = ped-venda.nr-pedcli
                      AND int-ped-item-pai.nr-sequencia  = 10
                      AND int-ped-item-pai.it-codigo     = ped-item.it-codigo   
                      AND int-ped-item-pai.cod-refer     = ped-item.cod-refer  NO-LOCK:
                
                    FOR EACH b-int-ped-item-pai
                        WHERE b-int-ped-item-pai.nome-abrev     = ped-item.nome-abrev  
                          AND b-int-ped-item-pai.nr-pedcli      = ped-venda.nr-pedcli
                          AND b-int-ped-item-pai.nr-sequencia   = 10
                          AND b-int-ped-item-pai.it-codigo     <> ped-item.it-codigo   
                          AND b-int-ped-item-pai.cod-refer      = ped-item.cod-refer  
                          AND b-int-ped-item-pai.it-codigo-pai  = int-ped-item-pai.it-codigo-pai  NO-LOCK :
                
                        FIND FIRST prod-composto
                             WHERE prod-composto.it-codigo-pai   = b-int-ped-item-pai.it-codigo-pai 
                               AND prod-composto.it-codigo-filho = b-int-ped-item-pai.it-codigo NO-LOCK NO-ERROR.
                        IF AVAIL prod-composto 
                        THEN DO:
                            FOR EACH b-tt-itensPedido
                               WHERE b-tt-itensPedido.nome-abrev   = ped-item.nome-abrev
                                 AND b-tt-itensPedido.nr-pedcli    = ped-item.nr-pedcli 
                                 AND b-tt-itensPedido.it-codigo    = b-int-ped-item-pai.it-codigo NO-LOCK .

                                IF b-tt-itensPedido.qt-log-aloca <> 0 
                                THEN ASSIGN de-quantidade              = de-quantidade + (prod-composto.qt-filho * b-tt-itensPedido.qt-log-aloca)
                                            tt-itensPedido.qt-atendida = de-quantidade.
                            END.
                        END.
                    END.
                END.

                IF de-quantidade = 0 THEN NEXT. /*Se o item pai nao tem alocacao e ficar zero, nao envia pra BO padrao*/
            END.
            ELSE*/
            DO:
                IF (ITEM.cod-servico = 0 AND item.baixa-estoq = NO) 
                then ASSIGN de-quantidade = tt-itensPedido.qt-pedida - tt-itensPedido.qt-atendida.
                ELSE ASSIGN de-quantidade = tt-itensPedido.qt-log-aloca. /* Quantidade         */
            END.

            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
            
            /* Disponibilizar o registro WT-DOCTO na bodi317sd */
            run localizaWtDocto in h-bodi317sd(input  i-seq-wt-docto,
                                               output l-proc-ok-aux). 
            
            /* Cria um item para nota fiscal. */
            run criaWtItDocto in h-bodi317sd (input rowid(ped-item),
                                              input "ped-item":U,
                                              input 0,
                                              input "":U,
                                              input "":U,
                                              input ?,
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
                   WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK:

                    RUN pi-valida-erro.
                    IF NOT l-elimina-erro THEN DO:
                       FIND FIRST tt-erros
                            WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                       IF NOT AVAIL tt-erros THEN DO:
                           CREATE tt-erros.
                           BUFFER-COPY RowErrors TO tt-erros.
                           ASSIGN tt-erros.ErrorDescription = STRING(TIME,"HH:MM:SS") + "-" + ped-item.it-codigo + STRING(RowErrors.ErrorNumber) + ' PRIMEIRO - ' + tt-erros.ErrorDescription.
                       END. /* IF NOT AVAIL tt-erros THEN DO: */
                    END.
                end.
                
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  NOT l-proc-ok-aux THEN DO:
                UNDO bloco-cria-item, LEAVE bloco-cria-item.
            END.
        
            /* Grava informaá‰es gerais para o item da nota */
            run gravaInfGeraisWtItDocto in h-bodi317sd (input i-seq-wt-docto,
                                                        input i-seq-wt-it-docto,
                                                        input de-quantidade,
                                                        input de-vl-preori-ped,
                                                        input de-val-pct-desconto-tab-preco,
                                                        input de-per-des-item).
            
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
            
            FOR EACH tt-ped-saldo NO-LOCK:
                
                IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                            WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                              AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto
                              AND wt-fat-ser-lote.cod-depos         <> tt-ped-saldo.cod-depos) 
                THEN do:
                    ASSIGN l-ped-saldo = YES.
                    LEAVE.
                END.
            END.
            
            IF l-ped-saldo = NO 
            THEN DO:
                IF NOT CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                  AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto) 
                then ASSIGN l-ped-saldo = YES.
            END. 
            
            IF l-ped-saldo = YES THEN DO:
                
                RUN esp/es0018p.p (INPUT "spool-unix":U,
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                 
                FIND FIRST tt-prog-ponto NO-ERROR.
                
                for each wt-fat-ser-lote NO-LOCK
                   WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                     AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                     AND wt-fat-ser-lote.it-codigo         = ped-item.it-codigo:
                end.

                FOR EACH tt-ped-saldo no-lock     
                   where tt-ped-saldo.nome-abrev    = ped-item.nome-abrev       
                     and tt-ped-saldo.nr-pedcli     = ped-item.nr-pedcli       
                     and tt-ped-saldo.nr-seq-item   = ped-item.nr-sequencia       
                     and tt-ped-saldo.it-codigo     = ped-item.it-codigo       
                     and tt-ped-saldo.qt-aloc-ped   > 0.
                
                    FIND FIRST deposito 
                        WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-LOCK NO-ERROR.
                    IF AVAIL deposito 
                    THEN DO:
                        IF deposito.cod-depos     = 'EXP' OR deposito.log-gera-wms  = YES 
                        then ASSIGN c-cod-localizExp = ''.
                        ELSE ASSIGN c-cod-localizExp = tt-ped-saldo.cod-localiz.
                    END. 
                   
                    FIND FIRST wt-fat-ser-lote
                         WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                           AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                           AND wt-fat-ser-lote.it-codigo         = c-it-codigo                                                            
                           AND wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos                                                 
                           AND wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                           AND wt-fat-ser-lote.lote              = IF item.tipo-con-est = 3 THEN tt-ped-saldo.lote ELSE "" NO-LOCK NO-ERROR.
                    IF NOT avail wt-fat-ser-lote THEN DO:
                        create wt-fat-ser-lote.
                        assign wt-fat-ser-lote.lote              = IF item.tipo-con-est = 3 THEN tt-ped-saldo.lote ELSE ""
                               wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos   
                               wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                               wt-fat-ser-lote.quantidade[1]     = tt-ped-saldo.qt-aloc-ped
                               wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                               wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                               wt-fat-ser-lote.qtd-contada[1]    = tt-ped-saldo.qt-aloc-ped
                               wt-fat-ser-lote.it-codigo         = c-it-codigo.
                               //wt-fat-ser-lote.lote              = ped-item.cod-refer.

                    END.
                END.
            END.
            ELSE DO:
                for each wt-fat-ser-lote EXCLUSIVE-LOCK
                   WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                     AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto:

                    FIND FIRST deposito 
                         WHERE deposito.cod-depos = wt-fat-ser-lote.cod-depos NO-LOCK NO-ERROR.
                    IF AVAIL deposito 
                    THEN DO:
                        IF deposito.cod-depos     = 'EXP' OR deposito.log-gera-wms  = YES 
                        then ASSIGN wt-fat-ser-lote.cod-locali = ''.
                    END.
                END.
            END.

            run localizaWtDocto       in h-bodi317pr(input  i-seq-wt-docto,
                                                     output l-proc-ok-aux).
            run localizaWtItDocto     in h-bodi317pr(input  i-seq-wt-docto,
                                                     input  i-seq-wt-it-docto,
                                                     output l-proc-ok-aux).
            run localizaWtItImposto   in h-bodi317pr(input  i-seq-wt-docto,
                                                     input  i-seq-wt-it-docto,
                                                     output l-proc-ok-aux).
            
            /* Atualiza dados c†lculados do item */
            run atualizaDadosItemNota in h-bodi317pr(output l-proc-ok-aux).
                
            /* Busca poss°veis erros que ocorreram nas validaá‰es */
            run devolveErrosbodi317pr in h-bodi317pr(output c-ultimo-metodo-exec,
                                                     output table RowErrors).
            
            
            FIND FIRST deposito 
                WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-LOCK NO-ERROR.
            IF AVAIL deposito AND deposito.log-gera-wms  = YES 
            THEN DO:
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
            if  avail RowErrors 
            then 
                for each RowErrors
                   WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK:

                    RUN pi-valida-erro.
                    IF NOT l-elimina-erro THEN DO:
                       FIND FIRST tt-erros
                           WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                       IF NOT AVAIL tt-erros THEN DO:
                           CREATE tt-erros.
                           BUFFER-COPY RowErrors TO tt-erros.
                           ASSIGN tt-erros.ErrorDescription = STRING(TIME,"HH:MM:SS") + "-" + ped-item.it-codigo + STRING(RowErrors.ErrorNumber) + ' SEGUNDO - ' + tt-erros.ErrorDescription.
                       END. /* IF NOT AVAIL tt-erros THEN DO: */
                    END.
                end.
               
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                UNDO bloco-cria-item , LEAVE bloco-cria-item.
            END.

            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
            
            /* Valida informaá‰es do item */
            run validaItemDaNota      in h-bodi317va(input  i-seq-wt-docto,
                                                     input  i-seq-wt-it-docto,
                                                     output l-proc-ok-aux).
            
            /* Busca poss°veis erros que ocorreram nas validaá‰es */
            run devolveErrosbodi317va in h-bodi317va(output c-ultimo-metodo-exec,
                                                     output table RowErrors).
            
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors no-lock no-error.

            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK:
                    FIND FIRST tt-erros
                         WHERE tt-erros.ErrorNumber = RowErrors.ErrorNumber NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-erros THEN DO:
            
                        IF RowErrors.ErrorDescription MATCHES("*IPI*") THEN NEXT.

                        RUN pi-valida-erro.
                        IF NOT l-elimina-erro THEN DO:
                           CREATE tt-erros.
                           BUFFER-COPY RowErrors TO tt-erros.
                           ASSIGN tt-erros.ErrorDescription = STRING(TIME,"HH:MM:SS") + "-" + ped-item.it-codigo + ' TERCEIRO - ' + tt-erros.ErrorDescription.
                        END.
                    END. /* IF NOT AVAIL tt-erros THEN DO: */
                end.
            
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                UNDO bloco-cria-item, LEAVE bloco-cria-item.
            END.
            
            for first ped-ent
                where ped-ent.nome-abrev   = ped-venda.nome-abrev
                  and ped-ent.nr-pedcli    = ped-venda.nr-pedcli
                  and ped-ent.nr-sequencia = ped-item.nr-sequencia
                  and ped-ent.it-codigo    = ped-item.it-codigo
                  and ped-ent.cod-refer    = ped-item.cod-refer no-lock,
                 each wt-it-docto 
                where wt-it-docto.seq-wt-docto    = i-seq-wt-docto
                  and wt-it-docto.seq-wt-it-docto = i-seq-wt-it-docto
                  and wt-it-docto.it-codigo       = ped-ent.it-codigo exclusive-lock:
                assign wt-it-docto.nr-entrega     = ped-ent.nr-entrega
                       wt-it-docto.quantidade[2]  = wt-it-docto.quantidade[1].
            end.
        end.
    end. /* ped-item */

    FIND FIRST tt-itensPedido NO-LOCK NO-ERROR.
    RELEASE tt-itensPedido.

    FIND FIRST ped-item NO-LOCK NO-ERROR.
    RELEASE ped-item.

    /* Finalizaá∆o das BOS utilizada no c†lculo */
    IF  VALID-HANDLE (h-bodi317in) THEN
        RUN finalizaBOS in h-bodi317in. /* Finalizaá∆o das BOS utilizada no c†lculo */

    IF VALID-HANDLE(h-bodi317in) THEN DO:
       run destroy in h-bodi317in.
       ASSIGN h-bodi317in = ?.
    END.  /* if  valid-handle(h-bodi317in) then do */                 
END PROCEDURE.

PROCEDURE pi-move-xml-diretorio-neogrid:
    /* ----------------------------------------------------------------------------------------------- */
    /* MOVER DO DIRETÖRIO TEMPORÊRIO ONDE O XML ESTÊ PARA O DIRETÖRIO DE CONSUMO DO NEOGRID.           */
    /* ESTE PROCEDIMENTO » NECESSÊRIO PORQUE SÖ DEPOIS DA TRANSA∞ÄO DE CRIA∞ÄO DA NOTA SER FINALIZADA, */
    /* » QUE SE PODERÊ GERAR ENVIAR O XML PARA SEFAZ.                                                  */       
    /* ------------------------------------------------------------------------------------------------*/
    DEF VAR c-dir-DE           AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-dir-PARA         AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-nome-xml         AS CHAR FORMAT "x(200)" NO-UNDO.
    DEF VAR i-err-status       AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "cdapi590",                               
                       INPUT 1, /* Ponto do programa - DiretΩrio DE CONSUMO   */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto). 
    FIND FIRST tt-prog-ponto.

    IF  AVAIL tt-prog-ponto THEN DO:
        /*************************** DIRETÖRIO TEMPORÊRIO *************************/
        ASSIGN c-dir-DE   = tt-prog-ponto.conteudo + "/TMP/OUT".

        /************************* DIRETÖRIO NEOGRID OFICIAL **********************/
        ASSIGN c-dir-PARA = tt-prog-ponto.conteudo.  
    END.

    IF  TRIM(c-dir-PARA) = "" OR TRIM(c-dir-PARA) = "" THEN 
        RETURN.

    FOR EACH tt-notas-geradas:
        FIND nota-fiscal NO-LOCK
            WHERE ROWID(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal NO-ERROR.

        IF  AVAIL nota-fiscal THEN DO:
            
            FOR FIRST integr-totvs-colab NO-LOCK
                WHERE integr-totvs-colab.cod-edi = "170"    /* Tipo de Fluxo*/
                  AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro /* Chave de acesso da nota */
                  AND integr-totvs-colab.cod-msg  MATCHES "*.xml*" :
                
                  RUN pi-devolve-xml (INPUT integr-totvs-colab.cod-msg,
                                      OUTPUT c-nome-xml).
            END.

            IF  TRIM(c-nome-xml) <> "" THEN DO:
                ASSIGN c-dir-DE   = c-dir-DE   + "/"     + c-nome-xml.
                       c-dir-PARA = c-dir-PARA + "/OUT/" + c-nome-xml.

                OS-COPY VALUE(c-dir-DE) VALUE(c-dir-PARA).
                
                OS-DELETE VALUE(c-dir-DE).
            END.
        END.
    END.
END.


PROCEDURE pi-devolve-xml:

    DEF INPUT PARAM p-msg AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-nome-xml AS CHAR NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.

    DO  i = 1 TO NUM-ENTRIES (p-msg, " "):

        IF  ENTRY(i, p-msg, " ") MATCHES "*.xml*" THEN DO:
            ASSIGN p-nome-xml = ENTRY(i, p-msg, " ").
            LEAVE.
        END.
    END.

END.

PROCEDURE pi-valida-erro:

    ASSIGN l-elimina-erro = NO.

    IF RowErrors.ErrorNumber = 17459 THEN DO:
        IF CAN-FIND(FIRST tt-prog-ponto2
                    WHERE tt-prog-ponto2.conteudo = ped-venda.tp-pedido ) THEN DO: //atendentes loja
            ASSIGN l-elimina-erro = YES.
            ASSIGN l-proc-ok-aux = YES.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-valida-bloqueio-fat.
    DEFINE VAR da-data       AS DATETIME.
    DEFINE VAR da-data-atual AS DATETIME.
        
    DEFINE INPUT  PARAM p-cod-estabel AS CHAR.
    DEFINE INPUT  PARAM p-usuario     AS CHAR.
    
    FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
    
    IF AVAIL bloqueio-fat THEN DO:
        ASSIGN da-data       = DATETIME(bloqueio-fat.dt-bloq-espdp006)
               da-data-atual = DATETIME(TODAY, MTIME).  
    
        IF da-data-atual > da-data THEN DO:
            IF  LOOKUP(p-usuario,bloqueio-fat.usua-espdp006) = 0 
            AND LOOKUP(p-cod-estabel,bloqueio-fat.estab-espdp006)     = 0 THEN DO:
    
                RETURN "NOK".
            END.
        END.
    END.

    RETURN "OK" .

END PROCEDURE.



RETURN "OK".

