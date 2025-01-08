/****************************************************************************************
** INTEGRA°€O DE PEDIDOS VIA WSO2 (ORIGEM SALESFORCE)
** 
********************************************************************************************/


{esp/wso/in/wso0010.i}
{utp/ut-glob.i}
{esp/pdp/espdp006.i}
{btb/btb912zb.i}
{esp/esb/esesb000.i}
def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.


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
DEFINE INPUT  PARAM poNumber                       as CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM projectRegisterNumber          as CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM fiscalObservation              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAM dt-negociacao                  AS DATE        NO-UNDO.
DEFINE INPUT  PARAM dias-negociacao                AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAM dt-faturamento                 AS DATE        NO-UNDO.
DEFINE INPUT  PARAM projectCode                    as character   no-undo.
DEFINE INPUT  PARAM externalID                     as character   no-undo.  
DEFINE INPUT  PARAM totalService                   as decimal     NO-UNDO.
DEFINE INPUT  PARAM financialApproval              as logical     no-undo.
DEFINE INPUT  PARAM serviceContract                AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM c-pedido                       AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM c-status                       AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM c-observacao                   AS CHARACTER  FORMAT 'x(2000)' NO-UNDO.

DEF VAR v-rec-loc-entr  AS rowid NO-UNDO.
DEF VAR c-cod-transp    AS INTEGER.
DEF VAR c-sigla-transp  AS CHAR.
DEF VAR c-desc-suspend  AS CHAR.
DEF VAR l-solar         AS LOG.
DEF VAR c-delivery-cep  AS CHAR NO-UNDO.
DEF VAR c-item-pai      AS CHAR.
DEF VAR c-nome-item     AS CHAR FORMAT "x(256)"  NO-UNDO .


DEFINE VARIABLE h-bodi154sdf        AS HANDLE    NO-UNDO.          

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


define temp-table tt-item NO-UNDO
  field sequencia              like ped-item.nr-sequencia
  field it-codigo              like ped-item.it-codigo
  field preco-unit             like ped-item.vl-preuni
  field qt-pedida              like ped-item.qt-pedida
  FIELD nr-tabpre              LIKE preco-item.nr-tabpre
  field item-obs               as char format "x(2000)"
  field ordem-compra           as CHAR FORMAT "x(15)"
  FIELD dt-prev-fat            AS DATE
  field desconto-com           as decimal
  field desconto-qtd           as DECIMAL
  field desconto-kit           as DECIMAL
  FIELD log-servico            AS LOG
  field executivo              as INTEGER       
  field segmento-portifolio    as CHAR         
  field desc-maisverde         as decimal   
  field desc-topmilhao         as decimal
  field desc-focounidade       as decimal  
  field desc-distrib20         as decimal
  field desc-widecloud         as decimal .

DEFINE TEMP-TABLE tt-comissao NO-UNDO
    FIELD cnpj       AS CHAR
    FIELD percentual AS DEC 
    FIELD valor      AS DEC.

DEFINE TEMP-TABLE tt-grupo NO-UNDO
    FIELD ncm         AS CHAR
    field name        AS CHAR
    field items       AS CHAR
    field unitPrice   AS DEC 
    FIELD quantity    AS DEC.
	 

DEFINE TEMP-TABLE tt-cond-pagto NO-UNDO
    FIELD method    AS CHAR
    FIELD tid       AS CHAR 
    FIELD reference AS CHAR 
    FIELD processor AS CHAR
    FIELD number    AS INT
    FIELD sequencia AS INT.

DEFINE TEMP-TABLE tt-prestac
    FIELD method    AS CHAR
    FIELD reference AS CHAR 
    FIELD data      AS DATE
    FIELD valor     AS DEC.

DEFINE TEMP-TABLE tt-address NO-UNDO
    FIELD District   AS CHAR
    FIELD Cep        AS CHAR
    FIELD Complement AS CHAR
    FIELD Street     AS CHAR
    FIELD City       AS CHAR
    FIELD Number     AS CHAR
    FIELD State      AS CHAR
    FIELD Country    AS CHAR.
 
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

define temp-table tt-raw-digita
    field raw-digita    as raw.

//def input-output parameter                        table for tt-item.
//DEF OUTPUT parameter table                        FOR tt-erro .

def input-output parameter table for tt-comissao.
def input-output parameter table for tt-grupo.
def input-output parameter table for tt-item.
def input-output parameter table for tt-cond-pagto.
def input-output parameter table for tt-prestac.
def input-output parameter table for tt-address.
DEF OUTPUT parameter table FOR tt-erro .

/* ------------------------------------------------------------------ */
/*                     V A R I Æ V E I S  PEDIDO                      */
/* -------------------------------------------------------------------*/
DEFINE VARIABLE c-nat-oper-item        AS CHARACTER    NO-UNDO.
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
define variable l-maisverde            AS LOG          NO-UNDO.
define variable i-seq-p                AS INT          NO-UNDO.
define variable c-natureza-cliente     AS CHAR         NO-UNDO.
define variable log-contribuinte-icms  AS LOGICAL      NO-UNDO.
define variable c-arquivo-xml          AS CHAR         NO-UNDO.
DEFINE VARIABLE c-nat-operacao         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-fatura-automatico    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-suspende-projeto     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-serv-loc-sales       AS LOGICAL      NO-UNDO.

//variaveis para processo solar
DEFINE VAR l-pix              AS LOG NO-UNDO.
DEFINE VAR l-cartao           AS LOG NO-UNDO.
DEFINE VAR l-financiamento    AS LOG NO-UNDO.
DEFINE VAR l-boleto           AS LOG NO-UNDO.
DEFINE VAR l-suspende-solar   AS LOG NO-UNDO.
DEFINE VAR c-tid              AS CHAR NO-UNDO.
DEFINE VAR c-reference-number AS CHAR NO-UNDO.
//fim variaveis solar

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
           i-seq-p    = 1.
ELSE
    ASSIGN l-producao = NO
           i-seq-p    = 2.

EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'wso0010' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:

    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_wso0010_NEWPED_' + orderId.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_wso0010_NEWPED_' + orderId.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

END.

// Inicio 

FIND FIRST int-ped-venda
     WHERE int-ped-venda.nr-pedido-externo = orderId NO-LOCK NO-ERROR.
IF AVAIL int-ped-venda THEN  DO:
    FIND ped-venda NO-LOCK
        WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
    IF AVAIL ped-venda AND ped-venda.cod-sit-ped <= 3 THEN DO:
       RUN pi-erro (0000, 'Pedido ja importado do Salesforce com o codigo externo ' + STRING(orderId) + '. Pedido Totvs - ' + string(int-ped-venda.nr-pedido)).
       RETURN "NOK".
    END.
END.

// RF002 
FIND FIRST int-ped-venda NO-LOCK
    WHERE int-ped-venda.cod-projeto = projectCode NO-ERROR.
IF AVAIL int-ped-venda THEN DO:
    FIND ped-venda NO-LOCK
        WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
    IF AVAIL ped-venda AND (ped-venda.cod-sit-ped <= 3 OR ped-venda.cod-sit-ped = 5) THEN DO:
        RUN pi-erro (0000, 'Jÿ existe Pedido Totvs com o Projeto: ' + STRING(projectCode) + '. Pedido Totvs - ' + string(int-ped-venda.nr-pedido)).
        RETURN "NOK".
    END.
END.

RUN pi-gerar-dados-extrato ("INICIO DO PEDIDO TOTVS ").
RUN pi-gerar-dados-extrato ("CONTRATO DO PEDIDO " + serviceContract).


FOR EACH tt-item,
    FIRST ITEM WHERE ITEM.it-codigo = tt-item.it-codigo NO-LOCK:
  IF item.cod-servico <> 0 THEN
     ASSIGN tt-item.log-servico = YES.
