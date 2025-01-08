DEF INPUT PARAM p-ind-event        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object       AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object       AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table        AS ROWID         NO-UNDO.
    
DEFINE VARIABLE de-indice AS DECIMAL       NO-UNDO.
DEFINE VARIABLE h-objec   AS HANDLE        NO-UNDO.


DEF VAR c-objeto    AS CHAR            NO-UNDO.


ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), 
                        p-wgh-object:FILE-NAME,"~/").

{utp/ut-glob.i}

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)SKIP  */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */



IF  p-ind-event = "AFTER-END-UPDATE" 
AND c-objeto    = "cc0301b-v01.w" THEN DO:

    FIND FIRST prazo-compra EXCLUSIVE-LOCK
         WHERE ROWID(prazo-compra) = p-row-table NO-ERROR.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-ERROR.

    FIND FIRST cotacao-item EXCLUSIVE-LOCK 
         WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem NO-ERROR.

    IF AVAILABLE cotacao-item THEN
        ASSIGN cotacao-item.data-cotacao = TODAY
               cotacao-item.usuario      = c-seg-usuario
               cotacao-item.data-atualiz = TODAY
               cotacao-item.hora-atualiz = TRIM(STRING(TIME, "hh:mm:ss":U)).

    IF  AVAIL prazo-compra 
    AND AVAIL ordem-compra THEN DO:
        ASSIGN de-indice = 1.
    
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = prazo-compra.it-codigo NO-ERROR.
    
        IF AVAILABLE item THEN DO:
            FIND FIRST item-fornec NO-LOCK
                 WHERE item-fornec.it-codigo    = ITEM.it-codigo
                   AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
    
            IF (ITEM.tipo-contr = 4 AND NOT AVAILABLE item-fornec OR ITEM.it-codigo = "":U) THEN DO:
                IF AVAILABLE cotacao-item             AND
                   cotacao-item.un <> prazo-compra.un THEN DO:
                    FIND FIRST tab-conv-un
                         WHERE tab-conv-un.un           = prazo-compra.un
                           AND tab-conv-un.unid-med-for = cotacao-item.un NO-LOCK NO-ERROR.
    
                    IF AVAILABLE tab-conv-un THEN
                        ASSIGN de-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
                END.
            END.
            ELSE IF AVAILABLE item-fornec THEN
                ASSIGN de-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
        END.
    
        ASSIGN prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
               prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn.    
    END.

END.
