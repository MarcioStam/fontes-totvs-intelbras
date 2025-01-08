def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF NEW GLOBAL SHARED VAR h_qr_bem_pat_reclassif_conta AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR h_br_bem_pat_reclassif_conta AS WIDGET-HANDLE NO-UNDO. 

def temp-table tt_param_calc_cta no-undo like param_calc_cta
    field ttv_qtd_dias_vida_util           as decimal format ">>>,>>>,>>9".

DEF TEMP-TABLE tt_param_reclassif NO-UNDO
    FIELD cod_cta_pat           like bem_pat.cod_cta_pat     
    FIELD num_bem_pat           like bem_pat.num_bem_pat     
    FIELD num_seq_bem_pat       like bem_pat.num_seq_bem_pat 
    FIELD dat_reclassif_bem_pat like bem_pat.dat_calc_pat
    FIELD cod_cta_pat_reclassif like bem_pat.cod_cta_pat
    FIELD cod_grp_calc          like cta_pat.cod_grp_calc
    FIELD cod_plano_ccusto      like bem_pat.cod_plano_ccusto   
    FIELD cod_ccusto_respons    like bem_pat.cod_ccusto_respons 
    FIELD cod_estab             like bem_pat.cod_estab          
    FIELD cod_unid_negoc        like bem_pat.cod_unid_negoc     
    FIELD cod_localiz           like bem_pat.cod_localiz        
    FIELD cod_cta_pat_inc       like bem_pat.cod_cta_pat
    FIELD cod_cta_pat_reaval    like bem_pat.cod_cta_pat.

DEF VAR c-lin             AS CHAR                NO-UNDO.
def var v_num_order       as int                 no-undo.
def var v_num_order_aux   as int                 no-undo.
def var c-arquivo-entrada as char FORMAT "x(60)" no-undo.
def var l-ok              as LOG                 no-undo.
def var c-arq-conv        as char                no-undo.

DEF RECT rt_001 SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.

def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.

def button bt_arq
    label "Arq"
    tooltip "Seleciona arquivo"
    IMAGE-UP FILE "imagem/im-sea.bmp"
    size 1 by 1.

def frame f-arquivo
    rt_001            AT ROW 01.20 COL 01.50 
    c-arquivo-entrada AT ROW 02.42 COL 09.00 LABEL "Arquivo"
    bt_arq            AT ROW 02.42 COL 50.30 
    rt_002            AT ROW 04.75 COL 01.50 
    bt_ok             AT ROW 04.95 COL 02.55 FONT ? HELP "OK":U
    bt_can            AT ROW 04.95 COL 12.90 FONT ? HELP "Cancela"    
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 65.55 BY 06.60
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Carrega parƒmetros".

assign c-arquivo-entrada:width-chars   in frame f-arquivo = 35.00
       c-arquivo-entrada:height-chars  in frame f-arquivo = 01.00
       bt_can:width-chars              in frame f-arquivo = 10.00
       bt_can:height-chars             in frame f-arquivo = 01.00
       bt_ok:width-chars               in frame f-arquivo = 10.00
       bt_ok:height-chars              in frame f-arquivo = 01.00
       bt_arq:width-chars              in frame f-arquivo = 03.75
       bt_arq:height-chars             in frame f-arquivo = 01.00
       rt_001:WIDTH-CHARS              IN FRAME f-arquivo = 63.57
       rt_001:HEIGHT-CHARS             IN FRAME f-arquivo = 03.42
       rt_002:WIDTH-CHARS              IN FRAME f-arquivo = 63.57
       rt_002:HEIGHT-CHARS             IN FRAME f-arquivo = 01.42.

