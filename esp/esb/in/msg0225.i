{esp/esb/esesb000.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0225 NO-UNDO XML-NODE-NAME 'MSG0225'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoTabela            LIKE tb-pr-cc.nr-tab        INITIAL ?
   FIELD SituacaoTabela          LIKE tb-pr-cc.situacao      INITIAL ?
   FIELD CodigoFornecedorEMS     LIKE tb-pr-cc.cod-emitente  INITIAL ?
   FIELD CodigoCondicaoPagamento LIKE tb-pr-cc.cod-cond-pag  INITIAL ?
   FIELD CodigoProduto           LIKE item-tab.it-codigo     INITIAL ?
   FIELD MatriculaUsuario        LIKE usuar-mater.cod-usuario
   FIELD DataVigencia            LIKE tb-pr-cc.dt-inicio     INITIAL ?
   FIELD CodigoMoedaEMS          LIKE tb-pr-cc.mo-codigo     INITIAL ?
   FIELD CodigoEstabelecimento   LIKE tb-pr-cc.cod-estabel   INITIAL ?
   FIELD I18N                    AS LOGICAL
   .

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0225R1 NO-UNDO XML-NODE-NAME 'MSG0225R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ExibePrecos        AS LOG
   .

DEFINE TEMP-TABLE TabelaPreco NO-UNDO XML-NODE-NAME 'TabelaPreco'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD relac AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoTabela                LIKE tb-pr-cc.nr-tab      
   FIELD DescricaoTabela             LIKE tb-pr-cc.nome-abrev  
   FIELD DataInicio                  LIKE tb-pr-cc.dt-inicio   
   FIELD DataTermino                 LIKE tb-pr-cc.dt-termino  
   FIELD SituacaoTabela              LIKE tb-pr-cc.situacao    
   FIELD CodigoFornecedorEMS         LIKE tb-pr-cc.cod-emitente
   FIELD CodigoCondicaoPagamento     LIKE tb-pr-cc.cod-cond-pag
   FIELD CodigoMoedaEMS              LIKE tb-pr-cc.mo-codigo   
   FIELD IPIIncluso                  LIKE tb-pr-cc.codigo-IPI  
   FIELD ValorFrete                  LIKE tb-pr-cc.valor-frete 
   FIELD FreteIncluso                LIKE tb-pr-cc.frete       
   FIELD EncargosFinanceirosInclusos LIKE tb-pr-cc.taxa-financ
   FIELD DiasLiberaFFT               LIKE int-tb-pr-cc.num-dias-libera-fft
   INDEX tab-preco  IS PRIMARY UNIQUE CodigoFornecedorEMS CodigoCondicaoPagamento CodigoTabela DataInicio.
   
DEFINE TEMP-TABLE ItemTabela NO-UNDO XML-NODE-NAME 'ItemTabela'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD relac AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto       LIKE item-tab.it-codigo
   FIELD NomeProduto         LIKE ITEM.desc-item
   FIELD CodigoUnidadeMedida LIKE ITEM.un
   FIELD PrecoItem           LIKE item-tab.pr-item      
   FIELD GrupoCorrecoes      LIKE item-tab.int-1        
   FIELD QuantidadeMinima    LIKE item-tab.quant-min    
   FIELD AliquotaIPI         LIKE item-tab.aliquota-IPI 
   FIELD DescontoQuantidade  LIKE item-tab.desco-quant  
   FIELD AliquotaICMS        LIKE item-tab.aliquota-icm 
   FIELD TotalDesconto       AS DEC.


/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE i-relac AS INTEGER.
