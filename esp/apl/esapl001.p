/*****************************************************************************
** Programa..............: esp/apl/esapl001.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 03/03/2009
*****************************************************************************/

def temp-table tt_correcoes no-undo
    field tta_cod_indic_econ_juros         as character format "x(8)" label "Indic Econ Juros" column-label "Indic Econ Juros"
    field ttv_dat_correc                   as date format "99/99/9999" initial today label "Data Corre‡Æo" column-label "Data Corre‡Æo"
    field tta_num_id_movto_operac_financ   as integer format ">>>>,>>9" initial 0 label "Id Movto Oper Financ" column-label "Id Movto Oper Financ"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field ttv_val_correc_apl               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Corre‡Æo" column-label "Valor Corre‡Æo"
    field ttv_val_tax_pre_novo             as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Val.Tax.Pre" column-label "Val.Tax.Pre"
    field ttv_val_tax_pos_novo             as decimal format "->>>,>>9.9999999999" decimals 10 label "Val.Tax.Pos" column-label "Val.Tax.Pos"
    field ttv_val_cota_inic_novo           as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Cota‡Æo Inic" column-label "Cota‡Æo Inic"
    field ttv_val_cota_fim_novo            as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Cota‡Æo Fim" column-label "Cota‡Æo Fim"
    field ttv_val_juros_apl_1              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_comis_delcred            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Val Del Credere" column-label "Val Del Credere"
    field ttv_val_tax_delcred              as decimal format "->>>,>>9.999999999" decimals 9.

def temp-table tt_erros_correc no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field tta_num_id_movto_prev_operac     as integer format ">>>>,>>9" initial 0 label "Id Movto Previsto" column-label "Id Movto Previsto"
    field ttv_ind_tab_nom                  as character format "X(25)".

def temp-table tt_imposto_apl no-undo
    field ttv_dat_imposto                  as date format "99/99/9999" label "Dat.Imposto"
    field ttv_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Valor Imposto"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field ttv_num_seq_correc_pai           as integer format ">>>>,>>9"
    field ttv_ind_forma_aprop_impto        as character format "X(08)".


/* ** Temp-Table para a gera‡Æo da planilha excel ***/
def temp-table tt_excel no-undo
    field tta_cod_tip_registro             as character format "x(100)" label "Tipo Registro" column-label "Tipo Registro"
    field tta_cod_tip_produt_financ        as character format "x(8)" label "Tipo Prod Financeiro" column-label "Tipo Prod Fin"
    FIELD tta_cod_agrup_produt_financ      as character format "x(8)" label "Agrup Prod Financeiro" column-label "Agrup Prod Fin"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_produt_financ            as character format "x(8)" label "Produto Financeiro" column-label "Produto Financeiro"
    field tta_cod_operac_financ            as character format "x(10)" label "Opera‡Æo Financeira" column-label "Opera‡Æo Financeira"
    field tta_cod_cta_corren               LIKE cta_corren.cod_cta_corren    
    FIELD tta_cod_estab                    LIKE estabelecimento.cod_estab
    field tta_dat_movimento                as date format "99/99/9999" initial ? label "Data Movimento" column-label "Data Movimento"
    field tta_num_id_operac_financ         LIKE operac_financ.num_id_operac_financ    
    field ttv_val_operac_financ_total      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Opera‡Æo" column-label "Saldo Opera‡Æo"
    field ttv_val_operac_financ_curto_praz as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Curto Prazo"
    field ttv_val_operac_financ_longo_praz as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Longo Prazo"
    field ttv_val_juros_curto_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Curto Prazo"
    field ttv_val_juros_longo_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Longo Prazo"
    field ttv_val_juros_total              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    field ttv_val_pagto_curto_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Curto Prazo"
    field ttv_val_pagto_longo_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Longo Prazo"
    field ttv_val_pagto_total              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    field ttv_val_pagto_princ              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    field ttv_val_pagto_impto              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    field ttv_val_pagto_desp               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    field ttv_val_desembolso               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros" column-label "Juros"
    index tt_operac                        IS PRIMARY
          tta_cod_tip_registro             ascending
          tta_cod_tip_produt_financ        ascending
          tta_cod_agrup_produt_financ      ascending
          tta_cod_banco                    ASCENDING
    index tt_id
          tta_num_id_operac_financ         ASCENDING
    INDEX tt_cv
          tta_cod_tip_registro
          tta_cod_banco
          tta_cod_produt_financ 
          tta_cod_operac_financ            ASCENDING.

def temp-table tt_excel_novos no-undo
    field tta_cod_tip_registro             as character format "x(100)" label "Tipo Registro" column-label "Tipo Registro"
    field tta_cod_tip_produt_financ        as character format "x(8)" label "Tipo Prod Financeiro" column-label "Tipo Prod Fin"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_produt_financ            as character format "x(8)" label "Produto Financeiro" column-label "Prod Financ"
    FIELD tta_cod_estab                    LIKE estabelecimento.cod_estab
    field tta_dat_movimento                as date format "99/99/9999" initial ? label "Data Movimento" column-label "Data Movimento"
    
    field ttv_val_operac_financ_curto_praz as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Op Curto Prazo"
    field ttv_val_operac_financ_longo_praz as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Op Longo Prazo"
    field ttv_val_juros_curto_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Juros Curto Prazo"
    field ttv_val_juros_longo_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Juros Longo Prazo"
    field ttv_val_pagto_curto_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Pagto Curto Prazo"
    field ttv_val_pagto_longo_praz         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Pagto Longo Prazo"

    field tta_cod_indic_econ_operac       LIKE indic_econ_operac_financ.cod_indic_econ_operac
    field tta_dat_inic_valid              LIKE indic_econ_operac_financ.dat_inic_valid             
    field tta_dat_fim_valid               LIKE indic_econ_operac_financ.dat_fim_valid              
    field tta_ind_capitaliz_indic_econ    LIKE indic_econ_operac_financ.ind_capitaliz_indic_econ   
    field tta_ind_ump_tax_juros           LIKE indic_econ_operac_financ.ind_ump_tax_juros          
    field tta_num_id_operac_financ        LIKE indic_econ_operac_financ.num_id_operac_financ       
    field tta_val_tax_juros_operac_financ LIKE indic_econ_operac_financ.val_tax_juros_operac_financ.

/* ** Retorna saldo inicial na data de corte ***/
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

def temp-table tt_log_erros_apl_emp no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_produt_financ            as character format "x(8)" label "Produto Financeiro" column-label "Produto Financeiro"
    field tta_cod_operac_financ            as character format "x(10)" label "Opera‡Æo Financeira" column-label "Opera‡Æo Financeira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_ind_tip_trans_apl            as character format "X(20)" initial "Aplica‡Æo" label "Tipo Transa‡Æo" column-label "Tipo Transa‡Æo".

def temp-table tt_resumo_apl no-undo
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_produt_financ            as character format "x(8)" label "Produto Financeiro" column-label "Produto Financeiro"
    field tta_cod_tip_produt_financ        as character format "x(8)" label "Tipo Prod Financeiro" column-label "Tipo Prod Fin"
    field tta_cod_operac_financ            as character format "x(10)" label "Opera‡Æo Financeira" column-label "Opera‡Æo Financeira"
    field tta_dat_operac_financ            as date format "99/99/9999" initial ? label "Data Opera‡Æo" column-label "Data Opera‡Æo"
    field tta_dat_vencto_operac_financ     as date format "99/99/9999" initial ? label "Data Vencto" column-label "Data Vencto"
    field ttv_val_operac_financ            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Opera‡Æo" column-label "Saldo Opera‡Æo"
    field ttv_val_tot_aplic_dispon         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Dispon¡vel" column-label "Dispon¡vel"
    field ttv_val_tot_aplic_carenc         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo em Carˆncia" column-label "Carˆncia"
    field ttv_val_emprest_curto_praz       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Curto Prazo"
    field ttv_val_sdo_longo_praz           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Longo Prazo"
    field tta_ind_operac_financ            as character format "X(12)" label "Opera‡Æo" column-label "Opera‡Æo"
    field tta_log_emprest_concedid         as logical format "Sim/NÆo" initial no label "Empr‚stimo Concedido" column-label "Empr‚stimo Concedido"
    field ttv_val_sdo_princ                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Principal" column-label "Saldo Principal".

/* ** Retorna proje‡Æo das parcelas e juros ***/ 
def temp-table tt_operac_financ no-undo like operac_financ
    field ttv_val_sdo_curto_praz           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Curto Prazo" column-label "Saldo Curto Prazo"
    field ttv_val_sdo_longo_praz           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Longo Prazo" column-label "Longo Prazo".

def temp-table tt_movto_operac_financ no-undo like movto_operac_financ.
  
def temp-table tt_indic_econ_operac_financ no-undo like indic_econ_operac_financ.

def temp-table tt_despes_operac_financ no-undo like despes_operac_financ
    field tta_ind_forma_aprop_despes       as character format "X(15)" initial "Abate Sdo Princ" label "Apropria‡Æo Despesa" column-label "Apropria‡Æo Despesa"
    field ttv_val_despes                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Val Despesa" column-label "Val Despesa"
    field tta_val_cotac_contrat            as decimal format ">>>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo Contratada" column-label "Cota‡Æo Contratada"
    field tta_val_movto_indic_econ_movto   as decimal format ">>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movto na Moeda" column-label "Vl Movto na Moeda".

def temp-table tt_parc_operac_financ no-undo like parc_operac_financ.

def temp-table tt_documen_operac_financ no-undo like documen_operac_financ.

def temp-table tt_fiador_operac_financ no-undo like fiador_operac_financ.

def temp-table tt_gartia_operac_financ no-undo like gartia_operac_financ.

/* ** Retorna saldos das contas correntes  ***/
DEF TEMP-TABLE tt_cta_corren no-undo
    FIELD tta_cod_estab      LIKE cta_corren.cod_estab
    FIELD tta_cod_cta_corren LIKE cta_corren.cod_cta_corren
    FIELD tta_val_sdo        LIKE movto_cta_corren.val_movto_cta_corren.

/* ** Cota‡Æo ***/
DEF TEMP-TABLE tt_cotac no-undo
    FIELD tta_cod_indic_econ LIKE indic_econ.cod_indic_econ
    FIELD tta_val_cotac      LIKE cotac_parid.val_cotac_indic_econ.


DEFINE VARIABLE v_val_sdo_real_inic    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_nreal_inic   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_bcio_inic    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_dat_cotac_indic_econ AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_return           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_indic_econ_aux   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_val_sdo_dat                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_princ_operac_financ AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_acum_apl                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_movto_sdo_princ         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_cotac_indic_econ        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_convtdo_apl             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_emprest_curto_praz      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_longo_praz          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_juros_longo_praz    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_sdo_juros_curto_praz    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_acum_aux                AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_data_corte                AS DATE       FORMAT "99/99/9999" LABEL "Posi‡Æo em" NO-UNDO.
DEFINE VARIABLE v_data_projecao             AS DATE       FORMAT "99/99/9999" LABEL "Projetar at‚" NO-UNDO.
DEFINE VARIABLE v_qtd_dias_curto_praz       AS INTEGER    FORMAT "999" LABEL "Dias Curto Prazo" NO-UNDO.
DEFINE VARIABLE v_cod_banco_ini             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_banco_fim             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_produt_financ_ini     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_produt_financ_fim     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq                   AS CHARACTER   FORMAT "x(59)" LABEL "Arquivo" NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.


