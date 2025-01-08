/*****************************************************************************
** Programa..............: esp/essco005c.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 03/09/2009
*****************************************************************************/

/*************************** Temp-Table Definition Begin ********************/
DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD dat_transacao         LIKE tit_acr.dat_transacao
    FIELD dat_pedido            LIKE tit_acr.dat_transacao
    FIELD cod_adm_bco           AS CHAR
    FIELD cod_resumo            AS CHAR FORMAT "x(12)"
    FIELD cod_tip_reg           AS INT
    FIELD cod_nsu               AS CHAR
    FIELD num_ped_EMS           LIKE ped-venda.nr-pedido  
    FIELD num_ped_parceiro      LIKE ped-venda.nr-pedcli
    FIELD cdn_cliente_orig      LIKE tit_acr.cdn_cliente
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
    FIELD val_ped_vda           LIKE tit_acr.val_origin_tit_acr
    FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco
    FIELD des_status            AS CHAR
    FIELD ind_pedido            AS CHAR LABEL "Status Pedido"
    FIELD ind_nf                AS CHAR LABEL "Status NF"
  INDEX tt_concil
        cod_adm_bco             ASCENDING
        dat_transacao           ASCENDING
        cod_resumo              ASCENDING
        cod_tip_reg             ASCENDING
        cod_nsu                 ASCENDING
        num_ped_EMS             ASCENDING
  INDEX tt_ped
        num_ped_parceiro        ASCENDING.

/*************************** Temp-Table Definition Begin ********************/

/*************************** Query Definition Begin *************************/
DEF QUERY qr_tt_concil_adm
    FOR tt_concil
    SCROLLING.

/*************************** Query Definition End ***************************/

DEF BUFFER b_tit_acr          FOR tit_acr.
DEF BUFFER b_int_concil_b2    FOR int_concil_b2.

/************************** Browse Definition Begin *************************/
def browse br_tt_concil_adm query qr_tt_concil_adm display 
    tt_concil.cod_adm_bco        FORMAT "x(11)" COLUMN-LABEL "Adm"  
    tt_concil.dat_transacao      FORMAT "99/99/99" COLUMN-LABEL "Data"  
    tt_concil.cod_resumo         FORMAT "x(11)" COLUMN-LABEL "Resumo"  
    tt_concil.des_status         FORMAT "x(22)" COLUMN-LABEL "Status"
    tt_concil.cod_nsu            FORMAT "x(15)" COLUMN-LABEL "NSU / Autoriz"  
    tt_concil.num_ped_parceiro   COLUMN-LABEL "Ped Parc"
    tt_concil.dat_pedido         COLUMN-LABEL "Dt Pedido"
    tt_concil.val_ped_vda        COLUMN-LABEL "Vl Pedido"
    tt_concil.cdn_cliente_orig   COLUMN-LABEL "Cliente"  
    tt_concil.cod_tit_acr_bco    COLUMN-LABEL "Nr. Cart∆o"
    tt_concil.ind_pedido         COLUMN-LABEL "Status Pedido"
    tt_concil.ind_nf             COLUMN-LABEL "Status NF"
  with no-box separators 
         size 139 by 20
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************** Variable Definition Begin ***********************/

DEF VAR rs_opcao         AS CHARACTER INITIAL "Todos" VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "Todos", "Todos","VisaNet", "VisaNet","RedeCard", "RedeCard","HiperCard", "HiperCard" BGCOLOR 15 NO-UNDO.
DEF VAR v_log_method     AS LOGICAL            NO-UNDO.
DEF VAR v_dat_ini        AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.
DEF VAR v_dat_fim        AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.

DEF RECTANGLE rt_mold SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECTANGLE rt_cxcf SIZE 1 BY 1 FGCOLOR 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok LABEL "OK" TOOLTIP "OK" SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_can LABEL "Cancela" TOOLTIP "Cancela" SIZE 1 BY 1 AUTO-ENDKEY.

