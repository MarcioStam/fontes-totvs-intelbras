/* parametros */

DEF INPUT PARAMETER c-it-codigo AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER c-ativo AS LOGICAL NO-UNDO.
DEF OUTPUT PARAMETER c-itemob AS CHAR NO-UNDO. 

ASSIGN c-ativo = YES
       c-itemob = "". 

FIND FIRST ITEM WHERE ITEM.it-codigo = c-it-codigo
                        NO-LOCK NO-ERROR.
IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
    ASSIGN c-ativo = NO
           c-itemob = ITEM.it-codigo. 
          
    RETURN "NOK".
END.

RUN pi-looping (INPUT c-it-codigo).

PROCEDURE pi-looping:
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF VAR c-item AS CHAR NO-UNDO.

    ASSIGN c-item = p-it-codigo.
    
    FOR EACH estrutura
       WHERE estrutura.it-codigo = c-item NO-LOCK:
        
        IF estrutura.data-termino < TODAY THEN NEXT.

        FIND FIRST ITEM WHERE ITEM.it-codigo = estrutura.es-codigo
                        NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
            ASSIGN c-ativo = NO
                   c-itemob = estrutura.es-codigo. 
            
            RETURN "NOK".
        END.
        
        RUN pi-looping (INPUT estrutura.es-codigo).
    END.
    RETURN "OK".
END PROCEDURE.
