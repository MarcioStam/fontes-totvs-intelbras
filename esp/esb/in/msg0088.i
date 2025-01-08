{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0088 NO-UNDO XML-NODE-NAME 'MSG0088'
    FIELD idm                           AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto                 as character   
    FIELD Nome                          as character   
    FIELD Descricao                     as character   
    FIELD DescricaoInternacional        as character   
    FIELD PesoEstoque                   as decimal    
    FIELD Situacao                      as integer  
    FIELD TipoProduto                   as integer  
    FIELD NaturezaProduto               as integer  
    FIELD GrupoEstoque                  as integer  
    FIELD UnidadeNegocio                as character  
    FIELD Segmento                      as character   
    FIELD Familia                       as character   
    FIELD SubFamilia                    as character   
    FIELD Origem                        as integer   
    FIELD UnidadeMedida                 as character   
    FIELD GrupoUnidadeMedida            as character   
    FIELD FamiliaMaterial               as character  
    FIELD FamiliaComercial              as character   
    FIELD ListaPreco                    as character   
    FIELD Moeda                         as character   
    FIELD QuantidadeDecimal             as INT
    FIELD CustoAtual                    as decimal    
    FIELD PrecoLista                    as decimal    
    FIELD Fabricante                    as character   
    FIELD NumeroPecaFabricante          as character   
    FIELD VolumeEstoque                 as decimal    
    FIELD ComplementoProduto            as character   
    FIELD URL                           as character   
    FIELD QuantidadeDisponivel          as decimal    
    FIELD ExigeTreinamento              as logical  
    FIELD Fornecedor                    as character   
    FIELD CustoPadrao                   as decimal    
    FIELD RebateAtivado                 as logical
    FIELD ConsiderarOrcamentoMeta       AS LOG INITIAL YES
    FIELD FaturamentoOutroProduto       AS LOG INITIAL NO
    FIELD QuantidadeMultipla            AS DEC INITIAL 1
    FIELD DataAlteracaoPrecoVenda       AS DATE
    FIELD ShowRoom                      AS LOGICAL
    FIELD AliquotaIPI                   AS DEC
    FIELD NCM                           AS CHAR
    FIELD EAN                           AS CHAR
    /*
    FIELD BloquearComercializacao       AS CHAR 
    FIELD PossuiSubstituto              AS CHAR 
    FIELD CodigoProdutoSubstituto       AS CHAR 
    FIELD EKit                          AS CHAR 
    FIELD ComercializadoForaKit         AS CHAR 
    FIELD PoliticaPosVendas             AS CHAR 
    FIELD TempoGarantia                 AS CHAR 
    FIELD PassivelSolicitacaoBeneficio  AS CHAR 
    */ .

DEFINE TEMP-TABLE msg0088r1 NO-UNDO XML-NODE-NAME 'MSG0088R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.








































