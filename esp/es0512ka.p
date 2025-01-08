/*****************************************************************************
** Programa..............: sea_usuar_mestre
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512ka.p
** Criado por............: Fabiano
** Criado em.............: 30/08/2007
*****************************************************************************/

/************************* Variable Definition Begin ************************/ 

def var v_cod_dat_type 
    as character 
    format "x(8)":U 
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
def var v_cod_initial 
    as character 
    format "x(8)":U 
    initial ? 
    label "Inicial" 
    no-undo. 
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)":U 
    label "Usu rio Corrente" 
    column-label "Usu rio Corrente" 
    no-undo. 
def var v_nom_attrib 
    as character 
    format "x(30)":U 
    no-undo. 
def var v_nom_title_aux 
    as character 
    format "x(60)":U 
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
def new global shared var v_rec_usuar_mestre
    as recid 
    format ">>>>>>9":U 
    initial ? 
    no-undo. 

/************************** Query Definition Begin **************************/ 

def query qr_sea_grp_clien 
    for usuar_mestre 
    scrolling. 

/************************** Browse Definition Begin *************************/ 

def browse br_sea_grp_clien query qr_sea_grp_clien display  
    usuar_mestre.cod_usuar 
    width-chars 07.43 
        column-label "Usu rio" 
    usuar_mestre.nom_usuar 
    width-chars 40.00 
        column-label "Nome" 
    with no-box separators single  
         size 65.14 by 07.00 
         font 1 
         bgcolor 15. 

/************************ Rectangle Definition Begin ************************/ 

def rectangle rt_cxcf 
    size 1 by 1 
    fgcolor 1 edge-pixels 2. 
def rectangle rt_cxcl 
    size 1 by 1 
    edge-pixels 2. 

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

/************************ Radio-Set Definition Begin ************************/ 

def var rs_sea_grp_clien 
    as character 
    initial "Por C¢digo" 
    view-as radio-set Horizontal 
    radio-buttons "Por C¢digo", "Por C¢digo","Por Descri‡Æo", "Por Descri‡Æo" 
    bgcolor 15  
    no-undo. 

/************************** Frame Definition Begin **************************/ 

def frame f_sea_01_grp_clien 
    rt_cxcf 
         at row 11.25 col 02.00 bgcolor 7  
    rt_cxcl 
         at row 01.00 col 01.00 bgcolor 15  
    rs_sea_grp_clien 
         at row 01.21 col 02.00 
         help "" no-label 
    br_sea_grp_clien 
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
         size-char 66.72 by 13.04 default-button bt_ok 
         view-as dialog-box 
         font 1 fgcolor ? bgcolor 8 
         title "Pesquisa Usu rios - ES0512KA - 1.00.00.001". 
    /* adjust size of objects in this frame */ 
    assign bt_can:width-chars   in frame f_sea_01_grp_clien = 10.00 
           bt_can:height-chars  in frame f_sea_01_grp_clien = 01.00 
           bt_ok:width-chars    in frame f_sea_01_grp_clien = 10.00 
           bt_ok:height-chars   in frame f_sea_01_grp_clien = 01.00 
           bt_ran:width-chars   in frame f_sea_01_grp_clien = 10.00 
           bt_ran:height-chars  in frame f_sea_01_grp_clien = 01.00 
           rt_cxcf:width-chars  in frame f_sea_01_grp_clien = 63.29 
           rt_cxcf:height-chars in frame f_sea_01_grp_clien = 01.42 
           rt_cxcl:width-chars  in frame f_sea_01_grp_clien = 65.14 
           rt_cxcl:height-chars in frame f_sea_01_grp_clien = 01.25. 
    /* set private-data for the help system */ 
    assign rs_sea_grp_clien:private-data in frame f_sea_01_grp_clien = "HLP=000015134":U 
           br_sea_grp_clien:private-data in frame f_sea_01_grp_clien = "HLP=000015134":U 
           bt_ran:private-data           in frame f_sea_01_grp_clien = "HLP=000008967":U 
           bt_ok:private-data            in frame f_sea_01_grp_clien = "HLP=000010721":U 
           bt_can:private-data           in frame f_sea_01_grp_clien = "HLP=000011050":U 
           frame f_sea_01_grp_clien:private-data                     = "HLP=000015134". 

/*********************** User Interface Trigger Begin ***********************/ 

ON CHOOSE OF bt_can IN FRAME f_sea_01_grp_clien 
DO: 

    apply "end-error" to self. 
END.

ON CHOOSE OF bt_ok IN FRAME f_sea_01_grp_clien 
DO: 

    if  avail usuar_mestre 
    then do: 
        assign v_rec_usuar_mestre = recid(usuar_mestre). 
    end /* if */. 
END.

