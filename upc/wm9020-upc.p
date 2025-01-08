/********************************************************************************
**  Programa: upc-wm9020.p
**  Data....: Dezembro/2015
**  Autor...: SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: Gerar Tarefas com base nas embalagens Caixas / Fracionados
********************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}

DEF INPUT        PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE        FOR tt-epc. 

DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.

DEF TEMP-TABLE tt-volume NO-UNDO
    FIELD nr-nota-fis LIKE volume-nf.nr-nota-fis
    FIELD nr-volume   LIKE volume-nf.nr-volume
    FIELD qtde        LIKE volume-nf.qtde.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
    FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
    FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
    FIELD id-box           LIKE  wm-box-saldo.id-box
    FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
    FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
    FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
    FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
    FIELD qtd-embalagem    LIKE  wm-box-movto.qti-embalagem
    FIELD qtd-retirar      LIKE  wm-box-saldo.qtd-item.

DEFINE VARIABLE de-qtd-item AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-aux-event AS CHARACTER   NO-UNDO.

IF  p-ind-event = "'BeginsSugestion':U"
OR  p-ind-event = "BeginsSugestion" THEN DO:

    assign c-aux-event = "BeginsSugestion".

    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event     = c-aux-event
          AND tt-epc.cod-parameter = "piQtdItem":U :
        ASSIGN de-qtd-item = INTEGER(tt-epc.val-parameter).
    END.

    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event     = c-aux-event
          AND tt-epc.cod-parameter = "piRwDoctoItens":U:

        FIND FIRST wm-docto-itens NO-LOCK
            WHERE ROWID(wm-docto-itens) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF AVAIL wm-docto-itens THEN
            RUN piTarefaFlowRack.
    END. 
END.

RETURN "OK".

/************************* PROCEDURE INTERNAS ******************************/

