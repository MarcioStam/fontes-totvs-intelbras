{include/i-prgvrs.i UPC-RE0402RP 2.00.00.000}
{include/i-epc200.i re0402rp}

{gtp/gati0000.i}


DEF INPUT PARAM  p-ind-event AS  CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

IF p-ind-event = "final-atualiz" THEN DO:
    DEF BUFFER b-docum-est FOR docum-est.

    DEFINE VARIABLE h-boin090 AS HANDLE      NO-UNDO.

    FIND FIRST tt-epc WHERE
        tt-epc.cod-parameter = "ROWID-DOCUM-EST" NO-ERROR.

    FIND FIRST b-docum-est WHERE
               ROWID(b-docum-est) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
    IF  AVAIL b-docum-est 
    AND b-docum-est.ce-atual = NO THEN DO:
        FIND FIRST gt-docum-est-cancel 
             WHERE gt-docum-est-cancel.nro-docto    = b-docum-est.nro-docto    
             AND   gt-docum-est-cancel.cod-emitente = b-docum-est.cod-emitente 
             AND   gt-docum-est-cancel.serie-docto  = b-docum-est.serie-docto  
             AND   gt-docum-est-cancel.nat-operacao = b-docum-est.nat-operacao 
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL gt-docum-est-cancel THEN DO:
            DELETE gt-docum-est-cancel.

            /* Elimina tabelas importador */
            FIND FIRST natur-oper NO-LOCK WHERE
                       natur-oper.nat-operacao = b-docum-est.nat-operacao NO-ERROR.
    
            IF natur-oper.imp-nota THEN
                FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
                           gt-tt-docum-est.nat-operacao = b-docum-est.nat-operacao   AND
                           gt-tt-docum-est.serie-docto  = b-docum-est.serie-docto    AND
                           gt-tt-docum-est.int-1        = int(b-docum-est.nro-docto) AND
                           gt-tt-docum-est.cod-emitente = b-docum-est.cod-emitente   NO-ERROR.
            ELSE
                FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
                           gt-tt-docum-est.nat-operacao = b-docum-est.nat-operacao AND
                           gt-tt-docum-est.serie-docto  = b-docum-est.serie-docto  AND
                           gt-tt-docum-est.nro-docto    = b-docum-est.nro-docto    AND
                           gt-tt-docum-est.cod-emitente = b-docum-est.cod-emitente NO-ERROR.
    
            IF AVAIL gt-tt-docum-est THEN
                ASSIGN gt-tt-docum-est.log-cancelada = YES.

            &IF '{&pre-empresa}' <> "guararapes" &THEN
                FIND FIRST gati-cte EXCLUSIVE-LOCK WHERE
                           gati-cte.nro-docto    = b-docum-est.nro-docto    AND
                           gati-cte.serie-docto  = b-docum-est.serie-docto  AND
                           gati-cte.nat-operacao = b-docum-est.nat-operacao AND
                           gati-cte.cod-emitente = b-docum-est.cod-emitente NO-ERROR.
                IF AVAIL gati-cte THEN
                    DELETE gati-cte.
            &ENDIF

            IF NOT VALID-HANDLE(h-boin090) THEN
                RUN inbo/boin090.p PERSISTENT SET h-boin090.
    
            RUN openQueryStatic IN h-boin090 (INPUT "Docto":U).
    
            RUN goToKey2 IN h-boin090 (INPUT b-docum-est.serie-docto,
                                       INPUT b-docum-est.nro-docto,
                                       INPUT b-docum-est.cod-emitente,
                                       INPUT b-docum-est.nat-operacao).
    
            run emptyRowErrors in h-boin090.
            run deleteRecord in h-boin090.
        END.
    END.
END.

IF  CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-GT-padrao"
                    AND   funcao.ativo) THEN DO:

                Run gtupc/upc-re0402.p (input p-ind-event,
                                        INPUT-OUTPUT TABLE tt-epc).
END.

RETURN "OK".
