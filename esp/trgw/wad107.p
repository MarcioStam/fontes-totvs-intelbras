/********************************************************************************
 ** UPC........: wad107- UPC WRITE estabelec
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-estabelec      FOR estabelec.
DEF PARAM BUFFER b-old-estabelec  FOR estabelec.

DEF TEMP-TABLE tt-estabelec-raw   LIKE estabelec. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.


EMPTY TEMP-TABLE tt-estabelec-raw.
CREATE tt-estabelec-raw.
BUFFER-COPY b-estabelec TO tt-estabelec-raw.

RAW-TRANSFER tt-estabelec-raw TO raw-param.


{esp/esb/esesb006.i 'msg0042' 'wad107' 'estabelec'}

/*Fim Integra‡Æo Canais*/

{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "estabelec",
                         input "W",
                         input rowid(b-estabelec),
                         input table tt-raw-transfer).

RETURN "OK".


