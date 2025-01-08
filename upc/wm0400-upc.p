/* Par³metros */
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.


/* Variÿveis Globais */

DEFINE NEW GLOBAL SHARED VARIABLE r-wm-saldo-estoque-wm0400 AS ROWID        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-trans           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_browse             AS HANDLE            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-wm0400-upc        AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-query-wm0400     AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-buffer-wm0400    AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-column-id-box-wm0400 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW global SHARED VARIABLE h-column-seq-wm0400 AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_bt-next-wm0400  AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_bt-PREV-wm0400  AS WIDGET-HANDLE       NO-UNDO.


def var i-cod-comp  as INTEGER no-undo.
def var i-seq-comp  as INTEGER no-undo.
def var c-equipto   as char    no-undo.

/* Variÿveis Locais */
DEFINE VARIABLE h_Frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-cod-comp-aux AS INTEGER  INIT 1   NO-UNDO.


/* Atualiza variÿvel que verifica objeto */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

IF  p-ind-event  = "BEFORE-INITIALIZE"  THEN DO:
    RUN upc/wm0400-upc.p PERSISTENT SET h-wm0400-upc (INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table).
END.

IF p-ind-event  = "AFTER-INITIALIZE" THEN DO:

        ASSIGN h_Frame = p-wgh-frame:FIRST-CHILD. 
        ASSIGN h_Frame = h_Frame:FIRST-CHILD.
        DO WHILE h_Frame <> ? :
           if h_frame:type <> "field-group" then do: 
                IF h_Frame:NAME = "brson1" THEN DO :
                   assign h_browse = h_Frame
                          wh-query-wm0400  = h_browse:QUERY                   
                          wh-buffer-wm0400 = wh-query-wm0400:GET-BUFFER-HANDLE(1).
                   leave.
                END.
                IF h_Frame:NAME = "bTNEXT" THEN 
                   assign h_bt-next-wm0400 = h_Frame.
                IF h_Frame:NAME = "bTNEXT" THEN 
                   assign h_bt-prev-wm0400 = h_Frame.

                ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
             end. 
             else do:
               assign h_frame = h_frame:first-child.
             end.   
        END.

        /* Usa a fun»’o ADD-CALC-COLUMN para inserir uma nova coluna no browse (Parametros: tipo, formato, valor inicial, Label, posi»’o no Browse) */
        wh-dt-trans = h_browse:ADD-CALC-COLUMN("date", "99/99/9999", "", "Dt Trans", 3).
        IF VALID-HANDLE(h-wm0400-upc) THEN
            ON ROW-DISPLAY OF h_browse PERSISTENT RUN pi-row-display SET h-wm0400-upc.

        IF  VALID-HANDLE(h_bt-next-wm0400) THEN DO:
            APPLY "choose" TO h_bt-next-wm0400 .
            APPLY "choose" TO h_bt-prev-wm0400 .
        END.
END.

IF  p-ind-event = "after-display" THEN DO:
    ASSIGN r-wm-saldo-estoque-wm0400 = p-row-table.
END.

PROCEDURE pi-row-display:

    DEF VAR da-data-trans AS DATE FORMAT "99/99/9999" NO-UNDO .
    
    FIND FIRST wm-saldo-estoq NO-LOCK
        WHERE ROWID(wm-saldo-estoq) = r-wm-saldo-estoque-wm0400 NO-ERROR.


    IF  AVAIL wm-saldo-estoq THEN DO:

        IF VALID-HANDLE(wh-buffer-wm0400) THEN
            ASSIGN h-column-id-box-wm0400 = wh-buffer-wm0400:BUFFER-FIELD("id-box") NO-ERROR.

        FOR EACH wm-box-saldo
             where wm-box-saldo.cod-estabel       = wm-saldo-estoq.cod-estab 
               and wm-box-saldo.cod-local         = wm-saldo-estoque.cod-local 
               and wm-box-saldo.cod-item          = wm-saldo-estoque.cod-item
               and wm-box-saldo.cod-cliente       = wm-saldo-estoque.cod-cliente
               and wm-box-saldo.cod-refer         = ""
               and wm-box-saldo.cod-lote          = ""
               AND wm-box-saldo.id-box            = int(h-column-id-box-wm0400:BUFFER-VALUE)
               and wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq
               and wm-box-saldo.ind-status-saldo  = 3 /* liberado */ no-lock,
             first wm-box
             where wm-box.cod-estabel       = wm-box-saldo.cod-estabel
               and wm-box.cod-local         = wm-box-saldo.cod-local
               /*and wm-box.log-bloq-retir    = NO /** Liberado Retirada **/*/
               and wm-box.id-box            = wm-box-saldo.id-box no-lock,
             first wm-tipo-box /* normal */ where 
                   (wm-tipo-box.ind-status-box  = 1 or
                    wm-tipo-box.ind-status-box  = 2) and 
                    wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box no-lock,                    
             FIRST wm-item-embalagem-local
             WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local 
               AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK
                 by wm-box-saldo.dt-transacao    
                 by wm-box-saldo.cod-cliente
                 by wm-box-saldo.cod-estabel
                 by wm-box-saldo.cod-local
                 by wm-box-saldo.cod-item
                 by wm-box-saldo.cod-refer
                 by wm-box-saldo.cod-lote
                 by wm-box-saldo.ind-status-saldo
                 by wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
                 by wm-box.cod-bloco            
                 by wm-box.cod-rua              
                 by wm-box.cod-coluna           
                 by wm-box.cod-nivel   
                 BY wm-item-embalagem-local.qtd-volume.

            ASSIGN da-data-trans = wm-box-saldo.dt-transacao.
            LEAVE.
        END.
    
        IF  VALID-HANDLE(wh-dt-trans) THEN DO:
                ASSIGN wh-dt-trans:SCREEN-VALUE = string(da-data-trans) NO-ERROR .
        END.
    END.
END.


IF  p-ind-event  = "AFTER-DESTROY-INTERFACE"  THEN DO:
    DELETE PROCEDURE  h-wm0400-upc .
     h-wm0400-upc  = ?.
END.

RETURN "ok".


