{esp/es0018.i}

DEFINE VARIABLE l-procedure  AS LOG NO-UNDO.
DEFINE VARIABLE l-query      AS LOG NO-UNDO.
DEFINE VARIABLE l-DataSet    AS LOG NO-UNDO.
DEFINE VARIABLE l-DataSource AS LOG NO-UNDO.
DEFINE VARIABLE l-Buffer     AS LOG NO-UNDO.
DEFINE VARIABLE l-Object     AS LOG NO-UNDO.

DEFINE VARIABLE hProc             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNext             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cProceduresToKill AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTemp   AS HANDLE NO-UNDO.
DEFINE VARIABLE hObject AS HANDLE NO-UNDO.

DEFINE VARIABLE oObject AS Progress.Lang.Object NO-UNDO.
DEFINE VARIABLE oTemp   AS Progress.Lang.Object NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ES0103", /* Nome do programa */
                   INPUT 1,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto:
    CASE tt-prog-ponto.sequencia:
        WHEN 1 THEN ASSIGN l-procedure   = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
        WHEN 2 THEN ASSIGN l-query       = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
        WHEN 3 THEN ASSIGN l-DataSet     = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
        WHEN 4 THEN ASSIGN l-DataSource  = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
        WHEN 5 THEN ASSIGN l-Buffer      = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
        WHEN 6 THEN ASSIGN l-Object      = IF tt-prog-ponto.conteudo = "YES" THEN YES ELSE NO.
    END.
END.

IF l-procedure THEN DO:

    EMPTY TEMP-TABLE tt-prog-ponto.
    ASSIGN cProceduresToKill = "".

    RUN esp/es0018p.p (INPUT "ES0103", /* Nome do programa */
                       INPUT 2,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FOR EACH tt-prog-ponto:
    
        IF cProceduresToKill = "" THEN
            ASSIGN cProceduresToKill = tt-prog-ponto.conteudo.
        ELSE
            ASSIGN cProceduresToKill = cProceduresToKill + "," + TRIM(tt-prog-ponto.conteudo).
    
    END.
    
    hProc = SESSION:FIRST-PROCEDURE.
    
    REPEAT WHILE VALID-HANDLE(hproc):
           /*we save the handle of the next procedure
           before removing it from the memory */
        hNext = hProc:NEXT-SIBLING.
    
        IF CAN-DO(cProceduresToKill, TRIM(hProc:FILE-NAME))  THEN
            DELETE PROCEDURE hproc.
    
        hProc = hNext.
    END.

END.

IF l-query THEN DO:
    ASSIGN hObject = SESSION:FIRST-QUERY.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.
        DELETE OBJECT hTemp NO-ERROR.
    END.
END.

IF l-DataSet THEN DO:
    ASSIGN hObject = SESSION:FIRST-DATASET.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.
        DELETE OBJECT hTemp NO-ERROR.
    END.
END.

IF l-DataSource THEN DO:
    ASSIGN hObject = SESSION:FIRST-DATA-SOURCE.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.
        DELETE OBJECT hTemp NO-ERROR.
    END.
END.

IF l-Buffer THEN DO:
    ASSIGN hObject = SESSION:FIRST-BUFFER.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.
        DELETE OBJECT hTemp NO-ERROR.
    END.
END.

IF l-Object THEN DO:
    ASSIGN oObject = SESSION:FIRST-OBJECT.
    DO WHILE VALID-OBJECT(oObject):
        ASSIGN oTemp = oObject.
        ASSIGN oObject = oObject:NEXT-SIBLING.
        
        DELETE OBJECT oTemp NO-ERROR.

        IF VALID-OBJECT(oObject) = NO THEN
            ASSIGN oObject = SESSION:FIRST-OBJECT.
    END.
END.

RETURN "OK".

