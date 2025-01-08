/********************************************************************************
 ** UPC........: wdi050- UPC WRITE fam-comerc comercial
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-fam-comerc      FOR  fam-comerc.
DEF PARAM BUFFER b-old-fam-comerc  FOR  fam-comerc. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-fam-comerc TO raw-param.
{esp/esb/esesb006.i 'msg0036' 'wdi050' 'fam-com-item'}
/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "fam-comerc",
                         input "W",
                         input rowid(b-fam-comerc),
                         input table tt-raw-transfer).
*/
