/***********************************************************************
**  Programa..: upc\en0105-upc.p
**  Autor.....: Marcio Chaves - Aporte
**  Data......: OUTUBRO/2004 - Desenvolvimento
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

DEFINE VARIABLE h-frame                     AS HANDLE        NO-UNDO.
DEFINE VARIABLE adm-current-page            AS INTEGER       NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vRowDp-Estrut  AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-folder     AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE c-folder AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

DEF NEW GLOBAL SHARED VAR wh-local-montag AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-montag    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl  AS WIDGET-HANDLE NO-UNDO.
define new global shared var wh-componente-dp0301b as widget-handle no-undo.
define new global shared var wh-itemdp-dp0301b as widget-handle no-undo.
define new global shared var wh-versao-dp0301b as widget-handle no-undo.
define new global shared var wh-fator-perda-dp0301b as widget-handle no-undo.
define new global shared var wh-proporcao-dp0301b as widget-handle no-undo.
define new global shared var wh-qtd-item-dp0301b as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-log-quant-fix-dp0301b AS WIDGET-HANDLE NO-UNDO.

/*define new global shared var wh-log-quant-fixdp0301b-upc as widget-handle no-undo.*/
DEFINE NEW GLOBAL SHARED VAR wh-local-montag-dp0301b AS WIDGET-HANDLE NO-UNDO.
DEF VAR p-ativo AS LOGICAL NO-UNDO.
DEF VAR p-itemob AS CHAR NO-UNDO.

/*
OUTPUT TO 'c:\temp\teste.txt' APPEND.
/*
p-ind-event          p-ind-object    p-cod-table          c-objeto
-------------------- --------------- -------------------- ---------------
*/
DISP p-ind-event          FORMAT 'x(20)'
     p-ind-object         FORMAT 'x(15)'
     p-cod-table          FORMAT 'x(20)'
     c-objeto             FORMAT 'x(15)'
     string(p-row-table)  FORMAT 'x(05)'
     string(p-wgh-object) <> ""
     string(p-wgh-frame)  <> ""
     WITH WIDTH 400 STREAM-IO NO-BOX DOWN NO-LABEL.
*/
/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

*/

/*IF  p-ind-object = "VIEWER"     
AND c-objeto     = "v03mf603.w" THEN DO:
    IF p-ind-event  = "add" THEN DO:
        IF VALID-HANDLE(wh-log-quant-fixdp0301b-upc) THEN DO:
            ASSIGN wh-log-quant-fixdp0301b-upc:CHECKED = YES.
            APPLY 'VALUE-CHANGED' TO wh-log-quant-fixdp0301b-upc.

        END.
    END.
    
    IF p-ind-event  = "INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "TOGGLE-BOX",      /*** Type ***/
                      INPUT "log-quant-fix",    /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-log-quant-fixdp0301b-upc).
    END.

END.*/

IF p-ind-object = "VIEWER"     AND 
   c-objeto     = "v04mf603.w" THEN
DO:
    CASE p-ind-event:

        WHEN "ENABLE" THEN DO:

            ASSIGN vRowDp-Estrut = p-row-table.

            IF VALID-HANDLE(wh-local-montag) THEN
                ASSIGN wh-local-montag:SENSITIVE = FALSE.

        END.

        WHEN "AFTER-ENABLE" THEN DO:

            IF VALID-HANDLE(wh-local-montag) THEN
                ASSIGN wh-local-montag:SENSITIVE = FALSE.

        END.

        WHEN "BEFORE-INITIALIZE" THEN
        DO:
            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(h-frame):
                IF  h-frame:TYPE <> "field-group" THEN DO:
                    CASE h-frame:NAME:
                        WHEN "local-montag" THEN ASSIGN wh-local-montag = h-frame.
                    END.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING.
                END.
                ELSE LEAVE.
            END.
            IF VALID-HANDLE(wh-local-montag) THEN
            DO:
                CREATE BUTTON wh-bt-montag
                ASSIGN FRAME     = wh-local-montag:FRAME
                       WIDTH     = 4
                       HEIGHT    = 1
                       ROW       = 2.17
                       LABEL     = ""
                       COL       = 80
                       SENSITIVE = NO
                       VISIBLE   = NO
                TRIGGERS:
                      ON CHOOSE PERSISTENT RUN esp\dpp\esdpp001.w.
                END TRIGGERS.
                wh-bt-montag:LOAD-IMAGE-UP('image/im-abc.bmp').
                wh-bt-montag:LOAD-IMAGE-INSENSITIVE('image/ii-abc.bmp').

            END.
        END.

        WHEN "VALIDATE" THEN DO:

            RUN tela-upc (INPUT p-wgh-frame,
                          INPUT p-ind-Event,
                          INPUT "fill-in",      /*** Type ***/
                          INPUT "local-montag",    /*** Name ***/
                          INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                          INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                          OUTPUT wh-local-montag-dp0301b).

            IF length(wh-local-montag-dp0301b:SCREEN-VALUE) > 55 THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "O campo Local de Montagem n∆o suporta mais de 55 caracteres. Redefina o Local de Montagem.").
    
                RETURN "NOK":U.

            END.

        END.

    END CASE.
