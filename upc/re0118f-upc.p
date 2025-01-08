/***********************************************************************
**  Programa..: upc/re0118f-upc.p
**  Descricao.: inclui coluna CFOP na tela do re0118f
************************************************************************/

def input param p-ind-event       as char          no-undo.
def input param p-ind-object      as char          no-undo.
def input param p-wgh-object      as handle        no-undo.
def input param p-wgh-frame       as widget-handle no-undo.
def input param p-cod-table       as char          no-undo.
def input param p-row-table       as rowid         no-undo.
                                  

define variable c-objeto          as char          no-undo.
                                                          
define new global shared variable h-campo-cfop-re0118f as handle        no-undo.
define new global shared variable hBrowseTela-re0118f  as handle        no-undo.
define new global shared variable wh-query-re0118f     as widget-handle no-undo.

define variable wh-browse-re0118f as widget-handle no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/* OUTPUT TO "C:\TEMP\EVENTOS-re0118f.TXT" NO-CONVERT APPEND. */
/* PUT UNFORMATTED                                             */
/*         "Evento: " p-ind-event         SKIP                 */
/*         "Objeto: " p-ind-object        SKIP                 */
/*         "Tabela: " p-cod-table         SKIP                 */
/*         "Rowid : " STRING(p-row-table) SKIP                 */
/*         "Objeto: " c-objeto            SKIP(1).             */
/* OUTPUT CLOSE.                                               */


if  p-ind-event  = "BEFORE-DISPLAY" 
and c-objeto     = "re0118f.w" then do:
    
    run getFieldHandle (input "brSource", output hBrowseTela-re0118f).

    run pi-busca-valor-atual.

    ASSIGN h-campo-cfop-re0118f           = hBrowseTela-re0118f:ADD-CALC-COLUMN("CHAR", "X(06)", " ", "CFOP    ", 4)
           h-campo-cfop-re0118f:VISIBLE   = TRUE
           h-campo-cfop-re0118f:READ-ONLY = TRUE.
end.

PROCEDURE getFieldHandle:
    DEF INPUT  PARAMETER  p-campo  AS CHAR no-undo.
    DEF OUTPUT PARAMETER p-handle AS HANDLE no-undo.
    
    def var h_frame as widget-handle no-undo. 
    
    ASSIGN h_Frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h_Frame = h_Frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    
    DO WHILE h_Frame <> ? :
        IF h_frame:type <> "field-group" THEN DO: 
            
            IF h_Frame:NAME = p-campo THEN DO:
                assign p-handle = h_Frame.
                leave.
            END.
            ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
        END. 
        ELSE
            ASSIGN h_frame = h_frame:first-child. 
    END.
end.

PROCEDURE pi-busca-valor-atual.
    
    ASSIGN wh-browse-re0118f = hBrowseTela-re0118f:FIRST-COLUMN.
    IF VALID-HANDLE(wh-browse-re0118f) THEN DO:
        ASSIGN wh-query-re0118f = hBrowseTela-re0118f:QUERY.
        IF VALID-HANDLE(hBrowseTela-re0118f) THEN
             ON 'ROW-DISPLAY' OF hBrowseTela-re0118f PERSISTENT RUN upc/re0118f-upca.p (INPUT wh-browse-re0118f /*:HANDLE*/,
                                                                                        INPUT wh-query-re0118f).
    END.

END PROCEDURE.
