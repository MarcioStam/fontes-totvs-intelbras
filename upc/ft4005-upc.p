/***********************************************************************
**  Programa..: UPC\FT4005-UPC.P
**  Autor.....: Giovane - Developer
**  Data......: Junho/2007 - Desenvolvimento
**  Descricao.: Criar bot∆o para invocar programa de preview da NF
**  Vers∆o....: 001 06/06/2007
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
def var wh-btCancel as widget-handle no-undo.
def var wh-object as widget-handle   no-undo.
def new global shared var wh-btPreview-gs as widget-handle no-undo.
def new global shared var h-ft4005-upcb as handle no-undo.
assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
                        
case p-ind-event:
    when "AFTER-INITIALIZE" then do:
        ASSIGN wh-object = p-wgh-frame:FIRST-CHILD
               wh-object = wh-object:FIRST-CHILD.

        DO WHILE VALID-HANDLE(wh-object):
            IF wh-object:TYPE <> "field-group" THEN DO:
                IF wh-object:NAME = 'btCancel' THEN wh-btCancel = wh-object.
                ASSIGN wh-object = wh-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.
        
        if valid-handle(wh-btCancel) then do:
        
            CREATE BUTTON wh-btPreview-gs
            ASSIGN FRAME     = wh-btCancel:FRAME
                   WIDTH     = 15.0
                   HEIGHT    = wh-btCancel:HEIGHT
                   ROW       = wh-btCancel:ROW
                   LABEL     = "Visualiza Nota"
                   COL       = wh-btCancel:COL + 20.0
                   SENSITIVE = wh-btCancel:SENSITIVE
                   VISIBLE   = wh-btCancel:VISIBLE
                   NAME      = "btPreview"
                   HELP      = "Previs∆o da impress∆o da nota sem os r¢tulos de campos"
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\ft4005-upca.p.
            END TRIGGERS.       
            wh-btPreview-gs:MOVE-AFTER(wh-btCancel).  
        end.
        
    end.
    when "BEFORE-DESTROY-INTERFACE" then do:
        if valid-handle(wh-btPreview-gs) then do:
            delete widget wh-btPreview-gs.
            wh-btPreview-gs = ?.
        end.    
        if valid-handle(h-ft4005-upcb) then do:
            delete procedure h-ft4005-upcb.
            h-ft4005-upcb = ?.
        end.
    end.        
    
end case.
                                 



