/********************************************************************************
 ** UPC........: win122- UPC WRITE familia
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-familia      FOR familia.
DEF PARAM BUFFER b-old-familia  FOR familia. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-familia TO raw-param.
{esp/esb/esesb006.i 'msg0034' 'win122' 'familia'}
/*Fim Integra‡Æo Canais*/

/*
/********************** Integracao do Ems para o CRM *****************/
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

run esp/crm/escrm001a.p (input "familia",
                         input "W",
                         input rowid(b-familia),
                         input table tt-raw-transfer).
*/                         
RETURN "OK".
