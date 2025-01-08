{include/i-prgvrs.i ESPDP006rp 2.06.00.002}
/***********************************************************************
**  Programa..: ESP\PDP\ESPDP006RP.P
**  Autor.....: Anderson Cenci
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/pdp/espdp006d.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}
{cdp/cd0666.i} 
{esapi/esapi002tt.i}
{method/dbotterr.i}
{utp/ut-glob.i}
{esp/esb/esesb000.i}
{esp/es0018.i}

/*fnEstoque*/
{esp/pdp/espdp006fn.i}

DEFINE TEMP-TABLE tt-param-aval NO-UNDO
    FIELD nr-pedido     LIKE ped-venda.nr-pedido
    FIELD param-aval    AS INTEGER
    FIELD cod-sit-aval  AS INTEGER
    FIELD embarque      AS LOGICAL
    FIELD efetiva       AS LOGICAL
    FIELD retorna       AS LOGICAL
    FIELD reavalia-forc AS LOGICAL
    FIELD vl-a-avaliar  AS DECIMAL
    FIELD saldo-lim     AS DECIMAL
    FIELD usuario       AS CHARACTER
    FIELD programa      AS CHARACTER
    INDEX codigo IS UNIQUE PRIMARY nr-pedido.

DEFINE TEMP-TABLE tt-erros-aval NO-UNDO
    FIELD cod-emitente AS INTEGER
    FIELD cd-erro      AS INTEGER
    INDEX codigo IS UNIQUE PRIMARY cod-emitente cd-erro.

/****************************  Temp-Tables  ****************************/
/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
DEF TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS   ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

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

DEF TEMP-TABLE tt-itensPedido        NO-UNDO       LIKE ped-item. 

DEF TEMP-TABLE tt-PedidosFaturaveis  NO-UNDO       LIKE ped-venda
    FIELD c-mensagemErro    AS CHARACTER. 

DEF TEMP-TABLE tt-ped-saldo          NO-UNDO       LIKE ped-saldo.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-PedSaldoShared NO-UNDO LIKE ped-saldo.

DEF TEMP-TABLE tt-notaFiscaisGeradas NO-UNDO       LIKE nota-fiscal.

DEF TEMP-TABLE tt-fatCom             NO-UNDO       LIKE fat-comercial
    FIELD oldNota AS CHAR.

DEF TEMP-TABLE tt-composto                  NO-UNDO
    FIELD it-codigo                         LIKE ITEM.it-codigo
    FIELD qt-log-aloca                      LIKE ped-item.qt-log-aloca.

DEFINE VARIABLE l-ped-saldo         AS LOGICAL     NO-UNDO.

/****************************  Variaveis    ****************************/
DEFINE VARIABLE c_cod_estab_usuar     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi018            AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-qt-a-alocar-astec  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-mensagem            AS CHAR        NO-UNDO.
DEFINE VARIABLE de-qt-saldo           AS DEC         NO-UNDO.
DEFINE VARIABLE de-qt-a-alocar        AS DEC         NO-UNDO.
DEFINE VARIABLE de-qt-disponivel      AS DEC         NO-UNDO.
DEFINE VARIABLE h-acomp               AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-erro                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-erro-critico        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-entrou              AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-alocacao            AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-valor              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-param        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-parc                AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-reserva             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cotas               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cReturn               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mesgitem            AS CHAR        NO-UNDO.
DEFINE VARIABLE l-peso                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-vl-total-alocado   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-total           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE da-data-atual         AS DATE        NO-UNDO.
DEFINE VARIABLE de-qt-saldo-exp-geral AS DECIMAL     NO-UNDO.
DEFINE VARIABLE da-data               AS DATE        NO-UNDO.
DEFINE VARIABLE i-SeqPonto            AS INTEGER     NO-UNDO.
DEFINE VARIABLE vQtAlocar             LIKE ped-item.qt-pedida         NO-UNDO.
DEFINE VARIABLE vQtAlocada            AS INTEGER FORMAT '->>>,>>>,>99.99'         NO-UNDO.
DEFINE VARIABLE vQtSaldo              LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE vQtTransferida        AS   INTEGER                    NO-UNDO.

def buffer bped-item          for ped-item.
DEF BUFFER b-tt-itensPedido   FOR tt-itensPedido.
def buffer bnota              for nota-fiscal.
def buffer bped-venda         for ped-venda.
def buffer b-fat-comercial    for fat-comercial.
def buffer bFatCom            for fat-comercial.
def buffer b-PedItem          FOR ped-item.
def buffer b-int-ped-item-pai FOR int-ped-item-pai.

DEFINE TEMP-TABLE tt-AtuErro  NO-UNDO LIKE tt-erro.
DEFINE BUFFER bsaldo-estoq    FOR saldo-estoq.
DEFINE VARIABLE qt-log-alocaComposto2 LIKE ped-item.qt-log-aloca NO-UNDO.
DEFINE VARIABLE l-usb         AS LOGICAL     NO-UNDO.
{upc/pd4000k-upce.i}
{utp/utapi019.i}        /* Definiá∆o de temp-tables do email */
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR FORM "x(12)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod-deposESPDP006       LIKE deposito.cod-depos NO-UNDO.

DEFINE VARIABLE l-embarque AS LOGICAL   INIT NO  NO-UNDO.
DEFINE VARIABLE vNrOrdem                AS INT                          NO-UNDO.
DEFINE VARIABLE vMsgErro                AS CHAR                         NO-UNDO.
DEFINE VARIABLE c-cod-localizExp AS CHARACTER   NO-UNDO.

DEFINE VARIABLE p-qtd-total     LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEFINE VARIABLE p-qtd-disp      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEFINE VARIABLE p-qtd-bloq      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEFINE VARIABLE l-wms           AS LOGICAL   INIT NO                NO-UNDO.
DEFINE VARIABLE h-bodi149       AS HANDLE                           NO-UNDO.

FOR EACH tt-ped-saldo.
    DELETE tt-ped-saldo.
END.

FOR EACH tt-PedSaldoShared.
    DELETE tt-PedSaldoShared.
END.

FOR EACH tt-notaFiscaisGeradas.
    DELETE tt-notaFiscaisGeradas.
END.

/****************************  Forms    ****************************/
form ped-venda.nr-pedcli
     c-mensagem format "x(140)" column-label "Mensagem"
with frame f-detalhe width 172 64 down stream-io.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Alocaá∆o Autom†tica Total"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESPDP006d"
       c-versao       = "2.06"
       c-revisao      = "002".

