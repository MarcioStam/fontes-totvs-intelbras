/************************************************************************
**  Programa..: upc\cd0402-upc.p
**  Autor.....: Rubia Oliveira
**  Data......: Maráo/2016 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 01/03/2016
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

DEFINE INPUT PARAM p-ind-event  AS char          NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS char          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS handle        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS widget-handle NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS char          NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS rowid         NO-UNDO.

DEFINE VARIABLE h-object        AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo         AS HANDLE        NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL       NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-cgc-cd0402                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-cod-transp-cd0402        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-SepUF-cd0402               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ind-cons-dt-entrega-cd0402 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-objeto AS   CHAR.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


/* MESSAGE "Evento " p-ind-event  SKIP     */
/*         "Objeto " p-ind-object SKIP     */
/*         "Nome   " c-objeto SKIP         */
/*         "Tabela " p-cod-table  SKIP     */
/*         "Rowid  " STRING(p-row-table)   */
/*         "Frame  " p-wgh-frame:NAME SKIP */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.  */
/*                                         */

IF p-ind-object = "VIEWER"      AND 
   p-ind-event = "INITIALIZE":U AND
   c-objeto    = "v01ad268.w":U THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'c-cod-transp' THEN DO:
                ASSIGN wh-c-cod-transp-cd0402 = h-object.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    

END.


IF p-ind-object = "VIEWER"      AND 
   p-ind-event = "INITIALIZE":U AND
   c-objeto    = "v05ad268.w":U THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'cgc' THEN DO:
                ASSIGN wh-cgc-cd0402 = h-object.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    
    
    CREATE TOGGLE-BOX wh-SepUF-cd0402
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = wh-cgc-cd0402:ROW - 1
           LABEL        = "Separacao por UF":U
           HELP         = "":U
           COLUMN       = wh-cgc-cd0402:COL
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    FIND FIRST transporte WHERE ROWID(transporte) = p-row-table NO-ERROR.
    IF AVAIL transporte THEN DO:
        FIND FIRST int-transporte WHERE
             int-transporte.cod-transp = transporte.cod-transp NO-ERROR.
        IF AVAIL int-transporte THEN DO:
            IF VALID-HANDLE(wh-SepUF-cd0402) THEN ASSIGN wh-SepUF-cd0402:SCREEN-VALUE  = string(int-transporte.separa-uf).
        END.
    END.

END.

IF p-ind-event = "ADD" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      ASSIGN wh-SepUF-cd0402:SENSITIVE = YES.
   END.
END.

IF p-ind-event = "ENABLE" THEN DO:
    IF p-wgh-frame:NAME = "f-main"  THEN DO:
       ASSIGN wh-SepUF-cd0402:SENSITIVE = YES.
    END.
END.

IF p-ind-event = "CANCEL" THEN DO:
   ASSIGN wh-SepUF-cd0402:SENSITIVE = NO.

   FIND FIRST transporte WHERE ROWID(transporte) = p-row-table NO-ERROR.
   IF AVAIL transporte THEN DO:
       FIND FIRST int-transporte WHERE
            int-transporte.cod-transp = transporte.cod-transp NO-ERROR.
       IF AVAIL int-transporte THEN DO:
           IF VALID-HANDLE(wh-SepUF-cd0402) THEN ASSIGN wh-SepUF-cd0402:SCREEN-VALUE  = string(int-transporte.separa-uf).
       END.
   END.

END.

IF p-ind-event = "DISPLAY"      AND
   p-ind-object = "VIEWER"      AND 
   c-objeto    = "v05ad268.w":U THEN DO:

    FIND FIRST transporte WHERE ROWID(transporte) = p-row-table NO-ERROR.
    IF AVAIL transporte THEN DO:
        FIND FIRST int-transporte WHERE
             int-transporte.cod-transp = transporte.cod-transp NO-ERROR.
        IF AVAIL int-transporte THEN DO:
            IF VALID-HANDLE(wh-SepUF-cd0402) THEN ASSIGN wh-SepUF-cd0402:SCREEN-VALUE  = string(int-transporte.separa-uf).
        END.
        ELSE 
            IF VALID-HANDLE(wh-SepUF-cd0402) THEN ASSIGN wh-SepUF-cd0402:SCREEN-VALUE  = 'NO'.
    END.

END.

