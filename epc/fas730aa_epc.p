/*****************************************************************************
** Programa..............: fas730aa_epc.p
** Descricao.............: EPC do programa bas_bem_pat_reclassif_conta
** Criado em.............: 23/01/2019.
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.

DEF NEW GLOBAL SHARED VAR h_qr_bem_pat_reclassif_conta AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR h_br_bem_pat_reclassif_conta AS WIDGET-HANDLE NO-UNDO. 

if  p_ind_event = "INITIALIZE" then do:

    RUN piFindWidget(INPUT "br_bem_pat_reclassif_conta", 
                     INPUT "BROWSE", 
                     INPUT p_wgh_frame, 
                     OUTPUT h_br_bem_pat_reclassif_conta).

    IF  VALID-HANDLE(h_br_bem_pat_reclassif_conta) THEN
        ASSIGN h_qr_bem_pat_reclassif_conta = h_br_bem_pat_reclassif_conta:QUERY.

    /* BotÆo para carregar os parametros da planilha */
    create button wh_button
    assign frame      = p_wgh_frame
           NAME       = "bt_carrega_planilha"
           width      = 4
           height     = 1.20
           row        = 01.00
           col        = 32
           sensitive  = yes
           visible    = yes
           tooltip    = "Importa parƒmetros da planilha"
           triggers:
               on choose persistent run epc/fas730aa2_epc.p(input p_ind_event,
                                                            input p_ind_object,
                                                            input p_wgh_object,
                                                            input p_wgh_frame, 
                                                            input p_cod_table, 
                                                            input p_rec_table).
           end triggers.

    wh_button:load-image("image/im-imp.bmp":U).
END.

PROCEDURE piFindWidget:
    def input  param c-widget-name  as char   no-undo.
    def input  param c-widget-type  as char   no-undo.
    def input  param h-start-widget as handle no-undo.
    def output param h-widget       as handle no-undo.

    do while valid-handle(h-start-widget):

        if h-start-widget:name = c-widget-name and
           h-start-widget:type = c-widget-type then do:
            
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if  h-start-widget:type = "field-group":u 
        or  h-start-widget:type = "frame":u 
        or  h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if  valid-handle(h-widget) then
                leave.
        end.

        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.
