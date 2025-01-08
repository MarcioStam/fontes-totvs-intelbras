/***********************************************************************
**  Programa..: UPC\re1005rp-epc.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 16/11/2004 - Desenvolvimento Programa

compile \\tsclient\c\fontes\upc\re1005rp-epc.p save into c:\temp\upc.
************************************************************************/
{utp/ut-glob.i}
{include/i-epc200.i1}
{upc/btb910za-upc.i}
{method/dbotterr.i}
{btb/btb912zb.i}

/*{adapters/xml/ep2/axsep006.i}                  /* Definiá‰es Tabelas Tempor†rias           */*/

/**/

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

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


DEF VAR i-cont AS INTE NO-UNDO.
DEF VAR c-narrativa AS CHAR NO-UNDO.
DEFINE VARIABLE h-boun135   AS HANDLE  NO-UNDO.    
DEFINE VARIABLE l-cria-cabecalho AS LOGICAL     NO-UNDO.
def var l-erro-x                 as logical   no-undo.
DEF VAR c-cod-estabel            AS CHAR NO-UNDO.
DEFINE VARIABLE h-boes398 AS HANDLE      NO-UNDO.
DEFINE VARIABLE p-erro           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-dt-implant-ped AS DATE NO-UNDO.

DEFINE VARIABLE c-nat-operacao LIKE ficha-cq.nat-operacao LABEL "Nat. Operaá∆o" NO-UNDO.
DEF VAR c-cod-depos            AS CHAR NO-UNDO.
DEFINE VARIABLE c-retorno      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-gerou-ficha-html AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-transacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-identific    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-unid-neg     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-tot-dev     AS DECIMAL     NO-UNDO.

DEFINE VARIABLE raw-param    AS RAW         NO-UNDO.
DEF VAR i-nr AS INT NO-UNDO.

DEFINE VARIABLE h-boun178 AS HANDLE     NO-UNDO.
def var c-mail-destino as char no-undo.
def var c-return       as char no-undo.
DEF VAR c-correcao AS LOGICAL INITIAL NO NO-UNDO.
def var l-gera-nf as log no-undo.
/*def var c-conta-contabil like movto-estoq.conta-contabil no-undo.*/
def var c-nro-docto like item-doc-est.nro-comp no-undo.
def var c-nro-comp  like item-doc-est.nro-comp no-undo.

DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pedido        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-perc AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-bodi159 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi157 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi154 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi159cal AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-vl-merc-liq AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat.
DEFINE TEMP-TABLE tt-ped-venda    no-undo like ped-venda
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-item     no-undo like ped-item
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-ent      no-undo like ped-ent
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-repre    no-undo like ped-repre
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-antecip  no-undo like ped-antecip
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-cond-ped     no-undo like cond-ped
    field r-rowid  as rowid.

def temp-table tt-ped-vendor NO-UNDO
    field data-base    as date
    field dias-base    as int  format ">>>9"
    field cod-cond-pag as int  format ">9"
    field taxa-cliente as dec  format ">>9.9999".

DEF TEMP-TABLE tt-unid-neg NO-UNDO
    FIELD unid-neg LIKE  unid-neg-item.cod_unid_negoc
    FIELD cod-canal-venda  LIKE ped-venda.cod-canal-venda
    FIELD valor AS DEC.

DEF BUFFER b-natur-oper FOR natur-oper.

{esp/es0006a.i}
{esp/es0006.i}
{esp/es0018.i}
DEF TEMP-TABLE tt-prog-ponto-1 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

{esp/eslib.i} /*{cdp/cd0666.i}*/
{esapi/esapi010tt.i}
{esp/cqp/escqp003tt.i}

DEFINE VARIABLE l-bloqueia-pedido AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-bloqueia-fifo   AS LOGICAL INITIAL NO NO-UNDO.

/****************************  Variaveis    ****************************/
DEFINE TEMP-TABLE tt-AtuErro NO-UNDO LIKE tt-erro.

DEFINE VARIABLE l-continua-pendencia AS LOGICAL  INITIAL YES   NO-UNDO.

