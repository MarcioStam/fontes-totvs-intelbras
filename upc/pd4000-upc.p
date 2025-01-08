/************************************************************************
**  Programa..: UPC\PD4000K-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Versao....: 001 16/11/2004
**                  Desenvolvimento Programa
**              002 26/12/2004 - Robson Jeorge Moser - Gestech
                    InclusÆo das upc's para a rotina de comiss’o de
                    representantes que serÆo utilizadas na tela de
                    servi‡o Instala»’o/Vendor e atualiza»’o do valor
                    da comiss’o do representante conforme tabela 
                    espec­fica do magnus.
**              003 24/02/2005 - Ivan G. Steinbach - DTS Logistica
**                  Criado tratamento para setar valores default na
**                  tela de parametros do PD4000 (PD4000B).
**                  pi-seta-parametros
**              004 06/03/2014 - Rubia Ayabe - SENSUS
**                  Retirei a tratativa do envio de e-mail
**              005 21/09/2022 - Mauricio C. - iDBA
**                  substitui‡Æo do Integrador pela Origem
**                  Adi»’o campos Complementos2
**              006 05/07/2023 - Bruno Joaquim IDBA - Adicionado campos wh-desc-neg-comercial 
                    e wh-desc-comercial, bem como suas tratativas para controle na composisÆo 
                    do desconto informado para os clientes que possuem o int-emitente.sales-force = yes.
**              007 14/03/2023 - Bruno Joaquim IDBA - M2305-132 -  Adicionado wh-bt-local-entrega-alternativo-pd4000 
                    para adicionar a obervacao da NF o local de entraga alternativo do cliente                    
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd     AS INTEGER.
DEFINE VARIABLE h-bodi317im1br    AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-perc-icms      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-msg138a         AS HANDLE    NO-UNDO.
DEFINE VARIABLE p-indice-financiamento AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-reativa-suspente AS LOG NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE l-confirma-dt-base-pd4000 AS LOG.
DEFINE VARIABLE raw-param          AS RAW NO-UNDO.
DEFINE VARIABLE v_log_nat_deps     AS LOG NO-UNDO.

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-origem-inegr AS INT /*1 - Pedido, 2 - Faturamento, 3 - Atualiza saldo*/.

DEFINE TEMP-TABLE tt-pedidosItens NO-UNDO  
    FIELD nome-abrev    LIKE ped-item.nome-abrev  
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli   
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD it-codigo     LIKE ped-item.it-codigo   
    FIELD cod-refer     LIKE ped-item.cod-refer   
    FIELD vl-preoriOld  LIKE ped-item.vl-preori   
    FIELD vl-preoriNew  LIKE ped-item.vl-preori
    FIELD c-Status      AS CHAR FORMAT 'X(150)'.

{esp/es0018.i}
{esp/esb/esesb000.i}
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-prog-ponto-nat-oper NO-UNDO LIKE tt-prog-ponto.

DEFINE TEMP-TABLE tt-int-ped-item-pci LIKE int-ped-item-pci.

{esp/esb/esesb007-solicita.i1}

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

/*usada para quebrar o calculo de Pre‡os para NÆo estourar o longchar*/
DEFINE TEMP-TABLE ProdutoItemR-temp LIKE ProdutoItemR.
    
DEFINE NEW GLOBAL SHARED TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Solu»’o */

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

DEFINE VARIABLE c-cod-transp      LIKE transporte.cod-trans        NO-UNDO.
DEFINE VARIABLE c-sigla-transp    LIKE def-transportes.sigla-trans NO-UNDO.
DEFINE VARIABLE c-nome-transp     LIKE transporte.nome-abrev       NO-UNDO.
DEFINE VARIABLE c-nome-transp-aux LIKE transporte.nome-abrev       NO-UNDO.
DEFINE VARIABLE c-cod-entrega-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-valida-natureza AS LOGICAL     NO-UNDO.
DEFINE VARIABLE perc-desc-comercial AS DEC.
DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame2  AS HANDLE          NO-UNDO.
DEF VAR h-frame3  AS HANDLE          NO-UNDO.
DEFINE VARIABLE h-boes505 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nat-oper AS CHARACTER   NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF var wh-frame0 as widget-handle no-undo.
DEF var wh-frame1 as widget-handle no-undo.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
DEF var wgh-grupo     as widget-handle no-undo.
DEF var wgh-grupo2    as widget-handle no-undo.
/* DEF var wh-button-prod-composto     as widget-handle no-undo. */
DEF var wh-button-perc-segmento     as widget-handle no-undo.
DEF var wh-button-espdp079     as widget-handle no-undo.
DEF var wh-button-transfere as widget-handle no-undo.
DEF var wh-window     as widget-handle no-undo.
DEF var wgh-child     as widget-handle no-undo.
DEFINE VARIABLE de-valor   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cDestino   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDescEmail AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAssunto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRemetente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-valor-item AS DEC      NO-UNDO.
DEFINE VARIABLE l-ind-icm-ret AS LOG      NO-UNDO.

DEF VAR de-indice-finan AS DECIMAL DECIMALS 5.
DEF VAR de-fator-cli    AS DECIMAL.
DEF VAR d-fator         AS DECIMAL.
DEF VAR de-preco-venda  AS DECIMAL.
DEF VAR de-perc-desc    AS DECIMAL.
DEF VAR de-desco-qt     AS DECIMAL.
DEF VAR l-atual         AS LOG.
DEFINE VARIABLE h-bodi159cal            as handle         no-undo.

DEFINE VARIABLE l-return AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-mensagem-transp AS LOGICAL INITIAL YES     NO-UNDO.
{upc/btb910za-upc.i}
{utp/ut-glob.i}
{utp/utapi019.i}
def new global shared var wh-combo                      as widget-handle no-undo. 
define new global shared var whit-codigo                as widget-handle no-undo.
define new global shared var whqt-pedida                as widget-handle no-undo.
define new global shared var whvl-preuni                as widget-handle no-undo.
define new global shared var wh-bt-calcula-preco        as widget-handle no-undo.
define new global shared var wh-bt-receita-recorrente   as widget-handle no-undo.
define new global shared var wh-atualiza-preco          as widget-handle no-undo.
define new global shared var wh-espdp027                as widget-handle no-undo.
define new global shared var whNomeTransp               as widget-handle no-undo.
define new global shared var whdes-pct-desconto-inform  as widget-handle no-undo.
define new global shared var l-mudou-cod-priori-pd4000  AS LOGICAL     NO-UNDO.

/* Variaveis Botoes de Tela - Padrao */
DEF new global shared VAR wh-btDeleteOrder                       as widget-handle no-undo.  
DEF new global shared VAR wh-btCancelOrder-pd4000                as widget-handle no-undo.  
DEF new global shared VAR wh-btCancelationItem-pd4000            as widget-handle no-undo.
DEF new global shared VAR wh-btCancelationOrder-pd4000           as widget-handle no-undo.
DEF new global shared VAR wh-btDeleteOrder-pd4000                as widget-handle no-undo.
DEF new global shared VAR wh-btDeleteItem-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-btUpdateItem-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-btUpdateOrder-pd4000                as widget-handle no-undo.
DEF new global shared VAR wh-btOrderFunctions-pd4000             as widget-handle no-undo.
DEF new global shared VAR wh-bt-confirma-item-pd4000             as widget-handle no-undo.  
DEF new global shared VAR wh-bt-confirma-item-novo-pd4000        as widget-handle no-undo.  
DEF new global shared VAR wh-bt-cancelar-item-pd4000             as widget-handle no-undo.  
DEF new global shared VAR wh-bt-cancelar-item-novo-pd4000        as widget-handle no-undo.  
DEF new global shared VAR wh-btdelivery-pd4000                   as widget-handle no-undo.
DEF new global shared VAR wh-btdelivery-aux-pd4000               as widget-handle no-undo.
DEF new global shared VAR wh-combo-modal-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-gpon-pd4000                         as widget-handle no-undo.
DEF new global shared VAR wh-bt-local-entrega-alternativo-pd4000 as widget-handle no-undo.


DEF new global shared VAR whqt-un-fat                            as widget-handle no-undo.
DEF new global shared VAR whval-desconto-inform-pd4000           as widget-handle no-undo.
DEF new global shared VAR whval-desconto-inform-fpage6-pd4000    as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage1-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage6-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage8-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage10-pd4000                as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage13-pd4000                as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage19-pd4000                as widget-handle no-undo.
DEF new global shared VAR wh-frame-fpage3-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-nome-abrev-tri-pd4000               as widget-handle no-undo.
DEF new global shared VAR wh-nome-transp-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-nat-operacao-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-cod-entrega-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-cod-entrega-aux-pd4000              as widget-handle no-undo.
DEF new global shared VAR tx-cod-entrega-aux-pd4000              as widget-handle no-undo.
DEF new global shared VAR wh-nat-operacao-item-pd4000            as widget-handle no-undo.
DEF new global shared VAR wh-it-codigo-pd4000                    as widget-handle no-undo.
DEF new global shared VAR wh-dt-entrega-pd4000                   as widget-handle no-undo.
DEF new global shared VAR wh-dt-entrega-page3-pd4000             as widget-handle no-undo.
DEF new global shared VAR wh-dt-entorig-pd4000                   as widget-handle no-undo.
DEF new global shared VAR wh-dt-entrega3-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-dt-entorig3-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-dt-entrega13-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-dt-entorig13-pd4000                 as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-dt-entorig-item-pd4000              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-entorig3-item-pd4000             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-entorig13-item-pd4000            AS WIDGET-HANDLE NO-UNDO.
DEF new global shared VAR wh-cod-cond-pag-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-nome-abrev-pd4000                   as widget-handle no-undo.
DEF new global shared VAR wh-cond-redespa-pd4000                 as widget-handle no-undo.
DEF new global shared VAR wh-nr-pedcli-pd4000                    as widget-handle no-undo.
DEF new global shared VAR wh-cod-canal-venda-pd4000              as widget-handle no-undo.
DEF new global shared VAR wh-perc-desco1-pd4000                  as widget-handle no-undo.
DEF new global shared VAR wh-cidade-cif-pd4000                   as widget-handle no-undo.
DEF new global shared VAR whnr-sequencia-pd4000                  as widget-handle no-undo.  
DEF new global shared VAR whcb-cod-des-mer-pd4000                as widget-handle no-undo.  
DEF new global shared VAR wh-cod-rota-pd4000                     as widget-handle no-undo.
DEF new global shared VAR wh-button-espdp079-pd4000              as widget-handle no-undo.
DEF new global shared VAR wh-cb-frame-pd4000                     as widget-handle no-undo.
DEF new global shared VAR wh-libera-preco-canais-pd4000          as widget-handle no-undo.
DEF new global shared VAR wh-val-pct-desconto-tab-preco-pd4000   as widget-handle no-undo.
DEF new global shared VAR wh-des-pct-desconto-inform-pd4000      as widget-handle no-undo.
DEF new global shared VAR wh-perc-desco1-pd4000                  as widget-handle no-undo.


DEFINE new global shared var c-tp-pedido-anterior-pd4000   AS CHAR      NO-UNDO.

def new global shared var l-implanta as logical init no.
def new global shared var adm-broker-hdl as handle no-undo.

DEF new global shared VAR wh-c-cod-modalid-frete-pd4000 as widget-handle no-undo.  
DEF NEW GLOBAL SHARED VAR h-pd4000-upc                   as widget-handle no-undo.  

DEF VAR whCodEstabel                                AS HANDLE          NO-UNDO.
DEF VAR h-upc-pd4000-upc                            AS HANDLE NO-UNDO.
DEFINE VARIABLE i-cod-cond-pag-antes                AS INTEGER     NO-UNDO.
DEF BUFFER b-int-cond-pagto                         FOR int-cond-pagto.
def buffer b-repres                                 for repres.
DEF BUFFER bf-Pedido                                FOR ped-venda.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/") NO-ERROR.

/* temp-table para setar parametros do PD4000B */
DEFINE TEMP-TABLE tt-ped-param NO-UNDO
    FIELD relacao-item-cli     AS LOG INIT YES 
    FIELD tp-relacao-item-cli  AS INT INIT 1
    FIELD qtde-un-medida-cli   AS LOG INIT YES 
    FIELD multiplicar-qtde     AS LOG INIT YES 
    FIELD atribuir-preco-comp  AS LOG INIT NO 
    FIELD tp-exp-nat-oper      AS INT INIT 1
    FIELD tp-exp-dt-entrega    AS INT INIT 1
    FIELD exp-nat-cons-final   AS LOG INIT NO 
    FIELD exp-nat-cod-mensagem AS LOG INIT NO 
    FIELD atualizar-entregas   AS LOG INIT YES 
    FIELD arredondar-qtde-lote AS LOG INIT NO 
    FIELD gerar-proc-exp       AS LOG INIT NO 
    FIELD itinerario           AS INT.

/* esta temp-table ainda nao e usada*/
/* sera usada quando a DTS liberar a atualizacao da TT via UPC do PD4000 */
DEFINE TEMP-TABLE tt-ped-param2 NO-UNDO
    field tp-exp-local-entrega  as int  init 2 /* tipo exportacao local entrega */
    field tp-exp-tb-preco       as int  init 2 /* tipo exportacao tabela preco */
    field exp-desc-tab-preco    as log  init no /*Atualizar Desconto Tab Precos */
    field log-livre-1           as log
    field log-livre-2           as log
    field log-livre-3           as log
    field int-livre-1           as int
    field int-livre-2           as int
    field int-livre-3           as int
    field dec-livre-1           as dec
    field char-livre-1          as char.

/****************************  Variaveis    ****************************/
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ped-item       AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whTgLimpaDesc     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalAdd      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtAddOrder      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR vLogLimpaDesc     AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogCopiaPedido   AS LOGICAL       NO-UNDO.

/* UPC da rotina de comiss’o de representantes */
DEF NEW GLOBAL SHARED VAR whbtAddServInst              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddServInst-new          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whPedCli                     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtDeleteRepresentative     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtDeleteRepresentative-new AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative-new    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFinome-ab-rep              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFinome-ab-rep-new          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFiperc-comis               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFinome-abrev               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFidt-implant               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFidt-emissao               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative-new    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR vProgOrigemPD4000            AS LOGICAL       NO-UNDO.

DEF NEW GLOBAL SHARED VAR whlb-cod-emitente            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-desc-comercial          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-seq-bon                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-tipo-faturamento        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-emitente              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-comercial            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tipo-faturamento          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-priori-orig             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-priori-orig               AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-tp-pedido-pd4000          AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-des-unid-negoc-pd4000     AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-priori-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-vl-frete-pd4000           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-vl-frete-pd4000           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-grupo-canais-pd4000       AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-grupo-canais-pd4000       AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-troca-nf-pd4000           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-rec-frete-pd4000          AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-rec-pci-pd4000        as widget-handle   no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wh-rec-pci-pd4000            as widget-handle   no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE tx-origem-pd4000 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-origem-pd4000 AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-estab-atend-pd4000        AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-desc-estab-atend-pd4000   AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-estab-central-pd4000      AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-desc-estab-central-pd4000 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-data-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-dias-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dias-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whNomeAbrev                  AS WIDGET-HANDLE   NO-UNDO. 

DEF NEW GLOBAL SHARED VAR r-rowid-pd4000                       AS ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-save-ord                       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-save-ord-new                   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcompleteorder-ped4000-new       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcompleteorder-ped4000           AS WIDGET-HANDLE NO-UNDO.
/***DEF NEW GLOBAL SHARED VAR wh-btCopyOrder-pd4000-new            AS WIDGET-HANDLE NO-UNDO.***/
DEF NEW GLOBAL SHARED VAR wh-btCopyOrder-pd4000                AS WIDGET-HANDLE NO-UNDO.
/* Trava ASTEC - NÆo permitir InclusÆo de itens pelo PD4000 para pedidos ASTEC */
DEFINE NEW GLOBAL SHARED VARIABLE wh-btAddItem-pd4000        AS WIDGET-HANDLE   NO-UNDO. 
/* DEFINE NEW GLOBAL SHARED VARIABLE wh-btAddItem-novo-pd4000   AS WIDGET-HANDLE   NO-UNDO. */

def var wh-btsaldo as widget-handle no-undo.
def var wh-it-codigo as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR l-inclusao-pd4000 AS LOGICAL     NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-busca-transportadora AS LOGICAL     NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-cod-entrega-item-pd4000      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-nr-os-pd4000               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-os-pd4000                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-id-projeto-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-add-nr-os-pd4000              AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-refer-pd4000             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-unid-negoc-pd4000        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-cod-repres-pd4000        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-repres-pd4000            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-no-ab-reppri-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-cod-segmento-pd4000      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-segmento-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-segmento-pd4000         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-neg-comercial       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-neg-comercial           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-topmilhao-pd4000    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-topmilhao-pd4000        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-maisverde-pd4000    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-maisverde-pd4000        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-focounidade-pd4000  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-focounidade-pd4000      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-distrib20-pd4000    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-distrib20-pd4000        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-desc-widecloud-pd4000    AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-desc-widecloud-pd4000        AS WIDGET-HANDLE NO-UNDO. 

DEF NEW GLOBAL SHARED VAR wh-txt-desc-kit-pd4000          AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-desc-kit-pd4000              AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-txt-desc-qtde-pd4000         AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-desc-qtde-pd4000             AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-txt-desc-comercial-pd4000    AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-desc-comercial-pd4000        AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-txt-tabpre-pd4000            AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-tabpre-pd4000                AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-txt-segmento-pd4000          AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-segmento-pd4000              AS WIDGET-HANDLE NO-UNDO. 

DEF NEW GLOBAL SHARED VAR whlb-cd-unid-comerc-pd4000      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cd-unid-comerc-pd4000        AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR whlb-po-cliente-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-po-cliente-pd4000            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-contrato-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-contrato-pd4000            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-pedido-origem-pd4000     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-estabel-pd4000           AS WIDGET-HANDLE NO-UNDO.

/* Tratativa Supervisor */
DEF NEW GLOBAL SHARED VAR l-transp-checked                AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-gpon-checked                  AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-supervisor-pd4000            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whlb-supervisor-pd4000          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-repres-pd4000           AS WIDGET-HANDLE NO-UNDO.
DEF VARIABLE              wh-button-supervisor            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE l-supervisorSave        AS LOGICAL  INIT  NO   NO-UNDO.
DEFINE VARIABLE c-unidadeNegocioPedido  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-supervisorItem        AS CHARACTER   NO-UNDO.

/* OUTPUT TO VALUE("C:\temp\" + c-seg-usuario + "eventos-pd4000.txt":U) APPEND. */
/* PUT UNFORMATTED                                                              */
/*     "Evento.......: ":U p-ind-event         SKIP                             */
/*     "Objeto.......: ":U p-ind-object        SKIP                             */
/*     "Nome Objeto..: ":U c-objeto            SKIP                             */
/*     "Frame........: ":U p-wgh-frame         SKIP                             */
/*     "Tabela.......: ":U p-cod-table         SKIP                             */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                             */
/*     FILL("-":U, 50)                         SKIP.                            */
/* OUTPUT CLOSE.                                                                */

/* MESSAGE  "Evento.......: ":U p-ind-event         SKIP */
/*          "Objeto.......: ":U p-ind-object        SKIP */
/*          "Nome Objeto..: ":U c-objeto            SKIP */
/*          "Frame........: ":U p-wgh-frame         SKIP */
/*          "Tabela.......: ":U p-cod-table         SKIP */
/*          "Rowid........: ":U STRING(p-row-table) SKIP */
/*          FILL("-":U, 50)                              */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                */

/*RUN piMessage.*/

ASSIGN c-unidadeNegocioPedido = ''.

IF  VALID-HANDLE(wh-btcompleteorder-ped4000) 
AND VALID-HANDLE(wh-btcompleteorder-ped4000-new) THEN DO:
    wh-btcompleteorder-ped4000-new:LOAD-IMAGE(wh-btcompleteorder-ped4000:IMAGE).                                           
    wh-btcompleteorder-ped4000-new:LOAD-IMAGE-INSENSITIVE(wh-btcompleteorder-ped4000:IMAGE-INSENSITIVE).               
END.

/*
IF  VALID-HANDLE(wh-btCopyOrder-pd4000) 
AND VALID-HANDLE(wh-btCopyOrder-pd4000-new) THEN DO:
    wh-btCopyOrder-pd4000-new:LOAD-IMAGE(wh-btCopyOrder-pd4000:IMAGE).                                           
    wh-btCopyOrder-pd4000-new:LOAD-IMAGE-INSENSITIVE(wh-btCopyOrder-pd4000:IMAGE-INSENSITIVE).               

    ASSIGN wh-btCopyOrder-pd4000:SENSITIVE = NO.

END.
*/
IF  p-ind-event = "pi-enable" 
AND valid-handle(wh-bt-save-ord-new) THEN  DO:

    ASSIGN l-confirma-dt-base-pd4000 = NO.

    ASSIGN wh-bt-save-ord-new:SENSITIVE         = wh-bt-save-ord:SENSITIVE.
/*     IF  VALID-HANDLE(wh-origem-pd4000) THEN                             */
/*         wh-origem-pd4000:SENSITIVE          = wh-bt-save-ord:SENSITIVE. */
    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE   = wh-bt-save-ord:SENSITIVE.
END.           


IF  p-ind-event = "afterdisplayorder" 
AND valid-handle(wh-bt-save-ord-new) THEN DO:
    ASSIGN wh-bt-save-ord-new:SENSITIVE         = wh-bt-save-ord:SENSITIVE.
/*     IF  VALID-HANDLE(wh-origem-pd4000) THEN                             */
/*         wh-origem-pd4000:SENSITIVE          = wh-bt-save-ord:SENSITIVE. */
    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE   = wh-bt-save-ord:SENSITIVE.
END.


IF  p-ind-event = "AFTERCLICKTREEVIEW" THEN DO:
    IF VALID-HANDLE(wh-btcompleteorder-ped4000) THEN DO:
        ASSIGN wh-btcompleteorder-ped4000:VISIBLE = NO.
    END.
    RETURN "OK":U.
END.

IF valid-handle(tx-grupo-canais-pd4000) THEN
    ASSIGN tx-grupo-canais-pd4000:SCREEN-VALUE     = "Gr.Canais:":U  .

IF p-ind-event = "AFTER-BTADDORDER" THEN DO :

    IF  valid-handle(tx-vl-frete-pd4000            ) and
        valid-handle(tx-origem-pd4000              ) and
        valid-handle(tx-data-negoc-pd4000          ) and
        valid-handle(tx-dias-negoc-pd4000          ) and
        valid-handle(whlb-nr-os-pd4000             ) and
        valid-handle(whlb-cod-emitente             ) and
        valid-handle(whlb-cd-unid-comerc-pd4000    ) and 
        valid-handle(tx-cod-entrega-aux-pd4000     ) and 
        valid-handle(whlb-po-cliente-pd4000        ) and 
        valid-handle(whlb-contrato-pd4000          ) and 
        valid-handle(whlb-supervisor-pd4000        ) and 
        valid-handle(tx-grupo-canais-pd4000        ) THEN

    ASSIGN tx-vl-frete-pd4000:SCREEN-VALUE             = "Valor Frete: "
           tx-origem-pd4000:SCREEN-VALUE               = "Origem: "
           tx-data-negoc-pd4000:SCREEN-VALUE           = "Data Negociacao:"
           tx-dias-negoc-pd4000:SCREEN-VALUE           = "Dias Negociacao:"
           whlb-nr-os-pd4000:SCREEN-VALUE              = "Nro OS:"
           whlb-cod-emitente:SCREEN-VALUE              = "Cliente:"
           whlb-cd-unid-comerc-pd4000:SCREEN-VALUE     = "Unid. Comercial:"
           tx-cod-entrega-aux-pd4000:SCREEN-VALUE      = "Local Entrega:":U
           whlb-po-cliente-pd4000:SCREEN-VALUE         = "PO Cliente:":U 
           whlb-contrato-pd4000:SCREEN-VALUE          = "Contrato:":U 
           whlb-supervisor-pd4000:SCREEN-VALUE         = "Supervisor:":U  
           tx-grupo-canais-pd4000:SCREEN-VALUE         = "Gr.Canais:":U. 

    IF VALID-HANDLE(wh-cb-frame-pd4000) THEN
        ASSIGN wh-cb-frame-pd4000:SCREEN-VALUE = "Principal":U.

    APPLY "VALUE-CHANGED":U TO wh-cb-frame-pd4000.

    APPLY "Entry":U TO wh-nome-abrev-pd4000.

    IF VALID-HANDLE(whlb-id-projeto-pd4000) THEN DO:
        ASSIGN whlb-id-projeto-pd4000:SCREEN-VALUE = "ID Projeto".
    END.

    RETURN "OK":U.
END.



IF  p-ind-event = "AFTER-BTADDORDER" AND VALID-HANDLE(wh-origem-pd4000) THEN DO:
/*     ASSIGN wh-origem-pd4000:SENSITIVE = YES. */
    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE   = YES.
END.

IF  p-ind-event = "AfterValueChangeCbFrame" THEN DO:


    IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN DO:
        IF VALID-HANDLE(wh-nr-pedcli-pd4000) THEN DO:

            FIND FIRST ped-venda
                WHERE ped-venda.nr-pedcli = TRIM(wh-nr-pedcli-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
            IF AVAILABLE ped-venda THEN DO:

                IF (wh-grupo-canais-pd4000:SCREEN-VALUE = '0' 
                OR  wh-grupo-canais-pd4000:SCREEN-VALUE = '' 
                OR  wh-grupo-canais-pd4000:SCREEN-VALUE = ?) THEN DO:

                    FIND FIRST atendente WHERE atendente.cd-oper = integer(wh-tp-pedido-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
                    IF AVAIL atendente THEN DO:
                        IF atendente.cod-gr-canais <> 0 THEN
                            ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(atendente.cod-gr-canais).
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                FIND FIRST grupo-canais-clientes
                                    WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                                IF AVAIL grupo-canais-clientes THEN
                                    ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                            END.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            FIND FIRST grupo-canais-clientes
                                WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                            IF AVAIL grupo-canais-clientes THEN
                                ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                        END.
                    END.

                END.

                FIND FIRST int-ped-venda2
                    WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                IF AVAIL int-ped-venda2 THEN DO:
                    IF int-ped-venda2.int-1 <> 0 THEN
                        ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(int-ped-venda2.int-1).

                END.

                IF VALID-HANDLE(wh-priori-orig) THEN DO:
                    ASSIGN wh-priori-orig:SCREEN-VALUE = "".
                    FIND FIRST int-ped-venda
                         WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                    IF AVAIL int-ped-venda THEN DO:
                        IF int-ped-venda.cod-priori-orig <> ? THEN
                            ASSIGN wh-priori-orig:SCREEN-VALUE = STRING(int-ped-venda.cod-priori-orig,"99").
                    END.
                END.

            END. /* IF AVAILABLE ped-venda THEN DO: */
            ELSE DO:

                IF  VALID-HANDLE(wh-nome-abrev-pd4000) THEN DO:

                    IF (wh-grupo-canais-pd4000:SCREEN-VALUE = '0' 
                    OR  wh-grupo-canais-pd4000:SCREEN-VALUE = '' 
                    OR  wh-grupo-canais-pd4000:SCREEN-VALUE = ?) THEN DO:

                        FIND FIRST atendente WHERE atendente.cd-oper = integer(wh-tp-pedido-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
                        IF AVAIL atendente THEN DO:
                            IF atendente.cod-gr-canais <> 0 THEN
                                ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(atendente.cod-gr-canais).
                            ELSE DO:
                                FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                                IF AVAIL emitente THEN DO:
                                    FIND FIRST grupo-canais-clientes
                                        WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                                    IF AVAIL grupo-canais-clientes THEN
                                        ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                                END.
                            END.
                        END.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                FIND FIRST grupo-canais-clientes
                                    WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                                IF AVAIL grupo-canais-clientes THEN
                                    ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                            END.
                        END.

                    END. /* IF (wh-grupo-canais-pd4000:SCREEN-VALUE = '0'  */

                END.

            END.
        END. /* IF VALID-HANDLE(wh-nr-pedcli-pd4000) THEN DO: */
    END. /* IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN DO: */

    RETURN "OK":U.

END.
IF  p-ind-object = "CONTAINER" 
AND p-ind-event = "BEFORE-DISPLAY" THEN DO:
    FIND ped-venda
        where rowid(ped-venda) = p-row-table no-lock no-error.

    FIND FIRST int-ped-venda
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

    ASSIGN l-gpon-checked = IF AVAIL int-ped-venda THEN int-ped-venda.log-gpon ELSE NO.
         
    IF AVAIL ped-venda THEN DO:
        FIND FIRST int-ped-trans  NO-LOCK 
            WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel
              AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
              AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli NO-ERROR.
    
        IF AVAIL int-ped-trans  THEN
            ASSIGN l-transp-checked = int-ped-trans.lot-transp.
        ELSE ASSIGN l-transp-checked = NO.
    END.
END.

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    IF  VALID-HANDLE (wh-dt-entrega-pd4000) THEN
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atencao, ja existe uma Tela do PD4000 aberta em sua sessao EMS, favor fechar a tela recem aberta. ~~ " +
                                 "Por restricoes tecnicas, nao e possivel trabalhar com mais de uma tela do PD4000 na mesma sessao do EMS.").

    IF  NOT VALID-HANDLE(h-pd4000-upc) THEN
        RUN upc/pd4000-upc.p PERSISTENT SET h-pd4000-upc(INPUT "",            
                                                         INPUT "",            
                                                         INPUT p-wgh-object,  
                                                         INPUT p-wgh-frame,   
                                                         INPUT "",            
                                                         INPUT p-row-table).
END.



if  p-ind-event = "pi-enable"         or
    p-ind-event = "BEFORE-INITIALIZE" then do:
    ASSIGN l-inclusao-pd4000 = NO.
END.



if p-ind-event = "btAddOrder" then do:
    ASSIGN l-inclusao-pd4000 = yes.
END.



if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):
                   
       if h-frame:type = "button" and h-frame:name = "btfirst" then
           leave.  

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end. 


    if  h-frame:type = "button" and h-frame:name = "btfirst" then do:
        create button wh-button-espdp079
        assign frame     = h-frame:FRAME
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 33.3
               visible   = yes
               sensitive = yes
               tooltip   = "Cria Pedido de Or»amento atrav‚s de Planilha".

        if wh-button-espdp079:load-image("image/gr-lay.bmp") then.
        on "choose" of wh-button-espdp079  persistent run esp/pdp/espdp079.w.

        
        CREATE  BUTTON wh-bt-calcula-preco
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 10.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 37.3
               VISIBLE   = yes
               SENSITIVE = yes
               TOOLTIP   = "Calcula Precos Canais".

        IF VALID-HANDLE(h-pd4000-upc) THEN ON "CHOOSE" OF  wh-bt-calcula-preco  persistent run cria-cash IN h-pd4000-upc.

        /*IDBA BRUNO*/
        CREATE  BUTTON wh-bt-receita-recorrente
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 57
               VISIBLE   = yes
               SENSITIVE = yes
               TOOLTIP   = " Receita Recorrente".
        wh-bt-receita-recorrente:LOAD-IMAGE ( 'image/dolar2.bmp' ).

        IF VALID-HANDLE(h-pd4000-upc) THEN ON "CHOOSE" OF  wh-bt-receita-recorrente  persistent run pi-bt-receita-recorrente IN h-pd4000-upc.


        CREATE  BUTTON wh-atualiza-preco
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 61
               VISIBLE   = yes
               SENSITIVE = yes
               LABEL     = "Atualiza Pre‡os"
               TOOLTIP   = "Atualiza Pre‡os".

        IF VALID-HANDLE(h-pd4000-upc) THEN ON "CHOOSE" OF wh-atualiza-preco  persistent run pi-atualiza-preco IN h-pd4000-upc.

        wh-atualiza-preco:LOAD-IMAGE ( 'image/ii-orcto.bmp' ).

        CREATE  BUTTON wh-espdp027
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 65
               VISIBLE   = yes
               SENSITIVE = yes
               LABEL     = "espdp027"
               TOOLTIP   = "espdp027".

        IF VALID-HANDLE(h-pd4000-upc) THEN ON "CHOOSE" OF wh-espdp027  persistent run pi-espdp027 IN h-pd4000-upc.

        wh-espdp027:LOAD-IMAGE ( 'image/im-send.bmp' ).
        
    END.
END.




if p-ind-event = "AFTER-INITIALIZE" then do:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    
    do while valid-handle(h-frame):
        
        if h-frame:type = "frame" and h-frame:name = "fpage3" then
            leave.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end.    
END.


if p-ind-event = "AFTER-INITIALIZE" then do:

    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'frame':U,
                         input 'fPage10':U,
                         input NO,
                         output wh-frame-fpage10-pd4000).

    IF  VALID-HANDLE(wh-frame-fpage10-pd4000) THEN DO:

        CREATE TEXT whlb-id-projeto-pd4000
        ASSIGN FRAME        = wh-frame-fpage10-pd4000
               WIDTH        = 50
               FORMAT       = "x(50)":U
               SCREEN-VALUE = "ID Projeto"
               ROW          = 4.7
               COLUMN       = 2
               VISIBLE      = YES.
    END.
    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "fpage0" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nome-abrev':U,
                             input NO,
                             output wh-nome-abrev-pd4000).

        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nr-pedcli':U,
                             input NO,
                             output wh-nr-pedcli-pd4000).

        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nome-abrev':U,
                             input NO,
                             output whnomeabrev).

        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'combo-box':U,
                             input 'cb-frame':U,
                             input NO,
                             output wh-cb-frame-pd4000).

        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'frame':U,
                             input 'fPage1':U,
                             input NO,
                             output wh-frame-fpage1-pd4000).

        IF  VALID-HANDLE(wh-frame-fpage1-pd4000) THEN
            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtCompleteOrder':U,
                                 input NO,
                                 output  wh-btcompleteorder-ped4000).

        IF  VALID-HANDLE(wh-frame-fpage1-pd4000) THEN
            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtSaveOrder':U,
                                 input NO,
                                 output wh-bt-save-ord).

        IF VALID-HANDLE (wh-bt-save-ord) THEN DO:
            ON 'CHOOSE':U OF wh-bt-save-ord PERSISTENT RUN pi-choose-bt-save-ord IN h-pd4000-upc. 
        END.

        IF  VALID-HANDLE(wh-frame-fpage1-pd4000) THEN DO:
        
            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtCancelOrder':U,
                                 input NO,
                                 output wh-btCancelOrder-pd4000).

        END.

        IF  VALID-HANDLE(wh-frame-fpage1-pd4000) THEN DO:
        
/*             run pi-busca-handle (input wh-frame-fpage1-pd4000, */
/*                               input p-ind-event,               */
/*                               input 'button':U,                */
/*                               input 'BtCopyOrder':U,           */
/*                               input NO,                        */
/*                               output wh-btCopyOrder-pd4000).   */

            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtCancelationOrder':U,
                                 input NO,
                                 output wh-btCancelationOrder-pd4000).
            IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btCancelationOrder-pd4000 PERSISTENT RUN pi-btCancelationOrder-pd4000 IN h-pd4000-upc. 
       
            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                             input p-ind-event,
                             input 'button':U,
                             input 'BtUpdateOrder':U,
                             input NO,
                             output wh-btUpdateOrder-pd4000).
            IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btUpdateOrder-pd4000 PERSISTENT RUN pi-btUpdateOrder-pd4000 IN h-pd4000-upc.         

            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtOrderFunctions':U,
                                 input NO,
                                 output wh-btOrderFunctions-pd4000).
            IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btOrderFunctions-pd4000 PERSISTENT RUN pi-btOrderFunctions-pd4000 IN h-pd4000-upc.         
            

            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'BtDeleteOrder':U,
                                 input NO,
                                 output wh-btdeleteOrder-pd4000).
            IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btDeleteOrder-pd4000 PERSISTENT RUN pi-btDeleteOrder-pd4000 IN h-pd4000-upc. 
           
        END.        
        
        IF  VALID-HANDLE (wh-btcompleteorder-ped4000) THEN DO:
            CREATE BUTTON  wh-btcompleteorder-ped4000-new
            ASSIGN FRAME        = wh-frame-fpage1-pd4000
                   WIDTH        = wh-btcompleteorder-ped4000:WIDTH
                   HEIGHT       = wh-btcompleteorder-ped4000:HEIGHT
                   ROW          = wh-btcompleteorder-ped4000:ROW 
                   LABEL        = wh-btcompleteorder-ped4000:LABEL
                   COLUMN       = wh-btcompleteorder-ped4000:COLUMN
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   TOOLTIP      = wh-btcompleteorder-ped4000:TOOLTIP
                TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-btcompleteorder-ped4000-new IN h-pd4000-upc. /***!!**/
                END TRIGGERS.

             wh-btcompleteorder-ped4000-new:LOAD-IMAGE(wh-btcompleteorder-ped4000:IMAGE).                                           
             wh-btcompleteorder-ped4000-new:LOAD-IMAGE-INSENSITIVE(wh-btcompleteorder-ped4000:IMAGE-INSENSITIVE).               
             wh-btcompleteorder-ped4000:VISIBLE = NO.
        END.

        /*
        IF VALID-HANDLE(wh-btCopyOrder-pd4000) THEN DO:
            CREATE BUTTON  wh-btCopyOrder-pd4000-new
            ASSIGN FRAME        = wh-frame-fpage1-pd4000
                   WIDTH        = wh-btCopyOrder-pd4000:WIDTH
                   HEIGHT       = wh-btCopyOrder-pd4000:HEIGHT
                   ROW          = wh-btCopyOrder-pd4000:ROW 
                   LABEL        = wh-btCopyOrder-pd4000:LABEL
                   COLUMN       = wh-btCopyOrder-pd4000:COLUMN
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   TOOLTIP      = wh-btCopyOrder-pd4000:TOOLTIP
                TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-CopyOrder-pd4000-new IN h-pd4000-upc.
                END TRIGGERS.

             wh-btCopyOrder-pd4000-new:LOAD-IMAGE(wh-btCopyOrder-pd4000:IMAGE).                                           
             wh-btCopyOrder-pd4000-new:LOAD-IMAGE-INSENSITIVE(wh-btCopyOrder-pd4000:IMAGE-INSENSITIVE).               
             wh-btCopyOrder-pd4000:VISIBLE = NO.
        END.
        */

        IF  VALID-HANDLE (wh-bt-save-ord) THEN DO:
            CREATE BUTTON wh-bt-save-ord-new
            ASSIGN FRAME        = wh-frame-fpage1-pd4000
                   WIDTH        = wh-bt-save-ord:WIDTH
                   HEIGHT       = wh-bt-save-ord:HEIGHT
                   ROW          = wh-bt-save-ord:ROW 
                   LABEL        = wh-bt-save-ord:LABEL
                   COLUMN       = wh-bt-save-ord:COLUMN
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   NAME         = "wh-bt-save-ord-new"
                   TOOLTIP      = wh-bt-save-ord:TOOLTIP
                   TRIGGERS:
                        ON CHOOSE PERSISTENT RUN pi-confirma-pedido IN h-pd4000-upc.
                   END TRIGGERS.

            wh-bt-save-ord-new:LOAD-IMAGE(wh-bt-save-ord:IMAGE).
            wh-bt-save-ord-new:LOAD-IMAGE-INSENSITIVE(wh-bt-save-ord-new:IMAGE-INSENSITIVE).

            wh-bt-save-ord:VISIBLE = NO.

        END.
                
    end.

    if valid-handle(wh-frame-fpage1-pd4000) then do:
        run pi-busca-handle (input wh-frame-fpage1-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'cod-canal-venda':U,
                             input NO,
                             output wh-cod-canal-venda-pd4000).

        run pi-busca-handle (input wh-frame-fpage1-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'perc-desco1':U,
                             input NO,
                             output wh-perc-desco1-pd4000).
    end.
