/************************************************************************
 ** Programa....: din172.p - UPC delete para a tabela item             **
 ** Data........: novembro/2004                                        **
 ************************************************************************/

define param buffer b-item   for ITEM.
    /***** foi substituida pela trigger de assign ***/
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-item TO raw-param.
{esp/esb/esesb006.i 'msg0088' 'din172' 'ITEM'}

find int-item where int-item.it-codigo = b-item.it-codigo no-error.
if  avail int-item then
    delete int-item.

/*
run esp/es0669.p (input "no",
                  "item",
                  b-item.it-codigo,
                  "", "", "", "", "", "", "", ""). 

if /* b-item.ge-codigo <> 0  AND  /* Debito direto */   
  b-item.ge-codigo <> 20 AND  /* Semi acabado */   
  b-item.ge-codigo <> 25 AND  /* Semi acabado */
  b-item.ge-codigo <> 30 AND /* Material de Consumo */   */
  b-item.ind-item-fat = yes then do: 

    create tt-item-atu.
    buffer-copy b-item to tt-item-atu.
    create tt-raw-transfer.

    raw-transfer tt-item-atu to tt-raw-transfer.record.

    run esp/crm/escrm001a.p (input "Item",
                             input "D",
                             input rowid(b-item),
                             input table tt-raw-transfer).
end.
*/
