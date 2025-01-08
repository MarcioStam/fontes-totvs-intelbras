/***********************************************************************
**  Programa..: UPC\en0109b-UPC.P
**  Autor.....: Emerson Colla - Gestech
**  Data......: abril/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 13/04/2009
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{utp\ut-glob.i}

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vNrOrdProdu LIKE ord-prod.nr-ord-produ NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").


DEF NEW GLOBAL SHARED VAR whBtRetirar-en0109d       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtExportaTela-en0109d      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbrowse-en0109d      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-upc-en0109d           AS WIDGET-HANDLE NO-UNDO.
define new global shared var wh-componente-en0109d as widget-handle no-undo.
DEF BUFFER bestrutura FOR estrutura.

/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/****************************  Variaveis    ****************************/

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/en0109d-upc.p PERSISTENT SET h-upc-en0109d(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-upc-en0109d) THEN
        DELETE PROCEDURE h-upc-en0109d.




IF  p-ind-event   = "BEFORE-INITIALIZE" AND
    p-ind-object  = "CONTAINER"  THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "c-es-codigo-atual",    /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-componente-en0109d).

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.
    
    DO  WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "bt-retirar"        THEN 
                    ASSIGN whBtExportaTela-en0109d = h-frame.
                WHEN "br-estrutura" THEN
                    ASSIGN whbrowse-en0109d = h-frame.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
    END.
    
    ASSIGN whBtExportaTela-en0109d:SENSITIVE = NO.
    
    CREATE BUTTON whBtRetirar-en0109d
    ASSIGN FRAME     = whBtExportaTela-en0109d:FRAME
           WIDTH     = whBtExportaTela-en0109d:WIDTH
           HEIGHT    = whBtExportaTela-en0109d:HEIGHT
           ROW       = whBtExportaTela-en0109d:ROW
           LABEL     = "Retirar por data"
           COL       = whBtExportaTela-en0109d:COL + 15
           SENSITIVE = YES /* whBtExportaTela-en0109d:SENSITIVE */
           VISIBLE   = YES /* whBtExportaTela-en0109d:VISIBLE */
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-data IN h-upc-en0109d.
    END TRIGGERS.
    
   /* whBtRetirar-en0109d:LOAD-IMAGE-UP(whBtExportaTela-en0109d:IMAGE-UP). */
    /* whBtRetirar-en0109d:LOAD-IMAGE-INSENSITIVE(whBtExportaTela-en0109d:IMAGE-INSENSITIVE). */
    whBtRetirar-en0109d:MOVE-TO-TOP().
END.

PROCEDURE pi-data:
    DEFINE VARIABLE h-item    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-seq    AS HANDLE      NO-UNDO.
    def  var wh-query         as widget-handle no-undo.
    def  var wh-buffer        as widget-handle no-undo.

    ASSIGN wh-query  = whbrowse-en0109d:QUERY
           wh-buffer = wh-query:GET-BUFFER-HANDLE(1)
           h-item    = wh-buffer:BUFFER-FIELD("it-codigo")
           h-seq     = wh-buffer:BUFFER-FIELD("sequencia").
    
    wh-query:GET-FIRST().

    REPEAT:
        FIND FIRST bestrutura WHERE bestrutura.it-codigo = h-item:BUFFER-VALUE AND
                                    bestrutura.sequencia = h-seq:BUFFER-VALUE AND
                                    bestrutura.es-codigo = wh-componente-en0109d:SCREEN-VALUE
                                   NO-LOCK NO-ERROR.
        IF AVAIL bestrutura AND bestrutura.data-termino < TODAY THEN DO:
            wh-buffer:BUFFER-DELETE().
        END.
        
        wh-query:GET-NEXT().

        IF wh-query:QUERY-OFF-END THEN LEAVE.
    END.
    
    whbrowse-en0109d:REFRESH().
    whbrowse-en0109d:DESELECT-SELECTED-ROW(1) NO-ERROR.
    whbrowse-en0109d:SELECT-ROW(1) NO-ERROR.

END PROCEDURE.

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
  
