/********************************************************************************
 ** UPC........: din122.p - UPC DELETE familia
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-familia      FOR familia.
DEF BUFFER b-comp-familia-item  FOR comp-familia-item.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-familia TO raw-param.
{esp/esb/esesb006.i 'msg0034' 'din122' 'familia'}
/*Fim Integra‡Æo Canais*/
    

/* Integra‡Æo com CRM4 */ 
/*   
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

IF  l-web-service = NO THEN DO:
    create tt-familia-material-atu.
    buffer-copy b-familia to tt-familia-material-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-familia-material-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "familia",
                             input "D",
                             input rowid(b-familia),
                             input table tt-raw-transfer).
END.
*/
RETURN "OK".

