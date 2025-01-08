/*****************************************************************************
** Descricao.............: Altera Status SERASA/PEFIN
** Nome Externo..........: esp/acr/esacr055a.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 17/10/2012
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

DISABLE TRIGGERS FOR LOAD OF tit_acr.
DISABLE TRIGGERS FOR LOAD OF histor_movto_tit_acr.

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_estab    LIKE tit_acr.cod_estab    NO-UNDO.
DEFINE VARIABLE v_cod_espec    LIKE tit_acr.cod_espec    NO-UNDO.
DEFINE VARIABLE v_cod_ser      LIKE tit_acr.cod_ser      NO-UNDO.
DEFINE VARIABLE v_cod_tit_acr  LIKE tit_acr.cod_tit_acr  NO-UNDO.
DEFINE VARIABLE v_cod_parcela  LIKE tit_acr.cod_parcela  NO-UNDO.
DEFINE VARIABLE v_log_status   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_log_answer   AS LOGICAL     NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF BUFFER b_histor_movto_tit_acr FOR histor_movto_tit_acr.

def var rs_qry_item_bord_acr
    as character
    initial "Retira"
    view-as radio-set Horizontal
    radio-buttons "Retira PEFIN", "Retira PEFIN", "Inclui PEFIN", "Inclui PEFIN"
    bgcolor 15 
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
def rectangle rt_mold2
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
def button bt_enter
    label "Entra"
    tooltip "Entra"
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_altera_status_pefin
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    rt_mold2
         at row 05 col 02.00
    v_cod_estab
         at row 02.67 col 11.72 colon-aligned label "Estab"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec
         at row 02.67 col 23.43 colon-aligned label "EspÇcie"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ser
         at row 02.67 col 34.86 colon-aligned label "SÇrie"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_tit_acr
         at row 02.67 col 47.00 colon-aligned label "T°tulo"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_parcela
         at row 02.67 col 60.5 no-label
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_enter
         at row 02.67 col 64 font ?
         help "Entra"
    tit_acr.cdn_cliente
         at row 03.67 col 11.72 colon-aligned label "Cliente"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    emscad.cliente.nom_pessoa
         at row 03.67 col 26.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    tit_acr.cod_indic_econ
         at row 05.5 col 7 colon-aligned label "Moeda"
         fgcolor ? bgcolor 15 font 2
    tit_acr.val_origin_tit_acr
         at row 06.5 col 7 colon-aligned label "Vl Orig"
         fgcolor ? bgcolor 15 font 2
    tit_acr.val_sdo_tit_acr
         at row 07.5 col 7 colon-aligned label "Saldo"
         fgcolor ? bgcolor 15 font 2
    tit_acr.cod_portad
         at row 05.5 col 31 colon-aligned label "Portador"
         fgcolor ? bgcolor 15 font 2
    tit_acr.cod_cart_bcia
         at row 06.5 col 31 colon-aligned label "Carteira"
         fgcolor ? bgcolor 15 font 2
    tit_acr.cod_cond_cobr
         at row 07.5 col 31 colon-aligned label "Cond Cobr"
         fgcolor ? bgcolor 15 font 2
    tit_acr.dat_emis
         at row 05.5 col 47 colon-aligned label "Emiss∆o"
         fgcolor ? bgcolor 15 font 2
    tit_acr.dat_vencto_tit_acr
         at row 06.5 col 47 colon-aligned label "Vencto"
         fgcolor ? bgcolor 15 font 2
    int_tit_acr.dat_envi_asses_cob
         at row 05.5 col 66 colon-aligned label "Inclus∆o"
         fgcolor ? bgcolor 15 font 2
    int_tit_acr.dat_ret_asses_cob     
         at row 06.5 col 66 colon-aligned label "Exclus∆o"
         fgcolor ? bgcolor 15 font 2
    rs_qry_item_bord_acr
         at row 01.28 col 14.00
         help "" no-label
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
         title "Altera Status PEFIN/SERASA (ESACR055) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_altera_status_pefin = 04.00
           bt_exi:height-chars    in frame f_altera_status_pefin = 01.13
           bt_rnl1:width-chars    in frame f_altera_status_pefin = 04.00
           bt_rnl1:height-chars   in frame f_altera_status_pefin = 01.13
           rt_mold:width-chars    in frame f_altera_status_pefin = 78.44
           rt_mold:height-chars   in frame f_altera_status_pefin = 02.3
           rt_mold2:width-chars   in frame f_altera_status_pefin = 78.44
           rt_mold2:height-chars  in frame f_altera_status_pefin = 04
           rt_rgf:width-chars     in frame f_altera_status_pefin = 80.44
           rt_rgf:height-chars    in frame f_altera_status_pefin = 01.29
           bt_enter:height-chars  in frame f_altera_status_pefin = 00.88
           bt_enter:width-chars   in frame f_altera_status_pefin = 04.00.
    /* set return-inserted = yes for editors */
    assign bt_rnl1:private-data                  in frame f_altera_status_pefin = "HLP=000008794":U
           bt_exi:private-data                   in frame f_altera_status_pefin = "HLP=000004665":U
           frame f_altera_status_pefin:private-data                             = "HLP=000023693".
    /* enable function buttons */

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_exi IN FRAME f_altera_status_pefin
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_altera_status_pefin
DO:

    APPLY "choose" TO bt_enter IN FRAME f_altera_status_pefin.

    IF v_log_status = NO 
       THEN RETURN NO-APPLY.

    IF rs_qry_item_bord_acr = "Retira PEFIN" 
    THEN DO:

         FIND int_tit_acr OF tit_acr EXCLUSIVE-LOCK NO-ERROR.

         IF NOT AVAIL int_tit_acr
         OR tit_acr.cod_cond_cobr           = ""
         OR int_tit_acr.dat_ret_asses_cob  <> ?
         OR int_tit_acr.dat_envi_asses_cob  = ?
         THEN DO:
              MESSAGE "T°tulo n∆o est† registrado no PEFIN!"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              RETURN NO-APPLY.
         END.

         ASSIGN v_log_answer = NO.
        
         MESSAGE "Confirma retirada MANUAL do PEFIN?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "PEFIN" UPDATE v_log_answer.
        
         IF v_log_answer = NO
            THEN RETURN NO-APPLY.

         FIND tit_acr EXCLUSIVE-LOCK
            WHERE tit_acr.cod_estab   = v_cod_estab  
              AND tit_acr.cod_espec   = v_cod_espec  
              AND tit_acr.cod_ser     = v_cod_ser    
              AND tit_acr.cod_tit_acr = v_cod_tit_acr
              AND tit_acr.cod_parcela = v_cod_parcela NO-ERROR.         

         ASSIGN tit_acr.cod_cond_cobr         = ""
                int_tit_acr.dat_ret_asses_cob = TODAY.

         FIND LAST movto_tit_acr NO-LOCK
              WHERE movto_tit_acr.cod_estab         = tit_acr.cod_estab
                AND movto_tit_acr.num_id_tit_acr    = tit_acr.num_id_tit_acr
                AND (movto_tit_acr.ind_trans_acr    = "Implantaá∆o"  OR    
                     movto_tit_acr.ind_trans_acr    = "Renegociaá∆o" OR
                     movto_tit_acr.ind_trans_acr    = "Transf Estabelecimento") NO-ERROR.

         FIND LAST b_histor_movto_tit_acr NO-LOCK
              WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                AND b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                AND b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

         CREATE histor_movto_tit_acr.
         ASSIGN histor_movto_tit_acr.cod_estab                   = movto_tit_acr.cod_estab
                histor_movto_tit_acr.num_id_tit_acr              = movto_tit_acr.num_id_tit_acr
                histor_movto_tit_acr.num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                histor_movto_tit_acr.num_seq_histor_movto_acr    = IF AVAIL b_histor_movto_tit_acr THEN (b_histor_movto_tit_acr.num_seq_histor_movto_acr + 1) ELSE 1
                histor_movto_tit_acr.ind_orig_histor_acr         = "Sistema"
                histor_movto_tit_acr.des_text_histor             = "Convem - Pefin; " + "Retirada a Condiá∆o de Cobranáa do t°tulo conforme Baixa MANUAL do Serasa (esacr055). Usu†rio: " + CAPS(v_cod_usuar_corren) + " as " + STRING(TIME,"hh:mm:ss") + " no dia " + STRING(TODAY).

         MESSAGE "T°tulo retirado manualmente do PEFIN!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.
    ELSE DO:

         FIND int_tit_acr OF tit_acr EXCLUSIVE-LOCK NO-ERROR.
         
         IF  AVAIL int_tit_acr 
         AND int_tit_acr.dat_envi_asses_cob <> ? 
         THEN DO:      
              MESSAGE "T°tulo j† est† registrado no PEFIN!"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              RETURN NO-APPLY.
         END.
             
         ASSIGN v_log_answer = NO.
        
         MESSAGE "Confirma inclus∆o MANUAL do PEFIN?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "PEFIN" UPDATE v_log_answer.
        
         IF v_log_answer = NO
            THEN RETURN NO-APPLY.

         FIND tit_acr EXCLUSIVE-LOCK
            WHERE tit_acr.cod_estab   = v_cod_estab  
              AND tit_acr.cod_espec   = v_cod_espec  
              AND tit_acr.cod_ser     = v_cod_ser    
              AND tit_acr.cod_tit_acr = v_cod_tit_acr
              AND tit_acr.cod_parcela = v_cod_parcela NO-ERROR.   
                
         ASSIGN tit_acr.cod_cond_cobr = "99".

         IF NOT AVAIL int_tit_acr 
         THEN DO:
              CREATE int_tit_acr.
              ASSIGN int_tit_acr.cod_estab      = tit_acr.cod_estab
                     int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.
         END.
         ASSIGN int_tit_acr.dat_envi_asses_cob = TODAY.

         FIND LAST movto_tit_acr NO-LOCK
              WHERE movto_tit_acr.cod_estab         = tit_acr.cod_estab
                AND movto_tit_acr.num_id_tit_acr    = tit_acr.num_id_tit_acr
                AND (movto_tit_acr.ind_trans_acr    = "Implantaá∆o"  OR    
                     movto_tit_acr.ind_trans_acr    = "Renegociaá∆o" OR
                     movto_tit_acr.ind_trans_acr    = "Transf Estabelecimento") NO-ERROR.

         FIND LAST b_histor_movto_tit_acr NO-LOCK
              WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                AND b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                AND b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

         CREATE histor_movto_tit_acr.
         ASSIGN histor_movto_tit_acr.cod_estab                   = movto_tit_acr.cod_estab
                histor_movto_tit_acr.num_id_tit_acr              = movto_tit_acr.num_id_tit_acr
                histor_movto_tit_acr.num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                histor_movto_tit_acr.num_seq_histor_movto_acr    = IF AVAIL b_histor_movto_tit_acr THEN (b_histor_movto_tit_acr.num_seq_histor_movto_acr + 1) ELSE 1
                histor_movto_tit_acr.ind_orig_histor_acr         = "Sistema"
                histor_movto_tit_acr.des_text_histor             = "Convem - Pefin; Alocado MANUALMENTE (esacr055) a Condiá∆o de Cobranáa 99 pelo usu†rio " + CAPS(v_cod_usuar_corren) + " as " + STRING(TIME,"hh:mm:ss") + " no dia " + STRING(TODAY).

         MESSAGE "T°tulo inclu°do manualmente do PEFIN!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.

    APPLY "choose" TO bt_enter IN FRAME f_altera_status_pefin.

