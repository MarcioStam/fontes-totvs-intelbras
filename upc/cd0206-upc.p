/***********************************************************************
**  Programa..: upc\cd0206-upc.p
**  Autor.....: Rubia Oliveira - SENSUS
**  Data......: JUNHO/2015 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 23/06/2015
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

/* Definiá∆o da temp-table "tt-prog-ponto" */

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR wgh-objeto            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-categoria          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-categoria          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-categoriaDesc      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tb-aloc-neg-cd0206 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fm-cod-com-cd0206  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cd0206          AS WIDGET-HANDLE NO-UNDO.

/* MESSAGE "Evento " p-ind-event  SKIP    */
/*         "Objeto " p-ind-object SKIP    */
/*         "Tabela " p-cod-table  SKIP    */
/*         "Rowid  " STRING(p-row-table)  */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0206-upc.p PERSISTENT SET h-upc-cd0206(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).
END.

IF p-ind-event = "destroy" AND VALID-HANDLE(h-upc-cd0206) THEN
    DELETE PROCEDURE h-upc-cd0206.


IF  p-ind-event  = "INITIALIZE"
AND p-ind-object = "VIEWER" THEN DO:
                                          
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            CASE h-object:NAME:
                WHEN "fm-cod-com":U THEN
                    ASSIGN wh-fm-cod-com-cd0206  = h-object.
                WHEN "tb-aloc-neg":U THEN
                    ASSIGN wh-tb-aloc-neg-cd0206 = h-object.
            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN wh-tb-aloc-neg-cd0206:COLUMN = wh-tb-aloc-neg-cd0206:COLUMN - 22
           wh-tb-aloc-neg-cd0206:ROW = wh-tb-aloc-neg-cd0206:ROW + 0.2.

    CREATE TEXT tx-categoria
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(21)"
           WIDTH        = 21
           SCREEN-VALUE = "Categoria:"
           ROW          = wh-tb-aloc-neg-cd0206:ROW    
           COL          = wh-tb-aloc-neg-cd0206:COLUMN + 25
           VISIBLE      = YES.

    CREATE FILL-IN wh-categoria
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           WIDTH             = 20
           HEIGHT            = 0.88
           ROW               = wh-tb-aloc-neg-cd0206:ROW    - 0.2
           COL               = wh-tb-aloc-neg-cd0206:COLUMN + 32
           VISIBLE           = YES
           SENSITIVE         = NO
    TRIGGERS:
       ON "LEAVE":U PERSISTENT RUN pi-leave-categoria IN h-upc-cd0206.
       ON "F5":U PERSISTENT RUN upc/cd0206-upczoom.p.
       ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/cd0206-upczoom.p.
    END TRIGGERS.

    wh-categoria:LOAD-MOUSE-POINTER('image/lupa.cur').

    CREATE FILL-IN wh-categoriaDesc
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           WIDTH             = 30
           HEIGHT            = 0.88
           ROW               = wh-tb-aloc-neg-cd0206:ROW    - 0.2
           COL               = wh-tb-aloc-neg-cd0206:COLUMN + 52
           FORMAT            = "X(40)"
           VISIBLE           = YES
           SENSITIVE         = NO.
END.

IF  p-ind-event = "DISPLAY"
AND p-ind-object = "VIEWER"  THEN DO:

    IF  VALID-HANDLE(wh-categoria)
    AND VALID-HANDLE(wh-fm-cod-com-cd0206) THEN DO:

        ASSIGN wh-categoria:SENSITIVE    = NO
               wh-categoria:SCREEN-VALUE = ''.
        FIND FIRST categoria-fmcom
            WHERE categoria-fmcom.fm-cod-com = wh-fm-cod-com-cd0206:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL categoria-fmcom THEN
            ASSIGN wh-categoria:SCREEN-VALUE = categoria-fmcom.cod-categoria.

        FIND FIRST categoria-produto
            WHERE categoria-produto.cod-categoria = wh-categoria:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL categoria-produto THEN
            ASSIGN wh-categoriaDesc:SCREEN-VALUE = categoria-produto.desc-categoria.
        ELSE
            ASSIGN wh-categoriaDesc:SCREEN-VALUE = ''.
        
    END.

END.

IF  p-ind-event  = "ENABLE" 
AND p-ind-object = "VIEWER" THEN do:
    assign wh-categoria:SENSITIVE = YES.
end.
        
           

IF  p-ind-event  = "DISABLE" 
AND p-ind-object = "VIEWER" THEN do:
    ASSIGN wh-categoria:SENSITIVE = NO.
end.

IF  p-ind-event  = "ASSIGN" 
AND p-ind-object = "VIEWER" THEN DO:

    IF  VALID-HANDLE(wh-categoria)
    AND VALID-HANDLE(wh-fm-cod-com-cd0206) THEN DO:

        FIND FIRST categoria-fmcom
            WHERE categoria-fmcom.fm-cod-com    = wh-fm-cod-com-cd0206:SCREEN-VALUE 
              AND categoria-fmcom.cod-categoria = wh-categoria:SCREEN-VALUE         NO-LOCK NO-ERROR.
        IF NOT AVAIL categoria-fmcom THEN DO:
            CREATE categoria-fmcom.
            ASSIGN categoria-fmcom.fm-cod-com    = wh-fm-cod-com-cd0206:SCREEN-VALUE
                   categoria-fmcom.cod-categoria = wh-categoria:SCREEN-VALUE        .
        END.

    END.

END.

PROCEDURE pi-leave-categoria:

    IF VALID-HANDLE(wh-categoria) AND wh-categoria:SCREEN-VALUE <> '' THEN DO:

        FIND FIRST categoria-produto NO-LOCK
             WHERE categoria-produto.cod-categoria = wh-categoria:SCREEN-VALUE NO-ERROR.
        IF NOT AVAIL categoria-produto THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Categoria inv†lida~~Favor informe uma categoria cadastrada. (ESCDP078)!").
            APPLY "ENTRY" TO wh-categoria.
            RETURN "NOK".
        END.
        ELSE 
            ASSIGN wh-categoriaDesc:SCREEN-VALUE = categoria-produto.desc-categoria.
    END.
    
END PROCEDURE.

