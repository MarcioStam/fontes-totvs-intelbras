/*********************** Retorna os Parƒmetros Benef¡cio **********************************/

{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0142 NO-UNDO XML-NODE-NAME 'MSG0142'
    FIELD idm             AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoBeneficio AS CHAR. 


DEFINE TEMP-TABLE msg0142r NO-UNDO XML-NODE-NAME 'MSG0142R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.


DEFINE temp-table msg0142r-ParametroBeneficioItens no-undo xml-node-name 'ParametroBeneficioItens'
   field idm as int xml-node-type 'hidden'.

DEFINE temp-table msg0142r-ParametroBeneficioItem no-undo xml-node-name 'ParametroBeneficioItem'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoUnidadeNegocio      AS CHAR 
    FIELD CodigoEstabelecimento     AS INT
    FIELD TipoFluxoFinanceiro       AS CHAR
    FIELD EspecieDocumento          AS CHAR
    FIELD ContaContabil             AS CHAR
    FIELD CentroCusto               AS CHAR
    FIELD PercentualAtingimentoMeta AS DEC
    FIELD PercentualCusto           AS DEC.
   


