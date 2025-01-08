/***********************************************************************
**  Programa..: UPC\BODI154-EPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: EPC - BODI154-EPC ONDE:
**              001 - Limpar descontos na implantaá∆o do registro.  
**  Vers∆o....: 001 10/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/
{include/i-epc200.i1}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

DEFINE TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item
       FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-desc-ped-item NO-UNDO LIKE desc-ped-item
       field r-rowid as rowid.

DEFINE VARIABLE bo-ped-item         AS HANDLE     NO-UNDO.
DEFINE VARIABLE bo-ped-venda-cal    AS HANDLE     NO-UNDO.
DEFINE VARIABLE bo-ped-item-cal     AS HANDLE     NO-UNDO.

DEF NEW GLOBAL SHARED VAR vLogCopiaPedido    AS LOGICAL       NO-UNDO.

DEFINE BUFFER b-copia-ped-item FOR ped-item.
DEFINE BUFFER b-copia-item     FOR ITEM.

DEF VAR rRaw AS RAW NO-UNDO.

DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.

DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDesc      AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDescItem  AS CHAR          NO-UNDO.

/*                                                */
/* FOR EACH tt-epc:                               */
/*     MESSAGE "BODI154 - PED-ITEM"    SKIP(2)    */
/*             pIndEvent               SKIP       */
/*             tt-epc.cod-event        SKIP       */
/*             tt-epc.cod-parameter    SKIP       */
/*             tt-epc.val-parameter    SKIP       */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/* END.                                           */
/*                                                */
/*                                                */

IF pIndEvent = "AfterCreateRecord" THEN DO:
    
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = pIndEvent
           AND tt-epc.cod-parameter = "Table-Rowid" NO-ERROR.

    FIND FIRST ped-item NO-LOCK
         WHERE ROWID(ped-item) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

    /*trata metas do canal*/
    IF AVAIL ped-item THEN
        RUN esp/ftp/esftp213a.p (INPUT ROWID(ped-item)).

    IF vLogCopiaPedido THEN  //copia pedido pd4000
        RUN pi-atualiza-pedido.

END.
IF pIndEvent = "AfterValidateRecord" THEN DO:

    FIND tt-epc
        WHERE tt-epc.cod-event = pIndEvent
        AND   tt-epc.cod-parameter = "Object-Handle"
    NO-LOCK NO-ERROR.

    ASSIGN bo-ped-item = WIDGET-HANDLE(tt-epc.val-parameter).

    RUN getRawRecord IN bo-ped-item (OUTPUT rRaw).

    CREATE tt-ped-item.
    RAW-TRANSFER rRaw TO tt-ped-item.

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = pIndEvent
        AND   tt-epc.cod-parameter = "Table-Rowid"
    NO-LOCK NO-ERROR.

    FIND ped-item
        WHERE ROWID(ped-item) = TO-ROWID(tt-epc.val-parameter)
    NO-LOCK NO-ERROR.

    FIND FIRST ped-venda NO-LOCK
        WHERE  ped-venda.nome-abrev = ped-item.nome-abrev
        AND    ped-venda.nr-pedcli  = ped-item.nr-pedcli NO-ERROR.
    IF  AVAIL  ped-venda THEN DO:

        IF  ped-item.nome-abrev  = tt-ped-item.nome-abrev AND /* se for diferente e inclusao de registro e nao deve validar */
            ped-item.nr-pedcli   = tt-ped-item.nr-pedcli  AND
            ped-venda.cod-priori = 10 THEN DO:
            RUN _insertErrorManual IN bo-ped-item (INPUT 99999,
                                           INPUT "EMS",
                                           INPUT "ERROR",
                                           INPUT "Pedido liberado para faturamento (Prioridade 10).",
                                           INPUT "Pedido liberado para faturamento n∆o pode ser alterado.",
                                           INPUT "").
        END.
    
        /* Valida se o Pedido est† sendo transferido de um estabelecimento para outro (esftp079) */
        IF  CAN-FIND(FIRST ped-transf NO-LOCK
                     WHERE ped-transf.nome-abrev = ped-venda.nome-abrev
                     AND   ped-transf.nr-pedcli  = ped-venda.nr-pedcli) THEN DO:
            RUN _insertErrorManual IN bo-ped-item (INPUT 99999,
                                                   INPUT "EMS",
                                                   INPUT "ERROR",
                                                   INPUT "Pedido em processo de Transferància. Aguarde o processo finalizar para alterar o pedido.",
                                                   INPUT "O pedido n∆o pode ser alterado pois est† em processo de Transferància entre Estabelecimentos!",
                                                   INPUT "").
        END.
    END.

    /* PEDIDOS PROVINIENTES DE SOLICITAÄ«O, N«O PODEM TER SEUS ITENS ALTERADOS. */
    IF CAN-FIND (FIRST int-solicitacao-item 
                       WHERE int-solicitacao-item.nome-abrev = ped-venda.nome-abrev
                         AND int-solicitacao-item.nr-pedcli  = ped-venda.nr-pedcli) THEN DO:
        RUN _insertErrorManual IN bo-ped-item (INPUT 99999,
                                               INPUT "EMS",
                                               INPUT "ERROR",
                                               INPUT "Pedido de venda foi gerado via Solicitaá∆o (Canais), n∆o pode ser alterado",
                                               INPUT "Os itens deste pedido n∆o podem ser alterados, visto que seus valores e quantidade devem refletir exatamente ao que foi informado na Solicitaá∆o",
                                               INPUT "").
    END.


END.

