
PROCEDURE pi-gera-tt:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt-baixa.
       delete tt-baixa.
    end.

/*    for each movto_tit_acr no-lock
        where movto_tit_acr.cod_empresa = v_cod_empres_usuar
          and movto_tit_acr.cdn_cliente = iCdn_cliente
          and movto_tit_acr.dat_liquidac_tit_acr >= dtBaixaini
          and movto_tit_acr.dat_liquidac_tit_acr <= dtBaixafim   
          and movto_tit_acr.cod_espec_docto >= cespecieini 
          and movto_tit_acr.cod_espec_docto <= cespeciefim 
          and movto_tit_acr.cod_portador >= cportadorini
          and movto_tit_acr.cod_portador <= cportadorfim
          and (movto_tit_acr.cod_espec_docto = "DP" 
           or movto_tit_acr.cod_espec_docto = "dm"
           or movto_tit_acr.cod_espec_docto = "ve"
           or movto_tit_acr.cod_espec_docto = "vd"
           or movto_tit_acr.cod_espec_docto = "za"
           or movto_tit_acr.cod_espec_docto = "zb"
           or movto_tit_acr.cod_espec_docto = "zc")
          and (movto_tit_acr.ind_trans_acr = "Liquida‡Æo" /*2*/
          /*or   movto_tit_acr.transacao = 21)*/
          /*and not movto_tit_acr.baixa-subs*/ ),
        first tit_acr NO-LOCK
            WHERE tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr :
*/
    
    /***** alterei o for each pois estava muito lento a entrada no 
           programa - claudiney 06/01/2006  *********/
    
    FOR EACH tit_acr NO-LOCK
        WHERE tit_acr.cod_estab = v_cod_estab_usuar
        AND   tit_acr.cdn_cliente = icdn_cliente,
        EACH movto_tit_acr OF tit_acr NO-LOCK
             where movto_tit_acr.dat_liquidac_tit_acr >= dtBaixaini
             and movto_tit_acr.dat_liquidac_tit_acr <= dtBaixafim   
             and movto_tit_acr.cod_espec_docto >= cespecieini 
             and movto_tit_acr.cod_espec_docto <= cespeciefim 
             and movto_tit_acr.cod_portador >= cportadorini
             and movto_tit_acr.cod_portador <= cportadorfim
             and (movto_tit_acr.cod_espec_docto = "DP" 
             or  movto_tit_acr.cod_espec_docto = "dm"
             or  movto_tit_acr.cod_espec_docto = "ve"
             or  movto_tit_acr.cod_espec_docto = "vd")
             and (movto_tit_acr.ind_trans_acr = "Liquida‡Æo"):

        assign i-tit = "". 

        if movto_tit_acr.cod_espec_docto = "dp" or movto_tit_acr.cod_espec_docto = "dm" then do:
            find first btit_acr no-lock
                where btit_acr.cod_empresa      = v_cod_empres_usuar
                  and btit_acr.cod_estab        = v_cod_estab_usuar
                  and btit_acr.cod_espec_docto  = "ZA"
                  and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                  and btit_acr.cod_parcela      = tit_acr.cod_parcela
                no-error.
            if avail btit_acr then next.
            FIND FIRST dupl_vendor NO-LOCK
                WHERE dupl_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
            if avail dupl_vendor then next.
               /*
               FOR EACH  parc_vendor 
                   WHERE parc_vendor.cod_estab           = dupl_vendor.cod_estab
                   AND   parc_vendor.num_planilha_vendor = dupl_vendor.num_planilha_vendor:
               END.*/
          /*
          find dp-vendor no-lock   
               where dp-vendor.cod_empresa      = movto_tit_acr.cod_empresa 
                 and dp-vendor.cod_estab        = movto_tit_acr.cod_estab 
                 and dp-vendor.cod_espec_docto  = movto_tit_acr.cod_espec_docto
                 and dp-vendor.cod_tit_acr      = tit_acr.cod_tit_acr 
                 and dp-vendor.cod_parcela      = tit_acr.cod_parcela no-error.
          if not avail dp-vendor then do: 
             find first dp-vendor no-lock   
                  where dp-vendor.cod_empresa   = movto_tit_acr.cod_empresa 
                    and dp-vendor.cod_estab     = movto_tit_acr.cod_estab 
                    and dp-vendor.cod_espec_docto = movto_tit_acr.cod_espec_docto
                    and dp-vendor.cod_tit_acr   = tit_acr.cod_tit_acr no-error.
          end.
          */
            assign i-tit  = tit_acr.cod_tit_acr.
            assign da-tit = movto_tit_acr.dat_vencto_tit_acr.
            run pi-grava-tt-baixa.
        end.
        if movto_tit_acr.cod_espec_docto = "ve" then do:
            find first btit_acr no-lock
                where btit_acr.cod_empresa      = v_cod_empres_usuar
                  and btit_acr.cod_estab        = v_cod_estab_usuar
                  and btit_acr.cod_espec_docto  = "vd"
                  and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                  and btit_acr.cod_parcela      = tit_acr.cod_parcela
                no-error.
            if avail btit_acr then next.

          /*
          find dp-vendor no-lock
               where dp-vendor.nr-planilha = tit_acr.cod_tit_acr no-error.
          if avail dp-vendor then   
              assign i-tit = dp-vendor.cod_tit_acr
                     da-tit = movto_tit_acr.dat_vencto_tit_acr.
          */
            run pi-grava-tt-baixa.

        end.
        if movto_tit_acr.cod_espec_docto = "vd" then do:
            find first btit_acr no-lock
                where btit_acr.cod_empresa      = v_cod_empres_usuar
                  and btit_acr.cod_estab        = v_cod_estab_usuar
                  and btit_acr.cod_espec_docto  = "ZA"
                  and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                  and btit_acr.cod_parcela      = tit_acr.cod_parcela no-error.
            if avail btit_acr then next.