/*************************** Varable Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_import
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 8.75 col 02.00 bgcolor 7 
    rs_opcao
         at row 02.5 col 12 colon-aligned label "Extrato"
         help "Extrato"
         fgcolor ? bgcolor ? font 2
    v_dat_ini
         at row 06 col 12 colon-aligned label "Per°odo"
         help "Data Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_fim
         at row 06 col 27 colon-aligned label "AtÇ"
         help "Data Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 08.96 col 03.00 font ?
         help "OK"
    bt_can
         at row 08.96 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 48.14 by 10.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Contestaá‰es/Cancelamentos - B2x".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_import = 10.00
           bt_can:height-chars              in frame f_import = 01.00
           bt_ok:width-chars                in frame f_import = 10.00
           bt_ok:height-chars               in frame f_import = 01.00
           rt_cxcf:width-chars              in frame f_import = 44.72
           rt_cxcf:height-chars             in frame f_import = 01.42
           rt_mold:width-chars              in frame f_import = 44.72
           rt_mold:height-chars             in frame f_import = 07.17.

def frame f_comiss_det
    rt_cxcf
         at row 23.00 col 02.00 bgcolor 7 
    br_tt_concil_adm
         AT ROW 1.21 COL 2
    bt_ok
         at row 23.21 col 03.00 font ?
         help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 142 by 25 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Extrato B2x  - Detalhado".
/* adjust size of objects in this frame */
assign bt_ok:width-chars            in frame f_comiss_det = 10.00
       bt_ok:height-chars           in frame f_comiss_det = 01.00
       rt_cxcf:width-chars          in frame f_comiss_det = 139
       rt_cxcf:height-chars         in frame f_comiss_det = 01.42.

/*************************** Frame Definition End ***************************/

/*************************** Trigger Definition Begins **********************/


/*************************** Trigger Definition End *************************/

/************************** Main Code Begin *********************************/

VIEW FRAME f_import.

filter_block:
DO ON ERROR UNDO filter_block, RETRY filter_block
                 ON ENDKEY UNDO filter_block, LEAVE filter_block:

     DISPLAY bt_can
             bt_ok
             rs_opcao
             v_dat_ini
             v_dat_fim
             WITH FRAME f_import.

     ENABLE ALL WITH FRAME f_import.

     WAIT-FOR GO OF FRAME f_import.

     ASSIGN INPUT FRAME f_import rs_opcao v_dat_ini v_dat_fim.

     RUN pi_import.  

     HIDE FRAME f_import.

     VIEW FRAME f_comiss_det.

     concil_block:
     DO ON ERROR UNDO concil_block, RETRY concil_block
                      ON ENDKEY UNDO concil_block, LEAVE concil_block:

          ENABLE ALL WITH FRAME f_comiss_det.

          OPEN QUERY qr_tt_concil_adm
               FOR EACH tt_concil NO-LOCK.

          WAIT-FOR GO OF FRAME f_comiss_det.

     END.

     HIDE FRAME f_comiss_det.


END.

/************************** Main Code End ***********************************/

PROCEDURE pi_import:

    DEFINE VARIABLE v_tot_val_bruto   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_val_liquido AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE v_dat_aux      AS DATE        NO-UNDO.
    DEFINE VARIABLE v_cod_parc_aux AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_cv_nsu   AS CHARACTER   NO-UNDO.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

    FOR EACH tt_concil:
        DELETE tt_concil.
    END.

    ASSIGN v_tot_val_bruto       = 0
           v_tot_val_liquido     = 0.

    DO v_dat_aux = v_dat_ini TO v_dat_fim:

        IF rs_opcao = "VisaNet"
        OR rs_opcao = "Todos"
        THEN DO:
             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = "VisaNet"
                 BREAK BY int_concil_b2.cod_reg
                       BY int_concil_b2.cod_rv:

                 /* ** Detalhe Resumo de Venda ***/
                 IF int_concil_b2.cod_reg = "2"
                 THEN DO:

                       IF int_concil_b2.val_bruto > 0 
                          THEN NEXT.
