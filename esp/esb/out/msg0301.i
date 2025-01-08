{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0301 NO-UNDO XML-NODE-NAME 'MSG0301'
    FIELD idm                     AS INT XML-NODE-TYPE 'hidden'.
                                           
DEFINE TEMP-TABLE EstuturaASTEC NO-UNDO XML-NODE-NAME 'EstuturaASTEC'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto LIKE estrutura.it-codigo.

DEFINE TEMP-TABLE ItemEstrutura NO-UNDO XML-NODE-NAME 'ItemEstrutura'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoItemEstrutura    AS CHARACTER  
    FIELD DescricaoItem          LIKE ITEM.desc-item
    FIELD TipoItem               AS CHAR
    FIELD QuantidadeUsada        AS INT
    FIELD TempoGarantia          LIKE int-estrutura.garantia
    FIELD PermiteVenda           LIKE int-estrutura.venda
    FIELD PermiteDiagnostico     AS LOG
    FIELD LocalMontagem          AS CHAR.
    
DEFINE TEMP-TABLE msg0301r NO-UNDO XML-NODE-NAME 'MSG0301R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.


DEFINE TEMP-TABLE tt-estrut-astec NO-UNDO LIKE estrut-astec
       field r-rowid as ROWID.

DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO
    FIELD CodigoProduto LIKE estrutura.it-codigo.