END.



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
       /* Programador: IDBA Bruno Joaquim 
       ** Data: 16/07/2024
       ** Chamado: C2407-2135 Desfazer transacao total quando pedido entrar sem item pai
       */
       IF RETURN-VALUE = "NOK" THEN DO:
           RUN pi-gerar-dados-extrato (">>DEU ERRO VOU DESFAZER O PEDIDO").

           UNDO blk_principal, LEAVE blk_principal.
       END.


       IF  VALID-HANDLE(h-boes505) THEN DO:
           RUN DESTROY IN h-boes505 NO-ERROR.
           IF  VALID-HANDLE(h-boes505) THEN
               DELETE procedure h-boes505.
       END.
       ASSIGN h-boes505 = ?.

       IF  RETURN-VALUE <> "OK" OR 
           l-erro = YES         THEN DO:
           RUN pi-gerar-dados-extrato (">>DEU ERRO VOU DESFAZER O PEDIDO").
           UNDO blk_principal, LEAVE blk_principal.
       END.

      FIND FIRST RowErrors NO-LOCK
      where RowErrors.ErrorType   <> 'INTERNAL':U
        and RowErrors.ErrorSubType = 'Error':U NO-ERROR.
      IF AVAIL RowErrors THEN
         UNDO blk_principal, LEAVE blk_principal.
    END.
    

    RUN pi-gerar-dados-extrato (">>INICIO Erros P¢s blk_principal ").
     RUN pi-gerar-dados-extrato (">>------------------------ ").
    FOR EACH tt-erro:
        RUN pi-gerar-dados-extrato (">> tt-erro.i-sequen : " + string(tt-erro.i-sequen) ).
        RUN pi-gerar-dados-extrato (">> tt-erro.cd-erro  : " + string(tt-erro.cd-erro) ).
        RUN pi-gerar-dados-extrato (">> tt-erro.mensagem : " + string(tt-erro.mensagem) ).
    END.
    RUN pi-gerar-dados-extrato (">>FIM Erros P¢s blk_principal ").



END.

IF c-pedido <> "" AND l-fatura-automatico THEN
    RUN pi-fatura-pedido(INPUT c-pedido).

