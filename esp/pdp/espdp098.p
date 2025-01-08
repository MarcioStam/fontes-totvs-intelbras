DEFINE INPUT PARAM  pConta     AS CHAR NO-UNDO.
DEFINE INPUT PARAM  pEstab     AS CHAR NO-UNDO.
DEFINE INPUT PARAM  pItem      LIKE ITEM.it-codigo NO-UNDO.
DEFINE INPUT PARAM  pPrecoUnit AS DEC NO-UNDO.
DEFINE INPUT PARAM  pPercIcms  AS DEC NO-UNDO.
DEFINE INPUT PARAM  pIndice    AS DEC NO-UNDO.
DEFINE OUTPUT PARAM pPreco     AS DEC NO-UNDO.

DEFINE VAR d-preco AS DEC NO-UNDO.

ASSIGN d-preco = 0.

find first int-emitente 
     where int-emitente.cod-guid = pConta no-lock no-error.
find first emitente 
     where emitente.cod-emitente = int-emitente.cod-emitente no-lock no-error.

/*ESTADOS que devem ser desconsideradas*/
FIND first ponto-programa
     WHERE ponto-programa.nome-programa = "msg0138":U
       AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
IF AVAIL ponto-programa THEN DO:
   FIND FIRST conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          and ENTRY(1,conteudo-programa.conteudo) = pEstab 
          and ENTRY(2,conteudo-programa.conteudo) = emitente.estado NO-ERROR.
   IF AVAIL conteudo-programa THEN DO:

        IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ponto1").
     
        FIND FIRST ct-clas-item
             WHERE ct-clas-item.cod-item = pItem
               AND ct-clas-item.cod-clas-fis BEGINS "PE -"  no-lock NO-ERROR.
        if AVAIL ct-clas-item then DO:
           FIND FIRST ct-clas-fis
                WHERE ct-clas-fis.cod-clas-fis = ct-clas-item.cod-clas-fis
                  and ct-clas-fis.idi-tip-clas = 1 no-error.
           if avail ct-clas-fis then 
              find first ct-trib-clas-fisc
                   where ct-trib-clas-fisc.cod-clas-fis = ct-clas-fis.cod-clas-fis no-error.
           if avail ct-trib-clas-fisc then 
              find first ct-configur-trib
                   where ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib no-error.
              if avail ct-configur-trib then 
                 find first ct-formul
                      where ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc.

           IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ponto2").
     
           if AVAIL ct-configur-trib AND ct-configur-trib.cod-tip-trib = 'ICMS' and avail ct-formul and ct-formul.val-perc-reduc > 0 then DO:

                 //IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> " + string(ct-formul.val-perc-reduc).

                 assign d-preco = round(pPrecoUnit / (1 - (1 * ((pPercIcms / 100) *  (1 - (ct-formul.val-perc-reduc / 100))))) * pIndice,4).

                // IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ProdutoItemR.PrecoLiquido -> " + string(ProdutoItemR.PrecoLiquido)).
           END.
        END.
   END.
   ASSIGN pPreco = d-preco.  
END.
