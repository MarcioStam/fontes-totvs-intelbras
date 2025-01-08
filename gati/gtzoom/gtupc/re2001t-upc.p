/*******************************************************************************
** Copyright GATI LTDA (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da GATI SA, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i re2001t-upc 2.00.00.000}  /*** 010000 ***/
{include/i-epc200.i1}
{cdp/cdcfgmat.i}

/***************** Defini¯Êo de Parametros ************************************/
DEF INPUT PARAM p-ind-event      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-object       AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-br-itens     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-emitente AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-serie-docto  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-nro-docto    AS WIDGET-HANDLE NO-UNDO.

/* Evento ap¢s componentes criados em tela */
IF p-ind-event = "AFTER-INITIALIZE" THEN DO:
    
    /* pega primeiro objeto da tela */
    ASSIGN wgh-object = p-wgh-frame:FIRST-CHILD.

    /* a partir deste objeto, varre todos os outros */
    DO WHILE VALID-HANDLE(wgh-object):

        /*  caso o objeto da tela seja o Browse que queremos manipular, 
        seta em uma var separada para manipula‡Æo */
        IF wgh-object:NAME = "brItens" THEN DO:
            ASSIGN wgh-br-itens = wgh-object.
        END.

        IF wgh-object:NAME = "cod-emitente" THEN DO:
            ASSIGN wgh-cod-emitente = wgh-object.
        END.

        IF wgh-object:NAME = "serie-docto" THEN DO:
            ASSIGN wgh-serie-docto = wgh-object.
        END.

        IF wgh-object:NAME = "nro-docto" THEN DO:
            ASSIGN wgh-nro-docto = wgh-object.
        END.

        /* se o objeto for um container, varre todos os itens do container tamb‚m 
        caso contrario, passa para o proximo objeto da tela */
        IF wgh-object:TYPE = "field-group" THEN
            ASSIGN wgh-object = wgh-object:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-object = wgh-object:NEXT-SIBLING.
    END.

    /* quando handle estiver valida */
    IF VALID-HANDLE(wgh-br-itens) THEN DO:

        /* acrecenta evento de display no browse para moniturarmos o buffer */
        ON 'ROW-DISPLAY' OF wgh-br-itens PERSISTENT 
            RUN gtupc/re2001t-upc-change-value.p(INPUT wgh-br-itens:QUERY).
        
    END.
END.

