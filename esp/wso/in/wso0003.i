/*---------------------------------------------------------------------------*/
/* WSO003.i - Recebe um xml com o pedido + cliente                           */
/*---------------------------------------------------------------------------*/
define {1} temp-table MsgErro no-undo
    field SeqErro as integer
    field DescErro as character
        index idErro is primary unique SeqErro.


/*-------------------------------------------------------------------*/ 
/*     LAYOUT RESPOSTA AO WEB SERVICE QUE SE COMUNICA COM A VTEX     */
/*-------------------------------------------------------------------*/
DEF TEMP-TABLE ttResultado NO-UNDO XML-NODE-NAME "Resultado" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD sucesso AS LOG.

DEF TEMP-TABLE ttErro NO-UNDO XML-NODE-NAME "Erro"
   FIELD idm            AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD SeqErro        AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD codigoErro     AS INTEGER
   FIELD detalhe        AS CHAR
   FIELD mensagem       AS CHAR.

DEFINE DATASET mensagemr XML-NODE-TYPE 'hidden' FOR ttResultado, ttErro
    DATA-RELATION FOR ttResultado, ttErro RELATION-FIELDS (idm, idm) NESTED.


/*---------------------------------------------*/ 
/*     LAYOUT PROVENIENTE DO XML DE PEDIDO     */
/*---------------------------------------------*/ 
DEFINE TEMP-TABLE ttPedido XML-NODE-NAME "Pedido" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'                                                           
   FIELD numeroPedido         AS CHAR
   FIELD sequenciaPedido      AS CHAR
   FIELD codigoLoja           AS CHAR
   FIELD marketplace          AS CHAR
   FIELD statusPedido         AS CHAR
   FIELD dataCriacao          AS DATE
   FIELD totalFrete           AS DEC
   FIELD totalTaxas           AS DEC
   FIELD totalItens           AS DEC
   FIELD totalPedido          AS DEC
   FIELD totalDesconto        AS DEC
   FIELD condicaoPagamento    AS CHAR
   FIELD valorPagamento       AS DEC
   FIELD parcelas             AS INT
   FIELD dataPagamento        AS DATE
   FIELD moedaCorrente        AS CHAR
   FIELD descontoMarketplace  AS DEC.

DEFINE TEMP-TABLE ttCondicaoPagamento XML-NODE-NAME "CondicaoPagamento" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD formaPagamento     AS CHAR
   FIELD dataCaptura        AS DATE
   FIELD quantidadeParcelas AS INT
   FIELD valorTotal         AS DEC
   FIELD finalCartao        AS IN
   FIELD idAutorizacao      AS CHAR
   FIELD nsu                AS CHAR
   FIELD numeroReferencia AS CHAR
   FIELD tid AS CHAR.

DEFINE TEMP-TABLE ttComissao XML-NODE-NAME "Comissao" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD tipo              AS CHAR
   FIELD numeroDocumento   AS CHAR
   FIELD valor             AS INT.


DEFINE TEMP-TABLE ttItem XML-NODE-NAME "Item" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD codigoItem           AS CHAR
   FIELD quantidade           AS DEC
   FIELD precoItem            AS DEC
   FIELD valorDesconto        AS DEC
   FIELD precoFinal           AS DEC
   FIELD estabelecimento      AS CHAR
   FIELD codigoTransportadora AS CHAR.
                                                            



/*----------------------------------------------------------*/ 
/*                  LAYOUT XML PESSOA FÖSCA                 */
/*----------------------------------------------------------*/ 
DEFINE TEMP-TABLE ttPessoaFisica XML-NODE-NAME "PessoaFisica" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD dataNascimento        AS DATE
   FIELD genero                AS CHAR
   FIELD nome                  AS CHAR
   FIELD nomeMae               AS CHAR
   FIELD paisNascimento        AS CHAR
   FIELD funcaoPessoaFisica    AS CHAR
   FIELD estadoCivil           AS CHAR 
   FIELD municioNascimento     AS CHAR
   FIELD siglaEstadoNascimento AS CHAR.
   
