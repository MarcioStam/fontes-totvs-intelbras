/******************************************************************************************
**  Programa: esapb037rp.p
**  Funcao..: Importaá∆o ITÔs de embarque via csv.
**  Autor...: Andrey M Oliveira
**  Data....: 19/05/2022
**  Versao..: 1.00.00.000 - Versao Inicial.
******************************************************************************************/
/* include de controle de vers∆o */
{include/i-prgvrs.i esapb037rp 1.00.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}

{esp/cms/apb900zg.i} /* Definiá∆o das temp-tables da API de implantaá∆o */

/* preprocessador para ativar ou nao a saida para RTF */
&GLOBAL-DEFINE RTF NO
/* preprocessador para setar o tamanho da pagina */
&SCOPED-DEFINE pagesize 62  

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR FORMAT "x(35)":U
    FIELD usuario      AS CHAR FORMAT "x(12)":U
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD arquivo-import AS CHAR FORMAT "x(256)"
    FIELD fi_dat_trans   AS DATE FORMAT "99/99/9999".

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp         AS HANDLE      NO-UNDO.
DEF VAR v_conta_refer   AS INTEGER     NO-UNDO.
DEF VAR v_seq_erro_aux  AS INT         NO-UNDO.
DEF VAR v_log_refer_uni AS LOG INIT NO NO-UNDO.
DEF VAR v_cod_refer     AS CHAR        NO-UNDO.
DEF VAR v_hdl_aux       AS HANDLE      NO-UNDO.

def new global shared var v_log_atualiza_refer_apb
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Atualiza Referància"
    column-label "Atualiza Referància"
    no-undo.

DEFINE TEMP-TABLE tt_import NO-UNDO   
    FIELD linha           AS INT
    FIELD cod_estab       LIKE tit_ap.cod_estab      
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    FIELD cod_ser_docto   LIKE tit_ap.cod_ser_docto  
    FIELD cdn_fornecedor  LIKE tit_ap.cdn_fornecedor 
    FIELD cod_tit_ap      LIKE tit_ap.cod_tit_ap     
    FIELD cod_parcela     LIKE tit_ap.cod_parcela
    FIELD dat_emis        LIKE tit_ap.dat_emis_docto
    FIELD dat_venc        LIKE tit_ap.dat_vencto_tit_ap
    FIELD val_movto       LIKE tit_ap.val_origin_tit_ap
    FIELD cod_indic_econ  LIKE tit_ap.cod_indic_econ
    FIELD cod_unid_negoc  LIKE val_tit_ap.cod_unid_negoc.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen         AS INT
    FIELD tipo             AS INT
    FIELD cd-erro          AS INT
    FIELD mensagem         AS CHAR FORMAT "x(255)"
    FIELD cod_estab        LIKE tit_ap.cod_estab      
    FIELD cod_espec_docto  LIKE tit_ap.cod_espec_docto
    FIELD cod_ser_docto    LIKE tit_ap.cod_ser_docto  
    FIELD cdn_fornecedor   LIKE tit_ap.cdn_fornecedor 
    FIELD cod_tit_ap       LIKE tit_ap.cod_tit_ap     
    FIELD cod_parcela      LIKE tit_ap.cod_parcela.

def temp-table tt_relac_erro no-undo
    field tta_cod_refer            as character format "x(50)"    label "Ajuda"  column-label "Ajuda"
    field ttv_num_linha            as integer   format ">>>>,>>9" label "N£mero" column-label "N£mero"
    index tt_refer                    
          tta_cod_refer                    ascending.

FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

ASSIGN c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "esapb037rp.p"
       c-titulo-relat = "Importar Planilha Ajustes Trimestrais VMC".
       
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In°cio Importaá∆o"). 

FIND FIRST tt-param NO-ERROR.

RUN pi-acompanhar IN h-acomp (INPUT "Lendo arquivo: " + tt-param.arquivo-import).

EMPTY TEMP-TABLE tt-erro.

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

PUT "Est;Esp;Ser;For;Cod Tit;Parcela;Cod Msg;Desc Msg" SKIP.

RUN pi_importa.

/* Importar IT */
IF  CAN-FIND(FIRST tt_import) THEN DO:
    RUN pi_gera_it.
END.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.


