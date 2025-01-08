/****************************************************************************************
** INTEGRA°€O DE PEDIDOS VIA WSO2 (ORIGEM SALESFORCE)
** 
********************************************************************************************/


{esp/wso/in/wso0010.i}


// definicao dos parametros de entrada 
DEFINE INPUT  PARAM origin                         AS CHARACTER   NO-UNDO.
DEFINE input  param orderId                        AS CHARACTER   FORMAT "x(60)" NO-UNDO.
DEFINE input  param accountExternalId              AS CHARACTER   FORMAT "x(60)" NO-UNDO.
DEFINE INPUT  PARAM finallity                      AS CHARACTER   NO-UNDO.
DEFINE input  param siteCode                       AS CHARACTER   NO-UNDO.
DEFINE input  param paymentCondition               AS INTEGER     NO-UNDO. 
DEFINE input  param partialBillingAllowed          AS LOGICAL     NO-UNDO.
DEFINE input  param accountCurrency                AS INTEGER     NO-UNDO.
DEFINE input  param effectiveDate                  AS CHAR        NO-UNDO.
DEFINE input  param orderComments                  AS CHARACTER   FORMAT "x(200)" NO-UNDO.
DEFINE input  param representativeCode             AS INTEGER     NO-UNDO.
DEFINE input  param attendantCode                  AS CHARACTER   NO-UNDO.
DEFINE input  param supervisorRegistration         AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM shippingCost                   AS DECIMAL     NO-UNDO.
DEFINE input  param priceBook                      AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM poNumber                       as CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM projectRegisterNumber          as CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM fiscalObservation              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM dt-negociacao                  AS DATE        NO-UNDO.
DEFINE INPUT  PARAM dias-negociacao                AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAM dt-faturamento                 AS DATE        NO-UNDO.
DEFINE OUTPUT PARAM c-pedido                       AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM c-status                       AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM c-observacao                   AS CHARACTER  FORMAT 'x(2000)' NO-UNDO.

DEF VAR c-cod-transp    AS INTEGER.
DEF VAR c-sigla-transp  AS CHAR.
DEF VAR c-desc-suspend  AS CHAR.

DEFINE VARIABLE h-bodi154sdf        AS HANDLE    NO-UNDO.          

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


def temp-table tt-item NO-UNDO
    FIELD sequencia                               LIKE ped-item.nr-sequencia
    field it-codigo                               LIKE ped-item.it-codigo
    field preco-unit                              LIKE ped-item.vl-preuni
    field qt-pedida                               LIKE ped-item.qt-pedida
    field item-obs                                as char format "x(2000)"
    field ordem-compra                            as CHAR FORMAT "x(15)"
    field desconto-com                            AS DECIMAL
    FIELD desconto-qtd                            AS DECIMAL.
    
def input-output parameter                        table for tt-item.
DEF OUTPUT parameter table                        FOR tt-erro .



/* ------------------------------------------------------------------ */
/*                     V A R I Æ V E I S  PEDIDO                      */
/* -------------------------------------------------------------------*/
DEFINE VARIABLE c-nat-oper-item             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-natureza             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-consumidor-final     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-erro                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE h-bodi159cal           AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-return               AS LOGICAL      NO-UNDO.
DEFINE VARIABLE de-vl-preco            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-vl-pre-liq          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe           AS DECIMAL      NO-UNDO.
DEFINE VARIABLE d-vl-liq-it            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE i-sequencia            AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-suspender-pedido     AS LOG          NO-UNDO.
DEFINE VARIABLE c-cod-redespacho       AS CHAR         NO-UNDO.   
DEFINE VARIABLE c-estab-entrega        AS CHAR         NO-UNDO. 
DEFINE VARIABLE h-boes505              as handle       NO-UNDO.
DEFINE VARIABLE c-pedido-origem        AS CHAR         NO-UNDO.
define variable iCount                 as integer      no-undo.
DEF VAR i-seq                  AS INT       NO-UNDO.
DEF VAR c-natureza-cliente     AS CHAR      NO-UNDO.
DEF VAR log-contribuinte-icms  AS LOGICAL   NO-UNDO.
DEF VAR c-arquivo-xml AS CHAR NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

DEF BUFFER b-estab  FOR estabelec.
DEF BUFFER b-fornec FOR emitente.
DEF BUFFER b-redespacho FOR transporte.

RUN pi-gerar-dados-extrato (">> INICIO").

{include/i-freeac.i}

// VERIFICA BASE LOGADA 
DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

def var l-producao   AS LOG NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES
           i-seq      = 1.
ELSE
    ASSIGN l-producao = NO
           i-seq      = 2.


// ABERTURA DO LOG 
IF OPSYS = 'UNIX' THEN
   ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_wso0010_NEWPED_'.
ELSE
   ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_wso0010_NEWPED_'.

IF l-producao THEN
   ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
ELSE 
   ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.



// Inicio 

FIND FIRST int-ped-venda
     WHERE int-ped-venda.nr-pedido-externo = orderId NO-LOCK NO-ERROR.
IF AVAIL int-ped-venda THEN  DO:
    RUN pi-erro (0000, 'Pedido ja importado do Salesforce com o codigo externo ' + STRING(orderId) + '. Pedido Totvs - ' + string(int-ped-venda.nr-pedido)).
    RETURN "NOK".
END.

