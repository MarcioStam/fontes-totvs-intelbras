/*****************************************************************************
** Descricao.............: Relaá∆o movimentos HSBC
** Versao................:  1.00.00.001
** Nome Externo..........: esp/acr/esacr031.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 06/09/2010
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

def button bt_get_file
    label "Get"
    tooltip "Encontra Arquivo"
    image-up file "image/im-sea2"
    image-insensitive file "image/ii-sea2"
    size 4 by 1.1.

/************************ Temp-Table Definition Begin ***********************/

/*
CNPJ;RAZAO SOCIAL;ENDERECO;BAIRRO;CEP;MUNICIPIO;UNIDADE FEDERACAO;TELEFONE;CONTATO;CLIENTE DESDE
*/

DEF TEMP-TABLE tt_cadastro 
  FIELD tta_cgc           LIKE emitente.cgc 
  FIELD tta_razao_social  LIKE emitente.nome-emit
  FIELD tta_endereco      LIKE emitente.endereco
  FIELD tta_bairro        LIKE emitente.bairro         
  FIELD tta_cep           LIKE emitente.zip-code
  FIELD tta_cidade        LIKE emitente.cidade        
  FIELD tta_estado        LIKE emitente.estado
  FIELD tta_telefone      LIKE emitente.telefone
  FIELD tta_contato       LIKE emitente.contato
  FIELD tta_cliente_desde LIKE emitente.data-implant  
  INDEX tt_cliente IS PRIMARY UNIQUE tta_cgc.

DEF TEMP-TABLE tt_cliente
  FIELD tta_cdn_cliente  LIKE emscad.cliente.cdn_cliente
  INDEX tt_cliente IS PRIMARY UNIQUE tta_cdn_cliente.


/************************ Temp-Table Definition End *************************/

/************************* Variable Definition Begin ************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)":U
    LABEL "Usu†rio Corrente"
    COLUMN-LABEL "Usu†rio Corrente"
    NO-UNDO.

DEF VAR v_cod_arq              AS CHAR NO-UNDO.
DEF VAR v_cod_arq2             AS CHAR NO-UNDO.
DEF VAR v_arq_cli              AS CHAR LABEL "Lista Cliente" NO-UNDO.
DEF VAR v_cod_filename_initial AS CHAR NO-UNDO.
DEF VAR v_cod_filename_final   AS CHAR NO-UNDO.
DEF VAR v_cod_id_feder_aux     AS CHAR NO-UNDO.
DEF VAR v_dat_ocorrencia       AS DATE NO-UNDO.

DEF VAR v_ind_tipo       AS CHAR FORMAT "x(10)":U     INITIAL "Envio":U    LABEL "Tipo Ocorrància":U VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Envio":U,"Envio":U,"Retorno":U,"Retorno":U BGCOLOR 8.
DEF VAR v_dat_emis_ini   AS DATE FORMAT "99/99/9999"  INITIAL 01/01/2008   LABEL "Data Emiss∆o"      VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_dat_emis_fim   AS DATE FORMAT "99/99/9999"  INITIAL TODAY        LABEL "atÇ"               VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_cod_gr_cob_ini AS INT  FORMAT ">9"          INITIAL 0            LABEL "Grupo Cobranáa"    VIEW-AS FILL-IN SIZE 04 BY .88 NO-UNDO.
DEF VAR v_cod_gr_cob_fim AS INT  FORMAT ">9"          INITIAL 99           LABEL "atÇ"               VIEW-AS FILL-IN SIZE 04 BY .88 NO-UNDO.
DEFINE VARIABLE v_dat_liquidac AS DATE        NO-UNDO.

DEF VAR v_log_conf     AS LOG  INITIAL NO LABEL "Log Conferància?"    VIEW-AS TOGGLE-BOX SIZE 15 BY .83 NO-UNDO.
DEF VAR v_log_cnpj     AS LOG  INITIAL NO LABEL "Importar pelo CNPJ?" VIEW-AS TOGGLE-BOX SIZE 17 BY .83 NO-UNDO.

/************************** Variable Definition End *************************/

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
    image-up file "image/toolbar/im-exi"
    IMAGE-DOWN file "image/toolbar/im-exi"
    image-insensitive file "image/toolbar/ii-exi"
    size 1 by 1.
