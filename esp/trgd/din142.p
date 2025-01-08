/********************************************************************************
 ** UPC........: din142.p - UPC DELETE Grup-estoque
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-grup-estoque      FOR grup-estoque.
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-grup-estoque TO raw-param.
{esp/esb/esesb006.i 'msg0038' 'din142' 'grup-estoque'}

/*
/*****  Integracao com CRM *******/
create tt-grup-estoque-atu.
buffer-copy b-grup-estoque to tt-grup-estoque-atu.
create tt-raw-transfer.

raw-transfer tt-grup-estoque-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "grup-estoque",
                         input "D",
                         input rowid(b-grup-estoque),
                         input table tt-raw-transfer).
*/
