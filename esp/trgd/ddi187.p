/********************************************************************************
 ** UPC........: ddi187.p - UPC DELETE tab-finan
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-tab-finan  FOR tab-finan.
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */
*/
DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-tab-finan TO raw-param.
{esp/esb/esesb006.i 'msg0044' 'ddi187' 'tab-finan'}
           
/*
DEF VAR i-cont AS INTEGER.                         


IF  l-web-service = NO THEN DO:
    do i-cont = 1 to 12:
        create tt-ind-tab-finan-atu.
    
        assign tt-ind-tab-finan-atu.nr-tab-finan  = b-tab-finan.nr-tab-finan
               tt-ind-tab-finan-atu.nr-ind-finan  = i-cont
               tt-ind-tab-finan-atu.tab-dia-fin   = b-tab-finan.tab-dia-fin[i-cont]
               tt-ind-tab-finan-atu.tab-ind-fin   = b-tab-finan.tab-ind-fin[i-cont].
    
        create tt-raw-transfer.
    
        raw-transfer tt-ind-tab-finan-atu to tt-raw-transfer.record.
    
        run esp/crm/escrm001a.p (input "ind-tab-finan",
                                 input "D",
                                 input rowid(b-tab-finan),
                                 input table tt-raw-transfer).
    end.
    
    
    create tt-tab-finan-atu.
    buffer-copy b-tab-finan to tt-tab-finan-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-tab-finan-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "tab-finan",
                             input "D",
                             input rowid(b-tab-finan),
                             input table tt-raw-transfer).
END.
*/