/* ***************************  Main Block  *************************** */
    
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    FOR EACH tt-raw-digita:
        CREATE tt-digita.
        RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
    END. 

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Selecionando Informaá‰es").
    
    IF tt-param.fi-Atendente-ini > tt-param.fi-Atendente-fim THEN DO:
        PUT "Atendente inicial informado maior que atendente final informado" SKIP.
        RUN pi-finalizar IN h-acomp.
    
        {include/i-rpclo.i}
    
        RETURN "OK".
    END.
    FOR EACH ponto-programa NO-LOCK
       WHERE ponto-programa.nome-programa = "espdp006"
         AND ponto-programa.ponto         = 10,  
        EACH conteudo-programa NO-LOCK
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF (tt-param.fi-Atendente-ini >  entry(2,conteudo-programa.conteudo, ";")     or
            tt-param.fi-Atendente-fim <  entry(1,conteudo-programa.conteudo, ";")) THEN .
        ELSE DO:
            IF entry(4,conteudo-programa.conteudo, ";") = '' THEN DO:
                PUT "Ja existe execuá∆o para atendentes informados, usuario : "  entry(3,conteudo-programa.conteudo, ";") SKIP.
                RUN pi-finalizar IN h-acomp.
                {include/i-rpclo.i}
                RETURN "OK".

            END.
            ELSE DO:
                IF tt-param.cod-unid-neg = entry(4,conteudo-programa.conteudo, ";") THEN DO:
                    PUT "Ja existe execuá∆o para atendentes informados, usuario : "  entry(3,conteudo-programa.conteudo, ";") " - Unid Neg " entry(4,conteudo-programa.conteudo, ";") SKIP.
                    RUN pi-finalizar IN h-acomp.
                    {include/i-rpclo.i}
                    RETURN "OK".
                END.
            END.

        END.
    end.

    ASSIGN i-SeqPonto = 0.
    REPEAT:
        ASSIGN i-SeqPonto = i-SeqPonto + 1.
        for first ponto-programa NO-LOCK
            where ponto-programa.nome-programa = "espdp006" 
              AND ponto-programa.ponto         = 10,  
            FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia = i-SeqPonto:
        END.
        IF NOT AVAIL conteudo-programa THEN DO:
            CREATE conteudo-programa.
            ASSIGN conteudo-programa.cod-programa = ponto-programa.cod-programa
                   conteudo-programa.sequencia    = i-SeqPonto
                   conteudo-programa.conteudo     = tt-param.fi-Atendente-ini + ";" +
                                                    tt-param.fi-Atendente-fim + ";" +
                                                    c-seg-usuario             + ";" +
                                                    tt-param.cod-unid-neg.
            FIND CURRENT conteudo-programa NO-LOCK NO-ERROR.
            RELEASE conteudo-programa.
            LEAVE.
        END.
    END.

    RUN piSeleciona.

    PUT SKIP
        'Ped Cli FAT  Mensagem' SKIP
        '------------ --------------------------------------------------------------------------------------------------------------------------------------------' SKIP.
    /******************** Faturamento dos pedidos */
    FOR EACH tt-PedidosFaturaveis:

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido:" + tt-PedidosFaturaveis.nr-pedcli).
        ASSIGN l-embarque = NO
               c-mensagem = ''.
               l-erro     = IF tt-PedidosFaturaveis.c-mensagemErro <> '' THEN YES ELSE NO.

        IF  l-erro      = NO
        AND l-embarque  = NO THEN DO:
            DO TRANSACTION ON ERROR UNDO, LEAVE:
                RUN pi-faturaPedido.
            END. /* DO TRANSACTION ON ERROR UNDO, LEAVE: */
        END. /* IF l-erro = NO THEN DO: */
        ELSE DO:

            IF tt-param.l-AlocFat = YES THEN DO: /* Gera apenas para FatCom */


                FIND LAST bFatCom EXCLUSIVE-LOCK
                    WHERE bFatCom.num-ped-exec = 111
                      AND bFatCom.nr-pedcli    = string(tt-PedidosFaturaveis.nr-pedido) NO-ERROR.

                IF NOT AVAIL bFatCom THEN DO:
                    CREATE fat-comercial.                          
                    ASSIGN fat-comercial.nr-sequencia    = 10 
                           fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME 
                           fat-comercial.nome-abrev      = tt-PedidosFaturaveis.nome-abrev 
                           fat-comercial.nr-pedcli       = string(tt-PedidosFaturaveis.nr-pedido) 
                           fat-comercial.num-ped-exec    = 111
                           fat-comercial.c-status        = IF c-mensagem = '' THEN c-mensagem ELSE tt-PedidosFaturaveis.c-mensagemErro.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    ASSIGN bFatCom.c-status        = IF c-mensagem = '' THEN c-mensagem ELSE tt-PedidosFaturaveis.c-mensagemErro.
                END.

                FIND CURRENT bFatCom NO-LOCK NO-ERROR.
                RELEASE bFatCom.

                FIND CURRENT fat-comercial NO-LOCK NO-ERROR.
                RELEASE fat-comercial.
            END.

        END.

        IF c-mensagem <> '' THEN DO:
            PUT tt-PedidosFaturaveis.nr-pedido        AT 01
                trim(c-mensagem)    FORMAT  'X(256)'  AT 14 SKIP.
            ASSIGN c-mensagem = ''.
        END.

    END. /* FOR EACH tt-PedidosFaturaveis: */
    /******************** Atualiza notas geradas  */

    /* Mostrar as notas geradas */
    FOR EACH tt-notaFiscaisGeradas no-lock:

        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = tt-notaFiscaisGeradas.cod-estabel
               AND nota-fiscal.serie       = tt-notaFiscaisGeradas.serie      
               AND nota-fiscal.nr-nota-fis = tt-notaFiscaisGeradas.nr-nota-fis NO-ERROR.
             
        IF AVAIL nota-fiscal THEN DO:

            /** gera TXT e XML - MAUAL **/
            CREATE tt-ft0910.
            ASSIGN tt-ft0910.usuario           = ""
                   tt-ft0910.arquivo           = "espdp006rp.txt"
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

            RAW-TRANSFER tt-ft0910 TO raw-param.

            RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-ft0910).

            RUN esp/ftp/esft067rp.p (INPUT nota-fiscal.cod-estabel,
                                     INPUT 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').

            /**  NOTAS COM NATUREZA VINCULADA **/
            FIND FIRST fat-comercial
                 WHERE fat-comercial.cod-estabel = nota-fiscal.cod-estabel 
                   AND fat-comercial.serie       = nota-fiscal.serie       
                   AND fat-comercial.nr-nota-fis = nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
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
            FOR EACH tt-fatCom.

                IF tt-fatCom.nr-nota-fis = string(int(tt-fatCom.oldNota) + 1,'9999999') THEN DO:
                    FIND FIRST fat-comercial 
                        WHERE fat-comercial.cod-estabel  = tt-fatCom.cod-estabel  
                          AND fat-comercial.serie        = tt-fatCom.serie        
                          AND fat-comercial.nr-nota-fis  = tt-fatCom.nr-nota-fis  NO-LOCK NO-ERROR.
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

        end. /* IF AVAIL nota-fiscal THEN DO: */

    end. /* FOR EACH tt-notaFiscaisGeradas no-lock: */
    /******************** Atualiza notas geradas */
    
    for first ponto-programa NO-LOCK
        where ponto-programa.nome-programa = "espdp006" 
          AND ponto-programa.ponto         = 10,  
        FIRST conteudo-programa EXCLUSIVE-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia = i-SeqPonto:
        DELETE conteudo-programa.
    END.

    RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i}

    RETURN "OK".