def button bt_rnl1
    label "Exc"
    tooltip "Executar"
    image-up file "image/toolbar/im-rnl"
    IMAGE-DOWN file "image/toolbar/im-rnl"
    image-insensitive file "image/toolbar/ii-rnl"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 18 
    rt_mold
         at row 02.50 col 02.00
    v_ind_tipo
         at row 03 col 13.00 COLON-ALIGNED BGCOLOR 17
         help "Tipo Ocorrància"
    v_dat_emis_ini 
         at row 04 col 13.00 COLON-ALIGNED BGCOLOR 15 FONT 2
         help "Data de emiss∆o inicial"
    v_dat_emis_fim
         at row 04 col 27.50 COLON-ALIGNED BGCOLOR 15 FONT 2
         help "Data de emiss∆o final"
    v_arq_cli 
         at row 05 col 13.00 COLON-ALIGNED view-as editor max-chars 250 no-word-wrap
         size 45 by .88 BGCOLOR 15 FONT 2
         help "Lista Cliente"
    bt_get_file
         at row 04.87 col 60.14
         help "Pesquisar arquivo Lista Cliente"
    v_log_cnpj
         at row 05 col 65.00
         help "Importar cliente pelo CNPJ?"
    v_cod_gr_cob_ini
         at row 06 col 13.00 COLON-ALIGNED BGCOLOR 15 FONT 2
         help "Grupo Cobranáa inicial"
    v_cod_gr_cob_fim
         at row 06 col 20.50 COLON-ALIGNED BGCOLOR 15 FONT 2
         help "Grupo Cobranáa final"
    v_log_conf
         at row 06 col 44.00 COLON-ALIGNED
         help "Log Conferància?"
    v_cod_arq
         at row 07.00 col 13.00 colon-aligned label "Nome Arquivo"
         help "Arquivo com os dados para importaá∆o"
         view-as editor max-chars 250 no-word-wrap
         size 55 by .88
         bgcolor 15 font 2
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 78.34 font ?
         help "Sa°da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 82.72 by 09
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 17
         title "Relaá∆o Movimentos HSBC (ESACR031) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 06
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 82.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_cod_arq:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           v_cod_arq:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data                             = "HLP=000023693".
    /* enable function buttons */

    ASSIGN bt_exi:FLAT-BUTTON  IN FRAME f_bas_10_histor_fornec_import_ems = YES
           bt_rnl1:FLAT-BUTTON IN FRAME f_bas_10_histor_fornec_import_ems = YES.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON  CHOOSE OF bt_get_file IN FRAME f_bas_10_histor_fornec_import_ems
OR F5 OF v_arq_cli IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_get_file                   as character       no-undo. /*local*/
    def var v_log_pressed                    as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

     system-dialog get-file v_cod_get_file
         title "Procurando..." /*l_procurando...*/ 
         filters '*.csv' '*.csv'
         must-exist
         update v_log_pressed.

    if  v_log_pressed = yes
    then do:
        assign v_arq_cli:screen-value in frame f_bas_10_histor_fornec_import_ems = v_cod_get_file.
        apply "entry" to v_arq_cli in frame f_bas_10_histor_fornec_import_ems.
    end /* if */.

end. /* ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_10_histor_fornec_import_ems */

ON  LEAVE OF v_arq_cli IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    IF v_arq_cli:screen-value in frame f_bas_10_histor_fornec_import_ems <> ""
    THEN DO:
         ASSIGN v_cod_gr_cob_ini:screen-value in frame f_bas_10_histor_fornec_import_ems = "0"
                v_cod_gr_cob_fim:screen-value in frame f_bas_10_histor_fornec_import_ems = "99".
         DISABLE v_cod_gr_cob_ini
                 v_cod_gr_cob_fim WITH FRAME f_bas_10_histor_fornec_import_ems.
    END.
    ELSE DO:
         ENABLE v_cod_gr_cob_ini
                v_cod_gr_cob_fim WITH FRAME f_bas_10_histor_fornec_import_ems.
    END.

