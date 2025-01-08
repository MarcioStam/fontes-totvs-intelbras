{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0232 NO-UNDO XML-NODE-NAME 'MSG0232'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaComprador        LIKE ordem-compra.cod-comprado INITIAL ?
   FIELD CodigoFornecedorEMS       LIKE ordem-compra.cod-emitente INITIAL ?
   FIELD SomenteAnalisadas         AS LOG                         INITIAL NO
   FIELD CodigoProdutoInicial      LIKE ordem-compra.it-codigo    INITIAL ""
   FIELD CodigoProdutoFinal        LIKE ordem-compra.it-codigo    INITIAL "ZZZZZZZZZZZZZZZZ"
   FIELD FiltroDemandaDependente   AS LOG                         INITIAL NO
   FIELD FiltroDemandaIndependente AS LOG                         INITIAL NO
   FIELD ExibirCotadas             AS LOG                         INITIAL NO
   FIELD ExibirEmCotacao           AS LOG                         INITIAL NO
   FIELD ExibirNaoConfirmadas      AS LOG                         INITIAL NO
   FIELD MatriculaUsuario          LIKE usuar_mestre.cod_usuar
   FIELD I18N                      AS LOG.

DEFINE TEMP-TABLE FiltroEstabelecimento NO-UNDO XML-NODE-NAME 'FiltroEstabelecimento'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento LIKE ordem-compra.cod-estabel.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0232_R1 NO-UNDO XML-NODE-NAME 'MSG0232R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ExibePrecos AS LOG.

DEFINE TEMP-TABLE MSG_OrdemCompra_R1 NO-UNDO XML-NODE-NAME 'OrdemCompraSemPedido'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto                LIKE ordem-compra.it-codigo
   FIELD NomeProduto                  LIKE ITEM.desc-item
   FIELD CodigoEstabelecimento        LIKE ordem-compra.cod-estabel
   FIELD NomeEstabelecimento          LIKE estabelec.nome
   FIELD MatriculaComprador           LIKE ordem-compra.cod-comprado
   FIELD NomeComprador                LIKE usuar_mestre.nom_usuario
   FIELD CodigoFornecedorEMS          LIKE ordem-compra.cod-emitente
   FIELD NomeAbreviadoFornecedor      LIKE emitente.nome-abrev
   FIELD NumeroOrdemCompra            LIKE ordem-compra.numero-ordem
   FIELD ValorUnitarioItem            LIKE ordem-compra.pre-unit-for
   FIELD SituacaoOrdemCompra          LIKE ordem-compra.situacao
   FIELD LoteMultiploItemFornecedor   LIKE item-fornec-estab.lote-mul-for
   FIELD LoteMinimoItemFornecedor     LIKE item-fornec-estab.lote-minimo
   FIELD UnidadeFornecedor            AS CHAR
   FIELD OrigemFornecedor             AS CHAR
   FIELD TempoRessuprimentoFornecedor LIKE item-uni-estab.res-for-comp.


DEFINE TEMP-TABLE MSG_ParcelaOrdemCompra_R1 NO-UNDO XML-NODE-NAME 'ParcelaSemPedido'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra LIKE prazo-compra.numero-ordem XML-NODE-TYPE 'HIDDEN'
   FIELD SequenciaParcela  LIKE prazo-compra.parcela
   FIELD DataParcela       AS DATE
   FIELD QuantidadeParcela LIKE prazo-compra.quantidade
   FIELD Analisada         AS LOG
   FIELD DataNecessidade   AS DATE
   FIELD RequerAvaliacao   AS LOG.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
