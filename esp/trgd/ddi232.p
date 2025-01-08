/********************************************************************************
 ** UPC........: ddi232.p - UPC DELETE 
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-canal-venda      FOR canal-venda.

/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/

DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-canal-venda TO raw-param.
{esp/esb/esesb006.i 'msg0040' 'ddi232' 'canal-venda'}

/*
IF  l-web-service = NO THEN DO:
    create tt-canal-venda-atu.
    buffer-copy b-canal-venda to tt-canal-venda-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-canal-venda-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "Canal-venda",
                             input "D",
                             input rowid(b-canal-venda),
                             input table tt-raw-transfer).
END.
*/
