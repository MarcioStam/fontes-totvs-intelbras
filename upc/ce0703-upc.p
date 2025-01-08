
/***********************************************************************
**  Programa..: 
**  Autor.....: Carlos Daniel
**  Data......: 04/01/2016
**  Descricao.: 
**  Vers∆o....: 
**                  Desenvolvimento Programa
************************************************************************/
DEFINE INPUT PARAMETER p-ind-event        AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object       AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object       AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table        AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table        AS ROWID         NO-UNDO.

DEFINE VARIABLE h-lib-upc  AS HANDLE      NO-UNDO.
DEFINE VARIABLE lbloqueia  AS LOGICAL     NO-UNDO.

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF  p-ind-event  = "INITIALIZE" AND p-ind-object = "CONTAINER"   THEN DO:

    RUN upc/lib-upc.p PERSISTENT SET h-lib-upc.

    RUN piBloqueiaRequis IN h-lib-upc (OUTPUT lbloqueia).

    IF lbloqueia THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Programa bloqueado~~O programa est† temporariamente bloqueado para fins de fechamento. D£vidas entrar em contato com a Controladoria.").

        IF VALID-HANDLE(h-lib-upc) THEN
            DELETE PROCEDURE h-lib-upc.
        RUN adm-destroy IN p-wgh-object.
        RETURN "NOK".
    END.

    IF VALID-HANDLE(h-lib-upc) THEN
        DELETE PROCEDURE h-lib-upc.
END.