DEF VAR v_cod_arq_imp AS CHAR NO-UNDO.

DEFINE VARIABLE i-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cont bil", 1,
          "Financeiro", 2
     SIZE 26 BY .75 NO-UNDO.

/*************************** Query Definition     ***************************/
DEF QUERY qr_tt_excel_novos
    FOR tt_excel_novos
    SCROLLING.

/************************** Browse Definition Begin *************************/

def browse br_tt_excel_novos query qr_tt_excel_novos display 
    tta_cod_produt_financ           
    tta_cod_banco                   
    tta_cod_estab                   
    tta_dat_movimento               
    ttv_val_operac_financ_curto_praz
    ttv_val_operac_financ_longo_praz
    ttv_val_juros_curto_praz        
    ttv_val_juros_longo_praz        
    ttv_val_pagto_curto_praz        
    ttv_val_pagto_longo_praz        
    tta_cod_indic_econ_operac       
    tta_dat_inic_valid              
    tta_dat_fim_valid               
    tta_ind_capitaliz_indic_econ    
    tta_ind_ump_tax_juros           
    tta_val_tax_juros_operac_financ 
  ENABLE ALL
  with no-box separators single 
         size 87 by 05.08
         font 1
         bgcolor 15.

/************************** Browse Definition End *************************/

/* ** Main Code ***/
ASSIGN v_qtd_dias_curto_praz   = 360
       i-opcao                 = 1
       v_cod_banco_ini         = ""
       v_cod_banco_fim         = "ZZZ"
       v_cod_produt_financ_ini = ""
       v_cod_produt_financ_fim = "zzzzzzzzzzzzz"
       v_data_corte            = 01/31/2009
       v_data_projecao         = 12/31/2009
       v_cod_arq               = SESSION:TEMP-DIRECTORY + "apl.txt"
       v_cod_arq_imp           = SESSION:TEMP-DIRECTORY + "esapl001.txt".


def var wh_w_program
    as widget-handle
    no-undo.

create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
         resize               = no
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.

def rectangle rt_key
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    fgcolor 1 edge-pixels 2.

def button bt_exi
    label "Sa¡da"
        tooltip "Sa¡da"
    image-up file "image/im-exi"
    size 1 by 1.
def button bt_aprova
    label "Projetar APL"
        tooltip "Projetar APL"
    image-up file "image/im-cotof"
    size 1 by 1.

DEFINE BUTTON bt_add
     LABEL "Inclui" 
     SIZE 19 BY 1.

DEFINE BUTTON bt_era
     LABEL "Elimina" 
     SIZE 19 BY 1.

DEFINE BUTTON bt_cotac
     LABEL "Cota‡Æo" 
     SIZE 19 BY 1.

def frame f_apl
    rt_rgf   at row 01.00 col 01.00 bgcolor 7
    rt_key   at row 02.50 col 02.00
    rt_mold  AT ROW 13 COL 2
    v_data_corte         
         at row 02.8 col 25 colon-aligned
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_data_projecao      
         at row 02.8 col 48 colon-aligned
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_qtd_dias_curto_praz
         at row 03.8 col 25 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    i-opcao  AT ROW 04.75 COL 52 LABEL "VisÆo"
    bt_cotac AT ROW 04.75 COL 27
    v_cod_arq            
         at row 05.8 col 25 colon-aligned
         view-as fill-in
         size-chars 60.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_aprova
         at row 01.08 col 2.14 font ?
         help "Projetar APL"
    bt_exi   at row 01.08 col 84.14 font ?
       help "Sa¡da"
    br_tt_excel_novos
         AT ROW 7.5 COL 2
    bt_add
         AT ROW 13.4 COL 3
    bt_era
         AT ROW 13.4 COL 23
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 89.29 by 15.04
         at row 01.00 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Proje‡Æo APL - ESAPL001".
/* adjust size of objects in this frame */
assign bt_exi:width-chars     in frame f_apl = 04.00
       bt_exi:height-chars    in frame f_apl = 01.13
       bt_aprova:width-chars  in frame f_apl = 04.00
       bt_aprova:height-chars in frame f_apl = 01.13
       rt_key:width-chars     in frame f_apl = 86.79
       rt_key:height-chars    in frame f_apl = 04.70
       rt_rgf:width-chars     in frame f_apl = 88.29
       rt_rgf:height-chars    in frame f_apl = 01.29
       rt_mold:width-chars    in frame f_apl = 86.79
       rt_mold:height-chars   in frame f_apl = 01.80.


ON LEAVE OF v_data_corte IN FRAME f_apl
DO:

    FOR EACH tt_cotac:
        DELETE tt_cotac.
    END.

    /* ** Carrega cota‡Æo com base na data de corte - Proje‡Æo pagamento e juros dos empr‚stimos ***/
    CREATE tt_cotac.
    ASSIGN tt_cotac.tta_cod_indic_econ = "Real"
           tt_cotac.tta_val_cotac      = 1.
    FOR EACH operac_financ NO-LOCK
        WHERE operac_financ.ind_operac_financ         = "Empr‚stimo"
          AND (operac_financ.ind_sit_operac_financ_apl = "Ativa" OR
               operac_financ.ind_sit_operac_financ_apl = "Encerrada"):
    
        IF operac_financ.ind_operac_financ = "Real" 
           THEN NEXT.
        FIND tt_cotac NO-LOCK
            WHERE tt_cotac.tta_cod_indic_econ = operac_financ.cod_indic_econ NO-ERROR.
        IF AVAIL tt_cotac 
           THEN NEXT.
    
        RUN pi_achar_cotac_indic_econ (INPUT operac_financ.cod_indic_econ,
                                       INPUT "Real",
                                       INPUT INPUT FRAME f_apl v_data_corte,
                                       INPUT "Real" /*l_real*/,
                                       OUTPUT v_dat_cotac_indic_econ,
                                       OUTPUT v_val_cotac_indic_econ,
                                       OUTPUT v_cod_return) /*pi_achar_cotac_indic_econ*/.
    
        CREATE tt_cotac.
        ASSIGN tt_cotac.tta_cod_indic_econ = operac_financ.cod_indic_econ
               tt_cotac.tta_val_cotac      = IF v_val_cotac_indic_econ <> 0 
                                                THEN (1 / v_val_cotac_indic_econ)
                                                ELSE 0.
    
    END.
    /* ** Final Cota‡Æo ***/    

END.

ON CHOOSE OF bt_exi IN FRAME f_apl
DO:
    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END.

ON WINDOW-CLOSE OF wh_w_program
DO:

    APPLY "choose" TO bt_exi IN FRAME f_apl.

END.

ON CHOOSE OF bt_aprova IN FRAME f_apl
DO:

  ASSIGN v_data_projecao       = INPUT FRAME f_apl v_data_projecao       
         v_data_corte          = INPUT FRAME f_apl v_data_corte         
         v_qtd_dias_curto_praz = INPUT FRAME f_apl v_qtd_dias_curto_praz
         i-opcao               = INPUT FRAME f_apl i-opcao
         v_cod_arq             = INPUT FRAME f_apl v_cod_arq.

  IF v_data_projecao < v_data_corte 
  THEN DO:
       MESSAGE "Data de Proje‡Æo deve ser menor que a data de Posi‡Æo !"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
  END.
  IF v_data_corte > TODAY 
  THEN DO:
       MESSAGE "Data de Posi‡Æo deve ser um per¡odo Fechado !"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
  END.

  IF SESSION:SET-WAIT-STATE("general") THEN.
  RUN pi_projetar_apl.
  IF SESSION:SET-WAIT-STATE("") THEN.

END.

ON CHOOSE OF bt_era IN FRAME f_apl
DO:

  IF AVAIL tt_excel_novos 
  THEN DO:
       DELETE tt_excel_novos.
       OPEN QUERY qr_tt_excel_novos
                  FOR EACH  tt_excel_novos NO-LOCK.
  END.

END.

ON CHOOSE OF bt_add IN FRAME f_apl
DO:

    DEFINE VARIABLE v_rec_atual AS RECID NO-UNDO.

    CREATE tt_excel_novos.
    ASSIGN tta_cod_tip_registro      = "APL NOVOS EMP"
           tta_cod_tip_produt_financ = "Emprest"
           v_rec_atual               = recid(tt_excel_novos).

    OPEN QUERY qr_tt_excel_novos
         FOR EACH  tt_excel_novos NO-LOCK.

    REPOSITION qr_tt_excel_novos TO RECID v_rec_atual.

END.

/* ** Informar Cota‡Æo ***/
DEF QUERY qr_cotac
  FOR tt_cotac
  SCROLLING.

def browse br_cotac query qr_cotac display 
    tt_cotac.tta_cod_indic_econ 
    tt_cotac.tta_val_cotac     
    ENABLE tt_cotac.tta_val_cotac
  with no-box separators single 
         size 28 by 6.08
         font 1
         bgcolor 15.

def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.

def frame f_cotac
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 8.75 col 02.00 bgcolor 7 
    br_cotac
         at row 01.8 col 4.5
    bt_ok
         at row 08.96 col 03.00 font ?
         help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 35.14 by 10.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Cota‡Æo Proje‡Æo".
    /* adjust size of objects in this frame */
    assign bt_ok:width-chars                in frame f_cotac = 10.00
           bt_ok:height-chars               in frame f_cotac = 01.00
           rt_cxcf:width-chars              in frame f_cotac = 32.72
           rt_cxcf:height-chars             in frame f_cotac = 01.42
           rt_mold:width-chars              in frame f_cotac = 32.72
           rt_mold:height-chars             in frame f_cotac = 07.5.


ON CHOOSE OF bt_cotac IN FRAME f_apl
DO:

      VIEW FRAME f_cotac.

      OPEN QUERY qr_cotac
           FOR EACH  tt_cotac
               WHERE tt_cotac.tta_cod_indic_econ <> "Real".

     filter_block:
     do on error undo filter_block, retry filter_block
                      on endkey undo filter_block, leave filter_block:
          DISPLAY bt_ok
                  br_cotac
                  WITH FRAME f_cotac.
    
          ENABLE ALL WITH FRAME f_cotac.
          
          WAIT-FOR GO OF FRAME f_cotac.
      END.
      HIDE FRAME f_cotac.

END.


assign wh_w_program:title         = frame f_apl:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 1.00.00.000":U)
                                  + chr(41)
       frame f_apl:title       = ?
       wh_w_program:width-chars   = frame f_apl:width-chars
       wh_w_program:height-chars  = frame f_apl:height-chars - 0.85
       frame f_apl:row         = 1
       frame f_apl:col         = 1
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.


