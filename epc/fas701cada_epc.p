/*****************************************************************************
** Programa..............: fas701cada_epc.p
** Descricao.............: EPC do programa add_bem_pat e mod_bem_pat
** Criado em.............: 28/01/2016
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
DEF NEW GLOBAL SHARED VAR h_fas701cada_upc          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_fas701cada_epc_1        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_estab               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_ccusto_respons      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_new_cod_estab           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_localiz             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_bem_pat             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_seq_bem_pat         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cb3_ident_visual        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_f_ads_02_bem_pat_invent AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_fas701cada_epc          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_num_seq_bem_pat_new     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_bt_inventario           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_bt_documentos           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_new_bt_documentos       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR l_invent_autom            AS LOG INIT NO   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_des_bem_pat             AS WIDGET-HANDLE NO-UNDO.

DEF VAR v_des_bem_pat     LIKE bem_pat.des_bem_pat NO-UNDO.
DEF VAR v_aux_des_bem_pat LIKE bem_pat.des_bem_pat NO-UNDO.
DEF VAR i_cont            AS INT                   NO-UNDO.
DEF VAR l-igual           AS LOG INIT NO           NO-UNDO.

/*
MESSAGE "p_ind_event "   p_ind_event  skip
        "p_ind_object "  p_ind_object skip
        "p_wgh_object "  p_wgh_object skip
        "p_wgh_frame "   p_wgh_frame  skip
        "p_cod_table "   p_cod_table 
        VIEW-AS ALERT-BOX.
*/

IF  p_ind_event = "INITIALIZE" then do:

    IF  NOT VALID-HANDLE(h_fas701cada_epc_1) THEN
        RUN epc/fas701cada_epc_1.r PERSISTENT SET h_fas701cada_epc_1 (INPUT p_ind_event,
                                                                      INPUT p_ind_object,
                                                                      INPUT p_wgh_object,
                                                                      INPUT p_wgh_frame,
                                                                      INPUT p_cod_table,
                                                                      INPUT p_rec_table).

    RUN piFindWidget(INPUT "des_bem_pat", 
                     INPUT "FILL-IN", 
                     INPUT p_wgh_frame, 
                     OUTPUT h_des_bem_pat).

    IF  VALID-HANDLE(h_des_bem_pat) THEN
        ON "LEAVE" OF h_des_bem_pat PERSISTENT RUN pi_trata_leave_des_bem_pat IN h_fas701cada_epc_1.

    RUN epc/fas701cada_epc.p PERSISTENT SET h_fas701cada_epc (INPUT "",            
                                                              INPUT "",            
                                                              INPUT p_wgh_object,  
                                                              INPUT p_wgh_frame,   
                                                              INPUT "",            
                                                              INPUT p_rec_table).  

    RUN piFindWidget(INPUT "bt_inventario",
                     INPUT "BUTTON",
                     INPUT  p_wgh_frame,
                     OUTPUT h_bt_inventario).

    IF  VALID-HANDLE(h_bt_inventario) THEN
        ASSIGN h_bt_inventario:SENSITIVE = NO.

    RUN piFindWidget(INPUT "cod_cta_pat",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_cod_cta_pat).

    RUN piFindWidget(INPUT "num_bem_pat",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_num_bem_pat).

    RUN piFindWidget(INPUT "num_seq_bem_pat",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_num_seq_bem_pat).

    RUN piFindWidget(INPUT "cod_ccusto_respons",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_cod_ccusto_respons).

    RUN piFindWidget(INPUT "cod_localiz",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_cod_localiz).

    RUN piFindWidget(INPUT "cb3_ident_visual",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_cb3_ident_visual).
    
    RUN piFindWidget(INPUT "cod_estab",
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT h_cod_estab).

    CREATE FILL-IN h_new_cod_estab
    ASSIGN NAME       = h_cod_estab:NAME
           FRAME      = h_cod_estab:FRAME
           ROW        = h_cod_estab:ROW
           COLUMN     = h_cod_estab:COLUMN
           HEIGHT     = h_cod_estab:HEIGHT
           WIDTH      = h_cod_estab:WIDTH
           DATA-TYPE  = h_cod_estab:DATA-TYPE
           FORMAT     = h_cod_estab:FORMAT
           TOOLTIP    = h_cod_estab:TOOLTIP
           HELP       = h_cod_estab:HELP
           VISIBLE    = h_cod_estab:VISIBLE
           SENSITIVE  = YES.

    ON "LEAVE":U OF h_new_cod_estab PERSISTENT RUN pi_leave_cod_estab IN h_fas701cada_epc.

    IF  VALID-HANDLE(h_cod_estab) 
    AND VALID-HANDLE(h_new_cod_estab) THEN DO:
        h_new_cod_estab:MOVE-AFTER-TAB-ITEM(h_cod_estab).

        ASSIGN h_cod_estab:SENSITIVE = NO.
    END.

    RUN piFindWidget(INPUT "bt_documentos",
                     INPUT "BUTTON",
                     INPUT p_wgh_frame,
                     OUTPUT h_bt_documentos).

    IF  VALID-HANDLE(h_bt_documentos) THEN DO:
        CREATE BUTTON h_new_bt_documentos
        ASSIGN FRAME       = h_bt_documentos:FRAME
               WIDTH       = h_bt_documentos:WIDTH
               HEIGHT      = h_bt_documentos:HEIGHT
               LABEL       = h_bt_documentos:LABEL
               ROW         = h_bt_documentos:ROW
               COL         = h_bt_documentos:COL 
               TOOLTIP     = h_bt_documentos:TOOLTIP
               FLAT-BUTTON = h_bt_documentos:FLAT-BUTTON
               VISIBLE     = h_bt_documentos:VISIBLE
               SENSITIVE   = YES.
        
        ON "CHOOSE" OF h_new_bt_documentos PERSISTENT RUN pi_bt_documentos IN h_fas701cada_epc.

        h_new_bt_documentos:MOVE-TO-TOP().
        h_bt_documentos:VISIBLE = NO.
    END.
