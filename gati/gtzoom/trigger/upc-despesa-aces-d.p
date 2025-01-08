/***********************************************************************
**  Programa...: upc-despesa-aces-d
**  Autor......: Oliver Fagionato
**  Descricao..: Upc utilizada na exclusao da tabela despesa-aces
**  data.......: mar‡o de 2013
************************************************************************/

{include/i-prgvrs.i UPC-DESPESA-ACES-D 2.00.00.000}
/******************** DEFINICAO PARAMETROS ********************/
define param buffer bdespesa-aces for despesa-aces.

/************************ DEFINICAO VARIAVEIS ************************/
{utp/ut-glob.i}
{gtp/gati0000.i}

DEFINE VARIABLE l-achou AS LOGICAL NO-UNDO.

FOR FIRST gati-cte EXCLUSIVE-LOCK WHERE
          gati-cte.cod-emitente = bdespesa-aces.cod-forn-ac  AND
          gati-cte.nat-operacao = bdespesa-aces.nat-oper-ac  AND
          gati-cte.nro-docto    = bdespesa-aces.nro-docto-ac AND
          gati-cte.serie-docto  = bdespesa-aces.ser-docto-ac :

    &IF '{&pre-empresa}' = "guararapes" OR 
		'{&pre-empresa}' = "solidus"    &THEN
        ASSIGN gati-cte.log-importado = NO.
    &ELSE
        ASSIGN l-achou = NO.
        
        FOR EACH gati-rat-cte NO-LOCK WHERE
                 gati-rat-cte.cod-aces-comp-nfe = gati-cte.cod-aces-comp-nfe:
        
            IF CAN-FIND(FIRST despesa-aces WHERE
                       despesa-aces.serie-docto  = gati-rat-cte.nf-serie    AND
                       despesa-aces.nro-docto    = gati-rat-cte.nf-nro      AND
                       despesa-aces.cod-emitente = gati-rat-cte.nf-emitente AND
                       despesa-aces.nat-operacao = gati-rat-cte.nf-nat-oper AND
                       despesa-aces.ser-docto-ac = gati-cte.serie-docto     AND
                       despesa-aces.nro-docto-ac = gati-cte.nro-docto       AND
                       despesa-aces.cod-forn-ac  = gati-cte.cod-emitente    AND
                       despesa-aces.nat-oper-ac  = gati-rat-cte.nat-oper-ac) THEN DO:
                ASSIGN l-achou = YES.
            END.
        END.
        
        IF l-achou THEN DO:
            ASSIGN gati-cte.log-importado = NO.
        END.
    &ENDIF
END.

RETURN "OK".
