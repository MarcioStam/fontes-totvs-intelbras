/*****************************************************************************
** Programa..............: apb711zd_epc.p
** Descricao.............: EPC do programa fnc_item_lote_pagto_inclui_conjto
** Criado em.............: 19/10/2004.
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.
define variable wh_button2        as widget-handle  no-undo.
define variable wh_button3        as widget-handle  no-undo.
define variable wh_button4        as widget-handle  no-undo.
define variable wh_button5        as widget-handle  no-undo.
define variable wh_button6        as widget-handle  no-undo.
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.
define variable h_epc_apb711zd    as widget-handle  no-undo.
DEFINE VARIABLE wgh-BROWSE-pagto  AS WIDGET-HANDLE  NO-UNDO.

DEF VAR H-ZD5 AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE l-todos-apb711zd           AS LOG INIT NO    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_br_pagto_conjunto        AS widget-handle no-undo. 
DEFINE NEW GLOBAL SHARED VARIABLE h_br_dlg_item_bord_ap_cjto AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE h_br_dlg_liberados         AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query                  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer                 AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE hitem_bord_ap              AS widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh_bt_tot_apb711zd         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh_new_bt_tot_apb711zd     AS WIDGET-HANDLE NO-UNDO.
define new global shared variable h-programa                 as handle        no-undo.
define new global shared variable wgh-window                 as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh_bt_todos_apb711zd       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh_new_bt_todos_apb711zd   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh_bt_nenhum_apb711zd      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh_new_bt_nenhum_apb711zd  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h_bt_det1                  AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh_bt_det1_epc             AS WIDGET-HANDLE NO-UNDO.

def new global shared var v_rec_bord_ap_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

def var v_log_impto_vincul_refer
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.

def var v_val_tot_impto
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total a Ratear"
    column-label "Valor Total a Ratear"
    no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE h_apb711zd  AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_apb711zd4 AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_apb711zd6 AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_apb711zd8 AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_apb711zd9 AS HANDLE      NO-UNDO.
DEFINE VARIABLE                   i-linha     AS INT         NO-UNDO.

def new global shared var v_rec_banco
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.

def var v_val_total
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total %"
    column-label "Valor Total"
    no-undo.

DEF BUFFER b_item_bord_ap FOR item_bord_ap.

def temp-table tt_tot_pagto no-undo
    field ttv_val_total                    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Total %" column-label "Valor Total"
    field ttv_val_tot_pend_1               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 column-label "Total Pendente"
    FIELD cod_indic_econ                   AS CHAR FORMAT "x(8)" COLUMN-LABEL "Moeda".

def shared temp-table tt_pagamentos_realizados no-undo
    field ttv_rec_item_lote_pagto          as recid format ">>>>>>9"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    index tt_recid_tit_ap                 
          ttv_rec_tit_ap                   ascending
    .

def shared temp-table tt_titulo_antecip_pef_a_pagar no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_ser_docto                as character format "x(5)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_tit_ap                   as character format "x(16)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_prepar_pagto             as date format "99/99/9999" initial ? label "Data Prepar Pagto" column-label "Dat Prepar"
    field tta_dat_liber_pagto              as date format "99/99/9999" initial ? label "Data Liber Pagto" column-label "Dat  Liber"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_refer_antecip_pef        as character format "x(10)" label "Ref Antec PEF Pend" column-label "Ref Antec PEF Pend"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_num_seq_pagto_tit_ap         as integer format ">9" initial 0 label "Sequància" column-label "Seq"
    field ttv_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_val_pagto_moe                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagto Moeda" column-label "Valor Pagto Moeda"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field ttv_rec_proces_pagto             as recid format ">>>>>>9" initial ?
    field ttv_log_mostra_tit               as logical format "Sim/N∆o" initial yes label "T°tulo" column-label "T°tulo"
    field ttv_ind_sit_prepar_liber         as character format "X(03)" label "Situaá∆o" column-label "Sit"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_cod_classif_1                as character format "x(8)"
    field ttv_cod_classif_2                as character format "x(8)"
    field ttv_cod_classif_3                as character format "x(8)"
    field ttv_cod_classif_4                as character format "x(8)"
    field ttv_cod_classif_5                as character format "x(8)"
    field ttv_cod_classif_6                as character format "x(8)"
    field ttv_cod_classif_7                as character format "x(8)"
    field ttv_cod_classif_8                as character format "x(8)"
    field tta_cod_safra                    as character format "9999/9999" label "Safra" column-label "Safra"
    field tta_cod_contrat_graos            as character format "x(20)" label "Contrato Gr∆os" column-label "Contr Gr∆os"
    index tt_cdn_fornec                   
          tta_cdn_fornecedor               ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_cod_classif                  
          ttv_cod_classif_1                ascending
          ttv_cod_classif_2                ascending
          ttv_cod_classif_3                ascending
          ttv_cod_classif_4                ascending
          ttv_cod_classif_5                ascending
          ttv_cod_classif_6                ascending
          ttv_cod_classif_7                ascending
          ttv_cod_classif_8                ascending
    index tt_cod_forma_pagto              
          tta_cod_forma_pagto              ascending
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_cod_refer                    
          tta_cod_refer                    ascending
    index tt_cod_tit_ap                   
          tta_cod_tit_ap                   ascending
    index tt_dat_prev_pagto               
          tta_dat_prev_pagto               ascending
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_estab_espec                  
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_sel_faixa                    
          ttv_log_mostra_tit               ascending
          tta_cdn_fornecedor               ascending
          tta_nom_abrev                    ascending
          tta_dat_prev_pagto               ascending
          tta_dat_vencto_tit_ap            ascending
          tta_cod_tit_ap                   ascending
          tta_cod_estab                    ascending
          tta_cod_forma_pagto              ascending
          ttv_val_sdo_tit_ap               ascending
          tta_cod_refer                    ascending.

def new global shared temp-table tt_paint_row_tit_ap no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_num_color                    as integer format ">>>>,>>9"
    field ttv_num_color_1                  as integer format ">>>>,>>9"
    index tt_index_unique                 
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

DEF NEW GLOBAL SHARED temp-table tt_pessoa_jurid_matriz     no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica".

DEF NEW GLOBAL SHARED temp-table tt_pessoa_jurid_matriz_aux no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    index tt_index                 
        tta_num_pessoa_jurid               ascending.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED temp-table tt_tot_selec no-undo
    FIELD num_id_reg     AS INT
    FIELD rec_reg        AS RECID
    FIELD val_pagto      AS DEC  FORMAT ">>,>>>,>>>,>>9.99" 
    FIELD cod_indic_econ AS CHAR FORMAT "x(8)"
    INDEX indic_econ
          cod_indic_econ ASCENDING.

DEF NEW GLOBAL SHARED temp-table tt_item_cotacao no-undo
    FIELD num_id_reg AS INT.

DEFINE VARIABLE hCol AS HANDLE NO-UNDO.

def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.

def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

def query qr_tot_bord_pagto
    for tt_tot_pagto
    scrolling.

def browse br_tot_bord_pagto query qr_tot_bord_pagto display 
    tt_tot_pagto.cod_indic_econ     width-chars 09.00 COLUMN-LABEL "Moeda"
    tt_tot_pagto.ttv_val_tot_pend_1 width-chars 12.00
    tt_tot_pagto.ttv_val_total      width-chars 12.00 column-label "Valor Total"
    with separators single 
         size 41.00 by 06.00
         font 4
         bgcolor 15
         title "Total Borderì".

def frame f_dlg_03_bord_ap_tot
    rt_cxcf           at row 07.32 col 01.94 bgcolor 7 
    br_tot_bord_pagto at row 01.21 col 01.94
    bt_ok             at row 07.55 col 02.94 font ? help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 45.20 by 09.20 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Total Borderì do Contas a Pagar".

assign bt_ok:width-chars    in frame f_dlg_03_bord_ap_tot = 10.00
       bt_ok:height-chars   in frame f_dlg_03_bord_ap_tot = 01.00
       rt_cxcf:width-chars  in frame f_dlg_03_bord_ap_tot = 41.00
       rt_cxcf:height-chars in frame f_dlg_03_bord_ap_tot = 01.40.


def var c-objeto         as char                          no-undo.
DEF VAR v_cod_indic_econ LIKE tt_tot_selec.cod_indic_econ NO-UNDO.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").

/*
message "EVENTO" p_ind_event skip
        "OBJETO" p_ind_object skip
        "NOME OBJ" c-objeto skip
        "FRAME" p_wgh_frame skip
        "TABELA" p_cod_table skip
        "ROWID" string(p_rec_table) view-as alert-box.  
*/

