/***********************************************************************
**  Programa..: upc\cc0504a-upc.p
**  Autor.....: Raphael
**  Data......: Fevereiro/2010
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-programa         AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window         AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-br-table1-cc0504a  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-br-table2-cc0504a  AS WIDGET-HANDLE NO-UNDO.
/*DEFINE NEW GLOBAL SHARED VARIABLE wh-data-ent-cc0504a AS WIDGET-HANDLE NO-UNDO.*/

DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-embarque-cc0504a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-cc0504a           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-itinerario-cc0504a      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-itinerario-cc0504a         AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-embarque2-cc0504a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque2-cc0504a           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-itinerario2-cc0504a      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-itinerario2-cc0504a         AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-parcela-cc0504a            AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-coluna1 AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-query  AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-buffer AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

DEFINE VARIABLE c-embarque   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-itinerario AS CHARACTER   NO-UNDO.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */


IF p-ind-object = "BROWSER"           AND
   p-ind-event  = "BEFORE-INITIALIZE" THEN DO:

    IF c-char     = "b39in172.w" THEN DO:
        CREATE TEXT wh-tx-embarque-cc0504a
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(9)"   
               WIDTH        = 9
               SCREEN-VALUE = "Embarque:"
               ROW          = 8.2
               COL          = 11
               VISIBLE      = YES.

        CREATE FILL-IN wh-embarque-cc0504a
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(40)" 
               WIDTH             = 30
               HEIGHT            = 0.88
               ROW               = 8.1
               COL               = 20
               VISIBLE           = YES
               SENSITIVE         = YES
               READ-ONLY         = YES
               TAB-STOP          = NO.

        CREATE TEXT wh-tx-itinerario-cc0504a
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(9)"   
               WIDTH        = 9
               SCREEN-VALUE = "Itiner:"
               ROW          = 8.2
               COL          = 53
               VISIBLE      = YES.

        CREATE FILL-IN wh-itinerario-cc0504a
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(40)" 
               WIDTH             = 20
               HEIGHT            = 0.88
               ROW               = 8.1
               COL               = 60
               VISIBLE           = YES
               SENSITIVE         = YES
               READ-ONLY         = YES
               TAB-STOP          = NO.
    END.

    IF c-char     = "b40in172.w" THEN DO:
        CREATE TEXT wh-tx-embarque2-cc0504a
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(9)"   
               WIDTH        = 9
               SCREEN-VALUE = "Embarque:"
               ROW          = 8.2
               COL          = 11
               VISIBLE      = YES.

        CREATE FILL-IN wh-embarque2-cc0504a
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(40)" 
               WIDTH             = 30
               HEIGHT            = 0.88
               ROW               = 8.1
               COL               = 20
               VISIBLE           = YES
               SENSITIVE         = YES
               READ-ONLY         = YES
               TAB-STOP          = NO.

        CREATE TEXT wh-tx-itinerario2-cc0504a
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(9)"   
               WIDTH        = 9
               SCREEN-VALUE = "Itiner:"
               ROW          = 8.2
               COL          = 53
               VISIBLE      = YES.

        CREATE FILL-IN wh-itinerario2-cc0504a
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(40)" 
               WIDTH             = 20
               HEIGHT            = 0.88
               ROW               = 8.1
               COL               = 60
               VISIBLE           = YES
               SENSITIVE         = YES
               READ-ONLY         = YES
               TAB-STOP          = NO.
    END.


END.

