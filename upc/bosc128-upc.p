/********************************************************************************
**  Programa: BOSC128-UPC.P                                    
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: UPC do DBO de µrea de Picking WMS - BOSC128
**            Grava o campos espec¡ficos
**            A exibi‡Æo ‚ feita pela UPC do Programa WM0210A.
********************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWm-Aux NO-UNDO LIKE wm-picking
    FIELD r-Rowid AS ROWID.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-flow-rack   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-qt-min-pick AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-qt-max-pick AS WIDGET-HANDLE  NO-UNDO.

DEFINE VARIABLE de-qtd-item-embal AS DECIMAL     NO-UNDO.
/* Parƒmetros da UPC */

DEF INPUT PARAM  p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF VAR h-bo  AS HANDLE NO-UNDO.

IF p-ind-event = "beforeCreateRecord" 
OR p-ind-event = "beforeUpdateRecord" THEN DO:

    IF NOT VALID-HANDLE(wgh-flow-rack)
    OR NOT VALID-HANDLE(wgh-qt-min-pick)
    OR NOT VALID-HANDLE(wgh-qt-max-pick) THEN
        RETURN "OK".

    IF wgh-flow-rack:CHECKED THEN DO: /* so valida se ‚ flow rack */
        IF INT(wgh-qt-min-pick:SCREEN-VALUE) >= INT(wgh-qt-max-pick:SCREEN-VALUE)THEN DO:
            RUN piCreateError (INPUT 17006, INPUT "Quantidade M¡nima e M xima Flow Rack inv lidas").
            RETURN "NOK".
        END.
    END.

END.

IF  p-ind-event = "afterUpdateRecord"
OR  p-ind-event = "afterCreateRecord"
OR  p-ind-event = "afterDeleteRecord" THEN DO:

    FIND FIRST tt-epc WHERE 
               tt-epc.cod-event = p-ind-event AND
               tt-epc.cod-parameter = "OBJECT-HANDLE" NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:

        ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).
        
        RUN getRecord IN h-bo (OUTPUT TABLE ttWm-aux).

        FIND FIRST ttWm-aux NO-ERROR.

        IF NOT AVAIL ttWm-aux THEN
            RETURN "OK".

        FIND FIRST ext-wm-picking EXCLUSIVE-LOCK
            WHERE ext-wm-picking.cod-estabel = ttWm-aux.cod-estabel
              AND ext-wm-picking.cod-local   = ttWm-aux.cod-local
              AND ext-wm-picking.cod-picking = ttWm-aux.cod-picking NO-ERROR.

        IF p-ind-event = "afterDeleteRecord" THEN DO:
            IF AVAIL ext-wm-picking THEN
                DELETE ext-wm-picking.
        END.
        ELSE DO:
            IF NOT AVAIL ext-wm-picking THEN DO:
                CREATE ext-wm-picking.
                ASSIGN ext-wm-picking.cod-estabel = ttWm-aux.cod-estabel
                       ext-wm-picking.cod-local   = ttWm-aux.cod-local
                       ext-wm-picking.cod-picking = ttWm-aux.cod-picking.
            END.

            IF VALID-HANDLE(wgh-flow-rack) THEN
                ASSIGN ext-wm-picking.log-flow-rack = wgh-flow-rack:CHECKED.

            IF VALID-HANDLE(wgh-qt-min-pick) THEN
                ASSIGN ext-wm-picking.qtd-min-pick = INT(wgh-qt-min-pick:SCREEN-VALUE).
            
            IF VALID-HANDLE(wgh-qt-max-pick) THEN
                ASSIGN ext-wm-picking.qtd-max-pick = INT(wgh-qt-max-pick:SCREEN-VALUE).

            IF ext-wm-picking.log-flow-rack THEN DO:
                FOR FIRST wm-item-picking EXCLUSIVE-LOCK
                    WHERE wm-item-picking.cod-estabel = ttWm-aux.cod-estabel
                      AND wm-item-picking.cod-local   = ttWm-aux.cod-local
                      AND wm-item-picking.cod-picking = ttWm-aux.cod-picking:

                    FOR FIRST wm-item-embalagem-local NO-LOCK
                         WHERE wm-item-embalagem-local.cod-estabel   = wm-item-picking.cod-estabel
                           AND wm-item-embalagem-local.cod-local     = wm-item-picking.cod-local
                           AND wm-item-embalagem-local.cod-embalagem = wm-item-picking.cod-emb-area
                           AND wm-item-embalagem-local.cod-item      = wm-item-picking.cod-item:
                        ASSIGN de-qtd-item-embal = wm-item-embalagem-local.qtd-item-emb.
                    END.
    
                    IF NOT AVAIL wm-item-embalagem-local THEN DO: /* procura na embal filha */
                        FOR FIRST wm-item-embalagem-local NO-LOCK
                             WHERE wm-item-embalagem-local.cod-estabel   = wm-item-picking.cod-estabel
                               AND wm-item-embalagem-local.cod-local     = wm-item-picking.cod-local
                               AND wm-item-embalagem-local.cod-item      = wm-item-picking.cod-item
                               AND wm-item-embalagem-local.cod-emb-item  = wm-item-picking.cod-emb-area:
                            ASSIGN de-qtd-item-embal = wm-item-embalagem-local.qtd-emb-item.
                        END.
                    END.

                    ASSIGN wm-item-picking.qtd-minima = de-qtd-item-embal * ext-wm-picking.qtd-min-pick.
                END.

                /* ajusta capacidade */
                RUN esp/wmp/eswmapi002.p (INPUT ttWm-aux.cod-estabel,
                                          INPUT ttWm-aux.cod-local,
                                          INPUT ttWm-aux.cod-picking,
                                          OUTPUT TABLE RowErrors).
            END.
        END.
    END.
END.

/**************************** procedures *****************************/
PROCEDURE piCreateError:
    DEFINE INPUT  PARAMETER pCodErro  AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pDescErro AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-bo AS HANDLE      NO-UNDO.

    FIND FIRST tt-epc WHERE 
               tt-epc.cod-event = p-ind-event AND
               tt-epc.cod-parameter = "OBJECT-HANDLE" NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).

            run _insertErrorManual in h-bo (input pCodErro,
                                            input "EMS",
                                            input "ERROR",
                                            input pDescErro,
                                            input pDescErro,
                                            input pDescErro).
    END.

    RETURN "OK".
END PROCEDURE.
