/********************************************************************************
 ** UPC........: upcd-un007.p - UPC DELETE  tab-unidade
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-tab-unidade      FOR tab-unidade.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-tab-unidade TO raw-param.
{esp/esb/esesb006.i 'msg0084' 'din417' 'tab-unidade'}

/*Fim Integra‡Æo Canais*/
