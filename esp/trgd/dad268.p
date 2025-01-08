/********************************************************************************
 ** UPC........: dad268.p - UPC DELETE transporte
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de transportadores para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-transporte      FOR transporte.
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/

DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-transporte TO raw-param.
{esp/esb/esesb006.i 'msg0022' 'dad268' 'transporte'}

/*
run esp/es0669.p (input "no",
                  "transporte",
                  string(b-transporte.cod-transp,"99999"),
                  "","","","", "", "", "", "").
                  

create tt-transporte-atu.
buffer-copy b-transporte to tt-transporte-atu.
create tt-raw-transfer.

raw-transfer tt-transporte-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Transporte",
                         input "D",
                         input rowid(b-transporte),
                         input table tt-raw-transfer).

*/