PROCEDURE pi_importa:
    DEF VAR v_num_line       AS INT                    NO-UNDO.
    DEF VAR v_des_reg_import AS CHAR FORMAT "x(200)":U NO-UNDO.

    EMPTY TEMP-TABLE tt_import.
    
    INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.
    
    REPEAT:
        IMPORT UNFORMATTED v_des_reg_import.
    
        ASSIGN v_num_line = v_num_line + 1.
    
        IF  v_num_line = 1 THEN
            NEXT.

        run pi-acompanhar in h-acomp (input "Importando arquivo: " + tt-param.arquivo-import + " - Linha: " + string(v_num_line)).

        CREATE tt_import.
        ASSIGN tt_import.linha            = v_num_line
               tt_import.cod_estab        = TRIM(ENTRY(1,v_des_reg_import, ";"))
               tt_import.cod_espec_docto  = "IT"
               tt_import.cod_ser_docto    = ""
               tt_import.cdn_fornecedor   = INT(ENTRY(2,v_des_reg_import, ";"))
               tt_import.cod_tit_ap       = TRIM(ENTRY(3,v_des_reg_import, ";"))
               tt_import.cod_parcela      = TRIM(ENTRY(8,v_des_reg_import, ";"))
               tt_import.dat_emis         = DATE(TRIM(ENTRY(5,v_des_reg_import, ";")))
               tt_import.dat_venc         = date(TRIM(ENTRY(6,v_des_reg_import, ";")))
               tt_import.val_movto        = DEC(ENTRY(4,v_des_reg_import, ";"))
               tt_import.cod_indic_econ   = TRIM(ENTRY(7,v_des_reg_import, ";"))
               tt_import.cod_unid_negoc   = TRIM(ENTRY(9,v_des_reg_import, ";")).
    END.

END PROCEDURE.

