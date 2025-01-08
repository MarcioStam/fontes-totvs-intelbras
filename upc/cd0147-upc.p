/***********************************************************************
**  Programa..: UPC\CD0147-UPC.P
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

DEF NEW GLOBAL SHARED VAR tx-mensagem-cd0147      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-mensagem-cd0147      AS WIDGET-HANDLE NO-UNDO.


DEF VAR h-objeto-aux AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl       AS HANDLE NO-UNDO.




 IF p-ind-event = "BEFORE-INITIALIZE":U  THEN DO: 

   CREATE TEXT tx-mensagem-cd0147
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(14)"
                       WIDTH        = 14
                       SCREEN-VALUE = "Mensagem:"
                       ROW          = 9
                       COL          = 63
                       VISIBLE      = YES.         
    
   CREATE FILL-IN wh-mensagem-cd0147
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "integer"
                       FORMAT            = ">>>>9"
                       WIDTH             = 5
                       HEIGHT            = 0.80
                       ROW               = 9
                       COL               = 72.09
                       VISIBLE           = YES
                       SENSITIVE         = NO
   TRIGGERS:
        ON F5 PERSISTENT RUN upc\cd0147-upca.p.
        ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN upc\cd0147-upca.p. 
   END TRIGGERS.               

    
END.




IF VALID-HANDLE(tx-mensagem-cd0147) THEN
    ASSIGN tx-mensagem-cd0147:VISIBLE = TRUE
           tx-mensagem-cd0147:SCREEN-VALUE = "Mensagem:".

IF p-ind-event = "after-enable" THEN DO:
   ASSIGN wh-mensagem-cd0147:SENSITIVE = TRUE.
   ASSIGN tx-mensagem-cd0147:SCREEN-VALUE = "Mensagem:".
           
END.
ELSE IF p-ind-event = "after-disable" THEN DO:
     ASSIGN wh-mensagem-cd0147:SENSITIVE = FALSE.
     ASSIGN tx-mensagem-cd0147:SCREEN-VALUE = "Mensagem:".
END.
ELSE IF p-ind-event = "after-display" THEN DO:
        ASSIGN tx-mensagem-cd0147:SCREEN-VALUE = "Mensagem:".
        FIND FIRST item-uni-estab WHERE
             ROWID(item-uni-estab) = p-row-table NO-ERROR.
    
        FIND FIRST int-item-uni-estab
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo
             NO-LOCK NO-ERROR.
    
        IF AVAIL int-item-uni-estab THEN DO:
           ASSIGN wh-mensagem-cd0147:SCREEN-VALUE = string(int-item-uni-estab.cod-mensagem).
        END.
        ELSE
            ASSIGN wh-mensagem-cd0147:SCREEN-VALUE = "".
    END.
    ELSE IF p-ind-event = "after-assign" THEN DO:
            FIND FIRST item-uni-estab WHERE
                 ROWID(item-uni-estab) = p-row-table NO-ERROR.

            IF  int(wh-mensagem-cd0147:SCREEN-VALUE)  <> 0 THEN DO:
                FIND mensagem
                     WHERE mensagem.cod-mensagem = int(wh-mensagem-cd0147:SCREEN-VALUE)  
                     NO-LOCK NO-ERROR.
                IF NOT AVAIL mensagem THEN DO:
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17567,
                                       INPUT "Codigo de Mensagem Informado n∆o cadastrado, verifique no programa cd0405" ).
                    FIND FIRST int-item-uni-estab 
                         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo
                         no-LOCK NO-ERROR.

                    IF AVAIL INT-item-uni-estab THEN
                       ASSIGN wh-mensagem-cd0147:SCREEN-VALUE = string(int-item-uni-estab.cod-mensagem).
                    ELSE
                       ASSIGN wh-mensagem-cd0147:SCREEN-VALUE = "0".
                    
                    RETURN "NOK":U.
                END.
            END.
        
            FIND FIRST int-item-uni-estab 
                 WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                   AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo
                 EXCLUSIVE-LOCK NO-ERROR.
        
            IF NOT AVAIL int-item-uni-estab THEN DO:
               CREATE int-item-uni-estab.
               assign int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                      int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo.
            END.
            ASSIGN int-item-uni-estab.cod-mensagem = int(wh-mensagem-cd0147:SCREEN-VALUE)  .
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
