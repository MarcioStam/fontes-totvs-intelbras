/***********************************************************************
**  Programa..: upc\cd2565a-upc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/
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

DEF VARIABLE h-object           AS HANDLE        NO-UNDO.
DEF VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-programa         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-window         AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-tg-gera-custo-cd2565a   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-duplicata-cd2565a    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-ativo-portal-cd2565a AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-inc-val-frete-cd2565a   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-l-inc-afrmm-cd2565a     AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-pto-base AS c NO-UNDO.


//DEF NEW GLOBAL SHARED VAR h-cd2565a-btOK                  AS HANDLE NO-UNDO.
//DEF NEW GLOBAL SHARED VAR h-cd2565a-btSave-falso          AS HANDLE NO-UNDO.
//DEF NEW GLOBAL SHARED VAR h-cd2565a-btSave                AS HANDLE NO-UNDO.
//DEF NEW GLOBAL SHARED VAR h-cd2565a-btOK-falso            AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-pto-base-cd2565a         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-pto-base-txt-cd2565a     AS HANDLE        NO-UNDO.


DEFINE VAR c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/


IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "TOGGLE-BOX",    /*** Type ***/
                  INPUT "inc-val-frete", /*** Name ***/
                  INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-inc-val-frete-cd2565a).

    wh-inc-val-frete-cd2565a:ROW = wh-inc-val-frete-cd2565a:ROW + 0.3.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "TOGGLE-BOX",    /*** Type ***/
                  INPUT "l-inc-afrmm", /*** Name ***/
                  INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-l-inc-afrmm-cd2565a).

    wh-l-inc-afrmm-cd2565a:ROW = wh-l-inc-afrmm-cd2565a:ROW - 0.3.

/*
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "BUTTON",    /*** Type ***/
                  INPUT "btOK", /*** Name ***/
                  INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT h-cd2565a-btOK).
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "BUTTON",    /*** Type ***/
                  INPUT "btSave", /*** Name ***/
                  INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT h-cd2565a-btSave).
*/
    
    CREATE TEXT h-pto-base-txt-cd2565a
    ASSIGN FRAME          = p-wgh-frame
           FORMAT         = "x(20)"
           WIDTH          = 20
           SCREEN-VALUE   = "Ponto Controle Base:"
           ROW            = 8.7
           COL            = 2
           VISIBLE        = YES.


    RUN pi-pto-base.

    CREATE COMBO-BOX h-pto-base-cd2565a
    ASSIGN FRAME           = p-wgh-frame
           DATA-TYPE       = "character"
           FORMAT          = "x(30)" 
           WIDTH           = 25
//           HEIGHT          = 0.88
           ROW             = 8.6
           COL             = 16.8
           VISIBLE         = YES
           SENSITIVE       = YES
           LIST-ITEMS      = c-pto-base
           INNER-LINES     = NUM-ENTRIES(c-pto-base)
           SCREEN-VALUE    = ENTRY(1,c-pto-base)
           .


    CREATE TOGGLE-BOX wh-tg-gera-custo-cd2565a
    ASSIGN FRAME         = p-wgh-frame
           WIDTH         = 14
           HEIGHT        = 0.88
           COL           = 22
           ROW           = 10.9
           VISIBLE       = YES
           SENSITIVE     = YES
           SCREEN-VALUE  = "YES"
           LABEL         = "Gera Custo"
           HELP          = "Gera Custo"
           FONT          = 1.

    CREATE TOGGLE-BOX wh-tg-ativo-portal-cd2565a
    ASSIGN FRAME         = p-wgh-frame
           WIDTH         = 22
           HEIGHT        = 0.88
           COL           = 49.77
           ROW           = 8.5
           VISIBLE       = YES
           SENSITIVE     = YES
           SCREEN-VALUE  = "YES"
           LABEL         = "Ativo Portal Fornecedores"
           HELP          = "Ativo Portal Fornecedores"
           FONT          = 1.

/*
    IF VALID-HANDLE(h-cd2565a-btOK)
    THEN DO:
        CREATE BUTTON h-cd2565a-btOK-falso
            ASSIGN 
               FRAME       = h-cd2565a-btOK:FRAME
               WIDTH       = h-cd2565a-btOK:WIDTH
               HEIGHT      = h-cd2565a-btOK:HEIGHT
               LABEL       = h-cd2565a-btOK:LABEL + " *"
               ROW         = h-cd2565a-btOK:ROW
               COLUMN      = h-cd2565a-btOK:COLUMN
               TOOLTIP     = h-cd2565a-btOK:TOOLTIP
               HELP        = h-cd2565a-btOK:HELP
               NAME        = "falso-" + h-cd2565a-btOK:NAME
               SENSITIVE   = YES
               VISIBLE     = YES
               FONT        = h-cd2565a-btOK:FONT
            TRIGGERS:
               ON 'choose':U PERSISTENT RUN upc/cd2565a-upc.p ("btOK"      ,
                                                               "btOK"      ,
                                                               p-wgh-object,
                                                               p-wgh-frame ,
                                                               p-cod-table ,
                                                               p-row-table 
                                                             ).
            END TRIGGERS.

        h-cd2565a-btOK      :SENSITIVE = NO.
        h-cd2565a-btOK-falso:MOVE-AFTER-TAB-ITEM(h-cd2565a-btOK) NO-ERROR.
    END.

    IF VALID-HANDLE(h-cd2565a-btSave)
    THEN DO:
        CREATE BUTTON h-cd2565a-btSave-falso
            ASSIGN 
               FRAME       = h-cd2565a-btSave:FRAME
               WIDTH       = h-cd2565a-btSave:WIDTH
               HEIGHT      = h-cd2565a-btSave:HEIGHT
               LABEL       = h-cd2565a-btSave:LABEL + " *"
               ROW         = h-cd2565a-btSave:ROW
               COLUMN      = h-cd2565a-btSave:COLUMN
               TOOLTIP     = h-cd2565a-btSave:TOOLTIP
               HELP        = h-cd2565a-btSave:HELP
               NAME        = "falso-" + h-cd2565a-btSave:NAME
               SENSITIVE   = YES
               VISIBLE     = YES
               FONT        = h-cd2565a-btSave:FONT
            TRIGGERS:
               ON 'choose':U PERSISTENT RUN upc/cd2565a-upc.p ("btSave"      ,
                                                               "btSave"      ,
                                                               p-wgh-object,
                                                               p-wgh-frame ,
                                                               p-cod-table ,
                                                               p-row-table 
                                                             ).
            END TRIGGERS.

        h-cd2565a-btSave      :SENSITIVE = NO.
        h-cd2565a-btSave-falso:MOVE-AFTER-TAB-ITEM(h-cd2565a-btSave) NO-ERROR.
    END.
*/



