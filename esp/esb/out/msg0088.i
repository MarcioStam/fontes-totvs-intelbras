{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0088 NO-UNDO XML-NODE-NAME 'MSG0088'
    FIELD idm                     AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto           as character   
    FIELD Nome                    as character   
    FIELD Descricao               as character   
    FIELD DescricaoInternacional  AS CHARACTER
    FIELD PesoEstoque             as decimal    
    FIELD Situacao                as integer  
    FIELD TipoProduto             as integer  
    FIELD NaturezaProduto         as integer  
    FIELD GrupoEstoque            as integer  
    FIELD UnidadeNegocio          as character  
    FIELD NomeUnidadeNegocio      as character  
    FIELD Segmento                as character   
    FIELD NomeSegmento            as character   
    FIELD Familia                 as character   
    FIELD SubFamilia              as character   
    FIELD Origem                  as integer   
    FIELD UnidadeMedida           as character   
    FIELD GrupoUnidadeMedida      as character   
    FIELD FamiliaMaterial         as character  
    FIELD FamiliaComercial        as character   
    FIELD ListaPreco              as character   
    FIELD Moeda                   as character   
    FIELD QuantidadeDecimal       as INT
    FIELD CustoAtual              as decimal    
    FIELD PrecoLista              as decimal    
    FIELD Fabricante              as character   
    FIELD NumeroPecaFabricante    as character   
    FIELD VolumeEstoque           as decimal    
    FIELD ComplementoProduto      as character   
    FIELD URL                     as character   
    FIELD QuantidadeDisponivel    as decimal    
    FIELD ExigeTreinamento        as logical  
    FIELD Fornecedor              as character   
    FIELD CustoPadrao             as decimal    
    FIELD RebateAtivado           as logical
    FIELD ConsiderarOrcamentoMeta AS LOG INITIAL YES
    FIELD FaturamentoOutroProduto AS LOG INITIAL NO
    FIELD QuantidadeMultipla      AS DEC INITIAL 1
    FIELD DataAlteracaoPrecoVenda AS DATE
    FIELD ShowRoom                AS LOGICAL
    FIELD AliquotaIPI             AS DEC
    FIELD NCM                     AS CHAR
    FIELD EAN                     AS CHAR
    FIELD BloquearComercializacao AS LOGICAL
    FIELD PossuiSubstituto        AS LOGICAL
    FIELD CodigoProdutoSubstituto AS CHARACTER
    FIELD EKit                    AS LOGICAL
    FIELD ComercializadoForaKit   AS LOGICAL
    /*FIELD PoliticaPosVendas       AS INTEGER
    FIELD TempoGarantia           AS INTEGER  */
    FIELD PassivelSolicitacaoBeneficio AS LOGICAL 
    FIELD TemMensagem             AS LOGICAL
    FIELD DescricaoMensagem       AS CHARACTER
    FIELD DepositoPadrao          LIKE ITEM.deposito-pad
    FIELD CodigoTipoDespesa       LIKE ITEM.tp-desp-padrao
    FIELD DestaqueNCM             LIKE int-item.destaque
    FIELD NVE                     LIKE int-item.nve
    FIELD CodigoUnidadeFamilia    AS CHAR
    FIELD TipoItem                AS CHAR.
                                           
DEFINE TEMP-TABLE ProdutosFilhos NO-UNDO XML-NODE-NAME 'ProdutosFilhos'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutoFilho NO-UNDO XML-NODE-NAME 'ProdutoFilho'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto          as character   
    FIELD QuantidadeProdutoFilho as INTEGER.   
    
DEFINE TEMP-TABLE msg0088r NO-UNDO XML-NODE-NAME 'MSG0088R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.







































