/*********************** Retorna os parƒmetros globais **********************************/

{esp/esb/esesb000.i}

/* Para busca Benef¡cios CRM */
DEFINE temp-table msg0165 no-undo xml-node-name 'MSG0165'
    FIELD idm                         AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoBeneficioCanal        AS CHAR
    FIELD NomeBeneficioCanal          AS CHAR
    FIELD CodigoConta                 AS CHAR 
    FIELD CodigoBeneficio             AS CHAR 
    FIELD BeneficioCodigo             AS INTEGER
    FIELD NomeBeneficio               AS CHAR
    FIELD CodigoCategoria             AS CHAR
    FIELD CategoriaCodigo             AS INTEGER
    FIELD NomeCategoria               AS CHAR
    FIELD CodigoUnidadeNegocio        AS CHAR
    FIELD NomeUnidadeNegocio          AS CHAR 
    FIELD CodigoStatusBeneficio       AS CHAR
    FIELD NomeStatusBeneficio         AS CHAR
    FIELD CalcularVerba               AS LOGICAL
    FIELD AcumularVerba               AS LOGICAL
    FIELD PassivelSolicitacao         AS LOGICAL
    FIELD PossuiControleContaCorrente AS INTEGER
    FIELD Situacao                    AS INT 
    FIELD Proprietario                AS CHAR 
    FIELD TipoProprietario            AS CHAR.
    
DEFINE TEMP-TABLE msg0165r1 NO-UNDO XML-NODE-NAME 'MSG0165R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
