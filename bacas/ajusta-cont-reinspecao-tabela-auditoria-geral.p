DEFINE BUFFER b-audit FOR auditoria-geral.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
FOR EACH auditoria-geral EXCLUSIVE-LOCK:

    ASSIGN i-cont = 0.

    FOR EACH b-audit NO-LOCK
        WHERE b-audit.cod-audit-origem = auditoria-geral.nr-seq-auditoria:

        ASSIGN i-cont = i-cont + 1.

    END.

    ASSIGN auditoria-geral.cont-reinspecao = i-cont.

END.

MESSAGE "Processo Finalizado."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
