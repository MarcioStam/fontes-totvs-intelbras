/*****************************************************************************
** Programa..............: fas211aa1_epc.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 10/03/2010
*****************************************************************************/

/**************************************************** Initialize **********************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

DEFINE RECTANGLE rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.
DEFINE BUTTON bt_ok         LABEL "&OK":U         TOOLTIP "OK":U                   SIZE 1 BY 1 AUTO-GO.

DEFINE TEMP-TABLE tt_histor_inventario NO-UNDO LIKE histor_inventario.

/************************** Query Definition Begin **************************/

DEFINE QUERY qr_dlg_histor_inventario
    FOR tt_histor_inventario
    SCROLLING.

/************************** Browse Definition Begin *************************/

DEFINE BROWSE br_dlg_histor_inventario QUERY qr_dlg_histor_inventario DISPLAY 
    tt_histor_inventario.num_inventario        WIDTH-CHARS 10.00 COLUMN-LABEL "Invent†rio":U
    tt_histor_inventario.cod_ccusto_respons    WIDTH-CHARS 12.00 COLUMN-LABEL "CCusto Res":U
    tt_histor_inventario.cod_unid_negoc        WIDTH-CHARS 05.00 COLUMN-LABEL "UNeg":U
    tt_histor_inventario.dat_transf            WIDTH-CHARS 11.00 COLUMN-LABEL "Dt Transf":U
    tt_histor_inventario.cod_usuar_ult_atualiz WIDTH-CHARS 13.00 COLUMN-LABEL "Usuar Ult Atual":U
    tt_histor_inventario.dat_ult_atualiz       WIDTH-CHARS 11.00 COLUMN-LABEL "Data Ult Atual":U
    tt_histor_inventario.hra_ult_atualiz       WIDTH-CHARS 11.00 COLUMN-LABEL "Hora Ult Atual":U
    with no-box separators single size 63.57 by 06.58 font 1 bgcolor 15 FIT-LAST-COLUMN. 

DEFINE FRAME fPage0
    br_dlg_histor_inventario AT ROW 01.17 COL 02.00
    rt_002                   AT ROW 07.75 COL 02.00 BGCOLOR 7 
    bt_ok                    AT ROW 07.95 COL 02.75 font ? help "OK":U
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 67.00 by 09.83
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Invent†rios - Bem Patrimonial".

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

    open query qr_dlg_histor_inventario for each tt_histor_inventario no-lock.
    
    wait-for go of frame fPage0.

end. /* do  on endkey undo ... */
hide frame fPage0.

RETURN "OK".

/*---[ pi_monta_temptable ]---------------------------------------------------------------*/
procedure pi_monta_temptable:

    FIND bem_pat NO-LOCK WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-ERROR.
    IF  NOT AVAIL bem_pat THEN DO:
        MESSAGE "Bem Patrimonial n∆o Localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END. /* IF  NOT AVAIL bem_pat THEN DO: */
    
    empty temp-table tt_histor_inventario no-error.
    FOR EACH  histor_inventario NO-LOCK
        WHERE histor_inventario.cod_empresa     = bem_pat.cod_empresa    
        AND   histor_inventario.cod_cta_pat     = bem_pat.cod_cta_pat    
        AND   histor_inventario.num_bem_pat     = bem_pat.num_bem_pat    
        AND   histor_inventario.num_seq_bem_pat = bem_pat.num_seq_bem_pat:

        CREATE tt_histor_inventario.
        buffer-copy histor_inventario to tt_histor_inventario no-error.
    END. /* FOR EACH histor_inventario */

end procedure.
