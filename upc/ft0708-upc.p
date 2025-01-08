/**********************************************************************************
**  Programa..: upc\FT0708-upc.p
**  Autor.....: Roger
**  Data......: JANEIRO/2015 - Desenvolvimento
**  Descricao.: BLOQUEAR A ELIMINA€ÇO DO SUMµRIO PARA USUµRIOS SEM PERMISSÇO
**              OU SE Jµ EXISTIREM MOVIMENTOS CONTµBEIS PARA A SELE€ÇO INFORMADA.    
***********************************************************************************/

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
define new global shared var wh-cod-estabel-ft0502      as widget-handle no-undo.
define new global shared var wh-serie-ft0502      as widget-handle no-undo.
define new global shared var wh-nr-nota-fis-ft0502      as widget-handle no-undo.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wg-tb-sumario         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wg-tb-sumario-fat-ant AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-f-pg-sel           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-f-pg-par           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-estab-ini        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-estab-fim        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-da-emissao-ini     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-da-emissao-fim     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-executar        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-im-pg-par          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-im-pg-sel          AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-ft0708-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-executar-ft0708       AS WIDGET-HANDLE    NO-UNDO.
DEF VAR c-objeto   AS CHAR     NO-UNDO.

IF VALID-HANDLE(p-wgh-object) THEN
   assign c-objeto = entry(num-entries(p-wgh-object:private-data, "/"), p-wgh-object:private-data, "/").

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/ft0708-upc.p PERSISTENT SET h-ft0708-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-ft0708-upc) THEN
        DELETE PROCEDURE h-ft0708-upc.


IF  p-ind-object = "Container" 
AND p-ind-event = "change-page"
AND p-wgh-frame:NAME = "f-pg-sel"
AND NOT VALID-HANDLE(wh-c-estab-ini) THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-estabel-ini",
                     OUTPUT wh-c-estab-ini).
    
    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-estabel-fim",
                     OUTPUT wh-c-estab-fim).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "da-emissao-ini",
                     OUTPUT wh-da-emissao-ini).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "da-emissao-fim",
                     OUTPUT wh-da-emissao-fim).
 
END.

if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    

    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "bt-executar",
                     OUTPUT wh-bt-executar).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "im-pg-par",
                     OUTPUT wh-im-pg-par).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "im-pg-sel",
                     OUTPUT wh-im-pg-sel).


    APPLY "mouse-select-click" TO wh-im-pg-par.

    APPLY "mouse-select-click" TO wh-im-pg-sel.

    IF  VALID-HANDLE (wh-bt-executar) THEN DO:
        create button wh-bt-executar-ft0708  
        assign frame     = p-wgh-frame 
               width     = wh-bt-executar:WIDTH        
               height    = wh-bt-executar:HEIGHT
               row       = wh-bt-executar:ROW
               col       = wh-bt-executar:COL 
               LABEL     = "Executar"
               visible   = yes
               sensitive = yes
               tooltip   = ""
               triggers:
                 on CHOOSE PERSISTENT run pi-valida-eliminacao IN h-ft0708-upc.
               end triggers.

        
    END.
  
end.


PROCEDURE pi-valida-eliminacao:

    DEF VAR l-encontrou AS LOG NO-UNDO.
    FOR EACH lancto_ctbl NO-LOCK
        WHERE lancto_ctbl.cod_modul = "ftp"
          AND lancto_ctbl.dat_lancto >= DATE(wh-da-emissao-ini:SCREEN-VALUE)
          AND lancto_ctbl.dat_lancto <= DATE(wh-da-emissao-fim:SCREEN-VALUE),
        FIRST ITEM_lancto_ctbl OF lancto_ctbl NO-LOCK
            WHERE ITEM_lancto_ctbl.cod_estab >= wh-c-estab-ini:SCREEN-VALUE
              AND ITEM_lancto_ctbl.cod_estab <= wh-c-estab-fim:SCREEN-VALUE:
        ASSIGN l-encontrou = YES.
    END.

    IF  l-encontrou THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "J  existem lan‡amentos na contabilidade dentro da sele‡Æo informada. ~~" + "Para eliminar o sum rio, deve-se eliminar a informa‡Æo do lote na contabilidade. " ).
        RETURN "OK".
    END.

    APPLY "CHOOSE" TO wh-bt-executar.
    

END PROCEDURE.


PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame-aux  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame-aux.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

