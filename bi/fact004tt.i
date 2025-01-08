define temp-table tt-param no-undo
   field usuario  as character
   field senha    as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table ttFactContasReceberCarteira no-undo
   field CD_Estabelecimento      like tit_acr.cod_estab
   field CD_Especie_Documento    like tit_acr.cod_espec_docto
   field CD_Serie                like tit_acr.cod_ser_docto
   field CD_Titulo               like tit_acr.cod_tit_acr
   field CD_Parcela              like tit_acr.cod_parcela
   field CD_Unidade_Negocio      like val_tit_acr.cod_unid_negoc
   field CD_Emitente             like tit_acr.cdn_cliente
   field CD_Portador             like tit_acr.cod_portador
   field CD_Carteira_Bancaria    like tit_acr.cod_cart_bcia
   field CD_Representante        like tit_acr.cdn_repres
   field CD_Pais                 like emitente.pais
   field CD_Estado               like emitente.estado
   field CD_Cidade               like emitente.cidade
   field DT_Posicao              as date
   field DT_Emissao              like tit_acr.dat_emis_docto
   field DT_Vencimento           like tit_acr.dat_vencto_tit_acr
   field NM_Vl_Saldo             like tit_acr.val_sdo_tit_acr
   field NM_Dias_Atraso          as integer
   index idx_pri is primary unique CD_Estabelecimento CD_Especie_Documento CD_Serie CD_Titulo CD_Parcela CD_Unidade_Negocio DT_Posicao.

def temp-table tt_titulos_em_aberto_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field ttv_val_sdo_tit_acr_apres        as decimal format "->>>,>>>,>>9.99" decimals 2 label "Saldo Finalid Apres" column-label "Saldo Apres"
    field ttv_num_atraso_dias_acr          as integer format "->>>>>>9" label "Dias" column-label "Dias"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_unid_negoc               ascending
    INDEX id-emitente
            tta_cdn_cliente.
