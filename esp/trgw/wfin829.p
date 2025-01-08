/********************************************************************************
 ** UPC........: wfin829.p - UPC TRIGGER WRITE tit_acr_cobr_especial
 ** Data.......: Agosto / 2012
 ** Objetivo...: Repassar a informa‡Æo do numero do comprovante de venda
                 para o campo de contrato, pois o campo de contrato possui chave 
                 de acesso e conseguimos desta forma deixar a concilia‡Æo mais 
                 perform tica - essco005b
 ********************************************************************************/

DEF PARAM BUFFER b_tit_acr_cobr_especial      FOR tit_acr_cobr_especial.
DEF PARAM BUFFER b_old_tit_acr_cobr_especial  FOR tit_acr_cobr_especial.

DEF VAR v_parcelas AS INT NO-UNDO.


ASSIGN b_tit_acr_cobr_especial.cod_contrat = b_tit_acr_cobr_especial.cod_comprov_vda.

IF  PROGRAM-NAME(1) MATCHES "*acr702zw*" 
OR  PROGRAM-NAME(2) MATCHES "*acr702zw*" 
OR  PROGRAM-NAME(3) MATCHES "*acr702zw*" 
OR  PROGRAM-NAME(4) MATCHES "*acr702zw*" 
OR  PROGRAM-NAME(5) MATCHES "*acr702zw*" 
OR  PROGRAM-NAME(6) MATCHES "*acr702zw*" THEN DO:

    FIND FIRST fat-duplic NO-LOCK
        WHERE fat-duplic.cod-estabel = b_tit_acr_cobr_especial.cod_estab
          AND fat-duplic.serie       = b_tit_acr_cobr_especial.cod_ser_docto
          AND fat-duplic.nr-fatura   = b_tit_acr_cobr_especial.cod_tit_acr
          AND fat-duplic.parcela     = b_tit_acr_cobr_especial.cod_parcela
          AND fat-duplic.cod-esp     = b_tit_acr_cobr_especial.cod_espec_docto NO-ERROR.
    
    IF  AVAIL fat-duplic THEN DO:
    
        FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = fat-duplic.nr-pedido NO-ERROR.
    
        IF  AVAIL ped-venda THEN DO:
            ASSIGN v_parcelas = 0.
    
            FOR EACH cond-ped OF ped-venda NO-LOCK:
                ASSIGN v_parcelas = v_parcelas + 1.
            END.

            find last remun_parc_cartao_cr no-lock
                where remun_parc_cartao_cr.cod_admdra_cartao_cr = b_tit_acr_cobr_especial.cod_admdra_cartao_cr
                  and remun_parc_cartao_cr.cod_band             = b_tit_acr_cobr_especial.cod_band
                  and remun_parc_cartao_cr.num_parc_cartcred   <= v_parcelas no-error.
            
            if  avail remun_parc_cartao_cr then
                assign b_tit_acr_cobr_especial.val_perc_remun_portad = remun_parc_cartao_cr.val_perc_remun_parc.
        END.
    END.
END.

RETURN "OK".
