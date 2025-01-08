/*********************** Retorna os parƒmetros globais **********************************
        O campo TipoDato pode ser: 
        993520000: Decimal
        993520001: Inteiro
        993520002: Conjunto de Valores
        993520003: Booleano
*****************************************************************************************/

{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0111 NO-UNDO XML-NODE-NAME 'MSG0111'
    FIELD idm                     AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoClassificacao     AS CHAR
    FIELD CodigoCompromisso       AS CHAR
    FIELD CodigoCategoria         AS CHAR
    FIELD CodigoBeneficio         AS CHAR 
    FIELD TipoParametroGlobal     AS INT
    FIELD CodigoNivelPosVenda     AS CHAR
    FIELD CodigoUnidadeNegocio    AS CHAR.
   
DEFINE TEMP-TABLE msg0111r NO-UNDO XML-NODE-NAME 'MSG0111R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE temp-table msg0111r-ParametroGlobal no-undo xml-node-name 'ParametroGlobal'
   field idm as int xml-node-type 'hidden'
   field TipoDado as int
   field Valor    as char.
   