END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" THEN DO:

    IF VALID-HANDLE(wh-tg-gera-custo-cd2565a) THEN DO:

        FIND FIRST desp-imp NO-LOCK
             WHERE ROWID(desp-imp) = p-row-table NO-ERROR.
        IF AVAIL desp-imp THEN DO:
            ASSIGN wh-tg-gera-custo-cd2565a:SCREEN-VALUE = IF desp-imp.gera-custo THEN "yes" ELSE "no". 
        END.
        ELSE
            ASSIGN wh-tg-gera-custo-cd2565a:SCREEN-VALUE = "no".
    END.

    IF VALID-HANDLE(wh-tg-ativo-portal-cd2565a) THEN DO:

        FIND FIRST desp-imp NO-LOCK
             WHERE ROWID(desp-imp) = p-row-table NO-ERROR.

        FIND FIRST int-desp-imp NO-LOCK
             WHERE int-desp-imp.cod-desp = desp-imp.cod-desp NO-ERROR.
        
        IF AVAIL int-desp-imp THEN DO:
            ASSIGN 
               wh-tg-ativo-portal-cd2565a:SCREEN-VALUE = IF int-desp-imp.log-ativo-portal THEN "yes" ELSE "no".

            RUN pi-pto-base.

            IF int-desp-imp.cdn-pto-base > 0
            THEN ASSIGN
               h-pto-base-cd2565a:SCREEN-VALUE         = ENTRY(int-desp-imp.cdn-pto-base,c-pto-base)
               .
        END.
        ELSE
            ASSIGN wh-tg-ativo-portal-cd2565a:SCREEN-VALUE = "no".
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ASSIGN" THEN DO:

    IF VALID-HANDLE(wh-tg-gera-custo-cd2565a) THEN DO:
        FIND FIRST desp-imp EXCLUSIVE-LOCK
             WHERE ROWID(desp-imp) = p-row-table NO-ERROR.
        IF AVAIL desp-imp THEN DO:
            ASSIGN desp-imp.gera-custo = IF wh-tg-gera-custo-cd2565a:SCREEN-VALUE = "yes" THEN YES ELSE NO.
        END.
    END.

    IF VALID-HANDLE(wh-tg-ativo-portal-cd2565a) THEN DO:
       FIND FIRST desp-imp EXCLUSIVE-LOCK
            WHERE ROWID(desp-imp) = p-row-table NO-ERROR.

       FIND FIRST int-desp-imp EXCLUSIVE-LOCK
            WHERE int-desp-imp.cod-desp = desp-imp.cod-desp NO-ERROR.

       IF NOT AVAIL int-desp-imp THEN DO:
           CREATE int-desp-imp.
           ASSIGN int-desp-imp.cod-desp = desp-imp.cod-desp.
       END.
    
       RUN pi-pto-base.

       ASSIGN 
          int-desp-imp.log-ativo-portal = IF wh-tg-ativo-portal-cd2565a:SCREEN-VALUE = "yes" THEN YES ELSE NO
          int-desp-imp.cdn-pto-base     = LOOKUP(h-pto-base-cd2565a:SCREEN-VALUE,c-pto-base)
         .
       RELEASE int-desp-imp.
    END.
END.

/*
IF p-ind-event = "btOK" 
OR p-ind-event = "btSave" 
THEN DO:
   FIND FIRST pto-itiner NO-LOCK
        WHERE pto-itiner.cod-pto-contr = INT(h-pto-base-cd2565a:SCREEN-VALUE)
        NO-ERROR.
   IF NOT AVAIL pto-itiner
   THEN DO:
      RUN utp/ut-msgs.p ("show",17006,"Ponto de controle n∆o encontrado").
      RETURN "NOK".
   END.
   IF p-ind-event = "btOK" 
   THEN APPLY "choose" TO h-cd2565a-btOK.
   IF p-ind-event = "btSave" 
   THEN APPLY "choose" TO h-cd2565a-btSave.
END.
*/

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VAR wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VAR i-aux   AS INTEGER       NO-UNDO.

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

PROCEDURE pi-pto-base:

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

END.
