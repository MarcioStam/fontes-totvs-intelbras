/***********************************************************************
**  Programa..: upc/re1001e2-upc.p
**  Descricao.: inclui coluna CFOP na tela do re1001e2
************************************************************************/

def input param p-ind-event       as char          no-undo.
def input param p-ind-object      as char          no-undo.
def input param p-wgh-object      as handle        no-undo.
def input param p-wgh-frame       as widget-handle no-undo.
def input param p-cod-table       as char          no-undo.
def input param p-row-table       as rowid         no-undo.
                                  
define variable h-object          as handle        no-undo.
define variable h-campo           as handle        no-undo.
define variable wgh-grupo         as widget-handle no-undo.
define variable c-objeto          as char          no-undo.
                                                          
define new global shared variable h-campo-cfop-re1001e2 as handle        no-undo.
define new global shared variable hBrowseTela-re1001e2  as handle        no-undo.
define new global shared variable wh-query-re1001e2     as widget-handle no-undo.
define new global shared variable rowid-nf-re1001e2     as rowid         no-undo.

define buffer bf-nota-fiscal  for nota-fiscal.
define buffer bf-it-nota-fisc for it-nota-fisc.

define variable wh-browse-page3 as widget-handle no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/* OUTPUT TO "C:\TEMP\EVENTOS-RE1001E2.TXT" NO-CONVERT APPEND. */
/* PUT UNFORMATTED                                             */
/*         "Evento: " p-ind-event         SKIP                 */
/*         "Objeto: " p-ind-object        SKIP                 */
/*         "Tabela: " p-cod-table         SKIP                 */
/*         "Rowid : " STRING(p-row-table) SKIP                 */
/*         "Objeto: " c-objeto            SKIP(1).             */
/* OUTPUT CLOSE.                                               */


IF  p-ind-event  = "AFTER-INITIALIZE"
AND p-ind-object = "CONTAINER"
AND p-cod-table  = "nota-fiscal"
AND c-objeto     = "re1001e2.w" THEN ASSIGN rowid-nf-re1001e2 = p-row-table.

if  p-ind-event  = "BEFORE-OPEN-BROWSE" 
and p-ind-object = "tt-it-nota-fisc"    
and c-objeto     = "re1001e2.w" then do:
    
    def var iLeft as integer no-undo.
           
    run getFieldHandle (input "brSon1", output hBrowseTela-re1001e2).

    run pi-busca-valor-atual.

    ASSIGN h-campo-cfop-re1001e2           = hBrowseTela-re1001e2:ADD-CALC-COLUMN("CHAR", "X(06)", " ", "CFOP    ", 4)
           h-campo-cfop-re1001e2:VISIBLE   = TRUE
           h-campo-cfop-re1001e2:READ-ONLY = TRUE.
end.

PROCEDURE getFieldHandle:
    DEF INPUT PARAMETER  p-campo  AS CHAR no-undo.
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
    
    ASSIGN wh-browse-page3 = hBrowseTela-re1001e2:FIRST-COLUMN.
    IF VALID-HANDLE(wh-browse-page3) THEN DO:
        ASSIGN wh-query-re1001e2 = hBrowseTela-re1001e2:QUERY.
        IF VALID-HANDLE(hBrowseTela-re1001e2) THEN
             ON 'ROW-DISPLAY' OF hBrowseTela-re1001e2 PERSISTENT RUN upc/re1001e2-upca.P (INPUT wh-browse-page3 /*:HANDLE*/,
                                                                                          INPUT wh-query-re1001e2).
    END.

END PROCEDURE.
