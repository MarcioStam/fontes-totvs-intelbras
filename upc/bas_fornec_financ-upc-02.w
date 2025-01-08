/* bas_fornec_financ-upc-02.w */

DEF BUFFER fornecedor FOR emscad.fornecedor.

def buffer b_int_espec_fornec_mod for int_espec_fornec.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

def var v_log_exist  as logical format "Sim/NÆo" initial yes no-undo.
def var v_log_method as logical format "Sim/NÆo" initial yes no-undo.
def var v_log_repeat as logical format "Sim/NÆo" initial yes view-as toggle-box no-undo.
def var v_num_row_a  as integer format ">>>,>>9":U no-undo.

def new global shared var v_rec_espec_docto_financ
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_fornec_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_int_espec_fornec
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def query qr_espec_docto_financ
    for espec_docto_financ,
        espec_docto
    scrolling.
def query qr_int_espec_fornec
    for int_espec_fornec,
        espec_docto
    scrolling.

def browse br_espec_docto_financ query qr_espec_docto_financ display 
    espec_docto_financ.cod_espec_docto width-chars 07.14 column-label "Esp‚cie"
    espec_docto.des_espec_docto        width-chars 24.00 column-label "Descri‡Æo"
    with separators multiple size 37.00 by 10.00 font 1 bgcolor 15 title "Esp‚cies APB".

def browse br_int_espec_fornec query qr_int_espec_fornec display 
    int_espec_fornec.cod_espec_docto width-chars 07.14 column-label "Esp‚cie"
    espec_docto.des_espec_docto      width-chars 24.00 column-label "Descri‡Æo"
    with separators single size 37.00 by 10.00 font 1 bgcolor 15 title "Libera‡Æo Autom tica Pagamento".

def rectangle rt_001 
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_key
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_exclui
    label "<"
    tooltip "Retira Linha"
    size 1 by 1.
def button bt_ajuda
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_insere
    label ">"
    tooltip "Insere Linha"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_salva
    label "Salva"
    tooltip "Salva"
    size 1 by 1
    auto-go.

def frame f_int_espec_fornec
    rt_mold                      at row 02.54 col 02.00
    rt_cxcf                      at row 13.17 col 02.00 bgcolor 7 
    rt_key                       at row 01.21 col 02.00
    fornec_financ.cdn_fornecedor at row 01.38 col 21.00 colon-aligned label "Fornecedor" view-as FILL-IN size-chars 12.14 by .88 fgcolor ? bgcolor 15 font 2
    fornecedor.nom_pessoa        at row 01.38 col 36.00 no-label view-as fill-in size-chars 41.14 by .88 fgcolor ? bgcolor 15 font 2
    br_espec_docto_financ        at row 02.75 col 03.00
    br_int_espec_fornec          at row 02.75 col 46.00
    bt_insere                    at row 05.50 col 41.00 font ? help "Insere Linha"
    bt_exclui                    at row 08.00 col 41.00 font ? help "Retira Linha"
    bt_ok                        at row 13.38 col 03.00 font ? help "OK"
    bt_salva                     at row 13.38 col 14.00 font ? help "Salva"
    bt_can                       at row 13.38 col 25.00 font ? help "Cancela"
    bt_ajuda                     at row 13.38 col 73.00 font ? help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 85.00 by 15.00 default-button bt_ok view-as dialog-box font 1 fgcolor ? bgcolor 8
         title "Forma‡Æo Esp‚cies Libera‡Æo Pagamento".
    