/* **********************  Internal Procedures  *********************** */
PROCEDURE piSeleciona:

    FOR EACH ped-venda NO-LOCK 
        WHERE (ped-venda.cod-sit-ped  <= 2) 
           AND ped-venda.completo      = YES
           AND ped-venda.cod-estabel  >= tt-param.fi-Estabel-ini
           AND ped-venda.cod-estabel  <= tt-param.fi-Estabel-fim
           AND ped-venda.tp-pedido    >= tt-param.fi-Atendente-ini
           AND ped-venda.tp-pedido    <= tt-param.fi-Atendente-fim
           AND ped-venda.nr-pedcli    >= tt-param.fi-nr-pedcli-ini
           AND ped-venda.nr-pedcli    <= tt-param.fi-nr-pedcli-fim
           AND ped-venda.dt-implant   >= tt-param.fi-dt-implant-ini
           AND ped-venda.dt-implant   <= tt-param.fi-dt-implant-fim
           AND ped-venda.cod-cond-pag >= tt-param.fi-cond-pagto-ini
           AND ped-venda.cod-cond-pag <= tt-param.fi-cond-pagto-fim
           AND ped-venda.cod-priori   >= tt-param.fi-prioridade-ini
           AND ped-venda.cod-priori   <= tt-param.fi-prioridade-fim
           AND ped-venda.cod-priori   <> 09
           AND ped-venda.cod-priori   <> 44
           AND ped-venda.cod-gr-cli   >= tt-param.fi-cod-grupo-ini
           AND ped-venda.cod-gr-cli   <= tt-param.fi-cod-grupo-fim,
           FIRST emitente NO-LOCK 
           WHERE emitente.cod-emitente  = ped-venda.cod-emitente
           AND  (emitente.ind-lib-estoq = YES OR 
                 ped-venda.cod-sit-aval = 3   OR 
                 ped-venda.mo-codigo <> 0),
           FIRST repres NO-LOCK
           WHERE repres.nome-abrev = ped-venda.no-ab-reppri AND
                 repres.cod-rep >= tt-param.fi-Cod-repres-ini AND
                 repres.cod-rep <= tt-param.fi-Cod-repres-fim,
           first atendente NO-LOCK
           WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
             AND atendente.oper-mestre >= int(tt-param.fi-Atendente-mestre-ini)
             AND atendente.oper-mestre <= int(tt-param.fi-Atendente-mestre-fim)
       BY ped-venda.dt-emissao
       BY ped-venda.nr-pedido :

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido:" + ped-venda.nr-pedcli).

        ASSIGN l-embarque = NO
               c-mensagem = ''.

        IF  tt-param.cod-unid-neg <> "" 
        AND NOT CAN-FIND(FIRST ped-item OF ped-venda NO-LOCK 
                         WHERE ped-item.cod-unid-neg = tt-param.cod-unid-neg) THEN 
            NEXT.

        FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
             WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
               AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.  

        IF VALID-HANDLE(h-alocacao) THEN
            DELETE PROCEDURE h-alocacao.

        RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.      

        ASSIGN l-erro            = NO 
               l-erro-critico    = NO
               c-mensagem        = ""
               l-entrou          = NO 
               l-embarque        = NO
               da-data           = ?.

        FIND FIRST tt-digita
             WHERE tt-digita.cod-estabel = ped-venda.cod-estabel NO-ERROR.

        IF NOT AVAIL tt-digita THEN DO:
            ASSIGN l-erro     = YES
                   c-mensagem = "N∆o encontrado dep¢sito para alocaá∆o no estabelecimento " + ped-venda.cod-estabel.
        END.

        IF ped-venda.cod-priori = 07 THEN DO:
            FIND FIRST ponto-programa NO-LOCK
                WHERE ponto-programa.nome-programa = "pd4000"
                  AND ponto-programa.ponto         = 7 NO-ERROR.
            IF AVAIL ponto-programa THEN DO:
                IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                    assign l-erro     = YES
                           c-mensagem = "Pedido est† sendo faturado.~~Aguarde o mesmo ser liberado.".
                END. /* IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK */
            END. /* IF AVAIL ponto-programa THEN DO: */
        END.

        RUN pi-valida-bloqueio-fat (INPUT  ped-venda.cod-estabel,
                                    OUTPUT c-mensagem).

        IF RETURN-VALUE <> "OK" THEN DO:
            ASSIGN l-erro     = YES.
        END.

        IF tt-param.l-AlocFat THEN DO:

            FOR FIRST ped-item fields ()
                WHERE ped-item.nome-abrev = ped-venda.nome-abrev
                  AND ped-item.nr-pedcli  = ped-venda.nr-pedcli
                  AND (ped-item.qt-alocada > 0
                   OR ped-item.dec-1       > 0) NO-LOCK:

                ASSIGN l-erro     = YES
                       l-embarque = YES
                       c-mensagem = "Pedido vinculado a embarque. Por gentileza, faturar este pedido atravÇs de embarque.".
            END.    
        END.

        IF l-erro = NO THEN DO:
            FOR EACH ped-item OF ped-venda NO-LOCK
               WHERE ped-item.cod-sit-item <= 2
                 AND ped-item.dt-entrega   >= tt-param.fi-dt-entrega-ini
                 AND ped-item.dt-entrega   <= tt-param.fi-dt-entrega-fim:

                ASSIGN de-qt-disponivel = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, tt-digita.cod-depos, "*", NO).

                IF tt-param.libera-item-parcial THEN DO:
                    IF de-qt-disponivel < ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca THEN
                        ASSIGN de-qt-a-alocar = de-qt-disponivel.
                    ELSE 
                        ASSIGN de-qt-a-alocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.
                END.
                ELSE
                    ASSIGN de-qt-a-alocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.

                IF de-qt-a-alocar > 0 
                OR ped-item.qt-log-aloca > 0 THEN 
                    ASSIGN l-entrou = YES.

                IF de-qt-a-alocar = 0 THEN 
                    NEXT.

                IF ped-item.it-codigo <> '4990709' THEN DO:
                    FIND FIRST ITEM NO-LOCK 
                         WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                    IF  AVAIL ITEM 
                    AND ITEM.cod-servico = 0 
                    AND ITEM.baixa-estoq = NO THEN
                        ASSIGN l-entrou = YES.
                END. 

                RUN esp/pdp/espdp006f.p (INPUT c-seg-usuario,
                                         INPUT ROWID(ped-venda),
                                         INPUT ROWID(ped-item),
                                         INPUT tt-digita.cod-depos,
                                         INPUT tt-param.Localizacao,
                                         INPUT de-qt-a-alocar,
                                         INPUT tt-param.cod-unid-neg,
                                         OUTPUT TABLE tt-erro).

                IF CAN-FIND (FIRST tt-erro) THEN DO:
                     assign l-erro     = yes
                            l-entrou   = NO.

                     FOR EACH tt-erro:
                         ASSIGN c-mensagem = c-mensagem + tt-erro.mensagem + CHR(13).
                     END.
                END.
            END. /* for each ped-item of ped-venda  */

            if l-entrou = yes then do:

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
                /****/
            END.

        END.

        if l-entrou = yes then do:
            if l-erro = no then DO:
                ASSIGN l-reserva = FALSE
                       l-cotas   = FALSE.

                FOR EACH ped-item OF ped-venda where ped-item.cod-sit-item <= 2 NO-LOCK:

                    ASSIGN de-qt-a-alocar = 0
                           l-erro         = NO.

                    IF tt-param.libera-item-parcial = NO THEN DO:
                        assign de-qt-a-alocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.
                        IF de-qt-a-alocar      > 0          and
                           ped-item.it-codigo <> '4990709'  and
                           de-qt-a-alocar     <> ped-item.qt-pedida - ped-item.qt-atendida THEN DO:

                            ASSIGN l-erro      = YES
                                   c-mensagem  = "Falta de estoque parcial".
                        END.   
                    END.

                    IF ped-item.qt-log-aloca > 0 THEN DO:
                        ASSIGN l-reserva = TRUE.

                        IF ped-item.dt-entrega > TODAY THEN DO:
                            ASSIGN l-erro     = yes
                                   c-mensagem = "Item com data Futura".
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST ITEM NO-LOCK 
                             WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                        IF AVAIL ITEM THEN DO:
                            IF ITEM.baixa-estoq THEN DO:
                                assign l-erro     = yes
                                       c-mensagem = "Falta de estoque para o item " + ped-item.it-codigo.
                            END.
                        END.
                    END.

                    IF ped-item.cod-sit-com <> 2 THEN DO:
                        assign l-erro     = yes
                               c-mensagem = "Este pedido est† bloqueado por cotas! Liberar atravÇs do programa AC1004 (Aprovaá∆o Manual Cotas por Item).".
                    END.

                    IF  l-erro = NO THEN DO:

                        RUN piAtualizaAstec (INPUT de-qt-a-alocar-astec).

                        run LiberaParaFaturamento.   

                    END. /* IF  l-erro = NO THEN DO: */

                END. /* FOR EACH ped-item OF ped-venda where ped-item.cod-sit-item <= 2 NO-LOCK: */

            END. /* if l-erro = no then DO: */

        END. /* if l-entrou = yes then do: */

        IF  l-erro = NO 
        AND c-mensagem = '' THEN
            ASSIGN c-mensagem = 'Pedido ' + ped-venda.nr-pedcli + ' liberado'.

        IF c-mensagem <> '' THEN DO:
            
            IF tt-param.l-AlocFat = YES THEN DO: /* Gera apenas para FatCom */

                FIND LAST bFatCom
                    WHERE  bFatCom.num-ped-exec    = 111
                     AND  bFatCom.nr-pedcli       = string(ped-venda.nr-pedido)  
                   EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL bFatCom THEN DO:

                    CREATE fat-comercial.                          
                    ASSIGN fat-comercial.nr-sequencia    = 10 
                           fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME 
                           fat-comercial.nome-abrev      = ped-venda.nome-abrev 
                           fat-comercial.nr-pedcli       = string(ped-venda.nr-pedido)
                           fat-comercial.num-ped-exec    = 111
                           fat-comercial.c-status        = c-mensagem.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    IF c-mensagem <> '' THEN ASSIGN bFatCom.c-status        = c-mensagem.
                END.

                FIND CURRENT bFatCom         NO-LOCK NO-ERROR.
                RELEASE bFatCom.

                FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

            END.

            PUT SKIP(1)
               'Ped Cli      Mensagem' SKIP
               '------------ --------------------------------------------------------------------------------------------------------------------------------------------' SKIP
               ped-venda.nr-pedido                    AT 01
               c-mensagem          FORMAT  'X(150)'   AT 14 SKIP(2).
        END. /* IF c-mensagem <> '' THEN DO: */

        IF l-erro-critico THEN DO:
            UNDO, NEXT.
        END.

        delete procedure h-alocacao.

    END. /* FOR EACH ped-venda NO-LOCK  */

