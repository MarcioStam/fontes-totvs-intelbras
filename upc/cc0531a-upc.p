/* ----------------------------------------------------------------------------
   Programa..: upc/cc0531a-upc.p
   Data......: 20/05/2010.
   Autor.....: Gustavo Eduardo Tamanini - SQL WORKS
   Objetivo..: Trazer condiá∆o de pagamento do fornecedor no momento da inclus∆o.
---------------------------------------------------------------------------- */

/* Parameter Definitions ****************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER.
DEFINE INPUT PARAMETER p-row-table  AS ROWID.

DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR h-frame    AS HANDLE   NO-UNDO.

/* Global Variable Definitions **********************************************/
DEF NEW GLOBAL SHARED VAR h-cc0531a-upc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-emit-cc0531a      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-cond-cc0531a      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-cond-cc0531a     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-cc0531a          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo-cc0531a         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lote-minimo-cc0531a   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lote-mul-for-cc0531a  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-jan-cancel-cc0531a AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fi-jan-cancel-cc0531a AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-classe-repro-cc0531a  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-moeda-padrao-cc0531a  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-it-codigo              AS CHARACTER     NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-cod-emitente           AS INTEGER       NO-UNDO.                          

DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.

DEF VAR l-ativo AS LOG NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").
/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        "Item   " c-it-codigo  SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF p-ind-object = "container" THEN DO:
    CASE p-ind-event:
        WHEN "BEFORE-INITIALIZE" THEN DO:
            RUN upc/cc0531a-upc.p PERSISTENT SET h-cc0531a-upc (INPUT "",            
                                                                INPUT "",            
                                                                INPUT p-wgh-object,  
                                                                INPUT p-wgh-frame,   
                                                                INPUT "",            
                                                                INPUT p-row-table).  

            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.

            DO WHILE VALID-HANDLE(h-frame):
                IF h-frame:NAME = "fPage1":U THEN DO:
                    ASSIGN h-frame = h-frame:FIRST-CHILD.
                    ASSIGN h-frame = h-frame:FIRST-CHILD.
                    LEAVE.
                END.
                ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
            END.

            DO WHILE VALID-HANDLE(h-frame):
                IF h-frame:TYPE <> "field-group":U THEN DO:
                    CASE h-frame:NAME:
                        WHEN "lote-minimo":U     THEN ASSIGN wh-lote-minimo-cc0531a  = h-frame.
                        WHEN "lote-mul-for":U    THEN ASSIGN wh-lote-mul-for-cc0531a = h-frame.
                        WHEN "cod-emitente":U    THEN ASSIGN wh-cod-emit-cc0531a     = h-frame.
                        WHEN "cod-cond-pag":U    THEN ASSIGN wh-cod-cond-cc0531a     = h-frame.
                        WHEN "c-desc-cond-pag":U THEN ASSIGN wh-desc-cond-cc0531a    = h-frame.
                        WHEN "c-nome-fornec":U   THEN ASSIGN wh-nome-cc0531a         = h-frame.
                        WHEN "ativo":U           THEN ASSIGN wh-ativo-cc0531a        = h-frame.
                        WHEN "classe-repro":U    THEN ASSIGN wh-classe-repro-cc0531a = h-frame.
                        WHEN "fi-moeda-padrao"   THEN ASSIGN wh-moeda-padrao-cc0531a = h-frame.
                    END CASE.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
                END.
                ELSE LEAVE.
            END.
            IF VALID-HANDLE(wh-cod-emit-cc0531a) THEN
                ON "LEAVE":U OF wh-cod-emit-cc0531a PERSISTENT RUN pi-leave-emitente IN h-cc0531a-upc.

            ASSIGN de-aux                                    = wh-cod-cond-cc0531a:ROW - wh-lote-minimo-cc0531a:ROW
                   wh-cod-cond-cc0531a:ROW                   = wh-lote-minimo-cc0531a:ROW
                   wh-desc-cond-cc0531a:ROW                  = wh-lote-minimo-cc0531a:ROW
                   wh-cod-cond-cc0531a:SIDE-LABEL-HANDLE:ROW = wh-cod-cond-cc0531a:SIDE-LABEL-HANDLE:ROW - de-aux.

            CREATE TEXT wh-tx-jan-cancel-cc0531a
            ASSIGN FRAME        = wh-cod-cond-cc0531a:FRAME
                   FORMAT       = "x(20)":U
                   WIDTH        = wh-cod-cond-cc0531a:SIDE-LABEL-HANDLE:WIDTH
                   HEIGHT       = wh-lote-mul-for-cc0531a:SIDE-LABEL-HANDLE:HEIGHT
                   SCREEN-VALUE = "Janela Cancelamento:":U
                   ROW          = wh-lote-mul-for-cc0531a:SIDE-LABEL-HANDLE:ROW
                   COLUMN       = wh-cod-cond-cc0531a:SIDE-LABEL-HANDLE:COLUMN + 21.7
                   VISIBLE      = YES.

            CREATE FILL-IN wh-fi-jan-cancel-cc0531a
            ASSIGN NAME               = "wh-fi-jan-cancel-cc0531a":U
                   FRAME              = wh-cod-cond-cc0531a:FRAME
                   DATA-TYPE          = "INTEGER":U
                   FORMAT             = ">>9":U
                   SIDE-LABEL-HANDLE  = wh-tx-jan-cancel-cc0531a:HANDLE
                   WIDTH              = wh-cod-cond-cc0531a:WIDTH
                   HEIGHT             = wh-lote-mul-for-cc0531a:HEIGHT
                   ROW                = wh-lote-mul-for-cc0531a:ROW
                   COLUMN             = wh-cod-cond-cc0531a:COLUMN + 20
                   LABEL              = "Janela Cancelamento:":U
                   VISIBLE            = YES
                   SENSITIVE          = NO
                   FONT               = 1.

            
        END.
        WHEN "AFTER-INITIALIZE":U THEN DO:
            wh-moeda-padrao-cc0531a:MOVE-AFTER-TAB-ITEM(wh-cod-cond-cc0531a).
            wh-fi-jan-cancel-cc0531a:MOVE-AFTER-TAB-ITEM(wh-moeda-padrao-cc0531a).
            wh-classe-repro-cc0531a:MOVE-AFTER-TAB-ITEM(wh-fi-jan-cancel-cc0531a).
        END.
        WHEN "AFTER-DISPLAY":U THEN DO:
            FIND FIRST item-fornec-estab
                WHERE ROWID(item-fornec-estab) = p-row-table NO-LOCK NO-ERROR.

            IF AVAILABLE item-fornec-estab THEN DO:
                FIND FIRST int-item-fornec
                    WHERE int-item-fornec.it-codigo    = item-fornec-estab.it-codigo
                      AND int-item-fornec.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.

                IF AVAILABLE int-item-fornec THEN
                    ASSIGN wh-fi-jan-cancel-cc0531a:SCREEN-VALUE = TRIM(STRING(int-item-fornec.janela-dias-cancel)).
                ELSE
                    ASSIGN wh-fi-jan-cancel-cc0531a:SCREEN-VALUE = "0":U.
            END.
            ELSE
                ASSIGN wh-fi-jan-cancel-cc0531a:SCREEN-VALUE = "0":U.
        END.
        WHEN "AFTER-ENABLE":U THEN DO:
            ASSIGN wh-fi-jan-cancel-cc0531a:SENSITIVE = YES.
        END.
        WHEN "before-SAVE-FIELDS" THEN DO:
            FIND item-fornec WHERE 
                 item-fornec.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE)  AND
                 item-fornec.it-codigo    = c-it-codigo EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL item-fornec THEN DO:
                FIND ITEM WHERE
                     ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

                CREATE item-fornec.
                ASSIGN item-fornec.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE)
                       item-fornec.it-codigo    = c-it-codigo
                       item-fornec.unid-med-for = IF AVAIL ITEM THEN ITEM.un ELSE ""
                      /* item-fornec.item-do-forn = wh-cod-emit-cc0531a:SCREEN-VALUE*/.
            END.
            
            FIND int-item-for-PN 
                WHERE int-item-for-PN.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE)  
                  AND int-item-for-PN.it-codigo    = c-it-codigo NO-LOCK NO-ERROR.                           

            IF NOT AVAIL int-item-for-PN THEN DO:
                FIND ITEM WHERE
                     ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

                CREATE int-item-for-PN.
                ASSIGN int-item-for-PN.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE)
                       int-item-for-PN.it-codigo    = c-it-codigo
                       int-item-for-PN.item-do-forn = wh-cod-emit-cc0531a:SCREEN-VALUE.

                RELEASE int-item-for-PN.
            END.

            IF wh-ativo-cc0531a:SCREEN-VALUE = "Sim" THEN DO:
                ASSIGN item-fornec.ativo = YES.
            END.
            ELSE DO:
                ASSIGN item-fornec.ativo = NO.
            END.

            RELEASE item-fornec.
        END.
        WHEN "AFTER-ASSIGN":U THEN DO:
            FIND FIRST item-fornec-estab
                WHERE ROWID(item-fornec-estab) = p-row-table NO-LOCK NO-ERROR.

            IF AVAILABLE item-fornec-estab THEN DO:
                FIND FIRST int-item-fornec
                    WHERE int-item-fornec.it-codigo    = item-fornec-estab.it-codigo
                      AND int-item-fornec.cod-emitente = item-fornec-estab.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAILABLE int-item-fornec THEN DO:
                    CREATE int-item-fornec.
                    ASSIGN int-item-fornec.it-codigo    = item-fornec-estab.it-codigo
                           int-item-fornec.cod-emitente = item-fornec-estab.cod-emitente.
                END.

                ASSIGN int-item-fornec.janela-dias-cancel = INTEGER(TRIM(wh-fi-jan-cancel-cc0531a:SCREEN-VALUE)).

                RELEASE int-item-fornec.
            END.
        END.
        WHEN "AFTER-DESTROY-INTERFACE" THEN DO:
            ASSIGN l-ativo = NO.
            FOR EACH item-fornec-estab
               WHERE item-fornec-estab.it-codigo = c-it-codigo
                 AND item-fornec-estab.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE) NO-LOCK:
                IF item-fornec-estab.ativo THEN
                    ASSIGN l-ativo = YES.
            END.

            FIND item-fornec WHERE 
                 item-fornec.cod-emitente = int(wh-cod-emit-cc0531a:SCREEN-VALUE)  AND
                 item-fornec.it-codigo    = c-it-codigo EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL item-fornec THEN DO:
                ASSIGN item-fornec.perc-compra = 0.

                IF l-ativo THEN
                    ASSIGN item-fornec.ativo = YES.
            END.

            RELEASE item-fornec.

            IF VALID-HANDLE(h-cc0531a-upc) THEN
                ASSIGN h-cc0531a-upc = ?.

            IF VALID-HANDLE(wh-cod-emit-cc0531a) THEN
                ASSIGN wh-cod-emit-cc0531a = ?.

            IF VALID-HANDLE(wh-cod-cond-cc0531a) THEN
                ASSIGN wh-cod-cond-cc0531a = ?.

            IF VALID-HANDLE(wh-desc-cond-cc0531a) THEN
                ASSIGN wh-desc-cond-cc0531a = ?.

            IF VALID-HANDLE(wh-nome-cc0531a) THEN
                ASSIGN wh-nome-cc0531a = ?.

            IF VALID-HANDLE(wh-ativo-cc0531a) THEN
                ASSIGN wh-ativo-cc0531a = ?.

            IF VALID-HANDLE(wh-lote-minimo-cc0531a) THEN
                ASSIGN wh-lote-minimo-cc0531a = ?.

            IF VALID-HANDLE(wh-lote-mul-for-cc0531a) THEN
                ASSIGN wh-lote-mul-for-cc0531a = ?.

            IF VALID-HANDLE(wh-tx-jan-cancel-cc0531a) THEN
                ASSIGN wh-tx-jan-cancel-cc0531a = ?.

            IF VALID-HANDLE(wh-fi-jan-cancel-cc0531a) THEN
                ASSIGN wh-fi-jan-cancel-cc0531a = ?.

            IF VALID-HANDLE(wh-classe-repro-cc0531a) THEN
                ASSIGN wh-classe-repro-cc0531a = ?.
        END.
    END CASE.
