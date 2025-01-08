/********************************************************************************
 ** UPC........: dad098.p - UPC DELETE cont-emit
 ** Data.......: Fevereiro / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes de emitente para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-cont-emit      FOR cont-emit.

    
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "yes",  /**** para elimina‡Æo de contatos, este flag tem que estar yes pois a tratativa de contatos ‚ feita no programa es0666. */
                  "emitente", 
                  string(b-cont-emit.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "", "").


IF  l-web-service = NO THEN DO:
    find first emitente no-lock where
               emitente.cod-emitente = b-cont-emit.cod-emitente no-error.
    if avail emitente and emitente.identific <> 2 then do:
      create tt-cont-emit-atu.
      buffer-copy b-cont-emit to tt-cont-emit-atu.
      create tt-raw-transfer.
      
      raw-transfer tt-cont-emit-atu to tt-raw-transfer.record.
       
      run esp/crm/escrm001a.p (input "Cont-emit",
                               input "D",
                               input rowid(b-cont-emit),
                               input table tt-raw-transfer).
    end.
END.
*/