PROCEDURE pi-cria-pedido. 

    DEF VAR i-cont AS INT.
    DEF VAR l-ok   AS LOG.
    DEF VAR i-item     AS INT.
    DEF VAR i-seq-cond AS INT.
    DEF VAR i-seq-prestac AS INT.

    find first param-global no-lock no-error.
    find mgcad.empresa no-lock
       where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
    find FIRST para-fat no-lock no-error.
    find para-ped no-lock no-error.

    RUN pi-gerar-dados-extrato (">> CRIA PEDIDO").

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "Pedidowso2":U, 
                       INPUT 1, 
                       INPUT 0, 
                       INPUT "":U, 
                       OUTPUT TABLE tt-prog-ponto).
    ASSIGN l-ok = NO.
    RUN pi-gerar-dados-extrato (">> VERIFICANDO ORIGEM ").
    
    REPEAT:
       ASSIGN i-cont = i-cont + 1.
       FIND FIRST tt-prog-ponto
            WHERE int(entry(1,tt-prog-ponto.conteudo,";")) = i-seq-p  /* 1 = Producao, 2 = Homologacao */
              AND ENTRY(2,tt-prog-ponto.conteudo,";")      = origin NO-ERROR.

       IF AVAIL tt-prog-ponto THEN DO:
          RUN pi-gerar-dados-extrato (STRING(i-seq-p) + ' ' + STRING(origin) + ' ' + STRING(i-cont)).
          ASSIGN l-ok = YES
                 c-nat-operacao      = ENTRY(3,tt-prog-ponto.conteudo,";")
                 l-fatura-automatico = IF ENTRY(4,tt-prog-ponto.conteudo,";") = "YES" THEN YES ELSE NO.

          RUN pi-gerar-dados-extrato("natureza ponto1 -> "  + ENTRY(3,tt-prog-ponto.conteudo,";")).
          RUN pi-gerar-dados-extrato("natureza ponto2 -> "  + c-nat-operacao).

          LEAVE.
       END.
       IF L-OK = YES OR i-cont = 10 THEN LEAVE.
    END.

    RUN pi-gerar-dados-extrato("natureza ponto3 -> "  + c-nat-operacao).

    RUN pi-gerar-dados-extrato( STRING(i-cont)).
    RUN pi-gerar-dados-extrato (">> PASSEI DO PONTO 1"). 
   
    IF l-ok = NO THEN DO:
       RUN pi-erro (1000, "Origem do pedido nÆo habilitada para integra‡Æo com o ERP").
       RUN pi-gerar-dados-extrato (">> Origem do pedido nÆo habilitada para integracao com o ERP").
       RETURN "NOK".
    END.

    RUN pi-gerar-dados-extrato (">> ok" ).

   

    RUN pi-gerar-dados-extrato (">> Origem ok para integra‡Æo com o ERP").

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


    RUN pi-gerar-dados-extrato (">> REPRESENTANTE: " + string(representativeCode)).


    FIND FIRST repres NO-LOCK                                        
         WHERE repres.cod-rep =  representativeCode NO-ERROR. 
    IF  NOT AVAIL repres THEN DO:
        RUN pi-erro (1010, 'Representante nÆo cadastrado no ERP ').
        RETURN "NOK".
    END.

    RUN pi-gerar-dados-extrato (">> REPRESENTANTE2: " + string(representativeCode)).

    IF attendantCode = '' THEN DO:
       RUN pi-gerar-dados-extrato (">> REPRESENTANTE3: " + string(representativeCode)).
       RUN pi-gerar-dados-extrato (">> ESTABELEC3: " + siteCode).
       FIND FIRST repres-atend
            WHERE repres-atend.cod-estab = siteCode
              AND repres-atend.cod-rep   = representativeCode NO-LOCK NO-ERROR.

       IF  NOT AVAIL repres-atend THEN DO:
           RUN pi-gerar-dados-extrato ("ERRO DE ATENDENTE NAO ENCONTRADO PARA O REPRES" ).
           RUN pi-erro (1020, 'Representante nÆo possui atendente associado no Salesforce, e nÆo possui no programa espdp011 do Totvs. Favor entrar em contato com a ADM de Vendas ').
           RETURN "NOK".
       END.
       ELSE DO:
           ASSIGN attendantCode = string(repres-atend.cd-oper).
       END.
    END.

    IF origin MATCHES "*solar*" THEN DO:

        IF attendantCode = "0" THEN DO:
               RUN pi-erro (1010, 'Atendente 0 invalido ').
               RETURN "NOK".
        END.

        FIND FIRST atendente 
             WHERE string(atendente.cd-oper) = attendantCode NO-LOCK NO-ERROR.
        IF NOT AVAIL atendente THEN DO:
            RUN pi-erro (1010, 'Atendente ' + string(attendantCode) + " nao cadastrado ").
            RETURN "NOK".
        END. 

    END.

    RUN pi-gerar-dados-extrato ("ERRO DE ATENDENTE NAO ENCONTRADO PARA O REPRES2: " + STRING(attendantCode) ).
    
    FIND FIRST cond-pagto
         WHERE cond-pagto.cod-cond-pag = paymentCondition NO-LOCK NO-ERROR.
    IF NOT AVAIL cond-pagto AND paymentCondition > 0 THEN DO:
       RUN pi-erro (1030, 'C¢digo da condi‡Æo de pagamento nÆo cadastrada no Totvs - ' +
                                             string(paymentCondition) + ' - Favor entrar em contato com a ADM de Vendas').
       RETURN "NOK".
    END.
    
    RUN pi-gerar-dados-extrato (">>CRIANDO A TEMP-TABLE TT-PED-VENDA").

    RUN pi-gerar-dados-extrato (">>CRIANDO A TEMP-TABLE TT-PED-VENDA2").

    RUN pi-gerar-dados-extrato (">>avail cond-pagto" + ' ' + STRING(AVAIL cond-pagto) + ' ' + "paymentCondition: " + ' ' + string(paymentCondition)).
    

    CREATE tt-ped-venda.
    ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
           tt-ped-venda.nome-abrev = emitente.nome-abrev
           tt-ped-venda.nr-pedcli  = string(tt-ped-venda.nr-pedido)
           tt-ped-venda.nr-pedrep  = orderId.

    ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
           tt-ped-venda.dt-emissao              = IF effectiveDate <> '' THEN DATE ( string(substr(effectiveDate,9,2)) + STRING(substr(effectiveDate,6,2)) + string(substr(effectiveDate,1,4))) ELSE TODAY
           tt-ped-venda.no-ab-reppri            = repres.nome-abrev
           tt-ped-venda.dt-implant              = today
           tt-ped-venda.dt-entrega              = TODAY
           tt-ped-venda.dt-entorig              = TODAY
           tt-ped-venda.nome-tr-red             = ""
           tt-ped-venda.cod-emitente            = emitente.cod-emitente
          // tt-ped-venda.cod-cond-pag            = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE 0
          // tt-ped-venda.nr-tab-finan            = IF AVAIL cond-pagto THEN cond-pagto.nr-tab-fin   ELSE 1
          // tt-ped-venda.nr-ind-finan            = IF AVAIL cond-pagto THEN cond-pagto.nr-ind-fin   ELSE 1

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


    RUN pi-gerar-dados-extrato (">>Antes assign cond-pagto").

    ASSIGN tt-ped-venda.cod-cond-pag            = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE 0
           tt-ped-venda.nr-tab-finan            = IF AVAIL cond-pagto THEN cond-pagto.nr-tab-fin   ELSE 1
           tt-ped-venda.nr-ind-finan            = IF AVAIL cond-pagto THEN cond-pagto.nr-ind-fin   ELSE 1.

    RUN pi-gerar-dados-extrato (">>Depois assign cond-pagto").


    IF dt-faturamento < TODAY  OR 
       dt-faturamento = ? THEN
       ASSIGN tt-ped-venda.dt-entrega = TODAY
              tt-ped-venda.dt-entorig = TODAY. 
    ELSE                           
      ASSIGN tt-ped-venda.dt-entrega  = dt-faturamento
             tt-ped-venda.dt-entorig  = dt-faturamento.

    FIND FIRST atendente 
         WHERE string(atendente.cd-oper) = attendantCode NO-LOCK NO-ERROR.
    IF AVAIL atendente AND 
       (atendente.cod-gr-canais = 3 /* Verticais */  OR 
        atendente.cod-gr-canais = 7) /*Provedores*/  THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.

       RUN esp/es0018p.p (INPUT  "pd4000":U,
                          INPUT  12,
                          INPUT  0,
                          INPUT  "":U,
                          OUTPUT TABLE tt-prog-ponto).

       FIND FIRST tt-prog-ponto NO-ERROR.
       IF AVAIL tt-prog-ponto THEN
          ASSIGN tt-ped-venda.cod-priori = INT(tt-prog-ponto.conteudo).
    END.
           
    ASSIGN l-maisverde = YES.
    FOR EACH tt-item:
        IF desc-maisverde = 0 THEN l-maisverde = NO.
    END.
    
    IF l-maisverde = YES THEN DO:
       ASSIGN tt-ped-venda.cod-priori = 3.
    END.


    RUN pi-gerar-dados-extrato (">> PRIORIDADE: " + STRING(tt-PED-VENDA.COD-PRIORI)).


     /* Atribuir Portador conforme o cadastro do cliente */
    IF  emitente.portador <> 0 THEN
        ASSIGN tt-ped-venda.cod-portador = emitente.portador
               tt-ped-venda.modalidade   = emitente.modalidade.
    ELSE
        ASSIGN tt-ped-venda.cod-portador = 999
               tt-ped-venda.modalidade   = 6.

    //C2309-1393
    
    ASSIGN l-serv-loc-sales = NO.
    IF origin MATCHES("*sales*") THEN DO:
        IF attendantCode = "67" THEN
            ASSIGN c-natureza = "800112"
                   l-serv-loc-sales = YES.
        ELSE IF attendantCode = "68" THEN
                ASSIGN c-natureza = "500012"
                       l-serv-loc-sales = YES.
    END.

    RUN pi-busca-transportadora.

    FIND FIRST tt-item NO-LOCK NO-ERROR.

    IF l-serv-loc-sales = NO THEN DO:
       IF tt-item.log-servico = YES THEN ASSIGN c-natureza = '500001'.
       ELSE DO:

           RUN pi-gerar-dados-extrato (">> DEFINE NATUREZA DO PEDIDO - " + ' ' + siteCode + " " + STRING(emitente.cod-emitente) + " " + loc-entr.cod-entrega + " " + STRING(l-consumidor-final)).

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
       END.
       
       IF c-nat-operacao <> "" THEN ASSIGN c-natureza = c-nat-operacao.
    END.

    //RUN pi-busca-transportadora.


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
           tt-ped-venda.cod-des-merc    = (if (natur-oper.consum-final OR l-serv-loc-sales) then 2 else 1).
    

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

       /* RF017 */
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "pd4000":U,
                       INPUT  11,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    IF CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = STRING(tt-ped-venda.cod-cond-pag)) THEN DO:
        ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Aten»’o! Pedido com condi»’o Santander.".
    END.       

    RUN pi-gerar-dados-extrato (">> ANTES DA TT-COND-PAGTO ").

    /* Condi»’o de Pagamento - RF010 */
    IF origin MATCHES "*solar*" THEN DO:
        IF CAN-FIND (FIRST tt-cond-pagto) AND paymentCondition = 0 THEN DO:
            ASSIGN i-seq-cond = 0.
    
            ASSIGN l-pix            = NO
                   l-cartao         = NO
                   l-financiamento  = no
                   l-boleto         = NO
                   l-suspende-solar = NO.
    
            ASSIGN c-tid              = ""
                   c-reference-number = "".
    
            RUN pi-gerar-dados-extrato (">> TEM TT-COND-PAGTO " + " - " + c-tid + " - " + c-reference-number).
    
            FOR EACH tt-cond-pagto
               BREAK BY tt-cond-pagto.sequencia: 

               /* IF tt-cond-pagto.method = "creditcard" THEN DO:
                   ASSIGN tt-cond-ped.observacoes = TRIM (tt-cond-pagto.processor) + '...' + 'Final' + STRING (tt-cond-pagto.number)
                          l-cartao                = YES.
                   
                   IF c-reference-number = "" THEN
                       ASSIGN c-reference-number = tt-cond-pagto.reference.
                   ELSE
                       ASSIGN c-reference-number = c-reference-number + "/" + tt-cond-pagto.reference.
                   
                END.
                ELSE DO:
                    IF tt-cond-pagto.method = 'billet' THEN
                       ASSIGN tt-cond-ped.observacoes = 'Boleto'
                              l-boleto                = YES
                              c-tid                   = tt-cond-pagto.tid.
                    ELSE //adicionado forma pagamento PIX
                        IF tt-cond-pagto.method = 'pix' THEN
                           ASSIGN tt-cond-ped.observacoes = 'Pix'
                                  l-pix                   = YES
                                  c-tid                   = tt-cond-pagto.tid.
                        ELSE IF tt-cond-pagto.METHOD = "financing" THEN
                                ASSIGN tt-cond-ped.observacoes = "financiamento"
                                         l-financiamento         = YES. 
                END.*/

                FOR EACH tt-prestac
                   WHERE tt-prestac.method    = tt-cond-pagto.method
                     AND tt-prestac.reference = tt-cond-pagto.reference
                     BREAK BY tt-prestac.reference:

                    IF FIRST-OF(tt-prestac.reference) THEN
                       ASSIGN i-seq-prestac = 0.

                    RUN pi-gerar-dados-extrato (">> TEM tt-prestac ").
    
                    RUN pi-gerar-dados-extrato (">> TEM tt-prestac - TID: " + tt-cond-pagto.tid).
    
                    RUN pi-gerar-dados-extrato (">> TEM tt-prestac - REFERENCE NUMBER : " +  tt-cond-pagto.reference).
    
    
                   /* IF c-tid = "" THEN
                        ASSIGN c-tid = tt-cond-pagto.tid.
    
                    IF c-reference-number = "" THEN
                        ASSIGN c-reference-number = tt-cond-pagto.reference. */
    
    
                    CREATE tt-cond-ped.
                    ASSIGN i-seq-cond = i-seq-cond + 1
                           tt-cond-ped.nr-pedido    = tt-ped-venda.nr-pedido
                           tt-cond-ped.nr-sequencia = i-seq-cond
                           tt-cond-ped.data-pagto   = tt-prestac.data
                           tt-cond-ped.vl-pagto     = tt-prestac.valor.

                    ASSIGN i-seq-prestac = i-seq-prestac + 1.
    
                    IF tt-cond-pagto.method = "creditcard" THEN DO:
                       ASSIGN tt-cond-ped.observacoes = TRIM (tt-cond-pagto.processor) + '...' + 'Final' + STRING (tt-cond-pagto.number)
                              l-cartao                = YES.
    
                       IF i-seq-prestac = 1 THEN DO: //soh pega da primeira sequencia, visto que repete o reference
                          IF c-reference-number = "" THEN
                              ASSIGN c-reference-number = tt-cond-pagto.reference.
                          ELSE
                              ASSIGN c-reference-number = c-reference-number + "/" + tt-cond-pagto.reference.
                       END.
                    END.
                    ELSE
                        IF tt-cond-pagto.method = 'billet' THEN
                           ASSIGN tt-cond-ped.observacoes = 'Boleto'
                                  l-boleto                = YES
                                  c-tid                   = tt-cond-pagto.tid.
                        ELSE //adicionado forma pagamento PIX
                            IF tt-cond-pagto.method = 'pix' THEN
                               ASSIGN tt-cond-ped.observacoes = 'Pix'
                                      l-pix                   = YES
                                      c-tid                   = tt-cond-pagto.tid.
                            ELSE IF tt-cond-pagto.METHOD = "financing" THEN
                                    ASSIGN tt-cond-ped.observacoes = "financiamento"
                                           l-financiamento         = YES. 
                    
                    RUN pi-gerar-dados-extrato (">> CONDICAO DE PAGAMENTO - " + ' Metodo: ' + TRIM (tt-cond-pagto.method)  
                                                + ' Pedido: ' + STRING (tt-cond-ped.nr-pedido) + ' Seq: ' + STRING (tt-cond-ped.nr-sequencia)
                                                + ' Data: ' + STRING (tt-cond-ped.data-pagto, "99/99/9999") + ' Valor: ' + STRING (tt-cond-ped.vl-pagto)).
                END.
            END.
    
            IF c-tid <> "" AND c-reference-number <> "" THEN 
                ASSIGN c-tid = c-tid + "/0".
    
            IF c-reference-number <> "" THEN DO:
            
                IF INDEX(c-reference-number, "/") = 0  THEN DO:
    
                    IF c-tid <> "" THEN
                        ASSIGN c-reference-number = "0/" + c-reference-number.
                    ELSE
                        ASSIGN c-reference-number = c-reference-number + "/0".
                END.
            
            END.    
    
            IF (l-pix AND l-financiamento) OR (l-cartao AND l-financiamento) OR (l-boleto AND l-financiamento) OR l-financiamento THEN 
                ASSIGN l-suspende-solar = YES.
    
        END.
        ELSE DO:
            ASSIGN c-tid = "".
            FOR EACH tt-cond-pagto:
                ASSIGN c-tid = tt-cond-pagto.tid.
            END.
        END.
    END.
   
    FOR EACH tt-item:
        IF tt-item.item-obs MATCHES '*combo*' THEN DO:

            IF index(tt-ped-venda.observacoes,'Aten‡Æo! Pedido possui itens combo!') = 0 THEN
              ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + CHR(13) + 'Aten‡Æo! Pedido possui itens combo!:'.

            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + ENTRY(2,tt-item.item-obs,":") + ",".
           //LEAVE.
        END.
    END.


    RUN pi-gerar-dados-extrato (">> CRIACAO DOS ITENS "). 
    ASSIGN l-solar = NO
           l-suspende-projeto = NO.

    // Cria‡Æo da tabela ped-item
    FOR EACH tt-item:
      
       FIND FIRST ITEM no-lock
            WHERE item.it-codigo = tt-item.it-codigo NO-ERROR.
       IF  NOT AVAIL ITEM THEN DO:
           RUN pi-erro (1080, 'Item nÆo encontrado ' + string(tt-item.it-codigo)).
           RETURN "NOK".
       END.

       IF AVAIL ITEM AND ITEM.cod-unid-neg = 'ENS' THEN l-solar = YES.

      /* EMPTY TEMP-TABLE tt-prog-ponto.

       RUN esp/es0018p.p (INPUT  "solar":U,
                          INPUT  10,
                          INPUT  0,
                          INPUT  "":U,
                          OUTPUT TABLE tt-prog-ponto).

       FIND FIRST tt-prog-ponto
            WHERE tt-prog-ponto.conteudo = ITEM.it-codigo NO-ERROR.
       IF AVAIL tt-prog-ponto THEN
          ASSIGN l-solar = YES.  */

       IF l-fatura-automatico THEN
           ASSIGN c-nat-oper-item = c-nat-operacao.
       ELSE DO: 

           RUN pi-gerar-dados-extrato (">> DEFINE NATUREZA DO ITEM - " + ' ' + siteCode + " " + STRING(emitente.cod-emitente) + " " + loc-entr.cod-entrega + " " + tt-item.it-codigo + " " + STRING(l-consumidor-final)).


          // Natureza de operacao do item 
          RUN defineNatOperacao IN h-boes505 (INPUT siteCode,
                                              INPUT emitente.cod-emitente,
                                              INPUT loc-entr.cod-entrega,
                                              INPUT tt-item.it-codigo,
                                              INPUT l-Consumidor-final,
                                              OUTPUT c-nat-oper-item,
                                              OUTPUT l-return).
          
          IF tt-item.log-servico = YES THEN 
              ASSIGN c-nat-oper-item = '500001'.
       END.

       IF l-serv-loc-sales THEN
           ASSIGN c-nat-oper-item = c-natureza.

       RUN pi-gerar-dados-extrato (">> NATUREZA DO ITEM DO PEDIDO - " + ' ' + c-nat-oper-item).
       RUN pi-gerar-dados-extrato (">> l-serv-loc-sales - " + ' ' + string(l-serv-loc-sales)).


       IF c-nat-oper-item = "" THEN DO:
          RUN pi-erro (1071, 'Item ' + tt-item.it-codigo + ' sem natureza de opera‡Æo relacionada. Favor entrar em contato com a equipe do Tribut rio.').
          RETURN "NOK".
         
       END.

       //IF tt-item.log-servico = YES  THEN c-nat-oper-item = '500001'.

       RUN pi-gerar-dados-extrato (">> NATUREZA DO ITENS - " + TT-ITEM.IT-CODIGO + ' ' + c-nat-oper-item + ' ' + STRING(TT-ITEM.SEQUENCIA)).


       CREATE tt-ped-item.
       ASSIGN tt-ped-item.nr-sequencia            = tt-item.sequencia
              tt-ped-item.aliquota-ipi            = item.aliquota-ipi
              tt-ped-item.nr-pedcli               = tt-ped-venda.nr-pedcli
              tt-ped-item.cod-entrega             = tt-ped-venda.cod-entrega
              tt-ped-item.nat-operacao            = c-nat-oper-item
              OVERLAY(tt-ped-item.char-2,1,8)     = item.class-fiscal
              tt-ped-item.qt-pedida               = tt-Item.qt-pedida
              tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
              tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
              tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
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
              tt-ped-item.qt-log-aloca            = IF l-fatura-automatico THEN tt-ped-item.qt-pedida ELSE 0.
       
      IF tt-item.dt-prev-fat < TODAY  OR 
         tt-item.dt-prev-fat = ?  THEN
         ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega
                tt-ped-item.dt-entorig = tt-ped-venda.dt-entrega. 
      ELSE                           
        ASSIGN tt-ped-item.dt-entrega  = tt-item.dt-prev-fat
               tt-ped-item.dt-entorig  = tt-item.dt-prev-fat.

       FIND FIRST int-segmento-portifolio
            WHERE int-segmento-portifolio.descricao = tt-item.segmento-portifolio    NO-LOCK NO-ERROR.

       RUN pi-gerar-dados-extrato (">> origem plataforma " + origin).

       IF origin MATCHES("*sales*") THEN DO:
            
           RUN pi-gerar-dados-extrato (">> l-suspende-projeto " + string(l-suspende-projeto)).

           RUN esp/es0018p.p (INPUT "tb-preco-esp":U,
                              INPUT 1,
                              INPUT 0,
                              INPUT "":U,
                              OUTPUT TABLE tt-prog-ponto).

           FIND FIRST tt-prog-ponto
                WHERE tt-prog-ponto.conteudo = tt-item.nr-tabpre NO-ERROR.
           IF AVAIL tt-prog-ponto THEN
               ASSIGN l-suspende-projeto = YES.
           //marcio stam

           RUN pi-gerar-dados-extrato (">> l-suspende-projeto depois" + string(l-suspende-projeto)).


           CREATE mgesp.int-ped-item-pci.
           ASSIGN int-ped-item-pci.nr-pedcli           = tt-ped-item.nr-pedcli
                  int-ped-item-pci.nome-abrev          = tt-ped-item.nome-abrev
                  int-ped-item-pci.nr-sequencia        = tt-ped-item.nr-sequencia
                  int-ped-item-pci.it-codigo           = tt-ped-item.it-codigo
                  int-ped-item-pci.cod-refer           = tt-ped-item.cod-refer
                  int-ped-item-pci.nr-tabpre           = tt-item.nr-tabpre              
                  int-ped-item-pci.cod-repres          = IF tt-item.executivo > 0 THEN tt-item.executivo ELSE representativeCode             
                  int-ped-item-pci.cod-segmento        = IF AVAIL int-segmento-portifolio THEN int-segmento-portifolio.cod-segmento ELSE 0
                  int-ped-item-pci.desc-comerical      = tt-item.desconto-com
                  int-ped-item-pci.desc-kit            = tt-item.desconto-kit
                  int-ped-item-pci.desc-quant          = tt-item.desconto-qtd
                  int-ped-item-pci.desc-topmilhao      = tt-item.desc-topmilhao         
                  int-ped-item-pci.desc-maisverde      = tt-item.desc-maisverde         
                  int-ped-item-pci.desc-focounidade    = tt-item.desc-focounidade       
                  int-ped-item-pci.desc-distrib20      = tt-item.desc-distrib20         
                  int-ped-item-pci.desc-widecloud      = tt-item.desc-widecloud.    

           IF tt-item.desconto-kit < 1 THEN 
               ASSIGN tt-ped-item.des-pct-desconto-inform = "0+" + string(tt-item.desconto-kit).
           ELSE
               ASSIGN tt-ped-item.des-pct-desconto-inform = string(tt-item.desconto-kit).
    
           IF tt-item.desconto-com > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + STRING(tt-item.desconto-com).
          
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desconto-qtd > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    
           IF tt-item.desconto-qtd > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform +  STRING(tt-item.desconto-qtd).
    
           // Aplica‡Æo dos descontos do PCI 
    
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desc-topmilhao > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
           IF dec(tt-item.desc-topmilhao) > 0 THEN
              ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(tt-item.desc-topmilhao).
              
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desc-maisverde > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
           IF dec(tt-item.desc-maisverde) > 0 THEN
              ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(tt-item.desc-maisverde).
               
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desc-focounid > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
           IF dec(tt-item.desc-focounid) > 0 THEN
              ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(tt-item.desc-focounid).
                   
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desc-distrib > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
           IF dec(tt-item.desc-distrib) > 0 THEN
              ASSIGN tt-ped-item.des-pct-desconto-inform   = tt-ped-item.des-pct-desconto-inform + string(tt-item.desc-distrib20).
                       
           IF tt-ped-item.des-pct-desconto-inform <> '' AND 
              tt-item.desc-widecloud > 0 THEN 
              ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
           IF dec(tt-item.desc-widecloud) > 0 THEN
              ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(tt-item.desc-widecloud).

       END.
    
       RUN pi-gerar-dados-extrato (">> DESCONTO CASCATA DO ITEM - " + TT-ITEM.IT-CODIGO + ' ' +  STRING(TT-ped-item.des-pct-desconto-inform)).

       IF tt-ped-item.des-pct-desconto-inform = "0" THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform = "".

       ASSIGN tt-ped-item.observacao              = tt-item.item-obs
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

          RUN pi-gerar-dados-extrato (">> vou criar a cond ped").

    FOR EACH tt-cond-ped:
        RUN pi-gerar-dados-extrato (">> COND PED: " + STRING(TT-COND-PED.DATA-PAGTO)).
        CREATE cond-ped.
        ASSIGN cond-ped.nr-pedido    = TT-ped-venda.nr-pedido
               cond-ped.nr-sequencia = tt-cond-ped.nr-sequencia
               cond-ped.data-pagto   = tt-cond-ped.data-pagto
               cond-ped.vl-pagto     = tt-cond-ped.vl-pagto
               cond-ped.observacoes  = tt-cond-ped.observacoes.

    END.

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
    RUN pi-gerar-dados-extrato (">> Passando na int-ped-venda: " + string(int-ped-venda.nr-pedido)).
    RUN pi-gerar-dados-extrato (">> CONTRATO DO PEDIDO " + serviceContract).



    RUN pi-gerar-dados-extrato (">> ANTES CRIAR INT-PED-VENDA ").

    RUN pi-gerar-dados-extrato (">> ANTES CRIAR INT-PED-VENDA - TID " + c-tid).
    RUN pi-gerar-dados-extrato (">> ANTES CRIAR INT-PED-VENDA - REFERENCE-NUMBER - " + c-reference-number).

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
           //int-ped-venda.nr-tabpre              = priceBook
           OVERLAY(int-ped-venda.char-1,68,8)   = supervisorRegistration
           OVERLAY(int-ped-venda.char-1, 53,12) = poNumber
           overlay(int-ped-venda.char-1,26,15)  = ""       /*ttpedido.CpfCnpjOrigem*/
           OVERLAY(int-ped-venda.char-1,20,5)   = c-sigla-transp
           int-ped-venda.dt-negociacao          = dt-negociacao
           int-ped-venda.dias-negociacao        = dias-negociacao
           int-ped-venda.cod-projeto            = projectCode
           OVERLAY(int-ped-venda.char-1,150,12)  = externalID   /* RF001 */
           int-ped-venda.vl-serv-inst           = totalService /* RF001 */
          // int-ped-venda.log-avalia-financ      = financialApproval  /* RF013 */
           int-ped-venda.nr-contrato            = serviceContract  //novo campo do contrato.
           int-ped-venda.tid                    = c-tid
           int-ped-venda.reference-number       = c-reference-number.

    RUN pi-gerar-dados-extrato (">> CONTRATO DO PEDIDO22:  " + serviceContract).

        /* Grava somente a primeira Comiss’o - RF012 */
     FIND FIRST tt-comissao NO-LOCK NO-ERROR.
     IF AVAIL tt-comissao THEN DO:
         ASSIGN int-ped-venda.perc-comissao = tt-comissao.percentual
                int-ped-venda.vlr-comissao  = tt-comissao.valor.
     END.

     RUN pi-gerar-dados-extrato (">> Gravou int-ped-venda: " + string(int-ped-venda.nr-pedido)).
    
     FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
          WHERE int-ped-venda2.cod-estabel = int-ped-venda.cod-estabel
            AND int-ped-venda2.nr-pedido   = int-ped-venda.nr-pedido NO-ERROR.

     IF NOT AVAIL int-ped-venda2 THEN DO:
         RUN pi-gerar-dados-extrato (">> Passando na int-ped-venda2: " + string(int-ped-venda.nr-pedido)).


         CREATE int-ped-venda2.
         ASSIGN int-ped-venda2.nr-pedido   = int-ped-venda.nr-pedido
                int-ped-venda2.cod-estabel = int-ped-venda.cod-estabel.
         RUN pi-gerar-dados-extrato (">> INT-PED-VENDA2: " + STRING(INT-PED-VENDA2.NR-PEDIDO)).


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

     IF AVAIL ped-venda THEN DO:
        /**** verifica declara‡Æo de zona franca de manaus ***/
        IF ped-venda.cod-estabel = '105' THEN DO:
           FIND FIRST emitente
                WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
           FIND FIRST int-emitente-trib NO-LOCK
                WHERE int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
           IF  NOT AVAIL int-emitente-trib OR
               (AVAIL int-emitente-trib AND 
               int-emitente-trib.ind-declaracao = NO) THEN DO:
               RUN pi-gerar-dados-extrato (">> DECLARACAO ZONA FRANCA: ").
               FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
               ASSIGN ped-venda.observ = ped-venda.observ +  CHR(10) +
                                         "Declaracao ZFM nÆo cadastrada!".
           END.
        END.

    END.

  /*  IF l-solar = YES THEN DO:
       ASSIGN ped-venda.observ = ped-venda.observ + ' '  +
                                 "Pedidos contem item(s) de energia Solar!".
       RUN pi-gerar-dados-extrato (">> Possui itens de solar ").

    END. */

    IF origin MATCHES "*solar*" THEN DO:
        IF l-suspende-solar THEN DO:
           RUN pi-gerar-dados-extrato (">> SUSPENDE PEDIDO SOLAR").
           RUN UpdateSuspension.
        END.
    END.
    ELSE DO:
        RUN pi-gerar-dados-extrato (">> l-suspende-projeto depois 2" + string(l-suspende-projeto)).

       IF ped-venda.observ <> '' OR l-suspende-projeto THEN DO:
          RUN pi-gerar-dados-extrato (">> SUSPENDE PEDIDO ").


          IF l-suspende-projeto THEN
              ASSIGN ped-venda.observ = ped-venda.observ + ' '  +
                                 "Pedido com item de projeto especial".

          RUN UpdateSuspension.
       END.
    END.

    IF l-solar = NO THEN
       if not ped-venda.completo then
          RUN pi-completa-pedido.
    ELSE DO:
       ASSIGN l-erro = NO.
       RUN pi-gerar-dados-extrato (">> COMPLETA PEDIDO SOLAR ").
      //RUN pi-completa-pedido.
    END.

    IF AVAIL ped-venda THEN DO:
       ASSIGN c-pedido = ped-venda.nr-pedcli
              c-observacao = ped-venda.observ
              c-status = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.

       /* Gerador Solar */ /* RF005 */ 
        FOR EACH tt-grupo:

           RUN pi-gerar-dados-extrato (">> CRIANDO ITEM GERADOR: ante do 058").
           RUN pi-gerar-dados-extrato (">> " + ped-venda.nr-pedcli + ped-venda.nome-abrev + tt-grupo.NAME + tt-grupo.ncm + STRING(tt-grupo.unitPrice)).
           ASSIGN c-nome-item = tt-grupo.NAME  .

           RUN esp/cdp/escdp058.p  (INPUT ped-venda.nr-pedcli,
                                    INPUT ped-venda.nome-abrev,
                                    INPUT tt-grupo.name,
                                    INPUT tt-grupo.ncm,
                                    //INPUT tt-grupo.unitPrice,
                                    //INPUT tt-grupo.quantity,
                                    INPUT ped-venda.observ).
                                    //INPUT tt-grupo.items,
                                    //OUTPUT c-item-pai).

         /*  DO i-item = 1 TO NUM-ENTRIES (tt-grupo.items):
               
               FIND FIRST tt-ped-item NO-LOCK 
                   WHERE tt-ped-item.nr-sequencia = INT (ENTRY (i-item, tt-grupo.items)) NO-ERROR.
               IF AVAIL tt-ped-item THEN DO:
                   RUN pi-gerar-dados-extrato (">> GRAVANDO ITEM GERADOR NOS FILHOS" + STRING(TT-PED-ITEM.NR-SEQUENCIA) ).
                  /* Grava o It-gerador */
                  FIND FIRST int-ped-item EXCLUSIVE-LOCK
                       WHERE int-ped-item.nome-abrev   = ped-venda.nome-abrev
                         AND int-ped-item.nr-pedcli    = ped-venda.nr-pedcli
                         AND int-ped-item.nr-sequencia = tt-ped-item.nr-sequencia
                         AND int-ped-item.it-codigo    = tt-ped-item.it-codigo
                         AND int-ped-item.cod-refer    = tt-ped-item.cod-refer NO-ERROR.
                   IF NOT AVAIL int-ped-item THEN DO:                       
                      CREATE int-ped-item.
                      ASSIGN int-ped-item.nome-abrev    = ped-venda.nome-abrev      
                             int-ped-item.nr-pedcli     = ped-venda.nr-pedcli       
                             int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia  
                             int-ped-item.it-codigo     = tt-ped-item.it-codigo     
                             int-ped-item.cod-refer     = tt-ped-item.cod-refer.
                   END.
                   //ASSIGN int-ped-item.it-gerador = c-item-pai. /* RF007 */
               END.
           END.     */        
        END.

        IF origin MATCHES "*solar*" THEN DO:
            //RUN pi-erro (1130, ">>>Pedido Solar").
            RUN pi-gerar-dados-extrato (">>>Pedido Solar").
            FIND FIRST int-item NO-LOCK
                 WHERE int-item.nr-ped-energia = ped-venda.nr-pedcli  NO-ERROR.
            IF NOT AVAIL int-item THEN DO:
                RUN pi-erro (1130, "Gerado pedido de venda numero sem item pai").
                 /* Programador: IDBA Bruno Joaquim 
                  ** Data: 16/07/2024
                  ** Chamado: C2407-2135 Desfazer transacao total quando pedido entrar sem item pai
                  */
                RETURN "NOK".
            END.
            ELSE DO:
                 /** Programador: IDBA Bruno Joaquim
                  ** Data: 06/08/2024
                  ** Chamado: Desfazer transacao total se a descricao do item pai gerada for difernete da descricacao do projeto
                  */
                RUN pi-gerar-dados-extrato (">>>Avail int-item ") .
                FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = int-item.it-codigo NO-ERROR.
                FIND FIRST tt-grupo NO-ERROR.
                IF AVAIL ITEM THEN DO:
                        RUN pi-gerar-dados-extrato (">>>Avail ITEM ") .
                        RUN pi-gerar-dados-extrato (">>>ITEM.desc-item: " +  ITEM.desc-item ) .
                        RUN pi-gerar-dados-extrato (">>>c-nome-item:    " +  c-nome-item ) .
                        RUN pi-gerar-dados-extrato (">>>tt-grupo.NAME:  " +  tt-grupo.NAME ) .
                    IF ITEM.desc-item <> c-nome-item THEN DO:
                         RUN pi-erro (1130, "Item pai com descri‡Æo diferente do projeto. Item Pai: " +  string(ITEM.desc-item) + " Item Projeto: " + c-nome-item ).
                        //RUN pi-erro (1130, "Item pai com descri‡Æo diferente do projeto " ) .
                        RETURN "NOK".
                    END.
                END.

                //validar estrutura do pedido com a estrutura do item pai gerador Se estiver diferente desfaz a integracao
                FOR EACH ped-item OF ped-venda NO-LOCK:

                    IF NOT CAN-FIND(FIRST estrutura NO-LOCK
                                    WHERE estrutura.it-codigo = int-item.it-codigo
                                      AND estrutura.es-codigo = ped-item.it-codigo) THEN DO:
                         RUN pi-erro (1130, "Estrutura do item pai diferente dos itens do pedido de venda do projeto: " + projectCode  ).
                         RETURN "NOK".
                    END.
                END.

            END.
        END.

    END.
    ELSE DO:
        RUN pi-erro (1130, "NÆo foi possivel concluir com sucesso a cria‡Æo do pedido. ").
        RETURN "NOK".
    END.
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
      RUN pi-gerar-dados-extrato (INPUT 'Gerou erro na BODI159: ' + RowErrors.ERRORDescription).
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
   
   IF l-solar = NO THEN
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
   
     
    RUN pi-gerar-dados-extrato (">> DT ENTREGA ITEM: " + STRING(tt-ped-item.dt-entrega)).


    IF tt-ped-item.dt-entrega > TODAY + 730 THEN DO:
        RUN pi-erro (0, INPUT "Data de entrega do item " + tt-ped-item.it-codigo +  " superior a 2 anos!").
    END.