IF p_ind_event = "after-destroy-interface" THEN DO:
    ASSIGN h_apb711zd6 = ?
           h_apb711zd6 = ?.
END.
  
if  p_ind_event = "INITIALIZE" then do:
    ASSIGN l-todos-apb711zd = NO.
    
    FOR EACH tt_paint_row_tit_ap:
        DELETE tt_paint_row_tit_ap.
    END.

    FOR EACH tt_tot_selec:
        DELETE tt_tot_selec.
    END.

    FOR EACH tt_item_cotacao:
        DELETE tt_item_cotacao.
    END.

    /* ** Bot∆o alteraá∆o informaá‰es banc†rias ***/
    create button wh_button
    assign frame      = p_wgh_frame
           NAME       = "bt_manut_esp"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 13
           sensitive  = yes
           visible    = yes
           tooltip    = "Manutená∆o Fornecedor Financeiro"
           triggers:
               on choose persistent run epc/apb711zd2_epc.p.
           end triggers.

    wh_button:load-image("image/im-pess.bmp":U).

    /* ** Bot∆o para imprimir relat¢rio Encontro de Contas ***/
    create button wh_button2
    assign frame      = p_wgh_frame
           NAME       = "bt_enctro_esp"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 16
           sensitive  = yes
           visible    = yes
           LABEL      = "Enctro Ctas"
           tooltip    = "Relat¢rio Encontro de Contas"
           triggers:
               on choose persistent run epc/apb711zd3_epc.p.
           end triggers.

    wh_button2:LOAD-IMAGE("image/im-hedge.bmp":U).

    /* ** Bot∆o para imprimir relat¢rio Encontro de Contas ***/
    create button wh_button3
    assign frame      = p_wgh_frame
           NAME       = "bt_consulta_imp_esp"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 19
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Imposto lancto Nota"
           tooltip    = "Consulta Imposto lancto Nota"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb711zd5_epc.w.
           end triggers.

    wh_button3:LOAD-IMAGE("image/intelbras/infopg.ico":U). 

    create button wh_button4
    assign frame      = p_wgh_frame
           NAME       = "bt_consulta_imp_esp"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 22
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Èltimos Pagamentos"
           tooltip    = "Consulta Èltimos Pagamentos"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb711zd7_epc.w.
           end triggers.

    wh_button4:LOAD-IMAGE("image/dolar.ico"). 

    /* cotaá∆o £nica */
    create button wh_button5
    assign frame      = p_wgh_frame
           NAME       = "bt_cotacao"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 25
           sensitive  = yes
           visible    = yes
           LABEL      = "Cotaá∆o Ènica"
           tooltip    = "Cotaá∆o Ènica"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb711zd10_epc.p .
           end triggers.

    wh_button5:LOAD-IMAGE("image/im-extra.bmp").
    /* cotaá∆o £nica */

    /* hist¢ricos do t°tulo */
    create button wh_button6
    assign frame      = p_wgh_frame
           NAME       = "bt_histor"
           width      = 3
           height     = 1.08
           row        = 18.25
           col        = 28
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Hist¢ricos"
           tooltip    = "Consulta Hist¢ricos"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb711zd12_epc.p(INPUT p_ind_event,  
                                                             INPUT p_ind_object, 
                                                             INPUT p_wgh_object, 
                                                             INPUT p_wgh_frame,  
                                                             INPUT p_cod_table,  
                                                             INPUT p_rec_table). 
           end triggers.

    wh_button6:LOAD-IMAGE("image/im-hist.bmp").

    RUN piFindWidget(INPUT "bt_det1", INPUT "BUTTON", INPUT p_wgh_frame, OUTPUT h_bt_det1).

    create button wh_bt_det1_epc
    assign frame      = p_wgh_frame
           NAME       = "bt_det1_epc"
           width      = h_bt_det1:WIDTH
           height     = h_bt_det1:HEIGHT
           row        = h_bt_det1:ROW + 1.1
           col        = h_bt_det1:COL
           sensitive  = yes
           visible    = yes
           LABEL      = "Alteraá∆o de T°tulos"
           tooltip    = "Alteraá∆o de T°tulos"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb711zd11_epc.p(INPUT p_ind_event,  
                                                             INPUT p_ind_object, 
                                                             INPUT p_wgh_object, 
                                                             INPUT p_wgh_frame,  
                                                             INPUT p_cod_table,  
                                                             INPUT p_rec_table). 
           end triggers.

    wh_bt_det1_epc:LOAD-IMAGE("image/im-mod").

    /* Corrigir Tab Order bt_manut_esp */
    RUN piFindWidget(INPUT "bt_enctro_esp", INPUT "BUTTON", INPUT p_wgh_frame, OUTPUT h_prev).
    RUN piFindWidget(INPUT "bt_hel2", INPUT "BUTTON", INPUT p_wgh_frame, OUTPUT h_next).
    wh_button:move-after-tab-item(h_prev).
    wh_button:move-before-tab-item(h_next).
    /* Corrigir Tab Order */

    /* Corrigir Tab Order bt_enctro_esp */
    RUN piFindWidget(INPUT "bt_ok", INPUT "BUTTON", INPUT p_wgh_frame, OUTPUT h_prev).
    RUN piFindWidget(INPUT "bt_manut_esp", INPUT "BUTTON", INPUT p_wgh_frame, OUTPUT h_next).
    wh_button2:move-after-tab-item(h_prev).
    wh_button2:move-before-tab-item(h_next).
    /* Corrigir Tab Order */


    RUN epc/apb711zd4_epc.p PERSISTENT SET h_apb711zd4(INPUT p_ind_event,
                                                       INPUT p_ind_object,
                                                       INPUT p_wgh_object,
                                                       INPUT p_wgh_frame,
                                                       INPUT p_cod_table,
                                                       INPUT p_rec_table).

    RUN epc/apb711zd6_epc.p PERSISTENT SET h_apb711zd6(INPUT p_ind_event,
                                                       INPUT p_ind_object,
                                                       INPUT p_wgh_object,
                                                       INPUT p_wgh_frame,
                                                       INPUT p_cod_table,
                                                       INPUT p_rec_table).
    
    RUN epc/apb711zd8_epc.p PERSISTENT SET h_apb711zd8(INPUT p_ind_event,
                                                       INPUT p_ind_object,
                                                       INPUT p_wgh_object,
                                                       INPUT p_wgh_frame,
                                                       INPUT p_cod_table,
                                                       INPUT p_rec_table).

    RUN epc/apb711zd9_epc.p PERSISTENT SET h_apb711zd9(INPUT p_ind_event,
                                                       INPUT p_ind_object,
                                                       INPUT p_wgh_object,
                                                       INPUT p_wgh_frame,
                                                       INPUT p_cod_table,
                                                       INPUT p_rec_table).

    FOR EACH tt_titulo_antecip_pef_a_pagar NO-LOCK:
        /* ** Filtro Assessoria de Cobranáa, sempre serˇ considerado como tendo t°tulo no contas a receber ***/
        IF  tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor = 16954
        OR  tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor = 927
        OR  tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor = 931787
        OR  tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor = 13036 THEN DO:
            FIND tt_paint_row_tit_ap
               WHERE tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
               AND   tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
               AND   tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
               AND   tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
               AND   tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
               AND   tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela NO-ERROR.
            IF  AVAIL tt_paint_row_tit_ap THEN NEXT.

            CREATE tt_paint_row_tit_ap.
            ASSIGN tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                   tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                   tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                   tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                   tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                   tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela.
            NEXT.
        END. /* IF  tt_titulo_antecip_pef_a_pagar... */
    
        FIND FIRST tt_paint_row_tit_ap
             WHERE tt_paint_row_tit_ap.tta_cdn_fornecedor = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor NO-ERROR.
        IF  AVAIL tt_paint_row_tit_ap THEN DO:
            FIND tt_paint_row_tit_ap
                WHERE tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                  AND tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                  AND tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                  AND tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                  AND tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                  AND tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela NO-ERROR.
            IF  AVAIL tt_paint_row_tit_ap THEN NEXT.

            CREATE tt_paint_row_tit_ap.
            ASSIGN tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                   tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                   tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                   tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                   tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                   tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela.
            NEXT.
        END. /* IF  AVAIL tt_paint_row_tit_ap THEN DO: */
    
        FIND emscad.fornecedor NO-LOCK
           WHERE emscad.fornecedor.cod_empresa    = v_cod_empres_usuar
           AND   emscad.fornecedor.cdn_fornecedor = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor NO-ERROR.
        IF NOT AVAIL emscad.fornecedor THEN NEXT. /* ** PEF ***/
    
        FIND FIRST tt_pessoa_jurid_matriz_aux
             WHERE tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa NO-ERROR.
        IF  AVAIL tt_pessoa_jurid_matriz_aux THEN NEXT.
    
        FOR EACH tt_pessoa_jurid_matriz: DELETE tt_pessoa_jurid_matriz. END.
    
        /* --- Fornecedor Pessoa F≠sica ---*/
        IF  emscad.fornecedor.num_pessoa MOD 2 = 0 THEN DO:
            CREATE tt_pessoa_jurid_matriz.
            ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
            CREATE tt_pessoa_jurid_matriz_aux.
            ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
        END. /* IF  emscad.fornecedor.num_pessoa */
        ELSE DO:
             /* --- Fornecedor Pessoa Jur≠dica ---*/
             RUN pi_retornar_pessoa_jurid_matriz (INPUT emscad.fornecedor.num_pessoa,
                                                  OUTPUT v_cod_return).
             IF  v_cod_return = "107" THEN DO:
                 CREATE tt_pessoa_jurid_matriz.
                 ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
                 CREATE tt_pessoa_jurid_matriz_aux.
                 ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
             END. /* IF  v_cod_return = */
        END. /* ELSE DO: */
    
        blk_estab:
        FOR EACH estabelecimento
            WHERE estabelecimento.cod_empresa = v_cod_empres_usuar NO-LOCK:
            IF  estabelecimento.cod_estab = '201' THEN NEXT.
    
            FOR EACH tt_pessoa_jurid_matriz:
                /* ** Se alterar esta regra se seleá∆o do tit_acr, alterar tambem o programa apb711zd3_epc ***/
                FIND FIRST tit_acr NO-LOCK
                     WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
                     AND   tit_acr.ind_tip_espec_docto  = "Normal"
                     AND   tit_acr.num_pessoa           = tt_pessoa_jurid_matriz.tta_num_pessoa_jurid
                     AND   tit_acr.log_sdo_tit_acr      = YES
                     AND   tit_acr.log_tit_acr_estordo  = NO
                     AND   tit_acr.dat_vencto_tit_acr   < (TODAY - 1)
                     AND   tit_acr.cod_portador        <> '9905'
                     AND   tit_acr.cod_portador        <> '9943'
                     AND   tit_acr.cod_portador        <> '9996' USE-INDEX titacr_espec_pessoa_emis NO-ERROR.
                IF  AVAIL tit_acr THEN DO:
                    FIND tt_paint_row_tit_ap
                        WHERE tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                        AND   tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                        AND   tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                        AND   tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                        AND   tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                        AND   tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela NO-ERROR.
                    IF AVAIL tt_paint_row_tit_ap THEN LEAVE blk_estab.

                    IF  tit_acr.dat_vencto_tit_acr = (TODAY - 2) THEN DO:
                        IF  WEEKDAY(tit_acr.dat_vencto_tit_acr) = 7 THEN
                            NEXT.
                    END.

                    CREATE tt_paint_row_tit_ap.
                    ASSIGN tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                           tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                           tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                           tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                           tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                           tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela.
                    LEAVE blk_estab.
                END. /* IF  AVAIL tit_acr THEN DO: */
            END. /* FOR EACH tt_pessoa_jurid_matriz: */
        END. /* FOR EACH estabelecimento */
    END. /* FOR EACH tt_titulo_antecip_pef_a_pagar: */
    
    IF  INDEX(p_wgh_frame:TITLE,"Inclui Item Borderì Pagamento") <> 0 THEN DO:

        IF  valid-handle(wh_bt_det1_epc) THEN
            ASSIGN wh_bt_det1_epc:VISIBLE = NO.

        FOR EACH tt_titulo_antecip_pef_a_pagar:

             FIND fornec_financ NO-LOCK
                 WHERE fornec_financ.cod_empresa    = v_cod_empres_usuar
                 AND   fornec_financ.cdn_fornecedor = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor NO-ERROR.
             IF AVAIL fornec_financ
             AND (fornec_financ.cod_forma_pagto = "15"  OR 
                  fornec_financ.cod_forma_pagto = "25") THEN DO:
                  FIND tt_paint_row_tit_ap
                      WHERE tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                        AND tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                        AND tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                        AND tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                        AND tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                        AND tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela NO-ERROR.
                  IF  NOT AVAIL tt_paint_row_tit_ap THEN DO:
                      CREATE tt_paint_row_tit_ap.
                      ASSIGN tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                             tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                             tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                             tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                             tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                             tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela.
                  END.
                  NEXT.
             END. /* IF AVAIL fornec_financ */

             IF NOT AVAIL fornec_financ OR fornec_financ.cod_banco <> "341" THEN NEXT. /* ** PEF ou banco diferente de Itaú ***/

             FIND tt_paint_row_tit_ap
                 WHERE tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                 AND   tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                 AND   tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                 AND   tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                 AND   tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                 AND   tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela NO-ERROR.
             IF  NOT AVAIL tt_paint_row_tit_ap THEN DO:
                 CREATE tt_paint_row_tit_ap.
                 ASSIGN tt_paint_row_tit_ap.tta_cod_estab       = tt_titulo_antecip_pef_a_pagar.tta_cod_estab
                        tt_paint_row_tit_ap.tta_cdn_fornecedor  = tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor
                        tt_paint_row_tit_ap.tta_cod_espec_docto = tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto
                        tt_paint_row_tit_ap.tta_cod_ser_docto   = tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto
                        tt_paint_row_tit_ap.tta_cod_tit_ap      = tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap
                        tt_paint_row_tit_ap.tta_cod_parcela     = tt_titulo_antecip_pef_a_pagar.tta_cod_parcela.
             END.
        END. /* FOR EACH tt_titulo_antecip_pef_a_pagar: */
    END. /* IF  INDEX(p_wgh_frame:TITLE,"Inclui Item BorderÀ Pagamento") <> 0 THEN DO: */

    
    RUN piFindWidget(INPUT "br_pagto_conjunto", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT h_br_pagto_conjunto).

    IF  VALID-HANDLE(h_br_pagto_conjunto) THEN DO:
        
        assign wgh-query  = h_br_pagto_conjunto:QUERY
               wgh-buffer = wgh-query:GET-BUFFER-HANDLE(1).
    
        ON "ROW-DISPLAY" OF h_br_pagto_conjunto PERSISTENT RUN pi-row-display IN h_apb711zd4. 
    
        ON "MOUSE-SELECT-CLICK" OF h_br_pagto_conjunto PERSISTENT RUN pi-armazena-campos IN h_apb711zd6.

        EMPTY TEMP-TABLE ttCol.
    
        ASSIGN hCol = h_br_pagto_conjunto:FIRST-COLUMN.
        DO  WHILE VALID-HANDLE(hCol):
            IF  NOT CAN-FIND(FIRST ttCol 
                               WHERE ttCol.ColHdl = hCol) THEN  DO:
                CREATE ttCol.
                ASSIGN ttCol.ColHdl = hCol.
            END.
            hCol = hCol:NEXT-COLUMN.
        END.
    END.

    /* somatoria dos itens selecionados browse inferior */
    assign h-programa = p_wgh_object
           wgh-window = p_wgh_object.

    RUN busca-handle(INPUT p_wgh_frame,
                     INPUT "bt_tot",
                     OUTPUT wh_bt_tot_apb711zd).

    IF VALID-HANDLE(wh_bt_tot_apb711zd) THEN DO:

        IF NOT VALID-HANDLE (h_epc_apb711zd) THEN
            RUN epc/apb711zd_epc.p PERSISTENT SET h_epc_apb711zd (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p_wgh_object,
                                                                  INPUT p_wgh_frame,
                                                                  INPUT "",
                                                                  INPUT p_rec_table).

        CREATE BUTTON wh_new_bt_tot_apb711zd
        ASSIGN FRAME       = wh_bt_tot_apb711zd:FRAME
               WIDTH       = wh_bt_tot_apb711zd:WIDTH
               HEIGHT      = wh_bt_tot_apb711zd:HEIGHT
               LABEL       = wh_bt_tot_apb711zd:LABEL
               ROW         = wh_bt_tot_apb711zd:ROW
               COL         = wh_bt_tot_apb711zd:COL 
               TOOLTIP     = wh_bt_tot_apb711zd:TOOLTIP
               FLAT-BUTTON = wh_bt_tot_apb711zd:FLAT-BUTTON
               VISIBLE     = wh_bt_tot_apb711zd:VISIBLE
               SENSITIVE   = wh_bt_tot_apb711zd:SENSITIVE.
        ON "CHOOSE" OF wh_new_bt_tot_apb711zd PERSISTENT RUN pi_bt_tot IN h_epc_apb711zd.

        wh_new_bt_tot_apb711zd:LOAD-IMAGE ( 'image/im-total' ).
        wh_new_bt_tot_apb711zd:MOVE-TO-TOP().
        wh_bt_tot_apb711zd:VISIBLE = NO.
    END.

    assign h-programa = p_wgh_object
           wgh-window = p_wgh_object.

    RUN busca-handle(INPUT p_wgh_frame,
                     INPUT "bt_todos_img_2",
                     OUTPUT wh_bt_todos_apb711zd).

    IF VALID-HANDLE(wh_bt_todos_apb711zd) THEN DO:

        IF NOT VALID-HANDLE (h_epc_apb711zd) THEN
            RUN epc/apb711zd_epc.p PERSISTENT SET h_epc_apb711zd (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p_wgh_object,
                                                                  INPUT p_wgh_frame,
                                                                  INPUT "",
                                                                  INPUT p_rec_table).

        CREATE BUTTON wh_new_bt_todos_apb711zd
        ASSIGN FRAME       = wh_bt_todos_apb711zd:FRAME
               WIDTH       = wh_bt_todos_apb711zd:WIDTH
               HEIGHT      = wh_bt_todos_apb711zd:HEIGHT
               LABEL       = wh_bt_todos_apb711zd:LABEL
               ROW         = wh_bt_todos_apb711zd:ROW
               COL         = wh_bt_todos_apb711zd:COL 
               TOOLTIP     = wh_bt_todos_apb711zd:TOOLTIP
               FLAT-BUTTON = wh_bt_todos_apb711zd:FLAT-BUTTON
               VISIBLE     = wh_bt_todos_apb711zd:VISIBLE
               SENSITIVE   = wh_bt_todos_apb711zd:SENSITIVE.
        ON "CHOOSE" OF wh_new_bt_todos_apb711zd PERSISTENT RUN pi_bt_todos IN h_epc_apb711zd.

        wh_new_bt_todos_apb711zd:LOAD-IMAGE ( 'image/im-ran_a' ).
        wh_new_bt_todos_apb711zd:MOVE-TO-TOP().
        wh_bt_todos_apb711zd:VISIBLE = NO.

    END.

    assign h-programa = p_wgh_object
           wgh-window = p_wgh_object.

    RUN busca-handle(INPUT p_wgh_frame,
                     INPUT "bt_nenhum_img_2",
                     OUTPUT wh_bt_nenhum_apb711zd).

    IF VALID-HANDLE(wh_bt_nenhum_apb711zd) THEN DO:

        IF NOT VALID-HANDLE (h_epc_apb711zd) THEN
            RUN epc/apb711zd_epc.p PERSISTENT SET h_epc_apb711zd (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p_wgh_object,
                                                                  INPUT p_wgh_frame,
                                                                  INPUT "",
                                                                  INPUT p_rec_table).

        CREATE BUTTON wh_new_bt_nenhum_apb711zd
        ASSIGN FRAME       = wh_bt_nenhum_apb711zd:FRAME
               WIDTH       = wh_bt_nenhum_apb711zd:WIDTH
               HEIGHT      = wh_bt_nenhum_apb711zd:HEIGHT
               LABEL       = wh_bt_nenhum_apb711zd:LABEL
               ROW         = wh_bt_nenhum_apb711zd:ROW
               COL         = wh_bt_nenhum_apb711zd:COL 
               TOOLTIP     = wh_bt_nenhum_apb711zd:TOOLTIP
               FLAT-BUTTON = wh_bt_nenhum_apb711zd:FLAT-BUTTON
               VISIBLE     = wh_bt_nenhum_apb711zd:VISIBLE
               SENSITIVE   = wh_bt_nenhum_apb711zd:SENSITIVE.
        ON "CHOOSE" OF wh_new_bt_nenhum_apb711zd PERSISTENT RUN pi_bt_nenhum IN h_epc_apb711zd.

        wh_new_bt_nenhum_apb711zd:LOAD-IMAGE ( 'image/im-ran_n' ).
        wh_new_bt_nenhum_apb711zd:MOVE-TO-TOP().
        wh_bt_nenhum_apb711zd:VISIBLE = NO.

    END.

    RUN piFindWidget(INPUT "br_dlg_item_bord_ap_cjto", 
                     INPUT "BROWSE", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_br_dlg_item_bord_ap_cjto).
    
    IF  VALID-HANDLE (h_br_dlg_item_bord_ap_cjto)
    AND h_br_dlg_item_bord_ap_cjto:SENSITIVE = YES THEN DO:

        ON "MOUSE-SELECT-CLICK" OF h_br_dlg_item_bord_ap_cjto PERSISTENT RUN pi_cria_reg_unico    IN h_apb711zd8.
        ON "MOUSE-EXTEND-CLICK" OF h_br_dlg_item_bord_ap_cjto PERSISTENT RUN pi_cria_reg_multiplo IN h_apb711zd8.
        ON "MOUSE-SELECT-DOWN"  OF h_br_dlg_item_bord_ap_cjto PERSISTENT RUN pi_cria_reg_down     IN h_apb711zd8.
        ON "MOUSE-SELECT-UP"    OF h_br_dlg_item_bord_ap_cjto PERSISTENT RUN pi_cria_reg_up       IN h_apb711zd8.
        /* somatoria dos itens selecionados browse inferior BORDERO*/
    END.
    ELSE DO:
        RUN piFindWidget(INPUT "br_dlg_liberados", 
                         INPUT "BROWSE", 
                         INPUT  p_wgh_frame, 
                         OUTPUT h_br_dlg_liberados).

        IF  VALID-HANDLE (h_br_dlg_liberados)
        AND h_br_dlg_liberados:SENSITIVE = YES THEN DO:
            ON "MOUSE-SELECT-CLICK" OF h_br_dlg_liberados PERSISTENT RUN pi_cria_reg_unico    IN h_apb711zd9.
            ON "MOUSE-EXTEND-CLICK" OF h_br_dlg_liberados PERSISTENT RUN pi_cria_reg_multiplo IN h_apb711zd9.
            /* somatoria dos itens selecionados browse inferior LIBERAÄAO */
        END.
    END.
