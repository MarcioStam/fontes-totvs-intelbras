DEFINE TEMP-TABLE tt-mail NO-UNDO
    FIELD sequencia     AS INTEGER
    FIELD Remetente     AS CHARACTER 
    FIELD Destinatario  AS CHARACTER 
    FIELD Copia         AS CHARACTER 
    FIELD Assunto       AS CHARACTER 
    FIELD Mensagem      AS CHARACTER 
    FIELD Arquivo       AS CHARACTER 
    FIELD lEnviado      AS LOGICAL
    INDEX id sequencia.