IF SEARCH(v_cod_arq_imp) <> ?
THEN DO:
     INPUT FROM VALUE(v_cod_arq_imp).
     REPEAT:
         CREATE tt_excel_novos.
         IMPORT tt_excel_novos.
     END.
     INPUT CLOSE. 
END.

FOR EACH tt_excel_novos
    WHERE tta_cod_tip_registro = "":
    DELETE tt_excel_novos.
END.

pause 0 before-hide.
view frame f_apl.

OPEN QUERY qr_tt_excel_novos
           FOR EACH  tt_excel_novos NO-LOCK.

DISP v_data_corte         
     v_data_projecao      
     v_qtd_dias_curto_praz
     i-opcao
     v_cod_arq WITH FRAME f_apl.

enable v_data_corte         
       v_data_projecao      
       v_qtd_dias_curto_praz
       i-opcao
       bt_cotac
       v_cod_arq            
       bt_aprova
       bt_exi
       br_tt_excel_novos
       bt_add
       bt_era
       with frame f_apl.

if  this-procedure:persistent = no
then do:
    wait-for choose of bt_exi in frame f_apl.
end.

OUTPUT TO VALUE(v_cod_arq_imp).
FOR EACH tt_excel_novos:
    EXPORT tt_excel_novos.
END.
OUTPUT CLOSE.


PROCEDURE pi_projetar_apl:

    FOR EACH tt_excel:
        DELETE tt_excel.
    END.

    /* ** Zarpe ***/
    RUN pi_retorna_sdo_inicial_apl.

    IF i-opcao = 1 
    THEN DO:
         RUN pi_retorna_projecao_apl.               /* ** Proje‡Æo Parcela, Proje‡Æo VC da Parcela ***/
         RUN pi_retorna_projecao_juros_apl.         /* ** Projecao Juros                           ***/
         RUN pi_retorna_projecao_parcela_juros_apl. /* ** Projecao Parcela + Juros                 ***/
         RUN pi_retorna_sdo_inicial_cmg.
         RUN pi_retorna_novos_emprestimos.
    END.
    ELSE DO:
         RUN pi_retorna_projecao_apl_fin.           /* ** Proje‡Æo Parcela, Proje‡Æo VC da Parcela ***/
    END.
    
    OUTPUT TO VALUE(v_cod_arq) NO-CONVERT.
    
    DEF BUFFER b_tt_excel FOR tt_excel.
    
    PUT UNFORMATTED "Tipo;"
                    "Tipo Produto;"
                    "Agrupador Produto;"
                    "Banco;"
                    "Descricao;"
                    "Produto;"
                    "Descricao;"
                    "Operacao;"
                    "Conta Corrente;"
                    "Estabelecimento;"
                    "Data Movimento;"
                    "ID Operacao;"
                    "Valor Operacao Total;"
                    "Valor Operacao Curto Prazo;"
                    "Valor Operacao Longo Prazo;"
                    "Valor Juros Total;"
                    "Valor Juros Curto Prazo;"
                    "Valor Juros Longo Prazo;"
                    "Valor Pagto Total;"
                    "Valor Pagto Curto Prazo;"
                    "Valor Pagto Longo Prazo;"
                    "Valor Pagto Principal;"
                    "Valor Imposto;"
                    "Valor Despesas;"
                    "Valor Desembolso;"
                    "Data Inicio Operacao;"     
                    "Data Vcto Operacao;"
                    "Indicador Economico;"
                    "Inicio Validade;"
                    "Fim Validade;"
                    "Indice;"
                    "UMP;"
                    "ID Operacao;"
                    "% Taxa Juros" SKIP.
    
    FOR EACH tt_excel
        WHERE tt_excel.tta_cod_tip_registro <> "PROJECAO NOVOS"
          AND tt_excel.tta_cod_tip_registro <> "PROJECAO JUROS"
          AND tt_excel.tta_cod_tip_registro <> "PROJECAO PARCELA"
          AND tt_excel.tta_cod_tip_registro <> "PROJECAO PARCELA + JUROS"
          AND tt_excel.tta_cod_tip_registro <> "PROJECAO VC":
    
        FIND emscad.banco NO-LOCK
            WHERE emscad.banco.cod_banco = tt_excel.tta_cod_banco NO-ERROR.
    
        FIND produt_financ NO-LOCK
            WHERE produt_financ.cod_produt_financ = tt_excel.tta_cod_produt_financ NO-ERROR.
    
        FIND operac_financ NO-LOCK
            WHERE operac_financ.num_id_operac_financ = tt_excel.tta_num_id_operac_financ NO-ERROR.
    
        PUT UNFORMATTED tt_excel.tta_cod_tip_registro             ";"
                        tt_excel.tta_cod_tip_produt_financ        ";"
                        tt_excel.tta_cod_agrup_produt_financ      ";"
                        tt_excel.tta_cod_banco                    ";"
                        IF AVAIL emscad.banco 
                           THEN emscad.banco.nom_banco 
                           ELSE ""                                ";"
                        tt_excel.tta_cod_produt_financ            ";"
                        IF AVAIL produt_financ 
                           THEN produt_financ.des_produt_financ 
                           ELSE ""                                ";"
                        tt_excel.tta_cod_operac_financ            ";"
                        tt_excel.tta_cod_cta_corren               ";"
                        tt_excel.tta_cod_estab                    ";"
                        tt_excel.tta_dat_movimento                ";"
                        tt_excel.tta_num_id_operac_financ         ";"
                        tt_excel.ttv_val_operac_financ_total      ";"
                        tt_excel.ttv_val_operac_financ_curto_praz ";"
                        tt_excel.ttv_val_operac_financ_longo_praz ";"
                        tt_excel.ttv_val_juros_total              ";"
                        tt_excel.ttv_val_juros_curto_praz         ";"
                        tt_excel.ttv_val_juros_longo_praz         ";"
                        tt_excel.ttv_val_pagto_total              ";"
                        tt_excel.ttv_val_pagto_curto_praz         ";"
                        tt_excel.ttv_val_pagto_longo_praz         ";"
                        tt_excel.ttv_val_pagto_princ              ";"
                        tt_excel.ttv_val_pagto_impto              ";"
                        tt_excel.ttv_val_pagto_desp               ";"
                        tt_excel.ttv_val_desembolso               ";"
                        IF AVAIL operac_financ
                           THEN string(operac_financ.dat_operac_financ)       
                           ELSE ""                                ";"
                        IF AVAIL operac_financ
                           THEN string(operac_financ.dat_vencto_operac_financ) 
                           ELSE ""                                SKIP.
        
        IF  (tt_excel.tta_cod_tip_registro      = "SDO INIC APL" OR
             tt_excel.tta_cod_tip_registro      = "SDO INIC APL NOVOS")
        AND tt_excel.tta_cod_tip_produt_financ = "Emprest"
        THEN DO:
             FOR EACH tt_indic_econ_operac_financ 
                 WHERE tt_indic_econ_operac_financ.num_id_operac_financ = tt_excel.tta_num_id_operac_financ:
                 PUT UNFORMATTED IF tt_excel.tta_cod_tip_registro      = "SDO INIC APL" 
                                    THEN "TAXAS"                                        
                                    ELSE "TAXAS NOVOS"                                  ";"
                                 tt_excel.tta_cod_tip_produt_financ                     ";"
                                 tt_excel.tta_cod_agrup_produt_financ                   ";"
                                 tt_excel.tta_cod_banco                                 ";"
                                 IF AVAIL emscad.banco 
                                    THEN emscad.banco.nom_banco 
                                    ELSE ""                                             ";"
                                 tt_excel.tta_cod_produt_financ                         ";"
                                 IF AVAIL produt_financ 
                                    THEN produt_financ.des_produt_financ 
                                    ELSE ""                                             ";"
                                 tt_excel.tta_cod_operac_financ                         ";"
                                 tt_excel.tta_cod_cta_corren                            ";"
                                 tt_excel.tta_cod_estab                                 ";"
                                 tt_excel.tta_dat_movimento                             ";"
                                 tt_excel.tta_num_id_operac_financ                      ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                         ""                                             ";"
                                 tt_indic_econ_operac_financ.cod_indic_econ_operac      ";"
                                 tt_indic_econ_operac_financ.dat_inic_valid             ";"
                                 tt_indic_econ_operac_financ.dat_fim_valid              ";"
                                 tt_indic_econ_operac_financ.ind_capitaliz_indic_econ   ";"
                                 tt_indic_econ_operac_financ.ind_ump_tax_juros          ";"
                                 tt_indic_econ_operac_financ.num_id_operac_financ       ";"
                                 tt_indic_econ_operac_financ.val_tax_juros_operac_financ SKIP.
             END.
             FOR EACH b_tt_excel
                 WHERE b_tt_excel.tta_num_id_operac_financ = tt_excel.tta_num_id_operac_financ
                   AND (b_tt_excel.tta_cod_tip_registro    = "PROJECAO NOVOS"   OR 
                        b_tt_excel.tta_cod_tip_registro    = "PROJECAO JUROS"   OR
                        b_tt_excel.tta_cod_tip_registro    = "PROJECAO PARCELA" OR 
                        b_tt_excel.tta_cod_tip_registro    = "PROJECAO PARCELA + JUROS" OR
                        b_tt_excel.tta_cod_tip_registro    = "PROJECAO VC"):
    
                   PUT UNFORMATTED b_tt_excel.tta_cod_tip_registro             ";"
                                   b_tt_excel.tta_cod_tip_produt_financ        ";"
                                   b_tt_excel.tta_cod_agrup_produt_financ      ";"
                                   b_tt_excel.tta_cod_banco                    ";"
                                   IF AVAIL emscad.banco 
                                      THEN emscad.banco.nom_banco 
                                      ELSE ""                                  ";"
                                   b_tt_excel.tta_cod_produt_financ            ";"
                                   IF AVAIL produt_financ 
                                      THEN produt_financ.des_produt_financ 
                                      ELSE ""                                  ";"
                                   b_tt_excel.tta_cod_operac_financ            ";"
                                   b_tt_excel.tta_cod_cta_corren               ";"
                                   b_tt_excel.tta_cod_estab                    ";"
                                   b_tt_excel.tta_dat_movimento                ";"
                                   b_tt_excel.tta_num_id_operac_financ         ";"
                                   b_tt_excel.ttv_val_operac_financ_total      ";"
                                   b_tt_excel.ttv_val_operac_financ_curto_praz ";"
                                   b_tt_excel.ttv_val_operac_financ_longo_praz ";"
                                   b_tt_excel.ttv_val_juros_total              ";"
                                   b_tt_excel.ttv_val_juros_curto_praz         ";"
                                   b_tt_excel.ttv_val_juros_longo_praz         ";"
                                   b_tt_excel.ttv_val_pagto_total              ";"
                                   b_tt_excel.ttv_val_pagto_curto_praz         ";"
                                   b_tt_excel.ttv_val_pagto_longo_praz         ";" 
                                   b_tt_excel.ttv_val_pagto_princ              ";" 
                                   b_tt_excel.ttv_val_pagto_impto              ";"
                                   b_tt_excel.ttv_val_pagto_desp               ";"
                                   b_tt_excel.ttv_val_desembolso               ";"
                                   SKIP.

             END.
        END.
    
    END.
    
    OUTPUT CLOSE.
    