end. /* ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_10_histor_fornec_import_ems */

ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    ASSIGN v_ind_tipo
           v_dat_emis_ini      
           v_dat_emis_fim
           v_arq_cli
           v_log_cnpj
           v_cod_gr_cob_ini
           v_cod_gr_cob_fim
           v_log_conf
           v_cod_arq.

    IF v_dat_emis_ini > v_dat_emis_fim 
    THEN DO:
         MESSAGE "Data Inicial maior que Data Final !"
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF v_ind_tipo = "Retorno":U AND
       v_arq_cli  = "":U        THEN DO:
        MESSAGE "Para o Tipo Ocorrància ~"Retorno~", Ç obrigat¢rio a informaá∆o do campo ~"Lista Cliente~""
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN NO-APPLY.
    END.
           
    IF v_cod_gr_cob_ini > v_cod_gr_cob_fim 
    THEN DO:
         MESSAGE "Grupo Cobranáa Inicial maior que Grupo Cobranáa Final !"
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_arq:SCREEN-VALUE = REPLACE(v_cod_arq:SCREEN-VALUE, '~\', '/').

    IF NUM-ENTRIES(v_cod_arq, "/") = 0
    THEN DO:
         MESSAGE "Diret¢rio n∆o informado !"
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_filename_initial = ENTRY(NUM-ENTRIES(v_cod_arq:SCREEN-VALUE, '/'), v_cod_arq:SCREEN-VALUE, '/')
           v_cod_filename_final   = SUBSTRING(v_cod_arq:SCREEN-VALUE, 1,
                                              LENGTH(v_cod_arq:SCREEN-VALUE) - LENGTH(v_cod_filename_initial) - 1)
           FILE-INFO:FILE-NAME    = v_cod_filename_final.

    IF FILE-INFO:FILE-TYPE = ?
    THEN DO:
         MESSAGE "Diret¢rio n∆o localizado: " v_cod_filename_final
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    /* ** Importar CSV ***/
    DEFINE VARIABLE v_des_reg_import AS CHARACTER   NO-UNDO.
    FOR EACH tt_cliente:
        DELETE tt_cliente.
    END.

    ASSIGN v_dat_ocorrencia = TODAY.

    IF v_arq_cli <> "" 
    THEN DO:
         INPUT FROM VALUE(v_arq_cli).

         import_block:
         REPEAT TRANSACTION:

             IMPORT UNFORMATTED v_des_reg_import.
     
             IF TRIM(ENTRY(1, v_des_reg_import, ";")) = ""
                THEN NEXT.

             IF v_log_cnpj THEN DO:
                 ASSIGN v_cod_id_feder_aux = ENTRY(1, v_des_reg_import, ";")
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "#":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "*":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "(":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, ")":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "-":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "_":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "=":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "+":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "[":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "]":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "~{":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "}":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "<":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, ">":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, ",":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, ".":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, ":":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "/":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "\":U, "":U)
                        v_cod_id_feder_aux = REPLACE(v_cod_id_feder_aux, "|":U, "":U)
                        v_cod_id_feder_aux = TRIM(v_cod_id_feder_aux).

                 FIND FIRST emscad.cliente
                     WHERE emscad.cliente.cod_id_feder = v_cod_id_feder_aux NO-LOCK NO-ERROR.

                 IF AVAILABLE emscad.cliente THEN DO:
                     CREATE tt_cliente.
                     ASSIGN tt_cliente.tta_cdn_cliente = emscad.cliente.cdn_cliente.
                 END.
             END.
             ELSE DO:
                 CREATE tt_cliente.
                 ASSIGN tt_cliente.tta_cdn_cliente = INT(TRIM(ENTRY(1, v_des_reg_import, ";"))).
             END.
         END.

         INPUT CLOSE.
    END.

    FOR EACH tt_cadastro:
        DELETE tt_cadastro.
    END.

    OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.

    IF v_log_conf 
       THEN PUT UNFORMATTED "CNPJ;Emissao;Vencimento;Baixa;Vlr.Titulo;Cliente Desde;Estab;Espec;Ser;Titulo;Parc" SKIP.
       ELSE PUT UNFORMATTED "CNPJ;Emissao;Vencimento;Baixa;Vlr.Titulo;Cliente Desde" SKIP.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        IF CAN-FIND(FIRST tt_cliente) 
        THEN DO:
             FOR EACH tt_cliente NO-LOCK:
                 FIND emscad.cliente NO-LOCK
                     WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                       AND emscad.cliente.cdn_cliente = tt_cliente.tta_cdn_cliente NO-ERROR.

                 IF AVAIL emscad.cliente
                     THEN RUN pi_gera_arquivo.
             END.
        END.
        ELSE DO:
             FOR EACH emscad.cliente NO-LOCK
                 WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar,
                 EACH int-emitente USE-INDEX codigo NO-LOCK
                 WHERE int-emitente.cod-emitente = emscad.cliente.cdn_cliente
                   AND int-emitente.cod-gr-cob  >= v_cod_gr_cob_ini
                   AND int-emitente.cod-gr-cob  <= v_cod_gr_cob_fim:

                 RUN pi_gera_arquivo.

             END.
         END.

    END.

    OUTPUT CLOSE.

    ASSIGN v_cod_arq2 = REPLACE(v_cod_arq, ".", "C.").

    OUTPUT TO VALUE(v_cod_arq2) CONVERT TARGET 'iso8859-1'.

    PUT UNFORMATTED "CNPJ;RAZAO SOCIAL;ENDERECO;BAIRRO;CEP;MUNICIPIO;UNIDADE FEDERACAO;TELEFONE;CONTATO;CLIENTE DESDE" SKIP.

    FOR EACH tt_cadastro:
        PUT UNFORMATTED STRING(tt_cadastro.tta_cgc, "99999999999999") ";"
                        tt_cadastro.tta_razao_social     ";"
                        tt_cadastro.tta_endereco         ";"
                        tt_cadastro.tta_bairro           ";"
                        STRING(tt_cadastro.tta_cep, "999999999") ";"
                        tt_cadastro.tta_cidade           ";"
                        tt_cadastro.tta_estado           ";"
                        tt_cadastro.tta_telefone         ";"
                        TRIM(tt_cadastro.tta_contato[1]) ";"
                        STRING(tt_cadastro.tta_cliente_desde, "99/99/9999") SKIP.
            
    END.

    OUTPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("") THEN.

    MESSAGE "Processamento conclu°do !" SKIP(1) "Verificar arquivos: " SKIP v_cod_arq SKIP v_cod_arq2
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
                                  + trim(" 1.00.00.001":U)
                                  + chr(41)
       frame f_bas_10_histor_fornec_import_ems:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_histor_fornec_import_ems:width-chars
       wh_w_program:height-chars  = frame f_bas_10_histor_fornec_import_ems:height-chars - 0.85
       frame f_bas_10_histor_fornec_import_ems:row         = 1
       frame f_bas_10_histor_fornec_import_ems:col         = 1
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_10_histor_fornec_import_ems:handle).

