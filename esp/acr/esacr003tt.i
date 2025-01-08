DEF TEMP-TABLE tt_saldo
    FIELD cod_empresa            LIKE tit_acr.cod_empresa 
    FIELD cod_estab              LIKE tit_acr.cod_estab
    FIELD cod_espec_docto        LIKE tit_acr.cod_espec_docto  
    FIELD cod_ser_docto          LIKE tit_acr.cod_ser_docto
    FIELD cod_tit_acr            LIKE tit_acr.cod_tit_acr               
    FIELD cod_parcela            LIKE tit_acr.cod_parcela               
    FIELD dat_vencto_tit_acr     LIKE tit_acr.dat_vencto_tit_acr        
    FIELD dat_emis_docto         LIKE tit_acr.dat_emis_docto            
    FIELD val_sdo_origin_tit_acr LIKE tit_acr.val_origin_tit_acr
    FIELD val_origin_tit_acr     LIKE tit_acr.val_origin_tit_acr        
    FIELD val_sdo_tit_acr        LIKE tit_acr.val_sdo_tit_acr
    FIELD num_atr                AS INTEGER 
    FIELD cod_portador           LIKE tit_acr.cod_portador              
    FIELD cod_cart_bcia          LIKE tit_acr.cod_cart_bcia
    FIELD rec_tit_acr            AS RECID
    FIELD cdn_cliente            LIKE tit_acr.cdn_cliente 
    FIELD num_id_tit_acr         LIKE tit_acr.num_id_tit_acr
    FIELD ind_sit_envio          LIKE int_tit_acr.ind_sit_envio
    FIELD cod_tit_acr_bco        LIKE tit_acr.cod_tit_acr_bco
    FIELD val_desp_cartorio      LIKE int_tit_acr.val_desp_cartorio
    FIELD cod_boleto_impresso    AS CHAR FORMAT "x(3)" INITIAL "NÇO"
    FIELD cod_perda              AS CHAR FORMAT "x(3)" INITIAL "NÇO"
    FIELD num_planinha_vendor    LIKE parc_vendor.num_planilha_vendor
    FIELD ind_tip_espec_docto    LIKE tit_acr.ind_tip_espec_docto
    FIELD l-ok                   AS CHAR FORMAT "x(1)" LABEL " "
    FIELD cod_cond_cobr          LIKE tit_acr.cod_cond_cobr
    FIELD log_liq_perdas         AS LOG FORMAT "Sim/NÆo" LABEL "Liq. Perda"
    FIELD cod_PO_cliente         AS CHAR FORMAT "x(12)"
    FIELD dat_entrega            LIKE nota-fiscal.dt-entr-cli
    FIELD dat_prev_entr          LIKE nota-fiscal.dt-entr-cli
    INDEX ix-dt-venc dat_vencto_tit_acr
                     cod_tit_acr
                     cod_parcela
    INDEX ix-tit     cod_tit_acr
                     cod_parcela
                     dat_vencto_tit_acr.

DEF TEMP-TABLE tt_tit_acr_enviado
    FIELD cod_estab           LIKE tit_acr.cod_estab
    FIELD cod_espec_docto     LIKE tit_acr.cod_espec_docto  
    FIELD cod_ser_docto       LIKE tit_acr.cod_ser_docto
    FIELD cod_tit_acr         LIKE tit_acr.cod_tit_acr               
    FIELD cod_parcela         LIKE tit_acr.cod_parcela               
    FIELD dat_vencto_tit_acr  LIKE tit_acr.dat_vencto_tit_acr        
    FIELD dat_emis_docto      LIKE tit_acr.dat_emis_docto            
    FIELD cod_portador        LIKE tit_acr.cod_portador              
    FIELD cod_cart_bcia       LIKE tit_acr.cod_cart_bcia
    FIELD cdn_cliente         LIKE tit_acr.cdn_cliente 
    FIELD nom_abrev           LIKE emscad.cliente.nom_abrev
    FIELD val_sdo_tit_acr     LIKE tit_acr.val_sdo_tit_acr           
    FIELD val_origin_tit_acr  LIKE tit_acr.val_origin_tit_acr
    FIELD val_desp_cartorio   LIKE int_tit_acr.val_desp_cartorio
    INDEX dt-venc cdn_cliente 
                  dat_vencto_tit_acr.

DEFINE TEMP-TABLE tt_Cliente
    FIELD cdn_cliente       LIKE emscad.cliente.cdn_cliente
    FIELD nom_pessoa        LIKE emscad.cliente.nom_pessoa
    FIELD nom_cidade        LIKE pessoa_jurid.nom_cidade
    FIELD cod_telefone      LIKE pessoa_jurid.cod_telefone
    FIELD des_grp_clien     LIKE grp_clien.des_grp_clien
    FIELD cod_unid_federac  LIKE pessoa_jurid.cod_unid_federac
    FIELD cdn_repres        LIKE clien_financ.cdn_repres
    FIELD nom_abrev_repres  LIKE representante.nom_abrev
    FIELD d-saldo           LIKE tit_acr.val_origin_tit_acr
    FIELD d-saldoc          LIKE tit_acr.val_sdo_tit_acr
    FIELD d-credito         LIKE tit_acr.val_origin_tit_acr
    FIELD d-vecdo           LIKE tit_acr.val_sdo_tit_acr
    FIELD d-avcer           LIKE tit_acr.val_sdo_tit_acr
    FIELD d-vcto-mes        LIKE tit_acr.val_sdo_tit_acr
    FIELD d-vl-cartorio     LIKE int_tit_acr.val_desp_cartorio.