END PROCEDURE. /* piSeleciona */


PROCEDURE LiberaParaFaturamento: /* Mesma rotina do espdp006.w botao libera para faturamento */
    DEFINE VARIABLE d-peso-alocado AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-peso-aberto  AS DECIMAL     NO-UNDO.

    DEFINE BUFFER bf-item FOR item.

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
        END.
    END.

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
    
            ASSIGN l-usb                 = NO.

            FOR EACH bPed-item OF Ped-venda NO-LOCK
                WHERE bped-item.cod-sit-item <> 6 :                    
                ASSIGN qt-log-alocaComposto2 = 0.

                IF bPed-item.it-codigo = '4990709' THEN ASSIGN l-usb = YES.

                IF bped-item.qt-log-aloc <> 0 THEN 
                    ASSIGN qt-log-alocaComposto2 = bped-item.qt-log-aloc.
                ELSE DO:
                    RUN pi-composto (INPUT  bped-item.it-codigo,
                                     OUTPUT qt-log-alocaComposto2).

                    IF qt-log-alocaComposto2 = 0 THEN DO:

                        IF bPed-item.it-codigo <> '4990709' THEN DO:
                            FIND FIRST ITEM WHERE ITEM.it-codigo = bped-item.it-codigo NO-LOCK NO-ERROR.
                            IF AVAIL ITEM AND ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO THEN
                                assign qt-log-alocaComposto2 = bped-item.qt-pedida - bped-item.qt-atendida.
                        END. /* IF bPed-item.it-codigo <> '4990709' THEN DO: */
                        ELSE DO:

                            FOR EACH int-ped-item-pai
                                WHERE int-ped-item-pai.nome-abrev    = bped-item.nome-abrev  
                                  AND int-ped-item-pai.nr-pedcli     = ped-venda.nr-pedcli
                                  AND int-ped-item-pai.nr-sequencia  = 10
                                  AND int-ped-item-pai.it-codigo     = bped-item.it-codigo   
                                  AND int-ped-item-pai.cod-refer     = bped-item.cod-refer  NO-LOCK:

                                /*** ASSIGN c-PaiMesmoFilho = int-ped-item-pai.it-codigo-pai.***/

                                FOR EACH b-int-ped-item-pai
                                    WHERE b-int-ped-item-pai.nome-abrev     = bped-item.nome-abrev  
                                      AND b-int-ped-item-pai.nr-pedcli      = ped-venda.nr-pedcli
                                      AND b-int-ped-item-pai.nr-sequencia   = 10
                                      AND b-int-ped-item-pai.it-codigo     <> bped-item.it-codigo   
                                      AND b-int-ped-item-pai.cod-refer      = bped-item.cod-refer  
                                      AND b-int-ped-item-pai.it-codigo-pai  = int-ped-item-pai.it-codigo-pai  NO-LOCK :

                                    FIND FIRST prod-composto
                                        WHERE prod-composto.it-codigo-pai   = b-int-ped-item-pai.it-codigo-pai 
                                          AND prod-composto.it-codigo-filho = b-int-ped-item-pai.it-codigo NO-LOCK NO-ERROR.
                                    IF AVAIL prod-composto THEN DO: /* Multiplicador de filhos */

                                        FOR EACH b-PedItem
                                            WHERE b-PedItem.nome-abrev   = bped-item.nome-abrev
                                              AND b-PedItem.nr-pedcli    = bped-item.nr-pedcli 
                                              AND b-PedItem.it-codigo    = b-int-ped-item-pai.it-codigo NO-LOCK .

                                            IF b-PedItem.qt-log-aloca <> 0 THEN
                                                ASSIGN qt-log-alocaComposto2 = qt-log-alocaComposto2 + (prod-composto.qt-filho * b-PedItem.qt-log-aloca).
                                        END.

                                    END.

                                END. /* FOR EACH b-int-ped-item-pai */

                            END. /* int-ped-item-pai */

                        END. /* IF bPed-item.it-codigo = '4990709' THEN DO: */

                    END. /* IF qt-log-alocaComposto2 = 0 THEN DO: */

                END.

                ASSIGN de-valor    = de-valor                    + (bped-item.vl-tot-it   / bped-item.qt-pedida    * qt-log-alocaComposto2)                           
                       de-vl-total = de-vl-total                 + (bped-item.qt-pedida   - bped-item.qt-atendida) * bped-item.vl-preori
                       de-vl-total-alocado = de-vl-total-alocado + (qt-log-alocaComposto2 * bped-item.vl-preori).

                FOR FIRST bf-item FIELDS(peso-bruto)
                    WHERE bf-item.it-codigo = bPed-item.it-codigo NO-LOCK:

                    ASSIGN d-peso-alocado = d-peso-alocado + (bPed-item.qt-log-aloc * bf-item.peso-bruto)
                           d-peso-aberto  = d-peso-aberto  + ((bPed-item.qt-pedida - bPed-item.qt-atendida) * bf-item.peso-bruto).
                END.
            END.
    
            FIND FIRST atendente
                 WHERE atendente.cd-oper = INT(Ped-venda.tp-pedido) NO-LOCK NO-ERROR.
    
            IF AVAIL atendente THEN DO:
                FIND FIRST minimos-faturamento
                     WHERE minimos-faturamento.oper-mestre = atendente.oper-mestre NO-LOCK NO-ERROR.
    
                
                IF AVAIL minimos-faturamento THEN DO:
                    IF (de-valor / i-parc) < minimos-faturamento.vl-parc-minima THEN DO:
    
        
                        IF de-valor < minimos-faturamento.vl-fatur-minimo THEN DO:

                            ASSIGN l-erro = yes
                                   c-mensagem = "Faturamento inferior ao limite permitido! O valor de R$ " + STRING(de-valor) + " em " + STRING(i-parc) + " parcela(s) Ç inferior a R$ " + STRING(minimos-faturamento.vl-fatur-minimo ).
                            
                        END.
                        ELSE DO:
                            ASSIGN l-erro = yes
                                   c-mensagem = "Valor da Parcela do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-parc-minima) + " O valor Alocado de R$ " + STRING(de-valor).
                        END.
                    END.
                    ELSE 
        
                        IF de-valor < minimos-faturamento.vl-fatur-minimo THEN DO:
                            ASSIGN l-erro = yes
                                   c-mensagem = "Valor Liberado para faturamento inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-fatur-minimo).
         
                        END.
    
                    IF ((de-vl-total - DEC(de-vl-total-alocado)) / i-parc)  > 1 AND /* Maior que 1 para evitar diferenáa de arredondamento */
                       ((de-vl-total - DEC(de-vl-total-alocado)) / i-parc) < minimos-faturamento.vl-saldo-minimo THEN DO:

                        IF l-usb = NO THEN DO: /* se USB n∆o valida */
                            ASSIGN l-erro = YES
                                   c-mensagem = "Valor de Saldo do Pedido por parcela " + STRING((de-vl-total - DEC(de-vl-total-alocado)) / i-parc) + " inferior ao Parametrizado!~~" + CHR(10) +
                                                "Valor de Saldo do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-saldo-minimo) + ".".
                        END. /* IF l-usb = NO THEN DO: */

                    END.

                    IF (d-peso-aberto - d-peso-alocado) < minimos-faturamento.peso-bruto-min THEN DO:
                        IF l-usb = NO THEN DO:
                            ASSIGN l-erro = YES
                                   c-mensagem = "Peso aberto do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.peso-bruto-min) + ".":U.
                        END.
                    END.

                    IF d-peso-alocado < minimos-faturamento.peso-bruto-min THEN DO:
                        IF l-usb = NO THEN DO:
                            ASSIGN l-erro = YES
                                   c-mensagem = "Peso alocado do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.peso-bruto-min) + ".":U.
                        END.
                    END.
                END.
            END.         
       END.
    END.

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
    
    IF ped-venda.dt-entrega > TODAY THEN DO:        
        assign l-erro     = yes
               c-mensagem =  "Item com data Futura".
    END.

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
    
    IF ped-venda.ind-fat-par = NO OR
       tt-param.fatura-total THEN DO:
        FOR EACH bPed-item OF ped-venda
                where bPed-item.cod-sit-item <= 2 NO-LOCK:
            FIND FIRST ITEM WHERE ITEM.it-codigo = bped-item.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM AND ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO AND bped-item.it-codigo <> '4990709' THEN NEXT.
            ELSE DO:
                IF (bPed-item.qt-pedida - bPed-item.qt-atendida - bPed-item.qt-log-aloca) <> 0 THEN DO:
                    IF bPed-item.qt-log-aloca = 0 AND 
                       bPed-item.dt-entrega > TODAY THEN . /* N∆o faz nada */
                    ELSE DO:
                        assign l-erro = yes.
                        IF tt-param.fatura-total THEN
                            assign c-mensagem =  "Pedido alocado parcialmente, n∆o Liberado p/Faturamento".
                        ELSE
                            assign c-mensagem =  "Este pedido n∆o permite faturamento parcial!".

                    END.
                END.
            END.
        END. /* FOR EACH bPed-item OF ped-venda */
    END.
        
    IF  emitente.ind-aval-embarque = 1 THEN  do: /* Definido para Canais */
        IF  ped-venda.cod-sit-aval <> 3 THEN DO:
            
            assign l-erro     = yes
                   c-mensagem =  "Problemas com CrÇdito".
             
        END. 
    END.

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

                for each tt-erros-aval:
                    delete tt-erros-aval.
                end.
            end.
        end.
     END.

     IF ped-venda.cidade-cif <> "" THEN DO:
    
        ASSIGN c-mesgitem = "Verifique se existe pesos (l°quido/bruto) cadastrados para os seguintes itens:" + CHR(13)
               l-peso = TRUE.

        FOR EACH bPed-item OF ped-venda NO-LOCK:
            FIND FIRST ITEM OF bPed-item NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:
                IF ITEM.peso-bruto = 0 OR 
                   ITEM.peso-bruto = ? OR
                   ITEM.peso-liquido = 0 OR 
                   ITEM.peso-liquido = ? THEN DO:
                    ASSIGN c-mesgitem = c-mesgitem + STRING(ITEM.it-codigo) + " - " + ITEM.desc-item + CHR(13)
                           l-peso = FALSE.
                END.
            END.
        END.
        
        IF l-peso = FALSE THEN DO:
            assign l-erro     = YES 
                   c-mensagem =  c-mesgitem.
        END.
    END.           

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

        FIND FIRST bped-venda WHERE bped-venda.nome-abrev = ped-venda.nome-abrev AND
                                    bped-venda.nr-pedcli = ped-venda.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bped-venda THEN DO:         
            FIND int-ped-venda
                WHERE int-ped-venda.nr-pedido = bped-venda.nr-pedido
                AND int-ped-venda.cod-estabel = bped-venda.cod-estabel
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL int-ped-venda THEN
                ASSIGN int-ped-venda.mensagem = "Pedido Liberado Para Faturamento".

            IF tt-param.l-AlocFat = NO THEN DO:
                ASSIGN bped-venda.cod-priori = 10.
            END.

            IF tt-param.l-AlocFat THEN DO:
                FIND FIRST tt-PedidosFaturaveis
                    WHERE tt-PedidosFaturaveis.nr-pedido  = bped-venda.nr-pedido NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-PedidosFaturaveis THEN DO:
                    CREATE tt-PedidosFaturaveis.
                    BUFFER-COPY bped-venda TO tt-PedidosFaturaveis.
                    ASSIGN tt-PedidosFaturaveis.c-mensagemErro = c-mensagem.
                END. /* IF NOT AVAIL tt-PedidosFaturaveis THEN DO: */

            END.

        END.                                  
        FIND CURRENT bped-venda NO-LOCK NO-ERROR.
        RELEASE bped-venda.

     END.
     ELSE DO:

         IF tt-param.l-AlocFat = YES THEN DO: /* Gera apenas para FatCom */
             FIND LAST bFatCom
                 WHERE  bFatCom.num-ped-exec    = 111
                   AND  bFatCom.nr-pedcli       = string(ped-venda.nr-pedido) 
                 EXCLUSIVE-LOCK NO-ERROR.
             IF NOT AVAIL bFatCom THEN DO:
                 CREATE fat-comercial.                          
                 ASSIGN fat-comercial.nr-sequencia    = 10 
                        fat-comercial.dt-fatura       = TODAY
                        fat-comercial.hr-fatura       = TIME 
                        fat-comercial.nome-abrev      = ped-venda.nome-abrev 
                        fat-comercial.nr-pedcli       = string(ped-venda.nr-pedido) 
                        fat-comercial.num-ped-exec    = 111
                        fat-comercial.c-status        = c-mensagem.
             END. /* IF NOT AVAIL fat-comercial THEN DO: */
             ELSE DO:
                 IF c-mensagem <> '' THEN
                     ASSIGN bFatCom.c-status        = c-mensagem.
             END.
             
             FIND CURRENT bFatCom         NO-LOCK NO-ERROR.
             RELEASE bFatCom.

             FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
             RELEASE fat-comercial.
         END.
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


