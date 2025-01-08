/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upc.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: 
---------------------------------------------------------------------------- */


/* Parameter Definitions ****************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

/* Temp-Table Definitions **********************************************/
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/* Global Variable Definitions **********************************************/
define new global shared var adm-broker-hdl as handle no-undo.
define new global shared var h-folder       as handle no-undo.
define new global shared var h-viewer       as handle no-undo.

define new global shared var g-ind-cre-cli  as integer   no-undo.
define new global shared var whIndCreCli    as widget-handle no-undo.

define var c-objeto       as character no-undo.
define var h-frame        as widget-handle no-undo. 

{upc\btb910za-upc.i}

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").
/*
MESSAGE p-ind-event SKIP
        p-ind-object SKIP
        c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
/* Main Block ***************************************************************/


IF  p-ind-event  = "INITIALIZE"
AND p-ind-object = "VIEWER" 
AND c-objeto     = "v32ad098.w" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                WHEN "ind-cre-cli" THEN DO:
                    ASSIGN whIndCreCli = h-frame.
                    LEAVE.
                END.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.
END.

IF  p-ind-event  = "VALIDATE"
AND p-ind-object = "VIEWER" 
AND c-objeto     = "v32ad098.w" THEN DO:

    DEF VAR i-sequencia AS INT    NO-UNDO.
    DEF VAR l-erro-ped  AS LOG    NO-UNDO.
    DEF VAR hShowMsg    AS HANDLE NO-UNDO.

    /* verifica se foi alterado o tipo de avaliacao de credito */
    IF  INT(whIndCreCli:SCREEN-VALUE) = 4  /* suspenso */
    AND INT(whIndCreCli:SCREEN-VALUE) <> g-ind-cre-cli THEN DO:
        FIND FIRST emitente 
            WHERE ROWID(emitente) = p-row-table 
        EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL emitente THEN DO:

            EMPTY TEMP-TABLE RowErrors.
            FOR EACH ped-venda NO-LOCK
                WHERE ped-venda.cod-estabel = v_cod_estab_usuar
                and   ped-venda.nome-abrev   = emitente.nome-abrev
                AND   ped-venda.cod-sit-ped <= 2:    /* aberto e atend parcial */

                IF ped-venda.cod-priori   = 10 THEN DO:   /* disponivel fat */
                    CREATE RowErrors.
                    ASSIGN i-sequencia                = i-sequencia + 1
                           RowErrors.ErrorSequence    = i-sequencia
                           RowErrors.ErrorNumber      = 99999
                           RowErrors.ErrorDescription = "Pedido " + TRIM(ped-venda.nr-pedcli)
                                                      + " liberado para faturamento (Prioridade 10)."
                           RowErrors.ErrorType        = "ERROR"
                           RowErrors.ErrorHelp        = "NÆo ‚ poss¡vel suspender o cr‚dito do cliente. " + CHR(10)
                                                      + "O pedido " + TRIM(ped-venda.nr-pedcli)
                                                      + " do cliente " + TRIM(ped-venda.nome-abrev)
                                                      + " est  liberado para faturamento (Prioridade 10).".
                END.

                ASSIGN l-erro-ped = NO.

                FOR EACH ped-ent NO-LOCK OF ped-venda:
                    IF  ped-ent.qt-alocada > 0
                    AND (ped-ent.qt-alocada - ped-ent.qt-atendida) > 0 THEN
                        ASSIGN l-erro-ped = YES.
                END.

                IF l-erro-ped THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia                = i-sequencia + 1
                           RowErrors.ErrorSequence    = i-sequencia
                           RowErrors.ErrorNumber      = 99999
                           RowErrors.ErrorDescription = "Pedido " + TRIM(ped-venda.nr-pedcli)
                                                      + " alocado em embarque."
                           RowErrors.ErrorType        = "ERROR"
                           RowErrors.ErrorHelp        = "NÆo ‚ poss¡vel suspender o cr‚dito do cliente. " + CHR(10)
                                                      + "O pedido " + TRIM(ped-venda.nr-pedcli)
                                                      + " do cliente " + TRIM(ped-venda.nome-abrev)
                                                      + " est  alocado em embarque(s) nÆo faturado(s).".
                END.
            END.

            IF CAN-FIND(FIRST RowErrors) THEN DO:
                IF NOT VALID-HANDLE(hShowMsg) or
                   hShowMsg:TYPE <> "PROCEDURE":U or
                   hShowMsg:FILE-NAME <> "utp/ShowMessage.w":U THEN
                        RUN utp/ShowMessage.w PERSISTENT SET hShowMsg.

                RUN setModal IN hShowMsg (INPUT YES) NO-ERROR.
                RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

                RETURN "NOK".
            END.
        END.
    END.
END.

IF  p-ind-event  = "ENABLE"
AND p-ind-object = "VIEWER" 
AND c-objeto     = "v32ad098.w" THEN
    ASSIGN g-ind-cre-cli = INT(whIndCreCli:SCREEN-VALUE).
