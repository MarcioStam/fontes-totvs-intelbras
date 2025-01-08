
{include/i-prgvrs.i re2001t-upc-change-value 2.00.00.001}  /*** 010001 ***/
/* recebe por parametro QUERY do browse da tela */
DEFINE INPUT PARAM p-query AS HANDLE NO-UNDO.
DEFINE VARIABLE h-buffer   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-field    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-emitente AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-serie-docto  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-nro-docto    AS WIDGET-HANDLE NO-UNDO.

ASSIGN h-buffer = p-query:GET-BUFFER-HANDLE(1). /* pega buffer do registro corrente */

/*Busca o item que est  sendo apresentado em tela para manipular a informa‡Æo */
FIND FIRST it-doc-fisico NO-LOCK 
     WHERE it-doc-fisico.serie-docto  = h-buffer:BUFFER-FIELD('serie-docto'):BUFFER-VALUE
       AND it-doc-fisico.nro-docto    = wgh-nro-docto:SCREEN-VALUE       
       AND it-doc-fisico.cod-emitente = INTEGER(wgh-cod-emitente:SCREEN-VALUE)
       AND it-doc-fisico.tipo-nota    = h-buffer:BUFFER-FIELD('tipo-nota'):BUFFER-VALUE
       AND it-doc-fisico.sequencia    = h-buffer:BUFFER-FIELD('sequencia'):BUFFER-VALUE NO-ERROR.

/* altera oa nat-acomp que era pre-carregada pelo valor real que existe no banco de dados*/
IF AVAIL it-doc-fisico AND it-doc-fisico.nat-comp <> "" THEN DO:

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = it-doc-fisico.nat-comp NO-ERROR.

    IF AVAIL natur-oper
    AND natur-oper.tipo = 1 THEN
        ASSIGN h-buffer:BUFFER-FIELD('nat-comp'):BUFFER-VALUE = it-doc-fisico.nat-comp.
END.
