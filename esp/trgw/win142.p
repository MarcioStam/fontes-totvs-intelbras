/********************************************************************************
 ** UPC........: win142 - UPC WRITE grup-estoque
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-grup-estoque      FOR grup-estoque.
DEF PARAM BUFFER b-old-grup-estoque  FOR grup-estoque.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-grup-estoque TO raw-param.
{esp/esb/esesb006.i 'msg0038' 'win142' 'grup-estoque'}
/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "Grup-estoque",
                         input "W",
                         input rowid(b-grup-estoque),
                         input table tt-raw-transfer).
*/