/*
                       IF CAN-FIND(FIRST b_int_concil_b2
                                   WHERE b_int_concil_b2.cod_adm_bco = int_concil_b2.cod_adm_bco
                                     AND b_int_concil_b2.cod_rv      = int_concil_b2.cod_rv     
                                     AND b_int_concil_b2.cod_tit_acr = int_concil_b2.cod_tit_acr
                                     AND b_int_concil_b2.cod_reg     = int_concil_b2.cod_reg
                                     AND b_int_concil_b2.dat_credito < v_dat_aux) 
                          THEN NEXT.
*/

                       ASSIGN v_cod_cv_nsu = IF LENGTH(int_concil_b2.cod_cv_nsu) > 9 
                                                THEN STRING(INT(SUBSTRING(int_concil_b2.cod_cv_nsu, LENGTH(int_concil_b2.cod_cv_nsu) - 8, 9))) 
                                                ELSE STRING(INT(int_concil_b2.cod_cv_nsu)). /* ** STRING(INT(int_concil_b2.cod_cv_nsu)) ***/

                       IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                        WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                          AND tit_acr_cobr_especial.cod_portador    = '9910'
                                          /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/ ***/
                                          AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                       THEN DO:

                            FIND gateway-ikeda NO-LOCK
                                 WHERE gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz  NO-ERROR.
                            IF NOT AVAIL gateway-ikeda 
                            THEN DO:

                                 /*
                                 CREATE tt_concil.
                                 ASSIGN tt_concil.dat_transacao    = int_concil_b2.dat_credito
                                        tt_concil.cod_resumo       = int_concil_b2.cod_rv
                                        tt_concil.cod_tip_reg      = 2
                                        tt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                        tt_concil.des_status       = "Verificar Autorizaá∆o"
                                        tt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) .
                                        */
                                 NEXT.
                            END.
                            ELSE DO:
                                 FIND FIRST int-ped-venda NO-LOCK
                                      WHERE int-ped-venda.PedidoCodigo = gateway-ikeda.pedido NO-ERROR.
                                 IF AVAIL int-ped-venda 
                                 THEN DO:
                                      ASSIGN v_cod_cv_nsu = IF LENGTH(INT-ped-venda.cartid) > 9 
                                                               THEN STRING(INT(SUBSTRING(INT-ped-venda.cartid, LENGTH(INT-ped-venda.cartid) - 8, 9))) 
                                                               ELSE STRING(INT(INT-ped-venda.cartid)). /* ** STRING(INT(INT-ped-venda.cartid)) ***/
                                      IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                       WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                                                         AND tit_acr_cobr_especial.cod_portador                   = '9910'
                                                         /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu) ***/
                                                         AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) 
                                      THEN DO: 

                                           IF NOT CAN-FIND(tt_concil
                                                           WHERE tt_concil.num_ped_parceiro = STRING(int-ped-venda.pedidocodigo)) 
                                           THEN DO:
    
                                               /*
                                               IF int_concil_b2.cod_rv = '0090611' THEN
                                               MESSAGE int_concil_b2.cod_rv int_concil_b2.val_bruto int-ped-venda.nr-pedido
                                                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                                 */

                                                FIND ped-venda NO-LOCK
                                                    WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

                                                /*
                                                IF NOT AVAIL ped-venda 
                                                   THEN NEXT.
                                                  */


                                                CREATE tt_concil.
                                                ASSIGN tt_concil.cod_adm_bco           = "VisaNet"
                                                       tt_concil.dat_transacao         = int_concil_b2.dat_credito
                                                       tt_concil.dat_pedido            = gateway-ikeda.DataProcessamento
                                                       tt_concil.cod_resumo            = int_concil_b2.cod_rv
                                                       tt_concil.cod_tip_reg           = 3
                                                       tt_concil.cod_nsu               = v_cod_cv_nsu
                                                       tt_concil.num_ped_EMS           = int-ped-venda.nr-pedido /*ped-venda.nr-pedido*/
                                                       tt_concil.num_ped_parceiro      = STRING(int-ped-venda.pedidocodigo)
                                                       tt_concil.cdn_cliente_orig      = IF AVAIL ped-venda THEN ped-venda.cod-emitente ELSE 0
                                                       tt_concil.val_ped_vda           = int-ped-venda.ValorSubTotal
                                                       tt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                                       tt_concil.des_status            = "Resumo Ajuste DB/CR" /*int_concil_b2.des_ocor*/.
                                           END.
                                      END.
                                 END.
                                 ELSE DO:
                                   /*
                                      CREATE tt_concil.
                                      ASSIGN tt_concil.dat_transacao    = int_concil_b2.dat_credito
                                             tt_concil.cod_resumo       = int_concil_b2.cod_rv
                                             tt_concil.cod_tip_reg      = 2
                                             tt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                             tt_concil.des_status       = "Verificar Autorizaá∆o"
                                             tt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) .
                                             */
                                      NEXT.
                                 END.
                            END.
                       END.

                       FOR EACH tit_acr_cobr_especial NO-LOCK
                           WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                             AND tit_acr_cobr_especial.cod_portador                   = '9910'
                             /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/: ***/
                             AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/:
    
                             FIND tit_acr NO-LOCK
                                 WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                   AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                             IF NOT AVAIL tit_acr 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                             IF NOT AVAIL ped_vda_tit_acr 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND emscad.cliente NO-LOCK
                                 WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                   AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
    
                             FIND ped-venda NO-LOCK
                                 WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                   AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                             IF NOT AVAIL ped-venda 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND int-ped-venda NO-LOCK
                                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                             IF NOT AVAIL int-ped-venda 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
                             FIND gateway-ikeda NO-LOCK
                                 WHERE gateway-ikeda.PedidoCodigo      = int-ped-venda.PedidoCodigo
                                   AND gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz NO-ERROR.
                             IF NOT AVAIL gateway-ikeda 
                             THEN DO:
                                  NEXT.
                             END.
    
                             ASSIGN v_cod_parc_aux = '01/01'.
    
                             /* ** 505
                             FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                                  WHERE tab_livre_emsfin.cod_modul_dtsul      = "SCO"
                                    AND tab_livre_emsfin.cod_tab_dic_dtsul    = "RELAC_PARC_CARTCRED"
                                    AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                                    AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                             IF AVAIL tab_livre_emsfin 
                                THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
                             ***/
                                      
                             FIND FIRST relac_parc_cartcred NO-LOCK
                                  WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                                    AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                             IF AVAIL relac_parc_cartcred 
                                THEN ASSIGN v_cod_parc_aux = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + "/" + STRING(relac_parc_cartcred.num_parc_cartcred, "99").

                             IF int_concil_b2.cod_parcela <> v_cod_parc_aux
                             THEN DO:
                                  IF int_concil_b2.cod_parcela <> '01/01' 
                                     THEN NEXT.
