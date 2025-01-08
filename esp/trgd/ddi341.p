/********************************************************************************
 ** UPC........: ddi341.p - UPC DELETE 
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-cidade FOR mgcad.cidade.
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/
 
DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-cidade TO raw-param.
{esp/esb/esesb006.i 'msg0012' 'ddi341' 'cidade'}

/*
IF  l-web-service = NO THEN DO:
    create tt-cidade-atu.
    buffer-copy b-cidade to tt-cidade-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-cidade-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "Cidade",
                             input "D",
                             input rowid(b-cidade),
                             input table tt-raw-transfer).
END.
 */