RUN pi-gerar-dados-extrato ("INICIO DO PEDIDO").

IF accountExternalId <> '' THEN
FIND FIRST emitente 
     WHERE emitente.cgc = SUBSTR(accountExternalId,3,15) NO-LOCK NO-ERROR.

RUN pi-gerar-dados-extrato (" CNPJ: " + accountExternalId + ' - ' + SUBSTR(accountExternalId,3,15)).

RUN pi-gerar-dados-extrato ("Cliente: " + STRING( emitente.cod-emitente) + ' - ' + EMITENTE.NOME-ABREV).


if AVAIL emitente AND 
   c-natureza-cliente    <> 'EX'       and 
   log-contribuinte-icms  = NO         and 
  (emitente.ins-estadual  = ""         or 
   emitente.ins-estadual  = "ISENTO"   or
   emitente.ins-estadual  = "ISENTA")  THEN
   ASSIGN l-consumidor-final = YES.

IF finallity BEGINS 'Consumo' 
   AND AVAIL emitente          THEN
   ASSIGN l-consumidor-final = YES.

RUN pi-gerar-dados-extrato ("Consumidor final: " + STRING(l-consumidor-final)).

IF AVAIL emitente THEN DO:

    RUN pi-gerar-dados-extrato ("Emitente v lido " ).

    blk_principal:
       DO TRANSACTION
       ON ERROR UNDO blk_principal,LEAVE blk_principal
       ON STOP  UNDO blk_principal,LEAVE blk_principal:
    
       RUN pi-gerar-dados-extrato ("Antes de ativar a boes505").

       IF NOT VALID-HANDLE(h-boes505) THEN
          run esbo/boes505.p persistent set h-boes505.

       RUN pi-gerar-dados-extrato (">>ANTES DE CRIAR O PEDIDO").
       RUN pi-cria-pedido.
       
       IF  VALID-HANDLE(h-boes505) THEN DO:
           RUN DESTROY IN h-boes505 NO-ERROR.
           IF  VALID-HANDLE(h-boes505) THEN
               DELETE procedure h-boes505.
       END.
       ASSIGN h-boes505 = ?.

       IF  RETURN-VALUE <> "OK" THEN DO:
           UNDO blk_principal, LEAVE blk_principal.
       END.

      FIND FIRST RowErrors NO-LOCK
      where RowErrors.ErrorType   <> 'INTERNAL':U
        and RowErrors.ErrorSubType = 'Error':U NO-ERROR.
      IF AVAIL RowErrors THEN
         UNDO blk_principal, LEAVE blk_principal.
    END.
END.


