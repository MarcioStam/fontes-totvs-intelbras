/*****************************************************************************
** Descricao.............: Relaá∆o movimentos ocorrància banc†ria
** Versao................:  5.00.00.000
** Nome Externo..........: esp/acr/esacr026.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 26/10/2009
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

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.
DEF VAR v_nom_filename 
    AS CHARACTER 
    FORMAT "x(80)":U
    VIEW-AS EDITOR MAX-CHARS 250 NO-WORD-WRAP 
    SIZE 40 BY 1
    BGCOLOR 15 FONT 2
    LABEL "Nome Arquivo"
    NO-UNDO.
DEF VAR v_nom_name
    AS CHARACTER 
    FORMAT "x(20)":U
    EXTENT 10
    NO-UNDO.
DEF VAR v_des_filespec
    AS CHARACTER 
    FORMAT "x(10)":U
    EXTENT 10
    NO-UNDO.
DEF VAR v_nom_title
    AS CHARACTER 
    FORMAT "x(40)":U
    NO-UNDO.
DEF VAR v_log_answer
    AS LOGICAL 
    FORMAT "Sim/N∆o"
    INITIAL YES 
    VIEW-AS TOGGLE-BOX 
    NO-UNDO.
DEF VAR v_dat_ini       AS DATE FORMAT "99/99/9999"  INITIAL "01/01/0001" LABEL "Data" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_dat_fim       AS DATE FORMAT "99/99/9999"  INITIAL "12/31/9999" LABEL "atÇ" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_dat_aux       AS DATE NO-UNDO.
DEF VAR v_cod_arq       AS CHAR.
DEF VAR v_cod_filename_initial AS CHAR NO-UNDO.
DEF VAR v_cod_filename_final   AS CHAR NO-UNDO.

/************************** Variable Definition End *************************/

/*************************** Temp-Table Definition Begin **************************/

DEF TEMP-TABLE tt_cliente_matriz NO-UNDO
    FIELD ttv_cdn_cliente AS INT
    INDEX cliente_matriz  IS PRIMARY UNIQUE 
          ttv_cdn_cliente ASCENDING.

/**************************** Temp-Table Definition End ***************************/

/*************************** Buffer Definition Begin **************************/

DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
DEF BUFFER b_cliente      FOR emscad.cliente.

/**************************** Buffer Definition End ***************************/

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
    tooltip "Executar"
    image-up file "image/im-rnl"
    image-insensitive file "image/ii-rnl"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    v_dat_ini 
         at row 03.20 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_dat_fim
         at row 03.20 col 35.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cod_arq
         at row 04.8 col 18.00 colon-aligned label "Nome Arquivo"
         help "Arquivo com os dados para importaá∆o"
         view-as editor max-chars 250 no-word-wrap
         size 50 by 1
         bgcolor 15 font 2
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 76.34 font ?
         help "Sa°da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 07
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Relaá∆o Movimentos Ocorrància Banc†ria (ESACR026) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 78.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 04
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_cod_arq:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           v_cod_arq:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data                             = "HLP=000023693".
    /* enable function buttons */

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    ASSIGN v_dat_ini      
           v_dat_fim      
           v_cod_arq.

    IF v_dat_ini > v_dat_fim 
    THEN DO:
         MESSAGE "Data Inicial maior que Data Final !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.
           
    ASSIGN v_cod_arq:SCREEN-VALUE = REPLACE(v_cod_arq:SCREEN-VALUE, '~\', '/').

    IF NUM-ENTRIES(v_cod_arq, "/") = 0
    THEN DO:
         MESSAGE "Diret¢rio n∆o informado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_filename_initial = ENTRY(NUM-ENTRIES(v_cod_arq:SCREEN-VALUE, '/'), v_cod_arq:SCREEN-VALUE, '/')
           v_cod_filename_final   = SUBSTRING(v_cod_arq:SCREEN-VALUE, 1,
                                              LENGTH(v_cod_arq:SCREEN-VALUE) - LENGTH(v_cod_filename_initial) - 1)
           FILE-INFO:FILE-NAME    = v_cod_filename_final.
    IF FILE-INFO:FILE-TYPE = ?
    THEN DO:
         MESSAGE "Diret¢rio n∆o localizado: " v_cod_filename_final
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.

    PUT UNFORMATTED "estab;data;port;cart;usuar;ind ocor;tip ocor;val desp;val movto;nr bancario" SKIP.

    FOR EACH movto_ocor_bcia NO-LOCK
        WHERE movto_ocor_bcia.dat_movto_ocor_bcia >= v_dat_ini
          AND movto_ocor_bcia.dat_movto_ocor_bcia <= v_dat_fim
          AND movto_ocor_bcia.val_despes_bcia     > 0:
        
        PUT UNFORMATTED cod_estab               ";"
                        dat_movto_ocor_bcia     ";"
                        cod_portador            ";"
                        cod_cart_bcia           ";"
                        cod_usuario             ";"
                        ind_ocor_bcia_remes_ret ";"
                        ind_tip_ocor_bcia       ";"
                        val_despes_bcia         ";"
                        val_movto_ocor_bcia     ";"
                        cod_tit_acr_bco         SKIP.

    END.

    OUTPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("") THEN.

    MESSAGE "Processamento conclu°do !" SKIP(1) "Verificar arquivo: " v_cod_arq
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.


/************************ User Interface Trigger End ************************/

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
       v_dat_ini      
       v_dat_fim      
       v_cod_arq      
       with frame f_bas_10_histor_fornec_import_ems.

ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "esacr026.txt".

DISP v_dat_ini      
     v_dat_fim      
     v_cod_arq WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_cod_arq:read-only in frame f_bas_10_histor_fornec_import_ems = no.

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
