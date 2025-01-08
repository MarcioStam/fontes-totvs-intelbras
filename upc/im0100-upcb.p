/***********************************************************************
**  Programa..: upc\im0100-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF INPUT PARAM p-tipo AS INT.

DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-docto-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-cotacao-im0100   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-di-im0100        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-im0100          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0100    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-icms-diferido-im0100  AS WIDGET-HANDLE    NO-UNDO.

CASE p-tipo:
    WHEN 1 THEN
        IF wh-data-di-im0100:SCREEN-VALUE <> "" THEN
            ASSIGN wh-data-cotacao-im0100:SCREEN-VALUE = STRING(DATE(wh-data-di-im0100:SCREEN-VALUE) - 2).
    WHEN 2 THEN
        IF wh-embarque-im0100:SCREEN-VALUE <> "" THEN 
            ASSIGN wh-nr-docto-im0100:SCREEN-VALUE = FILL("0",7 - LENGTH(TRIM(wh-embarque-im0100:SCREEN-VALUE))) + TRIM(wh-embarque-im0100:SCREEN-VALUE).
    WHEN 3 THEN DO:
        IF wh-natureza-im0100:SCREEN-VALUE <> "" THEN DO:
            FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = wh-natureza-im0100:SCREEN-VALUE NO-ERROR.
            IF AVAIL natur-oper
            AND natur-oper.ind-it-sub-dif = ? THEN
                ASSIGN wh-icms-diferido-im0100:CHECKED = YES.
        END.
    END.
    WHEN 4 THEN DO:
        IF wh-cod-estabel-im0100:SCREEN-VALUE <> "" THEN DO:
            FOR EACH ser-estab
               WHERE ser-estab.cod-estabel = wh-cod-estabel-im0100:SCREEN-VALUE NO-LOCK:
                IF ser-estab.log-2 THEN
                    ASSIGN wh-serie-im0100:SCREEN-VALUE = ser-estab.serie.
            END.
        END.
    END.
END CASE.