/*
                                  IF int_concil_b2.cod_parcela = '01/01' 
                                     THEN RUN pi_cria_sem_parcela.
                                  NEXT.
*/                                  
                             END.

                             IF NOT CAN-FIND(tt_concil
                                             WHERE tt_concil.num_ped_parceiro = STRING(int-ped-venda.pedidocodigo)) 
                             THEN DO:

                                  CREATE tt_concil.
                                  ASSIGN tt_concil.cod_adm_bco           = "VisaNet"
                                         tt_concil.dat_transacao         = int_concil_b2.dat_credito
                                         tt_concil.dat_pedido            = gateway-ikeda.DataProcessamento
                                         tt_concil.cod_resumo            = int_concil_b2.cod_rv
                                         tt_concil.cod_tip_reg           = 3
                                         tt_concil.cod_nsu               = v_cod_cv_nsu
                                         tt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                         tt_concil.num_ped_parceiro      = STRING(int-ped-venda.pedidocodigo)
                                         tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                         tt_concil.val_ped_vda           = int-ped-venda.ValorSubTotal
                                         tt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                         tt_concil.des_status            = "Resumo Ajuste DB/CR" /*int_concil_b2.des_ocor*/.
                             END.

                       END.
                 END.
             END.
        END.

        IF rs_opcao = "RedeCard"
        OR rs_opcao = "Todos"
        THEN DO:
             
             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = "RedeCard"
                   AND int_concil_b2.cod_reg     = "035"
                 BREAK BY int_concil_b2.cod_rv DESC:

                 IF CAN-FIND(FIRST b_int_concil_b2
                             WHERE b_int_concil_b2.cod_adm_bco = int_concil_b2.cod_adm_bco
                               AND b_int_concil_b2.cod_rv      = int_concil_b2.cod_rv     
                               AND b_int_concil_b2.cod_tit_acr = int_concil_b2.cod_tit_acr
                               AND b_int_concil_b2.cod_reg     = int_concil_b2.cod_reg
                               AND b_int_concil_b2.dat_credito < v_dat_aux) 
                    THEN NEXT.

                 IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                  WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                                    AND tit_acr_cobr_especial.cod_portador                   = '9911'
                                    /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                    AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu))) 
                 THEN DO:
                      RUN pi_cria_sem_parcela.
                 END.

                 blk_35:
                 FOR EACH tit_acr_cobr_especial NO-LOCK
                     WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                       AND tit_acr_cobr_especial.cod_portador                   = '9911'
                       /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu)): ***/
                       AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu)):

                       FIND tit_acr NO-LOCK
                           WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                             AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                       IF NOT AVAIL tit_acr 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_35.
                       END.

                       FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                       IF NOT AVAIL ped_vda_tit_acr 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_35.
                       END.

                       FIND emscad.cliente NO-LOCK
                           WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                             AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.

                       FIND ped-venda NO-LOCK
                           WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                             AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                       IF NOT AVAIL ped-venda 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_35.
                       END.

                       FIND int-ped-venda NO-LOCK
                          WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                       IF NOT AVAIL int-ped-venda 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_35.
                       END.

                       IF NOT CAN-FIND(tt_concil
                                       WHERE tt_concil.num_ped_parceiro = STRING(int-ped-venda.pedidocodigo)) 
                       THEN DO:

                            FIND gateway-ikeda NO-LOCK
                                WHERE gateway-ikeda.PedidoCodigo = int-ped-venda.PedidoCodigo  NO-ERROR.
                            IF NOT AVAIL gateway-ikeda 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 LEAVE blk_35.
                            END.

                            CREATE tt_concil.
                            ASSIGN tt_concil.cod_adm_bco           = "Redecard"
                                   tt_concil.dat_transacao         = int_concil_b2.dat_credito
                                   tt_concil.dat_pedido            = gateway-ikeda.DataProcessamento
                                   tt_concil.cod_resumo            = int_concil_b2.cod_rv
                                   tt_concil.cod_tip_reg           = 3
                                   tt_concil.cod_nsu               = int_concil_b2.cod_cv_nsu
                                   tt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                   tt_concil.num_ped_parceiro      = STRING(int-ped-venda.pedidocodigo)
                                   tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                   tt_concil.val_ped_vda           = int-ped-venda.ValorSubTotal
                                   tt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                   tt_concil.des_status            = int_concil_b2.des_ocor.
                       END.
                 END.
            END.
        END.

        IF rs_opcao = "HiperCard"
        OR rs_opcao = "Todos"
        THEN DO:
             
             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = "HiperCard"
                   AND int_concil_b2.cod_reg     = "5"
                 BREAK BY int_concil_b2.cod_rv DESC:

                 IF CAN-FIND(FIRST b_int_concil_b2
                             WHERE b_int_concil_b2.cod_adm_bco = int_concil_b2.cod_adm_bco
                               AND b_int_concil_b2.cod_rv      = int_concil_b2.cod_rv     
                               AND b_int_concil_b2.cod_tit_acr = int_concil_b2.cod_tit_acr
                               AND b_int_concil_b2.cod_reg     = int_concil_b2.cod_reg
                               AND b_int_concil_b2.dat_credito < v_dat_aux) 
                    THEN NEXT.

                 IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                  WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                                    AND tit_acr_cobr_especial.cod_portador                   = '9914'
                                    /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                    AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu))) 
                 THEN DO:
                      RUN pi_cria_sem_parcela.
                 END.

                 blk_5:
                 FOR EACH tit_acr_cobr_especial NO-LOCK
                     WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar
                       AND tit_acr_cobr_especial.cod_portador                   = '9914'
                       /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu)): ***/
                       AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu)):

                       FIND tit_acr NO-LOCK
                           WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                             AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                       IF NOT AVAIL tit_acr 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_5.
                       END.

                       FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                       IF NOT AVAIL ped_vda_tit_acr 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_5.
                       END.

                       FIND emscad.cliente NO-LOCK
                           WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                             AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.

                       FIND ped-venda NO-LOCK
                           WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                             AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                       IF NOT AVAIL ped-venda 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_5.
                       END.

                       FIND int-ped-venda NO-LOCK
                          WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                       IF NOT AVAIL int-ped-venda 
                       THEN DO:
                            RUN pi_cria_sem_parcela.
                            LEAVE blk_5.
                       END.

                       IF NOT CAN-FIND(tt_concil
                                       WHERE tt_concil.num_ped_parceiro = STRING(int-ped-venda.pedidocodigo)) 
                       THEN DO:

                            FIND gateway-ikeda NO-LOCK
                                WHERE gateway-ikeda.PedidoCodigo = int-ped-venda.PedidoCodigo  NO-ERROR.
                            IF NOT AVAIL gateway-ikeda 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 LEAVE blk_5.
                            END.

                            CREATE tt_concil.
                            ASSIGN tt_concil.cod_adm_bco           = "Hipercard"
                                   tt_concil.dat_transacao         = int_concil_b2.dat_credito
                                   tt_concil.dat_pedido            = gateway-ikeda.DataProcessamento
                                   tt_concil.cod_resumo            = int_concil_b2.cod_rv
                                   tt_concil.cod_tip_reg           = 3
                                   tt_concil.cod_nsu               = int_concil_b2.cod_cv_nsu
                                   tt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                   tt_concil.num_ped_parceiro      = STRING(int-ped-venda.pedidocodigo)
                                   tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                   tt_concil.val_ped_vda           = int-ped-venda.ValorSubTotal
                                   tt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                   tt_concil.des_status            = int_concil_b2.des_ocor.
                       END.
                 END.
            END.
        END.
    END.

    FOR EACH tt_concil:

        IF tt_concil.num_ped_EMS = 0
           THEN NEXT.

        FIND ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = tt_concil.num_ped_EMS NO-ERROR.
        IF NOT AVAIL ped-venda 
        THEN DO: 
             ASSIGN tt_concil.ind_pedido = "NOK"
                    tt_concil.ind_nf     = "NOK".
             NEXT.
        END.

        ASSIGN tt_concil.ind_pedido = "Implantado".
        IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
           THEN ASSIGN tt_concil.ind_pedido = "Aprovado".
        IF ped-venda.dt-cancela <> ? 
           THEN ASSIGN tt_concil.ind_pedido = "Cancelado".

        ASSIGN tt_concil.ind_nf = "Pendente".
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
               AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL nota-fiscal 
        THEN DO:

             IF nota-fiscal.emite-duplic = YES 
                THEN ASSIGN tt_concil.ind_nf = "Faturada".

             IF nota-fiscal.dt-cancela <> ?
                THEN ASSIGN tt_concil.ind_nf = "Cancelada".

             FIND natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
          
             IF AVAIL natur-oper 
             THEN DO:
                  IF natur-oper.tipo = 1 
                  THEN DO:
          
                       FIND FIRST devol-cli USE-INDEX ch-nfe 
                            WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel 
                              AND devol-cli.serie-docto  = nota-fiscal.serie       
                              AND devol-cli.nro-docto    = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                       IF AVAIL devol-cli 
                          THEN ASSIGN tt_concil.ind_nf = "Devolvida".
                  END.
                  ELSE DO:
                       IF natur-oper.tipo = 2 
                       OR natur-oper.tipo = 3 
                       THEN DO:
                            FIND FIRST devol-cli USE-INDEX ch-nfs 
                                 WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel 
                                   AND devol-cli.serie        = nota-fiscal.serie       
                                   AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                            IF AVAIL devol-cli 
                               THEN ASSIGN tt_concil.ind_nf = "Devolvida".
                       END.
                  END.
             END.
        END.
    END.

    ASSIGN v_log_method = session:SET-WAIT-STATE("").

END.


PROCEDURE pi_cria_sem_parcela:
  /* n∆o possui relacionamento com o EMS
    CREATE tt_concil.
    ASSIGN tt_concil.dat_transacao   = int_concil_b2.dat_credito
           tt_concil.cod_resumo      = int_concil_b2.cod_rv
           tt_concil.cod_tip_reg     = 2
           tt_concil.cod_nsu         = int_concil_b2.cod_cv_nsu
           tt_concil.des_status      = "Verificar NSU *" + int_concil_b2.des_ocor
           tt_concil.cod_tit_acr_bco = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4).
           */
END.
