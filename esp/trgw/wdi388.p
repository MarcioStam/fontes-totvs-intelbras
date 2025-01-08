/********************************************************************************
 ** UPC........: 
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-tab-finan-indice      FOR tab-finan-indice.
DEF PARAM BUFFER b-old-tab-finan-indice  FOR tab-finan-indice.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-tab-finan-indice TO raw-param.
{esp/esb/esesb006.i 'msg0046' 'wdi388' 'tab-finan-indice'}

/*Fim Integra‡Æo Canais*/

