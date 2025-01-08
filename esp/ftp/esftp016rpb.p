{include/i-prgvrs.i ESFTP016rpb 2.06.00.002}
/***********************************************************************
**  Programa..: ESP\PDP\ESFTP016RPb.P
**  Autor.....: Rubia Oliveira
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{include/i-rpvar.i}
{method/dbotterr.i}
{utp/ut-glob.i}
{btb/btb008za.i0}
{upc/btb910za-upc.i}
{cdp/cd0666.i} 
{esapi/esapi002tt.i}
{esp/esb/esesb000.i}
{utp/utapi019.i}        /* Definiá∆o de temp-tables do email */
{esp/es0018.i}

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

def new global shared var v_cod-deposESPDP006   like deposito.cod-depos no-undo.

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
    field Localizacao   LIKE saldo-estoq.cod-localiz 
    .

define temp-table tt-digita NO-UNDO
    field nome-abrev     LIKE ped-venda.nome-abrev
    field nr-pedcli      LIKE ped-venda.nr-pedcli 
    field c-it-codigo    LIKE ped-item.it-codigo
    field c-cod-refer    LIKE ped-item.cod-refer
    field i-nr-sequencia LIKE ped-item.nr-sequencia
    .

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


FOR EACH tt-param.
    DELETE tt-param.
END.

FOR EACH tt-digita.
    DELETE tt-digita.
END.

create tt-param.
raw-transfer raw-param to tt-param.
ASSIGN tt-param.arquivo = "esftp016rpPedSel_UNIX.tmp".

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
PUT 'entrando esftp016rpb ' SKIP.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEFINE VARIABLE da-data-atual   AS DATE        NO-UNDO.
DEFINE VARIABLE da-data         AS DATE        NO-UNDO.
DEFINE VARIABLE cReturn         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ativa-log     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-embarque      AS LOGICAL   INIT NO            NO-UNDO.
DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-erro-critico  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-entrou        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-qt-a-alocar  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vNrOrdem        AS INTEGER     NO-UNDO.
DEFINE VARIABLE vMsgErro        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qt-saldo-exp-geral AS DECIMAL                NO-UNDO.
DEFINE VARIABLE vQtAlocar       LIKE ped-item.qt-pedida         NO-UNDO.
DEFINE VARIABLE vQtAlocada      AS INTEGER FORMAT '->>>,>>>,>99.99'         NO-UNDO.
DEFINE VARIABLE c_cod_estab_usuar     AS CHARACTER              NO-UNDO.
DEFINE VARIABLE vQtTransferida        AS   INTEGER              NO-UNDO.
DEFINE VARIABLE de-qt-saldo     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qt-a-alocar-astec AS DECIMAL                 NO-UNDO.
DEFINE VARIABLE l-reserva       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cotas         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-parc          AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-valor        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-total-alocado AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-total         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-usb           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE qt-log-alocaComposto2 LIKE ped-item.qt-log-aloca NO-UNDO.
DEFINE VARIABLE c-mesgitem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-peso          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-ped-saldo     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cod-localizExp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE nr-PedExec      LIKE fat-comercial.num-ped-exec   NO-UNDO.
DEF TEMP-TABLE tt-PedidosFaturaveis  NO-UNDO       LIKE ped-venda
    FIELD c-mensagemErro    AS CHARACTER. 
DEF TEMP-TABLE tt-notaFiscaisGeradas NO-UNDO       LIKE nota-fiscal.
DEF TEMP-TABLE tt-fatCom             NO-UNDO       LIKE fat-comercial
    FIELD oldNota AS CHAR.
define temp-table tt-param-aval no-undo
    field nr-pedido     like ped-venda.nr-pedido
    field param-aval    as integer
    field cod-sit-aval  as integer
    field embarque      as logical
    field efetiva       as logical
    field retorna       as logical
    field reavalia-forc as logical
    field vl-a-avaliar  as decimal
    field saldo-lim     as decimal
    field usuario       as character
    field programa      as character
    index codigo is unique primary nr-pedido.
define temp-table tt-erros-aval no-undo
    field cod-emitente as integer
    field cd-erro      as integer
    index codigo is unique primary cod-emitente cd-erro.
/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
def temp-table tt-notas-geradas no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis
    field seq-wt-docto   like wt-docto.seq-wt-docto.
DEF TEMP-TABLE tt-itensPedido        NO-UNDO       LIKE ped-item. 
DEF TEMP-TABLE tt-ped-saldo          NO-UNDO       LIKE ped-saldo.
DEF NEW GLOBAL SHARED TEMP-TABLE tt-PedSaldoShared NO-UNDO LIKE ped-saldo.
DEF TEMP-TABLE tt-composto                  NO-UNDO
    FIELD it-codigo                         LIKE ITEM.it-codigo
    FIELD qt-log-aloca                      LIKE ped-item.qt-log-aloca.
DEFINE TEMP-TABLE tt-AtuErro  NO-UNDO LIKE tt-erro.

def buffer bFatCom            for fat-comercial.
def buffer bnota              for nota-fiscal.
def buffer bped-item          for ped-item.
def buffer bped-venda         for ped-venda.
def buffer b-tt-itensPedido   for tt-itensPedido.
def buffer bsaldo-estoq       for saldo-estoq.
def buffer b-PedItem          FOR ped-item.
def buffer b-int-ped-item-pai FOR int-ped-item-pai.


DEFINE VARIABLE h-esapi018 AS HANDLE      NO-UNDO.

{upc/pd4000k-upce.i}

{esp/trgw/wdi159.i}

FOR EACH tt-ped-saldo.
    DELETE tt-ped-saldo.
END.

FOR EACH tt-PedSaldoShared.
    DELETE tt-PedSaldoShared.
END.

/***************************************************************************************/
    ASSIGN da-data-atual = DATETIME(TODAY, MTIME)
           l-ativa-log   = NO. 
    IF l-ativa-log THEN PUT 'INICIO' SKIP.
    
    FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
    IF AVAIL bloqueio-fat THEN DO:
        ASSIGN da-data =  DATETIME(bloqueio-fat.dt-bloq-espdp006). 
        IF da-data-atual > da-data 
            AND LOOKUP(v_cod_usuar_corren,bloqueio-fat.usua-espdp006) = 0 THEN DO:

            PUT "Bloqueado para Faturamento a partir de " + string(da-data) + " Horas ".
            ASSIGN cReturn = "NOK".                
            RETURN NO-APPLY.  
        END.
    END. /* IF AVAIL bloqueio-fat THEN DO: */
    
    IF l-ativa-log THEN PUT 'antes piSeleciona ' l-erro SKIP.

    RUN piSeleciona.

    PUT SKIP(3)
        '---------------------------------------------------------------------------------------------------------------------------------------------------------' SKIP
        'Ped Cli FAT  Mensagem   ' SKIP
        '------------ --------------------------------------------------------------------------------------------------------------------------------------------' SKIP.
    /******************** Faturamento dos pedidos */
    FOR EACH tt-PedidosFaturaveis NO-LOCK:

        IF l-ativa-log THEN PUT 'FATCOM tt-PedidosFaturaveis.nr-pedcli ' tt-PedidosFaturaveis.nr-pedcli SKIP.
        ASSIGN l-embarque = NO
               c-mensagem = ''.
               l-erro     = IF tt-PedidosFaturaveis.c-mensagemErro <> '' THEN YES ELSE NO.

        IF  l-erro      = NO
        AND l-embarque  = NO THEN DO:
            DO TRANSACTION ON ERROR UNDO, LEAVE:
                IF l-ativa-log THEN PUT 'antes pifaturapedido' SKIP.
                RUN pi-faturaPedido.
            END. /* DO TRANSACTION ON ERROR UNDO, LEAVE: */
        END. /* IF l-erro = NO THEN DO: */

        
        IF NOT CAN-FIND(FIRST tt-notaFiscaisGeradas
                        WHERE tt-notaFiscaisGeradas.nr-pedcli = tt-PedidosFaturaveis.nr-pedcli ) THEN DO:
            FIND FIRST ped-venda WHERE ped-venda.nr-pedido = tt-PedidosFaturaveis.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL ped-venda THEN DO:
                FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            
                ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori <> ? THEN 
                                                  int-ped-venda.cod-priori /*Volta para a prioridade original do pedido*/
                                              ELSE 01.
            END.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            RELEASE ped-venda.
        END.

        IF l-erro = YES THEN DO:

            FIND FIRST ped-venda WHERE ped-venda.nr-pedido = tt-PedidosFaturaveis.nr-pedido EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ped-venda THEN DO:
                FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

                ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori <> ? THEN 
                                                  int-ped-venda.cod-priori /*Volta para a prioridade original do pedido*/
                                              ELSE 01.

