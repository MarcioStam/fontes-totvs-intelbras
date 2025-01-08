/*--------------------------------------------------------------------*/
/* Objetivo: Recalcular as parcelas com base nas regras de vencimento */
/*           paramentrizadas no esacr070                              */        
/*--------------------------------------------------------------------*/

DEF INPUT PARAM p-row-nota AS ROWID.

DEF VAR da-prorrogada AS DATE NO-UNDO.

/* Fun‡äes de prorroga‡Æo de vencimento */
{esp/acr/esacrapi002.i}

FOR FIRST nota-fiscal NO-LOCK
    WHERE ROWID(nota-fiscal) = p-row-nota:

    FOR EACH  fat-duplic EXCLUSIVE-LOCK
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
          AND fat-duplic.serie       = nota-fiscal.serie
          AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:


        RUN esp/acr/esacrapi002.p (INPUT  nota-fiscal.cod-emitente,
                                   INPUT  fat-duplic.dt-venciment,
                                   OUTPUT da-prorrogada).

        IF  da-prorrogada <> ? THEN
            ASSIGN fat-duplic.dt-venciment = da-prorrogada.            
    END.

END.

RETURN "OK".
