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

DEF VAR h-frame AS HANDLE   NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vRowItem AS ROWID NO-UNDO.

DEF VAR c-objeto       AS CHARACTER               NO-UNDO.

DEFINE BUFFER bf-est FOR estrutura.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

DEF NEW GLOBAL SHARED VAR wh-bt-incluir     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-modificar   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-eliminar    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-alternativo AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-referencia  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-renumerar   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-item        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-browse         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtCopiaComponenteUPC    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-br-table-en0105-upc       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-item            AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-inbrw-en0105   AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-bt-desenho AS HANDLE      NO-UNDO.

{upc/btb910za-upc.i}


IF p-ind-object = "VIEWER" AND
   p-ind-event  = "DISPLAY" AND 
   c-objeto     = "v20in172.w" THEN DO:

    ASSIGN vRowItem = p-row-table.

END.


IF p-ind-object = "CONTAINER" AND
   p-ind-event  = "INITIALIZE" AND 
   c-objeto     = "EN0105.w" THEN DO:

    DEF VAR bt-cria-estr   AS widget-handle    no-undo.

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "bt-desenho",
                      OUTPUT wh-bt-desenho).

    CREATE BUTTON whBtCopiaComponenteUPC
    ASSIGN FLAT-BUTTON = TRUE
           FRAME     = p-wgh-frame
           WIDTH     = wh-bt-desenho:WIDTH
           HEIGHT    = wh-bt-desenho:HEIGHT
           ROW       = wh-bt-desenho:ROW
           NAME      = "whBtCopiaComponenteUPC":U
           LABEL     = "CopiaComponente"
           COL       = wh-bt-desenho:COL + wh-bt-desenho:WIDTH
           SENSITIVE = YES /* whBtExportaTela:SENSITIVE */
           VISIBLE   = YES /* whBtExportaTela:VISIBLE */
           HELP      = "Copia Componente"
           TOOLTIP   = "Copia Componente"
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN upc/en0105-trg-upc.p.
    END TRIGGERS.

    whBtCopiaComponenteUPC:LOAD-IMAGE-UP("IMAGE/im-joi.bmp").

    IF CAN-FIND(FIRST usuar_univ 
                WHERE usuar_univ.cod_usuario = c-seg-usuario 
                  AND usuar_univ.cod_empresa = "6") THEN DO:
        create button bt-cria-estr
        assign FLAT-BUTTON = TRUE
               frame     = p-wgh-frame
               width     = wh-bt-desenho:WIDTH 
               height    = wh-bt-desenho:HEIGHT
               row       = wh-bt-desenho:ROW   
               col       = whBtCopiaComponenteUPC:COL + whBtCopiaComponenteUPC:WIDTH
               font      = 4
               tooltip   = "Importa estrutura"
               HELP      = "Importa estrutura"
               visible   = YES
               sensitive = yes
               triggers:
                    on CHOOSE persistent run upc/en0105-upcw.w.
               end.
        
        if bt-cria-estr:load-image-up ("image~\im-negoc") then.
        bt-cria-estr:move-to-top(). 
    END.
END.


IF p-ind-object = "BROWSER" AND
   p-ind-event  = "INITIALIZE" AND 
   c-objeto     = "b01in111.w" THEN DO:

    ASSIGN wh-inbrw-en0105 = p-wgh-object.

    assign h-frame = p-wgh-frame:FIRST-CHILD.
    assign h-frame = h-frame:FIRST-CHILD.
    do  while valid-handle(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "bt-incluir"     THEN ASSIGN wh-bt-incluir     = h-frame.
                WHEN "bt-modificar"   THEN ASSIGN wh-bt-modificar   = h-frame.
                WHEN "bt-eliminar"    THEN ASSIGN wh-bt-eliminar    = h-frame.
                WHEN "bt-alternativo" THEN ASSIGN wh-bt-alternativo = h-frame.
                WHEN "bt-referencia"  THEN ASSIGN wh-bt-referencia  = h-frame.
                WHEN "bt-renumerar"   THEN ASSIGN wh-bt-renumerar   = h-frame.
                WHEN "bt-item"        THEN ASSIGN wh-bt-item        = h-frame.
                WHEN "br-table"       THEN ASSIGN wh-br-table-en0105-upc       = h-frame.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE LEAVE.
    END.

END.
   




PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.




PROCEDURE busca-folder:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