/*
CASE pIndEvent:
    WHEN "AfterCreateRecord" THEN
    DO:
        FOR EACH  tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
            AND   tt-epc.cod-parameter = "Table-Rowid":
            FOR FIRST ped-item NO-LOCK
                WHERE ROWID(ped-item) = TO-ROWID(tt-epc.val-parameter):
                FIND FIRST ped-venda NO-LOCK OF ped-item
                     WHERE ped-venda.origem = 6 NO-ERROR.
                IF AVAIL ped-venda THEN NEXT.

                IF NOT VALID-HANDLE(bo-ped-item)        OR 
                   bo-ped-item:TYPE <> "PROCEDURE":U   OR 
                   bo-ped-item:FILE-NAME <> "dibo/bodi154.p" THEN 
                   RUN dibo/bodi154.p PERSISTENT SET bo-ped-item.

                
                IF  vLogLimpaDescItem = "" AND vLogLimpaDesc THEN
                     ASSIGN vLogLimpaDescItem = "YES".
                ELSE IF vLogLimpaDescItem = "" AND NOT vLogLimpaDesc THEN
                        ASSIGN vLogLimpaDescItem = "NO".
                ELSE IF vLogLimpaDescItem = "NO" AND vLogLimpaDesc THEN
                        ASSIGN vLogLimpaDescItem = "YES".

                IF vLogLimpaDescItem = "YES" THEN
                DO:
                    /*
                    001 - Limpa Informaá‰es de descontos calculados no pedido de venda.
                     */
                    RUN EmptyRowErrors  IN bo-ped-item.
                    RUN setConstraintRowid IN bo-ped-item (INPUT ROWID(ped-item)).
                    RUN openQueryStatic    IN bo-ped-item (INPUT "Rowid":U).
                    RUN getRecord       IN bo-ped-item (OUTPUT TABLE tt-ped-item).
                    FOR FIRST tt-ped-item. END.
                    ASSIGN tt-ped-item.val-desconto-inform        = 0
                           tt-ped-item.des-pct-desconto-inform    = ""
                           tt-ped-item.val-pct-desconto-tab-preco = 0
                           tt-ped-item.val-desconto[1]            = 0
                           tt-ped-item.val-desconto[2]            = 0
                           tt-ped-item.val-desconto[3]            = 0
                           tt-ped-item.val-desconto[4]            = 0
                           tt-ped-item.val-desconto[5]            = 0
                           tt-ped-item.val-pct-desconto-periodo   = 0
                           tt-ped-item.val-pct-desconto-prazo     = 0.
                    RUN setRecord       IN bo-ped-item (INPUT TABLE tt-ped-item).
                    RUN UpdateRecord IN bo-ped-item.
                    RUN getRowErrors IN bo-ped-item (OUTPUT TABLE RowErrors). 
                    IF  CAN-FIND(FIRST RowErrors
                                 WHERE RowErrors.ErrorType <> "INTERNAL":U) then do:
                        {method/ShowMessage.i1}
                        {method/ShowMessage.i2 &Modal=YES}
                    END.

                    RUN piCalculaItemPedido(INPUT ROWID(ped-item)).
                    FOR FIRST ped-venda OF ped-item NO-LOCK:
                        RUN piCalculaPedido(INPUT ROWID(ped-venda)).
                    END.

                END.
                IF  VALID-HANDLE(bo-ped-item) THEN DO:
                    RUN destroyBO IN bo-ped-item.
                    RUN destroy   IN bo-ped-item.
                    ASSIGN bo-ped-item = ?.
                END.
            END.
        END.
    END.
END CASE.
PROCEDURE piCalculaItemPedido:
    DEFINE INPUT PARAM pRowid AS ROWID NO-UNDO.

    if not valid-handle(bo-ped-item-cal) or
       bo-ped-item-cal:type <> "PROCEDURE":U or
       bo-ped-item-cal:file-name <> "dibo/bodi154cal.p" then
        run dibo/bodi154cal.p persistent set bo-ped-item-cal.

    run calculateItemPrice in bo-ped-item-cal(input pRowid).

    DELETE PROCEDURE bo-ped-item-cal.
END PROCEDURE.

PROCEDURE piCalculaPedido:
    DEFINE INPUT PARAM pRowid AS ROWID NO-UNDO.

    if not valid-handle(bo-ped-venda-cal) or
       bo-ped-venda-cal:type <> "PROCEDURE":U or
       bo-ped-venda-cal:file-name <> "dibo/bodi159cal.p" then
        run dibo/bodi159cal.p persistent set bo-ped-venda-cal.

    run calculateOrder in bo-ped-venda-cal(input pRowid).

    DELETE PROCEDURE bo-ped-venda-cal.
END PROCEDURE.
*/


PROCEDURE pi-atualiza-pedido:

    FOR FIRST b-copia-ped-item OF ped-item NO-LOCK:
        
           FIND FIRST b-copia-item NO-LOCK
                WHERE b-copia-item.it-codigo = b-copia-ped-item.it-codigo NO-ERROR.
           IF AVAIL b-copia-item THEN DO:
              FIND CURRENT b-copia-ped-item EXCLUSIVE-LOCK.
              ASSIGN b-copia-ped-item.aliquota-ipi  = b-copia-item.aliquota-ipi.

              IF SUBSTRING(ped-item.char-2,01,08) <> "" THEN
                  OVERLAY(ped-item.char-2,01,08) = b-copia-item.class-fiscal.

              FIND CURRENT b-copia-ped-item NO-LOCK.
           END.
       
    END. // for each b-copia-ped-item


END PROCEDURE.