CASE pIndEvent:

    
    WHEN "inicio-verifica-documento" THEN DO:   
        
        /* PONTO 3 - Chamado no inicio da atualizaá∆o da nota passando o recid da tabela DOCUM-EST 
                     para o parametro r-registro1. Existe tratamento para variavel controle erro. */
        ASSIGN l-bloqueia-pedido = FALSE
               l-bloqueia-fifo   = FALSE.

        FOR FIRST tt-epc WHERE
                  tt-epc.cod-event     = pIndEvent AND
                  tt-epc.cod-parameter = "docum-est rowid":
            FIND FIRST docum-est NO-LOCK WHERE
                 ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.     
                 
            IF NOT AVAIL docum-est THEN RETURN "ok". 
            
            /*Validar nota completa*/
            FIND FIRST int-docum-est NO-LOCK
                 WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                   AND int-docum-est.nro-docto    = docum-est.nro-docto
                   AND int-docum-est.cod-emitente = docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = docum-est.nat-operacao  NO-ERROR.

            RUN esp/es0018p.p (INPUT "re1005rp",
                               INPUT 10, /* Naturezas que nao valida nota completa*/
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).

            IF NOT AVAIL int-docum-est
            OR NOT int-docum-est.nota-completa THEN DO:
                IF NOT CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN DO:
                    PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "O documento deve estar marcado como completo!" AT 53 FORMAT "x(75)" SKIP.
                        RETURN "NOK".
                END.
            END.
                

            /* Chamado IR63195 */
            IF  docum-est.cod-observa                    = 4 AND /* Serviáos */ 
                INT(SUBSTRING(docum-est.char-2,143,8))  <> 9     /* Sem cobranáa de frete */
            THEN DO:
                FIND CURRENT docum-est EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN OVERLAY(docum-est.char-2,143,8) = "9".
                FIND CURRENT docum-est NO-LOCK NO-ERROR.
            END.

            IF NOT CAN-FIND (FIRST modalid-frete WHERE modalid-frete.cod-modalid-frete = substring(docum-est.char-2,143,8)) THEN DO:
                PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                        "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                    PUT docum-est.serie-docto at 1.
                    PUT docum-est.nro-docto   at 7.
                    PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                    PUT docum-est.nat-operacao at 35.
                    PUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600  !" AT 53 FORMAT "x(75)" SKIP.
                    RETURN "NOK".
            
            END.

            FIND FIRST param-estoq NO-LOCK NO-ERROR.

            FIND natur-oper WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
            IF NOT AVAIL natur-oper THEN RETURN "OK".

            FIND emitente WHERE
                 emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
            IF NOT AVAIL emitente THEN RETURN "ok".

            RUN esp/es0018p.p (INPUT "re1005rp",
                               INPUT 6, /* Gera Pedido de venda de acordo com as naturezas cadastradas neste ponto */
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).

            for each tt-prog-ponto where 
                entry(1,tt-prog-ponto.conteudo,";") = docum-est.nat-operacao:
                IF emitente.ind-cre-cli = 4 THEN DO:
                    PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                        "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                    PUT docum-est.serie-docto at 1.
                    PUT docum-est.nro-docto   at 7.
                    PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                    PUT docum-est.nat-operacao at 35.
                    PUT "Cliente Suspenso para Implantaá∆o/Efetivaá∆o do Pedidos, Avise Responsavel  !" AT 53 FORMAT "x(75)" SKIP.
                    RETURN "NOK".

                END.
            END.
            
            IF  natur-oper.nota-rateio  = NO /*AND
                NOT natur-oper.nat-operacao BEGINS "162"*/ THEN DO:

                FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.

                IF /*docum-est.cod-estabel = '101' and*/
                   item-doc-est.cod-depos = "rec" THEN DO: 

                    FIND FIRST ae-entrada 
                         WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
                           AND ae-entrada.nro-docto    = int(docum-est.nro-docto) 
                           AND ae-entrada.cod-emitente = docum-est.cod-emitente  NO-LOCK NO-ERROR.
                    IF NOT AVAIL ae-entrada THEN DO:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "N∆o informado volume e localizaá∆o. NF n∆o atualizada!" AT 53 FORMAT "x(75)" SKIP.
                        RETURN "NOK".
                    END.
                END.
            END.

            ASSIGN l-erro-x = NO.

            /* Incidente 5470 - Nao atualizar NF quando nao houver duplicata para natureza que Gera Duplicata. Somente para Emitentes nacionais. */
            IF natur-oper.emite-duplic THEN DO:
                RUN pi-verifica-duplicata (OUTPUT l-erro-x).
                IF l-erro-x THEN 
                    RETURN "NOK":U.
            END.

            /*
            Chamado 29373 - Ao atualizar uma nota, e depois uma segunda nota com o mesmo n£mero de documento, porÇm com outra natureza, estava alterando a ae-inspecao e ficha-cq do primeiro documento
            RUN piAtualizaAeInspecao.
            */
            

            FOR EACH item-doc-est OF docum-est NO-LOCK:

                /*Acerta unidade negocio da nota*/
                IF docum-est.cod-estabel = "103" THEN DO:
                    FOR EACH unid-neg-nota OF item-doc-est EXCLUSIVE-LOCK
                       WHERE unid-neg-nota.cod_unid_negoc <> "MAX":
                        ASSIGN unid-neg-nota.cod_unid_negoc = "MAX".
                    END.
                END.

                IF natur-oper.especie-doc = "NFD" THEN DO:
                    FOR EACH fat-duplic NO-LOCK
                       WHERE fat-duplic.cod-estabel = docum-est.cod-estabel
                         AND fat-duplic.serie       = item-doc-est.serie-comp
                         AND fat-duplic.nr-fatura   = item-doc-est.nro-comp:
                
                        RUN upc/re1005rp-epc2.p (INPUT docum-est.cod-estabel, 
                                                 INPUT fat-duplic.cod-esp,    
                                                 INPUT fat-duplic.serie,      
                                                 INPUT fat-duplic.nr-fatura,  
                                                 INPUT fat-duplic.parcela,
                                                 OUTPUT c-retorno).
                        IF c-retorno = "NOK" THEN DO:
                             PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                                 "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                             PUT docum-est.serie-docto at 1.
                             PUT docum-est.nro-docto   at 7.
                             PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                             PUT docum-est.nat-operacao at 35.
                             PUT "Titulo da Nota Origem sem confirmaá∆o Banc†ria ! Documento n∆o atualizado!" AT 53 FORMAT "x(75)" SKIP.
                             RETURN "NOK".
                        END.
                    END.
                END.

                FIND ITEM WHERE
                     ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
                IF  AVAIL ITEM THEN DO:

                    /*---[ Referente solicitaá∆o nro. 20643, por Claudia Rogalsky ]---------------------------------------------------------------------------------------*/
                    IF  natur-oper.emite-duplic /* Emite Duplicata? */ AND natur-oper.tipo-compra = 1 /* Normal */ THEN DO:
                        IF  CAN-FIND(FIRST ext-grupo WHERE ext-grupo.ge-codigo = ITEM.ge-codigo) THEN DO:
                            /*---[ Pedido do item ]---------------------------------------------*/
                            IF  item-doc-est.num-pedido = 0 THEN ASSIGN l-bloqueia-pedido = TRUE.

                            IF NOT can-find(FIRST rat-ordem
                                            WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                            AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                            AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                            AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                            AND   rat-ordem.sequencia    = item-doc-est.sequencia) THEN ASSIGN l-bloqueia-fifo = TRUE.

                            /*---[ FIFO ]-------------------------------------------------------*/
                            IF  (l-bloqueia-pedido  AND l-bloqueia-fifo) THEN DO:
                                PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                                PUT docum-est.serie-docto at 1.
                                PUT docum-est.nro-docto   at 7.
                                PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                                PUT docum-est.nat-operacao at 35.
                                PUT "Nao permitida atualizacao de notas com itens sem pedido e/ou sem FIFO." AT 53 FORMAT "x(100)" SKIP.
                                RETURN "NOK".
                            END. /* IF  l-bloqueia- ... */
                        END. /* IF  CAN-FIND(FIRST ext-grupo WHERE ext-grupo.ge-codigo ... */
                    END. /* IF natur-oper.emite-duplic THEN DO: */
                    /*---------------------------------------------------------------------------------------[ Referente solicitaá∆o nro. 20643, por Claudia Rogalsky ]---*/

                    FIND natur-oper
                        WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
                    IF AVAIL natur-oper AND
                       natur-oper.imp-nota = YES THEN DO:
                       IF ITEM.ind-imp-desc = 7 THEN do:
                            IF length(item-doc-est.narrativa) = 0 OR LENGTH(item-doc-est.narrativa ) > 120 THEN DO:
                                 PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                                     "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                                 PUT docum-est.serie-docto at 1.
                                 PUT docum-est.nro-docto   at 7.
                                 PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                                 PUT docum-est.nat-operacao at 35.
                                 PUT "Narrativa n∆o informada ou ultrapassou 120 posiá‰es aceita pela SEFAZ" AT 53 FORMAT "x(75)" SKIP.
                                 RETURN "NOK".
                            END.
                        END.
                        IF ITEM.ind-imp-desc = 5 THEN do:
                            IF length(ITEM.narrativa) = 0 OR LENGTH(ITEM.narrativa ) > 120 THEN DO:

                                 PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                                     "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                                 PUT docum-est.serie-docto at 1.
                                 PUT docum-est.nro-docto   at 7.
                                 PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                                 PUT docum-est.nat-operacao at 35.
                                 PUT "Narrativa do item n∆o informada ou ultrapassou 120 posiá‰es aceita pela SEFAZ" AT 53 FORMAT "x(175)" SKIP.
                                 RETURN "NOK".
                            END.
                        END.
                    END.
                END.
                   

                FIND item-uni-estab WHERE
                     item-uni-estab.it-codigo = item-doc-est.it-codigo AND
                     item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

                /*verifica conta notas saldo terceiros - trava
                  Se a natureza for de terceiros e o tipo de terceiros for "Remessa Beneficiamento" e o item for "Terc" dever† validar se a conta informada no item da nota 
                  Ç diferente da conta de aplicaá∆o do item. Se for dever† exibir uma mensagem de erro para o usu†rio e n∆o atualizar a nota.*/
                IF natur-oper.terceiros             AND  
                   natur-oper.tp-oper-terc = 1      AND 
                   item-doc-est.it-codigo  = "Terc" THEN DO:

                    /*verifica conta transit da nota com conta parametrizada no estoque*/
                    FIND estab-mat NO-LOCK
                        WHERE estab-mat.cod-estabel = docum-est.cod-estabel NO-ERROR.

                    IF docum-est.ct-transit <> estab-mat.cod-cta-e-consig-unif AND
                       docum-est.sc-transit <> estab-mat.cod-ccusto-e-consig-unif
                    THEN DO:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "Conta Transit¢ria inv†lida.Conta informada diferente da Conta: " +  estab-mat.cod-cta-e-consig-unif + "." + estab-mat.cod-ccusto-e-consig-unif AT 53 FORMAT "x(100)" SKIP.
                        RETURN "NOK".
                    END.

                    /*verifica conta contabil do item da nota com conta aplicacao do item*/
                    IF item-doc-est.ct-codigo <> ITEM.ct-codigo AND
                       item-doc-est.sc-codigo <> ITEM.sc-codigo
                    THEN DO:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "Conta Contabil inv†lida.Conta diferente de Conta Aplicaá∆o Item: TERC - " + ITEM.ct-codigo + "." + ITEM.sc-codigo AT 53 FORMAT "x(100)" SKIP.
                        RETURN "NOK".
                    END.
                END.

                IF natur-oper.terceiros = YES AND
                   natur-oper.tp-oper-terc = 1 THEN DO:
                    IF ITEM.tipo-contr = 4 AND 
                       ITEM.it-codigo <> "terc" AND
                       ITEM.it-codigo <> "estq" AND
                       ITEM.it-codigo <> "imobile" AND
                       ITEM.it-codigo <> "TERC IMPORTADO" AND
                       SUBSTRING(item.it-codigo,1,1) <> "9" THEN DO:

                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "Nota que movimenta Saldos em Terceiros deve ter itens terc, estq ou imobile, ou com tipo de controle Total" AT 53 FORMAT "x(100)" SKIP.
                        RETURN "NOK".
                    END.
                END.

                IF docum-est.cod-estabel  = "101" AND
                   item-doc-est.cod-depos = "cst" AND
                   ITEM.tipo-contr        = 2     THEN DO: 
                    /*validar familia material para estabelecimento 101 e deposito cst e itens com controle total*/
                    
                    FIND FIRST familia
                         WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL familia OR item.fm-codigo = "" THEN DO:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT "Item " + item.it-codigo + " com Familia Material invalida. NF nao atualizada! VERIFIQUE..." AT 53 FORMAT "x(100)" SKIP.
                        RETURN "NOK".
                    END.
                END.

                IF item-doc-est.cod-depos = "rec" AND item-uni-estab.contr-qualid = NO THEN DO:
                     PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                         "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                     PUT docum-est.serie-docto at 1.
                     PUT docum-est.nro-docto   at 7.
                     PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                     PUT docum-est.nat-operacao at 35.
                     PUT "Item " + item.it-codigo + " sem controle de CQ. Nao sera atualizado a nota fiscal. VERIFIQUE..." AT 53 FORMAT "x(100)" SKIP.
                     RETURN "NOK".

                    /* comentado pois o estabelecimento 102 n∆o existe mais.
                    
                    /* Cria relacionamento item-fornec para Nova" */
                    if docum-est.cod-estabel = '102' then do:
                        find first item-fornec
                             where item-fornec.cod-emitente = docum-est.cod-emitente
                               and item-fornec.it-codigo    = item-doc-est.it-codigo no-lock no-error.
                        if not avail item-fornec then do:
                            create item-fornec.
                            assign item-fornec.it-codigo    = item-doc-est.it-codigo
                                   item-fornec.cod-emitente = docum-est.cod-emitente
                                   item-fornec.item-do-forn = item-doc-est.it-codigo
                                   item-fornec.unid-med-for = item.un
                                   item-fornec.lote-mul-for = item.lote-multipl.
                        end.
                    end.
                    */
                END.
            END. /* FOR EACH item-doc-est OF docum-est NO-LOCK: */

            ASSIGN i-nr = int(docum-est.nro-docto).
            FOR EACH pre-no
               WHERE pre-nota.cod-emitente = docum-est.cod-emitente AND
                     pre-nota.nro-docto    = string(i-nr)           AND
                     pre-nota.serie        = docum-est.serie-docto EXCLUSIVE-LOCK:  
                ASSIGN pre-nota.importado = YES. /* Atualiza pre-nota colocando importado = sim */
            END.
        END. 
    END.
    WHEN "fim-atualizacao" THEN DO:

        RUN epc/epcre1005rp-13.r (INPUT pIndEvent,
                                  INPUT-OUTPUT TABLE tt-epc).

        ASSIGN l-erro-x = NO.
        FOR FIRST tt-epc                                    WHERE
                  tt-epc.cod-event     = pIndEvent          AND
                  tt-epc.cod-parameter = "docum-est rowid":

            FIND FIRST docum-est WHERE
                 ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

            find natur-oper where
                 natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.

            IF l-erro-x THEN 
                RETURN "NOK".

            FIND emitente WHERE
                 emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

            RUN esp/es0018p.p (INPUT "re1005rp",
                               INPUT 6, /* Gera Pedido de venda de acordo com as naturezas cadastradas neste ponto */
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).

            for first tt-prog-ponto 
                where entry(1,tt-prog-ponto.conteudo,";") = docum-est.nat-operacao
                  AND entry(7,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel:
            end.
            if not avail tt-prog-ponto then                  
                for first tt-prog-ponto 
                    where entry(1,tt-prog-ponto.conteudo,";") = docum-est.nat-operacao
                      AND entry(7,tt-prog-ponto.conteudo,";") = "":
                end.
                
            if avail tt-prog-ponto then do:
                FIND int-docum-est
                     WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                       AND int-docum-est.nro-docto    = docum-est.nro-docto
                       AND int-docum-est.cod-emitente = docum-est.cod-emitente
                       AND int-docum-est.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK NO-ERROR.
                IF  NOT AVAIL int-docum-est OR int-docum-est.nr-pedido = 0 THEN DO:
                    RUN GeraPedidoDeVenda.
                END.
            END.

            IF docum-est.esp-docto = 20 THEN DO:

                RUN esbo/boes398.p PERSISTENT SET h-boes398.
                FOR EACH item-doc-est OF docum-est NO-LOCK:
                    IF item-doc-est.nro-comp   <> "" AND
                       item-doc-est.serie-comp <> "" THEN DO:
                        FIND nota-fiscal
                             WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                               AND nota-fiscal.serie       = item-doc-est.serie-comp
                               AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp NO-LOCK NO-ERROR.
                        IF NOT AVAIL nota-fiscal THEN RETURN "ok".
                        
                        
                        /* SupplierCard - Cria uma pendància para que a devoluá∆o seja enviada para a SupplierCard */
                        ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999")
                               i-identific    = IF docum-est.tot-valor < nota-fiscal.vl-tot-nota THEN 10 /* Cancelamento Parcial de Compra */ ELSE 03 /* Cancelamento Total de Compra */.
    
                        /* S¢ ir† criar uma pendància para a NF se ela foi enviada para a SupplierCard (existir alguma ocorrància para a NF),
                           e se a nota ainda n∆o teve uma ocorrància gerada para ela */
                        DEF VAR l-impede-reenvio AS LOG NO-UNDO.
                    
                        FOR EACH int-pendencias-supcard    NO-LOCK
                              WHERE int-pendencias-supcard.cod-estab     = nota-fiscal.cod-estabel
                              AND   int-pendencias-supcard.cod-ser-docto = nota-fiscal.serie
                              AND   int-pendencias-supcard.cod-tit-acr   = nota-fiscal.nr-nota-fis:
                    
                            IF NUM-ENTRIES(int-pendencias-supcard.obs, ";") > 4
                            AND entry(2, int-pendencias-supcard.obs, ";")  = docum-est.nro-docto
                            AND entry(3, int-pendencias-supcard.obs, ";")  = docum-est.nat-operacao  
                            AND entry(4, int-pendencias-supcard.obs, ";")  = docum-est.serie-docto
                            AND int(entry(5, int-pendencias-supcard.obs, ";")) = docum-est.cod-emitente THEN 
                                ASSIGN l-impede-reenvio = YES.
                    
                        END.

                        IF      CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                                         WHERE int-emitente-supcard-ocor.num-transac = c-nr-transacao) AND
                            NOT CAN-FIND(FIRST int-pendencias-supcard    NO-LOCK
                                         WHERE int-pendencias-supcard.dat-criacao   = TODAY
                                         AND   int-pendencias-supcard.identific     = i-identific
                                         AND   int-pendencias-supcard.cod-estab     = nota-fiscal.cod-estabel
                                         AND   int-pendencias-supcard.cod-ser-docto = nota-fiscal.serie
                                         AND   int-pendencias-supcard.cod-tit-acr   = nota-fiscal.nr-nota-fis) 
                         AND NOT l-impede-reenvio THEN DO:
                            FIND FIRST emitente NO-LOCK
                                WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

                            /* Verifica se a raiz do cnpj n∆o est† cadastrado como exceá∆o para envio */
                            ASSIGN l-continua-pendencia = YES.
                            IF LENGTH(TRIM(emitente.cgc)) = 14 THEN DO: /* Verifica se Ç PJ atravÇs da quantidade de digitos do cnpj */
                                IF CAN-FIND(excecao_envio_sc NO-LOCK
                                        WHERE excecao_envio_sc.raiz_cnpj = SUBSTRING(TRIM(emitente.cgc),1,8) 
                                          AND excecao_envio_sc.lg_devolucao = YES) THEN DO:
                                    ASSIGN l-continua-pendencia = NO.
                                END.
                            END.

                            IF l-continua-pendencia = YES THEN DO:
                                ASSIGN de-tot-dev = 0.
                                FOR EACH  devol-cli NO-LOCK
                                    WHERE devol-cli.cod-estabel  = docum-est.cod-estabel
                                    AND   devol-cli.nro-docto    = docum-est.nro-docto
                                    AND   devol-cli.nat-operacao = docum-est.nat-operacao
                                    AND   devol-cli.serie-docto  = docum-est.serie-docto
                                    AND   devol-cli.cod-emitente = docum-est.cod-emitente
                                    AND   devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                                    AND   devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                                    AND   devol-cli.serie        = nota-fiscal.serie:
                                    ASSIGN de-tot-dev = de-tot-dev + devol-cli.vl-devol.
                                END.
                                
                                CREATE int-pendencias-supcard.
                                ASSIGN int-pendencias-supcard.dat-criacao     = TODAY
                                       int-pendencias-supcard.cod-usuar       = c-seg-usuario
                                       int-pendencias-supcard.identific       = i-identific
                                       int-pendencias-supcard.cnpj-cliente    = IF AVAIL emitente THEN emitente.cgc ELSE ""
                                       int-pendencias-supcard.cod-estab       = nota-fiscal.cod-estabel
                                       int-pendencias-supcard.cod-espec-docto = "DM"
                                       int-pendencias-supcard.cod-ser-docto   = nota-fiscal.serie
                                       int-pendencias-supcard.cod-tit-acr     = nota-fiscal.nr-nota-fis
                                       int-pendencias-supcard.cod-parcela     = "01"
                                       int-pendencias-supcard.val-lancamento  = de-tot-dev
                                       int-pendencias-supcard.obs             = "Referente a nota de entrada Estabelecimento: " + docum-est.cod-estabel +
                                                                                ", SÇrie " + docum-est.serie-docto + ", Natureza " + docum-est.nat-operacao +
                                                                                ", Emitente " + STRING(docum-est.cod-emitente) + ". Chave ;" +
                                                                                docum-est.nro-docto + ";" + docum-est.nat-operacao + ";" + docum-est.serie-docto + 
                                                                                ";" + string(docum-est.cod-emitente).
                                        
                            END.
                        END.
                        /* SupplierCard - FIM */



                        FIND FIRST fat-duplic
                             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                               AND fat-duplic.serie        = nota-fiscal.serie
                               AND fat-duplic.nr-fatura    = nota-fiscal.nr-fatura NO-LOCK NO-ERROR.
                        IF AVAIL fat-duplic THEN DO:
                            IF nota-fiscal.nr-pedcli <> "" THEN DO:
                                FIND ped-venda WHERE 
                                     ped-venda.nome-abrev = nota-fiscal.nome-ab-cli AND 
                                     ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
                                IF AVAIL ped-venda THEN
                                    ASSIGN p-dt-implant-ped = ped-venda.dt-implant.
                                ELSE
                                    ASSIGN p-dt-implant-ped = ?.
                            END.
                            RUN comissoes IN h-boes398 (INPUT 2,
                                                        INPUT YES,
                                                        INPUT nota-fiscal.cod-estabel,
                                                        INPUT nota-fiscal.cod-emitente,
                                                        INPUT nota-fiscal.cod-rep,
                                                        INPUT item-doc-est.it-codigo,
                                                        INPUT item-doc-est.sequencia,
                                                        INPUT item-doc-est.quantidade,
                                                        INPUT nota-fiscal.dt-emis-nota,
                                                        INPUT p-dt-implant-ped,
                                                        INPUT docum-est.dt-trans,
                                                        INPUT nota-fiscal.serie,
                                                        INPUT nota-fiscal.nr-nota-fis,
                                                        INPUT docum-est.nro-docto,
                                                        INPUT "",
                                                        INPUT fat-duplic.cod-esp,
                                                        INPUT nota-fiscal.nr-praz-med,
                                                        INPUT nota-fiscal.cod-cond-pag,
                                                        INPUT ((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) - abs(de-vl-merc-liq)) * -1,   
                                                        output p-erro,
                                                        INPUT-OUTPUT TABLE tt-comissao-fat).
                        END.
                    END. /* IF item-doc-est.nro-comp   <> "" AND */
                END. /* FOR EACH item-doc-est OF docum-est NO-LOCK:*/
                DELETE PROCEDURE h-boes398.

                IF l-continua-pendencia = NO THEN DO:
                    PUT SKIP
                        "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        ":U SKIP
                        "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------":U SKIP
                        docum-est.serie-docto          AT 1
                        docum-est.nro-docto            AT 7
                        STRING(docum-est.cod-emitente) AT 24 FORMAT "x(9)":U
                        docum-est.nat-operacao         AT 35 
                        "N∆o foi gerada pendància SupplierCard!":U AT 53 FORMAT "x(100)":U SKIP.
                     PUT "Cliente est† cadastrado para envio manual de pendàncias para o SupplierCard.":U AT 53 FORMAT "x(100)":U SKIP.
                END.

                //verifica se tem registro na expedicao pra excluir quando for realizada uma devolucao
                FOR EACH devol-cli NO-LOCK
                   WHERE devol-cli.cod-estabel  = docum-est.cod-estabel
                     AND devol-cli.nro-docto    = docum-est.nro-docto
                     AND devol-cli.nat-operacao = docum-est.nat-operacao
                     AND devol-cli.serie-docto  = docum-est.serie-docto
                     AND devol-cli.cod-emitente = docum-est.cod-emitente
                     AND devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                     AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                     AND devol-cli.serie        = nota-fiscal.serie:

                    FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK
                       WHERE int-wms-nf-atualiz.cod-estabel = nota-fiscal.cod-estabel
                         and int-wms-nf-atualiz.serie       = nota-fiscal.serie      
                         and int-wms-nf-atualiz.nr-nota-fis = nota-fiscal.nr-nota-fis:

                         DELETE int-wms-nf-atualiz.
                    END. //for ech int-wms-nf-atualiza
                END. //for each devol-cli

            END.  /* IF docum-est.esp-docto = 20 THEN DO:*/
                 
            if avail natur-oper and natur-oper.imp-nota then            
                assign l-gera-nf = yes.
            
            FIND FIRST item-doc-est of docum-est NO-LOCK NO-ERROR.
            IF AVAIL item-doc-est THEN DO:
                
                IF docum-est.cod-estabel   = "101":U THEN DO:
                    FIND FIRST int-natur-oper
                        WHERE int-natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

                    IF AVAILABLE int-natur-oper AND
                       int-natur-oper.log-1     AND
                       item-doc-est.cod-depos <> SUBSTRING(int-natur-oper.char-1, 1, 3) THEN DO:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        ":U SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------":U SKIP
                            docum-est.serie-docto          AT 1
                            docum-est.nro-docto            AT 7
                            STRING(docum-est.cod-emitente) AT 24 FORMAT "x(9)":U
                            docum-est.nat-operacao         AT 35 
                            "Nat Operaá∆o Ç de Assitància TÇcnica. Dep¢sito informado n∆o Ç o informado no Cadastro Nat Operaá∆o":U AT 53 FORMAT "x(100)":U SKIP.
                    END.
                END.

                IF docum-est.esp-docto = 21 AND docum-est.cod-estabel = '101' AND item-doc-est.cod-depos = "rec" THEN DO: 
                    FIND FIRST ae-entrada 
                         WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
                           AND ae-entrada.nro-docto    = int(docum-est.nro-docto) 
                           AND ae-entrada.cod-emitente = docum-est.cod-emitente  NO-LOCK NO-ERROR.
                    IF AVAIL ae-entrada THEN DO:
                        ASSIGN c-narrativa = "".

                        do i-cont = 1 to 5:
                            IF ae-entrada.localizacao[i-cont] <> "" THEN
                                assign c-narrativa = c-narrativa + STRING(i-cont) + "-" + ae-entrada.localizacao[i-cont] + " / ".
                        end.

                        FOR EACH  movto-estoq
                            where movto-estoq.serie-docto  = item-doc-est.serie-docto
                              and movto-estoq.nro-docto    = item-doc-est.nro-docto
                              and movto-estoq.cod-emitente = item-doc-est.cod-emitente
                              and movto-estoq.nat-operacao = item-doc-est.nat-operacao EXCLUSIVE-LOCK:
                            ASSIGN movto-estoq.descricao-db = movto-estoq.descricao-db + " Localizaá∆o no REC em: " + c-narrativa.
                        END.
                    END.
                END.

                ASSIGN c-cod-depos = item-doc-est.cod-depos
                       c-it-codigo = item-doc-est.it-codigo.

                if l-gera-nf and item-doc-est.nro-comp <> "" then
                    assign c-nro-comp = item-doc-est.nro-comp.
