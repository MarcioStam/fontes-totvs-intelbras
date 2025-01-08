if not can-find(first aloc_bem where
                      aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                      no-lock)
then if  bem_pat.cod_plano_ccusto    = tt-param.cod_plano_ccusto
     and bem_pat.cod_ccusto_respons >= tt-param.cod_ccusto_ini
     and bem_pat.cod_ccusto_respons <= tt-param.cod_ccusto_fim
     then.
     else next.
else if not can-find(first aloc_bem where
                           aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                       and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                       and aloc_bem.cod_plano_ccusto = tt-param.cod_plano_ccusto
                       and aloc_bem.cod_ccusto      >= tt-param.cod_ccusto_ini
                       and aloc_bem.cod_ccusto      <= tt-param.cod_ccusto_fim
                           no-lock)
     then next.

for first grup-maquina fields(gm-codigo descricao)
    where grup-maquina.gm-codigo = int_bem_pat_gm.gm-codigo
          no-lock: end.

create tt_int_bem_pat.
assign tt_int_bem_pat.num_bem_pat       = int_bem_pat.num_bem_pat
       tt_int_bem_pat.num_seq_bem_pat   = int_bem_pat.num_seq_bem_pat
       tt_int_bem_pat.cod_cta_pat       = int_bem_pat.cod_cta_pat
       tt_int_bem_pat.des_bem_pat       = bem_pat.des_bem_pat
       tt_int_bem_pat.cod_estab         = bem_pat.cod_estab
       tt_int_bem_pat.dat_aquis_bem_pat = bem_pat.dat_aquis_bem_pat
       tt_int_bem_pat.gm-codigo         = int_bem_pat_gm.gm-codigo
       tt_int_bem_pat.descricao         = grup-maquina.descricao when avail grup-maquina.
