/*****************************************************************************
** Programa..............: bas_seg_ccusto
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512.p
** Criado por............: Fabiano
** Criado em.............: 30/08/2007
*****************************************************************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
         resize               = yes
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.

/************************** Buffer Definition Begin *************************/

def buffer b_usu-cc-un-orc_enter
    for usu-cc-un-orc.

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_centro-custo
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_empresa
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_estab
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_usu-cc-un-orc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/************************ Rectangle Definition Begin ************************/

def rectangle rt_key
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.

/************************** Button Definition Begin *************************/

DEFINE BUTTON bt-exporta 
     IMAGE-UP FILE "Image\im-exp":U
     LABEL "Exportar Seguranáa" 
     TOOLTIP "Exporta Seguranáa"
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-importar 
     IMAGE-UP FILE "Image\im-carga":U
     LABEL "Importa Seguranáa" 
     TOOLTIP "Importa Seguranáa"
     SIZE 4 BY 1.25.

def button bt_seg
    label "Det"
    tooltip "Seguranáa"
    image-up file "image/im-segur.bmp"
    image-insensitive file "image/ii-segur"
    size 1 by 1.
def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 1 by 1.
def button bt_fir
    label "<<"
    tooltip "Primeira Ocorrància da Tabela"
    image-up file "image/im-fir"
    image-insensitive file "image/ii-fir"
    size 1 by 1.
def button bt_usuario
    label "Usu†rio"
    tooltip "Usu†rio"
    image-up file "image/im-joi"
    image-insensitive file "image/ii-joi.bmp"
    size 1 by 1.
def button bt_las
    label ">>"
    tooltip "Èltima Ocorrància da Tabela"
    image-up file "image/im-las"
    image-insensitive file "image/ii-las"
    size 1 by 1.
def button bt_ccusto
    label "CCusto"
    tooltip "CCusto"
    image file "image/im-aloca.bmp"
    size 1 by 1.
def button bt_seg_un
    label "UN"
    tooltip "UN"
    image file "image/im-estru.bmp"
    size 1 by 1.
def button bt_nex1
    label ">"
    tooltip "Pr¢xima Ocorrància da Tabela"
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
    size 1 by 1.
def button bt_pre1
    label "<"
    tooltip "Ocorrància Anterior da Tabela"
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
    size 1 by 1.
def button bt_pri
    label "Imp"
    tooltip "Imprime"
    image-up file "image/im-pri"
    image-insensitive file "image/ii-pri.bmp"
    size 1 by 1.
def button bt_sea1
    label "Psq"
    tooltip "Pesquisa"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.

/****************************** Function Button *****************************/
def button bt_ent_30681
    label "Loc"
    tooltip "Entra"
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
    size 4 by .88.
def button bt_zoo_30681
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_30682
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_30683
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_30684
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_30685
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

/************************** Frame Definition Begin **************************/

