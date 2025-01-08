/*****************************************************************************
** Programa..............: apb711zd11_epc.p
** Descricao.............: EPC para chamada do programa de altera‡Æo.
** Criado em.............: 19/02/2019
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def shared temp-table tt_titulo_antecip_pef_a_pagar no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_ser_docto                as character format "x(5)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_tit_ap                   as character format "x(16)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_prepar_pagto             as date format "99/99/9999" initial ? label "Data Prepar Pagto" column-label "Dat Prepar"
    field tta_dat_liber_pagto              as date format "99/99/9999" initial ? label "Data Liber Pagto" column-label "Dat  Liber"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_refer_antecip_pef        as character format "x(10)" label "Ref Antec PEF Pend" column-label "Ref Antec PEF Pend"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_num_seq_pagto_tit_ap         as integer format ">9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_val_pagto_moe                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagto Moeda" column-label "Valor Pagto Moeda"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field ttv_rec_proces_pagto             as recid format ">>>>>>9" initial ?
    field ttv_log_mostra_tit               as logical format "Sim/NÆo" initial yes label "T¡tulo" column-label "T¡tulo"
    field ttv_ind_sit_prepar_liber         as character format "X(03)" label "Situa‡Æo" column-label "Sit"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_cod_classif_1                as character format "x(8)"
    field ttv_cod_classif_2                as character format "x(8)"
    field ttv_cod_classif_3                as character format "x(8)"
    field ttv_cod_classif_4                as character format "x(8)"
    field ttv_cod_classif_5                as character format "x(8)"
    field ttv_cod_classif_6                as character format "x(8)"
    field ttv_cod_classif_7                as character format "x(8)"
    field ttv_cod_classif_8                as character format "x(8)"
    field tta_cod_safra                    as character format "9999/9999" label "Safra" column-label "Safra"
    field tta_cod_contrat_graos            as character format "x(20)" label "Contrato GrÆos" column-label "Contr GrÆos"
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

DEFINE NEW GLOBAL SHARED VARIABLE h_br_pagto_conjunto  AS widget-handle no-undo.

def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new shared temp-table tt_xml_output_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .


run prgfin/apb/apb717ec.p .

IF  VALID-HANDLE(h_br_pagto_conjunto) THEN DO:
    FIND FIRST tit_ap
        WHERE RECID(tit_ap) = v_rec_tit_ap NO-LOCK NO-ERROR.

    IF  AVAIL tit_ap THEN DO:
        FIND FIRST tt_titulo_antecip_pef_a_pagar
            WHERE tt_titulo_antecip_pef_a_pagar.tta_cdn_fornecedor  = tit_ap.cdn_fornecedor 
            AND   tt_titulo_antecip_pef_a_pagar.tta_cod_estab       = tit_ap.cod_estab      
            AND   tt_titulo_antecip_pef_a_pagar.tta_cod_espec_docto = tit_ap.cod_espec_docto
            AND   tt_titulo_antecip_pef_a_pagar.tta_cod_ser_docto   = tit_ap.cod_ser_docto  
            AND   tt_titulo_antecip_pef_a_pagar.tta_cod_tit_ap      = tit_ap.cod_tit_ap     
            AND   tt_titulo_antecip_pef_a_pagar.tta_cod_parcela     = tit_ap.cod_parcela    
            EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL tit_ap 
        AND tit_ap.dat_vencto_tit_ap <> tt_titulo_antecip_pef_a_pagar.tta_dat_vencto_tit_ap THEN
            ASSIGN tt_titulo_antecip_pef_a_pagar.tta_dat_vencto_tit_ap = tit_ap.dat_vencto_tit_ap
                   tt_titulo_antecip_pef_a_pagar.tta_dat_prev_pagto    = tit_ap.dat_prev_pagto.

    END.

    RUN pi_open_pagamento_conjunto IN p_wgh_object.

    h_br_pagto_conjunto:REFRESH().
END.

RETURN "OK":U .
