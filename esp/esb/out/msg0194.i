
DEFINE TEMP-TABLE msg0194 NO-UNDO XML-NODE-NAME 'MSG0194'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoRelacionamentoB2B AS CHAR
    FIELD NomeRelacionamento      AS CHAR
    FIELD CodigoCategoriaB2B      AS INTEGER
    FIELD CodigoCliente           AS INTEGER
    FIELD CodigoGrupoCliente      AS INTEGER
    FIELD CodigoRepresentante     AS INTEGER
    FIELD NomeUnidadeComercial    AS CHAR
    FIELD Sequencia               AS INTEGER
    FIELD DataInicial             AS DATE
    FIELD DataFinal               AS DATE
    FIELD Mensagem                AS CHAR INIT ?
    FIELD Situacao                AS INTEGER.

DEFINE TEMP-TABLE msg0194r NO-UNDO XML-NODE-NAME 'MSG0194R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD proprietario                          AS CHAR
   FIELD tipo-proprietario                     AS CHAR.