/*** a data de credito da ve tem que ser no maximo 1 ano atras *******/

            find first btit_Acr no-lock
                where btit_acr.cod_empresa      = v_cod_empres_usuar
                  and btit_acr.cod_estab        = v_cod_estab_usuar
                  and btit_acr.cod_espec_docto  = "ve"
                  and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                  and btit_acr.cod_parcela      = tit_acr.cod_parcela 
                no-error.
            if avail btit_acr then do:
              /*
              find dp-vendor no-lock
                   where dp-vendor.nr-planilha = tit_acr.cod_tit_acr no-error.
              if avail dp-vendor then   
                  assign i-tit = dp-vendor.cod_tit_acr
                         da-tit = tit_acr.dat_vencto_tit_acr.
              */
                run pi-grava-tt-baixa.
            end.
        end.
        if movto_tit_acr.cod_espec_docto begins "z" then do:
            find first btit_acr no-lock
                where btit_acr.cod_empresa      = v_cod_empres_usuar
                  and btit_acr.cod_estab        = v_cod_estab_usuar
                  and btit_acr.cod_espec_docto  = "ve"
                  and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                  and btit_acr.cod_parcela      = tit_acr.cod_parcela 
                no-error.

            if not avail btit_acr then 
                find first btit_acr no-lock
                    where btit_acr.cod_empresa      = v_cod_empres_usuar
                      and btit_acr.cod_estab        = v_cod_estab_usuar
                      and btit_acr.cod_espec_docto  = "dm"
                      and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                      and btit_acr.cod_parcela      = tit_acr.cod_parcela 
                    no-error.
            if not avail btit_acr then     
                find first btit_acr no-lock
                    where btit_acr.cod_empresa      = v_cod_empres_usuar
                      and btit_acr.cod_estab        = v_cod_estab_usuar
                      and btit_acr.cod_espec_docto  = "dp"
                      and btit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                      and btit_acr.cod_parcela      = tit_acr.cod_parcela 
                    no-error.
            if avail btit_acr then do:
              /*
              find dp-vendor no-lock
                   where dp-vendor.nr-planilha = tit_acr.cod_tit_acr no-error.
              if avail dp-vendor then   
                  assign i-tit = dp-vendor.cod_tit_acr.
              */    
                assign da-tit = btit_acr.dat_vencto_tit_acr.
                run pi-grava-tt-baixa.
            end.
        end.
    end.

END PROCEDURE.



PROCEDURE pi-grava-tt-baixa:
    find first tt-baixa
         where tt-baixa.cod-esp  = tit_acr.cod_espec_docto
           and tt-baixa.nr-docto = tit_acr.cod_tit_acr
           and tt-baixa.parcela  = tit_acr.cod_parcela 
           and tt-baixa.dt-baixa = movto_tit_acr.dat_liquidac_tit_acr no-error.
    if not avail tt-baixa then do:
        create tt-baixa.
        assign tt-baixa.cod-esp  = movto_tit_acr.cod_espec_docto
               tt-baixa.nr-docto = tit_acr.cod_tit_acr
               tt-baixa.tit-ven  = i-tit
               tt-baixa.parcela  = tit_acr.cod_parcela
               tt-baixa.dt-baixa = movto_tit_acr.dat_liquidac_tit_acr
               tt-baixa.periodo = string(year(movto_tit_acr.dat_liquidac_tit_acr),"9999") +
                                  string(month(movto_tit_acr.dat_liquidac_tit_acr),"99")  .
    end.
    assign tt-baixa.dt-vencimen = da-tit
           tt-baixa.vl-baixa    = tt-baixa.vl-baixa + movto_tit_acr.val_movto_tit_acr
           tt-baixa.cod-port    = movto_tit_acr.cod_portador
           tt-baixa.modalidade  = movto_tit_acr.cod_cart_bcia.
  
END PROCEDURE.


