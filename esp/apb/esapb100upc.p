/*****************************************************************************
** Programa..............: esapb100upc.p - bas_bord_ap - apb710aa
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 30/09/2010.
*****************************************************************************/

def input param p_ind_event  as char                           no-undo.
def input param p_ind_object as char                           no-undo.
def input param p_wgh_object as handle                         no-undo.
def input param p_wgh_frame  as widget-handle                  no-undo.
def input param p_cod_table  as char                           no-undo.
def input param p_rec_table  as recid                          no-undo.

define variable wh_button               as widget-handle       no-undo.
define variable wh_button2              as widget-handle       no-undo.
define variable wh_button3              as widget-handle       no-undo.
define variable wh_button4              as widget-handle       no-undo.
define NEW GLOBAL SHARED VAR wh-bas-tg-envio-email   as widget-handle       no-undo.
define variable h_object                as widget-handle       no-undo.
define variable h_prev                  as widget-handle       no-undo.
define variable h_next                  as widget-handle       no-undo.
define variable c-aux                   as char format "x(30)" no-undo.
define variable c-bord-aux              as char format "x(30)" no-undo.

def new global shared var v_rec_bord_ap_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

if  p_ind_event = "INITIALIZE" then do:

    CREATE TOGGLE-BOX wh-bas-tg-envio-email
    ASSIGN NAME      = "wh-bas-tg-envio-email"
           FORMAT    = "Sim/NÆo"
           FRAME     = p_wgh_frame
           WIDTH     = 12.00
           HEIGHT    =  0.70
           COLUMN    = 56.90
           ROW       =  4.80
           LABEL     = "EMail Enviado"
           HELP      = "EMail Enviado"
           CHECKED   = NO
           VISIBLE   = YES
           SENSITIVE = NO.

    create button wh_button
    assign frame      = p_wgh_frame
           width      = 5
           height     = 1.3
           row        = 2.7
           col        = 75.7
           sensitive  = yes
           visible    = yes
           tooltip    = "Email Pagamentos do dia"
           triggers:
               on choose persistent run esp/apb/esapb100d.p.
           end triggers.
    wh_button:load-image("adeicon/appsrvr.bmp":U).

    create button wh_button2
    assign frame      = p_wgh_frame
           width      = 5
           height     = 1.3
           row        = 2.7
           col        = 81.7
           sensitive  = yes
           visible    = yes
           tooltip    = "Ajusta Datas"
           triggers:
               on choose persistent run esp/apb/esapb710aa.p(INPUT p_wgh_frame).
           end triggers.
    wh_button2:load-image("image/im-orcto.bmp":U).

    create button wh_button3
    assign frame      = p_wgh_frame
           width      = 5
           height     = 1.3
           row        = 4.2
           col        = 75.7
           sensitive  = yes
           visible    = yes
           tooltip    = "Confere PIS/COFINS/CSLL"
           triggers:
               on choose persistent run esp/apb/esapb100b.p.
           end triggers.
    wh_button3:load-image("image/im-impt.bmp":U).

    create button wh_button4
    assign frame      = p_wgh_frame
           width      = 5
           height     = 1.3
           row        = 4.2
           col        = 81.7
           sensitive  = yes
           visible    = yes
           tooltip    = "Verifica Divergˆncias"
           triggers:
               on choose persistent run esp/apb/esapb100c.p.
           end triggers.
    wh_button4:load-image("image/im-res-i.bmp":U).

    /* Corrigir Tab Order */
    assign h_object = p_wgh_frame:first-child
           h_object = h_object:first-child
           h_prev   = ?
           h_next   = ?.
    do  while valid-handle(h_object):
        if  h_object:type <> "field_group" then do:
            case h_object:name:
                when "bt_enter" then
                    assign h_prev = h_object.
            end case.
            assign h_object = h_object:next-sibling.
        end.
        else do:
            assign h_object = h_object:first-child.
        end.
        if  valid-handle(h_prev) and valid-handle(h_next) then
            leave.
    end.
    wh_button:move-after-tab-item(h_prev).
    /* Corrigir Tab Order */

    /* Corrigir Tab Order */
    assign h_object = p_wgh_frame:first-child
           h_object = h_object:first-child
           h_prev   = ?
           h_next   = ?.
    do  while valid-handle(h_object):
        if  h_object:type <> "field_group" then do:
            case h_object:name:
                when "br_bap_item_bord_ap" then
                    assign h_next = h_object.
            end case.
            assign h_object = h_object:next-sibling.
        end.
        else do:
            assign h_object = h_object:first-child.
        end.
        if  valid-handle(h_prev) and valid-handle(h_next) then
            leave.
    end.
    wh_button2:move-before-tab-item(h_next).

