/********************************************************************************
**  Programa: WSC118.P                                    
**  Data....: AGOSTO /2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: UPC da trigger de WRITE da tabela wm-inventario-endereco
**            Gravar embalagem e ocupacao do endereáo corretamente nos endereáos
**            de flow rack, devido Ö falha no sistema padr∆o.
********************************************************************************/
{utp/ut-glob.i}

DEFINE PARAMETER BUFFER p-table     FOR wm-inventario-endereco.
DEFINE PARAMETER BUFFER p-table-old FOR wm-inventario-endereco.

IF p-table-old.ind-sit-inv-end <> 4
AND p-table.ind-sit-inv-end     = 4 THEN DO: /* quando marca endereáo como atualizado */

    FOR FIRST wm-box-picking NO-LOCK
        WHERE wm-box-picking.cod-estabel = p-table.cod-estabel
          AND wm-box-picking.cod-local   = p-table.cod-local
          AND wm-box-picking.id-box-comp = p-table.id-box:
    END.

    IF AVAIL wm-box-picking THEN DO:
        /* verifica se o box pertence a picking de flow rack */
        FOR FIRST ext-wm-picking NO-LOCK
            WHERE ext-wm-picking.cod-estabel = wm-box-picking.cod-estabel
              AND ext-wm-picking.cod-local   = wm-box-picking.cod-local
              AND ext-wm-picking.cod-picking = wm-box-picking.cod-picking
              AND ext-wm-picking.log-flow-rack = YES:
            RUN piTrataFlowRack.
        END.
    END.

END.

RETURN "OK":U.

/*********************************************************************/
PROCEDURE piTrataFlowRack:
    DEFINE VARIABLE l-embal AS LOGICAL     NO-UNDO.
    DEFINE BUFFER bf-box-movto FOR wm-box-movto.
    
    FOR EACH wm-box-saldo EXCLUSIVE-LOCK
        WHERE wm-box-saldo.cod-estabel = p-table.cod-estabel
          AND wm-box-saldo.cod-local   = p-table.cod-local
          AND wm-box-saldo.id-box      = p-table.id-box,
        EACH wm-box-saldo-etiqueta NO-LOCK
           WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-saldo.cod-estabel
             AND wm-box-saldo-etiqueta.cod-local   = wm-box-saldo.cod-local
             AND wm-box-saldo-etiqueta.id-saldo    = wm-box-saldo.id-saldo,
        FIRST wm-etiqueta OF wm-box-saldo-etiqueta NO-LOCK:

        IF wm-etiqueta.cod-embalagem <> wm-box-saldo.cod-embalagem THEN DO:
            FOR EACH wm-box-movto EXCLUSIVE-LOCK
                WHERE wm-box-movto.cod-estabel    = wm-box-saldo.cod-estabel
                  AND wm-box-movto.cod-local      = wm-box-saldo.cod-local
                  AND wm-box-movto.id-docto       = wm-box-saldo.id-docto
                  AND wm-box-movto.num-seq-item   = wm-box-saldo.num-seq-item
                  AND wm-box-movto.id-box         = wm-box-saldo.id-box
                  AND wm-box-movto.cod-embalagem  = wm-box-saldo.cod-embalagem
                  AND wm-box-movto.ind-tipo-movto = 1:
                ASSIGN wm-box-movto.cod-embalagem = wm-etiqueta.cod-embalagem.

                FOR FIRST bf-box-movto EXCLUSIVE-LOCK
                    WHERE bf-box-movto.cod-estabel    = wm-box-movto.cod-estabel
                      AND bf-box-movto.cod-local      = wm-box-movto.cod-local
                      AND bf-box-movto.id-movto       = wm-box-movto.id-movto
                      AND bf-box-movto.ind-tipo-movto = 2:
                    ASSIGN bf-box-movto.cod-embalagem = wm-etiqueta.cod-embalagem.
                END.

            END.
            ASSIGN wm-box-saldo.cod-embalagem = wm-etiqueta.cod-embalagem
                   l-embal = YES.
            IF wm-box-saldo.dt-trans = ? THEN
                ASSIGN wm-box-saldo.dt-trans = TODAY.
        END.
    END.

    IF l-embal THEN 
        RUN esp/wmp/eswmapi006.p (INPUT p-table.cod-estabel,
                                  INPUT p-table.cod-local,
                                  INPUT p-table.id-box).

    RETURN "OK".
END PROCEDURE.
