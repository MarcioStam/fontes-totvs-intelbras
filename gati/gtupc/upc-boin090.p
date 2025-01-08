{include/i-prgvrs.i UPC-BOIN090 2.00.00.000}
{include/i-epc200.i boin090}

DEF INPUT PARAM  p-ind-event AS  CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.
DEFINE VARIABLE c-nro-docto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie-docto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-operacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-emitente AS CHARACTER   NO-UNDO.

{cdp/cdcfgmat.i}

/*
Validar com program-name cria‡Æo pelo padrao - especifico Aguia
*/
IF p-ind-event = "afterCreateRecord" THEN DO:
END.

IF p-ind-event = "create-docum-est" THEN DO:
    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "create-docum-est".        
        
        FOR FIRST docum-est EXCLUSIVE-LOCK
            WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter).
            
            FOR FIRST gt-doc-fisico OF docum-est EXCLUSIVE-LOCK.
                ASSIGN overlay(docum-est.char-1,93,60) = (IF gt-doc-fisico.ds-chave = ? THEN '' ELSE gt-doc-fisico.ds-chave).

                &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                    ASSIGN OVERLAY(docum-est.char-1,93,60) = (IF gt-doc-fisico.ds-chave = ? THEN '' ELSE gt-doc-fisico.ds-chave)
                           OVERLAY(docum-est.char-1,153,1) = "3".
                &ELSE
                    ASSIGN docum-est.cod-chave-aces-nf-eletro = gt-doc-fisico.ds-chave
                           docum-est.cdn-sit-nfe              = 3.
                &ENDIF
            END.
        END.
    END.
END.

IF p-ind-event = "fim-calculateTotalNota" THEN DO:
    
    FOR EACH tt-epc.

        CASE tt-epc.cod-parameter:
            WHEN "cod-emitente" THEN
                ASSIGN c-cod-emitente = tt-epc.val-parameter.
            WHEN "serie-docto" THEN
                ASSIGN c-serie-docto = tt-epc.val-parameter.
            WHEN "nro-docto" THEN
                ASSIGN c-nro-docto = tt-epc.val-parameter.
            WHEN "nat-operacao" THEN
                ASSIGN c-nat-operacao= tt-epc.val-parameter.
        END CASE.        
    END.
        
    FOR FIRST docum-est NO-LOCK
        WHERE docum-est.nro-docto    = c-nro-docto
          AND docum-est.serie-docto  = c-serie-docto
          AND docum-est.cod-emitente = int(c-cod-emitente)
          AND docum-est.nat-operacao = c-nat-operacao.        
        
        FOR FIRST gt-doc-fisico OF docum-est EXCLUSIVE-LOCK.

            DELETE gt-doc-fisico.
        END.
    END.
END.

RETURN "OK".
