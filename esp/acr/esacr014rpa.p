{utp/ut-glob.i}
{esp/acr/esacr014tt.i}

DEF INPUT  PARAMETER c-cliente         LIKE tit_acr.cdn_cliente     no-undo.
DEF OUTPUT PARAMETER d-saldo           LIKE tit_acr.val_sdo_tit_acr no-undo.
DEF OUTPUT PARAMETER d-saldoc          LIKE tit_acr.val_sdo_tit_acr no-undo.
DEF OUTPUT PARAMETER d-credito         LIKE tit_acr.val_sdo_tit_acr no-undo.
DEF OUTPUT PARAM TABLE FOR tt-saldo.
DEF INPUT  PARAM TABLE FOR tt-portador.

DEF BUFFER b_tit_acr_VE FOR tit_acr.
DEF BUFFER b_tit_acr_DM FOR tit_acr.

DEF VAR d-valor LIKE tit_acr.val_sdo_tit_acr.

def buffer b-tit_acr   for tit_acr.
def buffer b1-tit_acr  for tit_acr.

DEFINE BUFFER b_tit_acr FOR tit_acr.

def var i-cont as int.

DEFINE VARIABLE v_num_cont_aux AS INTEGER     NO-UNDO.

FOR EACH tt-saldo :
   DELETE tt-saldo .
END.

DEFINE VARIABLE diferenca AS INTEGER     NO-UNDO.

{esp/acr/esacr014rp.i} /* Carga de ParÉmetros de emiss∆o do relat¢rio */

ASSIGN d-saldo   = 0
       d-saldoc  = 0
       d-credito = 0.

