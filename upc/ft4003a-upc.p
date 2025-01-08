/* ---------------------------------------------------------------------------
Programa : ft4003a-upc.p
Autor    : Roger Marcelino Bruhn
Data     : 08/2016
Alteraá∆o:
--------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS ROWID            NO-UNDO.


DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-ft4003a-upc      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-ft4003a-btok     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-upc       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-canal-venda-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-dt-emis-nota-ft4003a AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-estabel-ft4003a AS HANDLE NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    IF  NOT VALID-HANDLE(h-ft4003a-upc) THEN
        RUN upc/ft4003a-upc.p PERSISTENT SET h-ft4003a-upc(INPUT "",            
                                                           INPUT "",            
                                                           INPUT p-wgh-object,  
                                                           INPUT p-wgh-frame,   
                                                           INPUT "",            
                                                           INPUT p-row-table).
END.


IF  p-ind-event = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(h-object):
        IF  h-object:TYPE <> "field-group" THEN DO:

            IF  h-object:NAME = 'BtOK'    THEN 
                ASSIGN h-ft4003a-btok = h-object.

            IF  h-object:NAME = 'cod-canal-venda'   THEN
                ASSIGN wh-canal-venda-upc = h-object.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    RUN tela-upc (INPUT p-wgh-frame,                                                               
                  INPUT p-ind-event,                                                              
                  INPUT "FILL-IN",                /*** Type ***/                                             
                  INPUT "dt-emis-nota",           /*** NOME DO CAMPO DESEJADO ***/                                             
                  INPUT NO,                       /*** Apresenta Mensagem dos Objetos ***/                   
                  INPUT 1,                        /*** Quando existir mais de um objeto com o mesmo nome ***/ 
                  OUTPUT wgh-dt-emis-nota-ft4003a).

    RUN tela-upc (INPUT p-wgh-frame,                                                               
                  INPUT p-ind-event,                                                              
                  INPUT "FILL-IN",                /*** Type ***/                                             
                  INPUT "cod-estabel",           /*** NOME DO CAMPO DESEJADO ***/                                             
                  INPUT NO,                       /*** Apresenta Mensagem dos Objetos ***/                   
                  INPUT 1,                        /*** Quando existir mais de um objeto com o mesmo nome ***/ 
                  OUTPUT wgh-cod-estabel-ft4003a).
   
    IF  VALID-HANDLE (h-ft4003a-btok) THEN DO:

        CREATE BUTTON wh-bt-ok-upc
            ASSIGN FRAME        = p-wgh-frame
                   WIDTH        = h-ft4003a-btok:WIDTH
                   HEIGHT       = h-ft4003a-btok:HEIGHT
                   ROW          = h-ft4003a-btok:ROW
                   LABEL        = "OK"
                   COLUMN       = h-ft4003a-btok:COLUMN
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   TOOLTIP      = 'OK'
                TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-valida IN h-ft4003a-upc.
                END TRIGGERS.
    END.
END.

IF  p-ind-event = "AFTER-DESTROY-INTERFACE" THEN 
    ASSIGN h-ft4003a-upc = ?.

PROCEDURE pi-valida:

    
    IF  VALID-HANDLE (wh-canal-venda-upc) 
    AND wh-canal-venda-upc:SCREEN-VALUE = "12" THEN DO:
        RUN utp/ut-msgs ("show",
                         17006,
                         "Canal de venda 12 n∆o Ç permitido atravÇs deste programa. ").
        RETURN "OK".

    END.

    IF  VALID-HANDLE(wgh-dt-emis-nota-ft4003a)
    AND VALID-HANDLE(wgh-cod-estabel-ft4003a) THEN DO:

        IF date(wgh-dt-emis-nota-ft4003a:SCREEN-VALUE) > TODAY THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de faturamento n∆o pode ser maior que a Data atual!~~Data de Emiss∆o da Nota Fiscal deve ser " + STRING(TODAY,"99/99/9999")).
            APPLY "ENTRY" TO wgh-dt-emis-nota-ft4003a.
            RETURN "NOK".
        END.
        ELSE DO:
           IF date(wgh-dt-emis-nota-ft4003a:SCREEN-VALUE) <> TODAY THEN DO:
               FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
               IF AVAIL bloqueio-fat THEN DO:
                   IF LOOKUP(wgh-cod-estabel-ft4003a:SCREEN-VALUE,bloqueio-fat.estab-fatcom) = 0 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                          INPUT 17006,
                                          INPUT "Data de faturamento Ç diferente da Data de Emiss∆o da Nota Fiscal!~~Data de Emiss∆o da Nota Fiscal deve ser " + STRING(TODAY,"99/99/9999")).
                       APPLY "ENTRY" TO wgh-dt-emis-nota-ft4003a.
                       RETURN "OK".
                   END.
               END.
           END.
        END.
    END.
    APPLY "choose" TO h-ft4003a-btok.

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
