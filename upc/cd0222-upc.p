/****************************************************************************
** Programa : CD0222-UPC
** Descricao: Inclusao de coluna % Desconto (PROD-COMPOSTO.DEC-1)
**     Autor: Isac Abrahao
**      Data: 24/08/2021
*****************************************************************************/
/***  Parametros de recepao da UPC **/

DEF INPUT PARAM p-ind-event      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR            NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE          NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE   NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID           NO-UNDO.

DEF VAR wh-objeto AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-objeto   AS CHAR         NO-UNDO.

/***  identificando nome de objeto ***/
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/") ,p-wgh-object:FILE-NAME, "~/"). 

/*
message "Evento    " p-ind-event  skip        
        "Objeto    " p-ind-object skip        
        "nome obj  " c-objeto     skip        
        "Frame     " p-wgh-frame  skip        
        "Tabela    " p-cod-table  skip        
        "ROWID     " string(p-row-table) SKIP 
        view-as alert-box information.   */

DEF NEW GLOBAL SHARED VAR wh-query-brw-cd0222    AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-browse-cd0222       AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-buffer-brw-cd0222   AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-col-desconto-cd0222 AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR rw-table-cd0222         AS ROWID NO-UNDO.

/******** Inicio ********/

IF p-ind-event  = "DISPLAY" AND 
   p-ind-object = "VIEWER"  THEN DO:
   ASSIGN rw-table-cd0222 = p-row-table.
END.


IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "BROWSER"    THEN DO:

   IF NOT VALID-HANDLE(wh-objeto) THEN DO:

      RUN busca-handle(INPUT 'br-table',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).

      IF VALID-HANDLE(wh-objeto) THEN DO:
          wh-browse-cd0222 = wh-objeto:HANDLE.
    
          wh-browse-cd0222:HANDLE:ADD-CALC-COLUMN('DECIMAL','>>9.99','','% Desconto',5).
    
          wh-col-desconto-cd0222       = wh-browse-cd0222:GET-BROWSE-COLUMN(5).
          wh-col-desconto-cd0222:WIDTH = 10. 
    
          wh-query-brw-cd0222 = wh-browse-cd0222:QUERY.
          
          on "row-display" OF wh-browse-cd0222 persistent run upc/cd0222-upc.p ('Row-Display-br-cd0222', 
                                                                                 p-ind-object,
                                                                                 p-wgh-object,
                                                                                 p-wgh-frame, 
                                                                                 p-cod-table, 
                                                                                 p-row-table).
      END.                                                                                    
   END.
END.


IF p-ind-event = 'Row-Display-br-cd0222' THEN DO:

   IF VALID-HANDLE(wh-query-brw-cd0222)    AND 
      VALID-HANDLE(wh-col-desconto-cd0222) THEN DO:

      FIND ITEM WHERE ROWID(ITEM) = rw-table-cd0222 NO-LOCK NO-ERROR.

      IF AVAIL ITEM THEN DO:
         ASSIGN wh-buffer-brw-cd0222 = wh-query-brw-cd0222:GET-BUFFER-HANDLE(1).
    
         FIND FIRST prod-composto WHERE prod-composto.it-codigo-pai   = ITEM.it-codigo
                                    AND prod-composto.it-codigo-filho = wh-buffer-brw-cd0222:Buffer-field("it-codigo-filho"):BUFFER-VALUE 
                                    AND prod-composto.cod-refer       = wh-buffer-brw-cd0222:Buffer-field("cod-refer"):BUFFER-VALUE   
         NO-LOCK NO-ERROR.

         IF AVAIL prod-composto THEN
            ASSIGN wh-col-desconto-cd0222:SCREEN-VALUE = STRING(prod-composto.dec-1).
      END.
   END.
END.


PROCEDURE busca-handle:

   DEF INPUT  PARAM p-nome     AS CHAR.
   DEF INPUT  PARAM p-frame    AS WIDGET-HANDLE.
   DEF OUTPUT PARAM p-object   AS WIDGET-HANDLE.
   DEF VAR h-frame             AS WIDGET-HANDLE.

   DEF VAR wh-objeto           AS WIDGET-HANDLE.
   
   ASSIGN h-frame = p-frame:FIRST-CHILD.

   DO WHILE VALID-HANDLE(h-frame):

      IF h-frame:TYPE <> "field-group" THEN DO: 

          IF h-frame:NAME = p-nome THEN DO:
              ASSIGN p-object = h-frame.
              LEAVE.
          END.

          ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE
          ASSIGN h-frame = h-frame:FIRST-CHILD.
   END.

END PROCEDURE.





