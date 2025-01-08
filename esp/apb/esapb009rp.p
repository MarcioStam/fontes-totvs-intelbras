/*****************************************************************************
**     Programa.........: esp/apb/esapb009rp.p
**     Descricao .......: Relat¢rio de Pagamentos por Transa‡Æo
**     Versao...........: 1.00.001
**     Autor............: Giovane Alves
**     Criado...........: 21/02/2008
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/

def temp-table tt-fluxo
    field cod_estab       like movto_tit_ap.cod_estab
    field dat_transacao   like movto_tit_ap.dat_transacao
    field cdn_fornecedor  like movto_tit_ap.cdn_fornecedor
    field nome-emit       like emitente.nome-emit
    field cod_espec_docto like movto_tit_ap.cod_espec_docto
    FIELD serie           LIKE tit_ap.cod_ser_docto
    field ind_trans_ap_abrev like movto_tit_ap.ind_trans_ap_abrev
    field ind_trans_ap    like movto_tit_ap.ind_trans_ap
    field cod_tit_ap      like tit_ap.cod_tit_ap
    field cod_parcela     like tit_ap.cod_parcela
    field dat_emis_docto  like tit_ap.dat_emis_docto
    field val_movto_ap    like movto_tit_ap.val_movto_ap
    field cod_tip_fluxo_financ like val_movto_ap.cod_tip_fluxo_financ
    FIELD num_id_tit_ap   LIKE tit_ap.num_id_tit_ap
    FIELD cod_portador    LIKE bord_ap.cod_portador
    FIELD nom_portador    LIKE emscad.portador.nom_pessoa
    FIELD cod_forma_pagto LIKE item_bord_ap.cod_forma_pagto
    FIELD des_forma_pagto LIKE forma_pagto.des_forma_pagto
    FIELD id_feder        LIKE emitente.cgc
    FIELD val_liq         LIKE movto_tit_ap.val_movto_ap
    index data is primary dat_transacao cod_estab ind_trans_ap cdn_fornecedor.

DEFINE VARIABLE c_cod_estab_selec AS CHARACTER FORMAT "x(2000)" 
     LABEL "Estabelecimento" 
     VIEW-AS EDITOR MAX-CHARS 2000
     SIZE 30 BY .88 NO-UNDO.

DEF VAR v_fim_cod_tip_fluxo_financ AS CHAR                                                                                                    NO-UNDO.
DEF VAR v_fim_data                 AS DATE                                                                                                    NO-UNDO.
DEF VAR v_ini_cod_tip_fluxo_financ AS CHAR                                                                                                    NO-UNDO.
DEF VAR v_ini_data                 AS DATE                                                                                                    NO-UNDO.
DEF VAR v_log_impto_vincul_refer   AS LOG FORMAT "Sim/NÆo" INIT YES                                                                           NO-UNDO.
DEF VAR v_val_tot_impto            AS DEC FORMAT "->>>,>>>,>>9.99":U    DECIMALS 2 LABEL "Total a Ratear" COLUMN-LABEL "Valor Total a Ratear" NO-UNDO.
DEF VAR v_val_liquidad_bord        AS DEC FORMAT "->>,>>>,>>>,>>9.99":U DECIMALS 2 LABEL "Total L¡quido"                                      NO-UNDO.

{esinc/es0000.i}

DEF NEW GLOBAL SHARED VAR l-implanta              AS LOG INIT NO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario           AS CHAR FORMAT "x(12)"  NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-num-ped-exec-rpw      AS INT                  NO-UNDO.   
DEF NEW GLOBAL SHARED VAR i-pais-impto-usuario    AS INT  FORMAT ">>9"    NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-rpc                   AS LOG                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-registro-atual        AS ROWID                NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-arquivo-log           AS CHAR FORMAT "x(60)"  NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-num-ped               AS INT                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_prog_segur_estab      AS HANDLE               NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_num_tip_aces_usuar    AS INT                  NO-UNDO.     
DEF NEW GLOBAL SHARED VAR v_num_ped_exec_corren   AS INT  FORMAT ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_dwb_user          AS CHAR FORMAT "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR c-dir-spool-servid-exec AS CHAR                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-num-ped-exec-rpw      AS INT                  NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec                             AS ROWID                                   NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " "              NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " "              NO-UNDO.
DEF VAR v_des_tip_fluxo                         LIKE tip_fluxo_financ.des_tip_fluxo_financ NO-UNDO.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/

DEF VAR v_cod_empresa        LIKE EmsUni.Empresa.Cod_Empresa          NO-UNDO.
DEF VAR i                    AS INT                                   NO-UNDO.
DEF VAR v_cod_dwb_file       LIKE dwb_set_list_param.Cod_Dwb_File     NO-UNDO.
DEF VAR v_cod_dwb_output     LIKE dwb_set_list_param.Cod_Dwb_Output   NO-UNDO.
DEF VAR c-impressora         LIKE ped_exec_param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR c-layout             LIKE ped_exec_param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR h-hacr155            AS HANDLE                                NO-UNDO.
DEF VAR v-cod-destino-impres AS CHAR                                  NO-UNDO.
DEF VAR v-num-reg-lidos      AS INT                                   NO-UNDO.
DEF VAR v-num-point          AS INT                                   NO-UNDO.
DEF VAR v-num-set            AS INT                                   NO-UNDO.
DEF VAR v-cod-arquivo        AS CHAR                                  NO-UNDO.
DEF VAR v-num-tip-reg        AS INT  FORMAT "999"                     NO-UNDO.
DEF VAR c-empresa            AS CHAR FORMAT "x(40)"                   NO-UNDO.
DEF VAR c-titulo-relat       AS CHAR FORMAT "x(50)"                   NO-UNDO.
DEF VAR c-sistema            AS CHAR FORMAT "x(25)"                   NO-UNDO.
DEF VAR C-Rodape             AS CHAR                                  NO-UNDO.
DEF VAR c-programa           AS CHAR FORMAT "x(08)"                   NO-UNDO.
DEF VAR c-versao             AS CHAR FORMAT "x(04)"                   NO-UNDO.
DEF VAR c-revisao            AS CHAR FORMAT "999"                     NO-UNDO.
DEF VAR v_num_pag            AS INT INIT 1                            NO-UNDO.
DEF VAR ch_linha             AS CHAR FORMAT "x(215)"                  NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_ped_exec_Style     FOR ped_exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines   AS INT  INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns AS INT  INIT 255.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom  AS INT  INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page    AS INT.
DEF NEW SHARED VAR v_rpt_stream_1_name    AS CHAR INIT "Relat¢rio D¡vidas Cliente".

/*****  Defini‡Æo das Forms de ImpressÆo  ******/

