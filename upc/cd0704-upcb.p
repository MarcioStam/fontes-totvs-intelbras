/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upca.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: LEAVE do campo ESTADO criado dinamicamente
---------------------------------------------------------------------------- */

define new global shared var whCidade      as widget-handle no-undo.
define new global shared var whEstado      as widget-handle no-undo.
define new global shared var whEstadoLocal as widget-handle no-undo.
define new global shared var whNomeTransp   as widget-handle no-undo.
define new global shared var whCodRota      as widget-handle no-undo.
define new global shared var whCidadeCif    as widget-handle no-undo.

DEFINE VARIABLE c-cod-rota AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-cont     AS INTEGER    NO-UNDO.

ASSIGN whEstado:SCREEN-VALUE = whEstadoLocal:SCREEN-VALUE.

/** Retirado por n∆o haver mais a necessidade de preencher a rota **/
/** Felipe - 03.10 **/
IF whCodRota:SCREEN-VALUE = "" THEN DO:
    FOR EACH rota 
        WHERE rota.cod-rota BEGINS TRIM(whEstadoLocal:SCREEN-VALUE) 
        AND   rota.roteiro <> "" NO-LOCK:   /* somente capital */

        DO i-cont = 1 TO NUM-ENTRIES(rota.roteiro,";"):
            IF TRIM(ENTRY(i-cont,rota.roteiro,";")) = TRIM(whCidade:SCREEN-VALUE) THEN DO:
                ASSIGN c-cod-rota = rota.cod-rota.
                LEAVE.
            END.
        END.
    END.
    
    /* se nao achou capital, procura primeira que nao tiver lista de cidades */
    IF c-cod-rota = "" THEN DO:
        FIND FIRST rota
            WHERE rota.cod-rota BEGINS TRIM(whEstadoLocal:SCREEN-VALUE)
            AND   rota.roteiro = ""
        NO-LOCK NO-ERROR.
    
        IF AVAIL rota THEN
            ASSIGN c-cod-rota = rota.cod-rota.
    END.

    ASSIGN whCodRota:SCREEN-VALUE = c-cod-rota.
END.
/* TMS 
IF whNomeTransp:SCREEN-VALUE = "" THEN DO:

    FIND FIRST rota-transp
        WHERE rota-transp.cod-rota    = c-cod-rota 
        AND   rota-transp.cod-servico = 1 /* rodoviario */
        AND   rota-transp.LOG-operacao  
    NO-LOCK NO-ERROR.

    IF AVAIL rota-transp THEN
        ASSIGN whNomeTransp:SCREEN-VALUE = rota-transp.nome-transp.
END.
*/

IF whCidadeCif:SCREEN-VALUE = "" THEN
    ASSIGN whCidadeCif:SCREEN-VALUE = whCidade:SCREEN-VALUE.
