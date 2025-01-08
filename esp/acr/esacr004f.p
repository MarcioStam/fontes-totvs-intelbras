/*****************************************************************************
** Programa..............: esp/acr/esacr004f.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 04/12/2008
*****************************************************************************/

/************************ Parameter Definition Begin ************************/

def Input param p_numero
    as integer
    format ">>>>>9"
    no-undo.
def Input param p_val_tit
    as DEC
    no-undo.

/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

def buffer b_fedex-rateio
    for fedex-rateio.

/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_dat_type
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def new shared var v_ind_tip_prog
    as character
    format "X(20)":U
    no-undo.
def var v_nom_attrib
    as character
    format "x(30)":U
    no-undo.
def var v_nom_program
    as character
    format "x(50)":U
    label "Programa"
    column-label "Programa"
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_rec_fedex-rateio
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_acr
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_sdo_rat_tit_acr
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Saldo a Ratear"
    column-label "Saldo a Ratear"
    no-undo.
def var v_val_tot_rat
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total Rateio"
    column-label "Total Rateio"
    no-undo.
def var v_cod_format_ccusto
    as character
    format "x(11)":U
    INITIAL "99999"
    label "Formato CCusto"
    column-label "Formato CCusto"
    no-undo.
def var v_cod_format_cta_ctbl
    as character
    format "x(20)":U
    INITIAL "9.9.9.99.999"
    label "Formato Cta Cont†bil"
    column-label "Formato Conta"
    no-undo.

def var v_log_repeat                     as logical         no-undo. /*local*/
DEF VAR v_val_tit AS DEC.

DEFINE VARIABLE v_cod_cta_ctbl     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl     AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl AS INTEGER     NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància".

/************************** Variable Definition End *************************/



FUNCTION fn-retorna-desc-cta RETURNS CHAR ():

    ASSIGN v_cod_cta_ctbl = fedex-rateio.cod_cta_ctbl.
    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT         INT(v_cod_empres_usuar)   , /* EMPRESA EMS2 */
                                                   INPUT         ""                        , /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT  v_cod_cta_ctbl            , /* CONTA */
                                                   INPUT         TODAY                     , /* DATA TRANSACAO */   
                                                   OUTPUT        v_des_cta_ctbl            , /* DESCRICAO CONTA */
                                                   OUTPUT        v_num_tip_cta_ctbl        , /* TIPO DA CONTA */
                                                   OUTPUT        v_num_sit_cta_ctbl        , /* SITUAÄ«O DA CONTA */
                                                   OUTPUT        v_ind_finalid_cta         , /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE  tt_log_erro).               /* ERROS */

    RETURN v_des_cta_ctbl.
END FUNCTION.

/************************** Query Definition Begin **************************/

def query qr_bac_fedex-rateio
    for fedex-rateio
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_bac_fedex-rateio query qr_bac_fedex-rateio display 
    string(fedex-rateio.cod_cta_ctbl,v_cod_format_cta_ctbl) format "x(20)"    column-label "Conta Cont†bil"
    fn-retorna-desc-cta() @ v_des_cta_ctbl                  FORMAT "x(30)"    COLUMN-LABEL "Descriá∆o"
    fedex-rateio.cod_unid_negoc                             width-chars 04.00 column-label "Un N"
    string(fedex-rateio.cod_ccusto,v_cod_format_ccusto)     format "x(11)"    column-label "CCusto"
    fedex-rateio.perc_aprop_ctbl                            width-chars 7.00  column-label "% Rateio"
    v_val_tit                                               width-chars 15.00 column-label "Valor Rateio"
    with separators single 
         size 55 by 06.65
         font 4
         bgcolor 15
         title "Itens do Rateio de Valores".


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_cxcl
    size 1 by 1
    edge-pixels 2.

/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_add2
    label "Inclui"
    tooltip "Inclui"
    size 1 by 1.
