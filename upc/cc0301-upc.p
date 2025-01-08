DEF INPUT PARAM p-ind-event        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object       AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object       AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table        AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR r-ordem-compra-cd0301     AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-modificar-cd0301    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-incluir-cd0301      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-eliminar-cd0301     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd0301-upc              AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd0301-query-upc        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR v-row-cc0301              AS ROWID         NO-UNDO.

DEFINE VARIABLE h-object                            AS HANDLE        NO-UNDO.

DEF VAR c-objeto    AS CHAR            NO-UNDO.
DEF VAR h-frame     AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo   AS WIDGET-HANDLE   NO-UNDO.
DEF VAR h-query-tmp AS HANDLE      NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), 
                        p-wgh-object:FILE-NAME,"~/").

/*                                            */
/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)SKIP  */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */


IF  p-ind-event = "AFTER-OPEN-QUERY" 
AND c-objeto    = "cc0301-b01.w" THEN DO:
    FIND FIRST ordem-compra NO-LOCK
         WHERE ROWID(ordem-compra) = r-ordem-compra-cd0301 NO-ERROR.

    IF AVAIL ordem-compra THEN DO:
        IF ordem-compra.situacao = 3 THEN DO:
            ASSIGN wh-bt-incluir-cd0301  :SENSITIVE = YES
                   wh-bt-modificar-cd0301:SENSITIVE = YES
                   wh-bt-eliminar-cd0301 :SENSITIVE = YES.
        END.
    END.
END.


IF  p-ind-event = "DISPLAY" 
AND c-objeto    = "cc0301-v01.w" THEN DO:
    ASSIGN r-ordem-compra-cd0301 = p-row-table.
END.

IF  p-ind-event  = "DESTROY" 
AND p-ind-object = "CONTAINER" THEN DO:
    DELETE PROCEDURE h-cd0301-upc.
END.

IF  p-ind-event = "INITIALIZE"
AND c-objeto    = "cc0301-b01.w " THEN DO:

    IF NOT VALID-HANDLE(h-cd0301-upc) THEN
        RUN upc/cc0301-upc.p PERSISTENT SET h-cd0301-upc(INPUT "",            
                                                         INPUT "",            
                                                         INPUT p-wgh-object,  
                                                         INPUT p-wgh-frame,   
                                                         INPUT "",            
                                                         INPUT p-row-table).

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "bt-incluir"   THEN ASSIGN wh-bt-incluir-cd0301   = h-frame.
                WHEN "bt-modificar" THEN ASSIGN wh-bt-modificar-cd0301 = h-frame.
                WHEN "bt-eliminar"  THEN ASSIGN wh-bt-eliminar-cd0301  = h-frame.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(h-cd0301-upc) THEN
        ON "CHOOSE":U OF wh-bt-incluir-cd0301 PERSISTENT RUN pi-choose-incluir IN h-cd0301-upc.

    ASSIGN h-cd0301-query-upc = SESSION:FIRST-PROCEDURE.
      
    DO  WHILE h-cd0301-query-upc <> ?:
        ASSIGN h-query-tmp = h-cd0301-query-upc:NEXT-SIBLING.
    
        IF (INDEX(h-cd0301-query-upc:FILE-NAME, "inqry/q02in274.w") <> 0) THEN
            LEAVE.
    
        ASSIGN h-cd0301-query-upc = h-query-tmp.
    END.

    IF VALID-HANDLE (h-cd0301-query-upc) THEN
        RUN pi-reposiciona-query IN h-cd0301-query-upc (INPUT v-row-cc0301).
       
END.


PROCEDURE pi-choose-incluir:
    FIND FIRST ordem-compra NO-LOCK
         WHERE ROWID(ordem-compra) = r-ordem-compra-cd0301 NO-ERROR.

    IF  AVAIL ordem-compra     
    AND ordem-compra.int-1 = 1 THEN DO:
        {utp/ut-table.i mgind ordem-compra 1}
        RUN utp/ut-msgs.p ("show":U,7193,TRIM(RETURN-VALUE)).
        RETURN NO-APPLY.
    END.    

    RUN pi-Incmod IN p-wgh-object ('incluir':U).

    RETURN "OK":U.
END PROCEDURE.
RETURN "OK":u.


