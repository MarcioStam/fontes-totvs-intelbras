/********************************************************************************
 ** UPC........: des546.p - UPC Delete crm-categ-un
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes crm-categ-unid p/ o CRM
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF crm-categ-un.

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
 
create tt-crm-categ-un-atu.
buffer-copy crm-categ-un to tt-crm-categ-un-atu.
create tt-raw-transfer.

raw-transfer tt-crm-categ-un-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "crm-categ-unid",
                         input "D",
                         input rowid(crm-categ-un),
                         input table tt-raw-transfer).
*/
