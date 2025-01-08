DEF TEMP-TABLE tt_movto NO-UNDO 
    FIELD tta_tip_documento                 AS CHARACTER 
    FIELD tta_tip_pagto                     AS CHARACTER
    FIELD tta_cod_estab                     AS CHARACTER
    FIELD tta_cdn_fornec                    AS INT
    FIELD tta_cod_espec                     AS CHARACTER
    FIELD tta_cod_ser                       AS CHARACTER
    FIELD tta_cod_tit_ap                    AS CHARACTER
    FIELD tta_cod_parcela                   AS CHARACTER
    FIELD tta_cod_cta_ctbl                  AS CHARACTER
    FIELD tta_cod_ccusto                    AS CHARACTER
    FIELD tta_cod_bco_pagto                 AS CHARACTER
    FIELD tta_cod_agenc_bcia_pagto          AS CHARACTER
    FIELD tta_cod_digito_agenc_bcia_pagto   AS CHARACTER
    FIELD tta_cod_cta_corren_bco_pagto      AS CHARACTER
    FIELD tta_cod_digito_cta_corren_pagto   AS CHARACTER
    FIELD tta_dat_pagto                     AS DATE 
    FIELD tta_ind_modo_pagto                AS CHARACTER
    FIELD tta_cod_portador                  AS CHARACTER
    FIELD tta_num_bord_ap                   AS INT
    FIELD tta_num_cheque                    AS INT
    FIELD tta_val_aprop_ctbl                AS DEC
    FIELD tta_log_contra_an                 AS LOG
    FIELD tta_num_id_movto                  AS INT
    FIELD tta_des_histor                    AS CHAR
    FIELD tta_nom_pessoa                    AS CHAR
    INDEX tt_codigo                      
          tta_cod_estab                  ASCENDING 
          tta_cdn_fornec                 ASCENDING 
          tta_cod_espec                  ASCENDING
          tta_cod_ser                    ASCENDING
          tta_cod_tit_ap                 ASCENDING
          tta_cod_parcela                ASCENDING
          tta_tip_pagto                  ASCENDING 
          tta_tip_documento              ASCENDING 
          tta_num_id_movto               ASCENDING.

DEF INPUT PARAMETER p_serie_docto  LIKE dupli-apagar.serie-docto  NO-UNDO.
DEF INPUT PARAMETER p_nro_docto    LIKE dupli-apagar.nro-docto    NO-UNDO. 
DEF INPUT PARAMETER p_cod_emitente LIKE dupli-apagar.cod-emitente NO-UNDO.
DEF INPUT PARAMETER p_nat_operacao LIKE dupli-apagar.nat-operacao NO-UNDO.
DEF INPUT PARAMETER p_opcao          AS INT  NO-UNDO.
DEF INPUT PARAMETER p_dat_ini        AS DATE NO-UNDO.
DEF INPUT PARAMETER p_dat_fim        AS DATE NO-UNDO.
DEF INPUT PARAMETER p_estab_ini      AS CHAR NO-UNDO.
DEF INPUT PARAMETER p_estab_fim      AS CHAR NO-UNDO.
DEF INPUT PARAMETER p_num_col        AS INT NO-UNDO.

DEF VAR v_cod_tit_ap              LIKE tit_ap.cod_tit_ap.
DEF VAR v_des_histor              AS CHAR.
DEF VAR v_nom_pessoa              AS CHAR.
DEF VAR v_val_aprop_ctbl_ap_apres AS DEC.
DEF VAR v_log_first               AS LOG.

DEF BUFFER b-docum-est        FOR docum-est.
DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.
DEF BUFFER b_movto_tit_ap_an  FOR movto_tit_ap.
DEF BUFFER b_movto_tit_ap_im  FOR movto_tit_ap.
DEF BUFFER b_tit_ap_an        FOR tit_ap.
DEF BUFFER b_aprop_ctbl_ap_apres     FOR aprop_ctbl_ap.
DEF BUFFER b_val_aprop_ctbl_ap_apres FOR val_aprop_ctbl_ap.

