/***********************************************************************
** Programa: dp0101-u00.p 
** Objetivo: UPC - Item DP - DP0101
**           
************************************************************************/

/* parametros */
DEF INPUT PARAM p-ind-event  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR           NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE         NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID          NO-UNDO.

DEF VAR c-item LIKE dp-item.item-dp NO-UNDO.

FUNCTION SearchObject RETURN HANDLE 
                     ( INPUT pHandle AS HANDLE , INPUT pName   AS CHARACTER ):

    DEFINE VARIABLE pReturnHandle AS HANDLE.
    
    pReturnHandle = ?.
    
    IF NOT CAN-QUERY(pHandle,"first-child") THEN RETURN pReturnHandle.
    
    pHandle = pHandle:FIRST-CHILD.
    
    REPEAT:
       IF NOT VALID-HANDLE(pHandle) THEN LEAVE.
       
       IF pName = pHandle:NAME THEN RETURN pHandle.
          pReturnHandle = SearchObject(pHandle,pName).

       IF pReturnHandle <> ? THEN RETURN pReturnHandle.
          pHandle = pHandle:NEXT-SIBLING.
    END.
    
    RETURN pReturnHandle.
END.

/* variaveis */
DEFINE NEW GLOBAL SHARED VARIABLE h_item-dp AS HANDLE NO-UNDO.

IF  p-ind-event               = "BEFORE-DISPLAY":U AND 
    p-ind-object              = "VIEWER":U         AND 
    p-wgh-object:PRIVATE-DATA = "mfvwr/v01mf601.w" AND    
    p-row-table               <> ?                 THEN DO:
    h_item-dp = SearchObject(p-wgh-frame,"ITEM-DP").
END.

IF  p-ind-event               = "VALIDATE":U         AND 
    p-ind-object              = "VIEWER":u           AND 
    p-wgh-object:PRIVATE-DATA = "mfvwr/v01mf601.w":U AND    
  /*p-row-table               <> ?                   AND*/
    p-cod-table               = "dp-item":U          AND
    VALID-HANDLE( h_item-dp )THEN DO:

    RUN GET-ATTRIBUTE IN p-wgh-object ('adm-new-record').
    IF  RETURN-VALUE = "YES" THEN DO: /* Inclus∆o */ 
        IF  CAN-FIND(FIRST ITEM WHERE ITEM.IT-CODIGO = h_item-dp:SCREEN-VALUE) THEN DO:
            run utp/ut-msgs.p (input "show", input 1, input "ITEM":U).
            APPLY 'entry':U to h_item-dp.
            RETURN "NOK".
        END. /* IF  CAN-FIND(FIRST ITEM */
    END. /* IF  RETURN-VALUE */
END. /* IF p-ind-event = "VALIDATE":U */

/*--------------------------------------------------------------------------------------------*/
/* procedures DE AJUDA */
PROCEDURE pi-mensagem: 
    MESSAGE "p-ind-event  = " p-ind-event               SKIP
            "p-ind-object = " p-ind-object              SKIP
            "p-wgh-object = " p-wgh-object:PRIVATE-DATA SKIP
            "p-wgh-frame  = " p-wgh-frame:NAME          SKIP
            "p-cod-table  = " p-cod-table               SKIP
            "p-row-table  = " STRING(p-row-table)       SKIP VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE pi-arq-eventos: 
    OUTPUT TO c:\temp\pontos.txt APPEND. 
    PUT p-ind-event               FORMAT "x(20)" SPACE(1)
        p-ind-object              FORMAT "x(20)" SPACE(1)
        p-wgh-object:PRIVATE-DATA FORMAT "x(20)" SPACE(1)
        p-wgh-frame:NAME          FORMAT "x(20)" SPACE(1)
        p-cod-table               FORMAT "x(20)" SPACE(1)
        STRING(p-row-table)       FORMAT "x(20)" SPACE(1) SKIP.
    OUTPUT CLOSE.
END PROCEDURE.
