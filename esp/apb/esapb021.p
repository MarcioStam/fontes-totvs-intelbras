/*****************************************************************************
** Descricao.............: Importaá∆o - SISCOMEX
** Versao................:  5.00.00.000
** Nome Externo..........: esp/apb/esapb021.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 01/03/2010
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
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
         resize               = yes
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.

/*************************** Window Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_rec_fornecedor
    as recid
    format ">>>>>>9":U
    no-undo.
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
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
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
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
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
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
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
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_des_filespec
    as character
    format "x(10)":U
    extent 10
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_historico
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Hist¢rico"
    column-label "Hist¢rico"
    no-undo.
def var v_nom_filename
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    no-undo.
def var v_nom_name
    as character
    format "x(20)":U
    extent 10
    no-undo.
def var v_nom_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.

def new global shared var v_nom_filename_import
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 0.88
    bgcolor 15 font 2
    label "Nome Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_estab_imp
    as character
    format "x(03)":U
    VIEW-AS FILL-IN
    size 4 by 0.88
    bgcolor 15 font 2
    label "Estab. Borderì"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_portador_imp
    as character
    format "x(05)":U
    VIEW-AS FILL-IN
    size 06 by 0.88
    bgcolor 15 font 2
    label "Portador Borderì"
    column-label "Portador Borderì"
    no-undo.
def new global shared var v_dat_bordero_imp
    as DATE
    format "99/99/9999":U
    VIEW-AS FILL-IN
    size 11 by 0.88
    bgcolor 15 font 2
    label "Data Borderì"
    column-label "Data Borderì"
    no-undo.
def new global shared var v_val_bordero_imp
    as DEC
    FORMAT ">>>>,>>>,>>9.99"
    VIEW-AS FILL-IN
    size 16.14 by 0.88
    bgcolor 15 font 2
    label "Valor Borderì"
    column-label "Valor Borderì"
    no-undo.
def new global shared var v_remessa
    as INT
    FORMAT ">>>,>>>,>>9"
    VIEW-AS FILL-IN
    size 16.14 by 0.88
    bgcolor 15 font 2
    label "Remessa"
    column-label "Remessa"
    no-undo.
def new global shared var v_cdn_fornec_esapb021
    as INT
    FORMAT ">>>,>>>,>>9"
    VIEW-AS FILL-IN
    size 16.14 by 0.88
    bgcolor 15 font 2
    label "Fornecedor"
    column-label "Fornecedor"
    no-undo.
def new global shared var v_log_reproces
    as LOG
    FORMAT "Sim/N∆o"
    INITIAL NO
    label "Reprocessamento"
    column-label "Reprocessamento"
    no-undo.
def new global shared var v_num_reproces
    as INT
    INITIAL 1
    VIEW-AS FILL-IN
    size 3 by 0.88
    bgcolor 15 font 2
    no-undo.
def new global shared var v_process
    as INT
    INITIAL 3
    VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "CSV", 1, "XML", 2, "WS", 3
    size 20 by 0.88
    no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

def sub-menu  mi_table
    menu-item mi_exi               label "Sa°da".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Tabela".

/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 1 by 1.
def button bt_rnl1
    label "Exc"
    tooltip "Executar Lista"
    image-up file "image/im-rnl"
    image-insensitive file "image/ii-rnl"
    size 1 by 1.
def button bt_get_file2_264936
    label "Get"
    tooltip "Encontra Arquivo"
    image-up file "image/im-sea2"
    image-insensitive file "image/ii-sea2"
    size 4 by 1.1.
def button bt_sea1
    label "Psq"
    tooltip "Pesquisa"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 4 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    v_cod_estab_imp  
         at row 03.20 col 18.00 COLON-ALIGNED
    v_cod_portador_imp
         at row 04.20 col 18.00 COLON-ALIGNED
    v_log_reproces
         at row 04.20 col 40.00
         view-as TOGGLE-BOX SIZE 15 BY 0.88
    v_num_reproces
         at row 04.20 col 56.00 NO-LABEL FORMAT "99"
    v_dat_bordero_imp
         at row 05.20 col 18.00 COLON-ALIGNED
    v_process
         AT ROW 05.20 COL 40 NO-LABEL
    v_val_bordero_imp
         at row 06.20 col 18.00 COLON-ALIGNED
    v_remessa
         at row 06.20 col 42.65
    v_cdn_fornec_esapb021
         at row 06.20 col 41.30
    bt_sea1  
         AT ROW 06.20 COL 66.30
    v_nom_filename_import
         at row 07.20 col 18.00 colon-aligned label "Nome Arquivo"
         help "Arquivo com os dados para importaá∆o"
         view-as editor max-chars 250 no-word-wrap
         size 46 by 0.88
         bgcolor 15 font 2
    bt_get_file2_264936
         at row 07.12 col 66.25
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 76.34 font ?
         help "Sa°da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 09.29
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Importaá∆o - SISCOMEX (esapb021) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 78.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 06.50
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_nom_filename_import:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           bt_get_file2_264936:private-data      in frame f_bas_10_histor_fornec_import_ems = "HLP=000023693":U
           v_nom_filename_import:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data                             = "HLP=000023693".
    /* enable function buttons */
    assign bt_get_file2_264936:sensitive in frame f_bas_10_histor_fornec_import_ems = yes.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_sea1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    RUN prgint/utb/utb031nb.p.

    IF v_rec_fornecedor <> ?
    THEN DO:
         FIND emscad.fornecedor NO-LOCK 
            WHERE RECID(emscad.fornecedor) = v_rec_fornecedor NO-ERROR.
         IF AVAIL emscad.fornecedor
            THEN ASSIGN v_cdn_fornec_esapb021:SCREEN-VALUE IN FRAME f_bas_10_histor_fornec_import_ems = STRING(emscad.fornecedor.cdn_fornec).
    END.

