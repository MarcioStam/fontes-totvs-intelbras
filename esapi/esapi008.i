FOR FIRST layout_impres no-lock
    WHERE layout_impres.nom_impressora    = c-impressora 
    AND   layout_impres.cod_layout_impres = c-form:

    FIND FIRST imprsor_usuar NO-LOCK 
         WHERE imprsor_usuar.nom_impressora = c-impressora
         AND   imprsor_usuar.cod_usuario    = c-seg-usuario
         use-index imprsrsr_id NO-ERROR.
    FIND impressora  OF imprsor_usuar NO-LOCK NO-ERROR.
    FIND tip_imprsor OF impressora    NO-LOCK NO-ERROR.

    IF layout_impres.num_lin_pag = 0 then do:
        /* sem salta pÿgina */
       output  {&stream} 
                to value(imprsor_usuar.nom_disposit_so)
                page-size 0
                convert target tip_imprsor.cod_pag_carac_conver . 
    END.
    ELSE DO:
        /* com salta página */
        output {&stream} 
                to value(imprsor_usuar.nom_disposit_so)
                paged page-size value(layout_impres.num_lin_pag) 
                convert target tip_imprsor.cod_pag_carac_conver.
    END.
    
    for each configur_layout_impres no-lock
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:
    
        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.
    
        do iCont = 1 to extent(configur_tip_imprsor.num_carac_configur):
          case configur_tip_imprsor.num_carac_configur[iCont]:
            when 0 then put {&stream} control null.
            when ? then leave.
            otherwise   put {&stream} control CODEPAGE-CONVERT(chr(configur_tip_imprsor.num_carac_configur[iCont]),
                                                               session:cpinternal, 
                                                               tip_imprsor.cod_pag_carac_conver).
          end case.
        end.
    end.
END.
IF NOT AVAIL layout_impres THEN
    MESSAGE "NÆo encontrado Sa¡da de ImpressÆo para [" c-impressora  "] e Formul rio [" c-form "]"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
