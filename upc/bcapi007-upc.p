{include\i-epc200.i}
{utp/ut-glob.i}

DEF INPUT        PARAM p-ind-event     AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE           FOR tt-epc.

DEF NEW GLOBAL SHARED VAR d-time          AS INT      NO-UNDO.
DEF NEW GLOBAL SHARED VAR d-dt-etiqueta   AS DATE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-imp-impressora-bc9026 AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-log-troca-imp-bc9026  AS LOGICAL NO-UNDO.

DEF BUFFER bftt-epc  FOR tt-epc.

IF p-ind-event = "Auxiliary-Field" THEN DO:

    FOR EACH bftt-epc WHERE
        bftt-epc.cod-event     = "Auxiliary-Field" AND
        bftt-epc.cod-parameter = "cd-trans"        AND
        bftt-epc.val-parameter = "WMOUT004"        NO-LOCK:

        /* Etiqueta de Pallet */
        IF CAN-FIND(FIRST tt-epc WHERE
            tt-epc.cod-event     = "Auxiliary-Field" AND
            tt-epc.cod-parameter = "tipo-etiq"       AND
            tt-epc.val-parameter = "102"             NO-LOCK) THEN DO:

            FIND FIRST tt-epc WHERE
                tt-epc.cod-event     = "Auxiliary-Field" AND
                tt-epc.cod-parameter = "Auxiliar-03"     NO-ERROR.
            
            FIND FIRST wm-etiqueta WHERE
                wm-etiqueta.id-etiqueta = DEC(tt-epc.val-parameter) NO-LOCK NO-ERROR.
            IF AVAIL wm-etiqueta THEN DO:
            
                FIND FIRST tt-epc WHERE
                    tt-epc.cod-event     = "Auxiliary-Field" AND
                    tt-epc.cod-parameter = "Auxiliar-10"     NO-ERROR.
                IF AVAIL tt-epc THEN DO:

                    IF wm-etiqueta.nr-ord-prod <> 999999999 THEN DO:
                        ASSIGN tt-epc.val-parameter = STRING(wm-etiqueta.nr-ord-prod).
                    END.
                    ELSE DO:
                        FIND FIRST wm-docto WHERE
                            wm-docto.id-carga = wm-etiqueta.id-carga NO-LOCK NO-ERROR.
                        ASSIGN tt-epc.val-parameter = IF AVAIL wm-docto AND wm-docto.id-carga <> 0 THEN wm-docto.num-docto ELSE "".
                    END.
                END.
            
                IF wm-etiqueta.nr-ord-prod = 999999999 /* Nao por OP    */ AND
                   wm-etiqueta.id-carga    = 0         /* Nao por Docto */ AND
                   NOT CAN-FIND(FIRST wm-box-saldo-etiqueta OF wm-etiqueta NO-LOCK) THEN DO:

                    FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR.

                    IF TIME - d-time > 3 THEN DO:
                        RUN getFifo (OUTPUT d-dt-etiqueta).
                    END.
                    ASSIGN wm-etiqueta.dt-geracao = d-dt-etiqueta
                           d-time                 = TIME.
                    FIND CURRENT wm-etiqueta NO-LOCK NO-ERROR.
                    FIND FIRST tt-epc WHERE
                        tt-epc.cod-event     = "Auxiliary-Field" AND
                        tt-epc.cod-parameter = "Auxiliar-11"     NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
                        ASSIGN tt-epc.val-parameter = STRING(wm-etiqueta.dt-geracao,"99/99/9999").                           
                    END.
                END.
                ELSE DO:
                    FIND FIRST tt-epc WHERE
                        tt-epc.cod-event     = "Auxiliary-Field" AND
                        tt-epc.cod-parameter = "Auxiliar-11"     NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
                        ASSIGN tt-epc.val-parameter = STRING(wm-etiqueta.dt-geracao,"99/99/9999").                           
                    END.
                END.

                FIND FIRST tt-epc WHERE
                    tt-epc.cod-event     = "Auxiliary-Field" AND
                    tt-epc.cod-parameter = "Auxiliar-18"     NO-ERROR.

                IF AVAIL tt-epc THEN DO:
                    ASSIGN tt-epc.val-parameter = STRING(wm-etiqueta.cod-usuario) + " - " + STRING(wm-etiqueta.hr-geracao,"HH:MM"). 
                END.
            END.    
            
        END.
    END.
END.

PROCEDURE getFIFO :
    
    DEF OUTPUT PARAM p-dt-fifo      AS DATE NO-UNDO.

    DEFINE BUTTON btGetFIFOOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGetFIFOButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE rGetFIFO AS ROWID NO-UNDO.

    DEFINE VARIABLE d-dt-fifo AS DATE INITIAL TODAY LABEL "Data FIFO" FORMAT "99/99/9999" VIEW-AS FILL-IN
     SIZE 10.14 BY .88  NO-UNDO.

    DEFINE FRAME fGetFIFO
        d-dt-fifo            AT ROW 1.21 COL 17.72 COLON-ALIGNED 
        btGetFIFOOK          AT ROW 2.63 COL 2.14
        rtGetFIFOButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "FIFO Etiqueta" FONT 1
             DEFAULT-BUTTON btGetFIFOOK.

    RUN utp/ut-trfrrp.p (input Frame fGetFIFO:Handle).
    {utp/ut-liter.i "FIFO Etiqueta"}
    ASSIGN FRAME fGetFIFO:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGetFIFOOK IN FRAME fGetFIFO DO:
        ASSIGN d-dt-fifo.

        ASSIGN p-dt-fifo = d-dt-fifo.

        APPLY "GO":U TO FRAME fGetFIFO.
    END.

    DISP d-dt-fifo WITH FRAME fGetFIFO.
    ENABLE d-dt-fifo btGetFIFOOK  
        WITH FRAME fGetFIFO. 

    WAIT-FOR "GO":U OF FRAME fGetFIFO.
END PROCEDURE.

IF p-ind-event = "SelectPrint3" THEN DO:

    /* troca impressora conforme indica»’o no BC9026 */
    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "destino-impressora":
        IF  g-log-troca-imp-bc9026
        AND g-imp-impressora-bc9026 <> tt-epc.val-parameter THEN DO:
            ASSIGN tt-epc.val-parameter = entry(1,g-imp-impressora-bc9026,"|") NO-ERROR.
        END.
    END.

    ASSIGN g-log-troca-imp-bc9026 = NO.

END.