PROCEDURE piTransdereSemAE:
     DEFINE VARIABLE vQtTransfere AS DECIMAL     NO-UNDO.
     DEFINE VARIABLE de-qt-saldo  AS DECIMAL     NO-UNDO.
     EMPTY TEMP-TABLE tt-erro.
     EMPTY TEMP-TABLE tt-item.
 
     ASSIGN vQtTransferida = 0.

     FOR EACH saldo-estoq NO-LOCK 
         WHERE saldo-estoq.cod-estabel = ped-venda.cod-estabel
         AND   saldo-estoq.it-codigo   = ped-ent.it-codigo
         AND   saldo-estoq.cod-refer   = ped-ent.cod-refer
         AND   saldo-estoq.cod-depos   = tt-digita.cod-depos   
         AND   saldo-estoq.cod-localiz <> "":

         ASSIGN de-qt-saldo = fnEstoque(tt-PedidosFaturaveis.cod-estabel, tt-itensPedido.it-codigo, tt-digita.cod-depos, saldo-estoq.cod-localiz, NO).

         IF de-qt-saldo < vQtAlocar THEN 
            NEXT.
    
        IF   de-qt-saldo >= vQtAlocar THEN 
             ASSIGN vQtTransfere = vQtAlocar.
        ELSE ASSIGN vQtTransfere = de-qt-saldo.
    
        ASSIGN cReturn = "".
        FIND tt-item
            WHERE tt-item.TipoTrans    = 1 /* 1 - Entrada*/
              AND tt-item.cod-estabel  = ped-venda.cod-estabel
              AND tt-item.it-codigo    = ped-ent.it-codigo 
              AND tt-item.cod-depos    = tt-digita.cod-depos
              AND tt-item.cod-localiz  = ""
              AND tt-item.serie        = ""
              AND tt-item.nro-docto    = string(ped-venda.nr-pedido)
              AND  tt-item.lote        = ""
              AND tt-item.cod-refer    = "" NO-LOCK NO-ERROR.
    
    
        IF NOT AVAIL tt-item THEN
           CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
               tt-item.cod-estabel  = ped-venda.cod-estabel
               tt-item.it-codigo    = ped-ent.it-codigo 
               tt-item.cod-depos    = tt-digita.cod-depos
               tt-item.cod-localiz  = ""
               tt-item.quantidade   = vQtTransfere
               tt-item.serie        = ""
               tt-item.nro-docto    = string(ped-venda.nr-pedido)
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".
    
        FIND tt-item
            WHERE tt-item.TipoTrans    = 2 /* 2 - Saida */
              AND tt-item.cod-estabel  = ped-venda.cod-estabel
              AND tt-item.it-codigo    = ped-ent.it-codigo 
              AND tt-item.cod-depos    = tt-digita.cod-depos
              AND tt-item.cod-localiz  = saldo-estoq.cod-localiz
              AND tt-item.serie        = ""
              AND tt-item.nro-docto    = string(ped-venda.nr-pedido)
              AND  tt-item.lote        = ""
              AND tt-item.cod-refer    = "" NO-LOCK NO-ERROR.
    
        IF NOT AVAIL tt-item THEN
           CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 2 /* 2 - Saida */
               tt-item.it-codigo    = ped-ent.it-codigo 
               tt-item.cod-estabel  = ped-venda.cod-estabel
               tt-item.cod-depos    = tt-digita.cod-depos
               tt-item.quantidade   = vQtTransfere
               tt-item.serie        = ""
               tt-item.nro-docto    = string(ped-venda.nr-pedido)
               tt-item.cod-localiz  = saldo-estoq.cod-localiz
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".
    
        ASSIGN vQtTransferida = vQtTransferida + vQtTransfere
               vQtAlocar      = vQtAlocar - vQtTransfere.
    
        IF vQtAlocar <= 0 THEN LEAVE.
        /*
        FAZ A EFETIVA TRANSFERENCIA ENTRE DEP‡SITOS
        */
     END.
    
    RUN esapi/esapi002.p (INPUT 1, /* Transferància Entre Dep¢sitos */
                          INPUT "ESPDP003",
                          INPUT  TABLE tt-item,
                          OUTPUT TABLE tt-erro).
 
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

                RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ped-item.nome-abrev,
                                                               INPUT ped-item.nr-pedcli,
                                                               INPUT ped-item.nr-sequencia,
                                                               INPUT ped-item.it-codigo,
                                                               INPUT 1,
                                                               INPUT p-de-qt-a-alocar).

                IF ped-item.qt-log-aloca <> 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                IF ped-item.qt-alocada   <> 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                IF  ped-item.qt-log-aloca = 0 
                AND ped-item.qt-alocada   = 0 THEN
                    ASSIGN int-ped-item-astec.qt-alocada = 0.

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

    FOR EACH tt-itensPedido.
        DELETE tt-itensPedido.
    END.

    FOR EACH tt-notas-geradas:
        DELETE tt-notas-geradas.
    END.

    /* Inicializaá∆o das BOS para C†lculo */
    run dibo/bodi317in.p persistent set h-bodi317in.
    run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                     output h-bodi317sd,     
                                     output h-bodi317im1bra,
                                     output h-bodi317va).

    run leaveCodEstabel in h-bodi317sd (input  tt-PedidosFaturaveis.cod-estabel,
                                        input  no,
                                        output c-char-aux).

    RUN pi-valida-bloqueio-fat (INPUT  tt-PedidosFaturaveis.cod-estabel,
                                OUTPUT c-mensagem).

    IF RETURN-VALUE <> "OK" THEN DO:
        ASSIGN l-erro     = YES.
    END.

    IF tt-param.l-AlocFat = YES THEN DO: /* Gera apenas para FatCom */
        FIND LAST bFatCom
          WHERE  bFatCom.num-ped-exec    = 111
            AND  bFatCom.nr-pedcli       = string(tt-PedidosFaturaveis.nr-pedido)  
          EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL bFatCom THEN DO:
          CREATE fat-comercial.                          
          ASSIGN fat-comercial.nr-sequencia    = 10 
                 fat-comercial.dt-fatura       = TODAY
                 fat-comercial.hr-fatura       = TIME 
                 fat-comercial.nome-abrev      = tt-PedidosFaturaveis.nome-abrev 
                 fat-comercial.nr-pedcli       = string(tt-PedidosFaturaveis.nr-pedido) 
                 fat-comercial.num-ped-exec    = 111
                 fat-comercial.c-status        = c-mensagem.
        END. /* IF NOT AVAIL fat-comercial THEN DO: */
        ELSE DO:
                ASSIGN bFatCom.c-status        = IF c-mensagem = '' THEN c-mensagem ELSE tt-PedidosFaturaveis.c-mensagemErro.
        END.

        FIND CURRENT bFatCom         NO-LOCK NO-ERROR.
        RELEASE bFatCom.

        FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
        RELEASE fat-comercial.
    END.

    FIND FIRST tt-digita
         WHERE tt-digita.cod-estabel = tt-PedidosFaturaveis.cod-estabel NO-ERROR.

    IF NOT AVAIL tt-digita THEN DO:
        PUT "1antes do erro " SKIP.
        ASSIGN l-erro     = YES
               c-mensagem = "N∆o encontrado dep¢sito para alocaá∆o no estabelecimento " + ped-venda.cod-estabel.
    END.

    IF c-mensagem = '' THEN DO:

        FOR EACH ped-item OF tt-PedidosFaturaveis EXCLUSIVE-LOCK:
            CREATE tt-itensPedido.
            BUFFER-COPY ped-item TO tt-itensPedido.
            ASSIGN ped-item.qt-log-aloca = 0
                   /*ped-item.qt-alocada   = 0 */ .
        END. /* FOR EACH ped-item OF tt-PedidosFaturaveis EXCLUSIVE-LOCK: */
        FIND CURRENT ped-item NO-LOCK NO-ERROR.
        RELEASE ped-item.
    
    
        /* Informaá‰es do embarque para c†lculo */
        assign c-cod-estabel     = tt-PedidosFaturaveis.cod-estabel    /* Estabelecimento do pedido  */
               c-serie           = c-char-aux                /* SÇrie das notas            */
               c-nome-abrev      = tt-PedidosFaturaveis.nome-abrev     /* Nome abreviado do cliente  */
               c-nr-pedcli       = tt-PedidosFaturaveis.nr-pedcli      /* Nr pedido do cliente       */
               da-dt-emis-nota   = IF AVAIL ser-estab THEN ser-estab.dt-ult-fat 
                                   ELSE TODAY               /* Data de emiss∆o da nota    */
               c-nat-operacao    = ?                        /* Quando Ç ? busca do pedido */
               c-cod-canal-venda = ?.                       /* Quando Ç ? busca do pedido */
        
        /************************************* ped-saldo */

        FOR EACH ped-saldo no-lock     
          where ped-saldo.nome-abrev    = tt-PedidosFaturaveis.nome-abrev       
            and ped-saldo.nr-pedcli     = tt-PedidosFaturaveis.nr-pedcli .
        
            FIND FIRST tt-ped-saldo
                where
