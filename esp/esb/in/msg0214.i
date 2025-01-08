{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0214 NO-UNDO XML-NODE-NAME 'MSG0214'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento       LIKE int-criticidade-item.cod-estabel
   FIELD CodigoPlano                 LIKE int-criticidade-item.cd-plano
   FIELD CodigoProdutoInicial        LIKE int-criticidade-item.it-codigo
   FIELD CodigoProdutoFinal          LIKE int-criticidade-item.it-codigo
   FIELD CodigoFornecedorEMS         LIKE emitente.cod-emitente
   FIELD MatriculaComprador          LIKE usuar_mestre.cod_usuar
   FIELD I18N                        AS LOGICAL
   FIELD DataCalculoCriticidade      LIKE int-criticidade-item.data-calculo
   .

DEFINE TEMP-TABLE FiltroUnidadeNegocio NO-UNDO XML-NODE-NAME 'FiltroUnidadeNegocio'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoUnidadeNegocio LIKE ITEM.cod-unid-negoc
    .

DEFINE TEMP-TABLE FiltroCriticidade NO-UNDO XML-NODE-NAME 'FiltroCriticidade'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD NivelCriticidade LIKE int-criticidade-item.nivel-criticidade
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0214R1 NO-UNDO XML-NODE-NAME 'MSG0214R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE MSG_ListaFalta_R1 NO-UNDO XML-NODE-NAME 'ListaFalta'
   FIELD idm                         AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD idm-falta                   AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento       LIKE int-criticidade-item.cod-estabel
   FIELD CodigoPlano                 LIKE int-criticidade-item.cd-plano   
   FIELD DataCalculoCriticidade      LIKE int-criticidade-item.data-calculo
   FIELD SequenciaCalculoCriticidade LIKE int-criticidade-item.sequencia
   FIELD MatriculaComprador          LIKE usuar_mestre.cod_usuar
   FIELD NomeComprador               LIKE usuar_mestre.nom_usuario
   FIELD CodigoUnidadeNegocio        LIKE ITEM.cod-unid-negoc
   FIELD NomeUnidadeNegocio          LIKE unid-negoc.des-unid-negoc
   FIELD CodigoFornecedorEMS         LIKE emitente.cod-emitente
   FIELD NomeAbreviadoFornecedor     LIKE emitente.nome-abrev
   FIELD CodigoProduto               LIKE int-criticidade-item.it-codigo  
   FIELD NomeProduto                 LIKE ITEM.desc-item
   FIELD DataPrevisaoChegada         AS DATE
   FIELD QuantidadeChegada           AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
   FIELD NumeroEmbarque              LIKE embarque-imp.embarque
   FIELD CodigoPontoControle         LIKE historico-embarque.cod-pto-contr
   FIELD DescricaoPontoControle      LIKE pto-contr.descricao
   FIELD DataPontoControle           AS DATE
   FIELD NivelCriticidade            LIKE int-criticidade-item.nivel-criticidade
   FIELD CodigoTipoDespesa           AS INTEGER FORMAT ">>9"
   FIELD DescricaoTipoDespesa        LIKE tipo-rec-desp.descricao
   FIELD AcaoAnterior                LIKE int-acao-criticidade-item.comentario-acao
   FIELD DataPrimeiraFalta           LIKE int-falta-criticidade-item.data-falta
   FIELD QuantidadeFinalFalta        LIKE int-falta-criticidade-item.quantidade-falta
   FIELD SituacaoItemEMS             LIKE item-uni-estab.cod-obsoleto
   FIELD NumeroPedidoCompra          LIKE pedido-compr.num-pedido.

DEFINE TEMP-TABLE MSG_Faltas_R1 NO-UNDO XML-NODE-NAME 'Faltas'
   FIELD idm-falta                   AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD DataFalta                   LIKE int-falta-criticidade-item.data-falta
   FIELD QuantidadeFalta             LIKE int-falta-criticidade-item.quantidade-falta
   .


/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".



DEFINE BUFFER b-int-falta-criticidade-item FOR int-falta-criticidade-item.

DEFINE VARIABLE c-comprador         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-produto-inicial   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-produto-final     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ident-falta       AS INTEGER     NO-UNDO.
DEFINE VARIABLE r-prox-prazo-compra AS ROWID       NO-UNDO.
DEFINE VARIABLE r-embarque-historico-embarque AS ROWID       NO-UNDO.
DEFINE VARIABLE l-tem-entrega-prevista AS LOGICAL     NO-UNDO.
