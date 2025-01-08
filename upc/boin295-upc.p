/* ----------------------------------------------------------------------------
   Programa..: upc/boin295-upc.p
   Data......: Junho / 2011.
   Autor.....: Gustavo
   Objetivo..: Bloquear pedido para fornecedor inativo.
---------------------------------------------------------------------------- */

{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
    FIELD r-rowid AS ROWID
    FIELD RowNum  AS INTEGER INIT 1
    INDEX iSeq    AS PRIMARY RowNum
    .

DEFINE TEMP-TABLE tt-pedido-compr-aux NO-UNDO LIKE tt-pedido-compr.

DEFINE VARIABLE h-boin295      AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-pedido-compr AS ROWID       NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER   NO-UNDO.

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

/* MESSAGE p-ind-event                        */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.     */
/*                                            */
/* FOR EACH tt-epc                            */
/*     WHERE tt-epc.cod-event = p-ind-event:  */
/*     MESSAGE tt-epc.cod-event     SKIP      */
/*             tt-epc.cod-parameter SKIP      */
/*             tt-epc.val-parameter           */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/* END.                                       */

/* main block */
CASE p-ind-event:
    WHEN 'afterValidateCreate' THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "OBJECT-HANDLE" NO-LOCK NO-ERROR.

        IF AVAIL tt-epc AND VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO:

            RUN getRecord IN WIDGET-HANDLE(tt-epc.val-parameter) (OUTPUT TABLE tt-pedido-compr).

            FIND FIRST tt-pedido-compr NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-pedido-compr THEN 
                RETURN "OK":U.

            FIND FIRST emitente 
                 WHERE emitente.cod-emitente = tt-pedido-compr.cod-emitente NO-LOCK NO-ERROR.

            IF AVAIL emitente THEN DO:

                find first dist-emitente NO-LOCK
                    where dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

                IF AVAIL dist-emitente AND dist-emitente.idi-sit-fornec <> 1 THEN DO:
                    RUN _insertErrorManual IN WIDGET-HANDLE(tt-epc.val-parameter)  
                                                         (INPUT 0,
                                                          INPUT "EMS":U,
                                                          INPUT "ERROR":U,
                                                          INPUT "Fornecedor Inativo, n∆o Ç possivel incluir Documentos",
                                                          INPUT "Fornecedor Inativo, n∆o Ç possivel incluir Documentos",
                                                          INPUT "").
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    WHEN "beforeupdateRecord":U THEN DO:
        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.

        IF AVAILABLE tt-epc THEN
            ASSIGN h-boin295 = WIDGET-HANDLE(tt-epc.val-parameter).
        ELSE
            RETURN "OK":U.

        IF NOT VALID-HANDLE(h-boin295) THEN
            RETURN "OK":U.

        RUN getRecord IN h-boin295 (OUTPUT TABLE tt-pedido-compr).

        FIND FIRST tt-pedido-compr NO-LOCK NO-ERROR.

        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.

        IF AVAILABLE tt-epc THEN
            ASSIGN r-pedido-compr = TO-ROWID(tt-epc.val-parameter).
        ELSE
            RETURN "OK":U.
        
        FIND FIRST pedido-compr
            WHERE ROWID(pedido-compr) = r-pedido-compr NO-LOCK NO-ERROR.

        IF NOT AVAILABLE pedido-compr THEN
            RETURN "OK":U.

        IF pedido-compr.via-transp <> tt-pedido-compr.via-transp THEN DO:
            ASSIGN c-mensagem = "":U.

            FOR EACH ordem-compra NO-LOCK
                WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
                EACH ordens-embarque NO-LOCK
                WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem:
                IF c-mensagem <> "":U THEN
                    ASSIGN c-mensagem = c-mensagem + CHR(10).

                ASSIGN c-mensagem = c-mensagem + "- Estabel: ":U + TRIM(ordens-embarque.cod-estabel) + " / Embarque: ":U + TRIM(ordens-embarque.embarque) + " / Ordem Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U)) + " / Parc.: ":U + TRIM(STRING(ordens-embarque.parcela, ">>>>9":U)).
            END.

            IF c-mensagem <> "":U THEN DO:
                RUN _insertErrorManual IN h-boin295 (INPUT 17006,
                                                     INPUT "EMS":U,
                                                     INPUT "ERROR":U,
                                                     INPUT "Este pedido possui ordem(s) vinculada(s) a embarque(s)!":U,
                                                     INPUT "Para realizar a alteraá∆o do campo ~"Via Transporte~", desvincule a(s) ordem(s) do(s) embarque(s).":U + CHR(10) + CHR(10) + c-mensagem,
                                                     INPUT "Este pedido possui ordem(s) vinculada(s) a embarque(s)!":U +
                                                           "~~":U +
                                                           "Para realizar a alteraá∆o, desvincule a(s) ordem(s) do(s) embarque(s).":U + CHR(10) + CHR(10) + c-mensagem).

                RETURN "NOK":U.
            END.
        END.
    END.
    WHEN "afterupdateRecord":U THEN DO:
        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.

        IF AVAILABLE tt-epc THEN
            ASSIGN r-pedido-compr = TO-ROWID(tt-epc.val-parameter).
        ELSE
            RETURN "OK":U.
        
        FIND FIRST pedido-compr
            WHERE ROWID(pedido-compr) = r-pedido-compr NO-LOCK NO-ERROR.

        IF NOT AVAILABLE pedido-compr THEN
            RETURN "OK":U.

        FOR EACH processo-imp EXCLUSIVE-LOCK
            WHERE processo-imp.num-pedido = pedido-compr.num-pedido:
            ASSIGN processo-imp.via-transp = pedido-compr.via-transp.
        END.

        RELEASE processo-imp.
    END.
END CASE.

RETURN "OK".