end.


IF p-ind-event = "after-initialize":U THEN DO:
    assign wh-frame-fpage19-pd4000        = ?
           wh-cod-unid-negoc-pd4000       = ?.

    IF p-wgh-frame:TYPE = "frame":U  AND
       p-wgh-frame:NAME = "fpage0":U THEN DO:
        IF NOT VALID-HANDLE(wh-frame-fpage8-pd4000)    OR
           (wh-frame-fpage8-pd4000:TYPE <> "frame":U   AND
            wh-frame-fpage8-pd4000:NAME <> "fpage8":U) THEN DO:
            RUN pi-busca-handle (INPUT  p-wgh-frame,
                                 INPUT  p-ind-event,
                                 INPUT  "frame":U,
                                 INPUT  "fpage8":U,
                                 INPUT  NO,
                                 OUTPUT wh-frame-fpage8-pd4000).
        END.
        IF NOT VALID-HANDLE(wh-frame-fpage3-pd4000)    OR
           (wh-frame-fpage3-pd4000:TYPE <> "frame":U   AND
            wh-frame-fpage3-pd4000:NAME <> "fpage3":U) THEN DO:
            RUN pi-busca-handle (INPUT  p-wgh-frame,
                                 INPUT  p-ind-event,
                                 INPUT  "frame":U,
                                 INPUT  "fpage3":U,
                                 INPUT  NO,
                                 OUTPUT wh-frame-fpage3-pd4000).
        END.
        
        IF NOT VALID-HANDLE(wh-frame-fpage13-pd4000)    OR
           (wh-frame-fpage13-pd4000:TYPE <> "frame":U   AND
            wh-frame-fpage13-pd4000:NAME <> "fpage13":U) THEN DO:
            RUN pi-busca-handle (INPUT  p-wgh-frame,
                                 INPUT  p-ind-event,
                                 INPUT  "frame":U,
                                 INPUT  "fpage13":U,
                                 INPUT  NO,
                                 OUTPUT wh-frame-fpage13-pd4000).
        END.
        
        IF NOT VALID-HANDLE(wh-dt-entrega3-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage3-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entrega":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entrega3-pd4000).
        
        IF NOT VALID-HANDLE(wh-dt-entorig3-item-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage3-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entorig":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entorig3-item-pd4000).


        IF NOT VALID-HANDLE(wh-cod-entrega-item-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage8-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "cod-entrega":U,
                                 INPUT  NO,
                                 OUTPUT wh-cod-entrega-item-pd4000).

        IF NOT VALID-HANDLE(wh-dt-entrega-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage8-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entrega":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entrega-pd4000).

        IF NOT VALID-HANDLE(wh-dt-entorig-item-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage8-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entorig":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entorig-item-pd4000).
                                 
        IF NOT VALID-HANDLE(wh-dt-entrega13-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage13-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entrega":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entrega13-pd4000).
        
        IF NOT VALID-HANDLE(wh-dt-entorig13-item-pd4000) THEN
            RUN pi-busca-handle (INPUT  wh-frame-fpage13-pd4000,
                                 INPUT  p-ind-event,
                                 INPUT  "fill-in":U,
                                 INPUT  "dt-entorig":U,
                                 INPUT  NO,
                                 OUTPUT wh-dt-entorig13-item-pd4000).
                                 

        IF NOT VALID-HANDLE(wh-c-cod-modalid-frete-pd4000) THEN DO:
        
            run pi-busca-handle (input wh-frame-fpage3-pd4000,
                                 input p-ind-event,
                                 input 'fill-in':U,
                                 input 'c-cod-modalid-frete':U,
                                 input NO,
                                 output wh-c-cod-modalid-frete-pd4000).

        END.

        IF NOT VALID-HANDLE(wh-frame-fpage6-pd4000)    OR
           (wh-frame-fpage6-pd4000:TYPE <> "frame":U   AND
            wh-frame-fpage6-pd4000:NAME <> "fpage6":U) THEN DO:
            run pi-busca-handle (input p-wgh-frame,
                                 input p-ind-event,
                                 input 'frame':U,
                                 input 'fpage6':U,
                                 input NO,
                                 output wh-frame-fpage6-pd4000).
        END.

        run pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'des-pct-desconto-inform':U,
                             input NO,
                             output whdes-pct-desconto-inform).

        IF  VALID-HANDLE(whdes-pct-desconto-inform) AND valid-handle(h-pd4000-upc) THEN DO:

              IF  NOT VALID-HANDLE(whqt-pedida) THEN
                  run pi-busca-handle (input wh-frame-fpage6-pd4000,
                                       input p-ind-event,
                                       input 'fill-in':U,
                                       input 'qt-pedida':U,
                                       input NO,
                                       output whqt-pedida).

              IF  NOT VALID-HANDLE(whvl-preuni) THEN DO:
                  run pi-busca-handle (input wh-frame-fpage6-pd4000,
                                       input p-ind-event,
                                       input 'fill-in':U,
                                       input 'vl-preori':U,
                                       input NO,
                                       output whvl-preuni).
                  
                  ON "ENTRY":U OF whvl-preuni PERSISTENT RUN pi-entry-vl-preuni IN h-pd4000-upc.
                  ON "RETURN":U OF whvl-preuni PERSISTENT RUN pi-return-vl-preuni IN h-pd4000-upc.
              END.
             //on "leave" of whdes-pct-desconto-inform  persistent run upc/pd4000-upcM.p .
            
        END.
        
        run pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nr-sequencia':U,
                             input NO,
                             output whnr-sequencia-pd4000).

        run pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'cod-refer':U,
                             input NO,
                             output wh-cod-refer-pd4000).

        IF NOT VALID-HANDLE(wh-frame-fpage19-pd4000)    OR
           (wh-frame-fpage19-pd4000:TYPE <> "frame":U   AND
            wh-frame-fpage19-pd4000:NAME <> "fpage19":U) THEN DO:
            RUN pi-busca-handle (INPUT  p-wgh-frame,
                                 INPUT  p-ind-event,
                                 INPUT  "frame":U,
                                 INPUT  "fpage19":U,
                                 INPUT  NO,
                                 OUTPUT wh-frame-fpage19-pd4000).
        END.

        IF NOT VALID-HANDLE(wh-cod-unid-negoc-pd4000) THEN DO:
        
            run pi-busca-handle (input wh-frame-fpage19-pd4000,
                                 input p-ind-event,
                                 input 'fill-in':U,
                                 input 'cod-unid-negoc':U,
                                 input NO,
                                 output wh-cod-unid-negoc-pd4000).

        END.

        CREATE TEXT whlb-nr-os-pd4000
        ASSIGN FRAME        = wh-frame-fpage8-pd4000
               WIDTH        = wh-dt-entorig-item-pd4000:SIDE-LABEL-HANDLE:WIDTH
               FORMAT       = "x(8)":U
               SCREEN-VALUE = "Nro OS:":U
               ROW          = wh-cod-entrega-item-pd4000:SIDE-LABEL-HANDLE:ROW
               COLUMN       = wh-dt-entorig-item-pd4000:COLUMN - 6
               VISIBLE      = YES.



        IF NOT VALID-HANDLE (wh-combo-modal-pd4000) THEN DO:
    
            /* Cria um botÊo "falso" por cima */
            CREATE TOGGLE-BOX wh-combo-modal-pd4000
            ASSIGN FRAME     = wh-frame-fpage3-pd4000
                  COL       = 48   
                  ROW       = 7.96 
                  WIDTH     = 11.57
                  HEIGHT    = 0.86
                  LABEL     = "Transp. A²reo" 
                  VISIBLE   = YES 
                  SENSITIVE = YES
                  CHECKED   = YES
                  TOOLTIP   = "Transp. A²reo" 
              TRIGGERS:
                    ON VALUE-CHANGED PERSISTENT RUN pi-onchoose-modal IN h-pd4000-upc.
              END TRIGGERS.
    
        END.
        
        /*IDBA BRUNO - M2305-132 -- 14/03/2024 */
        IF NOT VALID-HANDLE (wh-bt-local-entrega-alternativo-pd4000) THEN DO:
            CREATE BUTTON wh-bt-local-entrega-alternativo-pd4000
            ASSIGN FRAME        = h-frame
                   WIDTH        = 4
                   HEIGHT       = 1
                   ROW          = wh-cod-rota-pd4000:ROW 
                   LABEL        = "TESTE"
                   COLUMN       = 32 
                   SENSITIVE    = YES
                   NAME         = "wh-bt-confirma-item-novo-pd4000"
                   VISIBLE      = YES
                   TOOLTIP      = "TESTE" .
            wh-bt-local-entrega-alternativo-pd4000:LOAD-IMAGE ( 'image/im-pneu.bmp' ). //( 'image/green2.ico' ).
        END.

        IF VALID-HANDLE(h-pd4000-upc) THEN ON "CHOOSE" OF  wh-bt-local-entrega-alternativo-pd4000  persistent run pi-bt-local-entrega-alternativo IN h-pd4000-upc.

        IF NOT VALID-HANDLE (wh-gpon-pd4000) THEN DO:
    
            /* Cria um botÊo "falso" por cima */
            CREATE TOGGLE-BOX wh-gpon-pd4000
            ASSIGN FRAME    = wh-frame-fpage3-pd4000
                  COL       = 48   
                  ROW       = 9.96 
                  WIDTH     = 11.57
                  HEIGHT    = 0.86
                  LABEL     = "GPON" 
                  VISIBLE   = YES 
                  SENSITIVE = YES
                  CHECKED   = NO
                  TOOLTIP   = "GPON"
                TRIGGERS:
                    ON VALUE-CHANGED PERSISTENT RUN pi-onchoose-gpon IN h-pd4000-upc.
              END TRIGGERS.
        END.

        CREATE FILL-IN wh-nr-os-pd4000
        ASSIGN FRAME             = wh-frame-fpage8-pd4000
               SIDE-LABEL-HANDLE = whlb-nr-os-pd4000:HANDLE
               LABEL             = whlb-nr-os-pd4000:SCREEN-VALUE
               DATA-TYPE         = "CHARACTER":U
               FORMAT            = "x(20)":U
               WIDTH             = wh-dt-entorig-item-pd4000:WIDTH + 7.3
               HEIGHT            = wh-cod-entrega-item-pd4000:HEIGHT
               ROW               = wh-cod-entrega-item-pd4000:ROW
               COLUMN            = wh-dt-entorig-item-pd4000:COLUMN
               VISIBLE           = YES
            TRIGGERS:
                ON F5 PERSISTENT RUN pi-sel-nr-os IN h-pd4000-upc.
                ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN pi-sel-nr-os IN h-pd4000-upc.
            END TRIGGERS.

        wh-nr-os-pd4000:LOAD-MOUSE-POINTER("image/lupa.cur":U).

        ASSIGN wh-nr-os-pd4000:SENSITIVE = NO
               l-add-nr-os-pd4000        = wh-nr-os-pd4000:SENSITIVE.

        IF VALID-HANDLE(wh-cod-entrega-item-pd4000) THEN
            wh-nr-os-pd4000:MOVE-AFTER-TAB-ITEM(wh-cod-entrega-item-pd4000).

        IF VALID-HANDLE(wh-dt-entrega-pd4000)
        AND VALID-HANDLE(wh-nr-os-pd4000) THEN
            wh-dt-entrega-pd4000:MOVE-AFTER-TAB-ITEM(wh-nr-os-pd4000).

        CREATE RECTANGLE wh-rec-pci-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               EDGE-PIXELS  = 2
               GRAPHIC-EDGE = YES
               FILLED       = NO
               WIDTH        = 60.3
               HEIGHT       = 7.6
               ROW          = 4.5
               COLUMN       = 1
               VISIBLE      = YES
               SENSITIVE    = NO.

        CREATE TEXT wh-txt-rec-pci-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 7
               FORMAT       = "x(7)":U
               SCREEN-VALUE = "Inf PCI":U
               ROW          = wh-rec-pci-pd4000:ROW - 0.3
               COLUMN       = wh-rec-pci-pd4000:COL + 2
               VISIBLE      = YES.

        CREATE TEXT wh-txt-cod-repres-pd4000
        ASSIGN FRAME         = wh-frame-fpage19-pd4000
               WIDTH         = 11
               FORMAT        = "x(14)":U
               SCREEN-VALUE  = "Representante:":U
               ROW           = wh-rec-pci-pd4000:row + 0.4
               COLUMN        = wh-rec-pci-pd4000:COL + 5
               VISIBLE       = YES.

        CREATE FILL-IN wh-cod-repres-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-cod-repres-pd4000:HANDLE
               LABEL             = wh-txt-cod-repres-pd4000:SCREEN-VALUE
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>>>9":U
               WIDTH             = 6
               HEIGHT            = 0.88
               ROW               = wh-txt-cod-repres-pd4000:row - 0.1
               COLUMN            = wh-txt-cod-repres-pd4000:column + 11.

        CREATE FILL-IN wh-no-ab-reppri-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               DATA-TYPE         = "CHARACTER":U
               FORMAT            = "x(12)":U
               WIDTH             = 13
               HEIGHT            = 0.88
               ROW               = wh-cod-repres-pd4000:row
               COLUMN            = wh-cod-repres-pd4000:column + 6.5.

        CREATE TEXT wh-txt-cod-segmento-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 10
               FORMAT       = "x(12)":U
               SCREEN-VALUE = "Segmenta»’o:":U
               ROW          = wh-txt-cod-repres-pd4000:row + 1
               COLUMN       = wh-txt-cod-repres-pd4000:COL + 0.5
               VISIBLE      = YES.

        CREATE FILL-IN wh-cod-segmento-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-cod-segmento-pd4000:HANDLE
               LABEL             = wh-txt-cod-segmento-pd4000:SCREEN-VALUE
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>9":U
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = wh-cod-repres-pd4000:row + 1
               COLUMN            = wh-cod-repres-pd4000:COL.

        CREATE FILL-IN wh-desc-segmento-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               DATA-TYPE         = "CHARACTER":U
               FORMAT            = "x(40)":U
               WIDTH             = 15
               HEIGHT            = 0.88
               ROW               = wh-cod-segmento-pd4000:row
               COLUMN            = wh-cod-segmento-pd4000:column + 4.5.

        CREATE FILL-IN wh-cod-segmento-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-cod-segmento-pd4000:HANDLE
               LABEL             = wh-txt-cod-segmento-pd4000:SCREEN-VALUE
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>9":U
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = wh-cod-repres-pd4000:row + 1
               COLUMN            = wh-cod-repres-pd4000:COL.

        CREATE FILL-IN wh-desc-segmento-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               DATA-TYPE         = "CHARACTER":U
               FORMAT            = "x(40)":U
               WIDTH             = 15
               HEIGHT            = 0.88
               ROW               = wh-cod-segmento-pd4000:row
               COLUMN            = wh-cod-segmento-pd4000:column + 4.5.

        CREATE TEXT wh-txt-desc-topmilhao-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Top Milh’o:":U
               ROW          = wh-txt-cod-segmento-pd4000:row + 1
               COLUMN       = wh-txt-cod-segmento-pd4000:COL - 2
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-topmilhao-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-topmilhao-pd4000:HANDLE
               LABEL             = wh-txt-desc-topmilhao-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-cod-segmento-pd4000:row + 1
               COLUMN            = wh-cod-segmento-pd4000:column.

        CREATE TEXT wh-txt-desc-kit-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Kit:":U
               ROW          = wh-txt-cod-segmento-pd4000:row + 1
               COLUMN       = wh-txt-cod-segmento-pd4000:COL + 38
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-kit-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-kit-pd4000:HANDLE
               LABEL             = wh-txt-desc-kit-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-cod-segmento-pd4000:row + 1
               COLUMN            = wh-cod-segmento-pd4000:COLUMN + 35.

        CREATE TEXT wh-txt-desc-maisverde-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Mais Verde:":U
               ROW          = wh-txt-desc-topmilhao-pd4000:row + 1
               COLUMN       = wh-txt-desc-topmilhao-pd4000:COL 
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-maisverde-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-maisverde-pd4000:HANDLE
               LABEL             = wh-txt-desc-maisverde-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-topmilhao-pd4000:row + 1
               COLUMN            = wh-desc-topmilhao-pd4000:COL.

        CREATE TEXT wh-txt-desc-qtde-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Quantidade:":U
               ROW          = wh-txt-desc-topmilhao-pd4000:row + 1
               COLUMN       = wh-txt-desc-topmilhao-pd4000:COL + 34
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-qtde-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-qtde-pd4000:HANDLE
               LABEL             = wh-txt-desc-qtde-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-topmilhao-pd4000:row + 1
               COLUMN            = wh-desc-topmilhao-pd4000:COL + 35.

        CREATE TEXT wh-txt-desc-focounidade-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 15
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Desc Foco Unidade:":U
               ROW          = wh-txt-desc-maisverde-pd4000:row + 1
               COLUMN       = wh-txt-desc-maisverde-pd4000:COL - 2
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-focounidade-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-focounidade-pd4000:HANDLE
               LABEL             = wh-txt-desc-focounidade-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-maisverde-pd4000:row + 1
               COLUMN            = wh-desc-maisverde-pd4000:column.

        CREATE TEXT wh-txt-desc-comercial-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 15
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Desc Comercial:":U
               ROW          = wh-txt-desc-maisverde-pd4000:row + 1
               COLUMN       = wh-txt-desc-maisverde-pd4000:COL + 35
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-comercial-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-comercial-pd4000:HANDLE
               LABEL             = wh-txt-desc-comercial-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-maisverde-pd4000:row + 1
               COLUMN            = wh-desc-maisverde-pd4000:COLUMN + 35.

        CREATE TEXT wh-txt-tabpre-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 15
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Tabela Pre‡o:":U
               ROW          = wh-txt-desc-maisverde-pd4000:row + 2
               COLUMN       = wh-txt-desc-maisverde-pd4000:COL + 36
               VISIBLE      = YES.

        CREATE FILL-IN wh-tabpre-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-tabpre-pd4000:HANDLE
               LABEL             = wh-txt-tabpre-pd4000:SCREEN-VALUE
               DATA-TYPE         = "character":U
               FORMAT            = "x(08)":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-maisverde-pd4000:row + 2
               COLUMN            = wh-desc-maisverde-pd4000:COLUMN + 35.

        CREATE TEXT wh-txt-segmento-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 15
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Segmento:":U
               ROW          = wh-txt-desc-maisverde-pd4000:row + 3
               COLUMN       = wh-txt-desc-maisverde-pd4000:COL + 24
               VISIBLE      = YES.

        CREATE FILL-IN wh-segmento-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-segmento-pd4000:HANDLE
               LABEL             = wh-txt-segmento-pd4000:SCREEN-VALUE
               DATA-TYPE         = "character":U
               FORMAT            = "x(22)":U
               WIDTH             = 22
               HEIGHT            = 0.88
               ROW               = wh-desc-maisverde-pd4000:row + 3
               COLUMN            = wh-desc-maisverde-pd4000:COLUMN + 20.

        CREATE TEXT wh-txt-desc-distrib20-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Distrib2.0:":U
               ROW          = wh-txt-desc-focounidade-pd4000:row + 1
               COLUMN       = wh-txt-desc-focounidade-pd4000:COL + 3
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-distrib20-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-distrib20-pd4000:HANDLE
               LABEL             = wh-txt-desc-distrib20-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-focounidade-pd4000:row + 1
               COLUMN            = wh-desc-focounidade-pd4000:column.

        CREATE TEXT wh-txt-desc-widecloud-pd4000
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 13
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc Wide Cloud:":U
               ROW          = wh-txt-desc-distrib20-pd4000:row + 1
               COLUMN       = wh-txt-desc-distrib20-pd4000:COL - 1.5
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-widecloud-pd4000
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-widecloud-pd4000:HANDLE
               LABEL             = wh-txt-desc-widecloud-pd4000:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>9.99":U
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-desc-distrib20-pd4000:row + 1
               COLUMN            = wh-desc-distrib20-pd4000:column.


        /************/

        CREATE TEXT wh-txt-desc-neg-comercial
        ASSIGN FRAME        = wh-frame-fpage19-pd4000
               WIDTH        = 22
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Desc. Neg. Comercial:":U
               ROW          = wh-cod-segmento-pd4000:row
               COLUMN       = 38
               VISIBLE      = YES.

        CREATE FILL-IN wh-desc-neg-comercial
        ASSIGN FRAME             = wh-frame-fpage19-pd4000
               SIDE-LABEL-HANDLE = wh-txt-desc-neg-comercial:HANDLE
               LABEL             = wh-txt-desc-neg-comercial:SCREEN-VALUE
               DATA-TYPE         = "DECIMAL":U 
               FORMAT            = ">>9.99":U  
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-cod-segmento-pd4000:row
               COLUMN            = wh-desc-qtde-pd4000:COL  .

        /***********/


    END.
    IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
        ASSIGN wh-combo-modal-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-gpon-pd4000) THEN
        ASSIGN wh-gpon-pd4000:SENSITIVE = NO.
END.



if p-ind-event = "before_pi-enableitem" then do:
    
    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "fpage0" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'frame':U,
                             input 'fpage8':U,
                             input NO,
                             output wh-frame-fpage8-pd4000).

        run pi-busca-handle (input wh-frame-fpage8-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nat-operacao':U,
                             input NO,
                             output wh-nat-operacao-item-pd4000).

        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'frame':U,
                             input 'fpage6':U,
                             input NO,
                             output wh-frame-fpage8-pd4000).

        run pi-busca-handle (input wh-frame-fpage8-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'it-codigo':U,
                             input NO,
                             output whit-codigo).
        run pi-busca-handle (input wh-frame-fpage8-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'val-desconto-inform':U,
                             input NO,
                             output whval-desconto-inform-pd4000).

/*         run pi-busca-handle (input p-wgh-frame,                */
/*                              input p-ind-event,                */
/*                              input 'frame':U,                  */
/*                              input 'fpage19':U,                */
/*                              input NO,                         */
/*                              output wh-frame-fpage19-pd4000).  */
/*                                                                */
/*                                                                */
/*         run pi-busca-handle (input wh-frame-fpage19-pd4000,    */
/*                              input p-ind-event,                */
/*                              input 'fill-in':U,                */
/*                              input 'cod-unid-negoc':U,         */
/*                              input NO,                         */
/*                              output wh-cod-unid-negoc-pd4000). */
    end.

    

    IF VALID-HANDLE(whval-desconto-inform-pd4000) THEN
        ASSIGN whval-desconto-inform-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-nr-os-pd4000) THEN
        ASSIGN wh-nr-os-pd4000:SENSITIVE = YES
               l-add-nr-os-pd4000        = wh-nr-os-pd4000:SENSITIVE.

    IF VALID-HANDLE(whlb-nr-os-pd4000) THEN
        ASSIGN whlb-nr-os-pd4000:SENSITIVE    = YES
               whlb-nr-os-pd4000:SCREEN-VALUE = "Nro OS:":U.

    if valid-handle(wh-txt-rec-pci-pd4000)
    then assign wh-txt-rec-pci-pd4000:SENSITIVE             = YES
                wh-txt-cod-repres-pd4000:SENSITIVE          = YES
                wh-txt-cod-segmento-pd4000:SENSITIVE        = YES
                wh-txt-desc-topmilhao-pd4000:SENSITIVE      = YES
                wh-txt-desc-maisverde-pd4000:SENSITIVE      = YES
                wh-txt-desc-focounidade-pd4000:SENSITIVE    = YES
                wh-txt-desc-distrib20-pd4000:SENSITIVE      = YES
                wh-txt-desc-widecloud-pd4000:SENSITIVE      = YES
                wh-txt-segmento-pd4000:SENSITIVE            = YES
                wh-txt-rec-pci-pd4000:SCREEN-VALUE          = "Inf PCI":U
                wh-txt-cod-repres-pd4000:SCREEN-VALUE       = "Representante:":U
                wh-txt-cod-segmento-pd4000:SCREEN-VALUE     = "Segmentacao:":U
                wh-txt-desc-topmilhao-pd4000:SCREEN-VALUE   = "Desc Top Milh’o:":U
                wh-txt-desc-maisverde-pd4000:SCREEN-VALUE   = "Desc Mais Verde:":U
                wh-txt-desc-focounidade-pd4000:screen-value = "Desc Foco Unidade:":U
                wh-txt-desc-distrib20-pd4000:SCREEN-VALUE   = "Desc Distrib2.0:":U
                wh-txt-desc-widecloud-pd4000:SCREEN-VALUE   = "Desc Wide Cloud:":U
                wh-txt-segmento-pd4000:SCREEN-VALUE         = "Segmento":U.
END.


RUN pi-muda-natureza.


/* Implementa»’o Nova - 03/12/07 - Giovane Oliveira - Sys Developer */
IF p-wgh-frame:NAME = "fPage6" THEN DO:
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'fill-in':U,
                         input 'it-codigo':U,
                         input NO,
                         output wh-it-codigo).

    if v_cod_estab_usuar = "102" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'btsaldo':U,
                             input NO,
                             output wh-btsaldo).

        IF VALID-HANDLE(wh-it-codigo) and
           VALID-HANDLE(wh-btsaldo)   THEN
            on "choose" of wh-btsaldo persistent run upc/pd4000-upc-nova.p (input wh-it-codigo).
    end.

    if p-ind-event = "AFTER-DESTROY-INTERFACE" then
        delete widget-pool "upc-pool" no-error.
end.


IF valid-handle(wh-bt-confirma-item-pd4000) THEN
    ASSIGN wh-bt-confirma-item-novo-pd4000:SENSITIVE = wh-bt-confirma-item-pd4000:SENSITIVE
           wh-bt-confirma-item-pd4000:VISIBLE = NO.

/* IF valid-handle(wh-btAddItem-pd4000) THEN                                      */
/*     ASSIGN wh-btAddItem-novo-pd4000 :SENSITIVE = wh-btAddItem-pd4000:SENSITIVE */
/*            wh-btAddItem-pd4000      :VISIBLE   = NO.                           */

IF valid-handle(wh-bt-cancelar-item-pd4000) THEN
    ASSIGN wh-bt-cancelar-item-novo-pd4000:SENSITIVE = wh-bt-cancelar-item-pd4000:SENSITIVE
           wh-bt-cancelar-item-pd4000:VISIBLE = NO.

IF p-ind-event = "BEFORE-CONTROL-TOOL-BAR" then do:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    do while valid-handle(h-frame):
        if h-frame:type = "frame" and h-frame:name = "fpage6" then
            leave.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end.

    if h-frame:type = "frame" and h-frame:name = "fpage6"  then do:

        
        /***************************************************************/
        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'btAdditem':U,
                             input NO,
                             output wh-btAddItem-pd4000).

/*         IF VALID-HANDLE(wh-btAddItem-pd4000) THEN DO:                                               */
/*                                                                                                     */
/*             CREATE BUTTON wh-btAddItem-novo-pd4000                                                  */
/*             ASSIGN FRAME        = h-frame                                                           */
/*                    WIDTH        = wh-btAddItem-pd4000:WIDTH                                         */
/*                    HEIGHT       = wh-btAddItem-pd4000:HEIGHT                                        */
/*                    ROW          = wh-btAddItem-pd4000:row                                           */
/*                    LABEL        = wh-btAddItem-pd4000:LABEL                                         */
/*                    COLUMN       = wh-btAddItem-pd4000:COLUMN                                        */
/*                    SENSITIVE    = YES                                                               */
/*                    VISIBLE      = YES                                                               */
/*                    TOOLTIP      = wh-btAddItem-pd4000:TOOLTIP                                       */
/*                    TRIGGERS:                                                                        */
/*                         ON CHOOSE PERSISTENT RUN pi-trataPedidoASTEC IN h-pd4000-upc.               */
/*                    END TRIGGERS.                                                                    */
/*                                                                                                     */
/*             wh-btAddItem-novo-pd4000:LOAD-IMAGE(wh-btAddItem-pd4000:IMAGE).                         */
/*             wh-btAddItem-novo-pd4000:LOAD-IMAGE-INSENSITIVE(wh-btAddItem-pd4000:IMAGE-INSENSITIVE). */
/*                                                                                                     */
/*             wh-btAddItem-novo-pd4000:MOVE-TO-TOP().                                                 */
/*         END.                                                                                        */
        /***************************************************************/

        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'btsaveitem':U,
                             input NO,
                             output wh-bt-confirma-item-pd4000).

        IF VALID-HANDLE(wh-bt-confirma-item-pd4000) THEN DO:
            
            CREATE BUTTON wh-bt-confirma-item-novo-pd4000
            ASSIGN FRAME        = h-frame
                   WIDTH        = wh-bt-confirma-item-pd4000:WIDTH
                   HEIGHT       = wh-bt-confirma-item-pd4000:HEIGHT
                   ROW          = wh-bt-confirma-item-pd4000:row 
                   LABEL        = wh-bt-confirma-item-pd4000:LABEL
                   COLUMN       = wh-bt-confirma-item-pd4000:COLUMN 
                   SENSITIVE    = YES
                   NAME         = "wh-bt-confirma-item-novo-pd4000"
                   VISIBLE      = YES
                   TOOLTIP      = wh-bt-confirma-item-pd4000:TOOLTIP
                   TRIGGERS:
                        ON CHOOSE PERSISTENT RUN pi-confirma-item IN h-pd4000-upc.
                   END TRIGGERS.

            wh-bt-confirma-item-novo-pd4000:LOAD-IMAGE(wh-bt-confirma-item-pd4000:IMAGE).
            wh-bt-confirma-item-novo-pd4000:LOAD-IMAGE-INSENSITIVE(wh-bt-confirma-item-pd4000:IMAGE-INSENSITIVE).
                               
            wh-bt-confirma-item-novo-pd4000:MOVE-TO-TOP().
        END.
        
        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'BtCancelationItem':U,
                             input NO,
                             output wh-btCancelationItem-pd4000).
        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btCancelationItem-pd4000 PERSISTENT RUN pi-btCancelationItem-pd4000 IN h-pd4000-upc. 
        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'BtDeleteItem':U,
                             input NO,
                             output wh-btDeleteItem-pd4000).
        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btdeleteItem-pd4000 PERSISTENT RUN pi-btDeleteItem-pd4000 IN h-pd4000-upc. 

        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'BtupdateItem':U,
                             input NO,
                             output wh-btUpdateItem-pd4000).
        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btUpdateItem-pd4000 PERSISTENT RUN pi-btUpdateItem-pd4000 IN h-pd4000-upc. 

        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'btAddItem':U,
                             input NO,
                             output wh-btAddItem-pd4000).
        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'CHOOSE':U OF wh-btAddItem-pd4000 PERSISTENT RUN pi-trataPedidoASTEC IN h-pd4000-upc. 
        

        run pi-busca-handle (input h-frame,
                             input p-ind-event,
                             input 'button':U,
                             input 'btcancelitem':U,
                             input NO,
                             output wh-bt-cancelar-item-pd4000).

        IF VALID-HANDLE(wh-bt-cancelar-item-pd4000) THEN DO:
            
            
            CREATE BUTTON wh-bt-cancelar-item-novo-pd4000
            ASSIGN FRAME        = h-frame
                   WIDTH        = wh-bt-cancelar-item-pd4000:WIDTH
                   HEIGHT       = wh-bt-cancelar-item-pd4000:HEIGHT
                   ROW          = wh-bt-cancelar-item-pd4000:row 
                   LABEL        = wh-bt-cancelar-item-pd4000:LABEL
                   COLUMN       = wh-bt-cancelar-item-pd4000:COLUMN 
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   TOOLTIP      = wh-bt-cancelar-item-pd4000:TOOLTIP
                   TRIGGERS:
                        ON CHOOSE PERSISTENT RUN pi-cancelar-item IN h-pd4000-upc.
                   END TRIGGERS.

            wh-bt-cancelar-item-novo-pd4000:LOAD-IMAGE(wh-bt-cancelar-item-pd4000:IMAGE).
            wh-bt-cancelar-item-novo-pd4000:LOAD-IMAGE-INSENSITIVE(wh-bt-cancelar-item-pd4000:IMAGE-INSENSITIVE).
                               
            wh-bt-cancelar-item-novo-pd4000:MOVE-TO-TOP().
        END.

/*         create button wh-button-prod-composto                                                            */
/*         assign frame     = h-frame                                                                       */
/*                width     = 4.00                                                                          */
/*                height    = 1.10                                                                          */
/*                row       = 12.50                                                                         */
/*                col       = 25.32                                                                         */
/*                visible   = yes                                                                           */
/*                sensitive = yes                                                                           */
/*                tooltip   = "Cria Itens Compostos".                                                       */
/*                                                                                                          */
/*         if wh-button-prod-composto:load-image("image/gr-lay.bmp") then.                                  */
/*                                                                                                          */
/*         on "choose" of wh-button-prod-composto  persistent run esp/pdp/espdp032.w (input p-wgh-object).  */

        
        create button wh-button-perc-segmento
        assign frame     = h-frame
               width     = 4.00
               height    = 1.10
               row       = 12.50
               col       = 35.32
               visible   = yes
               sensitive = yes
               tooltip   = "Informar Rateio por Segmento".

        if wh-button-perc-segmento:load-image("adeicon/calc-u.bmp") then.
        on "choose" of wh-button-perc-segmento persistent run esp/pdp/espdp076.w. 
    end.

end.


if v_cod_estab_usuar = "102" THEN DO:
    IF v_cod_usuar_corren <> "jo846350" THEN DO:
        
        If p-ind-object = "CONTAINER" AND
           p-ind-event = "BEFORE-INITIALIZE" THEN DO:
            
            IF NOT VALID-HANDLE(h-upc-pd4000-upc) THEN
                RUN upc/pd4000b-upcl.p PERSISTENT SET h-upc-pd4000-upc (INPUT "",
                                                                        INPUT "",
                                                                        INPUT p-wgh-object,
                                                                        INPUT p-wgh-frame,
                                                                        INPUT "",
                                                                        INPUT p-row-table).
        END.
    END.

    ASSIGN h-frame2 = p-wgh-frame:FIRST-CHILD
           h-frame2 = h-frame2:FIRST-CHILD.

    do while valid-handle(h-frame2):
        if h-frame2:type = "frame"  and
           h-frame2:name = "fpage1" THEN DO:

            run pi-busca-handle (input h-frame2,
                                 input p-ind-event,
                                 input 'button':U,
                                 input 'btDeleteOrder':U,
                                 input NO,
                                 output wh-btDeleteOrder).

            IF VALID-HANDLE(wh-btDeleteOrder) AND
               valid-handle(h-upc-pd4000-upc) THEN
                ON 'choose' OF wh-btDeleteOrder PERSISTENT RUN pi-choose-btdeleteorder IN h-upc-pd4000-upc.

        end.

        if h-frame2:type ne "field-group" then
            h-frame2 = h-frame2:next-sibling.
        else
            h-frame2 = h-frame2:first-child.
    end.

    IF p-ind-event = "BEFORE-CONTROL-TOOL-BAR" then do:
        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.

        do while valid-handle(h-frame):
            if h-frame:type = "frame" and h-frame:name = "fpage6" then
                leave.

            if h-frame:type ne "field-group" then
                h-frame = h-frame:next-sibling.
            else
                h-frame = h-frame:first-child.
        end.

        if h-frame:type = "frame" and h-frame:name = "fpage6" then do:

            create button wh-button-transfere
            assign frame     = h-frame
                   width     = 4.00
                   height    = 1.10
                   row       = 12.50
                   col       = 30.32
                   visible   = yes
                   sensitive = yes
                   tooltip   = "Transferencia de Estabelecimento".

            if wh-button-transfere:load-image("image/im-trf.bmp") then.
            
            on "choose" of wh-button-transfere  persistent run esp/pdp/espdp042.w (input p-wgh-object).

            CREATE WIDGET-POOL "upc-pool" persistent no-error.

            create button wh-btsaldo IN WIDGET-POOL "upc-pool"
            assign name = "btsaldo"
                   label = "Consulta Saldo"
                   row = 3.0
                   COLUMN = 49.5
                   height = 0.79
                   width = 12
                   frame = h-frame
                   visible = yes
                   sensitive = yes.

            h-frame = h-frame:first-child.

            do while valid-handle(h-frame):
                if h-frame:type = "fill-in" and h-frame:name = "cod-refer" then
                    wh-btsaldo:move-after(h-frame).
                if h-frame:type ne "field-group" then
                    h-frame = h-frame:next-sibling.
                else
                    h-frame = h-frame:first-child.
            end.
        end.
    end.
end.
/* Fim Implementa»’o Nova */ 




