/********************************************************************************
 ** UPC........: upcd-un007.p - UPC DELETE  unidade da federa‡Æo
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades da federa‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-unid-feder      FOR unid-feder.

DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-unid-feder TO raw-param.
{esp/esb/esesb006.i 'msg0010' 'dun007' 'unid-feder'}

/*
run esp/es0669.p (input "no", 
                  "unid-feder", 
                  b-unid-feder.pais,
                  b-unid-feder.estado, 
                  "", "", "", "", "", "", "").
 
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

IF  l-web-service = NO THEN DO:
    create tt-unid-feder-atu.
    buffer-copy b-unid-feder to tt-unid-feder-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-unid-feder-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "uf",
                             input "D",
                             input rowid(b-unid-feder),
                             input table tt-raw-transfer).
END.
*/
