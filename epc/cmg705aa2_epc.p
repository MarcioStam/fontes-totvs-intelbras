/*****************************************************************************
** Programa..............: cmg705aa2_epc.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 17/11/2008
*****************************************************************************/

/**************************************************** Initialize **********************************************************/
DEF TEMP-TABLE tt-ped-venda NO-UNDO 
    FIELD nr-ped-ikeda                     AS INTEGER.

DEF INPUT PARAMETER TABLE FOR tt-ped-venda.

DO ON ERROR UNDO, RETURN 'NOK':

    FOR EACH tt-ped-venda:

        /*V rios pedidos no EMS para cada pedido da IKEDA*/
        FOR EACH int-ped-venda NO-LOCK
            WHERE int-ped-venda.pedidocodigo = tt-ped-venda.nr-ped-ikeda:

            FIND ped-venda EXCLUSIVE-LOCK 
                WHERE ped-venda.nr-pedido  = int-ped-venda.nr-pedido NO-ERROR.

            IF AVAIL ped-venda 
               THEN ASSIGN ped-venda.cod-sit-aval       = 3 /* Aprovado */
                           ped-venda.desc-bloq-cr       = ""
                           ped-venda.dsp-pre-fat        = YES 
                           ped-venda.cod-message-alerta = 0
                           ped-venda.dt-mensagem        = ?
                           ped-venda.nome-prog          = "".

        END.

    END.

END.

RETURN 'OK'.