def frame f_bap_01_usu-cc-un-orc
    rt_key
         at row 02.50 col 01.00
    rt_mold
         at row 02.50 col 01.00
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    bt_fir
         at row 01.08 col 01.14 font ?
         help "Primeira Ocorrància da Tabela"
    bt_pre1
         at row 01.08 col 05.14 font ?
         help "Ocorrància Anterior da Tabela"
    bt_nex1
         at row 01.08 col 09.14 font ?
         help "Pr¢xima Ocorrància da Tabela"
    bt_las
         at row 01.08 col 13.14 font ?
         help "Èltima Ocorrància da Tabela"
    bt_pri
         at row 01.08 col 50.14 font ?
         help "Imprime"
    bt_usuario
         at row 01.08 col 20 font ?
         help "Usu†rio"
    bt_ccusto
         at row 01.08 col 25 font ?
         help "CCusto"
    bt_seg_un         
         at row 01.08 col 30 font ?
         help "Unidade"
    bt_sea1
         at row 01.08 col 40.14 font ?
         help "Pesquisa"
    bt_seg
         at row 01.08 col 45.14 font ?
         help "Seguranáa"
    bt-exporta
         at row 01.08 col 55.14 font ?
         help "Exporta Seguranáa"
    bt-importar
         at row 01.08 col 60.14 font ?
         help "Importa Seguranáa"
    bt_exi
         at row 01.08 col 78.57 font ?
         help "Sa°da"
    usu-cc-un-orc.cod-empresa
         at row 02.67 col 18.00 colon-aligned label "Empresa"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30683
         at row 02.67 col 24.14
    emscad.empresa.nom_razao_social
         at row 02.67 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    usu-cc-un-orc.cod-estab
         at row 03.67 col 18.00 colon-aligned label "Estabelecimento"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30684
         at row 03.67 col 24.14
    estabelecimento.nom_abrev
         at row 03.67 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    usu-cc-un-orc.cod-usuario
         at row 04.67 col 18.00 colon-aligned label "Usu†rio"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30682
         at row 04.67 col 33.14
    usuar_mestre.nom_usuar
         at row 04.67 col 37.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    usu-cc-un-orc.cod-unid-negoc
         at row 05.67 col 18.00 colon-aligned label "UN"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30685
         at row 05.67 col 29.14    
    unid_negoc.des_unid_negoc
         at row 05.67 col 37.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    usu-cc-un-orc.cod-ccusto
         at row 06.67 col 18.00 colon-aligned label "Centro Custo"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30681
         at row 06.67 col 29.14
    bt_ent_30681
         at row 06.67 col 33.14
    emscad.ccusto.des_tit_ctbl
         at row 06.67 col 37.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 82.00 by 08
         at row 01.50 col 03.00
         font 1 fgcolor ? bgcolor 8
         title "Manutená∆o Seguranáa Centro Custo - ES0512 - 1.00.00.001".
    /* adjust size of objects in this frame */
    assign bt_seg:width-chars     in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_seg:height-chars    in frame f_bap_01_usu-cc-un-orc = 01.13
           bt-exporta:width-chars  in frame f_bap_01_usu-cc-un-orc = 04.00
           bt-exporta:height-chars in frame f_bap_01_usu-cc-un-orc = 01.13
           bt-importar:width-chars  in frame f_bap_01_usu-cc-un-orc = 04.00
           bt-importar:height-chars in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_exi:width-chars      in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_exi:height-chars     in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_fir:width-chars      in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_fir:height-chars     in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_usuario:width-chars  in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_usuario:height-chars in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_las:width-chars      in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_las:height-chars     in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_ccusto:width-chars  in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_ccusto:height-chars in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_seg_un:width-chars  in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_seg_un:height-chars in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_nex1:width-chars     in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_nex1:height-chars    in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_pre1:width-chars     in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_pre1:height-chars    in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_pri:width-chars      in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_pri:height-chars     in frame f_bap_01_usu-cc-un-orc = 01.13
           bt_sea1:width-chars     in frame f_bap_01_usu-cc-un-orc = 04.00
           bt_sea1:height-chars    in frame f_bap_01_usu-cc-un-orc = 01.13
           rt_key:width-chars      in frame f_bap_01_usu-cc-un-orc = 69.72
           rt_key:height-chars     in frame f_bap_01_usu-cc-un-orc = 02.21
           rt_mold:width-chars     in frame f_bap_01_usu-cc-un-orc = 79.72
           rt_mold:height-chars    in frame f_bap_01_usu-cc-un-orc = 05.21
           rt_rgf:width-chars      in frame f_bap_01_usu-cc-un-orc = 81.72
           rt_rgf:height-chars     in frame f_bap_01_usu-cc-un-orc = 01.29.
    /* set private-data for the help system */
    assign bt_fir:private-data                               in frame f_bap_01_usu-cc-un-orc = "HLP=000004657":U
           bt_pre1:private-data                              in frame f_bap_01_usu-cc-un-orc = "HLP=000010790":U
           bt_nex1:private-data                              in frame f_bap_01_usu-cc-un-orc = "HLP=000010787":U
           bt_las:private-data                               in frame f_bap_01_usu-cc-un-orc = "HLP=000004658":U
           bt_seg:private-data                               in frame f_bap_01_usu-cc-un-orc = "HLP=000010830":U
           bt_sea1:private-data                              in frame f_bap_01_usu-cc-un-orc = "HLP=000010810":U
           bt_pri:private-data                               in frame f_bap_01_usu-cc-un-orc = "HLP=000010833":U
           bt_ccusto:private-data                            in frame f_bap_01_usu-cc-un-orc = "HLP=000021702":U
           bt_usuario:private-data                           in frame f_bap_01_usu-cc-un-orc = "HLP=000021703":U
           bt_exi:private-data                               in frame f_bap_01_usu-cc-un-orc = "HLP=000004665":U
           bt_zoo_30681:private-data                         in frame f_bap_01_usu-cc-un-orc = "HLP=000009431":U
           bt_ent_30681:private-data                         in frame f_bap_01_usu-cc-un-orc = "HLP=000009422":U
           bt_zoo_30685:PRIVATE-DATA                         in frame f_bap_01_usu-cc-un-orc = "HLP=000009425":U
           frame f_bap_01_usu-cc-un-orc:private-data                                         = "HLP=000013608".
    /* enable function buttons */
    assign bt_zoo_30681:sensitive in frame f_bap_01_usu-cc-un-orc = yes
           bt_ent_30681:sensitive in frame f_bap_01_usu-cc-un-orc = yes
           bt_zoo_30685:SENSITIVE in frame f_bap_01_usu-cc-un-orc = YES.

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt-exporta IN FRAME f_bap_01_usu-cc-un-orc
DO:

    RUN esp/es0514.w .