END.


ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    assign v_cod_estab_imp  
           v_cod_portador_imp
           v_dat_bordero_imp
           v_val_bordero_imp
           v_remessa
           v_cdn_fornec_esapb021
           v_nom_filename_import
           v_log_reproces
           v_num_reproces
           v_process.

    IF v_process = 1 OR
       v_process = 2 THEN DO:
        run pi_filename_validation (Input v_nom_filename_import) /*pi_filename_validation*/.
        if  return-value = "NOK" /*l_nok*/ 
        then do:
            /* Arquivo a ser importado n∆o foi encontrado ! */
            run pi_messages (input "show",
                             input 2175,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2175*/.
            return no-apply.
        end /* if */.
        if  search(v_nom_filename_import) = ?
        then do:
            /* Arquivo a ser importado n∆o foi encontrado ! */
            run pi_messages (input "show",
                             input 2175,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2175*/.
            return no-apply.
        end /* if */.
    END.

    IF v_process = 1
    THEN DO:
         FIND fornec_financ NO-LOCK
             WHERE fornec_financ.cod_empresa = v_cod_empres_usuar
               AND fornec_financ.cdn_fornec  = v_cdn_fornec_esapb021 NO-ERROR.
         IF NOT AVAIL fornec_financ 
         THEN DO:
              MESSAGE "Fornecedor Financeiro n∆o Localizado!"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              RETURN NO-APPLY.
         END.
    END.

    run esp/apb/esapb021rp.p.
END.


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/

ON VALUE-CHANGED OF v_log_reproces IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    ASSIGN v_log_reproces.

    IF v_log_reproces THEN
        ENABLE v_num_reproces
            WITH FRAME f_bas_10_histor_fornec_import_ems.
    ELSE
        DISABLE v_num_reproces
            WITH FRAME f_bas_10_histor_fornec_import_ems.

END.


ON VALUE-CHANGED OF v_process IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    ASSIGN v_process.
    ASSIGN v_nom_filename_import:SCREEN-VALUE IN FRAME f_bas_10_histor_fornec_import_ems = ""
           v_remessa:SCREEN-VALUE             IN FRAME f_bas_10_histor_fornec_import_ems = "0":U
           v_cdn_fornec_esapb021:SCREEN-VALUE IN FRAME f_bas_10_histor_fornec_import_ems = "0":U.

    IF v_process = 1 OR
       v_process = 2 THEN DO:
        ENABLE v_nom_filename_import
               bt_get_file2_264936
            WITH FRAME f_bas_10_histor_fornec_import_ems.

        ASSIGN v_remessa:VISIBLE             = FALSE
               v_cdn_fornec_esapb021:VISIBLE = TRUE
               bt_sea1:VISIBLE               = TRUE.

        IF v_process = 2 
           THEN ASSIGN v_cdn_fornec_esapb021:VISIBLE = FALSE
                       bt_sea1:VISIBLE               = FALSE.

    END.
    ELSE DO:
        DISABLE v_nom_filename_import
                bt_get_file2_264936
            WITH FRAME f_bas_10_histor_fornec_import_ems.

        ASSIGN v_remessa:VISIBLE             = TRUE
               v_cdn_fornec_esapb021:VISIBLE = FALSE
               bt_sea1:VISIBLE               = FALSE.
    END.
END.


ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_10_histor_fornec_import_ems
OR F5 OF v_nom_filename_import IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_get_file                   as character       no-undo. /*local*/
    def var v_log_pressed                    as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    IF v_process = 2 
    THEN DO:
         system-dialog get-file v_cod_get_file
             title "Procurando..." /*l_procurando...*/ 
             filters 'Arquivo XML (*.xml)' '*.xml'
             must-exist
             update v_log_pressed.
    END.
    ELSE IF v_process = 1 THEN DO:
         system-dialog get-file v_cod_get_file
             title "Procurando..." /*l_procurando...*/ 
             filters 'Arquivo CSV (*.csv)' '*.csv'
             must-exist
             update v_log_pressed.
    END.

    if  v_log_pressed = yes
    then do:
        assign v_nom_filename_import:screen-value in frame f_bas_10_histor_fornec_import_ems = v_cod_get_file.
        apply "entry" to v_nom_filename_import in frame f_bas_10_histor_fornec_import_ems.
    end /* if */.

end. /* ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_10_histor_fornec_import_ems */

/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

/*************************** Window Trigger Begin ***************************/

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_histor_fornec_import_ems.
END.

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign wh_w_program:title         = frame f_bas_10_histor_fornec_import_ems:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_10_histor_fornec_import_ems:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_histor_fornec_import_ems:width-chars
       wh_w_program:height-chars  = frame f_bas_10_histor_fornec_import_ems:height-chars - 0.85
       frame f_bas_10_histor_fornec_import_ems:row         = 1
       frame f_bas_10_histor_fornec_import_ems:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_10_histor_fornec_import_ems:handle).

pause 0 before-hide.

view frame f_bas_10_histor_fornec_import_ems.

enable bt_rnl1
       bt_exi
       v_cod_estab_imp  
       v_cod_portador_imp
       v_log_reproces
       v_num_reproces
       v_dat_bordero_imp
       v_val_bordero_imp
       v_remessa
       v_cdn_fornec_esapb021
       bt_sea1
       v_process
       v_nom_filename_import
       with frame f_bas_10_histor_fornec_import_ems.

ASSIGN v_cod_estab_imp   = v_cod_estab_usuar
       v_dat_bordero_imp = TODAY
       v_process         = 3
       v_remessa         = 0
       v_cdn_fornec_esapb021 = 0.

DISP v_cod_estab_imp  
     v_cod_portador_imp
     v_log_reproces
     v_num_reproces
     v_dat_bordero_imp
     v_val_bordero_imp 
     v_remessa
     v_cdn_fornec_esapb021
     v_process WITH FRAME f_bas_10_histor_fornec_import_ems.

APPLY "VALUE-CHANGED" TO v_log_reproces.
APPLY "VALUE-CHANGED" TO v_process.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_nom_filename_import:read-only in frame f_bas_10_histor_fornec_import_ems = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_histor_fornec_import_ems.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END PROCEDURE. /* pi_close_program */
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/
    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.
    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/
    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/
    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/
    def Input param p_cod_filename
        as character
        format "x(40)"
        no-undo.
    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/
    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/
    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "."
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(v_cod_1, "~/~/") > 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0
        then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).
    if  length(v_cod_2) > 8
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE.
PROCEDURE pi_system_dialog_get_file:

    system-dialog get-file v_nom_filename
        title v_nom_title
        filters v_nom_name[1]  v_des_filespec[1] ,
                v_nom_name[2]  v_des_filespec[2] ,
                v_nom_name[3]  v_des_filespec[3] ,
                v_nom_name[4]  v_des_filespec[4] ,
                v_nom_name[5]  v_des_filespec[5] ,
                v_nom_name[6]  v_des_filespec[6] ,
                v_nom_name[7]  v_des_filespec[7] ,
                v_nom_name[8]  v_des_filespec[8] ,
                v_nom_name[9]  v_des_filespec[9] ,
                v_nom_name[10] v_des_filespec[10]
        must-exist
        initial-dir v_nom_filename
        use-filename
        update v_log_answer.

END PROCEDURE.
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
END PROCEDURE.
