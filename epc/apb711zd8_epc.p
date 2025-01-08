/*****************************************************************************
**
** Programa..............: apb711zd8_epc.p
**
** Descricao.............: EPC do Evento do browse br_dlg_item_bord_ap_cjto do 
**                         programa fnc_item_lote_pagto_inclui_conjto.
**
** Criado em.............: 15/12/2017
**
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").

DEFINE NEW GLOBAL SHARED VARIABLE h_br_dlg_item_bord_ap_cjto  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global  AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query        AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE hitem_bord_ap    AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE l-todos-apb711zd AS LOG INIT NO   NO-UNDO.

DEF VAR l-desconsidera          AS LOG    NO-UNDO.
DEF VAR v_log_return            AS LOG    NO-UNDO.
DEF VAR wgh_rec_item_lote_pagto AS HANDLE NO-UNDO.
DEF VAR h_num_id_item_bord_ap   AS HANDLE NO-UNDO.
DEF VAR hbuffer                 AS HANDLE NO-UNDO.

DEF VAR i-linha AS INT NO-UNDO.
DEF VAR i-cont  AS INT NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.

DEF NEW GLOBAL SHARED temp-table tt_tot_selec no-undo
    FIELD num_id_reg     AS INT
    FIELD rec_reg        AS RECID
    FIELD val_pagto      AS DEC  FORMAT ">>,>>>,>>>,>>9.99" 
    FIELD cod_indic_econ AS CHAR FORMAT "x(8)"
    INDEX indic_econ
          cod_indic_econ ASCENDING.

DEF NEW GLOBAL SHARED temp-table tt_item_cotacao no-undo
    FIELD num_id_reg AS INT.

PROCEDURE pi_cria_reg_unico:
    /*MESSAGE "pi_cria_reg_unico" VIEW-AS ALERT-BOX.*/

    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    ASSIGN l-todos-apb711zd = NO.

    FOR EACH tt_tot_selec:
        DELETE tt_tot_selec.
        /*MESSAGE "pi_cria_reg_unico - delete" VIEW-AS ALERT-BOX.*/
    END.

    ASSIGN hquery        = h_br_dlg_item_bord_ap_cjto:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_item_lote_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .

    FIND FIRST item_bord_ap
        WHERE recid(item_bord_ap) = wgh_rec_item_lote_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL item_bord_ap THEN DO:
        /*MESSAGE "pi_cria_reg_unico - item_bord_ap.cod_estab " item_bord_ap.cod_estab       skip 
                "item_bord_ap.cod_espec_docto "      item_bord_ap.cod_espec_docto skip
                "item_bord_ap.cod_ser_docto "        item_bord_ap.cod_ser_docto   skip
                "item_bord_ap.cdn_fornecedor "       item_bord_ap.cdn_fornecedor  skip
                "item_bord_ap.cod_tit_ap "           item_bord_ap.cod_tit_ap      skip
                "item_bord_ap.cod_parcela "          item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

        find first bord_ap 
             where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
             and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
             and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.

        CREATE tt_tot_selec.
        ASSIGN tt_tot_selec.num_id_reg     = item_bord_ap.num_id_item_bord_ap
               tt_tot_selec.val_pagto      = item_bord_ap.val_pagto
               tt_tot_selec.cod_indic_econ = bord_ap.cod_indic_econ WHEN AVAIL bord_ap.
    END.
END.

PROCEDURE pi_cria_reg_multiplo:
    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    ASSIGN l-todos-apb711zd = NO.

    ASSIGN hquery        = h_br_dlg_item_bord_ap_cjto:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_item_lote_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .

    FIND FIRST item_bord_ap
        WHERE recid(item_bord_ap) = wgh_rec_item_lote_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL item_bord_ap THEN DO:
        /*MESSAGE "pi_cria_reg_multiplo - item_bord_ap.cod_estab " item_bord_ap.cod_estab       skip 
                "item_bord_ap.cod_espec_docto "      item_bord_ap.cod_espec_docto skip
                "item_bord_ap.cod_ser_docto "        item_bord_ap.cod_ser_docto   skip
                "item_bord_ap.cdn_fornecedor "       item_bord_ap.cdn_fornecedor  skip
                "item_bord_ap.cod_tit_ap "           item_bord_ap.cod_tit_ap      skip
                "item_bord_ap.cod_parcela "          item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

        FIND FIRST tt_tot_selec
            WHERE tt_tot_selec.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL tt_tot_selec THEN DO:
            find first bord_ap 
                 where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                 and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                 and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.

            CREATE tt_tot_selec.
            ASSIGN tt_tot_selec.num_id_reg     = item_bord_ap.num_id_item_bord_ap
                   tt_tot_selec.val_pagto      = item_bord_ap.val_pagto
                   tt_tot_selec.cod_indic_econ = bord_ap.cod_indic_econ WHEN AVAIL bord_ap.
        END.

        FIND FIRST tit_ap 
            WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab      
            AND   tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
            AND   tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto  
            AND   tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor 
            AND   tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap     
            AND   tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-LOCK NO-ERROR.

        IF  AVAIL tit_ap
        AND tit_ap.cod_indic_econ <> "Real" THEN DO:
            FIND FIRST tt_item_cotacao
                WHERE tt_item_cotacao.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.
    
            IF  NOT AVAIL tt_item_cotacao THEN DO:
                CREATE tt_item_cotacao.
                ASSIGN tt_item_cotacao.num_id_reg = item_bord_ap.num_id_item_bord_ap.
            END.
        END.
    END.
END.

PROCEDURE pi_cria_reg_down:
    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    ASSIGN l-todos-apb711zd = NO.

    FOR EACH tt_tot_selec:
        DELETE tt_tot_selec.
        /*MESSAGE "pi_cria_reg_unico - delete" VIEW-AS ALERT-BOX.*/
    END.

    ASSIGN hquery        = h_br_dlg_item_bord_ap_cjto:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_item_lote_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .
    
    FIND FIRST item_bord_ap
        WHERE recid(item_bord_ap) = wgh_rec_item_lote_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL item_bord_ap THEN DO:
        /*MESSAGE "pi_cria_reg_down - item_bord_ap.cod_estab " item_bord_ap.cod_estab       skip 
                "item_bord_ap.cod_espec_docto "      item_bord_ap.cod_espec_docto skip
                "item_bord_ap.cod_ser_docto "        item_bord_ap.cod_ser_docto   skip
                "item_bord_ap.cdn_fornecedor "       item_bord_ap.cdn_fornecedor  skip
                "item_bord_ap.cod_tit_ap "           item_bord_ap.cod_tit_ap      skip
                "item_bord_ap.cod_parcela "          item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

        FIND FIRST tt_tot_selec
            WHERE tt_tot_selec.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL tt_tot_selec THEN DO:
            find first bord_ap 
                 where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                 and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                 and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.

            CREATE tt_tot_selec.
            ASSIGN tt_tot_selec.num_id_reg     = item_bord_ap.num_id_item_bord_ap
                   tt_tot_selec.val_pagto      = item_bord_ap.val_pagto
                   tt_tot_selec.cod_indic_econ = bord_ap.cod_indic_econ WHEN AVAIL bord_ap.
        END.
    END.
END.

PROCEDURE pi_cria_reg_up:
    /*MESSAGE "up" VIEW-AS ALERT-BOX.*/

    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    EMPTY TEMP-TABLE tt_item_cotacao.

    ASSIGN l-todos-apb711zd = NO.

    ASSIGN hquery        = h_br_dlg_item_bord_ap_cjto:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_item_lote_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .

    FIND FIRST item_bord_ap
        WHERE recid(item_bord_ap) = wgh_rec_item_lote_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL item_bord_ap THEN DO:

        /*MESSAGE "pi_cria_reg_up - item_bord_ap.cod_estab " item_bord_ap.cod_estab       skip 
                "item_bord_ap.cod_espec_docto "      item_bord_ap.cod_espec_docto skip
                "item_bord_ap.cod_ser_docto "        item_bord_ap.cod_ser_docto   skip
                "item_bord_ap.cdn_fornecedor "       item_bord_ap.cdn_fornecedor  skip
                "item_bord_ap.cod_tit_ap "           item_bord_ap.cod_tit_ap      skip
                "item_bord_ap.cod_parcela "          item_bord_ap.cod_parcela VIEW-AS ALERT-BOX. /* andrey */*/

        FIND FIRST tt_tot_selec
            WHERE tt_tot_selec.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL tt_tot_selec THEN DO:
            find first bord_ap 
                 where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                 and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                 and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.

            CREATE tt_tot_selec.
            ASSIGN tt_tot_selec.num_id_reg     = item_bord_ap.num_id_item_bord_ap
                   tt_tot_selec.val_pagto      = item_bord_ap.val_pagto
                   tt_tot_selec.cod_indic_econ = bord_ap.cod_indic_econ WHEN AVAIL bord_ap.
        END.
    END.

    IF VALID-HANDLE(h_br_dlg_item_bord_ap_cjto) THEN DO:
        DO  i-linha = 1 TO h_br_dlg_item_bord_ap_cjto:NUM-SELECTED-ROWS:
            
            h_br_dlg_item_bord_ap_cjto:FETCH-SELECTED-ROW(i-linha).
    
            ASSIGN hquery                = h_br_dlg_item_bord_ap_cjto:QUERY 
                   hbuffer               = hquery:GET-BUFFER-HANDLE(2)
                   h_num_id_item_bord_ap = hbuffer:BUFFER-FIELD("num_id_item_bord_ap").   
        
            FIND FIRST item_bord_ap
                WHERE item_bord_ap.num_id_item_bord_ap = h_num_id_item_bord_ap:BUFFER-VALUE NO-LOCK NO-ERROR.
    
            IF  AVAIL item_bord_ap THEN DO:

                FIND FIRST tit_ap 
                    WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab      
                    AND   tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                    AND   tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto  
                    AND   tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor 
                    AND   tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap     
                    AND   tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-LOCK NO-ERROR.

                IF  AVAIL tit_ap
                AND tit_ap.cod_indic_econ <> "Real" THEN DO:
                    FIND FIRST tt_item_cotacao
                        WHERE tt_item_cotacao.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_item_cotacao THEN DO:
                        CREATE tt_item_cotacao.
                        ASSIGN tt_item_cotacao.num_id_reg = item_bord_ap.num_id_item_bord_ap.
                    END.
                END.

                FIND FIRST tt_tot_selec
                    WHERE tt_tot_selec.num_id_reg = item_bord_ap.num_id_item_bord_ap EXCLUSIVE-LOCK NO-ERROR.
        
                IF  NOT AVAIL tt_tot_selec THEN DO:
                    find first bord_ap 
                         where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                         and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                         and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.
        
                    CREATE tt_tot_selec.
                    ASSIGN tt_tot_selec.num_id_reg     = item_bord_ap.num_id_item_bord_ap
                           tt_tot_selec.val_pagto      = item_bord_ap.val_pagto
                           tt_tot_selec.cod_indic_econ = bord_ap.cod_indic_econ WHEN AVAIL bord_ap.
                END.
            END.
        END.
    END.
END.
