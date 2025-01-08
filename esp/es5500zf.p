/*****************************************************************************
** Programa..............: sea_estabelecimento
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512zf.p
** Criado por............: Fabiano
** Criado em.............: 30/08/2007
*****************************************************************************/

/************************* Variable Definition Begin ************************/ 

def var v_cod_dat_type 
    as character 
    format "x(8)":U 
    no-undo. 
def var v_nom_title_aux 
    as character 
    format "x(60)":U 
    no-undo. 
def var v_rec_log 
    as recid 
    format ">>>>>>9":U 
    no-undo. 
def new global shared var v_rec_estab
    as recid 
    format ">>>>>>9":U 
    initial ? 
    no-undo. 

DEF VAR i-linha AS INT.
DEF NEW GLOBAL SHARED VAR c_lista_estabel AS CHAR NO-UNDO.

/************************** Query Definition Begin **************************/ 

def query qr_sea_grp_clien 
    for estabelecimento
    scrolling. 

/************************** Browse Definition Begin *************************/ 

def browse br_sea_grp_clien query qr_sea_grp_clien display  
    estabelecimento.cod_estab
    width-chars 04.43 
        column-label "Est" 
    estabelecimento.nom_abrev
    width-chars 40.00 
        column-label "Nome" 
    with no-box separators MULTIPLE
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
def button bt_todos 
    label "Todos" 
    tooltip "todos" 
    size 1 by 1. 
def button bt_nenhum 
    label "Nenhum" 
    tooltip "Nenhum" 
    size 1 by 1. 


/************************ Radio-Set Definition Begin ************************/ 

def var rs_sea_grp_clien 
    as character 
    initial "Por C¢digo" 
    view-as radio-set Horizontal 
    radio-buttons "Por C¢digo", "Por C¢digo"
    bgcolor 15  
    no-undo. 

/************************** Frame Definition Begin **************************/ 

def frame f_sea_01_grp_clien 
    rt_cxcf 
         at row 9.5 col 02.00 bgcolor 7  
    rt_cxcl 
         at row 01.00 col 01.00 bgcolor 15  
    rs_sea_grp_clien 
         at row 01.21 col 02.00 
         help "" no-label 
    br_sea_grp_clien 
         at row 02.25 col 01.00 
    bt_ok 
         at row 9.75 col 03.00 font ? 
         help "OK" 
    bt_can 
         at row 9.75 col 14.00 font ? 
         help "Cancela" 
    bt_todos
         AT ROW 9.75 COL 25.00 FONT ? 
         HELP "Todos"
    bt_nenhum
         AT ROW 9.75 COL 36.00 FONT ? 
         HELP "Nenhum"
    with 1 down side-labels no-validate keep-tab-order three-d 
         size-char 66.72 by 11.5 default-button bt_ok 
         view-as dialog-box 
         font 1 fgcolor ? bgcolor 8 
         title "Pesquisa Estabelecimento - ES5500ZF - 1.00.00.001". 
    /* adjust size of objects in this frame */ 
    assign bt_can:width-chars   in frame f_sea_01_grp_clien = 10.00 
           bt_can:height-chars  in frame f_sea_01_grp_clien = 01.00 
           bt_ok:width-chars    in frame f_sea_01_grp_clien = 10.00 
           bt_ok:height-chars   in frame f_sea_01_grp_clien = 01.00 
           bt_todos:width-chars    in frame f_sea_01_grp_clien = 10.00 
           bt_todos:height-chars   in frame f_sea_01_grp_clien = 01.00 
           bt_nenhum:width-chars    in frame f_sea_01_grp_clien = 10.00 
           bt_nenhum:height-chars   in frame f_sea_01_grp_clien = 01.00 
           rt_cxcf:width-chars  in frame f_sea_01_grp_clien = 63.29 
           rt_cxcf:height-chars in frame f_sea_01_grp_clien = 01.42 
           rt_cxcl:width-chars  in frame f_sea_01_grp_clien = 65.14 
           rt_cxcl:height-chars in frame f_sea_01_grp_clien = 01.25. 
    /* set private-data for the help system */ 
    assign rs_sea_grp_clien:private-data in frame f_sea_01_grp_clien = "HLP=000015134":U 
           br_sea_grp_clien:private-data in frame f_sea_01_grp_clien = "HLP=000015134":U 
           bt_ok:private-data            in frame f_sea_01_grp_clien = "HLP=000010721":U 
           bt_can:private-data           in frame f_sea_01_grp_clien = "HLP=000011050":U 
           frame f_sea_01_grp_clien:private-data                     = "HLP=000015134". 

/*********************** User Interface Trigger Begin ***********************/ 

ON CHOOSE OF bt_can IN FRAME f_sea_01_grp_clien 
DO: 

    apply "end-error" to self. 
END.

ON CHOOSE OF bt_nenhum IN FRAME f_sea_01_grp_clien DO:

    br_sea_grp_clien:DESELECT-ROWS().   
END.


ON CHOOSE OF bt_todos IN FRAME f_sea_01_grp_clien DO:

    br_sea_grp_clien:SELECT-ALL().   
END.

ON CHOOSE OF bt_ok IN FRAME f_sea_01_grp_clien DO: 
    ASSIGN c_lista_estabel = "".

    DO i-linha = 1 TO br_sea_grp_clien:NUM-SELECTED-ROWS :
       if  br_sea_grp_clien:fetch-selected-row(i-linha) then do:       
           ASSIGN c_lista_estabel = c_lista_estabel + estabelecimento.cod_estab + IF  i-linha < br_sea_grp_clien:NUM-SELECTED-ROWS THEN "," ELSE "".                      
       END.
    END.    
END.

ON VALUE-CHANGED OF rs_sea_grp_clien IN FRAME f_sea_01_grp_clien 
DO: 

    run pi_open_sea_grp_clien /*pi_open_sea_grp_clien*/. 

END.

/**************************** Frame Trigger Begin ***************************/ 

ON END-ERROR OF FRAME f_sea_01_grp_clien 
DO: 

    assign v_rec_estab = ?. 
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

/* tratamento do titulo e vers∆o */ 
assign frame f_sea_01_grp_clien:title = frame f_sea_01_grp_clien:title. 

assign br_sea_grp_clien:num-locked-columns in frame f_sea_01_grp_clien = 0. 

pause 0 before-hide. 
view frame f_sea_01_grp_clien. 

main_block: 
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block. 
    enable rs_sea_grp_clien 
           br_sea_grp_clien 
           bt_ok 
           bt_todos
           bt_nenhum
           bt_can 
           with frame f_sea_01_grp_clien. 

    wait-for go of frame f_sea_01_grp_clien. 

    if  avail estabelecimento then do: 
        assign v_rec_estab = recid(estabelecimento). 
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
                    each estabelecimento WHERE (estabelecimento.cod_empresa = "1" 
                                         OR     estabelecimento.cod_empresa = "5"
                                         OR     estabelecimento.cod_empresa = "6")
                                         AND    estabelecimento.cod_estab  <> "102" 
                                         AND    estabelecimento.cod_estab  <>  "201"  no-lock. 
            end. 
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
                "Programa Mensagem" c_prg_msg "n∆o encontrado." 
                view-as alert-box error. 
        return error. 
    end. 

    run value(c_prg_msg + ".p":U) (input c_action, input c_param). 
    return return-value. 
END PROCEDURE.  /* pi_messages */ 
/***************************  End of sea_grp_clien **************************/
