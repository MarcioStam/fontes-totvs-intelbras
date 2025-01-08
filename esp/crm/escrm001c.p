/****************************************************************************************
**  Programa...: ESCRM001c.P
**  Objetivo...: Retornar ocorrencias da nota
**  Parametros.: 
**  Autor......: SQLWORKS - Setembro 2010 
*****************************************************************************************/

/*--- Defini‡Æo das Temp-Tables ---*/
{esp/crm/escrm001.i}


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-rw-nota-fiscal AS rowid  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ocorrencia.

find first nota-fiscal no-lock where
           rowid(nota-fiscal) = p-rw-nota-fiscal no-error.
  
if avail nota-fiscal 
then do:
           
    FIND FIRST estabelec WHERE 
               estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
    
    /* TMS FIND FIRST nota-fiscal-tr WHERE
               nota-fiscal-tr.cod-estabel = nota-fiscal.cod-estabel      AND
               nota-fiscal-tr.cd-serie    = nota-fiscal.serie            AND
               nota-fiscal-tr.nr-nf       = INT(nota-fiscal.nr-nota-fis) AND
               nota-fiscal-tr.cgc-rem     = estabelec.cgc NO-LOCK NO-ERROR.
    IF AVAIL NOTa-fiscal-tr 
    THEN DO:   
        
        for each ocorrencia no-lock where
                 ocorrencia.cd-tp-docto     = 2   and
                 ocorrencia.cod-estab-docto = ""  and
                 ocorrencia.cd-serie        = nota-fiscal-tr.cd-serie and
                 ocorrencia.nr-docto        = nota-fiscal-tr.nr-nf    and
                 ocorrencia.cgc-rem         = nota-fiscal-tr.cgc-rem
        break by ocorrencia.dt-ocorrencia:
    
            CREATE tt-ocorrencia.
            ASSIGN tt-ocorrencia.nr-ocorrencia  = ocorrencia.nr-ocorrencia
                   tt-ocorrencia.dt-ocorrencia  = ocorrencia.dt-ocorrencia
                   tt-ocorrencia.ds-ocorrencia  = ocorrencia.ds-ocorrencia   
                   tt-ocorrencia.des-tipo       = "Nota Fiscal" 
                   tt-ocorrencia.chave-integracao-nota-fiscal = STRING(nota-fiscal.cod-estabel) + ",":U + STRING(nota-fiscal.serie) + ",":U + STRING(nota-fiscal.nr-nota-fis)
                   tt-ocorrencia.chave-integracao-ocorrencia  = STRING(ocorrencia.cod-estabel)  + ",":U + STRING(ocorrencia.nr-ocorrencia).
   
        END.
    
    END. */
end.

return "OK".
    
