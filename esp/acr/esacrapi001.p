/*------------------------------------------------------*/
/*             Regras de Vencimento                     */
/* Efetua valida‡Æo no ESACR003-1 e pd4000-upc          */
/* VALIDA EXISTÒNCIA DE REGRA DE VENCIMENTO NO ESACR070 */
/*------------------------------------------------------*/

DEF INPUT  PARAM p-nome-abrev     AS CHAR        NO-UNDO.
DEF INPUT  PARAM p-cod-cond-pagto AS INTEGER      NO-UNDO.
DEF INPUT  PARAM p-nat-operacao   AS CHAR         NO-UNDO.
DEF OUTPUT PARAM p-pedido-ok      AS LOG INIT YES NO-UNDO.
                                              
DEF BUFFER b-matriz FOR emitente.
DEF BUFFER b-int-cond-pagto FOR int-cond-pagto.

/* Apenas valida a regra quando a natureza Emitir Duplicta */
FIND FIRST natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = p-nat-operacao NO-ERROR.

IF  AVAIL natur-oper AND NOT natur-oper.emite-duplic THEN
    RETURN "OK".

/* E-COMMERCE */
FOR LAST param-b2c NO-LOCK:
    IF  param-b2c.cond-pagto-bol   = p-cod-cond-pagto
    OR  param-b2c.cond-pagto-cred  = p-cod-cond-pagto THEN 
        RETURN "OK".
END.

FIND b-int-cond-pagto NO-LOCK
    WHERE b-int-cond-pagto.cod-cond-pag = p-cod-cond-pagto NO-ERROR.

ASSIGN p-pedido-ok = NO.

/* VERIFICA AINDA CONDI€åES GLOBAIS, A CONDI€ÇO TEM QUE SER CANAIS ATIVOS OU B2B. Tamb‚m verifica Revendas... */
IF  AVAIL b-int-cond-pagto 
AND (SUBSTRING(b-int-cond-pagto.char-1,6,1)  = "S" 
 OR  SUBSTR(b-int-cond-pagto.char-1,7,1)     = "S" 
 OR  SUBSTRING(b-int-cond-pagto.char-1,10,1) = "S"
 OR  SUBSTRING(b-int-cond-pagto.char-1,11,1) = "S") THEN
    ASSIGN p-pedido-ok = YES.
ELSE
    ASSIGN p-pedido-ok = NO.
    
IF  NOT p-pedido-ok THEN DO:
    FIND emitente NO-LOCK 
        WHERE emitente.nome-abrev = p-nome-abrev NO-ERROR.
    
    IF  AVAIL emitente THEN DO:
        FIND FIRST int-cond-pag-cli-det NO-LOCK
             WHERE int-cond-pag-cli-det.cod-emitente = emitente.cod-emitente  NO-ERROR.
        
        /* Procura pela matriz, se for Grupo Econ“mico */
        IF  NOT AVAIL int-cond-pag-cli-det THEN DO:
            FIND b-matriz NO-LOCK
                 WHERE b-matriz.nome-abrev = emitente.nome-matriz NO-ERROR.

            IF  AVAIL b-matriz THEN DO:
                FIND FIRST int-cond-pag-cli NO-LOCK
                    WHERE int-cond-pag-cli.cod-emitente = b-matriz.cod-emitente 
                      AND int-cond-pag-cli.grupo-econ NO-ERROR.

                IF  AVAIL int-cond-pag-cli THEN DO:
                    FIND FIRST int-cond-pag-cli-det
                        WHERE int-cond-pag-cli-det.cod-emitente = b-matriz.cod-emitente 
                          AND int-cond-pag-cli-det.cod-cond-pag = p-cod-cond-pagto
                          AND int-cond-pag-cli-det.dt-ini-valid <= TODAY 
                          AND int-cond-pag-cli-det.dt-fim-valid >= TODAY NO-ERROR.
                    IF  AVAIL int-cond-pag-cli-det THEN
                        ASSIGN p-pedido-ok = YES.
                END.
            END.
        END.
        ELSE DO:
            FIND int-cond-pag-cli-det NO-LOCK
                WHERE int-cond-pag-cli-det.cod-emitente  = emitente.cod-emitente 
                  AND int-cond-pag-cli-det.cod-cond-pag  = p-cod-cond-pagto
                  AND int-cond-pag-cli-det.dt-ini-valid <= TODAY 
                  AND int-cond-pag-cli-det.dt-fim-valid >= TODAY NO-ERROR.
            IF  AVAIL int-cond-pag-cli-det THEN
                p-pedido-ok  = YES.
        END.
    END.
END.

RETURN "OK".