END.

ON CHOOSE OF bt-importar IN FRAME f_bap_01_usu-cc-un-orc
DO:

    ASSIGN wh_w_program:SENSITIVE = NO.
    RUN esp/es0512zg.p.
    ASSIGN wh_w_program:SENSITIVE = YES.

END.
        

ON CHOOSE OF bt_seg IN FRAME f_bap_01_usu-cc-un-orc
DO:

    run esp/es0512zd.p.

END.

ON CHOOSE OF bt_exi IN FRAME f_bap_01_usu-cc-un-orc
DO:

    if avail usu-cc-un-orc
       then assign v_rec_usu-cc-un-orc = recid(usu-cc-un-orc).
       else assign v_rec_usu-cc-un-orc = ?.

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.

END.

ON CHOOSE OF bt_fir IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find first usu-cc-un-orc no-lock no-error.
    if  avail usu-cc-un-orc
    then do:
        assign v_rec_table = recid(usu-cc-un-orc).
        run pi_disp_fields.
    end.
    else do:
         assign usu-cc-un-orc.cod-empresa:screen-value    in frame f_bap_01_usu-cc-un-orc = ""
                emscad.empresa.nom_razao_social:screen-value in frame f_bap_01_usu-cc-un-orc = ""
                usuar_mestre.nom_usuar:screen-value   in frame f_bap_01_usu-cc-un-orc = ""
                emscad.ccusto.des_tit_ctbl:screen-value      in frame f_bap_01_usu-cc-un-orc = ""
                usu-cc-un-orc.cod-usuario:screen-value    in frame f_bap_01_usu-cc-un-orc = ""
                usu-cc-un-orc.cod-ccusto:screen-value     in frame f_bap_01_usu-cc-un-orc = "".
         message "N∆o existem ocorràncias na tabela."
                view-as alert-box warning buttons ok.
         assign v_rec_table = ?.
    end.
    
END.

