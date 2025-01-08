/***********************************************************************
**  Programa..: upc\cd0606-epc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 
************************************************************************/

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

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VARIABLE r-row-id-natur-oper AS ROWID NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button-upc-cd0606      AS WIDGET-HANDLE    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage0-cd0606      AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-cd0606      AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-esp-acr-cd0606 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-cod-esp-apb-cd0606 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-esp-apb-cd0606 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-observacao-cd0606  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-cons-averb-seg-cd0606  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-observacao-cd0606  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-tipo-cd0606     AS WIDGET-HANDLE   NO-UNDO.


DEF NEW GLOBAL SHARED VAR h-upc-cd0606           AS WIDGET-HANDLE NO-UNDO.

ASSIGN r-row-id-natur-oper = p-row-table.

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0606-upc.p PERSISTENT SET h-upc-cd0606(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).
END.

IF p-ind-event = "destroy" AND VALID-HANDLE(h-upc-cd0606) THEN
    DELETE PROCEDURE h-upc-cd0606.


if  p-ind-event  = "AFTER-INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    create button wh-button-upc-cd0606  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.10       
           col       = 60.32       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             on choose persistent run upc/cd0606a-upc.w  .
           end triggers.
  if wh-button-upc-cd0606:load-image("image/gr-lay.bmp") then.