assign bt_can:width-chars     in frame f_int_espec_fornec = 10.00
       bt_can:height-chars    in frame f_int_espec_fornec = 01.00
       bt_exclui:width-chars  in frame f_int_espec_fornec = 04.00
       bt_exclui:height-chars in frame f_int_espec_fornec = 01.13
       bt_ajuda:width-chars   in frame f_int_espec_fornec = 10.00
       bt_ajuda:height-chars  in frame f_int_espec_fornec = 01.00
       bt_insere:width-chars  in frame f_int_espec_fornec = 04.00
       bt_insere:height-chars in frame f_int_espec_fornec = 01.13
       bt_ok:width-chars      in frame f_int_espec_fornec = 10.00
       bt_ok:height-chars     in frame f_int_espec_fornec = 01.00
       bt_salva:width-chars   in frame f_int_espec_fornec = 10.00
       bt_salva:height-chars  in frame f_int_espec_fornec = 01.00
       rt_cxcf:width-chars    in frame f_int_espec_fornec = 82.00
       rt_cxcf:height-chars   in frame f_int_espec_fornec = 01.42
       rt_key:width-chars     in frame f_int_espec_fornec = 82.00
       rt_key:height-chars    in frame f_int_espec_fornec = 01.21
       rt_mold:width-chars    in frame f_int_espec_fornec = 82.00
       rt_mold:height-chars   in frame f_int_espec_fornec = 10.55.

assign fornec_financ.cdn_fornecedor:private-data in frame f_int_espec_fornec = "HLP=000026122":U
       fornecedor.nom_pessoa:private-data        in frame f_int_espec_fornec = "HLP=000012617":U
       br_espec_docto_financ:private-data        in frame f_int_espec_fornec = "HLP=000019037":U
       br_int_espec_fornec:private-data          in frame f_int_espec_fornec = "HLP=000019037":U
       bt_insere:private-data                    in frame f_int_espec_fornec = "HLP=000009353":U
       bt_exclui:private-data                    in frame f_int_espec_fornec = "HLP=000009347":U
       bt_ok:private-data                        in frame f_int_espec_fornec = "HLP=000010721":U
       bt_salva:private-data                     in frame f_int_espec_fornec = "HLP=000011048":U
       bt_can:private-data                       in frame f_int_espec_fornec = "HLP=000011050":U
       bt_ajuda:private-data                     in frame f_int_espec_fornec = "HLP=000011326":U
       frame f_int_espec_fornec:private-data                                 = "HLP=000019037".

ON CTRL-CURSOR-RIGHT OF br_espec_docto_financ IN FRAME f_int_espec_fornec DO:
    if  bt_insere:sensitive in frame f_int_espec_fornec then do:
        apply "choose" to bt_insere in frame f_int_espec_fornec.
    end.
END.

ON ROW-DISPLAY OF br_int_espec_fornec IN FRAME f_int_espec_fornec DO:
    if  avail int_espec_fornec then do:
    end.
END.

ON VALUE-CHANGED OF br_int_espec_fornec IN FRAME f_int_espec_fornec DO:
    if  avail int_espec_fornec then do:
    end.

    if  avail fornecedor  then do:
    end.
END.

ON CHOOSE OF bt_exclui IN FRAME f_int_espec_fornec DO:
    exclui:
    do v_num_row_a = 1 to browse br_int_espec_fornec:num-selected-rows:
        assign v_log_method = browse br_int_espec_fornec:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(int_espec_fornec).
        
        find int_espec_fornec 
            where recid(int_espec_fornec) = v_rec_table exclusive-lock no-error.
        
        IF  AVAIL int_espec_fornec THEN
            assign int_espec_fornec.log_ativo   = NO
                   int_espec_fornec.ult_alterac = int_espec_fornec.ult_alterac + " ** Exc Usuar " + v_cod_usuar_corren + " Dt " + string(TODAY,"99/99/9999").
    end.
    
    assign v_log_exist = yes.
    
    run pi_open_int_espec_fornec.
END.

ON CHOOSE OF bt_ajuda IN FRAME f_int_espec_fornec DO:
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle).
END.

