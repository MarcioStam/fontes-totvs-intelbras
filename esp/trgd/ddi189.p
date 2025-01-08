/************************************************************************
 ** Programa....: ddi189.p - UPC delete para a tabela tb-preco         **
 ** Data........: junho/2011                                           **
 ************************************************************************/

define param buffer b-tb-preco   for tb-preco.
/***** foi substituida pela trigger de assign ***/

{esp/esb/out/msg0195.i}
{esp/esb/esesb000.i}
DEF VAR raw-param AS RAW NO-UNDO.

/*Situa‡Æo da Tabela de pro‡o. 0-Manuten‡Æo / 1-elimina‡Æo */
{esp/trgw/wdi189.i "1"}


/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

create tt-tb-preco-atu.
buffer-copy b-tb-preco to tt-tb-preco-atu.
create tt-raw-transfer.

raw-transfer tt-tb-preco-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Tb-preco",
                         input "D",
                         input rowid(b-tb-preco),
                         input table tt-raw-transfer).
*/
