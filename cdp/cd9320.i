/*******************************************************************************
**
**  CD9320.I - Atualizacao da Inspecao do Fornecedor
**
*******************************************************************************/

if (ficha-cq.qt-original - ficha-cq.qt-aprovada - ficha-cq.qt-consumida -
    ficha-cq.qt-rejeitada - ficha-cq.qt-apr-cond = 0) and
    param-cq.tipo-cq = 3 then do:
    
    if ficha-cq.qt-rejeitada > 0 then
        assign i-insp = 2.
    else if ficha-cq.qt-apr-cond > 0 then
        assign i-insp = 3.
    else
        assign i-insp = 1.

   &if "{&bf_mat_versao_ems}" >= "2.04" &then
        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-cq-itfornest"
                    AND   funcao.ativo     = YES NO-LOCK) THEN DO:
            ASSIGN l-leitura-item-fornec-estab = YES.
        END.
        &if "{&bf_mat_versao_ems}" >= "2.062" &then
            ASSIGN l-leitura-item-fornec-estab = YES.
        &ENDIF
        
        IF l-leitura-item-fornec-estab THEN DO:    
            FIND FIRST item-fornec-estab
                 WHERE item-fornec-estab.it-codigo   = ficha-cq.it-codigo 
                 AND   item-fornec-estab.cod-emite   = ficha-cq.cod-emite 
                 AND   item-fornec-estab.cod-estabel = ficha-cq.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL item-fornec-estab THEN DO:
               {cdp/cd9320.i1 "item-fornec-estab"}
            END.
            ELSE 
                ASSIGN l-leitura-item-fornec-estab = NO.
        END.
   &ENDIF
    IF l-leitura-item-fornec-estab = NO THEN DO:
        find item-fornec where
             item-fornec.it-codigo = ficha-cq.it-codigo and
             item-fornec.cod-emite = ficha-cq.cod-emite EXCLUSIVE-LOCK no-error.
        IF AVAIL item-fornec THEN DO:
            {cdp/cd9320.i1 "item-fornec"}
        END.
    END.
end.

/* CD9320.I */

