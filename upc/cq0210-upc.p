{utp/ut-glob.i}
{upc/btb910za-upc.i}

/* Defini‡Æo da temp-table "tt-prog-ponto" */
{esp/es0018.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

def new global shared var ficha-cq-cq0210-row as rowid no-undo.

{utp/utapi019.i}
/*
MESSAGE 
    "p-ind-event:  " p-ind-event  SKIP
    "p-ind-object: " p-ind-object SKIP
    "p-wgh-object: " p-wgh-object SKIP
    "p-wgh-frame : " p-wgh-frame  SKIP
    "p-cod-table:  " p-cod-table  SKIP
    "p-row-table:  " string(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF p-ind-event  = "DISPLAY"  AND 
   p-ind-object = "VIEWER" 
THEN DO: 
    ASSIGN ficha-cq-cq0210-row = p-row-table.
END.


