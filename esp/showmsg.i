&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowMessage Include 
PROCEDURE ShowMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-tipo AS INT no-undo.
    DEF INPUT PARAM p-texto-msg AS CHAR NO-UNDO.
    DEF INPUT PARAM p-help-msg AS CHAR NO-UNDO.

    def var v_msg_val           as char     no-undo 
        view-as editor size-char 61 by 1.7 
        scrollbar-vertical.
    def var v_msg_hlp           as char     no-undo 
        view-as editor size-char 50 by 3
        scrollbar-vertical font 2.
    def var c-ajuda             as char format "x(7)" no-undo view-as text size 7 by 1 INIT "Ajuda".

    def image im_msg_ico     file "image/im-mqerr".
    def rectangle rt_help    size-char 52 by 4 edge-pixels 2 bgcolor 8.
    def rectangle rt_button  size-char 61 by 1.42 edge-pixels 1 bgcolor 7.
    def button bt_yes        label "&OK" size-char 10 by 1 auto-go.
    def button bt_no         label "&NÆo" size-char 10 by 1 auto-go.
    
    def frame f_msg_help
        v_msg_val    at row 1.5 col 2
        im_msg_ico   at row 4.5 col  4
        v_msg_hlp    at row 4.5 col 12
        rt_help      at row 4.0 col 11
        c-ajuda      at row 3.5 col 14 
        rt_button    at row 8.5 col 2 space(1)
        bt_yes        at row 8.71 col 3
        bt_no        at row 8.71 col 14
        skip(0.5)
        with three-d no-label view-as DIALOG-BOX TITLE "Pergunta" DEFAULT-BUTTON bt_yes.

    on cursor-right of 
        bt_yes, bt_no    apply "TAB" to self.
    on cursor-left of
        bt_yes, bt_no    apply "SHIFT-TAB" to self.
     
    on choose of bt_yes
        return "yes".
    on choose of bt_no 
        return "no".
    on end-error of frame f_msg_help do:
        if bt_no:HIDDEN in frame f_msg_help = no then 
            return "no".
        else return "yes".
    end.
    CASE p-tipo:
        WHEN 1 THEN do:
            im_msg_ico:load-image("image/im-mqerr").
            frame f_msg_help:TITLE = "Erro".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 2 THEN do:
            im_msg_ico:load-image("image/im-mqwar").
            frame f_msg_help:TITLE = "Advertˆncia".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 3 THEN do:
            im_msg_ico:load-image("image/im-mqqst").
            frame f_msg_help:TITLE = "Pergunta".
            assign bt_no:hidden in frame f_msg_help = no
                   bt_no:sensitive in frame f_msg_help = yes
                   bt_yes:hidden in frame f_msg_help = no     
                   bt_yes:sensitive in frame f_msg_help = yes.
            bt_yes:label in frame f_msg_help = "&Sim".
        END.
        WHEN 4 THEN do:
            im_msg_ico:load-image("image/im-mqinf").
            frame f_msg_help:TITLE = "Informa‡Æo".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
    END CASE.
 
    assign v_msg_val = p-texto-msg.
    assign v_msg_hlp = p-help-msg + chr(10) + "".

    assign v_msg_val:read-only in frame f_msg_help = yes
           v_msg_hlp:read-only in frame f_msg_help = yes.

    VIEW FRAME f_msg_help.
    DISP c-ajuda v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    ENABLE v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    apply "entry" to bt_no.
    wait-for choose of bt_yes or choose of bt_no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