PROCEDURE piTarefaFlowRack:
    DEFINE VARIABLE i-cont-vol    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-tot-movto  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-sugere AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-box         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-embal       AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-bosc035exi AS HANDLE      NO-UNDO.

    DEFINE BUFFER bf-box-movto FOR wm-box-movto.

    FOR FIRST wm-docto NO-LOCK
        WHERE wm-docto.cod-estabel = wm-docto-itens.cod-estabel
          AND wm-docto.cod-local   = wm-docto-itens.cod-local
          AND wm-docto.id-docto    = wm-docto-itens.id-docto:
    END.

    IF NOT wm-docto.num-docto MATCHES "*-FRAC" THEN
        RETURN "OK".

    EMPTY TEMP-TABLE tt-volume.

    FOR EACH integra-mft-wms-notas NO-LOCK
        WHERE integra-mft-wms-notas.cod-integra = wm-docto.num-docto
        BREAK BY integra-mft-wms-notas.cod-estabel
              BY integra-mft-wms-notas.serie
              BY integra-mft-wms-notas.nr-nota-fis:

        IF FIRST-OF(integra-mft-wms-notas.nr-nota-fis) THEN DO:

            FOR EACH volume-nf NO-LOCK
                WHERE volume-nf.cod-estabel = integra-mft-wms-notas.cod-estabel
                  AND volume-nf.serie       = integra-mft-wms-notas.serie
                  AND volume-nf.nr-nota-fis = integra-mft-wms-notas.nr-nota-fis
                  AND volume-nf.it-codigo   = wm-docto-itens.cod-item
                  AND CAN-FIND(FIRST volume-wms-nf NO-LOCK
                               WHERE volume-wms-nf.cod-estabel = volume-nf.cod-estabel
                                 AND volume-wms-nf.serie       = volume-nf.serie
                                 AND volume-wms-nf.nr-nota-fis = volume-nf.nr-nota-fis
                                 AND volume-wms-nf.nr-volume   = volume-nf.nr-volume
                                 AND volume-wms-nf.tipo-separa = 3): /* flow rack */

                ASSIGN i-cont-vol = i-cont-vol + 1.

                CREATE tt-volume.
                ASSIGN tt-volume.nr-nota-fis = volume-nf.nr-nota-fis
                       tt-volume.nr-volume   = volume-nf.nr-volume
                       tt-volume.qtde        = volume-nf.qtde.
            END.
        END.
    END.

    IF i-cont-vol <= 1 THEN /* se foi s¢ um nao muda nada */
        RETURN "OK".

    FOR EACH tt-volume:

        FOR EACH wm-item-picking NO-LOCK
            WHERE wm-item-picking.cod-estabel = wm-docto-itens.cod-estabel
              AND wm-item-picking.cod-local   = wm-docto-itens.cod-local
              AND wm-item-picking.cod-item    = wm-docto-itens.cod-item
              AND CAN-FIND(FIRST ext-wm-picking NO-LOCK
                           WHERE ext-wm-picking.cod-estabel   = wm-item-picking.cod-estabel
                             AND ext-wm-picking.cod-local     = wm-item-picking.cod-local
                             AND ext-wm-picking.cod-picking   = wm-item-picking.cod-picking
                             AND ext-wm-picking.log-flow-rack = YES),
            EACH wm-box-picking NO-LOCK
                WHERE wm-box-picking.cod-estabel = wm-item-picking.cod-estabel
                  AND wm-box-picking.cod-local   = wm-item-picking.cod-local
                  AND wm-box-picking.cod-picking = wm-item-picking.cod-picking
                  AND CAN-FIND(FIRST wm-box NO-LOCK
                               WHERE wm-box.cod-estabel = wm-box-picking.cod-estabel
                                 AND wm-box.cod-local   = wm-box-picking.cod-local
                                 AND wm-box.id-box      = wm-box-picking.id-box-comp
                                 AND wm-box.log-bloq-retir = NO),
                FIRST zona-separa-box NO-LOCK
                    WHERE zona-separa-box.cod-estabel = wm-box-picking.cod-estabel
                      AND zona-separa-box.cod-local   = wm-box-picking.cod-local
                      AND zona-separa-box.id-box      = wm-box-picking.id-box-comp:

            EMPTY TEMP-TABLE tt-saldo.

            CREATE tt-saldo.
            ASSIGN tt-saldo.cod-lote      = wm-docto-itens.cod-lote
                   tt-saldo.dt-transacao  = TODAY
                   tt-saldo.id-box        = wm-box-picking.id-box-comp
                   tt-saldo.cod-embalagem = wm-item-picking.cod-emb-area
                   tt-saldo.qtd-original  = tt-volume.qtde
                   tt-saldo.qtd-item      = tt-volume.qtde
                   tt-saldo.qtd-embalagem = 1 
                   tt-saldo.qtd-retirar   = tt-volume.qtde.

            IF NOT VALID-HANDLE(h-bosc035exi) THEN
                RUN scbo/bosc035exi.p PERSISTENT SET h-bosc035exi.

            RUN emptyRowErrors     IN h-bosc035exi.
            RUN makeBestExitManual IN h-bosc035exi (INPUT ROWID(wm-docto-itens),
                                                    INPUT TABLE tt-saldo).
            IF  RETURN-VALUE = "NOK":U THEN /* tenta outro endereco */
                NEXT.

            FOR LAST bf-box-movto EXCLUSIVE-LOCK
                WHERE bf-box-movto.cod-estabel      = wm-docto-itens.cod-estabel
                  AND bf-box-movto.cod-local        = wm-docto-itens.cod-local
                  AND bf-box-movto.id-docto         = wm-docto-itens.id-docto
                  AND bf-box-movto.num-seq-item     = wm-docto-itens.num-seq-item
                  AND bf-box-movto.ind-tipo-movto   = 2
                  AND bf-box-movto.ind-status-movto = 1
                  AND bf-box-movto.int-2            = 0:
                ASSIGN bf-box-movto.int-2  = tt-volume.nr-volume
                       bf-box-movto.char-2 = tt-volume.nr-nota-fis.
            END.
            ASSIGN de-tot-sugere = de-tot-sugere + tt-volume.qtde.
        END.
    END.

    IF VALID-HANDLE(h-bosc035exi) THEN
        RUN destroy IN h-bosc035exi.

    IF de-tot-sugere > 0 THEN DO: /* atualiza quantidade que programa padr∆o vai sugerir */
        ASSIGN de-qtd-item = de-qtd-item - de-tot-sugere.

        IF de-qtd-item <= 0 THEN DO:
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = c-aux-event
                  AND tt-epc.cod-parameter = "Return":
            END.
            IF NOT AVAIL tt-epc THEN DO:
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = c-aux-event
                       tt-epc.cod-parameter = "Return".
            END.
            ASSIGN tt-epc.val-parameter = "ReturnOK".
        END.
        ELSE DO:
            FOR FIRST tt-epc 
                WHERE tt-epc.cod-event     = c-aux-event
                  AND tt-epc.cod-parameter = "piQtdItem":
                ASSIGN tt-epc.val-parameter = STRING(de-qtd-item).
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

