/***********************************************************************
**  Programa..: UPC\ft0312-UPC.P
**  Autor.....: Anderson Cenci
**  Data......: Maráo/2010 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 01/03/2010
**                  Desenvolvimento Programa
************************************************************************/
DEF input param p-ind-event        as char          no-undo.
DEF input param p-ind-object       as char          no-undo.
DEF input param p-wgh-object       as handle        no-undo.
DEF input param p-wgh-frame        as widget-handle no-undo.
DEF input param p-cod-table        as char          no-undo.
DEF input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo AS WIDGET-HANDLE   NO-UNDO.

def NEW GLOBAL SHARED var wh-browse         as handle        no-undo.
def new global shared var wh-query           as widget-handle no-undo.
def new global shared var h-objeto           as widget-handle no-undo.
def new global shared var wh-buffer          as widget-handle no-undo.

define variable h-campo as handle  extent 10   no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

DEF VAR i-cont  AS INT NO-UNDO.
DEF VAR achou   AS INT NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-mensagem-ft0312      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-mensagem-ft0312      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-it-codigo-ft0312      AS WIDGET-HANDLE NO-UNDO.




DEF VAR h-objeto-aux AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl       AS HANDLE NO-UNDO.




 IF p-ind-event = "BEFORE-INITIALIZE":U  THEN DO: 

   CREATE TEXT tx-mensagem-ft0312
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(14)"
                       WIDTH        = 14
                       SCREEN-VALUE = "Mensagem:"
                       ROW          = 3.33
                       COL          = 73
                       VISIBLE      = YES.         
    
   CREATE FILL-IN wh-mensagem-ft0312
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "integer"
                       FORMAT            = ">>>>9"
                       WIDTH             = 5
                       HEIGHT            = 0.80
                       ROW               = 3.33
                       COL               = 82.09
                       VISIBLE           = YES
                       SENSITIVE         = NO
   TRIGGERS:
        ON F5 PERSISTENT RUN upc\ft0312-upca.p.
        ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN upc\ft0312-upca.p. 
   END TRIGGERS.   

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    
    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                WHEN "it-codigo" THEN DO:
                    ASSIGN wh-it-codigo-ft0312 = h-frame.
                END.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.
    
END.



IF VALID-HANDLE(tx-mensagem-ft0312) THEN
    ASSIGN tx-mensagem-ft0312:VISIBLE = TRUE. 

IF p-ind-event = "after-enable" THEN DO:
   ASSIGN wh-mensagem-ft0312:SENSITIVE = TRUE.
   ASSIGN tx-mensagem-ft0312:SCREEN-VALUE = "Mensagem:".
           
END.
ELSE IF p-ind-event = "after-disable" THEN DO:
     ASSIGN wh-mensagem-ft0312:SENSITIVE = FALSE.
     ASSIGN tx-mensagem-ft0312:SCREEN-VALUE = "Mensagem:".
END.
ELSE IF p-ind-event = "display" THEN DO:
        ASSIGN tx-mensagem-ft0312:SCREEN-VALUE = "Mensagem:".
        FIND FIRST icms-it-uf WHERE
             ROWID(icms-it-uf) = p-row-table NO-ERROR.
    
        FIND FIRST int-icms-it-uf 
             WHERE int-icms-it-uf.estado    = icms-it-uf.estado
               AND int-icms-it-uf.it-codigo = icms-it-uf.it-codigo
             NO-LOCK NO-ERROR.
    
        IF AVAIL int-icms-it-uf THEN DO:
           ASSIGN wh-mensagem-ft0312:SCREEN-VALUE = string(int-icms-it-uf.cod-mensagem).
        END.
        ELSE
            ASSIGN wh-mensagem-ft0312:SCREEN-VALUE = "".
    END.
    ELSE IF p-ind-event = "assign" THEN DO:
            IF  int(wh-mensagem-ft0312:SCREEN-VALUE)  <> 0 THEN DO:
                FIND mensagem
                     WHERE mensagem.cod-mensagem = int(wh-mensagem-ft0312:SCREEN-VALUE)  
                     NO-LOCK NO-ERROR.
                IF NOT AVAIL mensagem THEN DO:
                    MESSAGE "Codigo de Mensagem Informado n∆o cadastrado, verifique no programa cd0405"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK":U.
                END.
            END.

           /* comentado chamado c2203-0216
           
            IF VALID-HANDLE(wh-it-codigo-ft0312) AND
               wh-it-codigo-ft0312:SCREEN-VALUE = "" THEN DO:
                MESSAGE "Codigo do item deve ser diferente de branco"
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                APPLY "entry" TO wh-it-codigo-ft0312.
                RETURN "NOK":U.
            END. */


            FIND FIRST icms-it-uf WHERE
                 ROWID(icms-it-uf) = p-row-table NO-ERROR.
        
            FIND FIRST int-icms-it-uf 
                 WHERE int-icms-it-uf.estado    = icms-it-uf.estado
                   AND int-icms-it-uf.it-codigo = icms-it-uf.it-codigo
                 EXCLUSIVE-LOCK NO-ERROR.
        
            IF NOT AVAIL int-icms-it-uf THEN DO:
               CREATE int-icms-it-uf.
               assign int-icms-it-uf.estado    = icms-it-uf.estado
                      int-icms-it-uf.it-codigo = icms-it-uf.it-codigo.
            END.
            ASSIGN int-icms-it-uf.cod-mensagem = int(wh-mensagem-ft0312:SCREEN-VALUE)  .
         END.


PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.
