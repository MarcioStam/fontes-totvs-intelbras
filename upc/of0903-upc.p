/***********************************************************************
**  Programa..: upc\of0903-upc.p
**  Data......: Setembro/2015 - Desenvolvimento
**  Descricao.: Bot∆o para Importar arquivo
**  Vers∆o....: 001 - 00/00/2002 - Desenvolvimento Programa
************************************************************************/
{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-objeto         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-programa         AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btUpdate-of0903 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-char AS CHAR NO-UNDO.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), 
                                  p-wgh-object:file-name,"~/") no-error.

/* MESSAGE "Evento " p-ind-event  SKIP */
/*         "Objeto " p-ind-object SKIP */
/*         "Nome   " c-char SKIP */
/*         "Tabela " p-cod-table  SKIP */
/*         "Rowid  " STRING(p-row-table) */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

if p-ind-event  = "AFTER-INITIALIZE" then do:
   
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
        
            IF h-object:NAME = "btUpdate":U THEN DO:
                ASSIGN wh-btUpdate-of0903 = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.

    if valid-handle(wh-btUpdate-of0903) then do:
    
        create button wh-button  
        assign flat-button   = YES
               frame         = wh-btUpdate-of0903:frame 
               width         = wh-btUpdate-of0903:WIDTH
               height        = wh-btUpdate-of0903:HEIGHT
               row           = wh-btUpdate-of0903:ROW
               col           = wh-btUpdate-of0903:COLUMN + 25
               visible       = yes
               sensitive     = yes
               tooltip       = "Importar Planilha"
               triggers:
                    on choose persistent run upc/of0903a-upc.w.
               end triggers.
    
        if wh-button:load-image("image/gr-lay.bmp") then.
        if wh-button:load-image-down("image/gr-lay.bmp") then.
    end.
end.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:

    IF VALID-HANDLE(wh-btUpdate-of0903) THEN
        DELETE WIDGET wh-btUpdate-of0903.

    ASSIGN wh-btUpdate-of0903 = ?.
END.
