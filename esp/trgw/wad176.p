/********************************************************************************
 ** UPC........: wad176- UPC WRITE mensagem
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-mensagem      FOR mensagem.
DEF PARAM BUFFER b-old-mensagem  FOR mensagem. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-mensagem TO raw-param.
{esp/esb/esesb006.i 'msg0048' 'wad176' 'mensagem'}

/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "mensagem",
                         input "W",
                         input rowid(b-mensagem),
                         input table tt-raw-transfer).
*/
