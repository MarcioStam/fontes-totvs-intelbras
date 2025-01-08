/*****************************************************************************
** Nome Externo..........: prgint/utb/utb011na.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 12/01/2009
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

&if "{&emsuni_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSUNI")) /*msg_5884*/.
&elseif "{&emsuni_version}" < "1.00" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "SEE_UNID_NEGOC_ESTAB","~~EMSUNI", "~~{~&emsuni_version}", "~~1.00")) /*msg_5009*/.
&else

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_dat_type
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_unid_negoc_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "at‚"
    column-label "Final"
    no-undo.
def var v_cod_unid_negoc_ini
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Inicial"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_des_unid_negoc_fim
    as character
    format "x(40)":U
    initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
    label "Descr Unid Negoc Fim"
    column-label "Descri‡Æo"
    no-undo.
def var v_des_unid_negoc_ini
    as character
    format "x(40)":U
    label "Descr Unid Negoc Ini"
    column-label "Descri‡Æo"
    no-undo.
def var v_nom_attrib
    as character
    format "x(30)":U
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/

/************************** Query Definition Begin **************************/

def query qr_see_unid_negoc_estab
    for estab_unid_negoc,
        unid_negoc
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_see_unid_negoc_estab query qr_see_unid_negoc_estab display 
    unid_negoc.cdn_unid_negoc
    width-chars 07.00
        column-label "Num"
    unid_negoc.cod_unid_negoc
    width-chars 05.29
        column-label "Un Neg"
    unid_negoc.des_unid_negoc
    width-chars 40.00
        column-label "Descri‡Æo"
    estab_unid_negoc.dat_inic_valid
    width-chars 10.00
        column-label "Inic Validade"
    estab_unid_negoc.dat_fim_valid
    width-chars 10.00
        column-label "Fim Valid"
    with no-box separators single 
         size 75.57 by 07.00
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_cxcl
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_ran
    label "Faixa"
    tooltip "Faixa"
    size 1 by 1.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_see_unid_negoc_estab
    as character
    initial "Por Unidade de Neg¢cio"
    view-as radio-set Horizontal
    radio-buttons "Por Unidade de Neg¢cio", "Por Unidade de Neg¢cio","Por Descri‡Æo", "Por Descri‡Æo"
     /*l_por_unidade_de_negocio*/ /*l_por_unidade_de_negocio*/ /*l_por_descricao*/ /*l_por_descricao*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_ran_01_unid_negoc
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.88 col 02.00 bgcolor 7 
    v_cod_unid_negoc_ini
         at row 01.42 col 23.00 colon-aligned label "Inicial"
         help "Unidade de Neg¢cio Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_unid_negoc_fim
         at row 02.42 col 23.00 colon-aligned label "at‚"
         help "Unidade de Neg¢cio Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.08 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 50.00 by 05.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - Unidade Neg¢cio".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_unid_negoc = 10.00
           bt_can:height-chars  in frame f_ran_01_unid_negoc = 01.00
           bt_ok:width-chars    in frame f_ran_01_unid_negoc = 10.00
           bt_ok:height-chars   in frame f_ran_01_unid_negoc = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_unid_negoc = 46.57
           rt_cxcf:height-chars in frame f_ran_01_unid_negoc = 01.42
           rt_mold:width-chars  in frame f_ran_01_unid_negoc = 46.57
           rt_mold:height-chars in frame f_ran_01_unid_negoc = 02.29.
    /* set private-data for the help system */
    assign v_cod_unid_negoc_ini:private-data in frame f_ran_01_unid_negoc = "HLP=000019459":U
           v_cod_unid_negoc_fim:private-data in frame f_ran_01_unid_negoc = "HLP=000019460":U
           bt_ok:private-data                in frame f_ran_01_unid_negoc = "HLP=000010721":U
           bt_can:private-data               in frame f_ran_01_unid_negoc = "HLP=000011050":U
           frame f_ran_01_unid_negoc:private-data                         = "HLP=000009975".