END.

PROCEDURE pi-leave-emitente:
    IF  VALID-HANDLE(wh-cod-emit-cc0531a) AND
        VALID-HANDLE(wh-cod-cond-cc0531a) AND
        VALID-HANDLE(wh-nome-cc0531a)     THEN DO:

        

        FOR FIRST emitente FIELDS (nome-abrev cod-cond-pag)
            WHERE emitente.cod-emitente = INT(wh-cod-emit-cc0531a:SCREEN-VALUE) NO-LOCK: 
        END.    
        IF AVAIL emitente THEN
            ASSIGN wh-nome-cc0531a:SCREEN-VALUE     = emitente.nome-abrev
                   wh-cod-cond-cc0531a:SCREEN-VALUE = STRING(emitente.cod-cond-pag).
        ELSE
            ASSIGN wh-nome-cc0531a:SCREEN-VALUE     = "":U
                   wh-cod-cond-cc0531a:SCREEN-VALUE = "":U.

        ASSIGN i-cod-emitente = INT(wh-cod-emit-cc0531a:SCREEN-VALUE).

        FIND FIRST dist-emitente NO-LOCK
             WHERE dist-emitente.cod-emitente = i-cod-emitente NO-ERROR.
        
        IF AVAIL dist-emitente THEN
            ASSIGN wh-moeda-padrao-cc0531a:SCREEN-VALUE = STRING(dist-emitente.mo-fatur).
        ELSE 
            ASSIGN wh-moeda-padrao-cc0531a:SCREEN-VALUE = "".

        
        APPLY "LEAVE" TO wh-cod-cond-cc0531a.
    END.
END PROCEDURE.