IF p-ind-object  = "CONTAINER"         AND
   c-objeto      = "PD4000.W"          AND
   p-ind-event   = "AfterDisplayOrder" THEN DO:

    FIND ped-venda
        where rowid(ped-venda) = p-row-table no-lock no-error.
    IF AVAIL ped-venda THEN DO:
        ASSIGN r-rowid-pd4000 = ROWID(ped-venda)
               i-cod-cond-pag-antes = ped-venda.cod-cond-pag.
    END.

    IF  VALID-HANDLE(wh-vl-frete-pd4000) THEN
        ASSIGN wh-vl-frete-pd4000:SENSITIVE = NO.

    IF v_cod_estab_usuar = "101" OR
       v_cod_estab_usuar = "104" THEN DO:
        
        IF VALID-HANDLE(wh-nome-abrev-tri-pd4000) AND
           wh-nome-abrev-tri-pd4000:SENSITIVE     AND
           wh-nome-abrev-tri-pd4000:SCREEN-VALUE <> "" THEN DO:
            APPLY "leave" TO wh-nome-abrev-tri-pd4000.
        END.
    END.

    IF VALID-HANDLE(wh-c-cod-modalid-frete-pd4000) THEN
        IF wh-c-cod-modalid-frete-pd4000:SCREEN-VALUE = "" THEN DO:
            ASSIGN wh-c-cod-modalid-frete-pd4000:SCREEN-VALUE = "0".
            
        END.

    IF valid-handle(wh-cod-cond-pag-pd4000) AND
       int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) <> i-cod-cond-pag-antes AND
       i-cod-cond-pag-antes <> 0 THEN DO:
        
        FIND int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = i-cod-cond-pag-antes NO-LOCK NO-ERROR.
        FIND b-int-cond-pagto
            WHERE b-int-cond-pagto.cod-cond-pag = INT(wh-cod-cond-pag-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
        
            IF AVAIL int-cond-pagto AND AVAIL b-int-cond-pagto THEN DO:
            IF b-int-cond-pagto.transacao-com-cartao <> int-cond-pagto.transacao-com-cartao OR
               b-int-cond-pagto.tipo-trans-cartao       <> int-cond-pagto.tipo-trans-cartao THEN DO:
               
                
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17567,
                                   INPUT "Nao ² permitido alterar condi‡Æo de pagamento com tipo de transa‡Æo CARTÇO diferentes" ).

                ASSIGN wh-cod-cond-pag-pd4000:SCREEN-VALUE = string(i-cod-cond-pag-antes)
                       wh-cod-cond-pag-pd4000:SENSITIVE = NO.
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            IF AVAIL b-int-cond-pagto AND 
               b-int-cond-pagto.transacao-com-cartao = YES THEN DO:
                
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17567,
                                   INPUT "Nao ² permitido alterar condi‡Æo de pagamento com tipo de transa‡Æo CARTÇO diferentes" ).
                ASSIGN wh-cod-cond-pag-pd4000:SCREEN-VALUE = string(i-cod-cond-pag-antes)
                       wh-cod-cond-pag-pd4000:SENSITIVE = NO.
                RETURN "NOK".
            END.
        END.
    END.

    IF VALID-HANDLE(wh-vl-frete-pd4000) THEN DO:
        IF AVAILABLE ped-venda THEN DO:
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

            ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = IF AVAILABLE int-ped-venda THEN STRING(int-ped-venda.vl-frete) ELSE "0":U.
        END.
        ELSE
            ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.
    END.


    /* Origem */
    IF VALID-HANDLE(wh-origem-pd4000) THEN DO:
        assign wh-origem-pd4000:screen-value = "":U.

        IF AVAILABLE ped-venda THEN DO:
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

            if avail int-ped-venda
            then ASSIGN wh-origem-pd4000:SCREEN-VALUE = 
                                                          //substr(int-ped-venda.char-1, 41, 12)
                                                       int-ped-venda.origem.
        END.
    END.
    
    IF VALID-HANDLE(wh-troca-nf-pd4000) THEN DO:
        IF AVAILABLE ped-venda THEN DO:
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

            ASSIGN wh-troca-nf-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda AND SUBSTRING(int-ped-venda.char-1, 11, 1) = "S":U THEN "YES":U ELSE "NO":U.
        END.
        ELSE
            ASSIGN wh-troca-nf-pd4000:SCREEN-VALUE = "NO":U.
    END.


    /* Data de Negocia»’o e Dias de Negocia»’o */
/*     IF  VALID-HANDLE(wh-data-negoc-pd4000)          AND      */
/*         VALID-HANDLE(wh-dias-negoc-pd4000)          AND      */
/*         VALID-HANDLE(wh-supervisor-pd4000)          AND      */
/*         VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND      */
/*         VALID-HANDLE(wh-libera-preco-canais-pd4000) AND      */
/*         VALID-HANDLE(wh-po-cliente-pd4000)          THEN DO: */
    
    IF  AVAIL ped-venda THEN DO:
        IF  NOT AVAIL int-ped-venda THEN DO:
            FIND FIRST int-ped-venda NO-LOCK
                WHERE  int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        END.

        IF  VALID-HANDLE(wh-data-negoc-pd4000)          AND
            VALID-HANDLE(wh-dias-negoc-pd4000)          THEN DO:
        
            IF AVAIL int-ped-venda THEN DO:
                IF wh-data-negoc-pd4000:SCREEN-VALUE = STRING(int-ped-venda.dt-negociacao) THEN 
                    ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE = STRING(int-ped-venda.dt-negociacao).  
                ELSE "".

                 IF wh-dias-negoc-pd4000:SCREEN-VALUE = STRING(int-ped-venda.dias-negociacao) THEN 
                    ASSIGN wh-dias-negoc-pd4000:SCREEN-VALUE = STRING(int-ped-venda.dias-negociacao). 
                 ELSE "0".
            END.

        END.


        IF  VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND
            NOT wh-cd-unid-comerc-pd4000:SENSITIVE      THEN
                ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,16,3) ELSE "0".

        IF  VALID-HANDLE(wh-libera-preco-canais-pd4000) AND
            NOT wh-libera-preco-canais-pd4000:SENSITIVE THEN
            ASSIGN wh-libera-preco-canais-pd4000:CHECKED = IF AVAIL int-ped-venda AND SUBSTRING(int-ped-venda.char-1, 65, 1) = "1" THEN YES ELSE NO.

        IF  VALID-HANDLE(wh-po-cliente-pd4000)          AND
            NOT wh-po-cliente-pd4000:SENSITIVE          THEN
            ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,53,12) ELSE "".

        IF  VALID-HANDLE(wh-contrato-pd4000)          AND
            NOT wh-contrato-pd4000:SENSITIVE          THEN
            ASSIGN wh-contrato-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN int-ped-venda.nr-contrato ELSE "".
            //ASSIGN wh-contrato-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,80,12) ELSE "".

      
       IF  VALID-HANDLE(wh-supervisor-pd4000)          THEN 
        ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,68,8) ELSE "".
               
    END.
    ELSE DO:
        IF VALID-HANDLE(wh-data-negoc-pd4000) THEN
        ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE = "".

        IF VALID-HANDLE(wh-dias-negoc-pd4000) THEN
        ASSIGN wh-dias-negoc-pd4000:SCREEN-VALUE = "0".

        IF VALID-HANDLE(wh-po-cliente-pd4000) AND
            NOT wh-po-cliente-pd4000:SENSITIVE THEN
            ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE = "".

        IF VALID-HANDLE(wh-contrato-pd4000) AND
           NOT wh-contrato-pd4000:SENSITIVE THEN
           ASSIGN wh-contrato-pd4000:SCREEN-VALUE = "".


        IF VALID-HANDLE(wh-cd-unid-comerc-pd4000) AND
            NOT wh-cd-unid-comerc-pd4000:SENSITIVE THEN
            ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = "0":U.

        IF NOT wh-libera-preco-canais-pd4000:SENSITIVE THEN
            ASSIGN wh-libera-preco-canais-pd4000:CHECKED = NO.

    END.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.

    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
        ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.


/*     IF VALID-HANDLE(wh-nome-transp-pd4000) AND AVAIL ped-venda THEN        */
/*         ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = ped-venda.nome-transp. */

    IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN
            ASSIGN wh-cod-entrega-aux-pd4000:SCREEN-VALUE = wh-cod-entrega-pd4000:SCREEN-VALUE.

    IF VALID-HANDLE(tx-cod-entrega-aux-pd4000) THEN
        ASSIGN tx-cod-entrega-aux-pd4000:SCREEN-VALUE = "Local Entrega:".

    /* Pedido Origem - Produto padr’o */
    IF  VALID-HANDLE(wh-num-pedido-origem-pd4000) THEN
        ASSIGN wh-num-pedido-origem-pd4000:VISIBLE = NO.

    IF VALID-HANDLE(whlb-supervisor-pd4000) THEN
        ASSIGN whlb-supervisor-pd4000:SCREEN-VALUE = "Supervisor: ":U.

END.

IF p-ind-event  = "btSaveOrder"  THEN DO:
  
    IF VALID-HANDLE(wh-vl-frete-pd4000) THEN
        ASSIGN wh-vl-frete-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN
        ASSIGN wh-grupo-canais-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-troca-nf-pd4000) THEN
        ASSIGN wh-troca-nf-pd4000:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-button-supervisor) THEN
        ASSIGN wh-button-supervisor:SENSITIVE = YES.
    
    /* Data de Negocia»’o e Dias de Negocia»’o */
    IF  VALID-HANDLE(wh-data-negoc-pd4000) AND
        VALID-HANDLE(wh-dias-negoc-pd4000) THEN DO:
        ASSIGN wh-data-negoc-pd4000:SENSITIVE = NO
               wh-dias-negoc-pd4000:SENSITIVE = NO.
    END.

/*     IF VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND      */
/*        VALID-HANDLE(wh-libera-preco-canais-pd4000) AND      */
/*        VALID-HANDLE(wh-nome-abrev-pd4000)          AND      */
/*        VALID-HANDLE(wh-nr-pedcli-pd4000)           AND      */
/*        VALID-HANDLE(wh-po-cliente-pd4000)          THEN DO: */

    IF VALID-HANDLE(wh-nome-abrev-pd4000)          AND
       VALID-HANDLE(wh-nr-pedcli-pd4000)           THEN DO:

        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE ped-venda THEN DO:


            IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN DO:

                FIND FIRST int-ped-venda2
                    WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL int-ped-venda2 THEN
                    ASSIGN int-ped-venda2.int-1        = INTEGER(wh-grupo-canais-pd4000:SCREEN-VALUE)
                           int-ped-venda2.cod-estabel  = ped-venda.cod-estabel
                           int-ped-venda2.dt-avaliacao = TODAY.
                ELSE DO:

                    CREATE int-ped-venda2.
                    ASSIGN int-ped-venda2.nr-pedido    = ped-venda.nr-pedido
                           int-ped-venda2.cod-estabel  = ped-venda.cod-estabel
                           int-ped-venda2.int-1        = INTEGER(wh-grupo-canais-pd4000:SCREEN-VALUE)
                           int-ped-venda2.dt-avaliacao = TODAY.
                END.

            END. /* IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN DO: */

            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido             = ped-venda.nr-pedido
                       int-ped-venda.cod-estabel           = ped-venda.cod-estabel
                       OVERLAY(int-ped-venda.char-1, 1, 8) = STRING(TIME, "hh:mm:ss":U).
            END.
            ELSE
                ASSIGN int-ped-venda.cod-estabel = ped-venda.cod-estabel.

            FIND FIRST int-emitente 
                 WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
            IF int-emitente.log-salesforce = NO THEN DO:
                RUN pi-libera-preco-canais.
                IF RETURN-VALUE <> "OK":U THEN DO:
                    IF VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN
                    ASSIGN wh-libera-preco-canais-pd4000:SENSITIVE = NO.
                    RETURN "NOK":U.
                END.
    
                FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                     WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido  NO-ERROR.
    
                ASSIGN OVERLAY(int-ped-venda.char-1, 16,  3) = IF VALID-HANDLE(wh-cd-unid-comerc-pd4000)      THEN wh-cd-unid-comerc-pd4000:SCREEN-VALUE ELSE "0":U
                       OVERLAY(int-ped-venda.char-1, 53, 12) = IF VALID-HANDLE(wh-po-cliente-pd4000)          THEN wh-po-cliente-pd4000:SCREEN-VALUE     ELSE "":U 
                       OVERLAY(int-ped-venda.char-1, 80, 12) = IF VALID-HANDLE(wh-contrato-pd4000)            THEN wh-contrato-pd4000:SCREEN-VALUE     ELSE "":U 
                       OVERLAY(int-ped-venda.char-1, 65, 1)  = IF VALID-HANDLE(wh-libera-preco-canais-pd4000) AND wh-libera-preco-canais-pd4000:CHECKED THEN "1" ELSE "0"
                       int-ped-venda.log-gpon = wh-gpon-pd4000:CHECKED.
                                                   
                FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    
                FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN ped-venda.cod-entrega = IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN wh-cod-entrega-aux-pd4000:SCREEN-VALUE ELSE "".
                FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            END.
        END.
        ELSE DO:
            IF VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND
               VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN
                ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = "0":U
                       wh-libera-preco-canais-pd4000:CHECKED = NO.
        END.
        
        IF VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND
           VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN
        ASSIGN wh-cd-unid-comerc-pd4000:SENSITIVE      = NO
               wh-libera-preco-canais-pd4000:SENSITIVE = NO.

        IF  VALID-HANDLE(wh-num-pedido-origem-pd4000) THEN
            ASSIGN wh-num-pedido-origem-pd4000:VISIBLE = NO.

    END.

    IF VALID-HANDLE(wh-nome-abrev-pd4000)  AND 
        NOT wh-nome-abrev-pd4000:SENSITIVE THEN
        ASSIGN wh-po-cliente-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-nome-abrev-pd4000)  AND 
        NOT wh-nome-abrev-pd4000:SENSITIVE THEN
        ASSIGN wh-contrato-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN DO:
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.
        IF  wh-cd-unid-comerc-pd4000:SCREEN-VALUE = "0":U THEN DO:
            /*
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 27979,
                               INPUT "Unidade Comercial NÆo foi preenchida.~~Esta informa»’o ² importante para definir a Transportadora, caso NÆo informar verifique se a transportadora esta de acordo com suas necessidades!":U).
            */
            ASSIGN wh-cd-unid-comerc-pd4000:SENSITIVE = YES.
        END.
    END.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.
    
    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
    ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.

    IF  VALID-HANDLE(wh-cod-entrega-pd4000)
    AND VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN
    ASSIGN wh-cod-entrega-pd4000:SCREEN-VALUE = wh-cod-entrega-aux-pd4000:SCREEN-VALUE.

    IF  VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN
        ASSIGN wh-cod-entrega-aux-pd4000:SENSITIVE = NO.

    IF AVAIL ped-venda THEN DO:

        IF not ped-venda.nat-operacao BEGINS "6949" AND
           NOT ped-venda.nat-operacao BEGINS "5949" THEN /* assistencia tecnica nao devera mudar */
           RUN pi-muda-natureza-do-item-muda-estabel.
        
        
        FIND FIRST int-ped-trans  
             WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel
               AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
               AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli    EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL int-ped-trans  THEN DO:
            CREATE int-ped-trans.
            ASSIGN int-ped-trans.cod-estabel     = ped-venda.cod-estabel
                   int-ped-trans.nome-abrev      = ped-venda.nome-abrev 
                   int-ped-trans.nr-pedcli       = ped-venda.nr-pedcli .
        END.
        ASSIGN int-ped-trans.lot-transp      = l-transp-checked.

        FIND CURRENT int-ped-trans NO-LOCK NO-ERROR.
        RELEASE int-ped-trans.

    END.
    IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
        ASSIGN wh-combo-modal-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-gpon-pd4000) THEN
        ASSIGN wh-gpon-pd4000:SENSITIVE = NO.

        
END.


IF p-ind-event  = "AFTER-INITIALIZE"  THEN DO:

    assign wgh-grupo = p-wgh-frame:first-child
           wh-window = p-wgh-frame:parent.
           wh-frame0 = p-wgh-frame.
               
    do while valid-handle(wgh-grupo):
        assign wgh-child = wgh-grupo:first-child.

        do  while valid-handle(wgh-child):
            case wgh-child:type:
                when "frame" then do:
                    if  wgh-child:name = "fpage1" then do:
                        assign h-frame = wgh-child:HANDLE.
                    end.
               end.
            end.
            ASSIGN wgh-child = wgh-child:next-sibling no-error.
        end.
        leave.
    end.


    FIND ped-venda
        where rowid(ped-venda) = p-row-table no-lock no-error.

    if h-frame:type = "frame" and h-frame:name = "fpage1" then do:

        /* Cod.Cliente */
        CREATE TEXT whlb-cod-emitente
        ASSIGN FRAME        = h-frame
               WIDTH        = 12
               FORMAT       = "x(15)"
               SCREEN-VALUE = "Cod.Cli:"
               ROW          = 1.21
               COL          = 48.82
               VISIBLE      = YES.

        CREATE FILL-IN wh-cod-emitente
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = whlb-cod-emitente:HANDLE
               LABEL             = "Cliente:"
               DATA-TYPE         = "Integer"
               FORMAT            = ">>>>>9"
               WIDTH             = 6
               HEIGHT            = 0.79
               ROW               = 1.21
               COL               = 54.72
               VISIBLE           = YES.
        ASSIGN wh-cod-emitente:SCREEN-VALUE = STRING(ped-venda.cod-emitente). 

        CREATE TOGGLE-BOX wh-libera-preco-canais-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 10
               HEIGHT       = 1.00
               ROW          = 3.5
               LABEL        = "Operadora"
               COLUMN       = 49
               SENSITIVE    = NO
               VISIBLE      = YES
               SCREEN-VALUE = "NO":U
               FONT         = 1.

        CREATE TEXT whlb-cd-unid-comerc-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 15
               FORMAT       = "x(16)":U
               SCREEN-VALUE = "Unid. Comercial:":U
               ROW          = 11.1
               COL          = 45.42
               VISIBLE      = YES.

        CREATE FILL-IN wh-cd-unid-comerc-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = whlb-cd-unid-comerc-pd4000:HANDLE
               LABEL             = whlb-cd-unid-comerc-pd4000:HANDLE:SCREEN-VALUE
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>9":U
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 10.9
               COL               = 56.72
               VISIBLE           = YES
            TRIGGERS:
                ON F5 PERSISTENT RUN pi-sel-unid-comerc IN h-pd4000-upc.
                ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN pi-sel-unid-comerc IN h-pd4000-upc.
            END TRIGGERS.

        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'LEAVE' OF wh-cd-unid-comerc-pd4000 PERSISTENT RUN pi-leave-unid-comerc IN h-pd4000-upc.

        wh-cd-unid-comerc-pd4000:LOAD-MOUSE-POINTER("image/lupa.cur":U).

        IF VALID-HANDLE(whFidt-emissao) THEN
            wh-cd-unid-comerc-pd4000:MOVE-AFTER-TAB-ITEM(whFidt-emissao).

        /* Pedido de Origem do Cliente */
        IF  VALID-HANDLE(wh-num-pedido-origem-pd4000) THEN DO:
            CREATE TEXT whlb-po-cliente-pd4000
            ASSIGN FRAME        = h-frame
                   WIDTH        = 9
                   FORMAT       = "x(16)":U
                   SCREEN-VALUE = "PO Cliente:":U
                   ROW          = 2.7
                   COL          = 36.7
                   VISIBLE      = YES.
    
            CREATE TEXT whlb-contrato-pd4000
            ASSIGN FRAME        = h-frame
                   WIDTH        = 9
                   FORMAT       = "x(16)":U
                   SCREEN-VALUE = "Contrato:":U
                   ROW          = 4.5
                   COL          = 42.5
                   VISIBLE      = YES.
            
            CREATE FILL-IN wh-po-cliente-pd4000
            ASSIGN FRAME             = h-frame
                   SIDE-LABEL-HANDLE = whlb-po-cliente-pd4000:HANDLE
                   LABEL             = whlb-po-cliente-pd4000:HANDLE:SCREEN-VALUE
                   DATA-TYPE         = "CHARACTER":U
                   FORMAT            = "x(12)":U
                   WIDTH             = wh-num-pedido-origem-pd4000:WIDTH
                   HEIGHT            = wh-num-pedido-origem-pd4000:HEIGHT
                   ROW               = wh-num-pedido-origem-pd4000:ROW
                   COL               = wh-num-pedido-origem-pd4000:COL
                   VISIBLE           = YES
                   HELP              = "Pedido de Origem do cliente".

            CREATE FILL-IN wh-contrato-pd4000
            ASSIGN FRAME             = h-frame
                   SIDE-LABEL-HANDLE = whlb-contrato-pd4000:HANDLE
                   LABEL             = whlb-contrato-pd4000:HANDLE:SCREEN-VALUE
                   DATA-TYPE         = "CHARACTER":U
                   FORMAT            = "x(12)":U
                   WIDTH             = 12
                   HEIGHT            = 0.88
                   ROW               = 4.4
                   COL               = 48.5
                   VISIBLE           = YES
                   HELP              = "Pedido de Origem do cliente".
            
            ASSIGN wh-num-pedido-origem-pd4000:VISIBLE = NO.
        END.


        IF AVAILABLE ped-venda THEN DO:
            IF NOT AVAILABLE int-ped-venda THEN DO:
                FIND FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
            END.

            IF VALID-HANDLE(wh-cd-unid-comerc-pd4000     ) THEN
                ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 16, 3) ELSE "0":U.
            IF VALID-HANDLE(wh-po-cliente-pd4000         ) THEN
                ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE     = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 53,12) ELSE "":U.
            IF VALID-HANDLE(wh-contrato-pd4000         ) THEN
                ASSIGN wh-contrato-pd4000:SCREEN-VALUE     = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 80,12) ELSE "":U.

                                                                                                                                           
            IF VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN
                ASSIGN wh-libera-preco-canais-pd4000:CHECKED = IF AVAILABLE int-ped-venda AND SUBSTRING(int-ped-venda.char-1, 65,1) = "1" THEN YES ELSE NO.

        END.
        ELSE DO:
            IF VALID-HANDLE(wh-cd-unid-comerc-pd4000     ) THEN
                ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = "0":U.
            IF VALID-HANDLE(wh-po-cliente-pd4000         ) THEN
                ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE     = "":U.
            IF VALID-HANDLE(wh-contrato-pd4000         ) THEN
               ASSIGN wh-contrato-pd4000:SCREEN-VALUE     = "":U.

            IF VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN
                ASSIGN wh-libera-preco-canais-pd4000:CHECKED = NO.
        END.

        IF VALID-HANDLE(whFidt-emissao) THEN
            ASSIGN whFidt-emissao:COLUMN                   = whFidt-emissao:COLUMN - 12
                   whFidt-emissao:SIDE-LABEL-HANDLE:COLUMN = whFidt-emissao:SIDE-LABEL-HANDLE:COLUMN - 12.
    END.

    assign wgh-grupo = p-wgh-frame:first-child
           wh-window = p-wgh-frame:parent.
           wh-frame0 = p-wgh-frame.           

    DO WHILE valid-handle(wgh-grupo):
        assign wgh-child = wgh-grupo:first-child.

        do while valid-handle(wgh-child):
            case wgh-child:type:
                when "frame" then do:
                    if wgh-child:name = "fpage4" then do:
                        assign h-frame = wgh-child:HANDLE.
                    end.
                end.
            end.
            ASSIGN wgh-child = wgh-child:next-sibling no-error.
        end.
        leave.
    END.
    
    if (h-frame:type = "frame" and h-frame:name = "fpage4") THEN DO:
    
        CREATE TEXT whlb-supervisor-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 10
               FORMAT       = "x(12)":U
               SCREEN-VALUE = "Supervisor:":U
               ROW          = 8.25
               COL          = 35
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-supervisor-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = whlb-supervisor-pd4000:HANDLE
               LABEL             = "Supervisor"
               NAME              = "wh-supervisor-pd4000":U
               DATA-TYPE         = "CHARACTER"
               WIDTH             = 10
               HEIGHT            = 0.88
               FORMAT            = "x(11)":U
               ROW               = 8.20
               COLUMN            = 43 
               VISIBLE           = YES
               SENSITIVE         = YES
               SCREEN-VALUE      = ""
        TRIGGERS:
            ON 'LEAVE':U                 PERSISTENT RUN pi-leaveSupervisor IN h-pd4000-upc.
            ON 'MOUSE-SELECT-DBLCLICK':U PERSISTENT RUN upc/pd4000-upcd.p.
            ON 'F5':U PERSISTENT RUN upc/pd4000-upcd.p.
        END TRIGGERS.       
        wh-supervisor-pd4000:LOAD-MOUSE-POINTER("image/lupa.cur":U).

        create button wh-button-supervisor
        assign frame     = h-frame
               LABEL     = "Sup"
               width     = 4
               height    = 0.88
               row       = 8.20
               col       = 53
               visible   = yes
               sensitive = YES
               tooltip   = "Consulta Supervisor Canais".
        IF VALID-HANDLE(h-pd4000-upc) THEN on "choose" of wh-button-supervisor  persistent run pi-buttonSupervisor IN h-pd4000-upc.

        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "c-des-unid-negoc":U,
                             INPUT  NO,
                             OUTPUT wh-des-unid-negoc-pd4000).

        ASSIGN wh-des-unid-negoc-pd4000:WIDTH = wh-des-unid-negoc-pd4000:WIDTH - 10.

        
        IF VALID-HANDLE(whbtAddServInst) THEN DO:
            CREATE BUTTON whbtAddServInst-new
            ASSIGN FRAME     = h-frame            
                   WIDTH     = 10
                   HEIGHT    = 0.88
                   ROW       = wh-des-unid-negoc-pd4000:ROW           
                   LABEL     = "Vlr. servi‡o"          
                   COL       = 50.5
                   SENSITIVE = YES                                     
                   VISIBLE   = YES
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/pd4000-upcc.w.
            END TRIGGERS.
        END.
    END. /* if (h-frame:type = "frame" and h-frame:name = "fpage4") THEN DO: */


    if (h-frame:type = "frame" and h-frame:name = "fpage4") or
        p-ind-event = "AfterValueChangeCbFRame" then do:
        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "tp-pedido":U,
                             INPUT  NO,
                             OUTPUT wh-tp-pedido-pd4000).

        IF VALID-HANDLE(wh-tp-pedido-pd4000) AND
           VALID-HANDLE(h-pd4000-upc)        THEN DO:
            
            ASSIGN wh-tp-pedido-pd4000:LABEL  = "Atendente".
            
            ON 'LEAVE':U OF wh-tp-pedido-pd4000 PERSISTENT RUN pi-leave-tp-pedido IN h-pd4000-upc.
        END.

        /* Priori. Orig. */
        CREATE TEXT whlb-priori-orig
        ASSIGN FRAME        = h-frame
               WIDTH        = 6
               FORMAT       = "x(6)"
               SCREEN-VALUE = "Orig.:"
               ROW          = wh-tp-pedido-pd4000:ROW + 1
               COL          = wh-tp-pedido-pd4000:COL + 5
               VISIBLE      = YES.

        CREATE FILL-IN wh-priori-orig
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = whlb-priori-orig:HANDLE
               LABEL             = "Orig.:"
               DATA-TYPE         = "Character"
               FORMAT            = "x(2)"
               WIDTH             = 4
               HEIGHT            = 0.79
               ROW               = wh-tp-pedido-pd4000:ROW + 0.9
               COL               = wh-tp-pedido-pd4000:COL + 9
               VISIBLE           = YES.

        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "cod-priori":U,
                             INPUT  NO,
                             OUTPUT wh-cod-priori-pd4000).
        
        CREATE TEXT tx-vl-frete-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 12
               FORMAT       = "x(14)":U
               SCREEN-VALUE = "Valor Frete: ":U
               ROW          = 3.6
               COLUMN       = 36
               VISIBLE      = YES.

        CREATE FILL-IN wh-vl-frete-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = tx-vl-frete-pd4000
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>,>>>,>>>,>>9.99":U
               WIDTH             = 16
               HEIGHT            = 0.88
               ROW               = 3.50
               COLUMN            = 44
               VISIBLE           = YES.
        ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.

        CREATE TEXT tx-grupo-canais-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 12
               FORMAT       = "x(14)":U
               SCREEN-VALUE = "Gp. Canais: ":U
               ROW          = 4.6
               COLUMN       = 21
               VISIBLE      = YES.

        CREATE FILL-IN wh-grupo-canais-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = tx-grupo-canais-pd4000 
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>9":U
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 4.46
               COLUMN            = 28.5
               VISIBLE           = YES
               LABEL             = "Gp. Canais: ":U.

       CREATE TOGGLE-BOX wh-troca-nf-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 10
               HEIGHT       = 0.88
               ROW          = 3.45
               COLUMN       = 25
               VISIBLE      = YES
               SENSITIVE    = NO
               SCREEN-VALUE = "NO":U
               LABEL        = "Troca NF":U
               HELP         = "Troca de Nota Fiscal":U
               FONT         = 1.

        CREATE RECTANGLE wh-rec-frete-pd4000
        ASSIGN FRAME        = h-frame
               EDGE-PIXELS  = 2
               GRAPHIC-EDGE = YES
               FILLED       = NO
               WIDTH        = 60.57
               HEIGHT       = 1.5
               ROW          = 10.35
               COLUMN       = 1
               VISIBLE      = YES
               SENSITIVE    = NO.

        CREATE TEXT tx-origem-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 8
               FORMAT       = "x(10)":U
               SCREEN-VALUE = "Origem: ":U
               ROW          = 4.45
               COLUMN       = 38.5
               VISIBLE      = YES.


        CREATE FILL-IN wh-origem-pd4000
        ASSIGN NAME         = "wh-origem-pd4000":U
               FRAME        = h-frame
               DATA-TYPE    = "CHARACTER"
               WIDTH        = 16
               HEIGHT       = 0.88
               FORMAT       = "x(40)":U
               SCREEN-VALUE = "Origem: ":U
               ROW          = 4.45
               COLUMN       = 44
               VISIBLE      = YES.

        ASSIGN wh-origem-pd4000:SCREEN-VALUE = "".


        /**** Dias de Negocia»’o e Data de Negocia»’o ****/
        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "estab-atend":U,
                             INPUT  NO,
                             OUTPUT wh-estab-atend-pd4000).

        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "c-desc-estab-atend":U,
                             INPUT  NO,
                             OUTPUT wh-desc-estab-atend-pd4000).

        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "estab-central":U,
                             INPUT  NO,
                             OUTPUT wh-estab-central-pd4000).

        RUN pi-busca-handle (INPUT  h-frame,
                             INPUT  p-ind-event,
                             INPUT  "fill-in":U,
                             INPUT  "c-desc-estab-central":U,
                             INPUT  NO,
                             OUTPUT wh-desc-estab-central-pd4000).

        IF  VALID-HANDLE(wh-estab-atend-pd4000)        AND
            VALID-HANDLE(wh-desc-estab-atend-pd4000)   THEN DO:
            ASSIGN wh-estab-atend-pd4000:VISIBLE        = NO
                   wh-desc-estab-atend-pd4000:VISIBLE   = NO.
        END.

        IF  VALID-HANDLE(wh-estab-central-pd4000)      AND
            VALID-HANDLE(wh-desc-estab-central-pd4000) THEN DO:
            ASSIGN wh-estab-central-pd4000:VISIBLE      = NO
                   wh-desc-estab-central-pd4000:VISIBLE = NO.
        END.
            
        CREATE TEXT tx-data-negoc-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 14
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Data Negocia»’o:":U
               ROW          = 3.65
               COLUMN       = 2
               VISIBLE      = YES.

        CREATE FILL-IN wh-data-negoc-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = tx-data-negoc-pd4000
               NAME              = "wh-data-negoc-pd4000":U
               DATA-TYPE         = "DATE":U
               FORMAT            = "99/99/9999":U
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 3.5
               COLUMN            = 14.86
               VISIBLE           = YES.

        CREATE TEXT tx-dias-negoc-pd4000
        ASSIGN FRAME        = h-frame
               WIDTH        = 14
               FORMAT       = "x(18)":U
               SCREEN-VALUE = "Dias Negocia»’o:":U
               ROW          = 4.6
               COLUMN       = 2.25
               VISIBLE      = YES.

        CREATE FILL-IN wh-dias-negoc-pd4000
        ASSIGN FRAME             = h-frame
               SIDE-LABEL-HANDLE = tx-dias-negoc-pd4000
               NAME              = "wh-dias-negoc-pd4000":U
               DATA-TYPE         = "INTEGER":U
               FORMAT            = ">>9":U
               WIDTH             = 5
               HEIGHT            = 0.88
               ROW               = 4.5
               COLUMN            = 14.86
               VISIBLE           = YES.
    END.

    ASSIGN wh-grupo-canais-pd4000:LABEL  = "Gp.Canais:".

END.



IF p-ind-event  = "AFTER-DISPLAY":U THEN DO:

    ASSIGN l-busca-transportadora = NO
           l-mudou-cod-priori-pd4000 = NO.

    FIND FIRST ped-venda NO-LOCK
        WHERE  ROWID(ped-venda) = p-row-table NO-ERROR.

    IF  VALID-HANDLE(wh-cod-emitente) THEN DO:
        IF  AVAIL ped-venda THEN
            ASSIGN wh-cod-emitente:SCREEN-VALUE = STRING(ped-venda.cod-emitente).
        ELSE
            ASSIGN wh-cod-emitente:SCREEN-VALUE = STRING(0).
    END.

    IF AVAIL ped-venda THEN
        ASSIGN g-cod-emitente-bodi317im1br  = ped-venda.cod-emitente.

    /* Data de Negocia»’o e Dias de Negocia»’o */
/*     IF  VALID-HANDLE(wh-data-negoc-pd4000)          AND       */
/*         VALID-HANDLE(wh-dias-negoc-pd4000)          AND       */
/*         VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND       */
/*         VALID-HANDLE(wh-libera-preco-canais-pd4000) AND       */
/*         VALID-HANDLE(wh-po-cliente-pd4000)          AND       */
/*         VALID-HANDLE(wh-supervisor-pd4000)           THEN DO: */

        IF  AVAIL ped-venda THEN DO:

            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

            /*Verificar se tem calculo para o re»o de canais*/
            IF AVAIL int-emitente THEN 
                FIND FIRST int-calculo-canal NO-LOCK
                     WHERE int-calculo-canal.cod-guid      = int-emitente.cod-guid
                       AND int-calculo-canal.cod-estabel   = ped-venda.cod-estabel
                       AND int-calculo-canal.data-calculo  = TODAY NO-ERROR.

            IF  AVAIL int-calculo-canal THEN DO:
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN
                    ASSIGN wh-bt-calcula-preco:LABEL   = SUBSTRING(ENTRY(2,STRING(int-calculo-canal.hora-calculo),""),1,5)  /*Somente a hora do campo datetime*/
                           wh-bt-calcula-preco:BGCOLOR = ?.
            END.
            ELSE DO: 
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN DO:
                    IF int-emitente.ind-participa-canais = 993520001 THEN DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "CALCULAR"
                               wh-bt-calcula-preco:BGCOLOR = 12. 
                    END.
                    ELSE DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "-"
                               wh-bt-calcula-preco:BGCOLOR = ?.
                    END.
                END.
            END.

            FIND FIRST int-ped-venda NO-LOCK
                WHERE  int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
            
            IF  VALID-HANDLE(wh-data-negoc-pd4000)          THEN
            ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN STRING(int-ped-venda.dt-negociacao)   ELSE ""
                   wh-dias-negoc-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN STRING(int-ped-venda.dias-negociacao) ELSE "0".

            IF  VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND
                NOT wh-cd-unid-comerc-pd4000:SENSITIVE       THEN
                ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 16, 3) ELSE "0":U.

            IF  VALID-HANDLE(wh-libera-preco-canais-pd4000) AND
                NOT wh-libera-preco-canais-pd4000:SENSITIVE THEN
                ASSIGN wh-libera-preco-canais-pd4000:CHECKED = IF AVAIL int-ped-venda AND SUBSTRING(int-ped-venda.char-1, 65, 1) = "1" THEN YES ELSE NO.

            IF  VALID-HANDLE(wh-po-cliente-pd4000)          AND
                NOT wh-po-cliente-pd4000:SENSITIVE          THEN
                ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,53,12) ELSE "".
           
            IF  VALID-HANDLE(wh-contrato-pd4000)          AND
                NOT wh-contrato-pd4000:SENSITIVE          THEN
                ASSIGN wh-contrato-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,80,12) ELSE "".

            IF VALID-HANDLE(wh-supervisor-pd4000)           THEN
                ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,68,8) ELSE "".

        END.
    /*END.*/
    IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
       ASSIGN  wh-combo-modal-pd4000:CHECKED = l-transp-checked.

    IF VALID-HANDLE(wh-gpon-pd4000)           THEN
        ASSIGN wh-gpon-pd4000:CHECKED = l-gpon-checked.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.

    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
        ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.

    IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN
        ASSIGN wh-cod-entrega-aux-pd4000:SCREEN-VALUE = wh-cod-entrega-pd4000:SCREEN-VALUE.
    //RUN pi-verifica-portfolio-canais.


END.


IF p-ind-event  = "PI-ENABLE" AND
   p-ind-object = "VIEWER"    THEN DO:

  IF VALID-HANDLE( wh-combo-modal-pd4000) THEN
     ASSIGN wh-combo-modal-pd4000:SENSITIVE = YES.

  IF VALID-HANDLE( wh-gpon-pd4000) THEN
     ASSIGN wh-gpon-pd4000:SENSITIVE = YES.

  IF NOT AVAILABLE ped-venda THEN DO:
        IF  VALID-HANDLE(wh-nome-abrev-pd4000)
        AND VALID-HANDLE(wh-nr-pedcli-pd4000 ) THEN
            FIND FIRST ped-venda
                WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                  AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
    END.

/*
    IF AVAIL ped-venda THEN DO:
        FIND FIRST int-ped-trans  
               WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel
                 AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
                 AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli      NO-LOCK NO-ERROR.
        
           IF AVAIL int-ped-trans  THEN
               IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
                  ASSIGN  wh-combo-modal-pd4000:CHECKED = int-ped-trans.lot-transp.
           ELSE

               IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
                  ASSIGN  wh-combo-modal-pd4000:CHECKED = NO.



    END.

*/
   

    FIND FIRST int-ped-venda
         WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.

    
    IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN
        ASSIGN wh-grupo-canais-pd4000:SENSITIVE     = YES.

    IF VALID-HANDLE(wh-troca-nf-pd4000) THEN
        ASSIGN wh-troca-nf-pd4000:SENSITIVE     = YES.
    
