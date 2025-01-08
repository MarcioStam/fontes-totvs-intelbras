/*****************************************************************************
** Descricao.............: Relaá∆o movimentos e apropriaá‰es
** Versao................:  5.00.00.000
** Nome Externo..........: esp/acr/esacr025.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 05/08/2009
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

/************************** Window Definition Begin *************************/

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

/*************************** Window Definition End **************************/

/************************* Variable Definition Begin ************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.
DEF VAR v_nom_filename 
    AS CHARACTER 
    FORMAT "x(80)":U
    VIEW-AS EDITOR MAX-CHARS 250 NO-WORD-WRAP 
    SIZE 40 BY 1
    BGCOLOR 15 FONT 2
    LABEL "Nome Arquivo"
    NO-UNDO.
DEF VAR v_nom_name
    AS CHARACTER 
    FORMAT "x(20)":U
    EXTENT 10
    NO-UNDO.
DEF VAR v_des_filespec
    AS CHARACTER 
    FORMAT "x(10)":U
    EXTENT 10
    NO-UNDO.
DEF VAR v_nom_title
    AS CHARACTER 
    FORMAT "x(40)":U
    NO-UNDO.
DEF VAR v_log_answer
    AS LOGICAL 
    FORMAT "Sim/N∆o"
    INITIAL YES 
    VIEW-AS TOGGLE-BOX 
    NO-UNDO.
DEF VAR v_cod_estab_ini AS CHAR FORMAT "x(03)"       INITIAL ""    LABEL "Estabelecimento" VIEW-AS FILL-IN SIZE 4 BY .88 NO-UNDO.
DEF VAR v_cod_estab_fim AS CHAR FORMAT "x(03)"       INITIAL "ZZZ" LABEL "atÇ" VIEW-AS FILL-IN SIZE 4 BY .88 NO-UNDO.
DEF VAR v_dat_ini       AS DATE FORMAT "99/99/9999"  INITIAL "01/01/0001" LABEL "Data" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_dat_fim       AS DATE FORMAT "99/99/9999"  INITIAL "12/31/9999" LABEL "atÇ" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_cdn_cliente   AS INT  FORMAT ">>>,>>>,>>9" INITIAL 0 LABEL "Cliente" VIEW-AS FILL-IN SIZE 12 BY .88 NO-UNDO.
DEF VAR v_log_matriz    AS LOG  LABEL "Lista Matriz (Grupo) ?" INITIAL YES VIEW-AS TOGGLE-BOX NO-UNDO.
DEF VAR v_dat_aux       AS DATE NO-UNDO.
DEF VAR v_cod_arq       AS CHAR.
DEF VAR v_cod_filename_initial AS CHAR NO-UNDO.
DEF VAR v_cod_filename_final   AS CHAR NO-UNDO.

/************************** Variable Definition End *************************/

/*************************** Temp-Table Definition Begin **************************/

DEF TEMP-TABLE tt_cliente_matriz NO-UNDO
    FIELD ttv_cdn_cliente AS INT
    INDEX cliente_matriz  IS PRIMARY UNIQUE 
          ttv_cdn_cliente ASCENDING.

/**************************** Temp-Table Definition End ***************************/

/*************************** Buffer Definition Begin **************************/

DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
DEF BUFFER b_cliente      FOR emscad.cliente.

/**************************** Buffer Definition End ***************************/

/*************************** Menu Definition Begin **************************/

def sub-menu  mi_table
    menu-item mi_exi               label "Sa°da".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Tabela".