END.

PROCEDURE pi_retornar_pessoa_jurid_matriz:

    def Input  param p_num_pessoa_jurid as integer   format ">>>,>>>,>>9" no-undo.
    def output param p_cod_return       as character format "x(40)"       no-undo.

    def var v_num_pessoa_jurid_matriz as integer format ">>>,>>>,>>9":U label "Matriz" column-label "Matriz" no-undo.

    FIND pessoa_jurid NO-LOCK 
         WHERE pessoa_jurid.num_pessoa_jurid = p_num_pessoa_jurid NO-ERROR.
    IF  AVAIL pessoa_jurid THEN DO:
        ASSIGN v_num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz.

        FIND FIRST tt_pessoa_jurid_matriz NO-LOCK 
             WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.
        IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO:
            CREATE tt_pessoa_jurid_matriz.
            ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid.
            CREATE tt_pessoa_jurid_matriz_aux.
            ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
        END. /* IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO: */
        IF  pessoa_jurid.num_pessoa_jurid_matriz <> 0 THEN DO:
            FOR EACH pessoa_jurid NO-LOCK 
                WHERE pessoa_jurid.num_pessoa_jurid_matriz = v_num_pessoa_jurid_matriz
                USE-INDEX pssjrda_matriz:
                FIND FIRST tt_pessoa_jurid_matriz NO-LOCK 
                     WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.
                IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO:
                    CREATE tt_pessoa_jurid_matriz.
                    ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid.
                    CREATE tt_pessoa_jurid_matriz_aux.
                    ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
                END. /* IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO: */
            END. /* FOR EACH pessoa_jurid NO-LOCK */
        END. /* IF  pessoa_jurid.num_pessoa_jurid_matriz <> 0 THEN DO: */
    END. /* IF  AVAIL pessoa_jurid THEN DO: */
    ELSE DO:
         ASSIGN p_cod_return = "107".
    END. /* ELSE DO: */

