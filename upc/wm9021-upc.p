/*****************************************************************************
** Programa: upc\wm9021-upc.p
** VersÆo..: 1.00
** Data....: 30\03\2021
** Autor...: Isac Abrahao
** Obs.....: UPC responsavel por nao baxar estoque de Documento WMS Solar 
             Antecipados pelo ESFTP211
*****************************************************************************/

/*--- Defini‡Æo dos Parƒmetros ---*/
{include/i-epc200.i1}
{method/dbotterr.i}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

IF pIndEvent = "Validate-Picking" THEN DO:

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = pIndEvent
           AND tt-epc.cod-parameter = "wm-box-movto-rowid"
    NO-ERROR.

    IF AVAIL tt-epc THEN
    DO:
        FIND wm-box-movto WHERE ROWID(wm-box-movto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

        IF AVAIL wm-box-movto THEN
        DO:
            FIND FIRST wm-docto EXCLUSIVE-LOCK
                 WHERE wm-docto.cod-estabel  = wm-box-movto.cod-estabel
                   AND wm-docto.cod-local    = wm-box-movto.cod-local
                   AND wm-docto.id-docto     = wm-box-movto.id-docto 
            NO-ERROR.

            IF AVAIL wm-docto THEN
            DO:
               FIND FIRST int-wm-docto  
                    WHERE int-wm-docto.cod-estabel    = wm-docto.cod-estabel 
                      and int-wm-docto.cod-local      = wm-docto.cod-local   
                      and int-wm-docto.id-docto       = wm-docto.id-docto    
               NO-LOCK NO-ERROR.

               IF AVAIL int-wm-docto THEN
                  ASSIGN wm-docto.ind-origem-docto = 2.

            END.
        END.                                               
    END.                                                   
END.


IF pIndEvent = "After-Confirm" THEN DO:

    FIND tt-epc WHERE tt-epc.cod-event     = pIndEvent 
                  AND tt-epc.cod-parameter = "rowid-movto"    
    NO-ERROR.

    IF AVAIL tt-epc THEN
    DO:
        FIND wm-box-movto WHERE ROWID(wm-box-movto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

        IF AVAIL wm-box-movto THEN
        DO:
            FIND FIRST wm-docto EXCLUSIVE-LOCK
                 WHERE wm-docto.cod-estabel  = wm-box-movto.cod-estabel
                   AND wm-docto.cod-local    = wm-box-movto.cod-local
                   AND wm-docto.id-docto     = wm-box-movto.id-docto 
            NO-ERROR.

            IF AVAIL wm-docto THEN
            DO:
                FIND FIRST int-wm-docto  
                     WHERE int-wm-docto.cod-estabel    = wm-docto.cod-estabel 
                       and int-wm-docto.cod-local      = wm-docto.cod-local   
                       and int-wm-docto.id-docto       = wm-docto.id-docto    
                NO-LOCK NO-ERROR.                                             
                
                IF AVAIL int-wm-docto THEN   
                   ASSIGN wm-docto.ind-origem-docto = 19.
            END.
            RUN piFlowRack.
        END.                                               
    END.                      
END.


RETURN "OK":U.

PROCEDURE piFlowRack:

    FOR FIRST wm-box-picking NO-LOCK
        WHERE wm-box-picking.cod-estabel = wm-box-movto.cod-estabel
          AND wm-box-picking.cod-local   = wm-box-movto.cod-local
          AND wm-box-picking.id-box-comp = wm-box-movto.id-box:
    END.

    IF AVAIL wm-box-picking THEN DO:
        /* verifica se o box pertence a picking de flow rack */
        FOR FIRST ext-wm-picking NO-LOCK
            WHERE ext-wm-picking.cod-estabel = wm-box-picking.cod-estabel
              AND ext-wm-picking.cod-local   = wm-box-picking.cod-local
              AND ext-wm-picking.cod-picking = wm-box-picking.cod-picking
              AND ext-wm-picking.log-flow-rack = YES:
            RUN calculaCapacidadeEndereco.
        END.
    END.
    RETURN "OK".
END PROCEDURE.

PROCEDURE calculaCapacidadeEndereco:
    DEFINE VARIABLE de-saldo-box AS DECIMAL     NO-UNDO.

    RUN esp/wmp/eswmapi006.p (INPUT wm-box-movto.cod-estabel,
                              INPUT wm-box-movto.cod-local,
                              INPUT wm-box-movto.id-box).

    assign de-saldo-box = 0.

    FOR FIRST wm-item-picking 
         WHERE wm-item-picking.cod-estabel = wm-box-picking.cod-estabel AND
               wm-item-picking.cod-local   = wm-box-picking.cod-local   AND
               wm-item-picking.cod-picking = wm-box-picking.cod-picking NO-LOCK:
    END.

    for each wm-box-saldo
       where wm-box-saldo.cod-estabel = wm-box-movto.cod-estabel
         and wm-box-saldo.cod-local   = wm-box-movto.cod-local
         and wm-box-saldo.cod-cliente = wm-box-movto.cod-cliente
         and wm-box-saldo.cod-item    = wm-box-movto.cod-item
         and wm-box-saldo.id-box      = wm-box-picking.id-box-comp
         and wm-box-saldo.ind-status-saldo = 3 /* liberado */
         and wm-box-saldo.qtd-item > wm-box-saldo.qtd-item-bloq no-lock:

         assign de-saldo-box = de-saldo-box
                             + ( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ).
    end.                             

    if  de-saldo-box <= wm-item-picking.qtd-minima then do:
            RUN wmp/wm9060.p (INPUT  ROWID(wm-box-movto),
                              OUTPUT TABLE RowErrors).
    END.

    RETURN "OK".
END PROCEDURE.