PROCEDURE pi_gera_it:

    EMPTY TEMP-TABLE tt_relac_erro                  NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_lote_impl        NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3 NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend  NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erros_atualiz           NO-ERROR.

    ASSIGN v_conta_refer            = 0
           v_log_atualiza_refer_apb = yes
           v_seq_erro_aux           = 0.
    
    FOR EACH tt_import 
        BREAK BY tt_import.cod_estab:
        
        IF  FIRST-OF(tt_import.cod_estab) THEN DO:

            FIND FIRST estabelecimento NO-LOCK
                WHERE  estabelecimento.cod_estab = tt_import.cod_estab NO-ERROR.
            
            IF  NOT AVAIL estabelecimento THEN DO:
                PUT tt_import.cod_estab       ";"
                    tt_import.cod_espec_docto ";"
                    tt_import.cod_ser_docto   ";"
                    tt_import.cdn_fornecedor  ";"
                    tt_import.cod_tit_ap      ";"
                    tt_import.cod_parcela     ";"
                    "17006;"
                    "Estabelecimento n∆o cadastrado." SKIP.

                NEXT.
            END.

            ASSIGN v_log_refer_uni = NO.

            REPEAT WHILE NOT v_log_refer_uni:
                RUN pi_retorna_sugestao_referencia (INPUT "IT":U,
                                                    INPUT tt_import.dat_emis,
                                                    OUTPUT v_cod_refer).

                RUN pi_verifica_refer_unica_apb (INPUT  estabelecimento.cod_estab,
                                                 INPUT  v_cod_refer,
                                                 INPUT  "lote_impl_tit_ap":U,
                                                 INPUT  ?,
                                                 OUTPUT v_log_refer_uni).
            END.
            
            CREATE tt_integr_apb_lote_impl.
            ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = estabelecimento.cod_estab
                   tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer
                   tt_integr_apb_lote_impl.tta_dat_transacao     = tt-param.fi_dat_trans
                   tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
                   tt_integr_apb_lote_impl.tta_cod_empresa       = estabelecimento.cod_empresa
                   tt_integr_apb_lote_impl.tta_cod_espec_docto   = "IT". /* provis∆o */
        END.

        RELEASE tt_integr_apb_lote_impl.
        
        FIND FIRST tt_integr_apb_lote_impl 
            where tt_integr_apb_lote_impl.tta_cod_estab = tt_import.cod_estab
            and   tt_integr_apb_lote_impl.tta_cod_refer = v_cod_refer NO-ERROR.

        ASSIGN v_conta_refer = v_conta_refer + 1.

        CREATE tt_integr_apb_item_lote_impl_3.
        ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
               tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = v_conta_refer
               tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = tt_import.cdn_fornecedor
               tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = tt_import.cod_espec_docto
               tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = tt_import.cod_ser_docto
               tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = tt_import.cod_tit_ap
               tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = tt_import.cod_parcela
               tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = tt_import.dat_emis
               tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = tt_import.dat_venc
               tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = tt_import.dat_venc
               tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = "20":U
               tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = tt_import.cod_indic_econ
               tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               = tt_import.val_movto
               tt_integr_apb_item_lote_impl_3.tta_cod_portador             = "9991"
               tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 1
               tt_integr_apb_item_lote_impl_3.tta_des_text_histor          = "".

        FIND FIRST emsuni.cotac_parid NO-LOCK 
             WHERE emsuni.cotac_parid.cod_indic_econ_base  = tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ 
             AND   emsuni.cotac_parid.cod_indic_econ_idx   = "Real"
             AND   emsuni.cotac_parid.dat_cotac_indic_econ = tt_import.dat_emis
             AND   emsuni.cotac_parid.ind_tip_cotac_parid  = "Real" NO-ERROR.
        
        IF  AVAIL emsuni.cotac_parid THEN
            ASSIGN tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ = emsuni.cotac_parid.val_cotac_indic_econ.
        ELSE DO:
            PUT tt_import.cod_estab       ";"
                tt_import.cod_espec_docto ";"
                tt_import.cod_ser_docto   ";"
                tt_import.cdn_fornecedor  ";"
                tt_import.cod_tit_ap      ";"
                tt_import.cod_parcela     ";"
                "17006;"
                "Cotaá∆o n∆o encontrada para o dia " + STRING(tt_import.dat_emis) + " ." SKIP.

            NEXT.
        END.

        IF  tt_import.cod_unid_negoc <> "" THEN DO:
         
            FIND FIRST unid_negoc NO-LOCK                                                                  
                WHERE unid_negoc.cod_unid_negoc = tt_import.cod_unid_negoc NO-ERROR.

            IF  NOT AVAIL unid_negoc THEN DO:
                PUT tt_import.cod_estab       ";"
                    tt_import.cod_espec_docto ";"
                    tt_import.cod_ser_docto   ";"
                    tt_import.cdn_fornecedor  ";"
                    tt_import.cod_tit_ap      ";"
                    tt_import.cod_parcela     ";"
                    "17006;"
                    "Unidade de neg¢cio " + tt_import.cod_unid_negoc + " n∆o cadastrada." SKIP.

                NEXT.
            END.
        END.

        CREATE tt_integr_apb_aprop_ctbl_pend.
        ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = IF  tt_import.cod_unid_negoc = "" THEN "ADM" ELSE tt_import.cod_unid_negoc
               tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "202"
               tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = tt_import.val_movto
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
               tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = "11520010".
        
        RELEASE tt_integr_apb_aprop_ctbl_pend.
        
        FIND FIRST tt_integr_apb_aprop_ctbl_pend NO-ERROR.
    
        IF  LAST-OF(tt_import.cod_estab) THEN
            ASSIGN v_conta_refer = 0.
    END.

    IF  CAN-FIND(FIRST tt_integr_apb_lote_impl) THEN DO:

        cria_docto:
        DO TRANSACTION:
            
            IF NOT VALID-HANDLE(v_hdl_aux) THEN RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
        
            EMPTY TEMP-TABLE tt_log_erros_atualiz NO-ERROR.
            
            RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                              INPUT "EMS":U,
                                                              INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_3).
            
            IF  VALID-HANDLE(v_hdl_aux) THEN 
                DELETE PROCEDURE v_hdl_aux.
            
            ASSIGN v_hdl_aux = ?.
            
            IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
                FOR EACH tt_log_erros_atualiz:
                    FIND FIRST tt_integr_apb_lote_impl
                        WHERE tt_integr_apb_lote_impl.tta_cod_estab = tt_log_erros_atualiz.tta_cod_estab
                        AND   tt_integr_apb_lote_impl.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.
                    
                    IF  tt_log_erros_atualiz.tta_num_seq_refer > 0 THEN DO:
                        find first tt_integr_apb_item_lote_impl_3 
                            where tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
                            and   tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = tt_log_erros_atualiz.tta_num_seq_refer 
                            NO-LOCK NO-ERROR.

                        FIND FIRST tt_import
                            WHERE tt_import.cod_estab       = tt_integr_apb_lote_impl.tta_cod_estab
                            AND   tt_import.cdn_fornecedor  = tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor
                            AND   tt_import.cod_espec_docto = tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto
                            AND   tt_import.cod_ser_docto   = tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto
                            AND   tt_import.cod_tit_ap      = tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap
                            AND   tt_import.cod_parcela     = tt_integr_apb_item_lote_impl_3.tta_cod_parcela NO-LOCK NO-ERROR.

                        PUT tt_import.cod_estab       ";"
                            tt_import.cod_espec_docto ";"
                            tt_import.cod_ser_docto   ";"
                            tt_import.cdn_fornecedor  ";"
                            tt_import.cod_tit_ap      ";"
                            tt_import.cod_parcela     ";"
                            tt_log_erros_atualiz.ttv_num_mensagem ";"
                            tt_log_erros_atualiz.ttv_des_msg_erro SKIP.
        
                    END.
                    ELSE DO:
                        PUT tt_import.cod_estab       ";"
                            tt_import.cod_espec_docto ";"
                            tt_import.cod_ser_docto   ";"
                            tt_import.cdn_fornecedor  ";"
                            tt_import.cod_tit_ap      ";"
                            tt_import.cod_parcela     ";"
                            tt_log_erros_atualiz.ttv_num_mensagem ";"
                            tt_log_erros_atualiz.ttv_des_msg_erro SKIP.
        
                    END.
                END.
                UNDO cria_docto, LEAVE cria_docto.
            END.
        END.
    END.
    ELSE DO:
        PUT ";"
            ";"
            ";"
            ";"
            ";"
            ";"
            ";"
            "T°tulo(s) n∆o foram criados. Atualizaá∆o interrompida." SKIP.
    END.
    
    IF  NOT CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
        PUT ";"
            ";"
            ";"
            ";"
            ";"
            ";"
            ";"
            "T°tulo(s) foram criados com sucesso. Atualizaá∆o encerrada." SKIP.
    END.
