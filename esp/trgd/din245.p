/********************************************************************************
 ** UPC........: din245.p - UPC DELETE natur-oper
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-natur-oper  FOR natur-oper.
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/
DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-natur-oper TO raw-param.
{esp/esb/esesb006.i 'msg0050' 'din245' 'natur-oper'}

/*
IF  l-web-service = NO THEN DO:
    create tt-natur-oper-atu.
    buffer-copy b-natur-oper to tt-natur-oper-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-natur-oper-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "natur-oper",
                             input "D",
                             input rowid(b-natur-oper),
                             input table tt-raw-transfer).                  
END.
*/
RETURN "OK":U.

