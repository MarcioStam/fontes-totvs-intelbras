DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-transp-wm1050A       AS WIDGET-HANDLE  NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-btOk-wm1050A             AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cdn-tipo-equipto-wm1050A AS WIDGET-HANDLE  NO-UNDO.

IF CAN-FIND(FIRST wm-tipo-equipamento WHERE
            wm-tipo-equipamento.cdn-tipo-equipamento   = INT(wh-cdn-tipo-equipto-wm1050a:SCREEN-VALUE) AND
            wm-tipo-equipamento.ind-status-equipamento = 2 NO-LOCK) THEN DO: 

    IF wh-cod-transp-wm1050A:SCREEN-VALUE <> "" AND
       NOT CAN-FIND(FIRST transporte WHERE
                    transporte.nome-abrev = wh-cod-transp-wm1050A:SCREEN-VALUE) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 56,
                           INPUT "Transportador").
        APPLY "ENTRY" TO wh-cod-transp-wm1050A.
    END.
    ELSE DO:
        APPLY "CHOOSE" TO wh-btOk-wm1050A.
    END.

END.
ELSE DO:
    APPLY "CHOOSE" TO wh-btOk-wm1050A.
END.