def frame f_ran_01_unid_negoc_descr
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.88 col 02.00 bgcolor 7 
    v_des_unid_negoc_ini
         at row 01.42 col 10.00 colon-aligned label "Inicial"
         help "Descri‡Æo Unidade Neg¢cio"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_unid_negoc_fim
         at row 02.42 col 10.00 colon-aligned label "Final"
         help "Descri‡Æo Unidade Neg¢cio"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.08 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 60.00 by 05.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - Descri‡Æo".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_unid_negoc_descr = 10.00
           bt_can:height-chars  in frame f_ran_01_unid_negoc_descr = 01.00
           bt_ok:width-chars    in frame f_ran_01_unid_negoc_descr = 10.00
           bt_ok:height-chars   in frame f_ran_01_unid_negoc_descr = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_unid_negoc_descr = 56.57
           rt_cxcf:height-chars in frame f_ran_01_unid_negoc_descr = 01.42
           rt_mold:width-chars  in frame f_ran_01_unid_negoc_descr = 56.57
           rt_mold:height-chars in frame f_ran_01_unid_negoc_descr = 02.29.
    /* set private-data for the help system */
    assign v_des_unid_negoc_ini:private-data in frame f_ran_01_unid_negoc_descr = "HLP=000021983":U
           v_des_unid_negoc_fim:private-data in frame f_ran_01_unid_negoc_descr = "HLP=000021984":U
           bt_ok:private-data                in frame f_ran_01_unid_negoc_descr = "HLP=000010721":U
           bt_can:private-data               in frame f_ran_01_unid_negoc_descr = "HLP=000011050":U
           frame f_ran_01_unid_negoc_descr:private-data                         = "HLP=000009975".

def frame f_see_01_unid_negoc_estab
    rt_cxcf
         at row 11.25 col 02.00 bgcolor 7 
    rt_cxcl
         at row 01.00 col 01.00 bgcolor 15 
    rs_see_unid_negoc_estab
         at row 01.21 col 03.00
         help "" no-label
    br_see_unid_negoc_estab
         at row 02.25 col 01.00
    bt_ran
         at row 09.75 col 03.00 font ?
         help "Faixa"
    bt_ok
         at row 11.46 col 03.00 font ?
         help "OK"
    bt_can
         at row 11.46 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 78.00 by 13.08 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Pesquisa Unidade Neg¢cio Estabelecimento".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_see_01_unid_negoc_estab = 10.00
           bt_can:height-chars  in frame f_see_01_unid_negoc_estab = 01.00
           bt_ok:width-chars    in frame f_see_01_unid_negoc_estab = 10.00
           bt_ok:height-chars   in frame f_see_01_unid_negoc_estab = 01.00
           bt_ran:width-chars   in frame f_see_01_unid_negoc_estab = 10.00
           bt_ran:height-chars  in frame f_see_01_unid_negoc_estab = 01.00
           rt_cxcf:width-chars  in frame f_see_01_unid_negoc_estab = 74.57
           rt_cxcf:height-chars in frame f_see_01_unid_negoc_estab = 01.42
           rt_cxcl:width-chars  in frame f_see_01_unid_negoc_estab = 75.57
           rt_cxcl:height-chars in frame f_see_01_unid_negoc_estab = 01.25.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_see_unid_negoc_estab:ALLOW-COLUMN-SEARCHING in frame f_see_01_unid_negoc_estab = no
       br_see_unid_negoc_estab:COLUMN-MOVABLE in frame f_see_01_unid_negoc_estab = no.
end.
&endif
    /* set private-data for the help system */
    assign rs_see_unid_negoc_estab:private-data in frame f_see_01_unid_negoc_estab = "HLP=000009975":U
           br_see_unid_negoc_estab:private-data in frame f_see_01_unid_negoc_estab = "HLP=000009975":U
           bt_ran:private-data                  in frame f_see_01_unid_negoc_estab = "HLP=000008967":U
           bt_ok:private-data                   in frame f_see_01_unid_negoc_estab = "HLP=000010721":U
           bt_can:private-data                  in frame f_see_01_unid_negoc_estab = "HLP=000011050":U
           frame f_see_01_unid_negoc_estab:private-data                            = "HLP=000009975".