/*                 FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK,                         */
/*                     FIRST tt-itensPedido                                               */
/*                     WHERE tt-itensPedido.nome-abrev   =  ped-item.nome-abrev           */
/*                       AND tt-itensPedido.nr-pedcli    =  ped-item.nr-pedcli            */
/*                       AND tt-itensPedido.nr-sequencia =  ped-item.nr-sequencia         */
/*                       AND tt-itensPedido.it-codigo    =  ped-item.it-codigo            */
/*                       AND tt-itensPedido.cod-refer    =  ped-item.cod-refer   NO-LOCK: */
/*                                                                                        */
/*                     ASSIGN ped-item.qt-log-aloca = tt-itensPedido.qt-log-aloca         */
/*                            ped-item.qt-atendida  = tt-itensPedido.qt-atendida.         */
/*                                                                                        */
/*                 END. /* FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK: */              */
/*                 FIND CURRENT ped-item NO-LOCK NO-ERROR.                                */
/*                 RELEASE ped-item.                                                      */

            END.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            RELEASE ped-venda.

        END. /* IF l-erro = YES THEN DO: */
        ELSE DO:

            FIND FIRST ped-venda WHERE ped-venda.nr-pedido = tt-PedidosFaturaveis.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            
            IF AVAIL ped-venda AND ped-venda.cod-sit-ped = 2 THEN DO:
                ASSIGN ped-venda.cod-priori = fnAlteraPrioridadeFaturamentoParcial (ped-venda.nr-pedido,   
                                                                                    ped-venda.cod-sit-ped, 
                                                                                    01).                   
                    
                FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
                    ASSIGN ped-item.qt-log-aloca = 0.
                END. /* FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK: */
                FIND CURRENT ped-item NO-LOCK NO-ERROR.
                RELEASE ped-item.

            END.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            RELEASE ped-venda.
        END.

        IF l-ativa-log THEN PUT 'FATCOM1 ' nr-PedExec ' ' l-erro ' ' c-mensagem SKIP.
        FIND LAST bFatCom
            WHERE  bFatCom.num-ped-exec    = nr-PedExec
              AND  bFatCom.nr-pedcli       = string(tt-PedidosFaturaveis.nr-pedido)  EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bFatCom THEN DO:
            ASSIGN bFatCom.c-status        = IF c-mensagem <> '' THEN c-mensagem ELSE tt-PedidosFaturaveis.c-mensagemErro.
        END.
        FIND CURRENT bFatCom NO-LOCK NO-ERROR.
        RELEASE bFatCom.

        IF c-mensagem <> '' THEN DO:
            PUT tt-PedidosFaturaveis.nr-pedido        AT 01
                trim(c-mensagem)    FORMAT  'X(150)'  AT 14 SKIP.
            ASSIGN c-mensagem = ''.
        END.
        

    END. /* FOR EACH tt-PedidosFaturaveis: */
    /******************** Atualiza notas geradas  */

    /* Mostrar as notas geradas */
    FOR EACH tt-notaFiscaisGeradas no-lock:

        FIND FIRST nota-fiscal 
            WHERE nota-fiscal.cod-estabel = tt-notaFiscaisGeradas.cod-estabel
              AND nota-fiscal.serie       = tt-notaFiscaisGeradas.serie      
              AND nota-fiscal.nr-nota-fis = tt-notaFiscaisGeradas.nr-nota-fis
            NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:

            /** gera TXT e XML - MAUAL **/
            CREATE tt-ft0910.
            ASSIGN tt-ft0910.usuario           = ""
                   tt-ft0910.arquivo           = "espdp006rpPedSel.txt"
                   tt-ft0910.destino           = 2
                   tt-ft0910.data-exec         = TODAY
                   tt-ft0910.hora-exec         = TIME
                   tt-ft0910.cod-estabel       = nota-fiscal.cod-estabel
                   tt-ft0910.serie             = nota-fiscal.serie
                   tt-ft0910.nr-nota-fis-ini   = nota-fiscal.nr-nota-fis
                   tt-ft0910.nr-nota-fis-fim   = nota-fiscal.nr-nota-fis
                   tt-ft0910.nome-ab-cli-ini   = ""
                   tt-ft0910.nome-ab-cli-fim   = "ZZZZZZZZZZZZZ"
                   tt-ft0910.dt-emis-nota-ini  = 01/01/1900
                   tt-ft0910.dt-emis-nota-fim  = 12/31/2099
                   tt-ft0910.gera-nfe-n-gerada = YES
                   tt-ft0910.gera-nfe-gerada   = YES
                   tt-ft0910.exporta-est-txt   = YES
                   tt-ft0910.gera-nfe-cancel   = YES
                   tt-ft0910.gera-nfe-inut     = YES
                   tt-ft0910.c-motivo          = "".

            raw-transfer tt-ft0910 to raw-param.
            RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-ft0910).
            run esp/ftp/esft067rp.p (input nota-fiscal.cod-estabel,
                                 input 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').

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
                                   tt-fatCom.c-STATUS     = ''
                                   tt-fatCom.oldNota      = fat-comercial.nr-nota-fis.
                        END. /* IF NOT AVAIL tt-fatCom THEN DO: */

                    END. /* IF bnota.nr-pedcli = fat-comercial.nr-pedcli THEN DO: */

                END. /* IF AVAIL bnota THEN DO: */

            END. /* IF AVAIL fat-comercial THEN DO: */

            FIND FIRST ped-venda WHERE ped-venda.nr-pedido = nota-fiscal.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL ped-venda AND ped-venda.cod-sit-ped = 2 THEN 
                ASSIGN ped-venda.cod-priori = fnAlteraPrioridadeFaturamentoParcial (ped-venda.nr-pedido,   
                                                                                    ped-venda.cod-sit-ped, 
                                                                                    01).                   

        end. /* IF AVAIL nota-fiscal THEN DO: */

    end. /* FOR EACH tt-notaFiscaisGeradas no-lock: */
    /******************** Atualiza notas geradas */
    
    PUT 'saindo esftp016rpb ' SKIP.
    {include/i-rpclo.i}

    RETURN "OK".

/* **********************  Internal Procedures  *********************** */
PROCEDURE piSeleciona:

    IF l-ativa-log THEN PUT "Log Ativado " TODAY STRING(TIME,"HH:MM:SS") SKIP.

    ASSIGN nr-PedExec = 0.

    FOR EACH fat-comercial
        WHERE fat-comercial.nr-sequencia = 99 EXCLUSIVE-LOCK:

        ASSIGN nr-PedExec = fat-comercial.num-ped-exec.
        IF l-ativa-log THEN PUT "fat-comercial " fat-comercial.nr-pedcli nr-PedExec SKIP.

        FOR EACH ped-venda EXCLUSIVE-LOCK 
            WHERE ped-venda.nr-pedcli  = fat-comercial.nr-pedcli
              AND ped-venda.nome-abrev = fat-comercial.nome-abrev,
               FIRST emitente NO-LOCK 
               WHERE emitente.cod-emitente  = ped-venda.cod-emitente
               AND  (emitente.ind-lib-estoq = YES OR 
                     ped-venda.cod-sit-aval = 3   OR 
                     ped-venda.mo-codigo <> 0),
               FIRST repres NO-LOCK
               WHERE repres.nome-abrev = ped-venda.no-ab-reppri ,
               first atendente NO-LOCK
               WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
           BY ped-venda.dt-emissao
           BY ped-venda.nr-pedido :

            IF l-ativa-log THEN PUT " 1 pedido " ped-venda.nr-pedido " " ped-venda.cod-sit-ped " " ped-venda.completo " " ped-venda.cod-priori SKIP.

            IF ped-venda.cod-sit-ped  > 2   THEN NEXT.
            IF ped-venda.completo     = NO  THEN NEXT.
            IF ped-venda.cod-priori  <> 09  THEN NEXT.

            IF l-ativa-log THEN PUT "pedido validacoes iniciais" ped-venda.nr-pedido SKIP.

            ASSIGN fat-comercial.nr-sequencia = 10.

            ASSIGN l-embarque = NO
                   c-mensagem = ''
                   c-mensagem = 'Pedido ' + ped-venda.nr-pedcli + ' liberado'
                   l-erro     = NO.

            IF fat-comercial.tipo = 2 THEN DO: /* Ped-Selc por usu†rio */
                IF l-ativa-log THEN PUT "Pedidos selecionados" ped-venda.nr-pedido " / " ped-venda.cod-estabel SKIP.
                FIND FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                    AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
                IF AVAIL int-ped-venda THEN DO:
                    IF l-ativa-log THEN PUT "USUARIO " trim(SUBSTRING(int-ped-venda.char-1,250,15)) " ? " tt-param.usuario SKIP.
                    IF trim(SUBSTRING(int-ped-venda.char-1,250,15)) <> tt-param.usuario THEN DO:

                            FIND FIRST ponto-programa NO-LOCK
                                WHERE ponto-programa.nome-programa = "espdp006"
                                  AND ponto-programa.ponto         = 14 NO-ERROR.
                            IF AVAIL ponto-programa THEN DO:
                                IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                          AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                                    assign l-erro = yes
                                           c-mensagem = "Usuario diferente DO que selecionou este pedido, ou nao gerencial".
                                    NEXT.
                                END.
                            END.

                    END.
                END. /* IF AVAIL int-ped-venda THEN DO: */
            END.
            ELSE
                IF l-ativa-log THEN PUT "TODOS USUARIOS " SKIP.

            IF l-erro = NO THEN DO:
                FOR EACH ped-item OF ped-venda 
                    where ped-item.cod-sit-item <= 2 NO-LOCK:

                    IF ped-item.qt-pedida = ped-item.qt-atendida THEN NEXT.

                    IF ped-item.qt-log-aloca = 0 THEN DO:
                        IF ped-item.it-codigo <> '4990709' THEN NEXT.

                        FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                        IF AVAIL ITEM AND ITEM.cod-servico = 0 AND item.baixa-estoq = YES AND ped-item.it-codigo <> '4990709' THEN NEXT.
                    END.
                    IF l-ativa-log THEN PUT "ITEM " ped-item.it-codigo SKIP.

                    FIND FIRST int-ped-item EXCLUSIVE-LOCK
                        WHERE int-ped-item.nome-abrev      = ped-venda.nome-abrev  
                        AND   int-ped-item.nr-pedcli       = ped-venda.nr-pedcli        
                        AND   int-ped-item.nr-sequencia    = ped-item.nr-sequencia     
                        AND   int-ped-item.it-codigo       = ped-item.it-codigo        
                        AND   int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
                    IF NOT AVAIL int-ped-item  THEN DO:
                        CREATE int-ped-item.
                        ASSIGN int-ped-item.nome-abrev      = ped-venda.nome-abrev   
                               int-ped-item.nr-pedcli       = ped-venda.nr-pedcli    
                               int-ped-item.nr-sequencia    = ped-item.nr-sequencia     
                               int-ped-item.it-codigo       = ped-item.it-codigo        
                               int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
                    END.

                    FIND FIRST int-ped-venda
                        WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel 
                        EXCLUSIVE-LOCK NO-ERROR.  
                    /*Integra com programa de canais via msg0091.p os pedidos que tiveram quantidade alocada*/
                    IF  AVAIL int-ped-venda THEN DO:

                        RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                                           INPUT 1,         /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                         FIND FIRST tt-prog-ponto 
                              WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

                        FIND FIRST int-emitente NO-LOCK
                            WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
                        IF  AVAIL ped-venda
                        AND AVAIL int-emitente 
                        AND int-emitente.ind-participa-canais  = 993520001 
                        AND AVAIL tt-prog-ponto THEN DO:

                            RAW-TRANSFER ped-venda TO raw-param.
                            RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                    INPUT        raw-param, /* Tupla do registro */
                                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.            
                        END.

                        OVERLAY(int-ped-venda.char-1,66,1) = "0".
                    END.

                    IF l-ativa-log THEN PUT "Passo 12 ASTEC " l-erro " / " trim(ped-item.it-codigo) SKIP.
                    RUN piAtualizaAstec (INPUT de-qt-a-alocar-astec).
                    IF l-ativa-log THEN PUT "Passo 13a ASTEC " l-erro " / " trim(ped-item.it-codigo)  SKIP.
                    run LiberaParaFaturamento.   
                    IF l-ativa-log THEN PUT "Passo 13bb ASTEC " l-erro " / " trim(ped-item.it-codigo)  SKIP.

                END. /* FOR EACH ped-item OF ped-venda where ped-item.cod-sit-item <= 2 NO-LOCK: */
            END. /* IF l-erro = NO THEN DO: */

            IF c-mensagem <> '' THEN DO:

                IF l-ativa-log THEN PUT 'FATCOM2' SKIP.
                ASSIGN fat-comercial.c-status        = c-mensagem.

                PUT SKIP(1)
                   'Ped Cli      Mensagem' SKIP
                   '------------ --------------------------------------------------------------------------------------------------------------------------------------------' SKIP
                   ped-venda.nr-pedido                    AT 01
                   c-mensagem          FORMAT  'X(150)'   AT 14 SKIP(2).
            END. /* IF c-mensagem <> '' THEN DO: */

            IF l-erro-critico THEN DO:
                IF l-ativa-log THEN PUT "Passo 16 " c-mensagem FORMAT  'X(150)' SKIP.
                UNDO, NEXT.
            END.

            IF  l-erro = YES THEN DO:
                IF  NOT AVAIL int-ped-venda  THEN
                    FIND FIRST int-ped-venda NO-LOCK
                        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                
                IF  AVAIL int-ped-venda THEN
                    ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori <> ? THEN 
                                                      int-ped-venda.cod-priori /*Volta para a prioridade original do pedido*/
                                                  ELSE 
                                                      01.
            END. 

        END. /* FOR EACH ped-venda EXCLUSIVE-LOCK  */
        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        RELEASE ped-venda.

    END. /* FOR EACH fat-comercial */
    FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
    RELEASE fat-comercial.

END PROCEDURE. /* piSeleciona */


procedure LiberaParaFaturamento: /* Mesma rotina do espdp006.w botao libera para faturamento */

    FIND int-emitente WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente and
       emitente.cod-gr-cli <> 8 AND
       emitente.cod-gr-cli <> 9 and
       emitente.cod-gr-cli <> 10 and
       emitente.cod-gr-cli <> 15 and
       emitente.cod-gr-cli <> 16 AND
       ped-venda.nat-operacao <> "694924" AND
       ped-venda.nat-operacao <> "594934" THEN DO:
        IF AVAILABLE int-emitente     AND
           NOT int-emitente.id-ativo THEN DO:
           assign l-erro = yes
                  c-mensagem = "Cliente Inativo. Imposs°vel liberar para faturamento".

             IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 1 " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.
           
        END.
    END.

    IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 1a " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.

    FIND natur-oper OF ped-venda NO-LOCK.
    IF AVAIL natur-oper THEN DO:
       IF natur-oper.emite-duplic THEN DO:

            ASSIGN i-parc               = 1
                   de-valor             = 0
                   de-vl-total          = 0
                   de-vl-total-alocado  = 0.
            
            FIND FIRST pd-vendor OF Ped-venda NO-LOCK NO-ERROR.
            IF AVAIL pd-vendor THEN DO:
                FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = pd-vendor.cod-cond-cli NO-LOCK NO-ERROR.
                IF AVAIL cond-pagto THEN
                    ASSIGN i-parc = cond-pagto.num-parcelas.
            END.
            ELSE DO:
                FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
                IF AVAIL cond-pagto THEN
                    ASSIGN i-parc = cond-pagto.num-parcelas.
            END.
    
            ASSIGN l-usb = NO.

            FOR EACH bPed-item OF Ped-venda NO-LOCK:                    
                ASSIGN qt-log-alocaComposto2 = 0.

                IF bPed-item.it-codigo = '4990709' THEN ASSIGN l-usb = YES.

                IF bped-item.qt-log-aloc <> 0 THEN 
                    ASSIGN qt-log-alocaComposto2 = bped-item.qt-log-aloc.

                ASSIGN de-valor    = de-valor                    + (bped-item.vl-tot-it   / bped-item.qt-pedida    * qt-log-alocaComposto2)                           
                       de-vl-total = de-vl-total                 + (bped-item.qt-pedida   - bped-item.qt-atendida) * bped-item.vl-preuni
                       de-vl-total-alocado = de-vl-total-alocado + (qt-log-alocaComposto2 * bped-item.vl-preuni).

                IF l-ativa-log THEN PUT bPed-item.it-codigo
                                     ' de-vl-total-alocado                           ' de-vl-total-alocado                           
                                     ' qt-log-alocaComposto2                         ' qt-log-alocaComposto2                         
                                     ' bped-item.vl-preuni                           ' bped-item.vl-preuni                           
                                     ' (qt-log-alocaComposto2 * bped-item.vl-preuni) ' (qt-log-alocaComposto2 * bped-item.vl-preuni) SKIP.
            END.
    
            IF l-ativa-log THEN PUT ' i-parc              ' i-parc             
                                    ' de-valor            ' de-valor           
                                    ' de-vl-total         ' de-vl-total        
                                    ' de-vl-total-alocado ' de-vl-total-alocado SKIP.
                                      
       END.
    END.

    IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 2a " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.

    /** Verificaá∆o colocada por Felipe, em 16.07.2007, para liberar pedido APENAS quando o cliente
        estiver com o cadastro de cidade preenchido corretamente **/
    IF NOT CAN-FIND (FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = ped-venda.cod-emitente
          AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
            WHERE mgcad.cidade.pais   = emitente.pais
              AND mgcad.cidade.estado = emitente.estado
              AND mgcad.cidade.cidade = emitente.cidade))
              THEN DO:
        assign l-erro = yes.
               c-mensagem =  "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                                 "Verifique o cadastro do ENDEREÄO DE ENTREGA.".       

    END.
    IF NOT CAN-FIND (FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = ped-venda.cod-emitente
          AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
            WHERE mgcad.cidade.pais   = emitente.pais-cob
              AND mgcad.cidade.estado = emitente.estado-cob
              AND mgcad.cidade.cidade = emitente.cidade-cob))
              THEN DO:
        assign l-erro     = yes
               c-mensagem =  "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                         "Verifique o cadastro do ENDEREÄO DE COBRANÄA.".
    END.
    
    IF NOT CAN-FIND (FIRST loc-entr NO-LOCK
        WHERE loc-entr.nome-abrev  = ped-venda.nome-abrev
          AND loc-entr.cod-entrega = ped-venda.cod-entrega 
          AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
            WHERE mgcad.cidade.pais   = loc-entr.pais
              AND mgcad.cidade.estado = loc-entr.estado
              AND mgcad.cidade.cidade = loc-entr.cidade))
              THEN DO:
        assign l-erro     = yes
               c-mensagem =  "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                         "Verifique o cadastro do LOCAL DE ENTREGA.".
    
    END.

    FIND FIRST int-cond-pagto
        WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
    IF NOT AVAILABLE int-cond-pagto                      OR
       (AVAILABLE int-cond-pagto                         AND
        SUBSTRING(int-cond-pagto.char-1, 4, 1) <> "S":U) THEN DO:
        IF NOT ped-venda.dsp-pre-fat THEN DO:
            assign l-erro     = yes
                   c-mensagem =  "N∆o Ç poss°vel liberar para faturamento,Este pedido n∆o est† liberado para faturamento!".
        END.
    END.    
    /** Fim das verificaá‰es **/
    
    IF  ped-venda.dsp-pre-fat = NO THEN DO:        
        assign l-erro     = yes
               c-mensagem =  "Pedido n∆o est† liberado para faturamento!" + CHR(10) + 
                         "Favor alterar o pedido.".
    END.
    
    IF ped-venda.nome-abrev-tri <> "" THEN DO:        
        assign l-erro-critico = yes
               c-mensagem     =  "Pedido com operaá∆o triangular. Deve ser faturado pelo FT4002!".
    END.
    
    IF ped-venda.dt-entrega > TODAY THEN DO:        
        assign l-erro     = yes
               c-mensagem =  "Item com data Futura".
    END.

    IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 3 " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.

    IF ped-venda.cidade-cif <> "" and
       ( ped-venda.nome-transp = "" OR
         ped-venda.nome-transp = ? /* OR
         ped-venda.cod-rota = "" OR
         ped-venda.cod-rota = ? OR
         ped-venda.dec-1 = 0 OR
         ped-venda.dec-1 = ? */ ) THEN DO:
        assign l-erro     = yes
               c-mensagem = "Pedido n∆o pode ser faturado pois o frete Ç CIF e n∆o existe transportadora definida para o mesmo!".
    END.
    
    IF ped-venda.ind-fat-par = NO THEN DO:
        FOR EACH bPed-item OF ped-venda
                where bPed-item.cod-sit-item <= 2 NO-LOCK:
            IF (bPed-item.qt-pedida - bPed-item.qt-atendida - bPed-item.qt-log-aloca) <> 0 THEN DO:
                IF bPed-item.qt-log-aloca = 0 AND 
                   bPed-item.dt-entrega > TODAY THEN . /* N∆o faz nada */
                ELSE DO:
                    assign l-erro     = yes
                           c-mensagem =  "Este pedido n∆o permite faturamento parcial!".

                END.
            END.
        END.
    END.
        
    IF  emitente.ind-aval-embarque = 1 THEN  do: /* Definido para Canais */
        IF  ped-venda.cod-sit-aval <> 3 THEN DO:
            assign l-erro     = yes
                   c-mensagem =  "Problemas com CrÇdito".
        END. 
    END.
        
    IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 4 - antes Canais " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.

    IF  emitente.ind-aval-embarque <> 1 THEN DO: /* para Canais */

        if   (   emitente.ind-cre-cli  = 1  /* Normal                      */
              or emitente.ind-cre-cli  = 5)  /* Pagamento a Vista           */  
        and emitente.ind-aval-emb > 1        /* Atrasos ou Atrasos + Limite */ 
        and ped-venda.origem <> 9 /* pedidos de bonificaØ o n o avaliam cr˝dito */
        then do:
            create tt-param-aval.
            assign tt-param-aval.nr-pedido    = ped-venda.nr-pedido
                   tt-param-aval.param-aval   = (if emitente.ind-aval-embarque = 2
                                                 then 1
                                                 else 3)
                  tt-param-aval.embarque      = yes
                  tt-param-aval.efetiva       = yes
                  tt-param-aval.retorna       = yes
                  tt-param-aval.reavalia-forc = no
                  tt-param-aval.vl-a-aval     = ped-venda.vl-liq-abe
                  tt-param-aval.usuario       = c-seg-usuario
                  tt-param-aval.programa      = 'eqapi300'.

            run cdp/cdapi013.p (input-output table tt-param-aval,
                                input-output table tt-erros-aval).

            for each tt-param-aval:
                delete tt-param-aval.
            end.

            find first tt-erros-aval no-error.
            if  available(tt-erros-aval) then do:
                assign l-erro     = yes
                       c-mensagem =  "Problemas com AVALIACAO de CrÇdito, Pedido Nao Aprovado".
             
                IF l-ativa-log THEN PUT "LiberaParaFaturamento Canais Passo 1 " c-mensagem FORMAT  'X(150)' SKIP.

                for each tt-erros-aval:
                    delete tt-erros-aval.
                end.
            end.
        end.
     END.

     IF ped-venda.cidade-cif <> "" THEN DO:
    
        ASSIGN c-mesgitem = "Verifique se existe pesos (l°quido/bruto) cadastrados para os seguintes itens:" + CHR(13)
               l-peso = TRUE.

        IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 5 " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.
        
        FOR EACH bPed-item OF ped-venda NO-LOCK:
            FIND FIRST ITEM OF bPed-item NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:
                IF ITEM.peso-bruto = 0 OR 
                   ITEM.peso-bruto = ? OR
                   ITEM.peso-liquido = 0 OR 
                   ITEM.peso-liquido = ? THEN DO:
                    ASSIGN c-mesgitem = c-mesgitem + STRING(ITEM.it-codigo) + " - " + ITEM.desc-item + CHR(13)
                           l-peso = FALSE.
                     IF l-ativa-log THEN PUT "LiberaParaFaturamento  Passo 6 " l-erro " / " c-mesgitem FORMAT  'X(150)' SKIP.
                END.
            END.
        END.
        
        IF l-peso = FALSE THEN DO:
            assign l-erro     = YES 
                   c-mensagem =  c-mesgitem.
             IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 7 " c-mensagem FORMAT  'X(150)' SKIP.
        END.
    END.           
                
    IF l-ativa-log THEN IF c-mensagem <> '' OR l-erro = YES THEN PUT "Erros LiberaParaFaturamento " l-erro " - " c-mensagem FORMAT  'X(150)' SKIP.

    if l-erro = no then do:

        /* Bloco para enviar email aos usu†rios, quando os pedidos faturados forem de determinadas naturezas cadastradas - Incidente 33949 */
        FIND FIRST ponto-programa NO-LOCK
            WHERE  ponto-programa.nome-programa = "espdp006"
            AND    ponto-programa.ponto         = 8 /* Naturezas que dever∆o enviar email */ NO-ERROR.
        IF  AVAIL  ponto-programa THEN DO:
            IF  CAN-FIND(FIRST conteudo-programa NO-LOCK
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                         AND   conteudo-programa.conteudo     = ped-venda.nat-operacao) THEN DO:
                RUN pi-enviar-email IN THIS-PROCEDURE.
            END.
        END.

        IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 9 " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.


        FIND FIRST bped-venda WHERE bped-venda.nome-abrev = ped-venda.nome-abrev AND
                                    bped-venda.nr-pedcli = ped-venda.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bped-venda THEN DO:         
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = bped-venda.nr-pedido
                AND int-ped-venda.cod-estabel = bped-venda.cod-estabel
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL int-ped-venda THEN
                ASSIGN int-ped-venda.mensagem = "Pedido Liberado Para Faturamento".

            IF l-ativa-log THEN PUT "LiberaParaFaturamento Passo 10 " l-erro " / " c-mensagem FORMAT  'X(150)' SKIP.

            IF l-ativa-log THEN PUT "Cria tt-PedidosFaturaveis" SKIP.
            FIND FIRST tt-PedidosFaturaveis
                WHERE tt-PedidosFaturaveis.nr-pedido  = bped-venda.nr-pedido NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-PedidosFaturaveis THEN DO:
                CREATE tt-PedidosFaturaveis.
                BUFFER-COPY bped-venda TO tt-PedidosFaturaveis.
            END. /* IF NOT AVAIL tt-PedidosFaturaveis THEN DO: */

            IF l-ativa-log THEN PUT "Liberou Faturamento " SKIP.

        END.                                  

     END.
     ELSE DO:

         IF l-ativa-log THEN PUT 'Tratando erro - Liberou Faturamento' FORMAT 'X(50)' SKIP. 

         ASSIGN fat-comercial.c-status = c-mensagem.

         IF l-ativa-log THEN PUT 'FIM Tratando erro - Liberou Faturamento' FORMAT 'X(50)' SKIP. 

     END.

