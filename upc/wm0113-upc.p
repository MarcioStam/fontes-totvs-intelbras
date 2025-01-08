/***********************************************************************
**  Programa..: upc\wm0113-epc.p
**  Autor.....: Nicolas Martinez
**  Data......: Agosto/2021 - Desenvolvimento
**  Descricao.: UPC para especifico de tabela wms-item-estab-local
**  VersÆo....: 001 
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

{esp/es0018.i}

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

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-wm0113           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage0-wm0113           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-i-num-dias-valid-wm0113 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lg-dt-entrada-wm0113    AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fi-dt-entrada-wm0113    AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-log-compart-box-lote-wm0113  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-log-compart-box-item-wm0113 AS WIDGET-HANDLE   NO-UNDO.

/*
MESSAGE "EVENTO: ":U   p-ind-event      SKIP    
        "OBJETO: ":U   p-ind-object     SKIP    
        //"NOME OBJ: ":U c-objeto         SKIP    
        "FRAME: ":U    p-wgh-frame:NAME SKIP
        "TABELA: ":U   p-cod-table      SKIP    
        "ROWID: ":U    STRING(p-row-table)  
        VIEW-AS ALERT-BOX INFO BUTTONS OK.      
*/
IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-INITIALIZE" 
THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fpage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-wm0113).

    IF VALID-HANDLE(wh-fpage1-wm0113) THEN DO:

        RUN tela-upc (INPUT wh-fpage1-wm0113,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",       /*** Type ***/
                      INPUT "i-num-dias-valid",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-i-num-dias-valid-wm0113).

        IF VALID-HANDLE(wh-i-num-dias-valid-wm0113) THEN DO:
            
            CREATE TOGGLE-BOX wh-lg-dt-entrada-wm0113
            ASSIGN FRAME        = wh-fpage1-wm0113
                   WIDTH        = wh-i-num-dias-valid-wm0113:WIDTH-CHARS + 12
                   HEIGHT       = wh-i-num-dias-valid-wm0113:HEIGHT-CHARS
                   LABEL        = "Controla dias Entrada":U
                   ROW          = wh-i-num-dias-valid-wm0113:ROW
                   COLUMN       = wh-i-num-dias-valid-wm0113:COL + 7
                   SENSITIVE    = NO
                   VISIBLE      = YES.

            CREATE FILL-IN wh-fi-dt-entrada-wm0113
            ASSIGN FRAME             = wh-fpage1-wm0113
                   DATA-TYPE         = "INTEGER":U
                   FORMAT            = ">>9":U
                   WIDTH             = 5
                   HEIGHT            = wh-lg-dt-entrada-wm0113:HEIGHT-CHARS
                   ROW               = wh-lg-dt-entrada-wm0113:ROW
                   COLUMN            = wh-lg-dt-entrada-wm0113:COL + 18
                   VISIBLE           = YES.

        END.

        RUN tela-upc (INPUT wh-fpage1-wm0113,
                      INPUT p-ind-Event,                                                       
                      INPUT "TOGGLE-BOX",       /*** Type ***/
                      INPUT "tg-log-compart-box-lote",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-log-compart-box-lote-wm0113).

        RUN tela-upc (INPUT wh-fpage1-wm0113,
                      INPUT p-ind-Event,                                                       
                      INPUT "TOGGLE-BOX",       /*** Type ***/
                      INPUT "tg-log-compart-box-item",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-log-compart-box-item-wm0113).

    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" THEN DO:

    IF VALID-HANDLE(wh-lg-dt-entrada-wm0113) 
    THEN ASSIGN wh-lg-dt-entrada-wm0113:SENSITIVE = YES.

    IF VALID-HANDLE(wh-fi-dt-entrada-wm0113) 
    THEN ASSIGN wh-fi-dt-entrada-wm0113:SENSITIVE = YES.

    FIND FIRST wms-item-estab-local WHERE
         ROWID(wms-item-estab-local) = p-row-table
               NO-LOCK NO-ERROR.

    IF AVAIL wms-item-estab-local  
    THEN DO:
        IF VALID-HANDLE(wh-log-compart-box-lote-wm0113) AND
           VALID-HANDLE(wh-log-compart-box-item-wm0113)
        THEN DO:

            EMPTY TEMP-TABLE tt-prog-ponto.
            
            RUN esp/es0018p.p (INPUT "WM0113", /* Nome do programa */
                               INPUT 1,        /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto WHERE
                               ENTRY(1, tt-prog-ponto.conteudo,";") = wms-item-estab-local.cod-estab
                           AND ENTRY(2, tt-prog-ponto.conteudo,";") = wms-item-estab-local.cod-local
                               NO-LOCK) 
            THEN DO:
                ASSIGN wh-log-compart-box-lote-wm0113:SENSITIVE = NO
                       wh-log-compart-box-item-wm0113:SENSITIVE = NO.
            END.
        END.
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISABLE" THEN DO:

    IF VALID-HANDLE(wh-lg-dt-entrada-wm0113) 
    THEN ASSIGN wh-lg-dt-entrada-wm0113:SENSITIVE = NO.

    IF VALID-HANDLE(wh-fi-dt-entrada-wm0113) 
    THEN ASSIGN wh-fi-dt-entrada-wm0113:SENSITIVE = NO.
