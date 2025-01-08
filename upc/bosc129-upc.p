/********************************************************************************
**  Programa: BOSC130-UPC.P                                    
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: UPC do DBO de Endere‡o da µrea de Picking WMS - BOSC130
**            Ajusta capacidade do endere‡o conforme caixas m ximas definidas
**            no programa WM0210A.
********************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWm-Aux NO-UNDO LIKE wm-box-picking
    FIELD r-Rowid AS ROWID.

DEF INPUT PARAM  p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF VAR h-bo  AS HANDLE NO-UNDO.

IF  p-ind-event = "afterUpdateRecord"
OR  p-ind-event = "afterCreateRecord" THEN DO:

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

        IF AVAIL ext-wm-picking 
        AND ext-wm-picking.log-flow-rack THEN DO:
            /* ajusta capacidade */
            RUN esp/wmp/eswmapi002.p (INPUT ttWm-aux.cod-estabel,
                                      INPUT ttWm-aux.cod-local,
                                      INPUT ttWm-aux.cod-picking,
                                      OUTPUT TABLE RowErrors).

        END.
    END.
END.

