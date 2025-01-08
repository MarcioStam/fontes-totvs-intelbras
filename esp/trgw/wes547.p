TRIGGER PROCEDURE FOR WRITE OF crm-categ-un.

/********************************************************************************
** UPC........: wes547.p - UPC WRITE crm-categ-un
** Data.......: Setembro / 2010
** Objetivo...: Repassa inclusäes e modifica‡äes da categoria para o CRM
********************************************************************************/

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}


run esp/crm/escrm001a.p (input "Crm-categ-un",
                         input "W",
                         input rowid(crm-categ-un),
                         input table tt-raw-transfer).
*/