END.

PROCEDURE pi_retorna_sdo_inicial_apl:
    /* ** C lculo do saldo inicial ***/
    FOR EACH emscad.empresa NO-LOCK:
        /* *************** APLICACOES ***************** */
        IF i-opcao = 1 
           THEN RUN pi_rpt_resumo_apl_aplicacoes.
        /* *************** EMPRESTIMOS ***************** */
        RUN pi_rpt_resumo_apl_emprestimos.
    END.
    
    FOR EACH tt_log_erros_apl_emp:
        DISP 'Erro: ' tt_log_erros_apl_emp.ttv_des_msg_ajuda tt_log_erros_apl_emp.ttv_des_msg_erro.
    END.

    FOR EACH tt_resumo_apl:
        FIND operac_financ NO-LOCK
            WHERE operac_financ.cod_banco         = tt_resumo_apl.tta_cod_banco        
              AND operac_financ.cod_produt_financ = tt_resumo_apl.tta_cod_produt_financ
              AND operac_financ.cod_operac_financ = tt_resumo_apl.tta_cod_operac_financ NO-ERROR.
    
        FIND cta_corren NO-LOCK
            WHERE cta_corren.cod_cta_corren = operac_financ.cod_cta_corren_padr NO-ERROR.
/*    
OUTPUT TO u:\valida-ini.txt APPEND.
PUT operac_financ.cod_indic_econ
    operac_financ.cod_banco        
    operac_financ.cod_produt_financ.
EXPORT tt_resumo_apl.
OUTPUT CLOSE.
*/
        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = "SDO INIC APL"
               tt_excel.tta_cod_tip_produt_financ        = tt_resumo_apl.tta_cod_tip_produt_financ
               tt_excel.tta_cod_agrup_produt_financ      = ""
               tt_excel.tta_cod_banco                    = tt_resumo_apl.tta_cod_banco
               tt_excel.tta_cod_produt_financ            = tt_resumo_apl.tta_cod_produt_financ
               tt_excel.tta_cod_operac_financ            = tt_resumo_apl.tta_cod_operac_financ
               tt_excel.tta_cod_cta_corren               = cta_corren.cod_cta_corren
               tt_excel.tta_cod_estab                    = cta_corren.cod_estab
               tt_excel.tta_dat_movimento                = v_data_corte
               tt_excel.tta_num_id_operac_financ         = operac_financ.num_id_operac_financ
               /* ** Totais do Saldo Inicial ****/
               ttv_val_operac_financ_curto_praz          = tt_resumo_apl.ttv_val_emprest_curto_praz
               ttv_val_operac_financ_longo_praz          = tt_resumo_apl.ttv_val_sdo_longo_praz
               ttv_val_operac_financ_total               = IF tt_resumo_apl.tta_cod_tip_produt_financ = "Aplic" 
                                                              THEN tt_resumo_apl.ttv_val_tot_aplic_dispon 
                                                              ELSE tt_resumo_apl.ttv_val_operac_financ.

        FIND int_produt_financ NO-LOCK
            WHERE int_produt_financ.cod_produt_financ = tt_excel.tta_cod_produt_financ NO-ERROR.
        IF AVAIL int_produt_financ 
           THEN ASSIGN tt_excel.tta_cod_agrup_produt_financ = int_produt_financ.tip_produt_financ.

    END.
    /* ** Fim calculo do saldo inicial ***/

END.

PROCEDURE pi_retorna_projecao_apl:

    DEF BUFFER b_tt_excel_cv FOR tt_excel.

    DEFINE VARIABLE v_val_parc_pagto       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_dat_cotac_indic_econ AS DATE        NO-UNDO.
    DEFINE VARIABLE v_val_cotac_indic_econ AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_cod_return           AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v_cod_operac_financ_ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_operac_financ_fim AS CHARACTER   NO-UNDO.

    ASSIGN v_cod_operac_financ_ini = ""
           v_cod_operac_financ_fim = "ZZZZZZZZZZZZZZZZZZZ".

    /* ** Zarpe *
    ASSIGN v_cod_banco_ini = "237"
           v_cod_banco_fim = "237"
           v_cod_produt_financ_ini = "finimp" 
           v_cod_produt_financ_fim = "finimp"
           v_cod_operac_financ_ini = "900078"
           v_cod_operac_financ_fim = "900078". ***/

    /* ** Tratamento para a leitura das Aplica‡äes e Empr‚stimos, Taxas e Parcelas ***/
    run prgfin/apl/apl313za.py (Input 1,
                                Input YES, /* v_log_operac_financ_com_sdo,*/
                                Input NO, /* v_log_mostra_operac_sem_sdo,*/
                                Input YES, /* v_log_mostra_operac_detdo,*/
                                Input v_qtd_dias_curto_praz, /* v_qtd_dias_curto_praz,*/
                                Input NO, /* v_log_mostra_movto_operac,*/
                                Input YES, /* v_log_mostra_tax_operac,*/
                                Input NO, /* v_log_mostra_despes_operac,*/
                                Input YES, /* v_log_mostra_parc_operac,*/
                                Input NO, /* v_log_mostra_docto_operac,*/
                                Input NO, /* v_log_mostra_gartia_operac,*/
                                Input NO, /* v_log_mostra_fiador_operac,*/
                                Input v_cod_banco_ini, /* v_cod_banco_ini,*/
                                Input v_cod_banco_fim, /* v_cod_banco_fim,*/
                                Input v_cod_produt_financ_ini, /* v_cod_produt_financ_ini,*/
                                Input v_cod_produt_financ_fim, /* v_cod_produt_financ_fim,*/
                                Input v_cod_operac_financ_ini, /*v_cod_operac_financ_ini,*/
                                Input v_cod_operac_financ_fim, /*v_cod_operac_financ_fim,*/
                                Input 01/01/0001, /*v_dat_operac_financ_ini,*/
                                Input 12/31/9999, /*v_dat_operac_financ_fim,*/
                                Input 01/01/0001, /*v_dat_vencto_operac_financ_ini,*/
                                Input 12/31/9999, /*v_dat_vencto_operac_financ_fim,*/
                                output table tt_operac_financ,
                                output table tt_movto_operac_financ,
                                output table tt_indic_econ_operac_financ,
                                output table tt_despes_operac_financ,
                                output table tt_parc_operac_financ,
                                output table tt_documen_operac_financ,
                                output table tt_fiador_operac_financ,
                                output table tt_gartia_operac_financ,
                                Input "ZZZZZZZZZZZZZZZZZZZ", /*v_cod_tip_produt_financ_fim,*/
                                Input "", /*v_cod_tip_produt_financ_ini,*/
                                Input NO,
                                Input "",
                                Input "ZZZ").
    
    FOR EACH tt_parc_operac_financ:

        IF tt_parc_operac_financ.dat_vencto_parc < v_data_corte
        OR tt_parc_operac_financ.dat_vencto_parc > v_data_projecao 
           THEN NEXT.
        
        IF tt_parc_operac_financ.ind_tip_parc_emprest <> "Pagamento"
           THEN NEXT.

        FIND operac_financ NO-LOCK
            WHERE operac_financ.num_id_operac_financ = tt_parc_operac_financ.num_id_operac_financ NO-ERROR.

        FIND tt_resumo_apl
            WHERE tt_resumo_apl.tta_cod_banco         = operac_financ.cod_banco
              AND tt_resumo_apl.tta_cod_produt_financ = operac_financ.cod_produt_financ
              AND tta_cod_tip_produt_financ           = "Emprest"
              AND tta_cod_operac_financ               = operac_financ.cod_operac_financ NO-ERROR.
        IF NOT AVAIL tt_resumo_apl 
           THEN NEXT.

        FIND cta_corren NO-LOCK
            WHERE cta_corren.cod_cta_corren = operac_financ.cod_cta_corren_padr NO-ERROR.

        FIND tt_cotac NO-LOCK
            WHERE tt_cotac.tta_cod_indic_econ = operac_financ.cod_indic_econ NO-ERROR.
        
/*zarpe
OUTPUT TO u:\valida-jur-antes.txt APPEND.
PUT operac_financ.cod_indic_econ
    operac_financ.cod_banco        
    operac_financ.cod_produt_financ
    tt_cotac.tta_val_cotac.
EXPORT tt_parc_operac_financ.
OUTPUT CLOSE.
*/

        /* ** Localiza cota‡Æo da data de corte, para calcular a varia‡Æo cambial ***/
        RUN pi_achar_cotac_indic_econ (INPUT operac_financ.cod_indic_econ,
                                       INPUT "Real",
                                       INPUT INPUT FRAME f_apl v_data_corte,
                                       INPUT "Real" /*l_real*/,
                                       OUTPUT v_dat_cotac_indic_econ,
                                       OUTPUT v_val_cotac_indic_econ,
                                       OUTPUT v_cod_return) /*pi_achar_cotac_indic_econ*/.

        ASSIGN v_val_parc_pagto                           = tt_parc_operac_financ.val_parc_pagto
               tt_parc_operac_financ.val_parc_pagto       = tt_parc_operac_financ.val_parc_pagto       * tt_cotac.tta_val_cotac
               tt_parc_operac_financ.val_princ_parc_pagto = tt_parc_operac_financ.val_princ_parc_pagto * tt_cotac.tta_val_cotac
               v_val_parc_pagto                           = tt_parc_operac_financ.val_parc_pagto       - (v_val_parc_pagto * (1 / v_val_cotac_indic_econ)).


