/********************************************************************************
 ** UPC........: upcw-un007.p - UPC WRITE Unidade da Federa‡Æo
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades de federa‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-unid-feder      FOR unid-feder.
DEF PARAM BUFFER b-old-unid-feder  FOR unid-feder.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-unid-feder TO raw-param.
{esp/esb/esesb006.i 'msg0010' 'wun007' 'unid-feder'}

/*Fim Integra‡Æo Canais*/

/*
run esp/es0669.p (input "yes", 
                  "unid-feder", 
                  b-unid-feder.pais,
                  b-unid-feder.estado, 
                  "", "", "", "", "", "", "").
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "Unid-feder",
                         input "W",
                         input rowid(b-unid-feder),
                         input table tt-raw-transfer).
*/