/*                
                FOR first movto-estoq
                    where movto-estoq.serie-docto  = item-doc-est.serie-docto
                      and movto-estoq.nro-docto    = item-doc-est.nro-docto
                      and movto-estoq.cod-emitente = item-doc-est.cod-emitente
                      and movto-estoq.nat-operacao = item-doc-est.nat-operacao
                      and movto-estoq.it-codigo    = item-doc-est.it-codigo
                      and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
                    if movto-estoq.tipo-trans = 1 then do:
                        assign c-conta-contabil = movto-estoq.conta-contabil.
                    end.
                end.        
*/                
            end.            
                
            RUN pi-dt-efetiva-embarque. /* Atualiza a data efetiva do ponto de controle de emissao da NF no embarque (im0055) */

            ASSIGN c-item-ini = ""
                   c-item-fim = ""
                   c-cod-estabel = ""
                   c-mail-destino = "".
/* N«O RETIRARA A CHAMADA DESTE PONTO, NAO FUNCIONA NO METODO "apos-finalizar"  */


            IF AVAIL natur-oper AND natur-oper.tipo-compra = 1 THEN DO:
                FOR EACH tt-prog-ponto-1:
                    DELETE tt-prog-ponto-1.
                END.

                RUN esp/es0018p.r (INPUT "re1005rp",
                                   INPUT 4,
                                   INPUT 0,
                                   INPUT "", 
                                   OUTPUT TABLE tt-prog-ponto-1).
                FOR EACH tt-prog-ponto-1:
                    ASSIGN c-cod-estabel = ENTRY(1,tt-prog-ponto-1.conteudo,";")
                           c-item-ini    = ENTRY(2,tt-prog-ponto-1.conteudo,";")
                           c-item-fim    = ENTRY(3,tt-prog-ponto-1.conteudo,";").
                END.

                /* Para o estabelecimento, dep¢sito e ficha de item parametrizado no es0018 enviar e-mail para usu†rio parametrizado */
                IF c-cod-estabel = docum-est.cod-estabel AND
                   c-it-codigo >= c-item-ini and
                   c-it-codigo <= c-item-fim THEN DO:

                    FOR EACH tt-prog-ponto-1:
                        DELETE tt-prog-ponto-1.
                    END.
/*
                    run pi-gera-html. /* Ficha de inspeá∆o da ASTEC */
