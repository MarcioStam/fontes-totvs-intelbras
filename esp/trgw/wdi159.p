/********************************************************************************
 ** UPC........: wdi159.p - UPC WRITE ped-venda    
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de pedidos de venda para a Base Oracle
 ********************************************************************************/
DEFINE BUFFER usuar_mestre FOR usuar_mestre.

CREATE WIDGET-POOL.

DEF PARAM BUFFER b-ped-venda      FOR ped-venda.
DEF PARAM BUFFER b-old-ped-venda  FOR ped-venda.
DEF NEW GLOBAL SHARED var v_cod_usuar_corren AS CHARACTER NO-UNDO.

DEFINE VARIABLE da-data       AS DATETIME  NO-UNDO.
DEFINE VARIABLE da-data-atual AS DATETIME  NO-UNDO.
DEFINE VARIABLE i-sequencia   AS INTEGER   NO-UNDO.

DEFINE VARIABLE h-escrm001api AS HANDLE    NO-UNDO.

define temp-table tt-ped-venda no-undo like ped-venda.
define temp-table tt-ped-item  no-undo like ped-item.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.

DEFINE VARIABLE h-esapi001            AS HANDLE      NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE de-vl-lim-tot-supcard AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Dezembro de 2011 **/
DEFINE VARIABLE de-limite-supcard     AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE de-ped-aloc-supcard   AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE de-lim-nfs-supcard    AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE de-lim-disp-supcard   AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 **/
DEFINE VARIABLE de-val-a-alocar       AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 **/
DEFINE VARIABLE l-atraso-pagto        AS LOGICAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 **/
DEFINE VARIABLE i-dias-atraso-tit     AS INTEGER     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 **/
DEFINE VARIABLE l-tit-atrasado        AS LOGICAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 **/

/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - In°cio */
DEFINE VARIABLE l-encontrou-cond-pagto AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE i-count                AS INTEGER                       NO-UNDO.
DEFINE VARIABLE v-cod-cond-pag         LIKE int-cond-pagto.cod-cond-pag NO-UNDO.
/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - Final */

/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */
DEFINE VARIABLE l-natur-oper-servico AS LOGICAL     NO-UNDO.
/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - Final */

DEFINE VARIABLE c-lista-clientes AS CHARACTER FORMAT 'x(100)':U NO-UNDO.

DEFINE VARIABLE c-dir           AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cDestino        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDescEmail      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAssunto        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRemetente      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-utapi019      AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-cod-transp    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sigla-transp  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-transp   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-transp-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-unid-comerc   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-nome-programa AS CHARACTER FORMAT 'X(100)' NO-UNDO.

DEFINE VARIABLE raw-param       AS RAW.
{esp/esb/esesb000.i}

{esp/trgw/wdi159.i}
{esp/wso/out/wso0004.i} /*Include Vtex*/

/* ** Retornar limite Intelbras dispon°vel ***/
DEFINE VARIABLE d-tot-matriz LIKE tit_acr.val_sdo_tit_acr
     LABEL "Limite Utilizado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     NO-UNDO.

DEFINE VARIABLE de-lim-disp-intelbras AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-matriz NO-UNDO 
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD nome-abrev   LIKE emitente.nome-abrev.

DEFINE TEMP-TABLE tt-situacao-ped NO-UNDO 
       FIELD it-codigo AS CHAR
       FIELD situacao  AS INT 
       INDEX situacao situacao.

DEF BUFFER b-emitente-matriz-sc FOR emitente.
DEF BUFFER b-emitente-sc        FOR emitente.
DEF BUFFER b-ped-venda-sc       FOR ped-venda.
DEF BUFFER b-estabelecimento-sc FOR estabelecimento.
DEF BUFFER b-cond-pagto-sc      FOR cond-pagto.
DEF BUFFER b-int-cond-pagto-sc  FOR int-cond-pagto.
/* ** Fim Retornar limite Intelbras dispon°vel ***/

define temp-table tt-envio2 NO-UNDO
    field versao-integracao     as integer format ">>9"
    field servidor              as char
    field porta                 as integer init 0
    field exchange              as logical init no
    field destino               as char
    field copia                 as char
    field remetente             as char
    field assunto               as char
    field mensagem              as char
    field arq-anexo             as char
    field importancia           as integer init 0
    field log-enviada           as logical
    field log-lida              as logical
    field acomp                 as logical init yes    
    field formato               as char init "texto".
                                
DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD seq-mensagem          AS INTEGER
    FIELD mensagem              AS CHAR
    INDEX i-seq-mensagem        
          seq-mensagem          ASCENDING.


DEFINE VARIABLE de-valor   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-msg138a         AS HANDLE    NO-UNDO.
DEFINE VARIABLE p-indice-financiamento AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD PrecoBase                AS DEC
    FIELD ValorProduto             AS DEC
    FIELD NomePoliticaComercial    AS CHAR
    FIELD TemCache                 AS LOGICAL
    FIELD DataValidade             AS DATE
    FIELD QuantidadeMaxima         AS DEC
    FIELD RebateAntecipado         AS LOGICAL
    FIELD CalcularRebate             AS LOGICAL
    FIELD PrecoAlterado              AS LOGICAL
    FIELD ValorComDesconto           AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.

/*usada para quebrar o calculo de preáos para n∆o estourar o longchar*/
DEFINE TEMP-TABLE ProdutoItemR-temp LIKE ProdutoItemR.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

find first param-global no-lock no-error.

DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.

{utp/utapi009.i} /* Include API CORREIO ELETRONICO */
{esinc/es0000.i}
{utp/ut-glob.i}
{esp/es0018.i}

IF b-old-ped-venda.cod-sit-ped <> b-ped-venda.cod-sit-ped THEN DO:
    IF b-ped-venda.cod-sit-ped = 2 THEN DO:
        ASSIGN b-ped-venda.val-frete      = 0
               b-ped-venda.val-perc-frete = 0.
    END.                                   
END.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF  b-ped-venda.cod-priori = 5 
OR  b-ped-venda.cod-priori = 6 THEN DO:        

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido NO-ERROR.
    IF AVAIL int-ped-venda THEN
       ASSIGN int-ped-venda.cod-priori-orig = b-ped-venda.cod-priori.

    RELEASE int-ped-venda.
end.

EMPTY TEMP-TABLE tt-prog-ponto.
FIND int-ped-venda
     WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido
     EXCLUSIVE-LOCK NO-ERROR.

IF  AVAIL int-ped-venda and
    int-ped-venda.cod-estabel <> b-ped-venda.cod-estabel THEN DO:
    ASSIGN int-ped-venda.cod-estabel = b-ped-venda.cod-estabel.
END.

RELEASE int-ped-venda.

IF  b-ped-venda.cod-priori <> 44 AND b-old-ped-venda.cod-priori = 44 THEN DO:

    FOR EACH ped-item EXCLUSIVE-LOCK
        WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
          AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli:

        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.nr-pedido = b-ped-venda.nr-pedido NO-ERROR.

        FIND LAST item-dt-entrega NO-LOCK
            WHERE item-dt-entrega.it-codigo = ped-item.it-codigo 
              AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

        IF NOT AVAIL item-dt-entrega THEN DO:

            ASSIGN i-cod-gr-canais = 0.
    
            FIND FIRST atendente
                 WHERE atendente.cd-oper = int(b-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
                ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
            END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
            ELSE DO:
                FIND FIRST emitente
                     WHERE emitente.cod-emitente = b-ped-venda.cod-emitente NO-LOCK NO-ERROR.
                IF  AVAIL emitente THEN DO:
                    FIND FIRST grupo-canais-clientes
                         WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                    IF AVAIL grupo-canais-clientes THEN DO:
                        ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                    END.
                END.
            END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */

            FIND LAST item-dt-entrega NO-LOCK
                WHERE item-dt-entrega.it-codigo = ped-item.it-codigo 
                  AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
        END.

        IF AVAIL item-dt-entrega
             AND item-dt-entrega.dt-entrega-futura > TODAY 
             AND b-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:

            ASSIGN ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura.
        END.
        ELSE
            ASSIGN ped-item.dt-entrega = b-ped-venda.dt-entrega.

        /*trata metas do canal*/
        IF AVAIL ped-item THEN
            RUN esp/ftp/esftp213a.p (INPUT ROWID(ped-item)).

    END.
END.

IF      b-ped-venda.cod-priori  = 44 AND
    b-old-ped-venda.cod-priori <> 44 AND
    b-old-ped-venda.cod-priori <> 00 THEN DO:

    FIND natur-oper
        WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao
        NO-LOCK NO-ERROR.
    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = b-ped-venda.nome-abrev NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    
    IF  AVAIL int-emitente
    AND int-emitente.ind-participa-canais = 993520001
    AND natur-oper.emite-duplic = YES                 THEN DO:

        FIND FIRST ped-item OF b-ped-venda
             NO-LOCK NO-ERROR.
        
        IF AVAIL ped-item  THEN DO:
            FIND FIRST item-uni-estab NO-LOCK
                         WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
                           AND item-uni-estab.cod-estabel = b-ped-venda.cod-estabel NO-ERROR.

            IF AVAIL item-uni-estab THEN DO:

                RUN esp/es0018p.p (INPUT "PD4000",
                                   INPUT 4,
                                   INPUT 0,
                                   INPUT "", 
                                   OUTPUT TABLE tt-prog-ponto).

                /*Unidade de negocios n∆o faz parte do programa de canais*/
                IF NOT CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = item-uni-estab.cod-unid)  THEN DO:
                    ASSIGN b-ped-venda.cod-priori = b-old-ped-venda.cod-priori.
                    IF  OPSYS <> "UNIX":U THEN
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 17006,
                                           INPUT "Pedido do Programa de Canais n∆o Ç permitido mudar a prioridade para 44 (Oráamento)":U +
                                                 "~~":U +
                                                 "":U).

                END.
            END.
        END.

        /**/

        IF b-ped-venda.origem = 1 /* Normal */ THEN DO:
            IF OPSYS <> "UNIX":U THEN
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Pedido do Programa de Canais com origem Normal n∆o Ç permitido mudar a prioridade para 44 (Oráamento).":U).


        END.

    END.