end procedure. /* LiberaParaFaturamento */

PROCEDURE pi-enviar-email :
/*------------------------------------------------------------------------------
  Purpose:     Enviar email informando que um Pedido com Material Faltante est†
               sendo liberado.
  Parameters:  <none>
  Notes:       Envia o email para os usu†rios que est∆o cadastrados no ES0018
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-dest     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-texto    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF  NOT AVAIL ped-venda THEN
        RETURN "OK":U.

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp006"
        AND   ponto-programa.ponto         = 9, /* Usu†rio que receber∆o email */
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN c-dest = c-dest + conteudo-programa.conteudo + ";".
    END.

    IF  c-dest = "" THEN
        RETURN "OK":U.

    /* Busca os Itens do Pedido para enviar por email */
    FOR EACH ped-item NO-LOCK:
        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = ped-item.it-codigo NO-ERROR.
        IF  NOT AVAIL item THEN
            NEXT.

        ASSIGN c-texto = c-texto + 
                         STRING(ped-item.it-codigo, "x(20)") + " - " +
                         STRING(item.descricao-1, "x(40)")             +
                         STRING(ped-item.qt-log-aloca, ">>>,>>9.99") +
                         CHR(13).

        IF  l-ativa-log THEN PUT 'c-texto ped-item.qt-log-aloca ' ped-item.qt-log-aloca SKIP.
    END.


    IF  NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "intelbras@intelbras.com.br"
           tt-envio2.destino           = c-dest
           tt-envio2.assunto           = "MATERIAL FALTANTE - Pedido: " + ped-venda.nr-pedcli
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Pedido Liberado para Faturamento."    + CHR(13) +
                                      "Pedido: " + ped-venda.nr-pedcli     + " Cliente: " + ped-venda.nome-abrev + CHR(13) + CHR(13) +
                                      STRING("Item", "x(62)") + "Quantidade" + CHR(13) +
                                      FILL("-", 73)     + CHR(13) +
                                      c-texto + CHR(13) + CHR(13) +
                                      "<E-mail autom†tico. N∆o responda>".

    IF  VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).


    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE retorna-ok:

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piAtualizaAstec:
    DEF INPUT PARAMETER p-de-qt-a-alocar AS DECIMAL.
   
    FOR EACH int-ped-item-astec EXCLUSIVE-LOCK
        WHERE int-ped-item-astec.nome-abrev   = ped-item.nome-abrev
          AND int-ped-item-astec.nr-pedcli    = ped-item.nr-pedcli
          AND int-ped-item-astec.nr-sequencia = ped-item.nr-sequencia
          AND int-ped-item-astec.it-codigo    = ped-item.it-codigo:

        EMPTY TEMP-TABLE RowErrors.

        IF  NOT VALID-HANDLE(h-esapi018)                  OR
            h-esapi018:TYPE      <> "PROCEDURE":U         OR
           (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
            h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
            RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN DO:

                 IF l-ativa-log THEN 
                       PUT "Passo piatualizaastec -> " ped-item.nome-abrev  
                                                       ped-item.nr-pedcli     
                                                       ped-item.nr-sequencia  
                                                       ped-item.it-codigo
                                                       p-de-qt-a-alocar


                     SKIP.

                RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ped-item.nome-abrev,
                                                               INPUT ped-item.nr-pedcli,
                                                               INPUT ped-item.nr-sequencia,
                                                               INPUT ped-item.it-codigo,
                                                               INPUT 1,
                                                               INPUT p-de-qt-a-alocar).

                IF AVAIL ped-item THEN IF l-ativa-log THEN PUT "QtLogAlocada Ped-item  " ped-item.qt-log-aloca " e QtAlocada Ped-item " ped-item.qt-alocada SKIP.

                IF ped-item.qt-log-aloca <> 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                IF ped-item.qt-alocada   <> 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                IF  ped-item.qt-log-aloca = 0 
                AND ped-item.qt-alocada   = 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = 0.

                IF AVAIL int-ped-item-astec THEN IF l-ativa-log THEN PUT "QtAlocadaASTEC " int-ped-item-astec.qt-alocada " e ITEM " int-ped-item-astec.it-codigo SKIP.

                IF RETURN-VALUE = "NOK":U THEN
                    RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    ASSIGN l-erro = YES.

                    FOR EACH RowErrors:
                        IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                        ASSIGN c-mensagem = c-mensagem + " Item " + ped-item.it-codigo + (IF c-mensagem = "":U THEN "":U ELSE CHR(13)) + RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U.

                    END.

                    UNDO, NEXT.
                END.

        END.

        IF VALID-HANDLE(h-esapi018) THEN
            RUN destroy IN h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN
            DELETE PROCEDURE h-esapi018.

        ASSIGN h-esapi018 = ?.

    END. /* FOR EACH int-ped-item-astec NO-LOCK: */