FIND FIRST EmsUni.Empresa NO-LOCK 
     WHERE Empresa.Cod_Empresa = V_Cod_Empres_Usuar NO-ERROR.

IF  AVAIL Empresa THEN 
    ASSIGN c-empresa = Empresa.Nom_Razao_Social.
ELSE 
    ASSIGN c-empresa = "".

IF  v_cod_dwb_user = "" THEN 
    ASSIGN v_cod_dwb_user = V_Cod_Usuar_Corren.

IF  v_num_ped_exec_corren > 0 THEN DO.
    
    FIND ped_exec_param NO-LOCK
         WHERE ped_exec_param.num_ped_exec = v_num_ped_exec_corren NO-ERROR.
    
    IF  AVAIL ped_exec_param THEN DO:
    
        FIND FIRST ped_exec NO-LOCK
            WHERE ped_exec.num_ped_exec = ped_exec_param.num_ped_exec NO-ERROR.
      
        IF  AVAIL ped_exec THEN DO:

            FIND FIRST dwb_set_list_param NO-LOCK
                WHERE dwb_set_list_param.Cod_Dwb_Program = "esapb009"
                AND   dwb_set_list_param.Cod_Dwb_User    = ped_exec.cod_usuario NO-ERROR.
    
            IF  OPSYS = "UNIX" THEN
                ASSIGN v_cod_dwb_file = "/mnt/spool/" + ped_exec.cod_usuario + "/" + ped_exec_param.Cod_Dwb_File.
            ELSE
                ASSIGN v_cod_dwb_file = "\\erpapp\spool\" + ped_exec.cod_usuario + "\" + ped_exec_param.Cod_Dwb_File.

            ASSIGN v_cod_dwb_output  = ped_exec_param.Cod_Dwb_Output
                   c-impressora      = ped_exec_param.Nom_Dwb_Printer
                   c-layout          = ped_exec_param.Cod_Dwb_Print_Layout.
            
            ASSIGN v_ini_cod_tip_fluxo_financ       =      ENTRY(02,dwb_set_list_param.cod_dwb_parameters,CHR(10))
                   v_fim_cod_tip_fluxo_financ       =      ENTRY(03,dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
            ASSIGN v_ini_data                       = date(ENTRY(04,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
                   v_fim_data                       = date(ENTRY(05,dwb_set_list_param.cod_dwb_parameters,CHR(10))) NO-ERROR.
            ASSIGN c_cod_estab_selec                =      ENTRY(06,dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
        END.
    END. /* End do IF AVAIL ped_exec_param */
END. /* end do IF v_num_ped_exec_corren > 0 */
ELSE DO:
    FIND FIRST dwb_set_list_param NO-LOCK
        WHERE dwb_set_list_param.Cod_Dwb_Program = "esapb009"
        AND   dwb_set_list_param.Cod_Dwb_User    = v_cod_dwb_user NO-ERROR.
  
    IF  AVAIL dwb_set_list_param THEN DO:
        ASSIGN v_cod_dwb_file   = dwb_set_list_param.Cod_Dwb_File             
               v_cod_dwb_output = dwb_set_list_param.Cod_Dwb_Output           
               c-impressora     = dwb_set_list_param.nom_Dwb_Printer          
               c-layout         = dwb_set_list_param.Cod_Dwb_Print_layout.
        ASSIGN v_ini_cod_tip_fluxo_financ       =      ENTRY(02,dwb_set_list_param.cod_dwb_parameters,CHR(10))
               v_fim_cod_tip_fluxo_financ       =      ENTRY(03,dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
        ASSIGN v_ini_data                       = date(ENTRY(04,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               v_fim_data                       = date(ENTRY(05,dwb_set_list_param.cod_dwb_parameters,CHR(10))) NO-ERROR.
        ASSIGN c_cod_estab_selec                =      ENTRY(06,dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
    END. /* End do IF AVAIL ped_exec_param */
END. /* End do ELSE Do - IF v_num_ped_exec_corren > 0 */

DO:   /* seta a saida da impressao */
  CASE v_cod_dwb_output:
      WHEN "Terminal" /*l_Terminal*/  THEN DO:
          ASSIGN v_cod_dwb_file   = session:temp-directory + "esapb009.csv".
          OUTPUT STREAM Stream_1 TO VALUE(v_cod_dwb_file).
      END.
      WHEN "Arquivo" /*l_File*/  THEN DO:
          OUTPUT STREAM Stream_1 TO VALUE(v_cod_dwb_file).
      END.
  END.
END.

ASSIGN c-programa          = "esapb009"
       c-versao            = "1.00"
       c-revisao           = "001"
       c-titulo-relat      = "Relat¢rio de Pagamentos por Transa‡Æo"
       v_rpt_stream_1_name = c-titulo-relat
       c-sistema           = "ESP"
       ch_linha            = FILL("-",132).

RUN PiMontaRelat.
RUN PiImprimeRelat.

OUTPUT STREAM Stream_1 CLOSE.

IF v_cod_dwb_output = "Terminal" 
THEN RUN pi_show_report_2 (INPUT v_cod_dwb_file).

RETURN "ok".
/* fim do programa */

PROCEDURE PiMontaRelat:
END PROCEDURE.

PROCEDURE PiImprimeRelat:
    def var v_tot_data as dec format "->>>,>>>,>>9.99" no-undo.
    def var v_tot_trans as dec format "->>>,>>>,>>9.99" no-undo.
    
    run pi-calcula in this-procedure.
    
    PUT STREAM Stream_1
        "Estab;Fornec;RazÆo Social;Especie;Serie;Transacao;Trans Abrev;Cod Titulo;Parcela;Dt Emissao;Vl Movto;Vl Liq Bord;Cod Tipo Fluxo;Dt Transacao;Desc Tipo Fluxo;Portador;Nome Portador;Forma Pagto;Desc Forma Pagto;CNPJ/CPF" SKIP.

    for each tt-fluxo
       where tt-fluxo.cod_tip_fluxo_financ >= v_ini_cod_tip_fluxo_financ
         and tt-fluxo.cod_tip_fluxo_financ <= v_fim_cod_tip_fluxo_financ
       break by tt-fluxo.dat_transacao
             by tt-fluxo.cod_tip_fluxo_financ
             BY tt-fluxo.ind_trans_ap
             BY tt-fluxo.cod_estab
             by tt-fluxo.nome-emit:
        
        FIND FIRST tip_fluxo_financ OF tt-fluxo NO-LOCK NO-ERROR.

        IF  AVAIL tip_fluxo_financ THEN
            ASSIGN v_des_tip_fluxo = tip_fluxo_financ.des_tip_fluxo_financ.
        ELSE
            ASSIGN v_des_tip_fluxo = "".

        PUT STREAM Stream_1
             tt-fluxo.cod_estab                                                 ";"
             tt-fluxo.cdn_fornecedor                                            ";"
             tt-fluxo.nome-emit                                                ";"
             tt-fluxo.cod_espec_docto                                           ";"
             tt-fluxo.serie                                                     ";"
             tt-fluxo.ind_trans_ap                                              ";"
             tt-fluxo.ind_trans_ap_abre                                         ";"
             tt-fluxo.cod_tit_ap                                                ";"
             tt-fluxo.cod_parcela                                               ";"
             tt-fluxo.dat_emis_docto                                            ";"
             tt-fluxo.val_movto_ap                                              ";"
             tt-fluxo.val_liq                                                   ";"
             tt-fluxo.cod_tip_fluxo_financ                                      ";"
             tt-fluxo.dat_transacao                                             ";"
             v_des_tip_fluxo                                                    ";"
             tt-fluxo.cod_portador                                              ";"
             tt-fluxo.nom_portador                                              ";"
             tt-fluxo.cod_forma_pagto                                           ";"
             tt-fluxo.des_forma_pagto                                           ";"
             tt-fluxo.id_feder
             SKIP.
    end.

END PROCEDURE.

PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE.

procedure pi-calcula:

    DEF VAR c-chave        AS CHAR NO-UNDO.
    DEF VAR v_num_cont_aux AS INT  NO-UNDO.

    des_estab_block:
    DO v_num_cont_aux = 1 TO NUM-ENTRIES(c_cod_estab_selec):
        estab_block:
    
        FOR EACH estabelecimento FIELDS(cod_estab) NO-LOCK
            WHERE estabelecimento.cod_estab = ENTRY(v_num_cont_aux, c_cod_estab_selec):
    
            /* Pega as antecipacoes */
            for each espec_docto no-lock
               where ind_tip_espec_docto = "Antecipacao",
                each tit_ap no-lock
               where tit_ap.dat_transacao   >= v_ini_data
                 and tit_ap.dat_transacao   <= v_fim_data
                 and tit_ap.cod_espec_docto  = espec_docto.cod_espec_docto
                 and tit_ap.cod_estab        = estabelecimento.cod_estab:
                
                find emitente no-lock 
                    where emitente.cod-emitente = tit_ap.cdn_fornecedor.
                
                for each movto_tit_ap of tit_ap no-lock
                    where not movto_tit_ap.log_movto_estordo 
                     and movto_tit_ap.cod_espec_docto     = espec_docto.cod_espec_docto
                     and movto_tit_ap.cod_estab           = estabelecimento.cod_estab
                     and movto_tit_ap.ind_trans_ap_abrev <> "BXTE" 
                     and movto_tit_ap.ind_trans_ap_abrev <> "EBTE" 
                     and movto_tit_ap.ind_trans_ap_abrev <> "BXA"                 
                     and movto_tit_ap.ind_trans_ap_abrev <> "EBXA"
                     and movto_tit_ap.ind_trans_ap_abrev <> "EVMN"
                     and movto_tit_ap.ind_trans_ap_abrev <> "TRUN"
                     and movto_tit_ap.ind_trans_ap_abrev <> "ETRU"
                     and movto_tit_ap.ind_trans_ap_abrev <> "CVLP"
                     and movto_tit_ap.ind_trans_ap_abrev <> "AVMN"
                     and movto_tit_ap.ind_trans_ap_abrev <> "EVMN"
                     and movto_tit_ap.ind_trans_ap_abrev <> "ESTT" 
                     and movto_tit_ap.ind_trans_ap_abrev <> "ECVP"
                     and movto_tit_ap.ind_trans_ap_abrev <> "CVAL":
                    for each val_tit_ap of tit_ap no-lock
                       where val_tit_ap.val_origin_tit_ap > 0 
                         and val_tit_ap.cod_finalid_econ = "Corrente":

                        FIND FIRST tt-fluxo
                             WHERE tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap 
                               AND tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ NO-LOCK NO-ERROR.

                        IF NOT AVAIL tt-fluxo THEN DO:

                            create tt-fluxo.
                            assign tt-fluxo.cod_estab            = movto_tit_ap.cod_estab
                                   tt-fluxo.dat_transacao        = movto_tit_ap.dat_transacao
                                   tt-fluxo.cdn_fornecedor       = movto_tit_ap.cdn_fornecedor
                                   tt-fluxo.nome-emit            = emitente.nome-emit
                                   tt-fluxo.id_feder             = emitente.cgc
                                   tt-fluxo.cod_espec_docto      = movto_tit_ap.cod_espec_docto
                                   tt-fluxo.serie                = tit_ap.cod_ser_docto
                                   tt-fluxo.ind_trans_ap         = movto_tit_ap.ind_trans_ap
                                   tt-fluxo.ind_trans_ap_abrev   = movto_tit_ap.ind_trans_ap_abrev
                                   tt-fluxo.cod_tit_ap           = tit_ap.cod_tit_ap
                                   tt-fluxo.cod_parcela          = tit_ap.cod_parcela
                                   tt-fluxo.dat_emis_docto       = tit_ap.dat_emis_docto                                  
                                   tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ
                                   tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap.

                            find first compl_movto_pagto no-lock
                                where compl_movto_pagto.cod_estab           = movto_tit_ap.cod_estab
                                and   compl_movto_pagto.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap no-error.
                            
                            IF  AVAIL compl_movto_pagto THEN DO:

                                find first item_bord_ap
                                     where item_bord_ap.cod_estab_bord = compl_movto_pagto.cod_estab_pagto
                                       and item_bord_ap.cod_portador   = compl_movto_pagto.cod_portador
                                       and item_bord_ap.num_bord_ap    = compl_movto_pagto.num_bord_ap
                                       and item_bord_ap.num_seq_bord   = compl_movto_pagto.num_seq_bord no-lock no-error.
    
                                IF  AVAIL item_bord_ap THEN DO:

                                    FIND FIRST emscad.portador
                                        WHERE emscad.portador.cod_portador = item_bord_ap.cod_portador NO-LOCK NO-ERROR.

                                    ASSIGN tt-fluxo.cod_portador    = item_bord_ap.cod_portador
                                           tt-fluxo.nom_portador    = emscad.portador.nom_pessoa WHEN AVAIL emscad.portador
                                           tt-fluxo.cod_forma_pagto = item_bord_ap.cod_forma_pagto.
    
                                     FIND FIRST forma_pagto
                                         WHERE forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto NO-LOCK NO-ERROR.
            
                                     IF  AVAIL forma_pagto THEN
                                         ASSIGN tt-fluxo.des_forma_pagto = forma_pagto.des_forma_pagto.
                                END.
                            END.
                        END.

                        ASSIGN  tt-fluxo.val_movto_ap = tt-fluxo.val_movto_ap + val_tit_ap.val_origin_tit_ap.
                    end.
                end.
            end.
            
            RUN pi-busca-borderos.

            /* Pega os titulos normais */
            for each movto_tit_ap no-lock
               where movto_tit_ap.cod_empresa    = v_cod_empres_usuar
                 and movto_tit_ap.cod_estab      = estabelecimento.cod_estab
                 and movto_tit_ap.dat_transacao >= v_ini_data
                 and movto_tit_ap.dat_transacao <= v_fim_data
                 and not movto_tit_ap.log_movto_estordo
                 and movto_tit_ap.ind_trans_ap_abrev <> "BXTE" 
                 and movto_tit_ap.ind_trans_ap_abrev <> "EBTE"
                 and movto_tit_ap.ind_trans_ap_abrev <> "IMPL" 
                 and movto_tit_ap.ind_trans_ap_abrev <> "PGEC" 
                 and movto_tit_ap.ind_trans_ap_abrev <> "PGEF" 
                 and movto_tit_ap.ind_trans_ap_abrev <> "ECVL"
                 and movto_tit_ap.ind_trans_ap_abrev <> "ECVP"
                 and movto_tit_ap.ind_trans_ap_abrev <> "EBXA"
                 and movto_tit_ap.ind_trans_ap_abrev <> "SBND"
                 and movto_tit_ap.ind_trans_ap_abrev <> "TRUN"
                 and movto_tit_ap.ind_trans_ap_abrev <> "ETRU"
                 and movto_tit_ap.ind_trans_ap_abrev <> "CVLP"
                 and movto_tit_ap.ind_trans_ap_abrev <> "AVMN"
                 and movto_tit_ap.ind_trans_ap_abrev <> "EVMN"
                 and movto_tit_ap.ind_trans_ap_abrev <> "CVAL"
                 and movto_tit_ap.ind_trans_ap_abrev <> "ESTT":
                 
                 find emitente no-lock 
                     where emitente.cod-emitente = movto_tit_ap.cdn_forne~cedor.
                 find first tit_ap of movto_tit_ap no-lock no-error.
                 if not avail tit_ap 
                    then next.      
                 find first val_movto_ap of movto_tit_ap no-lock no-error.
                 if not avail val_movto_ap 
                 then do:

                      for each val_tit_ap of tit_ap no-lock
                         where val_tit_ap.val_pagto_tit_ap > 0 
                           and val_tit_ap.cod_finalid_econ = "Corrente" :
            
                         if movto_tit_ap.ind_trans_ap_abrev = "ADVN" 
                         or movto_tit_ap.ind_trans_ap_abrev = "ALNC"          
                            then next.

                         FIND FIRST tt-fluxo
                              WHERE tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap 
                                AND tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ NO-LOCK NO-ERROR.

                         IF NOT AVAIL tt-fluxo THEN DO:
                             create tt-fluxo.
                             assign tt-fluxo.cod_estab            = movto_tit_ap.cod_estab
                                    tt-fluxo.dat_transacao        = movto_tit_ap.dat_transacao
                                    tt-fluxo.cdn_fornecedor       = movto_tit_ap.cdn_fornecedor
                                    tt-fluxo.nome-emit            = emitente.nome-emit
                                    tt-fluxo.id_feder             = emitente.cgc
                                    tt-fluxo.cod_espec_docto      = movto_tit_ap.cod_espec_docto
                                    tt-fluxo.serie                = tit_ap.cod_ser_docto
                                    tt-fluxo.ind_trans_ap         = movto_tit_ap.ind_trans_ap
                                    tt-fluxo.ind_trans_ap_abrev   = movto_tit_ap.ind_trans_ap_abrev
                                    tt-fluxo.cod_tit_ap           = tit_ap.cod_tit_ap
                                    tt-fluxo.cod_parcela          = tit_ap.cod_parcela
                                    tt-fluxo.dat_emis_docto       = tit_ap.dat_emis_docto                                    
                                    tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ
                                    tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap.
                         END.

                         ASSIGN tt-fluxo.val_movto_ap = tt-fluxo.val_movto_ap + val_tit_ap.val_pagto_tit_ap.
                    end.
                 end.

                 for each val_movto_ap of movto_tit_ap no-lock
                    where val_movto_ap.val_pagto_tit_ap > 0
                      and val_movto_ap.cod_finalid_econ = "Corrente":

                     FIND FIRST tt-fluxo
                          WHERE tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap 
                            AND tt-fluxo.cod_tip_fluxo_financ = val_movto_ap.cod_tip_fluxo_financ NO-LOCK NO-ERROR.

                     IF NOT AVAIL tt-fluxo THEN DO:
                        create tt-fluxo.
                        assign tt-fluxo.cod_estab            = movto_tit_ap.cod_estab
                               tt-fluxo.dat_transacao        = movto_tit_ap.dat_transacao
                               tt-fluxo.cdn_fornecedor       = movto_tit_ap.cdn_fornecedor
                               tt-fluxo.nome-emit            = emitente.nome-emit
                               tt-fluxo.id_feder             = emitente.cgc
                               tt-fluxo.cod_espec_docto      = movto_tit_ap.cod_espec_docto
                               tt-fluxo.serie                = tit_ap.cod_ser_docto
                               tt-fluxo.ind_trans_ap         = movto_tit_ap.ind_trans_ap
                               tt-fluxo.ind_trans_ap_abrev   = movto_tit_ap.ind_trans_ap_abrev
                               tt-fluxo.cod_tit_ap           = tit_ap.cod_tit_ap
                               tt-fluxo.cod_parcela          = tit_ap.cod_parcela
                               tt-fluxo.dat_emis_docto       = tit_ap.dat_emis_docto                               
                               tt-fluxo.cod_tip_fluxo_financ = val_movto_ap.cod_tip_fluxo_financ
                               tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap.

                        find first compl_movto_pagto no-lock
                            where compl_movto_pagto.cod_estab           = movto_tit_ap.cod_estab
                            and   compl_movto_pagto.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap no-error.
                        
                        IF  AVAIL compl_movto_pagto THEN DO:
                            find first item_bord_ap
                                 where item_bord_ap.cod_estab_bord = compl_movto_pagto.cod_estab_pagto
                                   and item_bord_ap.cod_portador   = compl_movto_pagto.cod_portador
                                   and item_bord_ap.num_bord_ap    = compl_movto_pagto.num_bord_ap
                                   and item_bord_ap.num_seq_bord   = compl_movto_pagto.num_seq_bord no-lock no-error.

                            IF  AVAIL item_bord_ap THEN DO:
                                FIND FIRST portador
                                    WHERE portador.cod_portador = item_bord_ap.cod_portador NO-LOCK NO-ERROR.

                                ASSIGN tt-fluxo.cod_portador    = item_bord_ap.cod_portador
                                       tt-fluxo.nom_portador    = portador.nom_pessoa WHEN AVAIL portador
                                       tt-fluxo.cod_forma_pagto = item_bord_ap.cod_forma_pagto.

                                 FIND FIRST forma_pagto
                                     WHERE forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto NO-LOCK NO-ERROR.
        
                                 IF  AVAIL forma_pagto THEN
                                     ASSIGN tt-fluxo.des_forma_pagto = forma_pagto.des_forma_pagto.
                            END.
                        END.
                     END.

                     ASSIGN tt-fluxo.val_movto_ap = tt-fluxo.val_movto_ap + (val_movto_ap.val_pagto_tit_ap + val_movto_ap.val_multa_tit_ap + val_movto_ap.val_juros).
                 END.
            end.
            
            /* Pega os Pagamentos Extra Fornecedor */        
            for each movto_tit_ap no-lock
               where movto_tit_ap.cod_empresa    = v_cod_empres_usuar
                 and movto_tit_ap.cod_estab      = estabelecimento.cod_estab
                 and movto_tit_ap.dat_transacao >= v_ini_data
                 and movto_tit_ap.dat_transacao <= v_fim_data
                 and not movto_tit_ap.log_movto_estordo
                 and movto_tit_ap.ind_trans_ap_abrev = "PGEF":

                find emitente no-lock 
                    where emitente.cod-emitente = movto_tit_ap.cdn_forne~cedor.

                find antecip_pef_pend of movto_tit_ap no-lock no-error.
                if not avail antecip_pef_pend 
                   then next.

                for each aprop_ctbl_pend_ap of antecip_pef_pend no-lock:                      
                    create tt-fluxo.
                    assign tt-fluxo.cod_estab            = movto_tit_ap.cod_estab
                           tt-fluxo.dat_transacao        = movto_tit_ap.dat_transacao
                           tt-fluxo.cdn_fornecedor       = movto_tit_ap.cdn_fornecedor
                           tt-fluxo.nome-emit            = emitente.nome-emit
                           tt-fluxo.id_feder             = emitente.cgc
                           tt-fluxo.cod_espec_docto      = movto_tit_ap.cod_espec_docto
                           tt-fluxo.serie                = antecip_pef_pend.cod_ser_docto
                           tt-fluxo.ind_trans_ap         = movto_tit_ap.ind_trans_ap
                           tt-fluxo.ind_trans_ap_abrev   = movto_tit_ap.ind_trans_ap_abrev
                           tt-fluxo.cod_tit_ap           = antecip_pef_pend.cod_tit_ap
                           tt-fluxo.cod_parcela          = antecip_pef_pend.cod_parcela
                           tt-fluxo.dat_emis_docto       = movto_tit_ap.dat_transacao
                           tt-fluxo.val_movto_ap         = aprop_ctbl_pend_ap.val_aprop_ctbl
                           tt-fluxo.cod_tip_fluxo_financ = aprop_ctbl_pend_ap.cod_tip_fluxo_financ.
                end.
            end.
            
            /* Pega os Pagamentos Extra Fornecedor a credito */        
            for each movto_tit_ap no-lock
               where movto_tit_ap.cod_empresa    = v_cod_empres_usuar
                 and movto_tit_ap.cod_estab      = estabelecimento.cod_estab
                 and movto_tit_ap.dat_transacao >= v_ini_data
                 and movto_tit_ap.dat_transacao <= v_fim_data
                 and not movto_tit_ap.log_movto_estordo
                 and movto_tit_ap.ind_trans_ap_abrev = "PECR":
                 
                find emitente no-lock 
                     where emitente.cod-emitente = movto_tit_ap.cdn_fornecedor.
                        
                /* *** 505
                assign c-chave = estabelecimento.cod_estab + left-trim(string(movto_tit_ap.num_id_movto_tit_ap)).
            
                for each tab_livre_emsfin no-lock 
                   where cod_modul_dtsul                       = "apb"
                     and tab_livre_emsfin.cod_tab_dic_dtsul    = "rat_movto_tit_ap"
                     and tab_livre_emsfin.cod_compon_1_idx_tab =  c-chave:
                **/

                for each rat_movto_tit_ap no-lock
                    where rat_movto_tit_ap.cod_estab            = movto_tit_ap.cod_estab
                      and rat_movto_tit_ap.num_id_movto_tit_ap  = movto_tit_ap.num_id_movto_tit_ap:

                   create tt-fluxo.
                   assign tt-fluxo.cod_estab            = movto_tit_ap.cod_estab
                          tt-fluxo.dat_transacao        = movto_tit_ap.dat_transacao
                          tt-fluxo.cdn_fornecedor       = movto_tit_ap.cdn_fornecedor
                          tt-fluxo.nome-emit            = emitente.nome-emit
                          tt-fluxo.id_feder             = emitente.cgc
                          tt-fluxo.cod_espec_docto      = movto_tit_ap.cod_espec_docto
                          tt-fluxo.serie                = ""
                          tt-fluxo.ind_trans_ap         = movto_tit_ap.ind_trans_ap
                          tt-fluxo.ind_trans_ap_abrev   = movto_tit_ap.ind_trans_ap_abrev
                          tt-fluxo.cod_tit_ap           = ""
                          tt-fluxo.cod_parcela          = ""
                          tt-fluxo.dat_emis_docto       = movto_tit_ap.dat_transacao
                          tt-fluxo.val_movto_ap         = rat_movto_tit_ap.val_aprop_ctbl       /* ** tab_livre_emsfin.val_livre_1 * - 1 ***/
                          tt-fluxo.cod_tip_fluxo_financ = rat_movto_tit_ap.cod_tip_fluxo_financ /* ** 505 substring(tab_livre_emsfin.cod_livre_1, length(tab_livre_emsfin.cod_livre_1) - 2 , 3) ***/.
                           
                 end.
            end.
                      
            /* pega movimentos de caixa e bancos */
            for each movto_cta_corren no-lock
               where movto_cta_corren.dat_transacao   >= v_ini_data
                 and movto_cta_corren.dat_transacao   <= v_fim_data
                 and movto_cta_corren.cod_modul_dtsul  = "cmg",
                each rat_financ_cmg of movto_cta_corren no-lock
               where rat_financ_cmg.cod_tip_fluxo_financ > "200"   
                 AND rat_financ_cmg.cod_estab = estabelecimento.cod_estab:
               find cta_corren of movto_cta_corren no-lock.
            
               create tt-fluxo.
               assign tt-fluxo.cod_estab            = estabelecimento.cod_estab
                      tt-fluxo.dat_transacao        = movto_cta_corren.dat_transacao
                      tt-fluxo.cdn_fornecedor       = int(cta_corren.cod_banco)
                      tt-fluxo.nome-emit            = cta_corren.nom_abrev
                      tt-fluxo.cod_espec_docto      = ""
                      tt-fluxo.serie                = ""
                      tt-fluxo.ind_trans_ap         = movto_cta_corren.cod_tip_trans_cx
                      tt-fluxo.ind_trans_ap_abrev   = movto_cta_corren.cod_tip_trans_cx
                      tt-fluxo.cod_tit_ap           = cod_docto_movto_ct
                      tt-fluxo.cod_parcela          = ""
                      tt-fluxo.dat_emis_docto       = ?
                      tt-fluxo.val_movto_ap         = if movto_cta_corren.ind_fluxo_movto_~cta_corren = "ENT" 
                                                         then rat_financ_cmg.val_movto_cta_corren * - 1 
                                                         else rat_financ_cmg.val_movto_cta_corren    
                      tt-fluxo.cod_tip_fluxo_financ = rat_financ_cmg.cod_tip_fluxo_financ.
                          
            end.

        END.

    END.

end.

PROCEDURE pi-busca-borderos:
    /*
      Situa‡Æo Border“: "Em Digita‡Æo","Ja Impresso","Enviado ao Banco","Parcialmente Baixado","Totalmente Baixado","Estornado","Transmitir ao Banco"
    */

    DEF VAR l-achou-tit AS LOG INIT NO NO-UNDO.

    FOR EACH bord_ap NO-LOCK
        WHERE bord_ap.cod_estab       = estabelecimento.cod_estab
        AND   bord_ap.dat_transacao  >= v_ini_data
        AND   bord_ap.dat_transacao  <= v_fim_data 
        AND   bord_ap.ind_sit_bord_ap = "Enviado ao Banco":

        FOR EACH item_bord_ap OF bord_ap NO-LOCK
            , FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = item_bord_ap.cdn_fornecedor:            

            IF  item_bord_ap.ind_sit_item_bord_ap = "Estornado" THEN
                NEXT.

            ASSIGN l-achou-tit = NO.

            FOR EACH tit_ap NO-LOCK
                 WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab
                   AND tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor
                   AND tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                   AND tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto
                   AND tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap
                   AND tit_ap.cod_parcela     = item_bord_ap.cod_parcela:
                   
                 ASSIGN l-achou-tit = YES.
                 FOR EACH val_tit_ap of tit_ap no-lock
                    where val_tit_ap.Val_Perc_Rat > 0 
                      and val_tit_ap.cod_finalid_econ = "Corrente":
             
                     FIND FIRST tt-fluxo
                          WHERE tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap 
                            AND tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ NO-LOCK NO-ERROR.
                     
                     IF NOT AVAIL tt-fluxo THEN DO:
                         create tt-fluxo.
                         assign tt-fluxo.cod_estab            = tit_ap.cod_estab
                                tt-fluxo.dat_transacao        = bord_ap.dat_transacao
                                tt-fluxo.cdn_fornecedor       = tit_ap.cdn_fornecedor
                                tt-fluxo.nome-emit            = emitente.nome-emit
                                tt-fluxo.id_feder             = emitente.cgc
                                tt-fluxo.cod_espec_docto      = tit_ap.cod_espec_docto
                                tt-fluxo.serie                = tit_ap.cod_ser_docto
                                tt-fluxo.ind_trans_ap         = "Bordero (" + bord_ap.cod_estab + "/" + bord_ap.cod_portad + "/" + STRING(bord_ap.num_bord_ap) +  ")"
                                tt-fluxo.ind_trans_ap_abrev   = "BOR"
                                tt-fluxo.cod_tit_ap           = tit_ap.cod_tit_ap
                                tt-fluxo.cod_parcela          = tit_ap.cod_parcela
                                tt-fluxo.dat_emis_docto       = tit_ap.dat_emis_docto                                  
                                tt-fluxo.cod_tip_fluxo_financ = val_tit_ap.cod_tip_fluxo_financ
                                tt-fluxo.num_id_tit_ap        = tit_ap.num_id_tit_ap
                                tt-fluxo.cod_portador         = bord_ap.cod_portad
                                tt-fluxo.cod_forma_pagto      = item_bord_ap.cod_forma_pagto.

                         FIND FIRST emscad.portador
                             WHERE emscad.portador.cod_portador = item_bord_ap.cod_portador NO-LOCK NO-ERROR.

                         ASSIGN tt-fluxo.nom_portador = emscad.portador.nom_pessoa WHEN AVAIL emscad.portador.

                         FIND FIRST forma_pagto
                             WHERE forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto NO-LOCK NO-ERROR.

                         IF  AVAIL forma_pagto THEN
                             ASSIGN tt-fluxo.des_forma_pagto = forma_pagto.des_forma_pagto.
                     END.
                     
                     ASSIGN  tt-fluxo.val_movto_ap = tt-fluxo.val_movto_ap + ((item_bord_ap.val_pagto * val_tit_ap.val_perc_rat) / 100).

                     RUN pi_calc_val_liq.

                     ASSIGN tt-fluxo.val_liq = tt-fluxo.val_liq + ((v_val_liquidad_bord * val_tit_ap.val_perc_rat) / 100).
                 END.
 
            END.

            /* Procurar antecipa‡äes */
            IF  NOT  l-achou-tit THEN DO:
                FOR EACH antecip_pef_pend NO-LOCK
                    WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                      AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef:
            
                     FOR EACH aprop_ctbl_pend_ap of antecip_pef_pend no-lock:                      
                        CREATE tt-fluxo.
                        ASSIGN tt-fluxo.cod_estab            = item_bord_ap.cod_estab
                               tt-fluxo.dat_transacao        = bord_ap.dat_transacao
                               tt-fluxo.cdn_fornecedor       = antecip_pef_pend.cdn_fornecedor
                               tt-fluxo.nome-emit            = emitente.nome-emit
                               tt-fluxo.id_feder             = emitente.cgc
                               tt-fluxo.cod_espec_docto      = antecip_pef_pend.cod_espec_docto
                               tt-fluxo.serie                = ""
                               tt-fluxo.ind_trans_ap         = "Bordero (" + bord_ap.cod_estab + "/" + bord_ap.cod_portad + "/" + STRING(bord_ap.num_bord_ap ) +  ")"
                               tt-fluxo.ind_trans_ap_abrev   = "BOR"
                               tt-fluxo.cod_tit_ap           = antecip_pef_pend.cod_tit_ap
                               tt-fluxo.cod_parcela          = antecip_pef_pend.cod_parcela
                               tt-fluxo.dat_emis_docto       = antecip_pef_pend.dat_emis_docto
                               tt-fluxo.val_movto_ap         = aprop_ctbl_pend_ap.val_aprop_ctbl
                               tt-fluxo.cod_tip_fluxo_financ = aprop_ctbl_pend_ap.cod_tip_fluxo_financ
                               tt-fluxo.cod_forma_pagto      = item_bord_ap.cod_forma_pagto
                               tt-fluxo.cod_portador         = item_bord_ap.cod_portador.

                         FIND FIRST emscad.portador
                             WHERE emscad.portador.cod_portador = item_bord_ap.cod_portador NO-LOCK NO-ERROR.

                         ASSIGN tt-fluxo.nom_portador = emscad.portador.nom_pessoa WHEN AVAIL emscad.portador.

                         FIND FIRST forma_pagto
                             WHERE forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto NO-LOCK NO-ERROR.

                         IF  AVAIL forma_pagto THEN
                             ASSIGN tt-fluxo.des_forma_pagto = forma_pagto.des_forma_pagto.

                         RUN pi_calc_val_liq.

                         ASSIGN tt-fluxo.val_liq = v_val_liquidad_bord.
                    END.
                END.
            END.
        END. /*Item_bord_ap*/
    END. /*bord_ap*/
END.

PROCEDURE pi_calc_val_liq:
    ASSIGN v_val_tot_impto     = 0
           v_val_liquidad_bord = 0.

    if  item_bord_ap.cod_refer_antecip_pef <> ""
    and item_bord_ap.cod_refer_antecip_pef <> ? then                                                     
        run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab,
                                    Input item_bord_ap.cod_refer_antecip_pef,
                                    Input "",
                                    Input 0,
                                    Input 0,
                                    Input yes,
                                    Input bord_ap.dat_transacao,
                                    Input "Retido",
                                    output v_log_impto_vincul_refer,
                                    output v_val_tot_impto,
                                    Input recid(bord_ap),
                                    Input ?,
                                    Input recid(item_lote_pagto)).

    ELSE
        run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab_bord,
                                    Input "",
                                    Input bord_ap.cod_portador,
                                    Input bord_ap.num_bord_ap,
                                    Input item_bord_ap.num_seq_bord,
                                    Input yes,
                                    Input bord_ap.dat_transacao,
                                    Input "Retido",
                                    output v_log_impto_vincul_refer,
                                    output v_val_tot_impto,
                                    Input ?,
                                    Input ?,
                                    Input ?).

    assign v_val_liquidad_bord =  item_bord_ap.val_pagto
                                + item_bord_ap.val_multa_tit_ap
                                + item_bord_ap.val_juros
                                + item_bord_ap.val_cm_tit_ap
                                - item_bord_ap.val_desc_tit_ap
                                - item_bord_ap.val_abat_tit_ap
                                - v_val_tot_impto.
END PROCEDURE.
