/***********************************************************************
**  Programa..: cd0354b-upc
**  Autor.....: Carlos Daniel
**  Data......: 08/03/2016
**  Descricao.: Validaá‰es CEST
**  Vers∆o....: 
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

{esp/es0018.i}

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

FUNCTION fnRetornaTp RETURNS CHARACTER (
    INPUT i-tipo AS INTEGER):

    CASE i-tipo:
        WHEN 1 THEN RETURN "Entrada".
        WHEN 2 THEN RETURN "Sa°da".
        OTHERWISE RETURN "".
    END CASE.

    RETURN "".
END.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-sit-tributo AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-idi-tip-docto    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-item         AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-ge-codigo AS CHARACTER NO-UNDO.

IF  p-ind-event  = "BEFORE-ASSIGN" AND p-ind-object = "CONTAINER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cod-sit-tributo",
                     OUTPUT wh-cod-sit-tributo).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "idi-tip-docto",
                     OUTPUT wh-idi-tip-docto).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cod-item",
                     OUTPUT wh-cod-item).

    IF VALID-HANDLE(wh-cod-sit-tributo) AND
       VALID-HANDLE(wh-idi-tip-docto)    AND
       VALID-HANDLE(wh-cod-item) THEN DO:
        
        RUN esp/es0018p.p (INPUT "cd0354":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FIND FIRST tt-prog-ponto NO-ERROR.
        IF AVAIL tt-prog-ponto THEN
            ASSIGN c-ge-codigo = tt-prog-ponto.conteudo.

       FOR FIRST item
           WHERE item.it-codigo = wh-cod-item:SCREEN-VALUE NO-LOCK:

           IF LOOKUP(STRING(item.ge-codigo),c-ge-codigo) > 0 THEN DO:
               RUN utp/ut-msgs.p (INPUT "SHOW",
                                  INPUT 17006,
                                  INPUT "Relacionamento CEST X C¢digo Item inv†lido~~" + 
                                        "N∆o Ç permitido a inclus∆o de itens que pertencem ao grupo de estoque " + STRING(item.ge-codigo) + ".").
               RETURN ERROR.
           END.
       END.

        FOR FIRST sit-tribut-relacto
            WHERE sit-tribut-relacto.cdn-tribut    = 11
            AND   sit-tribut-relacto.idi-tip-docto = INTEGER(wh-idi-tip-docto:SCREEN-VALUE)
            AND   sit-tribut-relacto.cod-item      = wh-cod-item:SCREEN-VALUE NO-LOCK:

            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Relacionamento CEST X C¢digo Item inv†lido~~" + 
                                     "J† existe relacionamento CEST X C¢digo Item de " + fnRetornaTp(INTEGER(wh-idi-tip-docto:SCREEN-VALUE)) + " para o item informado.").
            RETURN ERROR.
        END.
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
