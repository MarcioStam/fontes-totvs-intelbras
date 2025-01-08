/* ---------------------------------------------------------------------------------------------------------------------------------*/
/* Cria pedido de execu‡Æo para enviar o Status das Solicita‡Æo de Benef¡cio e saldo do canal para o CRM. - piEnviaSaldosBarramento */
/* ---------------------------------------------------------------------------------------------------------------------------------*/

{utp/ut-glob.i}
{esp/esb/in/msg0152.i2}

DEF INPUT PARAM p-id-solicitacao AS CHAR FORMAT "x(40)" NO-UNDO.

FOR FIRST int-solicitacao NO-LOCK
    WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-id-solicitacao:
    
    RUN piEnviaSaldosBarramento (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,
                                 INPUT STRING(int-solicitacao.cod-emitente)).
END.

RETURN "OK".

