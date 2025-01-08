/* --------------------------------------------------------- */
/* Calcular Vencimento conforme regra cadastrada no ESACR070 */
/* --------------------------------------------------------- */
           
DEF INPUT  PARAM p-emitente     AS INTEGER  NO-UNDO.
DEF INPUT  PARAM da-base        AS DATE     NO-UNDO.
DEF OUTPUT PARAM da-prorrogada  AS DATE     NO-UNDO.

/* Fun‡äes de prorroga‡Æo de vencimento */
{esp/acr/esacrapi002.i}

DEF BUFFER b-matriz FOR emitente.

ASSIGN da-prorrogada = da-base.

FIND emitente NO-LOCK
    WHERE emitente.cod-emitente = p-emitente NO-ERROR.
IF  NOT AVAIL emitente THEN
    RETURN "OK".

FIND int-cond-pag-cli NO-LOCK
    WHERE int-cond-pag-cli.cod-emitente = p-emitente NO-ERROR.

IF  NOT AVAIL int-cond-pag-cli THEN DO:
    /* Verifica se a matriz est  parametrizada como grupo econ“mico */
    FIND b-matriz NO-LOCK
        WHERE b-matriz.nome-abrev = emitente.nome-matriz.

    IF  NOT AVAIL b-matriz THEN
        RETURN "OK".

    FIND int-cond-pag-cli NO-LOCK
        WHERE int-cond-pag-cli.cod-emitente = b-matriz.cod-emitente NO-ERROR.

    IF  NOT AVAIL int-cond-pag-cli THEN
        RETURN "OK".

    IF  NOT int-cond-pag-cli.grupo-econ THEN
        RETURN "OK".
END.

IF int-cond-pag-cli.prazo-dde THEN
    RETURN "OK".


/* SEMANA */
CASE int-cond-pag-cli.vencto-fixo:
    WHEN 1 THEN /* SEMANA */
        ASSIGN da-prorrogada = fnDataProrrogadaDiaSEMANA(INPUT da-base,
                                                         INPUT int-cond-pag-cli.semana).
    WHEN 2 THEN /* DIA MÒS FIXO */
        ASSIGN da-prorrogada = fnDataProrrogadaDiaMES(INPUT da-base,
                                                      INPUT int-cond-pag-cli.mes).
    WHEN 3 THEN /* NENHUM */
        ASSIGN da-prorrogada = da-base.
END.  

RETURN "OK".
