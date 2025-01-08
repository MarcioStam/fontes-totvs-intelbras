/*****************************************************************************
** Programa..............: fas701cc_epc.p
** Descricao.............: EPC do programa add_bem_pat_invent
** Criado em.............: 26/04/2019.
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF BUFFER b_bem_pat        FOR bem_pat.
DEF BUFFER b_bem_pat_visual FOR bem_pat.

DEF TEMP-TABLE tt-conta NO-UNDO
    FIELD cod_cta_pat AS CHAR.

DEF NEW GLOBAL SHARED VAR h_v_log_cr_pis            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_v_log_cr_cofins         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_cta_pat             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_cod_cta_pat            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_fas701cc_upc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_estab               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_localiz             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_bem_pat             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_seq_bem_pat         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cb3_ident_visual        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_f_ads_02_bem_pat_invent AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_fas701cc_epc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_seq_bem_pat_new     AS WIDGET-HANDLE NO-UNDO.

/*
MESSAGE "p_ind_event "   p_ind_event  skip
        "p_ind_object "  p_ind_object skip
        "p_wgh_object "  p_wgh_object skip
        "p_wgh_frame "   p_wgh_frame  skip
        "p_cod_table "   p_cod_table 
        VIEW-AS ALERT-BOX.
*/

IF  p_ind_event = "INITIALIZE" then do:
    RUN piFindWidget(INPUT "f_ads_02_bem_pat_invent",
                     INPUT "DIALOG-BOX",
                     INPUT p_wgh_frame,
                     OUTPUT h_f_ads_02_bem_pat_invent).

    IF  VALID-HANDLE(h_f_ads_02_bem_pat_invent) THEN DO:
        RUN piFindWidget(INPUT "cod_localiz",
                         INPUT "FILL-IN",
                         INPUT h_f_ads_02_bem_pat_invent,
                         OUTPUT h_cod_localiz).

        RUN piFindWidget(INPUT "cb3_ident_visual",
                         INPUT "FILL-IN",
                         INPUT h_f_ads_02_bem_pat_invent,
                         OUTPUT h_cb3_ident_visual).
    END.
END.

IF  p_ind_event = "DISPLAY" then do:

    
    IF  VALID-HANDLE(h_f_ads_02_bem_pat_invent) THEN DO:

        IF   VALID-HANDLE(h_cod_cta_pat)
        AND  (h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (12 MESES)" 
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (36 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (48 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (60 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJ. ANDAM. INTAN"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJETOS EM ANDAME"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "VEICULOS") THEN DO:
    
            IF  VALID-HANDLE(h_cod_localiz) THEN DO:                
                IF  h_cod_estab:SCREEN-VALUE = "101" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "PATRIMONIO".
        
                IF  h_cod_estab:SCREEN-VALUE = "103" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "MAXCOM".
        
                IF  h_cod_estab:SCREEN-VALUE = "104" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "SERTAO".
        
                IF  h_cod_estab:SCREEN-VALUE = "105" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "MANAUS".
        
                IF  h_cod_estab:SCREEN-VALUE = "109" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "DEPOSITO AM".
            END.
        END.
        ELSE DO:
            IF  VALID-HANDLE(h_cod_localiz) THEN
                ASSIGN h_cod_localiz:SCREEN-VALUE = "".
        END.

        IF  VALID-HANDLE(h_num_bem_pat)
        AND VALID-HANDLE(h_num_seq_bem_pat)
        AND VALID-HANDLE(h_cb3_ident_visual) THEN
            ASSIGN h_cb3_ident_visual:SCREEN-VALUE = h_num_bem_pat:SCREEN-VALUE + "/" + STRING(INT(h_num_seq_bem_pat:SCREEN-VALUE),"999").

    END.
END.

PROCEDURE piFindWidget:
    def input  param c-widget-name  as char   no-undo.
    def input  param c-widget-type  as char   no-undo.
    def input  param h-start-widget as handle no-undo.
    def output param h-widget       as handle no-undo.

    do  while valid-handle(h-start-widget):

        if  h-start-widget:name = c-widget-name
        and h-start-widget:type = c-widget-type then do:
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

RETURN "OK".