/*     IF  VALID-HANDLE(wh-origem-pd4000) THEN        */
/*         ASSIGN wh-origem-pd4000:SENSITIVE   = YES. */

    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE   = YES.

    /* Data de Negocia»’o e Dias de Negocia»’o */
    IF  VALID-HANDLE(wh-data-negoc-pd4000) THEN
        ASSIGN wh-data-negoc-pd4000:SENSITIVE   = YES .

    IF VALID-HANDLE(wh-dias-negoc-pd4000)   THEN
            ASSIGN wh-dias-negoc-pd4000:SENSITIVE = YES .

    IF VALID-HANDLE(wh-cd-unid-comerc-pd4000)      THEN
        ASSIGN wh-cd-unid-comerc-pd4000:SENSITIVE = YES .

    IF VALID-HANDLE(wh-po-cliente-pd4000) THEN
        ASSIGN wh-po-cliente-pd4000:SENSITIVE   = YES .

    IF VALID-HANDLE(wh-contrato-pd4000) THEN
        ASSIGN wh-contrato-pd4000:SENSITIVE   = YES .
    
    IF VALID-HANDLE(wh-libera-preco-canais-pd4000) AND 
        ped-venda.cod-sit-ped = 1 THEN
        ASSIGN wh-libera-preco-canais-pd4000:SENSITIVE = YES.

    IF  VALID-HANDLE(wh-num-pedido-origem-pd4000) THEN
        ASSIGN wh-num-pedido-origem-pd4000:VISIBLE = NO.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.

    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
        ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.

    ASSIGN l-busca-transportadora = YES.

    IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN
        ASSIGN wh-cod-entrega-aux-pd4000:SCREEN-VALUE = wh-cod-entrega-pd4000:SCREEN-VALUE.

    IF VALID-HANDLE(wh-cod-entrega-pd4000) THEN DO:
        wh-cod-entrega-pd4000:VISIBLE          = NO.
        wh-cod-entrega-pd4000:SENSITIVE        = NO.
        wh-cod-entrega-pd4000:HIDDEN           = YES.
    END.

    IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN DO:
        wh-cod-entrega-aux-pd4000:SENSITIVE    = NO. //marcio yes
        tx-cod-entrega-aux-pd4000:SCREEN-VALUE = "Local Entrega:":U.
    END.

    IF VALID-HANDLE(wh-btdelivery-pd4000) THEN DO:
        wh-btdelivery-pd4000:VISIBLE       = NO.
        wh-btdelivery-pd4000:SENSITIVE     = NO.
        wh-btdelivery-pd4000:HIDDEN        = YES.
    END.

    IF VALID-HANDLE(wh-btdelivery-aux-pd4000) THEN
        wh-btdelivery-aux-pd4000:SENSITIVE = YES.

    IF  VALID-HANDLE(wh-nome-abrev-pd4000) 
    AND VALID-HANDLE(wh-nr-pedcli-pd4000 ) THEN DO: 

        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE ped-venda    THEN DO:

            for EACH ponto-programa NO-LOCK
                where ponto-programa.nome-programa = "espdp006"
                  AND ponto-programa.ponto         = 10,  
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                IF  ped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")     AND
                    ped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:

                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Aten‡Æo, Existe uma execu‡Æo de Aloca‡Æo Automÿtica para atendente do pedido.~~ " +
                                     "NÆo ‚ possivel alterar este pedido, aguarde o termino da execu‡Æo, usuario : " +  entry(3,conteudo-programa.conteudo, ";")).
                    APPLY "choose" TO wh-btCancelOrder-pd4000.
                    RETURN "NOK". 
                END.
            end.

            /* trata grupo-canais */
            FIND FIRST int-ped-venda2
                WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
            IF AVAIL int-ped-venda2 THEN DO:
                ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = STRING(int-ped-venda2.int-1) .
            END.
            ELSE DO:
                IF (wh-grupo-canais-pd4000:SCREEN-VALUE = '0' 
                OR  wh-grupo-canais-pd4000:SCREEN-VALUE = '' 
                OR  wh-grupo-canais-pd4000:SCREEN-VALUE = ?) THEN DO:

                    FIND FIRST atendente WHERE atendente.cd-oper = integer(wh-tp-pedido-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
                    IF AVAIL atendente THEN DO:
                        IF atendente.cod-gr-canais <> 0 THEN
                            ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(atendente.cod-gr-canais).
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                FIND FIRST grupo-canais-clientes
                                    WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                                IF AVAIL grupo-canais-clientes THEN
                                    ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                            END.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            FIND FIRST grupo-canais-clientes
                                WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                            IF AVAIL grupo-canais-clientes THEN
                                ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
                        END.
                    END.

                END. /* IF (wh-grupo-canais-pd4000:SCREEN-VALUE = '0'  */
            END. /* IF NOT AVAIL int-ped-venda2 THEN */

        END.
    END. /* IF  VALID-HANDLE(wh-nome-abrev-pd4000) AND VALID-HANDLE(wh-nr-pedcli-pd4000 ) THEN DO: */

    IF VALID-HANDLE(wh-tp-pedido-pd4000) THEN
        ASSIGN c-tp-pedido-anterior-pd4000 = wh-tp-pedido-pd4000:SCREEN-VALUE.
    
    RUN pi-leave-tp-pedido.

END.

IF p-ind-event  = "btCancelOrder":U AND
   p-ind-object = "VIEWER":U        THEN DO:

    IF VALID-HANDLE( wh-combo-modal-pd4000) THEN
       ASSIGN wh-combo-modal-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE( wh-gpon-pd4000) THEN
       ASSIGN wh-gpon-pd4000:SENSITIVE = NO.
    
    IF VALID-HANDLE(wh-btcompleteorder-ped4000) THEN
        ASSIGN wh-btcompleteorder-ped4000:VISIBLE = NO.

    IF VALID-HANDLE(wh-vl-frete-pd4000) THEN
        ASSIGN wh-vl-frete-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN
        ASSIGN wh-grupo-canais-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-troca-nf-pd4000) THEN
        ASSIGN wh-troca-nf-pd4000:SENSITIVE = NO.

    IF VALID-HANDLE(wh-supervisor-pd4000) THEN
        ASSIGN wh-supervisor-pd4000:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-button-supervisor) THEN
        ASSIGN wh-button-supervisor:SENSITIVE = YES.
    
    /* Data de Negocia»’o e Dias de Negocia»’o */
/*     IF  VALID-HANDLE(wh-data-negoc-pd4000)          AND      */
/*         VALID-HANDLE(wh-dias-negoc-pd4000)          AND      */
/*         VALID-HANDLE(wh-cd-unid-comerc-pd4000)      AND      */
/*         VALID-HANDLE(wh-libera-preco-canais-pd4000) AND      */
/*         VALID-HANDLE(wh-po-cliente-pd4000)          THEN DO: */

        IF NOT AVAILABLE ped-venda THEN DO:
            IF  VALID-HANDLE(wh-nome-abrev-pd4000)
            AND VALID-HANDLE(wh-nr-pedcli-pd4000 ) THEN
                FIND FIRST ped-venda
                    WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                      AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
        END.

        IF AVAILABLE ped-venda     AND
           NOT AVAIL int-ped-venda THEN DO:
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
        END.

        IF  VALID-HANDLE(wh-data-negoc-pd4000)          THEN 
            ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE       = IF AVAILABLE int-ped-venda THEN STRING(int-ped-venda.dt-negociacao)    ELSE "":U
                   wh-data-negoc-pd4000:SENSITIVE          = NO.

        IF  VALID-HANDLE(wh-dias-negoc-pd4000)          THEN 
            ASSIGN wh-dias-negoc-pd4000:SCREEN-VALUE       = IF AVAILABLE int-ped-venda THEN STRING(int-ped-venda.dias-negociacao)  ELSE "0":U
                   wh-dias-negoc-pd4000:SENSITIVE          = NO.

        IF  VALID-HANDLE(wh-cd-unid-comerc-pd4000)      THEN 
            ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE   = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 16, 3) ELSE "0":U
                   wh-cd-unid-comerc-pd4000:SENSITIVE      = NO.

        IF  VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN 
            ASSIGN wh-libera-preco-canais-pd4000:CHECKED   = IF AVAILABLE int-ped-venda AND SUBSTRING(int-ped-venda.char-1, 65, 1) = "1" THEN YES ELSE NO
                   wh-libera-preco-canais-pd4000:SENSITIVE = NO.

        IF  VALID-HANDLE(wh-po-cliente-pd4000)          THEN 
            ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE       = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 53,12) ELSE "":U
                   wh-po-cliente-pd4000:SENSITIVE          = NO.

        IF  VALID-HANDLE(wh-contrato-pd4000)          THEN 
            ASSIGN wh-contrato-pd4000:SCREEN-VALUE       = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 80,12) ELSE "":U
                   wh-contrato-pd4000:SENSITIVE          = NO.
        IF VALID-HANDLE(wh-supervisor-pd4000) THEN
            ASSIGN wh-supervisor-pd4000:SCREEN-VALUE       = IF AVAILABLE int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 68, 8) ELSE "":U .
        
        IF VALID-HANDLE(wh-gpon-pd4000) THEN
            ASSIGN wh-gpon-pd4000:CHECKED                  = IF AVAILABLE int-ped-venda THEN int-ped-venda.log-gpon ELSE NO.

        IF  VALID-HANDLE(wh-num-pedido-origem-pd4000) THEN
            ASSIGN wh-num-pedido-origem-pd4000:VISIBLE = NO.
    /*END.*/

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.


    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
        ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.
    
    ASSIGN l-busca-transportadora = NO.
    IF VALID-HANDLE(wh-cod-entrega-aux-pd4000) THEN ASSIGN wh-cod-entrega-aux-pd4000:SENSITIVE = NO.
    IF VALID-HANDLE(wh-btdelivery-aux-pd4000)  THEN ASSIGN wh-btdelivery-aux-pd4000:SENSITIVE  = NO.


    IF AVAIL ped-venda THEN DO:

        FIND FIRST int-ped-trans  
               WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel
                 AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
                 AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli      NO-LOCK NO-ERROR.
        
           IF AVAIL int-ped-trans  THEN
               IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
                  ASSIGN  wh-combo-modal-pd4000:CHECKED = int-ped-trans.lot-transp.
           ELSE

               IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
                  ASSIGN  wh-combo-modal-pd4000:CHECKED = NO.
    END.
END.




IF p-ind-event = "btAddOrder" THEN DO:
    IF  VALID-HANDLE(tx-origem-pd4000)
    AND VALID-HANDLE(wh-origem-pd4000) THEN
        ASSIGN tx-origem-pd4000:SCREEN-VALUE = "Origem: "
               wh-origem-pd4000:SCREEN-VALUE = "".

    IF  VALID-HANDLE(tx-vl-frete-pd4000) 
    AND VALID-HANDLE(wh-vl-frete-pd4000) THEN
        ASSIGN tx-vl-frete-pd4000:SCREEN-VALUE = "Valor Frete: ":U
               wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.
    
    IF VALID-HANDLE(whlb-supervisor-pd4000) THEN
        ASSIGN whlb-supervisor-pd4000:SCREEN-VALUE = "Supervisor: ":U.

    IF VALID-HANDLE(wh-grupo-canais-pd4000) THEN
        ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = "NO":U.

    IF VALID-HANDLE(wh-troca-nf-pd4000) THEN
        ASSIGN wh-troca-nf-pd4000:SCREEN-VALUE = "NO":U.


    /* Data de Negocia»’o e Dias de Negocia»’o */
    IF  VALID-HANDLE(tx-data-negoc-pd4000) AND
        VALID-HANDLE(tx-dias-negoc-pd4000) THEN DO:
        ASSIGN tx-data-negoc-pd4000:SCREEN-VALUE = "Data Negocia»’o:":U
               tx-dias-negoc-pd4000:SCREEN-VALUE = "Dias Negocia»’o:":U.
    END.

    IF  VALID-HANDLE(wh-data-negoc-pd4000)           THEN
        ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE     = "".
    IF  VALID-HANDLE(wh-dias-negoc-pd4000)           THEN
        ASSIGN wh-dias-negoc-pd4000:SCREEN-VALUE     = "0".
    IF  VALID-HANDLE(wh-cd-unid-comerc-pd4000)       THEN
        ASSIGN wh-cd-unid-comerc-pd4000:SCREEN-VALUE = "0":U.
    IF  VALID-HANDLE(wh-po-cliente-pd4000)           THEN
        ASSIGN wh-po-cliente-pd4000:SCREEN-VALUE     = "":U.
    IF  VALID-HANDLE(wh-contrato-pd4000)           THEN
         ASSIGN wh-contrato-pd4000:SCREEN-VALUE     = "":U.

    IF  VALID-HANDLE(wh-libera-preco-canais-pd4000)  THEN
        ASSIGN wh-libera-preco-canais-pd4000:CHECKED = NO.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN
        ASSIGN whlb-cd-unid-comerc-pd4000:SCREEN-VALUE = "Unid. Comercial:":U.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN
        ASSIGN whlb-po-cliente-pd4000:SCREEN-VALUE = "PO Cliente:":U.

    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN
    ASSIGN whlb-contrato-pd4000:SCREEN-VALUE = "Contrato:":U.

END.




IF  p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    IF  VALID-HANDLE(wh-combo-modal-pd4000) THEN DO:
        DELETE OBJECT wh-combo-modal-pd4000.
        ASSIGN wh-combo-modal-pd4000 = ?.
    END.

    IF  VALID-HANDLE(wh-gpon-pd4000) THEN DO:
        DELETE OBJECT wh-gpon-pd4000.
        ASSIGN wh-gpon-pd4000 = ?.
    END.


    IF  VALID-HANDLE(tx-data-negoc-pd4000) THEN DO:
        DELETE OBJECT tx-data-negoc-pd4000.
        ASSIGN tx-data-negoc-pd4000 = ?.
    END.

    IF  VALID-HANDLE(h-msg138a) THEN DO:
        DELETE OBJECT h-msg138a.
        ASSIGN h-msg138a = ?.
    END.

    IF  VALID-HANDLE(wh-data-negoc-pd4000) THEN DO:
        DELETE OBJECT wh-data-negoc-pd4000.
        ASSIGN wh-data-negoc-pd4000 = ?.
    END.

    IF  VALID-HANDLE(tx-dias-negoc-pd4000) THEN DO:
        DELETE OBJECT tx-dias-negoc-pd4000.
        ASSIGN tx-dias-negoc-pd4000 = ?.
    END.

    IF  VALID-HANDLE(wh-dias-negoc-pd4000) THEN DO:
        DELETE OBJECT wh-dias-negoc-pd4000.
        ASSIGN wh-dias-negoc-pd4000 = ?.
    END.

    IF VALID-HANDLE(whlb-cd-unid-comerc-pd4000) THEN DO:
        DELETE OBJECT whlb-cd-unid-comerc-pd4000.
        ASSIGN whlb-cd-unid-comerc-pd4000 = ?.
    END.

    IF VALID-HANDLE(wh-cd-unid-comerc-pd4000) THEN DO:
        DELETE OBJECT wh-cd-unid-comerc-pd4000.
        ASSIGN wh-cd-unid-comerc-pd4000 = ?.
    END.

    IF VALID-HANDLE(wh-libera-preco-canais-pd4000) THEN DO:
        DELETE OBJECT wh-libera-preco-canais-pd4000.
        ASSIGN wh-libera-preco-canais-pd4000 = ?.
    END.

    IF  VALID-HANDLE(whlb-po-cliente-pd4000) THEN DO:
        DELETE OBJECT whlb-po-cliente-pd4000.
        ASSIGN whlb-po-cliente-pd4000 = ?.
    END.

    IF  VALID-HANDLE(wh-po-cliente-pd4000) THEN DO:
        DELETE OBJECT wh-po-cliente-pd4000.
        ASSIGN wh-po-cliente-pd4000 = ?.
    END.
    

    IF  VALID-HANDLE(whlb-contrato-pd4000) THEN DO:
        DELETE OBJECT whlb-contrato-pd4000.
        ASSIGN whlb-contrato-pd4000 = ?.
    END.

    IF  VALID-HANDLE(wh-contrato-pd4000) THEN DO:
        DELETE OBJECT wh-contrato-pd4000.
        ASSIGN wh-contrato-pd4000 = ?.
    END.
    
    IF VALID-HANDLE(h-pd4000-upc) THEN DO:
        DELETE OBJECT h-pd4000-upc.
        ASSIGN h-pd4000-upc = ?.
    END.

END.

IF p-ind-event  = "BEFORE_PI-ENABLEITEM" AND
   p-ind-object = "VIEWER"               THEN DO:
    
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    
    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                WHEN "nome-abrev" THEN DO:
                    ASSIGN whNomeAbrev = h-frame.
                END.
                WHEN "nr-pedcli" THEN DO:
                    ASSIGN wh-nr-pedcli-pd4000 = h-frame.
                END.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.

    IF  VALID-HANDLE(wh-nr-pedcli-pd4000) 
    AND VALID-HANDLE(whNomeAbrev        ) THEN DO: 
    
        FIND FIRST emitente NO-LOCK
            WHERE emitente.nome-abrev = whNomeAbrev:SCREEN-VALUE NO-ERROR.
    
        IF emitente.estado = "MG" THEN DO:
            MESSAGE "Cliente de Minas Gerais." SKIP
                    "Verificar a natureza de oreca‡Æo para os itens de substitui‡Æo" SKIP
                    "tributaria assim como o campo Ret‚m Imposto!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    
        FIND ped-venda
            WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
              AND ped-venda.nome-abrev = whNomeAbrev:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE ped-venda    THEN DO:
    
            for EACH ponto-programa NO-LOCK
                where ponto-programa.nome-programa = "espdp006"
                  AND ponto-programa.ponto         = 10,  
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
                IF  ped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")     AND
                    ped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:
                
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Aten‡Æo, Existe uma execu‡Æo de Aloca‡Æo Automÿtica para atendente do pedido.~~ " +
                                     "NÆo ‚ possivel alterar este pedido, aguarde o termino da execu‡Æo, usuario : " +  entry(3,conteudo-programa.conteudo, ";")).
    
                               
                    APPLY "choose" TO wh-bt-cancelar-item-pd4000.
                    
                    RETURN "OK". 
                END.
            end.
        END.

    END. /* IF  VALID-HANDLE(wh-nr-pedcli-pd4000)  */

END.




IF p-ind-event  = "AFTERDISPLAYITEM" THEN DO:
    IF NOT VALID-HANDLE(whit-codigo) THEN
        run pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'it-codigo':U,
                             input NO,
                             output whit-codigo).

    IF NOT VALID-HANDLE(wh-nat-operacao-item-pd4000) THEN
        run pi-busca-handle (input wh-frame-fpage8-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'nat-operacao':U,
                             input NO,
                             output wh-nat-operacao-item-pd4000).

    IF NOT VALID-HANDLE(wh-cod-unid-negoc-pd4000) THEN
        run pi-busca-handle (input wh-frame-fpage19-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'cod-unid-negoc':U,
                             input NO,
                             output wh-cod-unid-negoc-pd4000).

    RUN pi-muda-natureza-do-item.

    IF  p-cod-table = "ped-item":U
    and (valid-handle(wh-cod-repres-pd4000) 
     or (VALID-HANDLE(wh-nr-os-pd4000) 
    and  NOT l-add-nr-os-pd4000))
    THEN DO:
        ASSIGN wh-nr-os-pd4000:SCREEN-VALUE            = "":U
               wh-cod-repres-pd4000:SCREEN-VALUE       = "":U          
               wh-no-ab-reppri-pd4000:SCREEN-VALUE     = "":U        
               wh-cod-segmento-pd4000:SCREEN-VALUE     = "":U        
               wh-desc-segmento-pd4000:SCREEN-VALUE    = "":U       
               wh-desc-topmilhao-pd4000:SCREEN-VALUE   = "":U      
               wh-desc-maisverde-pd4000:SCREEN-VALUE   = "":U      
               wh-desc-focounidade-pd4000:SCREEN-VALUE = "":U    
               wh-desc-distrib20-pd4000:SCREEN-VALUE   = "":U      
               wh-desc-widecloud-pd4000:SCREEN-VALUE   = "":U
               wh-desc-kit-pd4000:SCREEN-VALUE         = "":U
               wh-desc-qtde-pd4000:SCREEN-VALUE        = "":U
               wh-desc-comercial-pd4000:SCREEN-VALUE   = "":U
               wh-tabpre-pd4000:SCREEN-VALUE           = '':U
               wh-segmento-pd4000:SCREEN-VALUE         = '':U
               wh-desc-neg-comercial:SCREEN-VALUE      = '':U .


        FIND FIRST ped-item
            WHERE ROWID(ped-item) = p-row-table NO-LOCK NO-ERROR.

        IF AVAILABLE ped-item THEN DO:
            ASSIGN gr-ped-item = ROWID(ped-item).

            FIND FIRST int-ped-item
                WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
                  AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                  AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
                  AND int-ped-item.it-codigo    = ped-item.it-codigo
                  AND int-ped-item.cod-refer    = ped-item.cod-refer NO-LOCK NO-ERROR.

            IF AVAILABLE int-ped-item THEN
                ASSIGN wh-nr-os-pd4000:SCREEN-VALUE = TRIM(int-ped-item.nr-os).

            for FIRST mgesp.int-ped-item-pci no-lock
                WHERE int-ped-item-pci.nome-abrev   = ped-item.nome-abrev
                  AND int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli
                  AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                  AND int-ped-item-pci.it-codigo    = ped-item.it-codigo
                  AND int-ped-item-pci.cod-refer    = ped-item.cod-refer:
                 for first b-repres
                     where b-repres.cod-rep = int-ped-item-pci.cod-repres
                           no-lock: end.

                 for first int-segmento-portifolio
                     where int-segmento-portifolio.cod-segmento = int-ped-item-pci.cod-segmento
                           no-lock: end.

                 assign wh-cod-repres-pd4000:SCREEN-VALUE       = string(int-ped-item-pci.cod-repres)
                        wh-no-ab-reppri-pd4000:SCREEN-VALUE     = b-repres.nome-abrev when avail b-repres        
                        wh-cod-segmento-pd4000:SCREEN-VALUE     = string(int-ped-item-pci.cod-segmento)      
                        wh-desc-segmento-pd4000:SCREEN-VALUE    = int-segmento-portifolio.descricao when avail int-segmento-portifolio
                        wh-desc-topmilhao-pd4000:SCREEN-VALUE   = STRING(int-ped-item-pci.desc-topmilhao)  
                        wh-desc-maisverde-pd4000:SCREEN-VALUE   = STRING(int-ped-item-pci.desc-maisverde)   
                        wh-desc-focounidade-pd4000:SCREEN-VALUE = STRING(int-ped-item-pci.desc-focounidade)  
                        wh-desc-distrib20-pd4000:SCREEN-VALUE   = STRING(int-ped-item-pci.desc-distrib20)   
                        wh-desc-widecloud-pd4000:SCREEN-VALUE   = STRING(int-ped-item-pci.desc-widecloud)
                        wh-desc-kit-pd4000:SCREEN-VALUE         = STRING(int-ped-item-pci.desc-kit)
                        wh-desc-qtde-pd4000:SCREEN-VALUE        = STRING(int-ped-item-pci.desc-quant)
                        wh-desc-comercial-pd4000:SCREEN-VALUE   = STRING(int-ped-item-pci.desc-comerical)
                        wh-tabpre-pd4000:SCREEN-VALUE           = STRING(int-ped-item-pci.nr-tabpre).
                        wh-desc-neg-comercial:SCREEN-VALUE      = STRING(int-ped-item-pci.desc-neg-comercial) 
                        .
                FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL ITEM THEN
                   FIND FIRST fam-com-item
                        WHERE fam-com-item.unidade = SUBSTR(item.fm-cod-com,1,2)
                          AND fam-com-item.segmento = SUBSTR(ITEM.fm-cod-com,3,2) NO-LOCK NO-ERROR.
                IF AVAIL fam-com-item THEN
                   wh-segmento-pd4000:SCREEN-VALUE           = STRING(fam-com-item.descricao).
            end.
        END.
    END.

    IF VALID-HANDLE(whlb-nr-os-pd4000) THEN
        ASSIGN whlb-nr-os-pd4000:SENSITIVE    = YES
               whlb-nr-os-pd4000:SCREEN-VALUE = "Nro OS:":U.

    if valid-handle(wh-txt-rec-pci-pd4000)
    then assign wh-txt-rec-pci-pd4000:SENSITIVE             = YES
                wh-txt-cod-repres-pd4000:SENSITIVE          = YES
                wh-txt-cod-segmento-pd4000:SENSITIVE        = YES
                wh-txt-desc-topmilhao-pd4000:SENSITIVE      = YES
                wh-txt-desc-maisverde-pd4000:SENSITIVE      = YES
                wh-txt-desc-focounidade-pd4000:SENSITIVE    = YES
                wh-txt-desc-distrib20-pd4000:SENSITIVE      = YES
                wh-txt-desc-widecloud-pd4000:SENSITIVE      = YES
                wh-txt-desc-kit-pd4000:SENSITIVE            = YES
                wh-txt-desc-qtde-pd4000:SENSITIVE           = YES
                wh-txt-desc-comercial-pd4000:SENSITIVE      = YES
                wh-txt-segmento-pd4000:SENSITIVE            = YES
        
                wh-txt-rec-pci-pd4000:SCREEN-VALUE          = "Inf PCI":U
                wh-txt-cod-repres-pd4000:SCREEN-VALUE       = "Representante:":U
                wh-txt-cod-segmento-pd4000:SCREEN-VALUE     = "Segmenta»’o:":U
                wh-txt-desc-topmilhao-pd4000:SCREEN-VALUE   = "Desc Top Milh’o:":U
                wh-txt-desc-maisverde-pd4000:SCREEN-VALUE   = "Desc Mais Verde:":U
                wh-txt-desc-focounidade-pd4000:screen-value = "Desc Foco Unidade:":U
                wh-txt-desc-distrib20-pd4000:SCREEN-VALUE   = "Desc Distrib2.0:":U
                wh-txt-desc-widecloud-pd4000:SCREEN-VALUE   = "Desc Wide Cloud:":U
                wh-txt-desc-kit-pd4000:SCREEN-VALUE         = "Desc Kit:":U
                wh-txt-desc-qtde-pd4000:SCREEN-VALUE        = "Desc Quantidade:":U
                wh-txt-desc-comercial-pd4000:SCREEN-VALUE   = "Desc Comercial:":U
                wh-txt-segmento-pd4000:SCREEN-VALUE         = "Segmento":U.
END.




IF p-ind-event  = "AFTERLEAVEVLPREORI" AND
   p-ind-object = "VIEWER"             THEN DO:
    
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */

    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                WHEN "nome-abrev" THEN DO:
                    ASSIGN whNomeAbrev = h-frame.
                END.
                WHEN "nr-pedcli" THEN DO:
                    ASSIGN wh-nr-pedcli-pd4000 = h-frame.
                END.
            end.

            CASE h-frame:NAME:
                WHEN "fPage6"        THEN DO:
                    ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                    ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.
                        
                    DO WHILE VALID-HANDLE(h-frame-1):
                        IF  h-frame-1:TYPE <> "field-group" THEN DO:
                            CASE h-frame-1:NAME:
                                when "it-codigo" then do:
                                    assign whit-codigo = h-frame-1.
                                end.
                                when "nr-sequencia" then do:
                                    assign whnr-sequencia-pd4000 = h-frame-1.
                                end.
                                when "qt-pedida" then do:
                                    assign whqt-pedida = h-frame-1.
                                end.
                                when "vl-preori" then do:
                                    assign whvl-preuni = h-frame-1.
                                end.
                            end.
                        end.
                        ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.                    
                    end.
                end.

                WHEN "fPage8"        THEN DO:
                    ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                    ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.

                    DO WHILE VALID-HANDLE(h-frame-1):
                        IF  h-frame-1:TYPE <> "field-group" THEN DO:
                            CASE h-frame-1:NAME:
                                when "dt-entrega" then do:
                                    assign wh-dt-entrega-pd4000 = h-frame-1.
                                end.
                                when "nat-operacao" then do:
                                    assign wh-nat-operacao-item-pd4000 = h-frame-1.
                                end.
                            end.
                        end.
                        ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.                    
                    END.
                END.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.
    
    IF  VALID-HANDLE(wh-nome-abrev-pd4000 )     
    AND VALID-HANDLE(wh-nr-pedcli-pd4000  )     
    AND VALID-HANDLE(whit-codigo          )     
    AND VALID-HANDLE(whnr-sequencia-pd4000)  THEN DO:
        FIND ped-item
            WHERE ped-item.nome-abrev   = wh-nome-abrev-pd4000     :SCREEN-VALUE
              AND ped-item.nr-pedcli    = wh-nr-pedcli-pd4000      :SCREEN-VALUE
              AND ped-item.it-codigo    = whit-codigo              :SCREEN-VALUE
              AND ped-item.nr-sequencia = int(whnr-sequencia-pd4000:SCREEN-VALUE) NO-LOCK no-error.
        
        FIND ped-venda NO-LOCK
            WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
              AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.

        IF NOT AVAIL ped-item THEN DO:
            IF VALID-HANDLE(wh-dt-entrega-pd4000) THEN DO:
                /*IF v_cod_estab_usuar = "102" THEN DO:*/

                    IF  VALID-HANDLE(wh-it-codigo-pd4000) THEN DO:
                        FIND int-ped-venda2 NO-LOCK
                            WHERE  int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                        
                        FIND FIRST item-dt-entrega NO-LOCK
                             WHERE item-dt-entrega.it-codigo     = wh-it-codigo-pd4000:SCREEN-VALUE 
                              AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.
                    END.
                    IF  AVAIL item-dt-entrega AND item-dt-entrega.dt-entrega-futura > TODAY AND VALID-HANDLE(wh-dt-entrega-pd4000) THEN
                            ASSIGN wh-dt-entrega-pd4000:SCREEN-VALUE = STRING(item-dt-entrega.dt-entrega-futura) .
                /*END.*/
            END.
        END.
    END.

    /*Verificar o Pre‡o m¡nimo de tabela
    FIND FIRST int-emitente 
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
    IF INT-emitente.LOG-salesforce = NO THEN
     run pi-leave-vl-preori. */
    
/*                                                                                                                              */
/*         find last preco-item                                                                                                 */
/*             where preco-item.it-codigo  = whit-codigo:SCREEN-VALUE                                                           */
/*               and preco-item.cod-refer  = ""                                                                                 */
/*               and preco-item.nr-tabpre  = "MINIMO"                                                                           */
/*               and preco-item.situacao   = 1                                                                                  */
/*               and preco-item.quant-min <= dec(whqt-pedida:SCREEN-VALUE) no-lock no-error.                                    */
/*                                                                                                                              */
/*         IF avail preco-item  THEN DO:                                                                                        */
/*             if dec(whvl-preuni:screen-value) < preco-item.preco-venda then do:                                               */
/*                 MESSAGE "Pre‡o Informado inferior ao Pre‡o de tabela minimo - Preco = " string(preco-item.preco-venda) SKIP  */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                       */
/*             end.                                                                                                             */
/*         end.                                                                                                                 */

   

    /* Alerta caso o Pre‡o informado seja inferior ao Pre‡o m¡nimo + os impostos */
END.




ASSIGN vLogCopiaPedido   = NO
       vProgOrigemPD4000 = YES.

IF  p-ind-event  = "BEFORE_GET_USER" THEN DO:
    RETURN "YES".
END.



/*BHJ*/
IF p-ind-object  = "CONTAINER" AND 
   c-objeto      = "PD4000.W"  THEN DO:
    
    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        ASSIGN vLogLimpaDesc = YES.

        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-frame = h-frame:FIRST-CHILD.

        DO WHILE VALID-HANDLE(h-frame):
            IF h-frame:TYPE <> "field-group" THEN DO:
                
                /* Rotina de comiss’o de representante */
                RUN pi-frame-principal-comissao.
                CASE h-frame:NAME:
                    WHEN "fPage1" THEN DO:
                        ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                        ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.

                        DO WHILE VALID-HANDLE(h-frame-1):
                            IF  h-frame-1:TYPE <> "field-group" THEN DO:

                                CASE h-frame-1:NAME:
                                    WHEN "cod-estabel" THEN DO:
                                        ASSIGN whCodEstabel          = h-frame-1
                                               wh-cod-estabel-pd4000 = h-frame-1.
                                    END.
                                    WHEN "BtAddOrder" THEN 
                                       ASSIGN whBtAddOrder = h-frame-1.
                                   /* Rotina de comiss’o de representante */
                                   WHEN "dt-implant" THEN
                                       ASSIGN whFidt-implant = h-frame-1.
                                   WHEN "dt-emissao" THEN
                                       ASSIGN whFidt-emissao = h-frame-1.
                                   WHEN "nat-operacao" THEN
                                       ASSIGN wh-nat-operacao-pd4000 = h-frame-1.
                                   WHEN "cod-cond-pag" THEN
                                       ASSIGN wh-cod-cond-pag-pd4000 = h-frame-1.
                                    WHEN "num-pedido-origem" THEN
                                        ASSIGN wh-num-pedido-origem-pd4000 = h-frame-1.
                                    WHEN "val-pct-desconto-tab-preco" THEN
                                        ASSIGN wh-val-pct-desconto-tab-preco-pd4000 = h-frame-1.
                                    WHEN "des-pct-desconto-inform" THEN
                                        ASSIGN wh-des-pct-desconto-inform-pd4000 = h-frame-1.
                                    WHEN "num-pedido-origem" THEN
                                        ASSIGN wh-perc-desco1-pd4000 = h-frame-1.
                                END.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.

                        END.
                        
                    END.

                    WHEN "fPage3" THEN DO:
                        ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                        ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.
                        
                        DO WHILE VALID-HANDLE(h-frame-1):
                            IF  h-frame-1:TYPE <> "field-group" THEN DO:
                                CASE h-frame-1:NAME:
                                    WHEN "nome-abrev-tri" THEN 
                                        ASSIGN wh-nome-abrev-tri-pd4000 = h-frame-1.
                                    WHEN "nome-transp" THEN
                                        ASSIGN wh-nome-transp-pd4000 = h-frame-1.
                                    WHEN "cidade-cif" THEN
                                        ASSIGN wh-cidade-cif-pd4000 = h-frame-1.
                                    WHEN "cb-cod-des-mer" THEN
                                        ASSIGN whcb-cod-des-mer-pd4000 = h-frame-1.
                                    WHEN "cod-entrega" then
                                        assign wh-cod-entrega-pd4000 = h-frame-1. 
                                    WHEN "dt-entorig" THEN
                                        ASSIGN wh-dt-entorig-pd4000 = h-frame-1.
                                    WHEN "cod-rota" THEN
                                        ASSIGN wh-cod-rota-pd4000 = h-frame-1.
                                    WHEN "wh-button-espdp079" THEN
                                        ASSIGN wh-button-espdp079-pd4000 = h-frame-1.
                                    WHEN "no-ab-reppri" THEN
                                        ASSIGN wh-nome-repres-pd4000     = h-frame-1.
                                    WHEN "btdeliveryaddress" THEN
                                        ASSIGN wh-btdelivery-pd4000 = h-frame-1.
                                    WHEN "dt-entrega" THEN
                                        ASSIGN wh-dt-entrega-page3-pd4000     = h-frame-1.
                                        
                                END CASE.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.
                        END.

                        CREATE BUTTONS             wh-btdelivery-aux-pd4000
                        ASSIGN FRAME             = wh-btdelivery-pd4000:FRAME
                               WIDTH             = wh-btdelivery-pd4000:WIDTH
                               HEIGHT            = wh-btdelivery-pd4000:HEIGHT
                               ROW               = wh-btdelivery-pd4000:ROW
                               COLUMN            = wh-btdelivery-pd4000:COLUMN
                               SENSITIVE         = YES                            
                               TRIGGERS:
                                    ON "choose" PERSISTENT RUN pi-choose-btdelivery IN h-pd4000-upc.        
                               END TRIGGERS.

                               wh-btdelivery-aux-pd4000:LOAD-IMAGE-UP (wh-btdelivery-pd4000:IMAGE-UP).

                        wh-cod-entrega-pd4000:VISIBLE = NO.
                        wh-cod-entrega-pd4000:SENSITIVE = NO.
                        wh-cod-entrega-pd4000:HIDDEN = YES.

                        CREATE TEXT           tx-cod-entrega-aux-pd4000
                        ASSIGN FRAME        = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:FRAME
                               WIDTH        = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:WIDTH
                               HEIGHT        = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:HEIGHT
                               FORMAT       = "x(14)"
                               SCREEN-VALUE = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:SCREEN-VALUE
                               ROW          = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:ROW
                               COLUMN       = wh-cod-entrega-pd4000:SIDE-LABEL-HANDLE:COLUMN + 1.3
                               VISIBLE      = YES.
                        
                        CREATE FILL-IN             wh-cod-entrega-aux-pd4000
                        ASSIGN FRAME             = wh-cod-entrega-pd4000:FRAME
                               DATA-TYPE         = wh-cod-entrega-pd4000:DATA-TYPE
                               WIDTH             = wh-cod-entrega-pd4000:WIDTH
                               HEIGHT            = wh-cod-entrega-pd4000:HEIGHT
                               FORMAT            = wh-cod-entrega-pd4000:FORMAT
                               SCREEN-VALUE      = wh-cod-entrega-pd4000:SCREEN-VALUE
                               ROW               = wh-cod-entrega-pd4000:ROW
                               COLUMN            = wh-cod-entrega-pd4000:COLUMN
                               SIDE-LABEL-HANDLE = tx-cod-entrega-aux-pd4000
                               SENSITIVE         = NO
                               VISIBLE           = YES
                               TRIGGERS:
                                    ON "LEAVE":U PERSISTENT RUN pi-leave-cod-entrega IN h-pd4000-upc.
                                    ON 'MOUSE-SELECT-DBLCLICK':U PERSISTENT RUN upc/pd4000-upcn.p.
                                    ON 'F5':U PERSISTENT RUN upc/pd4000-upcn.p.
                                END TRIGGERS.

                                wh-cod-entrega-aux-pd4000:MOVE-AFTER-TAB-ITEM(wh-dt-entorig-pd4000).
                                wh-cod-entrega-aux-pd4000:LOAD-MOUSE-POINTER("image/lupa.cur":U).
                                wh-btdelivery-aux-pd4000:MOVE-AFTER-TAB-ITEM(wh-cod-entrega-aux-pd4000).

                        IF VALID-HANDLE(wh-nome-abrev-tri-pd4000) AND VALID-HANDLE(wh-nome-transp-pd4000) AND
                           VALID-HANDLE(wh-nat-operacao-pd4000)   THEN DO:
                            on "leave" of wh-nome-abrev-tri-pd4000  persistent run upc/pd4000-upcj.p (INPUT wh-nome-abrev-tri-pd4000,
                                                                                                      INPUT wh-nome-transp-pd4000,
                                                                                                      INPUT wh-nat-operacao-pd4000,
                                                                                                      INPUT wh-cidade-cif-pd4000).
                        END.  

                        IF VALID-HANDLE(h-pd4000-upc) THEN ON 'LEAVE':U OF wh-nome-repres-pd4000 PERSISTENT RUN pi-leave-repres IN h-pd4000-upc.

                    END.
            
                    WHEN "fPage8" THEN DO:
                        IF v_cod_estab_usuar = "102" THEN DO:
                            ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                            ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.

                            DO WHILE VALID-HANDLE(h-frame-1):
                                IF h-frame-1:TYPE <> "field-group" THEN DO:
                                    CASE h-frame-1:NAME:
                                        WHEN "nat-operacao" THEN DO:
                                            ASSIGN wh-nat-operacao-pd4000 = h-frame-1.
                                        END.
                                    END.
                                    ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                                END.
                                ELSE LEAVE.
                            END.
                        END.
                    END.

                    WHEN "fPage6" THEN DO:
                        ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                        ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.

                        DO WHILE VALID-HANDLE(h-frame-1):
                            IF h-frame-1:TYPE <> "field-group" THEN DO:
                                CASE h-frame-1:NAME:
                                    WHEN "it-codigo" THEN
                                        ASSIGN wh-it-codigo-pd4000 = h-frame-1.
                                END.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.
                        END.
                    END.

                    WHEN "fPage7" THEN DO:
                        DO WHILE VALID-HANDLE(h-frame-1):
                            IF  h-frame-1:TYPE <> "field-group" THEN DO:
                                CASE h-frame-1:NAME:
                                    WHEN "nat-operacao" THEN DO:
                                        ASSIGN wh-nat-operacao-item-pd4000 = h-frame-1.
                                    END.                                       
                                END.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.
                        END.
                    END.

                    WHEN "fPage11" THEN DO:
                        ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                        ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.

                        DO WHILE VALID-HANDLE(h-frame-1):
                            IF h-frame-1:TYPE <> "field-group" THEN DO:
                                /* Rotina de comiss’o de representante */
                                RUN pi-frame-fPage11-comissao.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.
                        END.
                    END.
                END.
                ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        /* Rotina de comiss’o de representante */
        RUN pi-cria-button-comissao.
    END.
END.




/* Rotina de comiss’o de representantes */
IF p-ind-object  = "CONTAINER" AND 
   c-objeto      = "PD4000.W"  THEN DO:
    IF p-ind-event = "AfterDisplayRepresentative" THEN DO:
        IF VALID-HANDLE(whbtDeleteRepresentative-new) THEN DO:
            ASSIGN whbtDeleteRepresentative-new:VISIBLE   = YES
                   whbtDeleteRepresentative-new:SENSITIVE = YES
                   whbtAddRepresentative-new:VISIBLE      = YES    
                   whbtAddRepresentative-new:SENSITIVE    = YES.   
        END.
        IF VALID-HANDLE(whbtAddServInst-new) THEN
            ASSIGN whbtAddServInst-new:SENSITIVE = YES.
    END.
