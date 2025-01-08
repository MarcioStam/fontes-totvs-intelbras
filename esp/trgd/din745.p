/********************************************************************************
 ** UPC........: dun006.p - UPC DELETE pais
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-unid-negoc FOR unid-negoc.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-unid-negoc TO raw-param.
{esp/esb/esesb006.i 'msg0002' 'din745' 'unid-negoc'}

/*Fim Integra‡Æo Canais*/

RETURN "OK":U.

