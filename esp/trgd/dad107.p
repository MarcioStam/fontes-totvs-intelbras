/********************************************************************************
 ** UPC........: dad107.p - UPC DELETE estabelec
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-estabelec  FOR estabelec.
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-estabelec TO raw-param.
{esp/esb/esesb006.i 'msg0042' 'dad107' 'estabelec'}

IF  l-web-service = NO THEN DO:
    create tt-estabelec-atu.
    buffer-copy b-estabelec to tt-estabelec-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-estabelec-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "estabelec",
                             input "D",
                             input rowid(b-estabelec),
                             input table tt-raw-transfer).
END.
