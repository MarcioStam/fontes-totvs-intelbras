/***************************************************************************
** Programa: gtupc/upc-re1001e.p
** Vers∆o..: 1.00.00.000
** Obs.....: UPC possui o objetivo de informar ao programa gati0102 de que
             a busca por notas de sa°da foi cancelada antes de selecionada
             alguma nota. O objetivo Ç o usuario poder incluir um item de
             forma manual Ö nota, procedimento esse necess†rio em notas de
             concerto.
** Cliente.: Intelbras
** Autor...: Oliver Fagionato
***************************************************************************/

DEFINE INPUT PARAM p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS ROWID         NO-UNDO.

{INCLUDE/VER-HDLS.I &ATIVA-GERACAO-LISTA=NO
                    &TELA-DISCO='D'
                    &NOME-ARQUIVO='c:/tmp/zz.LST'
                    &LISTA-FRAMES=''
                    &LISTA-TIPOS-OBJS=''}
                    
DEF NEW GLOBAL SHARED VAR btOK-re1001e         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR btOK-ESP-re1001e     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR btCancel-re1001e     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR btCancel-ESP-re1001e AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR btSave-re1001e       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR btSave-ESP-re1001e   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR window-re1001e AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-item-manual AS LOGICAL INITIAL NO NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-ok-save     AS LOGICAL INITIAL NO NO-UNDO.

IF p-ind-event = "AFTER-INITIALIZE" THEN DO:

    ASSIGN l-item-manual = NO
           l-ok-save     = NO.

    ASSIGN btOK-re1001e     = IF NOT VALID-HANDLE(btOK-re1001e)     THEN fc-all-hdl("fpage0", "btOK", 000)     ELSE btOK-re1001e
           btCancel-re1001e = IF NOT VALID-HANDLE(btCancel-re1001e) THEN fc-all-hdl("fpage0", "btCancel", 000) ELSE btCancel-re1001e
           btSave-re1001e   = IF NOT VALID-HANDLE(btSave-re1001e)   THEN fc-all-hdl("fpage0", "btSave", 000)   ELSE btSave-re1001e.

    IF VALID-HANDLE(btOK-re1001e)         AND
       NOT VALID-HANDLE(btOK-ESP-re1001e) THEN DO:

        CREATE BUTTON btOK-ESP-re1001e
        ASSIGN HEIGHT       = btOK-re1001e:HEIGHT
               WIDTH        = btOK-re1001e:WIDTH
               FRAME        = btOK-re1001e:FRAME
               ROW          = btOK-re1001e:ROW
               COL          = btOK-re1001e:COL
               SENSITIVE    = YES
               VISIBLE      = YES
               LABEL        = btOK-re1001e:LABEL
               TOOLTIP      = btOK-re1001e:TOOLTIP
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN gtupc/upc-re1001e.p(INPUT "CHOOSE-BTOK-RE1001E",
                                                             INPUT p-ind-object,
                                                             INPUT p-wgh-object,
                                                             INPUT p-wgh-frame,
                                                             INPUT p-cod-table,
                                                             INPUT p-row-table).
            END TRIGGERS.

        ASSIGN btOK-re1001e:SENSITIVE = NO
               btOK-re1001e:VISIBLE   = NO
               btOK-re1001e:WIDTH     = 0.1
               btOK-re1001e:HEIGHT    = 0.1.

        ASSIGN window-re1001e = btOK-re1001e:WINDOW:HANDLE.
        ON WINDOW-CLOSE OF window-re1001e PERSISTENT RUN gtupc/upc-re1001e.p(INPUT "WINDOW-CLOSE-RE1001E",
                                                                             INPUT p-ind-object,
                                                                             INPUT p-wgh-object,
                                                                             INPUT p-wgh-frame,
                                                                             INPUT p-cod-table,
                                                                             INPUT p-row-table).
    END. /* VALID-HANDLE(btOK-re1001e) AND NOT VALID-HANDLE(btOK-ESP-re1001e) */

    IF VALID-HANDLE(btCancel-re1001e)         AND
       NOT VALID-HANDLE(btCancel-ESP-re1001e) THEN DO:

        CREATE BUTTON btCancel-ESP-re1001e
        ASSIGN HEIGHT       = btCancel-re1001e:HEIGHT
               WIDTH        = btCancel-re1001e:WIDTH
               FRAME        = btCancel-re1001e:FRAME
               ROW          = btCancel-re1001e:ROW
               COL          = btCancel-re1001e:COL
               SENSITIVE    = YES
               VISIBLE      = YES
               LABEL        = btCancel-re1001e:LABEL
               TOOLTIP      = btCancel-re1001e:TOOLTIP
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN gtupc/upc-re1001e.p(INPUT "CHOOSE-BTCANCEL-RE1001E",
                                                             INPUT p-ind-object,
                                                             INPUT p-wgh-object,
                                                             INPUT p-wgh-frame,
                                                             INPUT p-cod-table,
                                                             INPUT p-row-table).
            END TRIGGERS.

        ASSIGN btCancel-re1001e:SENSITIVE = NO
               btCancel-re1001e:VISIBLE   = NO
               btCancel-re1001e:WIDTH     = 0.1
               btCancel-re1001e:HEIGHT    = 0.1.
    END. /* VALID-HANDLE(btCancel-re1001e) AND NOT VALID-HANDLE(btCancel-ESP-re1001e) */

    IF VALID-HANDLE(btSave-re1001e)         AND
       NOT VALID-HANDLE(btSave-ESP-re1001e) THEN DO:

        CREATE BUTTON btSave-ESP-re1001e
        ASSIGN HEIGHT       = btSave-re1001e:HEIGHT
               WIDTH        = btSave-re1001e:WIDTH
               FRAME        = btSave-re1001e:FRAME
               ROW          = btSave-re1001e:ROW
               COL          = btSave-re1001e:COL
               SENSITIVE    = YES
               VISIBLE      = YES
               LABEL        = btSave-re1001e:LABEL
               TOOLTIP      = btSave-re1001e:TOOLTIP
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN gtupc/upc-re1001e.p(INPUT "CHOOSE-BTSAVE-RE1001E",
                                                             INPUT p-ind-object,
                                                             INPUT p-wgh-object,
                                                             INPUT p-wgh-frame,
                                                             INPUT p-cod-table,
                                                             INPUT p-row-table).
            END TRIGGERS.

        ASSIGN btSave-re1001e:SENSITIVE = NO
               btSave-re1001e:VISIBLE   = NO
               btSave-re1001e:WIDTH     = 0.1
               btSave-re1001e:HEIGHT    = 0.1.
    END. /* VALID-HANDLE(btSave-re1001e) AND NOT VALID-HANDLE(btSave-ESP-re1001e) */