END PROCEDURE.

PROCEDURE pi_bt_tot:
    DEF VAR de-tot AS DEC INIT 0 FORMAT ">>,>>>,>>>,>>9.99" NO-UNDO.

    ASSIGN de-tot      = 0
           v_val_total = 0.

    IF  VALID-HANDLE (h_br_dlg_item_bord_ap_cjto)
    AND h_br_dlg_item_bord_ap_cjto:SENSITIVE = YES THEN DO:

        FOR EACH tt_tot_pagto:
            DELETE tt_tot_pagto.
        END.
        
        FIND FIRST tt_tot_selec NO-LOCK NO-ERROR.
    
        IF  AVAIL tt_tot_selec THEN DO:
    
            FOR EACH estabelecimento NO-LOCK:

                FIND FIRST item_bord_ap
                    WHERE item_bord_ap.cod_estab_bord      = estabelecimento.cod_estab
                    AND   item_bord_ap.num_id_item_bord_ap = tt_tot_selec.num_id_reg NO-LOCK NO-ERROR.
        
                IF  AVAIL item_bord_ap THEN DO:
                    for each b_item_bord_ap no-lock
                        where b_item_bord_ap.cod_estab_bord = item_bord_ap.cod_estab_bord
                        and   b_item_bord_ap.cod_portador   = item_bord_ap.cod_portador
                        and   b_item_bord_ap.num_bord_ap    = item_bord_ap.num_bord_ap:
        
                        find tt_pagamentos_realizados no-lock 
                            where tt_pagamentos_realizados.ttv_rec_item_lote_pagto = recid(b_item_bord_ap) no-error.
        
                        IF  NOT AVAIL tt_pagamentos_realizados THEN
                            assign v_val_total = v_val_total + b_item_bord_ap.val_pagto
                                                     + b_item_bord_ap.val_multa_tit_ap
                                                     - b_item_bord_ap.val_desc_tit_ap
                                                     + b_item_bord_ap.val_juros
                                                     - b_item_bord_ap.val_abat_tit_ap
                                                     + b_item_bord_ap.val_cm_tit_ap.
                    
                    END.            
                END.
            END.
        END.
          
        FOR EACH tt_tot_selec:

            FOR EACH estabelecimento NO-LOCK:
                FIND FIRST item_bord_ap
                    WHERE item_bord_ap.cod_estab_bord      = estabelecimento.cod_estab
                    AND   item_bord_ap.num_id_item_bord_ap = tt_tot_selec.num_id_reg NO-LOCK NO-ERROR.
    
                IF  AVAIL item_bord_ap THEN DO:
                    /*MESSAGE "bt-total - item_bord_ap.cod_estab " item_bord_ap.cod_estab       skip 
                            "item_bord_ap.cod_espec_docto "      item_bord_ap.cod_espec_docto skip
                            "item_bord_ap.cod_ser_docto "        item_bord_ap.cod_ser_docto   skip
                            "item_bord_ap.cdn_fornecedor "       item_bord_ap.cdn_fornecedor  skip
                            "item_bord_ap.cod_tit_ap "           item_bord_ap.cod_tit_ap      skip
                            "item_bord_ap.cod_parcela "          item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

                    find first bord_ap 
                         where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                         and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                         and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.
    
                    ASSIGN v_val_tot_impto = 0.
    
                    run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab_bord,
                                            Input "",
                                            Input bord_ap.cod_portador,
                                            Input bord_ap.num_bord_ap,
                                            Input item_bord_ap.num_seq_bord,
                                            Input yes,
                                            Input bord_ap.dat_transacao,
                                            Input "Retido",
                                            output v_log_impto_vincul_refer,
                                            output v_val_tot_impto,
                                            Input ?,
                                            Input ?,
                                            Input ?).
    
                    assign de-tot = de-tot + item_bord_ap.val_pagto
                                           + item_bord_ap.val_multa_tit_ap
                                           - item_bord_ap.val_desc_tit_ap
                                           + item_bord_ap.val_juros
                                           - item_bord_ap.val_abat_tit_ap
                                           + item_bord_ap.val_cm_tit_ap
                                           - v_val_tot_impto.
    
                    IF  tt_tot_selec.cod_indic_econ <> "" THEN
                        ASSIGN v_cod_indic_econ = tt_tot_selec.cod_indic_econ.
                END.
            END.
        END.
        
        create tt_tot_pagto.
        assign tt_tot_pagto.ttv_val_total      = IF  l-todos-apb711zd = YES THEN (de-tot - v_val_total) ELSE de-tot
               tt_tot_pagto.ttv_val_tot_pend_1 = v_val_total
               tt_tot_pagto.cod_indic_econ     = v_cod_indic_econ.
    END.

    IF  VALID-HANDLE (h_br_dlg_liberados)
    AND h_br_dlg_liberados:SENSITIVE = YES THEN DO:

        FOR EACH tt_tot_pagto:
            DELETE tt_tot_pagto.
        END.
    
        FOR EACH tt_tot_selec BREAK BY tt_tot_selec.cod_indic_econ:

            assign de-tot = de-tot + tt_tot_selec.val_pagto.

            IF  LAST-OF(tt_tot_selec.cod_indic_econ) THEN DO:
                create tt_tot_pagto.
                assign tt_tot_pagto.ttv_val_total      = de-tot
                       tt_tot_pagto.ttv_val_tot_pend_1 = v_val_total
                       tt_tot_pagto.cod_indic_econ     = tt_tot_selec.cod_indic_econ.

                assign de-tot = 0.
            END.
        END.    
    END.

    IF  VALID-HANDLE (h_br_dlg_item_bord_ap_cjto)
    AND h_br_dlg_item_bord_ap_cjto:SENSITIVE = YES THEN DO:
        view frame f_dlg_03_bord_ap_tot.
        display br_tot_bord_pagto
                bt_ok
                with frame f_dlg_03_bord_ap_tot.
        enable all with frame f_dlg_03_bord_ap_tot.
    
        open query qr_tot_bord_pagto for
            each tt_tot_pagto no-lock.
    
        wait-for go of frame f_dlg_03_bord_ap_tot.
        hide frame f_dlg_03_bord_ap_tot no-pause.
    END.
    ELSE DO:
        IF  l-todos-apb711zd = NO THEN DO:
            view frame f_dlg_03_bord_ap_tot.
            display br_tot_bord_pagto
                    bt_ok
                    with frame f_dlg_03_bord_ap_tot.
            enable all with frame f_dlg_03_bord_ap_tot.
        
            open query qr_tot_bord_pagto for
                each tt_tot_pagto no-lock.
        
            wait-for go of frame f_dlg_03_bord_ap_tot.
            hide frame f_dlg_03_bord_ap_tot no-pause.
        END.
        ELSE
            IF  VALID-HANDLE(wh_bt_tot_apb711zd) THEN
                APPLY "CHOOSE" TO wh_bt_tot_apb711zd.

    END.

END PROCEDURE.

PROCEDURE piFindWidget:

    define input  parameter c-widget-name  as char   no-undo.
    define input  parameter c-widget-type  as char   no-undo.
    define input  parameter h-start-widget as handle no-undo.
    define output parameter h-widget       as handle no-undo.

    do while valid-handle(h-start-widget):

        if h-start-widget:name = c-widget-name and
           h-start-widget:type = c-widget-type then do:
            
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if h-start-widget:type = "field-group":u or
           h-start-widget:type = "frame":u or
           h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if valid-handle(h-widget) then
                leave.
        end.
        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.

PROCEDURE pi_bt_todos:
    ASSIGN l-todos-apb711zd = YES.

    IF  VALID-HANDLE(wh_bt_todos_apb711zd) THEN
        APPLY "CHOOSE" TO wh_bt_todos_apb711zd.

    FOR EACH tt_tot_pagto:
        DELETE tt_tot_pagto.
    END.

    FIND FIRST bord_ap
        WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-LOCK NO-ERROR.

    IF  AVAIL bord_ap THEN DO:

        for each b_item_bord_ap no-lock
            where b_item_bord_ap.cod_estab_bord = bord_ap.cod_estab
            and   b_item_bord_ap.cod_portador   = bord_ap.cod_portador
            and   b_item_bord_ap.num_bord_ap    = bord_ap.num_bord_ap:

            FIND FIRST tt_tot_selec
                WHERE tt_tot_selec.num_id_reg = b_item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.
    
            IF  NOT AVAIL tt_tot_selec THEN DO:
                /*MESSAGE "pi_bt_todos - b_item_bord_ap.cod_estab " b_item_bord_ap.cod_estab       skip 
                        "b_item_bord_ap.cod_espec_docto "      b_item_bord_ap.cod_espec_docto skip
                        "b_item_bord_ap.cod_ser_docto "        b_item_bord_ap.cod_ser_docto   skip
                        "b_item_bord_ap.cdn_fornecedor "       b_item_bord_ap.cdn_fornecedor  skip
                        "b_item_bord_ap.cod_tit_ap "           b_item_bord_ap.cod_tit_ap      skip
                        "b_item_bord_ap.cod_parcela "          b_item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

                CREATE tt_tot_selec.
                ASSIGN tt_tot_selec.num_id_reg = b_item_bord_ap.num_id_item_bord_ap
                       tt_tot_selec.val_pagto           = b_item_bord_ap.val_pagto.
            END.
        end.                    
    END.

    /* cotacao unica */
    IF  VALID-HANDLE (h_br_dlg_item_bord_ap_cjto)
    AND h_br_dlg_item_bord_ap_cjto:SENSITIVE = YES 
    AND valid-handle(h_apb711zd8) THEN DO:
        IF  h_br_dlg_item_bord_ap_cjto:NUM-SELECTED-ROWS > 0 THEN
            RUN pi_cria_reg_up IN h_apb711zd8.
    END.
    /* cotacao unica */

END PROCEDURE.

PROCEDURE pi_bt_nenhum:
    ASSIGN l-todos-apb711zd = NO.

    IF  VALID-HANDLE(wh_bt_nenhum_apb711zd) THEN
        APPLY "CHOOSE" TO wh_bt_nenhum_apb711zd.

    FOR EACH tt_tot_pagto:
        DELETE tt_tot_pagto.
    END.

END PROCEDURE.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.