END.




/* Rotina de comiss’o de representantes */
IF p-ind-object  = "CONTAINER"                AND 
   c-objeto      = "PD4000.W"                 AND 
   p-ind-event   = "BEFORE-DESTROY-INTERFACE" THEN DO:
    ASSIGN vProgOrigemPD4000 = NO.
END.


/* setar os parametros iniciais do PD4000B */
IF p-ind-object = "VIEWER"                   AND
   c-objeto     = "PD4000.W"                 AND
   p-ind-event  = "AfterInitializeInterface" THEN
    RUN pi-seta-parametros.

IF  VALID-HANDLE(wh-bt-save-ord) THEN
    ASSIGN wh-bt-save-ord:VISIBLE = NO.

/* IF VALID-HANDLE(wh-btCopyOrder-pd4000) THEN    */
/*     ASSIGN wh-btCopyOrder-pd4000:VISIBLE = NO. */

IF  p-ind-event  = "AFTER-INITIALIZE"
AND p-ind-object = "CONTAINER" 
AND c-objeto     = "pd4000.w" THEN DO:

    IF NOT VALID-HANDLE(whit-codigo) THEN
        RUN pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'it-codigo':U,
                             input NO,
                             output whit-codigo).

    IF VALID-HANDLE(h-pd4000-upc) THEN
        ON "LEAVE":U OF whit-codigo PERSISTENT RUN pi-leave-item IN h-pd4000-upc.

    IF NOT VALID-HANDLE(whqt-un-fat) THEN
        RUN pi-busca-handle (input wh-frame-fpage6-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'qt-un-fat':U,
                             input NO,
                             output whqt-un-fat).

    IF VALID-HANDLE(whqt-un-fat) THEN DO:
        ON "LEAVE":U OF whqt-un-fat PERSISTENT RUN pi-leave-qt-un-fat IN h-pd4000-upc.
    END.

    IF NOT VALID-HANDLE(wh-cod-cond-pag-pd4000) THEN
        RUN pi-busca-handle (input wh-frame-fpage1-pd4000,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'cod-cond-pag':U,
                             input NO,
                             output wh-cod-cond-pag-pd4000).

    IF VALID-HANDLE(wh-cod-cond-pag-pd4000) THEN
        ON "LEAVE":U OF wh-cod-cond-pag-pd4000 PERSISTENT RUN pi-leave-cod-cond-pag IN h-pd4000-upc.


END.

if valid-handle(wh-txt-rec-pci-pd4000)
then assign wh-txt-rec-pci-pd4000:SENSITIVE             = YES
            wh-txt-cod-repres-pd4000:SENSITIVE          = YES
            wh-txt-cod-segmento-pd4000:SENSITIVE        = YES
            wh-txt-desc-topmilhao-pd4000:SENSITIVE      = YES
            wh-txt-desc-maisverde-pd4000:SENSITIVE      = YES
            wh-txt-desc-focounidade-pd4000:SENSITIVE    = YES
            wh-txt-desc-distrib20-pd4000:SENSITIVE      = YES
            wh-txt-desc-widecloud-pd4000:SENSITIVE      = YES
            wh-txt-segmento-pd4000:SENSITIVE            = YES
            wh-txt-rec-pci-pd4000:SCREEN-VALUE          = "Inf PCI":U
            wh-txt-cod-repres-pd4000:SCREEN-VALUE       = "Representante:":U
            wh-txt-cod-segmento-pd4000:SCREEN-VALUE     = "Segmenta»’o:":U
            wh-txt-desc-topmilhao-pd4000:SCREEN-VALUE   = "Desc Top Milh’o:":U
            wh-txt-desc-maisverde-pd4000:SCREEN-VALUE   = "Desc Mais Verde:":U
            wh-txt-desc-focounidade-pd4000:screen-value = "Desc Foco Unidade:":U
            wh-txt-desc-distrib20-pd4000:SCREEN-VALUE   = "Desc Distrib2.0:":U
            wh-txt-desc-widecloud-pd4000:SCREEN-VALUE   = "Desc Wide Cloud:":U
            wh-txt-segmento-pd4000:SCREEN-VALUE         = "Segmento:":U.


/************************************************************************
**                       PROCEDURES INTERNAS                          **
************************************************************************/
PROCEDURE pi-bt-local-entrega-alternativo:
//IDBA Bruno Joaquim - M2305-132 - 14/03/2024
     IF VALID-HANDLE(wh-nr-pedcli-pd4000) THEN DO:
        FIND FIRST ped-venda
            WHERE ped-venda.nr-pedcli = TRIM(wh-nr-pedcli-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            IF ped-venda.cod-sit-ped > 3 THEN DO:
                MESSAGE "Situa‡Æo do Pedido nÆo permite altera‡Æo do local de entrega alternativo" SKIP
                        "Apenas pedidos com situa‡Æo: Aberto e Atendido Parcial podem ser alterados" 
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
            ELSE DO:
                RUN esp\pdp\espdp106.w(ped-venda.nr-pedido).
            END.
        END.
     END.
END.


PROCEDURE pi-busca-transportadora:

    IF  VALID-HANDLE(wh-nome-abrev-tri-pd4000) 
    AND wh-nome-abrev-tri-pd4000:SCREEN-VALUE <> "" THEN DO:

        FOR FIRST loc-entr NO-LOCK WHERE
            loc-entr.nome-abrev  = wh-nome-abrev-tri-pd4000 :SCREEN-VALUE AND
            loc-entr.cod-entrega = wh-cod-entrega-pd4000    :SCREEN-VALUE:
            /* Busca Transportadora - Incidente 26357 */
            RUN esp/crm/escrm107.p (INPUT IF VALID-HANDLE(whCodEstabel) THEN whCodEstabel:SCREEN-VALUE ELSE "",
                                    INPUT STRING(emitente.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT IF VALID-HANDLE(wh-cd-unid-comerc-pd4000) THEN INT(wh-cd-unid-comerc-pd4000:SCREEN-VALUE) ELSE 0,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).

            IF c-cod-transp = ? THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17567,
                                       INPUT "NÆo encontrada transportadora para relacionamento UF x Cidade x Cliente.").
    
                ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = "".
                
                RETURN "NOK":U.
            END. /* IF c-cod-transp = ? THEN DO: */

            FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                ASSIGN c-nome-transp = transporte.nome-abrev.
            END. /* FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK: */

            RELEASE transporte.

            /****/
            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                   AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000 :SCREEN-VALUE NO-ERROR.
            IF AVAIL ped-venda THEN DO:

                FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                IF AVAIL int-ped-venda THEN DO:
                    RUN pi-validaTransp.
                END. /* IF AVAIL int-ped-venda THEN DO: */
                ELSE DO:
                    RUN pi-validaTranspSemPed.
                END. /* IF NOT AVAIL int-ped-venda THEN DO: */

            END. /* IF AVAIL ped-venda THEN DO: */
            ELSE DO:
                RUN pi-validaTranspSemPed.
            END. /* IF NOT AVAIL ped-venda THEN DO: */
            /****/

        END. /* FOR FIRST loc-entr WHERE */

    END. /* IF VALID-HANDLE(wh-nome-abrev-tri-pd4000) AND wh-nome-abrev-tri-pd4000:SCREEN-VALUE <> "" THEN DO: */
    ELSE DO:
        FOR FIRST loc-entr NO-LOCK 
            WHERE loc-entr.nome-abrev  = emitente.nome-abrev  
              AND loc-entr.cod-entrega = wh-cod-entrega-pd4000:SCREEN-VALUE:

            /* Busca Transportadora - Incidente 26357 */
            RUN esp/crm/escrm107.p (INPUT IF VALID-HANDLE(whCodEstabel) THEN whCodEstabel:SCREEN-VALUE ELSE "",
                                    INPUT STRING(emitente.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT IF VALID-HANDLE(wh-cd-unid-comerc-pd4000) THEN INT(wh-cd-unid-comerc-pd4000:SCREEN-VALUE) ELSE 0,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).
            
            IF c-cod-transp = ? THEN DO:
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17567,
                                   INPUT "NÆo encontrada transportadora para relacionamento UF x Cidade x Cliente.").

                IF VALID-HANDLE(wh-nome-transp-pd4000) THEN
                    ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = "".

                
                RETURN "NOK":U.
            END.
            ELSE DO:
                FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                    ASSIGN c-nome-transp = transporte.nome-abrev.
                END.
                
            END.
            RELEASE transporte.

            /****/
            IF  VALID-HANDLE(wh-nr-pedcli-pd4000 )
            AND VALID-HANDLE(wh-nome-abrev-pd4000) THEN
            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
                   AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
            IF AVAIL ped-venda THEN DO:

                FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                IF AVAIL int-ped-venda THEN DO:
                    RUN pi-validaTransp.
                END. /* IF AVAIL int-ped-venda THEN DO: */
                ELSE DO:
                    RUN pi-validaTranspSemPed.
                END. /* IF NOT AVAIL int-ped-venda THEN DO: */

            END. /* IF AVAIL ped-venda THEN DO: */
            ELSE DO:
                RUN pi-validaTranspSemPed.
            END. /* IF NOT AVAIL ped-venda THEN DO: */
            /****/

        END. /* FOR FIRST loc-entr WHERE */

    END. /* ELSE DO: */

END PROCEDURE.


/* Procedures da Rotina de comiss’o de representantes */
PROCEDURE pi-frame-principal-comissao:
    CASE h-frame:NAME:
        WHEN "nr-pedcli" THEN
            ASSIGN whPedCli = h-frame.
        WHEN "nome-abrev" THEN
            ASSIGN whFinome-abrev = h-frame.
    END.
END PROCEDURE.


PROCEDURE pi-frame-fPage11-comissao:
    CASE h-frame-1:NAME:
        WHEN "nome-ab-rep" THEN
            ASSIGN whbtAddServInst = h-frame-1.
        WHEN "btDeleteRepresentative" THEN
            ASSIGN whbtDeleteRepresentative = h-frame-1.
        WHEN "btAddRepresentative" THEN
            ASSIGN whbtAddRepresentative = h-frame-1.
    END.
END PROCEDURE.


PROCEDURE pi-cria-button-comissao:
    IF VALID-HANDLE(whbtDeleteRepresentative) THEN DO:
        CREATE BUTTON whbtDeleteRepresentative-new
        ASSIGN FRAME     = whbtDeleteRepresentative:FRAME
               WIDTH     = whbtDeleteRepresentative:WIDTH
               HEIGHT    = whbtDeleteRepresentative:HEIGHT
               ROW       = whbtDeleteRepresentative:ROW
               LABEL     = whbtDeleteRepresentative:LABEL
               COL       = whbtDeleteRepresentative:COL
               SENSITIVE = whbtDeleteRepresentative:SENSITIVE
               VISIBLE   = NO
        TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc/pd4000-upca.p.
        END TRIGGERS.

        whbtDeleteRepresentative-new:LOAD-IMAGE-UP(whbtDeleteRepresentative:IMAGE-UP).
        whbtDeleteRepresentative-new:LOAD-IMAGE-INSENSITIVE(whbtDeleteRepresentative:IMAGE-INSENSITIVE).
    END.

    IF VALID-HANDLE(whbtAddRepresentative) THEN DO:
        CREATE BUTTON whbtAddRepresentative-new
        ASSIGN FRAME     = whbtAddRepresentative:FRAME
               WIDTH     = whbtAddRepresentative:WIDTH
               HEIGHT    = whbtAddRepresentative:HEIGHT
               ROW       = whbtAddRepresentative:ROW
               LABEL     = whbtAddRepresentative:LABEL
               COL       = whbtAddRepresentative:COL
               SENSITIVE = whbtAddRepresentative:SENSITIVE
               VISIBLE   = NO
        TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc/pd4000-upcb.p.
        END TRIGGERS.

        whbtAddRepresentative-new:LOAD-IMAGE-UP(whbtAddRepresentative:IMAGE-UP).
        whbtAddRepresentative-new:LOAD-IMAGE-INSENSITIVE(whbtAddRepresentative:IMAGE-INSENSITIVE).
    END.
END PROCEDURE.
/* Procedures da Rotina de comiss’o de representantes */


PROCEDURE pi-seta-parametros:
    DEFINE VARIABLE l-mostrar-saldo-item AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-reabrir-cotacao    AS LOGICAL    NO-UNDO.

    RUN pi-OutputParameters IN p-wgh-object (OUTPUT TABLE tt-ped-param,
                                             OUTPUT l-mostrar-saldo-item,
                                             OUTPUT l-reabrir-cotacao).

    FIND FIRST tt-ped-param NO-LOCK NO-ERROR.

    IF AVAIL tt-ped-param THEN
        ASSIGN tt-ped-param.relacao-item-cli     = YES  /* tg-relacao-item-cli */
               tt-ped-param.tp-relacao-item-cli  = 1    /* rs-tp-relacao-item-cli */
               tt-ped-param.tp-exp-nat-oper      = 1    /* rs-tp-exp-nat-oper */
               tt-ped-param.tp-exp-dt-entrega    = 1    /* rs-tp-exp-dt-entrega */
               tt-ped-param.exp-nat-cod-mensagem = YES. /* tg-exp-nat-cod-mensagem */

    RUN pi-InputParameters IN p-wgh-object (INPUT TABLE tt-ped-param,
                                            INPUT l-mostrar-saldo-item,
                                            INPUT l-reabrir-cotacao).

END PROCEDURE.


PROCEDURE piMessage:
    MESSAGE 'p-ind-event  ' p-ind-event  SKIP
            'p-ind-object ' p-ind-object SKIP
            'p-cod-table  ' p-cod-table  SKIP
            'p-row-table  ' string(p-row-table) SKIP
             c-objeto
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.               


PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-obj):
        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto " wgh-obj:NAME SKIP
                    "Type do Objeto " wgh-obj:TYPE skip
                    "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF wgh-obj:TYPE = pObjType AND 
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.


PROCEDURE pi-trataPedidoASTEC:
    RUN validaCanais .
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    FIND FIRST int-ped-item-astec NO-LOCK 
        WHERE int-ped-item-astec.nr-pedcli = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.
    IF AVAIL int-ped-item-astec THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "InclusÆo NÆo permitida." +
                                                              "~~" +
                                                              "NÆo ² permitido InclusÆo de ITEM, manualmente, nos pedidos da ASTEC").

        RETURN "NOK":U.
    END. /* IF AVAIL int-ped-item-astec THEN DO: */
    ELSE 
        RUN pi-btAddItem IN p-wgh-object.

END PROCEDURE.

PROCEDURE pi-confirma-item: /*!!!!!!!!!!!!!!*/

    DEFINE VARIABLE cNomeAbrev    LIKE int-ped-item.nome-abrev               NO-UNDO.
    DEFINE VARIABLE cNrPedCli     LIKE int-ped-item.nr-pedcli                NO-UNDO.
    DEFINE VARIABLE iNrSequencia  LIKE int-ped-item.nr-sequencia             NO-UNDO.
    DEFINE VARIABLE cItcodigo     LIKE int-ped-item.it-codigo                NO-UNDO.
    DEFINE VARIABLE cCodrefer     LIKE int-ped-item.cod-refer                NO-UNDO.
    DEFINE VARIABLE cNrOs         LIKE int-ped-item.nr-os                    NO-UNDO.
    DEFINE VARIABLE desc-antigo   LIKE int-ped-item-pci.desc-neg-comercial   NO-UNDO.
    DEFINE VARIABLE l-muda-status AS LOGICAL                                 NO-UNDO.

    DEFINE BUFFER b1-ped-item FOR ped-item.

    ASSIGN cNomeAbrev   = wh-nome-abrev-pd4000:SCREEN-VALUE
       cNrPedCli    = wh-nr-pedcli-pd4000:SCREEN-VALUE
       iNrSequencia = INTEGER(whnr-sequencia-pd4000:SCREEN-VALUE)
       cItCodigo    = whit-codigo:SCREEN-VALUE
       cCodRefer    = wh-cod-refer-pd4000:SCREEN-VALUE
       cNrOs        = wh-nr-os-pd4000:SCREEN-VALUE.

    IF VALID-HANDLE(wh-desc-comercial) THEN DO:
        ASSIGN perc-desc-comercial = DEC(wh-desc-comercial:SCREEN-VALUE) .
        
        //Busca informa‡äes da tabela especifica int-ped-item-pci para gravar campo de desconto comercial
        ASSIGN perc-desc-comercial = DEC(wh-desc-comercial:SCREEN-VALUE) .
    
        FIND FIRST int-ped-item-pci WHERE int-ped-item-pci.nome-abrev   = cNomeAbrev  
                                      AND int-ped-item-pci.nr-pedcli    = cNrPedCli   
                                      AND int-ped-item-pci.nr-sequencia = iNrSequencia
                                      AND int-ped-item-pci.it-codigo    = cItCodigo   
                                      AND int-ped-item-pci.cod-refer    = cCodRefer NO-ERROR.
        IF NOT AVAIL int-ped-item-pci THEN DO:
            CREATE int-ped-item-pci.
            ASSIGN int-ped-item-pci.nome-abrev         = cNomeAbrev   
                   int-ped-item-pci.nr-pedcli          = cNrPedCli    
                   int-ped-item-pci.nr-sequencia       = iNrSequencia 
                   int-ped-item-pci.it-codigo          = cItCodigo    
                   int-ped-item-pci.cod-refer          = cCodRefer 
                   int-ped-item-pci.desc-neg-comercial = perc-desc-comercial . //decimal(wh-desc-comercial:SCREEN-VALUE) .
            ASSIGN l-muda-status = YES.

        END.
        ELSE DO:
            IF int-ped-item-pci.desc-neg-comercial <> perc-desc-comercial THEN DO:
                ASSIGN l-muda-status = YES.
                ASSIGN int-ped-item-pci.desc-neg-comercial = perc-desc-comercial. //decimal(wh-desc-comercial:SCREEN-VALUE) .
            END.
        END.  
        
    END.


    RUN pi-muda-natureza-do-item.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "espdp079":U,
                       INPUT  5,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto  NO-ERROR.

    IF TODAY + (365 * int(tt-prog-ponto.conteudo)) < date(wh-dt-entrega-pd4000:SCREEN-VALUE) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data de entrega superior a " + tt-prog-ponto.conteudo + " anos!":U).
        RETURN "NOK".
    END.
    
    APPLY "choose" TO wh-bt-confirma-item-pd4000.
    
    RUN pi-add-nr-os-item (INPUT cNomeAbrev,
                           INPUT cNrPedCli,
                           INPUT iNrSequencia,
                           INPUT cItCodigo,
                           INPUT cCodRefer,
                           INPUT cNrOs).

    /* Caso NÆo tenha sido criado*/
    FIND FIRST int-ped-item
        WHERE int-ped-item.nome-abrev   = cNomeAbrev
          AND int-ped-item.nr-pedcli    = cNrPedCli
          AND int-ped-item.nr-sequencia = iNrSequencia
          AND int-ped-item.it-codigo    = cItCodigo
          AND int-ped-item.cod-refer    = cCodRefer NO-LOCK NO-ERROR.

    IF  NOT AVAILABLE int-ped-item THEN DO:
        CREATE int-ped-item.
        ASSIGN int-ped-item.nome-abrev   = cNomeAbrev
               int-ped-item.nr-pedcli    = cNrPedCli
               int-ped-item.nr-sequencia = iNrSequencia
               int-ped-item.it-codigo    = cItCodigo
               int-ped-item.cod-refer    = cCodRefer.
    
        FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
        RELEASE int-ped-item.
    END.

    IF VALID-HANDLE(wh-btcompleteorder-ped4000) THEN DO:
        ASSIGN wh-btcompleteorder-ped4000:VISIBLE = NO.
    END.
    RUN pi-atualizaSupervisor.
    IF VALID-HANDLE(wh-desc-comercial) THEN
    ASSIGN wh-desc-comercial:SENSITIVE = NO.
    
    //Se teve alteracao nos descontos do pedido seta o status de completo = no
    IF AVAIL ped-venda AND l-muda-status = YES THEN DO:
        ASSIGN ped-venda.completo = NO .
    END.

END PROCEDURE.


PROCEDURE pi-muda-natureza:

    IF p-ind-event = "AfterDisplayOrder" AND valid-handle(wh-nome-abrev-pd4000) THEN do:

        FIND FIRST emitente
            WHERE emitente.nome-abrev =  wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:

            IF l-inclusao-pd4000 = YES then do:
                FIND FIRST int-canal-cliente
                    WHERE int-canal-cliente.cod-emitente = emitente.cod-emitente
                      AND int-canal-cliente.cod-estabel  = v_cod_estab_usuar NO-LOCK NO-ERROR.
                IF AVAIL int-canal-cliente THEN
                    ASSIGN wh-cod-canal-venda-pd4000:SCREEN-VALUE = STRING(int-canal-cliente.cod-canal-venda).

                ASSIGN wh-perc-desco1-pd4000:SCREEN-VALUE = STRING(0).
            END. /* IF l-inclusao-pd4000 = YES then do: */

            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'fill-in':U,
                                 input 'cod-estabel':U,
                                 input NO,
                                 output whCodEstabel).

            run pi-busca-handle (input wh-frame-fpage1-pd4000,
                                 input p-ind-event,
                                 input 'fill-in':U,
                                 input 'nat-operacao':U,
                                 input NO,
                                 output wh-nat-operacao-pd4000).

            FIND FIRST ped-venda
                WHERE ped-venda.nr-pedcli = wh-nr-pedcli-pd4000:SCREEN-VALUE
                  AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.

            IF valid-handle(wh-nat-operacao-pd4000)            and
               VALID-HANDLE( whCodEstabel)                     and
              (NOT AVAIL ped-venda                             or
              (AVAIL ped-venda AND ped-venda.cod-sit-ped < 3)) then do:


                IF AVAIL ped-venda AND
                   ped-venda.nr-tabpre = "ICOMP02" THEN DO:
                    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                        WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                    IF NOT AVAIL int-ped-venda THEN DO:
                        CREATE int-ped-venda.
                        ASSIGN int-ped-venda.nr-pedido       = ped-venda.nr-pedido
                               int-ped-venda.cod-estabel     = ped-venda.cod-estabel.    
                    END.
                    ELSE
                        ASSIGN int-ped-venda.cod-estabel     = ped-venda.cod-estabel.    

                    ASSIGN OVERLAY(INT-PED-VENDA.char-1,10,1) = "S".
                    RELEASE int-ped-venda.
                END.
                
                EMPTY TEMP-TABLE tt-prog-ponto-nat-oper.
                RUN esp/es0018p.p (INPUT  "pd4000":U,
                                   INPUT  13,
                                   INPUT  0,
                                   INPUT  "":U,
                                   OUTPUT TABLE tt-prog-ponto-nat-oper).

                FIND FIRST tt-prog-ponto-nat-oper 
                     WHERE entry(1,tt-prog-ponto-nat-oper.conteudo,";") = whCodEstabel:SCREEN-VALUE 
                       AND entry(2,tt-prog-ponto-nat-oper.conteudo,";") = string(emitente.cod-emitente)  NO-ERROR.
                IF AVAIL tt-prog-ponto-nat-oper THEN
                    ASSIGN wh-nat-operacao-pd4000:SCREEN-VALUE = entry(3,tt-prog-ponto-nat-oper.conteudo,";").

                RUN pi-verifica-se-valida-natureza (INPUT wh-nat-operacao-pd4000:SCREEN-VALUE,
                                                    INPUT whCodEstabel:SCREEN-VALUE,
                                                    OUTPUT l-valida-natureza).

                IF l-valida-natureza = YES THEN DO:
                    IF whcb-cod-des-mer-pd4000:SCREEN-VALUE begins("Com") THEN
                        ASSIGN l-consumidor-final = NO.
                    ELSE
                        ASSIGN l-consumidor-final = YES.

                    IF  emitente.natureza <> 3 
                    AND emitente.contrib-icms = NO
                    AND (emitente.ins-estadual = ""
                    OR   emitente.ins-estadual = "ISENTO"
                    OR   emitente.ins-estadual = "ISENTA") THEN
                        ASSIGN l-consumidor-final = YES.

                    RUN esbo/boes505.p PERSISTENT SET h-boes505.
                    RUN defineNatOperacao IN h-boes505 (INPUT whCodEstabel:SCREEN-VALUE,
                                                        INPUT emitente.cod-emitente,
                                                        INPUT wh-cod-entrega-pd4000:SCREEN-VALUE,
                                                        INPUT "",
                                                        INPUT l-consumidor-final,
                                                        OUTPUT c-nat-oper,
                                                        OUTPUT l-return).
                    DELETE PROCEDURE h-boes505.

                    IF l-return = YES THEN DO:
                        ASSIGN wh-nat-operacao-pd4000:SCREEN-VALUE = c-nat-oper.
                    END.
                    ELSE DO:
                        IF VALID-HANDLE(wh-nat-operacao-pd4000) THEN DO:
                            ASSIGN wh-nat-operacao-pd4000:SCREEN-VALUE = "".
                            run utp/ut-msgs.p (INPUT "show":U,
                                               INPUT 17567,
                                               INPUT "Natureza de oreca‡Æo NÆo encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015" ).

                            RETURN "NOK":U.
                        END.
                    END.
                END.

                FIND FIRST usuar-nat-operacao
                    WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                      AND wh-nat-operacao-pd4000:SCREEN-VALUE           BEGINS usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.
                IF NOT AVAIL usuar-nat-operacao THEN DO:
                    FIND FIRST usuar-nat-operacao
                        WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                          AND usuar-nat-operacao.nat-operacao = "*" NO-LOCK NO-ERROR.
                    IF NOT AVAIL usuar-nat-operacao THEN DO:
                        run utp/ut-msgs.p (INPUT "show":U,
                                               INPUT 17567,
                                               INPUT "Solicite para o grupo.fiscal libera‡Æo da natureza de oreca‡Æo " + wh-nat-operacao-pd4000:SCREEN-VALUE + " para o usuÿrio: " + v_cod_usuar_corren + "." ).
                            RETURN "NOK":U. 

                    END.
                END.

                FIND FIRST unid-feder NO-LOCK
                    WHERE unid-feder.pais = emitente.pais
                    AND   unid-feder.estado = emitente.estado NO-ERROR.
                FIND estabelec
                    WHERE estabelec.cod-estabel = whCodEstabel:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
                
                /*BHJ*/

                FOR each ped-ITEM
                    WHERE PED-ITEM.nr-pedcli  = ped-venda.nr-pedcli 
                      AND PED-ITEM.nome-abrev = ped-venda.nome-abrev, //NO-LOCK,
                    FIRST item NO-LOCK
                    WHERE ITEM.it-codigo = ped-item.it-codigo:
                    //ASSIGN ped-item.ind-icm-ret = NO.
                    ASSIGN l-ind-icm-ret = NO.

                    IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:

                       FIND FIRST item-uf NO-LOCK
                           WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
                             AND item-uf.cod-estado-orig = estabelec.estado
                             AND item-uf.estado          = emitente.estado NO-ERROR.
                       FIND FIRST dist-emitente OF emitente NO-LOCK NO-ERROR.

                       FIND FIRST natur-oper
                           WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.
                       IF AVAIL natur-oper THEN DO:
                           if  natur-oper.subs-trib AND
                              AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = ""
                              AND emitente.insc-subs-trib = "" THEN  DO:

                              //ASSIGN ped-item.ind-icm-ret = YES.
                               ASSIGN l-ind-icm-ret = YES.
                           END.
                       END. /* IF AVAIL natur-oper THEN DO: */

                    END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */
                    

                  //  FIND CURRENT PED-ITEM EXCLUSIVE-LOCK NO-ERROR.
                    ASSIGN ped-item.ind-icm-ret = l-ind-icm-ret . 

                  //  FIND CURRENT PED-ITEM NO-LOCK NO-ERROR.

                END.

            END. /* IF valid-handle(wh-nat-operacao-pd4000) */

        END. /* IF AVAIL emitente THEN DO: */

    END.

END PROCEDURE.

PROCEDURE pi-muda-natureza-do-item:

    FIND ped-venda
        WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
          AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF AVAIL ped-venda AND ped-venda.cod-sit-ped < 3 THEN DO:
        FOR each ped-ITEM
            WHERE PED-ITEM.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
              AND PED-ITEM.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND PED-ITEM.it-codigo  = whit-codigo:SCREEN-VALUE,
            FIRST item NO-LOCK
            WHERE ITEM.it-codigo = ped-item.it-codigo:
            IF ITEM.baixa-estoq = NO THEN
                ASSIGN ped-item.tipo-atend = 2.
        END.

        IF ped-venda.nat-operacao BEGINS "8000" THEN DO: /* Natureza de servi‡o - chamado IR95994 */
            FOR FIRST item NO-LOCK
                WHERE ITEM.it-codigo = whit-codigo:SCREEN-VALUE:
                IF ITEM.baixa-estoq  = YES THEN
                    ASSIGN wh-nat-operacao-item-pd4000:SCREEN-VALUE =  "800004".
                ELSE
                    ASSIGN wh-nat-operacao-item-pd4000:SCREEN-VALUE =  "800001".
            END.
            RETURN "OK":U.
        END.


        RUN pi-verifica-se-valida-natureza (INPUT wh-nat-operacao-item-pd4000:SCREEN-VALUE, 
                                            INPUT ped-venda.cod-estabel,
                                            OUTPUT l-valida-natureza).
        
        IF l-valida-natureza = YES THEN DO:
            IF ped-venda.cod-des-merc = 1 THEN
                ASSIGN l-consumidor-final = NO.
            ELSE
                ASSIGN l-consumidor-final = YES.

            FIND FIRST emitente
                 WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

            IF  emitente.natureza <> 3 
            AND emitente.contrib-icms = NO
            AND (emitente.ins-estadual = ""
            OR   emitente.ins-estadual = "ISENTO"
            OR   emitente.ins-estadual = "ISENTA") THEN
                ASSIGN l-consumidor-final = YES.
                    
            RUN esbo/boes505.p PERSISTENT SET h-boes505.

            RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                                INPUT ped-venda.cod-emitente,
                                                INPUT wh-cod-entrega-pd4000:SCREEN-VALUE,
                                                INPUT whit-codigo:SCREEN-VALUE,
                                                INPUT l-consumidor-final,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
            DELETE PROCEDURE h-boes505.

            IF l-return = YES THEN DO:
                IF wh-nat-operacao-item-pd4000:SCREEN-VALUE <> c-nat-oper THEN DO:
                    MESSAGE "Natureza de opra‡Æo alterada conforme cadastro escdp015, de " wh-nat-operacao-item-pd4000:SCREEN-VALUE " Para " c-nat-oper " , duvidas entrar em contato com GRUPO.TRIBUTARIO"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    ASSIGN wh-nat-operacao-item-pd4000:SCREEN-VALUE = c-nat-oper.
            
                    FIND FIRST unid-feder NO-LOCK
                        WHERE unid-feder.pais   = emitente.pais
                          AND unid-feder.estado = emitente.estado NO-ERROR.
                    FIND estabelec
                        WHERE estabelec.cod-estabel = ped-venda.cod-estabel
                        NO-LOCK NO-ERROR.

                    FOR each ped-ITEM
                        WHERE PED-ITEM.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
                          AND PED-ITEM.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                          AND PED-ITEM.it-codigo  = whit-codigo:SCREEN-VALUE : //NO-LOCK :
                        ASSIGN ped-item.nat-operacao = c-nat-oper.
                        /**/
                        //ASSIGN ped-item.ind-icm-ret = NO.
                        ASSIGN l-ind-icm-ret = NO.

                        IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:

                           FIND FIRST item-uf NO-LOCK
                               WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
                                 AND item-uf.cod-estado-orig = estabelec.estado
                                 AND item-uf.estado          = emitente.estado NO-ERROR.
                           FIND FIRST dist-emitente OF emitente NO-LOCK NO-ERROR.
        
                           FIND FIRST natur-oper
                               WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.
                           IF AVAIL natur-oper THEN DO:
                               if  natur-oper.subs-trib AND
                                  AVAIL item-uf AND 
                                  AVAIL dist-emitente AND 
                                  dist-emitente.nr-tb-pauta = "" AND 
                                  emitente.insc-subs-trib   = "" THEN  DO:

                                  //ASSIGN ped-item.ind-icm-ret = YES.
                                   ASSIGN l-ind-icm-ret = YES.
                               END.
                           END. /* IF AVAIL natur-oper THEN DO: */

                        END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */
                        /**/

                        //FIND CURRENT ped-item EXCLUSIVE-LOCK.
                        ASSIGN  ped-item.ind-icm-ret = l-ind-icm-ret.
                        //FIND CURRENT ped-item NO-LOCK.
                        
                    END.
                END.
            END.
            ELSE DO:
                IF VALID-HANDLE(wh-nat-operacao-item-pd4000) THEN DO:
                    ASSIGN wh-nat-operacao-item-pd4000:SCREEN-VALUE = "".
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17567,
                                       INPUT "Natureza de oreca‡Æo NÆo encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015" ).
                    RETURN "NOK":U. 
                END.
            END.
        END.
        

        FIND FIRST usuar-nat-operacao
            WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
              AND wh-nat-operacao-item-pd4000:SCREEN-VALUE           BEGINS usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.
        IF NOT AVAIL usuar-nat-operacao THEN DO:
            FIND FIRST usuar-nat-operacao
                WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                  AND usuar-nat-operacao.nat-operacao = "*" NO-LOCK NO-ERROR.
            IF NOT AVAIL usuar-nat-operacao THEN DO:
                run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17567,
                                       INPUT "Solicite para o grupo.fiscal libera‡Æo da natureza de oreca‡Æo " + wh-nat-operacao-item-pd4000:SCREEN-VALUE + " para o usuÿrio: " + v_cod_usuar_corren + "." ).
                    RETURN "NOK":U.

            END.
        END.
    END.
END PROCEDURE.


PROCEDURE pi-muda-natureza-do-item-muda-estabel:
    
    FIND ped-venda
        WHERE ped-venda.nr-pedcli = wh-nr-pedcli-pd4000:SCREEN-VALUE
          AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR. 
    FIND EMITENTE
         WHERE emitente.cod-emitente = ped-venda.cod-emitente
         NO-LOCK NO-ERROR.
    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.pais   = emitente.pais
          AND unid-feder.estado = emitente.estado NO-ERROR.
    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel
        NO-LOCK NO-ERROR.
    IF AVAIL ped-venda AND ped-venda.cod-sit-ped < 3 THEN DO:
        FOR each ped-ITEM NO-LOCK
            WHERE PED-ITEM.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
              AND PED-ITEM.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND ped-item.cod-sit-item < 3,
            FIRST item NO-LOCK
            WHERE ITEM.it-codigo = ped-item.it-codigo:
            
            RUN pi-verifica-se-valida-natureza (INPUT ped-item.nat-operacao,
                                                INPUT ped-venda.cod-estabel,
                                                OUTPUT l-valida-natureza).

            IF l-valida-natureza = YES THEN DO:
                IF ped-venda.cod-des-merc = 1 THEN
                    ASSIGN l-consumidor-final = NO.
                ELSE
                    ASSIGN l-consumidor-final = YES.
                    
                IF  emitente.natureza <> 3 
                AND emitente.contrib-icms = NO
                AND (emitente.ins-estadual = ""
                OR   emitente.ins-estadual = "ISENTO"
                OR   emitente.ins-estadual = "ISENTA") THEN
                    ASSIGN l-consumidor-final = YES.
                        
                RUN esbo/boes505.p PERSISTENT SET h-boes505.
    
                RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                                    INPUT ped-venda.cod-emitente,
                                                    INPUT wh-cod-entrega-pd4000:SCREEN-VALUE,
                                                    INPUT PED-ITEM.it-codigo,
                                                    INPUT l-consumidor-final,
                                                    OUTPUT c-nat-oper,
                                                    OUTPUT l-return).
                DELETE PROCEDURE h-boes505.

                IF l-return = YES THEN DO:
                    IF ped-item.nat-operacao <> c-nat-oper THEN DO:

                        FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.

                        ASSIGN ped-item.nat-operacao = c-nat-oper.
                        /**/
                        ASSIGN ped-item.ind-icm-ret = NO.

                        IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:

                           FIND FIRST item-uf NO-LOCK
                               WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
                                 AND item-uf.cod-estado-orig = estabelec.estado
                                 AND item-uf.estado          = emitente.estado NO-ERROR.
                           FIND FIRST dist-emitente OF emitente NO-LOCK NO-ERROR.
        
                           FIND natur-oper
                               WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.
                           IF AVAIL natur-oper THEN DO:
                               if  natur-oper.subs-trib AND
                                  AVAIL item-uf AND 
                                  AVAIL dist-emitente AND 
                                  dist-emitente.nr-tb-pauta = "" AND 
                                  emitente.insc-subs-trib = "" THEN  DO:

                                  ASSIGN ped-item.ind-icm-ret = YES.
                               END.
                           END. /* IF AVAIL natur-oper THEN DO: */

                        END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */
                        /**/

                        FIND CURRENT ped-item NO-LOCK NO-ERROR.
                    END.
                END.
                ELSE DO:
                        run utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 17567,
                                           INPUT "Natureza de oreca‡Æo NÆo encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015" ).
                         RETURN "NOK":U. 
                END.   
            END.
            FIND FIRST usuar-nat-operacao
                WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                  AND ped-item.nat-operacao           BEGINS usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.
            IF NOT AVAIL usuar-nat-operacao THEN DO:
                FIND FIRST usuar-nat-operacao
                    WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                      AND usuar-nat-operacao.nat-operacao = "*" NO-LOCK NO-ERROR.
                IF NOT AVAIL usuar-nat-operacao THEN DO:
                    run utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 17567,
                                           INPUT "Solicite para o grupo.fiscal libera‡Æo da natureza de operca‡Æo " + ped-item.nat-operacao + " para o usuÿrio: " + v_cod_usuar_corren + "." ).
                        RETURN "NOK":U.

                END.
            END.
        END.  
    END.

END PROCEDURE.


