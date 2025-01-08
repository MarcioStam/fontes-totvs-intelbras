/********************************************************************************
 ** UPC........: wdi232 - UPC WRITE Canal-Venda
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-canal-venda     FOR canal-venda.
DEF PARAM BUFFER b-old-canal-venda FOR canal-venda. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-canal-venda TO raw-param.
{esp/esb/esesb006.i 'msg0040' 'wdi232' 'canal-venda'}

/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "canal-venda",
                         input "W",
                         input rowid(b-canal-venda),
                         input table tt-raw-transfer).
*/
