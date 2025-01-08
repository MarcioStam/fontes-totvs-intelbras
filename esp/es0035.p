define variable v_dt_ini_mes  as date     no-undo.
define variable v_dt_fim_mes  as date     no-undo.
define variable v_dias_comerc as integer  no-undo. /* 3 £ltimos dias £teis para o Comercial */
define variable v_dias_fecham as integer  no-undo. /* 4 primeiros dias £teis para Controladoria e Financeiro */

assign v_dt_ini_mes = date(month(today), 1, year(today))
       v_dt_fim_mes = date(if month(today) < 12 then
                              month(today) + 1
                           else
                              1,
                           1,
                           if month(today) < 12 then
                              year(today)
                           else
                              year(today) + 1) - 1.

/* Para o Comercial */
for each dia_calend_glob no-lock
   where dia_calend_glob.cod_calend  = 'FISCAL'
     and dia_calend_glob.dat_calend >= today
     and dia_calend_glob.dat_calend <= v_dt_fim_mes
     and dia_calend_glob.log_dia_util:
   assign v_dias_comerc = v_dias_comerc + 1.
end.

/* Para a Controladoria e Financeiro */
for each dia_calend_glob no-lock
   where dia_calend_glob.cod_calend  = 'FISCAL'
     and dia_calend_glob.dat_calend >= v_dt_ini_mes
     and dia_calend_glob.dat_calend <= today
     and dia_calend_glob.log_dia_util:
   assign v_dias_fecham = v_dias_fecham + 1.
end.

for each param_basic no-lock
   where param_basic.log_ativ_timeout:

    run pi-apaga-tmo (input 'TMX').
    run pi-apaga-tmo (input 'TMC').

    /* 5 dias £teis do in¡cio do mˆs */
    if v_dias_fecham < 6 then
        run pi-cria-tmo (input 'TMX').

    /* 5 dias £teis para o fim do mˆs */
    if v_dias_comerc < 6 then
        run pi-cria-tmo (input 'TMC').

end.

procedure pi-cria-tmo:
   define input parameter p_cod_grp_usuar like grp_usuar.cod_grp_usuar no-undo.
   define buffer b-usuar_grp_usuar for usuar_grp_usuar.
   
   for each usuar_grp_usuar no-lock
      where usuar_grp_usuar.cod_grp_usuar = p_cod_grp_usuar:

      if can-find (first b-usuar_grp_usuar
                   where b-usuar_grp_usuar.cod_grp_usuar = 'TMO'
                     and b-usuar_grp_usuar.cod_usuario = usuar_grp_usuar.cod_usuario) then
         next.

      create b-usuar_grp_usuar.
      assign b-usuar_grp_usuar.cod_grp_usuar = 'TMO'.
      buffer-copy usuar_grp_usuar except cod_grp_usuar to b-usuar_grp_usuar.
   end.
end procedure.

procedure pi-apaga-tmo:
   define input parameter p_cod_grp_usuar like grp_usuar.cod_grp_usuar no-undo.
   define buffer b-usuar_grp_usuar for usuar_grp_usuar.
   
   for each usuar_grp_usuar exclusive-lock
      where usuar_grp_usuar.cod_grp_usuar = 'TMO':

      if can-find (first b-usuar_grp_usuar
                   where b-usuar_grp_usuar.cod_grp_usuar = p_cod_grp_usuar
                     and b-usuar_grp_usuar.cod_usuario = usuar_grp_usuar.cod_usuario) then
         delete usuar_grp_usuar.
   end.
end procedure.