IF p_opcao = 1 /* Lanáado no recebimento */
THEN DO:

     FIND b-docum-est NO-LOCK 
         WHERE b-docum-est.serie-docto  = p_serie_docto 
           AND b-docum-est.nro-docto    = p_nro_docto   
           AND b-docum-est.cod-emitente = p_cod_emitente
           AND b-docum-est.nat-operacao = p_nat_operacao NO-ERROR.
     IF NOT AVAIL b-docum-est 
     THEN DO: 
         PUT "ERRO: n∆o foi poss°vel localizar a docum-est" SKIP.
          RETURN.
     END.

     IF substring(b-docum-est.char-1,1,12) <> "" 
        THEN ASSIGN v_cod_tit_ap = substring(b-docum-est.char-1,1,12).
        ELSE ASSIGN v_cod_tit_ap = b-docum-est.nro-docto.

      ASSIGN v_log_first = YES.
      FOR EACH dupli-apagar NO-LOCK
          WHERE dupli-apagar.serie-docto  = p_serie_docto 
            AND dupli-apagar.nro-docto    = p_nro_docto   
            AND dupli-apagar.cod-emitente = p_cod_emitente
            AND dupli-apagar.nat-operacao = p_nat_operacao:
          FIND tit_ap NO-LOCK
              WHERE tit_ap.cod_estab   = dupli-apagar.cod-estabel
                AND tit_ap.cdn_fornec  = dupli-apagar.cod-emitente
                AND tit_ap.cod_espec   = dupli-apagar.cod-esp
                AND tit_ap.cod_ser     = dupli-apagar.serie  
                AND tit_ap.cod_tit_ap  = v_cod_tit_ap
                AND tit_ap.cod_parcela = dupli-apagar.parcela NO-ERROR.
          IF NOT AVAIL tit_ap 
          THEN DO:
               PUT "ERRO: n∆o foi poss°vel localizar o t°tulo no contas a pagar " dupli-apagar.cod-estabel " " dupli-apagar.cod-emitente " " dupli-apagar.cod-esp " "
                    dupli-apagar.serie " " v_cod_tit_ap " " dupli-apagar.parcela SKIP.
               NEXT.
          END.
    
          FOR EACH movto_tit_ap OF tit_ap NO-LOCK:

              IF movto_tit_ap.log_movto_estordo = YES 
                 THEN NEXT.

              /* Localiza pagamentos */
              FIND compl_movto_pagto OF movto_tit_ap NO-LOCK NO-ERROR.
              IF AVAIL compl_movto_pagto 
              THEN DO:

                   FIND FIRST histor_tit_movto_ap NO-LOCK 
                        WHERE histor_tit_movto_ap.cod_estab            = movto_tit_ap.cod_estab
                          AND histor_tit_movto_ap.num_id_movto_tit_ap  = movto_tit_ap.num_id_movto_tit_ap
                          AND histor_tit_movto_ap.num_id_tit_ap        = movto_tit_ap.num_id_tit_ap
                          AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

                   ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                            THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                            ELSE "". 
                   
                   IF v_log_first = NO 
                      THEN PUT UNFORMATTED FILL(";", p_num_col).

                   ASSIGN v_val_aprop_ctbl_ap_apres = 0.

                   FOR EACH b_aprop_ctbl_ap_apres NO-LOCK
                       WHERE b_aprop_ctbl_ap_apres.cod_estab           = movto_tit_ap.cod_estab
                         AND b_aprop_ctbl_ap_apres.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                         AND b_aprop_ctbl_ap_apres.ind_natur_lancto    = "DB":

                        FIND b_val_aprop_ctbl_ap_apres NO-LOCK
                            WHERE b_val_aprop_ctbl_ap_apres.cod_estab            = b_aprop_ctbl_ap_apres.cod_estab
                              AND b_val_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap = b_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap
                              AND b_val_aprop_ctbl_ap_apres.cod_finalid_econ     = "Corrente" NO-ERROR.
                        IF NOT AVAIL b_val_aprop_ctbl_ap_apres
                        THEN DO:
                             PUT FILL(";", p_num_col)
                                 "ERRO: n∆o foi poss°vel localizar o valor da apropriaá∆o" SKIP.
                             NEXT.
                        END.

                        ASSIGN v_val_aprop_ctbl_ap_apres = v_val_aprop_ctbl_ap_apres + b_val_aprop_ctbl_ap_apres.val_aprop_ctbl.

                   END.

                   PUT UNFORMATTED    ";Pagamento Origem Recebimento;"             
                                      tit_ap.cod_estab                              ";"
                                      tit_ap.cdn_fornec                             ";"
                                      tit_ap.cod_espec                              ";"
                                      tit_ap.cod_ser                                ";"
                                      tit_ap.cod_tit_ap                             ";"
                                      tit_ap.cod_parcela                            ";;;;"
                                      compl_movto_pagto.cod_bco_pagto               ";"
                                      compl_movto_pagto.cod_agenc_bcia_pagto        ";" 
                                      compl_movto_pagto.cod_digito_agenc_bcia_pagto ";" 
                                      compl_movto_pagto.cod_cta_corren_bco_pagto    ";" 
                                      compl_movto_pagto.cod_digito_cta_corren_pagto ";" 
                                      compl_movto_pagto.dat_pagto                   ";"
                                      compl_movto_pagto.ind_modo_pagto              ";" 
                                      compl_movto_pagto.cod_portador                ";" 
                                      compl_movto_pagto.num_bord_ap                 ";" 
                                      compl_movto_pagto.num_cheque                  ";" 
                                      v_val_aprop_ctbl_ap_apres                     ";"
                                      "no"                                          ";"
                                      v_des_histor SKIP.

                   ASSIGN v_log_first = NO.

              END.

              /* Localiza Antecipaá‰es */
              IF movto_tit_ap.log_bxa_contra_antecip = YES
              THEN DO:

                   FOR EACH b_movto_tit_ap_an NO-LOCK 
                      WHERE b_movto_tit_ap_an.cod_estab_tit_ap_pai    = movto_tit_ap.cod_estab
                        AND b_movto_tit_ap_an.num_id_movto_tit_ap_pai = movto_tit_ap.num_id_movto_tit_ap:
                      FIND b_tit_ap_an OF b_movto_tit_ap_an NO-LOCK NO-ERROR.
                      FIND b_movto_tit_ap_im OF b_tit_ap_an NO-LOCK
                          WHERE b_movto_tit_ap_im.ind_trans_ap_abrev = "IMPL" NO-ERROR.
                      FIND compl_movto_pagto OF b_movto_tit_ap_im NO-LOCK NO-ERROR.
                      IF AVAIL compl_movto_pagto 
                      THEN DO:

                           FIND FIRST histor_tit_movto_ap NO-LOCK 
                                WHERE histor_tit_movto_ap.cod_estab            = movto_tit_ap.cod_estab
                                  AND histor_tit_movto_ap.num_id_movto_tit_ap  = movto_tit_ap.num_id_movto_tit_ap
                                  AND histor_tit_movto_ap.num_id_tit_ap        = movto_tit_ap.num_id_tit_ap
                                  AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

                           ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                                    THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                                    ELSE "". 

                           IF v_log_first = NO 
                              THEN PUT UNFORMATTED FILL(";", p_num_col).


                           ASSIGN v_val_aprop_ctbl_ap_apres = 0.

                           FOR EACH b_aprop_ctbl_ap_apres NO-LOCK
                               WHERE b_aprop_ctbl_ap_apres.cod_estab           = movto_tit_ap.cod_estab
                                 AND b_aprop_ctbl_ap_apres.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                                 AND b_aprop_ctbl_ap_apres.ind_natur_lancto    = "DB":

                                FIND b_val_aprop_ctbl_ap_apres NO-LOCK
                                    WHERE b_val_aprop_ctbl_ap_apres.cod_estab            = b_aprop_ctbl_ap_apres.cod_estab
                                      AND b_val_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap = b_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap
                                      AND b_val_aprop_ctbl_ap_apres.cod_finalid_econ     = "Corrente" NO-ERROR.
                                IF NOT AVAIL b_val_aprop_ctbl_ap_apres
                                THEN DO:
                                     PUT FILL(";", p_num_col)
                                         "ERRO: n∆o foi poss°vel localizar o valor da apropriaá∆o" SKIP.
                                     NEXT.
                                END.

                                ASSIGN v_val_aprop_ctbl_ap_apres = v_val_aprop_ctbl_ap_apres + b_val_aprop_ctbl_ap_apres.val_aprop_ctbl.

                           END.

                           PUT UNFORMATTED   ";Pagamento Origem Recebimento;"      
                                              tit_ap.cod_estab                              ";"
                                              tit_ap.cdn_fornec                             ";"
                                              tit_ap.cod_espec                              ";"
                                              tit_ap.cod_ser                                ";"
                                              tit_ap.cod_tit_ap                             ";"
                                              tit_ap.cod_parcela                            ";;;;"
                                              compl_movto_pagto.cod_bco_pagto               ";"
                                              compl_movto_pagto.cod_agenc_bcia_pagto        ";" 
                                              compl_movto_pagto.cod_digito_agenc_bcia_pagto ";" 
                                              compl_movto_pagto.cod_cta_corren_bco_pagto    ";" 
                                              compl_movto_pagto.cod_digito_cta_corren_pagto ";" 
                                              compl_movto_pagto.dat_pagto                   ";"
                                              compl_movto_pagto.ind_modo_pagto              ";" 
                                              compl_movto_pagto.cod_portador                ";" 
                                              compl_movto_pagto.num_bord_ap                 ";" 
                                              compl_movto_pagto.num_cheque                  ";" 
                                              v_val_aprop_ctbl_ap_apres                     ";"
                                              "yes"                                         ";"
                                              v_des_histor SKIP.

                           ASSIGN v_log_first = NO.

                      END.

                   END.

              END.

          END.

     END.