/*----------------------------------------------------------*/ 
/*                  LAYOUT XML PESSOA JURIDICA              */
/*----------------------------------------------------------*/ 
DEFINE TEMP-TABLE ttPessoaJuridica XML-NODE-NAME "PessoaJuridica" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD dataAbertura          AS DATE
   FIELD nomeFantasia          AS CHAR
   FIELD razaoSocial           AS CHAR
   FIELD funcaoPessoaJuridica  AS CHAR
   FIELD grupoCliente          AS CHAR.   

DEF TEMP-TABLE ttTelefone XML-NODE-NAME "Telefone"
    FIELD idm           AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ddd           AS CHAR
    FIELD telefone      AS CHAR
    FIELD tipo          AS CHAR.

DEF TEMP-TABLE ttEmail XML-NODE-NAME "Email"
    FIELD idm       AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD endereco  AS CHAR
    FIELD tipo      AS CHAR.

DEF TEMP-TABLE ttEndereco XML-NODE-NAME "Endereco"
    FIELD idm            AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD identificador  AS CHAR
    FIELD bairro         AS CHAR
    FIELD cep            AS CHAR
    FIELD complemento    AS CHAR
    FIELD logradouro     AS CHAR
    FIELD municipio      AS CHAR
    FIELD numero         AS CHAR
    FIELD siglaEstado    AS CHAR
    FIELD siglaPais      AS CHAR
    FIELD tipo           AS CHAR.

DEF TEMP-TABLE ttDocumento XML-NODE-NAME "Documento"
    FIELD idm      AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD tipoDocumento   AS CHAR
    FIELD numeroDocumento AS CHAR.

DEF TEMP-TABLE ttPedidoPJ            XML-NODE-NAME "Pedido"            LIKE ttPedido.
DEF TEMP-TABLE ttPessoaJuridicaPJ    XML-NODE-NAME "PessoaJuridica"    LIKE ttPessoaJuridica.
DEF TEMP-TABLE ttCondicaoPagamentoPJ XML-NODE-NAME "CondicaoPagamento" LIKE ttCondicaoPagamento.
DEF TEMP-TABLE ttComissaoPJ          XML-NODE-NAME "Comissao"          LIKE ttComissao.
DEF TEMP-TABLE ttItemPJ              XML-NODE-NAME "Item"              LIKE ttItem.
DEF TEMP-TABLE ttTelefonePJ          XML-NODE-NAME "Telefone"          LIKE ttTelefone.
DEF TEMP-TABLE ttEmailPJ             XML-NODE-NAME "Email"             LIKE ttEmail.
DEF TEMP-TABLE ttEnderecoPJ          XML-NODE-NAME "Endereco"          LIKE ttEndereco.
DEF TEMP-TABLE ttDocumentoPJ         XML-NODE-NAME "Documento"         LIKE ttDocumento.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttPedido, ttCondicaoPagamento, ttComissao, ttItem, ttTelefone, ttEmail, ttEndereco, ttDocumento, ttPessoaFisica, ttPessoaJuridica
    DATA-RELATION FOR ttPedido, ttItem              RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedido, ttCondicaoPagamento RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedido, ttComissao          RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedido, ttPessoaFisica      RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttTelefone    RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttEmail       RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttDocumento   RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttEndereco    RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemPJ XML-NODE-TYPE 'hidden' FOR ttPedidoPJ, ttCondicaoPagamentoPJ, ttComissaoPJ, ttItemPJ, ttTelefonePJ, ttEmailPJ, ttEnderecoPJ, ttDocumentoPJ, ttPessoaJuridicaPJ
    DATA-RELATION FOR ttPedidoPJ, ttItemPJ              RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedidoPJ, ttCondicaoPagamentoPJ RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedidoPJ, ttComissaoPJ          RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedidoPJ, ttPessoaJuridicaPJ    RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttTelefonePJ  RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttEmailPJ     RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttDocumentoPJ RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttEnderecoPJ  RELATION-FIELDS (idm, idm) NESTED.

/* -------------------------------------------------------------------------*/
/*         TEMP-TABLES PARA CRIA€ÇO DO CLIENTE PESSOAL FÖSICA NO TOTVS      */
/* -------------------------------------------------------------------------*/
DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