IF p-ind-object = "BROWSER"     THEN DO:

   IF c-char     = "b39in172.w" THEN DO:
       IF p-ind-event  = "initialize" THEN DO:
           RUN tela-upc (INPUT p-wgh-frame,
                             INPUT p-ind-Event,
                             INPUT "browse",       /*** Type ***/
                             INPUT "br-table",      /*** Name ***/
                             INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                             INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                             OUTPUT wh-br-table1-cc0504a).
           
           IF VALID-HANDLE(wh-br-table1-cc0504a) THEN DO:
               ASSIGN wh-query  = wh-br-table1-cc0504a:QUERY
                      wh-buffer = wh-query:GET-BUFFER-HANDLE(1).
        
               wh-br-table1-cc0504a:ADD-LIKE-COLUMN("ordem-compra.cod-estabel", 3) NO-ERROR. 
           END.
       END.

      

       IF p-ind-event = "after-open-query" OR p-ind-event  = "after-value-changed" THEN DO:
           ASSIGN c-embarque   = ""
                  c-itinerario = "".

           IF VALID-HANDLE(wh-br-table1-cc0504a) THEN DO:
              ASSIGN wgh-parcela-cc0504a  = wh-br-table1-cc0504a:QUERY:GET-BUFFER-HANDLE("prazo-compra":U):BUFFER-FIELD("parcela":U).

              FIND FIRST ordem-compra NO-LOCK WHERE ROWID(ordem-compra) = p-row-table NO-ERROR.
              IF AVAIL ordem-compra THEN DO:
                  FOR EACH ordens-embarque OF ordem-compra NO-LOCK
                     WHERE ordens-embarque.parcela = wgh-parcela-cc0504a:BUFFER-VALUE:
                      IF c-embarque = "" THEN
                          ASSIGN c-embarque = ordens-embarque.embarque.
                      ELSE
                          ASSIGN c-embarque = c-embarque + ", " + ordens-embarque.embarque.
                  END.
              
                  FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
                  IF AVAIL cotacao-item THEN DO:
                      FIND FIRST itinerario NO-LOCK
                           WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
                      ASSIGN c-itinerario = STRING(cotacao-item.int-1) + (IF AVAIL itinerario THEN "-" + itinerario.descricao ELSE "").
                  END.
              END.
           END.
              
           

           ASSIGN wh-embarque-cc0504a:SCREEN-VALUE   = c-embarque
                  wh-itinerario-cc0504a:SCREEN-VALUE = c-itinerario.
       END.
    END.
    ELSE IF c-char     = "b40in172.w" THEN DO:
            IF p-ind-event  = "initialize" THEN DO:
                RUN tela-upc (INPUT p-wgh-frame,
                                  INPUT p-ind-Event,
                                  INPUT "browse",       /*** Type ***/
                                  INPUT "br-table",      /*** Name ***/
                                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                                  OUTPUT wh-br-table2-cc0504a).
        
                IF VALID-HANDLE(wh-br-table2-cc0504a) THEN DO:
                    ASSIGN wh-query  = wh-br-table2-cc0504a:QUERY
                           wh-buffer = wh-query:GET-BUFFER-HANDLE(1).
        
                    wh-br-table2-cc0504a:ADD-LIKE-COLUMN("ordem-compra.cod-estabel", 3) NO-ERROR. 
                END.
            END.
            IF p-ind-event = "after-open-query" OR p-ind-event  = "after-value-changed" THEN DO:
                ASSIGN c-embarque   = ""
                       c-itinerario = "".

                IF VALID-HANDLE(wh-br-table2-cc0504a) THEN DO:
                   ASSIGN wgh-parcela-cc0504a  = wh-br-table2-cc0504a:QUERY:GET-BUFFER-HANDLE("prazo-compra":U):BUFFER-FIELD("parcela":U).
                   FIND FIRST ordem-compra NO-LOCK WHERE ROWID(ordem-compra) = p-row-table NO-ERROR.
                   IF AVAIL ordem-compra THEN DO:
                       FOR EACH ordens-embarque OF ordem-compra NO-LOCK
                          WHERE ordens-embarque.parcela = wgh-parcela-cc0504a:BUFFER-VALUE:
                           IF c-embarque = "" THEN
                               ASSIGN c-embarque = ordens-embarque.embarque.
                           ELSE
                               ASSIGN c-embarque = c-embarque + ", " + ordens-embarque.embarque.
                       END.
                   
                       FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
                       IF AVAIL cotacao-item THEN DO:
                           FIND FIRST itinerario NO-LOCK
                                WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
                           ASSIGN c-itinerario = STRING(cotacao-item.int-1) + (IF AVAIL itinerario THEN "-" + itinerario.descricao ELSE "").
                       END.
                   
                   END.
                END.

                ASSIGN wh-embarque2-cc0504a:SCREEN-VALUE   = c-embarque
                       wh-itinerario2-cc0504a:SCREEN-VALUE = c-itinerario.
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