/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 1 by 1.
def button bt_rnl1
    label "Exc"
    tooltip "Executar"
    image-up file "image/im-rnl"
    image-insensitive file "image/ii-rnl"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    v_cod_estab_ini  
         at row 03.20 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cod_estab_fim 
         at row 03.20 col 38.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_dat_ini 
         at row 04.20 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_dat_fim
         at row 04.20 col 38.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cdn_cliente
         at row 05.20 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_log_matriz
         at row 06.20 col 18.00 COLON-ALIGNED
    v_cod_arq
         at row 07.20 col 18.00 colon-aligned label "Nome Arquivo"
         help "Arquivo com os dados para importaá∆o"
         view-as editor max-chars 250 no-word-wrap
         size 50 by 1
         bgcolor 15 font 2
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 76.34 font ?
         help "Sa°da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 09.29
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Geraá∆o Movimentos/Apropriaá∆o (ESACR025) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 78.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 06.50
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_cod_arq:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           v_cod_arq:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data                             = "HLP=000023693".
    /* enable function buttons */

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    ASSIGN v_cod_estab_ini
           v_cod_estab_fim
           v_dat_ini      
           v_dat_fim      
           v_cdn_cliente  
           v_log_matriz   
           v_cod_arq.

    IF v_cod_estab_ini > v_cod_estab_fim 
    THEN DO:
         MESSAGE "Estabelecimento Inicial maior que Estabelecimento Final !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.
    IF v_dat_ini > v_dat_fim 
    THEN DO:
         MESSAGE "Data Inicial maior que Data Final !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.
           
    ASSIGN v_cod_arq:SCREEN-VALUE = REPLACE(v_cod_arq:SCREEN-VALUE, '~\', '/').

    IF NUM-ENTRIES(v_cod_arq, "/") = 0
    THEN DO:
         MESSAGE "Diret¢rio n∆o informado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_filename_initial = ENTRY(NUM-ENTRIES(v_cod_arq:SCREEN-VALUE, '/'), v_cod_arq:SCREEN-VALUE, '/')
           v_cod_filename_final   = SUBSTRING(v_cod_arq:SCREEN-VALUE, 1,
                                              LENGTH(v_cod_arq:SCREEN-VALUE) - LENGTH(v_cod_filename_initial) - 1)
           FILE-INFO:FILE-NAME    = v_cod_filename_final.
    IF FILE-INFO:FILE-TYPE = ?
    THEN DO:
         MESSAGE "Diret¢rio n∆o localizado: " v_cod_filename_final
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    FIND emscad.cliente NO-LOCK
        WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
          AND emscad.cliente.cdn_cliente = v_cdn_cliente NO-ERROR.
    IF AVAIL emscad.cliente 
    THEN DO:
         IF v_log_matriz = YES 
         THEN DO:
              FIND pessoa_jurid NO-LOCK
                 WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
              IF AVAIL pessoa_jurid 
              THEN DO:
                   FOR EACH b_pessoa_jurid
                       WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz:
                       FIND b_cliente NO-LOCK 
                          WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                            AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
                       IF AVAIL b_cliente 
                       THEN DO:
                            CREATE tt_cliente_matriz.
                            ASSIGN tt_cliente_matriz.ttv_cdn_cliente = b_cliente.cdn_cliente.
                       END.
                   END.
              END.
         END.
         ELSE DO:
              CREATE tt_cliente_matriz.
              ASSIGN tt_cliente_matriz.ttv_cdn_cliente = emscad.cliente.cdn_cliente.
         END.
    END.
    ELSE DO:
         MESSAGE "Cliente n∆o localizado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.

    PUT UNFORMATTED "estab;espec;ser;tit;parc;cliente;nom_abrev;val_origin;dat_transacao;trans_abrev;trans;val_movto;tip_aprop;natur_lancto;cta_ctbl;des_cta;ccusto;des_ccusto;unid_negoc;val_aprop" SKIP.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empres = v_cod_empres_usuar
          AND estabelecimento.cod_estab >= v_cod_estab_ini
          AND estabelecimento.cod_estab <= v_cod_estab_fim:

        REPEAT v_dat_aux = v_dat_ini TO v_dat_fim:

            FOR EACH movto_tit_acr NO-LOCK
                WHERE movto_tit_acr.cod_estab             = estabelecimento.cod_estab
                  AND movto_tit_acr.dat_transacao         = v_dat_aux
                  AND movto_tit_acr.log_ctbz_aprop_ctbl   = YES 
                  AND movto_tit_acr.log_aprop_ctbl_ctbzda = YES:

                  FIND tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.

                  IF NOT CAN-FIND(tt_cliente_matriz
                                  WHERE tt_cliente_matriz.ttv_cdn_cliente = tit_acr.cdn_cliente) 
                     THEN NEXT.

                  FOR EACH aprop_ctbl_acr OF movto_tit_acr NO-LOCK:

                      FIND cta_ctbl NO-LOCK
                          WHERE cta_ctbl.cod_plano_cta = 'padrao'
                            AND cta_ctbl.cod_cta_ctbl = aprop_ctbl_acr.cod_cta_ctbl.
                      FIND emscad.ccusto NO-LOCK
                          WHERE emscad.ccusto.cod_plano_ccusto = 'padrao'
                            AND emscad.ccusto.cod_ccusto = aprop_ctbl_acr.cod_ccusto NO-ERROR.

                      PUT UNFORMATTED tit_acr.cod_estab                    ";"
                                      tit_acr.cod_espec                    ";"
                                      tit_acr.cod_ser                      ";"
                                      tit_acr.cod_tit_acr                  ";"
                                      tit_acr.cod_parcela                  ";"
                                      tit_acr.cdn_cliente                  ";"
                                      tit_acr.nom_abrev                    ";"
                                      tit_acr.val_origin_tit_acr           ";"
                                      movto_tit_acr.dat_transacao          ";"
                                      movto_tit_acr.ind_trans_acr_abrev    ";"
                                      movto_tit_acr.ind_trans_acr          ";"
                                      movto_tit_acr.val_movto_tit_acr      ";"
                                      aprop_ctbl_acr.ind_tip_aprop_ctbl    ";"
                                      aprop_ctbl_acr.ind_natur_lancto_ctbl ";"
                                      aprop_ctbl_acr.cod_cta_ctbl          ";"
                                      cta_ctbl.des_tit                     ";"
                                      aprop_ctbl_acr.cod_ccusto            ";"
                                      (IF AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "") ";"
                                      aprop_ctbl_acr.cod_unid_negoc        ";"
                                      aprop_ctbl_acr.val_aprop_ctbl SKIP.

                  END.

            END.

        END.

    END.

    OUTPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("") THEN.

    MESSAGE "Processamento conclu°do !" SKIP(1) "Verificar arquivo: " v_cod_arq
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

/*************************** Window Trigger Begin ***************************/

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_histor_fornec_import_ems.
END.

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign wh_w_program:title         = frame f_bas_10_histor_fornec_import_ems:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_10_histor_fornec_import_ems:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_histor_fornec_import_ems:width-chars
       wh_w_program:height-chars  = frame f_bas_10_histor_fornec_import_ems:height-chars - 0.85
       frame f_bas_10_histor_fornec_import_ems:row         = 1
       frame f_bas_10_histor_fornec_import_ems:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_10_histor_fornec_import_ems:handle).

pause 0 before-hide.

view frame f_bas_10_histor_fornec_import_ems.

enable bt_rnl1
       bt_exi
       v_cod_estab_ini
       v_cod_estab_fim
       v_dat_ini      
       v_dat_fim      
       v_cdn_cliente  
       v_log_matriz   
       v_cod_arq      
       with frame f_bas_10_histor_fornec_import_ems.

ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "esacr025.txt".

DISP v_cod_estab_ini
     v_cod_estab_fim
     v_dat_ini      
     v_dat_fim      
     v_cdn_cliente  
     v_log_matriz   
     v_cod_arq WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_cod_arq:read-only in frame f_bas_10_histor_fornec_import_ems = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_histor_fornec_import_ems.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END PROCEDURE. /* pi_close_program */
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