define temp-table tt-emitente no-UNDO like emitente
   field cod-maq-origem as int format "9999"
   field num-processo   as int format ">>>>>>>>9" init 0
   field num-sequencia  as int format ">>>>>9"    init 0
   field ind-tipo-movto as int format "99"        init 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-dist-emitente no-UNDO like dist-emitente
   field cod-maq-origem   as   integer format "9999"
   field num-processo     as   integer format ">>>>>>>>9" initial 0
   field num-sequencia    as   integer format ">>>>>9"    initial 0
   field ind-tipo-movto   as   integer format "99"        initial 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-loc-entr  NO-UNDO  like loc-entr
    field cod-maq-origem        as integer 
    field num-processo          as integer format "999999999"
    field num-sequencia         as integer format "999999"
    field ind-tipo-movto        as integer format "99".

define temp-table tt-loc-entr-aux no-UNDO like tt-loc-entr
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
define temp-table tt-int-loc-entr no-UNDO like int-loc-entr.
define temp-table tt-versao-integr no-UNDO
   field cod-versao-integracao as integer format "999"
   field ind-origem-msg        as integer format "99" /* i01mp900.i */.

define temp-table tt-erros-geral no-UNDO
   field identIF-msg           as char    format "x(60)"
   field num-sequencia-erro    as integer format "999"
   field cod-erro              as integer format "99999"   
   field des-erro              as char    format "x(60)"
   field cod-maq-origem        as integer format "999"
   field num-processo          as integer format "999999999".

/* ------------------------------------------------------------------ */
/*          TEMP-TABLES PARA CRIA€ÇO DO PEDIDO NO TOTVS               */
/* -------------------------------------------------------------------*/
/** temp-tables para BO's **/
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

define temp-table tt-ped-venda no-undo like ped-venda
   field r-rowid  as rowid.
define temp-table tt-ped-item no-undo like ped-item
   field r-rowid  as rowid.
define temp-table tt-ped-ent no-undo like ped-ent
   field r-rowid  as rowid.
define temp-table tt-ped-repre no-undo like ped-repre
   field r-rowid  as rowid.
define temp-table tt-ped-antecip no-undo like ped-antecip
   field r-rowid  as rowid.
define temp-table tt-cond-ped no-undo like cond-ped
   field r-rowid  as rowid.

define temp-table tt-ped-vendor no-undo
   field data-base    as date
   field dias-base    as integer format ">>>9"
   field cod-cond-pag as integer format ">9"
   field taxa-cliente as decimal format ">>9.9999".

define temp-table ttEstabPedido no-undo
    field cod-estabel like estabelec.cod-estabel.

define temp-table tt-ped-valid no-undo
    field PedidoCodigo as character
    FIELD contaCodigo  AS CHARACTER.

/** Temp-table maldita pra achar corretamente o pre‡o de um item na tabela **/
define temp-table tt-preco-item no-undo
   field nr-tabpre   like preco-item.nr-tabpre
   field it-codigo   like preco-item.it-codigo
   field cod-refer   like preco-item.cod-refer
   field dt-inival   like preco-item.dt-inival
   field quant-min   like preco-item.quant-min
   field preco-venda like preco-item.preco-venda
   field situacao    like preco-item.situacao
   field desco-quant like preco-item.desco-quant
   index ch-data     is primary dt-inival it-codigo nr-tabpre cod-refer quant-min
   index ch-itemtab  it-codigo cod-refer nr-tabpre dt-inival quant-min.

/** Temp-table do Pagador **/
define temp-table ttDadosPedido no-undo
   field CodigoAutorizacao as character
   field CodigoErro        as character
   field CodigoPagamento   as character
   field FormaPagamento    as character
   field MensagemErro      as character
   field NumeroParcelas    as character
   /*field Status            as character*/
   field Valor             as character
   field DataCancelamento  as character
   field DataPagamento     as character
   field DataPedido        as character
   field TransId           as character
   field BraspagTid        as character.


DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-ponto-aux LIKE tt-prog-ponto.