{include/i_fclfrm.i f_ran_01_unid_negoc f_ran_01_unid_negoc_descr f_see_01_unid_negoc_estab }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/
ON CHOOSE OF bt_can IN FRAME f_see_01_unid_negoc_estab
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_see_01_unid_negoc_estab */

ON CHOOSE OF bt_ok IN FRAME f_see_01_unid_negoc_estab
DO:

    if  avail unid_negoc
    then do:
        assign v_rec_unid_negoc = recid(unid_negoc).
    end /* if */.
END. /* ON CHOOSE OF bt_ok IN FRAME f_see_01_unid_negoc_estab */

ON CHOOSE OF bt_ran IN FRAME f_see_01_unid_negoc_estab
DO:

    /* case_block: */
    case input frame f_see_01_unid_negoc_estab rs_see_unid_negoc_estab:
        when "Por Unidade de Neg¢cio" /*l_por_unidade_de_negocio*/ then
            cod_unid_negoc_block:
            do:

              /* Begin_Include: i_see_range */
              view frame f_ran_01_unid_negoc.

              range_block:
              do on error undo range_block, retry range_block:
                  update v_cod_unid_negoc_ini
                         v_cod_unid_negoc_fim
                         bt_ok
                         bt_can
                         with frame f_ran_01_unid_negoc.
                  run pi_open_see_unid_negoc_estab /*pi_open_see_unid_negoc_estab*/.
              end /* do range_block */.

              hide frame f_ran_01_unid_negoc.

              /* End_Include: i_see_range */

            end /* do cod_unid_negoc_block */.
        when "Por Descri‡Æo" /*l_por_descricao*/ then
            des_unid_negoc_block:
            do:

              /* Begin_Include: i_see_range */
              view frame f_ran_01_unid_negoc_descr.

              range_block:
              do on error undo range_block, retry range_block:
                  update v_des_unid_negoc_ini
                         v_des_unid_negoc_fim
                         bt_ok
                         bt_can
                         with frame f_ran_01_unid_negoc_descr.
                  run pi_open_see_unid_negoc_estab /*pi_open_see_unid_negoc_estab*/.
              end /* do range_block */.

              hide frame f_ran_01_unid_negoc_descr.

              /* End_Include: i_see_range */

            end /* do des_unid_negoc_block */.
    end /* case case_block */.
END. /* ON CHOOSE OF bt_ran IN FRAME f_see_01_unid_negoc_estab */

ON VALUE-CHANGED OF rs_see_unid_negoc_estab IN FRAME f_see_01_unid_negoc_estab
DO:

    run pi_open_see_unid_negoc_estab /*pi_open_see_unid_negoc_estab*/.
END. /* ON VALUE-CHANGED OF rs_see_unid_negoc_estab IN FRAME f_see_01_unid_negoc_estab */


/************************ User Interface Trigger End ************************/

ON WINDOW-CLOSE OF FRAME f_ran_01_unid_negoc
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_ran_01_unid_negoc */

ON WINDOW-CLOSE OF FRAME f_ran_01_unid_negoc_descr
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_ran_01_unid_negoc_descr */

ON VALUE-CHANGED OF FRAME f_see_01_unid_negoc_estab
DO:

    run pi_open_see_unid_negoc_estab /*pi_open_see_unid_negoc_estab*/.
END. /* ON VALUE-CHANGED OF FRAME f_see_01_unid_negoc_estab */

ON END-ERROR OF FRAME f_see_01_unid_negoc_estab
DO:

    assign v_rec_unid_negoc = ?.
END. /* ON END-ERROR OF FRAME f_see_01_unid_negoc_estab */

ON ENTRY OF FRAME f_see_01_unid_negoc_estab
DO:

    apply "value-changed" to rs_see_unid_negoc_estab in frame f_see_01_unid_negoc_estab.

END. /* ON ENTRY OF FRAME f_see_01_unid_negoc_estab */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
/*{include/i-ctrlrp5.i see_unid_negoc_estab}*/

