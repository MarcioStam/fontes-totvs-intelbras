{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0226 NO-UNDO XML-NODE-NAME 'MSG0226'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroEmbarque        LIKE embarque-imp.embarque     INITIAL ?
    FIELD MatriculaComprador    LIKE ordem-compra.cod-comprado INITIAL ?
    FIELD NumeroPedidoCompra    LIKE ordem-compra.num-pedido   INITIAL ?
    FIELD CodigoProdutoInicial  LIKE ordem-compra.it-codigo    INITIAL ?
    FIELD CodigoProdutoFinal    LIKE ordem-compra.it-codigo    INITIAL ?
    FIELD DataInicialChegada    AS DATE                        INITIAL ?
    FIELD DataFinalChegada      AS DATE                        INITIAL ?
    FIELD SituacaoEmbarque      LIKE embarque-imp.situacao     INITIAL ?
    FIELD StatusEmbarque        AS INTEGER                     INITIAL ?
    FIELD NivelCriticidade      AS INTEGER                     INITIAL ?
    FIELD CodigoViaTransporte   AS INTEGER                     INITIAL ?
    FIELD EmbarquesDisponiveis  AS LOG                         INITIAL ?
    FIELD CodigoIncoterm        AS CHAR                        INITIAL ?
    FIELD CodigoItinerario      AS INT                         INITIAL ?
    FIELD CodigoEstabelecimento LIKE embarque-imp.cod-estabel  INITIAL ?
    FIELD CodigoFornecedorEMS   LIKE ordem-compra.cod-emitente INITIAL ?
    FIELD MatriculaUsuario      LIKE usuar_mestre.cod_usuar
    FIELD DISiscomex            LIKE embarque-imp.declaracao-import INITIAL ?
    FIELD CodigoDespachante     LIKE embarque-imp.cod-despachante   INITIAL ?
    FIELD SomenteComCoberturaCambial AS LOG.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0226R1 NO-UNDO XML-NODE-NAME 'MSG0226R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ExibePrecos AS LOG.

DEFINE TEMP-TABLE Embarque_R1 NO-UNDO XML-NODE-NAME 'EmbarqueResumo'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoEstabelecimento          LIKE embarque-imp.cod-estabel
    FIELD NumeroEmbarque                 LIKE embarque-imp.embarque
    FIELD SituacaoEmbarque               LIKE embarque-imp.situacao
    FIELD StatusEmbarque                 AS INTEGER
    FIELD DescricaoUltimoPontoControle   LIKE pto-contr.descricao
    FIELD DataEfetivaUltimoPontoControle AS DATE
    FIELD CodigoItinerario               LIKE cotacao-item.int-1
    FIELD DescricaoItinerario            LIKE itinerario.descricao
    FIELD ValorEmbarque                  AS DEC 
    FIELD CodigoMoedaEMS                 LIKE moeda.mo-codigo
    FIELD NomeMoeda                      LIKE moeda.descricao
    FIELD Atrasado                       AS LOG
    FIELD CodigoCondicaoPagamento        LIKE cond-pagto.cod-cond-pag
    FIELD NomeCondicaoPagamento          LIKE cond-pagto.descricao
    FIELD NivelCriticidade               AS INT
    FIELD CodigoFornecedorEMS            LIKE ordem-compra.cod-emitente
    FIELD NomeAbreviadoFornecedor        LIKE emitente.nome-abrev
    FIELD CodigoViaTransporte            AS INT
    FIELD CodigoIncoterm                 AS CHAR /*SUBSTRING(cotacao-item.char-1,21,20)*/
    FIELD DescricaoIncoterm              LIKE incoterm.descricao
    FIELD DataPrevisaoChegada            AS DATE
    FIELD DataPrevisaoEmbarque           AS DATE
    FIELD NomeDestino                    LIKE int-processo-imp.NomeDestino
    FIELD VeiculoTransporte              LIKE embarque-imp.id-meio-transp
    FIELD TipoContainer                  LIKE ext-embarque-imp.conteiner
    FIELD Quantidade1Container           LIKE ext-embarque-imp.qtd-conteiner
    FIELD Quantidade2Container           LIKE ext-embarque-imp.qtd2-conteiner
    FIELD Master                         LIKE embarque-imp.cod-conhecto-master
    FIELD House                          LIKE embarque-imp.cod-conhecto-house
    FIELD MatriculaResponsavel           LIKE pedido-compr.responsavel
    FIELD NomeResponsavel                LIKE usuar_mestre.nom_usuario
    FIELD DISiscomex                     LIKE embarque-imp.declaracao-import INITIAL ?
    FIELD CodigoDespachante              LIKE emitente.cod-emitente
    FIELD NomeDespachante                LIKE emitente.nome-abrev
    FIELD PossuiCIPagamento              AS LOG
    FIELD Recebida                       AS LOG
    FIELD DocsOriginais                  AS LOG  INIT ?
    FIELD CodigoPrimPontoNaoEfet                              AS INTEGER XML-NODE-NAME 'CodPrimPtContNaoEfetivado'
    FIELD DescricaoPrimePontoNaoEfet                          AS CHAR    XML-NODE-NAME 'DescPrimPtContNaoEfetivado'
    FIELD DtUltPrevPrimPontoNaoEfeto                          AS DATE    XML-NODE-NAME 'DtUltimaPrevPrimPtContNaoEfetivado'
    FIELD VeicTranspPrimPontoNaoEfet                          AS CHAR    XML-NODE-NAME 'VeiculoTranspPrimPtContNaoEfetivado'
    FIELD SequenciaPontoControle                              AS INTEGER 
    FIELD DataPrevOriginalPontoControle                       AS DATE
    FIELD ObservacoesPontoControle                            AS CHAR    
    FIELD DataEfetivaEmbarque            AS DATE.


/*Outras temp tables*/

{esp/imp/esimp000.i1} /*tt-emb*/

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)". 

DEFINE TEMP-TABLE tt-embarques-lidos NO-UNDO  
    FIELD embarque LIKE ordens-embarque.embarque
    INDEX ch-pri IS PRIMARY UNIQUE embarque.
