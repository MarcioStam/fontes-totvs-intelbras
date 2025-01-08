define input param p-ind-event as character no-undo.

DEF NEW GLOBAL SHARED VAR wh-log-antidump-esp    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-obs-antidumping     AS WIDGET-HANDLE NO-UNDO.

if p-ind-event = "VALUE-CHANGED" then do:

    if wh-log-antidump-esp:checked then
        assign wh-obs-antidumping:sensitive = yes.
    else
        assign wh-obs-antidumping:sensitive = no.

end.