END.

IF  p_ind_event = 'DISPLAY' THEN DO:
    RUN pi_trata_estab IN h_fas701cada_epc.
END.

IF  p_ind_event = 'VALIDATE' THEN DO:
    FIND FIRST b_bem_pat
        WHERE RECID(b_bem_pat) = p_rec_table EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT CAN-FIND (FIRST bem_pat_item_docto_entr OF b_bem_pat) THEN DO:
        IF  PROGRAM-NAME(1) MATCHES "*fas701ca.p" 
        OR  PROGRAM-NAME(2) MATCHES "*fas701ca.p" 
        OR  PROGRAM-NAME(3) MATCHES "*fas701ca.p" 
        OR  PROGRAM-NAME(4) MATCHES "*fas701ca.p" 
        OR  PROGRAM-NAME(5) MATCHES "*fas701ca.p" 
        OR  PROGRAM-NAME(6) MATCHES "*fas701ca.p" THEN DO:
            MESSAGE "Nota Fiscal de Entrada dever  ser selecionada!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
    END.

    ASSIGN v_des_bem_pat = b_bem_pat.des_bem_pat.

    run pi_retira_caracteres_nao_alfa (Input v_des_bem_pat,
                                       Input "3", /* somente numeros, letras e espa‡os em branco */
                                       output v_aux_des_bem_pat).

    IF  v_des_bem_pat <> v_aux_des_bem_pat THEN DO:
        MESSAGE "Descri‡Æo do bem nÆo pode conter caracteres especiais !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    FIND FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "fas701cada"
        AND   ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

    IF  NOT AVAIL ponto-programa THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "Contas Patrimoniais nÆo cadastradas para o programa fas701cada_epc no es0018.").
        RETURN "OK".
    END.

    FOR EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        CREATE tt-conta.
        ASSIGN tt-conta.cod_cta_pat = conteudo-programa.conteudo.
    END.

    DEF VAR l-diferente AS LOG INIT NO NO-UNDO.

    FOR EACH tt-conta:
        IF  b_bem_pat.cod_cta_pat <> tt-conta.cod_cta_pat THEN
            l-diferente = YES.
        ELSE DO:
            l-diferente = NO.
            LEAVE.
        END.
    END.

    IF  l-diferente 
    AND b_bem_pat.cod_localiz  = "" THEN DO:

        if  b_bem_pat.cb3_ident_visual <> ? 
        and b_bem_pat.cb3_ident_visual <> "" then do:

            find first b_bem_pat_visual use-index bempat_ident_visu 
                 where b_bem_pat_visual.cb3_ident_visual = b_bem_pat.cb3_ident_visual
                   and b_bem_pat_visual.cod_empresa      = b_bem_pat.cod_empresa 
                   and recid(b_bem_pat_visual) <> recid(b_bem_pat) no-lock no-error.

            if  NOT avail b_bem_pat_visual then do: 
                MESSAGE "Localiza‡Æo dever  ser informada!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "NOK".
            END.
            ELSE DO:
                MESSAGE "Localiza‡Æo dever  ser informada!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN ERROR.
            END.
        END.
        ELSE DO:
            MESSAGE "Localiza‡Æo dever  ser informada!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
    END.

    IF  (b_bem_pat.cod_cta_pat   = "BENFEITORIAS"
    OR   b_bem_pat.cod_cta_pat   = "EDIFICACOES")
    AND (b_bem_pat.log_cr_pis    =  NO
    OR   b_bem_pat.log_cr_cofins =  NO) THEN DO:

        IF  NOT PROGRAM-NAME(1) MATCHES "*fas701cc.p" 
        AND NOT PROGRAM-NAME(2) MATCHES "*fas701cc.p" 
        AND NOT PROGRAM-NAME(3) MATCHES "*fas701cc.p" THEN DO:
            MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO FORAM marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma1 AS LOGICAL.

            IF  l_confirma1 = NO THEN
                RETURN "NOK".
        END.
    END.

    IF  (b_bem_pat.cod_ccusto_respons BEGINS "44"
    OR   b_bem_pat.cod_ccusto_respons BEGINS "45"
    OR   b_bem_pat.cod_ccusto_respons BEGINS "46")
    AND (b_bem_pat.cod_cta_pat    <> "PROJETOS EM ANDAME"
    AND  b_bem_pat.cod_cta_pat    <> "PROJ. ANDAM. INTAN")
    AND (b_bem_pat.cod_estab      <> "101" /* C2005-1195 */
    AND  b_bem_pat.cod_estab      <> "109") THEN DO:

        IF  b_bem_pat.log_cr_pis    = NO
        OR  b_bem_pat.log_cr_cofins = NO THEN DO:

            IF  NOT PROGRAM-NAME(1) MATCHES "*fas701cc.p" 
            AND NOT PROGRAM-NAME(2) MATCHES "*fas701cc.p" 
            AND NOT PROGRAM-NAME(3) MATCHES "*fas701cc.p" THEN DO:
                MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO FORAM marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma2 AS LOGICAL.
    
                IF  l_confirma2 = NO THEN
                    RETURN "NOK".
            END.
        END.
    END.

    IF  ((b_bem_pat.cod_cta_pat  <> "BENFEITORIAS"
    AND   b_bem_pat.cod_cta_pat  <> "EDIFICACOES")
    AND  (b_bem_pat.cod_estab     = "101" /* C2005-1195 */
    OR    b_bem_pat.cod_estab     = "109"))
    AND  (b_bem_pat.log_cr_pis    =  YES
    OR    b_bem_pat.log_cr_cofins =  YES) THEN DO:
        IF  NOT PROGRAM-NAME(1) MATCHES "*fas701cc.p"
        AND NOT PROGRAM-NAME(2) MATCHES "*fas701cc.p"
        AND NOT PROGRAM-NAME(3) MATCHES "*fas701cc.p" THEN DO:
            MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO DEVEM ser marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma3 AS LOGICAL.

            IF  l_confirma3 = NO THEN
                RETURN "NOK".
        END.
    END.

    IF  b_bem_pat.cod_cta_pat = "PROJETOS EM ANDAME"
    OR  b_bem_pat.cod_cta_pat = "PROJ. ANDAM. INTAN" THEN DO:

        IF  b_bem_pat.log_cr_pis    = YES
        OR  b_bem_pat.log_cr_cofins = YES THEN DO:
            IF  NOT PROGRAM-NAME(1) MATCHES "*fas701cc.p" 
            AND NOT PROGRAM-NAME(2) MATCHES "*fas701cc.p" 
            AND NOT PROGRAM-NAME(3) MATCHES "*fas701cc.p" THEN DO:
                MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO DEVEM marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma4 AS LOGICAL.
    
                IF  l_confirma4 = NO THEN
                    RETURN "NOK".
            END.
        END.
    END.

    IF  (NOT b_bem_pat.cod_ccusto_respons BEGINS "44"
    AND  NOT b_bem_pat.cod_ccusto_respons BEGINS "45"
    AND  NOT b_bem_pat.cod_ccusto_respons BEGINS "46")
    AND (b_bem_pat.cod_estab   = "101" /* C2005-1195 */
    OR   b_bem_pat.cod_estab   = "109") THEN DO:

        IF  b_bem_pat.log_cr_pis    = YES
        OR  b_bem_pat.log_cr_cofins = YES THEN DO:
            IF  NOT PROGRAM-NAME(1) MATCHES "*fas701cc.p" 
            AND  NOT PROGRAM-NAME(2) MATCHES "*fas701cc.p" 
            AND  NOT PROGRAM-NAME(3) MATCHES "*fas701cc.p" THEN DO:
                MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO DEVEM marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma5 AS LOGICAL.
    
                IF  l_confirma5 = NO THEN
                    RETURN "NOK".
            END.
        END.
    END.

    IF  b_bem_pat.cod_cta_pat <> "PROJETOS EM ANDAME"
    AND b_bem_pat.cod_cta_pat <> "PROJ. ANDAM. INTAN" THEN DO:
        
        IF  b_bem_pat.cod_ccusto_respons BEGINS "5"
        OR  b_bem_pat.cod_ccusto_respons BEGINS "6" THEN DO:
            MESSAGE "Para esta conta patrimonial e centro de custo, ser  obrigat¢ria aloca‡Æo de centro de ccusto !" 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    ASSIGN l-igual = NO.

    FOR EACH tt-conta:
        IF  b_bem_pat.cod_cta_pat = tt-conta.cod_cta_pat THEN DO:
            ASSIGN l-igual = YES.
            LEAVE.
        END.
    END.

    IF  l-igual AND b_bem_pat.cod_localiz <> "" THEN DO:
        MESSAGE "Para esta Conta Patrimonial a Localiza‡Æo nÆo dever  ser informada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.
    
    IF  b_bem_pat.cb3_ident_visual = "" THEN DO:
        MESSAGE "N£mero da plaqueta dever  ser informada !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
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

