FUNCTION fnConvDatetimeChar RETURNS CHAR (INPUT p-dt AS DATETIME) :

    DEFINE VARIABLE c-dt AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE d-hor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-min AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-sec AS DECIMAL     NO-UNDO.


    ASSIGN d-hor = truncate(MTIME(p-dt) / 1000 / 60 / 60, 0)
           d-min = TRUNCATE((MTIME(p-dt) / 1000 / 60) - (d-hor * 60), 0)
           d-sec = TRUNCATE((MTIME(p-dt) / 1000) - (d-hor * 3600) - (d-min * 60), 0).

    ASSIGN c-dt = string(YEAR(p-dt), "9999") + "-" + STRING(MONTH(p-dt), "99") + "-" + STRING(DAY(p-dt), "99") + "T" + STRING(d-hor, "99") + ":" + STRING(d-min, "99") + ":" + STRING(d-sec, "99").

    RETURN c-dt.

END FUNCTION.