END PROCEDURE.


PROCEDURE pi-busca-transportadora.
    

    IF AVAIL emitente THEN DO:

        FIND FIRST tt-address NO-LOCK NO-ERROR. /* RF015 */
        IF AVAIL tt-address THEN DO:
            IF tt-address.Cep <> "" THEN DO: 
                ASSIGN c-delivery-cep = REPLACE (tt-address.Cep, "-", ""). 
                FIND FIRST loc-entr NO-LOCK
                    WHERE loc-entr.nome-abrev  = tt-ped-venda.nome-abrev
                      AND loc-entr.cod-entrega = c-delivery-cep NO-ERROR.
                IF NOT AVAIL loc-entr then do:
                    RUN pi-gerar-dados-extrato (">> CRIANDO LOCAL DE ENTREGA: " + tt-address.Cep ).

                    CREATE loc-entr.
                    ASSIGN v-rec-loc-entr       = ROWID(loc-entr)
                           loc-entr.nome-abrev  = tt-ped-venda.nome-abrev
                           loc-entr.cod-entrega = c-delivery-cep.
                    IF tt-address.Street <> "" THEN DO:
                       RUN pi-gerar-dados-extrato (">> tt-adress.Street: " + STRING(tt-address.Street)).

                        ASSIGN loc-entr.endereco      = tt-address.Street
                               loc-entr.bairro        = tt-address.District
                               loc-entr.cidade        = tt-address.City
                               loc-entr.estado        = tt-address.State
                               loc-entr.cep           = c-delivery-cep
                               loc-entr.pais          = tt-address.Country
                               loc-entr.cgc           = emitente.cgc
                               loc-entr.ins-estadual  = emitente.ins-estadual
                               loc-entr.nom-cidad-cif = tt-address.City.
                    END.
                END.
                ELSE DO:
                    ASSIGN v-rec-loc-entr = ROWID(loc-entr).
                END.
            END.
        END.
        ELSE DO:
           FIND FIRST loc-entr NO-LOCK
                WHERE loc-entr.nome-abrev  = emitente.nome-abrev 
                  AND loc-entr.cod-entrega BEGINS "padr" NO-ERROR.
           IF AVAIL loc-entr THEN
               ASSIGN v-rec-loc-entr = ROWID(loc-entr).
           ELSE
               ASSIGN v-rec-loc-entr = ?.
        END.

       FIND FIRST loc-entr NO-LOCK
            WHERE ROWID(loc-entr) = v-rec-loc-entr  NO-ERROR.
       IF AVAIL loc-entr THEN DO:
                       
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
              ASSIGN tt-ped-venda.nome-transp = 'RETIRA'.
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

           FOR FIRST transporte 
               WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
               ASSIGN tt-ped-venda.nome-transp = transporte.nome-abrev.
           END. 

           IF l-serv-loc-sales THEN
               ASSIGN tt-ped-venda.nome-transp = "Retira".

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

    RUN pi-gerar-dados-extrato (INPUT 'RETORNO COMPLETA PEDIDO:' ). 
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** crìdito nÒo aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
       RUN pi-erro (RowErrors.errorNumber, RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).

       RUN pi-gerar-dados-extrato (INPUT 'RETORNO COMPLETA PEDIDO: ' + STRING(RowErrors.errorNumber) + " " + RowErrors.ERRORDescription ). 

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
    
    RUN pi-gerar-dados-extrato (">> OBS SUSPENDE PEDIDO " + ped-venda.observacoes + " " + 
                                string(ped-venda.cod-sit-ped) + ' ' + string(ped-venda.cod-priori) + " FIM ").


    IF  (ped-venda.observacoes <> "" 
    AND ped-venda.cod-sit-ped <>  6) OR l-suspende-projeto THEN DO:

        RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao " + ped-venda.observacoes + " FIM ").

        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        for each ped-item of ped-venda
                where ped-item.cod-sit-item <= 2 exclusive-lock:
    
            RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao - ped item").
                for each ped-ent of ped-item
                    where ped-ent.cod-sit-ent <= 2 exclusive-lock:
    
                    RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao - ped ent").

                    assign ped-ent.cod-sit-ent  = 5
                           ped-ent.dt-suspensao = today
                           ped-ent.user-susp    = "Integra"
                           ped-ent.dt-usersusp  = today.
                end.

                assign ped-item.dt-suspensao = today
                       ped-item.user-susp    = "Integra"
                       ped-item.dt-usersusp  = today
                       ped-item.cod-sit-item = 5.
        end.
    
        assign ped-venda.dt-suspensao = today
               ped-venda.user-susp    = "Integra"
               ped-venda.dt-usersusp  = today
               ped-venda.desc-suspend = ped-venda.observacoes
               ped-venda.dt-useralt   = TODAY 
               ped-venda.user-alt     = "Integra"
               ped-venda.cod-sit-ped  = 5.

        RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao antes completar " + string(ped-venda.completo)).

        IF l-suspende-solar THEN
            ASSIGN ped-venda.completo = YES.

        RUN pi-gerar-dados-extrato  (INPUT "dentro suspensao depois completar " + string(ped-venda.completo)).

        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
       // RELEASE ped-venda.

    END.
