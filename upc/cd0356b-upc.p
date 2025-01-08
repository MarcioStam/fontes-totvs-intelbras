/***********************************************************************
**  Programa..: upc\cd0603-upc.p
**  Autor.....: Clayton Antunes
**  Data......: setembro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-frame            AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-cd0356b-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button     AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-cd0356b-espec                 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0356b-OK-espec              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0356b-Save-espec            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cd0356b          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btOK-cd0356b         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btSave-cd0356b       AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-c-uf-dest           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-natur-operac    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-ncm             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-item            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cdn-emitente        AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0356b-upc.p PERSISTENT SET h-cd0356b-upc(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table). 
END.


IF  p-ind-event  = "AFTER-INITIALIZE" AND
    p-ind-object = "CONTAINER"  THEN DO:    
    
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    do while valid-handle(h-frame): 
       
       if  h-frame:type = "button" and h-frame:name = "btOK" then
           h-btOK-cd0356b = h-frame.

       if  h-frame:type = "button" and h-frame:name = "btSave" then
           h-btSave-cd0356b = h-frame.

       IF h-frame:TYPE = "fill-in" AND h-frame:NAME = "c-uf-dest" THEN
           wh-c-uf-dest = h-frame.

       IF h-frame:TYPE = "fill-in" AND h-frame:NAME = "cod-natur-operac" THEN
           wh-cod-natur-operac = h-frame.

       IF h-frame:TYPE = "fill-in" AND h-frame:NAME = "cod-ncm" THEN
           wh-cod-ncm = h-frame.

       IF h-frame:TYPE = "fill-in" AND h-frame:NAME = "cod-item" THEN
           wh-cod-item = h-frame.

       IF h-frame:TYPE = "fill-in" AND h-frame:NAME = "cdn-emitente" THEN
          wh-cdn-emitente = h-frame.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:FIRST-CHILD.
    end.  

    if  /*h-frame:type = "button" and h-frame:name = "btfirst"*/
        valid-handle( h-btOK-cd0356b) then do:

        create button wh-cd0356b-OK-espec
        assign frame     = h-btOK-cd0356b:FRAME 
               width     = h-btOK-cd0356b:WIDTH 
               height    = h-btOK-cd0356b:height
               row       = h-btOK-cd0356b:row   
               col       = h-btOK-cd0356b:COL 
               visible   = yes
               sensitive = yes
               tooltip   = "OK"
               LABEL     = "OK".

       ON "CHOOSE" OF wh-cd0356b-OK-espec PERSISTENT RUN pi-bt-ok IN h-cd0356b-upc.

        create button wh-cd0356b-Save-espec
        assign frame     = h-btSave-cd0356b:FRAME 
               width     = h-btSave-cd0356b:WIDTH 
               height    = h-btSave-cd0356b:height
               row       = h-btSave-cd0356b:row   
               col       = h-btSave-cd0356b:COL 
               visible   = yes
               sensitive = yes
               tooltip   = "Salvar"
               LABEL     = "Salvar".

       ON "CHOOSE" OF wh-cd0356b-Save-espec PERSISTENT RUN pi-bt-save IN h-cd0356b-upc.
    
        h-btOK-cd0356b:VISIBLE = NO.
        h-btSave-cd0356b:VISIBLE = NO.
    END. 

   /* IF p-wgh-frame:NAME = "f-main"  THEN DO:
        ON "CHOOSE" OF wh-cd0356b-Save-espec PERSISTENT RUN pi-bt-save IN h-cd0356b-upc.
        ON "CHOOSE" OF wh-cd0356b-OK-espec PERSISTENT RUN pi-bt-ok IN h-cd0356b-upc.
    END. */
END.

PROCEDURE pi-bt-ok:
     
    IF wh-cod-item:SCREEN-VALUE = "*" OR wh-c-uf-dest:SCREEN-VALUE = "*" OR wh-cod-ncm:SCREEN-VALUE = "*   .  ." THEN DO:
        MESSAGE "N∆o Ç permitido gravar um registro generico, favor revisar as informaáoes digitadas"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.

    APPLY "choose":U TO h-btOK-cd0356b.

END PROCEDURE.

PROCEDURE pi-bt-save:
    
    IF wh-cod-item:SCREEN-VALUE = "*" OR wh-c-uf-dest:SCREEN-VALUE = "*" OR wh-cod-ncm:SCREEN-VALUE = "*" THEN DO:
        MESSAGE "N∆o Ç permitido gravar um registro generico, favor revisar as informaáoes digitadas"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.

    APPLY "choose":U TO h-btSave-cd0356b.

END PROCEDURE.

/*    
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
                    "P-Ind-Event"    pIndEvent  SKIP
            wgh-obj:SCREEN-VALUE VIEW-AS ALERT-BOX.  

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
    

PROCEDURE tela-upc-literal:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjScreen     AS CHARACTER     NO-UNDO.
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
                    "P-Ind-Event"    pIndEvent  SKIP
            wgh-obj:SCREEN-VALUE VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:SCREEN-VALUE = pObjScreen THEN DO:
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


PROCEDURE pi-calcula-volume:
       /* IF VALID-HANDLE(wh-de-volume) THEN DO:
            ASSIGN wh-de-volume:SCREEN-VALUE = string(DEC(wh-altura:SCREEN-VALUE) * DEC(wh-largura:SCREEN-VALUE) * DEC(wh-comprimento:SCREEN-VALUE) / 1000000000).
        END. */

    MESSAGE "calculo volume"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END PROCEDURE.

*/