ON CHOOSE OF bt_las IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find last usu-cc-un-orc no-lock no-error.
    if  avail usu-cc-un-orc
    then do:
        assign v_rec_table = recid(usu-cc-un-orc).
        run pi_disp_fields.
    end.
    else do:
         assign usu-cc-un-orc.cod-empresa:screen-value    in frame f_bap_01_usu-cc-un-orc = ""
                emscad.empresa.nom_razao_social:screen-value in frame f_bap_01_usu-cc-un-orc = ""
                usuar_mestre.nom_usuar:screen-value   in frame f_bap_01_usu-cc-un-orc = ""
                emscad.ccusto.des_tit_ctbl:screen-value      in frame f_bap_01_usu-cc-un-orc = ""
                usu-cc-un-orc.cod-usuario:screen-value    in frame f_bap_01_usu-cc-un-orc = ""
                usu-cc-un-orc.cod-ccusto:screen-value     in frame f_bap_01_usu-cc-un-orc = "".
        message "N∆o existem ocorràncias na tabela."
               view-as alert-box warning buttons ok.
        assign v_rec_table = ?.
    end.
    
END.

ON CHOOSE OF bt_nex1 IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find next usu-cc-un-orc no-lock no-error.
    if  avail usu-cc-un-orc
    then do:
        assign v_rec_table = recid(usu-cc-un-orc).
        run pi_disp_fields.
    end.
    else do:
        apply "choose" to  bt_las in frame  f_bap_01_usu-cc-un-orc.
        if  avail usu-cc-un-orc
        then do:
            message "Èltima ocorrància da tabela."
                   view-as alert-box warning buttons ok.
        end.
    end.
    
END.

ON CHOOSE OF bt_pre1 IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find prev usu-cc-un-orc no-lock no-error.
    if  avail usu-cc-un-orc
    then do:
        assign v_rec_table = recid(usu-cc-un-orc).
        run pi_disp_fields.
    end.
    else do:
        apply "choose" to  bt_fir in frame  f_bap_01_usu-cc-un-orc.
        if  avail usu-cc-un-orc
        then do:
            message "Primeira ocorrància da tabela."
                   view-as alert-box warning buttons ok.
        end.
    end.
    
END.

ON LEAVE OF usu-cc-un-orc.cod-usuario IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-usuario no-error.
    display usuar_mestre.nom_usuar when avail usuar_mestre
            "" when not avail usuar_mestre @ usuar_mestre.nom_usuar
            with frame f_bap_01_usu-cc-un-orc.

END.

ON LEAVE OF usu-cc-un-orc.cod-empresa IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find emscad.empresa no-lock
         where emscad.empresa.cod_empresa = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-empresa no-error.
    display emscad.empresa.nom_razao_social when avail emscad.empresa
            "" when not avail emscad.empresa @ emscad.empresa.nom_razao_social
            with frame f_bap_01_usu-cc-un-orc.

END.

ON LEAVE OF usu-cc-un-orc.cod-estab IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find estabelecimento no-lock
         where estabelecimento.cod_estab = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-estab no-error.
    display estabelecimento.nom_abrev when avail estabelecimento
            "" when not avail estabelecimento @ estabelecimento.nom_abrev
            with frame f_bap_01_usu-cc-un-orc.

END.

ON LEAVE OF usu-cc-un-orc.cod-ccusto IN FRAME f_bap_01_usu-cc-un-orc
DO:

    find emscad.ccusto no-lock 
         where emscad.ccusto.cod_empresa      = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-empresa
           and emscad.ccusto.cod_plano_ccusto = 'Padrao'
           and emscad.ccusto.cod_ccusto       = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-ccusto no-error.

    display emscad.ccusto.des_tit_ctbl when avail emscad.ccusto
            "" when not avail emscad.ccusto @ emscad.ccusto.des_tit_ctbl
            with frame f_bap_01_usu-cc-un-orc.

END.

ON LEAVE OF usu-cc-un-orc.cod-unid-negoc IN FRAME f_bap_01_usu-cc-un-orc DO:

    find unid_negoc no-lock
        where unid_negoc.cod_unid_negoc = INPUT frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-unid-negoc
        no-error.
    
    display unid_negoc.des_unid_negoc when avail unid_negoc
            "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
            with frame f_bap_01_usu-cc-un-orc.
    
END.


ON CHOOSE OF bt_usuario IN FRAME f_bap_01_usu-cc-un-orc
DO:

    run esp/es0512zb.p.

END.

