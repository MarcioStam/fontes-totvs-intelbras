/*********************** Retorna os parƒmetros globais **********************************/

{esp/esb/esesb000.i}

/* Para busca Benef¡cios CRM */
DEFINE temp-table msg0166 no-undo xml-node-name 'MSG0166'
    FIELD idm                         AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoParametroBeneficio    AS CHAR
    FIELD CodigoBeneficio             AS CHAR
    FIELD BeneficioCodigo             AS INTEGER
    FIELD CodigoUnidadeNegocio        AS CHAR
    FIELD CodigoEstabelecimento       AS INTEGER
    FIELD TipoFluxoFinanceiro         AS CHAR
    FIELD EspecieDocumento            AS CHAR
    FIELD ContaContabil               AS CHAR
    FIELD CentroCusto                 AS CHAR
    FIELD PercentualAtingimentoMeta   AS DEC DECIMALS 2
    FIELD PercentualCusto             AS DEC DECIMALS 2
    FIELD Situacao                    AS INT 
    FIELD Proprietario                AS CHAR 
    FIELD TipoProprietario            AS CHAR.
    
DEFINE TEMP-TABLE msg0166r1 NO-UNDO XML-NODE-NAME 'MSG0166R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