pause 0 before-hide.

view frame f_bas_10_histor_fornec_import_ems.

enable bt_rnl1
       bt_exi
       v_ind_tipo
       v_dat_emis_ini      
       v_dat_emis_fim
       v_arq_cli
       bt_get_file
       v_log_cnpj
       v_cod_gr_cob_ini
       v_cod_gr_cob_fim
       v_log_conf
       v_cod_arq      
       with frame f_bas_10_histor_fornec_import_ems.

ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "esacr031.txt".

DISP v_ind_tipo
     v_dat_emis_ini      
     v_dat_emis_fim      
     v_arq_cli
     bt_get_file
     v_log_cnpj
     v_cod_gr_cob_ini
     v_cod_gr_cob_fim
     v_log_conf
     v_cod_arq WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_cod_arq:read-only in frame f_bas_10_histor_fornec_import_ems = no
           v_arq_cli:read-only in frame f_bas_10_histor_fornec_import_ems = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_histor_fornec_import_ems.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_gera_arquivo:

    FOR EACH tit_acr NO-LOCK
        WHERE tit_acr.cod_estab   = estabelecimento.cod_estab
          AND tit_acr.cdn_cliente = emscad.cliente.cdn_cliente
          AND tit_acr.dat_emis   >= v_dat_emis_ini
          AND tit_acr.dat_emis   <= v_dat_emis_fim
          AND (tit_acr.ind_tip_espec_docto = 'Normal' OR tit_acr.ind_tip_espec_docto = 'Vendor')
          AND tit_acr.log_tit_acr_estordo = NO:
        FIND movto_tit_acr OF tit_acr NO-LOCK
            WHERE (movto_tit_acr.ind_trans_acr_abrev = "IMPL" OR 
                   movto_tit_acr.ind_trans_acr_abrev = "REM")NO-ERROR.
        IF NOT AVAIL movto_tit_acr 
           THEN NEXT.

        ASSIGN v_dat_liquidac = tit_acr.dat_ult_liquidac.

        IF  tit_acr.log_sdo_tit_acr  = NO
        AND tit_acr.dat_ult_liquidac = 12/31/9999 
            THEN ASSIGN v_dat_liquidac = tit_acr.dat_vencto_tit_acr.


        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = emscad.cliente.cdn_cliente NO-ERROR.
        IF NOT AVAIL emitente 
           THEN NEXT.

        FIND tt_cadastro NO-LOCK
            WHERE tt_cadastro.tta_cgc = emitente.cgc NO-ERROR.
        IF NOT AVAIL tt_cadastro 
        THEN DO:
             FIND FIRST cont-emit OF emitente NO-LOCK NO-ERROR.
             CREATE tt_cadastro.
             ASSIGN tt_cadastro.tta_cgc           = emitente.cgc           
                    tt_cadastro.tta_razao_social  = emitente.nome-emit     
                    tt_cadastro.tta_endereco      = emitente.endereco      
                    tt_cadastro.tta_bairro        = emitente.bairro        
                    tt_cadastro.tta_cep           = emitente.zip-code      
                    tt_cadastro.tta_cidade        = emitente.cidade        
                    tt_cadastro.tta_estado        = emitente.estado        
                    tt_cadastro.tta_telefone[1]   = emitente.telefone[1]
                    tt_cadastro.tta_contato[1]    = IF AVAIL cont-emit AND emitente.contato[1] = "" THEN cont-emit.nome ELSE emitente.contato[1]
                    tt_cadastro.tta_cliente_desde = emscad.cliente.dat_impl. 
        END.

        IF v_log_conf 
           THEN PUT UNFORMATTED STRING(emscad.cliente.cod_id_feder, "99999999999999") ";" 
                                STRING(tit_acr.dat_emis, "99/99/9999") ";" 
                                STRING(tit_acr.dat_vencto_orig, "99/99/9999") ";" 
                                IF v_dat_liquidac = 12/31/9999 THEN "          " ELSE STRING(v_dat_liquidac, "99/99/9999") ";" 
                                STRING(tit_acr.val_origin, ">>,>>>,>>>,>>9.99") ";" 
                                STRING(emscad.cliente.dat_impl, "99/99/9999")
                                ";" tit_acr.cod_estab ";" tit_acr.cod_espec ";" tit_acr.cod_ser ";" tit_acr.cod_tit_acr ";" tit_acr.cod_parcela SKIP.
           ELSE PUT UNFORMATTED STRING(emscad.cliente.cod_id_feder, "99999999999999") ";" 
                                STRING(tit_acr.dat_emis, "99/99/9999") ";" 
                                STRING(tit_acr.dat_vencto_orig, "99/99/9999") ";" 
                                IF v_dat_liquidac = 12/31/9999 THEN "          " ELSE STRING(v_dat_liquidac, "99/99/9999") ";" 
                                STRING(tit_acr.val_origin, ">>,>>>,>>>,>>9.99") ";" 
                                STRING(emscad.cliente.dat_impl, "99/99/9999") SKIP.

        FIND FIRST int-emitente-hsbc-limite
            WHERE int-emitente-hsbc-limite.cod-emitente   = emscad.cliente.cdn_cliente
              AND int-emitente-hsbc-limite.dat-ocorrencia = v_dat_ocorrencia
              AND int-emitente-hsbc-limite.ind-tipo       = v_ind_tipo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE int-emitente-hsbc-limite THEN DO:
            CREATE int-emitente-hsbc-limite.
            ASSIGN int-emitente-hsbc-limite.cod-emitente   = emscad.cliente.cdn_cliente
                   int-emitente-hsbc-limite.dat-ocorrencia = v_dat_ocorrencia
                   int-emitente-hsbc-limite.ind-tipo       = v_ind_tipo
                   int-emitente-hsbc-limite.val-limite     = ?
                   int-emitente-hsbc-limite.cod-usuario    = v_cod_usuar_corren.
        END.
    END.


END PROCEDURE.

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