END.

ON CHOOSE OF bt_enter IN FRAME f_altera_status_pefin
DO:

    ASSIGN v_log_status = NO.

    ASSIGN v_cod_estab
           v_cod_espec
           v_cod_ser      
           v_cod_tit_acr
           v_cod_parcela
           rs_qry_item_bord_acr.

    FIND tit_acr NO-LOCK
        WHERE tit_acr.cod_estab   = v_cod_estab  
          AND tit_acr.cod_espec   = v_cod_espec  
          AND tit_acr.cod_ser     = v_cod_ser    
          AND tit_acr.cod_tit_acr = v_cod_tit_acr
          AND tit_acr.cod_parcela = v_cod_parcela NO-ERROR.
    IF NOT AVAIL tit_acr 
    THEN DO:
         MESSAGE "T°tulo n∆o localizado!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    FIND emscad.cliente NO-LOCK
        WHERE emscad.cliente.cod_empresa = "1"
          AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente.

    FIND int_tit_acr OF tit_acr NO-LOCK NO-ERROR.

    DISP tit_acr.cdn_cliente
         emscad.cliente.nom_pessoa
         tit_acr.cod_indic_econ
         tit_acr.val_origin_tit_acr
         tit_acr.val_sdo_tit_acr
         tit_acr.cod_portad
         tit_acr.cod_cart_bcia
         tit_acr.cod_cond_cobr
         tit_acr.dat_emis
         tit_acr.dat_vencto_tit_acr
         int_tit_acr.dat_envi_asses_cob when avail int_tit_acr "" when not avail int_tit_acr @ int_tit_acr.dat_envi_asses_cob
         int_tit_acr.dat_ret_asses_cob  when avail int_tit_acr "" when not avail int_tit_acr @ int_tit_acr.dat_ret_asses_cob
         WITH FRAME f_altera_status_pefin. 

    ASSIGN v_log_status = YES.

END.



/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_altera_status_pefin
DO:

    run pi_close_program.
END.

/*************************** Window Trigger Begin ***************************/

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_altera_status_pefin.
END.

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign wh_w_program:title         = frame f_altera_status_pefin:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_altera_status_pefin:title       = ?
       wh_w_program:width-chars   = frame f_altera_status_pefin:width-chars
       wh_w_program:height-chars  = frame f_altera_status_pefin:height-chars - 0.85
       frame f_altera_status_pefin:row         = 1
       frame f_altera_status_pefin:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_altera_status_pefin:handle).

pause 0 before-hide.

view frame f_altera_status_pefin.

enable bt_rnl1
       bt_exi
       v_cod_estab
       v_cod_espec
       v_cod_ser      
       v_cod_tit_acr      
       v_cod_parcela
       bt_enter
       rs_qry_item_bord_acr
       with frame f_altera_status_pefin.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_altera_status_pefin.
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
