/*******************************************************************************************/
/*                                                                                         */
/* Programa...: esp/esb/esesbapi001.p - T¡tulos por canal                                  */
/* Altor......: Roger Marcelino Bruhn                                                      */
/* Data.......: 27/03/2014                                                                 */ 
/* Parƒmetros.: p-cod-emitente -> C¢digo do emitente                                       */
/*              tt_titulos_em_aberto_acr -> retornar  com os t¡tulos em aberto do cliente  */           
/*                                                                                         */
/*******************************************************************************************/

/* Temp-table conforme mensagem defini‡Æo MSG0098R1 */
{esp/esb/esesbapi001.i}

DEF INPUT  PARAM p-emitente AS INTEGER NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-titulos-canal.

DEF VAR l-lista AS LOG NO-UNDO.

FOR EACH estabelecimento FIELDS (nom_pessoa cod_estab) NO-LOCK
    WHERE estabelecimento.cod_empresa = "1"
      AND estabelecimento.cod_estab <> "102"

    , EACH tit_acr  FIELDS (cod_empresa cod_estab cdn_cliente cod_tit_acr cod_cart_bcia  dat_emis_docto           
                            dat_indcao_perda_dedut dat_liquidac_tit_acr dat_vencto_tit_acr dat_vencto_origin_tit_acr
                            cod_espec_docto ind_tip_espec_docto cod_ser_docto log_tit_acr_estordo cod_indic_econ      
                            cod_banco cod_parcela cod_portador cdn_repres log_tit_acr_cobr_bcia log_sdo_tit_acr           
                            val_origin_tit_acr val_sdo_tit_acr tit_acr.dat_vencto_tit_acr) 
    NO-LOCK
    WHERE tit_acr.cod_estab = estabelecimento.cod_estab
      AND tit_acr.cdn_cliente = p-emitente 
      AND  tit_acr.val_sdo_tit_acr      > 0
      AND  tit_acr.log_tit_acr_estordo  = NO
        ,FIRST emscad.cliente FIELDS(nom_pessoa cdn_cliente cod_id_feder) NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
              AND emscad.cliente.cod_empresa = tit_acr.cod_empresa
        
        ,FIRST emscad.portador FIELDS (nom_pessoa) NO-LOCK
            WHERE emscad.portador.cod_portador = tit_acr.cod_portador
        
        ,FIRST representante FIELDS (nom_pessoa) NO-LOCK
            WHERE representante.cod_empresa = tit_acr.cod_empresa
              AND representante.cdn_repres = tit_acr.cdn_repres:


    ASSIGN l-lista = NO.

    IF  tit_acr.ind_tip_espec_docto = "Normal"
    OR  tit_acr.ind_tip_espec_docto BEGINS "Vendor" THEN
        IF  tit_acr.cod_portador  <> "9904"
        AND tit_acr.cod_portador  <> "9905"
        AND tit_acr.cod_portador  <> "9930"
        AND tit_acr.cod_portador  <> "9915"
        AND tit_acr.cod_portador  <> "9919"
        AND tit_acr.cod_portador  <> "9929"
        AND tit_acr.cod_portador  <> "9943"
        AND tit_acr.cod_portador  <> "9996"
        AND tit_acr.cod_portador  <> "9977"
        AND tit_acr.cod_portador  <> "9954"
        AND tit_acr.cod_cart_bcia <> "CSR" THEN 
            ASSIGN l-lista = YES.

    IF  NOT l-lista THEN
        NEXT.

    CREATE tt-titulos-canal.
    ASSIGN tt-titulos-canal.CodigoCliente               = emscad.cliente.cdn_cliente
           tt-titulos-canal.NomeCliente                 = emscad.cliente.nom_pessoa
           tt-titulos-canal.CNPJ                        = emscad.cliente.cod_id_feder
           tt-titulos-canal.NumeroTitulo                = tit_acr.cod_tit_acr 
           tt-titulos-canal.Carteira                    = tit_acr.cod_cart_bcia
           tt-titulos-canal.DataEmissao                 = tit_acr.dat_emis_docto  
           tt-titulos-canal.DataIndicacaoPerdaDedutivel = tit_acr.dat_indcao_perda_dedut
           tt-titulos-canal.DataLiquidacao              = tit_acr.dat_liquidac_tit_acr
           tt-titulos-canal.DataVencimento              = tit_acr.dat_vencto_tit_acr
           tt-titulos-canal.DataVencimentoOriginal      = tit_acr.dat_vencto_origin_tit_acr
           tt-titulos-canal.Especie                     = tit_acr.cod_espec_docto
           tt-titulos-canal.TipoEspecie                 = tit_acr.ind_tip_espec_docto
           tt-titulos-canal.NumeroSerie                 = tit_acr.cod_ser_docto
           tt-titulos-canal.CodigoEstabelecimento       = estabelecimento.cod_estab
           tt-titulos-canal.NomeEstabelecimento         = estabelecimento.nom_pessoa
           tt-titulos-canal.Moeda                       = tit_acr.cod_indic_econ
           tt-titulos-canal.NumeroBancario              = tit_acr.cod_portador
           tt-titulos-canal.NumeroParcela               = tit_acr.cod_parcela 
           tt-titulos-canal.CodigoPortador              = int(tit_acr.cod_portador )
           tt-titulos-canal.NomePortador                = emscad.portador.nom_pessoa
           tt-titulos-canal.CodigoRepresentante         = tit_acr.cdn_repres
           tt-titulos-canal.NomeRepresentante           = representante.nom_pessoa
           tt-titulos-canal.TituloEmCobranca            = tit_acr.log_tit_acr_cobr_bcia
           tt-titulos-canal.NumeroDiasAtraso            = TODAY - tit_acr.dat_vencto_tit_acr.

    IF  tit_acr.cod_espec_docto = "VE" THEN DO:
         /*** Localiza extensÆo da parcela que cont‚m o valor do cliente(com juros) ***/
         FIND FIRST parc_vendor NO-LOCK
             WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
               AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
         IF AVAIL parc_vendor THEN
            ASSIGN tt-titulos-canal.ValorSaldo    = parc_vendor.val_parc_vendor_clien
                   tt-titulos-canal.ValorOriginal = parc_vendor.val_parc_vendor_orig.
    END.
    ELSE
        ASSIGN tt-titulos-canal.ValorSaldo    = tit_acr.val_sdo_tit_acr
               tt-titulos-canal.ValorOriginal = tit_acr.val_origin_tit_acr.

END.

RETURN "OK".
