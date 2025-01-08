/*** Busca de emitente ***/

CREATE WIDGET-POOL.

{include/i-freeac.i}

DEFINE INPUT  PARAMETER pCGC         LIKE emitente.cgc          NO-UNDO.
DEFINE OUTPUT PARAMETER pCodEmitente LIKE emitente.cod-emitente NO-UNDO.
DEFINE OUTPUT PARAMETER pNomeEmit    LIKE emitente.nome-emit    NO-UNDO.

FOR FIRST emitente
    WHERE emitente.cgc = pCGC NO-LOCK:

    ASSIGN pCodEmitente = emitente.cod-emitente
           pNomeEmit    = UPPER(TRIM(fn-free-accent(emitente.nome-emit))).
END.