/*zarpe
OUTPUT TO u:\valida-jur.txt APPEND.
PUT operac_financ.cod_indic_econ
    operac_financ.cod_banco        
    operac_financ.cod_produt_financ
    tt_cotac.tta_val_cotac.
EXPORT tt_parc_operac_financ.
OUTPUT CLOSE.
*/

        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = "PROJECAO PARCELA"
               tt_excel.tta_cod_tip_produt_financ        = "Emprest"
               tt_excel.tta_cod_agrup_produt_financ      = ""
               tt_excel.tta_cod_banco                    = operac_financ.cod_banco
               tt_excel.tta_cod_produt_financ            = operac_financ.cod_produt_financ
               tt_excel.tta_cod_operac_financ            = operac_financ.cod_operac_financ
               tt_excel.tta_cod_cta_corren               = cta_corren.cod_cta_corren
               tt_excel.tta_cod_estab                    = cta_corren.cod_estab
               tt_excel.tta_dat_movimento                = tt_parc_operac_financ.dat_vencto_parc
               tt_excel.tta_num_id_operac_financ         = operac_financ.num_id_operac_financ
               /* ** Totais da Proje‡Æo de Juros ***
               tt_excel.ttv_val_juros_curto_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte <= v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto  - tt_parc_operac_financ.val_princ_parc_pagto
                                                              ELSE 0
               tt_excel.ttv_val_juros_longo_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte  > v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto - tt_parc_operac_financ.val_princ_parc_pagto
                                                              ELSE 0
               tt_excel.ttv_val_juros_total              = tt_parc_operac_financ.val_parc_pagto - tt_parc_operac_financ.val_princ_parc_pagto*/
               /* ** Totais da Proje‡Æo das Parcelas ***/               
               tt_excel.ttv_val_pagto_curto_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte <= v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto
                                                              ELSE 0         
               tt_excel.ttv_val_pagto_longo_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte  > v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto
                                                              ELSE 0         
               tt_excel.ttv_val_pagto_total              = tt_parc_operac_financ.val_parc_pagto.  

        FIND int_produt_financ NO-LOCK
            WHERE int_produt_financ.cod_produt_financ = tt_excel.tta_cod_produt_financ NO-ERROR.
        IF AVAIL int_produt_financ 
           THEN ASSIGN tt_excel.tta_cod_agrup_produt_financ = int_produt_financ.tip_produt_financ.


        /* ** Criar registro para a varia‡Æo cambial ***/
        FIND b_tt_excel_cv NO-LOCK
            WHERE b_tt_excel_cv.tta_cod_tip_registro  = "PROJECAO VC"
              AND b_tt_excel_cv.tta_cod_banco         = tt_excel.tta_cod_banco
              AND b_tt_excel_cv.tta_cod_produt_financ = tt_excel.tta_cod_produt_financ
              AND b_tt_excel_cv.tta_cod_operac_financ = tt_excel.tta_cod_operac_financ NO-ERROR.
        IF NOT AVAIL b_tt_excel_cv 
        THEN DO:
             CREATE b_tt_excel_cv.
             ASSIGN b_tt_excel_cv.tta_cod_tip_registro        = "PROJECAO VC"
                    b_tt_excel_cv.tta_cod_banco               = tt_excel.tta_cod_banco              
                    b_tt_excel_cv.tta_cod_produt_financ       = tt_excel.tta_cod_produt_financ      
                    b_tt_excel_cv.tta_cod_operac_financ       = tt_excel.tta_cod_operac_financ      
                    b_tt_excel_cv.tta_cod_tip_produt_financ   = tt_excel.tta_cod_tip_produt_financ  
                    b_tt_excel_cv.tta_cod_agrup_produt_financ = tt_excel.tta_cod_agrup_produt_financ
                    b_tt_excel_cv.tta_dat_movimento           = v_data_corte + 1
                    b_tt_excel_cv.tta_cod_cta_corren          = tt_excel.tta_cod_cta_corren
                    b_tt_excel_cv.tta_cod_estab               = tt_excel.tta_cod_estab 
                    b_tt_excel_cv.tta_num_id_operac_financ    = tt_excel.tta_num_id_operac_financ.
        END.
        ASSIGN b_tt_excel_cv.ttv_val_pagto_total = b_tt_excel_cv.ttv_val_pagto_total + v_val_parc_pagto.

    END.
    /* ** Fim Tratamento para a leitura das Aplica‡äes e Empr‚stimos, Taxas e Parcelas ***/
END.

PROCEDURE pi_retorna_projecao_apl_fin:

    /* ** Tratamento para a leitura das Aplica‡äes e Empr‚stimos, Taxas e Parcelas ***/
    run prgfin/apl/apl313za.py (Input 1,
                                Input YES, /* v_log_operac_financ_com_sdo,*/
                                Input NO, /* v_log_mostra_operac_sem_sdo,*/
                                Input YES, /* v_log_mostra_operac_detdo,*/
                                Input v_qtd_dias_curto_praz, /* v_qtd_dias_curto_praz,*/
                                Input NO, /* v_log_mostra_movto_operac,*/
                                Input NO, /* v_log_mostra_tax_operac,*/
                                Input YES, /* v_log_mostra_despes_operac,*/
                                Input YES, /* v_log_mostra_parc_operac,*/
                                Input NO, /* v_log_mostra_docto_operac,*/
                                Input NO, /* v_log_mostra_gartia_operac,*/
                                Input NO, /* v_log_mostra_fiador_operac,*/
                                Input v_cod_banco_ini, /* v_cod_banco_ini,*/
                                Input v_cod_banco_fim, /* v_cod_banco_fim,*/
                                Input v_cod_produt_financ_ini, /* v_cod_produt_financ_ini,*/
                                Input v_cod_produt_financ_fim, /* v_cod_produt_financ_fim,*/
                                Input "", /*v_cod_operac_financ_ini,*/
                                INPUT "ZZZZZZZZZZZZZZZZZZZ", /*v_cod_operac_financ_fim,*/
                                Input 01/01/0001, /*v_dat_operac_financ_ini,*/
                                Input 12/31/9999, /*v_dat_operac_financ_fim,*/
                                Input 01/01/0001, /*v_dat_vencto_operac_financ_ini,*/
                                Input 12/31/9999, /*v_dat_vencto_operac_financ_fim,*/
                                output table tt_operac_financ,
                                output table tt_movto_operac_financ,
                                output table tt_indic_econ_operac_financ,
                                output table tt_despes_operac_financ,
                                output table tt_parc_operac_financ,
                                output table tt_documen_operac_financ,
                                output table tt_fiador_operac_financ,
                                output table tt_gartia_operac_financ,
                                Input "ZZZZZZZZZZZZZZZZZZZ", /*v_cod_tip_produt_financ_fim,*/
                                Input "", /*v_cod_tip_produt_financ_ini,*/
                                Input NO,
                                Input "",
                                Input "ZZZ").
    
    FOR EACH tt_despes_operac_financ:
        MESSAGE tt_despes_operac_financ.des_despes_operac tt_despes_operac_financ.ind_base_calc_despes tt_despes_operac_financ.ind_dat_despes_operac tt_despes_operac_financ.val_despes_operac tt_despes_operac_financ.val_perc_despes_operac
                tt_despes_operac_financ.tta_ind_forma_aprop_despes    
                tt_despes_operac_financ.ttv_val_despes                
                tt_despes_operac_financ.tta_val_cotac_contrat         
                tt_despes_operac_financ.tta_val_movto_indic_econ_movto VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    FOR EACH tt_parc_operac_financ:

        IF tt_parc_operac_financ.dat_vencto_parc < v_data_corte
        OR tt_parc_operac_financ.dat_vencto_parc > v_data_projecao 
           THEN NEXT.

        IF  tt_parc_operac_financ.ind_tip_parc_emprest <> "Pagamento"
        AND tt_parc_operac_financ.ind_tip_parc_emprest <> "Juros"
            THEN NEXT.

        FIND operac_financ NO-LOCK
            WHERE operac_financ.num_id_operac_financ = tt_parc_operac_financ.num_id_operac_financ NO-ERROR.

        FIND tt_resumo_apl
            WHERE tt_resumo_apl.tta_cod_banco         = operac_financ.cod_banco
              AND tt_resumo_apl.tta_cod_produt_financ = operac_financ.cod_produt_financ
              AND tta_cod_tip_produt_financ           = "Emprest"
              AND tta_cod_operac_financ               = operac_financ.cod_operac_financ NO-ERROR.
        IF NOT AVAIL tt_resumo_apl 
           THEN NEXT.

        FIND cta_corren NO-LOCK
            WHERE cta_corren.cod_cta_corren = operac_financ.cod_cta_corren_padr NO-ERROR.

        FIND tt_cotac NO-LOCK
            WHERE tt_cotac.tta_cod_indic_econ = operac_financ.cod_indic_econ NO-ERROR.
        
        ASSIGN tt_parc_operac_financ.val_parc_pagto       = tt_parc_operac_financ.val_parc_pagto       * tt_cotac.tta_val_cotac
               tt_parc_operac_financ.val_princ_parc_pagto = tt_parc_operac_financ.val_princ_parc_pagto * tt_cotac.tta_val_cotac.

        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = IF tt_parc_operac_financ.ind_tip_parc_emprest = "Pagamento"
                                                              THEN "PROJECAO PARCELA"
                                                              ELSE "PROJECAO JUROS"
               tt_excel.tta_cod_tip_produt_financ        = "Emprest"
               tt_excel.tta_cod_agrup_produt_financ      = ""
               tt_excel.tta_cod_banco                    = operac_financ.cod_banco
               tt_excel.tta_cod_produt_financ            = operac_financ.cod_produt_financ
               tt_excel.tta_cod_operac_financ            = operac_financ.cod_operac_financ
               tt_excel.tta_cod_cta_corren               = cta_corren.cod_cta_corren
               tt_excel.tta_cod_estab                    = cta_corren.cod_estab
               tt_excel.tta_dat_movimento                = tt_parc_operac_financ.dat_vencto_parc
               tt_excel.tta_num_id_operac_financ         = operac_financ.num_id_operac_financ
               /* ** Totais da Proje‡Æo de Juros ***/
               tt_excel.ttv_val_juros_curto_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte <= v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto  - tt_parc_operac_financ.val_princ_parc_pagto
                                                              ELSE 0
               tt_excel.ttv_val_juros_longo_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte  > v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto - tt_parc_operac_financ.val_princ_parc_pagto
                                                              ELSE 0
               tt_excel.ttv_val_juros_total              = tt_parc_operac_financ.val_parc_pagto - tt_parc_operac_financ.val_princ_parc_pagto
               /* ** Totais da Proje‡Æo das Parcelas ***/               
               tt_excel.ttv_val_pagto_curto_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte <= v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto
                                                              ELSE 0         
               tt_excel.ttv_val_pagto_longo_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte  > v_qtd_dias_curto_praz 
                                                              THEN tt_parc_operac_financ.val_parc_pagto
                                                              ELSE 0         
               tt_excel.ttv_val_pagto_total              = tt_parc_operac_financ.val_parc_pagto
               tt_excel.ttv_val_pagto_princ              = tt_parc_operac_financ.val_princ_parc_pagto.

        FIND int_produt_financ NO-LOCK
            WHERE int_produt_financ.cod_produt_financ = tt_excel.tta_cod_produt_financ NO-ERROR.
        IF AVAIL int_produt_financ 
           THEN ASSIGN tt_excel.tta_cod_agrup_produt_financ = int_produt_financ.tip_produt_financ.

        IF tt_excel.tta_cod_agrup_produt_financ = "FINIMP"
           THEN ASSIGN tt_excel.ttv_val_pagto_impto = tt_excel.ttv_val_juros_total * 0.15.

        /* ** Calculo Valor Despesas ***/
        /*tt_excel.ttv_val_pagto_desp*/

        ASSIGN tt_excel.ttv_val_desembolso = tt_excel.ttv_val_pagto_impto + tt_excel.ttv_val_pagto_desp + tt_excel.ttv_val_pagto_total.

    END.
    /* ** Fim Tratamento para a leitura das Aplica‡äes e Empr‚stimos, Taxas e Parcelas ***/