PROCEDURE pi_leave_cod_estab:
    DEF VAR v_cod_estab_old AS CHAR NO-UNDO.
    DEF VAR v_cod_estab_new AS CHAR NO-UNDO.

    ASSIGN v_cod_estab_old = h_cod_estab:SCREEN-VALUE
           v_cod_estab_new = h_new_cod_estab:SCREEN-VALUE.

    ASSIGN h_cod_estab:SCREEN-VALUE = h_new_cod_estab:SCREEN-VALUE.

    IF  valid-handle(h_fas701cada_epc) THEN
        RUN pi_trata_estab IN h_fas701cada_epc.

    ASSIGN h_cod_estab:SCREEN-VALUE = h_new_cod_estab:SCREEN-VALUE.

    IF  v_cod_estab_new <> v_cod_estab_old 
    OR NOT VALID-HANDLE(h_cb3_ident_visual) THEN
        APPLY "choose" TO h_bt_inventario.

END PROCEDURE.

PROCEDURE pi_trata_estab:

    IF  NOT VALID-HANDLE(h_cod_cta_pat) THEN DO:
        RUN piFindWidget(INPUT "cod_cta_pat",
                         INPUT "FILL-IN",
                         INPUT p_wgh_frame,
                         OUTPUT h_cod_cta_pat).
    END.

    IF   VALID-HANDLE(h_cod_cta_pat)
    AND  (h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (12 MESES)" 
    AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (24 MESES)"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (36 MESES)"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (48 MESES)"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (60 MESES)"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJ. ANDAM. INTAN"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJETOS EM ANDAME"
    AND   h_cod_cta_pat:SCREEN-VALUE <> "BENFEITORIA TERCER"
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
        ASSIGN h_cb3_ident_visual:SCREEN-VALUE = h_num_bem_pat:SCREEN-VALUE + "/" + STRING(INT(h_num_seq_bem_pat:SCREEN-VALUE),"99999").

    ASSIGN h_new_cod_estab:SCREEN-VALUE = h_cod_estab:SCREEN-VALUE.

END PROCEDURE.

PROCEDURE pi_bt_documentos:

    APPLY "choose" TO h_bt_documentos.
    ASSIGN h_new_cod_estab:SCREEN-VALUE = h_cod_estab:SCREEN-VALUE.

END PROCEDURE.

PROCEDURE pi_retira_caracteres_nao_alfa:
    def Input param p_cod_text
        as character
        format "x(8)"
        no-undo.
    def Input param p_ind_tipo
        as character
        format "X(10)"
        no-undo.
    def output param p_cod_string
        as character
        format "x(8)"
        no-undo.

    def var v_cod_aux   as character no-undo.
    def var v_cod_faixa as character no-undo.
    def var v_num_cont  as integer   no-undo.

    /***************************************************************
    *  p_ind_tipo = "1"  Somente n£meros
    *               "2"  Somente letras e espa‡os em branco
    *               "3"  Somente n£meros, letras e espa‡os em branco
    ***************************************************************/
    assign p_cod_string = "".

    /*** DEFINE A FAIXA DE CARACTERES VµLIDOS ***/
    if  p_ind_tipo = "1" then
        assign v_cod_faixa = '0123456789'.
    else if p_ind_tipo = "2" then
        assign v_cod_faixa = '()-abcdefghijklmnopqrstuvwxyz '.
    else
        assign v_cod_faixa = '()-abcdefghijklmnopqrstuvwxyz0123456789 '.

    /*** VERIFICA E RETORNA SOMENTE OS CARACTERES VµLIDOS  ***/
    do  v_num_cont = 1 to length( p_cod_text ):
        if  index( v_cod_faixa, substring(p_cod_text,v_num_cont,1) ) > 0 then
            assign p_cod_string = p_cod_string + substring(p_cod_text,v_num_cont,1).
    end.

END PROCEDURE.

RETURN "OK".