def button bt_mod2
    label "Modifica"
    tooltip "Modifica"
    size 1 by 1.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_era3
    label "Elimina"
    tooltip "Elimina"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_bac_fedex-rateio
    as character
    initial "Por Conta Cont†bil"
    view-as radio-set Horizontal
    radio-buttons "Por Conta Cont†bil", "Por Conta Cont†bil"
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_bac_01_fedex-rateio
    rt_001
         at row 10.29 col 02.00
    " % Rateio " view-as text
         at row 9.99 col 04.00 bgcolor 8 
    rt_cxcf
         at row 15.21 col 02.00 bgcolor 7 
    rt_cxcl
         at row 01.54 col 02.00 bgcolor 15 
    rs_bac_fedex-rateio
         at row 01.71 col 03.00
         help "" no-label
    br_bac_fedex-rateio
         at row 02.83 col 02.00
         help "Itens do Rateio de Valores"
    v_val_tot_rat
         at row 11.00 col 20.00 colon-aligned label "Total % Rateio"
         help "Total do % Rateio"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_rat_tit_acr
         at row 12.00 col 20.00 colon-aligned label "Saldo % a Ratear"
         help "Saldo do % que n∆o foi rateado"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_add2
         at row 13.71 col 03.00 font ?
         help "Inclui"
    bt_mod2
         at row 13.71 col 14.00 font ?
         help "Elimina"
    bt_era3
         at row 13.71 col 25.00 font ?
         help "Elimina"
    bt_ok
         at row 15.42 col 03.00 font ?
         help "OK"
    bt_can
         at row 15.42 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 58 by 17 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Manutená∆o Rateio Valores".
    /* adjust size of objects in this frame */
    assign bt_add2:width-chars      in frame f_bac_01_fedex-rateio = 10.00
           bt_add2:height-chars     in frame f_bac_01_fedex-rateio = 01.00
           bt_mod2:width-chars      in frame f_bac_01_fedex-rateio = 10.00
           bt_mod2:height-chars     in frame f_bac_01_fedex-rateio = 01.00
           bt_can:width-chars       in frame f_bac_01_fedex-rateio = 10.00
           bt_can:height-chars      in frame f_bac_01_fedex-rateio = 01.00
           bt_era3:width-chars      in frame f_bac_01_fedex-rateio = 10.00
           bt_era3:height-chars     in frame f_bac_01_fedex-rateio = 01.00
           bt_ok:width-chars        in frame f_bac_01_fedex-rateio = 10.00
           bt_ok:height-chars       in frame f_bac_01_fedex-rateio = 01.00
           rt_001:width-chars       in frame f_bac_01_fedex-rateio = 55
           rt_001:height-chars      in frame f_bac_01_fedex-rateio = 02.96
           rt_cxcf:width-chars      in frame f_bac_01_fedex-rateio = 55
           rt_cxcf:height-chars     in frame f_bac_01_fedex-rateio = 01.42
           rt_cxcl:width-chars      in frame f_bac_01_fedex-rateio = 55
           rt_cxcl:height-chars     in frame f_bac_01_fedex-rateio = 01.21.
    /* set private-data for the help system */
    assign rs_bac_fedex-rateio:private-data in frame f_bac_01_fedex-rateio = "HLP=000017220":U
           br_bac_fedex-rateio:private-data in frame f_bac_01_fedex-rateio = "HLP=000017220":U
           v_val_tot_rat:private-data              in frame f_bac_01_fedex-rateio = "HLP=000010897":U
           v_val_sdo_rat_tit_acr:private-data      in frame f_bac_01_fedex-rateio = "HLP=000017267":U
           bt_add2:private-data                    in frame f_bac_01_fedex-rateio = "HLP=000010825":U
           bt_era3:private-data                    in frame f_bac_01_fedex-rateio = "HLP=000010802":U
           bt_ok:private-data                      in frame f_bac_01_fedex-rateio = "HLP=000010721":U
           bt_can:private-data                     in frame f_bac_01_fedex-rateio = "HLP=000011050":U
           frame f_bac_01_fedex-rateio:private-data                               = "HLP=000017220".

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON ROW-DISPLAY OF br_bac_fedex-rateio IN FRAME f_bac_01_fedex-rateio
DO: 

    ASSIGN v_val_tit = round(p_val_tit * fedex-rateio.perc_aprop_ctbl / 100, 2).

END.

