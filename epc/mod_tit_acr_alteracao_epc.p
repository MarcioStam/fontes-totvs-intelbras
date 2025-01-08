/*****************************************************************************
** Programa..............: mod_tit_acr_alteracao_epc.p.p
** Descricao.............: EPC do programa de alteraá∆o de t°tulos do ACR
** Criado em.............: 21/11/2018
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

DEF NEW GLOBAL SHARED VAR v_dat_venc_tit_acr LIKE tit_acr.dat_vencto_tit_acr NO-UNDO.

DEF VAR h_dat_vencto_tit_acr AS HANDLE NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table  skip
        "p_rec_table "  p_rec_table 
        VIEW-AS ALERT-BOX.
*/

if  p_ind_event = "ALTERAC_DESC" then do:

    FIND FIRST tit_acr
        WHERE RECID(tit_acr) = p_rec_table NO-LOCK NO-ERROR.

    IF  AVAIL tit_acr THEN
        ASSIGN v_dat_venc_tit_acr = tit_acr.dat_vencto_tit_acr.
END.

if  p_ind_event = "VALIDATE" then do:

    RUN piFindWidget(INPUT "dat_vencto_tit_acr", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_dat_vencto_tit_acr).

    FIND FIRST tit_acr
        WHERE RECID(tit_acr) = p_rec_table NO-LOCK NO-ERROR.

    IF  VALID-HANDLE(h_dat_vencto_tit_acr) THEN DO:
        
        IF  AVAIL tit_acr 
        AND DATE(STRING(h_dat_vencto_tit_acr:SCREEN-VALUE)) <> v_dat_venc_tit_acr THEN DO:
            
            FIND FIRST espec_docto
                 WHERE espec_docto.cod_espec_docto = tit_acr.cod_espec_docto NO-LOCK NO-ERROR.
    
            IF  AVAIL espec_docto
            AND espec_docto.ind_tip_espec_docto = "Normal" THEN DO:
    
                FIND FIRST estabelecimento
                     WHERE estabelecimento.cod_estab = tit_acr.cod_estab NO-LOCK NO-ERROR.
                
                IF  AVAIL estabelecimento THEN DO:
                    FIND FIRST calend_glob
                         WHERE calend_glob.cod_calend = estabelecimento.cod_calend_financ NO-LOCK NO-ERROR.
    
                    IF  AVAIL calend_glob THEN DO:
                        FIND FIRST dia_calend_glob
                            WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
                            AND   dia_calend_glob.dat_calend = tit_acr.dat_vencto_tit_acr NO-LOCK NO-ERROR.
                            
                        IF  AVAIL dia_calend_glob THEN DO:
                            IF  dia_calend_glob.log_dia_util = NO THEN DO:
                                RUN utp/ut-msgs.p(input "show":U, 
                                                  input 17006,
                                                  input "Data de vencimento n∆o pode ser informada em dia n∆o £til !").
    
                                RETURN "NOK".
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.

PROCEDURE piFindWidget:
    define input  parameter c-widget-name  as char   no-undo.
    define input  parameter c-widget-type  as char   no-undo.
    define input  parameter h-start-widget as handle no-undo.
    define output parameter h-widget       as handle no-undo.

    do while valid-handle(h-start-widget):
        if  h-start-widget:name = c-widget-name 
        and h-start-widget:type = c-widget-type then do:
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if  h-start-widget:type = "field-group":u 
        or  h-start-widget:type = "frame":u 
        OR  h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if valid-handle(h-widget) then
                leave.
        end.
        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.