END. /* p-ind-event = "AFTER-INITIALIZE" */

/* INICIO - Usuario buscou nota de sa°da */
IF p-ind-event = "CHOOSE-BTOK-RE1001E" THEN DO:
    ASSIGN l-ok-save = YES.

    APPLY 'choose' TO btOK-re1001e.
END.
IF p-ind-event = "CHOOSE-BTSAVE-RE1001E" THEN DO:
    ASSIGN l-ok-save = YES.

    APPLY 'choose' TO btSave-re1001e.
END.
/* FIM - Usuario buscou nota de sa°da */

/* INICIO - Usuario cancelou busca de nota de sa°da - possivel nota de concerto */
IF p-ind-event = "CHOOSE-BTCANCEL-RE1001E" THEN DO:

    IF NOT l-ok-save THEN
        ASSIGN l-item-manual = YES.

    APPLY 'choose' TO btCancel-re1001e.
END.
IF p-ind-event = "WINDOW-CLOSE-RE1001E" THEN DO:

    IF NOT l-ok-save THEN
        ASSIGN l-item-manual = YES.

    APPLY 'CLOSE' TO p-wgh-object.
END.
/* FIM - Usuario cancelou busca de nota de sa°da - possivel nota de concerto */

IF p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    ASSIGN btOK-re1001e         = ?
           btOK-ESP-re1001e     = ?
           btCancel-re1001e     = ?
           btCancel-ESP-re1001e = ?
           btSave-re1001e       = ?
           btSave-ESP-re1001e   = ?
           window-re1001e       = ?.
END.
