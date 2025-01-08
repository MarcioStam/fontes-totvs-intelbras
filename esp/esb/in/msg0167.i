/*********************** Retorna os parƒmetros globais **********************************/

{esp/esb/esesb000.i}

/* Para busca Benef¡cios CRM */
DEFINE temp-table msg0167 no-undo xml-node-name 'MSG0167'
    FIELD idm                         AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoParametroGlobal       AS CHAR
    FIELD NomeParametroGlobal         AS CHAR
    FIELD TipoParametroGlobal         AS INTEGER
    FIELD CodigoClassificacao         AS CHAR    INIT ?
    FIELD CodigoCompromisso           AS CHAR    INIT ?
    FIELD CodigoCategoria             AS CHAR    INIT ?
    FIELD CategoriaCodigo             AS INTEGER
    FIELD CodigoBeneficio             AS CHAR    INIT ?
    FIELD BeneficioCodigo             AS INTEGER
    FIELD CodigoNivelPosVenda         AS CHAR    INIT ?
    FIELD CodigoUnidadeNegocio        AS CHAR    INIT ?
    FIELD TipoDado                    AS INTEGER
    FIELD ValorParametroGlobal        AS CHAR
    FIELD Situacao                    AS INT 
    FIELD Proprietario                AS CHAR 
    FIELD TipoProprietario            AS CHAR.
    
DEFINE TEMP-TABLE msg0167r1 NO-UNDO XML-NODE-NAME 'MSG0167R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
