/********************************************************************************
 ** UPC........: ddi181.p - UPC DELETE rota
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-rota  FOR rota.
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-rota TO raw-param.
{esp/esb/esesb006.i 'msg0054' 'ddi181' 'rota'}
                         
/*
IF  l-web-service = NO THEN DO:
    create tt-rota-atu.
    buffer-copy b-rota to tt-rota-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-rota-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "rota",
                             input "D",
                             input rowid(b-rota),
                             input table tt-raw-transfer).
END.
*/