ON CHOOSE OF bt_ccusto IN FRAME f_bap_01_usu-cc-un-orc
DO:

    run esp/es0512zc.p.

END.

ON CHOOSE OF bt_seg_un IN FRAME f_bap_01_usu-cc-un-orc
DO:

    run esp/es0512ze.p.

END.

ON CHOOSE OF bt_pri IN FRAME f_bap_01_usu-cc-un-orc
DO:

    run esp/es0512za.p.

END.

ON CHOOSE OF bt_sea1 IN FRAME f_bap_01_usu-cc-un-orc
DO:

    assign v_rec_usu-cc-un-orc = v_rec_table.
    run esp/es0512kc.p.
    if  v_rec_usu-cc-un-orc <> ?
    then do:
        assign v_rec_table = v_rec_usu-cc-un-orc.
        run pi_disp_fields.
    end.
    else do:
        assign v_rec_usu-cc-un-orc = v_rec_table.
    end.

END.

/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_ent_30681 IN FRAME f_bap_01_usu-cc-un-orc
OR ENTER OF usu-cc-un-orc.cod-ccusto IN FRAME f_bap_01_usu-cc-un-orc DO:

    find b_usu-cc-un-orc_enter no-lock
         where b_usu-cc-un-orc_enter.cod-empresa    = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-empresa
           and b_usu-cc-un-orc_enter.cod-estab      = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-estab
           and b_usu-cc-un-orc_enter.cod-usuario    = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-usuario
           and b_usu-cc-un-orc_enter.cod-ccusto     = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-ccusto
           AND b_usu-cc-un-orc_enter.cod-unid-negoc = input frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-unid-negoc no-error.

    if  avail b_usu-cc-un-orc_enter then do:
        assign v_rec_table = recid(b_usu-cc-un-orc_enter).
        run pi_disp_fields.
    end.
    else do:
        message substitute("&1 inexistente." ,"Usu†rio CCusto Inexistente")
               view-as alert-box warning buttons ok.
        find usu-cc-un-orc where recid(usu-cc-un-orc) = v_rec_table no-lock no-error.
    end.
    
end.

ON  CHOOSE OF bt_zoo_30681 IN FRAME f_bap_01_usu-cc-un-orc
OR F5 OF usu-cc-un-orc.cod-ccusto IN FRAME f_bap_01_usu-cc-un-orc DO:

    run esp/es0512kb.p.
    if  v_rec_centro-custo <> ? then do:

        find emscad.ccusto where recid(emscad.ccusto) = v_rec_centro-custo no-lock no-error.

        assign usu-cc-un-orc.cod-ccusto:screen-value in frame f_bap_01_usu-cc-un-orc = string(emscad.ccusto.cod_ccusto).
    
        display emscad.ccusto.des_tit_ctbl when avail emscad.ccusto
                "" when not avail emscad.ccusto @ emscad.ccusto.des_tit_ctbl
                with frame f_bap_01_usu-cc-un-orc.

    end.

    apply "entry" to usu-cc-un-orc.cod-ccusto in frame f_bap_01_usu-cc-un-orc.

end.

ON  CHOOSE OF bt_zoo_30685 IN FRAME f_bap_01_usu-cc-un-orc
OR F5 OF usu-cc-un-orc.cod-unid-negoc IN FRAME f_bap_01_usu-cc-un-orc DO:

    run esp/es0512ke.p.
    
    if  v_rec_unid_negoc <> ? then do:

        find unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.

        assign usu-cc-un-orc.cod-unid-negoc:screen-value in frame f_bap_01_usu-cc-un-orc = string(unid_negoc.cod_unid_negoc, '999').
    
    end.

    apply "entry" to usu-cc-un-orc.cod-unid-negoc in frame f_bap_01_usu-cc-un-orc.

end.


