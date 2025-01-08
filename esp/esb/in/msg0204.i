{esp/esb/esesb000.i}
{cdp/cdcfgman.i}
{esp/ccp/esccp032.i22}

DEFINE TEMP-TABLE msg0204 NO-UNDO XML-NODE-NAME 'MSG0204'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoEstabelecimento          LIKE estabelec.cod-estabel     INITIAL ?
    FIELD CodigoPlano                    LIKE pl-prod.cd-plano          INITIAL ?
    FIELD ConsideraOrdensCompra          AS LOGICAL
    FIELD ConsideraOrdensProducao        AS LOGICAL
    FIELD ConsideraOrdensPlanejadas      AS LOGICAL
    FIELD ConsideraReservasComprometidas AS LOGICAL
    FIELD ConsideraReservasPlanejadas    AS LOGICAL
    FIELD ConsideraSaldoEstoque          AS LOGICAL
    FIELD ConsideraSaldoTerceiros        AS LOGICAL
    FIELD ConsideraPedidosCarteira       AS LOGICAL
    FIELD ApenasPedidosCreditoAprovado   AS LOGICAL
    FIELD OrdensCompraBeneficiamento     AS INTEGER
    FIELD ConsideraRemessaBeneficiamento AS LOGICAL
    FIELD ConsideraEntradaBeneficiamento AS LOGICAL
    FIELD ConsideraTransferencia         AS LOGICAL
    FIELD ConsideraRemessaConsignacao    AS LOGICAL
    FIELD ConsideraEntradaConsignacao    AS LOGICAL
    FIELD SomenteOEM                     AS LOGICAL
    FIELD I18N                           AS LOGICAL.

DEFINE TEMP-TABLE ItensSimulacao NO-UNDO XML-NODE-NAME 'ItensSimulacao'
    FIELD CodigoProduto LIKE ITEM.it-codigo
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE msg0204r1 NO-UNDO XML-NODE-NAME 'MSG0204R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ItemEstoque NO-UNDO XML-NODE-NAME 'ItemEstoque'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto                LIKE ITEM.it-codigo
    FIELD NomeProduto                  LIKE ITEM.desc-item
    FIELD MatriculaComprador           LIKE ordem-compra.cod-comprado
    FIELD NomeComprador                LIKE usuar_mestre.nom_usuario
    FIELD QuantidadeEstoqueSeguranca   AS DECIMAL FORMAT "->>>>>,>>9.9999" 
    FIELD QuantidadePoliticaEstoque    AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD SaldoInicial                 AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD SaldoTerceiros               AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD CodigoUnidadeConsumo         LIKE ITEM.un
    FIELD DescricaoUnidadeConsumo      LIKE Tab-unidade.descricao
    FIELD TempoRessuprimentoFornecedor LIKE item-uni-estab.res-for-comp
    FIELD PeriodoFixo                  LIKE item-uni-estab.periodo-fixo
    FIELD DataRessuprimento            AS DATE
    field CodigoFornecedorEMS          LIKE item-fornec-estab.cod-emitente
    field NomeAbreviadoFornecedor      LIKE emitente.nome-abrev
    field SituacaoItemEMS              LIKE ITEM.cod-obsoleto 
    field CodigoUnidadeNegocio         LIKE ITEM.cod-unid-negoc
    field NomeUnidadeNegocio           AS CHARACTER FORMAT "x(100)" 
    field LoteMultiploItemFornecedor   like item-fornec-estab.lote-mul-for
    field LoteMinimoItemFornecedor     like item-fornec-estab.lote-minimo
    FIELD NivelCriticidade             AS INT 
    FIELD ObservacaoLogistica          AS CHAR
    FIELD AcaoAnterior                 AS CHAR
    FIELD NecessitaLicencaImportacao   AS LOG
    FIELD NecessitaInspecaoOrigem      AS LOG
    FIELD MotivoSituacaoItem           AS CHAR
    INDEX idx1 IS PRIMARY CodigoProduto.


DEFINE TEMP-TABLE RegistroEstoque NO-UNDO XML-NODE-NAME 'RegistroEstoque'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto                LIKE ITEM.it-codigo XML-NODE-TYPE 'hidden'
    FIELD TipoRegistro                 AS CHAR
    FIELD NumeroRegistro               AS CHAR /*prazo-compra.numero-ordem Podem ser n£meros de reservas (enviar com m scara)*/ 
    FIELD SequenciaParcela             LIKE prazo-compra.parcela
    FIELD NumeroEmbarque               LIKE embarque-imp.embarque
    FIELD NumeroPedidoCompra           LIKE ordem-compra.num-pedido
    FIELD CodigoFornecedorEMS          LIKE emitente.cod-emitente
    FIELD NomeAbreviadoFornecedor      LIKE Emitente.nome-abrev
    FIELD DataEmbarque                 AS DATE /*historico-embarque.dt-efetiva*/
    FIELD SituacaoEmbarque             AS INT
    FIELD CodigoPontoControle          LIKE pto-contr.cod-pto-contr 
    FIELD DescricaoPontoControle       LIKE pto-contr.descricao 
    FIELD ConhecimentoEmbarque         LIKE embarque-imp.cod-conhecto-master
    FIELD DataPrevista                 AS DATE /*prazo-compra.data-entrega ou data da reserva*/
    FIELD Quantidade                   AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD SaldoDisponivel              AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD LoteMultiploItemFornecedor   AS DECIMAL FORMAT "->>>>>,>>9.9999" 
    FIELD LoteMinimoItemFornecedor     AS DECIMAL FORMAT "->>>>>,>>9.9999" 
    FIELD ParcelaAnalisada             AS LOG
    FIELD SituacaoOrdemCompra          LIKE ordem-compra.situacao
    FIELD SituacaoAceitePedido         AS INT        
