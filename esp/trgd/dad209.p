/********************************************************************************
 ** UPC........: upcd-un007.p - UPC DELETE  portador
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades da federa‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-portador      FOR mgcad.portador.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-portador TO raw-param.
{esp/esb/esesb006.i 'msg0024' 'dad209.p' 'portador'}

/*Fim Integra‡Æo Canais*/
