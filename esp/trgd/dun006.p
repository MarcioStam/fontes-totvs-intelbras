/********************************************************************************
 ** UPC........: dun006.p - UPC DELETE pais
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-pais FOR mgcad.pais.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-pais TO raw-param.
{esp/esb/esesb006.i 'msg0006' 'dun006' 'pais'}

/*Fim Integra‡Æo Canais*/


RETURN "OK":U.

