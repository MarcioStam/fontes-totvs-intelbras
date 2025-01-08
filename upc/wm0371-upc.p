{utp/ut-glob.i}
{upc/btb910za-upc.i}

/* Defini‡Æo da temp-table "tt-prog-ponto" */
{esp/es0018.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
//def input param wh-btCancel        as widget-handle no-undo.

def new global shared var gr-ficha-cq  as rowid  no-undo.

/*
MESSAGE 
    "p-ind-event:  " p-ind-event  SKIP
    "p-ind-object: " p-ind-object SKIP
    "p-wgh-object: " p-wgh-object SKIP
    "p-wgh-frame : " p-wgh-frame  SKIP
    "p-cod-table:  " p-cod-table  SKIP
    "p-row-table:  " string(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF  p-ind-event  = "AFTER-INITIALIZE":U
AND p-ind-object = "CONTAINER"
THEN DO:

    DEFINE VARIABLE h-handle    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE wh-btOK AS HANDLE      NO-UNDO.

    ASSIGN h-handle = p-wgh-frame:FIRST-CHILD.  /* pegando o 1o. Campo */
    bloco:
    DO WHILE h-handle <> ? :
        IF h-handle:TYPE <> "field-group"
        THEN DO:
            IF h-handle:NAME = "btOK"
            THEN DO:
                ASSIGN  wh-btOK = h-handle.
            END.
            ASSIGN h-handle = h-handle:NEXT-SIBLING.
        END. 
        ELSE DO:
            ASSIGN h-handle = h-handle:FIRST-CHILD.
        END.
    END.

    DEFINE VARIABLE logProcessaRejeicao AS LOGICAL     NO-UNDO.
    DEFINE BUFFER bf-wm-roteiro-docto-itens FOR wm-roteiro-docto-itens.

    assign logProcessaRejeicao = no.

    find ficha-cq where rowid(ficha-cq) = gr-ficha-cq NO-LOCK NO-ERROR.

    FIND FIRST bf-wm-roteiro-docto-itens
         WHERE bf-wm-roteiro-docto-itens.nr-ficha = ficha-cq.nr-ficha
        NO-LOCK NO-ERROR.

    if  can-find(first wm-box-saldo no-lock
                 where wm-box-saldo.cod-estabel  = bf-wm-roteiro-docto-itens.cod-estabel
                   and wm-box-saldo.cod-local    = bf-wm-roteiro-docto-itens.cod-local
                   and wm-box-saldo.id-docto     = bf-wm-roteiro-docto-itens.id-docto
                   and wm-box-saldo.num-seq-item = bf-wm-roteiro-docto-itens.num-seq-item
                   and wm-box-saldo.ind-status-saldo = 7) /* CQ-Armazenado */
    then do:
        IF bf-wm-roteiro-docto-itens.qtd-rejeitada > 0
        THEN DO:
            FIND FIRST estabelec
                 WHERE estabelec.cod-estabel = bf-wm-roteiro-docto-itens.cod-estabel
                NO-LOCK NO-ERROR.
            IF CAN-FIND(FIRST rej-ficha
                        WHERE rej-ficha.nr-ficha    = bf-wm-roteiro-docto-itens.nr-ficha
                          AND rej-ficha.dep-rej     = estabelec.dep-rej
                          AND rej-ficha.qt-rejeitada > 0)
            THEN DO:
                assign logProcessaRejeicao = YES.
            END.
        END.
        ELSE DO:
            assign logProcessaRejeicao = NO.
        END.
    end.
    ELSE DO:
        assign logProcessaRejeicao = no.
    END.

    if NOT logProcessaRejeicao
    then do:
        ASSIGN wh-btOK:SENSITIVE = NO.
    end.

END.


