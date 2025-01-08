/********************************************************************************
 ** UPC........: wdi341 - UPC WRITE Cidade
 ** Data.......: Mar‡o / 2011
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-cidade     FOR mgcad.cidade.
DEF PARAM BUFFER b-old-cidade FOR mgcad.cidade.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-cidade TO raw-param.
{esp/esb/esesb006.i 'msg0012' 'wdi341' 'cidade'}

    
/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "cidade",
                         input "W",
                         input rowid(b-cidade),
                         input table tt-raw-transfer).
*/
