{include/i-prgvrs.i BODI135CANCEL-UPC-AUX 2.00.00.000}  /*** 010000 ***/
{include/i-epc200.i1}

/***************** Defini‡äes de Parametros ************************************/
DEF INPUT PARAM p-ind-event      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID         NO-UNDO.

IF SEARCH("gtupc/bodi135cancel-upc.p") <> ? THEN
    RUN gtupc/bodi135cancel-upc.p (INPUT p-ind-event ,
                                   INPUT p-ind-object,
                                   INPUT p-wgh-object,
                                   INPUT p-wgh-frame ,
                                   INPUT p-cod-table ,
                                   INPUT p-row-table ).


IF SEARCH("upc/bodi135cancel-upc.p") <> ? THEN
    RUN upc/bodi135cancel-upc.p (INPUT p-ind-event ,
                                 INPUT p-ind-object,
                                 INPUT p-wgh-object,
                                 INPUT p-wgh-frame ,
                                 INPUT p-cod-table ,
                                 INPUT p-row-table ).