ON  CHOOSE OF bt_arq IN FRAME f-arquivo DO:
    assign c-arq-conv = replace(input frame f-arquivo c-arquivo-entrada, "/", "~\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"         
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.
    
    if  l-ok = yes then do:
        assign c-arquivo-entrada = replace(c-arq-conv, "~\", "/").
        display c-arquivo-entrada with frame f-arquivo.
    end.

    ASSIGN c-arquivo-entrada.
END.

ON  CHOOSE OF bt_ok IN FRAME f-arquivo DO:

    IF  SEARCH(c-arquivo-entrada) = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo informado nÆo encontrado":U).
        RETURN NO-APPLY.
    END.
    
    INPUT FROM value(c-arquivo-entrada).
    
    REPEAT:
        IMPORT UNFORMATTED c-lin.
        
        FIND FIRST cta_pat
            WHERE cta_pat.cod_empresa = v_cod_empres_usuar
            AND   cta_pat.cod_cta_pat = ENTRY(1,c-lin,";") NO-LOCK NO-ERROR.

        IF  NOT AVAIL cta_pat THEN NEXT.

        CREATE tt_param_reclassif.
        ASSIGN tt_param_reclassif.cod_cta_pat           = ENTRY(1,c-lin,";")
               tt_param_reclassif.num_bem_pat           = INT(ENTRY(2,c-lin,";"))
               tt_param_reclassif.num_seq_bem_pat       = INT(ENTRY(3,c-lin,";"))
               tt_param_reclassif.dat_reclassif_bem_pat = DATE(ENTRY(4,c-lin,";"))
               tt_param_reclassif.cod_cta_pat_reclassif = ENTRY(5,c-lin,";")
               tt_param_reclassif.cod_grp_calc          = ENTRY(6,c-lin,";")
               tt_param_reclassif.cod_plano_ccusto      = ENTRY(7,c-lin,";")
               tt_param_reclassif.cod_ccusto_respons    = ENTRY(8,c-lin,";")
               tt_param_reclassif.cod_estab             = ENTRY(9,c-lin,";")
               tt_param_reclassif.cod_unid_negoc        = ENTRY(10,c-lin,";")
               tt_param_reclassif.cod_localiz           = ENTRY(11,c-lin,";")
               tt_param_reclassif.cod_cta_pat_inc       = ENTRY(12,c-lin,";")
               tt_param_reclassif.cod_cta_pat_reaval    = ENTRY(13,c-lin,";").
    END.
    
    ASSIGN v_num_order     = 0
           v_num_order_aux = 0.
    
    EMPTY TEMP-TABLE tt_param_calc_cta.

    FOR EACH tt_param_reclassif:
    
        FIND LAST dwb_set_list
             WHERE dwb_set_list.cod_dwb_program  = "tar_reclassif_bem_pat":U
             AND   dwb_set_list.cod_dwb_user     = v_cod_usuar_corren NO-LOCK NO-ERROR.

        IF  AVAIL dwb_set_list THEN
            ASSIGN v_num_order = dwb_set_list.num_dwb_order.

        ASSIGN v_num_order = v_num_order + 1.

        create dwb_set_list.
        assign dwb_set_list.cod_dwb_program  = "tar_reclassif_bem_pat":U
               dwb_set_list.cod_dwb_user     = v_cod_usuar_corren
               dwb_set_list.ind_dwb_set_type = "Regra"            
               dwb_set_list.cod_dwb_set      = "Individual"
               dwb_set_list.num_dwb_order    = v_num_order.
        
        assign dwb_set_list.cod_dwb_set_single = tt_param_reclassif.cod_cta_pat         + chr(10) +
                                                 string(tt_param_reclassif.num_bem_pat) + chr(10) +
                                                 string(tt_param_reclassif.num_seq_bem_pat).
        
        find first bem_pat
            where bem_pat.cod_cta_pat     = tt_param_reclassif.cod_cta_pat
            and   bem_pat.num_bem_pat     = tt_param_reclassif.num_bem_pat
            AND   bem_pat.num_seq_bem_pat = tt_param_reclassif.num_seq_bem_pat no-lock no-error.
        
        IF  AVAIL bem_pat THEN DO:
            FIND FIRST cta_pat
                WHERE cta_pat.cod_empresa = v_cod_empres_usuar
                AND   cta_pat.cod_cta_pat = bem_pat.cod_cta_pat NO-LOCK NO-ERROR.
            
            IF  NOT AVAIL cta_pat THEN NEXT.
        
            FIND FIRST grp_calc
                WHERE grp_calc.cod_grp_calc = tt_param_reclassif.cod_grp_calc NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL grp_calc THEN NEXT.
        
            if  cta_pat.cod_grp_calc = grp_calc.cod_grp_calc then do:
                
                blk_param:
                for each param_calc_cta no-lock
                    where param_calc_cta.cod_empresa = cta_pat.cod_empresa
                    and   param_calc_cta.cod_cta_pat = cta_pat.cod_cta_pat:
                    
                    find tt_param_calc_cta
                        where tt_param_calc_cta.cod_empresa      = cta_pat.cod_empresa
                        and   tt_param_calc_cta.cod_cta_pat      = tt_param_reclassif.cod_cta_pat_reclassif
                        and   tt_param_calc_cta.cod_tip_calc     = param_calc_cta.cod_tip_calc
                        and   tt_param_calc_cta.cod_cenar_ctbl   = param_calc_cta.cod_cenar_ctbl
                        and   tt_param_calc_cta.cod_finalid_econ = param_calc_cta.cod_finalid_econ
                        no-lock no-error.
                    
                    if  not avail tt_param_calc_cta then do:
                        create tt_param_calc_cta.
                        assign tt_param_calc_cta.cod_empresa      = param_calc_cta.cod_empresa
                               tt_param_calc_cta.cod_cta_pat      = tt_param_reclassif.cod_cta_pat_reclassif
                               tt_param_calc_cta.cod_tip_calc     = param_calc_cta.cod_tip_calc
                               tt_param_calc_cta.cod_cenar_ctbl   = param_calc_cta.cod_cenar_ctbl
                               tt_param_calc_cta.cod_finalid_econ = param_calc_cta.cod_finalid_econ.
                        assign tt_param_calc_cta.qtd_anos_vida_util         = param_calc_cta.qtd_anos_vida_util
                               tt_param_calc_cta.qtd_unid_vida_util         = param_calc_cta.qtd_unid_vida_util
                               tt_param_calc_cta.val_perc_anual_dpr         = param_calc_cta.val_perc_anual_dpr
                               tt_param_calc_cta.val_resid_min              = param_calc_cta.val_resid_min
                               tt_param_calc_cta.val_perc_anual_dpr_incevda = param_calc_cta.val_perc_anual_dpr_incevda
                               tt_param_calc_cta.dat_ult_atualiz            = param_calc_cta.dat_ult_atualiz
                               tt_param_calc_cta.hra_ult_atualiz            = param_calc_cta.hra_ult_atualiz
                               tt_param_calc_cta.cod_usuar_ult_atualiz      = param_calc_cta.cod_usuar_ult_atualiz.    
                    end.
                    
                    assign tt_param_calc_cta.cod_grp_calc = grp_calc.cod_grp_calc.
                end.
            end.
            else do:
                
                blk_grp:
                for each compos_grp_calc no-lock
                    where compos_grp_calc.cod_grp_calc = grp_calc.cod_grp_calc:
                    
                    find tt_param_calc_cta
                        where tt_param_calc_cta.cod_empresa      = cta_pat.cod_empresa
                        and   tt_param_calc_cta.cod_cta_pat      = tt_param_reclassif.cod_cta_pat_reclassif
                        and   tt_param_calc_cta.cod_tip_calc     = compos_grp_calc.cod_tip_calc
                        and   tt_param_calc_cta.cod_cenar_ctbl   = compos_grp_calc.cod_cenar_ctbl
                        and   tt_param_calc_cta.cod_finalid_econ = compos_grp_calc.cod_finalid_econ
                        no-lock no-error.
                    
                    if  not avail tt_param_calc_cta then do:
                        create tt_param_calc_cta.
                        assign tt_param_calc_cta.cod_empresa      = cta_pat.cod_empresa
                               tt_param_calc_cta.cod_cta_pat      = tt_param_reclassif.cod_cta_pat_reclassif
                               tt_param_calc_cta.cod_tip_calc     = compos_grp_calc.cod_tip_calc
                               tt_param_calc_cta.cod_cenar_ctbl   = compos_grp_calc.cod_cenar_ctbl
                               tt_param_calc_cta.cod_finalid_econ = compos_grp_calc.cod_finalid_econ.
            
                    end.
                    
                    assign tt_param_calc_cta.cod_grp_calc = grp_calc.cod_grp_calc.

                    find param_calc_cta no-lock
                        where param_calc_cta.cod_empresa      = cta_pat.cod_empresa                     
                        and   param_calc_cta.cod_cta_pat      = tt_param_reclassif.cod_cta_pat_reclassif
                        and   param_calc_cta.cod_tip_calc     = compos_grp_calc.cod_tip_calc            
                        and   param_calc_cta.cod_cenar_ctbl   = compos_grp_calc.cod_cenar_ctbl          
                        AND   param_calc_cta.cod_finalid_econ = compos_grp_calc.cod_finalid_econ no-error.

                    IF  AVAIL param_calc_cta THEN
                        ASSIGN tt_param_calc_cta.qtd_anos_vida_util = param_calc_cta.qtd_anos_vida_util
                               tt_param_calc_cta.qtd_unid_vida_util = param_calc_cta.qtd_unid_vida_util
                               tt_param_calc_cta.val_perc_anual_dpr = param_calc_cta.val_perc_anual_dpr.
                end.
            end.
            
            ASSIGN v_num_order_aux = v_num_order * 1000.
        
            tt_param:
            for each tt_param_calc_cta no-lock:
                
                find dwb_set_list_param_aux
                    where dwb_set_list_param_aux.cod_dwb_program = dwb_set_list.cod_dwb_program
                    and   dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list.cod_dwb_user
                    and   dwb_set_list_param_aux.num_dwb_order   = v_num_order_aux exclusive-lock no-error.
                
                if  not avail dwb_set_list_param_aux then do:
                    create dwb_set_list_param_aux.
                    assign dwb_set_list_param_aux.cod_dwb_program = dwb_set_list.cod_dwb_program
                           dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list.cod_dwb_user
                           dwb_set_list_param_aux.num_dwb_order   = v_num_order_aux.
                end.
                
                assign dwb_set_list_param_aux.cod_dwb_parameters = tt_param_calc_cta.cod_empresa                        + chr(10) +
                                                                   tt_param_calc_cta.cod_cta_pat                        + chr(10) +
                                                                   tt_param_calc_cta.cod_tip_calc                       + chr(10) +
                                                                   tt_param_calc_cta.cod_cenar_ctbl                     + chr(10) +
                                                                   tt_param_calc_cta.cod_finalid_econ                   + chr(10) +
                                                                   tt_param_calc_cta.cod_grp_calc                       + chr(10) +
                                                                   string(tt_param_calc_cta.qtd_anos_vida_util)         + chr(10) +
                                                                   string(tt_param_calc_cta.qtd_unid_vida_util)         + chr(10) +
                                                                   string(tt_param_calc_cta.val_perc_anual_dpr)         + chr(10) +
                                                                   string(tt_param_calc_cta.val_resid_min)              + chr(10) +
                                                                   string(tt_param_calc_cta.val_perc_anual_dpr_incevda) + chr(10) +
                                                                   "0"
                       v_num_order_aux = v_num_order_aux + 1.
            end.
            
            /*
            blk_dwb_set_list_param_aux:
            for each  dwb_set_list_param_aux exclusive-lock
                where dwb_set_list_param_aux.cod_dwb_program = dwb_set_list.cod_dwb_program
                and   dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list.cod_dwb_user
                and   dwb_set_list_param_aux.num_dwb_order  >= v_num_order:
                delete dwb_set_list_param_aux.
            end.
            */

            assign dwb_set_list.cod_dwb_set_parameters = string(tt_param_reclassif.dat_reclassif_bem_pat) + chr(10) +
                                                         tt_param_reclassif.cod_cta_pat_reclassif         + chr(10) +
                                                         tt_param_reclassif.cod_grp_calc                  + chr(10) +
                                                         string(v_num_order_aux)                          + chr(10) +
                                                         tt_param_reclassif.cod_plano_ccusto              + chr(10) +
                                                         tt_param_reclassif.cod_ccusto_respons            + chr(10) +
                                                         tt_param_reclassif.cod_estab                     + chr(10) +
                                                         tt_param_reclassif.cod_unid_negoc                + chr(10) +
                                                         tt_param_reclassif.cod_localiz                   + chr(10) + 
                                                         tt_param_reclassif.cod_cta_pat_inc               + chr(10) +
                                                         tt_param_reclassif.cod_cta_pat_reaval            + chr(10) +
                                                         "NÆo".

        END.
    END.

    IF  VALID-HANDLE(h_br_bem_pat_reclassif_conta) THEN DO:
        RUN pi_open_query_30_a IN p_wgh_object.
        h_br_bem_pat_reclassif_conta:REFRESH().
    END.
END.

/* main */
arq_block:
DO  ON ENDKEY UNDO arq_block, LEAVE arq_block:
    VIEW FRAME f-arquivo.

    ENABLE ALL WITH FRAME f-arquivo.

    WAIT-FOR GO OF FRAME f-arquivo.
END.

HIDE FRAME f-arquivo.

RETURN "OK".
