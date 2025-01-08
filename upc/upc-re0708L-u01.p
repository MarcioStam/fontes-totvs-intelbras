/******************************************************************
** Programa: upc-re0708L-u01.p
** Objetivo: CRIAR button falseo
**    Autor: 
**     Data: abr/2023
*******************************************************************/
/* parametros */
DEF INPUT PARAM p-ind-event  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR           NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE         NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID          NO-UNDO.

{utp/ut-glob.i}

function fc-handle-obj RETURN character (p-obj as char, p-frame as widget-handle):

def var wh-objeto as widget-handle no-undo.

wh-objeto = p-frame:first-child.


do while valid-handle(wh-objeto):

   if wh-objeto:type = "field-group" then do:
      p-obj = fc-handle-obj(p-obj,wh-objeto).
   end. 

   if wh-objeto:type = "frame" then do:
      p-obj = fc-handle-obj(p-obj,wh-objeto).
   end. 
   if lookup(wh-objeto:name,p-obj) <> 0 and
      lookup(wh-objeto:name,p-obj) <> ? then do:
      entry(lookup(wh-objeto:name,p-obj),p-obj) = string(wh-objeto:handle).
   end.   

   wh-objeto = wh-objeto:next-sibling.

end.

return p-obj.

end function.


/* variaveis dos objetos */
DEF NEW GLOBAL SHARED VAR wh-re0708L-btReprocessa2        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-btReprocessa2-f      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-browse-brTable2      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fpage1               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-btAtualiza           AS WIDGET-HANDLE NO-UNDO.

/* variaveis comuns */
DEF VAR c-handle-obj AS CHAR NO-UNDO.
DEF VAR c-folder     AS CHAR NO-UNDO.

/* Variable Definitions *****************************************************/
DEF VAR c-objects       AS CHARACTER NO-UNDO.
DEF VAR h_object        AS HANDLE    NO-UNDO.
DEF VAR h-child         AS HANDLE    NO-UNDO.
DEF VAR i-objects       AS INTEGER   NO-UNDO.
DEF VAR l-record        AS LOGICAL   NO-UNDO INIT NO.
DEF VAR l-group-assign  AS LOGICAL   NO-UNDO INIT NO.
DEF VAR i_objects       AS INT       NO-UNDO.

/* include de funcao usada para buscar objetos na tela */
    
/* pegando os handles dos objetos */
    
//RUN pi-mensagem.

//RUN pi-arq-eventos. 

IF p-ind-event  = "AFTER-ENABLE" AND 
   p-ind-object = "CONTAINER"  THEN DO:

   c-handle-obj = fc-handle-obj("fpage1,btAtualiza", p-wgh-frame).
   ASSIGN wh-re0708L-fpage1      = WIDGET-HANDLE(ENTRY(1,c-handle-obj)) 
          wh-re0708L-btAtualiza  = WIDGET-HANDLE(ENTRY(2,c-handle-obj))  NO-ERROR.

   c-handle-obj = fc-handle-obj("btGeraFiscal,brTable1", wh-re0708L-fpage1).

    /* alimentando as variaveis com os handles dos objetos */
   ASSIGN wh-re0708L-btReprocessa2   = WIDGET-HANDLE(ENTRY(1,c-handle-obj)) 
          wh-re0708L-browse-brTable2 = WIDGET-HANDLE(ENTRY(2,c-handle-obj)) NO-ERROR.   


   IF VALID-HANDLE(wh-re0708L-btReprocessa2) THEN DO:

        CREATE BUTTON wh-re0708L-btReprocessa2-f
        ASSIGN  FRAME       = wh-re0708L-btReprocessa2:FRAME
                TOOLTIP     = wh-re0708L-btReprocessa2:TOOLTIP
                LABEL       = wh-re0708L-btReprocessa2:LABEL
                WIDTH       = wh-re0708L-btReprocessa2:WIDTH
                HEIGHT      = wh-re0708L-btReprocessa2:HEIGHT
                COL         = wh-re0708L-btReprocessa2:COLUMN
                ROW         = wh-re0708L-btReprocessa2:ROW   /* + 0.5 */  
                VISIBLE     = wh-re0708L-btReprocessa2:VISIBLE     
                SENSITIVE   = wh-re0708L-btReprocessa2:SENSITIVE. 

        wh-re0708L-btReprocessa2-f:MOVE-TO-TOP( ). 
        ON CHOOSE OF wh-re0708L-btReprocessa2-f PERSISTENT RUN upc/upc-re0708L-u02.p.
   END.
END. 

/*.....................................................................................................*/           

/* procedures */
PROCEDURE pi-mensagem: 
    MESSAGE "p-ind-event  = " p-ind-event               SKIP
            "p-ind-object = " p-ind-object              SKIP
            "p-wgh-object = " p-wgh-object:PRIVATE-DATA SKIP
            "p-wgh-frame  = " p-wgh-frame:NAME          SKIP
            "p-cod-table  = " p-cod-table               SKIP
            "p-row-table  = " STRING(p-row-table)       SKIP VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE pi-arq-eventos: 
    OUTPUT TO c:\temp\pontos-cd0708L.txt APPEND. 
    PUT p-ind-event               FORMAT "x(20)" SPACE(1)
        p-ind-object              FORMAT "x(20)" SPACE(1)
        p-wgh-object:PRIVATE-DATA FORMAT "x(20)" SPACE(1)
        p-wgh-frame:NAME          FORMAT "x(20)" SPACE(1)
        p-cod-table               FORMAT "x(20)" SPACE(1)
        STRING(p-row-table)       FORMAT "x(20)" SPACE(1) SKIP.
    OUTPUT CLOSE.

END PROCEDURE.
                

RETURN "OK".