END.


PROCEDURE pi_retorna_projecao_juros_apl:

    DEFINE VARIABLE v_dat_fim_correc             AS DATE        NO-UNDO.
    DEFINE VARIABLE v_dat_inic_correc            AS DATE        NO-UNDO.
    DEFINE VARIABLE v_des_planilha_produt_financ AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_dat_prox_correc            AS DATE        NO-UNDO.
    DEFINE VARIABLE v_val_ftfin_atual            AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_log_correc_parcial         AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_ind_tip_tax_pos_fix        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_seq                    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_dat_fim_curto_praz         AS DATE        NO-UNDO.
    DEFINE VARIABLE v_val_sdo_princ_curto_praz   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_longo_ftfin        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_curto_ftfin        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_dat_inic_movimen           AS DATE        NO-UNDO.

    DEFINE VARIABLE v_data          AS DATE        NO-UNDO.
    DEFINE VARIABLE v_num_ano_refer AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_mes_refer AS INTEGER     NO-UNDO.

    DEF BUFFER b_movto_operac_financ FOR movto_operac_financ.

    /* ** cria movtos de corre‡Æo , juros e varia‡Æo ***/
    /*Zarpe*/
    FOR EACH tt_operac_financ 
        /* **
        WHERE tt_operac_financ.cod_banco         = "237"
          AND tt_operac_financ.cod_produt        = "finimp"
          AND tt_operac_financ.cod_operac_financ = "900078" ***/ :

        IF tt_operac_financ.ind_sit_operac_financ_apl = "Em Digita‡Æo"
           THEN RETURN.   
        
        FIND tt_resumo_apl
            WHERE tt_resumo_apl.tta_cod_banco         = tt_operac_financ.cod_banco
              AND tt_resumo_apl.tta_cod_produt_financ = tt_operac_financ.cod_produt_financ
              AND tta_cod_tip_produt_financ           = "Emprest"
              AND tta_cod_operac_financ               = tt_operac_financ.cod_operac_financ NO-ERROR.
        IF NOT AVAIL tt_resumo_apl 
           THEN NEXT.

        FIND cta_corren NO-LOCK
            WHERE cta_corren.cod_cta_corren = tt_operac_financ.cod_cta_corren_padr NO-ERROR.

        FIND tt_cotac NO-LOCK
            WHERE tt_cotac.tta_cod_indic_econ = tt_operac_financ.cod_indic_econ NO-ERROR.

        IF tt_operac_financ.dat_vencto_operac_financ < v_data_projecao
           THEN ASSIGN v_dat_fim_correc = tt_operac_financ.dat_vencto_operac_financ. 
           ELSE ASSIGN v_dat_fim_correc = v_data_projecao. 
    
        ASSIGN v_dat_inic_correc = v_data_corte + 1.
    
        FIND produt_financ NO-LOCK
            WHERE produt_financ.cod_produt_financ = tt_operac_financ.cod_produt_financ NO-ERROR.
    
        FIND FIRST produt_financ_bco NO-LOCK 
             WHERE produt_financ_bco.cod_produt_financ = tt_operac_financ.cod_produt_financ
               AND produt_financ_bco.cod_banco         = tt_operac_financ.cod_banco
               AND produt_financ_bco.dat_fim_valid    >= v_dat_fim_correc
               AND produt_financ_bco.dat_inic_valid   <= v_dat_fim_correc NO-ERROR.
    
        ASSIGN v_val_sdo_princ_operac_financ = tt_operac_financ.val_livre_1.
    
        IF  AVAIL produt_financ_bco
        AND produt_financ_bco.nom_arq_planilha_calc_juros <> "" 
            THEN ASSIGN v_des_planilha_produt_financ = produt_financ_bco.nom_arq_planilha_calc_juros.
            ELSE ASSIGN v_des_planilha_produt_financ = produt_financ.nom_arq_planilha_calc_juros.
    
        ASSIGN v_dat_prox_correc = tt_operac_financ.dat_prox_aniver_aplic.
    
        FOR EACH tt_correcoes:
            DELETE tt_correcoes.
        END.  

        IF v_dat_inic_correc < v_dat_fim_correc 
        THEN DO:
             RUN prgfin/apl/apl731za.py (INPUT 1,
                                         INPUT v_des_planilha_produt_financ,
                                         INPUT produt_financ.cod_produt_financ,
                                         INPUT tt_operac_financ.cod_indic_econ_orig_apl,
                                         INPUT v_dat_inic_correc,
                                         INPUT v_dat_fim_correc,
                                         INPUT tt_operac_financ.num_id_operac_financ,
                                         INPUT tt_operac_financ.ind_ump_produt_financ,
                                         INPUT produt_financ.ind_tip_freq_apl,
                                         INPUT produt_financ.ind_tip_dia_calc_juros,
                                         INPUT tt_operac_financ.val_ftfin_atlzdo,
                                         INPUT 0,
                                         INPUT "",
                                         INPUT "",
                                         INPUT 0,
                                         INPUT 0,
                                         INPUT 0,
                                         INPUT "Real",
                                         INPUT tt_operac_financ.val_sdo_operac_financ,
                                         INPUT tt_operac_financ.cod_atrib_utiliz_usuar_1,
                                         INPUT tt_operac_financ.cod_atrib_utiliz_usuar_2,
                                         INPUT tt_operac_financ.cod_atrib_utiliz_usuar_3,
                                         INPUT tt_operac_financ.cod_atrib_utiliz_usuar_4,
                                         INPUT tt_operac_financ.cod_atrib_utiliz_usuar_5,
                                         INPUT yes,
                                         INPUT "Financeira",
                                         INPUT tt_operac_financ.val_resid_operac_financ,
                                         INPUT-OUTPUT v_dat_prox_correc,
                                         OUTPUT v_val_ftfin_atual,
                                         OUTPUT TABLE tt_correcoes,
                                         OUTPUT TABLE tt_erros_correc,
                                         INPUT v_val_sdo_princ_operac_financ,
                                         INPUT v_log_correc_parcial,
                                         INPUT v_ind_tip_tax_pos_fix,
                                         OUTPUT TABLE tt_imposto_apl).
        END.
    
        ASSIGN v_num_seq = 1.
    
        FOR EACH tt_correcoes NO-LOCK:
                
                IF tt_correcoes.ttv_dat_correc <= v_data_corte
                OR tt_correcoes.ttv_dat_correc  > v_data_projecao 
                   THEN NEXT.

                bloco_seq:
                REPEAT:
                    FIND FIRST tt_movto_operac_financ NO-LOCK 
                         WHERE tt_movto_operac_financ.num_id_operac_financ        = tt_operac_financ.num_id_operac_financ
                           AND tt_movto_operac_financ.num_seq_movto_operac_financ = v_num_seq  NO-ERROR.
    
                    IF NOT AVAIL tt_movto_operac_financ 
                       THEN FIND FIRST tt_movto_operac_financ NO-LOCK 
                                 WHERE tt_movto_operac_financ.num_id_movto_operac_financ = v_num_seq  NO-ERROR.
    
                    IF AVAIL tt_movto_operac_financ 
                       THEN ASSIGN v_num_seq = v_num_seq + 1.
                       ELSE LEAVE bloco_seq.
                END.
    
                /* ** Calcula o £ltimo dia do mˆs de Referˆncia ***/
                ASSIGN v_data = DATE("01" + STRING(MONTH(tt_correcoes.ttv_dat_correc), "99") + STRING(YEAR(tt_correcoes.ttv_dat_correc), "9999")).
                /* ** Posiciona um mˆs a frente ***/
                ASSIGN v_num_ano_refer = YEAR(v_data)
                       v_num_mes_refer = MONTH(v_data) + 1.
                IF v_num_mes_refer = 13
                   THEN ASSIGN v_num_mes_refer = 1
                               v_num_ano_refer = v_num_ano_refer + 1.
                /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
                ASSIGN v_data = DATE('01' + STRING(v_num_mes_refer, '99') + STRING(v_num_ano_refer, '9999'))
                       v_data = v_data - 1.

                FIND tt_excel
                   WHERE tt_excel.tta_num_id_operac_financ = tt_operac_financ.num_id_operac_financ
                     AND tt_excel.tta_cod_tip_registro     = "PROJECAO JUROS"
                     AND tt_excel.tta_dat_movimento        = v_data NO-ERROR.

                IF NOT AVAIL tt_excel 
                THEN DO:

                     CREATE tt_excel.
                     ASSIGN tt_excel.tta_cod_tip_registro             = "PROJECAO JUROS"
                            tt_excel.tta_cod_tip_produt_financ        = "Emprest"
                            tt_excel.tta_cod_agrup_produt_financ      = ""
                            tt_excel.tta_cod_banco                    = tt_operac_financ.cod_banco
                            tt_excel.tta_cod_produt_financ            = tt_operac_financ.cod_produt_financ
                            tt_excel.tta_cod_operac_financ            = tt_operac_financ.cod_operac_financ
                            tt_excel.tta_cod_cta_corren               = cta_corren.cod_cta_corren
                            tt_excel.tta_cod_estab                    = cta_corren.cod_estab
                            tt_excel.tta_dat_movimento                = v_data
                            tt_excel.tta_num_id_operac_financ         = tt_operac_financ.num_id_operac_financ
                            /* ** Totais da Proje‡Æo das Parcelas ***
                            tt_excel.ttv_val_pagto_curto_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte <= v_qtd_dias_curto_praz 
                                                                           THEN tt_parc_operac_financ.val_parc_pagto
                                                                           ELSE 0         
                            tt_excel.ttv_val_pagto_longo_praz         = IF tt_parc_operac_financ.dat_vencto_parc - v_data_corte  > v_qtd_dias_curto_praz 
                                                                           THEN tt_parc_operac_financ.val_parc_pagto
                                                                           ELSE 0         
                            tt_excel.ttv_val_pagto_total              = tt_parc_operac_financ.val_parc_pagto*/.  
                            
                     FIND int_produt_financ NO-LOCK
                         WHERE int_produt_financ.cod_produt_financ = tt_excel.tta_cod_produt_financ NO-ERROR.
                     IF AVAIL int_produt_financ 
                        THEN ASSIGN tt_excel.tta_cod_agrup_produt_financ = int_produt_financ.tip_produt_financ.

                END.

                /* ** Totais da Proje‡Æo de Juros ***/
                ASSIGN tt_excel.ttv_val_juros_curto_praz         = IF v_data - v_data_corte <= v_qtd_dias_curto_praz 
                                                                      THEN tt_excel.ttv_val_juros_curto_praz + tt_correcoes.ttv_val_juros_apl_1 + tt_correcoes.ttv_val_comis_delcred
                                                                      ELSE 0
                       tt_excel.ttv_val_juros_longo_praz         = IF v_data - v_data_corte > v_qtd_dias_curto_praz 
                                                                      THEN tt_excel.ttv_val_juros_longo_praz + tt_correcoes.ttv_val_juros_apl_1 + tt_correcoes.ttv_val_comis_delcred
                                                                      ELSE 0
                       tt_excel.ttv_val_juros_total              = tt_excel.ttv_val_juros_total + tt_correcoes.ttv_val_juros_apl_1 + tt_correcoes.ttv_val_comis_delcred.

        END.
    
    END.