ON CHOOSE OF bt_add2 IN FRAME f_bac_01_fedex-rateio
DO:

    run esp/acr/esacr004g.p (Input p_numero,
                             Input TODAY,
                             Input 100).

    assign v_val_tot_rat         = 100
           v_val_sdo_rat_tit_acr = 100.

    calculo_valores:
    for each b_fedex-rateio no-lock 
        where b_fedex-rateio.numero = p_numero:
        assign v_val_sdo_rat_tit_acr = v_val_sdo_rat_tit_acr - b_fedex-rateio.perc_aprop_ctbl.
    end /* for calculo_valores */.

    apply "value-changed" to rs_bac_fedex-rateio in frame f_bac_01_fedex-rateio.
END. /* ON CHOOSE OF bt_add2 IN FRAME f_bac_01_fedex-rateio */

ON CHOOSE OF bt_mod2 IN FRAME f_bac_01_fedex-rateio
DO:

    IF AVAIL fedex-rateio
    THEN DO:
    
         ASSIGN v_rec_fedex-rateio = RECID(fedex-rateio).
    
         run esp/acr/esacr004h.p (Input p_numero,
                                  Input TODAY,
                                  Input 100).
    
         assign v_val_tot_rat         = 100
                v_val_sdo_rat_tit_acr = 100.
    
         calculo_valores:
         for each b_fedex-rateio no-lock 
             where b_fedex-rateio.numero = p_numero:
             assign v_val_sdo_rat_tit_acr = v_val_sdo_rat_tit_acr - b_fedex-rateio.perc_aprop_ctbl.
         end /* for calculo_valores */.
    
         apply "value-changed" to rs_bac_fedex-rateio in frame f_bac_01_fedex-rateio.

    END.

END. /* ON CHOOSE OF bt_add2 IN FRAME f_bac_01_fedex-rateio */

ON CHOOSE OF bt_can IN FRAME f_bac_01_fedex-rateio
DO:

    RETURN "NOK" /*l_nok*/ .

END. /* ON CHOOSE OF bt_can IN FRAME f_bac_01_fedex-rateio */

ON CHOOSE OF bt_era3 IN FRAME f_bac_01_fedex-rateio
DO:

    /************************* Variable Definition Begin ************************/

    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.


    /************************** Variable Definition End *************************/

    FIND CURRENT fedex-rateio EXCLUSIVE-LOCK NO-ERROR.
    if  avail fedex-rateio
    then do:
         DELETE fedex-rateio.
         assign v_log_method = br_bac_fedex-rateio:delete-current-row().
         assign v_val_sdo_rat_tit_acr = 100.
         calculo_valores:
         for each b_fedex-rateio no-lock 
             where b_fedex-rateio.numero = p_numero:
            assign v_val_sdo_rat_tit_acr = v_val_sdo_rat_tit_acr - b_fedex-rateio.perc_aprop_ctbl.
        end.
        apply "value-changed" to rs_bac_fedex-rateio in frame f_bac_01_fedex-rateio.
    end.

END. /* ON CHOOSE OF bt_era3 IN FRAME f_bac_01_fedex-rateio */

ON CHOOSE OF bt_ok IN FRAME f_bac_01_fedex-rateio
DO:

    v_rec_fedex-rateio = ?.
    if  avail fedex-rateio
    then do:
        assign v_rec_fedex-rateio = recid(fedex-rateio).
    end /* if */.

END. /* ON CHOOSE OF bt_ok IN FRAME f_bac_01_fedex-rateio */

ON VALUE-CHANGED OF rs_bac_fedex-rateio IN FRAME f_bac_01_fedex-rateio
DO:

    /* inifim: */
    case input frame f_bac_01_fedex-rateio  rs_bac_fedex-rateio:
        when "Por Conta Cont†bil" /*l_por_conta_contabil*/ then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(20)":U
                   v_nom_attrib   = "Conta Cont†bil"
                   v_cod_initial  = string("":U)
                   v_cod_final    = string("ZZZZZZZZZZZZZZZZZZZZ":U).

    end /* case inifim */.
    run pi_open_bac_fedex-rateio /*pi_open_bac_fedex-rateio*/.
END. /* ON VALUE-CHANGED OF rs_bac_fedex-rateio IN FRAME f_bac_01_fedex-rateio */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bac_01_fedex-rateio
DO:
    RETURN "NOK" /*l_nok*/ .
END. /* ON END-ERROR OF FRAME f_bac_01_fedex-rateio */

ON ENTRY OF FRAME f_bac_01_fedex-rateio
DO:

    apply "value-changed" to rs_bac_fedex-rateio in frame f_bac_01_fedex-rateio.
