{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0285 NO-UNDO XML-NODE-NAME 'MSG0285'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD Empresa         AS INTEGER INITIAL ?
    FIELD TipoColaborador AS INTEGER INITIAL ?
    FIELD Matricula       AS CHAR    INITIAL ?
    FIELD DataReferencia  AS DATE    INITIAL ?
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0285R NO-UNDO XML-NODE-NAME 'MSG0285R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD Empresa            AS INTEGER INITIAL ?
    FIELD TipoColaborador    AS INTEGER INITIAL ?
    FIELD Matricula          AS CHAR    INITIAL ?
    FIELD DataReferencia     AS DATE    INITIAL ?
    FIELD PercentualComissao AS DEC     INITIAL ?
    FIELD ValorTetoVariavel  AS DEC     INITIAL ?
    FIELD SalarioBase        AS DEC     INITIAL ?
    .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
