/********************************************************************************
 ** UPC........: wad268.p - UPC WRITE transporte
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de transportadores para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-transporte      FOR transporte.
DEF PARAM BUFFER b-old-transporte  FOR transporte.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-transporte TO raw-param.
{esp/esb/esesb006.i 'msg0022' 'wad268' 'transporte'}

/*Fim Integra‡Æo Canais*/

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "yes",
                  "transporte",
                  string(b-transporte.cod-transp,"99999"),
                  "","","","", "", "", "", "").


run esp/crm/escrm001a.p (input "Transporte",
                         input "W",
                         input rowid(b-transporte),
                         input table tt-raw-transfer).
*/