PROCEDURE pi-cria-pedido. 

    find first param-global no-lock no-error.
    find mgcad.empresa no-lock
       where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
    find FIRST para-fat no-lock no-error.
    find para-ped no-lock no-error.

    RUN pi-gerar-dados-extrato (">>NA API CRIA PEDIDO").

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "Pedidowso2":U, 
                       INPUT 1, 
                       INPUT 0, 
                       INPUT "":U, 
                       OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto
         WHERE tt-prog-ponto.sequencia = i-seq  /* 1 = Producao, 2 = Homologacao */
           AND tt-prog-ponto.conteudo  = origin NO-ERROR.
    IF NOT AVAIL tt-prog-ponto THEN DO:
        RUN pi-erro (1000, 'Origem do pedido nÆo habilitada para integra‡Æo com o ERP').
        RETURN "NOK".
    END.

    // Limpa temp-tables para as BO's 
    EMPTY TEMP-TABLE tt-ped-venda.
    EMPTY TEMP-TABLE tt-ped-item.
    EMPTY TEMP-TABLE tt-ped-ent.
    EMPTY TEMP-TABLE tt-ped-repre.
    EMPTY TEMP-TABLE tt-ped-antecip.
    EMPTY TEMP-TABLE tt-cond-ped.
    EMPTY TEMP-TABLE tt-ped-vendor.

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = siteCode: END.


    FIND FIRST repres NO-LOCK                                        
         WHERE repres.cod-rep =  representativeCode NO-ERROR. 
    IF  NOT AVAIL repres THEN DO:
        RUN pi-erro (1010, 'Representante nÆo cadastrado no ERP ').
        RETURN "NOK".
    END.

    IF attendantCode = '' THEN DO:
       FIND FIRST repres-atend
            WHERE repres-atend.cod-estab = siteCode
              AND repres-atend.cod-rep   = representativeCode NO-LOCK NO-ERROR.

       IF  NOT AVAIL repres-atend THEN DO:
           RUN pi-erro (1020, 'Representante nÆo possui atendente associado no Salesforce, e nÆo possui no programa espdp011 do Totvs. Favor entrar em contato com a ADM de Vendas ').
           RETURN "NOK".
       END.
       ELSE DO:
           ASSIGN attendantCode = string(repres-atend.cd-oper).
       END.
    END.
    
    FIND FIRST cond-pagto
         WHERE cond-pagto.cod-cond-pag = paymentCondition NO-LOCK NO-ERROR.
    IF NOT AVAIL cond-pagto THEN DO:
       RUN pi-erro (1030, 'C¢digo da condi‡Æo de pagamento nÆo cadastrada no Totvs - ' +
                                             string(paymentCondition) + ' - Favor entrar em contato com a ADM de Vendas').
       RETURN "NOK".
    END.
    
    RUN pi-gerar-dados-extrato (">>CRIANDO A TEMP-TABLE TT-PED-VENDA").

    CREATE tt-ped-venda.
    ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
           tt-ped-venda.nome-abrev = emitente.nome-abrev
           tt-ped-venda.nr-pedcli  = string(tt-ped-venda.nr-pedido).

    ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
           tt-ped-venda.dt-emissao              = IF effectiveDate <> '' THEN DATE ( string(substr(effectiveDate,9,2)) + STRING(substr(effectiveDate,6,2)) + string(substr(effectiveDate,1,4))) ELSE TODAY
           tt-ped-venda.no-ab-reppri            = repres.nome-abrev
           tt-ped-venda.dt-implant              = today
           tt-ped-venda.dt-entrega              = TODAY
           tt-ped-venda.dt-entorig              = TODAY
           tt-ped-venda.nome-tr-red             = ""
           tt-ped-venda.cod-emitente            = emitente.cod-emitente
           tt-ped-venda.cod-cond-pag            = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE 0
           tt-ped-venda.nr-tab-fin              = 1
           tt-ped-venda.nr-ind-finan            = 1

           tt-ped-venda.e-mail                  = emitente.e-mail
           tt-ped-venda.cod-sit-aval            = 1
           tt-ped-venda.mo-codigo               = accountCurrency
           tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
           tt-ped-venda.tp-faturam              = 1
           tt-ped-venda.origem                  = 12 /** 12-WEB **/
           tt-ped-venda.atendido                = no
           tt-ped-venda.cd-origem               = 3 /** 1-Usuario, 2-EDI, 3-Sistema **/
           tt-ped-venda.user-impl               = 'integra-wso2'
           tt-ped-venda.dt-userimp              = today
           tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
           tt-ped-venda.observacoes             = orderComments
           tt-ped-venda.cond-espec              = IF poNumber <> "" THEN "OC: " + poNumber ELSE ""
           tt-ped-venda.esp-ped                 = 1
           tt-ped-venda.cod-priori              = 01
           tt-ped-venda.cod-rota                = ''
           tt-ped-venda.ind-ent-completa        = yes
           tt-ped-venda.dsp-pre-fat             = yes
           tt-ped-venda.log-usa-tabela-desconto = no
           tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota when available para-ped
           tt-ped-venda.ind-fat-par             = partialBillingAllowed
           tt-ped-venda.tp-pedido               = attendantCode
           tt-ped-venda.cond-redespa            = projectRegisterNumber
           tt-ped-venda.cond-espec              = tt-ped-venda.cond-espec + fiscalObservation.

       IF dt-faturamento < TODAY  OR 
          dt-faturamento = ? THEN
          ASSIGN tt-ped-venda.dt-entrega = TODAY
                 tt-ped-venda.dt-entorig = TODAY. 
       ELSE                           
         ASSIGN tt-ped-venda.dt-entrega  = dt-faturamento
                tt-ped-venda.dt-entorig  = dt-faturamento.


     /* Atribuir Portador conforme o cadastro do cliente */
    IF  emitente.portador <> 0 THEN
        ASSIGN tt-ped-venda.cod-portador = emitente.portador
               tt-ped-venda.modalidade   = emitente.modalidade.
    ELSE
        ASSIGN tt-ped-venda.cod-portador = 999
               tt-ped-venda.modalidade   = 6.

     RUN pi-busca-transportadora.

    
    // Denife natureza de opera‡Æo     
    RUN DefineNatOperacao IN h-boes505 (INPUT siteCode,
                                        INPUT emitente.cod-emitente,
                                        INPUT loc-entr.cod-entrega,
                                        INPUT '',
                                        INPUT l-consumidor-final,
                                        OUTPUT c-natureza,
                                        OUTPUT l-return).

     IF c-natureza = "" THEN
        ASSIGN c-natureza = emitente.nat-operacao.

     RUN pi-gerar-dados-extrato (">> NATUREZA DO PEDIDO - " + ' ' + C-NATUREZA).

     FIND natur-oper NO-LOCK 
          where natur-oper.nat-operacao = c-natureza NO-ERROR .
     IF NOT AVAILABLE (natur-oper) THEN DO:
        RUN pi-erro (1070, 'Natureza de opera‡Æo ' + c-natureza + ' nÆo encontrada. Favor entrar em contato com a equipe do Tribut rio.').
        RETURN "NOK".
     END.

    ASSIGN c-nat-oper-item              = natur-oper.nat-operacao
           tt-ped-venda.nat-operacao    = natur-oper.nat-operacao
           tt-ped-venda.cod-mensagem    = natur-oper.cod-mensagem
           tt-ped-venda.cod-canal-venda = (if (natur-oper.cod-canal-venda <> 0) then natur-oper.cod-canal-venda else emitente.cod-canal-venda)
           tt-ped-venda.cod-des-merc    = (if (natur-oper.consum-final) then 2 else 1).

    // Cria‡Æo da tabela ped-repre
    CREATE tt-ped-repre.
    ASSIGN tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
           tt-ped-repre.ind-repbase = yes
           tt-ped-repre.perc-comis  = 0  // O % de comissÊo ý calculado por relat«rio 
           tt-ped-repre.nome-ab-rep = repres.nome-abrev.

    // Se tiver data ou dias de negocia‡Æo, o pedido devera ser Suspenso 
    ASSIGN  c-desc-suspend   = "".
    IF dt-negociacao   <> ? THEN
       ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Data Base: " + STRING(dt-negociacao)
              c-desc-suspend           = c-desc-suspend + " - Data Base: " + STRING(dt-negociacao).

    IF  dias-negociacao <> 0 THEN
        ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Dias de Negocia‡Æo: " + STRING(dias-negociacao)
               c-desc-suspend           = c-desc-suspend + " - Dias de Negocia‡Æo: " + STRING(dias-negociacao).
        
    IF  c-desc-suspend <> "" THEN
        ASSIGN tt-ped-venda.cod-priori = 99.

    RUN pi-gerar-dados-extrato (">> CRIACAO DOS ITENS "). 
    // Cria‡Æo da tabela ped-item
    FOR EACH tt-item:

       FIND FIRST ITEM no-lock
             WHERE item.it-codigo = tt-item.it-codigo NO-ERROR.
        IF  NOT AVAIL ITEM THEN DO:
            RUN pi-erro (1080, 'Item nÆo encontrado ' + string(tt-item.it-codigo)).
            RETURN "NOK".
        END.

        // Natureza de operacao do item 
        
        RUN defineNatOperacao IN h-boes505 (INPUT siteCode,
                                            INPUT emitente.cod-emitente,
                                            INPUT loc-entr.cod-entrega,
                                            INPUT tt-item.it-codigo,
                                            INPUT l-Consumidor-final,
                                            OUTPUT c-nat-oper-item,
                                            OUTPUT l-return).

        IF c-nat-oper-item = "" THEN
            ASSIGN c-nat-oper-item = emitente.nat-operacao.

        RUN pi-gerar-dados-extrato (">> NATUREZA DO ITENS - " + TT-ITEM.IT-CODIGO + ' ' + c-nat-oper-item + STRING(TT-ITEM.SEQUENCIA)).


        CREATE tt-ped-item.
        ASSIGN tt-ped-item.nr-sequencia            = tt-item.sequencia
               tt-ped-item.aliquota-ipi            = item.aliquota-ipi
               tt-ped-item.nr-pedcli               = tt-ped-venda.nr-pedcli
               tt-ped-item.cod-entrega             = tt-ped-venda.cod-entrega
               tt-ped-item.dt-entrega              = tt-ped-venda.dt-entrega
               tt-ped-item.nat-operacao            = c-nat-oper-item
               OVERLAY(tt-ped-item.char-2,1,8)     = item.class-fiscal
               tt-ped-item.qt-pedida               = tt-Item.qt-pedida
               tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
               tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
               tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
               tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
               tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
               tt-ped-item.esp-ped                 = 1
               tt-ped-item.it-codigo               = item.it-codigo
               tt-ped-item.nome-abrev              = tt-ped-venda.nome-abrev
               tt-ped-item.per-des-icms            = natur-oper.per-des-icms
               tt-ped-item.tp-adm-lote             = 1
               tt-ped-item.tp-preco                = 0
               tt-ped-item.user-impl               = tt-ped-venda.user-impl
               tt-ped-item.log-usa-tabela-desconto = no
               tt-ped-item.observacao              = ""
               tt-ped-item.per-minfat              = (IF AVAILABLE (emitente) THEN emitente.per-minfat else tt-ped-item.per-minfat)
               tt-ped-item.cd-origem               = 2
               tt-ped-item.tipo-atend              = (IF (tt-ped-venda.ind-fat-par) THEN 2 ELSE 1)
               tt-ped-item.cod-unid-negoc          = ITEM.cod-unid-negoc
               tt-ped-item.des-un-medida           = ITEM.un
               tt-ped-item.des-pct-desconto-inform = STRING(tt-item.desconto-com) + "+" + STRING(tt-item.desconto-qtd)
               tt-ped-item.observacao              = tt-item.item-obs
               tt-ped-item.cod-ord-compra          = tt-item.ordem-compra.


        if  can-find(first iss-cidad-item NO-LOCK
                     where iss-cidad-item.cod-pais   = tt-ped-venda.pais
                     and   iss-cidad-item.cod-estado = tt-ped-venda.estado
                     and   iss-cidad-item.nom-cidade = tt-ped-venda.cidade
                     and   iss-cidad-item.cod-item   = tt-ped-item.it-codigo)  then       
                     
            for first iss-cidad-item 
                where iss-cidad-item.cod-pais   = tt-ped-venda.pais    
                and   iss-cidad-item.cod-estado = tt-ped-venda.estado  
                and   iss-cidad-item.nom-cidade = tt-ped-venda.cidade  
                and   iss-cidad-item.cod-item   = tt-ped-item.it-codigo no-lock:
                assign overlay(tt-ped-item.char-2,56,5) = string(iss-cidad-item.cdn-servico).
        end.
        else do:  
           for first item
               where item.it-codigo = tt-ped-item.it-codigo no-lock:  end.
               assign overlay(tt-ped-item.char-2,56,5) = string(item.cod-servico).
        end.

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
        IF AVAIL item-uni-estab AND item-uni-estab.cod-unid-negoc <> tt-ped-item.cod-unid-negoc THEN
            ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

        RUN pi-gerar-dados-extrato (">> UNIDADE NEGOCIO ITEM: " + tt-ped-item.cod-unid-negoc).

        IF  ITEM.tipo-contr = 4 THEN
            ASSIGN OVERLAY(tt-ped-item.char-2,09,02) = ITEM.un.
        ELSE 
            assign OVERLAY(tt-ped-item.char-2,09,02) = "  ":U.

        // conta aplicacao
        FOR FIRST natur-oper
            WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK USE-INDEX natureza:
        END.
        
          if  ((item.tipo-contr = 4 or (item.aliquota-iss > 0 and item.tipo-contr <> 2)) and
               (item.baixa-estoq and natur-oper.baixa-estoq)) 
              or
              ((item.tipo-contr = 1 or item.tipo-contr = 4) and
               (natur-oper.terceiros or natur-oper.transf)) 
              or
               (item.tipo-contr = 2 or item.tipo-contr = 3) and
                natur-oper.terceiros and
               (not item.baixa-estoq or not natur-oper.baixa-estoq) then do:
        
               if item.ct-codigo = "":U then do:
                  find first para-fat no-lock no-error.
                  IF AVAIL para-fat THEN
                     assign tt-ped-item.ct-codigo = para-fat.ct-cuscon.
               end.   
               else 
                  assign tt-ped-item.ct-codigo = item.ct-codigo.
          end. 
          else 
              assign tt-ped-item.ct-codigo = "".
        // Fim Conta Aplicacao 

        ASSIGN de-vl-preco = tt-Item.preco-unit.

        ASSIGN tt-ped-item.vl-pretab   = de-vl-preco
               tt-ped-item.vl-preori   = de-vl-preco
               tt-ped-item.vl-preuni   = de-vl-preco.

        ASSIGN tt-ped-item.vl-liq-abe  = de-vl-preco
               tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-liq-abe  = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.
               

        RUN pi-gerar-dados-extrato (">> PRECO ITEM: " + STRING(de-vl-preco)).
        RUN pi-gerar-dados-extrato (">> QUANTIDADE: " + STRING(TT-PED-ITEM.QT-PEDIDA)).



        FIND emitente WHERE 
             emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
        FIND natur-oper WHERE
             natur-oper.nat-operacao = c-nat-oper-item NO-LOCK NO-ERROR.

        //Substitui‡Æo Tribut ria
        IF NOT VALID-HANDLE(h-bodi154sdf) 
        OR h-bodi154sdf:TYPE      <> "PROCEDURE":U 
        OR h-bodi154sdf:FILE-NAME <> "dibo/bodi154sdf.p":U THEN
            RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.
    
        IF  AVAIL emitente 
        AND AVAIL natur-oper THEN DO:    

         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(tt-ped-item.NOME-ABREV)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(tt-ped-item.COD-ENTREGA)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(tt-ped-item.IT-CODIGO)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(tt-ped-VENDA.COD-ESTABEL)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(c-nat-oper-item)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(EMITENTE.INSC-SUBS-TRIB)).
         RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(NATUR-OPER.SUBS-TRIB)).

            RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                              INPUT  tt-ped-item.cod-entrega,
                                              INPUT  tt-ped-item.it-codigo,
                                              INPUT  tt-ped-venda.cod-estabel,
                                              INPUT  emitente.insc-subs-trib,
                                              INPUT  natur-oper.subs-trib,
                                              OUTPUT tt-ped-item.ind-icm-ret).   

             RUN pi-gerar-dados-extrato (">> Subst Tributaria: " + STRING(tt-ped-item.ind-icm-ret)).
        END.
        RUN Destroy in h-bodi154sdf.
        ASSIGN h-bodi154sdf = ?.

       

        /* Fim Busca Indicador ICMS Ret */

        ASSIGN i-sequencia              = tt-item.sequencia
               tt-ped-item.nr-sequencia = i-sequencia.

        /* Tratamento IPI */
        IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
            (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
             natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
            ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
        ELSE
            ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

        ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.
    
        ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.


         // Cria‡Æo da tabela ped-ent
         CREATE tt-ped-ent.
         ASSIGN tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
                tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
                tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
                tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
                tt-ped-ent.dt-entrega   = tt-ped-item.dt-entrega
                tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
                tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
                tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
                tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
                tt-ped-ent.user-impl    = tt-ped-item.user-impl
                tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
                tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
                tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.

         /** Acumula valores totais do pedido **/
         ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
                d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.

         RUN pi-gerar-dados-extrato (">> CLASS FISCAL:" + STRING(ITEM.CLASS-FISC)).

         IF  (item.class-fisc = '') OR 
              NOT CAN-FIND (FIRST classif-fisc NO-LOCK
                            WHERE classif-fisc.class-fiscal = item.class-fisc) THEN DO:
              RUN pi-erro (1100, 'Item ' + tt-ped-item.it-codigo + ' sem classifica‡Æo fiscal cadastrada. Favor entrar em contato com a equipe do Tribut rio.').
              RETURN "NOK".
         END.

         // Ajusta data de entrega do item caso o mesmo ja tenha estourado a meta de vendas
         RUN pi-valida-dt-entrega.

    END. /* for each tt-item */


    // totaliza‡Æo do pedido
    assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
           tt-ped-venda.vl-liq-abe = d-vl-liq-abe
           tt-ped-venda.vl-mer-abe = d-vl-liq-it
           tt-ped-venda.vl-liq-ped = d-vl-liq-it.


    RUN pi-gerar-dados-extrato (">> TOTAL DO PEDIDO:" + STRING(TT-PED-VENDA.VL-TOT-PED)).

    FIND FIRST tt-ped-venda NO-ERROR.
        
    RUN pi-gerar-dados-extrato (">> ANTES DE EXECUTAR BOS").

    RUN pi-executar-bos.

    RUN pi-gerar-dados-extrato (">> DEPOIS DE EXECUTAR BOS " + STRING(RETURN-VALUE) + ' ' + STRING(l-erro) ).

    IF  l-erro = YES THEN DO:
        RUN pi-erro (1130, "NÆo foi possivel concluir com sucesso a chamada da pi-executar-bos. ").
        RETURN "NOK".
    END.

    RUN pi-gerar-dados-extrato (">> PEDIDO CRIADO: " + tt-ped-venda.nr-pedcli + orderID).

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

    IF  NOT AVAILABLE (int-ped-venda) THEN DO:
        CREATE int-ped-venda.
        ASSIGN int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido.
    END.
     
    ASSIGN int-ped-venda.nr-pedido-externo      = orderID
           int-ped-venda.cod-estabel            = estabelec.cod-estabel
           int-ped-venda.LojaCodigo             = 0
           int-ped-venda.UsuarioCodigo          = 0
           int-ped-venda.ContaCodigo            = emitente.cod-emitente
           int-ped-venda.ContaCorrenteCodigo    = ""
           int-ped-venda.GrupoCodigo            = 0
           int-ped-venda.CupomCodigo            = 0
           int-ped-venda.ParceiroCodigo         = 0
           int-ped-venda.VitrineCodigo          = 0
           int-ped-venda.ParcelamentoGCodigo    = 0
           int-ped-venda.ParcelamentoPCodigo    = 0
           int-ped-venda.ServicoEntregaCodigo   = 0
           int-ped-venda.Score                  = 0
           int-ped-venda.CestaCodigo            = ""
           int-ped-venda.CestaMensagem          = ""
           int-ped-venda.Sedex                  = ""
           int-ped-venda.SedexData              = ?
           int-ped-venda.MotivoCancel           = ""
           int-ped-venda.Desconto               = 0
           int-ped-venda.FormaPgto              = ""
           int-ped-venda.ValorSubTotal          = 0
           int-ped-venda.ValorParcela           = 0
           int-ped-venda.ValorJuros             = 0
           int-ped-venda.Mensagem               = ""
           int-ped-venda.ValorFrete             = 0
           int-ped-venda.ValorPresente          = 0
           int-ped-venda.PedidoStatus           = ""
           int-ped-venda.StatusIntegracao       = ""
           int-ped-venda.StatusClearSale        = ""
           int-ped-venda.AvisoBoleto            = ""
           int-ped-venda.FreteGratis            = ""
           int-ped-venda.ValorVale              = 0
           int-ped-venda.vl-frete               = shippingCost
           int-ped-venda.pedidocodigo           = tt-ped-venda.nr-pedido
           int-ped-venda.origem                 = origin
           int-ped-venda.nr-tabpre              = priceBook
           OVERLAY(int-ped-venda.char-1,68,8)   = supervisorRegistration
           OVERLAY(int-ped-venda.char-1, 53,12) = poNumber
           overlay(int-ped-venda.char-1,26,15)  = ""       /*ttpedido.CpfCnpjOrigem*/
           OVERLAY(int-ped-venda.char-1,20,5)   = c-sigla-transp
           int-ped-venda.dt-negociacao          = dt-negociacao
           int-ped-venda.dias-negociacao        = dias-negociacao.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

    IF AVAILABLE ped-venda THEN DO:
        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF NOT AVAIL int-ped-venda2 THEN DO:
            CREATE int-ped-venda2.
            ASSIGN int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   int-ped-venda2.cod-estabel = ped-venda.cod-estabel.

            FIND FIRST atendente
                 WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN 
               ASSIGN int-ped-venda2.int-1 = atendente.cod-gr-canais.
            ELSE DO:
               FIND FIRST emitente
                    WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
               IF  AVAIL emitente THEN DO:
                   FIND FIRST grupo-canais-clientes
                        WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                   IF AVAIL grupo-canais-clientes THEN 
                       ASSIGN int-ped-venda2.int-1 = grupo-canais-clientes.cod-gr-canais.
               END.
            END.
        END.
        ASSIGN c-pedido = ped-venda.nr-pedcli
               c-observacao = ped-venda.observ.

        /**** verifica declara‡Æo de zona franca de manaus ***/
        IF ped-venda.cod-estabel = '105' THEN DO:
           FIND FIRST emitente
                WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
           FIND FIRST int-emitente-trib NO-LOCK
                WHERE int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
           IF  AVAIL int-emitente-trib AND
               int-emitente-trib.ind-tipo-declaracao = 2 THEN DO:
               IF TODAY > int-emitente-trib.dt-copia-declaracao + 30 THEN DO:
                  ASSIGN ped-venda.observ = ped-venda.observ + 
                                            "Declaracao ZFM original nÆo entregue, ou com declaracao vencida!".
               END.
           END.
        END.

    END.


    IF ped-venda.observ <> '' THEN
       RUN UpdateSuspension.


    if not ped-venda.completo then
      RUN pi-completa-pedido.

    IF AVAIL ped-venda THEN
       ASSIGN c-status = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.

    RUN pi-gerar-dados-extrato (">> Status DO PEDIDO:" + c-status).


END.


PROCEDURE pi-executar-bos:
   
   DEFINE VARIABLE h-bodi159     AS HANDLE NO-UNDO.
   DEFINE VARIABLE h-bodi154     AS HANDLE NO-UNDO.
   DEFINE VARIABLE h-bodi157     AS HANDLE NO-UNDO.
   
   RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

   RUN openQueryStatic IN h-bodi159(INPUT 'Main':U).
   RUN setRecord       IN h-bodi159(INPUT TABLE tt-ped-venda).
   RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
   RUN emptyRowErrors  IN h-bodi159.
   RUN createMPLog     IN h-bodi159(INPUT no).
   RUN createRecord    IN h-bodi159.
   RUN getRowErrors    IN h-bodi159(OUTPUT TABLE RowErrors).
   
   ASSIGN l-erro = NO.

   FOR EACH RowErrors NO-LOCK
      where RowErrors.ErrorType   <> 'INTERNAL':U
        and RowErrors.ErrorSubType = 'Error':U:
      RUN pi-erro (RowErrors.errorNumber, RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
      ASSIGN l-erro = yes.
   end.


   IF  VALID-HANDLE(h-bodi159) AND (h-bodi159:file-name = 'dibo/bodi159.p' AND h-bodi159:type = 'procedure') THEN
       RUN destroyBO IN h-bodi159.

   IF  VALID-HANDLE(h-bodi159) THEN DO:
       DELETE PROCEDURE h-bodi159.
       ASSIGN h-bodi159 = ?.
   END.


   RUN pi-gerar-dados-extrato (INPUT 'Gerou erro na BODI159: ' + STRING(l-erro)). 
   IF  l-erro THEN
       RETURN 'NOK'.

   RUN dibo/bodi157.p PERSISTENT SET h-bodi157.

   FOR EACH tt-ped-repre:
      RUN openQueryStatic in h-bodi157(INPUT 'Default':U).

      RUN emptyRowErrors in h-bodi157.
      RUN setRecord in h-bodi157(INPUT TABLE tt-ped-repre).
      RUN createMPLog  in h-bodi157(INPUT no).
      RUN createRecord in h-bodi157.
      RUN getRowErrors in h-bodi157(OUTPUT TABLE RowErrors).
      
      FOR EACH RowErrors NO-LOCK
         WHERE RowErrors.ErrorType   <> 'INTERNAL':U
           AND RowErrors.ErrorSubType = 'Error':U:         
         RUN pi-gerar-dados-extrato (INPUT RowErrors.ERRORDescription).      
         RUN pi-erro ( RowErrors.errorNumber, RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
         ASSIGN l-erro = YES.
      END.
      DELETE tt-ped-repre.
   END.

   IF  VALID-HANDLE(h-bodi157) THEN DO:
      DELETE PROCEDURE h-bodi157.
      ASSIGN h-bodi157 = ?.
   END.
   
   RUN pi-gerar-dados-extrato (INPUT 'Gerou erro na BODI157: ' + STRING(l-erro)). 
   IF  l-erro THEN 
       RETURN 'NOK'.
                                                           
   RUN dibo/bodi154.p PERSISTENT SET h-bodi154.

   FOR EACH tt-ped-item:

      RUN openQueryStatic in h-bodi154(INPUT 'Default':U).

      RUN emptyRowErrors IN  h-bodi154.
      RUN setRecord      IN  h-bodi154(INPUT TABLE tt-ped-item).
      RUN createMPLog    IN h-bodi154(INPUT no).
      RUN createRecord   IN h-bodi154.
      RUN getRowErrors   IN h-bodi154(OUTPUT TABLE RowErrors).
                         
      FOR EACH RowErrors NO-LOCK
         WHERE RowErrors.ErrorType   <> 'INTERNAL':U
           AND RowErrors.ErrorSubType = 'Error':U:
         RUN pi-erro (RowErrors.errorNumber, RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
         ASSIGN l-erro = yes.
      end.
      delete tt-ped-item.
   end.

   IF  VALID-HANDLE(h-bodi154) AND h-bodi154:file-name = 'dibo/bodi154.p' AND h-bodi154:type = 'procedure' THEN
       RUN destroyBO IN h-bodi154.
   IF  VALID-HANDLE(h-bodi154) THEN DO:
      DELETE PROCEDURE h-bodi154.
      ASSIGN h-bodi154 = ?.
   END.
   
   RUN pi-gerar-dados-extrato (INPUT 'Gerou erro na BODI154: ' + STRING(l-erro)). 

   IF  l-erro THEN 
       RETURN 'NOK'.

   FIND ped-venda EXCLUSIVE-LOCK
       WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
         AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.
   
   RUN pi-completa-pedido.

END PROCEDURE .

PROCEDURE pi-valida-dt-entrega.
    DEF VAR i-cod-gr-canais AS INT.

    // Verifica data de entrega do item 
    
    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

    FIND LAST item-dt-entrega NO-LOCK
        WHERE item-dt-entrega.it-codigo     = tt-ped-item.it-codigo 
          AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

    IF NOT AVAIL item-dt-entrega THEN DO:
       ASSIGN i-cod-gr-canais = 0.

       FIND FIRST atendente
             WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
       IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
          ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
       END.
       ELSE DO:
          FIND FIRST emitente
               WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
          IF  AVAIL emitente THEN DO:
              FIND FIRST grupo-canais-clientes
                   WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
              IF AVAIL grupo-canais-clientes THEN DO:
                 ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
              END.
          END.
       END. 

       FIND LAST item-dt-entrega NO-LOCK
            WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
              AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
    END.
    
    IF AVAIL item-dt-entrega
         AND item-dt-entrega.dt-entrega-futura > TODAY 
         AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
       ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura
              tt-ped-item.dt-entorig = item-dt-entrega.dt-entrega-futura.
    END.
    ELSE
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.
     
    RUN pi-gerar-dados-extrato (">> DT ENTREGA ITEM: " + STRING(tt-ped-item.dt-entrega)).


    IF tt-ped-item.dt-entrega > TODAY + 730 THEN DO:
        RUN pi-erro (0, INPUT "Data de entrega do item " + tt-ped-item.it-codigo +  " superior a 2 anos!").
    END.

END PROCEDURE.


PROCEDURE pi-busca-transportadora.
    

    IF AVAIL emitente THEN DO:
       FOR FIRST loc-entr NO-LOCK WHERE
           loc-entr.nome-abrev  = emitente.nome-abrev AND
           (loc-entr.cod-entrega = "Padrao" OR 
           loc-entr.cod-entrega = "PadrÆo") :
                       
           RUN pi-gerar-dados-extrato (">> ACHOU LOCAL DE ENTREGA: " + loc-entr.cod-entrega).

           //Busca transportadora
           RUN esp/crm/escrm107.p (INPUT siteCode,
                                    INPUT STRING(emitente.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT 0,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).

         
           IF c-cod-transp = ? THEN DO:
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 17567,
                                 INPUT "NÆo encontrada transportadora para relacionamento UF x Cidade x Cliente.").
              ASSIGN tt-ped-venda.nome-transp = 'RETIRA'
                     .
              RETURN "NOK":U.
           END. 
           
           
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
                  tt-ped-venda.cidade-cif   = loc-entr.cidade. 

           FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                ASSIGN tt-ped-venda.nome-transp = transporte.nome-abrev.
           END. 


           IF tt-ped-venda.nome-transp BEGINS "Retira" THEN
              ASSIGN OVERLAY(tt-ped-venda.char-2,109,8) = "9".
           ELSE
              ASSIGN OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

           RUN pi-gerar-dados-extrato (">> TRANSPORTADORA: " + STRING(C-COD-TRANSP) + tt-ped-venda.nome-transp).

           RELEASE transporte.

       END. 
    END. 
END PROCEDURE.





PROCEDURE pi-completa-pedido:


    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

    /************************/
    /* COMPLETANDO O PEDIDO */
    /************************/
    ASSIGN l-erro = NO.
    EMPTY TEMP-TABLE RowErrors.
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
    RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda), OUTPUT TABLE RowErrors).
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** crìdito nÒo aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
       RUN pi-erro (RowErrors.errorNumber, RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
       ASSIGN l-erro = YES.
    END.
     
    RUN pi-gerar-dados-extrato (INPUT 'Gerou erro na BODI159com:' + STRING(l-erro)). 
    
    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
        RUN destroyBO IN  h-bodi159cal.
    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.

    IF  l-erro THEN 
      RETURN 'NOK'.

END PROCEDURE.

PROCEDURE UpdateSuspension:
    
    RUN pi-gerar-dados-extrato (">> OBS SUSPENDE PEDIDO " + ped-venda.observacoes + " FIM ").
    

    IF  (ped-venda.observacoes <> "" 
    AND ped-venda.cod-sit-ped <>  6 
    AND ped-venda.cod-priori  <>  3) THEN DO:

        RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao " + ped-venda.observacoes + " FIM ").

        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        for each ped-item of ped-venda
                where ped-item.cod-sit-item <= 2 exclusive-lock:
    
                for each ped-ent of ped-item
                    where ped-ent.cod-sit-ent <= 2 exclusive-lock:
    
                    assign ped-ent.cod-sit-ent  = 5
                           ped-ent.dt-suspensao = today
                           ped-ent.user-susp    = "Integra-wso2"
                           ped-ent.dt-usersusp  = today.
                end.

                assign ped-item.dt-suspensao = today
                       ped-item.user-susp    = "Integra-wso2"
                       ped-item.dt-usersusp  = today
                       ped-item.cod-sit-item = 5.
        end.
    
        assign ped-venda.dt-suspensao = today
               ped-venda.user-susp    = "Integra"
               ped-venda.dt-usersusp  = today
               ped-venda.desc-suspend = ped-venda.observacoes
               ped-venda.dt-useralt   = TODAY 
               ped-venda.user-alt     = "Integra-wso2"
               ped-venda.cod-sit-ped  = 5.
    END.
END PROCEDURE.

procedure pi-erro:
  define input parameter p-cd-erro  as integer   no-undo.
  define input parameter p-mensagem as character no-undo.

    create tt-erro.
    assign iCount           = iCount + 1
           tt-erro.i-sequen = iCount
           tt-erro.cd-erro  = p-cd-erro 
           tt-erro.mensagem = p-mensagem.
end procedure.


PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string format "x(100)" skip.
        output close. 
    
    end.
END.
