/********************************************************************************
 ** UPC........: wdi181- UPC WRITE rota
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-rota      FOR rota.
DEF PARAM BUFFER b-old-rota  FOR rota. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-rota TO raw-param.
{esp/esb/esesb006.i 'msg0054' 'wdi181' 'rota'}

/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "rota",
                         input "W",
                         input rowid(b-rota),
                         input table tt-raw-transfer).     
*/