DO v_num_cont_aux = 1 TO NUM-ENTRIES(c_cod_estab_selec):

    FOR EACH estabelecimento FIELDS(cod_estab) NO-LOCK
        WHERE estabelecimento.cod_estab = ENTRY(v_num_cont_aux, c_cod_estab_selec):

        bloco-tit-acr:
        FOR EACH  tit_acr NO-LOCK 
            WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
              AND tit_acr.cdn_repres          >= cdn_repres_ini
              AND tit_acr.cdn_repres          <= cdn_repres_fim
              AND tit_acr.LOG_sdo_tit_Acr      = YES
              AND tit_acr.cod_espec_docto     >= cod_espec_docto_ini
              AND tit_acr.cod_espec_docto     <= cod_espec_docto_fim
              AND tit_acr.val_sdo_tit_acr      > 0
              AND tit_acr.cdn_cliente          = c-cliente
              AND tit_acr.cod_portador        >= cod_portador_ini
              AND tit_acr.cod_portador        <= cod_portador_fim
              AND tit_acr.cod_cart_bcia       >= cod_cart_bcia_ini
              AND tit_acr.cod_cart_bcia       <= cod_cart_bcia_fim,
            FIRST espec_docto NO-LOCK
            WHERE espec_docto.cod_espec_docto = tit_acr.cod_espec_docto
              AND (IF  rs-docto = 3 THEN 
                       espec_docto.ind_tip_espec_docto = "Antecipaá∆o" 
                   ELSE 
                      (espec_docto.ind_tip_espec_docto = "Normal" OR  espec_docto.ind_tip_espec_docto = "Vendor" )
                   )
            BY tit_acr.cod_tit_acr
            BY tit_acr.cod_parcela:
        
            IF  (tit_acr.cod_portador = "999" AND tit_acr.cod_cart_bcia = "6") OR 
                (tit_acr.cod_portador = "955" AND tit_acr.cod_cart_bcia = "5") OR 
                (tit_acr.cod_portador = "977" AND tit_acr.cod_cart_bcia = "5") 
            THEN 
                NEXT bloco-tit-acr.
                  
            IF  rs-docto = 3 THEN DO:

                FIND FIRST nota_devol_tit_acr NO-LOCK                                                 
                     WHERE nota_devol_tit_acr.cod_estab       = tit_acr.cod_estab                     
                       AND nota_devol_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto               
                       AND nota_devol_tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto                 
                       AND nota_devol_tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr                   
                       AND nota_devol_tit_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.         
                                                                                                      
                IF NOT AVAIL nota_devol_tit_acr THEN DO:
                    FOR FIRST movto_tit_acr FIELDS(cod_estab num_id_movto_tit_acr) NO-LOCK
                        WHERE movto_tit_acr.cod_estab      = tit_acr.cod_estab
                          AND movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                          AND movto_tit_acr.ind_trans_acr  = "Implantaá∆o a CrÇdito":

                        FOR FIRST relacto_tit_acr FIELDS(cod_estab num_id_tit_acr) NO-LOCK
                            WHERE relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
                              AND relacto_tit_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr:

                            FOR FIRST b_tit_acr NO-LOCK 
                                WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                  AND b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr:

                                FIND nota_devol_tit_acr NO-LOCK 
                                    WHERE nota_devol_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                      AND nota_devol_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                                      AND nota_devol_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                                      AND nota_devol_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                                      AND nota_devol_tit_acr.cod_parcela     = b_tit_acr.cod_parcela NO-ERROR.
                            END.
                        END.
                    END.
                END.

                IF NOT AVAIL nota_devol_tit_acr THEN
                    NEXT bloco-tit-acr.
            END.

            FIND FIRST tt-portador NO-LOCK
                WHERE tt-portador.cod_portador  = tit_acr.cod_portador
                AND   tt-portador.cod_cart_bcia = tit_acr.cod_cart_bcia NO-ERROR.

            IF  NOT AVAIL tt-portador THEN 
                NEXT bloco-tit-acr.

            ASSIGN diferenca = (TODAY - tit_acr.dat_vencto_tit_acr).

            IF  (l-ve-a AND (diferenca > 0           AND diferenca <= fx-vea-fim)) OR 
                (l-ve-b AND (diferenca >= fx-veb-ini AND diferenca <= fx-veb-fim)) OR 
                (l-ve-c AND (diferenca >= fx-vec-ini AND diferenca <= fx-vec-fim)) OR 
                (l-ve-d AND (diferenca >= fx-ved-ini AND diferenca <= fx-ved-fim)) OR 
                (l-ve-e AND (diferenca >= fx-vee-ini AND diferenca <= fx-vee-fim)) OR 
                (l-ve-f AND (diferenca >= fx-vef-ini AND diferenca <= fx-vef-fim)) OR 
                (l-ve-g AND (diferenca >= fx-veg-ini                            )) OR 
                
                (l-av-a AND (diferenca <= 0                 AND diferenca >= (fx-ava-fim * -1))) OR 
                (l-av-b AND (diferenca <= (fx-avb-ini * -1) AND diferenca >= (fx-avb-fim * -1))) OR 
                (l-av-c AND (diferenca <= (fx-avc-ini * -1) AND diferenca >= (fx-avc-fim * -1))) OR 
                (l-av-d AND (diferenca <= (fx-avd-ini * -1) AND diferenca >= (fx-avd-fim * -1))) OR 
                (l-av-e AND (diferenca <= (fx-ave-ini * -1) AND diferenca >= (fx-ave-fim * -1))) OR 
                (l-av-f AND (diferenca <= (fx-avf-ini * -1) AND diferenca >= (fx-avf-fim * -1))) OR 
                (l-av-g AND (diferenca <= (fx-avg-ini * -1)                                   )) 
            THEN DO:

                ASSIGN d-saldo   = 0
                       d-saldoc  = 0
                       d-credito = 0
                       d-valor   = 0. 
            
                RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                         INPUT  TODAY,
                                         INPUT  tit_acr.val_sdo_tit_acr,
                                         OUTPUT d-valor).
                       
                IF  tit_acr.ind_tip_espec_docto = "Normal" 
                THEN
                    ASSIGN d-saldo  = d-valor      
                           d-saldoc = IF  tit_acr.cod_espec_docto <> "VE" AND 
                                          tit_acr.cod_espec_docto <> "VD" 
                                      THEN d-valor
                                      ELSE 0.
                ELSE 
                    ASSIGN d-credito = d-valor.
            
                CREATE tt-saldo.
                ASSIGN tt-saldo.cod_empresa         = tit_acr.cod_empresa
                       tt-saldo.cod_estab           = tit_acr.cod_estab
                       tt-saldo.cod_espec_docto     = tit_acr.cod_espec_docto
                       tt-saldo.cod_tit_acr         = tit_acr.cod_tit_acr
                       tt-saldo.cod_ser_docto       = tit_acr.cod_ser_docto
                       tt-saldo.num_id_tit_acr      = tit_acr.num_id_tit_acr
                       tt-saldo.cod_parcela         = tit_acr.cod_parcela
                       tt-saldo.dat_vencto_tit_acr  = tit_acr.dat_vencto_tit_acr
                       tt-saldo.ind_tip_espec_docto = tit_acr.ind_tip_espec_docto
                       tt-saldo.dat_emis_docto      = tit_acr.dat_emis_docto           
                       tt-saldo.cod_portador        = tit_acr.cod_portador
                       tt-saldo.cod_cart_bcia       = tit_acr.cod_cart_bcia
                       tt-saldo.val_origin_tit_acr  = d-saldo  + d-credito
                       tt-saldo.val_sdo_tit_acr     = d-saldoc + d-credito
                       tt-saldo.cartorio            = 0 /*tit_acr.u-dec-1*/ .
           END.
        end. /* for each */
    END.