/*                  tt-ped-saldo.cod-depos   = tt-digita.cod-depos */
                      tt-ped-saldo.cod-estabel = ped-saldo.cod-estabel
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
                ASSIGN tt-ped-saldo.cod-depos   = tt-digita.cod-depos.

                CREATE tt-PedSaldoShared.
                BUFFER-COPY ped-saldo TO tt-PedSaldoShared.
            END. /* IF NOT AVAIL tt-ped-saldo THEN DO: */

        END. /* FOR EACH ped-saldo no-lock */
        /************************************* ped-saldo */
        
        IF c-mensagem = '' THEN DO:

            for each ped-ent of tt-PedidosFaturaveis
                where ped-ent.qt-log-aloca <> 0 no-lock:
        
                assign l-unallocateDelivery = yes.
        
                if  not valid-handle(h-bodi149) or
                    h-bodi149:type      <> "PROCEDURE":U or
                    h-bodi149:file-name <> "dibo/bodi149.p":U then
                    run dibo/bodi149.p persistent set h-bodi149.
        
                run unallocateDelivery in h-bodi149(input  rowid(ped-ent),
                                                    input  ped-ent.qt-log-aloca).

                IF VALID-HANDLE(h-bodi149) THEN DO:
                   run destroyBO in h-bodi149.
                   run destroy   in h-bodi149.
                   delete procedure h-bodi149.
                   ASSIGN h-bodi149 = ?.
                END.  /* if  valid-handle(h-bodi149) then do */                 
        
            end. /*  for each ped-ent of tt-PedidosFaturaveis */
        
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
        
                /* tratativa itens que foram tratados para n∆o considerar alocaá∆o */
                FOR EACH tt-itensPedido,
                    FIRST ped-item EXCLUSIVE-LOCK
                    WHERE ped-item.nome-abrev    = tt-itensPedido.nome-abrev  
                      and ped-item.nr-pedcli     = tt-itensPedido.nr-pedcli   
                      and ped-item.nr-sequencia  = tt-itensPedido.nr-sequencia
                      and ped-item.it-codigo     = tt-itensPedido.it-codigo   
                      and ped-item.cod-refer     = tt-itensPedido.cod-refer :

                    ASSIGN l-wms = NO.

                    FOR FIRST item-uni-estab NO-LOCK
                        WHERE item-uni-estab.cod-estabel = tt-PedidosFaturaveis.cod-estabel
                        AND   item-uni-estab.it-codigo   = tt-itensPedido.it-codigo
                        AND   item-uni-estab.nr-linha    = 20:  
                    END. 

                    IF NOT avail item-uni-estab then do:
                        /****************************/
                        /* Validacao MFT x WMS  */
                        FIND FIRST deposito 
                            WHERE deposito.cod-depos    = tt-digita.cod-depos NO-LOCK NO-ERROR.
                        IF AVAIL deposito THEN DO:
    
                            IF deposito.log-gera-wms = YES THEN DO:
    
                                IF fnEstoque(tt-PedidosFaturaveis.cod-estabel, tt-itensPedido.it-codigo, tt-digita.cod-depos, tt-param.Localizacao, NO) < tt-itensPedido.qt-log-aloca THEN DO:
                                    ASSIGN l-wms         = YES.
                                END. 
                            END. /* IF AVAIL deposito THEN DO: */
    
                        END. /* IF AVAIL deposito THEN DO: */
                        /****************************/
                        /* FIM Validacao MFT x WMS  */

                    END.

                    IF l-wms = NO THEN DO:

                        ASSIGN ped-item.qt-log-aloca = tt-itensPedido.qt-log-aloca
                               qt-log-alocaComposto  = 0.

                        IF ped-item.qt-log-aloca = 0 THEN DO:
                            RUN pi-composto (INPUT  ped-item.it-codigo,
                                             OUTPUT qt-log-alocaComposto).
                            IF qt-log-alocaComposto <> 0 THEN
                                ASSIGN ped-item.qt-log-aloca = qt-log-alocaComposto.
                            ELSE
                                ASSIGN ped-item.qt-log-aloca = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.
                        END. /* IF ped-item.qt-log-aloca = 0 THEN DO: */
                        DELETE tt-itensPedido.
                    END.
                END. /* FOR EACH tt-itensPedido */
                FIND CURRENT ped-item NO-LOCK NO-ERROR.
                RELEASE ped-item.
        
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
        
                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    /* Finalizaá∆o das BOS utilizada no c†lculo */
                    IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                    IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                    IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                    IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
                    undo, leave.
                END.
        
                /* Bloco a ser repetido para cada item da nota */
                bloco-cria-item:
                FOR EACH ped-item OF tt-PedidosFaturaveis        
                   WHERE ped-item.cod-sit-item <= 2 NO-LOCK:
    
                    FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL ITEM THEN DO:
    
                        IF ped-item.qt-log-aloca = 0 THEN DO:

                            /* Trata erro WMS */
                            FIND FIRST tt-itensPedido
                                WHERE tt-itensPedido.nome-abrev    = ped-item.nome-abrev  
                                  AND tt-itensPedido.nr-pedcli     = ped-item.nr-pedcli   
                                  AND tt-itensPedido.nr-sequencia  = ped-item.nr-sequencia
                                  AND tt-itensPedido.it-codigo     = ped-item.it-codigo   
                                  AND tt-itensPedido.cod-refer     = ped-item.cod-refer     NO-LOCK NO-ERROR.
                            IF AVAIL tt-itensPedido THEN DO:
                                ASSIGN c-mensagem = "Saldo indisponivel WMS! Item " + ped-item.it-codigo + " nao possui saldo f°sico disponivel no deposito " + tt-digita.cod-depos + "." .
                            END.
                        END. /* IF ped-item.qt-log-aloca = 0 THEN DO: */
                        /**************/

                        IF ped-item.qt-pedida = ped-item.qt-atendida THEN NEXT.
                        
                        IF c-mensagem = '' AND ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO OR ped-item.qt-log-aloca <> 0 THEN DO:
    
                            assign c-it-codigo                   = ped-item.it-codigo                       /* C¢digo do item     */
                                   c-cod-refer                   = ped-item.cod-refer                       /* Referància do item */
                                   /*de-quantidade                 = ped-item.qt-log-aloca                    /* Quantidade         */*/
                                   de-vl-preori-ped              = ped-item.vl-preori                       /* Preáo unit†rio     */
                                   de-val-pct-desconto-tab-preco = ped-item.val-pct-desconto-tab-preco      /* Desconto de tabela */
                                   de-per-des-item               = ped-item.per-des-item                    /* Desconto do item   */
                                   l-ped-saldo                   = NO.
    
                            ASSIGN de-quantidade = 0.
                            IF ped-item.it-codigo = '4990709' THEN DO:
    
                                FOR EACH int-ped-item-pai
                                    WHERE int-ped-item-pai.nome-abrev    = ped-item.nome-abrev  
                                      AND int-ped-item-pai.nr-pedcli     = ped-item.nr-pedcli
                                      AND int-ped-item-pai.nr-sequencia  = 10
                                      AND int-ped-item-pai.it-codigo     = ped-item.it-codigo   
                                      AND int-ped-item-pai.cod-refer     = ped-item.cod-refer  NO-LOCK:
    
                                    /*** ASSIGN c-PaiMesmoFilho = int-ped-item-pai.it-codigo-pai.***/
    
                                    FOR EACH b-int-ped-item-pai
                                        WHERE b-int-ped-item-pai.nome-abrev     = ped-item.nome-abrev  
                                          AND b-int-ped-item-pai.nr-pedcli      = ped-item.nr-pedcli
                                          AND b-int-ped-item-pai.nr-sequencia   = 10
                                          AND b-int-ped-item-pai.it-codigo     <> ped-item.it-codigo   
                                          AND b-int-ped-item-pai.cod-refer      = ped-item.cod-refer  
                                          AND b-int-ped-item-pai.it-codigo-pai  = int-ped-item-pai.it-codigo-pai  NO-LOCK :
    
                                        FIND FIRST prod-composto
                                            WHERE prod-composto.it-codigo-pai   = b-int-ped-item-pai.it-codigo-pai 
                                              AND prod-composto.it-codigo-filho = b-int-ped-item-pai.it-codigo NO-LOCK NO-ERROR.
                                        IF AVAIL prod-composto THEN DO: /* Multiplicador de filhos */
    
                                            FOR EACH b-PedItem
                                                WHERE b-PedItem.nome-abrev   = ped-item.nome-abrev
                                                  AND b-PedItem.nr-pedcli    = ped-item.nr-pedcli 
                                                  AND b-PedItem.it-codigo    = b-int-ped-item-pai.it-codigo NO-LOCK .
    
                                                IF b-PedItem.qt-log-aloca <> 0 THEN
                                                    ASSIGN de-quantidade = de-quantidade + (prod-composto.qt-filho * b-PedItem.qt-log-aloca).
                                            END.
    
                                        END.
    
                                    END. /* FOR EACH b-int-ped-item-pai */
    
                                END. /* int-ped-item-pai */
    
                            END. /* IF ped-item.it-codigo = '4990709' THEN DO: */
                            ELSE DO:
                                IF ITEM.cod-servico = 0 AND ITEM.baixa-estoq = NO THEN
                                    ASSIGN de-quantidade = ped-item.qt-pedida - ped-item.qt-atendida.
                                ELSE 
                                    ASSIGN de-quantidade = ped-item.qt-log-aloca. /* Quantidade         */
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
                                for each RowErrors:
                                    IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                                    ASSIGN c-mensagem = "Erro BO  " + tt-PedidosFaturaveis.nr-pedcli + " " + ped-item.it-codigo + " " + 
                                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem.        
                                end.
    
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
    
                            FOR EACH tt-ped-saldo NO-LOCK:
                                IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                   WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                     AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto
                                     AND wt-fat-ser-lote.cod-depos         <> tt-ped-saldo.cod-depos) THEN DO:
                                    ASSIGN l-ped-saldo = YES.
                                END. /* IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK */
                                IF l-ped-saldo = YES THEN LEAVE.
                            END. /* FOR EACH tt-ped-saldo NO-LOCK: */
    
                            IF l-ped-saldo = NO THEN DO:
                                IF NOT CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                   WHERE wt-fat-ser-lote.seq-wt-docto       = i-seq-wt-docto
                                     AND wt-fat-ser-lote.seq-wt-it-docto    = i-seq-wt-it-docto) THEN
                                    ASSIGN l-ped-saldo = YES.
                            END. /* IF l-ped-saldo = NO THEN DO: */

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
    
                                    ASSIGN c-cod-localizExp = ''.
    
                                    FIND FIRST deposito 
                                        WHERE deposito.cod-depos    = tt-ped-saldo.cod-depos NO-LOCK NO-ERROR.
                                    IF AVAIL deposito THEN DO:
                                        IF  deposito.cod-depos    <> 'EXP'
                                        AND deposito.log-gera-wms  =   NO THEN
                                            ASSIGN c-cod-localizExp = tt-ped-saldo.cod-localiz.
                                   END. /* IF AVAIL deposito THEN DO: */
    
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
                                        WHERE deposito.cod-depos    = wt-fat-ser-lote.cod-depos NO-LOCK NO-ERROR.
                                    IF AVAIL deposito THEN DO:
                                        IF deposito.cod-depos     = 'EXP'
                                        OR deposito.log-gera-wms  = YES THEN
                                            ASSIGN wt-fat-ser-lote.cod-locali = ''.
                                    END. /* IF AVAIL deposito THEN DO: */
    
                                END.
    
                            END.
                            FIND CURRENT wt-fat-ser-lote NO-LOCK NO-ERROR.
                            RELEASE wt-fat-ser-lote.
    
                            find first saldo-estoq
                                 where saldo-estoq.it-codigo   = c-it-codigo           
                                   and saldo-estoq.cod-estabel = tt-ped-saldo.cod-estabel
                                   and saldo-estoq.cod-depos   = tt-ped-saldo.cod-depos 
                                   and saldo-estoq.cod-localiz = '' NO-LOCK no-error.

                            /*************************************************/
                            /*************************************************/
                            /*************************************************/
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

                            /* Busca poss°veis erros que ocorreram nas validaá‰es */
                            run devolveErrosbodi317pr in h-bodi317pr(output c-ultimo-metodo-exec,
                                                                     output table RowErrors).


                            FIND FIRST deposito 
                                WHERE deposito.cod-depos = tt-ped-saldo.cod-depos NO-LOCK NO-ERROR.
                            IF AVAIL deposito AND deposito.log-gera-wms  = YES THEN DO:
                                for each RowErrors
                                    where (RowErrors.ErrorNumber = 15178
                                       OR  RowErrors.ErrorNumber = 15811
                                       OR  RowErrors.ErrorNumber = 26082
                                       OR  RowErrors.ErrorNumber = 27607
                                       OR  RowErrors.ErrorNumber = 18168) :
                                    delete RowErrors.
                                end.
                            END.

                            find first saldo-estoq
                                 where saldo-estoq.it-codigo   = c-it-codigo           
                                   and saldo-estoq.cod-estabel = tt-ped-saldo.cod-estabel
                                   and saldo-estoq.cod-depos   = tt-ped-saldo.cod-depos 
                                   and saldo-estoq.cod-localiz = '' NO-LOCK no-error.

                             /* Pesquisa algum erro ou advertància que tenha ocorrido */
                             find first RowErrors no-lock no-error.
                             /* Caso tenha achado algum erro ou advertància, mostra em tela */
                             if  avail RowErrors then
                                 for each RowErrors:
                                     IF  RowErrors.errorSubType  = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ 
                                     AND RowErrors.ErrorNumber  <> 15811 THEN
                                     ASSIGN c-mensagem = "Erro BO 2 " + tt-PedidosFaturaveis.nr-pedcli + " " + ped-item.it-codigo + " " + 
                                                         RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem.        
                                 end.

                            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                            if  not l-proc-ok-aux then
                                undo, leave.

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
                                                        RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem.        
                                end.
    
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
    
                                    ASSIGN wt-it-docto.nr-entrega       = ped-ent.nr-entrega
                                           wt-it-docto.quantidade[2]    = wt-it-docto.quantidade[1].
                                END. /* FOR EACH wt-it-docto */
    
                            END. /* IF AVAIL ped-ent THEN DO: */
    
                        END. /* IF (ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca) <> 0 THEN DO: */
                        /**************/
    
                    END. /* IF AVAIL ITEM THEN DO: */
                    
                end. /* FOR EACH ped-item OF tt-PedidosFaturaveis */
        
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
                
                /* Caso tenha achado algum erro ou advertància, mostra em tela */
                if  avail RowErrors then
                    for each RowErrors:
                        IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                        ASSIGN c-mensagem = "Erro BO 4 " + tt-PedidosFaturaveis.nr-pedcli + " " + 
                                            RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem.        
                    end.
    
                /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
                if  not l-proc-ok-aux THEN DO:
                    /* Finalizaá∆o das BOS utilizada no c†lculo */
                    IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                    IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                    IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                    IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
    
                    UNDO, LEAVE.
    
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
                        IF RowErrors.errorSubType = "ERROR" /* OR RowErrors.errorSubType = "WARNING" */ THEN
                        ASSIGN c-mensagem = "Erro BO 5 " + tt-PedidosFaturaveis.nr-pedcli + " " +  
                                            RowErrors.ErrorDescription + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U + CHR(10) + "  " + c-mensagem.        
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
            
                /* Busca as notas fiscais geradas */
                run buscaTTNotasGeradas in h-bodi317ef(output l-proc-ok-aux,
                                                       output table tt-notas-geradas).
        
                /* Finalizaá∆o das BOS utilizada no c†lculo */
                IF VALID-HANDLE(h-bodi317in)     THEN run finalizaBOS in h-bodi317in.
                IF VALID-HANDLE(h-bodi317in)     THEN delete procedure h-bodi317in.
                IF VALID-HANDLE(h-bodi317ef)     THEN delete procedure h-bodi317ef.
                IF VALID-HANDLE(h-bodi317im1bra) THEN delete procedure h-bodi317im1bra.
    
                leave.
        
            end. /* TRANS */

        END. /* IF c-mensagem = '' THEN DO: */

    END. /* IF c-mensagem = '' THEN DO: */
    
    /* Caso tenha achado algum erro retorna prioridade 01 */
    find first RowErrors
         where RowErrors.ErrorSubType = "ERROR":U no-error.
    if  avail RowErrors THEN DO:
        ASSIGN tt-PedidosFaturaveis.cod-priori = 01.
        UNDO, LEAVE.
    END.

    IF l-entregaFutura THEN 
        ASSIGN tt-PedidosFaturaveis.cod-priori = 01.

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

                FIND LAST fat-comercial
                    WHERE  fat-comercial.num-ped-exec  = 111
                      AND (fat-comercial.nr-pedcli     = string(nota-fiscal.nr-pedido)
                       OR  fat-comercial.nr-pedcli     = nota-fiscal.nr-pedcli)
                      AND  fat-comercial.nome-abrev    = emitente.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL fat-comercial THEN DO:
                    ASSIGN fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                           fat-comercial.serie       = nota-fiscal.serie
                           fat-comercial.nr-nota-fis = tt-notas-geradas.nr-nota 
                           fat-comercial.dt-fatura   = TODAY
                           fat-comercial.hr-fatura   = TIME.
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
                        
                END.
            END.

            if  tt-notas-geradas.nr-nota = b-tt-notas-geradas.nr-nota then
                ASSIGN c-mensagem = ''
                       c-mensagem = "Pedido " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli +
                             (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + "  Gerou Nota: Estab " + string(nota-fiscal.cod-estabel)  + " Serie " + string(nota-fiscal.serie) + " Nota " + string(tt-notas-geradas.nr-nota).
            else
                ASSIGN c-mensagem = ''
                       c-mensagem = "Pedido " + tt-PedidosFaturaveis.nome-abrev + " / " + tt-PedidosFaturaveis.nr-pedcli +
                             (IF c-mensagem = "":U THEN "":U ELSE CHR(10)) + "  Gerou Nota: Estab " + string(nota-fiscal.cod-estabel)  + " Serie " + string(nota-fiscal.serie) + " Nota " + string(tt-notas-geradas.nr-nota) +  " - " + string(b-tt-notas-geradas.nr-nota).

        end. /* for  first nota-fiscal  */
        bell.

    end.

    FIND LAST fat-comercial
        WHERE  fat-comercial.num-ped-exec  = 111
          AND  fat-comercial.nr-pedcli     = string(tt-PedidosFaturaveis.nr-pedido)
          AND  fat-comercial.nome-abrev    = tt-PedidosFaturaveis.nome-abrev EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL fat-comercial THEN DO:

        IF  c-mensagem              <> '' 
        AND fat-comercial.c-status   = '' THEN DO:
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

/*pi-valida-bloqueio-fat*/
{esp/pdp/espdp006.i2}


