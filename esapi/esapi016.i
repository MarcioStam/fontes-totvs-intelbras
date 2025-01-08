
DEFINE TEMP-TABLE tt-lista-ns 
    FIELD num-serie     AS CHAR FORMAT "X(13)".

DEFINE TEMP-TABLE tt-kit-ns
    FIELD num-serie     AS CHAR FORMAT "X(13)".

DEFINE TEMP-TABLE tt-kit-impr
    FIELD it-codigo AS CHAR
    FIELD es-codigo AS CHAR
    FIELD sequencia AS INT
    FIELD n-serie   AS CHAR
    FIELD n-serie-sec AS CHAR
    INDEX id sequencia.

DEFINE TEMP-TABLE tt-etiq-coletiva LIKE etiq-coletiva
    .

DEFINE VARIABLE i-linha-conteudo AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-conteudo       AS INTEGER     NO-UNDO.