PROCEDURE pi-verifica-se-valida-natureza:
    DEF INPUT  PARAMETER c-natureza AS CHARACTER.
    DEF INPUT  PARAMETER pEstab     AS CHAR.
    DEF OUTPUT PARAMETER l-valida   AS LOGICAL.

    ASSIGN l-valida = YES.
    IF AVAIL ped-venda AND
       (ped-venda.nat-operacao BEGINS "6949" OR
        ped-venda.nat-operacao BEGINS "5949") THEN /* assistencia tecnica nao devera mudar */
       ASSIGN l-valida = NO.
    ELSE
        IF c-natureza <> "" THEN DO:
                 
            FIND natur-oper
                WHERE natur-oper.nat-operacao = c-natureza NO-LOCK NO-ERROR.
            IF AVAIL emitente and emitente.natureza = 4 THEN 
               ASSIGN l-valida = NO.
            ELSE
                IF AVAIL natur-oper THEN               /* devera ser alterado tambem no bodi159com-upc.p */
                    IF  natur-oper.cod-mensagem    = 11  OR
                        natur-oper.cod-mensagem    = 31  OR
                        natur-oper.cod-mensagem    = 70  OR
                        natur-oper.cod-mensagem    = 83  OR
                        natur-oper.cod-mensagem    = 120 OR
                        natur-oper.cod-mensagem    = 816 OR
                        natur-oper.cod-mensagem    = 819 OR
                        natur-oper.cod-mensagem    = 834 OR
                        natur-oper.cod-mensagem    = 906 OR
                        natur-oper.log-oper-triang = YES OR
                        natur-oper.nat-operacao BEGINS "8" OR //Natureza de servico/locacao
                        natur-oper.tipo            = 3 THEN /* Venda de ativo imobilizado */
                        	ASSIGN l-valida = NO.
                    ELSE
                        IF natur-oper.emite-duplic = YES THEN
                            ASSIGN l-valida = YES.
                        ELSE
                            ASSIGN l-valida = NO.
               
                ELSE
                    ASSIGN l-valida = YES.
        END.
        ELSE
            ASSIGN l-valida = YES.

     /*IF pTipo <> 2 THEN DO: /*Nao le quando for muda-item*/
        FIND FIRST user-coml NO-LOCK //M2107-068
             WHERE user-coml.usuario     = c-seg-usuario
               AND user-coml.inf-natoper = YES NO-ERROR.
        IF AVAIL user-coml THEN
            ASSIGN l-valida = NO.
     END. */

     FIND emitente
         WHERE emitente.nome-abrev =  wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
     
     IF pEstab = "105" AND AVAIL emitente AND emitente.estado <> "RS" THEN DO: //entreposto
         RUN esp/es0018p.p (INPUT "espdp079",
                            INPUT 2,
                            INPUT 0,
                            INPUT "", 
                            OUTPUT TABLE tt-prog-ponto).

         IF CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = c-natureza)  THEN
             ASSIGN l-valida = NO.

     END.

     IF pEstab BEGINS "6" THEN DO: //Natureza Decio
         RUN esp/es0018p.p (INPUT "espdp079",
                            INPUT 4,
                            INPUT 0,
                            INPUT "", 
                            OUTPUT TABLE tt-prog-ponto).

         IF CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = c-natureza)  THEN
             ASSIGN l-valida = NO.

     END.


END PROCEDURE.


PROCEDURE pi-leave-tp-pedido:

    IF VALID-HANDLE(wh-vl-frete-pd4000) THEN
        ASSIGN wh-vl-frete-pd4000:SENSITIVE = NO.

    FIND FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "pd4000":U
          AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.

    IF AVAILABLE ponto-programa THEN DO:
        FOR EACH conteudo-programa
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
            
            IF conteudo-programa.conteudo = TRIM(wh-tp-pedido-pd4000:SCREEN-VALUE) THEN DO:
                IF VALID-HANDLE(wh-vl-frete-pd4000) THEN
                    ASSIGN wh-vl-frete-pd4000:SENSITIVE = YES.
                LEAVE.
            END.
        END.
    END.
    IF NOT wh-vl-frete-pd4000:SENSITIVE THEN DO:
        IF VALID-HANDLE(wh-nr-pedcli-pd4000) THEN DO:

            FIND FIRST ped-venda
                WHERE ped-venda.nr-pedcli = TRIM(wh-nr-pedcli-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
            IF AVAILABLE ped-venda THEN DO:

                FIND FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.


                IF AVAILABLE int-ped-venda THEN
                    ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = STRING(int-ped-venda.vl-frete).
                ELSE
                    ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.
            END.
            ELSE
                ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.
        END.
        ELSE
            ASSIGN wh-vl-frete-pd4000:SCREEN-VALUE = "0":U.
    END.
    /*Valida se for pedido B2B desabilita o campo supervisor.
    IF  wh-nome-abrev-pd4000:SCREEN-VALUE <> '' THEN DO:
        FIND FIRST emitente
            WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE emitente THEN DO:
            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN DO:

                IF int-emitente.ind-participa-canais = 993520001 THEN DO:
                    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
                        ASSIGN wh-supervisor-pd4000:SENSITIVE = NO.
                END. /* IF int-emitente.ind-participa-canais = 993520001 THEN DO: */
                ELSE DO:
                    IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
                        ASSIGN wh-supervisor-pd4000:SENSITIVE = YES.
                END.

            END. /* IF AVAIL int-emitente THEN DO: */

        END. /* IF AVAILABLE emitente THEN DO: */
    END. /* IF  wh-nome-abrev-pd4000:SCREEN-VALUE <> '' THEN DO: */
    ELSE DO:
        IF  VALID-HANDLE(wh-supervisor-pd4000) THEN
            ASSIGN wh-supervisor-pd4000:SENSITIVE = NO.
    END.
    */

    FIND FIRST atendente WHERE atendente.cd-oper = integer(wh-tp-pedido-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL atendente THEN DO:
        IF atendente.cod-gr-canais <> 0 THEN
            ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(atendente.cod-gr-canais).
    END.

    RUN pi-atualizaSupervisor.

END PROCEDURE.


PROCEDURE pi-add-nr-os-item:
    DEFINE INPUT  PARAMETER pNomeAbrev   LIKE int-ped-item.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedCli    LIKE int-ped-item.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrSequencia LIKE int-ped-item.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER pItcodigo    LIKE int-ped-item.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodrefer    LIKE int-ped-item.cod-refer    NO-UNDO.
    DEFINE INPUT  PARAMETER pNrOs        LIKE int-ped-item.nr-os        NO-UNDO.


    IF VALID-HANDLE(wh-nr-os-pd4000) AND
       l-add-nr-os-pd4000            THEN DO:
        FIND FIRST int-ped-item
            WHERE int-ped-item.nome-abrev   = pNomeAbrev
              AND int-ped-item.nr-pedcli    = pNrPedCli
              AND int-ped-item.nr-sequencia = pNrSequencia
              AND int-ped-item.it-codigo    = pItcodigo
              AND int-ped-item.cod-refer    = pCodrefer EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE int-ped-item THEN
            ASSIGN int-ped-item.nr-os = pNrOs.
        ELSE DO:
            CREATE int-ped-item.
            ASSIGN int-ped-item.nome-abrev   = pNomeAbrev
                   int-ped-item.nr-pedcli    = pNrPedCli
                   int-ped-item.nr-sequencia = pNrSequencia
                   int-ped-item.it-codigo    = pItcodigo
                   int-ped-item.cod-refer    = pCodrefer
                   int-ped-item.nr-os        = pNrOs.
        END.

        FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
        RELEASE int-ped-item.

        ASSIGN wh-nr-os-pd4000:SENSITIVE = wh-cod-entrega-item-pd4000:SENSITIVE
               l-add-nr-os-pd4000        = wh-nr-os-pd4000:SENSITIVE.
    END.

    IF VALID-HANDLE(whlb-nr-os-pd4000) THEN
        ASSIGN whlb-nr-os-pd4000:SENSITIVE    = YES
               whlb-nr-os-pd4000:SCREEN-VALUE = "Nro OS:":U.

END PROCEDURE.


PROCEDURE pi-cancelar-item:
    ASSIGN l-add-nr-os-pd4000 = NO.

    APPLY "choose":U TO wh-bt-cancelar-item-pd4000.
    
    IF VALID-HANDLE(wh-desc-comercial) THEN
    ASSIGN wh-desc-comercial:SENSITIVE = NO.

    IF VALID-HANDLE(wh-nr-os-pd4000) THEN
        ASSIGN wh-nr-os-pd4000:SENSITIVE = wh-cod-entrega-item-pd4000:SENSITIVE
               l-add-nr-os-pd4000        = wh-nr-os-pd4000:SENSITIVE.

    IF VALID-HANDLE(whlb-nr-os-pd4000) THEN
        ASSIGN whlb-nr-os-pd4000:SENSITIVE    = YES
               whlb-nr-os-pd4000:SCREEN-VALUE = "Nro OS:":U.

    RUN deletaParcelasReceitaRecorrente.


END PROCEDURE.


PROCEDURE pi-sel-nr-os:
    DEFINE VARIABLE v-nr-os AS CHARACTER   NO-UNDO.

    ASSIGN v-nr-os = wh-nr-os-pd4000:SCREEN-VALUE.

    ASSIGN wh-frame-fpage8-pd4000:WINDOW:SENSITIVE = NO.

    RUN eszoom/z01es339.w (INPUT wh-nome-abrev-pd4000:SCREEN-VALUE,
                           INPUT wh-nr-pedcli-pd4000:SCREEN-VALUE,
                           INPUT-OUTPUT v-nr-os).

    ASSIGN wh-frame-fpage8-pd4000:WINDOW:SENSITIVE = YES.

    ASSIGN wh-nr-os-pd4000:SCREEN-VALUE = v-nr-os.

END PROCEDURE.


PROCEDURE pi-sel-unid-comerc:
    DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.

    {method/zoomFields.i &ProgramZoom="eszoom/z01es568.w"
                         &FieldZoom1="cd-unid-comerc"
                         &frame1="fPage1"
                         &fieldHandle1=wh-cd-unid-comerc-pd4000}

END PROCEDURE.


PROCEDURE pi-leave-unid-comerc:
    
    RUN pi-busca-handle (INPUT  wh-frame-fpage1-pd4000,
                         INPUT  p-ind-event,
                         INPUT  'fill-in':U,
                         INPUT  'cod-estabel':U,
                         INPUT  NO,
                         OUTPUT whCodEstabel).

    IF  VALID-HANDLE(wh-nome-abrev-pd4000) THEN DO:
        FIND FIRST emitente NO-LOCK
             WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.

        IF l-busca-transportadora THEN DO:
            RUN pi-busca-transportadora.
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.

    END.
    RUN pi-atualizaSupervisor.

END PROCEDURE.


PROCEDURE pi-leave-vl-preori:
    DEFINE VARIABLE de-liquido LIKE ped-item.vl-preori NO-UNDO.
    DEFINE VARIABLE de-preco   AS DECIMAL DECIMALS 5 NO-UNDO.

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
          AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE:
     

        /* Retorna o Pre‡o de tabela acrescendo os impotos */
        RUN esp/pdp/espdp071.p (INPUT ped-venda.cod-estabel,
                                INPUT wh-nome-abrev-pd4000:SCREEN-VALUE,
                                INPUT wh-nr-pedcli-pd4000:SCREEN-VALUE,
                                INPUT whnr-sequencia-pd4000:SCREEN-VALUE,
                                INPUT whit-codigo:SCREEN-VALUE,
                                INPUT DEC(whqt-pedida:SCREEN-VALUE),
                                INPUT wh-nat-operacao-item-pd4000:SCREEN-VALUE,
                                OUTPUT de-preco).

        ASSIGN de-liquido = dec(whvl-preuni:screen-value).

        RUN esp/pdp/espdp074.p (INPUT ped-venda.nome-abrev,
                                INPUT ped-venda.nr-pedcli,   
                                INPUT whnr-sequencia-pd4000:SCREEN-VALUE,
                                INPUT whit-codigo:SCREEN-VALUE,   
                                INPUT "",   
                                INPUT YES,
                                TRIM(whdes-pct-desconto-inform:SCREEN-VALUE),
                                INPUT-OUTPUT de-liquido). /* preori sem os descontos - l­quido */

        IF  de-preco = 0  THEN
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Pre‡o m¡nimo para o item NÆo existe na tabela de Pre‡os.").
        ELSE
            IF  de-liquido < de-preco THEN  
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Pre‡o Informado ² Inferior ao Pre‡o m¡nimo." +
                                                                      "~~" +
                                                                      "Pre‡o Informado (aplicando descontos): " + trim(STRING(de-liquido,">>>>>>>9.99999")) + " - È Inferior ao Pre‡o m¡nimo + impostos: " + 
                                                                      "(" + trim(STRING(de-preco, ">>>>>>>9.99999")) + ")").
       IF dec(whvl-preuni:screen-value) >= 100000 THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 15825, 
                              INPUT "Pre‡o informado maior ou igual a R$ 100.000,00." + "~~" + "Valor digitado: R$ " + TRIM(STRING(dec(whvl-preuni:screen-value),">>>,>>>,>>9.99999")) + " Confira o valor digitado").

       END.
    END.

END.


PROCEDURE pi-confirma-pedido:
    DEF VAR c-origem-pd4000 AS CHAR NO-UNDO.
    DEF VAR c-nome-abrev AS CHAR NO-UNDO.
    DEF VAR c-nr-pedcli  AS CHAR NO-UNDO.
    DEF VAR c-supervisor AS CHAR NO-UNDO.
    DEF VAR l-regra-vencto-ok AS LOG INIT YES NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "espdp079":U,
                       INPUT  5,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto  NO-ERROR.

    IF TODAY + (365 * int(tt-prog-ponto.conteudo)) < date(wh-dt-entrega-page3-pd4000:SCREEN-VALUE) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data de entrega superior a " + tt-prog-ponto.conteudo + " anos").
        RETURN "NOK".
    END.

    IF INT(wh-cod-canal-venda-pd4000:SCREEN-VALUE) = 12 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Canal de vendas 12 ý exclusivo de faturamento pelo ESFTP012 (Notas Extra)." + "~~" + "Dßvidas entrar em contato com a controladoria.":U).
        RETURN "NOK".
    END.

    IF wh-nat-operacao-pd4000:SCREEN-VALUE BEGINS "7" THEN DO:
        IF wh-po-cliente-pd4000:SCREEN-VALUE = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Pedido Exporta‡Æo, ² obrigat½rio a informa»’o de PO CLIENTE").
            RETURN "NOK".
        END.                                              
    END.

    IF l-confirma-dt-base-pd4000 = NO
    AND TRIM(wh-data-negoc-pd4000:SCREEN-VALUE) <> ""
    AND TRIM(wh-data-negoc-pd4000:SCREEN-VALUE) <> "/  /" THEN DO:

        FOR FIRST int-cond-pagto NO-LOCK
            WHERE int-cond-pagto.cod-cond-pag = int(wh-cod-cond-pag-pd4000:SCREEN-VALUE)
              AND substring(int-cond-pagto.char-1,4,1) = "S":
            ASSIGN l-confirma-dt-base-pd4000 = YES.
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "ATEN€ÇO" + "~~" + "condi‡Æo de pagamento ² CartÆo Intelbras, data base serÿ zerada - Confirma?").
            IF RETURN-VALUE <> "YES" THEN DO:
                ASSIGN wh-cod-cond-pag-pd4000:SCREEN-VALUE = STRING(ped-venda.cod-cond-pag).
                APPLY "ENTRY":U TO wh-cod-cond-pag-pd4000.
                RETURN "NOK".
            END.
        END.
    END.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao =  wh-nat-operacao-pd4000:SCREEN-VALUE NO-ERROR.

    IF AVAIL natur-oper
    AND natur-oper.tipo = 3 /*servi‡o*/ THEN DO:

        IF int(wh-val-pct-desconto-tab-preco-pd4000:SCREEN-VALUE) <> 0
        OR wh-des-pct-desconto-inform-pd4000:SCREEN-VALUE <> ""
        OR int(wh-perc-desco1-pd4000:SCREEN-VALUE) <> 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Natureza de servi‡o NÆo pode ter desconto informado. Favor revisar o pedido").
            RETURN "NOK".
        END.
    END.

    /* Tratativa frete ***/
    IF VALID-HANDLE(wh-vl-frete-pd4000)    AND
       VALID-HANDLE(wh-nome-abrev-pd4000)  AND
       VALID-HANDLE(wh-nr-pedcli-pd4000)   THEN DO:
    
         FIND FIRST ped-venda
             WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
               AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE ped-venda THEN DO:
    
             FIND FIRST int-ped-venda
                 WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL int-ped-venda THEN DO:
                IF DECIMAL(wh-vl-frete-pd4000:SCREEN-VALUE) <> int-ped-venda.vl-frete THEN
                    ASSIGN ped-venda.completo = NO.
            END. /* IF AVAIL int-ped-venda THEN DO: */
    
         END. /* IF AVAILABLE ped-venda THEN DO: */
         FIND CURRENT ped-venda NO-LOCK NO-ERROR.
         /*RELEASE ped-venda.*/

    END. /* IF VALID-HANDLE(wh-vl-frete-pd4000) THEN DO: */

    /*-------------------------------------------- Valida¯Êo regras de vencimento (esacr070) ---------------------------------------------*/
    IF  VALID-HANDLE(wh-nome-abrev-pd4000)
    AND VALID-HANDLE(wh-cod-cond-pag-pd4000)
    AND VALID-HANDLE(wh-nat-operacao-pd4000) THEN
        RUN esp\acr\esacrapi001.p (INPUT wh-nome-abrev-pd4000:SCREEN-VALUE,
                                   INPUT int(wh-cod-cond-pag-pd4000:SCREEN-VALUE),
                                   INPUT wh-nat-operacao-pd4000:SCREEN-VALUE,
                                   OUTPUT l-regra-vencto-ok).
    IF  NOT l-regra-vencto-ok THEN DO:
        RUN utp/ut-msgs.p (input "show", input 17006, input "Cond. de Pagto NÆo ‚ v lida conforme cadastro de exce»„es e/ou NÆo parametrizada(s) para Canais ou B2B").
        RETURN NO-APPLY.
    END.
    /*------------------------------------------------------------------------------------------------------------------------------------*/


    ASSIGN l-supervisorSave = YES.
    IF  l-supervisorSave = YES THEN DO:
        
        IF  VALID-HANDLE (wh-origem-pd4000) 
        AND VALID-HANDLE (wh-nome-abrev-pd4000)
        AND VALID-HANDLE (wh-nr-pedcli-pd4000 ) THEN
            ASSIGN c-origem-pd4000 = wh-origem-pd4000:SCREEN-VALUE
                   c-nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                   c-nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE.
    
        ASSIGN c-nome-transp-aux = wh-nome-transp-pd4000:SCREEN-VALUE
               l-mensagem-transp  = NO. 
    
        APPLY 'tab' TO wh-cod-entrega-aux-pd4000.
    
        ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp-aux
               l-mensagem-transp                  = YES.
    
    
        /* Valida entrega da Declara»’o de Forma de Tributa»’o, para Manuas */
        /* Retirado atraves do chamado 48772 - por Eduardo Jose da Silva */
/*         IF  VALID-HANDLE(wh-cod-estabel-pd4000)        AND                                                                                                                                                               */
/*             wh-cod-estabel-pd4000:SCREEN-VALUE = "105" THEN DO:                                                                                                                                                          */
/*             FIND FIRST emitente NO-LOCK                                                                                                                                                                                  */
/*                 WHERE  emitente.nome-abrev = c-nome-abrev NO-ERROR.                                                                                                                                                      */
/*             IF  AVAIL  emitente AND emitente.natureza = 2 /* Pessoa Jur­dica */ THEN DO:                                                                                                                                 */
/*                 FIND FIRST int-emitente-trib NO-LOCK                                                                                                                                                                     */
/*                     WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.                                                                                                                           */
/*                 IF  NOT AVAIL int-emitente-trib OR                                                                                                                                                                       */
/*                     NOT int-emitente-trib.ind-declaracao THEN DO:                                                                                                                                                        */
/*                     RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                                                                                   */
/*                                        INPUT 17006,                                                                                                                                                                      */
/*                                        INPUT "Cliente NÆo fez a entrega da Declara»’o de Forma de Tributa»’o!~~Cliente NÆo fez a entrega da Declara»’o de Forma de Tributa»’o, favor verificar o cadastro ESCDP066.":U). */
/*                     RETURN "NOK":U.                                                                                                                                                                                      */
/*                 END.                                                                                                                                                                                                     */
/*             END.                                                                                                                                                                                                         */
/*         END.                                                                                                                                                                                                             */
        /* Fim - Valida»’o Declara»’o Forma de Tributa»’o */
    
    
        FIND FIRST ped-venda
             WHERE ped-venda.nr-pedcli = TRIM(wh-nr-pedcli-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
        IF AVAILABLE ped-venda THEN DO:
            IF ped-venda.cod-priori = 44 AND wh-cod-priori-pd4000:SCREEN-VALUE <> "44" THEN DO:
                ASSIGN l-mudou-cod-priori-pd4000 = YES.
            END.
            ELSE DO:
                ASSIGN l-mudou-cod-priori-pd4000 = NO.
            END.
        END.
    /*         wh-btcompleteorder-ped4000:LOAD-IMAGE("image~/im-sav"). */
    
        IF wh-cod-estabel-pd4000:SCREEN-VALUE <> "105" THEN DO: 
            FIND FIRST emitente
                WHERE emitente.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.
        END.
    
        ASSIGN c-supervisor = STRING(wh-supervisor-pd4000:SCREEN-VALUE).
    
        /**92830**/
        FIND FIRST atendente NO-LOCK 
             WHERE atendente.cd-oper = integer(wh-tp-pedido-pd4000:SCREEN-VALUE) NO-ERROR.

        IF AVAIL atendente THEN DO:
            IF atendente.cod-gr-canais <> 0 THEN
                ASSIGN wh-grupo-canais-pd4000:SCREEN-VALUE = string(atendente.cod-gr-canais).
        END.

        /*APPLY "choose" TO wh-bt-save-ord.*/
        RUN pi-btSaveOrder IN p-wgh-object.

        FIND FIRST ped-venda no-lock
            WHERE ped-venda.nome-abrev = c-nome-abrev
              AND ped-venda.nr-pedcli  = c-nr-pedcli NO-ERROR.
    
        IF  NOT AVAIL ped-venda THEN DO:
            ASSIGN wh-origem-pd4000:SCREEN-VALUE  = c-origem-pd4000.
            RETURN "OK".
        END.
        ELSE DO TRANS:
    
            FIND FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
    
            IF NOT AVAILABLE int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido             = ped-venda.nr-pedido
                       int-ped-venda.cod-estabel           = ped-venda.cod-estabel
                       OVERLAY(int-ped-venda.char-1, 1, 8) = STRING(TIME, "hh:mm:ss":U)
                       OVERLAY(int-ped-venda.char-1,68,8)  = c-supervisor  .
            END.
            ELSE 
                ASSIGN int-ped-venda.cod-estabel = ped-venda.cod-estabel.
    
            /*Avalia a condi‡Æo de pagamento, se for CartÆo intelbras zera os campos abaixo.*/
             FIND  int-cond-pagto NO-LOCK 
                WHERE int-cond-pagto.cod-cond-pag = int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) NO-ERROR.
                 IF AVAIL int-cond-pagto THEN DO:
                    IF substring(int-cond-pagto.char-1,4,1) = "S" THEN DO:

                        IF VALID-HANDLE(wh-data-negoc-pd4000)  THEN
                            ASSIGN wh-data-negoc-pd4000:SCREEN-VALUE = "".

                        IF VALID-HANDLE(wh-dias-negoc-pd4000) THEN
                            ASSIGN wh-dias-negoc-pd4000:SCREEN-VALUE = "0".

                      ASSIGN int-ped-venda.dt-negociacao       = ?
                             int-ped-venda.dias-negociacao     = 0.
                    END.
                 END.
    
            ASSIGN //OVERLAY(int-ped-venda.char-1, 41, 12) = c-origem-pd4000 
                   //int-ped-venda.origem                  = c-origem-pd4000
                   OVERLAY(int-ped-venda.char-1,68,8)    = c-supervisor.

            IF VALID-HANDLE(wh-cod-priori-pd4000) THEN
                ASSIGN int-ped-venda.cod-priori-orig = int(wh-cod-priori-pd4000:SCREEN-VALUE).

            FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    
            ASSIGN wh-origem-pd4000:SCREEN-VALUE = c-origem-pd4000
                   wh-supervisor-pd4000:SCREEN-VALUE = c-supervisor.
    
        END.
    
        IF VALID-HANDLE(wh-btcompleteorder-ped4000) THEN DO:
            ASSIGN wh-btcompleteorder-ped4000:VISIBLE = NO.
        END.

    END. /* IF  l-supervisorSave = YES THEN DO: */


END.


PROCEDURE pi-leave-cod-entrega:
    
    ASSIGN wh-cod-entrega-pd4000:SCREEN-VALUE = wh-cod-entrega-aux-pd4000:SCREEN-VALUE. 
                                                                                     
    RUN pi-leave-unid-comerc.

    APPLY "LEAVE":U TO wh-cod-entrega-pd4000.

    IF c-nome-transp <> '' THEN
    ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp.

     
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-choose-btdelivery:

    ASSIGN c-nome-transp-aux = wh-nome-transp-pd4000:SCREEN-VALUE.

    APPLY "CHOOSE":U TO wh-btdelivery-pd4000.

    ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp-aux.

    
END PROCEDURE.

PROCEDURE pi-validaTransp:

    IF VALID-HANDLE(wh-nome-transp-pd4000) AND c-cod-transp <> ? THEN DO:

        IF  wh-nome-transp-pd4000:SCREEN-VALUE    <> c-nome-transp AND l-mensagem-transp = YES 
        AND wh-cd-unid-comerc-pd4000:SCREEN-VALUE <> SUBSTRING(int-ped-venda.char-1, 16, 3) THEN DO:
            MESSAGE "AVISO: " SKIP
                    "Houve uma mudan‡a no pedido que interfere na transportadora, portanto ela foi alterada, caso tenha necessidade de utilizar outra transportadora favor revisar neste mesmo programa (PD4000) pasta Complemento " SKIP
                    "Transportadora do Pedido : " wh-nome-transp-pd4000:SCREEN-VALUE SKIP
                    "Nova Transportadora      : " c-nome-transp
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp.
        END.
        ELSE DO:
            IF  wh-nome-transp-pd4000:SCREEN-VALUE <> c-nome-transp AND l-mensagem-transp = YES THEN DO:
                 MESSAGE "AVISO: " SKIP
                         "Houve uma mudan‡a no pedido que interfere na transportadora, portanto ela foi alterada, caso tenha necessidade de utilizar outra transportadora favor revisar neste mesmo programa (PD4000) pasta Complemento " SKIP
                         "Transportadora do Pedido : " wh-nome-transp-pd4000:SCREEN-VALUE SKIP
                         "Nova Transportadora      : " c-nome-transp
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp.
            END.
        END.

    END. /* IF VALID-HANDLE(wh-nome-transp-pd4000) AND c-cod-transp <> ? THEN DO: */

END PROCEDURE.

PROCEDURE pi-validaTranspSemPed:

    IF VALID-HANDLE(wh-nome-transp-pd4000) AND c-cod-transp <> ? THEN DO:

        IF  wh-nome-transp-pd4000:SCREEN-VALUE <> c-nome-transp AND l-mensagem-transp = YES THEN DO:
            MESSAGE "AVISO: " SKIP
                    "Houve uma mudan‡a no pedido que interfere na transportadora, portanto ela foi alterada, caso tenha necessidade de utilizar outra transportadora favor revisar neste mesmo programa (PD4000) pasta Complemento " SKIP
                    "Transportadora do Pedido : " wh-nome-transp-pd4000:SCREEN-VALUE SKIP
                    "Nova Transportadora      : " c-nome-transp
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN wh-nome-transp-pd4000:SCREEN-VALUE = c-nome-transp.

             
        END.

    END. /* IF VALID-HANDLE(wh-nome-transp-pd4000) AND c-cod-transp <> ? THEN DO: */

END PROCEDURE.

IF p-ind-event = "VLD-DESP" THEN DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
           AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.

    IF  AVAIL ped-venda THEN DO:
        FIND FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.

        IF  AVAIL natur-oper AND NOT natur-oper.emite-dup     AND
            INT(wh-cod-canal-venda-pd4000:SCREEN-VALUE) < 600 AND
            NOT (natur-oper.nat-operacao >= "692300" AND natur-oper.nat-operacao <= "6923ZZ") THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Canal de venda NÆo pode ser menor que 600 para natureza que NÆo emite duplicata.":U).

            RETURN "NOK":U.
        END.
    END.
END.

PROCEDURE pi-btcompleteorder-ped4000-new:

 //Bruno Joaquim -> 07/07/2023 - Se cliente for sales force entÆo recalcula o pedido antes de completar  
 //17/08/2023 - Solicitado para remover 
/* FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND FIRST int-emitente WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN DO:
                IF int-emitente.log-sales = yes THEN DO:
                    RUN cria-cash. 
                END.
            END.
    END.
*/
    ASSIGN l-supervisorSave = YES
           c-supervisorItem = wh-supervisor-pd4000:SCREEN-VALUE.

    /*RUN pi-atualizaSupervisor.*/

/*     IF ped-venda.nr-tabpre <> "lai02" AND ped-venda.nr-tabpre <> "ASTEC 02" THEN DO:                                                                         */
/*                                                                                                                                                              */
/*         FIND FIRST int-emitente                                                                                                                              */
/*              WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.                                                                      */
/*         IF AVAIL int-emitente THEN DO:                                                                                                                       */
/*             IF int-emitente.ind-participa-canais = 993520001 THEN DO:                                                                                        */
/*                 FIND FIRST int-portfolio-repres-canal                                                                                                        */
/*                     WHERE int-portfolio-repres-canal.cod-supervisor-ems = c-supervisorItem NO-LOCK NO-ERROR.                                                 */
/*                 IF NOT AVAIL int-portfolio-repres-canal OR c-supervisorItem = "" THEN DO:                                                                    */
/*                     run utp/ut-msgs.p (INPUT "show":U,                                                                                                       */
/*                                        INPUT 17006,                                                                                                          */
/*                                        INPUT "Supervisor " + c-supervisorItem + " inv lido ou em branco! ~~ Informar um supervisor vÿlido. Consultar CRM."). */
/*                     ASSIGN l-supervisorSave = NO.                                                                                                            */
/*                     RETURN NO-APPLY.                                                                                                                         */
/*                 END.                                                                                                                                         */
/*             END.                                                                                                                                             */
/*             ELSE DO:                                                                                                                                         */
/*                 FIND FIRST gerente                                                                                                                           */
/*                     WHERE gerente.matricula = trim(c-supervisorItem) NO-LOCK NO-ERROR.                                                                       */
/*                 IF NOT AVAIL gerente OR c-supervisorItem = "" THEN DO:                                                                                       */
/*                     run utp/ut-msgs.p (INPUT "show":U,                                                                                                       */
/*                                        INPUT 17006,                                                                                                          */
/*                                        INPUT "Supervisor " + c-supervisorItem + " inv lido ou em branco! ~~ Informar um supervisor vÿlido.").                */
/*                     ASSIGN l-supervisorSave = NO.                                                                                                            */
/*                     RETURN NO-APPLY.                                                                                                                         */
/*                 END.                                                                                                                                         */
/*             END.                                                                                                                                             */
/*         END. /* IF AVAIL int-emitente THEN DO: */                                                                                                            */

    FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL ped-venda THEN DO:
        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
    END.

    IF AVAILABLE ped-venda THEN DO:

        IF (ped-venda.cod-priori = 07 
        OR  ped-venda.cod-priori = 09) THEN DO:

            FIND FIRST ponto-programa NO-LOCK
                WHERE ponto-programa.nome-programa = "pd4000"
                  AND ponto-programa.ponto         = 7 NO-ERROR.
            IF AVAIL ponto-programa THEN DO:
                IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Pedido estÿ sendo faturado.~~Aguarde o mesmo ser liberado.").
                    RETURN "NOK".
                END. /* IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK */
            END. /* IF AVAIL ponto-programa THEN DO: */

        END. /* IF ped-venda.cod-priori = '07' THEN DO: */

        IF ped-venda.nr-tabpre <> "lai02" AND ped-venda.nr-tabpre <> "ASTEC 02" THEN DO:
        
            RUN pi-leaveSupervisor.   
    
            IF l-supervisorSave = NO THEN DO: /* Com erro Supervisor */
                ASSIGN ped-venda.completo = NO.
                APPLY "choose" TO wh-btCancelOrder-pd4000.
                IF VALID-HANDLE(wh-btcompleteorder-ped4000) THEN
                    wh-btcompleteorder-ped4000:SENSITIVE = YES.
            END.
            ELSE DO:
                FIND FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE int-ped-venda THEN
                    ASSIGN OVERLAY(int-ped-venda.char-1,68,8)  = c-supervisorItem.
                RELEASE int-ped-venda.
    
                APPLY "choose" TO wh-btcompleteorder-ped4000.
            END.
    
        END. /* IF ped-venda.nr-tabpre = "lai02" OR ped-venda.nr-tabpre = "ASTEC 02" THEN DO: */
        ELSE 
            APPLY "choose" TO wh-btcompleteorder-ped4000.

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:

            FOR EACH ped-item OF ped-venda NO-LOCK:

                FIND FIRST int-calculo-canal-item
                    WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid    
                      AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel 
                      AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo 
                      AND NOT int-calculo-canal-item.bloqueado  NO-LOCK NO-ERROR.
                IF AVAIL int-calculo-canal-item THEN DO:

                    FIND FIRST int-ped-item-rebate
                      WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
                        AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
                        AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                        AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
                        AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer     EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL int-ped-item-rebate THEN DO:
                        ASSIGN int-ped-item-rebate.log-calcrebate     = int-calculo-canal-item.log-calcrebate    
                               int-ped-item-rebate.log-preco-alterado = int-calculo-canal-item.log-preco-alterado
                               int-ped-item-rebate.log-rebate-antec   = int-calculo-canal-item.log-rebate-antec  
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

                END. /* IF AVAIL int-calculo-canal-item THEN DO: */

            END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */

        END. /* IF AVAIL int-emitente THEN DO: */

        FIND FIRST int-ped-trans  
             WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel
               AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
               AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli    EXCLUSIVE-LOCK NO-ERROR.

         IF NOT AVAIL int-ped-trans  THEN DO:
             CREATE int-ped-trans.
             ASSIGN int-ped-trans.cod-estabel     = ped-venda.cod-estabel
                    int-ped-trans.nome-abrev      = ped-venda.nome-abrev 
                    int-ped-trans.nr-pedcli       = ped-venda.nr-pedcli  .
         END.

         IF VALID-HANDLE(wh-combo-modal-pd4000) THEN
             ASSIGN  int-ped-trans.lot-transp      = wh-combo-modal-pd4000:CHECKED
                     wh-combo-modal-pd4000:CHECKED = int-ped-trans.lot-transp .

         FIND FIRST int-ped-venda
              WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
         IF VALID-HANDLE(wh-gpon-pd4000) THEN
             ASSIGN  int-ped-venda.log-gpon  = wh-gpon-pd4000:CHECKED
                     wh-gpon-pd4000:CHECKED  = int-ped-venda.log-gpon.

         RELEASE int-ped-venda.
         RELEASE int-ped-trans.

    END. /* IF AVAILABLE ped-venda THEN DO: */
    FIND CURRENT ped-venda NO-LOCK NO-ERROR.

    /*RELEASE ped-venda.*/

END PROCEDURE.

PROCEDURE pi-leave-qt-un-fat:
    RUN pi-LeaveUN IN p-wgh-object.

    IF AVAIL int-emitente  AND 
       NOT int-emitente.log-salesforce THEN
    RUN pi-seta-preco-canais (INPUT 1).    
END.

PROCEDURE pi-leave-item:
    RUN pi-ItCodigo IN p-wgh-object.
    IF AVAIL int-emitente  AND 
       NOT int-emitente.log-salesforce THEN
    RUN pi-seta-preco-canais (INPUT 1).
END.