END. /* ON ENTRY OF FRAME f_bac_01_fedex-rateio */

/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

DEF VAR v_log_alter AS LOG INITIAL NO.

IF v_cod_estab_usuar =  ""
   THEN ASSIGN v_cod_estab_usuar = v_cod_estab_usuar
               v_log_alter       = YES.

/* tratamento do titulo e vers∆o */
assign frame f_bac_01_fedex-rateio:title = frame f_bac_01_fedex-rateio:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

assign br_bac_fedex-rateio:num-locked-columns in frame f_bac_01_fedex-rateio = 0.

pause 0 before-hide.
view frame f_bac_01_fedex-rateio.

RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

assign v_log_repeat   = yes
       v_nom_program = program-name(2).
main_block:
repeat while v_log_repeat on error undo main_block, retry main_block transaction:
    enable rs_bac_fedex-rateio
           br_bac_fedex-rateio
           bt_add2
           bt_mod2
           bt_era3
           bt_ok
           bt_can
           with frame f_bac_01_fedex-rateio.

    assign v_log_repeat = no.

    apply "value-changed" to rs_bac_fedex-rateio in frame f_bac_01_fedex-rateio.

    if  not can-find( first fedex-rateio
                      where fedex-rateio.numero = p_numero) 
    then do:
         apply "choose" to bt_add2 in frame f_bac_01_fedex-rateio.
    end.

    wait-for go of frame f_bac_01_fedex-rateio.

    assign v_val_sdo_rat_tit_acr = 100.

    /* -------- Calcula Saldo a Ratear -----------*/
    calculo_valores:
    for each fedex-rateio no-lock 
        where fedex-rateio.numero = p_numero:
        assign v_val_sdo_rat_tit_acr = v_val_sdo_rat_tit_acr - fedex-rateio.perc_aprop_ctbl.
    end.

    display v_val_sdo_rat_tit_acr
            with frame f_bac_01_fedex-rateio.                                      

    IF v_val_sdo_rat_tit_acr < 0 
    THEN DO: 
         MESSAGE "Percentual superior a 100%"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         ASSIGN v_log_repeat = YES.
    END.


    IF  v_val_sdo_rat_tit_acr <> 0 
    THEN DO: 
         MESSAGE "Rateio diferente de 100%"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         ASSIGN v_log_repeat = YES.
    END.


end /* repeat main_block */.

IF v_log_alter = YES 
   THEN ASSIGN v_cod_estab_usuar =  "".

hide frame f_bac_01_fedex-rateio.

IF VALID-HANDLE( h_api_cta_ctbl) 
THEN 
    DELETE OBJECT h_api_cta_ctbl NO-ERROR.

/******************************* Main Code End ******************************/

PROCEDURE pi_open_bac_fedex-rateio:

    /************************* Variable Definition Begin ************************/

    def var v_val_iva_impl                   as decimal         no-undo. /*local*/
    def var v_val_iva_retid_impl             as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* case_block: */
    case rs_bac_fedex-rateio:screen-value in frame f_bac_01_fedex-rateio:
        when "Por Conta Cont†bil" /*l_por_conta_contabil*/ then
            open query qr_bac_fedex-rateio for
                each fedex-rateio EXCLUSIVE-LOCK 
                where fedex-rateio.numero       = p_numero 
                  and fedex-rateio.cod_cta_ctbl >= v_cod_initial 
                  and fedex-rateio.cod_cta_ctbl <= v_cod_final
                by fedex-rateio.cod_cta_ctbl.
    end.

    assign v_val_tot_rat         = 100
           v_val_sdo_rat_tit_acr = 100
           v_val_iva_retid_impl  = 0.

    /* -------- Calcula Saldo a Ratear -----------*/
    calculo_valores:
    for each b_fedex-rateio no-lock 
        where b_fedex-rateio.numero = p_numero:
        assign v_val_sdo_rat_tit_acr = v_val_sdo_rat_tit_acr - b_fedex-rateio.perc_aprop_ctbl.
    end /* for calculo_valores */.

    display v_val_sdo_rat_tit_acr
            v_val_tot_rat
            with frame f_bac_01_fedex-rateio.                                      

END PROCEDURE.

PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.
