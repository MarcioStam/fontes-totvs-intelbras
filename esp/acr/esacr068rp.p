{utp/ut-glob.i}
{include/i-rpvar.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD clientes         AS LOG
    FIELD compras          AS LOG
    FIELD pendencias       AS LOG
    .

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

RUN pi-exporta.

RETURN "OK".

PROCEDURE pi-exporta:
    /* Programas de Exporta‡Æo */
    IF  tt-param.clientes THEN
        RUN esp/acr/esacr033.p (INPUT "") /*Branco = considera todos*/.

    IF  tt-param.compras THEN
        RUN esp/acr/esacr040.p.

    IF  tt-param.pendencias THEN
        RUN esp/acr/esacr042.p.

    RETURN "OK".
END.


