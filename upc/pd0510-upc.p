/**********************************************************************************
**  Programa..: upc\FT0708-upc.p
**  Autor.....: Roger
**  Data......: JANEIRO/2015 - Desenvolvimento
**  Descricao.: BLOQUEAR A ELIMINA€ÇO DO SUMµRIO PARA USUµRIOS SEM PERMISSÇO
**              OU SE Jµ EXISTIREM MOVIMENTOS CONTµBEIS PARA A SELE€ÇO INFORMADA.    
***********************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.


DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
define new global shared var wh-cod-estabel-ft0502      as widget-handle no-undo.
define new global shared var wh-serie-ft0502      as widget-handle no-undo.
define new global shared var wh-nr-nota-fis-ft0502      as widget-handle no-undo.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-i-pri-ini AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rs-execucao AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-image-1   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estab-ini AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estab-fim AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-image-ini AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-image-fim AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-pd0510-upc AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-estab AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-objeto   AS CHAR     NO-UNDO.

IF VALID-HANDLE(p-wgh-object) THEN
   assign c-objeto = entry(num-entries(p-wgh-object:private-data, "/"), p-wgh-object:private-data, "/").

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    
    RUN upc/pd0510-upc.p PERSISTENT SET h-pd0510-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-pd0510-upc) THEN
        DELETE PROCEDURE h-pd0510-upc.


IF  p-ind-object = "Container" 
AND p-ind-event = "change-page"
AND p-wgh-frame:NAME = "f-pg-sel" THEN DO:
    IF  VALID-HANDLE(wh-i-pri-ini) THEN
         APPLY "entry" TO wh-estab-ini.
END.

IF  p-ind-object = "Container" 
AND p-ind-event = "change-page"
AND p-wgh-frame:NAME = "f-pg-sel"
AND NOT VALID-HANDLE(wh-i-pri-ini) THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "i-pri-ini",
                     OUTPUT wh-i-pri-ini).
    
    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "image-1",
                     OUTPUT wh-image-1).

    IF  VALID-HANDLE (wh-i-pri-ini) THEN DO:
        CREATE TEXT wh-txt-estab
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(9)"   
               WIDTH        = 4.43
               HEIGHT       = 0.54
               SCREEN-VALUE = "Estab:"
               ROW          = 2.63
               COL          = 17.24
               VISIBLE      = YES.

        create FILL-IN   wh-estab-ini                        
        assign frame     = p-wgh-frame                             
               FORMAT    = "X(5)"
               width     = 6.14                
               height    = 0.88                 
               row       = 2.45                 
               col       = 21.86                     
               visible   = yes                                     
               sensitive = yes                                     
               tooltip   = "".

        create FILL-IN   wh-estab-fim                       
        assign frame     = p-wgh-frame     
               FORMAT    = "X(5)"
               width     = 6.14                
               height    = 0.88                 
               row       = 2.46                
               col       = 53
               visible   = yes                                     
               sensitive = yes                                     
               tooltip   = "".      

        ASSIGN wh-estab-fim:SCREEN-VALUE = "ZZZZZ".

        create IMAGE   wh-image-ini                      
        assign frame     = p-wgh-frame   
               width     = 3                
               height    = 0.88                 
               row       = 2.46
               col       = 42.14
               visible   = yes                                     
               sensitive = yes                                     
               tooltip   = "". 

         wh-image-ini:LOAD-IMAGE ("image\im-fir.bmp").

        create IMAGE   wh-image-fim                      
        assign frame     = p-wgh-frame   
               width     = 3                
               height    = 0.88                 
               row       = 2.46
               col       = 50
               visible   = yes                                     
               sensitive = yes                                     
               tooltip   = "". 

         wh-image-fim:LOAD-IMAGE ("image\im-las.bmp").
    END.
    
END.

IF  p-ind-object = "Container" 
AND p-ind-event = "change-page"
AND p-wgh-frame:NAME = "f-pg-imp" THEN DO:


    IF  NOT VALID-HANDLE(wh-rs-execucao) THEN DO:
        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "rs-execucao",
                         OUTPUT wh-rs-execucao).
    END.
    ELSE DO:
        IF  wh-estab-ini:SCREEN-VALUE <> "" 
        OR  wh-estab-fim:SCREEN-VALUE <> "ZZZZZ" THEN
            wh-rs-execucao:SENSITIVE = NO.
        ELSE
            wh-rs-execucao:SENSITIVE = YES.
    END.

END.


IF  p-ind-event = "initialize" 
AND VALID-HANDLE (wh-estab-ini) THEN DO:
    wh-estab-fim:MOVE-BEFORE-TAB-ITEM(wh-i-pri-ini).
    wh-estab-ini:MOVE-BEFORE-TAB-ITEM(wh-estab-fim).
    APPLY "entry" TO wh-estab-ini.
END.

if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
end.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame-aux  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame-aux.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

PROCEDURE pi-habilita:


        

END.