END.

IF p-ind-object = "CONTAINER"   AND
  (p-ind-event = "AFTER-DISPLAY" OR 
   p-ind-event = "AFTER-INITIALIZE")
THEN DO:

    FIND FIRST wms-item-estab-local WHERE
         ROWID(wms-item-estab-local) = p-row-table
               NO-LOCK NO-ERROR.

    IF AVAIL wms-item-estab-local  
    THEN DO:
        FIND FIRST int-wms-item-estab-local WHERE
                   int-wms-item-estab-local.cod-local = wms-item-estab-local.cod-local AND
                   int-wms-item-estab-local.cod-estab = wms-item-estab-local.cod-estab AND
                   int-wms-item-estab-local.cod-item  = wms-item-estab-local.cod-item
                   NO-LOCK NO-ERROR.

        IF VALID-HANDLE(wh-lg-dt-entrada-wm0113) 
        THEN DO:
            IF AVAIL int-wms-item-estab-local 
            THEN ASSIGN wh-lg-dt-entrada-wm0113:CHECKED = int-wms-item-estab-local.log-cont-dt-entr.
            ELSE ASSIGN wh-lg-dt-entrada-wm0113:CHECKED = NO.
        END.    

        IF VALID-HANDLE(wh-fi-dt-entrada-wm0113) 
        THEN DO:
            IF AVAIL int-wms-item-estab-local 
            THEN ASSIGN wh-fi-dt-entrada-wm0113:SCREEN-VALUE = string(int-wms-item-estab-local.dias-vld-est).
            ELSE ASSIGN wh-fi-dt-entrada-wm0113:SCREEN-VALUE = "0".
        END.   
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ASSIGN" 
THEN DO:

    FIND FIRST wms-item-estab-local WHERE
         ROWID(wms-item-estab-local) = p-row-table
               NO-LOCK NO-ERROR.

    IF AVAIL wms-item-estab-local  
    THEN DO:
        FIND FIRST int-wms-item-estab-local WHERE
                   int-wms-item-estab-local.cod-local = wms-item-estab-local.cod-local AND
                   int-wms-item-estab-local.cod-estab = wms-item-estab-local.cod-estab AND
                   int-wms-item-estab-local.cod-item  = wms-item-estab-local.cod-item
                   EXCLUSIVE-LOCK NO-ERROR.        
            
        IF VALID-HANDLE(wh-lg-dt-entrada-wm0113) 
        THEN DO:

            IF AVAIL int-wms-item-estab-local 
            THEN DO:
                ASSIGN int-wms-item-estab-local.log-cont-dt-entr = wh-lg-dt-entrada-wm0113:CHECKED.

               // RELEASE int-wms-item-estab-local.
            END.
            ELSE DO:
                IF wh-lg-dt-entrada-wm0113:CHECKED = YES 
                THEN DO:
                    CREATE int-wms-item-estab-local.
                    ASSIGN int-wms-item-estab-local.cod-local        = wms-item-estab-local.cod-local      
                           int-wms-item-estab-local.cod-estab        = wms-item-estab-local.cod-estab
                           int-wms-item-estab-local.cod-item         = wms-item-estab-local.cod-item
                           int-wms-item-estab-local.log-cont-dt-entr = wh-lg-dt-entrada-wm0113:CHECKED.

                   // RELEASE int-wms-item-estab-local.
                END.
            END.
        END.            

        IF VALID-HANDLE(wh-fi-dt-entrada-wm0113) 
        THEN DO:

            IF AVAIL int-wms-item-estab-local 
            THEN DO:

                ASSIGN int-wms-item-estab-local.dias-vld-est = int(wh-fi-dt-entrada-wm0113:SCREEN-VALUE).

                RELEASE int-wms-item-estab-local.
            END.
            /*ELSE DO:
                CREATE int-wms-item-estab-local.
                ASSIGN int-wms-item-estab-local.cod-local        = wms-item-estab-local.cod-local      
                       int-wms-item-estab-local.cod-estab        = wms-item-estab-local.cod-estab
                       int-wms-item-estab-local.cod-item         = wms-item-estab-local.cod-item
                       int-wms-item-estab-local.dias-vld-est = int(wh-fi-dt-entrada-wm0113:SCREEN-VALUE).

                RELEASE int-wms-item-estab-local.
            END. */
        END.

        IF AVAIL int-wms-item-estab-local THEN RELEASE int-wms-item-estab-local.
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