/*     field CodigoUnidadeNegocio         LIKE ordem-compra.cod-unid-negoc */
/*     field NomeUnidadeNegocio           AS CHARACTER FORMAT "x(100)"     */
    FIELD DataNecessidade              AS DATE
    INDEX idx1 IS PRIMARY CodigoProduto DataPrevista.


DEF TEMP-TABLE tt-estoq NO-UNDO
    FIELD tipo         AS CHAR    FORMAT "x(08)"
    FIELD referencia   AS CHAR    FORMAT "x(85)"
    FIELD quantidade   AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD dt-inicio    AS DATE    FORMAT "99/99/9999"
    FIELD dt-termino   AS DATE    FORMAT "99/99/9999"
    FIELD saldo        AS DECIMAL FORMAT "->>>>>>,>>9.9999"
    FIELD observ       AS CHAR    FORMAT "x(18)" 
    FIELD item-pai     AS CHAR 
    FIELD unid-negoc   AS CHAR    FORMAT "x(3)"
    INDEX codigo IS PRIMARY dt-termino tipo.

DEF TEMP-TABLE tt-depositos
    FIELD cod-estabel LIKE estabelec.cod-estabel 
    FIELD cod-depos   LIKE deposito.cod-depos.

{esp/imp/esimp000.i1} /*tt-emb*/

{include/i-epc000.i}
{include/i-epc200.i1}
{utp/ut-glob.i}
{esp/es0018.i}
{esp/ccp/esccp032.i25}

DEFINE VARIABLE c-liter            AS CHARACTER FORMAT "x(18)" EXTENT 15    NO-UNDO.
DEFINE VARIABLE c-clientes-oem     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE de-saldo-item      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo-aloc      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo           AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-inic-teor AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-quantidade      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-terc-teor AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-fat       AS DECIMAL   FORMAT "->>>>,>>>,>>9.9999" NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo-inic      AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-quant-segur     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-saldo-terc      AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-min          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-dlt          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-ped-saldo       AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-seg          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-vezes           AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE da-termino         AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-inicio          AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-dat             AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-dat-in          AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-termino-f       AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-op-corte        AS DATE                                  NO-UNDO INITIAL ?.
DEFINE VARIABLE da-dt-corte        AS DATE                                  NO-UNDO.
DEFINE VARIABLE da-dt-plan         AS DATE                                  NO-UNDO.
DEFINE VARIABLE da-data-aux        AS DATE                                  NO-UNDO.
DEFINE VARIABLE l-apenas-oem       AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-ord-comp         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-res-comp         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-pedidos          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE i-tam-per          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-nr-dias          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-ressup           AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-ind              AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-dias-dlt         AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-res-var          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE c-cod-refer        LIKE ITEM.cod-refer                      NO-UNDO. 
DEFINE VARIABLE gr-item            AS ROWID                                 NO-UNDO.
DEFINE VARIABLE i-cod-fornec       AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-perc-compra      AS INTEGER                               NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc   AS CHARACTER                             NO-UNDO.
 
DEFINE BUFFER b-ped-item           FOR ped-item.
DEFINE BUFFER b-tt-estoq           FOR tt-estoq.
DEFINE BUFFER b-periodo            FOR periodo.
DEFINE BUFFER b-ped-ent            FOR ped-ent.
DEFINE BUFFER b-item               FOR ITEM.
DEFINE BUFFER b1-item              FOR ITEM.
DEFINE BUFFER b3-item              FOR ITEM.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.
DEFINE BUFFER b-item-fornec-estab  FOR item-fornec-estab.
DEFINE BUFFER b-emitente           FOR emitente.

{utp/ut-liter.i O_P * r}
ASSIGN c-liter[1] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_C* * r}
ASSIGN c-liter[2] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_C * r}
ASSIGN c-liter[3] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O.S. * r}
ASSIGN c-liter[4] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Res * r}
ASSIGN c-liter[5] = TRIM (RETURN-VALUE).
{utp/ut-liter.i P_V * r}
ASSIGN c-liter[6] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_Pl * r}
ASSIGN c-liter[7] = TRIM (RETURN-VALUE).
{utp/ut-liter.i R_Pl * r}
ASSIGN c-liter[8] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Negativo * r}
ASSIGN c-liter[9] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Abaixo_Qt_Segur * r}
ASSIGN c-liter[10] = TRIM (RETURN-VALUE).
