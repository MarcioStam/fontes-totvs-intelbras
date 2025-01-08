/********************************************************************************
 ** UPC........: wdi245- UPC WRITE natur-oper
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-natur-oper      FOR natur-oper.
DEF PARAM BUFFER b-old-natur-oper  FOR natur-oper. 

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.
DEF TEMP-TABLE tt-natur-oper-aux LIKE natur-oper.

EMPTY TEMP-TABLE tt-natur-oper-aux.
CREATE tt-natur-oper-aux.
BUFFER-COPY b-natur-oper       TO tt-natur-oper-aux.
RAW-TRANSFER tt-natur-oper-aux TO raw-param.

{esp/esb/esesb006.i 'msg0050' 'win245' 'natur-oper'}

/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */


/********************** Integracao do Ems para o CRM *****************/
run esp/crm/escrm001a.p (input "natur-oper",
                         input "W",
                         input rowid(b-natur-oper),
                         input table tt-raw-transfer).
*/
RETURN "OK":U.