END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    def Input param p_ind_tip_atualiz as CHARACTER format "X(08)"      no-undo.
    def Input param p_dat_refer       as DATE      format "99/99/9999" no-undo.
    def output param p_cod_refer      as CHARACTER format "x(10)"      no-undo.
    
    def var v_des_dat   as character no-undo.
    def var v_num_aux   as integer   no-undo.
    def var v_num_aux_2 as integer   no-undo.
    def var v_num_cont  as integer   no-undo.

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb :
    DEFINE INPUT  PARAMETER p_cod_estab        AS CHARACTER NO-UNDO FORMAT "x(3)":U.
    DEFINE INPUT  PARAMETER p_cod_refer        AS CHARACTER NO-UNDO FORMAT "x(10)":U.
    DEFINE INPUT  PARAMETER p_cod_table        AS CHARACTER NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_rec_movto_tit_ap AS RECID     NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_log_refer_uni    AS LOGICAL   NO-UNDO FORMAT "Sim/N∆o":U.

    DEFINE BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEFINE BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEFINE BUFFER b_lote_pagto       FOR lote_pagto.
    DEFINE BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    IF p_cod_table <> "antecip_pef_pend":U THEN
        FIND FIRST b_antecip_pef_pend
            WHERE b_antecip_pef_pend.cod_estab = p_cod_estab
              AND b_antecip_pef_pend.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

    IF AVAILABLE b_antecip_pef_pend THEN
        ASSIGN p_log_refer_uni = NO.
    ELSE DO:
        IF p_cod_table <> "lote_impl_tit_ap":U THEN
            FIND FIRST b_lote_impl_tit_ap
                WHERE b_lote_impl_tit_ap.cod_estab = p_cod_estab
                  AND b_lote_impl_tit_ap.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_impl_tit_ap THEN
            ASSIGN p_log_refer_uni = NO.
        ELSE DO:
            IF p_cod_table <> "lote_pagto":U THEN
                FIND FIRST b_lote_pagto
                    WHERE b_lote_pagto.cod_estab_refer = p_cod_estab
                      AND b_lote_pagto.cod_refer       = p_cod_refer NO-LOCK NO-ERROR.

            IF AVAILABLE b_lote_pagto THEN
                ASSIGN p_log_refer_uni = NO.
            ELSE DO:
                FIND FIRST b_movto_tit_ap
                    WHERE b_movto_tit_ap.cod_estab = p_cod_estab
                      AND b_movto_tit_ap.cod_refer = p_cod_refer
                      AND RECID(b_movto_tit_ap)   <> p_rec_movto_tit_ap NO-LOCK NO-ERROR.

                IF AVAILABLE b_movto_tit_ap THEN
                    ASSIGN p_log_refer_uni = NO.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

