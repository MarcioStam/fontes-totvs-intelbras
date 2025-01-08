/*****************************************************************************
** Programa..............: fas211aa1_epc.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 10/03/2010
*****************************************************************************/

/**************************************************** Initialize **********************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

DEFINE RECTANGLE rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.
DEFINE BUTTON bt_ok         LABEL "&OK":U         TOOLTIP "OK":U                   SIZE 1 BY 1 AUTO-GO.

DEFINE TEMP-TABLE tt_histor_aloc NO-UNDO 
   field num_seq        like tab_espec_financ.num_seq       
   field ind_event      like tab_espec_financ.ind_event     
   field dat_transacao  like tab_espec_financ.dat_transacao 
   field hra_transacao  like tab_espec_financ.hra_transacao 
   field des_histor_tab like tab_espec_financ.des_histor_tab
   field cod_usuario    like tab_espec_financ.cod_usuario   
   field ind_tip_alter  like tab_espec_financ.ind_tip_alter.
    
/************************** Query Definition Begin **************************/

DEFINE QUERY qr_dlg_histor_aloc
    FOR tt_histor_aloc
    SCROLLING.

/************************** Browse Definition Begin *************************/

DEFINE BROWSE br_dlg_histor_aloc QUERY qr_dlg_histor_aloc DISPLAY 
    tt_histor_aloc.num_seq        WIDTH-CHARS 05.00 COLUMN-LABEL "Seq":U
    tt_histor_aloc.dat_transacao  WIDTH-CHARS 10.00 COLUMN-LABEL "Dt Transaá∆o":U
    tt_histor_aloc.hra_transacao  WIDTH-CHARS 08.00 COLUMN-LABEL "Hora":U
    tt_histor_aloc.des_histor_tab WIDTH-CHARS 20.00 COLUMN-LABEL "Hist¢rico":U
    tt_histor_aloc.cod_usuario    WIDTH-CHARS 12.00 COLUMN-LABEL "Usu†rio":U
    tt_histor_aloc.ind_tip_alter  WIDTH-CHARS 12.00 COLUMN-LABEL "Tipo Alter":U
    with no-box separators single size 63.57 by 06.58 font 1 bgcolor 15 FIT-LAST-COLUMN. 

DEFINE FRAME fPage0
    br_dlg_histor_aloc AT ROW 01.17 COL 02.00
    rt_002                   AT ROW 07.75 COL 02.00 BGCOLOR 7 
    bt_ok                    AT ROW 07.95 COL 02.75 font ? help "OK":U
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 67.00 by 09.83
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Hist¢rico Alocaá‰es".

/* adjust size of objects in this frame */
ASSIGN bt_ok:width-chars          in frame fPage0 = 10.00
       bt_ok:height-chars         in frame fPage0 = 01.00
       rt_002:width-chars         in frame fPage0 = 63.57
       rt_002:height-chars        in frame fPage0 = 01.42.

histor_block:
do  on endkey undo histor_block, leave histor_block:
    view frame fPage0.

    enable ALL with frame fPage0.
    
    run pi_monta_temptable.

    open query qr_dlg_histor_aloc for each tt_histor_aloc no-lock.
    
    wait-for go of frame fPage0.

end. /* do  on endkey undo ... */
hide frame fPage0.

RETURN "OK".

/*---[ pi_monta_temptable ]---------------------------------------------------------------*/
procedure pi_monta_temptable:

    FIND bem_pat NO-LOCK 
        WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-ERROR.

    IF  NOT AVAIL bem_pat THEN DO:
        MESSAGE "Bem Patrimonial n∆o Localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END. /* IF  NOT AVAIL bem_pat THEN DO: */
    
    empty temp-table tt_histor_aloc no-error.
    
    FOR EACH tab_espec_financ
        WHERE tab_espec_financ.cod_modul_dtsul = "FAS"                            
        AND   tab_espec_financ.cod_tabela      = "aloc_bem"                       
        AND   tab_espec_financ.cod_reg_tab     = STRING(bem_pat.num_id_bem_pat):

        CREATE tt_histor_aloc.
        ASSIGN tt_histor_aloc.num_seq        = tab_espec_financ.num_seq       
               tt_histor_aloc.ind_event      = tab_espec_financ.ind_event     
               tt_histor_aloc.dat_transacao  = tab_espec_financ.dat_transacao 
               tt_histor_aloc.hra_transacao  = tab_espec_financ.hra_transacao 
               tt_histor_aloc.des_histor_tab = tab_espec_financ.des_histor_tab
               tt_histor_aloc.cod_usuario    = tab_espec_financ.cod_usuario   
               tt_histor_aloc.ind_tip_alter  = tab_espec_financ.ind_tip_alter. 
    END. /* FOR EACH histor_inventario */

end procedure.
