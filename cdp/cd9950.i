/* ***********************************************************************
**  Objetivo:  Valida e Converte Unidades de Medida - devolve de-indice.
**  
**  {1} = nossa unidade de medida
**  {2} = unidade do fornecedor
**  {3} = codigo fornecedor
**
************************************************************************ */
FIND FIRST param-compra NO-LOCK NO-ERROR.

if  item.it-codigo <> "" and item.it-codigo <> ? then 
    find item-fornec 
        where item-fornec.it-codigo    = item.it-codigo 
          and item-fornec.cod-emitente = {3}            
          and item-fornec.ativo        = yes
        no-lock no-error.

if  available item-fornec then do:
    if avail param-compra 
         and param-compra.log-multi-unid-medid
         and item-fornec.unid-med-for <> {2} then do:
        /*Utiliza M£ltiplas Unidades de Medida
        Se unidade da item-fornec <> unidade da cotaá∆o, busca fator de convers∆o conforme a unidade da cotaá∆o*/
        FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec)
            WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
              AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
              AND item-fornec-umd.unid-med-for = {2}
              AND item-fornec-umd.log-ativo NO-LOCK: END.
        IF AVAIL item-fornec-umd THEN
            assign de-indice = item-fornec-umd.fator-conver / 
                               if  item-fornec-umd.num-casa-dec = 0 then 1
                               else exp(10,item-fornec-umd.num-casa-dec).
        else 
            assign de-indice = 1.
    end.
    else
        assign de-indice = item-fornec.fator-conver / 
                           if  item-fornec.num-casa-dec = 0 then 1
                           else exp(10,item-fornec.num-casa-dec).   
end.
else do:
    find tab-conv-un 
        where tab-conv-un.un           = {1}      
          and tab-conv-un.unid-med-for = ( if avail cotacao-item
                                           and {2} = " "   then
                                              cotacao-item.un
                                           else {2} )
             no-lock no-error.

    if available tab-conv-un then do:
        assign de-indice = tab-conv-un.fator-conver /
                           if tab-conv-un.num-casa-dec = 0 then 1
                           else exp(10,tab-conv-un.num-casa-dec). 
    end.
    else 
        assign de-indice = 1.

end.

/* fim do include */