end.

if  p_ind_event = "DISPLAY" THEN DO:
    assign v_rec_bord_ap_upc             = p_rec_table
           wh-bas-tg-envio-email:CHECKED = NO.

    FOR FIRST bord_ap NO-LOCK
        WHERE RECID(bord_ap) = p_rec_table:

        FIND FIRST item_bord_ap OF bord_ap NO-LOCK NO-ERROR.

        IF  AVAIL item_bord_ap THEN DO:
            
            FOR EACH histor_fornec NO-LOCK
                WHERE histor_fornec.cod_empresa = bord_ap.cod_empresa
                AND   histor_fornec.cdn_fornec  = item_bord_ap.cdn_fornecedor:
            
                IF  SUBSTR(histor_fornec.des_histor_fornec,1,4) <> "Bord" THEN NEXT.
            
                ASSIGN c-aux      = SUBSTR(histor_fornec.des_histor_fornec,6,40)
                       c-bord-aux = ENTRY(3,c-aux,"/").
            
                IF  ENTRY(1,c-aux,"/")     = item_bord_ap.cod_estab 
                AND ENTRY(2,c-aux,"/")     = item_bord_ap.cod_portador 
                AND ENTRY(1,c-bord-aux,"") = string(item_bord_ap.num_bord_ap) THEN
                    ASSIGN wh-bas-tg-envio-email:CHECKED = YES.
            END.

            FOR EACH item_bord_ap OF bord_ap EXCLUSIVE-LOCK:

                IF  item_bord_ap.cod_espec_docto <> "VM"
                AND item_bord_ap.cod_espec_docto <> "RE"
                AND item_bord_ap.cod_espec_docto <> "PV"
                AND item_bord_ap.cod_espec_docto <> "VN"
                AND item_bord_ap.cod_espec_docto <> "VC"
                AND item_bord_ap.cod_espec_docto <> "VA"
                AND item_bord_ap.cod_espec_docto <> "VP"
                AND item_bord_ap.cod_espec_docto <> "VI"
                AND item_bord_ap.cod_espec_docto <> "TE"
                AND item_bord_ap.cod_espec_docto <> "PP" THEN
                    NEXT.

                IF  item_bord_ap.cod_refer_antecip_pef = "" THEN DO:
                    
                    FIND FIRST tit_ap 
                         WHERE tit_ap.cod_estab        = item_bord_ap.cod_estab
                         AND   tit_ap.cod_espec_docto  = item_bord_ap.cod_espec_docto
                         AND   tit_ap.cod_ser_docto    = item_bord_ap.cod_ser_docto
                         AND   tit_ap.cdn_fornecedor   = item_bord_ap.cdn_fornecedor
                         AND   tit_ap.cod_tit_ap       = item_bord_ap.cod_tit_ap
                         AND   tit_ap.cod_parcela      = item_bord_ap.cod_parcela NO-LOCK NO-ERROR.
                    
                    IF  AVAIL tit_ap THEN DO:
                        FIND FIRST movto_tit_ap OF tit_ap
                            WHERE  movto_tit_ap.ind_trans_ap = "Implanta‡Æo" NO-LOCK NO-ERROR.

                        IF  AVAIL movto_tit_ap THEN DO:
                            
                            FIND FIRST histor_tit_movto_ap 
                                WHERE histor_tit_movto_ap.cod_estab           = tit_ap.cod_estab
                                AND   histor_tit_movto_ap.num_id_tit_ap       = tit_ap.num_id_tit_ap
                                AND   histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                                AND   histor_tit_movto_ap.ind_orig_histor_ap <> "Erro" NO-LOCK NO-ERROR.
            
                            IF  AVAIL histor_tit_movto_ap THEN 
                                ASSIGN item_bord_ap.des_text_histor = histor_tit_movto_ap.des_text_histor.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