END.
IF p-ind-object = "CONTAINER"         AND 
   p-ind-event  = "AFTER-CHANGE-PAGE" THEN
DO:
    RUN GET-ATTRIBUTE IN wgh-folder ('Current-Page':U).
    ASSIGN adm-current-page       = INTEGER(RETURN-VALUE) 
           wh-bt-montag:VISIBLE   = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag)
           wh-bt-montag:SENSITIVE = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag).
END.


IF p-ind-event = "INITIALIZE" and p-ind-object = "CONTAINER" THEN 
DO:
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).
    RUN GET-ATTRIBUTE IN p-wgh-object ('Current-Page':U).

    ASSIGN wgh-folder             = p-wgh-object
           adm-current-page       = INTEGER(RETURN-VALUE)
           wh-bt-montag:VISIBLE   = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag)
           wh-bt-montag:SENSITIVE = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag).

END.


IF  p-ind-object = "VIEWER"    
AND c-objeto     = "v03mf603.w" THEN DO:

    IF  p-ind-event  = "INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "TOGGLE-BOX",   
                      INPUT "log-quant-fix",
                      INPUT NO,             
                      INPUT 1,              
                      OUTPUT wh-log-quant-fix-dp0301b).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",   
                      INPUT "fator-perda",
                      INPUT NO,             
                      INPUT 1,              
                      OUTPUT wh-fator-perda-dp0301b).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",   
                      INPUT "proporcao",
                      INPUT NO,             
                      INPUT 1,              
                      OUTPUT wh-proporcao-dp0301b).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",   
                      INPUT "qtd-item",
                      INPUT NO,             
                      INPUT 1,              
                      OUTPUT wh-qtd-item-dp0301b).
    END.

    IF  p-ind-event = "AFTER-DISPLAY" AND VALID-HANDLE(wh-log-quant-fix-dp0301b) THEN DO:
        ASSIGN wh-log-quant-fix-dp0301b:SENSITIVE = NO
               wh-fator-perda-dp0301b  :SENSITIVE = NO
               wh-proporcao-dp0301b    :SENSITIVE = NO
               wh-qtd-item-dp0301b     :SENSITIVE = NO.
    END.

    IF  (p-ind-event = "AFTER-ENABLE" OR p-ind-event = "ADD") AND VALID-HANDLE(wh-log-quant-fix-dp0301b) THEN DO:
        ASSIGN wh-log-quant-fix-dp0301b:SENSITIVE = NO
               wh-fator-perda-dp0301b  :SENSITIVE = NO
               wh-proporcao-dp0301b    :SENSITIVE = NO
               wh-qtd-item-dp0301b     :SENSITIVE = NO
               wh-qtd-item-dp0301b     :READ-ONLY = YES.
    END.
END.


/* Emerson - Verifica se o componente esta ativo */

IF p-ind-event  = "VALIDATE"  AND
   p-ind-object = "VIEWER"    AND
   p-row-table  = ?           AND
   c-objeto     = "v01mf603.w" THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "es-codigo",    /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-componente-dp0301b).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "toggle-box",      /*** Type ***/
                  INPUT "tgb-dp-item",    /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-itemdp-dp0301b).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "num-proces-compon",    /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-versao-dp0301b).

   
    IF wh-itemdp-dp0301b:SCREEN-VALUE = "NO" THEN DO:
        FIND FIRST estrutura WHERE estrutura.it-codigo = wh-componente-dp0301b:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAIL estrutura THEN DO:
            FIND FIRST ITEM WHERE ITEM.it-codigo = wh-componente-dp0301b:SCREEN-VALUE
                NO-LOCK NO-ERROR.
            IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
                MESSAGE "Componente Obsoleto. N∆o pode ser usado."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            RUN esp/verifica-estrutura.p (INPUT wh-componente-dp0301b:SCREEN-VALUE,
                                          OUTPUT p-ativo,
                                          OUTPUT p-itemob).
    
            IF p-ativo = NO THEN DO:
                MESSAGE "Item " p-itemob " esta Obsoleto. N∆o pode ser usado."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
                    RETURN "NOK".
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST dp-estrut WHERE dp-estrut.item-dp = wh-componente-dp0301b:SCREEN-VALUE and
                                   dp-estrut.num-proces-item = int(wh-versao-dp0301b:SCREEN-VALUE) NO-LOCK NO-ERROR.
        IF NOT AVAIL dp-estrut THEN DO:
            FIND FIRST ITEM WHERE ITEM.it-codigo = wh-componente-dp0301b:SCREEN-VALUE
                NO-LOCK NO-ERROR.
            IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
                MESSAGE "Componente Obsoleto. N∆o pode ser usado."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            RUN esp/verifica-dp-estrut.p (INPUT wh-componente-dp0301b:SCREEN-VALUE,
                                          INPUT int(wh-versao-dp0301b:SCREEN-VALUE),
                                          OUTPUT p-ativo,
                                          OUTPUT p-itemob).
            
            IF p-ativo = NO THEN DO:
                MESSAGE "Item " p-itemob " esta Obsoleto. N∆o pode ser usado."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
                    RETURN "NOK".
            END.
            
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


