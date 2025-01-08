/*********************** Retorna os parƒmetros globais **********************************/

{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0141 NO-UNDO XML-NODE-NAME 'MSG0141'
    FIELD idm                          AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoConta                  AS CHAR
    FIELD CodigoUnidadeNegocio         AS CHAR
    FIELD PassivelSolicitacao          AS LOG
    FIELD PossuiControleContaCorrente  AS INT.


DEFINE TEMP-TABLE msg0141r NO-UNDO XML-NODE-NAME 'MSG0141R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.


DEFINE temp-table msg0141r-BeneficioItens no-undo xml-node-name 'BeneficioItens'
   field idm as int xml-node-type 'hidden'.

/* Para busca Benef¡cios CRM */
DEFINE temp-table msg0141r-beneficioItem no-undo xml-node-name 'BeneficioItem'
    FIELD idm                         AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoBeneficioCanal        AS CHAR
    FIELD NomeBeneficioCanal          AS CHAR
    FIELD CodigoBeneficio             AS CHAR 
    FIELD BeneficioCodigo             AS INTEGER
    FIELD NomeBeneficio               AS CHAR
    FIELD CodigoCategoria             AS CHAR
    FIELD CategoriaCodigo             AS INTEGER
    FIELD NomeCategoria               AS CHAR
    FIELD CodigoUnidadeNegocio        AS CHAR
    FIELD NomeUnidadeNegocio          AS CHAR 
    FIELD VerbaCalculada              AS DEC
    FIELD VerbaPeriodoAnterior        AS DEC
    FIELD VerbaTotal                  AS DEC
    FIELD VerbaEmpenhada              AS DEC
    FIELD VerbaReembolsada            AS DEC
    FIELD VerbaCancelada              AS DEC
    FIELD VerbaAjustada               AS DEC
    FIELD VerbaDisponivel             AS DEC
    FIELD CodigoStatusBeneficio       AS CHAR
    FIELD NomeStatusBeneficio         AS CHAR
    FIELD CalculaVerba                AS LOGICAL
    FIELD AcumulaVerba                AS LOGICAL
    FIELD PassivelSolicitacao         AS LOGICAL
    FIELD PossuiControleContaCorrente AS INTEGER.
    