PROCEDURE pi-seta-preco-canais:

    DEF INPUT PARAM p-action AS INT.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000 :SCREEN-VALUE
           AND ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        FIND FIRST int-ped-venda NO-LOCK 
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    
        FIND FIRST natur-oper NO-LOCK 
             WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.

        IF AVAIL natur-oper AND
           natur-oper.emite-duplic = YES AND
           natur-oper.tipo         = 2   AND /* Saida */
           AVAIL int-emitente AND 
           int-emitente.ind-participa-canais = 993520001 THEN DO:

            FIND FIRST item-uni-estab NO-LOCK
                 WHERE item-uni-estab.it-codigo   = whit-codigo:SCREEN-VALUE
                   AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-ERROR.
        
            IF AVAIL item-uni-estab THEN DO:
                RUN esp/es0018p.p (INPUT "PD4000",
                                   INPUT 4,
                                   INPUT 0,
                                   INPUT "", 
                                   OUTPUT TABLE tt-prog-ponto).
        
    
                /*Unidade de negocios NÆo faz parte do programa de canais*/
                IF CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = item-uni-estab.cod-unid) 
                OR SUBSTRING(int-ped-venda.char-1, 65, 1) = "1" THEN DO:
                    ASSIGN whvl-preuni:SENSITIVE = YES.
                END.
                /*Unidade de negocios faz parte do programa de canais*/
                ELSE DO:
                    ASSIGN whvl-preuni:SENSITIVE = NO.
    
                    FOR FIRST ponto-programa NO-LOCK
                        WHERE ponto-programa.nome-programa = "pd4000"
                          AND ponto-programa.ponto         = 5:
    
                        FIND FIRST conteudo-programa 
                             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                               AND conteudo-programa.conteudo     = c-seg-usuario NO-LOCK NO-ERROR.
                        IF AVAIL conteudo-programa THEN
                            ASSIGN whvl-preuni:SENSITIVE = YES.
    
                    END. /* FOR FIRST ponto-programa NO-LOCK */
                
                    IF ped-venda.nr-tabpre = "lai02" OR ped-venda.nr-tabpre = "ASTEC 02" THEN 
                        ASSIGN whvl-preuni:SENSITIVE = YES.
    
                    IF p-action = 1 THEN DO:

                        FIND ITEM-uni-estab
                            WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                              AND item-uni-estab.it-codigo   = whit-codigo:SCREEN-VALUE
                            NO-LOCK NO-ERROR.
                        IF NOT AVAIL item-uni-estab THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "Relacionamento ITEM X Estabelecimento nao encontrado").
                        END.
                        FIND ITEM
                            WHERE ITEM.it-codigo = item-uni-estab.it-codigo NO-LOCK NO-ERROR.
                        IF NOT AVAIL item THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "ITEM nao encontrado").
                        END.
                            
    /*                     OUTPUT TO c:\temp\pd4000-upc2.txt.                                                                                */
    /*                         FOR EACH produtoitem:                                                                                         */
    /*                             DISP produtoitem.codigoproduto produtoitem.tipoportfolio FORMAT "9999999999" item-uni-estab.cod-unid-neg. */
    /*                         END.                                                                                                          */
    /*                         OUTPUT CLOSE.                                                                                                 */
    
                        /* Grupos que participam de canais e possuem portif¢lio -> chamado 72993 */
                        IF  fn-grupo-distribuidores(int-emitente.cod-emitente) THEN DO:
                        
                        FIND FIRST repres NO-LOCK
                            WHERE  repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
                        IF NOT AVAIL repres THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "Representante Nao encontrado durante a busca DO Portfolio").
                            RETURN "NOK":U.
                        END.

                        IF int-emitente.cod-guid = "" THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "Cliente NÆo possui c¢digo CRM").
                        END.
                        ELSE DO:
                            /* INICIO JONK */
                            ASSIGN de-valor          = 0
                                   de-perc-icms      = 0
                                   de-perc-desc-icms = 0.

                            //deleta a tabela pra buscar o preco sem imposto, vai calcular abaixo 
                            FOR EACH int-calculo-canal-item EXCLUSIVE-LOCK
                               WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                                 AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                                 AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE
                                 AND int-calculo-canal-item.data-calculo = TODAY:
                                DELETE int-calculo-canal-item.
                            END.

                            FIND FIRST int-calculo-canal-item NO-LOCK
                                 WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                                   AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                                   AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE
                                   AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
                            IF AVAIL int-calculo-canal-item THEN DO:
                                ASSIGN de-valor = int-calculo-canal-item.valor-produto.
                            END.
                            ELSE DO:
                                EMPTY TEMP-TABLE tt-itens.
                                CREATE tt-itens.
                                ASSIGN tt-itens.it-codigo              = whit-codigo:SCREEN-VALUE
                                       tt-itens.de-quantidade          = DEC(whqt-pedida:SCREEN-VALUE)
                                       tt-itens.TipoPortfolio          = 993520005
                                       tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                                       tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                                       tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.

                                RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
                                RUN pi-inicializar IN h-acomp (INPUT "c lculo Pre‡os.").
                                RUN pi-acompanhar IN h-acomp (INPUT "Calculando Pre‡os.").

                                RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                                           INPUT  TABLE tt-itens,
                                                           OUTPUT TABLE ProdutoItemR,
                                                           OUTPUT TABLE Resultado).

                                RUN pi-finalizar IN h-acomp.

                                FIND FIRST ProdutoItemR NO-ERROR.
                                FIND FIRST Resultado    NO-ERROR.

                                IF  AVAIL Resultado
                                AND Resultado.Sucesso THEN DO:
                                    ASSIGN de-valor = ProdutoItemR.ValorComDesconto.

                                    FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                                         WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                                           AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                                           AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE NO-ERROR.
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
                                               int-calculo-canal-item.cod-estabel            = ped-venda.cod-estabel   
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
                                    RELEASE int-calculo-canal-item.
                                END.
                            END.   
                            IF de-valor <> 0 THEN DO:

                                IF NOT VALID-HANDLE (h-msg138a) THEN
                                    RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.

                                RUN pi-calc-juros IN h-msg138a (INPUT IF VALID-HANDLE(wh-cod-cond-pag-pd4000) THEN int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) 
                                                                      ELSE ped-venda.cod-cond-pag,
                                                                OUTPUT p-indice-financiamento,
                                                                OUTPUT TABLE tt-erro).
        
                                RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                                  INPUT  ped-venda.cod-estabel,
                                                                  INPUT  whit-codigo:SCREEN-VALUE,
                                                                  OUTPUT de-perc-icms,
                                                                  OUTPUT de-perc-desc-icms,
                                                                  OUTPUT TABLE tt-erro).

                                IF VALID-HANDLE(h-msg138a) THEN
                                    DELETE PROCEDURE h-msg138a.

                                IF  de-perc-desc-icms > 0 THEN
                                    ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                                           de-valor = round(de-valor / de-perc-desc-icms,4).

                                //ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).
                                RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                                       INPUT ped-venda.cod-estabel ,
                                                       INPUT whit-codigo:SCREEN-VALUE,
                                                       INPUT de-valor,
                                                       INPUT de-perc-icms,
                                                       INPUT p-indice-financiamento,
                                                       OUTPUT de-valor-item ).

                                IF de-valor-item <> 0 THEN
                                    ASSIGN whvl-preuni:SCREEN-VALUE = string(de-valor-item).
                                ELSE
                                    ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).

                            END.
                            /* FIM JONK */
                            ELSE DO:
                                FIND FIRST int-calculo-canal NO-LOCK
                                     WHERE int-calculo-canal.cod-guid     = int-emitente.cod-guid
                                       AND int-calculo-canal.cod-estabel  = ped-venda.cod-estabel
                                       AND int-calculo-canal.data-calculo = TODAY NO-ERROR.
        
                                IF AVAIL int-calculo-canal THEN DO:
    
                                    FIND FIRST int-calculo-canal-item NO-LOCK
                                         WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
                                           AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel
                                           AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE 
                                           AND NOT int-calculo-canal-item.bloqueado NO-ERROR.
            
                                    IF AVAIL int-calculo-canal-item THEN DO:

                                        ASSIGN de-valor          = 0
                                               de-perc-icms      = 0
                                               de-perc-desc-icms = 0.
    
                                        IF  int-calculo-canal-item.tipo-portifolio <> 993520003 /* Cross-Selling */
                                        AND int-calculo-canal-item.tipo-portifolio <> 993520004 /* Solucoes */  THEN DO:
                                            FIND FIRST int-portfolio-repres-canal
                                                WHERE  int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                                                  AND  int-portfolio-repres-canal.cod-unid-neg       = item-uni-estab.cod-unid-neg
                                                  AND  int-portfolio-repres-canal.cod-segmento       = SUBSTRING(ITEM.fm-cod-com,1,4)
                                                  AND  int-portfolio-repres-canal.ind-situacao       = 0 NO-LOCK NO-ERROR.
                                            IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                                                FIND FIRST int-portfolio-repres-canal
                                                    WHERE  int-portfolio-repres-canal.cod-representante = repres.cod-rep
                                                      AND  int-portfolio-repres-canal.cod-unid-neg      = item-uni-estab.cod-unid-neg
                                                      AND  int-portfolio-repres-canal.cod-segmento      = ?
                                                      AND  int-portfolio-repres-canal.ind-situacao      = 0 NO-LOCK NO-ERROR.
                                                IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                                                    RUN utp/ut-msgs.p (INPUT "show",
                                                                       INPUT 17006,
                                                                       INPUT "Produto NÆo pertence ao portif¢lio do Representante").
                                                    RETURN "NOK":U.
                                                END.
                                            END.
                                        END.     
    
                                        /*IF Resultado.Sucesso THEN DO:*/
                                        IF NOT VALID-HANDLE (h-msg138a) THEN
                                            RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
            
                                        RUN pi-calc-juros IN h-msg138a (INPUT  IF VALID-HANDLE(wh-cod-cond-pag-pd4000)  THEN 
                                                                               int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) ELSE
                                                                               ped-venda.cod-cond-pag,
                                                                        OUTPUT p-indice-financiamento,
                                                                        OUTPUT TABLE tt-erro).
            
            
                                        RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                                          INPUT  ped-venda.cod-estabel,
                                                                          INPUT  whit-codigo:SCREEN-VALUE,
                                                                          OUTPUT de-perc-icms,
                                                                          OUTPUT de-perc-desc-icms,
                                                                          OUTPUT TABLE tt-erro).
                                        IF VALID-HANDLE(h-msg138a) THEN
                                            DELETE PROCEDURE h-msg138a.            
        
                                        /*Se a quantidade estÿ acima do range calcula o Pre‡o*/
                                        IF int-calculo-canal-item.qtd-range < DEC(whqt-pedida:SCREEN-VALUE) THEN DO:
        
                                            /*limpa tt's*/
                                            EMPTY TEMP-TABLE ProdutoItem.
                                            EMPTY TEMP-TABLE tt-itens.
                                            EMPTY TEMP-TABLE ProdutoItemR.
        
                                            CREATE tt-itens.
                                            ASSIGN tt-itens.it-codigo              = int-calculo-canal-item.it-codigo
                                                   tt-itens.de-quantidade          = DEC(whqt-pedida:SCREEN-VALUE)
                                                   tt-itens.TipoPortfolio          = int-calculo-canal-item.tipo-portifolio
                                                   tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                                                   tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                                                   tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
        
                                            RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
                                            RUN pi-inicializar IN h-acomp (INPUT "c lculo Pre‡os.").
                                            RUN pi-acompanhar IN h-acomp (INPUT "Calculando Pre‡os.").

                                            RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                                                       INPUT  TABLE tt-itens,
                                                                       OUTPUT TABLE ProdutoItemR,
                                                                       OUTPUT TABLE Resultado).

                                            RUN pi-finalizar IN h-acomp.
        
                                            FIND FIRST ProdutoItemR NO-ERROR.
                                            FIND FIRST Resultado    NO-ERROR.
        
                                            IF  AVAIL Resultado
                                            AND Resultado.Sucesso THEN DO:
                                                ASSIGN de-valor = ProdutoItemR.ValorComDesconto.
                                            END.
                                            ELSE DO:
                                                IF AVAIL resultado THEN DO:
                                                    RUN utp/ut-msgs.p (INPUT "show",
                                                                       INPUT 17006,
                                                                       INPUT Resultado.Mensagem).
                                                END.
                                                ELSE DO:
                                                    RUN utp/ut-msgs.p (INPUT "show",
                                                                       INPUT 17006,
                                                                       INPUT "NÆo foi poss¡vel consultar Pre‡os!~~NÆo foi poss¡vel consultar Pre‡o para o item " + int-calculo-canal-item.it-codigo + ".").
                                                    RETURN "NOK":U.
                                                END.
                                            END.
                                        END.
                                        ELSE DO:
                                            ASSIGN de-valor = int-calculo-canal-item.valor-produto.
                                            
                                        END.
                                        IF  de-perc-desc-icms > 0 THEN
                                            ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                                                   de-valor = round(de-valor / de-perc-desc-icms,4).
        
                                        //ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).
                                        RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                                               INPUT ped-venda.cod-estabel ,
                                                               INPUT whit-codigo:SCREEN-VALUE,
                                                               INPUT de-valor,
                                                               INPUT de-perc-icms,
                                                               INPUT p-indice-financiamento,
                                                               OUTPUT de-valor-item ).

                                        IF de-valor-item <> 0 THEN
                                            ASSIGN whvl-preuni:SCREEN-VALUE = string(de-valor-item).
                                        ELSE
                                            ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).

                                    END. /* IF AVAIL int-calculo-canal-item THEN DO: */
                                    ELSE DO:
                                        /* MESSAGE 'ANTES int-calculo-canal.cod-guid     '  int-calculo-canal.cod-guid     SKIP */
    /*                                             'int-calculo-canal.cod-estabel  '  int-calculo-canal.cod-estabel  SKIP       */
    /*                                             'int-emitente.cod-guid  '  int-emitente.cod-guid  SKIP                       */
    /*                                             'ped-venda.cod-estabel  '  ped-venda.cod-estabel  SKIP                       */
    /*                                             'whit-codigo:SCREEN-VALUE       '  whit-codigo:SCREEN-VALUE                  */
    /*                                         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                               */
                                        ASSIGN whvl-preuni:SENSITIVE = NO.
                                        RUN cria-cash2.
        
    /*                                     PAUSE 0.5.                                                                     */
    /*                                     MESSAGE 'int-calculo-canal.cod-guid     '  int-calculo-canal.cod-guid     SKIP */
    /*                                             'int-calculo-canal.cod-estabel  '  int-calculo-canal.cod-estabel  SKIP */
    /*                                             'int-emitente.cod-guid  '  int-emitente.cod-guid  SKIP                 */
    /*                                             'ped-venda.cod-estabel  '  ped-venda.cod-estabel  SKIP                 */
    /*                                             'whit-codigo:SCREEN-VALUE       '  whit-codigo:SCREEN-VALUE            */
    /*                                         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                         */
    
                                        FIND FIRST int-calculo-canal-item NO-LOCK
                                             WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid 
                                               AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel 
                                               AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE 
                                               AND NOT int-calculo-canal-item.bloqueado NO-ERROR.
                                        IF NOT AVAIL int-calculo-canal-item THEN DO:
    
                                            FOR FIRST ponto-programa NO-LOCK
                                                WHERE ponto-programa.nome-programa = "pd4000"
                                                  AND ponto-programa.ponto         = 5:
    
                                                FIND FIRST conteudo-programa 
                                                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                                                  AND conteudo-programa.conteudo     = c-seg-usuario NO-LOCK NO-ERROR.
                                                IF AVAIL conteudo-programa THEN
                                                    ASSIGN whvl-preuni:SENSITIVE = YES.
    
                                            END. /* FOR FIRST ponto-programa NO-LOCK */
    
                                            IF whvl-preuni:SENSITIVE = NO THEN DO:
                                                RUN utp/ut-msgs.p (INPUT "show",
                                                                   INPUT 17006,
                                                                   INPUT "Erro portif¢lio 1!~~NÆo encontrado produto " + whit-codigo:SCREEN-VALUE + " no portif¢lio do cliente " + STRING(int-emitente.cod-emitente)).
                                                RETURN "NOK":U.
                                            END.
                                        END. /* IF NOT AVAIL int-calculo-canal-item THEN DO: */
                                        ELSE DO:
                                            ASSIGN de-perc-desc-icms      = 0
                                                   de-perc-icms           = 0
                                                   de-valor               = 0
                                                   p-indice-financiamento = 0.
    
                                            IF NOT VALID-HANDLE (h-msg138a) THEN
                                                RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
    
                                            IF int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) <> 0 THEN
                                                RUN pi-calc-juros IN h-msg138a (INPUT  int(wh-cod-cond-pag-pd4000:SCREEN-VALUE),
                                                                                OUTPUT p-indice-financiamento,
                                                                                OUTPUT TABLE tt-erro).
                                            ELSE
                                                ASSIGN p-indice-financiamento = 1.
    
                                            RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                                              INPUT  ped-venda.cod-estabel,
                                                                              INPUT  whit-codigo:SCREEN-VALUE,
                                                                              OUTPUT de-perc-icms,
                                                                              OUTPUT de-perc-desc-icms,
                                                                              OUTPUT TABLE tt-erro).
    
                                            IF VALID-HANDLE(h-msg138a) THEN
                                                DELETE PROCEDURE h-msg138a.
    
                                            ASSIGN de-valor = int-calculo-canal-item.valor-produto.
    
                                            IF  de-perc-desc-icms > 0 THEN
                                                ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                                                       de-valor = round(de-valor / de-perc-desc-icms,4).
    
                                            //ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).
                                            RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                                                   INPUT ped-venda.cod-estabel ,
                                                                   INPUT whit-codigo:SCREEN-VALUE,
                                                                   INPUT de-valor,
                                                                   INPUT de-perc-icms,
                                                                   INPUT p-indice-financiamento,
                                                                   OUTPUT de-valor-item ).
                                      
                                            IF de-valor-item <> 0 THEN
                                                ASSIGN whvl-preuni:SCREEN-VALUE = string(de-valor-item).
                                            ELSE
                                                ASSIGN whvl-preuni:SCREEN-VALUE = STRING((de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento).
    
                                        END. /* IF AVAIL int-calculo-canal-item THEN DO: */
                                    END.
                                END.
                                ELSE DO:
                                    RUN utp/ut-msgs.p (INPUT "show",
                                                       INPUT 17006,
                                                       INPUT "NÆo encontrado c lculo de Pre‡os para o cliente " + STRING(int-emitente.cod-emitente) + " no dia " + STRING(TODAY) + "~~" + "O c lculo serÿ realizado automaticamente.").
                                        /*
                                    APPLY "CHOOSE" TO wh-bt-calcula-preco.
                                    RUN pi-seta-preco-canais (INPUT 1).
                                        */
                                END.
                            END.
                        END.
                        END. /*eh-grupo-canais*/
                        ELSE
                            ASSIGN whvl-preuni:SENSITIVE = YES. /* Habilitar se NÆo for canais */
                    END. /*IF p-action = 1 THEN DO:*/
                END.
            END.
        END.
        ELSE DO:
            ASSIGN whvl-preuni:SENSITIVE = YES.
        END.        
    
    END. /* IF AVAIL ped-venda THEN DO: */

    
END PROCEDURE.

PROCEDURE pi-libera-preco-canais:

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
           AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.

    FIND FIRST int-ped-venda NO-LOCK 
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente 
           AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.

    IF  AVAIL int-emitente AND fn-grupo-distribuidores(int-emitente.cod-emitente) /* Grupos que participam de canais e possuem portif¢lio -> chamado 72993 */ 
    THEN DO:
        IF  wh-libera-preco-canais-pd4000:CHECKED 
        AND AVAIL int-ped-venda
        AND SUBSTRING(int-ped-venda.char-1, 65,1) <> "1" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "ATEN€ÇO" + "~~" + "O parƒmetro Operadora deverÿ ser utilizado somente para pedidos vendidos para Operadoras com Pre‡o diferenciado, confirma informa‡äes de Pre‡o?").
    
            IF RETURN-VALUE <> "YES" THEN DO:
                ASSIGN wh-libera-preco-canais-pd4000:CHECKED = NO.
                RETURN "NOK":U.
            END.
        END.
        ELSE IF NOT wh-libera-preco-canais-pd4000:CHECKED 
        AND AVAIL int-ped-venda
        AND SUBSTRING(int-ped-venda.char-1, 65,1) = "1" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "ATEN€ÇO" + "~~" + "Os Pre‡os deste pedido serÆo refeitos considerando o Programa de Canais - Confirma?").
    
            IF RETURN-VALUE <> "YES" THEN DO:
                ASSIGN wh-libera-preco-canais-pd4000:CHECKED = YES.
                RETURN "NOK":U.
            END.
            RUN pi-recalcula-todos-itens.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-recalcula-todos-itens:

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
           AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.

    FIND FIRST int-ped-venda NO-LOCK 
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente 
           AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.

    IF AVAIL int-emitente THEN DO:
        IF int-emitente.cod-guid = ""
        OR NOT AVAIL int-emitente THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Cliente NÆo possui c¢digo CRM").
            RETURN "NOK":U.
        END.
    
        IF AVAIL ped-venda THEN DO:
            IF  ped-venda.cod-sit-ped <> 1 
            AND ped-venda.cod-sit-ped <> 2 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Rec lculo nÆo ‚ poss¡vel para pedidos com situa‡Æo Aberto e Atendido Parcial.").
                RETURN "NOK":U.
            END.
    
            APPLY "CHOOSE" TO wh-bt-calcula-preco.

            FOR EACH ped-item OF ped-venda
               WHERE ped-item.cod-sit-item = 1
                  OR ped-item.cod-sit-item = 2 NO-LOCK:

                FIND item-uni-estab
                        WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                          AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL item-uni-estab THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "Relacionamento ITEM X Estabelecimento nao encontrado").
                    END.
                    FIND ITEM
                        WHERE ITEM.it-codigo = item-uni-estab.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL item THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "ITEM nao encontrado").
                END.
            END.

            FIND FIRST int-calculo-canal NO-LOCK
                 WHERE int-calculo-canal.cod-guid     = int-emitente.cod-guid
                   AND int-calculo-canal.cod-estabel  = ped-venda.cod-estabel
                   AND int-calculo-canal.data-calculo = TODAY NO-ERROR.
            IF AVAIL int-calculo-canal THEN DO:

                FOR EACH ped-item OF ped-venda 
                   WHERE ped-item.cod-sit-item = 1
                      OR ped-item.cod-sit-item = 2 EXCLUSIVE-LOCK:

                    ASSIGN de-valor          = 0
                           de-perc-icms      = 0
                           de-perc-desc-icms = 0.

                    FIND FIRST int-calculo-canal-item NO-LOCK
                         WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
                           AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel
                           AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo 
                           AND NOT int-calculo-canal-item.bloqueado NO-ERROR.
                    IF AVAIL int-calculo-canal-item THEN DO:

                        IF NOT VALID-HANDLE (h-msg138a) THEN
                            RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
                    
                        IF int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) <> 0 THEN
                            RUN pi-calc-juros IN h-msg138a (INPUT  int(wh-cod-cond-pag-pd4000:SCREEN-VALUE),
                                                            OUTPUT p-indice-financiamento,
                                                            OUTPUT TABLE tt-erro).
                        ELSE
                            ASSIGN p-indice-financiamento = 1.
    
                        RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                          INPUT  ped-venda.cod-estabel,
                                                          INPUT  ped-item.it-codigo,
                                                          OUTPUT de-perc-icms,
                                                          OUTPUT de-perc-desc-icms,
                                                          OUTPUT TABLE tt-erro).

                        IF VALID-HANDLE(h-msg138a) THEN
                            DELETE PROCEDURE h-msg138a.

                        ASSIGN de-valor = int-calculo-canal-item.valor-produto.

                        IF  de-perc-desc-icms > 0 THEN
                            ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                                   de-valor  = round(de-valor / de-perc-desc-icms,4).

                        RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                               INPUT ped-venda.cod-estabel ,
                                               INPUT ped-item.it-codigo,
                                               INPUT de-valor,
                                               INPUT de-perc-icms,
                                               INPUT p-indice-financiamento,
                                               OUTPUT de-valor-item ).

                        IF de-valor-item <> 0 THEN
                            ASSIGN ped-item.vl-preori = de-valor-item.
                        ELSE
                            ASSIGN ped-item.vl-preori = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento.

                        ASSIGN ped-item.vl-preori-un-fat       = ped-item.vl-preori.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "NÆo existe c lculo de preco para o item. ~~Produto " + ped-item.it-codigo + " do cliente " + 
                                                  STRING(int-emitente.cod-emitente) + ". Para Calcular o Pre‡o de todos os itens do pedido, clique no botÆo <Calcular>").
                    END.
                END.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "NÆo encontrado c lculo de Pre‡os para o cliente " + STRING(int-emitente.cod-emitente) + " no dia " + STRING(TODAY) + 
                                          "~~. Para Calcular o Pre‡o de todos os itens do pedido, clique no botÆo <Calcular>").

                IF  wh-libera-preco-canais-pd4000:CHECKED 
                AND SUBSTRING(int-ped-venda.char-1, 65,1) <> "1" THEN 
                    ASSIGN wh-libera-preco-canais-pd4000:CHECKED = NO.
    
                ELSE IF NOT wh-libera-preco-canais-pd4000:CHECKED 
                AND SUBSTRING(int-ped-venda.char-1, 65,1) = "1" THEN
                    ASSIGN wh-libera-preco-canais-pd4000:CHECKED = YES.
    
                APPLY "CHOOSE" TO wh-bt-calcula-preco.
               
                RETURN "NOK":U.
            END.
        END. /* ped-venda */
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-leave-cod-cond-pag:

    RUN pi-CodCondPag IN p-wgh-object.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
           AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.

    IF  AVAIL ped-venda
    AND ped-venda.cod-cond-pag <> int(wh-cod-cond-pag-pd4000:SCREEN-VALUE) THEN DO:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente 
               AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.

        IF  AVAIL int-emitente AND fn-grupo-distribuidores(int-emitente.cod-emitente) /* Grupos que participam de canais e possuem portif¢lio -> chamado 72993 */ 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 27100,
                                   INPUT "ATEN€ÇO" + "~~" + "Os Pre‡os deste pedido serÆo refeitos considerando o Programa de Canais - Confirma?").

            IF RETURN-VALUE = "YES" THEN DO:
               RUN pi-recalcula-todos-itens. //(INPUT ""). 
            END.                            
        END.

        IF l-confirma-dt-base-pd4000 = NO
        AND TRIM(wh-data-negoc-pd4000:SCREEN-VALUE) <> ""
        AND TRIM(wh-data-negoc-pd4000:SCREEN-VALUE) <> "/  /" THEN DO:

            FOR FIRST int-cond-pagto NO-LOCK 
                WHERE int-cond-pagto.cod-cond-pag = int(wh-cod-cond-pag-pd4000:SCREEN-VALUE)
                  AND substring(int-cond-pagto.char-1,4,1) = "S":
                ASSIGN l-confirma-dt-base-pd4000 = YES.
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 27100,
                                   INPUT "ATEN€ÇO" + "~~" + "condi‡Æo de pagamento ² CartÆo Intelbras, data base serÿ zerada - Confirma?").
                IF RETURN-VALUE <> "YES" THEN DO:
                    ASSIGN wh-cod-cond-pag-pd4000:SCREEN-VALUE = STRING(ped-venda.cod-cond-pag).
                    APPLY "ENTRY":U TO wh-cod-cond-pag-pd4000.
                END.
            END.
        END.
    END.
        
END PROCEDURE.

PROCEDURE pi-entry-vl-preuni:
    IF AVAIL int-emitente  AND 
       NOT int-emitente.log-salesforce THEN
       RUN pi-seta-preco-canais (INPUT 0).
END PROCEDURE.

procedure pi-btCancelationOrder-pd4000:

    RUN validaCanais.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    RUN pi-btCancelationOrder IN p-wgh-object.

    FIND ped-venda
        WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
          AND ped-venda.nome-abrev = whNomeAbrev:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL ped-venda THEN DO:
        
        /*
        FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
        IF AVAILABLE int-ped-venda THEN DO:
           ASSIGN int-ped-venda.nr-contrato = "" .
        END.
        */
        
        //IDBA BRUNO 29/09 - Remove parcela ao cancelar item/pedido
        FOR EACH ped-item WHERE ped-item.nr-pedcli  = ped-venda.nr-pedcli   
                            AND ped-item.nome-abrev = ped-venda.nome-abrev :
                           // AND (ped-item..cod-sit-item <> 2 OR cod-sit-item <> 3) :

            IF (ped-item.cod-sit-item <> 3) THEN DO: //Atendidos Total

                FIND FIRST int-ped-item WHERE int-ped-item.nr-pedcli     = ped-item.nr-pedcli  
                                          AND int-ped-item.nome-abrev    = ped-item.nome-abrev 
                                          AND int-ped-item.nr-sequencia  = ped-item.nr-sequencia
                                          AND int-ped-item.it-codigo     = ped-item.it-codigo EXCLUSIVE-LOCK.

                IF AVAIL int-ped-item THEN DO:
                    ASSIGN int-ped-item.nr-parcela = ? .
                END.

            END.
        END.

        /*Integra»’o cancelamento de pedido DEPS*/
        CREATE tt-pedido-integra.
        ASSIGN tt-pedido-integra.r-rowid = ROWID(ped-venda)
               tt-pedido-integra.i-origem-inegr = 4.
        
        RAW-TRANSFER tt-pedido-integra TO raw-param.  

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

        IF  AVAIL int-emitente THEN DO:
            ASSIGN v_log_nat_deps = YES.
                           
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "dps-nat-oper",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(ped-venda.nat-operacao)) THEN
                ASSIGN v_log_nat_deps = NO.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "dps-canal-vd",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
                IF  v_log_nat_deps = yes /* garantia */ THEN DO:
                    RUN esp/trgw/wdi154a.p (INPUT raw-param,
                                            INPUT 'msg0310',
                                            OUTPUT TABLE resultado).

                    IF  RETURN-VALUE <> "OK" THEN DO:
                        /*FIND FIRST resultado.

                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                              INPUT "EMS",
                                                              INPUT "ERROR",
                                                              INPUT v_desc_bloq,
                                                              INPUT resultado.mensagem,
                                                              INPUT "").

                        RETURN "NOK".*/
                    END.
                END.
            END.
        END.
    END.
END PROCEDURE.

procedure pi-btCancelationItem-pd4000:
    IF VALID-HANDLE(wh-desc-comercial) THEN
    ASSIGN wh-desc-comercial:SENSITIVE = NO.

    RUN validaCanais .
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    RUN pi-btCancelationItem IN p-wgh-object.
END PROCEDURE.

procedure pi-btDeleteOrder-pd4000:
    FIND ped-venda
        WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
          AND ped-venda.nome-abrev = whNomeAbrev:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF AVAILABLE ped-venda THEN DO:

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

        IF AVAIL int-emitente
             AND int-emitente.ind-participa-canais = 993520001
             AND ped-venda.origem = 12 THEN DO:
             run utp/ut-msgs.p (INPUT "show":U,
                   INPUT 17006,
                   INPUT "Aten‡Æo, Pedido com origem Extranet, nÆo ² permitido ExclusÆo atrav‚s deste programa, utilize a propria extranet. ~~ " +
                         "Aten‡Æo, Pedido com origem Extranet, nÆo ² permitido ExclusÆo atrav‚s deste programa, utilize a propria extranet.").

             RETURN "NOK".
        END.

        FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
        IF AVAILABLE int-ped-venda THEN DO:
            DELETE int-ped-venda.
        END.

        FOR EACH int-ped-item WHERE int-ped-item.nr-pedcli  = ped-venda.nr-pedcli 
                                AND int-ped-item.nome-abrev = ped-venda.nome-abrev EXCLUSIVE-LOCK:
            DELETE int-ped-item.
        END.
    END.

    RUN pi-btDeleteOrder IN p-wgh-object.
END PROCEDURE.

procedure pi-btDeleteItem-pd4000:
    RUN validaCanais .
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    RUN pi-btDeleteItem IN p-wgh-object.
    

    //IDBA Bruno - 04/09/2023 - Ao excluir item, limpa do campo da parcela
    FIND ped-item
        WHERE ped-item.nome-abrev   = wh-nome-abrev-pd4000     :SCREEN-VALUE
          AND ped-item.nr-pedcli    = wh-nr-pedcli-pd4000      :SCREEN-VALUE
          AND ped-item.it-codigo    = whit-codigo              :SCREEN-VALUE
          AND ped-item.nr-sequencia = int(whnr-sequencia-pd4000:SCREEN-VALUE) NO-LOCK no-error.
    IF AVAIL ped-item THEN DO:
        FIND FIRST int-ped-item WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev   
                                  AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli    
                                  AND int-ped-item.it-codigo    = ped-item.it-codigo    
                                  AND int-ped-item.nr-sequencia = ped-item.nr-sequencia NO-ERROR.
        IF AVAIL int-ped-item THEN DO:
            ASSIGN int-ped-item.nr-parcela-recor = ?.
        END.
    END.

END PROCEDURE.

procedure pi-btUpdateItem-pd4000: 
    RUN validaCanais .
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    //IDBA Bruno - 07/08/2023 
    IF VALID-HANDLE(wh-desc-comercial) THEN DO:
        ASSIGN wh-desc-comercial:SENSITIVE = YES .
    END.
    RUN pi-btUpdateItem IN p-wgh-object.
END PROCEDURE.

procedure pi-btUpdateOrder-pd4000:

    ASSIGN l-reativa-suspente = YES.
    RUN validaCanais.
    ASSIGN l-reativa-suspente = NO.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    
    RUN pi-btUpdateOrder IN p-wgh-object.

END PROCEDURE.

procedure pi-btOrderFunctions-pd4000:
    ASSIGN l-reativa-suspente = YES.
    RUN validaCanais .
    ASSIGN l-reativa-suspente = NO.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    
    RUN pi-btOrderFunctions IN p-wgh-object.
END PROCEDURE.


PROCEDURE deletaParcelasReceitaRecorrente:
 
 FIND ped-item WHERE ped-item.nome-abrev   = wh-nome-abrev-pd4000     :SCREEN-VALUE
                 AND ped-item.nr-pedcli    = wh-nr-pedcli-pd4000      :SCREEN-VALUE
                 AND ped-item.it-codigo    = whit-codigo              :SCREEN-VALUE
                 AND ped-item.nr-sequencia = int(whnr-sequencia-pd4000:SCREEN-VALUE) NO-LOCK no-error.
 IF AVAIL ped-item THEN DO:
    FIND FIRST int-ped-item WHERE ped-item.nome-abrev   = int-ped-item.nome-abrev  
                              AND ped-item.nr-pedcli    = int-ped-item.nr-pedcli   
                              AND ped-item.it-codigo    = int-ped-item.it-codigo   
                              AND ped-item.nr-sequencia = int-ped-item.nr-sequencia NO-ERROR.
    IF AVAIL int-ped-item THEN DO:
       ASSIGN int-ped-item.nr-parcela = ? .
    END.
 END.

END PROCEDURE.

PROCEDURE validaCanais:

    FIND ped-venda
        WHERE ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE
          AND ped-venda.nome-abrev = whNomeAbrev:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF AVAILABLE ped-venda THEN DO:

        IF ped-venda.cod-priori = 07 THEN DO:

            FIND FIRST ponto-programa NO-LOCK
                WHERE ponto-programa.nome-programa = "pd4000"
                  AND ponto-programa.ponto         = 7 NO-ERROR.
            IF AVAIL ponto-programa THEN DO:
                IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Pedido est  sendo faturado.~~Aguarde o mesmo ser liberado.").
                    RETURN "NOK".
                END. /* IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK */
            END. /* IF AVAIL ponto-programa THEN DO: */

        END. /* IF ped-venda.cod-priori = '07' THEN DO: */

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    
        IF AVAIL int-emitente
             AND int-emitente.ind-participa-canais = 993520001
             AND ped-venda.origem = 12
             AND ped-venda.cod-priori = 44 THEN DO:
             run utp/ut-msgs.p (INPUT "show":U,
                   INPUT 17006,
                   INPUT "Aten‡Æo, Pedido de OR€AMENTO ou Cota‡Æo gerada pela extranet, NÆo ‚ permitido manuten‡Æo atrav‚s deste programa, utilize a propria extranet. ~~ " +
                         "Aten‡Æo, Pedido de OR€AMENTO ou Cota‡Æo gerada pela extranet, NÆo ‚ permitido manuten‡Æo atrav‚s deste programa, utilize a propria extranet.").

             RETURN "NOK".
        END.

        /* PEDIDOS PROVINIENTES DE SOLICITA°€O, N€O PODEM TER SEUS ITENS ALTERADOS. */
        IF CAN-FIND (FIRST int-solicitacao-item 
                           WHERE int-solicitacao-item.nome-abrev = ped-venda.nome-abrev
                             AND int-solicitacao-item.nr-pedcli  = ped-venda.nr-pedcli) 
        AND NOT l-reativa-suspente THEN DO:

            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Pedido de venda foi gerado via solicita‡Æo (Canais), NÆo pode ser Alterado/Cancelado. ~~ " +
                                     "Os itens deste pedido NÆo podem ser alterados/cancelados, visto que seus valores e quantidades devem refletir exatamente ao que foi informado na solicita‡Æo.").

            RETURN "NOK".
        END.

    END.

END PROCEDURE.

PROCEDURE pi-atualizaSupervisor:

    ASSIGN c-supervisorItem = ''.

    IF AVAILABLE emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST emitente NO-LOCK 
            WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    END.

    IF AVAIL int-emitente THEN DO:

        FIND FIRST repres NO-LOCK 
            WHERE  repres.nome-abrev = wh-nome-repres-pd4000:SCREEN-VALUE NO-ERROR.
        IF AVAIL repres THEN DO:

            IF int-emitente.ind-participa-canais = 993520001 THEN DO:

                /** TRATAMENTO UNIDADE DE NEG…CIO **/
                FOR FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
                      AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000 :SCREEN-VALUE,
                    FIRST ped-item OF ped-venda : //NO-LOCK :
                    ASSIGN c-unidadeNegocioPedido = ped-item.cod-unid-neg.
                END.

                IF c-unidadeNegocioPedido <> '' THEN DO:
                    FIND FIRST int-portfolio-repres-canal
                        WHERE  int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                          AND  int-portfolio-repres-canal.cod-assistente     = int(wh-tp-pedido-pd4000:SCREEN-VALUE)
                          AND  int-portfolio-repres-canal.cod-unid-neg       = c-unidadeNegocioPedido
                          AND  int-portfolio-repres-canal.ind-situacao       = 0 NO-LOCK NO-ERROR.
                    
                    IF  NOT AVAIL int-portfolio-repres-canal THEN DO: //c2108-1460
                        /*run utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 27979,
                                           INPUT "Portfolio Representante inexistente. Consultar botÆo 'Sup'."). */
                        RETURN.
                     END.
                     ELSE
                         ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = int-portfolio-repres-canal.cod-supervisor-ems
                                c-supervisorItem                  = int-portfolio-repres-canal.cod-supervisor-ems.
                END. /* IF c-unidadeNegocioPedido <> '' THEN DO: */

            END. /*IF int-emitente.ind-participa-canais = 993520001*/
            ELSE DO:

                ASSIGN c-unidadeNegocioPedido = wh-cd-unid-comerc-pd4000:SCREEN-VALUE.

                FIND FIRST  crm-relacionamento-cliente NO-LOCK                                         
                     WHERE  crm-relacionamento-cliente.cd-unid-negoc    = c-unidadeNegocioPedido
                       AND  crm-relacionamento-cliente.cod-rep          = repres.cod-rep
                       AND  crm-relacionamento-cliente.cod-emitente     = emitente.cod-emitente 
                       AND (crm-relacionamento-cliente.dt-vigencia-fim  = ? 
                        OR  crm-relacionamento-cliente.dt-vigencia-fim >= TODAY) NO-ERROR.
                IF AVAIL crm-relacionamento-cliente THEN DO:

                    IF crm-relacionamento-cliente.dt-vigencia-fim <> ? THEN DO:
                        IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY
                        AND crm-relacionamento-cliente.dt-vigencia-fim >= TODAY THEN DO:
                            FIND FIRST gerente NO-LOCK
                                WHERE gerente.cod-gerente = crm-relacionamento.cod-gerente NO-ERROR.
                            IF AVAIL gerente THEN 
                                ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = gerente.matricula
                                       c-supervisorItem                  = gerente.matricula.
                        END. /* Datas */
                    END.
                    ELSE DO:

                        IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY THEN DO:
                            FIND FIRST gerente NO-LOCK
                                WHERE gerente.cod-gerente = crm-relacionamento.cod-gerente NO-ERROR.
                            IF AVAIL gerente THEN 
                                ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = gerente.matricula
                                       c-supervisorItem                  = gerente.matricula.
                        END. /* Datas */
                    END.

                END. /*if avail crm-relacionamento-cliente*/

            END. /*IF int-emitente.ind-participa-canais <> 993520001*/

        END. /* IF AVAIL repres THEN DO: */

    END. /* IF AVAIL int-emitente THEN DO: */
    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
          AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000 :SCREEN-VALUE,
        FIRST int-ped-venda
        WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK .
        ASSIGN OVERLAY(int-ped-venda.char-1,68,8)  = c-supervisorItem.
    END.
    RELEASE int-ped-venda.

END PROCEDURE.

