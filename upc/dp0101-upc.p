/***********************************************************************
**  Programa..: DP0101-UPC.P
**  Autor.....: Nicolas Martinez
**  Data......: 01/02/2021
**  Descricao.: Upc DP0101
**  Vers∆o....: 2.00.001 01/02/2021 - Desenvolvimento Programa
**              2.00.002 27/10/2021 - Libera Narrativa na Inlc e Copia
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/  

DEFINE VARIABLE c-char                            AS CHARACTER     NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-narrativa-dp0101     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-item-dp-dp0101       AS WIDGET-HANDLE NO-UNDO.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*Functions*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
       
        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.

//Busca objeto do codigo do item
IF  p-ind-object = "VIEWER"
AND c-char     = "v01mf601.w"
THEN DO:
    IF p-ind-event = "AFTER-ENABLE" THEN DO:
        ASSIGN wh-item-dp-dp0101 = getObject(p-wgh-frame,"item-dp":U).
    END.
END.

/* viewer FISCAIS */
IF  p-ind-object = "VIEWER"
AND c-char     = "v03mf601.w"
THEN DO:

    IF p-ind-event = "AFTER-ENABLE" THEN DO:
        ASSIGN wh-narrativa-dp0101 = getObject(p-wgh-frame,"descricao":U).

        IF VALID-HANDLE(wh-narrativa-dp0101) THEN
        ASSIGN wh-narrativa-dp0101:SENSITIVE = NO.

        IF  VALID-HANDLE(wh-narrativa-dp0101) 
        AND VALID-HANDLE(wh-item-dp-dp0101) 
        THEN DO:
            //Somente Copia libera
            IF wh-item-dp-dp0101:SENSITIVE = YES
            THEN DO:
                IF wh-item-dp-dp0101:SCREEN-VALUE = "" 
                THEN ASSIGN wh-narrativa-dp0101:SENSITIVE = NO.
                ELSE ASSIGN wh-narrativa-dp0101:SENSITIVE = YES.
            END.
            ELSE ASSIGN wh-narrativa-dp0101:SENSITIVE = NO.

            /* Inlcus∆o e Copia libera
            IF wh-item-dp-dp0101:SENSITIVE = NO
            THEN ASSIGN wh-narrativa-dp0101:SENSITIVE = NO.
            ELSE ASSIGN wh-narrativa-dp0101:SENSITIVE = YES.
            */
        END.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:

    IF VALID-HANDLE(wh-narrativa-dp0101) THEN
        ASSIGN wh-narrativa-dp0101 = ?.

    IF VALID-HANDLE(wh-item-dp-dp0101) THEN
        ASSIGN wh-item-dp-dp0101 = ?.
END.