END.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                   INPUT 1,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FIND FIRST tt-prog-ponto 
     WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

IF  b-ped-venda.cod-priori <> 44 AND
    (b-old-ped-venda.cod-sit-ped <> b-ped-venda.cod-sit-ped OR
     b-old-ped-venda.cod-sit-aval <> b-ped-venda.cod-sit-aval)  THEN DO:
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = b-ped-venda.nome-abrev NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF  AVAIL int-emitente
    AND int-emitente.guid-class <> "" THEN DO:

        IF  PROGRAM-NAME(1)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(2)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(3)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(4)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(5)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(6)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(7)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(8)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(9)  MATCHES "*msg0093*" OR
            PROGRAM-NAME(10) MATCHES "*msg0093*" OR
            PROGRAM-NAME(11) MATCHES "*msg0093*" THEN DO:

        END.
        ELSE DO:
            IF AVAIL tt-prog-ponto THEN DO:
                RAW-TRANSFER b-ped-venda TO raw-param.
                RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                        INPUT        raw-param, /* Tupla do registro */
                                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.            
            END.
        END.
    END.
END.


IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

IF NEW b-ped-venda THEN DO:
    FIND FIRST int-ped-venda NO-LOCK 
         WHERE int-ped-venda.nr-pedido   = b-ped-venda.nr-pedido  NO-ERROR.
    IF NOT AVAIL int-ped-venda THEN DO:

        FIND FIRST usuar_mestre 
            WHERE  usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

        CREATE int-ped-venda.
        ASSIGN int-ped-venda.nr-pedido               = b-ped-venda.nr-pedido
               int-ped-venda.cod-estabel             = b-ped-venda.cod-estabel
               overlay(int-ped-venda.char-1,1,8)     = STRING(TIME,"HH:MM:SS").

        /*  Chamado 76313 - Gravar a prioridade original do pedido. Quando ocorrer um faturamento parcial  */
        /*  e piroridade mudar para 1, e a prioridade origem for 2, 3 ou 4, dever† voltar o pedido para a  */
        /*  prioridade original                                                                            */
        ASSIGN int-ped-venda.cod-priori-orig = b-ped-venda.cod-priori.

        FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
        RELEASE int-ped-venda.
    END.
    ELSE DO:
        FIND CURRENT int-ped-venda EXCLUSIVE-LOCK.

        IF int-ped-venda.cod-priori-orig = 44 THEN 
            ASSIGN int-ped-venda.cod-priori-orig = b-ped-venda.cod-priori.

        FIND CURRENT int-ped-venda NO-LOCK.
    END.
END.

