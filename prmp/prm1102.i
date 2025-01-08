DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)"
    FIELD usuario          AS CHARACTER FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHARACTER FORMAT "x(40)"
    FIELD modelo-rtf       AS CHARACTER FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD l-venda          AS LOG
    FIELD l-remessa        AS LOG
    FIELD l-cancela        AS LOG
    FIELD l-retorno        AS LOG
    FIELD l-devolucao      AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo          AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.
    
DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.    