PROCEDURE pi-leaveSupervisor:

    IF  AVAIL ped-venda
    AND (ped-venda.nr-tabpre <> "lai02" 
    AND  ped-venda.nr-tabpre <> "ASTEC 02") THEN DO:

        IF AVAILABLE emitente THEN DO:
            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST emitente NO-LOCK 
                WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        END.
    
        IF AVAIL int-emitente THEN DO:
    
            IF int-emitente.ind-participa-canais = 993520001 THEN DO:
    
                /** TRATAMENTO UNIDADE DE NEG…CIO **/
                FOR FIRST ped-item OF ped-venda NO-LOCK :
                    ASSIGN c-unidadeNegocioPedido = ped-item.cod-unid-neg.
                END.
                
                FIND FIRST ponto-programa
                    WHERE ponto-programa.nome-programa = "pd4000":U
                      AND ponto-programa.ponto         = 6 NO-LOCK NO-ERROR.
                IF AVAILABLE ponto-programa THEN DO:

                    IF NOT CAN-FIND(conteudo-programa
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                          AND conteudo-programa.conteudo     = TRIM(wh-tp-pedido-pd4000:SCREEN-VALUE)) THEN DO:

                        RUN esp/es0018p.p (INPUT "PD4000",
                                               INPUT 4,
                                               INPUT 0,
                                               INPUT "", 
                                               OUTPUT TABLE tt-prog-ponto).

                            /*Unidade de negocios NÆo faz parte do programa de canais*/
                        IF (NOT CAN-FIND (FIRST tt-prog-ponto
                                         WHERE tt-prog-ponto.conteudo = c-unidadeNegocioPedido)) AND
                            c-unidadeNegocioPedido <> '' THEN DO:

                            FIND FIRST repres NO-LOCK 
                                WHERE  repres.nome-abrev = wh-nome-repres-pd4000:SCREEN-VALUE NO-ERROR.
                            IF AVAIL repres THEN DO:

                                FIND FIRST int-portfolio-repres-canal
                                    WHERE  int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                                      AND  int-portfolio-repres-canal.cod-assistente     = int(wh-tp-pedido-pd4000:SCREEN-VALUE)
                                      AND  int-portfolio-repres-canal.cod-unid-neg       = c-unidadeNegocioPedido 
                                      AND  int-portfolio-repres-canal.ind-situacao           = 0 NO-LOCK NO-ERROR.
                                IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                                    run utp/ut-msgs.p (INPUT "show":U,
                                                       INPUT 17006,
                                                       INPUT "Supervisor inv lido! ~~ NÆo h ÿsupervisor cadastrado para Unid Neg X Repres X Cliente. Consultar CRM.").
                                     IF l-supervisorSave THEN DO:
                                         ASSIGN l-supervisorSave = NO.
                                         RETURN NO-APPLY.
                                     END.
                                     ELSE DO:
                                         IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                             APPLY "Entry":U TO wh-cod-priori-pd4000.
                                         END.
                                         RETURN 'NOK'.
                                     END.
                                END. /* IF NOT AVAIL int-portfolio-repres-canal THEN DO: */

                                FIND FIRST int-portfolio-repres-canal
                                    WHERE  int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                                      AND  int-portfolio-repres-canal.cod-assistente     = int(wh-tp-pedido-pd4000:SCREEN-VALUE)
                                      AND  int-portfolio-repres-canal.cod-unid-neg       = c-unidadeNegocioPedido 
                                      AND  int-portfolio-repres-canal.cod-supervisor-ems = wh-supervisor-pd4000:SCREEN-VALUE 
                                      AND  int-portfolio-repres-canal.ind-situacao           = 0 NO-LOCK NO-ERROR.
                                IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                                    run utp/ut-msgs.p (INPUT "show":U,
                                                       INPUT 17006,
                                                       INPUT "Supervisor inv lido! ~~ NÆo hÿ relacionamento entre Unid Neg X Repres X Cliente com data v lida.").
                                    IF l-supervisorSave THEN DO:
                                        ASSIGN l-supervisorSave = NO.
                                        RETURN NO-APPLY.
                                    END.
                                    ELSE DO:
                                        IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                            APPLY "Entry":U TO wh-cod-priori-pd4000.
                                        END.
                                        RETURN 'NOK'.
                                    END.
                                END. /* IF NOT AVAIL int-portfolio-repres-canal THEN DO: */

                            END. /* IF AVAIL repres THEN DO: */

                        END. /* IF c-unidadeNegocioPedido <> '' THEN DO: */

                    END. /* NOT CAN-FIND conteudo-programa */

                END. /* IF AVAILABLE ponto-programa THEN DO: */
    
            END. /* IF int-emitente.ind-participa-canais = 993520001 THEN DO: */
            /**************************************** 
            Quando NÆo ² canais, NÆo deve se validar
            
            ELSE DO:
    
                ASSIGN c-unidadeNegocioPedido = wh-cd-unid-comerc-pd4000:SCREEN-VALUE.
    
                FIND FIRST  crm-relacionamento-cliente NO-LOCK                                         
                     WHERE  crm-relacionamento-cliente.cd-unid-negoc    = c-unidadeNegocioPedido
                       AND  crm-relacionamento-cliente.cod-rep          = repres.cod-rep
                       AND  crm-relacionamento-cliente.cod-emitente     = emitente.cod-emitente  
                       AND (crm-relacionamento-cliente.dt-vigencia-fim  = ? 
                        OR  crm-relacionamento-cliente.dt-vigencia-fim >= TODAY) NO-ERROR.
                IF AVAIL crm-relacionamento-cliente THEN DO:
    
                    IF crm-relacionamento-cliente.dt-vigencia-fim <> ? THEN DO:

                        IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY
                        AND crm-relacionamento-cliente.dt-vigencia-fim >= TODAY THEN DO:

                            FIND FIRST gerente
                                WHERE gerente.matricula = trim(wh-supervisor-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
                            IF NOT AVAIL gerente OR wh-supervisor-pd4000:SCREEN-VALUE = "" THEN DO:
                                run utp/ut-msgs.p (INPUT "show":U,
                                                   INPUT 17006,
                                                   INPUT "Supervisor inv lido ou em branco! ~~ Informar um supervisor vÿlido.").
                                IF l-supervisorSave THEN DO:
                                    ASSIGN l-supervisorSave = NO.
                                    RETURN NO-APPLY.
                                END.
                                ELSE DO:
                                    IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                        APPLY "Entry":U TO wh-cod-priori-pd4000.
                                    END.
                                    RETURN 'NOK'.
                                END.

                            END. /* IF NOT AVAIL gerente OR wh-supervisor-pd4000:SCREEN-VALUE = "" THEN DO: */

                        END. /* Datas */
                        ELSE DO:
                            run utp/ut-msgs.p (INPUT "show":U,
                                               INPUT 17006,
                                               INPUT "Supervisor inv lido! ~~ NÆo hÿ relacionamento entre Unid Neg X Repres X Cliente com data v lida.").
                            IF l-supervisorSave THEN
                                ASSIGN l-supervisorSave = NO.
                            ELSE DO:
                                IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                    APPLY "Entry":U TO wh-cod-priori-pd4000.
                                END.
                                RETURN 'NOK'.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY THEN DO:

                            FIND FIRST gerente
                                WHERE gerente.matricula = trim(wh-supervisor-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.
                            IF NOT AVAIL gerente OR wh-supervisor-pd4000:SCREEN-VALUE = "" THEN DO:
                                run utp/ut-msgs.p (INPUT "show":U,
                                                   INPUT 17006,
                                                   INPUT "Supervisor inv lido ou em branco! ~~ Informar um supervisor vÿlido.").
                                IF l-supervisorSave THEN
                                    ASSIGN l-supervisorSave = NO.
                                ELSE DO:
                                    IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                        APPLY "Entry":U TO wh-cod-priori-pd4000.
                                    END.
                                    RETURN 'NOK'.
                                END.
                            END. /* IF NOT AVAIL gerente OR wh-supervisor-pd4000:SCREEN-VALUE = "" THEN DO: */

                        END. /* Datas */
                        ELSE DO:
                            run utp/ut-msgs.p (INPUT "show":U,
                                               INPUT 17006,
                                               INPUT "Supervisor inv lido! ~~ NÆo hÿ relacionamento entre Unid Neg X Repres X Cliente com data v lida.").
                            IF l-supervisorSave THEN
                                ASSIGN l-supervisorSave = NO.
                            ELSE DO:
                                IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                                    APPLY "Entry":U TO wh-cod-priori-pd4000.
                                END.
                                RETURN 'NOK'.
                            END.
                        END.
                    END.
    
                END. /* IF AVAIL crm-relacionamento-cliente THEN DO: */
                ELSE DO:
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "Supervisor inv lido! ~~ NÆo hÿ relacionamento entre Unid Neg X Repres X Cliente.").
                    IF l-supervisorSave THEN
                        ASSIGN l-supervisorSave = NO.
                    ELSE DO:
                        IF VALID-HANDLE(wh-cod-priori-pd4000) THEN DO:
                            APPLY "Entry":U TO wh-cod-priori-pd4000.
                        END.
                        RETURN 'NOK'.
                    END.
                END.
    
            END.
            ****************************************/

        END. /* IF AVAIL int-emitente THEN DO: */

    END. /* ped-venda.nr-tabpre = "lai02" OR ped-venda.nr-tabpre = "ASTEC 02" */

END PROCEDURE.

PROCEDURE pi-buttonSupervisor:

    /*Valida se for pedido B2B desabilita o campo supervisor.*/
    FIND FIRST emitente
        WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:

            IF int-emitente.ind-participa-canais = 993520001 THEN
                RUN esp/pdp/espdp082.w.
            ELSE
                APPLY "f5" TO wh-supervisor-pd4000.

        END. /* IF AVAIL int-emitente THEN DO: */

    END. /* IF AVAILABLE emitente THEN DO: */


END PROCEDURE.

PROCEDURE pi-leave-repres:

  RUN pi-seta-default-repres IN p-wgh-object.
  RUN pi-NomeAbrev IN p-wgh-object.

    RUN pi-atualizaSupervisor.

END PROCEDURE.

/*
PROCEDURE pi-CopyOrder-pd4000-new:

    FIND FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "pd4000":U
          AND ponto-programa.ponto         = 5 NO-LOCK NO-ERROR.
    IF AVAILABLE ponto-programa THEN DO:

        IF NOT CAN-FIND(conteudo-programa
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
              AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Op»’o DE c½pia indispon­vel.~~ " +
                             "Por gentileza, entrar em contato com PCI - Programa de Canais.")).
            /*APPLY "choose" TO wh-btCancelOrder-pd4000.*/
            RETURN "NOK". 

        END.
        ELSE
            APPLY "choose" TO wh-btCopyOrder-pd4000.

    END.

END PROCEDURE.
*/

PROCEDURE pi-verifica-portfolio-canais:

    IF NOT VALID-HANDLE(wh-nome-abrev-pd4000) THEN RETURN.
    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    IF AVAIL int-emitente THEN DO:

        IF  NOT fn-grupo-distribuidores(int-emitente.cod-emitente) /* Grupos que participam de canais e possuem portif¢lio -> chamado 72993 */  THEN
            RETURN "OK".
        FIND natur-oper
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL natur-oper THEN DO:

            IF  int-emitente.ind-participa-canais = 993520001 
            AND natur-oper.emite-duplic = YES THEN DO:

                    RUN esp/es0018p.p (INPUT "PD4000",
                                       INPUT 4,
                                       INPUT 0,
                                       INPUT "", 
                                       OUTPUT TABLE tt-prog-ponto).

                    /*Unidade de negocios NÆo faz parte do programa de canais*/
                    IF NOT CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = item-uni-estab.cod-unid)  THEN DO:

/*                         OUTPUT TO c:\temp\pd4000-upc.txt.   */
/*                         FOR EACH produtoitem:               */
/*                             DISP produtoitem.codigoproduto. */
/*                         END.                                */
/*                         OUTPUT CLOSE.                       */

                        FIND FIRST int-calculo-canal NO-LOCK
                             WHERE int-calculo-canal.cod-guid     = int-emitente.cod-guid 
                               AND int-calculo-canal.cod-estabel  = ped-venda.cod-estabel
                               AND int-calculo-canal.data-calculo = TODAY NO-ERROR.

                        IF AVAIL int-calculo-canal THEN DO:

                           FOR FIRST ponto-programa NO-LOCK
                               WHERE ponto-programa.nome-programa = "pd4000"
                                 AND ponto-programa.ponto         = 5:
                           END.
                           FIND FIRST conteudo-programa 
                           WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                              AND conteudo-programa.conteudo     = c-seg-usuario NO-LOCK NO-ERROR.
                           IF AVAIL conteudo-programa THEN DO:
                                FIND FIRST int-ped-venda
                                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                IF AVAIL int-ped-venda THEN
                                    ASSIGN OVERLAY(int-ped-venda.char-1, 80, 12) = c-seg-usuario.
                                RELEASE int-ped-venda.
                            END. /* IF AVAIL conteudo-programa THEN DO: */
                        END. /* IF AVAIL int-calculo-canal THEN DO: */
                        ELSE DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "NÆo encontrado c lculo de Pre‡os para o cliente " + STRING(int-emitente.cod-emitente) + " no dia " + STRING(TODAY)).
                            RETURN "NOK":U.
                        END. /* IF AVAIL int-calculo-canal THEN DO:*/

                    END. /* IF NOT CAN-FIND (FIRST tt-prog-ponto */

                
            END. /* IF  int-emitente.ind-participa-canais = 993520001 AND natur-oper.emite-duplic = YES THEN DO: */

        END. /* IF AVAIL natur-oper THEN DO: */

    END. /* IF AVAIL int-emitente THEN DO: */
END PROCEDURE.

PROCEDURE cria-cash:
    DEFINE VARIABLE i-num-itens-calculo AS INTEGER     NO-UNDO.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
           AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE NO-ERROR.

    FIND FIRST emitente NO-LOCK 
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF NOT AVAIL int-emitente
    OR int-emitente.cod-guid = "" THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Emitente NÆo cadastrado no CRM").
        RETURN.
    END.

    IF int-emitente.log-salesforce = NO THEN DO:
        /*limpa tt's*/
        EMPTY TEMP-TABLE ProdutoItem.
        EMPTY TEMP-TABLE tt-itens.
        EMPTY TEMP-TABLE ProdutoItemR.
        
    
        RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "c lculo Pre‡os.").
    
        Blk_calc:
        DO TRANS:
            /*Verifica se jÿ possui c lculo para o canal*/
            FIND FIRST int-calculo-canal EXCLUSIVE-LOCK
                 WHERE int-calculo-canal.cod-guid    = int-emitente.cod-guid 
                   AND int-calculo-canal.cod-estabel = ped-venda.cod-estabel NO-ERROR.
        
            /*Se NÆo possui calculo para o canal cria*/
            IF NOT AVAIL int-calculo-canal THEN DO:
                CREATE int-calculo-canal.
                ASSIGN int-calculo-canal.cod-guid    = int-emitente.cod-guid
                       int-calculo-canal.cod-estabel = ped-venda.cod-estabel.
            END.
        
            ASSIGN int-calculo-canal.data-calculo = TODAY
                   int-calculo-canal.hora-calculo = NOW.
        
            /*Elimina os itens calculados para calcular de novo*/
            FOR EACH int-calculo-canal-item EXCLUSIVE-LOCK
               WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
                 AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel:
                DELETE int-calculo-canal-item.
            END.
           
            
    
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando portif¢lio.").
        
            /*Busca portifolio*/
            RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                       OUTPUT TABLE ProdutoItem,                    
                                       OUTPUT TABLE Resultado). 
        
            FIND FIRST Resultado NO-ERROR.
        
            IF  AVAIL Resultado
            AND Resultado.Sucesso THEN DO:
    
                ASSIGN i-num-itens-calculo = 0.
    
                FOR EACH ped-item OF ped-venda NO-LOCK:
    
                     FIND FIRST ProdutoItem
                          WHERE ProdutoItem.codigoProduto = ped-item.it-codigo NO-ERROR.
                     IF AVAIL ProdutoItem THEN DO:
    
                         FIND FIRST ITEM NO-LOCK
                              WHERE ITEM.it-codigo = ProdutoItem.CodigoProduto NO-ERROR.
                   
                         IF NOT AVAIL ITEM THEN NEXT.
                   
                         FIND FIRST item-uni-estab NO-LOCK
                              WHERE item-uni-estab.it-codigo   = ProdutoItem.CodigoProduto
                                AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-ERROR.
                   
                         CREATE tt-itens.
                         ASSIGN tt-itens.it-codigo              = ProdutoItem.CodigoProduto
                                tt-itens.de-quantidade          = ped-item.qt-pedida
                                tt-itens.TipoPortfolio          = ProdutoItem.TipoPortfolio
                                tt-itens.CodigoUnidadeNegocio   = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-neg ELSE ITEM.cod-unid-neg
                                tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                                tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
                   
                         /*calcula o Pre‡o a cada 200 itens para NÆo estourar o longchar*/
                         ASSIGN i-num-itens-calculo = i-num-itens-calculo + 1.
                   
                         IF i-num-itens-calculo = 100 THEN DO:
                   
                             RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                                        INPUT TABLE tt-itens,
                                                        OUTPUT TABLE ProdutoItemR-temp,
                                                        OUTPUT TABLE Resultado).
                   
                             FIND FIRST Resultado NO-ERROR.
                   
                             IF NOT AVAIL Resultado THEN DO:
                                 RUN utp/ut-msgs.p (INPUT "show",
                                                    INPUT 17006,
                                                    INPUT "NÆo foi poss¡vel consultar Pre‡os").
                                 UNDO, LEAVE Blk_calc.
                             END.
                             ELSE IF NOT Resultado.Sucesso THEN DO:
                                  RUN utp/ut-msgs.p (INPUT "show",
                                                     INPUT 17006,
                                                     INPUT Resultado.Mensagem).
                                 UNDO, LEAVE Blk_calc.
                             END.
                   
                             FOR EACH ProdutoItemR-temp:
                                 CREATE ProdutoItemR.
                                 BUFFER-COPY ProdutoItemR-temp TO ProdutoItemR.
                             END.
                   
                             /*Ap½s o envio dos primeiros 300 zera tudo*/
                             EMPTY TEMP-TABLE tt-itens.
                             EMPTY TEMP-TABLE ProdutoItemR-temp.
                             ASSIGN i-num-itens-calculo = 0.
                         END.
                     END. /*find first produtoitem*/
                END. /*for each ped-item*/
                
                /*Calcula Pre‡os*/
                RUN pi-acompanhar IN h-acomp (INPUT "Calculando Pre‡os.").
                IF  CAN-FIND(FIRST tt-itens) THEN DO:
                    RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                               INPUT TABLE tt-itens,
                                               OUTPUT TABLE ProdutoItemR-temp,
                                               OUTPUT TABLE Resultado).
    
                    FIND FIRST Resultado NO-ERROR.
    
                    IF NOT AVAIL Resultado THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "NÆo foi poss¡vel consultar Pre‡os").
                        UNDO, LEAVE Blk_calc.
                    END.
                    ELSE IF NOT Resultado.Sucesso THEN DO:
                         RUN utp/ut-msgs.p (INPUT "show",
                                            INPUT 17006,
                                            INPUT Resultado.Mensagem).
                        UNDO, LEAVE Blk_calc.
                    END.
    
                    FOR EACH ProdutoItemR-temp:
                        CREATE ProdutoItemR.
                        BUFFER-COPY ProdutoItemR-temp TO ProdutoItemR.
                    END.
                END.
                
                FOR EACH ProdutoItemR:
                    /*Busca o tipo de prtifolio retornado pela mensagem do portifolio*/
                    FIND FIRST ProdutoItem 
                         WHERE ProdutoItem.CodigoProduto = ProdutoItemR.CodigoProduto NO-ERROR.
    
                    FIND FIRST int-calculo-canal-item NO-LOCK
                         WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
                           AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel
                           AND int-calculo-canal-item.it-codigo   = ProdutoItemR.CodigoProduto NO-ERROR.
                    IF NOT AVAIL int-calculo-canal-item THEN DO:
                       CREATE int-calculo-canal-item.
                       ASSIGN int-calculo-canal-item.cod-guid               = int-calculo-canal.cod-guid
                              int-calculo-canal-item.cod-estabel            = int-calculo-canal.cod-estabel
                              int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                              int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                              int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                              int-calculo-canal-item.tipo-portifolio        = ProdutoItem.TipoPortfolio
                              int-calculo-canal-item.bloqueado              = ProdutoItem.Bloqueado
                              int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                              int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                              int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                              int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                              int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                              int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                              int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                              int-calculo-canal-item.data-calculo           = TODAY.
                    END.
                END.
            END.
            ELSE DO:
                IF AVAIL resultado THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT Resultado.Mensagem).
    
                    UNDO, LEAVE Blk_calc.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "NÆo foi poss¡vel consultar portif¢lio").
    
                    UNDO, LEAVE Blk_calc.
                END.
            END.
            IF  AVAIL int-calculo-canal THEN DO:
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN
                    ASSIGN wh-bt-calcula-preco:LABEL   = SUBSTRING(ENTRY(2,STRING(int-calculo-canal.hora-calculo),""),1,5)  /*Somente a hora do campo datetime*/
                           wh-bt-calcula-preco:BGCOLOR = ?.
            END.
            ELSE DO: 
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN DO:
                    IF int-emitente.ind-participa-canais = 993520001 THEN DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "CALCULAR"
                               wh-bt-calcula-preco:BGCOLOR = 12. 
                    END.
                    ELSE DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "-"
                               wh-bt-calcula-preco:BGCOLOR = ?.
                    END.
                END.
            END.
        END. /*Blk_calc*/
    
        FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
        RELEASE int-calculo-canal-item.
    
        FIND CURRENT int-calculo-canal NO-LOCK NO-ERROR.
        RELEASE int-calculo-canal.
        RUN pi-finalizar IN h-acomp.
    END.
    ELSE DO:
       FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
              AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN l-atual = NO.  
       FOR EACH ped-item OF ped-venda :
           IF  ped-item.cod-sit-it <> 1 
           AND ped-item.cod-sit-it <> 2 THEN NEXT.    
                         
           RUN pi-atualiza-valor-item.
          
           {esp/pdp/espdp012.i}  /* busca descontos pci */ 
                      
           ASSIGN l-atual = YES.
       END.
       IF l-atual = YES THEN DO:
           ASSIGN ped-venda.completo = NO.
           APPLY "choose" TO wh-btcompleteorder-ped4000.
           FIND CURRENT ped-venda NO-LOCK NO-ERROR.

           if valid-handle(h-bodi159cal)then do:
              delete procedure h-bodi159cal.
              assign h-bodi159cal = ?.
           END.
           MESSAGE "Pedido atualizado com sucesso!" VIEW-AS ALERT-BOX INFORMAT.
       END.
       ELSE
          MESSAGE "Pedido NÆo atualizado! Verifique o Status do Pedido" VIEW-AS ALERT-BOX ERROR.
    END.

END PROCEDURE.

/********************************/
PROCEDURE cria-cash2:

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF int-emitente.log-salesforce = NO THEN DO:

        /*limpa tt's*/
        EMPTY TEMP-TABLE ProdutoItem.
        EMPTY TEMP-TABLE tt-itens.
        EMPTY TEMP-TABLE ProdutoItemR.
    
        RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Calculo Precos.").
    
        Blk_calc:
        DO TRANS:
            /*Elimina os itens calculados para calcular de novo*/
            FOR EACH int-calculo-canal-item EXCLUSIVE-LOCK
               WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
                 AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel
                 AND int-calculo-canal-item.it-codigo   = whit-codigo:SCREEN-VALUE:
                DELETE int-calculo-canal-item.
            END.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando portif¢lio.").
        
            /*Busca portifolio*/
            RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                       OUTPUT TABLE ProdutoItem,                    
                                       OUTPUT TABLE Resultado). 
        
            FIND FIRST Resultado NO-ERROR.
        
            IF  AVAIL Resultado
            AND Resultado.Sucesso THEN DO:
    
                IF VALID-HANDLE(whit-codigo) AND whit-codigo:SCREEN-VALUE <> '' THEN DO:
                    FOR EACH ProdutoItem
                        WHERE ProdutoItem.CodigoProduto = whit-codigo:SCREEN-VALUE:
                        FIND FIRST ITEM NO-LOCK
                             WHERE ITEM.it-codigo = ProdutoItem.CodigoProduto NO-ERROR.
    
                        FIND FIRST item-uni-estab NO-LOCK
                             WHERE item-uni-estab.it-codigo   = ProdutoItem.CodigoProduto
                               AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    
    
                        CREATE tt-itens.
                        ASSIGN tt-itens.it-codigo              = ProdutoItem.CodigoProduto
                               tt-itens.de-quantidade          = 1
                               tt-itens.TipoPortfolio          = ProdutoItem.TipoPortfolio
                               tt-itens.CodigoUnidadeNegocio   = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-neg ELSE ITEM.cod-unid-neg
                               tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                               tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
                    END.
                END. /* IF VALID-HANDLE(whit-codigo) AND whit-codigo:SCREEN-VALUE <> '' THEN DO: */
                ELSE DO:
                    FOR EACH ProdutoItem:
                        FIND FIRST ITEM NO-LOCK
                             WHERE ITEM.it-codigo = ProdutoItem.CodigoProduto NO-ERROR.
    
                        FIND FIRST item-uni-estab NO-LOCK
                             WHERE item-uni-estab.it-codigo   = ProdutoItem.CodigoProduto
                               AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    
    
                        CREATE tt-itens.
                        ASSIGN tt-itens.it-codigo              = ProdutoItem.CodigoProduto
                               tt-itens.de-quantidade          = 1
                               tt-itens.TipoPortfolio          = ProdutoItem.TipoPortfolio
                               tt-itens.CodigoUnidadeNegocio   = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-neg ELSE ITEM.cod-unid-neg
                               tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                               tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
                    END.
                END.
            
                EMPTY TEMP-TABLE Resultado.
                
                /*Calcula Pre‡os*/
                RUN pi-acompanhar IN h-acomp (INPUT "Calculando Pre‡os.").
                IF  CAN-FIND(FIRST tt-itens) THEN
                    RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                               INPUT TABLE tt-itens,
                                               OUTPUT TABLE ProdutoItemR,
                                               OUTPUT TABLE Resultado).
    
                FIND FIRST Resultado NO-ERROR.
        
                IF  AVAIL Resultado
                AND Resultado.Sucesso THEN DO:
                    FOR EACH ProdutoItemR:
                        
                        /*Busca o tipo de prtifolio retornado pela mensagem do portifolio*/
                        FIND FIRST ProdutoItem 
                             WHERE ProdutoItem.CodigoProduto = ProdutoItemR.CodigoProduto NO-ERROR.
    
                        CREATE int-calculo-canal-item.
                        ASSIGN int-calculo-canal-item.cod-guid               = int-calculo-canal.cod-guid
                               int-calculo-canal-item.cod-estabel            = int-calculo-canal.cod-estabel
                               int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                               int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                               int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                               int-calculo-canal-item.tipo-portifolio        = ProdutoItem.TipoPortfolio
                               int-calculo-canal-item.bloqueado              = ProdutoItem.Bloqueado
                               int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                               int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                               int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                               int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                               int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                               int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                               int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                               int-calculo-canal-item.data-calculo           = TODAY. // marcio stam
                    END.
                END.
                ELSE DO:
                    IF AVAIL resultado THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT Resultado.Mensagem).
                        UNDO, LEAVE Blk_calc.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "NÆo foi poss¡vel consultar Pre‡os").
                        UNDO, LEAVE Blk_calc.
                    END.
                END.
            END.
            ELSE DO:
                IF AVAIL resultado THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT Resultado.Mensagem).
    
                    UNDO, LEAVE Blk_calc.
            
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "NÆo foi poss¡vel consultar portif¢lio").
    
                    UNDO, LEAVE Blk_calc.
                END.
            END.
            IF  AVAIL int-calculo-canal THEN DO:
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN
                    ASSIGN wh-bt-calcula-preco:LABEL   = SUBSTRING(ENTRY(2,STRING(int-calculo-canal.hora-calculo),""),1,5)  /*Somente a hora do campo datetime*/
                           wh-bt-calcula-preco:BGCOLOR = ?.
            END.
            ELSE DO: 
                IF VALID-HANDLE (wh-bt-calcula-preco) THEN DO:
                    IF int-emitente.ind-participa-canais = 993520001 THEN DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "CALCULAR"
                               wh-bt-calcula-preco:BGCOLOR = 12. 
                    END.
                    ELSE DO:
                        ASSIGN wh-bt-calcula-preco:LABEL   = "-"
                               wh-bt-calcula-preco:BGCOLOR = ?.
                    END.
                END.
            END.
        END. /*Blk_calc*/
    
        FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
        RELEASE int-calculo-canal-item.
        
        RUN pi-finalizar IN h-acomp.
    END.
    ELSE DO:
        MESSAGE whvl-preuni VIEW-AS ALERT-BOX.
        FIND FIRST ped-venda
             WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
               AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN l-atual = NO.  
        FOR EACH ped-item OF ped-venda :
            IF  ped-item.cod-sit-it <> 1 
            AND ped-item.cod-sit-it <> 2 THEN NEXT.    

            RUN pi-atualiza-valor-item.

            {esp/pdp/espdp012.i}  /* busca descontos pci */ 

            ASSIGN l-atual = YES.
        END.
        IF l-atual = YES THEN DO:
            ASSIGN ped-venda.completo = NO.
            APPLY "choose" TO wh-btcompleteorder-ped4000.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.

            if valid-handle(h-bodi159cal)then do:
               delete procedure h-bodi159cal.
               assign h-bodi159cal = ?.
            END.
            MESSAGE "Pedido atualizado com sucesso!" VIEW-AS ALERT-BOX INFORMAT.
        END.
        ELSE
           MESSAGE "Pedido NÆo atualizado! Verifique o Status do Pedido" VIEW-AS ALERT-BOX ERROR.
    END.
END PROCEDURE.





PROCEDURE pi-atualiza-preco:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Deseja atualizar o Pre‡o de todos os itens do pedido?").

    IF RETURN-VALUE = "YES" THEN
        RUN pi-recalcula-todos-itens. //(INPUT "").

END PROCEDURE.

//IDBA Bruno Joaquim - 20/08/2023
PROCEDURE pi-bt-receita-recorrente:
 IF VALID-HANDLE(wh-nr-pedcli-pd4000) THEN DO:
    FIND FIRST ped-venda
        WHERE ped-venda.nr-pedcli = TRIM(wh-nr-pedcli-pd4000:SCREEN-VALUE) NO-LOCK NO-ERROR.

    FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF AVAIL int-ped-venda THEN DO:

        IF int-ped-venda.nr-contrato = "0" OR length(int-ped-venda.nr-contrato) = 0  THEN DO:
            MESSAGE "Pedido nÆo possui vinculo com contrato"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN.
        END.
        ELSE DO:
            RUN esp\pdp\espdp105.w(INPUT int-ped-venda.nr-contrato) .
        END.
    END.
    ELSE DO:
        MESSAGE "Pedido nÆo possui vinculo com contrato"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

 END.
                         
END PROCEDURE.

PROCEDURE pi-onchoose-modal:

    ASSIGN l-transp-checked = wh-combo-modal-pd4000:CHECKED.

END PROCEDURE.

PROCEDURE pi-onchoose-gpon:

    ASSIGN l-gpon-checked = wh-gpon-pd4000:CHECKED.

END PROCEDURE.

PROCEDURE pi-choose-bt-save-ord:
    APPLY "CHOOSE" TO wh-bt-save-ord-new.
END PROCEDURE.

PROCEDURE pi-return-vl-preuni:    
    APPLY "leave" TO whvl-preuni.
    APPLY "choose" TO wh-bt-confirma-item-pd4000.
    APPLY "entry" TO whit-codigo.

    RETURN NO-APPLY.
END PROCEDURE.

PROCEDURE pi-espdp027:
    RUN esp/pdp/espdp027.w.
END PROCEDURE.

PROCEDURE pi-desconto:

   CASE int-beneficio-conta.nome-beneficio: 
       WHEN 'Top Milhao'                THEN ASSIGN tt-int-ped-item-pci.desc-topmilhao  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Mais Verde  '              THEN ASSIGN tt-int-ped-item-pci.desc-maisverde  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Foco na Unidade'           THEN ASSIGN tt-int-ped-item-pci.desc-focounid   = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Distribuidor 2.0'          THEN ASSIGN tt-int-ped-item-pci.desc-distrib    = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Wide Cloud'                THEN ASSIGN tt-int-ped-item-pci.desc-widecloud  = int-beneficio-conta.perc-desconto / 100.
   END.
   
END PROCEDURE.

PROCEDURE pi-atualiza-valor-item.
    
    FIND FIRST mgesp.int-ped-item-pci
         WHERE int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev 
           AND int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
           AND int-ped-item-pci.it-codigo    = ped-item.it-codigo 
           AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-pci THEN DO:
       FIND LAST preco-item 
           WHERE preco-item.it-codigo  = int-ped-item-pci.it-codigo
             AND preco-item.nr-tabpre  = int-ped-item-pci.nr-tabpre  //c-tab-preco 
             AND preco-item.cod-refer  = ped-venda.cod-estabel
             and preco-item.dt-inival <= today    
             and preco-item.situacao   = 1 
             AND preco-item.quant-min  <= ped-item.qt-pedida NO-LOCK NO-ERROR.

       IF AVAIL preco-item THEN DO:
          ASSIGN de-preco-venda                = preco-item.preco-venda
                 de-desco-qt                   = preco-item.desco-quant.
       END.
       ELSE DO:
          FIND LAST preco-item 
              WHERE preco-item.it-codigo  = int-ped-item-pci.it-codigo
                AND preco-item.nr-tabpre  = int-ped-item-pci.nr-tabpre  //c-tab-preco 
                AND preco-item.cod-refer  = ped-venda.cod-estabel
                and preco-item.dt-inival <= today    
                and preco-item.situacao   = 1  NO-LOCK NO-ERROR.
          IF AVAIL preco-item THEN DO:
             ASSIGN de-preco-venda                = preco-item.preco-venda
                    de-desco-qt                   = preco-item.desco-quant.
          END.
          ELSE 
              ASSIGN de-preco-venda         = ped-item.vl-preori  
                     de-desco-qt            = 0.
       END.
    END.
    ELSE DO :
        ASSIGN de-preco-venda = ped-item.vl-preori.
    END.

    IF AVAIL int-ped-item-pci THEN DO:
        FIND FIRST cond-pagto 
             WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
        FIND FIRST tab-finan-indice NO-LOCK
             WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
               AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.
        IF AVAIL tab-finan-indice THEN 
           ASSIGN  de-indice-finan = tab-finan-indice.tab-ind-fin.
       // APLICA INDICE DE FINANCIAMENTO NO PRECO 
         IF de-indice-finan <> 1 THEN DO:
            ASSIGN de-preco-venda = de-preco-venda * de-indice-finan.
         END.
    
         // APLICA NO PRECO O FATOR DE DESCONTO ACRESCIMO DO CLIENTE 
         ASSIGN de-fator-cli = 0.
         FIND FIRST mgesp.int-ped-item-pci
              WHERE int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
                AND int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev
                AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                AND int-ped-item-pci.it-codigo    = ped-item.it-codigo NO-LOCK NO-ERROR.
         IF AVAIL int-ped-item-pci THEN
         RUN pi-busca-desconto-cliente (INPUT int-emitente.cod-emitente,
                                        INPUT int-ped-item-pci.nr-tabpre,
                                        INPUT ped-item.it-codigo,
                                        OUTPUT de-fator-cli).
    
         IF de-fator-cli <> 0 THEN DO:
            ASSIGN de-preco-venda = de-preco-venda * de-fator-cli.
         END.
         IF de-preco-venda > 0 THEN DO:
             ASSIGN ped-item.vl-preori           = de-preco-venda
                    ped-item.vl-preori-un-fat    = de-preco-venda
                    ped-item.vl-pretab           = de-preco-venda.
         END.
    END.
END.

PROCEDURE pi-busca-desconto-cliente.
   {esp/wso/eswso0010.i1}
END.

if valid-handle(wh-dt-entrega-pd4000) then
    assign wh-dt-entrega-pd4000:label = "Prev.Fatur".
    
if valid-handle(wh-dt-entorig-pd4000) then
    assign wh-dt-entorig-pd4000:label = "Prev.Fatur Orig".
    
if valid-handle(wh-dt-entrega3-pd4000) then
    assign wh-dt-entrega3-pd4000:label = "Prev.Fatur".
    
if valid-handle(wh-dt-entorig3-pd4000) then
    assign wh-dt-entorig3-pd4000:label = "Prev.Fatur Orig".
    
if valid-handle(wh-dt-entrega13-pd4000) then
    assign wh-dt-entrega13-pd4000:label = "Prev.Fatur".
    
if valid-handle(wh-dt-entorig13-pd4000) then
    assign wh-dt-entorig13-pd4000:label = "Prev.Fatur Orig".
    
if valid-handle(wh-dt-entorig-item-pd4000) then
    assign wh-dt-entorig-item-pd4000:label = "Prev.Fatur Orig".



IF VALID-HANDLE(wh-nome-abrev-pd4000) THEN DO:

/*** IDBA BRUNO - 29/06/2023 - Adiciona Campo Desconto Negociacao Comercial para clientes sales force ****/
    FIND FIRST emitente WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-ERROR.
    IF AVAIL emitente THEN DO:
    FIND FIRST int-emitente WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:
            IF int-emitente.log-sales = yes THEN DO:

                   run pi-busca-handle (input wh-frame-fpage6-pd4000,
                                        input p-ind-event,
                                        input 'fill-in':U,
                                        input 'val-desconto-inform':U,
                                        input NO,
                                        output whval-desconto-inform-fpage6-pd4000).
                        
                   IF VALID-HANDLE(whval-desconto-inform-fpage6-pd4000) THEN DO:
                      ASSIGN whval-desconto-inform-fpage6-pd4000 :VISIBLE = NO .
                   END.

                   IF AVAIL ped-item AND AVAIL ped-venda THEN DO:
                       IF ped-venda.cod-sit-ped = 1 /*pedido aberto */ THEN DO:
                           ASSIGN ped-item.val-desconto-inform = 0 .
                       END.
                   END.


                /*****/
                IF VALID-HANDLE(p-wgh-frame)  
                   AND p-wgh-frame:NAME = "fPage6" 
                   AND AVAIL ped-item THEN DO:

                    
                   IF NOT VALID-HANDLE(wh-desc-comercial) THEN DO:
                        CREATE TEXT whlb-desc-comercial
                        ASSIGN FRAME        = wh-frame-fpage6-pd4000
                               WIDTH        = 20
                               FORMAT       = "x(20)"
                               SCREEN-VALUE = "Desconto Acordo Com:"
                               ROW          = 7.4
                               COL          = 26
                               VISIBLE      = YES.
                        
                        CREATE FILL-IN wh-desc-comercial
                        ASSIGN FRAME             = wh-frame-fpage6-pd4000
                               SIDE-LABEL-HANDLE = whlb-desc-comercial:HANDLE
                               LABEL             = "Desconto Acordo Com:"
                               DATA-TYPE         = "DECIMAL":U
                               FORMAT            = ">>9.99":U
                               WIDTH             = 18
                               HEIGHT            = 0.8
                               ROW               = 7.4    
                               COL               = 42
                               VISIBLE           = YES 
                               SENSITIVE         = NO .
                    END.
                    ELSE DO: 
                     ASSIGN whlb-desc-comercial:SCREEN-VALUE = "Desconto Acordo Com:" .
                        ASSIGN wh-desc-comercial:SENSITIVE = NO.

                        FIND FIRST int-ped-item-pci WHERE int-ped-item-pci.nome-abrev   = ped-item.nome-abrev  
                                                      AND int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli   
                                                      AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                                                      AND int-ped-item-pci.it-codigo    = ped-item.it-codigo   
                                                      AND int-ped-item-pci.cod-refer    = ped-item.cod-refer   NO-ERROR.   
                         IF AVAIL int-ped-item-pci THEN DO: 
                            ASSIGN wh-desc-comercial:SCREEN-VALUE      = STRING(int-ped-item-pci.desc-neg-comercial). 
                         END.
                    END.  
                END.
            END.
        END.
    END. 
END. 