IF p-ind-event = "ASSIGN"       AND
   p-ind-object = "VIEWER"      AND 
   c-objeto    = "v05ad268.w":U THEN DO:

    FIND FIRST transporte WHERE ROWID(transporte) = p-row-table NO-ERROR.
    IF AVAIL transporte THEN DO:
        FIND FIRST int-transporte WHERE
             int-transporte.cod-transp = transporte.cod-transp NO-ERROR.
        IF AVAIL int-transporte THEN DO:
            IF VALID-HANDLE(wh-SepUF-cd0402) AND wh-SepUF-cd0402:SCREEN-VALUE = "yes" THEN
               ASSIGN int-transporte.separa-uf = YES.
            ELSE
                ASSIGN int-transporte.separa-uf = NO.
        END.
        ELSE DO:
            IF VALID-HANDLE(wh-SepUF-cd0402) AND wh-SepUF-cd0402:SCREEN-VALUE = "yes" THEN DO:
                CREATE int-transporte.
                ASSIGN int-transporte.cod-transp = transporte.cod-transp
                       int-transporte.separa-uf  = YES.
            END.
            ELSE DO:
                CREATE int-transporte.
                ASSIGN int-transporte.cod-transp = transporte.cod-transp
                       int-transporte.separa-uf  = NO.
            END.
        END.
    END.
    ASSIGN wh-SepUF-cd0402:SENSITIVE = NO.

END.

IF  p-ind-object = "VIEWER"      
AND c-objeto    = "v11ad268.w":U THEN DO:

    IF p-ind-event = "INITIALIZE":U  THEN DO:
        CREATE TOGGLE-BOX wh-ind-cons-dt-entrega-cd0402
        ASSIGN FRAME        = p-wgh-frame             
               WIDTH        = 35                      
               HEIGHT       = 1.00                    
               ROW          = 6
               LABEL        = "Considera Regra para Data de Entrega":U
               HELP         = "":U
               COLUMN       = 37
               SENSITIVE    = NO                      
               VISIBLE      = YES.    

        FIND FIRST transporte NO-LOCK
             WHERE ROWID(transporte) = p-row-table NO-ERROR.

        FIND FIRST int-transporte NO-LOCK
             WHERE int-transporte.cod-transp = transporte.cod-transp NO-ERROR.

        IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
            ASSIGN wh-ind-cons-dt-entrega-cd0402:CHECKED = IF AVAIL int-transporte THEN int-transporte.ind-cons-dt-entrega ELSE NO.

    END.
END.

IF p-ind-event = "ENABLE" THEN DO:
    IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
        ASSIGN wh-ind-cons-dt-entrega-cd0402:SENSITIVE = YES.
END.

IF p-ind-event = "DISABLE" THEN DO:
    IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
        ASSIGN wh-ind-cons-dt-entrega-cd0402:SENSITIVE = NO.
END.

IF p-ind-event = "ASSIGN" THEN DO:
    FIND FIRST transporte NO-LOCK
         WHERE ROWID(transporte) = p-row-table NO-ERROR.

    IF AVAIL transporte THEN DO:
    
        FIND FIRST int-transporte EXCLUSIVE-LOCK
             WHERE int-transporte.cod-transp = transporte.cod-transp NO-ERROR.

        IF NOT AVAIL int-transporte THEN DO:
            CREATE int-transporte.
            ASSIGN int-transporte.cod-transp = transporte.cod-transp.
        END.

        IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
            ASSIGN int-transporte.ind-cons-dt-entrega = wh-ind-cons-dt-entrega-cd0402:CHECKED.
    END.
END.

IF p-ind-event = "DISPLAY" THEN DO:

    FIND FIRST transporte NO-LOCK
         WHERE ROWID(transporte) = p-row-table NO-ERROR.

    FIND FIRST int-transporte NO-LOCK
         WHERE int-transporte.cod-transp = transporte.cod-transp NO-ERROR.

    IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
        ASSIGN wh-ind-cons-dt-entrega-cd0402:CHECKED = IF AVAIL int-transporte THEN int-transporte.ind-cons-dt-entrega ELSE NO.
END.

IF p-ind-event = "ADD" THEN DO:
    IF VALID-HANDLE (wh-ind-cons-dt-entrega-cd0402) THEN
        ASSIGN wh-ind-cons-dt-entrega-cd0402:CHECKED = NO.
END.


