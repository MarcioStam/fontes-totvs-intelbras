DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD cod-emitente  AS INTEGER
    FIELD serie-docto   AS CHARACTER
    FIELD nro-docto     AS CHARACTER
    FIELD nat-operacao  AS CHARACTER
    FIELD i-sequen      AS INT             
    FIELD cd-erro       AS INT
    FIELD mensagem      AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE tt-erro-docum NO-UNDO LIKE tt-erro.