END PROCEDURE.

procedure pi-erro:
  define input parameter p-cd-erro  as integer   no-undo.
  define input parameter p-mensagem as character no-undo.

    DEFINE VAR c-projeto-solar AS CHAR.
     
    IF origin MATCHES "*solar*" THEN
        ASSIGN c-projeto-solar = STRING(projectCode).
    ELSE
        ASSIGN c-projeto-solar = "".

    create tt-erro.
    assign iCount           = iCount + 1
           tt-erro.i-sequen = iCount
           tt-erro.cd-erro  = p-cd-erro 
           tt-erro.mensagem = p-mensagem + " " + c-projeto-solar.

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

PROCEDURE pi-fatura-pedido:

    DEFINE INPUT        PARAMETER c-nr-pedcli AS CHAR NO-UNDO.

    RUN pi-gerar-dados-extrato ("> INICIO pi-esftp016rp").

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.

    DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "esftp016":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli = c-nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        FIND FIRST tt-prog-ponto 
             WHERE entry(1,tt-prog-ponto.conteudo,";") = ped-venda.cod-estabel
               AND ENTRY(2,tt-prog-ponto.conteudo,";") = ped-venda.nat-operacao NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:

           FIND FIRST ser-estab NO-LOCK 
                WHERE ser-estab.serie       = entry(3,tt-prog-ponto.conteudo,";")      
                  AND ser-estab.cod-estabel = ped-venda.cod-estabel NO-ERROR.
          
           IF  AVAIL ser-estab AND ser-estab.dt-ult-fat < TODAY THEN DO:

               FIND CURRENT ser-estab EXCLUSIVE-LOCK.
               ASSIGN ser-estab.dt-ult-fat = TODAY.
               FIND CURRENT ser-estab NO-LOCK NO-ERROR.
               RELEASE ser-estab.

           END. 
        END. 

        RUN pi-gerar-dados-extrato ("> INICIO2 pi-esftp016rp").

        IF ped-venda.cod-priori <> 7 THEN DO:
            FOR EACH mgesp.ponto-programa NO-LOCK
               WHERE ponto-programa.nome-programa = "espdp006"
                 AND ponto-programa.ponto         = 11,  
                EACH mgesp.conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
               ASSIGN c-servidor = entry(1,conteudo-programa.conteudo, ";").
            END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

            /* Presa pelo faturamento comercial */
            DO TRANS:
                FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN ped-venda.cod-priori = 07 . 
            END.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.

            FOR EACH ped-item NO-LOCK
               WHERE ped-item.nome-abrev = ped-venda.nome-abrev
                 AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                IF ped-item.qt-log-aloc <> 0 or
                   ITEM.baixa-estoq = NO THEN DO:

                    CREATE tt-digita.
                    ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                           tt-digita.nr-pedcli      = ped-venda.nr-pedcli 
                           tt-digita.c-it-codigo    = ped-item.it-codigo    
                           tt-digita.c-cod-refer    = ped-item.cod-refer    
                           tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                END.
                ELSE DO:

                    FIND FIRST prod-composto WHERE prod-composto.it-codigo-filho = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL prod-composto THEN DO:

                        FIND FIRST ITEM WHERE ITEM.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                        IF AVAIL ITEM THEN DO:

                            IF item.baixa-estoq = NO THEN DO:
                                CREATE tt-digita.
                                ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                                       tt-digita.nr-pedcli      = ped-venda.nr-pedcli   
                                       tt-digita.c-it-codigo    = ped-item.it-codigo    
                                       tt-digita.c-cod-refer    = ped-item.cod-refer    
                                       tt-digita.i-nr-sequencia = ped-item.nr-sequencia 
                                       .
                            END. /* IF item.baixa-estoq = NO THEN DO: */
                        END. /* IF AVAIL ITEM THEN DO: */
                    END. /* IF AVAIL prod-composto THEN DO: */
                END.
            END.

            RUN pi-gerar-dados-extrato ("> INICIO3 pi-esftp016rp").

            create tt-param.
            assign tt-param.usuario     = c-seg-usuario
                   tt-param.destino     = 2
                   tt-param.data-exec   = today
                   tt-param.hora-exec   = time

                   tt-param.nome-abrev  = ped-venda.nome-abrev 
                   tt-param.nr-pedcli   = ped-venda.nr-pedcli 
                   tt-param.Cod-depos   = "wex"
                   tt-param.Localizacao = "".

            ASSIGN tt-param.arquivo = "esftp016rpFatCom_UNIX.tmp".

            RAW-TRANSFER tt-param TO raw-param.
            FOR each tt-digita NO-LOCK:
                create tt-raw-digita.
                raw-transfer tt-digita to tt-raw-digita.raw-digita.
            END.

            ASSIGN p_cod_prog_dtsul_w    = "esftp016rp"           
                   p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rp.p"
                   p_cod_release         = '2.00.00.000'                    
                   p_cdn_estil_dwb       = 97                   
                   p_arquivo             = "esftp016rpFatCom.tmp" 
                   p_destino             = 2                    
                   p_raw_param           = raw-param.  

            create tt_param_segur.
            assign tt_param_segur.tta_num_vers_integr_api      = 3
                   tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
                   tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)
                   tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
                   tt_param_segur.tta_cod_idiom_usuar          = "POR":U
                   tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
                   tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
                   tt_param_segur.tta_cod_usuar_corren         = tt-param.usuario
                   tt_param_segur.tta_cod_usuar_corren_criptog = ENCODE(tt-param.usuario).

            create tt_ped_exec.
            assign tt_ped_exec.tta_num_seq                = 1
                   tt_ped_exec.tta_cod_usuario            = tt-param.usuario
                   tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
                   tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
                   tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
                   tt_ped_exec.tta_dat_exec_ped_exec      = today
                   tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")
                   tt_ped_exec.tta_cod_servid_exec        = c-servidor
                   tt_ped_exec.tta_cdn_estil_dwb          = 97.

            create tt_ped_exec_param.
            assign tt_ped_exec_param.tta_num_seq              = 1
                   tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"
                   tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
                   tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

            raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.

            ASSIGN i-cont-aux = 0.
            FOR EACH tt-raw-digita NO-LOCK: 
                 ASSIGN i-cont-aux = i-cont-aux + 1.
                 CREATE tt_ped_exec_param_aux.
                 ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux
                        tt_ped_exec_param_aux.tta_num_seq            = 1
                        tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
            END.

            run btb/btb912zb.p (input-output table tt_param_segur,
                                input-output table tt_ped_exec,
                                input table tt_ped_exec_param,
                                input table tt_ped_exec_param_aux,
                                input table tt_ped_exec_sel).

            FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.
            IF AVAIL tt_ped_exec THEN DO TRANS:

                ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.

                FIND FIRST fat-comercial EXCLUSIVE-LOCK
                     WHERE fat-comercial.num-ped-exec = tt_ped_exec.tta_num_ped_exec
                       AND fat-comercial.nr-pedcli    = c-nr-pedcli  NO-ERROR.

                IF NOT AVAIL fat-comercial THEN DO:
                    CREATE fat-comercial.                          
                    ASSIGN fat-comercial.nr-sequencia    = 10 
                           fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME 
                           fat-comercial.nome-abrev      = ped-venda.nome-abrev
                           fat-comercial.nr-pedcli       = ped-venda.nr-pedcli 
                           fat-comercial.num-ped-exec    = tt_ped_exec.tta_num_ped_exec
                           fat-comercial.tipo            = 1.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    ASSIGN fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME.
                END.
                FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

            END. /* IF AVAIL tt_ped_exec THEN DO: */ 

            RUN pi-gerar-dados-extrato ("> INICIO4 pi-esftp016rp").

        END. /* IF ped-venda.cod-priori = 10 THEN DO: */

    END. /* IF AVAIL ped-venda THEN DO: */

END PROCEDURE.



