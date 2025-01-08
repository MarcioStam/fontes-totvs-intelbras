{utp/ut-glob.i}

DEF VAR wh-pesquisa AS WIDGET-HANDLE.
DEF NEW GLOBAL SHARED VAR l-implanta AS LOGICAL INIT NO.
DEF NEW GLOBAL SHARED VAR wh-fill    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-window  AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-transp-wm1050A AS WIDGET-HANDLE  NO-UNDO.

IF VALID-HANDLE(wh-cod-transp-wm1050A) THEN DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w 
                       &proghandle=wh-window 
                       &campohandle=wh-cod-transp-wm1050A
                       &campozoom=nome-abrev}
END.