END.

PROCEDURE pi_retorna_projecao_parcela_juros_apl:

    DEF BUFFER b_tt_excel_parc  FOR tt_excel.
    DEF BUFFER b_tt_excel_juros FOR tt_excel.

    FOR EACH b_tt_excel_parc
        WHERE b_tt_excel_parc.tta_cod_tip_registro = "PROJECAO PARCELA":

        FOR EACH b_tt_excel_juros
            WHERE b_tt_excel_juros.tta_num_id_operac_financ = b_tt_excel_parc.tta_num_id_operac_financ
              AND b_tt_excel_juros.tta_cod_tip_registro     = "PROJECAO JUROS"
              AND MONTH(b_tt_excel_juros.tta_dat_movimento) = MONTH(b_tt_excel_parc.tta_dat_movimento):
            
            FIND tt_excel
               WHERE tt_excel.tta_num_id_operac_financ = b_tt_excel_parc.tta_num_id_operac_financ
                 AND tt_excel.tta_cod_tip_registro     = "PROJECAO PARCELA + JUROS"
                 AND tt_excel.tta_dat_movimento        = b_tt_excel_parc.tta_dat_movimento NO-ERROR.
            IF NOT AVAIL tt_excel 
            THEN DO:
                 CREATE tt_excel.
                 BUFFER-COPY b_tt_excel_parc TO tt_excel.
                 ASSIGN tt_excel.tta_cod_tip_registro     = "PROJECAO PARCELA + JUROS".
            END.
             /* ** Totais da Proje‡Æo das Parcelas + Juros ***/               
            ASSIGN tt_excel.ttv_val_pagto_curto_praz = tt_excel.ttv_val_pagto_curto_praz + b_tt_excel_juros.ttv_val_juros_curto_praz
                   tt_excel.ttv_val_pagto_longo_praz = tt_excel.ttv_val_pagto_longo_praz + b_tt_excel_juros.ttv_val_juros_longo_praz
                   tt_excel.ttv_val_pagto_total      = tt_excel.ttv_val_pagto_total      + b_tt_excel_juros.ttv_val_juros_total.
  
        END.

    END.
  
END.

PROCEDURE pi_retorna_sdo_inicial_cmg:
    /* ** Retorna saldos das contas correntes  ***/
    FOR EACH cta_corren NO-LOCK:
        /* ** Incorpora‡Æo da empresa como filial ***/
        IF cta_corren.cod_estab = "201" 
           THEN NEXT.
        /* ** Verifica se a conta pertence ao grupo cont bil 111, caso contr rio nÆo est  dispon¡vel ***/
        FIND FIRST cta_corren_cta_ctbl NO-LOCK 
             WHERE cta_corren_cta_ctbl.cod_cta_corren               = cta_corren.cod_cta_corren
               AND cta_corren_cta_ctbl.ind_finalid_ctbl_cta_corren  = "Principal Ativo"
               AND cta_corren_cta_ctbl.dat_inic_valid              <= v_data_corte
               AND cta_corren_cta_ctbl.dat_fim_valid               >= v_data_corte NO-ERROR.
        IF NOT AVAIL cta_corren_cta_ctbl
        OR NOT cta_corren_cta_ctbl.cod_cta_ctbl BEGINS "111"
           THEN NEXT.
    
        RUN prgfin/cmg/cmg733zs.py (Input 1,
                                    Input cta_corren.cod_cta_corren,
                                    Input "",
                                    Input v_data_corte,
                                    Input "Empresa",
                                    output v_val_sdo_real_inic,
                                    output v_val_sdo_nreal_inic,
                                    output v_val_sdo_bcio_inic).

        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = "SDO INIC CMG"
               tt_excel.tta_cod_tip_produt_financ        = ""
               tt_excel.tta_cod_agrup_produt_financ      = ""
               tt_excel.tta_cod_banco                    = cta_corren.cod_banco
               tt_excel.tta_cod_produt_financ            = ""
               tt_excel.tta_cod_operac_financ            = ""
               tt_excel.tta_cod_cta_corren               = cta_corren.cod_cta_corren
               tt_excel.tta_cod_estab                    = cta_corren.cod_estab
               tt_excel.tta_dat_movimento                = v_data_corte.

        IF v_val_sdo_real_inic = 0 
        THEN ASSIGN tt_excel.ttv_val_operac_financ_total = 0.
        ELSE DO: 
            
             IF cta_corren.cod_finalid_econ <> "Corrente" 
             THEN DO:
                  run pi_retornar_indic_econ_finalid (Input cta_corren.cod_finalid_econ,
                                                      Input v_data_corte,
                                                      output v_cod_indic_econ_aux) /*pi_retornar_indic_econ_finalid*/.
    
                  run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_aux,
                                                 Input "Real",
                                                 Input v_data_corte,
                                                 Input "Real" /*l_real*/,
                                                 output v_dat_cotac_indic_econ,
                                                 output v_val_cotac_indic_econ,
                                                 output v_cod_return) /*pi_achar_cotac_indic_econ*/.
             END.
             ELSE ASSIGN v_val_cotac_indic_econ = 1.
    
             ASSIGN tt_excel.ttv_val_operac_financ_total = v_val_sdo_real_inic / v_val_cotac_indic_econ.
    
        END.
    END.
    /* ** Fim retorno saldo contas correntes ***/ 

END.

PROCEDURE pi_rpt_resumo_apl_emprestimos:
    
    block_operac_financ_2:
    for each operac_financ no-lock                
        where operac_financ.cod_empresa             = emscad.empresa.cod_empresa
        and   operac_financ.ind_operac_financ       = "Empr‚stimo"
        and   (operac_financ.ind_sit_operac_financ     = "Ativa" OR
               operac_financ.ind_sit_operac_financ_apl = "Encerrada")
        and   operac_financ.cod_banco             >= v_cod_banco_ini
        and   operac_financ.cod_banco             <= v_cod_banco_fim
        and   operac_financ.cod_produt_financ     >= v_cod_produt_financ_ini
        and   operac_financ.cod_produt_financ     <= v_cod_produt_financ_fim:
    
        find produt_financ no-lock
            where produt_financ.cod_produt_financ = operac_financ.cod_produt_financ no-error.
    
        if v_data_corte < operac_financ.dat_operac_financ then 
          next block_operac_financ_2.
    
        /* recompor o saldo ate dt referencia - mantido pois retorna o saldo do principal e valida cota‡Æo */
        run prgfin/apl/apl757zb.py (Input 1,
                                    Input (v_data_corte),
                                    Input operac_financ.num_id_operac_financ,
                                    output v_val_sdo_dat,
                                    output v_val_sdo_princ_operac_financ,
                                    Input "FISCAL").
    
        /* chama para considerar os movtos de varia‡Æo cambial */   
        run prgfin/apl/apl767za.py (Input 1,
                                    Input (v_data_corte),
                                    Input operac_financ.num_id_operac_financ,
                                    Input "Real",
                                    output v_val_acum_apl,
                                    output table tt_log_erro,
                                    Input "FISCAL",
                                    output v_val_movto_sdo_princ).
    
        find first tt_log_erro no-error.
        if avail tt_log_erro then do:
            create tt_log_erros_apl_emp.
            assign tt_log_erros_apl_emp.ttv_num_cod_erro      = tt_log_erro.ttv_num_cod_erro
                   tt_log_erros_apl_emp.ttv_des_msg_ajuda     = tt_log_erro.ttv_des_msg_ajuda
                   tt_log_erros_apl_emp.ttv_des_msg_erro      = tt_log_erro.ttv_des_msg_erro 
                   tt_log_erros_apl_emp.tta_cod_banco         = operac_financ.cod_banco
                   tt_log_erros_apl_emp.tta_cod_produt_financ = operac_financ.cod_produt_financ
                   tt_log_erros_apl_emp.tta_cod_operac_financ = operac_financ.cod_operac_financ 
                   tt_log_erros_apl_emp.tta_dat_transacao     = ?
                   tt_log_erros_apl_emp.tta_ind_tip_trans_apl = "Saldo Inicial" /*l_saldo_inicial*/ .
            next block_operac_financ_2.
        end.
    
        assign v_val_cotac_indic_econ = 0.
        if v_val_acum_apl <> 0 then 
            assign v_val_cotac_indic_econ  = v_val_sdo_dat / v_val_acum_apl .  /* sdo moeda emprestimo/sdo moeda apresenta‡Æo  */
    
        /* Verifica-se se ‚ necessario converter o v_val_sdo_princ_operac_financ para a moeda de apresentacao */
        if  operac_financ.cod_indic_econ_orig_apl <> "Real"
        then do:
            /* converte para cota‡Æo calculada e nÆo nais informada */
            assign v_val_convtdo_apl = 0.
            if v_val_cotac_indic_econ  <> 0 then do:
               assign v_val_convtdo_apl = v_val_sdo_princ_operac_financ / v_val_cotac_indic_econ.
            end.
        end.
        else do:
            assign v_val_convtdo_apl  = v_val_sdo_princ_operac_financ.
        end.
    
        if v_val_acum_apl = 0 then 
           next block_operac_financ_2.
    
        create tt_resumo_apl.
        assign tt_resumo_apl.tta_ind_operac_financ        = "Empr‚stimo" /*l_emprestimo*/ 
               tt_resumo_apl.tta_cod_banco                = operac_financ.cod_banco
               tt_resumo_apl.tta_cod_produt_financ        = operac_financ.cod_produt_financ
               tt_resumo_apl.tta_cod_tip_produt_financ    = produt_financ.cod_tip_produt_financ
               tt_resumo_apl.tta_cod_operac_financ        = operac_financ.cod_operac_financ
               tt_resumo_apl.tta_dat_operac_financ        = operac_financ.dat_operac_financ
               tt_resumo_apl.tta_dat_vencto_operac_financ = operac_financ.dat_vencto_operac_financ
               tt_resumo_apl.ttv_val_operac_financ        = v_val_acum_apl
               tt_resumo_apl.ttv_val_tot_aplic_dispon     = 0
               tt_resumo_apl.ttv_val_tot_aplic_carenc     = 0
               tt_resumo_apl.ttv_val_emprest_curto_praz   = 0
               tt_resumo_apl.ttv_val_sdo_longo_praz       = 0 
               tt_resumo_apl.ttv_val_sdo_princ            = v_val_convtdo_apl. 
    
    
        run prgfin/apl/apl717zb.py (Input 1,
                                    Input operac_financ.num_id_operac_financ,
                                    Input v_data_corte,
                                    Input "FISCAL",
                                    Input v_qtd_dias_curto_praz,
                                    output v_val_emprest_curto_praz,
                                    output v_val_sdo_longo_praz,
                                    output v_val_sdo_juros_longo_praz,
                                    output v_val_sdo_juros_curto_praz) /*prg_api_calc_sdo_curto_longo_prazo*/.
    
        /* Verifica-se se ‚ necessario converter o valor para a moeda de apresentacao */    
        if  operac_financ.cod_indic_econ_orig_apl <> "Real"
        then do:
            assign v_val_acum_aux  = 0.
            if v_val_cotac_indic_econ  <> 0 then do:
                assign v_val_acum_aux = v_val_emprest_curto_praz / v_val_cotac_indic_econ.
            end.
        end.
        else do:
            assign v_val_acum_aux = v_val_emprest_curto_praz.
        end.
    
        assign v_val_emprest_curto_praz = v_val_acum_aux .
    
        /* Verifica-se se ‚ necessario converter o valor para a moeda de apresentacao */
        if  operac_financ.cod_indic_econ_orig_apl <> "Real"
        then do:
            assign v_val_acum_aux  = 0.
            if v_val_cotac_indic_econ  <> 0 then do:
                assign v_val_acum_aux  = v_val_sdo_longo_praz / v_val_cotac_indic_econ.
            end.
        end.
        else do:
            assign v_val_acum_aux = v_val_sdo_longo_praz.
        end.
    
        assign v_val_sdo_longo_praz = v_val_acum_aux.
    
        assign tt_resumo_apl.ttv_val_emprest_curto_praz = v_val_emprest_curto_praz.
    
        assign tt_resumo_apl.ttv_val_sdo_longo_praz = v_val_sdo_longo_praz.
    
    end.

