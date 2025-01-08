/********************************************************************************
 ** UPC........: wun006.p - UPC WRITE pais
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/
 
DEF PARAM BUFFER b-pais      FOR mgcad.pais.
DEF PARAM BUFFER b-old-pais  FOR mgcad.pais.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-pais TO raw-param.
{esp/esb/esesb006.i 'msg0006' 'wun006' 'pais'}

/*Fim Integra‡Æo Canais*/


RETURN "OK":U.
