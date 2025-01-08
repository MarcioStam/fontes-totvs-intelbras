/*------------------------------------------------------------------------
    File        : IM0100-UPCC.P
    Purpose     : Realizar validaá∆o ao clicar no bot∆o "Conferància" da
                  tela IM0100.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Julho de 2012
    Notes       : <none>
----------------------------------------------------------------------*/
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0100      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0100   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btconferencia-im0100 AS HANDLE        NO-UNDO.

DEFINE VARIABLE l-preechido AS LOGICAL     NO-UNDO INITIAL YES.

FOR EACH ordens-embarque NO-LOCK
    WHERE ordens-embarque.cod-estabel = TRIM(wh-cod-estabel-im0100:SCREEN-VALUE)
      AND ordens-embarque.embarque    = TRIM(wh-embarque-im0100:SCREEN-VALUE):

    IF ordens-embarque.num-adic = ? OR
       ordens-embarque.num-adic = 0 OR 
       INTEGER(SUBSTRING(ordens-embarque.char-1, 80, 4)) = ? OR
       INTEGER(SUBSTRING(ordens-embarque.char-1, 80, 4)) = 0 THEN
        ASSIGN l-preechido = NO.
END.

IF l-preechido THEN
    APPLY "CHOOSE":U TO wh-btconferencia-im0100.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Os campos ~"Nr.Adiá∆o~" e ~"Seq. Item Adiá∆o~" n∆o foram preenchidos.":U +
                             "~~":U +
                             "Os campos ~"Nr.Adiá∆o~" e ~"Seq. Item Adiá∆o~" n∆o foram preenchidos no ~"Pesos e Impostos~".":U).

    RETURN "NOK":U.
END.