ON  CHOOSE OF bt_zoo_30682 IN FRAME f_bap_01_usu-cc-un-orc
OR F5 OF usu-cc-un-orc.cod-usuario IN FRAME f_bap_01_usu-cc-un-orc DO:

    run esp/es0512ka.p.
    if  v_rec_usuar_mestre <> ?
    then do:
        find usuar_mestre where recid(usuar_mestre) = v_rec_usuar_mestre no-lock no-error.
        assign usu-cc-un-orc.cod-usuario:screen-value in frame f_bap_01_usu-cc-un-orc = string(usuar_mestre.cod_usuario).

        display usuar_mestre.nom_usuar
                with frame f_bap_01_usu-cc-un-orc.

    end.
    apply "entry" to usu-cc-un-orc.cod-usuario in frame f_bap_01_usu-cc-un-orc.
    
end.

ON  CHOOSE OF bt_zoo_30683 IN FRAME f_bap_01_usu-cc-un-orc
OR F5 OF usu-cc-un-orc.cod-empresa IN FRAME f_bap_01_usu-cc-un-orc DO:

    run esp/es0512za.p.
    if  v_rec_empresa <> ?
    then do:
        find emscad.empresa where recid(emscad.empresa) = v_rec_empresa no-lock no-error.
        assign usu-cc-un-orc.cod-empresa:screen-value in frame f_bap_01_usu-cc-un-orc = string(emscad.empresa.cod_empresa).

        display emscad.empresa.nom_razao_social
                with frame f_bap_01_usu-cc-un-orc.

    end.
    apply "entry" to usu-cc-un-orc.cod-empresa in frame f_bap_01_usu-cc-un-orc.
    
end.

ON  CHOOSE OF bt_zoo_30684 IN FRAME f_bap_01_usu-cc-un-orc
OR F5 OF usu-cc-un-orc.cod-estab IN FRAME f_bap_01_usu-cc-un-orc DO:

    run esp/es0512zf.p.
    if  v_rec_estab <> ?
    then do:
        find estabelecimento where recid(estabelecimento) = v_rec_estab no-lock no-error.
        assign usu-cc-un-orc.cod-estab:screen-value in frame f_bap_01_usu-cc-un-orc = string(estabelecimento.cod_estab).

        display estabelecimento.nom_abrev
                with frame f_bap_01_usu-cc-un-orc.

    end.
    apply "entry" to usu-cc-un-orc.cod-estab in frame f_bap_01_usu-cc-un-orc.
    
end.

/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bap_01_usu-cc-un-orc
DO:

    if avail usu-cc-un-orc
       then assign v_rec_usu-cc-un-orc = recid(usu-cc-un-orc).
       else assign v_rec_usu-cc-un-orc = ?.

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.

END.

ON ENTRY OF wh_w_program
DO:
    if  valid-handle (wh_w_program)
    then do:
        assign current-window = wh_w_program.
    end.
END.

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bap_01_usu-cc-un-orc.

END.

/****************************** Main Code Begin *****************************/

if not can-find(first mgesp.rel-grup-user
                 where mgesp.rel-grup-user.cd-grup = 'ES0396'
                   and mgesp.rel-grup-user.usuario = v_cod_usuar_corren)
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'ES0512')).
    return.
end.

assign 
       wh_w_program:title                  = frame f_bap_01_usu-cc-un-orc:title
       frame f_bap_01_usu-cc-un-orc:title = ?
       wh_w_program:width-chars            = frame f_bap_01_usu-cc-un-orc:width-chars
       wh_w_program:height-chars           = frame f_bap_01_usu-cc-un-orc:height-chars - 0.85
       frame f_bap_01_usu-cc-un-orc:row   = 1
       frame f_bap_01_usu-cc-un-orc:col   = 1
       wh_w_program:col                    = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row                    = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window                      = wh_w_program.


run pi_frame_settings (Input frame f_bap_01_usu-cc-un-orc:handle).

pause 0 before-hide.

view frame f_bap_01_usu-cc-un-orc.


enable bt_fir
       bt_pre1
       bt_nex1
       bt_las
       bt_exi
       bt_ccusto
       bt_seg_un
       bt_usuario
       bt_seg
       bt-exporta
       bt-importar
       bt_sea1
       usu-cc-un-orc.cod-empresa
       usu-cc-un-orc.cod-estab
       usu-cc-un-orc.cod-usuario
       usu-cc-un-orc.cod-ccusto
       with frame f_bap_01_usu-cc-un-orc.

