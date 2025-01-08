
DEFINE NEW GLOBAL SHARED VARIABLE grw-int-familia-cd0134 AS ROWID NO-UNDO.

DEFINE VARIABLE h-tela AS HANDLE      NO-UNDO.
    

IF grw-int-familia-cd0134 <> ? THEN DO:

    RUN esp/cdp/escdp073.w PERSISTENT SET h-tela.

    RUN initializeInterface IN h-tela.

    RUN repositionRecord IN h-tela (INPUT grw-int-familia-cd0134).

    WAIT-FOR "CLOSE" OF h-tela.

END.
