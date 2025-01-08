DEFINE NEW GLOBAL SHARED VAR r-cdd-embarque-eq0506 AS ROWID NO-UNDO.
def var h-acomp      as handle no-undo.

run utp/ut-acomp.p persistent set h-acomp.  

RUN pi-inicializar in h-acomp (input "Imprimindo...").

FOR FIRST embarque
    WHERE rowid(embarque) = r-cdd-embarque-eq0506 NO-LOCK,
     EACH pre-fatur
    where pre-fatur.cdd-embarq      = embarque.cdd-embarq EXCLUSIVE-LOCK:

    RUN pi-acompanhar in h-acomp (input "Embarque "  + string(embarque.cdd-embarq) + " Resumo " + string(pre-fatur.nr-resumo)).
    assign pre-fatur.ind-sit-embarque = 1.
end.

    RUN pi-finalizar in h-acomp.
MESSAGE "Embarque " + STRING(embarque.cdd-embarq)  + " Desbloqueado com Sucesso "
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
