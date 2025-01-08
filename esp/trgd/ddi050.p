/********************************************************************************
 ** UPC........: ddi050.p - UPC DELETE fam-comerc
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-fam-comerc  FOR fam-comerc.

/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/

DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-fam-comerc TO raw-param.
{esp/esb/esesb006.i 'msg0036' 'ddi050' 'fam-comerc'}
           
/*
IF  l-web-service = NO THEN DO:
    create tt-familia-comercial-atu.
    buffer-copy b-fam-comerc to tt-familia-comercial-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-familia-comercial-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "fam-comerc",
                             input "D",
                             input rowid(b-fam-comerc),
                             input table tt-raw-transfer).
END.
*/
