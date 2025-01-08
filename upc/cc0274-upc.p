/***********************************************************************
**  Programa..: UPC\CC03274-UPC.P
**  Descricao.: Colocar campo Estabelec na tela 
**  Versão....: 001 20/10/2015 - Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEF VAR wh-natur-cc0274    AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-fi-estab-cc0274 AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-tx-estab-cc0274 AS WIDGET-HANDLE NO-UNDO.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/********************************************************/
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

/********************************************************/
IF p-ind-event  = "INITIALIZE" THEN DO:

    ASSIGN wh-natur-cc0274 = getObject(p-wgh-frame,"c-natureza":U).

    IF VALID-HANDLE( wh-natur-cc0274 ) THEN DO:

        CREATE TEXT wh-tx-estab-cc0274 
        ASSIGN NAME         = 'wh-tx-estab-cc0274':U
               ROW          = wh-natur-cc0274:ROW + 0.15
               COLUMN       = wh-natur-cc0274:COLUMN + 27
               WIDTH        = 6
               DATA-TYPE    = "character"
               FORMAT       = "x(04)"
               FRAME        = wh-natur-cc0274:FRAME
               VISIBLE      = YES
               SCREEN-VALUE = "Est:".

        CREATE FILL-IN wh-fi-estab-cc0274
        ASSIGN NAME       = 'wh-fi-estab-cc0274':U
               FRAME      = wh-natur-cc0274:FRAME
               ROW        = wh-natur-cc0274:ROW
               COLUMN     = wh-natur-cc0274:COLUMN + 30
               HEIGHT     = 0.88
               WIDTH      = 4
               DATA-TYPE  = "Character"
               FORMAT     = "x(05)"
               TOOLTIP    = "Estabelecimento"
               HELP       = "Estabelecimento"
               VISIBLE    = TRUE
               SENSITIVE  = NO.
    END.
   
END.
/******************************************************************************/
IF p-ind-event  = "DISPLAY" THEN DO:

    ASSIGN wh-fi-estab-cc0274 = getObject(p-wgh-frame,"wh-fi-estab-cc0274":U).

    FIND FIRST pedido-compr NO-LOCK
        WHERE ROWID(pedido-compr) = p-row-table NO-ERROR.

    IF VALID-HANDLE( wh-fi-estab-cc0274 ) THEN DO:

        IF AVAIL pedido-comp THEN
            ASSIGN wh-fi-estab-cc0274:SCREEN-VALUE = pedido-compr.cod-estabel.
        ELSE
            ASSIGN wh-fi-estab-cc0274:SCREEN-VALUE = ''.
    END.

END.
/******************************************************************************/
IF p-ind-event  = "DESTROY" THEN DO:

    IF VALID-HANDLE(wh-tx-estab-cc0274) THEN
        DELETE OBJECT wh-tx-estab-cc0274.

    IF VALID-HANDLE(wh-fi-estab-cc0274) THEN
        DELETE OBJECT wh-fi-estab-cc0274.

    IF VALID-HANDLE(wh-natur-cc0274) THEN
        DELETE OBJECT wh-natur-cc0274.

END.