IF b-ped-venda.cod-sit-aval = 1 THEN DO:

    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK 
         WHERE int-ped-venda2.nr-pedido   = b-ped-venda.nr-pedido NO-ERROR.
    IF NOT AVAIL int-ped-venda2 THEN DO:
        CREATE int-ped-venda2.
        ASSIGN int-ped-venda2.nr-pedido     = b-ped-venda.nr-pedido
               int-ped-venda2.dt-avaliacao  = TODAY.
    END.
    ELSE
        ASSIGN int-ped-venda2.dt-avaliacao  = TODAY.

    ASSIGN int-ped-venda2.cod-estabel = b-ped-venda.cod-estabel.

    IF int-ped-venda2.int-1 = 0 THEN DO:
        FIND FIRST atendente
            WHERE atendente.cd-oper = int(b-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
        IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
            ASSIGN int-ped-venda2.int-1 = atendente.cod-gr-canais.
        END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
        ELSE DO:
            FIND emitente
                 WHERE emitente.cod-emitente = b-ped-venda.cod-emitente
                 NO-LOCK NO-ERROR.
            IF  AVAIL emitente THEN DO:
                FIND FIRST grupo-canais-clientes
                     WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                IF AVAIL grupo-canais-clientes THEN DO:
                    ASSIGN int-ped-venda2.int-1 = grupo-canais-clientes.cod-gr-canais.
                END.
            END.
        END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */

    END.

    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE int-ped-venda.

END. /* IF b-ped-venda.cod-sit-aval = 1 THEN DO: */


FIND FIRST int-ped-venda EXCLUSIVE-LOCK
     WHERE int-ped-venda.nr-pedido   = b-ped-venda.nr-pedido
       AND int-ped-venda.cod-estabel = b-ped-venda.cod-estabel  NO-ERROR.

/*Marca para envio batch*/
IF  AVAIL int-ped-venda 
AND NOT AVAIL tt-prog-ponto THEN
    OVERLAY(int-ped-venda.char-1,76,1) = "1".

FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
RELEASE int-ped-venda.


find emitente no-lock where
     emitente.nome-abrev = b-ped-venda.nome-abrev no-error.

if not avail emitente then  next.

FIND FIRST repres NO-LOCK WHERE
    repres.nome-abrev = b-ped-venda.no-ab-reppri NO-ERROR.
IF NOT AVAIL repres THEN NEXT.


run esp/es0669.p (input "yes", 
                  "ped-venda", 
                  b-ped-venda.nr-pedcli,
                  string(emitente.cod-emitente,"99999999"),
                  "", "", "", "", "", "", "").

/*********************************************************************************
**  Prop¢sito:  Aprovaá∆o autom†tica de pedidos sem condiá∆o de pagamento e
**              natureza de operaá∆o que n∆o gere duplicata (exceto quando o
**              status de an†lise de crÇdito do cliente for suspenso ou Ö vista.
**  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
**  Criaá∆o:    Abril de 2013
**********************************************************************************/
/****************************************
**  In°cio
*****************************************/
FIND FIRST cond-pagto
    WHERE cond-pagto.cod-cond-pag = b-ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

IF NOT AVAILABLE cond-pagto      OR
   b-ped-venda.cod-cond-pag <> 0 THEN DO:

    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao NO-LOCK NO-ERROR.

    IF AVAILABLE natur-oper        AND
       NOT natur-oper.emite-duplic THEN DO:
        IF emitente.ind-cre-cli <> 4 AND
           emitente.ind-cre-cli <> 5 THEN DO:
            ASSIGN b-ped-venda.dsp-pre-fat  = YES.
                   /*b-ped-venda.cod-sit-aval = 3.*/

            IF PROGRAM-NAME(1) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(2) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(3) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(4) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(5) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(6) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(7) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(8) MATCHES '*ESACR003*'
            OR PROGRAM-NAME(9) MATCHES '*ESACR003*' THEN DO:
            END.
            ELSE
                ASSIGN b-ped-venda.cod-sit-aval = 3.


        END.
    END.
END.
/****************************************
**  Final
*****************************************/

/*********************************************************************************
**  Prop¢sito:  Validar os pedidos com os limites do SupplierCard
**  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
**  Criaá∆o:    Setembro de 2011
**********************************************************************************/
/****************************************
**  Validaá∆o do SupplierCard - In°cio
*****************************************/
/* Verificar se na Condiá∆o de Pagamento (CD0404) est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
FIND FIRST int-cond-pagto NO-LOCK
    WHERE  int-cond-pagto.cod-cond-pag = b-ped-venda.cod-cond-pag NO-ERROR.
IF  AVAILABLE int-cond-pagto                       AND
    SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
    ASSIGN b-ped-venda.dsp-pre-fat  = YES.
           /**b-ped-venda.cod-sit-aval = 3*/

    IF  PROGRAM-NAME(1) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(2) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(3) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(4) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(5) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(6) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(7) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(8) MATCHES '*ESACR003*'
    OR  PROGRAM-NAME(9) MATCHES '*ESACR003*'
    THEN DO:
    END.
    ELSE
         ASSIGN b-ped-venda.cod-sit-aval = 3.

END.

/****************************************
**  Validaá∆o do SupplierCard - Final
*****************************************/


IF  b-ped-venda.cod-des-mer  <> b-old-ped-venda.cod-des-mer THEN DO:
    ASSIGN b-ped-venda.completo = NO.
END.

if  b-ped-venda.tp-pedido    <> b-old-ped-venda.tp-pedido
OR  b-ped-venda.no-ab-reppri <> b-old-ped-venda.no-ab-reppri THEN DO: 

    FIND FIRST ponto-programa                               /* Pedidos  (pedidos pos venda e astec) que contem estes atendentes cadastrados no ponto 1 entao nao envia para barramento */
        WHERE ponto-programa.nome-programa = "espdp005":U
          AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    IF AVAILABLE ponto-programa THEN DO:
        IF  NOT CAN-FIND(FIRST conteudo-programa
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND ENTRY(4, conteudo-programa.conteudo, ",":U)      = TRIM(b-ped-venda.tp-pedido)) THEN DO:
            ASSIGN b-ped-venda.completo = NO.
            
        END.

    END.
    ELSE
        ASSIGN b-ped-venda.completo = NO.
    

END.

IF b-ped-venda.cod-priori <> b-old-ped-venda.cod-priori AND
    b-old-ped-venda.cod-priori = 44 THEN DO: /* Qdo mudar a prioridade de oráamento para outra devera ser recalculado o pedido para ver se tem item abaixo do minimo */

    ASSIGN b-ped-venda.completo = NO.

END.
IF b-ped-venda.cod-priori <> b-old-ped-venda.cod-priori AND
   b-ped-venda.cod-priori = 10  THEN DO:
    ASSIGN l-atraso-pagto = NO.

    FIND FIRST int-ped-venda
        WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido NO-LOCK NO-ERROR.

    IF AVAILABLE int-ped-venda             AND
       NOT int-ped-venda.liberacao-forcada THEN DO: /* Quando estiver com o flag "Liberaá∆o Foráada" marcado, n∆o realizar nenhuma validaá∆o de t°tulos ou SupplierCard */
        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao NO-LOCK NO-ERROR.

        /* S¢ valida os dias de atraso para os pedidos que geram duplicatas (n∆o s∆o de garantia, p¢s-venda, etc) */
        IF AVAILABLE natur-oper    AND
           natur-oper.emite-duplic THEN DO:
            FIND LAST int-param-supcard NO-LOCK NO-ERROR.

            IF AVAILABLE int-param-supcard THEN DO:
                RUN esp/acr/esacr043.p (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                        INPUT  emitente.nome-matriz,
                                        INPUT  int-param-supcard.qtd-dias-atraso,
                                        OUTPUT i-dias-atraso-tit,
                                        OUTPUT l-tit-atrasado,
                                        OUTPUT c-lista-clientes).

                IF l-tit-atrasado THEN DO:
                    IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                        FIND FIRST int-ped-venda
                            WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "O cliente possui t°tulos em atraso com a Intelbras".

                        RELEASE int-ped-venda.
                    END.
                    ELSE DO:
                        IF  OPSYS <> "UNIX":U THEN
                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                               INPUT 17006,
                                               INPUT "O cliente possui t°tulos em atraso com a Intelbras":U +
                                                     "~~":U +
                                                     "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + 
                                                     " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + 
                                                     " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).
                    END.
    
                    ASSIGN l-atraso-pagto           = YES
                           b-ped-venda.desc-bloq-cr = CAPS("O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.")
                           b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                           b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                END. /* IF l-tit-atrasado THEN DO: */
            END. /* IF AVAILABLE int-param-supcard THEN DO: */

            /*********************************************************************************
            **  Prop¢sito:  Validar os pedidos com os limites do SupplierCard
            **  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
            **  Criaá∆o:    Setembro de 2011
            **********************************************************************************/
            /****************************************
            **  Validaá∆o do SupplierCard - In°cio
            *****************************************/

            /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
            IF NOT l-atraso-pagto THEN DO:
                FIND FIRST int-emitente-supcard
                    WHERE int-emitente-supcard.raiz-cnpj      = SUBSTRING(emitente.cgc, 1, 8) /* Busca somente pela raiz do CNPJ (8 primeiros d°gitos) */
                      AND int-emitente-supcard.dat-avaliacao  = TODAY /* Sempre verificar o de hoje */
                      AND int-emitente-supcard.log-habilitado = YES NO-LOCK NO-ERROR.

                IF AVAILABLE int-emitente-supcard THEN DO:
                    /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - In°cio */
                    IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO:
                        IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                            IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                    FIND FIRST int-ped-venda
                                        WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                    ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "O cliente est† em atraso com o cart∆o Intelbras Clube".
                                    RELEASE int-ped-venda.
                                END.
                                ELSE DO:
                                    IF  OPSYS <> "UNIX":U THEN
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U +
                                                                 "~~":U +
                                                                 "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U).
                                END.
                                ASSIGN l-atraso-pagto           = YES
                                       b-ped-venda.desc-bloq-cr = CAPS("O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.")
                                       b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                       b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                            END. /* IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                        END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                        ELSE DO:
                            FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                            IF AVAILABLE int-param-supcard THEN DO:
                                IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                    IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                                    OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                        FIND FIRST int-ped-venda
                                            WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                        ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + " O cliente est† em atraso com o cart∆o Intelbras Clube".
                                        RELEASE int-ped-venda.
                                    END.
                                    ELSE DO:
                                        IF  OPSYS <> "UNIX":U THEN
                                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                               INPUT 17006,
                                                               INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U +
                                                                     "~~":U +
                                                                     "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U).
                                    END.
                                    ASSIGN l-atraso-pagto           = YES
                                           b-ped-venda.desc-bloq-cr = CAPS("O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.")
                                           b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                           b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                                END. /* IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                            END. /* IF AVAILABLE int-param-supcard THEN DO: */
                        END. /* ELSE DO: - IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                              int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                    END. /* IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO: */
                    /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - Final */

                    /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - In°cio */
                    IF NOT l-atraso-pagto THEN DO:
                        IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                            RUN esp/acr/esacr043.p (INPUT  int-emitente-supcard.raiz-cnpj,
                                                    INPUT  emitente.nome-matriz,
                                                    INPUT  int-emitente-supcard.qtd-dias-atraso-int,
                                                    OUTPUT i-dias-atraso-tit,
                                                    OUTPUT l-tit-atrasado,
                                                    OUTPUT c-lista-clientes).

                            IF l-tit-atrasado THEN DO:
                                IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                    FIND FIRST int-ped-venda
                                        WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                    ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + " O cliente possui t°tulos em atraso com a Intelbras".
                                    RELEASE int-ped-venda.
                                END.
                                ELSE DO:
                                    IF  OPSYS <> "UNIX":U THEN
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "O cliente possui t°tulos em atraso com a Intelbras":U +
                                                                 "~~":U +
                                                                 "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + 
                                                                 " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + 
                                                                 " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).
                                END.

                                ASSIGN l-atraso-pagto           = YES
                                       b-ped-venda.desc-bloq-cr = CAPS("O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.")
                                       b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                       b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                            END. /* IF l-tit-atrasado THEN DO: */
                        END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                    END. /* IF NOT l-atraso-pagto THEN DO: */
                    /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - Final */
                END. /* IF AVAILABLE int-emitente-supcard THEN DO: */
            END. /* IF NOT l-atraso-pagto THEN DO: */
            /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - Final */
        END. /* IF AVAILABLE natur-oper    AND
                   natur-oper.emite-duplic THEN DO: */

        /* Validaá∆o de Limites de CrÇdito caso a condiá∆o de pagamento seja "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
        IF NOT l-atraso-pagto THEN DO:
            /* Verificar se na Condiá∆o de Pagamento (CD0404) est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
            FIND FIRST int-cond-pagto
                WHERE int-cond-pagto.cod-cond-pag = b-ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

            IF AVAILABLE int-cond-pagto                       AND
               SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                /* Buscando o limite di†rio (de hoje) do SupplierCard */
                FIND FIRST int-emitente-supcard
                    WHERE int-emitente-supcard.raiz-cnpj      = SUBSTRING(emitente.cgc, 1, 8) /* Busca somente pela raiz do CNPJ (8 primeiros d°gitos) */
                      AND int-emitente-supcard.dat-avaliacao  = TODAY /* Sempre verificar o de hoje */
                      AND int-emitente-supcard.log-habilitado = YES NO-LOCK NO-ERROR.

                IF AVAILABLE int-emitente-supcard THEN DO:
                    /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - In°cio */
                    ASSIGN l-encontrou-cond-pagto = NO.

                    FIND FIRST int-classe-cli-supcard
                        WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-LOCK NO-ERROR.

                    IF NOT AVAILABLE int-classe-cli-supcard THEN DO:
                        IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                        OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                            FIND FIRST int-ped-venda
                                 WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                            ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o cliente ~"":U + TRIM(b-ped-venda.nome-abrev) + "~".".
                            RELEASE int-ped-venda.
                        END.
                        ELSE DO:
                            IF  OPSYS <> "UNIX":U THEN
                                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                   INPUT 17006,
                                                   INPUT "N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o cliente ~"":U + TRIM(b-ped-venda.nome-abrev) + "~".":U +
                                                         "~~":U +
                                                         "A validaá∆o foi realizada para o Cliente ~"":U + TRIM(b-ped-venda.nome-abrev) + "~", Pedido ~"":U + TRIM(b-ped-venda.nr-pedcli) + "~".":U).
                        END.

                        ASSIGN b-ped-venda.desc-bloq-cr = CAPS("N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o cliente ~"":U + TRIM(b-ped-venda.nome-abrev) + "~".":U)
                               b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                               b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                    END. /* IF NOT AVAILABLE int-classe-cli-supcard THEN DO: */
                    ELSE DO:
                        FOR LAST int-classe-cli-supcard NO-LOCK
                            WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe
                            BY int-classe-cli-supcard.dat-alteracao:
                            DO i-count = 1 TO NUM-ENTRIES(int-classe-cli-supcard.cod-cond-pag, ",":U):
                                ASSIGN v-cod-cond-pag = INTEGER(TRIM(ENTRY(i-count, int-classe-cli-supcard.cod-cond-pag, ",":U))) NO-ERROR.

                                IF NOT ERROR-STATUS:ERROR                       AND
                                   v-cod-cond-pag = int-cond-pagto.cod-cond-pag THEN
                                    ASSIGN l-encontrou-cond-pagto = YES.
                            END. /* DO i-count = 1 TO NUM-ENTRIES(int-classe-cli-supcard.cod-cond-pag, ",":U): */
                        END. /* FOR LAST int-classe-cli-supcard NO-LOCK
                                    WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe
                                    BY int-classe-cli-supcard.dat-alteracao: */

                        IF NOT l-encontrou-cond-pagto THEN DO:
                            FIND FIRST int-classe-cli-supcard
                                WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-LOCK NO-ERROR.

                            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                FIND FIRST int-ped-venda
                                     WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "N∆o foi encontrado a Condiá∆o de Pagamento do Pedido na Classe de Cliente Intelbras Clube.".
                                RELEASE int-ped-venda.
                            END.
                            ELSE DO:
                                IF  OPSYS <> "UNIX":U THEN
                                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                       INPUT 17006,
                                                       INPUT "N∆o foi encontrado a Condiá∆o de Pagamento do Pedido na Classe de Cliente Intelbras Clube.":U +
                                                             "~~":U +
                                                             "A Condiá∆o de Pagamento ~"":U + TRIM(STRING(b-ped-venda.cod-cond-pag, ">>>9":U)) + "~" do Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + ", Cliente ":U + TRIM(b-ped-venda.nome-abrev) + ", n∆o est† parametrizada na Classe de Cliente ~"":U + TRIM(int-classe-cli-supcard.des-classe) + "~" do Cart∆o Intelbras Clube.":U).
                            END.

                            ASSIGN b-ped-venda.desc-bloq-cr = CAPS("A Condiá∆o de Pagamento ~"":U + TRIM(STRING(b-ped-venda.cod-cond-pag, ">>>9":U)) + "~" do Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + ", Cliente ":U + TRIM(b-ped-venda.nome-abrev) + ", n∆o est† parametrizada na Classe de Cliente ~"":U + TRIM(int-classe-cli-supcard.des-classe) + "~" do Cart∆o Intelbras Clube.":U)
                                   b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                   b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                        END. /* IF NOT l-encontrou-cond-pagto THEN DO: */
                    END. /* ELSE DO: - IF NOT AVAILABLE int-classe-cli-supcard THEN DO: */
                    /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - Final */

                    /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */
                    IF l-encontrou-cond-pagto THEN DO:
                        ASSIGN l-natur-oper-servico = YES.

                        FIND FIRST natur-oper
                            WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao NO-LOCK NO-ERROR.

                        IF NOT AVAILABLE natur-oper THEN DO:
                            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                FIND FIRST int-ped-venda
                                     WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "A Natureza de Operaá∆o ":U + TRIM(b-ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(b-ped-venda.nome-abrev) + " e Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + " n∆o foi encotrado.".
                                RELEASE int-ped-venda.
                            END.
                            ELSE DO:
                                IF  OPSYS <> "UNIX":U THEN
                                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                       INPUT 2,
                                                       INPUT "Natureza de Operaá∆o":U +
                                                             "~~":U +
                                                             "A Natureza de Operaá∆o ":U + TRIM(b-ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(b-ped-venda.nome-abrev) + " e Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + " n∆o foi encotrado.":U).
                            END.

                            ASSIGN b-ped-venda.desc-bloq-cr = CAPS("A Natureza de Operaá∆o ":U + TRIM(b-ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(b-ped-venda.nome-abrev) + " e Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + " n∆o foi encotrado.":U)
                                   b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                   b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                        END. /* IF NOT AVAILABLE natur-oper THEN DO: */
                        ELSE IF natur-oper.tipo = 3 THEN DO:
                            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                FIND FIRST int-ped-venda
                                     WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + " Natureza de Operaá∆o utilizada Ç de Serviáo".
                                RELEASE int-ped-venda.
                            END.
                            ELSE DO:
                                IF  OPSYS <> "UNIX":U THEN
                                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                       INPUT 17006,
                                                       INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo":U +
                                                             "~~":U +
                                                             "A Natureza de Operaá∆o ":U + TRIM(b-ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(b-ped-venda.nome-abrev) + " e Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagemento do Cart∆o Intelbras Clube.":U).
                            END.

                            ASSIGN b-ped-venda.desc-bloq-cr = CAPS("A Natureza de Operaá∆o ":U + TRIM(b-ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(b-ped-venda.nome-abrev) + " e Pedido ":U + TRIM(b-ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagemento do Cart∆o Intelbras Clube.":U)
                                   b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                   b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                        END. /* ELSE IF natur-oper.tipo = 3 THEN DO: */
                        ELSE
                            ASSIGN l-natur-oper-servico = NO.
                    END. /* IF l-encontrou-cond-pagto THEN DO: */
                    /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - Final */

                    /* Caso n∆o tenha atraso de pagamento n∆o tolerado */
                    IF l-encontrou-cond-pagto   AND
                       NOT l-natur-oper-servico THEN DO:
                        IF NOT VALID-HANDLE(h-esapi001) THEN
                            RUN esp/esapi001.p PERSISTENT SET h-esapi001.

                        RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT SUBSTRING(emitente.cgc, 1, 8),
                                                              OUTPUT de-vl-lim-tot-supcard,
                                                              OUTPUT de-limite-supcard,
                                                              OUTPUT de-ped-aloc-supcard,
                                                              OUTPUT de-lim-nfs-supcard,
                                                              OUTPUT de-lim-disp-supcard).

                        /* Acumulando os valores do itens alocados */
                        ASSIGN de-val-a-alocar = 0.

                        FOR EACH ped-item NO-LOCK
                            WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
                              AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli
                              AND ped-item.cod-sit-item < 3:
                            FIND FIRST natur-oper
                                WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.

                            ASSIGN de-val-a-alocar = de-val-a-alocar + (ped-item.qt-log-aloc * ped-item.vl-preuni).

                            IF AVAILABLE natur-oper THEN DO:
                                IF natur-oper.subs-trib THEN
                                    ASSIGN de-val-a-alocar = de-val-a-alocar + ROUND(((ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * ped-item.qt-log-aloc, 2).
                                IF natur-oper.cd-trib-ipi <> 2 THEN
                                    ASSIGN de-val-a-alocar = de-val-a-alocar + ROUND((ped-item.qt-log-aloc * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100), 2).

                            END. /* IF AVAILABLE natur-oper THEN DO: */
                        END. /* FOR EACH ped-item NO-LOCK
                                    WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
                                      AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli
                                      AND ped-item.cod-sit-item < 3: */

                        /* Verifica se o valor dos itens alocados ultrapassaram o limite do SupplierCard */
                        IF ROUND(de-lim-disp-supcard, 2) < ROUND(de-val-a-alocar, 2) THEN DO:

                            RUN pi_retorna_disponivel_limite_intelbras(OUTPUT de-lim-disp-intelbras).

                            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' 
                            THEN DO:
                                 FIND FIRST int-ped-venda
                                      WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                 /* ** Liberaá∆o autom†tica n∆o solicita confirmaá∆o para reprovar pedido ***/
                                 ASSIGN int-ped-venda.mensagem   = int-ped-venda.mensagem + "O pedido ultrapassou o limite do cart∆o Intelbras Clube"
                                        b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */.
                                 RELEASE int-ped-venda.
                            END.
                            ELSE DO:
                                 IF  OPSYS <> "UNIX":U THEN DO:
                                     RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                        INPUT 27100,
                                                        INPUT "O pedido ultrapassou o limite do cart∆o Intelbras Clube. Deseja Faturar PARCIAL?":U +
                                                              "~~":U +
                                                              "O pedido ":U + b-ped-venda.nr-pedcli + " de R$ ":U + TRIM(STRING(ROUND(de-val-a-alocar, 2), "->>>,>>>,>>9.99":U)) + ", do cliente ":U + b-ped-venda.nome-abrev + ", ultrapassou o limite dispon°vel de R$ ":U + TRIM(STRING(ROUND(de-lim-disp-supcard, 2), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube. Limite de crÇdito dispon°vel Intelbras: " + TRIM(STRING(ROUND(de-lim-disp-intelbras, 2), "->>>,>>>,>>9.99"))).
                                     /* ** Liberaá∆o manual solicita confirmaá∆o para reprovar pedido ***/
                                     IF RETURN-VALUE = "NO"
                                        THEN b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */.
                                 END.
                            END.

                            ASSIGN b-ped-venda.desc-bloq-cr = CAPS(STRING(TODAY, "99/99/99") + " RELE. Valor Alocado: " + TRIM(STRING(ROUND(de-val-a-alocar, 2), "->>>,>>>,>>9.99":U)) + ". Limite IC: " + TRIM(STRING(ROUND(de-lim-disp-supcard, 2), "->>>,>>>,>>9.99":U)) + ". Limite Intelbras: " + TRIM(STRING(ROUND(de-lim-disp-intelbras, 2), "->>>,>>>,>>9.99":U)))
                                   b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */

                        END. /* IF ROUND(de-lim-disp-supcard, 2) < ROUND(de-val-a-alocar, 2) THEN DO: */
                        ELSE DO:
                            FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                            FIND FIRST cond-pagto
                                WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.

                            IF ROUND(de-val-a-alocar, 2) < ROUND(int-param-supcard.val-min-trans, 2) THEN DO:
                                IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                    FIND FIRST int-ped-venda
                                         WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                    ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "Valor da compra no cart∆o Intelbras Clube menor que valor m°nimo permitido de transaá∆o.".
                                    RELEASE int-ped-venda.
                                END.
                                ELSE DO:
                                    IF  OPSYS <> "UNIX":U THEN
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "Valor da compra no cart∆o Intelbras Clube menor que valor m°nimo permitido de transaá∆o.":U +
                                                                 "~~":U +
                                                                 "O pedido ":U + b-ped-venda.nr-pedcli + ", do cliente ":U + b-ped-venda.nome-abrev + ", est† com o valor da compra de R$ ":U + TRIM(STRING(ROUND(de-val-a-alocar, 2), "->>>,>>>,>>9.99":U)) + " , porÇm o valor m°nimo permitido da transaá∆o Ç de R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-trans, 2), "->>>,>>>,>>9.99":U)) + " no cart∆o Intelbras Clube.":U).
                                END.

                                ASSIGN b-ped-venda.desc-bloq-cr = CAPS("O pedido ":U + b-ped-venda.nr-pedcli + ", do cliente ":U + b-ped-venda.nome-abrev + ", est† com o valor da compra de R$ ":U + TRIM(STRING(ROUND(de-val-a-alocar, 2), "->>>,>>>,>>9.99":U)) + " , porÇm o valor m°nimo permitido da transaá∆o Ç de R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-trans, 2), "->>>,>>>,>>9.99":U)) + " no cart∆o Intelbras Clube.")
                                       b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                       b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                            END. /* IF ROUND(de-val-a-alocar, 2) < ROUND(int-param-supcard.val-min-trans, 2) THEN DO: */
                            ELSE IF ROUND((de-val-a-alocar / cond-pagto.num-parcelas), 2) < ROUND(int-param-supcard.val-min-parc, 2) THEN DO:
                                IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                                OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                                    FIND FIRST int-ped-venda
                                         WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                    ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "Valor da parcela do cart∆o Intelbras Clube menor que valor m°nimo permitido.".
                                    RELEASE int-ped-venda.
                                END.
                                ELSE DO:
                                    IF  OPSYS <> "UNIX":U THEN
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "Valor da parcela do cart∆o Intelbras Clube menor que valor m°nimo permitido.":U +
                                                                 "~~":U +
                                                                 "O pedido ":U + b-ped-venda.nr-pedcli + ", do cliente ":U + b-ped-venda.nome-abrev + ", est† com o valor da parcela de R$ ":U + TRIM(STRING(ROUND((de-val-a-alocar / cond-pagto.num-parcelas), 2), "->>>,>>>,>>9.99":U)) + " , porÇm o valor m°nimo permitido Ç de R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-parc, 2), "->>>,>>>,>>9.99":U)) + " no cart∆o Intelbras Clube.":U).
                                END.

                                ASSIGN b-ped-venda.desc-bloq-cr = CAPS("O pedido ":U + b-ped-venda.nr-pedcli + ", do cliente ":U + b-ped-venda.nome-abrev + ", est† com o valor da parcela de R$ ":U + TRIM(STRING(ROUND((de-val-a-alocar / cond-pagto.num-parcelas), 2), "->>>,>>>,>>9.99":U)) + " , porÇm o valor m°nimo permitido Ç de R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-parc, 2), "->>>,>>>,>>9.99":U)) + " no cart∆o Intelbras Clube.")
                                       b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                                       b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                            END. /* ELSE IF ROUND((de-val-a-alocar / cond-pagto.num-parcelas), 2) < ROUND(int-param-supcard.val-min-parc, 2) THEN DO: */
                            ELSE DO:
                                /* Consumindo o limite do SupplierCard de acordo com a alocaá∆o dos itens do pedido */
                                ASSIGN b-ped-venda.dsp-pre-fat  = YES.

                                /* Guardando o consumo, item a item do pedido (alocados) */
                                FOR EACH ped-item NO-LOCK
                                    WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
                                      AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli
                                      AND ped-item.cod-sit-item < 3:

                                    ASSIGN de-val-a-alocar = 0.

                                    ASSIGN de-val-a-alocar = ped-item.qt-log-aloc * ped-item.vl-preuni.

                                    FIND FIRST natur-oper
                                        WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.

                                    IF AVAILABLE natur-oper THEN DO:
                                        IF natur-oper.subs-trib THEN
                                            ASSIGN de-val-a-alocar = de-val-a-alocar + ROUND(((ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * ped-item.qt-log-aloc, 2).
                                        IF natur-oper.cd-trib-ipi <> 2 THEN
                                            ASSIGN de-val-a-alocar = de-val-a-alocar + ROUND((ped-item.qt-log-aloc * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100), 2).
                                    END. /* IF AVAILABLE natur-oper THEN DO: */

                                    RUN pi-aloca-saldo-pedido IN h-esapi001 (INPUT b-ped-venda.nome-abrev,
                                                                             INPUT b-ped-venda.nr-pedcli,
                                                                             INPUT ped-item.it-codigo,
                                                                             INPUT ROUND(de-val-a-alocar, 2)).
                                END. /* FOR EACH ped-item NO-LOCK
                                            WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
                                              AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli
                                              AND ped-item.cod-sit-item < 3: */
                            END. /* ELSE DO: - ELSE IF ROUND((de-val-a-alocar / cond-pagto.num-parcelas), 2) < ROUND(int-param-supcard.val-min-parc, 2) THEN DO: */
                        END. /* ELSE DO: - IF ROUND(de-lim-disp-supcard, 2) < ROUND(de-val-a-alocar, 2) THEN DO: */
                    END. /* IF l-encontrou-cond-pagto   AND
                               NOT l-natur-oper-servico THEN DO: */
                END. /* IF AVAILABLE int-emitente-supcard THEN DO: */
                ELSE DO:
                    IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
                    OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                        FIND FIRST int-ped-venda
                             WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "Limite do cart∆o Intelbras Clube indispon°vel".
                        RELEASE int-ped-venda.
                    END.
                    ELSE DO:
                        IF  OPSYS <> "UNIX":U THEN
                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                               INPUT 17006,
                                               INPUT "Limite do cart∆o Intelbras Clube indispon°vel":U +
                                                     "~~":U +
                                                     "Limite do cart∆o Intelbras Clube est† indispon°vel na data atual. Favor aguardar que esta informaá∆o entre no sistema ou entre em contato com a TIC.":U).
                    END.

                    ASSIGN b-ped-venda.desc-bloq-cr = CAPS("Limite do cart∆o Intelbras Clube est† indispon°vel na data atual. Favor aguardar que esta informaá∆o entre no sistema ou entre em contato com a TIC.")
                           b-ped-venda.cod-sit-aval = 4 /* N∆o Aprovado */
                           b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                END. /* ELSE DO: - IF AVAILABLE int-emitente-supcard THEN DO: */
            END. /* IF AVAILABLE int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */
        END. /* IF NOT l-atraso-pagto THEN DO: */
        /* Validaá∆o de Limites de CrÇdito caso a condiá∆o de pagamento seja "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
        /****************************************
        **  Validaá∆o do SupplierCard - Final
        ****************************************/
    END. /* IF AVAILABLE int-ped-venda             AND
               NOT int-ped-venda.liberacao-forcada THEN DO: */

    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE int-ped-venda.

    ASSIGN da-data-atual =  DATETIME(TODAY, MTIME). 

    for first ponto-programa
        where ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto         = 6
              NO-LOCK,  
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia = 1:

        ASSIGN da-data =  DATETIME(conteudo-programa.conteudo). 

        IF da-data-atual > da-data  THEN DO:
            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                        FIND FIRST int-ped-venda
                             WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "Sistema Bloqueado para Faturamento, n∆o Ç permitido alterar a prioridade, PRIORIDADE RETORNADA PARA ORIGINAL. Data de Bloqueio = " + string(da-data) + " Horas ".
                        RELEASE int-ped-venda.
            END.
            ELSE DO:
                IF  OPSYS <> "UNIX":U THEN
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "Sistema Bloqueado para Faturamento, n∆o Ç permitido alterar a prioridade, PRIORIDADE RETORNADA PARA ORIGINAL. Data de Bloqueio = " + string(da-data) + " Horas ").
            END.

            ASSIGN b-ped-venda.desc-bloq-cr = CAPS("Sistema Bloqueado para Faturamento, n∆o Ç permitido alterar a prioridade, PRIORIDADE RETORNADA PARA ORIGINAL. Data de Bloqueio = ":U + STRING(da-data) + " Horas ":U)
                   b-ped-venda.cod-priori   = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
        END.
    END.    
END.

IF b-ped-venda.cod-priori <> b-old-ped-venda.cod-priori AND
   b-ped-venda.cod-priori <> 10  THEN DO:

    /*********************************************************************************
    **  Prop¢sito:  Validar os pedidos com os limites do SupplierCard
    **  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
    **  Criaá∆o:    Setembro de 2011
    **********************************************************************************/
    /****************************************
    **  Validaá∆o do SupplierCard - In°cio
    *****************************************/
    /* Verificar se na Condiá∆o de Pagamento (CD0404) est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
    FIND FIRST int-cond-pagto
        WHERE int-cond-pagto.cod-cond-pag = b-ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

    IF AVAILABLE int-cond-pagto                       AND
       SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:

        IF NOT VALID-HANDLE(h-esapi001)      AND
           SEARCH("esp/esapi001.p":U) = "":U AND
           SEARCH("esp/esapi001.r":U) = "":U THEN DO:
            IF PROGRAM-NAME(1) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(2) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(3) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(4) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(5) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(6) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(7) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(8) MATCHES '*ESPDP006rp*'
            OR PROGRAM-NAME(9) MATCHES '*ESPDP006rp*' THEN DO:
                  FIND FIRST int-ped-venda
                             WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                  ASSIGN int-ped-venda.mensagem = int-ped-venda.mensagem + "Programa n∆o encontrado.~~O programa 'esp/esapi001.p' ou 'esp/esapi001.r' n∆o foi encontrado. O mesmo Ç utilizado para realizar as validaá‰es do cart∆o Intelbras Clube.":U + CHR(10) + "Entre em contato com a †rea de inform†tica para identificar este problema.".
                  RELEASE int-ped-venda.
            END.
            ELSE DO:
                IF  OPSYS <> "UNIX":U THEN
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Programa n∆o encontrado.~~O programa 'esp/esapi001.p' ou 'esp/esapi001.r' n∆o foi encontrado. O mesmo Ç utilizado para realizar as validaá‰es do cart∆o Intelbras Clube.":U + CHR(10) + "Entre em contato com a †rea de inform†tica para identificar este problema.":U).
            END.

            ASSIGN b-ped-venda.cod-priori = b-old-ped-venda.cod-priori. /* Volta o c¢digo da prioridade */
                   
        END.

        IF NOT VALID-HANDLE(h-esapi001) THEN
            RUN esp/esapi001.p PERSISTENT SET h-esapi001.

        FOR EACH ped-item NO-LOCK
            WHERE ped-item.nome-abrev   = b-ped-venda.nome-abrev
              AND ped-item.nr-pedcli    = b-ped-venda.nr-pedcli
              AND ped-item.cod-sit-item < 3:
            
            RUN pi-saldo-ped-item IN h-esapi001 (INPUT  b-ped-venda.nome-abrev,
                                                 INPUT  b-ped-venda.nr-pedcli,
                                                 INPUT  ped-item.it-codigo,
                                                 OUTPUT de-ped-aloc-supcard).

            RUN pi-desaloca-saldo-pedido IN h-esapi001 (INPUT b-ped-venda.nome-abrev,
                                                        INPUT b-ped-venda.nr-pedcli,
                                                        INPUT ped-item.it-codigo,
                                                        INPUT de-ped-aloc-supcard).
        END.
    END. /* IF AVAILABLE int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */
    /****************************************
    **  Validaá∆o do SupplierCard - Final
    ****************************************/
END.

IF   b-ped-venda.cod-sit-aval <> b-old-ped-venda.cod-sit-aval
AND (b-ped-venda.cod-sit-aval = 3 OR b-ped-venda.cod-sit-aval = 4) THEN DO:

    ASSIGN i-sequencia = 1.
    FIND LAST historico-credito 
         WHERE historico-credito.nome-abrev = b-ped-venda.nome-abrev
           AND historico-credito.nr-pedcli  = b-ped-venda.nr-pedcli
        NO-LOCK NO-ERROR.
    IF AVAIL historico-credito THEN
       ASSIGN i-sequencia     = historico-credito.nr-sequencia + 1. 

    CREATE historico-credito.
    ASSIGN historico-credito.nome-abrev    = b-ped-venda.nome-abrev
           historico-credito.nr-pedcli     = b-ped-venda.nr-pedcli            
           historico-credito.nr-sequencia  = i-sequencia            
           historico-credito.dt-data-movto = b-ped-venda.dt-apr-cred   
           historico-credito.usuar-movto   = b-ped-venda.quem-aprovou.

    IF b-ped-venda.cod-sit-aval = 3 THEN
       ASSIGN historico-credito.motivo        = b-ped-venda.desc-forc-cr + ' | Usuario: ' + c-seg-usuario + ' | Programas: ' + PROGRAM-NAME(1) + ' / ' + program-name(2) + ' / ' + program-name(3) + ' / ' + program-name(4)
              historico-credito.tipo-movto    = "Aprov".
    ELSE
        IF b-ped-venda.cod-sit-aval = 4 THEN
           ASSIGN historico-credito.motivo        = b-ped-venda.desc-bloq-cr + ' | Usuario: ' + c-seg-usuario + ' | Programas: ' + PROGRAM-NAME(1) + ' / ' + program-name(2) + ' / ' + program-name(3) + ' / ' + program-name(4)
                  historico-credito.tipo-movto    = "Bloq".

    RELEASE historico-credito.
END.

IF b-ped-venda.cod-mensagem = 0 THEN DO:
    FIND natur-oper
         WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao
         NO-LOCK NO-ERROR.
    IF AVAIL natur-oper and
       natur-oper.cod-mensagem <> 0 THEN DO:
        ASSIGN b-ped-venda.cod-mensagem = natur-oper.cod-mensagem.
    END.
END.

FIND int-ped-venda
     WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido
     EXCLUSIVE-LOCK NO-ERROR.

IF  AVAIL int-ped-venda and
    int-ped-venda.PedidoCodigo <> 0 AND
    (b-old-ped-venda.cod-sit-ped <> b-ped-venda.cod-sit-ped or
     b-old-ped-venda.cod-sit-aval <> b-ped-venda.cod-sit-aval) THEN DO:
    ASSIGN int-ped-venda.atualizaIkeda = YES.

    ASSIGN int-ped-venda.atualizacrm = YES.

    IF SUBSTRING(int-ped-venda.char-1,100,100) = ""  THEN DO:
        IF PROGRAM-NAME(1) MATCHES '*PD4000*'
        OR PROGRAM-NAME(2) MATCHES '*PD4000*'
        OR PROGRAM-NAME(3) MATCHES '*PD4000*'
        OR PROGRAM-NAME(4) MATCHES '*PD4000*'
        OR PROGRAM-NAME(5) MATCHES '*PD4000*'
        OR PROGRAM-NAME(6) MATCHES '*PD4000*'
        OR PROGRAM-NAME(7) MATCHES '*PD4000*'
        OR PROGRAM-NAME(8) MATCHES '*PD4000*'
        OR PROGRAM-NAME(9) MATCHES '*PD4000*' THEN 
            ASSIGN OVERLAY(int-ped-venda.char-1,100,100) = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ''
                   OVERLAY(int-ped-venda.char-1,201,10)  = '993520002'.
    END. /* IF SUBSTRING(int-ped-venda.char-1,100,100) = ""  THEN DO: */

END.

IF PROGRAM-NAME(1) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(2) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(3) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(4) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(5) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(6) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(7) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(8) MATCHES '*ESPDP049*'
OR PROGRAM-NAME(9) MATCHES '*ESPDP049*' THEN DO:
    find cond-pagto no-lock 
         where cond-pagto.cod-cond-pag = b-ped-venda.cod-cond-pag no-error.
    IF AVAIL cond-pagto THEN
        ASSIGN int-ped-venda.FormaPgto           = cond-pagto.descricao.
    ASSIGN int-ped-venda.PedidoCodigo        = INT(substring(b-PED-VENDA.NR-PEDCLI,1,8))
           int-ped-venda.ValorParcela        = b-ped-venda.vl-tot-ped.
END.

RELEASE int-ped-venda.

/* Projeto Modernizaá∆o Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos */
IF  NEW b-ped-venda OR
        b-ped-venda.cod-sit-aval <> b-old-ped-venda.cod-sit-aval
THEN DO:
    FIND int-evento-monitorado NO-LOCK
        WHERE int-evento-monitorado.cod-evento = 1 /* An†lise crÇdito pedido venda */
          AND int-evento-monitorado.log-ativo  = YES NO-ERROR.

    IF AVAIL int-evento-monitorado THEN DO:
       RUN pi-cria-historico-evento.
    END.
END.


IF NOT NEW b-ped-venda
THEN DO:
    IF  b-ped-venda.cod-sit-ped = 6 AND /* Cancelamento */
        b-ped-venda.cod-sit-ped <> b-old-ped-venda.cod-sit-ped
    THEN DO:
        FIND int-evento-monitorado NO-LOCK
            WHERE int-evento-monitorado.cod-evento = 4 /* Cancelamento do pedido */
              AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
        IF AVAIL int-evento-monitorado THEN DO:
            RUN pi-cria-historico-evento.
        END.

        /* Enviar mensagem de cancelamento para Vtex, mas apenas quando for alteraá∆o via ERP */
        IF PROGRAM-NAME(1) MATCHES '*wso0003*' OR PROGRAM-NAME(2) MATCHES '*wso0003*' OR PROGRAM-NAME(3) MATCHES '*wso0003*'
        OR PROGRAM-NAME(4) MATCHES '*wso0003*' OR PROGRAM-NAME(5) MATCHES '*wso0003*' OR PROGRAM-NAME(6) MATCHES '*wso0003*'
        OR PROGRAM-NAME(7) MATCHES '*wso0003*' OR PROGRAM-NAME(8) MATCHES '*wso0003*' OR PROGRAM-NAME(9) MATCHES '*wso0003*' THEN DO:
        END.
        ELSE DO:
                        
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido   = b-ped-venda.nr-pedido
                   AND int-ped-venda.cod-estabel = b-ped-venda.cod-estabel NO-ERROR.
            IF AVAIL int-ped-venda AND int-ped-venda.LojaCodigo > 0 THEN DO:
                FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido   = b-ped-venda.nr-pedido
                      AND int-ped-venda.cod-estabel = b-ped-venda.cod-estabel  NO-ERROR.

                FIND FIRST int-ped-venda2 NO-LOCK
                     WHERE int-ped-venda2.cod-estabel = b-ped-venda.cod-estabel
                       AND int-ped-venda2.nr-pedido   = b-ped-venda.nr-pedido NO-ERROR.
            
                CREATE ttPedidoAlteracao.
                ASSIGN ttPedidoAlteracao.numeroPedido    = IF AVAIL int-ped-venda2 THEN int-ped-venda2.PedidoeCommerce ELSE b-ped-venda.nr-pedcli + "-01"
                       ttPedidoAlteracao.codigoLoja      = int-ped-venda.LojaCodigo
                       ttPedidoAlteracao.status-ped      = "Cancelado"
                       ttPedidoAlteracao.motivoAlteracao = b-ped-venda.desc-cancela
                       ttPedidoAlteracao.totalDesconto   = 0
                       ttPedidoAlteracao.totalAcrescimo  = 0.
            
                RUN esp/wso/out/wso0004.p (INPUT  "v1/pedido",
                                           INPUT TABLE ttPedidoAlteracao,
                                           INPUT TABLE ttItemPedido).
            END.
        END.
    END. /* b-ped-item.cod-sit-item = 6 AND */
END. /* IF NOT NEW b-ped-venda */

IF VALID-HANDLE(h-esapi001) THEN
    DELETE PROCEDURE h-esapi001.

ASSIGN h-esapi001 = ?.

FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
RELEASE int-ped-venda.

DEFINE VARIABLE h-acomp           AS HANDLE NO-UNDO.

/* INICIO JONK */ 
IF b-ped-venda.cod-estabel <> b-old-ped-venda.cod-estabel THEN DO:

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = b-ped-venda.cod-emitente NO-ERROR.
    IF int-emitente.cod-guid <> ""
    AND int-emitente.ind-participa-canais = 993520001 THEN DO:

        IF NOT VALID-HANDLE(h-acomp) THEN
            RUN utp/ut-acomp.p PERSISTEN SET h-acomp.

        RUN pi-inicializar IN h-acomp (INPUT "C†lculo Preáos.").
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando preáos.").

        FOR EACH ped-item OF b-ped-venda NO-LOCK
           WHERE ped-item.cod-sit-item <= 2:

            FIND FIRST item-uni-estab
                 WHERE item-uni-estab.cod-estabel = b-ped-venda.cod-estabel
                   AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.
            IF NOT AVAIL item-uni-estab THEN NEXT.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

            IF NOT CAN-FIND(FIRST int-calculo-canal-item NO-LOCK
                            WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                              AND int-calculo-canal-item.cod-estabel = b-ped-venda.cod-estabel
                              AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo
                              AND int-calculo-canal-item.data-calculo = TODAY) THEN DO:
                EMPTY TEMP-TABLE tt-itens.
                CREATE tt-itens.
                ASSIGN tt-itens.it-codigo              = ped-item.it-codigo
                       tt-itens.de-quantidade          = ped-item.qt-pedida
                       tt-itens.TipoPortfolio          = 993520005
                       tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                       tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                       tt-itens.CodigoEstabelecimento  = b-ped-venda.cod-estabel.
    
                RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                           INPUT  TABLE tt-itens,
                                           OUTPUT TABLE ProdutoItemR,
                                           OUTPUT TABLE Resultado).

                FIND FIRST ProdutoItemR NO-ERROR.
                FIND FIRST Resultado    NO-ERROR.
                
                IF  AVAIL Resultado
                    AND Resultado.Sucesso THEN DO:
                    FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                         WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                           AND int-calculo-canal-item.cod-estabel = b-ped-venda.cod-estabel
                           AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo NO-ERROR.
                    IF AVAIL int-calculo-canal-item THEN DO:
                        ASSIGN int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                               int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                               int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                               int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                               int-calculo-canal-item.data-calculo           = TODAY.
                    END.
                    ELSE DO:
                        CREATE int-calculo-canal-item.
                        ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                               int-calculo-canal-item.cod-estabel            = b-ped-venda.cod-estabel   
                               int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                               int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                               int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                               int-calculo-canal-item.tipo-portifolio        = 993520005
                               int-calculo-canal-item.bloqueado              = NO
                               int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                               int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                               int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                               int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                               int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                               int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                               int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                               int-calculo-canal-item.data-calculo           = TODAY.
                    END.
                    FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
                    RELEASE int-calculo-canal-item.
                END.
            END.
            FIND FIRST int-calculo-canal-item NO-LOCK
                 WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                   AND int-calculo-canal-item.cod-estabel = b-ped-venda.cod-estabel
                   AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo
                   AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
            IF AVAIL int-calculo-canal-item THEN DO:
                FIND FIRST int-ped-item-rebate
                     WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
                       AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
                       AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                       AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
                       AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer     EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL int-ped-item-rebate THEN DO:
                    ASSIGN int-ped-item-rebate.log-calcrebate         = int-calculo-canal-item.log-calcrebate    
                           int-ped-item-rebate.log-preco-alterado     = int-calculo-canal-item.log-preco-alterado
                           int-ped-item-rebate.log-rebate-antec       = int-calculo-canal-item.log-rebate-antec  
                           int-ped-item-rebate.perc-descto-verde      = int-calculo-canal-item.perc-descto-verde
                           int-ped-item-rebate.perc-descto-top-milhao = int-calculo-canal-item.perc-descto-top-milhao
                           int-ped-item-rebate.perc-rebate-antec      = int-calculo-canal-item.perc-rebate-antec
                           .
                END. /* IF AVAIL int-ped-item-rebate THEN DO: */
                ELSE DO:
                    CREATE int-ped-item-rebate.
                    ASSIGN int-ped-item-rebate.nome-abrev         = ped-item.nome-abrev  
                           int-ped-item-rebate.nr-pedcli          = ped-item.nr-pedcli   
                           int-ped-item-rebate.nr-sequencia       = ped-item.nr-sequencia
                           int-ped-item-rebate.it-codigo          = ped-item.it-codigo   
                           int-ped-item-rebate.cod-refer          = ped-item.cod-refer   
                           int-ped-item-rebate.log-calcrebate     = int-calculo-canal-item.log-calcrebate      
                           int-ped-item-rebate.log-preco-alterado = int-calculo-canal-item.log-preco-alterado  
                           int-ped-item-rebate.log-rebate-antec   = int-calculo-canal-item.log-rebate-antec    
                           int-ped-item-rebate.perc-descto-verde       = int-calculo-canal-item.perc-descto-verde
                           int-ped-item-rebate.perc-descto-top-milhao  = int-calculo-canal-item.perc-descto-top-milhao
                           int-ped-item-rebate.perc-rebate-antec       = int-calculo-canal-item.perc-rebate-antec
                        .
                END. /* IF NOT AVAIL int-ped-item-rebate THEN DO: */
                FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
                RELEASE int-ped-item-rebate.
            END.
        END.
        RUN pi-finalizar IN h-acomp.
        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.
    END.
END.
/* FIM JONK */


IF NOT NEW b-ped-venda
THEN DO:
       
    /* Atualiza Salesforce quando completar o pedido ainda aberto*/
   IF (b-old-ped-venda.completo = NO AND b-ped-venda.completo = YES) AND
      (b-ped-venda.cod-sit-ped = 1) THEN 
      run pi-integra-salesforce.


   /* Atualiza Salesforce quando alterar o stsatus do pedido */
   IF b-old-ped-venda.cod-sit-ped <> b-ped-venda.cod-sit-ped THEN
      run pi-integra-salesforce.

END. 


PROCEDURE pi-cria-historico-evento:

        ASSIGN i-sequencia = 1.
        FIND LAST int-historico-evento NO-LOCK NO-ERROR.
        IF  AVAIL int-historico-evento
        THEN
            ASSIGN i-sequencia = int-historico-evento.num-seq-historico + 1.
        RELEASE int-historico-evento.

        FIND FIRST int-historico-evento NO-LOCK
             WHERE int-historico-evento.num-seq-historico  = i-sequencia NO-ERROR.
        IF NOT AVAIL int-historico-evento THEN DO:
           CREATE int-historico-evento.
           ASSIGN int-historico-evento.num-seq-historico  = i-sequencia
                  int-historico-evento.cod-emitente       = b-ped-venda.cod-emitente
                  int-historico-evento.nr-pedcli          = b-ped-venda.nr-pedcli
                  int-historico-evento.cod-estabel        = b-ped-venda.cod-estabel
                  int-historico-evento.cod-sit-aval       = b-ped-venda.cod-sit-aval
                  int-historico-evento.cod-sit-ped        = b-ped-venda.cod-sit-ped
                  int-historico-evento.cod-motivo-cancela = b-ped-venda.cod-mot-canc-cot
                  int-historico-evento.cod-evento         = int-evento-monitorado.cod-evento
                  int-historico-evento.cod-usuario        = c-seg-usuario
                  int-historico-evento.dat-historico      = NOW.
        END.
        FIND CURRENT int-historico-evento NO-LOCK NO-ERROR.
        RELEASE int-historico-evento.        

END PROCEDURE.

    
  /*C¢digo abaixo implementado par aenviar e-mail quando a transportadora
      padr∆o EMS do pedido for alterado para outra transportadora, mas somente
      de transportadora padr∆o para outra, de outra transportadora fora do padr∆o
      para outra transportadora fora do padr∆o n∆o envia.*/
    DEF VAR c-mail-transp AS CHAR NO-UNDO.

    IF  b-ped-venda.nome-transp <> b-old-ped-venda.nome-transp OR 
        (NEW b-ped-venda AND 
         b-ped-venda.nome-transp <> b-old-ped-venda.nome-transp) THEN DO:
      
        /***
        Chamado 13282
        As exceá‰es do envio de e-mail ser∆o as transportadoras PAC (264), SEDEX (254 e 34), RETIRA (0, 440 e 123) e FEDEX (7122)
        ***/
        FIND FIRST transporte WHERE transporte.nome-abrev = b-ped-venda.nome-transp NO-LOCK NO-ERROR.
        IF AVAIL transporte THEN DO:

            CASE transporte.cod-transp:
                WHEN 264  THEN NEXT.
                WHEN 254  THEN NEXT.
                WHEN  34  THEN NEXT.
                WHEN   0  THEN NEXT.
                WHEN 440  THEN NEXT.
                WHEN 123  THEN NEXT.
                WHEN 7122 THEN NEXT.
            END CASE.

        END. /* IF AVAIL transporte THEN DO: */

        FIND FIRST loc-entr 
             WHERE loc-entr.nome-abrev  = b-ped-venda.nome-abrev  
               AND loc-entr.cod-entrega = b-ped-venda.cod-entrega NO-LOCK. 

        FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido NO-LOCK NO-ERROR.
                ASSIGN c-unid-comerc = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 16, 3) ELSE "0":U.
            
        RUN esp/crm/escrm107.p (INPUT b-ped-venda.cod-estabel,
                                INPUT STRING(b-ped-venda.cod-emitente),
                                INPUT loc-entr.cidade,
                                INPUT loc-entr.estado,
                                INPUT c-unid-comerc,
                                INPUT loc-entr.cep,
                                OUTPUT c-cod-transp,
                                OUTPUT c-sigla-transp).
      
        FOR FIRST transporte 
            WHERE transporte.cod-transp = INTEGER(c-cod-transp) NO-LOCK:
            ASSIGN c-nome-transp = transporte.nome-abrev.
        END.
        
        IF  (NEW b-ped-venda AND 
             b-ped-venda.nome-transp <> c-nome-transp) OR 
             b-ped-venda.nome-transp <> c-nome-transp THEN DO:
                 
             IF NEW b-ped-venda AND b-old-ped-venda.nome-transp = "" THEN
                 ASSIGN c-nome-transp-aux = c-nome-transp.
             ELSE 
                 ASSIGN c-nome-transp-aux = b-old-ped-venda.nome-transp.
                
             FOR FIRST ponto-programa NO-LOCK
                 WHERE ponto-programa.nome-programa = "esftp012"
                   AND ponto-programa.ponto         = 4:
             
                FOR EACH conteudo-programa NO-LOCK
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
                     IF  c-mail-transp = "" THEN
                         c-mail-transp = conteudo-programa.conteudo .
                     ELSE
                         c-mail-transp = c-mail-transp + "," + conteudo-programa.conteudo .
                 END.
             END.
             
             ASSIGN cDestino   = /*'paulo.souza@intelbras.com.br'*/ c-mail-transp
                    cDescEmail = "Usu†rio: " + c-seg-usuario + " selecionou transportadora diferente de padr∆o cadastrado, pedido: " + b-ped-venda.nr-pedcli + "." + CHR(13)
                                  + "Transportadora anterior: " + c-nome-transp-aux + CHR(13)
                                  + "Nova transportadora selecionada: " + b-ped-venda.nome-transp
                    cAssunto   = "Transportadora incorreta. Pedido: " + b-ped-venda.nr-pedcli
                    cRemetente = "ems@intelbras.com.br".
                
             RUN piEnviaEmailTransp(INPUT cRemetente,
                                    INPUT cDestino,
                                    INPUT cAssunto,
                                    INPUT cDescEmail,
                                    INPUT "").
        END.
    END.
/*************************************************************************************************************/

/*Procedure que envia e-mail informando alteraá∆o da transportadora padr∆o.*/

PROCEDURE piEnviaEmailTransp :

    DEFINE INPUT  PARAM pRemetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   
        DELETE tt-envio2.   
    END.
    FOR EACH tt-mensagem. 
        DELETE tt-mensagem. 
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                              /* Destinatˇrio       */ 
           tt-envio2.remetente         = pRemetente                            /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                              /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                              /* Arquivo Temporˇrio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail + CHR(13). /* Mensagem */
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.

         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.

    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 


END PROCEDURE.

PROCEDURE pi_retorna_disponivel_limite_intelbras:

    DEF OUTPUT PARAM de-lim-disp-intelbras AS DECIMAL.

    FIND b-emitente-matriz-sc NO-LOCK
         WHERE b-emitente-matriz-sc.nome-abrev = emitente.nome-matriz NO-ERROR.
    
    FOR EACH tt-matriz:
        DELETE tt-matriz.
    END.
    FOR EACH b-emitente-sc NO-LOCK
        WHERE b-emitente-sc.nome-matriz = b-emitente-matriz-sc.nome-abrev:
        CREATE tt-matriz.
        ASSIGN tt-matriz.cod-emitente = b-emitente-sc.cod-emitente
               tt-matriz.nome-abrev   = b-emitente-sc.nome-abrev.
    END.
    
    FOR EACH b-estabelecimento-sc NO-LOCK:
          
        /* T°tulos transferidos para o 102 e 103 */
        IF b-estabelecimento-sc.cod_estab = '201'
        OR b-estabelecimento-sc.cod_estab = '301'
           THEN NEXT.
    
        FOR EACH tt-matriz:
    
            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab           = b-estabelecimento-sc.cod_estab
                  AND tit_acr.cdn_cliente         = tt-matriz.cod-emitente
                  AND tit_acr.val_sdo_tit_acr      > 0
                  AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:
    
                IF tit_acr.ind_tip_espec_docto      = "Normal"
                OR tit_acr.ind_tip_espec_docto BEGINS "Vendor" 
                THEN DO:
    
                     IF  tit_acr.cod_portador <> "9905"
                     AND tit_acr.cod_portador <> "9930"
                     AND tit_acr.cod_portador <> "9915"
                     AND tit_acr.cod_portador <> "9943"
                     AND tit_acr.cod_cart_bcia <> "CSR" 
                     THEN DO: 
    
                          IF tit_acr.cod_espec_docto = "VE" 
                          THEN DO:
                               /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                               FIND FIRST parc_vendor NO-LOCK
                                    WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                      AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
                               IF AVAIL parc_vendor 
                                  THEN ASSIGN d-tot-matriz = d-tot-matriz + parc_vendor.val_parc_vendor_clien.
                          END.
                          IF tit_acr.cod_espec_docto = "VEM" 
                          THEN DO:
                               ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr.
                               FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                                    WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
                               IF AVAIL movto_tit_acr 
                               THEN DO:
                                    FIND FIRST histor_movto_tit_acr NO-LOCK
                                         WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                           AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                           AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                                    IF AVAIL histor_movto_tit_acr 
                                       THEN ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr. 
                               END.
                          END.
                          IF  tit_acr.cod_espec_docto <> "VE" 
                          AND tit_acr.cod_espec_docto <> "VEM" 
                          THEN DO:
                               ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr. 
                         END.
                    END.
                END.   
            END.
            
            /* ** Soma saldo dos pedidos em aberto ***/
            FOR EACH tt-situacao-ped:
                DELETE tt-situacao-ped.
            END.
            CREATE tt-situacao-ped. 
            ASSIGN tt-situacao-ped.situacao = 1. /* Aberto */
            CREATE tt-situacao-ped. 
            ASSIGN tt-situacao-ped.situacao = 2. /* Atendido Parcial */
    
            FOR EACH tt-situacao-ped NO-LOCK,
                EACH b-ped-venda-sc NO-LOCK
                WHERE  b-ped-venda-sc.cod-estabel  = b-estabelecimento-sc.cod_estab
                  AND  b-ped-venda-sc.nome-abrev   = tt-matriz.nome-abrev
                  AND  b-ped-venda-sc.cod-sit-ped  = tt-situacao-ped.situacao
                  AND  b-ped-venda-sc.completo     = YES
                  AND  b-ped-venda-sc.cod-sit-aval = 3 /* Aprovado */
                  AND (b-ped-venda-sc.cod-priori  <> 44) /* Oráamento */:
    
                FIND b-cond-pagto-sc NO-LOCK
                   WHERE b-cond-pagto-sc.cod-cond-pag = b-ped-venda-sc.cod-cond-pag NO-ERROR.
                IF AVAIL b-cond-pagto-sc
                AND b-cond-pagto-sc.cod-cond-pag <> 502
                AND b-cond-pagto-sc.cod-vencto    = 2
                    THEN NEXT.
    
                FIND b-int-cond-pagto-sc OF b-cond-pagto-sc NO-LOCK NO-ERROR.
                IF  AVAIL b-int-cond-pagto-sc
                AND SUBSTRING(b-int-cond-pagto-sc.char-1, 4, 1) = "S":U  
                    THEN NEXT.
    
                ASSIGN d-tot-matriz = d-tot-matriz + b-ped-venda-sc.vl-liq-abe.
    
            END.
            /* ** Fim totalizaá∆o pedidos ***/
        END.
    END.
    
    ASSIGN de-lim-disp-intelbras = b-emitente-matriz-sc.lim-credito - d-tot-matriz.

END.

procedure pi-integra-salesforce:
  empty temp-table tt-ped-venda.
  empty temp-table tt-ped-item.
  create tt-ped-venda.
  buffer-copy b-ped-venda to tt-ped-venda.
  for each ped-item of b-ped-venda no-lock:
    create tt-ped-item.
    buffer-copy ped-item to tt-ped-item.
  end.
  
  run esp/wso/eswso0011.p(input table tt-ped-venda,
                          input table tt-ped-item).
end procedure.


DELETE WIDGET-POOL.

RETURN "ok".


