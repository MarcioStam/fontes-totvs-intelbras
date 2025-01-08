/********************************************************************************
**  Programa: WM9062-UPC.P                                    
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: Desfazer saldo gerado para ressuprimento Flow Rack
**            Ver ESWMAPI003
********************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}

DEF INPUT        PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE        FOR tt-epc. 

DEFINE BUFFER bf-box-movto FOR wm-box-movto.

IF  p-ind-event = "ValidateDeleteRessup" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "wm-box-movto-rowid":
    END.

    IF NOT AVAIL tt-epc THEN
        RETURN "OK".

    FOR FIRST wm-box-movto NO-LOCK
        WHERE ROWID(wm-box-movto) = TO-ROWID(tt-epc.val-parameter):
    END.
    IF NOT AVAIL wm-box-movto THEN
        RETURN "OK".

    FOR FIRST bf-box-movto NO-LOCK 
         WHERE bf-box-movto.cod-estabel    = wm-box-movto.cod-estabel
           AND bf-box-movto.cod-local      = wm-box-movto.cod-local
           AND bf-box-movto.id-movto       = wm-box-movto.id-movto
           AND bf-box-movto.ind-tipo-movto = 1:
    END.

    FOR FIRST wm-box-picking NO-LOCK
        WHERE wm-box-picking.cod-estabel = bf-box-movto.cod-estabel
          AND wm-box-picking.cod-local   = bf-box-movto.cod-local
          AND wm-box-picking.id-box-comp = bf-box-movto.id-box:
    END.

    IF NOT AVAIL wm-box-picking THEN
        RETURN "OK".

    /* verifica se o box pertence a picking de flow rack */
    FOR FIRST ext-wm-picking NO-LOCK
        WHERE ext-wm-picking.cod-estabel = wm-box-picking.cod-estabel
          AND ext-wm-picking.cod-local   = wm-box-picking.cod-local
          AND ext-wm-picking.cod-picking = wm-box-picking.cod-picking
          AND ext-wm-picking.log-flow-rack = YES:
    END.

    IF AVAIL ext-wm-picking THEN DO:

        FOR EACH wms-box-sdo-alocad WHERE
            wms-box-sdo-alocad.cod-estabel  = wm-box-movto.cod-estabel   AND
            wms-box-sdo-alocad.cod-local    = wm-box-movto.cod-local     AND
            wms-box-sdo-alocad.id-docto     = wm-box-movto.id-docto      AND
            wms-box-sdo-alocad.num-seq-item = wm-box-movto.num-seq-item  EXCLUSIVE-LOCK:
            ASSIGN wms-box-sdo-alocad.qtd-alocad = wms-box-sdo-alocad.qtd-alocad - (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
            IF wms-box-sdo-alocad.qtd-alocad <= wms-box-sdo-alocad.qtd-item-ret THEN
                DELETE wms-box-sdo-alocad.
        END.
        
        IF wm-box-movto.ind-status-movto > 1 THEN DO:

            RUN piTrataFlowRack.
        
        END.
    END.

END.

RETURN "OK".

/**********************************************************************/
PROCEDURE piTrataFlowRack:

    RUN esp/wmp/eswmapi004.p (INPUT ROWID(bf-box-movto),
                              OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH RowErrors:
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = p-ind-event
                   tt-epc.cod-parameter = "mensagem-erro"
                   tt-epc.val-parameter = STRING(RowErrors.ErrorNumber) + ":" + RowErrors.errorDescription.
        END.
        RETURN "NOK":U.
    END.

    RETURN "OK".
END PROCEDURE.
