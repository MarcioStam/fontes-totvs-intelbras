ASSIGN tt-consulta-res.c-periodo-ano-{1} =  movto_real_orcto.num_period_ctbl + movto_real_orcto.cod_exerc_ctbl                      
       tt-consulta-res.valor_real-{1}    =  tt-consulta-res.valor_real-{1} + IF movto_real_orcto.ind_natur_lancto_ctbl = "CR" THEN movto_real_orcto.val_realiz_per ELSE movto_real_orcto.val_realiz_per * -1.