*/
                    assign c-assunto = "Entrada de materiais O&M (187 Œ 188) - Doc: " + (if c-nro-comp <> "" then c-nro-comp else docum-est.nro-docto)
                                                                          + " Serie: "    + docum-est.serie-docto
                                                                          + " Emitente: " + string(docum-est.cod-emitente)
                                                                          + " CFOP: "     + docum-est.nat-operacao.

                    IF OPSYS = "UNIX" THEN
                        assign c-arquivo = session:temp-directory + c-seg-usuario + "/e-mail.log".
                    ELSE
                        assign c-arquivo = session:temp-directory + "e-mail.log".

                    /* O Arquivo abaixo Ç apenas para nao dar erro no e-nvio de e-mail que exige um arquivo em anexo.*/
                    OUTPUT TO VALUE(c-arquivo) CONVERT TARGET SESSION:CHARSET.
                    PUT " " SKIP. 
                    OUTPUT CLOSE.
           
                    RUN esp/es0018p.r (INPUT "re1005rp",
                                       INPUT 5,
                                       INPUT 0,
                                       INPUT "", 
                                       OUTPUT TABLE tt-prog-ponto-1).

                    FOR EACH tt-prog-ponto-1:
                        ASSIGN c-mail-destino = ENTRY(1,tt-prog-ponto-1.conteudo,";").

                        run enviaMail (input "ems@intelbras.com.br",
                                       input c-mail-destino,
                                       input c-assunto, 
                                       input c-arquivo,
                                       input c-arquivo).
                    END.
                END.
            END.

            FOR EACH tt-prog-ponto:
                DELETE tt-prog-ponto.
            END.

            RUN esp/es0018p.r (INPUT "re1005rp",
                               INPUT 2,
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).
            
            find first tt-prog-ponto no-error.
            if avail tt-prog-ponto then do:
                for each tt-prog-ponto where 
                    entry(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel AND
                    entry(3,tt-prog-ponto.conteudo,";") = c-cod-depos:
    
                    IF NOT l-gerou-ficha-html THEN DO:
                        run pi-gera-html. /* Ficha de inspeá∆o da ASTEC */
                        ASSIGN l-gerou-ficha-html = YES.
                    END.
    
                    /* SOS 33857 - Jorge - Enviar e-mail para o usu†rio logado */            
                    assign c-assunto = "Ficha de Inspeá∆o Fiscal - Doc: " + (if c-nro-comp <> "" then c-nro-comp else docum-est.nro-docto)
                                                                          + " Serie: "    + docum-est.serie-docto
                                                                          + " Emitente: " + string(docum-est.cod-emitente)
                                                                          + " CFOP: "     + docum-est.nat-operacao
                           c-mail-destino = entry(2,tt-prog-ponto.conteudo,";").
    
                    run enviaMail (input "ems@intelbras.com.br",
                                   input c-mail-destino,
                                   input c-assunto, 
                                   input c-arquivo,
                                   input c-arquivo).
                end.
            end.

            /** Envia email quando lanáada uma NFE ou NFD no dep¢sito EXP. **/
            IF  (docum-est.esp-docto = 20  OR 
                 docum-est.esp-docto = 21) THEN DO:                
                FOR EACH tt-prog-ponto:
                    DELETE tt-prog-ponto.
                END.

                RUN esp/es0018p.r (INPUT "re1005rp",
                                   INPUT 7,
                                   INPUT 0,
                                   INPUT "", 
                                   OUTPUT TABLE tt-prog-ponto).

                FIND FIRST tt-prog-ponto NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                    FOR EACH tt-prog-ponto WHERE 
                        ENTRY(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel AND
                        ENTRY(2,tt-prog-ponto.conteudo,";") = c-cod-depos:
    
                        ASSIGN c-mensagem = "Documento: "      + docum-est.nro-docto + "~n"
                                          + "Serie: "          + docum-est.serie-docto + "~n"
                                          + "Emitente: "       + STRING(docum-est.cod-emitente) + " - ":U + emitente.nome-emit + "~n"
                                          + "Natureza: "       + docum-est.nat-operacao + " - ":U + natur-oper.denominacao + "~n"
                                          + "Data Transaá∆o: " + STRING(docum-est.dt-trans) + "~n".
                                          
                        IF AVAIL tt-ped-venda THEN
                           ASSIGN  c-mensagem = c-mensagem + "Pedido: "          + string(tt-ped-venda.nr-pedcli).
                        ASSIGN c-mail-destino = ENTRY(3,tt-prog-ponto.conteudo,";").

                        IF c-cod-depos = "EPE" THEN NEXT.
    
                        RUN enviaMail (INPUT "ems@intelbras.com.br",
                                       INPUT c-mail-destino,
                                       INPUT "Entrada Documento - Dep¢sito: " + CAPS(c-cod-depos),
                                       INPUT c-mensagem,
                                       INPUT "").
                    END.
                END.
            END.

            /* Envia email quando lanáada uma NFD no deposito EPE. */
              IF  docum-est.esp-docto = 20 THEN DO:                
                FOR EACH tt-prog-ponto:
                    DELETE tt-prog-ponto.
                END.

                RUN esp/es0018p.r (INPUT "re1005rp",
                                   INPUT 7,
                                   INPUT 0,
                                   INPUT "", 
                                   OUTPUT TABLE tt-prog-ponto).

                FIND FIRST tt-prog-ponto NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                    FOR EACH tt-prog-ponto WHERE 
                        ENTRY(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel AND
                        ENTRY(2,tt-prog-ponto.conteudo,";") = c-cod-depos:

                        FIND FIRST devol-cli NO-LOCK
                             WHERE devol-cli.cod-estabel  = docum-est.cod-estabel
                               AND devol-cli.nro-docto    = docum-est.nro-docto
                               AND devol-cli.nat-operacao = docum-est.nat-operacao
                               AND devol-cli.serie-docto  = docum-est.serie-docto
                               AND devol-cli.cod-emitente = docum-est.cod-emitente NO-ERROR.
                        
                        IF AVAIL devol-cli THEN DO:

                            FIND FIRST nota-fiscal
                                 WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
                                  AND  nota-fiscal.serie       = devol-cli.serie   
                                  AND  nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK NO-ERROR.

                            IF AVAIL nota-fiscal THEN DO:

                                FIND FIRST emitente
                                     WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

                                IF AVAIL emitente THEN DO:
                                                            
                                    ASSIGN c-mensagem = "Prezada Supplog" + CHR(10)                               
                                                      + "Informamos que a NF: " + STRING(devol-cli.nr-nota-fis) + " " + "emitida em " + STRING(nota-fiscal.dt-emis-nota) + " " + "destinatario " + emitente.nome-emit + " e " + STRING(emitente.cgc) + CHR(10)
                                                      + "foi anulada atraves de emissao de entrada NF " + STRING(docum-est.nro-docto) + " " + "emitida em " + STRING(docum-est.dt-emissao) + ", devido as 24hrs do prazo de cancelamento ter expirado.".  

                                    ASSIGN c-mail-destino = ENTRY(3,tt-prog-ponto.conteudo,";").
                                   
                                    RUN enviaMail (INPUT "ems@intelbras.com.br",
                                                   INPUT c-mail-destino,
                                                   INPUT "Entrada Documento - Dep¢sito Externo: " + CAPS(c-cod-depos),
                                                   INPUT c-mensagem,
                                                   INPUT "").
                                END. 
                            END.
                        END.
                    END.
                END.
            END. /* IF docum-est.esp-docto = 20 */
        END. /* tt-epc.cod-parameter = "docum-est rowid": */
    END. /* WHEN "fim-atualizacao" THEN DO: */
/*
    when "apos-atualizacao" then do:
    end.          
*/                
/* comentado ap¢s utilizacao do CQ padr∆o*/
    WHEN "apos-finalizar" THEN DO:
        /* IMPRIMIR A FICHA APENAS SE O DOCUMENTO FOI REALMENTE ATUALIZADO E AINDA EXISTA TABELA FICHA-CQ */
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = pIndEvent          
              AND tt-epc.cod-parameter = "docum-est rowid":

            FIND FIRST docum-est 
                WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

            FIND natur-oper 
                WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

            /* NOTA REALMENTE ATUALIZADA, Jµ DEPOIS DAS TRANSAÄÂES */
            IF  docum-est.ce-atual THEN DO:

                /*MESSAGE "re1005rp-epc - 1" VIEW-AS ALERT-BOX.*/

                IF  AVAIL natur-oper 
                AND CAN-FIND(FIRST int-natur-oper NO-LOCK
                WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao
                AND   int-natur-oper.cod-observa  = 4) /* Servico */ THEN DO:
                    /*
                    OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
                    PUT UNFORMATTED "1 - re1005rp-epc - docum-est.serie-docto "  docum-est.serie-docto   skip
                                                       "docum-est.nro-docto "    docum-est.nro-docto     skip
                                                       "docum-est.cod-emitente " docum-est.cod-emitente  skip
                                                       "docum-est.nat-operacao " docum-est.nat-operacao  skip(2).
                    OUTPUT CLOSE.  
                    */

                    RUN piIntegraV360. /* envia retorno da escrituracao para V360 */
                END.

                EMPTY TEMP-TABLE tt-prog-ponto.
    
                RUN esp/es0018p.p (INPUT "ALM-WMS":U,
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                
                IF NOT CAN-FIND(FIRST tt-prog-ponto
                                WHERE tt-prog-ponto.conteudo = docum-est.cod-estabel) THEN DO:
                   IF  natur-oper.nota-rateio  = NO THEN
                       RUN piImprimeRoteiro.    
                END.
            END.
        END.
    END.
/**/
    /*
    WHEN "apos-finalizar" THEN DO:
        
        FOR FIRST tt-epc WHERE
                  tt-epc.cod-event     = pIndEvent AND
                  tt-epc.cod-parameter = "docum-est rowid":

            FIND FIRST docum-est WHERE
                 ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

            if avail docum-est and docum-est.ce-atual then DO:
                FIND natur-oper
                    WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

/*             /* Deixer esta integraá∆o antes desse envio de e-mail, para evitar problemas com a api de e-mail */  
                                                                                                */
                IF     PROGRAM-NAME(1) MATCHES '*esrep1005*' 
                    OR PROGRAM-NAME(2) MATCHES '*esrep1005*' 
                    OR PROGRAM-NAME(3) MATCHES '*esrep1005*' 
                    OR PROGRAM-NAME(4) MATCHES '*esrep1005*' 
                    OR PROGRAM-NAME(5) MATCHES '*esrep1005*'
                    OR PROGRAM-NAME(6) MATCHES '*esrep1005*'
                    OR PROGRAM-NAME(7) MATCHES '*esrep1005*'
                    OR PROGRAM-NAME(8) MATCHES '*esrep1005*'
                    OR PROGRAM-NAME(9) MATCHES '*esrep1005*' THEN . /* sera enviado ao final da execuá∆o do esrep1005.*/
                ELSE DO:
                    IF AVAIL natur-oper
                         AND natur-oper.imp-nota THEN DO:
                        /* Regra para integraá∆o NFE - GATI */
                        for first nota-fiscal exclusive-lock
                            where nota-fiscal.cod-estabel     = docum-est.cod-estabel
                                  and nota-fiscal.serie       = docum-est.serie-docto
                                  and nota-fiscal.nr-nota-fis = docum-est.nro-docto.
        
                                IF docum-est.CE-atual = YES THEN DO:
                                    FIND FIRST docum-est EXCLUSIVE-LOCK WHERE
                                         ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.     
        
                                    IF nota-fiscal.cod-emitente <> docum-est.cod-emitente THEN NEXT.

                                    ASSIGN docum-est.ce-atual = NO.
        
                                    CREATE tt-ft0910.
                                    ASSIGN tt-ft0910.usuario           = ""
                                           tt-ft0910.arquivo           = SESSION:TEMP-DIRECTORY + "re1005rp-epc-" + trim(replace(string(TODAY), "/", "")) + trim(STRING(TIME)) + ".txt"
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
                                    
                                    ASSIGN docum-est.ce-atual = YES.
        
                                    run esp/ftp/esft067rp.p (input nota-fiscal.cod-estabel,
                                                         input 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').
                                   ASSIGN nota-fiscal.dt-confirma = TODAY.
                                   FIND FIRST docum-est EXCLUSIVE-LOCK WHERE
                                        ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.     
        
                                END.
        
                        end.
                    END.
                END.
            END. /* if avail docum-est and docum-est.ce-atual then DO: */
        END.
    END.
    */

END CASE.

.return "OK":U.


procedure pi-gera-html.
    def var c-emitente as char no-undo.

    IF OPSYS = "UNIX" THEN
        assign c-arquivo = session:temp-directory + c-seg-usuario + "/re1005_" + trim(docum-est.nro-docto) + ".html".
    ELSE
        assign c-arquivo = session:temp-directory + "re1005_" + trim(docum-est.nro-docto) + ".html".
    
    output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               
      
    run html-inicio("Ficha de Inspeá∆o Fiscal").                                
    run html-titulo("Ficha de Inspeá∆o Fiscal").
    run html-ini-tab.
    run html-ini-lin-tab.

    run html-cab-tab("Emitente").
    if avail emitente then
        assign c-emitente = string(docum-est.cod-emitente) + " - " + emitente.nome-emit.
    
    run html-con-tab-colspan(c-emitente, "left", 3).
    run html-fim-lin-tab.
    
    run html-ini-lin-tab.    
    run html-cab-tab("Documento").
    
    assign c-nro-docto = c-nro-comp + "  NFE: " + docum-est.nro-docto.
    
    run html-con-tab(c-nro-docto, "left").    
    run html-cab-tab("SÇrie").
    run html-con-tab(docum-est.serie-docto, "left").
    run html-fim-lin-tab.
    
    run html-ini-lin-tab.            
    run html-cab-tab("CFOP").        
    
    if avail natur-oper then
        assign c-nat-operacao = docum-est.nat-operacao + " - " + natur-oper.denominacao.
        
    run html-con-tab(c-nat-operacao, "left").        
/*    run html-cab-tab("Conta Cont†bil").
    run html-con-tab(c-conta-contabil, "left").    
*/    
    run html-ini-lin-tab.            
    run html-cab-tab("Vlr Total NF").        
    RUN html-con-tab(string(docum-est.tot-valor,">>>>>,>>9.99"), "left").        

    run html-fim-lin-tab.    
    run html-fim-tab.    
    
    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("Item").
    run html-cab-tab("Descriá∆o").
    run html-cab-tab("Dep").
    run html-cab-tab("Quantidade").
    run html-cab-tab("Vlr Unitario").    
    run html-cab-tab("Vlr Total").
    run html-cab-tab("% ICMS").
    run html-cab-tab("Vlr ICMS").        
    run html-cab-tab("% IPI").        
    run html-cab-tab("Vlr IPI").        
    run html-fim-lin-tab.
    
    for each item-doc-est of docum-est no-lock:        
        FOR EACH movto-estoq
             where movto-estoq.serie-docto  = item-doc-est.serie-docto
               and movto-estoq.nro-docto    = item-doc-est.nro-docto
               and movto-estoq.cod-emitente = item-doc-est.cod-emitente
               and movto-estoq.nat-operacao = item-doc-est.nat-operacao
               and movto-estoq.it-codigo    = item-doc-est.it-codigo
               and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
            if movto-estoq.tipo-trans = 1 then do:
                run html-ini-lin-tab.
                run html-con-tab(item-doc-est.it-codigo, "left").
                
                find item where
                     item.it-codigo = movto-estoq.it-codigo no-lock no-error.
                     
                run html-con-tab(substring(item.desc-item,1,40), "left").
                run html-con-tab(item-doc-est.cod-depos, "center").    
                run html-con-tab(string(item-doc-est.quantidade,">>>>>,>>9.9999"), "right").        
                run html-con-tab(string(item-doc-est.preco-unit[1],">>>>>,>>9.99"), "right").        
                run html-con-tab(string(item-doc-est.preco-total[1],">>>>>,>>9.99"), "right").
                run html-con-tab(string(item-doc-est.aliquota-icm,">>9.99"), "right").
                run html-con-tab(string(item-doc-est.valor-icm[1],">>>,>>9.99"), "right").
                run html-con-tab(string(item-doc-est.aliquota-ipi,">>9.99"), "right").
                run html-con-tab(string(item-doc-est.valor-ipi[1],">>>,>>9.99"), "right").
                run html-fim-lin-tab.                
            end.
        end.        
    end.    
    run html-fim-tab.

    output close.
end procedure.


PROCEDURE piAtualizaAeInspecao:
    FOR EACH ae-inspecao 
       WHERE ae-inspecao.cod-estabel  = docum-est.cod-estabel and
             ae-inspecao.cod-emitente = docum-est.cod-emitente   AND
             ae-inspecao.nro-docto    = int(docum-est.nro-docto) AND
             ae-inspecao.serie        = docum-est.serie-docto EXCLUSIVE-LOCK:
        ASSIGN ae-inspecao.nat-operacao = docum-est.nat-operacao.
    END.
    FOR EACH ficha-cq WHERE
             ficha-cq.cod-estabel  = docum-est.cod-estabel and   
             ficha-cq.cod-emitente = docum-est.cod-emitente AND
             ficha-cq.nro-docto    = docum-est.nro-docto    AND
             ficha-cq.serie        = docum-est.serie-docto EXCLUSIVE-LOCK:
        ASSIGN  ficha-cq.nat-operacao = docum-est.nat-operacao.
    END.
END PROCEDURE.

PROCEDURE piImprimeRoteiro:
    DEF VAR cfile AS CHAR NO-UNDO.
    DEF VAR t-raw AS RAW NO-UNDO.

    DEFINE VARIABLE c-impressora LIKE imprsor_usuar.nom_impressora  INIT ""  NO-UNDO.
    DEFINE VARIABLE c-layout     LIKE layout_impres.cod_layout      INIT ""  NO-UNDO.


    FIND FIRST ae-entrada 
         WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
           AND ae-entrada.nro-docto    = int(docum-est.nro-docto) 
           AND ae-entrada.cod-emitente = docum-est.cod-emitente  NO-LOCK NO-ERROR.
    IF AVAIL ae-entrada THEN DO:
        FOR EACH tt-param:
            DELETE tt-param.
        END.

        RUN esp/es0018p.p (INPUT "re1005rp",
                           INPUT 9, 
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).

        for FIRST tt-prog-ponto 
            where entry(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel:

            ASSIGN c-impressora = entry(2,tt-prog-ponto.conteudo,";")
                   c-layout     = entry(3,tt-prog-ponto.conteudo,";").

        END.

        CREATE tt-param.
        ASSIGN tt-param.usuario         = docum-est.usuario
               tt-param.cod-estabel     = docum-est.cod-estabel
               tt-param.destino         = 1
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               tt-param.cod-emitente    = docum-est.cod-emitente
               tt-param.serie-docto     = docum-est.serie-docto
               tt-param.nro-docto       = docum-est.nro-docto
               tt-param.nat-operacao    = docum-est.nat-operacao
               tt-param.urgencia        = NO
               tt-param.imprime-param   = NO
               tt-param.volume          = dec(ae-entrada.estrado[1])
               tt-param.localizacao1    = ae-entrada.localizacao[1]
               tt-param.localizacao2    = ae-entrada.localizacao[2]
               tt-param.localizacao3    = ae-entrada.localizacao[3]
               tt-param.localizacao4    = ae-entrada.localizacao[4]
               tt-param.localizacao5    = ae-entrada.localizacao[5]
               tt-param.arquivo         = c-impressora + ":" + c-layout /*"REC-Laser:Padr∆o_132_R_Duplex"*/
            .

        /* Substitui a include acima */
        FIND imprsor_usuar                                    WHERE
             imprsor_usuar.nom_impressora = c-impressora /*"REC-Laser"*/       AND
             imprsor_usuar.cod_usuario    = docum-est.usuario NO-ERROR.
        
        IF NOT AVAIL imprsor_usuar THEN DO:
            PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
            PUT docum-est.serie-docto at 1.
            PUT docum-est.nro-docto   at 7.
            PUT string(docum-est.cod-emitente) at 24 format "x(9)".
            PUT docum-est.nat-operacao at 35.
            PUT "N∆o encontrado impressora " + c-impressora + " para usuario " + docum-est.usuario + " para impress∆o do roteiro." AT 53 FORMAT "x(100)" SKIP.
            RETURN.
        END.
        ELSE DO:
            FIND layout_impres WHERE
                 layout_impres.nom_impressora = imprsor_usuar.nom_impressora AND
                 layout_impres.cod_layout     = c-layout /*"Padr∆o_132_R_Duplex"*/ NO-ERROR.
            IF NOT AVAIL layout_impres THEN DO:
                PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                PUT docum-est.serie-docto at 1.
                PUT docum-est.nro-docto   at 7.
                PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                PUT docum-est.nat-operacao at 35.
                PUT "N∆o encontrado layout de impress∆o " + c-layout + " para impressora " + c-impressora + "." AT 53 FORMAT "x(100)" SKIP.
                RETURN.
            END.
        END.

        IF OPSYS = "UNIX" THEN DO:
            RUN pi-pedido-execucao.
        END.
        ELSE DO:
            RAW-TRANSFER tt-param TO t-raw.
            RUN esp/cqp/escqp003rp.p (INPUT t-raw,
                                      INPUT TABLE tt-raw-digita).
        END.
    END.
    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-dt-efetiva-embarque:
    DEF VAR c-embarque AS CHAR NO-UNDO.

    ASSIGN c-embarque = TRIM(SUBSTRING(docum-est.char-1,1,12)).

    FOR LAST historico-embarque
       WHERE historico-embarque.cod-estabel = docum-est.cod-estabel
         AND historico-embarque.embarque = c-embarque EXCLUSIVE-LOCK:
        ASSIGN historico-embarque.dt-efetiva = docum-est.dt-trans.
    END.

    find first embarque-imp where
               embarque-imp.cod-estabel = docum-est.cod-estabel and
               embarque-imp.embarque    = c-embarque exclusive-lock no-error.
    if avail embarque-imp then
        assign embarque-imp.situacao = 2. /* encerrado */
    RELEASE embarque-imp.
END PROCEDURE. 


PROCEDURE GeraPedidoDeVenda:
    DEF VAR  i-cond-pagto LIKE cat.cod-cond-pagto NO-UNDO.
    DEF VAR i-cod-transp LIKE cat.cod-transp NO-UNDO .
    DEF VAR d-vl-liq-abe AS DECIMAL NO-UNDO.
    DEF VAR d-vl-liq-it  AS DECIMAL NO-UNDO.
    DEF VAR i-sequencia  AS INTEGER NO-UNDO.
    DEF VAR l-abaixo-min AS LOGICAL NO-UNDO.
    DEF VAR c-desc-suspend AS CHARACTER NO-UNDO.
    DEF VAR l-erro         AS LOGICAL NO-UNDO.
    DEF VAR h-acomp-1 AS HANDLE NO-UNDO.
    DEF VAR c-atendente  AS CHARACTER NO-UNDO.

    FIND FIRST para-ped NO-LOCK.
    FIND FIRST para-fat NO-LOCK.
    
    run utp/ut-acomp.p persistent set h-acomp-1.  
    run pi-inicializar in h-acomp-1 (input "UPC-Gerando Pedido de Venda...").
    
    PUT 1 SKIP.

    do trans:
          assign d-vl-liq-abe = 0
                 d-vl-liq-it  = 0
                 i-sequencia  = 0
                 l-abaixo-min = no
                 c-desc-suspend = ""
                 l-erro = NO.
    
          RUN pi-zerar-temporarias.

          IF NOT AVAIL emitente THEN RETURN "OK".

          PUT 2 emitente.cod-emitente emitente.cod-rep  SKIP.
          find repres no-lock where
               repres.cod-rep = IF emitente.cod-rep = 0 THEN 4000 ELSE emitente.cod-rep no-error.
          PUT 3 AVAIL repres SKIP.

    /*
          IF NOT AVAIL emitente THEN DO:
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Cliente " + string(cat.cod-emitente) + " nao cadastrado ").
    
             LEAVE.
          END.
    
          IF NOT AVAIL repres THEN DO:
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Representante " + string(emitente.cod-rep) + " do cliente nío cadastrado.").
    
             LEAVE.
          END.
    */
    
          find first loc-entr no-lock use-index ch-entrega
               WHERE loc-entr.cod-entrega = "padrao"
                 AND loc-entr.nome-abrev  = emitente.nome-abrev no-error.
    
          IF NOT AVAIL loc-entr THEN DO:
              PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                  "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
              PUT docum-est.serie-docto at 1.
              PUT docum-est.nro-docto   at 7.
              PUT string(docum-est.cod-emitente) at 24 format "x(9)".
              PUT docum-est.nat-operacao at 35.
              PUT "17567" AT 45.
              PUT "Local de entrega do cliente " + string(emitente.cod-emitente) + " nío cadastrado." AT 53 FORMAT "x(60)" SKIP.
/*
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Local de entrega do cliente " + string(emitente.cod-emitente) + " nío cadastrado.").
*/    
             LEAVE.
          END.

         FIND FIRST loc-entr
             WHERE loc-entr.nome-abrev  = emitente.nome-abrev
             AND   loc-entr.cod-entrega = "Padrao"
         NO-LOCK NO-ERROR.

         IF AVAIL loc-entr THEN DO:
            FIND FIRST transporte
                 WHERE transporte.nome-abrev = loc-entr.nome-transp
                 NO-LOCK NO-ERROR.
         END.
    
          IF NOT AVAIL transporte THEN DO:
              PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                  "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
              PUT docum-est.serie-docto at 1.
              PUT docum-est.nro-docto   at 7.
              PUT string(docum-est.cod-emitente) at 24 format "x(9)".
              PUT docum-est.nat-operacao at 35.
              PUT "17567" AT 45.
              PUT "Transportador do cliente nao cadastrado no local de entrega.Sera atribuido SEDEX PARA O PEDIDO GERADO" AT 53 FORMAT "x(60)" SKIP.
/*
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Transportador do cat nao cadastrado no local de entrega.").
*/                                 
             
          END.
          
          assign c-nat-oper = entry(2,tt-prog-ponto.conteudo,";")
                 c-atendente = entry(3,tt-prog-ponto.conteudo,";").
    
          find b-natur-oper no-lock where
               b-natur-oper.nat-operacao = c-nat-oper no-error.

          IF NOT AVAIL b-natur-oper THEN DO:
              PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                  "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
              PUT docum-est.serie-docto at 1.
              PUT docum-est.nro-docto   at 7.
              PUT string(docum-est.cod-emitente) at 24 format "x(9)".
              PUT docum-est.nat-operacao at 35.
              PUT "17567" AT 45.
              PUT "Natureza de operacao " + c-nat-oper + "Nao Encontrada." AT 53 FORMAT "x(60)" SKIP.
/*
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Natureza de operacao " + c-nat-oper + "Nao Encontrada").
*/                                 
             LEAVE.
          END.

        ASSIGN l-cria-cabecalho = NO.
        FIND FIRST ped-venda
               WHERE ped-venda.nome-abrev = emitente.nome-abrev
                 AND ped-venda.dt-implant = TODAY
                 AND ped-venda.completo   = NO 
                 AND ped-venda.nat-operacao = b-natur-oper.nat-operacao exclusive-LOCK NO-ERROR.
        IF NOT AVAIL ped-venda  THEN DO:
              ASSIGN l-cria-cabecalho = YES.
              create tt-ped-venda.
        
              /* find last ped-venda USE-INDEX ch-pedido no-lock no-error. */
        
              assign tt-ped-venda.nr-pedido = NEXT-VALUE(seq-nr-pedido)
                     tt-ped-venda.nome-abrev = emitente.nome-abrev.
        
              ASSIGN c-pedido = string(tt-ped-venda.nr-pedido).
        
              ASSIGN tt-ped-venda.nr-pedcli = c-pedido.
              
              assign tt-ped-venda.cod-estabel    = IF string(entry(7,tt-prog-ponto.conteudo,";")) <> "" THEN string(entry(7,tt-prog-ponto.conteudo,";")) ELSE docum-est.cod-estabel.
            
                 PUT 5 AVAIL repres SKIP.
              ASSIGN tt-ped-venda.dt-emissao     = today
                     tt-ped-venda.no-ab-reppri   = repres.nome-abrev
                     tt-ped-venda.dt-implant     = today
                     tt-ped-venda.nome-transp    = IF AVAIL transporte THEN transporte.nome-abrev ELSE "SEDEX"
                     tt-ped-venda.cod-emitente   = emitente.cod-emitente
                     tt-ped-venda.nat-operacao   = b-natur-oper.nat-operacao
                     tt-ped-venda.cod-mensagem   = b-natur-oper.cod-mensagem
                     tt-ped-venda.cod-cond-pag   = 0
                     tt-ped-venda.nr-tab-fin     = 1
                     tt-ped-venda.nr-ind-finan   = 1
                     tt-ped-venda.tp-pedido      = c-atendente
                     tt-ped-venda.e-mail         = emitente.e-mail
                     tt-ped-venda.cod-sit-aval   = 1   /* Credito nao Avaliado */
                     tt-ped-venda.mo-codigo      = 0
                     tt-ped-venda.cod-gr-cli     = emitente.cod-gr-cli
                     tt-ped-venda.tp-faturam     = 1
                     tt-ped-venda.origem         = 6
                     tt-ped-venda.atendido       = no
                     tt-ped-venda.cd-origem      = 2
                     tt-ped-venda.user-impl      = c-seg-usuario
                     tt-ped-venda.dt-userimp     = today
                     tt-ped-venda.tip-cob-desp   = para-fat.tip-cob-desp
                     tt-ped-venda.observacoes    = "REF SUA NF; " + docum-est.nro-docto + ";" + docum-est.serie-docto + ";" 
                     tt-ped-venda.cond-espec     = "REF SUA NF; " + docum-est.nro-docto + ";" + docum-est.serie-docto + ";" 
                     tt-ped-venda.esp-ped        = 1.

              ASSIGN tt-ped-venda.cod-priori     = IF int(entry(6,tt-prog-ponto.conteudo,";")) <> 0 THEN int(entry(6,tt-prog-ponto.conteudo,";")) ELSE 01.
              ASSIGN tt-ped-venda.cod-rota       = ""
                     tt-ped-venda.cod-canal-venda  = if b-natur-oper.cod-canal-venda <> 0 then
                                                        b-natur-oper.cod-canal-venda
                                                     else emitente.cod-canal-venda
                     tt-ped-venda.ind-ent-completa = YES
                     tt-ped-venda.dsp-pre-fat      = YES
                     tt-ped-venda.log-usa-tabela-desconto = NO
                     tt-ped-venda.ind-lib-nota     = para-ped.ind-lib-nota WHEN avail para-ped
                     OVERLAY(tt-ped-venda.char-2,109,8)   = "0"
                     tt-ped-venda.ind-fat-par      = YES.

              ASSIGN tt-ped-venda.cod-canal-venda = IF STRING(entry(4,tt-prog-ponto.conteudo,";")) <> "" THEN int(entry(4,tt-prog-ponto.conteudo,";")) ELSE tt-ped-venda.cod-canal-venda.

              if b-natur-oper.consum-final then
                 assign tt-ped-venda.cod-des-merc = 2.
              else
                 assign tt-ped-venda.cod-des-merc = 1.
        
             assign tt-ped-venda.dt-entrega = today
                    tt-ped-venda.dt-entorig = today.
        
             PUT 6 SKIP.
             if  avail loc-entr then
                 ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
                        tt-ped-venda.bairro       = loc-entr.bairro
                        tt-ped-venda.cidade       = loc-entr.cidade
                        tt-ped-venda.pais         = loc-entr.pais
                        tt-ped-venda.estado       = loc-entr.estado
                        tt-ped-venda.cep          = loc-entr.cep
                        tt-ped-venda.caixa-postal = loc-entr.caixa-postal
                        tt-ped-venda.cgc          = loc-entr.cgc
                        tt-ped-venda.ins-estadual = loc-entr.ins-estadual
                        tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
                        tt-ped-venda.cidade-cif   = "".
             else
                 if  avail emitente then
                     ASSIGN tt-ped-venda.local-entreg = emitente.endereco
                            tt-ped-venda.bairro       = emitente.bairro
                            tt-ped-venda.cidade       = emitente.cidade
                            tt-ped-venda.pais         = emitente.pais
                            tt-ped-venda.estado       = emitente.estado
                            tt-ped-venda.cep          = emitente.cep
                            tt-ped-venda.caixa-postal = emitente.caixa-postal
                            tt-ped-venda.cgc          = emitente.cgc
                            tt-ped-venda.ins-estadual = emitente.ins-estadual
                            tt-ped-venda.cidade-cif   = emitente.cidade.
        
              assign tt-ped-venda.ind-fat-par = YES.

              PUT "5a " AVAIL repres SKIP.

              /***** CRIACAO DO PED-REPRE ******* */
              find first tt-ped-repre where
                   tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido and
                   tt-ped-repre.nome-ab-rep = repres.nome-abrev no-error.
        
              if not avail tt-ped-repre then do:
                find first comis-rep no-lock where
                     comis-rep.cod-gr-cli = emitente.cod-gr-cli and
                     comis-rep.cod-rep = repres.cod-rep and
                     comis-rep.dt-ini <= today and
                     comis-rep.dt-fim >= today no-error.
        
                assign de-perc = 0.
                if not avail comis-rep then do:
                   assign c-desc-suspend = " Repres " + string(repres.cod-rep,">>>>9") +
                                 " sem comissao cadastrada".
                end.
                else
                   assign de-perc = comis-rep.perc.
        
                 create tt-ped-repre.
                 assign tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido
                        tt-ped-repre.ind-repbase = yes
                        tt-ped-repre.perc-comis =  de-perc
                        tt-ped-repre.nome-ab-rep = repres.nome-abrev.
              end.
        
        
            /*** Atribuir Portador conforme o cadastro do cliente ***/
              if emitente.portador <> 0 then
                 assign tt-ped-venda.cod-portador = emitente.portador
                        tt-ped-venda.modalidade   = emitente.modalidade.
              else
                 assign tt-ped-venda.cod-portador = 999
                        tt-ped-venda.modalidade   = 6.
            
            run pi-acompanhar in h-acomp-1 (input "Documento " + docum-est.nro-docto).
        END.
        ELSE DO:
            ASSIGN ped-venda.observacoes    = ped-venda.observacoes + " e NF ;" + docum-est.nro-docto + ";" + docum-est.serie-docto + ";" 
                   ped-venda.cond-espec     = ped-venda.cond-espec  + " e NF ;" + docum-est.nro-docto + ";" + docum-est.serie-docto + ";" .
            CREATE tt-ped-venda.
            BUFFER-COPY ped-venda TO tt-ped-venda.
            FIND LAST ped-item
                 WHERE ped-item.nome-abrev = ped-venda.nome-abrev
                   AND ped-item.nr-pedcli  = ped-venda.nr-pedcli
                 NO-LOCK NO-ERROR.
            IF AVAIL ped-item THEN 
               ASSIGN i-sequencia = ped-item.nr-sequencia.
        END.
        /*************** ITENS DO PEDIDO   ****************** */
        FOR EACH item-doc-est OF docum-est NO-LOCK:
    
            find item no-lock where
                 item.it-codigo = item-doc-est.it-codigo no-error.
/*        
            if not avail item then do:         
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Item " + item-doc-est.it-codigo + "Nao Encontrado").
                undo, return.
            end.
  */      
            FIND FIRST classif-fisc NO-LOCK
                 WHERE classif-fisc.class-fiscal = ITEM.class-fisc NO-ERROR.
        
            IF NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
                PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                PUT docum-est.serie-docto at 1.
                PUT docum-est.nro-docto   at 7.
                PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                PUT docum-est.nat-operacao at 35.
                PUT "17567" AT 45.
                PUT "Classificacao fiscal " + item.class-fisc + "Nao Encontrado ou em branco no cadastro de itens." AT 53 FORMAT "x(60)" SKIP.
/*
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Classificacao fiscal " + item.class-fisc + "Nao Encontrado ou em branco no cadastro de itens").
*/    
                undo, return.
            end.         
        
            find repres no-lock where
                 repres.nome-abrev = tt-ped-venda.no-ab-reppri no-error.
        
            find first tt-ped-item exclusive-lock
                 where tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                   and tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli
                   and tt-ped-item.it-codigo = item.it-codigo
                   and tt-ped-item.vl-preori =  item-doc-est.preco-unit[1] no-error.
            if avail tt-ped-item then do:
               find tt-ped-ent of tt-ped-item exclusive-lock no-error.
               assign tt-ped-item.qt-pedida = tt-ped-item.qt-pedida + item-doc-est.quantidade
                      tt-ped-ent.qt-pedida  = tt-ped-item.qt-pedida.
            end.
            else do:
                /* Buscar unidadem de neg¢cio do item */
                FIND item-uni-estab NO-LOCK
                    WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
                      AND item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel NO-ERROR.
    
                    /* ATRIBUIR SEQUENCIA AO ITEM */
                  assign i-sequencia = i-sequencia + 10.        
                    
                  create tt-ped-item.    
                  assign tt-ped-item.aliquota-ipi     = item.aliquota-ipi when avail item
                         tt-ped-item.nr-pedcli        = tt-ped-venda.nr-pedcli
                         tt-ped-item.cod-entrega      = tt-ped-venda.cod-entrega
                         tt-ped-item.dt-entrega       = tt-ped-venda.dt-entrega
                         substr(tt-ped-item.char-2,1,8) = ITEM.class-fiscal.
                         
                  assign tt-ped-item.nr-sequencia = i-sequencia.               
              
                  assign tt-ped-item.qt-pedida        = item-doc-est.quantidade
                         tt-ped-item.cod-sit-item     = tt-ped-venda.cod-sit-ped
                         tt-ped-item.cod-sit-pre      = tt-ped-venda.cod-sit-pre
                         tt-ped-item.dt-entorig       = tt-ped-venda.dt-entorig
                         tt-ped-item.dt-userimp       = tt-ped-venda.dt-userimp
                         tt-ped-item.esp-ped          = 1
                         tt-ped-item.it-codigo        = item.it-codigo when avail item
                         tt-ped-item.nat-operacao     = b-natur-oper.nat-operacao
                         tt-ped-item.nome-abrev       = tt-ped-venda.nome-abrev
                         tt-ped-item.per-des-icms     = b-natur-oper.per-des-icms
                         tt-ped-item.tp-adm-lote      = 1
                         tt-ped-item.tp-preco         = 0
                         tt-ped-item.user-impl        = tt-ped-venda.user-impl
                         tt-ped-item.vl-pretab        = item-doc-est.preco-unit[1]
                         tt-ped-item.vl-preori        = item-doc-est.preco-unit[1]
                         tt-ped-item.des-pct-desconto = ""
                         tt-ped-item.log-usa-tabela-desconto = NO
                         tt-ped-item.des-un-medida    = ITEM.un
                         tt-ped-item.observacao       = ""
                         tt-ped-item.cod-unid-negoc   = item-uni-estab.cod-unid-negoc WHEN AVAIL item-uni-estab
                         tt-ped-item.per-minfat   = if  avail emitente
                                                 then emitente.per-minfat
                                                 else tt-ped-item.per-minfat
                         tt-ped-item.cd-origem    = 2
                         tt-ped-item.tipo-atend   = IF tt-ped-venda.ind-fat-par THEN
                                                       2
                                                    ELSE
                                                        1.
              
                  /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
              
                  if b-natur-oper.per-des-icm > 0 then
                     assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori -
                                                (tt-ped-item.vl-preori *
                                                (b-natur-oper.per-des-icm / 100))
                                                when avail b-natur-oper.
                  else
                     assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
                  create tt-ped-ent.
                  assign tt-ped-ent.nr-pedcli        = tt-ped-item.nr-pedcli
                         tt-ped-ent.cod-sit-ent      = tt-ped-item.cod-sit-item
                         tt-ped-ent.cod-sit-pre      = tt-ped-item.cod-sit-pre
                         tt-ped-ent.dt-entorig       = tt-ped-item.dt-entorig
                         tt-ped-ent.dt-entrega       = tt-ped-item.dt-entrega
                         tt-ped-ent.dt-userimp       = tt-ped-item.dt-userimp
                         tt-ped-ent.it-codigo        = tt-ped-item.it-codigo
                         tt-ped-ent.nome-abrev       = tt-ped-item.nome-abrev
                         tt-ped-ent.qt-pedida        = tt-ped-item.qt-pedida
                         tt-ped-ent.user-impl        = tt-ped-item.user-impl
                         tt-ped-ent.nr-sequencia     = tt-ped-item.nr-sequencia.
                     
            end.
            assign tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                   tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                   tt-ped-ent.vl-liq-it        = tt-ped-item.vl-liq-it         
                   tt-ped-ent.vl-liq-abe       = tt-ped-item.vl-liq-abe.
        
            /*** TRATAMENTO IPI ** */
            if item.cd-trib-ipi = 1 and  /*** tributado *** */
              (b-natur-oper.cd-trib-ipi = 1 or      /**** tributado *** */
               b-natur-oper.cd-trib-ipi = 4) then  /**** Reduzido **** */
               assign tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it +
                                           (tt-ped-item.vl-liq-it *
                                            tt-ped-item.aliquota-ipi / 100).
            else
               assign tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.
        
            assign tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.
        
            /* ATRIBUICAO DE VALORES TOTAIS DO PEDIDO */
            assign d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
                   d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
         
            /* CASO ENCONTRE ALGUM ERRO, ENVIA E-MAIL E VAI PARA O PROXIMO ARQUIVO **** */
            IF l-erro  THEN
               NEXT.
        
            ASSIGN tt-ped-venda.nat-operacao = b-natur-oper.nat-operacao
                   tt-ped-venda.cod-mensagem = b-natur-oper.cod-mensagem.
                   tt-ped-venda.cod-canal-venda  = if b-natur-oper.cod-canal-venda <> 0 then
                                                      b-natur-oper.cod-canal-venda
                                                   else emitente.cod-canal-venda.
            ASSIGN tt-ped-venda.cod-canal-venda = IF entry(4,tt-prog-ponto.conteudo,";") <> "" THEN int(entry(4,tt-prog-ponto.conteudo,";")) ELSE tt-ped-venda.cod-canal-venda.
            if b-natur-oper.consum-final then
               assign tt-ped-venda.cod-des-merc = 2.
            else
               assign tt-ped-venda.cod-des-merc = 1.
        
            assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
                   tt-ped-venda.vl-liq-abe = d-vl-liq-abe
                   tt-ped-venda.vl-mer-abe = d-vl-liq-it
                   tt-ped-venda.vl-liq-ped = d-vl-liq-it.
        
            find first repres no-lock
                 where repres.nome-abrev = tt-ped-venda.no-ab-reppri no-error.
        
            /**** A COBRANCA DO FRETE SO ACONTECE PARA A UNIDADE DE CENTRAIS
                  PARA PEDIDO COM VALOR ABAIXO DE R$ 3000,00
                  NO CADASTRO DE LOCAIS DE ENTREGA CIDADE CIF = BRANCO
                  IDENTIFICA SE CONTROLA FRETE CIF E FOB ******* */
        
            if emitente.cod-gr-cli = 22 OR emitente.cod-gr-cli = 23 or
               emitente.cod-gr-cli = 24 OR emitente.cod-gr-cli = 26 THEN DO:
               IF TT-ped-venda.vl-tot-ped > 3000 then
                  assign tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
               else
                  assign tt-ped-venda.cidade-cif = "".
            END.
        
            if l-abaixo-min then do:
               assign tt-ped-venda.observacoes = tt-ped-venda.observacoes +  " CONTEM ITENS ABAIXO DO MINIMO. ".
            end.

           

        end.  /* FOR EACH item-doc-est OF docum-est NO-LOCK: */
        
        ASSIGN l-erro = NO.

        PUT 7 SKIP.
        RUN pi-executar-bos (INPUT c-desc-suspend,
                             OUTPUT l-erro).

        IF l-erro THEN
           undo, leave.        
        ELSE DO:
            FIND int-docum-est
                 WHERE int-docum-est.cod-emitente = docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = docum-est.nat-operacao
                   AND int-docum-est.nro-docto    = docum-est.nro-docto
                   AND int-docum-est.serie-docto  = docum-est.serie-docto
                 EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL INT-docum-est THEN DO:
                CREATE int-docum-est.
                ASSIGN int-docum-est.cod-emitente = docum-est.cod-emitente
                       int-docum-est.nat-operacao = docum-est.nat-operacao
                       int-docum-est.nro-docto    = docum-est.nro-docto
                       int-docum-est.serie-docto  = docum-est.serie-docto.
            END.
            ASSIGN int-docum-est.nr-pedido = tt-ped-venda.nr-pedido.




            FOR EACH ped-item NO-LOCK
                WHERE ped-item.nome-abrev = tt-ped-venda.nome-abrev
                  AND ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli:

                assign c-unid-neg = "".
                FIND item-uni-estab NO-LOCK
                    WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
                      AND item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel NO-ERROR.

                IF  AVAIL item-uni-estab
                THEN
                    ASSIGN c-unid-neg = item-uni-estab.cod-unid-neg.

                IF c-unid-neg <> "" THEN DO:
                    FIND FIRST ponto-programa
                        WHERE ponto-programa.nome-programa = "re1005rp":U
                          AND ponto-programa.ponto         = 8 NO-LOCK NO-ERROR.
                    
                    IF AVAILABLE ponto-programa THEN DO:
                        FOR EACH conteudo-programa
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                            and entry(1,conteudo-programa.conteudo) = c-unid-neg:
                            FIND tt-unid-neg
                                 WHERE tt-unid-neg.unid-neg = c-unid-neg
                                 NO-ERROR.
                            IF NOT AVAIL tt-unid-neg THEN DO:
                                CREATE tt-unid-neg.
                                ASSIGN tt-unid-neg.unid-neg         = c-unid-neg
                                       tt-unid-neg.cod-canal-venda  = int(entry(2,conteudo-programa.conteudo)).
                            END.
                            ASSIGN tt-unid-neg.valor = tt-unid-neg.valor + ped-item.qt-pedida * ped-item.vl-preuni.
                                
                            LEAVE.
                        END.
                    END.
                END.
            END.

            FIND ped-venda
                 WHERE ped-venda.nome-abrev = tt-ped-venda.nome-abrev    
                   AND ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
                EXCLUSIVE-LOCK NO-ERROR.
            FOR EACH tt-unid-neg
                BY tt-unid-neg.valor:
                ASSIGN ped-venda.cod-canal-venda = tt-unid-neg.cod-canal-venda.
            END.

            PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
            PUT docum-est.serie-docto at 1.
            PUT docum-est.nro-docto   at 7.
            PUT string(docum-est.cod-emitente) at 24 format "x(9)".
            PUT docum-est.nat-operacao at 35.
            PUT "17567" AT 45.
            PUT "Pedido Assitància TÇcnica Criado " + string(tt-ped-venda.nr-pedcli) AT 53 FORMAT "x(50)" SKIP.
        END.
    end.       
    run pi-finalizar in h-acomp-1.
end procedure.


PROCEDURE pi-zerar-temporarias:
    FOR EACH tt-ped-venda:
        DELETE tt-ped-venda.
    END.

    FOR EACH tt-ped-item:
        DELETE tt-ped-item.
    END.


    FOR EACH tt-ped-ent:
        DELETE tt-ped-ent.
    END.

    FOR EACH tt-ped-repre:
        DELETE tt-ped-repre.
    END.

    for each tt-ped-vendor:
        delete tt-ped-vendor.
    end.

    FOR EACH RowErrors:
        DELETE RowErrors.
    END.
END PROCEDURE.


PROCEDURE pi-executar-bos.
    DEF INPUT PARAMETER p-desc-suspend AS CHAR.
    DEFINE OUTPUT PARAM l-erro         AS LOG NO-UNDO.
    
    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:

        IF l-cria-cabecalho THEN DO:
            run dibo/bodi159.p persistent set h-bodi159.
    
            run openQueryStatic in h-bodi159(input "Main":U).
            run setRecord       in h-bodi159(input table tt-ped-venda).
            RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
            run emptyRowErrors in h-bodi159.
            run createMPLog    in h-bodi159(input no).
            RUN createRecord   in h-bodi159.
            run getRowErrors   in h-bodi159(output table RowErrors).
    
            if can-find (first RowErrors
                        where RowErrors.ErrorType   <> "INTERNAL":U
                            and RowErrors.ErrorSubType = "Error") then do:
                for each rowerrors:
                    PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                        "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                    PUT docum-est.serie-docto at 1.
                    PUT docum-est.nro-docto   at 7.
                    PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                    PUT docum-est.nat-operacao at 35.
                    PUT string(rowErrors.errornumber) AT 48.
                    PUT "Erro na Criaá∆o do Pedido de Venda, avise o responsavel " rowerrors.errordescription AT 53 FORMAT "x(100)" SKIP.
                end.
               ASSIGN l-erro = yes.
      
            END.
            run destroyBO in h-bodi159.
    
            delete procedure h-bodi159.

            IF l-erro  THEN
               UNDO bloco, LEAVE bloco.
    
    
            run dibo/bodi157.p persistent set h-bodi157.
    
            FOR EACH tt-ped-repre:
                run openQueryStatic in h-bodi157(input "Default":U).
                run emptyRowErrors in h-bodi157.
                run setRecord in h-bodi157(input table tt-ped-repre).
                run createMPLog  in h-bodi157(input no).
                run createRecord in h-bodi157.
                run getRowErrors in h-bodi157(output table RowErrors).
    
                if can-find (first RowErrors
                            where RowErrors.ErrorType   <> "INTERNAL":U
                                and RowErrors.ErrorSubType = "Error") then do:
                    for each rowerrors:
                        PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                        PUT docum-est.serie-docto at 1.
                        PUT docum-est.nro-docto   at 7.
                        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                        PUT docum-est.nat-operacao at 35.
                        PUT string(rowErrors.errornumber) AT 48.
                        PUT "Erro na Criaá∆o do Pedido de Venda - Representante, avise o responsavel " rowerrors.errordescription AT 53 FORMAT "x(100)" SKIP.

                    end.

                   ASSIGN l-erro = yes.
          
                END.
                DELETE tt-ped-repre.
            END.
    
            delete procedure h-bodi157.
    
            IF l-erro  THEN
               UNDO bloco, LEAVE bloco.
        end.   

        run dibo/bodi154.p persistent set h-bodi154.

        FOR EACH tt-ped-item:
            run openQueryStatic in h-bodi154(input "Default":U).
            run emptyRowErrors in h-bodi154.
            run setRecord in h-bodi154(input table tt-ped-item).
            run createMPLog  in h-bodi154(input no).
            run createRecord in h-bodi154.
            run getRowErrors in h-bodi154(output table RowErrors).

            FIND first RowErrors
                 where RowErrors.ErrorType   <> "INTERNAL":U
                   and RowErrors.ErrorSubType = "Error" NO-ERROR.
            IF AVAIL rowErrors THEN DO:
                PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
                PUT docum-est.serie-docto at 1.
                PUT docum-est.nro-docto   at 7.
                PUT string(docum-est.cod-emitente) at 24 format "x(9)".
                PUT docum-est.nat-operacao at 35.
                PUT string(rowErrors.errornumber) AT 48.

                PUT "Erro na Criaá∆o do Pedido de Venda - Item, avise o responsavel "  rowerrors.errordescription AT 53 FORMAT "x(100)" SKIP.
               ASSIGN l-erro = yes.
            END.
            DELETE tt-ped-item.
        END.
        run destroyBO in h-bodi154.
        delete procedure h-bodi154.

        IF l-erro  THEN do:
            PUT "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
            PUT docum-est.serie-docto at 1.
            PUT docum-est.nro-docto   at 7.
            PUT string(docum-est.cod-emitente) at 24 format "x(9)".
            PUT docum-est.nat-operacao at 35.
            PUT "4 - Erro " AT 53 FORMAT "x(100)" SKIP.
            UNDO bloco, LEAVE bloco.
        end.



        /* COMPLETA ORDER */

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli = tt-ped-venda.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.


        FIND FIRST int-ped-venda
            WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-ped-venda THEN DO:
            CREATE int-ped-venda.
            ASSIGN int-ped-venda.nr-pedido             = ped-venda.nr-pedido
                   int-ped-venda.cod-estabel           = ped-venda.cod-estabel
                   OVERLAY(int-ped-venda.char-1, 1, 8) = STRING(TIME, "hh:mm:ss":U).
            ASSIGN OVERLAY(int-ped-venda.char-1,16,3)  = "90". /* Por solicitaá∆o Simone Junckes chamado ir95780 */
        END.
        ELSE
            ASSIGN OVERLAY(int-ped-venda.char-1,16,3)  = "90"
                   int-ped-venda.cod-estabel           = ped-venda.cod-estabel.

       ASSIGN OVERLAY(int-ped-venda.char-1,16,3) = IF entry(5,tt-prog-ponto.conteudo,";") <> "" THEN entry(5,tt-prog-ponto.conteudo,";") ELSE SUBSTRING(int-ped-venda.char-1,16,3).
            
        IF ped-venda.tp-pedido = "96" THEN DO: /* Por solicitaá∆o Simone Junckes chamado ir95780 */
        
            run dibo/bodi159com.p persistent set h-bodi159cal.
    
    
            run completeOrder in h-bodi159cal (input rowid(ped-venda),
                                               OUTPUT TABLE rowerrors).
    
            if can-find (first RowErrors
                        where RowErrors.ErrorType   <> "INTERNAL":U
                            and RowErrors.ErrorSubType = "Error") then do:
                FOR EACH rowerrors:
                    MESSAGE rowerrors.errordescription SKIP
                        "Tipo " RowErrors.ErrorType
                        "Pedido " tt-ped-venda.nr-pedcli
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
            END.
    
            delete procedure h-bodi159cal.
    
            IF l-erro  THEN do:
                            message "6 - erro " view-as alert-box.
               UNDO bloco, LEAVE bloco.
            end.
       END.


        /* SUSPENDE PEDIDO */

/*         IF p-desc-suspend <> "" THEN DO: */
/*             run dibo/bodi159sus.p persistent set h-bodi159sus. */
/*    */
/*             FOR EACH RowErrors: */
/*                 DELETE RowErrors. */
/*             END. */
/*    */
/*             run ValidateSuspension in h-bodi159sus (input rowid(ped-venda), */
/*                                                     OUTPUT TABLE RowErrors). */
/*             if can-find (first RowErrors */
/*                         where RowErrors.ErrorType   <> "INTERNAL":U */
/*                             and RowErrors.ErrorSubType = "Error") then do: */
/*                         message "7 - erro " view-as alert-box. */
/*                undo, return. */
/*    */
/*             END. */
/*             IF l-erro THEN */
/*                 UNDO bloco, LEAVE bloco. */
/*    */
/*             run UpdateSuspension in h-bodi159sus(input rowid(ped-venda), */
/*                                                  INPUT p-desc-suspend). */
/*             IF RETURN-VALUE <> "no":U AND */
/*                RETURN-VALUE <> "ok":U THEN DO: */
/*                         message "8 - erro " view-as alert-box. */
/*                 create rowerrors. */
/*                 assign rowerrors.errordescription = "Problema de integraªío entre B2B e EMS(CONFIRMA-SUSPENSAO)" + */
/*                                 " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli. */
/*    */
/*                UNDO bloco, LEAVE bloco. */
/*             END. */
/*    */
/*             delete procedure h-bodi159sus. */
/*         END. */
    END.
END PROCEDURE.


PROCEDURE pi-pedido-execucao:
    DEFINE VARIABLE cTipServid  AS CHAR NO-UNDO.
    DEFINE VARIABLE cCodServid  AS CHAR    NO-UNDO.
    DEFINE VARIABLE cDesServid  AS CHAR    NO-UNDO.
    DEFINE VARIABLE cMensagServ AS CHAR    NO-UNDO.

    find ped_exec 
        where ped_exec.num_ped_exec = i-num-ped-exec-rpw no-lock no-error.

    if  avail ped_exec then do:
        ASSIGN cCodServid = ped_exec.cod_servid_exec.

        RUN fnbo/bofn054.p persistent set h-boun135.  /*BO alterada no totvs 11*/ 
        RUN openQueryStatic IN h-boun135 ("Main":U).
        RUN gotoKey IN h-boun135 (cCodServid).
        IF RETURN-VALUE = "OK":U THEN
           RUN getCharField IN h-boun135 ("ind_tip_fila_exec", OUTPUT cTipServid).
        IF cTipServid <> "Windows":U AND 
           cTipServid <> "Windows NT":U THEN DO:
           RUN BuscaTipoServidor IN h-boun135 ("Windows":U).
           IF RETURN-VALUE = "NOK":U THEN
              RUN BuscaTipoServidor IN h-boun135 ("Windows NT":U).
           IF RETURN-VALUE = "OK":U THEN DO: /* Encontrou um Servidor Windows */
               RUN getCharField IN h-boun135 ("cod_servid_exec", OUTPUT cCodServid).
               RUN getCharField IN h-boun135 ("des_servid_exec", OUTPUT cDesServid).
               ASSIGN cMensagServ =  "ATENÄ«O! O seu Pedido de Execuá∆o Foi Encaminhado Para o Servidor de Execuá∆o(Windows) " 
                                     + cCodServid + " - " + cDesServid.
           END.
           ELSE DO: /* N∆o Encontrou um Servidor Windows */
               ASSIGN cMensagServ =  "ATENÄ«O! N∆o Foi Encontrado Nenhum Servidor de Execuá∆o Windows/Windows NT Cadastrado. Ficha de Inspeá∆o n∆o impressa.".          
           END.    
        END.
        DELETE PROCEDURE h-boun135.

        IF cMensagServ <> "" THEN DO:
            PUT cMensagServ AT 01 FORMAT "x(130)" SKIP(1).
        END.

        IF cCodServid <> "" THEN DO:
            find ped_exec_param
                where ped_exec_param.num_ped_exec = ped_exec.num_ped_exec no-lock no-error.

            create tt_param_segur.
            assign tt_param_segur.tta_num_vers_integr_api      = 3
                   tt_param_segur.tta_cod_aplicat_dtsul_corren = "MAT"
                   tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)
                   tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
                   tt_param_segur.tta_cod_idiom_usuar          = "POR":U
                   tt_param_segur.tta_cod_modul_dtsul_corren   = "mre"
                   tt_param_segur.tta_cod_pais_empres_usuar    = ped_exec_param.cod_pais
                   tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
                   tt_param_segur.tta_cod_usuar_corren_criptog = ped_exec_param.cod_usuar_criptog.

            create tt_ped_exec.
            assign tt_ped_exec.tta_num_seq                = 1
                   tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
                   tt_ped_exec.tta_cod_prog_dtsul         = "escqp003"
                   tt_ped_exec.tta_cod_prog_dtsul_rp      = "esp/cqp/escqp003rp.p":U
                   tt_ped_exec.tta_cod_release_prog_dtsul = "2.00.00.001"
                   tt_ped_exec.tta_dat_exec_ped_exec      = today
                   tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")
                   tt_ped_exec.tta_cod_servid_exec        = cCodServid
                   tt_ped_exec.tta_cdn_estil_dwb          = 97.

            create tt_ped_exec_param.
            assign tt_ped_exec_param.tta_num_seq              = 1
                   tt_ped_exec_param.tta_cod_dwb_file         = "cqp/escqp003rp.p"
                   tt_ped_exec_param.tta_cod_dwb_output       = ped_exec_param.cod_dwb_output
                   tt_ped_exec_param.tta_nom_dwb_printer      = ped_exec_param.nom_dwb_printer
                   tt_ped_exec_param.tta_cod_dwb_print_layout = ped_exec_param.cod_dwb_print_layout.

            raw-transfer tt-param to tt_ped_exec_param.tta_raw_param_ped_exec.

            run btb/btb912zb.p (input-output table tt_param_segur,
                                input-output table tt_ped_exec,
                                input table tt_ped_exec_param,
                                input table tt_ped_exec_param_aux,
                                input table tt_ped_exec_sel).
        END.
    end.
END PROCEDURE.

/* ----------------------------------------------- */
PROCEDURE pi-verifica-duplicata:
    def output param piErro as logical no-undo.    
    DEFINE VARIABLE l-erro-dupl AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE c-parcela AS CHARACTER  NO-UNDO.
    DEF VAR de-total-dupli like dupli-apagar.vl-a-pagar NO-UNDO.

    ASSIGN l-erro-dupl = NO.

    FIND FIRST dupli-apagar 
         WHERE dupli-apagar.cod-emitente = docum-est.cod-emitente 
           AND dupli-apagar.serie-docto  = docum-est.serie-docto  
           AND dupli-apagar.nro-docto    = docum-est.nro-docto    
           AND dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL dupli-apagar THEN DO:
        PUT SKIP(1)
            "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
            "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.
        PUT docum-est.serie-docto at 1.
        PUT docum-est.nro-docto   at 7.
        PUT string(docum-est.cod-emitente) at 24 format "x(9)".
        PUT docum-est.nat-operacao at 35.
        PUT "EPC" AT 45.
        PUT "N«O ENCONTRADO DUPLICATA. NOTA FISCAL N«O ATUALIZADA" AT 53 FORMAT "x(100)" SKIP.
        assign l-erro-dupl = yes.
    END.
    ELSE DO:
        IF dupli-apagar.dt-vencim < docum-est.dt-trans THEN DO:
            IF NOT l-erro-dupl THEN
                PUT SKIP(1)
                    "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.

            PUT docum-est.serie-docto at 1.
            PUT docum-est.nro-docto   at 7.
            PUT string(docum-est.cod-emitente) at 24 format "x(9)".
            PUT docum-est.nat-operacao at 35.
            PUT "EPC" AT 45.
            PUT "DATA DE VENCIMENTO DA DUPLICATA INCORRETA. NOTA FISCAL N«O ATUALIZADA" AT 53 FORMAT "x(100)" SKIP.
            assign l-erro-dupl = yes.
        END.
    END.

    IF emitente.natureza <= 2 THEN  DO: /* Somente emitentes nacionais valida o total da duplicta como total da nota */
        FOR EACH dupli-apagar WHERE
                 dupli-apagar.cod-emitente = docum-est.cod-emitente AND
                 dupli-apagar.serie-docto  = docum-est.serie-docto  AND
                 dupli-apagar.nro-docto    = docum-est.nro-docto    AND 
                 dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK:

            ASSIGN de-total-dupli = de-total-dupli + dupli-apagar.vl-a-pagar.
        END.
        IF de-total-dupli <> docum-est.tot-valor THEN DO:
            IF NOT l-erro-dupl THEN
                PUT SKIP(1)
                    "SÇrie Documento        Emitente   Nat Oper  Erro    Mensagem                                                                        " SKIP
                    "----- ---------------- ---------  --------  ------  --------------------------------------------------------------------------------" SKIP.

            PUT docum-est.serie-docto at 1.
            PUT docum-est.nro-docto   at 7.
            PUT string(docum-est.cod-emitente) at 24 format "x(9)".
            PUT docum-est.nat-operacao at 35.
            PUT "EPC" AT 45.
            PUT "VALOR DA(s) DUPLICATA(s) N«O CONFERE COM O TOTAL DA NOTA. NOTA FISCAL N«O ATUALIZADA" AT 53 FORMAT "x(100)" SKIP.
            assign l-erro-dupl = yes.
        END.
    END.
/*
    FOR EACH dupli-apagar WHERE
             dupli-apagar.cod-emitente = docum-est.cod-emitente AND
             dupli-apagar.serie-docto  = docum-est.serie-docto  AND
             dupli-apagar.nro-docto    = docum-est.nro-docto    AND 
             dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK:
        IF CAN-FIND(FIRST bf-dupli-apagar WHERE
                          bf-dupli-apagar.cod-emitente  = dupli-apagar.cod-emitente AND
                          bf-dupli-apagar.serie-docto   = dupli-apagar.serie-docto  AND
                          bf-dupli-apagar.nro-docto     = dupli-apagar.nro-docto    AND
                          bf-dupli-apagar.nat-operacao <> dupli-apagar.nat-operacao and
                          bf-dupli-apagar.parcela       = dupli-apagar.parcela NO-LOCK) THEN DO:
            l-erro = YES.
            LEAVE.
        END.
        ELSE DO:
            IF CAN-FIND(FIRST tit-ap
                        WHERE tit-ap.ep-codigo   = estabelec.ep-codigo
                        AND   tit-ap.cod-fornec  = dupli-apagar.cod-emitente
                        AND   tit-ap.cod-esp     = dupli-apagar.cod-esp
                        AND   tit-ap.nr-docto    = dupli-apagar.nro-docto
                        AND   tit-ap.parcela     = dupli-apagar.parcela
                        AND   tit-ap.nat-operac <> dupli-apagar.nat-operacao NO-LOCK) THEN DO:
                l-erro = YES.
                LEAVE.
            END.
        END.
    END.*/

    IF l-erro-dupl THEN DO:
        RETURN "NOK".
    END.
END PROCEDURE.

PROCEDURE piIntegraV360:
    DEF VAR v_row_nota AS ROWID NO-UNDO.

    ASSIGN v_row_nota = ROWID(docum-est).

    /*
    OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
    PUT UNFORMATTED "2.1 - re1005rp-epc - docum-est.serie-docto "  docum-est.serie-docto   skip
                                       "docum-est.nro-docto "    docum-est.nro-docto     skip
                                       "docum-est.cod-emitente " docum-est.cod-emitente  skip
                                       "docum-est.nat-operacao " docum-est.nat-operacao  skip(2).
    OUTPUT CLOSE.  
    */

    RUN esp/wso/eswso0020.p (INPUT v_row_nota).

END PROCEDURE.