if  v_rec_estabelecimento = ?
then do:
    /* Estabelecimento Desconhecido ! */
    run pi_messages (input "show",
                     input 626,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_626*/.
    return.
end /* if */.
else do:
    find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
    assign v_rec_unid_negoc = ?.
end /* else */.
/* End_Include: ix_p00_see_unid_negoc_estab */


/* redefini‡äes do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e versÆo */
assign frame f_see_01_unid_negoc_estab:title = frame f_see_01_unid_negoc_estab:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).

assign br_see_unid_negoc_estab:num-locked-columns in frame f_see_01_unid_negoc_estab = 0.

pause 0 before-hide.
view frame f_see_01_unid_negoc_estab.

assign v_rec_table    = v_rec_unid_negoc.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.
    display rs_see_unid_negoc_estab
            with frame f_see_01_unid_negoc_estab.

    enable rs_see_unid_negoc_estab
           br_see_unid_negoc_estab
           bt_ran
           bt_ok
           bt_can
           with frame f_see_01_unid_negoc_estab.

    wait-for go of frame f_see_01_unid_negoc_estab
          or default-action of br_see_unid_negoc_estab
          or mouse-select-dblclick of br_see_unid_negoc_estab.
    if  avail unid_negoc
    then do:
        assign v_rec_unid_negoc = recid(unid_negoc).
    end /* if */.
    /* ix_p20_see_unid_negoc_estab */
end /* do main_block */.

hide frame f_see_01_unid_negoc_estab.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_see_unid_negoc_estab
** Descricao.............: pi_open_see_unid_negoc_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: src388
** Alterado em...........: 17/08/2001 10:04:47
*****************************************************************************/
PROCEDURE pi_open_see_unid_negoc_estab:

    /* case_block: */
    case input frame f_see_01_unid_negoc_estab rs_see_unid_negoc_estab:
        when "Por Unidade de Neg¢cio" /*l_por_unidade_de_negocio*/ then
            code_block:
            do:
            &if '{&emsfin_version}' >= '5.05' &then
                open query qr_see_unid_negoc_estab for
                        each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab = estabelecimento.cod_estab

                          and estab_unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
                          and estab_unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim /*cl_see_estab_unid_negoc_codigo of estab_unid_negoc*/,
                        first unid_negoc no-lock
                            where unid_negoc.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc
                              and unid_negoc.ind_espec_unid_negoc <> "Sint‚tica" /*l_sintetica*/ 
                        by unid_negoc.cod_unid_negoc.
            &else
                open query qr_see_unid_negoc_estab for
                        each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab = estabelecimento.cod_estab

                          and estab_unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
                          and estab_unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim /*cl_see_estab_unid_negoc_codigo of estab_unid_negoc*/,
                        first unid_negoc no-lock
                        where unid_negoc.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc

                        by unid_negoc.cod_unid_negoc.
            &endif
            end /* do code_block */.
        when "Por Descri‡Æo" /*l_por_descricao*/ then
            name_block:
            do:
            &if '{&emsfin_version}' >= '5.05' &then
                open query qr_see_unid_negoc_estab for
                        each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab = estabelecimento.cod_estab
                        ,
                        first unid_negoc no-lock
                        where unid_negoc.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc

                          and unid_negoc.des_unid_negoc >= v_des_unid_negoc_ini
                          and unid_negoc.des_unid_negoc <= v_des_unid_negoc_fim
                          and ind_espec_unid_negoc <> "Sint‚tica" /*cl_sea_descr_1 of unid_negoc*/
                        by unid_negoc.des_unid_negoc.
            &else
                open query qr_see_unid_negoc_estab for
                        each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab = estabelecimento.cod_estab
                        ,
                        first unid_negoc no-lock
                        where unid_negoc.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc

                          and unid_negoc.des_unid_negoc >= v_des_unid_negoc_ini
                          and unid_negoc.des_unid_negoc <= v_des_unid_negoc_fim /*cl_sea_descr of unid_negoc*/
                        by unid_negoc.des_unid_negoc.
            &endif
            end /* do name_block */.
    end /* case case_block */.
END PROCEDURE. /* pi_open_see_unid_negoc_estab */
/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/
&endif

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of see_unid_negoc_estab ***********************/