END PROCEDURE.

PROCEDURE pi-faturaPedido:
    /* Definiá∆o da vari†veis */
    def var h-bodi317pr          as handle no-undo.
    def var h-bodi317sd          as handle no-undo.
    def var h-bodi317im1bra      as handle no-undo.
    def var h-bodi317va          as handle no-undo.
    def var h-bodi317in          as handle no-undo.
    def var h-bodi317ef          as handle no-undo.
    def var h-bodi149            as handle no-undo.
    def var l-proc-ok-aux        as log    no-undo.
    def var c-ultimo-metodo-exec as char   no-undo.
    def var c-cod-estabel        as char   no-undo.
    def var c-serie              as char   no-undo.
    def var da-dt-emis-nota      as date   no-undo.
    def var da-dt-base-dup       as date   no-undo.
    def var da-dt-prvenc         as date   no-undo.
    def var c-seg-usuario        as char   no-undo.
    def var c-nome-abrev         as char   no-undo.   
    def var c-nr-pedcli          as char   no-undo.
    def var c-nat-operacao       as char   no-undo.
    def var c-cod-canal-venda    as char   no-undo.
    def var i-seq-wt-docto       as int    no-undo.
    def var i-seq-wt-it-docto             as int    no-undo.
    def var i-cont-itens                  as int    no-undo.
    def var c-it-codigo                   as char   no-undo.
    def var c-cod-refer                   as char   no-undo.
    def var de-quantidade                 as dec    no-undo.
    def var de-vl-preori-ped              as dec    no-undo.
    def var de-val-pct-desconto-tab-preco as dec    no-undo.
    def var de-per-des-item               as dec    no-undo.
    def var l-entregaFutura               as logical INIT NO no-undo.
    def var qt-log-alocaComposto LIKE ped-item.qt-log-aloca NO-UNDO.

    def var c-char-aux           as char   no-undo.
    def var hShowMsg             as handle no-undo.
    def var l-unallocateDelivery as logical no-undo.

    /* Definiá∆o de um buffer para tt-notas-geradas */
    def buffer b-tt-notas-geradas for tt-notas-geradas.

    IF l-ativa-log THEN PUT 'pi-faturaPedido ' l-erro ' ' c-mensagem SKIP.
    FOR EACH tt-itensPedido.
        DELETE tt-itensPedido.
    END.

    IF l-ativa-log THEN PUT 'pi-faturaPedido2 ' l-erro ' ' c-mensagem SKIP.
    /* Inicializaá∆o das BOS para C†lculo */
    run dibo/bodi317in.p persistent set h-bodi317in.
    run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                     output h-bodi317sd,     
                                     output h-bodi317im1bra,
                                     output h-bodi317va).

    IF l-ativa-log THEN PUT 'pi-faturaPedido3 ' l-erro ' ' c-mensagem SKIP.
    run leaveCodEstabel in h-bodi317sd (input  tt-PedidosFaturaveis.cod-estabel,
                                        input  no,
                                        output c-char-aux).

    IF l-ativa-log THEN PUT 'pi-faturaPedido4 ' l-erro ' ' c-mensagem SKIP.
    FIND FIRST ser-estab
        WHERE ser-estab.serie       = c-char-aux  
          AND ser-estab.cod-estabel = tt-PedidosFaturaveis.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ser-estab THEN DO:
        IF ser-estab.dt-ult-fat < TODAY THEN DO:
            FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
            IF AVAIL bloqueio-fat THEN DO:
                IF LOOKUP(ser-estab.cod-estabel,bloqueio-fat.estab-fatcom) = 0 THEN DO:
                    ASSIGN c-mensagem = c-mensagem + CHR(10) + /*" Pedido " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli + */
                                        (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + " Data Èltimo faturamento. "        + 
                                            " Serie: " + ser-estab.serie              + " Estab: " + ser-estab.cod-estabel  +
                                            " Dt. Ult. Fat.: " + STRING(ser-estab.dt-ult-fat,'99/99/9999').
                END.
                ELSE
                    ASSIGN ser-estab.dt-ult-fat = TODAY.
            END. /* IF AVAIL bloqueio-fat THEN DO: */
        END. /* IF ser-estab.dt-ult-fat < TODAY THEN DO: */
    END.
    FIND CURRENT ser-estab NO-LOCK NO-ERROR.
    RELEASE ser-estab.

    IF l-ativa-log THEN PUT 'FATCOM4 ' nr-PedExec ' ' l-erro ' ' c-mensagem SKIP.
    FIND LAST bFatCom
      WHERE  bFatCom.num-ped-exec    = nr-PedExec
        AND  bFatCom.nr-pedcli       = string(tt-PedidosFaturaveis.nr-pedido)  EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bFatCom THEN
        ASSIGN bFatCom.c-status        = IF c-mensagem <> '' THEN c-mensagem ELSE tt-PedidosFaturaveis.c-mensagemErro.
    
    FIND CURRENT bFatCom         NO-LOCK NO-ERROR.
    RELEASE bFatCom.


    IF l-ativa-log THEN PUT 'FATCOM5 ' l-erro ' ' c-mensagem SKIP.
    IF c-mensagem = '' THEN DO:

        FOR EACH ped-item OF tt-PedidosFaturaveis EXCLUSIVE-LOCK:
    
            IF  l-ativa-log THEN PUT 'criando tt-itensPedido ' PED-ITEM.IT-CODIGO " "  ped-item.qt-log-aloca SKIP.
            CREATE tt-itensPedido.
            BUFFER-COPY ped-item TO tt-itensPedido.
            ASSIGN ped-item.qt-log-aloca = 0
                   /*ped-item.qt-alocada   = 0 */ .

            IF  l-ativa-log THEN PUT 'terminando tt-itensPedido ' ped-item.qt-log-aloca SKIP.
        END. /* FOR EACH ped-item OF tt-PedidosFaturaveis EXCLUSIVE-LOCK: */
        IF l-ativa-log THEN PUT 'ENTROU FATCOM6 ' SKIP.
        FIND CURRENT ped-item NO-LOCK NO-ERROR.
        RELEASE ped-item.
        IF l-ativa-log THEN PUT '...'  SKIP.

        IF l-ativa-log THEN PUT 'FATCOM6 ' l-erro ' ' c-mensagem                                    SKIP.
        IF l-ativa-log THEN PUT 'FATCOM6 ' tt-PedidosFaturaveis.cod-estabel                         SKIP.
        IF l-ativa-log THEN PUT 'FATCOM6 ' c-char-aux                                               SKIP.
        IF l-ativa-log THEN PUT 'FATCOM6 ' tt-PedidosFaturaveis.nome-abrev                          SKIP.
        IF l-ativa-log THEN PUT 'FATCOM6 ' tt-PedidosFaturaveis.nr-pedcli                           SKIP.
        IF l-ativa-log THEN PUT 'FATCOM6 ' IF AVAIL ser-estab THEN ser-estab.dt-ult-fat ELSE TODAY  SKIP.
    
        /* Informaá‰es do embarque para c†lculo */
        assign c-cod-estabel     = tt-PedidosFaturaveis.cod-estabel     /* Estabelecimento do pedido  */
               c-serie           = c-char-aux                           /* SÇrie das notas            */
               c-nome-abrev      = tt-PedidosFaturaveis.nome-abrev      /* Nome abreviado do cliente  */
               c-nr-pedcli       = tt-PedidosFaturaveis.nr-pedcli       /* Nr pedido do cliente       */
               da-dt-emis-nota   = IF AVAIL ser-estab THEN ser-estab.dt-ult-fat 
                                   ELSE TODAY                           /* Data de emiss∆o da nota    */
               c-nat-operacao    = ?                                    /* Quando Ç ? busca do pedido */
               c-cod-canal-venda = ?.                                   /* Quando Ç ? busca do pedido */
        
        IF l-ativa-log THEN PUT 'FATCOM6 ' l-erro ' ' c-mensagem SKIP.
        /************************************* ped-saldo */
        FOR EACH ped-saldo no-lock     
          where ped-saldo.nome-abrev    = tt-PedidosFaturaveis.nome-abrev       
            and ped-saldo.nr-pedcli     = tt-PedidosFaturaveis.nr-pedcli .
        
            FIND FIRST tt-ped-saldo
                where tt-ped-saldo.cod-depos   = ped-saldo.cod-depos   
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

                CREATE tt-PedSaldoShared.
                BUFFER-COPY ped-saldo TO tt-PedSaldoShared.
            END. /* IF NOT AVAIL tt-ped-saldo THEN DO: */
        
        END. /* FOR EACH ped-saldo no-lock */
        /************************************* ped-saldo */
        
        IF l-ativa-log THEN PUT 'FATCOM7 ' l-erro ' ' c-mensagem SKIP.
        for each ped-ent of tt-PedidosFaturaveis
            where ped-ent.qt-log-aloca <> 0 no-lock:
    
            assign l-unallocateDelivery = yes.
    
            if  not valid-handle(h-bodi149) or
                h-bodi149:type      <> "PROCEDURE":U or
                h-bodi149:file-name <> "dibo/bodi149.p":U then
                run dibo/bodi149.p persistent set h-bodi149.
    
            IF  l-ativa-log THEN PUT 'antes desaloca ped-ent ' ped-ent.qt-log-aloca SKIP.
            run unallocateDelivery in h-bodi149(input  rowid(ped-ent),
                                                input  ped-ent.qt-log-aloca).

            IF  l-ativa-log THEN PUT 'depois desaloca ped-ent ' ped-ent.qt-log-aloca SKIP.

            if  valid-handle(h-bodi149) then do:
                delete procedure h-bodi149.
                assign h-bodi149 = ?.
            end. /* if  valid-handle(h-bodi149) then do */                 
    
        end. /*  for each ped-ent of tt-PedidosFaturaveis */
    
        IF l-ativa-log THEN PUT 'FATCOM8 ' l-erro ' ' c-mensagem SKIP.
        /* In°cio da transaá∆o */
        repeat trans:
    
            /* Limpar a tabela de erros em todas as BOS */
            run emptyRowErrors        in h-bodi317in.
    
            /* Cria o registro WT-DOCTO para o pedido */
            run criaWtDocto in h-bodi317sd
                    (input  c-seg-usuario,
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
    
            IF l-ativa-log THEN PUT 'FATCOM9 ' l-erro ' ' c-mensagem SKIP.
            /* tratativa itens que foram tratados para n∆o considerar alocaá∆o */
            FOR EACH tt-itensPedido NO-LOCK,
                FIRST ped-item EXCLUSIVE-LOCK
                WHERE ped-item.nome-abrev    = tt-itensPedido.nome-abrev  
                  and ped-item.nr-pedcli     = tt-itensPedido.nr-pedcli   
                  and ped-item.nr-sequencia  = tt-itensPedido.nr-sequencia
                  and ped-item.it-codigo     = tt-itensPedido.it-codigo   
                  and ped-item.cod-refer     = tt-itensPedido.cod-refer :

                IF  l-ativa-log THEN PUT 'antes atualizando o ped-item.qt-log-aloca ' ped-item.qt-log-aloca " / " tt-itensPedido.qt-log-aloca SKIP.
                ASSIGN ped-item.qt-log-aloca = tt-itensPedido.qt-log-aloca
                       qt-log-alocaComposto  = 0.

                IF  l-ativa-log THEN PUT 'depois atualizando o ped-item.qt-log-aloca ' ped-item.qt-log-aloca " / " tt-itensPedido.qt-log-aloca SKIP.

                DELETE tt-itensPedido.
            END. /* FOR EACH tt-itensPedido */
            FIND CURRENT ped-item NO-LOCK NO-ERROR.
            RELEASE ped-item.
    
            IF l-ativa-log THEN PUT 'FATCOM10 ' l-erro ' ' c-mensagem SKIP.
            /* Pesquisa algum erro ou advertància que tenha ocorrido */
            find first RowErrors no-lock no-error.
    
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors THEN DO:
                for each RowErrors:
                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                    ASSIGN c-mensagem = c-mensagem + CHR(10) + " Pedido A " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli + 
                                        (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + " " + RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U.        
                END.
            END.
    
            IF  l-ativa-log THEN PUT 'l-proc-ok-aux ' l-proc-ok-aux SKIP.
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                /* Finalizaá∆o das BOS utilizada no c†lculo */
                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
                undo, leave.
            END.
    
            IF l-ativa-log THEN PUT 'FATCOM11 ' l-erro ' ' c-mensagem SKIP.
            /* Bloco a ser repetido para cada item da nota */
            bloco-cria-item:
            FOR EACH ped-item OF tt-PedidosFaturaveis
                    where ped-item.cod-sit-item <= 2 NO-LOCK:

                IF  l-ativa-log THEN PUT 'Itens Pedido - faturando ' ped-item.it-codigo SKIP.
    
                FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL ITEM THEN DO:
 
                    IF  l-ativa-log THEN PUT "bloco cria ITEM " + " " + ped-item.it-codigo + " " + STRING(ped-item.qt-log-aloca) + " " + STRING(item.baixa-estoq) + " " + c-mensagem FORMAT  'X(150)' SKIP.
                    IF  l-ativa-log THEN PUT "Servico " + " " + string(ITEM.cod-servico) SKIP.
                        
                        IF (ITEM.cod-servico       = 0 AND item.baixa-estoq = NO) 
                        OR  ped-item.it-codigo     = '4990709' 
                        OR  ped-item.qt-log-aloca <> 0                              THEN DO:
    
                            IF  l-ativa-log THEN PUT "entrou bloco cria ITEM " + " " + ped-item.it-codigo + " " + STRING(ped-item.qt-log-aloca) + " " + c-mensagem FORMAT  'X(150)' SKIP.
    
                            IF  l-ativa-log THEN PUT ' ped-item.it-codigo                  '  ped-item.it-codigo                   SKIP.
                            IF  l-ativa-log THEN PUT ' ped-item.cod-refer                  '  ped-item.cod-refer                   SKIP.
                            IF  l-ativa-log THEN PUT ' ped-item.qt-log-aloca               '  ped-item.qt-log-aloca                SKIP.
                            IF  l-ativa-log THEN PUT ' ped-item.vl-preuni                  '  ped-item.vl-preuni                   SKIP.
                            IF  l-ativa-log THEN PUT ' ped-item.val-pct-desconto-tab-preco '  ped-item.val-pct-desconto-tab-preco  SKIP.
                            IF  l-ativa-log THEN PUT ' ped-item.per-des-item               '  ped-item.per-des-item                SKIP.
                            IF  l-ativa-log THEN PUT ' c-mensagem                          '  trim(c-mensagem)                     SKIP.
    
                            assign c-it-codigo                   = ped-item.it-codigo                       /* C¢digo do item     */
                                   c-cod-refer                   = ped-item.cod-refer                       /* Referància do item */
                                   /*de-quantidade                 = ped-item.qt-log-aloca                    /* Quantidade         */*/
                                   de-vl-preori-ped              = ped-item.vl-preuni                       /* Preáo unit†rio     */
                                   de-val-pct-desconto-tab-preco = ped-item.val-pct-desconto-tab-preco      /* Desconto de tabela */
                                   de-per-des-item               = ped-item.per-des-item                    /* Desconto do item   */
                                   l-ped-saldo                   = NO.
    
                            ASSIGN de-quantidade = 0.
                            IF ped-item.it-codigo = '4990709' THEN DO:
    
                                IF  l-ativa-log THEN PUT "Entrou Paii " SKIP
                                     ped-item.nome-abrev " "
                                     ped-item.nr-pedcli  " "
                                     ped-item.it-codigo  " " 
                                     ped-item.cod-refer  SKIP.
    
                                FOR EACH int-ped-item-pai
                                    WHERE int-ped-item-pai.nome-abrev    = ped-item.nome-abrev  
                                      AND int-ped-item-pai.nr-pedcli     = ped-item.nr-pedcli
                                      AND int-ped-item-pai.nr-sequencia  = 10
                                      AND int-ped-item-pai.it-codigo     = ped-item.it-codigo   
                                      AND int-ped-item-pai.cod-refer     = ped-item.cod-refer  NO-LOCK:
    
                                    /*** ASSIGN c-PaiMesmoFilho = int-ped-item-pai.it-codigo-pai.***/
                                    IF  l-ativa-log THEN PUT "int-ped-item-pai" int-ped-item-pai.it-codigo-pai  SKIP.
    
                                    FOR EACH b-int-ped-item-pai
                                        WHERE b-int-ped-item-pai.nome-abrev     = ped-item.nome-abrev  
                                          AND b-int-ped-item-pai.nr-pedcli      = ped-item.nr-pedcli
                                          AND b-int-ped-item-pai.nr-sequencia   = 10
                                          AND b-int-ped-item-pai.it-codigo     <> ped-item.it-codigo   
                                          AND b-int-ped-item-pai.cod-refer      = ped-item.cod-refer  
                                          AND b-int-ped-item-pai.it-codigo-pai  = int-ped-item-pai.it-codigo-pai  NO-LOCK :
    
                                        IF  l-ativa-log THEN PUT "Pai " b-int-ped-item-pai.it-codigo-pai " FILHO " b-int-ped-item-pai.it-codigo SKIP.
    
                                        FIND FIRST prod-composto
                                            WHERE prod-composto.it-codigo-pai   = b-int-ped-item-pai.it-codigo-pai 
                                              AND prod-composto.it-codigo-filho = b-int-ped-item-pai.it-codigo NO-LOCK NO-ERROR.
                                        IF AVAIL prod-composto THEN DO: /* Multiplicador de filhos */
    
                                            IF  l-ativa-log THEN PUT "AVAIL prod-composto" SKIP.
    
                                            FOR EACH b-PedItem
                                                WHERE b-PedItem.nome-abrev   = ped-item.nome-abrev
                                                  AND b-PedItem.nr-pedcli    = ped-item.nr-pedcli 
                                                  AND b-PedItem.it-codigo    = b-int-ped-item-pai.it-codigo NO-LOCK .
    
                                                IF  l-ativa-log THEN PUT "BUFFER " b-PedItem.it-codigo  " / " b-PedItem.qt-log-aloca  SKIP.
    
                                                IF b-PedItem.qt-log-aloca <> 0 THEN
                                                    ASSIGN de-quantidade = de-quantidade + (prod-composto.qt-filho * b-PedItem.qt-log-aloca).
                                            END.
    
                                        END.
    
                                    END. /* FOR EACH b-int-ped-item-pai */
    
                                END. /* int-ped-item-pai */
    
                            END. /* IF ped-item.it-codigo = '4990709' THEN DO: */
                            ELSE DO:
                                IF (ITEM.cod-servico = 0 AND item.baixa-estoq = NO) THEN
                                    ASSIGN de-quantidade = ped-item.qt-pedida - ped-item.qt-atendida.
                                ELSE
                                    ASSIGN de-quantidade = ped-item.qt-log-aloca. /* Quantidade         */
                            END.
                                
    
    
                            IF  l-ativa-log THEN PUT "Limpar " de-quantidade SKIP.
                            /* Limpar a tabela de erros em todas as BOS */
                            run emptyRowErrors        in h-bodi317in.
    
                            IF  l-ativa-log  THEN PUT "Disponibilizar" SKIP.
                            /* Disponibilizar o registro WT-DOCTO na bodi317sd */
                            run localizaWtDocto in h-bodi317sd(input  i-seq-wt-docto,
                                                               output l-proc-ok-aux). 
    
                            IF  l-ativa-log  THEN PUT "criaWtItDocto ITEM " + " " + ped-item.it-codigo + " " + c-mensagem FORMAT  'X(150)' SKIP.
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
                                for each RowErrors:
                                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                                    ASSIGN c-mensagem = "Erro BO  " + tt-PedidosFaturaveis.nr-pedcli + " " + ped-item.it-codigo + " " + 
                                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem
                                           l-erro     = YES .        
                                end.
    
                            IF  l-ativa-log  THEN PUT string(l-proc-ok-aux) + " depois criaWtItDocto ITEM " + " " + ped-item.it-codigo + " " + c-mensagem FORMAT  'X(150)' SKIP.
                            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                            if  not l-proc-ok-aux THEN DO:
                                /* Finalizaá∆o das BOS utilizada no c†lculo */
                                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
    
                                UNDO, LEAVE.
    
                            END.
    
                            /* Grava informaá‰es gerais para o item da nota */
                            run gravaInfGeraisWtItDocto in h-bodi317sd 
                                   (input i-seq-wt-docto,
                                    input i-seq-wt-it-docto,
                                    input de-quantidade,
                                    input de-vl-preori-ped,
                                    input de-val-pct-desconto-tab-preco,
                                    input de-per-des-item).
    
                            /* Limpar a tabela de erros em todas as BOS */
                            run emptyRowErrors        in h-bodi317in.
    
                            /* Disp. registro WT-DOCTO, WT-IT-DOCTO e WT-IT-IMPOSTO na bodi317pr */
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
    
                            /*************************************************/
                            /*************************************************/
                            /*************************************************/
                            /*************************************************/
                            IF  l-ativa-log  THEN PUT string(l-proc-ok-aux) + " depois gravaInfGeraisWtItDocto ITEM " + " " + ped-item.it-codigo + " " + c-mensagem FORMAT  'X(150)' SKIP.
    
                            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                            if  not l-proc-ok-aux THEN DO:
                                /* Finalizaá∆o das BOS utilizada no c†lculo */
                                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
    
                                UNDO, LEAVE.
    
                            END.
    
                            FOR EACH tt-ped-saldo NO-LOCK:
                                IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                   WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                     AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto
                                     AND wt-fat-ser-lote.cod-depos         <> tt-ped-saldo.cod-depos) THEN DO:
                                    ASSIGN l-ped-saldo = YES.
                                END. /* IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK */
                                IF l-ped-saldo = YES THEN LEAVE.
                            END. /* FOR EACH tt-ped-saldo NO-LOCK: */
    
                            IF l-ped-saldo = YES THEN DO:
    
                                for each wt-fat-ser-lote EXCLUSIVE-LOCK
                                   WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                                     AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto:
                                   delete wt-fat-ser-lote.
                                end.
    
                                FOR EACH tt-ped-saldo no-lock     
                                    where tt-ped-saldo.nome-abrev    = ped-item.nome-abrev       
                                      and tt-ped-saldo.nr-pedcli     = ped-item.nr-pedcli       
                                      and tt-ped-saldo.nr-seq-item   = ped-item.nr-sequencia       
                                      and tt-ped-saldo.it-codigo     = ped-item.it-codigo       
                                      /***and tt-ped-saldo.nr-entrega    = ped-item.nr-entrega        ***/
                                      and tt-ped-saldo.qt-aloc-ped   > 0.
    
                                    FIND FIRST deposito 
                                        WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-LOCK NO-ERROR.
                                    IF AVAIL deposito THEN DO:
                                        IF deposito.cod-depos     = 'EXP'
                                        OR deposito.log-gera-wms  = YES THEN
                                            ASSIGN c-cod-localizExp = ''.
                                        ELSE 
                                            ASSIGN c-cod-localizExp = tt-ped-saldo.cod-localiz.
                                    END. /* IF AVAIL deposito THEN DO: */

/*                                     ASSIGN c-cod-localizExp = ''                                                                                                          */
/*                                            c-cod-localizExp = IF tt-ped-saldo.cod-depos = 'EXP' OR  tt-ped-saldo.cod-depos = 'WEX' THEN '' ELSE tt-ped-saldo.cod-localiz. */
    
                                    FIND FIRST wt-fat-ser-lot
                                        WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                                          AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                                          AND wt-fat-ser-lote.it-codigo         = c-it-codigo                                                            
                                          AND wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos                                                 
                                          AND wt-fat-ser-lote.cod-locali        = c-cod-localizExp
                                          AND wt-fat-ser-lote.lote              = "" NO-LOCK NO-ERROR.
                                    IF NOT avail wt-fat-ser-lote THEN DO:
                                        create wt-fat-ser-lote.
                                        assign wt-fat-ser-lote.lote              = ""
                                               wt-fat-ser-lote.cod-depos         = tt-ped-saldo.cod-depos   
                                               wt-fat-ser-lote.cod-localiz       = tt-ped-saldo.cod-localiz
                                               wt-fat-ser-lote.quantidade[1]     = tt-ped-saldo.qt-aloc-ped
                                               wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto
                                               wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto   
                                               wt-fat-ser-lote.qtd-contada[1]    = tt-ped-saldo.qt-aloc-ped
                                               wt-fat-ser-lote.it-codigo         = c-it-codigo
                                               wt-fat-ser-lote.lote              = ped-item.cod-refer.
                                    END.
    
                                END. /* FOR EACH ped-saldo no-lock      */
                            END. /* IF l-ped-saldo THEN DO: */
                            ELSE DO:
    
                                for each wt-fat-ser-lote EXCLUSIVE-LOCK
                                   WHERE wt-fat-ser-lote.seq-wt-docto      = i-seq-wt-docto
                                     AND wt-fat-ser-lote.seq-wt-it-docto   = i-seq-wt-it-docto:

                                    FIND FIRST deposito 
                                        WHERE deposito.cod-depos = wt-fat-ser-lote.cod-depos NO-LOCK NO-ERROR.
                                    IF AVAIL deposito THEN DO:
                                        IF deposito.cod-depos     = 'EXP'
                                        OR deposito.log-gera-wms  = YES THEN
                                            ASSIGN wt-fat-ser-lote.cod-locali = ''.
                                    END. /* IF AVAIL deposito THEN DO: */

/*                                     IF   wt-fat-ser-lote.cod-depos = 'EXP' OR wt-fat-ser-lote.cod-depos = 'WEX' THEN DO: */
/*                                         ASSIGN wt-fat-ser-lote.cod-locali = ''.                                          */
/*                                     END.                                                                                 */
    
                                END.
    
                            END.
                            FIND CURRENT wt-fat-ser-lote NO-LOCK NO-ERROR.
                            RELEASE wt-fat-ser-lote.
                            /*************************************************/
                            /*************************************************/
                            /*************************************************/
                            /*************************************************/

    
                            /* Busca poss°veis erros que ocorreram nas validaá‰es */
                            run devolveErrosbodi317pr in h-bodi317pr(output c-ultimo-metodo-exec,
                                                                     output table RowErrors).
    
                            /* Pesquisa algum erro ou advertància que tenha ocorrido */
                            find first RowErrors no-lock no-error.
                            /* Caso tenha achado algum erro ou advertància, mostra em tela */
                            if  avail RowErrors then
                                for each RowErrors:
                                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                                    ASSIGN c-mensagem = "Erro BO 2 " + tt-PedidosFaturaveis.nr-pedcli + " " + ped-item.it-codigo + " " + 
                                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem
                                           l-erro     = YES .        
                                end.
    
                            /***** TRATATIVA Fat ser lote *******************************/
                            
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
                                for each RowErrors:
                                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                                    ASSIGN c-mensagem = "Erro BO 3 " + tt-PedidosFaturaveis.nr-pedcli + " " + ped-item.it-codigo + " " + 
                                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem
                                           l-erro     = YES .        
                                end.
    
                            IF  l-ativa-log  THEN PUT string(l-proc-ok-aux) + " depois validaItemDaNota ITEM " + " " + ped-item.it-codigo + " " + c-mensagem FORMAT  'X(150)' SKIP.
    
                            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                            if  not l-proc-ok-aux THEN DO:
                                /* Finalizaá∆o das BOS utilizada no c†lculo */
                                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
    
                                UNDO, LEAVE.
    
                            END.
    
                            find ped-ent
                                 where ped-ent.nome-abrev   = tt-PedidosFaturaveis.nome-abrev
                                 and   ped-ent.nr-pedcli    = tt-PedidosFaturaveis.nr-pedcli
                                 and   ped-ent.nr-sequencia = ped-item.nr-sequencia
                                 and   ped-ent.it-codigo    = ped-item.it-codigo
                                 and   ped-ent.cod-refer    = ped-item.cod-refer exclusive-lock no-error.
                            IF AVAIL ped-ent THEN DO:
    
                                FOR EACH wt-it-docto 
                                    WHERE wt-it-docto.seq-wt-docto      = i-seq-wt-docto
                                      AND wt-it-docto.seq-wt-it-docto   = i-seq-wt-it-docto
                                      AND wt-it-docto.it-codigo         = ped-ent.it-codigo EXCLUSIVE-LOCK .
    
                                    IF l-ativa-log THEN PUT 'wt-it-docto ' wt-it-docto.it-codigo SKIP.
    
                                    ASSIGN wt-it-docto.nr-entrega       = ped-ent.nr-entrega
                                           wt-it-docto.quantidade[2]    = wt-it-docto.quantidade[1].
                                END. /* FOR EACH wt-it-docto */
    
                            END. /* IF AVAIL ped-ent THEN DO: */
    
                        END. /* IF  ped-item.it-codigo = '4990709' OR ped-item.qt-log-aloca <> 0 THEN DO: */

                END. /* IF AVAIL ITEM THEN DO: */
    
                IF l-ativa-log THEN PUT 'FIM Itens Pedido - faturando ' ped-item.it-codigo SKIP.

            end. /* FOR EACH ped-item OF tt-PedidosFaturaveis */
    
            IF l-ativa-log THEN PUT 'FATCOM12 ' l-erro ' ' c-mensagem SKIP.
            /* Finalizaá∆o das BOS utilizada no c†lculo */
            IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
            IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
            IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
            IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.

            /* Reinicializaá∆o das BOS para C†lculo */
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
            
            IF l-ativa-log THEN PUT 'FATCOM13 ' l-erro ' ' c-mensagem SKIP.
            /* Caso tenha achado algum erro ou advertància, mostra em tela */
            if  avail RowErrors then
                for each RowErrors:
                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                    ASSIGN c-mensagem = "Erro BO 4 " + tt-PedidosFaturaveis.nr-pedcli + " " + 
                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem
                                       l-erro     = YES .        
                end.
            
                IF  l-ativa-log  THEN PUT string(l-proc-ok-aux) + " depois confirmaCalculo ITEM " + " " + c-mensagem FORMAT  'X(150)' SKIP.

            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux THEN DO:
                /* Finalizaá∆o das BOS utilizada no c†lculo */
                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.

                UNDO, LEAVE.

            END.
                
            IF l-ativa-log THEN PUT 'FATCOM14 ' l-erro ' ' c-mensagem SKIP.
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
                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                    ASSIGN c-mensagem = "Erro BO 5 " + tt-PedidosFaturaveis.nr-pedcli + " " +  
                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem
                                       l-erro     = YES .        
                end.
            
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            if  not l-proc-ok-aux then do:
                IF VALID-HANDLE(h-bodi317ef) THEN
                    IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                    IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                    IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                    IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
                undo, leave.
            end.
        
            IF l-ativa-log THEN PUT 'FATCOM15 ' l-erro ' ' c-mensagem SKIP.
            /* Busca as notas fiscais geradas */
            run buscaTTNotasGeradas in h-bodi317ef(output l-proc-ok-aux,
                                                   output table tt-notas-geradas).
    
            /* Finalizaá∆o das BOS utilizada no c†lculo */
            IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
            IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
            IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
            IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.

            leave.
    
        end.

    END. /* IF c-mensagem = '' THEN DO: */
    
    IF l-ativa-log THEN PUT 'FATCOM16 ' l-erro ' ' c-mensagem SKIP.
    /* Caso tenha achado algum erro retorna prioridade 01 */
    find first RowErrors
         where RowErrors.ErrorSubType = "ERROR":U no-error.
    if  avail RowErrors THEN DO:
        FIND FIRST ped-venda WHERE ped-venda.nr-pedcli = tt-PedidosFaturaveis.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda NO-LOCK
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
             
            IF  AVAIL int-ped-venda THEN
                ASSIGN ped-venda.cod-priori = IF  AVAIL int-ped-venda AND int-ped-venda.cod-priori <> ? THEN 
                                                  int-ped-venda.cod-priori /*Volta para a prioridade original do pedido*/
                                              ELSE 
                                                  01.
        END.
        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        RELEASE ped-venda.
        UNDO, LEAVE.
    END.

    IF l-entregaFutura THEN ASSIGN tt-PedidosFaturaveis.cod-priori = 01.

    IF l-ativa-log THEN PUT 'FATCOM17 ' l-erro ' ' c-mensagem SKIP.
    /* Mostrar as notas geradas */
    for first tt-notas-geradas no-lock:
        find last b-tt-notas-geradas no-error.

        for  first nota-fiscal
            where rowid(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal EXCLUSIVE-LOCK:

            FIND FIRST tt-notaFiscaisGeradas
                WHERE tt-notaFiscaisGeradas.cod-estabel = nota-fiscal.cod-estabel
                  AND tt-notaFiscaisGeradas.serie       = nota-fiscal.serie
                  AND tt-notaFiscaisGeradas.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-notaFiscaisGeradas THEN DO:
                CREATE tt-notaFiscaisGeradas.
                BUFFER-COPY nota-fiscal TO tt-notaFiscaisGeradas.
            END. /* IF NOT AVAIL tt-notaFiscaisGeradas THEN DO: */
            FIND CURRENT tt-notaFiscaisGeradas NO-LOCK NO-ERROR.
            RELEASE tt-notaFiscaisGeradas.

            FIND FIRST emitente where emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:

                IF l-ativa-log THEN PUT 'FATCOM5 ' nr-PedExec SKIP.
                FIND LAST fat-comercial
                    WHERE  fat-comercial.num-ped-exec  = nr-PedExec
                      AND (fat-comercial.nr-pedcli     = string(nota-fiscal.nr-pedido)
                       OR  fat-comercial.nr-pedcli     = nota-fiscal.nr-pedcli)
                      AND  fat-comercial.nome-abrev    = emitente.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL fat-comercial THEN DO:
                    ASSIGN fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                           fat-comercial.serie       = nota-fiscal.serie
                           fat-comercial.nr-nota-fis = tt-notas-geradas.nr-nota 
                           fat-comercial.dt-fatura   = TODAY
                           fat-comercial.hr-fatura   = TIME
                           fat-comercial.c-status    = "Gerou Nota: Estab " + string(nota-fiscal.cod-estabel)  + " Serie " + string(nota-fiscal.serie) + " Nota " + string(tt-notas-geradas.nr-nota).
                END.
                FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

            END. /* IF AVAIL emitente THEN DO: */

            FOR EACH ped-item OF tt-PedidosFaturaveis EXCLUSIVE-LOCK:
                IF ped-item.qt-log-aloca <> 0 THEN DO:
                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                        IF  it-nota-fisc.it-codigo   = ped-item.it-codigo
                        AND it-nota-fisc.qt-fatur[1] = ped-item.qt-log-aloc THEN
                            ASSIGN /*ped-item.qt-alocada  = ped-item.qt-log-aloc*/
                                   ped-item.qt-log-aloc = 0.
                    END.
                    IF  l-ativa-log THEN PUT 'antes atualizando o ped-item.qt-log-aloca com ped-saldo ' ped-item.qt-log-aloca SKIP.

                    IF ped-item.qt-log-aloca > ped-item.qt-atendida THEN DO:
                        FIND FIRST ped-saldo no-lock     
                            where ped-saldo.nome-abrev    = ped-item.nome-abrev       
                              and ped-saldo.nr-pedcli     = ped-item.nr-pedcli       
                              and ped-saldo.nr-seq-item   = ped-item.nr-sequencia       
                              and ped-saldo.it-codigo     = ped-item.it-codigo       
                              and ped-saldo.qt-aloc-ped   > 0 NO-ERROR.
                        IF AVAIL ped-saldo THEN
                            ASSIGN ped-item.qt-log-aloca = ped-saldo.qt-aloc-ped.
                        ELSE
                            ASSIGN ped-item.qt-log-aloca = 0.
                    END.
                    IF  l-ativa-log THEN PUT 'NO antes atualizando o ped-item.qt-log-aloca com ped-saldo ' ped-item.qt-log-aloca SKIP.
                        
                END.
            END.
            FIND CURRENT ped-item NO-LOCK NO-ERROR.
            RELEASE ped-item.

            if  tt-notas-geradas.nr-nota = b-tt-notas-geradas.nr-nota then
                ASSIGN c-mensagem = ''
                       c-mensagem = "Pedido " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli +
                             (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + "  Gerou Nota: Estab " + string(nota-fiscal.cod-estabel)  + " Serie " + string(nota-fiscal.serie) + " Nota " + string(tt-notas-geradas.nr-nota).
            else
                ASSIGN c-mensagem = ''
                       c-mensagem = "Pedido " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli +
                             (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + "  Gerou Nota: Estab " + string(nota-fiscal.cod-estabel)  + " Serie " + string(nota-fiscal.serie) + " Nota " + string(tt-notas-geradas.nr-nota) + " - " + string(b-tt-notas-geradas.nr-nota).

        end. /* for  first nota-fiscal  */
        bell.

    end.

    IF l-ativa-log THEN PUT 'FATCOM18 ' nr-PedExec SKIP.
    FIND LAST fat-comercial
        WHERE  fat-comercial.num-ped-exec  = nr-PedExec
          AND  fat-comercial.nr-pedcli     = string(tt-PedidosFaturaveis.nr-pedido)
          AND  fat-comercial.nome-abrev    = tt-PedidosFaturaveis.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL fat-comercial THEN DO:

        IF  c-mensagem              <> '' 
        AND fat-comercial.c-status   = '' THEN DO:
/*             IF l-ativa-log THEN                                                           */
/*                 PUT '4 - Existe cria fat-com c-mensagem ' c-mensagem FORMAT 'X(50)' SKIP. */
            ASSIGN fat-comercial.c-status    = c-mensagem.
        END.

    END.
    FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
    RELEASE fat-comercial.

END PROCEDURE.

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






