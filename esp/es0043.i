DEFINE VARIABLE c-dir-arquivo-session AS CHAR NO-UNDO.

IF OPSYS = 'unix'
THEN DO:
    FIND FIRST ponto-programa USE-INDEX ponto 
         WHERE ponto-programa.nome-programa = "spool-unix"
           AND ponto-programa.ponto         = 1
               NO-LOCK NO-ERROR.

    IF AVAIL ponto-programa 
    THEN FIND FIRST conteudo-programa 
              WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                    NO-LOCK NO-ERROR.
               
    IF AVAIL conteudo-programa 
    THEN ASSIGN c-dir-arquivo-session = conteudo-programa.conteudo + "/".
               
END.
ELSE DO:
    FIND FIRST ponto-programa USE-INDEX ponto 
         WHERE ponto-programa.nome-programa = "spool-win"
           AND ponto-programa.ponto         = 1
               NO-LOCK NO-ERROR.

    IF AVAIL ponto-programa 
    THEN FIND FIRST conteudo-programa 
              WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                    NO-LOCK NO-ERROR.
               
    IF AVAIL conteudo-programa 
    THEN ASSIGN c-dir-arquivo-session = conteudo-programa.conteudo + "\".
END.