END.

d-saldo = 0.
d-saldoc = 0.
d-credito = 0.
FOR EACH tt-saldo: 
  IF tt-saldo.cod_espec_docto = "VE"  OR 
     tt-saldo.cod_espec_docto = "VEM" THEN DO:  /*Parcela Vendor Migrados do Magnus*/
     /* Localiza parcela vendor gerada no fechamento - VE */
     FIND FIRST tit_acr NO-LOCK
          WHERE tit_acr.cod_estab       = tt-saldo.cod_estab
            AND tit_acr.cod_espec_docto = tt-saldo.cod_espec_docto
            AND tit_acr.cod_ser_docto   = tt-saldo.cod_ser_docto
            AND tit_acr.cod_tit_acr     = tt-saldo.cod_tit_acr
            AND tit_acr.cod_parcela     = tt-saldo.cod_parcela NO-ERROR.
     IF AVAIL tit_acr THEN DO:
         IF tit_acr.cod_espec_docto = "VE" THEN DO:
             /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
             FIND FIRST parc_vendor NO-LOCK
                 WHERE parc_vendor.cod_estab_tit_acr = tt-saldo.cod_estab
                   AND parc_vendor.num_id_tit_acr    = tt-saldo.num_id_tit_acr NO-ERROR.
             IF AVAIL parc_vendor THEN DO:

                 ASSIGN d-valor = parc_vendor.val_parc_vendor_clien.

                 RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                          INPUT  TODAY,
                                          INPUT  parc_vendor.val_parc_vendor_clien,
                                          OUTPUT d-valor).

                 ASSIGN tt-saldo.val_sdo_tit_acr     = d-valor
                        tt-saldo.val_origin_tit_acr  = parc_vendor.val_parc_vendor_orig
                        tt-saldo.num_planinha_vendor = parc_vendor.num_planilha_vendor. 
             END.
            /* Localiza planilha vendor para buscar a nota fiscal de origem */
            FIND FIRST planilha_vendor NO-LOCK
                WHERE planilha_vendor.cod_estab           = tit_acr.cod_estab
                  AND planilha_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.

            /* Localiza duplicata origem (DM, que tem o mesmo numero da nota fiscal) */
            FIND FIRST dupl_vendor NO-LOCK OF planilha_vendor NO-ERROR.
            IF AVAIL dupl_vendor THEN DO:
                FIND FIRST tit_acr NO-LOCK
                    WHERE tit_acr.cod_estab       = dupl_vendor.cod_estab_tit_acr
                      AND tit_acr.num_id_tit_acr  = dupl_vendor.num_id_tit_acr NO-ERROR.
                 IF AVAIL tit_acr THEN
                     ASSIGN tt-saldo.nr_duplic   = tt-saldo.cod_tit_acr
                            tt-saldo.cod_tit_acr = tit_acr.cod_tit_acr.
             END.
             ELSE
                 ASSIGN tt-saldo.cod_tit_acr = "".
         END.
         ELSE DO:
            /* Vers∆o 1.00.00.004 - Mario Fleith Jr.*/

            RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                     INPUT  TODAY,
                                     INPUT  tit_acr.val_sdo_tit_acr,
                                     OUTPUT d-valor).
            
            ASSIGN tt-saldo.num_planinha_vendor = 0                  
                   tt-saldo.cod_tit_acr         = tit_acr.cod_tit_acr
                   tt-saldo.val_sdo_tit_acr     = d-valor.
            FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
            IF AVAIL movto_tit_acr THEN DO:
               FIND FIRST histor_movto_tit_acr NO-LOCK
                  WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                  AND   histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                  AND   histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
               IF AVAIL histor_movto_tit_acr THEN DO:

                  RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                           INPUT  TODAY,
                                           INPUT  tit_acr.val_sdo_tit_acr,
                                           OUTPUT d-valor).

                  ASSIGN tt-saldo.val_sdo_tit_acr     = d-valor
                         tt-saldo.val_origin_tit_acr  = DEC(entry(1,histor_movto_tit_acr.des_text_histor,';')). 
               END.
               ELSE
                  ASSIGN tt-saldo.val_origin_tit_acr  = 0.
            END.
            ELSE 
               ASSIGN tt-saldo.val_origin_tit_acr = 0.

         END.
     END.
  END.

  /** Rotina para Buscar DP-Original de Vendor Debitado **/
  FIND FIRST tit_acr NO-LOCK
      WHERE tit_acr.cod_estab          = tt-saldo.cod_estab
        AND tit_acr.cod_espec_docto    = "VD"
        AND tit_acr.cod_ser_docto      = tt-saldo.cod_ser_docto
        AND tit_acr.cod_tit_acr        = tt-saldo.cod_tit_acr
        AND tit_acr.cod_parcela        = tt-saldo.cod_parcela
        AND tt-saldo.cod_espec_docto     <> "AC" NO-ERROR.
  IF AVAIL tit_acr THEN DO:
     FIND FIRST b_tit_acr_VE NO-LOCK
         WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
           AND b_tit_acr_VE.cod_espec_docto = "VE"
           AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
           AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
           AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
     IF AVAIL b_tit_acr_VE THEN DO:
         IF tit_acr.dat_vencto_tit_acr = tit_acr.dat_emis_docto THEN
             ASSIGN tt-saldo.dat_vencto_tit_acr = b_tit_acr_VE.dat_vencto_tit_acr.

         /* Dias de atraso */
         ASSIGN tt-saldo.num_atr = TODAY - b_tit_acr_VE.dat_vencto_tit_acr.

          /* localiza parcela para buscar o valor do cliente */
         FIND FIRST parc_vendor NO-LOCK
             WHERE parc_vendor.cod_estab_tit_acr = b_tit_acr_VE.cod_estab
               AND parc_vendor.num_id_tit_acr    = b_tit_acr_VE.num_id_tit_acr NO-ERROR.

         FIND FIRST planilha_vendor NO-LOCK
             WHERE planilha_vendor.cod_estab           = b_tit_acr_VE.cod_estab
               AND planilha_vendor.num_planilha_vendor = INT(b_tit_acr_VE.cod_tit_acr) NO-ERROR.
         IF AVAIL planilha_vendor THEN DO:
             FIND FIRST dupl_vendor NO-LOCK OF planilha_vendor NO-ERROR.
             IF AVAIL dupl_vendor THEN DO:
                 FIND FIRST b_tit_acr_DM NO-LOCK
                     WHERE b_tit_acr_DM.cod_estab      = dupl_vendor.cod_estab_tit_acr
                       AND b_tit_acr_DM.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                 IF AVAIL b_tit_acr_DM THEN DO:

                     RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                              INPUT  TODAY,
                                              INPUT  parc_vendor.val_parc_vendor_clien,
                                              OUTPUT d-valor).

                     ASSIGN tt-saldo.cod_tit_acr        = b_tit_acr_DM.cod_tit_acr
                            tt-saldo.val_sdo_tit_acr    = d-valor.
                 END.
             END.
         END.
     END.
  END.
END. /******* FOR EACH tt-saldo *********/    

FOR EACH tt-saldo:

    /*IF tt-saldo.ind_tip_espec_docto = "Normal" THEN */
       ASSIGN d-saldo   = d-saldo  + tt-saldo.val_origin_tit_acr  /*Acumula total Original*/
              d-saldoc  = d-saldoc + tt-saldo.val_sdo_tit_acr.    /*Acumula total Cliente*/
    /*
    ELSE
       ASSIGN d-credito = d-credito + tt-saldo.val_origin_tit_acr /*acumula credito */. */

END.      



