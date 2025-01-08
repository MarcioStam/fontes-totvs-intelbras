{esp/es0018.i}

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)":U
    LABEL "Usu rio Corrente"
    COLUMN-LABEL "Usu rio Corrente"
    NO-UNDO.

DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-esp-lib-aut AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-cta_corren_fornec-recid   AS RECID                              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_fornec_financ         AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF  p-row-table <> ? THEN 
    ASSIGN g-cta_corren_fornec-recid = p-row-table.

IF  p-ind-event = "DISPLAY" THEN DO:
    ASSIGN v_rec_fornec_financ = p-row-table.

    FIND FIRST fornec_financ
        WHERE RECID(fornec_financ) = p-row-table NO-LOCK NO-ERROR.

    IF  AVAIL fornec_financ THEN DO:
        FIND FIRST int-emitente
            WHERE int-emitente.cod-emit = fornec_financ.cdn_fornec NO-LOCK NO-ERROR.

        IF  AVAIL int-emitente THEN DO:

            RUN esp/es0018p.p (INPUT "cd0401", /* Nome do programa */
                               INPUT 1,        /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren) THEN
                ASSIGN wh-esp-lib-aut:SENSITIVE = YES.
            ELSE
                ASSIGN wh-esp-lib-aut:SENSITIVE = NO.
                
        END.
    END.
END.

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "VIEWER" THEN DO:

    CREATE BUTTON wh-button
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 4
           HEIGHT       = 1.13
           ROW          = 1.13
           LABEL        = "Hist¢rico Altera‡Æo Conta Corrente"
           COLUMN       = 70
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Hist¢rico Altera‡Æo Conta Corrente"
           HELP         = "Hist¢rico Altera‡Æo Conta Corrente" 
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc\bas_fornec_financ-upc-01.w.
           END TRIGGERS.

    wh-button:LOAD-IMAGE ( 'image/im-brows.bmp' ).
    wh-button:MOVE-TO-TOP().
               
    CREATE BUTTON wh-esp-lib-aut
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 4
           HEIGHT       = 1.13
           ROW          = 1.13
           LABEL        = "Esp‚cies Libera‡Æo Autom tica"
           COLUMN       = 74.4
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Esp‚cies Libera‡Æo Autom tica"
           HELP         = "Esp‚cies Libera‡Æo Autom tica" 
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc\bas_fornec_financ-upc-02.w.
           END TRIGGERS.

    wh-esp-lib-aut:LOAD-IMAGE ( 'image/im-forma.bmp' ).
    wh-esp-lib-aut:MOVE-TO-TOP().

END.

/*
MESSAGE "p-ind-event "  p-ind-event          SKIP
        "p-ind-object " p-ind-object         SKIP
        "p-wgh-object " string(p-wgh-object) SKIP
        "p-row-table "  STRING(p-row-table)  SKIP
        "p-wgh-frame "  STRING(p-wgh-frame)  SKIP
        "p-cod-table "  p-cod-table          SKIP
        "c-objeto "     c-objeto
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
