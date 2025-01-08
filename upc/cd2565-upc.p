/***********************************************************************
**  Programa..: upc\cd2565-upc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008
**  Descricao.: 
**  VersÆo....: 001 - 00/00/
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}
{esp/es0018.i}

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

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-cd2565              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-gera-custo-cd2565       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-log-ativo-portal-cd2565 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-duplicata-cd2565        AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-pto-base-cd2565             AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-pto-base-txt-cd2565         AS HANDLE        NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

DEF VAR c-pto-base AS c NO-UNDO.


assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/**************************************
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
***************************************/


IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-cd2565).

    IF VALID-HANDLE(wh-fpage1-cd2565) THEN DO:

        /*fPage1*/
        RUN tela-upc (INPUT wh-fpage1-cd2565,
                      INPUT p-ind-event,
                      INPUT "toggle-box",       /*** Type ***/
                      INPUT "inc-val-duplic",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-tg-duplicata-cd2565).

        CREATE TOGGLE-BOX wh-tg-gera-custo-cd2565
        ASSIGN FRAME         = wh-fpage1-cd2565
               WIDTH         = 14
               HEIGHT        = 0.88
               COL           = 54
               ROW           = 1
               VISIBLE       = YES
               SENSITIVE     = NO
               SCREEN-VALUE  = "YES"
               LABEL         = "Gera Custo"
               HELP          = "Gera Custo"
               FONT          = 1.

        CREATE TOGGLE-BOX wh-tg-log-ativo-portal-cd2565
        ASSIGN FRAME         = wh-fpage1-cd2565
               WIDTH         = 24
               HEIGHT        = 0.88
               COL           = 29
               ROW           = 1
               VISIBLE       = YES
               SENSITIVE     = NO
               SCREEN-VALUE  = "YES"
               LABEL         = "Ativo Portal Fornecedores"
               HELP          = "Ativo Portal Fornecedores"
               FONT          = 1.

        CREATE TEXT h-pto-base-txt-cd2565
        ASSIGN FRAME          = wh-fpage1-cd2565
               FORMAT         = "x(20)"
               WIDTH          = 20
               SCREEN-VALUE   = "Ponto Controle Base:"
               ROW            = 1.2
               COL            = 2
               VISIBLE        = YES.

        CREATE FILL-IN h-pto-base-cd2565
        ASSIGN FRAME         = wh-fpage1-cd2565
               DATA-TYPE     = "Character"
               FORMAT        = "x(30)" 
               WIDTH         = 25
               HEIGHT        = 0.88
               ROW           = 2
               COL           = 2
               VISIBLE       = YES
               SENSITIVE     = NO.

    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" 
THEN DO:
    RUN esp/es0018p.p (INPUT "cd2566":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN
       c-pto-base = "".

    FOR EACH tt-prog-ponto:
        IF c-pto-base = ""
        THEN ASSIGN
           c-pto-base = tt-prog-ponto.conteudo.
        ELSE ASSIGN
           c-pto-base = c-pto-base
                      + ","
                      + tt-prog-ponto.conteudo.
    END.
    ASSIGN
       c-pto-base = c-pto-base 
                  + ",".
    ASSIGN
       h-pto-base-cd2565:SCREEN-VALUE = "".


    IF VALID-HANDLE(wh-tg-gera-custo-cd2565) THEN DO:

        FIND FIRST desp-imp NO-LOCK
             WHERE ROWID(desp-imp) = p-row-table NO-ERROR.
        IF AVAIL desp-imp 
        THEN ASSIGN 
           wh-tg-gera-custo-cd2565:SCREEN-VALUE = IF desp-imp.gera-custo THEN "yes" ELSE "no".
        ELSE ASSIGN 
           wh-tg-gera-custo-cd2565:SCREEN-VALUE = "no".
    END.

    IF VALID-HANDLE(wh-tg-log-ativo-portal-cd2565) THEN DO:

        FIND FIRST desp-imp NO-LOCK
             WHERE ROWID(desp-imp) = p-row-table NO-ERROR.

        FIND FIRST int-desp-imp NO-LOCK
             WHERE int-desp-imp.cod-desp = desp-imp.cod-desp NO-ERROR.

        IF AVAIL int-desp-imp 
        THEN DO:
           ASSIGN 
              wh-tg-log-ativo-portal-cd2565:SCREEN-VALUE = IF int-desp-imp.log-ativo-portal THEN "yes" ELSE "no".
           IF int-desp-imp.cdn-pto-base > 0
           THEN ASSIGN
               h-pto-base-cd2565            :SCREEN-VALUE = ENTRY(int-desp-imp.cdn-pto-base,c-pto-base).
        END.
        ELSE ASSIGN 
           wh-tg-log-ativo-portal-cd2565:SCREEN-VALUE = "no".
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