hide bt_pri in frame f_bap_01_usu-cc-un-orc.

if  v_rec_usu-cc-un-orc <> ?
then do:
    find usu-cc-un-orc where recid(usu-cc-un-orc) = v_rec_usu-cc-un-orc no-lock no-error.
    if  not avail usu-cc-un-orc
    then do:
        apply "choose" to bt_fir in frame f_bap_01_usu-cc-un-orc.
    end.
    else do:
            assign v_rec_table = v_rec_usu-cc-un-orc.
            run pi_disp_fields.

    end.
end.
else do:
    apply "choose" to bt_fir in frame f_bap_01_usu-cc-un-orc.
end.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_log_answer = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bap_01_usu-cc-un-orc.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_disp_fields
** Descricao.............: pi_disp_fields
*****************************************************************************/
PROCEDURE pi_disp_fields:

    find usu-cc-un-orc where recid(usu-cc-un-orc) = v_rec_table no-lock no-error.

    if available usu-cc-un-orc then do:

        find emscad.empresa no-lock
             where emscad.empresa.cod_empresa = usu-cc-un-orc.cod-empresa no-error.
        find estabelecimento no-lock
             where estabelecimento.cod_estab = usu-cc-un-orc.cod-estab no-error.
        find usuar_mestre no-lock
             where usuar_mestre.cod_usuario = usu-cc-un-orc.cod-usuario no-error.
        find emscad.ccusto no-lock
             where emscad.ccusto.cod_empresa      = usu-cc-un-orc.cod-empresa
               and emscad.ccusto.cod_plano_ccusto = 'Padrao'
               and emscad.ccusto.cod_ccusto       = usu-cc-un-orc.cod-ccusto no-error.

        enable usu-cc-un-orc.cod-empresa
               usu-cc-un-orc.cod-estab
               usu-cc-un-orc.cod-usuario
               usu-cc-un-orc.cod-ccusto
               usu-cc-un-orc.cod-unid-negoc
               with frame f_bap_01_usu-cc-un-orc.
        enable bt_zoo_30683
               bt_zoo_30681
               bt_ent_30681
               bt_zoo_30682
               bt_zoo_30684
               with frame f_bap_01_usu-cc-un-orc.

        display usu-cc-un-orc.cod-empresa
                usu-cc-un-orc.cod-estab
                usu-cc-un-orc.cod-usuario
                usu-cc-un-orc.cod-unid-negoc
                usu-cc-un-orc.cod-ccusto               
                with frame f_bap_01_usu-cc-un-orc.

        find unid_negoc no-lock
            where unid_negoc.cod_unid_negoc = INPUT frame f_bap_01_usu-cc-un-orc usu-cc-un-orc.cod-unid-negoc
            no-error.
    
        display unid_negoc.des_unid_negoc when avail unid_negoc
                "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
                with frame f_bap_01_usu-cc-un-orc.

        display emscad.empresa.nom_razao_social when avail emscad.empresa
                "" when not avail emscad.empresa @ emscad.empresa.nom_razao_social
                estabelecimento.nom_abrev when avail estabelecimento
                "" when not avail estabelecimento @ estabelecimento.nom_abrev
                usuar_mestre.nom_usuar when avail usuar_mestre
                "" when not avail usuar_mestre @ usuar_mestre.nom_usuar
                emscad.ccusto.des_tit_ctbl when avail emscad.ccusto
                "" when not avail emscad.ccusto @ emscad.ccusto.des_tit_ctbl
                with frame f_bap_01_usu-cc-un-orc.

    end.

END PROCEDURE. /* pi_disp_fields */
/*****************************************************************************
** Procedure Interna.....: pi_frame_settings
** Descricao.............: pi_frame_settings
*****************************************************************************/
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
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
END PROCEDURE.  /* pi_messages */
/**********************  End of bas_usu-cc-un-orc *********************/