ON CHOOSE OF bt_insere IN FRAME f_int_espec_fornec DO:
    table_src_a:
    do v_num_row_a = 1 to browse br_espec_docto_financ:num-selected-rows:
        assign v_log_method = browse br_espec_docto_financ:fetch-selected-row(v_num_row_a).

        FIND FIRST int_espec_fornec EXCLUSIVE-LOCK
             where int_espec_fornec.cod_empresa     = fornec_financ.cod_empresa
             AND   int_espec_fornec.cdn_fornec      = fornec_financ.cdn_fornecedor
             and   int_espec_fornec.cod_espec_docto = espec_docto_financ.cod_espec_docto NO-ERROR.
        
        if  not avail int_espec_fornec then do:
            create int_espec_fornec.
            assign int_espec_fornec.cod_empresa     = fornec_financ.cod_empresa
                   int_espec_fornec.cdn_fornec      = fornec_financ.cdn_fornecedor
                   int_espec_fornec.cod_espec_docto = espec_docto_financ.cod_espec_docto
                   int_espec_fornec.log_ativo       = YES
                   int_espec_fornec.ult_alterac     = "Ins Usuar " + v_cod_usuar_corren + " Dt " + string(TODAY,"99/99/9999")
                   v_log_method                     = browse br_espec_docto_financ:deselect-selected-row(v_num_row_a)
                   v_num_row_a                      = v_num_row_a - 1.
        end.
        ELSE DO:
            assign int_espec_fornec.log_ativo   = YES
                   int_espec_fornec.ult_alterac = int_espec_fornec.ult_alterac + " ** Ins Usuar " + v_cod_usuar_corren + " Dt " + string(TODAY,"99/99/9999").
        END.
    end.
    
    assign v_log_exist = yes.
    
    run pi_open_int_espec_fornec.
END.

ON CHOOSE OF bt_ok IN FRAME f_int_espec_fornec DO:
    assign v_log_repeat = no.
END.

ON CHOOSE OF bt_salva IN FRAME f_int_espec_fornec DO:
    assign v_log_repeat = yes.
END.

ON HELP OF FRAME f_int_espec_fornec ANYWHERE DO:
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle).
END.

ON WINDOW-CLOSE OF FRAME f_int_espec_fornec DO:
    apply "end-error" to self.
END.

/* main */
def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

assign frame f_int_espec_fornec:title = frame f_int_espec_fornec:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.009":U)
                            + chr(41).

pause 0 before-hide.
view frame f_int_espec_fornec.

assign v_rec_table  = v_rec_int_espec_fornec
       v_log_exist  = no
       v_log_repeat = yes.

find fornec_financ 
    where recid(fornec_financ) = v_rec_fornec_financ no-lock no-error.

if  not avail fornec_financ then do:
    find first fornec_financ no-lock no-error.
end.

if  not avail fornec_financ then do:
    message "NÆo existem ocorrˆncias na tabela." view-as alert-box warning buttons ok.
    return.
end.
else do:
    assign v_rec_fornec_financ = recid(fornec_financ).
end.

main_block:
repeat while v_log_repeat = yes on endkey undo main_block, leave main_block
                                            on error undo main_block, leave main_block transaction:
    find first fornecedor no-lock
         where fornecedor.cdn_fornecedor = fornec_financ.cdn_fornecedor
         and   fornecedor.cod_empresa    = fornec_financ.cod_empresa no-error.

    enable br_int_espec_fornec
           br_espec_docto_financ
           bt_ok
           bt_salva
           bt_can
           bt_ajuda
           bt_insere
           bt_exclui
           with frame f_int_espec_fornec.

    display fornec_financ.cdn_fornecedor
            fornecedor.nom_pessoa
            with frame f_int_espec_fornec.

    run pi_open_int_espec_fornec.

    wait-for go of frame f_int_espec_fornec.

    assign v_log_exist = yes.
end.

hide frame f_int_espec_fornec.

PROCEDURE pi_open_int_espec_fornec:
    open query qr_espec_docto_financ for
        each espec_docto_financ,
        each espec_docto
            where espec_docto.cod_espec_docto     = espec_docto_financ.cod_espec_docto
            AND   espec_docto.ind_tip_espec_docto = "Normal".

    open query qr_int_espec_fornec for
        each int_espec_fornec no-lock
        where int_espec_fornec.cod_empresa = fornec_financ.cod_empresa
        AND   int_espec_fornec.cdn_fornec  = fornec_financ.cdn_fornecedor
        AND   int_espec_fornec.log_ativo   = YES,
        each espec_docto
            where espec_docto.cod_espec_docto = int_espec_fornec.cod_espec_docto.

    apply "value-changed" to br_int_espec_fornec in frame f_int_espec_fornec.
END PROCEDURE.