ON CHOOSE OF bt_ran IN FRAME f_sea_01_grp_clien 
DO: 

    run prgtec/btb/btb901za.p (Input v_cod_dat_type, 
                               Input v_cod_format, 
                               Input v_nom_attrib, 
                               input-output v_cod_initial, 
                               input-output v_cod_final). 

    run pi_open_sea_grp_clien.

END.

ON VALUE-CHANGED OF rs_sea_grp_clien IN FRAME f_sea_01_grp_clien 
DO: 

    /* inifim: */ 
    case input frame f_sea_01_grp_clien  rs_sea_grp_clien: 

        when "Por C¢digo" then block_1: 
         do: 
            assign v_cod_dat_type = "character" 
                   v_cod_format   = "x(12)":U 
                   v_nom_attrib   = "C¢digo" 
                   v_cod_initial  = string("":U) 
                   v_cod_final  = string("ZZZZZZZZZZZZ":U). 

        end /* do block_1 */. 
        when "Por Descri‡Æo" then block_2: 
         do: 
            assign v_cod_dat_type = "character" 
                   v_cod_format   = "x(40)":U 
                   v_nom_attrib   = "Descri‡Æo" 
                   v_cod_initial  = string("":U) 
                   v_cod_final  = string("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":U). 

        end /* do block_2 */. 

    end /* case inifim */. 
    run pi_open_sea_grp_clien /*pi_open_sea_grp_clien*/. 

END.

/**************************** Frame Trigger Begin ***************************/ 

ON END-ERROR OF FRAME f_sea_01_grp_clien 
DO: 

    assign v_rec_usuar_mestre = ?. 
END.

ON ENTRY OF FRAME f_sea_01_grp_clien 
DO: 

    apply "value-changed" to rs_sea_grp_clien in frame f_sea_01_grp_clien. 
END.

ON WINDOW-CLOSE OF FRAME f_sea_01_grp_clien 
DO: 

    apply "end-error" to self. 
END.

/****************************** Main Code Begin *****************************/ 

/* tratamento do titulo e versÆo */ 
assign frame f_sea_01_grp_clien:title = frame f_sea_01_grp_clien:title. 

assign br_sea_grp_clien:num-locked-columns in frame f_sea_01_grp_clien = 0. 

pause 0 before-hide. 
view frame f_sea_01_grp_clien. 

assign v_rec_table    = v_rec_usuar_mestre. 

main_block: 
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block. 
    enable rs_sea_grp_clien 
           br_sea_grp_clien 
           bt_ran 
           bt_ok 
           bt_can 
           with frame f_sea_01_grp_clien. 

    wait-for go of frame f_sea_01_grp_clien 
          or default-action of br_sea_grp_clien 
          or mouse-select-dblclick of br_sea_grp_clien focus browse br_sea_grp_clien. 

    if  avail usuar_mestre 
    then do: 
        assign v_rec_usuar_mestre = recid(usuar_mestre). 
    end /* if */. 

end /* do main_block */. 

hide frame f_sea_01_grp_clien. 

/******************************* Main Code End ******************************/ 

/************************* Internal Procedure Begin *************************/ 

/***************************************************************************** 
** Procedure Interna.....: pi_open_sea_grp_clien 
** Descricao.............: pi_open_sea_grp_clien 
** Criado por............: Celso 
** Criado em.............: 17/07/1996 08:09:07 
** Alterado por..........: brf12302 
** Alterado em...........: 11/09/2000 18:01:32 
*****************************************************************************/ 
PROCEDURE pi_open_sea_grp_clien: 

    case input frame f_sea_01_grp_clien rs_sea_grp_clien: 
        when "Por C¢digo" then 
            code_block: 
            do: 
                open query qr_sea_grp_clien for 
                    each usuar_mestre no-lock 
                    WHERE usuar_mestre.cod_usuario    >= v_cod_initial 
                    AND   usuar_mestre.cod_usuario    <= v_cod_final 
                    AND   usuar_mestre.dat_fim_valid  >= TODAY
                    AND   usuar_mestre.dat_inic_valid <= TODAY
                    by usuar_mestre.cod_usuario. 
            end. 
        when "Por Descri‡Æo" then 
            name_block: 
            do: 
                open query qr_sea_grp_clien for 
                    each usuar_mestre no-lock 
                    WHERE usuar_mestre.nom_usuario    >= v_cod_initial 
                    AND   usuar_mestre.nom_usuario    <= v_cod_final 
                    AND   usuar_mestre.dat_fim_valid  >= TODAY
                    AND   usuar_mestre.dat_inic_valid <= TODAY
                    by usuar_mestre.nom_usuario. 
            end /* do name_block */. 
    end /* case case_block */. 
END PROCEDURE.

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
/***************************  End of sea_grp_clien **************************/
