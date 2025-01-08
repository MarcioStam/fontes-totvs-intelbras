/*-------------------------------------------------------------------------*/
/* esp/esb/esesbapi013.p: Validar altera‡Æo do pedido que foi gerado via   */
/*                         solicita‡Æo de benef¡cio, nos programas:        */
/*                        UPC-PD4000-UPC.P e BODI154-EPC.p                 */
/*-------------------------------------------------------------------------*/

DEF  INPUT PARAM pNomeAbrev   AS CHAR NO-UNDO.
DEF  INPUT PARAM pNr-PedCli   AS CHAR NO-UNDO.
DEF OUTPUT PARAM pSolicitacao AS LOGICAL INIT NO.

    
IF  CAN-FIND (FIRST int-solicitacao-item 
                 WHERE int-solicitacao-item.nome-abrev = pNomeAbrev
                   AND int-solicitacao-item.nr-pedcli  = pNr-PedCli) THEN 
    ASSIGN pSolicitacao = YES.

RETURN  "OK".