end.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "combo-box",       /*** Type ***/
                  INPUT "cb-tipo",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cb-tipo-cd0606).

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-cd0606).

    IF VALID-HANDLE(wh-fpage1-cd0606) THEN DO:

        RUN tela-upc (INPUT wh-fpage1-cd0606,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",       /*** Type ***/
                      INPUT "cod-esp",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-esp-acr-cd0606).

        ASSIGN wh-cod-esp-acr-cd0606:LABEL = "Esp‚cie ACR".
    
        CREATE TEXT tx-cod-esp-apb-cd0606
        ASSIGN FRAME        = wh-fpage1-cd0606
               FORMAT       = "x(16)"   
               WIDTH        = 16
               SCREEN-VALUE = "Esp‚cie APB:"
               ROW          = wh-cod-esp-acr-cd0606:ROW + 0.15
               COL          = wh-cod-esp-acr-cd0606:COL + 40.20
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-cod-esp-apb-cd0606
        ASSIGN FRAME             = wh-fpage1-cd0606
               DATA-TYPE         = "character"
               FORMAT            = "x(02)"
               WIDTH             = wh-cod-esp-acr-cd0606:WIDTH-CHARS
               HEIGHT            = wh-cod-esp-acr-cd0606:HEIGHT-CHARS
               ROW               = wh-cod-esp-acr-cd0606:ROW
               COL               = wh-cod-esp-acr-cd0606:COL + 50.20
               VISIBLE           = YES
               SENSITIVE         = NO
        TRIGGERS:
           ON "LEAVE":U PERSISTENT RUN pi-leave-cod-esp-apb IN h-upc-cd0606.
           ON "F5":U PERSISTENT RUN upc/cd0606-upczoom.p.
           ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/cd0606-upczoom.p.
        END TRIGGERS.

        wh-cod-esp-apb-cd0606:LOAD-MOUSE-POINTER('image/lupa.cur').

        CREATE TEXT tx-observacao-cd0606
        ASSIGN FRAME        = wh-fpage1-cd0606
               FORMAT       = "x(16)"   
               WIDTH        = 16
               SCREEN-VALUE = "Observa‡Æo:"
               ROW          = wh-cod-esp-acr-cd0606:ROW - 8 + 0.15
               COL          = wh-cod-esp-acr-cd0606:COL + 31.20
               VISIBLE      = YES.
    
        CREATE COMBO-BOX wh-observacao-cd0606
        ASSIGN FRAME             = wh-fpage1-cd0606
               DATA-TYPE         = "character"
               WIDTH             = 16
               ROW               = wh-cod-esp-acr-cd0606:ROW - 8
               COL               = wh-cod-esp-acr-cd0606:COL + 40.20
               VISIBLE           = YES
               INNER-LINES       = 4
               FONT              = 1
               LIST-ITEM-PAIRS   = "Ind£stria,1,Com‚rcio,2,Devolu‡Æo Cliente,3,Servi‡os,4"
               SCREEN-VALUE     = "1".

        CREATE TOGGLE-BOX wh-tg-cons-averb-seg-cd0606
        ASSIGN FRAME        = wh-fpage1-cd0606
               WIDTH        = 24
               HEIGHT       = 0.83
               ROW          = wh-cod-esp-acr-cd0606:ROW - 7
               LABEL        = "Considera Averba‡Æo Seguro"
               COLUMN       = 57
               SENSITIVE    = NO
               VISIBLE      = YES
               CHECKED      = NO.
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" THEN DO:

    ASSIGN wh-cod-esp-apb-cd0606:SENSITIVE = YES
           wh-tg-cons-averb-seg-cd0606:SENSITIVE = YES
           wh-observacao-cd0606:SENSITIVE  = IF wh-cb-tipo-cd0606:SCREEN-VALUE = "Entrada" THEN YES ELSE NO.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISABLE" THEN DO:

    ASSIGN wh-cod-esp-apb-cd0606:SENSITIVE = NO
           wh-tg-cons-averb-seg-cd0606:SENSITIVE = NO
           wh-observacao-cd0606:SENSITIVE = NO.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-CONTROL-TOOL-BAR" THEN DO:

    IF VALID-HANDLE(wh-cod-esp-apb-cd0606)      AND 
       p-row-table <> ?                         AND 
       p-cod-table = "natur-oper" THEN DO:

        ASSIGN wh-cod-esp-apb-cd0606:SCREEN-VALUE = "".

        FIND FIRST natur-oper NO-LOCK
             WHERE ROWID(natur-oper) = p-row-table NO-ERROR.
        IF AVAIL natur-oper THEN DO:
            FIND FIRST int-natur-oper EXCLUSIVE-LOCK
                 WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
            IF NOT AVAIL int-natur-oper THEN DO:
                CREATE int-natur-oper.
                ASSIGN int-natur-oper.nat-operacao = natur-oper.nat-operacao.
            END.
            ASSIGN wh-cod-esp-apb-cd0606:SCREEN-VALUE  = int-natur-oper.cod-esp-apb 
                   wh-tg-cons-averb-seg-cd0606:CHECKED = int-natur-oper.cons-averb-seg.
            
            IF wh-cb-tipo-cd0606:SCREEN-VALUE = "Entrada" THEN DO:
                ASSIGN wh-observacao-cd0606:HIDDEN = NO
                       tx-observacao-cd0606:HIDDEN = NO
                       wh-observacao-cd0606:SCREEN-VALUE  = string(int-natur-oper.cod-observa).
            END.
            ELSE DO:
                ASSIGN wh-observacao-cd0606:HIDDEN = YES
                       tx-observacao-cd0606:HIDDEN = YES.
            END.
            RELEASE int-natur-oper.
        END.
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ASSIGN" THEN DO:

    IF VALID-HANDLE(wh-cod-esp-apb-cd0606)      AND 
       p-row-table <> ?                         AND 
       p-cod-table = "natur-oper" THEN DO:

        FIND FIRST natur-oper NO-LOCK
             WHERE ROWID(natur-oper) = p-row-table NO-ERROR.
        IF AVAIL natur-oper THEN DO:
            FIND FIRST int-natur-oper EXCLUSIVE-LOCK
                 WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
            IF NOT AVAIL int-natur-oper THEN DO:
                CREATE int-natur-oper.
                ASSIGN int-natur-oper.nat-operacao = natur-oper.nat-operacao.
            END.
            ASSIGN int-natur-oper.cod-esp-apb    = wh-cod-esp-apb-cd0606:SCREEN-VALUE
                   int-natur-oper.cod-observa    = int(wh-observacao-cd0606:SCREEN-VALUE)
                   int-natur-oper.cons-averb-seg = wh-tg-cons-averb-seg-cd0606:CHECKED.
            RELEASE int-natur-oper.
        END.
    END.
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

PROCEDURE pi-leave-cod-esp-apb:

    IF VALID-HANDLE(wh-cod-esp-apb-cd0606) AND 
       wh-cod-esp-apb-cd0606:SCREEN-VALUE <> "" THEN DO:

        FIND FIRST espec-ap NO-LOCK
             WHERE espec-ap.cod-esp = wh-cod-esp-apb-cd0606:SCREEN-VALUE NO-ERROR.
        IF NOT AVAIL espec-ap THEN DO:
            MESSAGE "Esp‚cie APB inv lida, favor informe uma Esp‚cie de T¡tulo cadastrada no APB!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "ENTRY" TO wh-cod-esp-apb-cd0606.
            RETURN NO-APPLY.
        END.
    END.
    
END PROCEDURE.
