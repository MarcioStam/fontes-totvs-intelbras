
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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

def temp-table tt_maximizacao no-undo
    field hdl-widget             as widget-handle
    field tipo-widget            as character 
    field row-original           as decimal
    field col-original           as decimal
    field width-original         as decimal
    field height-original        as decimal
    field log-posiciona-row      as logical
    field log-posiciona-col      as logical
    field log-calcula-width      as logical
    field log-calcula-height     as logical
    field log-button-right       as logical
    field frame-width-original   as decimal
    field frame-height-original  as decimal
    field window-width-original  as decimal
    field window-height-original as decimal.

def var v_log_restored as logical no-undo.

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

ON WINDOW-MAXIMIZED OF {1} DO:
    run setWindowState (input "maximized":U).
END.

ON WINDOW-MINIMIZED OF {1} DO:
    run setWindowState (input "minimized":U).
END.

ON WINDOW-RESTORED OF {1} DO:
    run setWindowState (input "restored":U).
END.

assign {1}:virtual-width-chars  = 300.00
       {1}:virtual-height-chars = 200.00.


/*run getWindowState.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWindowState Include 
PROCEDURE getWindowState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var v_whd_field_group   as widget-handle no-undo.
    def var v_whd_widget        as widget-handle no-undo.
    def buffer b_tt_maximizacao for tt_maximizacao.
    find first tt_maximizacao no-error.
    if not avail tt_maximizacao then do:
        assign v_whd_field_group = frame {&frame-name}:first-child.
        repeat while valid-handle(v_whd_field_group):
            assign v_whd_widget = v_whd_field_group:first-child.
            repeat while valid-handle(v_whd_widget):
                create tt_maximizacao.
                if can-query(v_whd_widget,'handle') then
                    assign tt_maximizacao.hdl-widget            = v_whd_widget:handle no-error.
                if can-query(v_whd_widget,'type') then
                    assign tt_maximizacao.tipo-widget           = v_whd_widget:type no-error.
                if can-query(v_whd_widget,'row') then
                    assign tt_maximizacao.row-original          = v_whd_widget:row no-error.
                if can-query(v_whd_widget,'col') then
                    assign tt_maximizacao.col-original          = v_whd_widget:col no-error.
                if can-query(v_whd_widget,'width') then
                    assign tt_maximizacao.width-original        = v_whd_widget:width no-error.
                if can-query(v_whd_widget,'height') then
                    assign tt_maximizacao.height-original       = v_whd_widget:height no-error.
                assign tt_maximizacao.frame-width-original   = frame {&frame-name}:width.
                assign tt_maximizacao.frame-height-original  = frame {&frame-name}:height.
                assign tt_maximizacao.window-width-original  = {&window-name}:width.
                assign tt_maximizacao.window-height-original = {&window-name}:height.
                assign tt_maximizacao.log-posiciona-row  = no.
                assign tt_maximizacao.log-posiciona-col  = no.
                assign tt_maximizacao.log-calcula-width  = no.
                assign tt_maximizacao.log-calcula-height = no.
                assign tt_maximizacao.log-button-right   = no.
                if can-query(v_whd_widget,'flat-button') then do:
                    if v_whd_widget:flat-button = yes then do:
                        assign tt_maximizacao.log-posiciona-col  = no.
                        if v_whd_widget:name = 'btExit' or
                           v_whd_widget:name = 'btHelp' then do:
                            assign tt_maximizacao.log-button-right   = yes.
                        end.
                    end.
                end.
                if can-query(v_whd_widget,'type') then do:
                    if v_whd_widget:type = 'browse' then 
                        assign tt_maximizacao.log-calcula-height = yes.
                end.
                assign v_whd_widget = v_whd_widget:next-sibling.
            end.
            assign v_whd_field_group = v_whd_field_group:next-sibling.
        end.
    end.
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'browse'
          by tt_maximizacao.row-original:
        find first b_tt_maximizacao
             where b_tt_maximizacao.tipo-widget = 'browse'
               and b_tt_maximizacao.hdl-widget = tt_maximizacao.hdl-widget
            no-error.
        if avail b_tt_maximizacao then do:
            leave.
        end.
    end.
    if avail b_tt_maximizacao then do:
        for each tt_maximizacao
            where tt_maximizacao.row-original >=  b_tt_maximizacao.row-original + 
                                                  b_tt_maximizacao.height-original - 1:
            assign tt_maximizacao.log-calcula-height = no.
            assign tt_maximizacao.log-posiciona-row  = yes.
            assign tt_maximizacao.log-posiciona-col  = no.
        end.
    end.
    for each b_tt_maximizacao
        where b_tt_maximizacao.tipo-widget = 'browse':
        assign b_tt_maximizacao.log-calcula-width = yes.
        for each tt_maximizacao
            where tt_maximizacao.row-original + tt_maximizacao.height-original >= 
                  b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.tipo-widget = 'rectangle'
              and b_tt_maximizacao.log-calcula-height = yes:
            assign tt_maximizacao.log-calcula-height = yes.
        end.
        for each tt_maximizacao
           where tt_maximizacao.tipo-widget <> 'browse'
             and not (    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                      and tt_maximizacao.row-original + tt_maximizacao.height-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original
                      and tt_maximizacao.col-original >= b_tt_maximizacao.col-original
                      and tt_maximizacao.col-original + tt_maximizacao.width-original < b_tt_maximizacao.col-original + b_tt_maximizacao.width-original )
             and ((    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original - 0.5 )
              or (     tt_maximizacao.row-original < b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original + tt_maximizacao.height-original > b_tt_maximizacao.row-original )):
            assign tt_maximizacao.log-posiciona-col = yes.
        end.
    end. 
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'rectangle':
        if tt_maximizacao.frame-width-original - tt_maximizacao.width-original < 4 then do:
            assign tt_maximizacao.log-posiciona-col  = no.
            assign tt_maximizacao.log-calcula-width  = yes.
        end.
    end.
    assign {&window-name}:max-width-chars  = 300 
           {&window-name}:max-height-chars = 300.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setWindowState Include 
PROCEDURE setWindowState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-window-state as char no-undo.

    def var v_wgh_widget as widget-handle no-undo.

    case p-window-state:

        when "minimized":U then do:
            assign v_log_restored = no.
        end.
        when "maximized":U then do:
            assign v_log_restored = yes
                   frame {&frame-name}:width-chars  = {&window-name}:width-chars
                   frame {&frame-name}:height-chars = {&window-name}:height-chars no-error.

            for each tt_maximizacao:
                assign v_wgh_widget = tt_maximizacao.hdl-widget.
            
                if tt_maximizacao.log-posiciona-row = yes then do:
                    assign v_wgh_widget:row = {&window-name}:height - (tt_maximizacao.window-height-original - tt_maximizacao.row-original).
                end.
                if tt_maximizacao.log-calcula-width = yes then do:
                    assign v_wgh_widget:width = {&window-name}:width - ( tt_maximizacao.window-width-original - tt_maximizacao.width-original ).
                end.
                if tt_maximizacao.log-calcula-height = yes then do:
                    assign v_wgh_widget:height = {&window-name}:height - ( tt_maximizacao.window-height-original - tt_maximizacao.height-original ).
                end.
                if tt_maximizacao.log-posiciona-col = yes then do:
                    assign v_wgh_widget:col = {&window-name}:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
                end.
                if tt_maximizacao.tipo-widget = 'button'
                and tt_maximizacao.log-button-right = yes then do:
                    assign v_wgh_widget:col = {&window-name}:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
                end.
            end.

        end.
        when "restored":U then do:
            if v_log_restored then do:
                for each tt_maximizacao:
                    assign v_wgh_widget = tt_maximizacao.hdl-widget.
                
                    if can-query(v_wgh_widget,'row') then
                        assign v_wgh_widget:row    = tt_maximizacao.row-original    no-error.
                
                    if can-query(v_wgh_widget,'col') then
                        assign v_wgh_widget:col    = tt_maximizacao.col-original    no-error.
                
                    if can-query(v_wgh_widget,'width') then
                        assign v_wgh_widget:width  = tt_maximizacao.width-original  no-error.
                
                    if can-query(v_wgh_widget,'height') then
                        assign v_wgh_widget:height = tt_maximizacao.height-original no-error.
                end.
            end.

            assign v_log_restored = yes.
        end.

    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