END.
ELSE DO: /* Lanáado no contas a pagar */

     FOR EACH estabelecimento NO-LOCK
         WHERE estabelecimento.cod_estab >= p_estab_ini
           AND estabelecimento.cod_estab <= p_estab_fim:

         FOR EACH aprop_ctbl_ap NO-LOCK
             WHERE aprop_ctbl_ap.cod_estab           = estabelecimento.cod_estab
               AND aprop_ctbl_ap.cod_plano_cta_ctbl  = 'Padrao'
               AND aprop_ctbl_ap.cod_cta_ctbl       >= "40000000"
               AND aprop_ctbl_ap.cod_cta_ctbl       <= "49999999"
               AND aprop_ctbl_ap.dat_transacao      >= p_dat_ini
               AND aprop_ctbl_ap.dat_transacao      <= p_dat_fim:

             IF aprop_ctbl_ap.cod_cta_ctbl = "41110005" 
                THEN NEXT.

             FIND movto_tit_ap OF aprop_ctbl_ap NO-LOCK NO-ERROR.
             IF NOT AVAIL movto_tit_ap 
                THEN NEXT.

             IF movto_tit_ap.log_movto_estordo  = YES 
             OR movto_tit_ap.ind_trans_ap_abrev = "PECR"
             OR movto_tit_ap.ind_trans_ap_abrev = "EPEF"
             OR movto_tit_ap.ind_trans_ap_abrev = "PFCC"
             OR movto_tit_ap.ind_trans_ap BEGINS "Estorno"
                THEN NEXT.

             FIND val_aprop_ctbl_ap NO-LOCK
                 WHERE val_aprop_ctbl_ap.cod_estab            = aprop_ctbl_ap.cod_estab
                   AND val_aprop_ctbl_ap.num_id_aprop_ctbl_ap = aprop_ctbl_ap.num_id_aprop_ctbl_ap
                   AND val_aprop_ctbl_ap.cod_finalid_econ     = "Corrente" NO-ERROR.
             IF NOT AVAIL val_aprop_ctbl_ap
             THEN DO:
                 PUT FILL(";", p_num_col)
                     "ERRO: n∆o foi poss°vel localizar o valor da apropriaá∆o" SKIP.
                  NEXT.
             END.

             IF movto_tit_ap.ind_trans_ap_abrev = "PGEF" 
             THEN DO:

                  FIND compl_movto_pagto OF movto_tit_ap NO-LOCK NO-ERROR.
                  IF NOT AVAIL compl_movto_pagto 
                  THEN DO:
                      PUT FILL(";", p_num_col)
                          "ERRO: n∆o foi poss°vel localizar o complemento do PEF" SKIP.
                       NEXT.
                  END.

                  FIND FIRST histor_tit_movto_ap NO-LOCK 
                       WHERE histor_tit_movto_ap.cod_estab            = movto_tit_ap.cod_estab
                         AND histor_tit_movto_ap.num_id_movto_tit_ap  = movto_tit_ap.num_id_movto_tit_ap
                         AND histor_tit_movto_ap.num_id_tit_ap        = movto_tit_ap.num_id_tit_ap
                         AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

                  ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                           THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                           ELSE "". 

                  CREATE tt_movto.
                  ASSIGN tt_movto.tta_tip_documento               = ""
                         tt_movto.tta_tip_pagto                   = "Pagamento " + movto_tit_ap.ind_trans_ap_abrev
                         tt_movto.tta_cod_estab                   = ""
                         tt_movto.tta_cdn_fornec                  = 0
                         tt_movto.tta_cod_espec                   = ""
                         tt_movto.tta_cod_ser                     = ""
                         tt_movto.tta_cod_tit_ap                  = ""
                         tt_movto.tta_cod_parcela                 = ""
                         tt_movto.tta_cod_cta_ctbl                = aprop_ctbl_ap.cod_cta_ctbl                   
                         tt_movto.tta_cod_ccusto                  = aprop_ctbl_ap.cod_ccusto                     
                         tt_movto.tta_cod_bco_pagto               = compl_movto_pagto.cod_bco_pagto              
                         tt_movto.tta_cod_agenc_bcia_pagto        = compl_movto_pagto.cod_agenc_bcia_pagto       
                         tt_movto.tta_cod_digito_agenc_bcia_pagto = compl_movto_pagto.cod_digito_agenc_bcia_pagto
                         tt_movto.tta_cod_cta_corren_bco_pagto    = compl_movto_pagto.cod_cta_corren_bco_pagto   
                         tt_movto.tta_cod_digito_cta_corren_pagto = compl_movto_pagto.cod_digito_cta_corren_pagto
                         tt_movto.tta_dat_pagto                   = compl_movto_pagto.dat_pagto                  
                         tt_movto.tta_ind_modo_pagto              = compl_movto_pagto.ind_modo_pagto             
                         tt_movto.tta_cod_portador                = compl_movto_pagto.cod_portador               
                         tt_movto.tta_num_bord_ap                 = compl_movto_pagto.num_bord_ap                
                         tt_movto.tta_num_cheque                  = compl_movto_pagto.num_cheque                 
                         tt_movto.tta_val_aprop_ctbl              = val_aprop_ctbl_ap.val_aprop_ctbl
                         tt_movto.tta_log_contra_an               = NO
                         tt_movto.tta_des_histor                  = v_des_histor.

                  NEXT. /* n∆o localiza o t°tulo abaixo */

             END.

             FIND tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
             IF NOT AVAIL tit_ap 
             THEN DO:
                  PUT FILL(";", p_num_col)
                           "ERRO: n∆o foi poss°vel localizar o t°tulo para o movimento de " movto_tit_ap.ind_trans_ap_abrev SKIP.
                  NEXT.
             END.
            
             IF tit_ap.cod_espec = "VP"
             OR tit_ap.cod_espec = "PP" 
             OR tit_ap.cod_espec = "VA" 
                THEN NEXT.

             IF tit_ap.num_pessoa MOD 2 <> 0
             THEN DO:
                  FIND pessoa_jurid NO-LOCK
                      WHERE pessoa_jurid.num_pessoa_jurid = tit_ap.num_pessoa NO-ERROR.
                  ASSIGN v_nom_pessoa = pessoa_jurid.nom_pessoa.
             END.
             ELSE DO:
                  FIND pessoa_fisic NO-LOCK
                      WHERE pessoa_fisic.num_pessoa_fisic = tit_ap.num_pessoa NO-ERROR.
                  ASSIGN v_nom_pessoa = pessoa_fisic.nom_pessoa.
             END.

             FIND FIRST histor_tit_movto_ap NO-LOCK 
                  WHERE histor_tit_movto_ap.cod_estab            = movto_tit_ap.cod_estab
                    AND histor_tit_movto_ap.num_id_movto_tit_ap  = movto_tit_ap.num_id_movto_tit_ap
                    AND histor_tit_movto_ap.num_id_tit_ap        = movto_tit_ap.num_id_tit_ap
                    AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

             ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                      THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                      ELSE "".

             CREATE tt_movto.
             ASSIGN tt_movto.tta_tip_documento               = "Implantaá∆o Contas a Pagar"
                    tt_movto.tta_tip_pagto                   = ""
                    tt_movto.tta_cod_estab                   = tit_ap.cod_estab  
                    tt_movto.tta_cdn_fornec                  = tit_ap.cdn_fornec 
                    tt_movto.tta_cod_espec                   = tit_ap.cod_espec  
                    tt_movto.tta_cod_ser                     = tit_ap.cod_ser    
                    tt_movto.tta_cod_tit_ap                  = tit_ap.cod_tit_ap 
                    tt_movto.tta_cod_parcela                 = tit_ap.cod_parcela
                    tt_movto.tta_dat_pagto                   = tit_ap.dat_transacao
                    tt_movto.tta_val_aprop_ctbl              = val_aprop_ctbl_ap.val_aprop_ctbl                    
                    tt_movto.tta_cod_cta_ctbl                = aprop_ctbl_ap.cod_cta_ctbl                   
                    tt_movto.tta_cod_ccusto                  = aprop_ctbl_ap.cod_ccusto
                    tt_movto.tta_des_histor                  = v_des_histor
                    tt_movto.tta_nom_pessoa                  = v_nom_pessoa.

             FOR EACH b_movto_tit_ap OF tit_ap NO-LOCK:

                 FIND FIRST tt_movto NO-LOCK
                      WHERE tt_movto.tta_tip_documento = ""
                        AND tt_movto.tta_tip_pagto     = "Pagamento " + b_movto_tit_ap.ind_trans_ap_abrev
                        AND tt_movto.tta_cod_estab     = tit_ap.cod_estab  
                        AND tt_movto.tta_cdn_fornec    = tit_ap.cdn_fornec 
                        AND tt_movto.tta_cod_espec     = tit_ap.cod_espec  
                        AND tt_movto.tta_cod_ser       = tit_ap.cod_ser    
                        AND tt_movto.tta_cod_tit_ap    = tit_ap.cod_tit_ap 
                        AND tt_movto.tta_cod_parcela   = tit_ap.cod_parcela 
                        AND tt_movto.tta_num_id_movto  = b_movto_tit_ap.num_id_movto_tit_ap NO-ERROR.
                 IF AVAIL tt_movto 
                    THEN NEXT. /* j† foi criado em outro rateio do mesmo movimento */

                 IF b_movto_tit_ap.log_movto_estordo = YES 
                    THEN NEXT.

                 FIND compl_movto_pagto OF b_movto_tit_ap NO-LOCK NO-ERROR.
                 IF AVAIL compl_movto_pagto 
                 THEN DO: 
                      
                     FIND FIRST histor_tit_movto_ap NO-LOCK 
                          WHERE histor_tit_movto_ap.cod_estab            = b_movto_tit_ap.cod_estab
                            AND histor_tit_movto_ap.num_id_movto_tit_ap  = b_movto_tit_ap.num_id_movto_tit_ap
                            AND histor_tit_movto_ap.num_id_tit_ap        = b_movto_tit_ap.num_id_tit_ap
                            AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

                     ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                              THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                              ELSE "". 

                     ASSIGN v_val_aprop_ctbl_ap_apres = 0.

                     FOR EACH b_aprop_ctbl_ap_apres NO-LOCK
                         WHERE b_aprop_ctbl_ap_apres.cod_estab           = b_movto_tit_ap.cod_estab
                           AND b_aprop_ctbl_ap_apres.num_id_movto_tit_ap = b_movto_tit_ap.num_id_movto_tit_ap
                           AND b_aprop_ctbl_ap_apres.ind_natur_lancto    = "DB":

                          FIND b_val_aprop_ctbl_ap_apres NO-LOCK
                              WHERE b_val_aprop_ctbl_ap_apres.cod_estab            = b_aprop_ctbl_ap_apres.cod_estab
                                AND b_val_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap = b_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap
                                AND b_val_aprop_ctbl_ap_apres.cod_finalid_econ     = "Corrente" NO-ERROR.
                          IF NOT AVAIL b_val_aprop_ctbl_ap_apres
                          THEN DO:
                               PUT FILL(";", p_num_col)
                                   "ERRO: n∆o foi poss°vel localizar o valor da apropriaá∆o" SKIP.
                               NEXT.
                          END.

                          ASSIGN v_val_aprop_ctbl_ap_apres = v_val_aprop_ctbl_ap_apres + b_val_aprop_ctbl_ap_apres.val_aprop_ctbl.

                     END.


                     CREATE tt_movto.
                     ASSIGN tt_movto.tta_tip_documento               = ""
                            tt_movto.tta_tip_pagto                   = "Pagamento " + b_movto_tit_ap.ind_trans_ap_abrev
                            tt_movto.tta_cod_estab                   = tit_ap.cod_estab  
                            tt_movto.tta_cdn_fornec                  = tit_ap.cdn_fornec 
                            tt_movto.tta_cod_espec                   = tit_ap.cod_espec  
                            tt_movto.tta_cod_ser                     = tit_ap.cod_ser    
                            tt_movto.tta_cod_tit_ap                  = tit_ap.cod_tit_ap 
                            tt_movto.tta_cod_parcela                 = tit_ap.cod_parcela
                            tt_movto.tta_cod_cta_ctbl                = ""
                            tt_movto.tta_cod_ccusto                  = ""
                            tt_movto.tta_cod_bco_pagto               = compl_movto_pagto.cod_bco_pagto              
                            tt_movto.tta_cod_agenc_bcia_pagto        = compl_movto_pagto.cod_agenc_bcia_pagto       
                            tt_movto.tta_cod_digito_agenc_bcia_pagto = compl_movto_pagto.cod_digito_agenc_bcia_pagto
                            tt_movto.tta_cod_cta_corren_bco_pagto    = compl_movto_pagto.cod_cta_corren_bco_pagto   
                            tt_movto.tta_cod_digito_cta_corren_pagto = compl_movto_pagto.cod_digito_cta_corren_pagto
                            tt_movto.tta_dat_pagto                   = compl_movto_pagto.dat_pagto                  
                            tt_movto.tta_ind_modo_pagto              = compl_movto_pagto.ind_modo_pagto             
                            tt_movto.tta_cod_portador                = compl_movto_pagto.cod_portador               
                            tt_movto.tta_num_bord_ap                 = compl_movto_pagto.num_bord_ap                
                            tt_movto.tta_num_cheque                  = compl_movto_pagto.num_cheque                 
                            tt_movto.tta_val_aprop_ctbl              = v_val_aprop_ctbl_ap_apres
                            tt_movto.tta_log_contra_an               = NO
                            tt_movto.tta_num_id_movto                = b_movto_tit_ap.num_id_movto_tit_ap
                            tt_movto.tta_des_histor                  = v_des_histor
                            tt_movto.tta_nom_pessoa                  = v_nom_pessoa.

                      NEXT.

                 END.
             
                 /* Localiza Antecipaá‰es */
                 IF b_movto_tit_ap.log_bxa_contra_antecip = YES
                 THEN DO:

                      FOR EACH b_movto_tit_ap_an NO-LOCK 
                         WHERE b_movto_tit_ap_an.cod_estab_tit_ap_pai    = b_movto_tit_ap.cod_estab
                           AND b_movto_tit_ap_an.num_id_movto_tit_ap_pai = b_movto_tit_ap.num_id_movto_tit_ap:
                         FIND b_tit_ap_an OF b_movto_tit_ap_an NO-LOCK NO-ERROR.
                         FIND b_movto_tit_ap_im OF b_tit_ap_an NO-LOCK
                             WHERE b_movto_tit_ap_im.ind_trans_ap_abrev = "IMPL" NO-ERROR.
                         FIND compl_movto_pagto OF b_movto_tit_ap_im NO-LOCK NO-ERROR.
                         IF AVAIL compl_movto_pagto 
                         THEN DO:

                              FIND FIRST tt_movto NO-LOCK
                                   WHERE tt_movto.tta_tip_documento = ""
                                     AND tt_movto.tta_tip_pagto     = "Pagamento " + b_movto_tit_ap.ind_trans_ap_abrev
                                     AND tt_movto.tta_cod_estab     = tit_ap.cod_estab  
                                     AND tt_movto.tta_cdn_fornec    = tit_ap.cdn_fornec 
                                     AND tt_movto.tta_cod_espec     = tit_ap.cod_espec  
                                     AND tt_movto.tta_cod_ser       = tit_ap.cod_ser    
                                     AND tt_movto.tta_cod_tit_ap    = tit_ap.cod_tit_ap 
                                     AND tt_movto.tta_cod_parcela   = tit_ap.cod_parcela 
                                     AND tt_movto.tta_num_id_movto  = b_movto_tit_ap_im.num_id_movto_tit_ap NO-ERROR.
                              IF AVAIL tt_movto 
                                 THEN NEXT. /* j† foi criado em outro rateio do mesmo movimento */

                              FIND FIRST histor_tit_movto_ap NO-LOCK 
                                   WHERE histor_tit_movto_ap.cod_estab            = b_movto_tit_ap.cod_estab
                                     AND histor_tit_movto_ap.num_id_movto_tit_ap  = b_movto_tit_ap.num_id_movto_tit_ap
                                     AND histor_tit_movto_ap.num_id_tit_ap        = b_movto_tit_ap.num_id_tit_ap
                                     AND histor_tit_movto_ap.ind_orig_histor_ap  <> "Erro" NO-ERROR.

                              ASSIGN v_des_histor = IF AVAIL histor_tit_movto_ap 
                                                       THEN REPLACE(histor_tit_movto_ap.des_text_histor , CHR(10), " ")
                                                       ELSE "". 

                              ASSIGN v_val_aprop_ctbl_ap_apres = 0.

                              FOR EACH b_aprop_ctbl_ap_apres NO-LOCK
                                 WHERE b_aprop_ctbl_ap_apres.cod_estab           = b_movto_tit_ap.cod_estab
                                   AND b_aprop_ctbl_ap_apres.num_id_movto_tit_ap = b_movto_tit_ap.num_id_movto_tit_ap
                                   AND b_aprop_ctbl_ap_apres.ind_natur_lancto    = "DB":

                                  FIND b_val_aprop_ctbl_ap_apres NO-LOCK
                                      WHERE b_val_aprop_ctbl_ap_apres.cod_estab            = b_aprop_ctbl_ap_apres.cod_estab
                                        AND b_val_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap = b_aprop_ctbl_ap_apres.num_id_aprop_ctbl_ap
                                        AND b_val_aprop_ctbl_ap_apres.cod_finalid_econ     = "Corrente" NO-ERROR.
                                  IF NOT AVAIL b_val_aprop_ctbl_ap_apres
                                  THEN DO:
                                       PUT FILL(";", p_num_col)
                                           "ERRO: n∆o foi poss°vel localizar o valor da apropriaá∆o" SKIP.
                                       NEXT.
                                  END.

                                  ASSIGN v_val_aprop_ctbl_ap_apres = v_val_aprop_ctbl_ap_apres + b_val_aprop_ctbl_ap_apres.val_aprop_ctbl.

                              END.

                              CREATE tt_movto.
                              ASSIGN tt_movto.tta_tip_documento               = ""
                                     tt_movto.tta_tip_pagto                   = "Pagamento " + b_movto_tit_ap.ind_trans_ap_abrev
                                     tt_movto.tta_cod_estab                   = tit_ap.cod_estab  
                                     tt_movto.tta_cdn_fornec                  = tit_ap.cdn_fornec 
                                     tt_movto.tta_cod_espec                   = tit_ap.cod_espec  
                                     tt_movto.tta_cod_ser                     = tit_ap.cod_ser    
                                     tt_movto.tta_cod_tit_ap                  = tit_ap.cod_tit_ap 
                                     tt_movto.tta_cod_parcela                 = tit_ap.cod_parcela
                                     tt_movto.tta_cod_cta_ctbl                = ""
                                     tt_movto.tta_cod_ccusto                  = ""
                                     tt_movto.tta_cod_bco_pagto               = compl_movto_pagto.cod_bco_pagto              
                                     tt_movto.tta_cod_agenc_bcia_pagto        = compl_movto_pagto.cod_agenc_bcia_pagto       
                                     tt_movto.tta_cod_digito_agenc_bcia_pagto = compl_movto_pagto.cod_digito_agenc_bcia_pagto
                                     tt_movto.tta_cod_cta_corren_bco_pagto    = compl_movto_pagto.cod_cta_corren_bco_pagto   
                                     tt_movto.tta_cod_digito_cta_corren_pagto = compl_movto_pagto.cod_digito_cta_corren_pagto
                                     tt_movto.tta_dat_pagto                   = compl_movto_pagto.dat_pagto                  
                                     tt_movto.tta_ind_modo_pagto              = compl_movto_pagto.ind_modo_pagto             
                                     tt_movto.tta_cod_portador                = compl_movto_pagto.cod_portador               
                                     tt_movto.tta_num_bord_ap                 = compl_movto_pagto.num_bord_ap                
                                     tt_movto.tta_num_cheque                  = compl_movto_pagto.num_cheque                 
                                     tt_movto.tta_val_aprop_ctbl              = v_val_aprop_ctbl_ap_apres
                                     tt_movto.tta_log_contra_an               = YES
                                     tt_movto.tta_num_id_movto                = b_movto_tit_ap_im.num_id_movto_tit_ap
                                     tt_movto.tta_des_histor                  = v_des_histor
                                     tt_movto.tta_nom_pessoa                  = v_nom_pessoa.

                         END.
                      END.
                 END.
             END.
         END.
     END.

     FOR EACH tt_movto:

         ASSIGN tt_movto.tta_des_histor = REPLACE(tt_movto.tta_des_histor, CHR(10), " ").

         PUT UNFORMATTED FILL(";", p_num_col)
                         tt_movto.tta_tip_documento               ";"       
                         tt_movto.tta_tip_pagto                   ";"     
                         tt_movto.tta_cod_estab                   ";"   
                         tt_movto.tta_cdn_fornec                  ";"
                         tt_movto.tta_cod_espec                   ";"
                         tt_movto.tta_cod_ser                     ";"
                         tt_movto.tta_cod_tit_ap                  ";"
                         tt_movto.tta_cod_parcela                 ";"
                         tt_movto.tta_nom_pessoa                  ";"
                         tt_movto.tta_cod_cta_ctbl                ";"
                         tt_movto.tta_cod_ccusto                  ";"
                         tt_movto.tta_cod_bco_pagto               ";"
                         tt_movto.tta_cod_agenc_bcia_pagto        ";"
                         tt_movto.tta_cod_digito_agenc_bcia_pagto ";"
                         tt_movto.tta_cod_cta_corren_bco_pagto    ";"
                         tt_movto.tta_cod_digito_cta_corren_pagto ";"
                         tt_movto.tta_dat_pagto                   ";"
                         tt_movto.tta_ind_modo_pagto              ";"
                         tt_movto.tta_cod_portador                ";"
                         tt_movto.tta_num_bord_ap                 ";"
                         tt_movto.tta_num_cheque                  ";"
                         tt_movto.tta_val_aprop_ctbl              ";"
                         tt_movto.tta_log_contra_an               ";"
                         tt_movto.tta_des_histor SKIP.
     END.

END.