END.

PROCEDURE pi_rpt_resumo_apl_aplicacoes:

    block_operac_financ:
    for each operac_financ no-lock
        where operac_financ.cod_empresa            = emscad.empresa.cod_empresa
        and   operac_financ.ind_operac_financ      = "Aplica‡Æo" 
        and   (operac_financ.ind_sit_operac_financ     = "Ativa"  OR
               operac_financ.ind_sit_operac_financ_apl = "Encerrada")
        and   operac_financ.cod_banco             >= v_cod_banco_ini
        and   operac_financ.cod_banco             <= v_cod_banco_fim
        and   operac_financ.cod_produt_financ     >= v_cod_produt_financ_ini
        and   operac_financ.cod_produt_financ     <= v_cod_produt_financ_fim:   

        if v_data_corte < operac_financ.dat_operac_financ then 
               next block_operac_financ.

        find produt_financ no-lock
            where produt_financ.cod_produt_financ = operac_financ.cod_produt_financ no-error.

        /* Verifica-se se ‚ necessario converter o val_sdo_operac_financ para a moeda de apresentacao */
        run prgfin/apl/apl757za.py (Input 1,
                                    Input (v_data_corte ),
                                    Input operac_financ.num_id_operac_financ,
                                    output v_val_sdo_dat,
                                    output v_val_sdo_princ_operac_financ,
                                    Input "FISCAL") /*prg_api_recompor_saldo_aplicacao*/.

        /* chama para considerar os movtos de varia‡Æo cambial */   
        run prgfin/apl/apl766za.py (Input 1,
                                    Input (v_data_corte ),
                                    Input operac_financ.num_id_operac_financ,
                                    Input "Real",
                                    output v_val_acum_apl,
                                    output table tt_log_erro,
                                    Input "FISCAL",
                                    output v_val_movto_sdo_princ) /*prg_api_recompor_saldo_aplicacao_moeda*/.

        find first tt_log_erro no-error.
        if avail tt_log_erro then do:
            create tt_log_erros_apl_emp.
            assign tt_log_erros_apl_emp.ttv_num_cod_erro      = tt_log_erro.ttv_num_cod_erro
                   tt_log_erros_apl_emp.ttv_des_msg_ajuda     = tt_log_erro.ttv_des_msg_ajuda
                   tt_log_erros_apl_emp.ttv_des_msg_erro      = tt_log_erro.ttv_des_msg_erro 
                   tt_log_erros_apl_emp.tta_cod_banco         = operac_financ.cod_banco
                   tt_log_erros_apl_emp.tta_cod_produt_financ = operac_financ.cod_produt_financ
                   tt_log_erros_apl_emp.tta_cod_operac_financ = operac_financ.cod_operac_financ 
                   tt_log_erros_apl_emp.tta_dat_transacao     = ?
                   tt_log_erros_apl_emp.tta_ind_tip_trans_apl = "Saldo Inicial" /*l_saldo_inicial*/ .
            next block_operac_financ.
        end.   

        assign v_val_cotac_indic_econ = 0.
        if v_val_acum_apl <> 0 then 
            assign v_val_cotac_indic_econ  = v_val_sdo_dat / v_val_acum_apl .  /* sdo moeda aplicacao /sdo moeda apresenta‡Æo  */

        /* Verifica-se se e necessario converter o v_val_sdo_princ_operac_financ para a moeda de apresentacao */
        if operac_financ.cod_indic_econ_orig_apl <> "Real" then do:    
            assign v_val_convtdo_apl = 0.
            if v_val_cotac_indic_econ  <> 0 then do:
                assign v_val_convtdo_apl = v_val_sdo_princ_operac_financ / v_val_cotac_indic_econ.
            end.
        end.
        else
            assign v_val_convtdo_apl  = v_val_sdo_princ_operac_financ.

        if v_val_acum_apl = 0 then 
           next block_operac_financ.

        create tt_resumo_apl.
        assign tt_resumo_apl.tta_ind_operac_financ        = "Aplica‡Æo" /*l_aplicacao*/ 
               tt_resumo_apl.tta_cod_banco                = operac_financ.cod_banco
               tt_resumo_apl.tta_cod_produt_financ        = operac_financ.cod_produt_financ
               tt_resumo_apl.tta_cod_tip_produt_financ    = produt_financ.cod_tip_produt_financ
               tt_resumo_apl.tta_cod_operac_financ        = operac_financ.cod_operac_financ
               tt_resumo_apl.tta_dat_operac_financ        = operac_financ.dat_operac_financ
               tt_resumo_apl.tta_dat_vencto_operac_financ = operac_financ.dat_vencto_operac_financ
               tt_resumo_apl.ttv_val_operac_financ        = v_val_acum_apl
               tt_resumo_apl.ttv_val_tot_aplic_dispon     = 0
               tt_resumo_apl.ttv_val_tot_aplic_carenc     = 0
               tt_resumo_apl.ttv_val_emprest_curto_praz   = 0
               tt_resumo_apl.ttv_val_sdo_longo_praz       = 0
               tt_resumo_apl.ttv_val_sdo_princ            = v_val_convtdo_apl.

        if operac_financ.dat_term_carenc_aplic > v_data_corte
           then assign tt_resumo_apl.ttv_val_tot_aplic_carenc = v_val_acum_apl.
           else assign tt_resumo_apl.ttv_val_tot_aplic_dispon = v_val_acum_apl.

    end.
END PROCEDURE. /* pi_rpt_resumo_apl_aplicacoes */

PROCEDURE pi_retorna_novos_emprestimos:

    DEFINE VARIABLE v_cont AS INTEGER NO-UNDO.

    FOR EACH tt_excel_novos:

        ASSIGN v_cont = v_cont + 1.

        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = "SDO INIC APL NOVOS"
               tt_excel.tta_cod_tip_produt_financ        = "Emprest"
               tt_excel.tta_cod_agrup_produt_financ      = ""
               tt_excel.tta_cod_banco                    = tt_excel_novos.tta_cod_banco
               tt_excel.tta_cod_produt_financ            = tt_excel_novos.tta_cod_produt_financ
               tt_excel.tta_cod_estab                    = tt_excel_novos.tta_cod_estab
               tt_excel.tta_dat_movimento                = tt_excel_novos.tta_dat_movimento
               tt_excel.tta_num_id_operac_financ         = v_cont
               tt_excel.ttv_val_operac_financ_total      = tt_excel_novos.ttv_val_operac_financ_curto_praz + tt_excel_novos.ttv_val_operac_financ_longo_praz
               tt_excel.ttv_val_operac_financ_curto_praz = tt_excel_novos.ttv_val_operac_financ_curto_praz
               tt_excel.ttv_val_operac_financ_longo_praz = tt_excel_novos.ttv_val_operac_financ_longo_praz.

        CREATE tt_excel.
        ASSIGN tt_excel.tta_cod_tip_registro             = "PROJECAO NOVOS"
               tt_excel.tta_cod_tip_produt_financ        = "Emprest"
               tt_excel.tta_cod_banco                    = tt_excel_novos.tta_cod_banco
               tt_excel.tta_cod_produt_financ            = tt_excel_novos.tta_cod_produt_financ
               tt_excel.tta_cod_estab                    = tt_excel_novos.tta_cod_estab
               tt_excel.tta_dat_movimento                = tt_excel_novos.tta_dat_movimento
               tt_excel.tta_num_id_operac_financ         = v_cont
               tt_excel.ttv_val_juros_total              = tt_excel_novos.ttv_val_juros_curto_praz + tt_excel_novos.ttv_val_juros_longo_praz
               tt_excel.ttv_val_juros_curto_praz         = tt_excel_novos.ttv_val_juros_curto_praz
               tt_excel.ttv_val_juros_longo_praz         = tt_excel_novos.ttv_val_juros_longo_praz
               tt_excel.ttv_val_pagto_total              = tt_excel_novos.ttv_val_pagto_curto_praz + tt_excel_novos.ttv_val_pagto_longo_praz
               tt_excel.ttv_val_pagto_curto_praz         = tt_excel_novos.ttv_val_pagto_curto_praz
               tt_excel.ttv_val_pagto_longo_praz         = tt_excel_novos.ttv_val_pagto_longo_praz.

        CREATE tt_indic_econ_operac_financ.
        ASSIGN tt_indic_econ_operac_financ.num_id_operac_financ        = v_cont
               tt_indic_econ_operac_financ.cod_indic_econ_operac       = tt_excel_novos.tta_cod_indic_econ_operac
               tt_indic_econ_operac_financ.dat_inic_valid              = tt_excel_novos.tta_dat_inic_valid             
               tt_indic_econ_operac_financ.dat_fim_valid               = tt_excel_novos.tta_dat_fim_valid              
               tt_indic_econ_operac_financ.ind_capitaliz_indic_econ    = tt_excel_novos.tta_ind_capitaliz_indic_econ    
               tt_indic_econ_operac_financ.ind_ump_tax_juros           = tt_excel_novos.tta_ind_ump_tax_juros          
               tt_indic_econ_operac_financ.val_tax_juros_operac_financ = tt_excel_novos.tta_val_tax_juros_operac_financ.

    END.

END. /* pi_retorna_novos_emprestimos */

PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
         use-index hstrfnld_id
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */

PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/NÆo"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* altera‡Æo sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o Öndice forem iguais, significa que a cota‡Æo pode ser percentual,
         portanto nÆo basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder¡amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               v_log_indic     = yes.
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cota‡Æo Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */

