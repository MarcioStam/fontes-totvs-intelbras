/*****************************************************************************
**     Programa.........: esp/acr/esacr028rp.p
**     Descricao .......: Relat¢rio Prorrogaá∆o Vencimentos
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 10/12/2009
*******************************************************************************/

DEF TEMP-TABLE tt_tit_acr                    
    FIELD cod_estab        LIKE tit_acr.cod_estab
    FIELD num_renegoc      LIKE renegoc_acr.num_renegoc
    FIELD ind_tip_reg      AS   CHAR
    FIELD cdn_cliente      LIKE tit_acr.cdn_cliente 
    FIELD nom_cliente      LIKE emscad.cliente.nom_abrev FORMAT "x(12)"
    FIELD cod_esp          LIKE tit_acr.cod_espec_docto
    FIELD cod_ser          LIKE tit_acr.cod_ser_docto
    FIELD cod_tit_acr      LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela      LIKE tit_acr.cod_parcela
    FIELD cod_unid_negoc   LIKE val_tit_acr.cod_unid_negoc
    FIELD val_origin       LIKE tit_acr.val_origin
    FIELD dat_vencto_orig  LIKE tit_acr.dat_vencto_orig
    FIELD dat_vencto_atual LIKE tit_acr.dat_vencto_tit
    FIELD dat_transacao    LIKE movto_tit_acr.dat_transacao
    FIELD cod_usuar        LIKE movto_tit_acr.cod_usuario
    FIELD des_motivo       LIKE histor_padr.des_histor_padr
    FIELD dat_vencto_ini   LIKE tit_acr.dat_vencto_tit
    FIELD dat_vencto_fim   LIKE tit_acr.dat_vencto_tit
    FIELD num_id_tit_acr   LIKE tit_acr.num_id_tit_acr
    INDEX tt_tit    IS PRIMARY cod_estab num_renegoc ind_tip_reg cod_esp cod_ser cod_tit_acr cod_parcela cod_unid_negoc
    INDEX tt_tit_un cod_unid_negoc cod_estab num_renegoc ind_tip_reg.

DEF TEMP-TABLE tt_cliente                    
    FIELD cdn_cliente      LIKE tit_acr.cdn_cliente 
    INDEX tt_cliente IS PRIMARY cdn_cliente.

DEF TEMP-TABLE tt_espec_docto
    FIELD tta_cod_espec_docto LIKE tit_acr.cod_espec_docto
    INDEX tt_espec IS PRIMARY tta_cod_espec_docto.

DEF TEMP-TABLE tt_tit_acr_movto
    FIELD cod_estab        LIKE renegoc_acr.cod_estab
    FIELD num_id_tit_acr   LIKE tit_acr.num_id_tit_acr
    FIELD num_renegoc      LIKE renegoc_acr.num_renegoc
    FIELD dat_transacao    LIKE movto_tit_acr.dat_transacao
    FIELD cod_usuar        LIKE movto_tit_acr.cod_usuario
    FIELD des_motivo       LIKE histor_padr.des_histor_padr
    FIELD dat_vencto_ini   LIKE tit_acr.dat_vencto_tit
    FIELD dat_vencto_fim   LIKE tit_acr.dat_vencto_tit
    INDEX tt_tit_movto IS PRIMARY cod_estab num_id_tit_acr num_renegoc.


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
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
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
def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

/************** Fim de variaveis de selecao *******/

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOG    INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOG    NO-UNDO.
DEF NEW GLOBAL SHARED VAR R-Registro-Atual        AS   ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR C-Arquivo-Log           AS   CHAR   FORM "x(60)"NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped               AS   INTE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR H_Prog_Segur_Estab      AS   HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Num_Tip_Aces_Usuar    AS   INTE   NO-UNDO.     
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR C-Dir-Spool-Servid-Exec AS   CHAR   NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec                             AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

DEF VAR V_Cod_Empresa           LIKE emscad.empresa.Cod_Empresa NO-UNDO.
DEF VAR I                       AS INTE NO-UNDO.
DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR H-Hacr155               AS HANDLE NO-UNDO.
DEF VAR V-Cod-Destino-Impres    AS CHAR   NO-UNDO.
DEF VAR V-Num-Reg-Lidos         AS INTE   NO-UNDO.
DEF VAR V-Num-Point             AS INTE   NO-UNDO.
DEF VAR V-Num-Set               AS INTE   NO-UNDO.
DEF VAR V-Cod-Arquivo           AS CHAR.
DEF VAR V-Num-Tip-Reg           AS INTE FORM "999".
DEF VAR C-Empresa               AS CHAR FORM "x(40)"  NO-UNDO.
DEF VAR C-Titulo-Relat          AS CHAR FORM "x(50)"  NO-UNDO.
DEF VAR C-Sistema               AS CHAR FORM "x(25)"  NO-UNDO.
DEF VAR C-Rodape                AS CHAR               NO-UNDO.
DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.

DEF VAR v_nom_enterprise        AS CHAR FORM "x(40)"  NO-UNDO.

DEF STREAM Stream_1.
DEF STREAM s_planilha.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio Prorrogaá∆o Vencimentos".

DEF VAR i_cdn_cliente_ini       LIKE movto_tit_acr.cdn_cliente. 
DEF VAR i_cdn_cliente_fim       LIKE movto_tit_acr.cdn_cliente. 
DEF VAR l_log_matiz          AS LOG.
DEF VAR l_log_vendor         AS LOG.
DEF VAR d_dt_emis_ini        AS DATE.
DEF VAR d_dt_emis_fim        AS DATE.
DEF VAR d_dt_vcto_ini        AS DATE.
DEF VAR d_dt_vcto_fim        AS DATE.
DEF VAR rs-tipo              AS INT.
DEF VAR c_cod_estab_selec    AS CHAR.
DEF VAR c_cod_un_selec       AS CHAR.
DEF VAR v_log_gerac_planilha AS LOG.
DEF VAR v_cod_arq_planilha   AS CHAR.
DEF VAR v_cod_carac_lim      AS CHAR.

DEFINE VARIABLE v_dat_reneg_orig   AS DATE        NO-UNDO.
DEFINE VARIABLE v_dat_reneg_dest   AS DATE        NO-UNDO.
DEFINE VARIABLE v_val_renegoc      AS DECIMAL     NO-UNDO.

def frame f-cabec header
    FILL('-', 204) FORMAT 'x(204)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 94 format 'x(40)'
    'P†gina:' at 191
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 185) FORMAT 'x(185)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 204 page-top stream-io.

def frame f-rodape header
    FILL('-', 145) FORMAT 'x(145)' AT 1
    'DATASUL - Espec°ficos Intelbras - esacr028 - V:5.00.00.000' SKIP
    with no-box no-labels width 204 page-bottom stream-io.

FIND emscad.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF AVAIL empresa THEN
    ASSIGN v_nom_enterprise   = empresa.nom_razao_social.
ELSE
    ASSIGN v_nom_enterprise   = 'DATASUL'.

ASSIGN C-Empresa = "XXXXXXXXXXXXXXX".

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF v_cod_dwb_user BEGINS 'es_'
   THEN ASSIGN v_cod_dwb_user = ENTRY(2,v_cod_usuar_corren,"_").

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr028"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User
         NO-ERROR.

    ASSIGN V_Cod_Dwb_File       = Ped_Exec_Param.Cod_Dwb_File
           C-Impressora         = Ped_Exec_Param.Nom_Dwb_Printer
           C-Layout             = Ped_Exec_Param.Cod_Dwb_Print_Layout
           V_Cod_Dwb_Output     = dwb_set_list_param.Cod_dwb_output
           i_cdn_cliente_ini    = INTEGER(ENTRY(02,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           i_cdn_cliente_fim    = INTEGER(ENTRY(03,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l_log_matiz          =        (ENTRY(04,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           d_dt_emis_ini        =    DATE(ENTRY(05,dwb_set_list_param.cod_dwb_parameters,chr(10)))    
           d_dt_emis_fim        =    DATE(ENTRY(06,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           d_dt_vcto_ini        =    DATE(entry(07,dwb_set_list_param.cod_dwb_parameters,chr(10)))         
           d_dt_vcto_fim        =    DATE(entry(08,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           rs-tipo              = INTEGER(entry(09,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           c_cod_estab_selec    =         ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_cod_un_selec       =         ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_log_gerac_planilha =        (ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           v_cod_arq_planilha   =         ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_carac_lim      =         ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           l_log_vendor         =        (ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes') NO-ERROR.

    /* Busca o diret¢rio de Spool do servidor de execuá∆o para gerar os arquivos */
    FIND FIRST ped_exec NO-LOCK
        WHERE  ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-ERROR.
    IF  AVAIL  ped_exec THEN DO:
        FIND FIRST servid_exec NO-LOCK
            WHERE  servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
        IF  AVAIL  servid_exec THEN
                ASSIGN V_Cod_Dwb_File     = servid_exec.nom_dir_spool + "~/" + V_Cod_Dwb_File
                       v_cod_arq_planilha = servid_exec.nom_dir_spool + "~/" + v_cod_arq_planilha.
    END.

  END. /* End do IF AVAIL EmsBas.Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr028"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File       = Dwb_Set_list_Param.Cod_Dwb_File             
           C-Impressora         = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout             = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           V_Cod_Dwb_Output     = dwb_set_list_param.Cod_dwb_output
           i_cdn_cliente_ini    = INTEGER(ENTRY(02,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           i_cdn_cliente_fim    = INTEGER(ENTRY(03,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l_log_matiz          =        (ENTRY(04,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           d_dt_emis_ini        =    DATE(ENTRY(05,dwb_set_list_param.cod_dwb_parameters,chr(10)))    
           d_dt_emis_fim        =    DATE(ENTRY(06,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           d_dt_vcto_ini        =    DATE(entry(07,dwb_set_list_param.cod_dwb_parameters,chr(10)))         
           d_dt_vcto_fim        =    DATE(entry(08,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           rs-tipo              = INTEGER(entry(09,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           c_cod_estab_selec    =         ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_cod_un_selec       =         ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_log_gerac_planilha =        (ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           v_cod_arq_planilha   =         ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_carac_lim      =         ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           l_log_vendor         =        (ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes') NO-ERROR.

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr028.txt".
      OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET 'iso8859-1'.
    END.
    WHEN "Impressora" /*l_Printer*/  THEN 
    DO.
      FIND Imprsor_Usuar NO-LOCK
          WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora
            AND Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User
          USE-INDEX imprsrsr_id NO-ERROR.
      FIND layout_impres NO-LOCK
           WHERE Layout_Impres.Nom_Impressora    = C-Impressora
             AND Layout_Impres.Cod_Layout_Impres = C-Layout
           NO-ERROR.
      ASSIGN V_Rpt_Stream_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_Stream_1_Bottom - V_Rpt_Stream_1_Lines */
             V_Rpt_Stream_1_Lines  = Layout_Impres.Num_Lin_Pag.

      IF OPSYS = "UNIX" THEN 
      DO.
        IF V_Num_Ped_Exec_Corren <> 0 THEN 
        DO.
          FIND Ped_Exec NO-LOCK
              WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
          IF AVAIL Ped_Exec THEN 
          DO.
            FIND Servid_Exec_Imprsor NO-LOCK
                 WHERE Servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec
                   AND Servid_Exec_Imprsor.Nom_Impressora  = C-Impressora 
                 NO-ERROR.
            IF AVAIL Servid_Exec_Imprsor 
            THEN OUTPUT STREAM Stream_1 
                        THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET 'iso8859-1'.
            ELSE OUTPUT STREAM Stream_1 
                        THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET 'iso8859-1'.
          END. /* End do - IF AVAIL ped_Exec */
        END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
        ELSE OUTPUT STREAM Stream_1 
                    THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                            PAGED 
                            PAGE-SIZE 
                            VALUE(V_Rpt_Stream_1_Lines) 
                            CONVERT TARGET 'iso8859-1'.
      END. /* End do - IF OPSYS = "UNIX" */
      ELSE OUTPUT STREAM Stream_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_Stream_1_Lines) 
                                           CONVERT TARGET 'iso8859-1'.
      FOR EACH Configur_Layout_Impres NO-LOCK
          WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
             BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
        FIND Configur_Tip_imprsor NO-LOCK
             WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
               AND Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
               AND Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
             NO-ERROR.
        PUT STREAM Stream_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
      END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
    END. /* End do - WHEN "Impressora" l_Printer */
    WHEN "Arquivo" /*l_File*/  THEN 
    DO.
      OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File)
                                      PAGED 
                                      PAGE-SIZE 
                                      VALUE(V_Rpt_Stream_1_Lines)
                                      CONVERT TARGET 'iso8859-1'.
    END. /* End do - WHEN "Arquivo" - l_File  */
  END. /* End do - CASE V_Cod_Dwb_Output */
END. /* End do - DO. -- Que seta a saida da impressao */
                                     
ASSIGN C-Programa          = "esacr028"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Prorrogaá∆o Vencimentos"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN pi_gera_tt.

RUN pi_imprime_tt.

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE pi_gera_tt:

    DEFINE VARIABLE v_num_cont_aux     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_dat_emis_tit_acr AS DATE        NO-UNDO.

    DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
    DEF BUFFER b_cliente      FOR emscad.cliente.
    DEF BUFFER b_histor_movto_tit_acr FOR histor_movto_tit_acr.

    DEF BUFFER b_estabelecimento      FOR estabelecimento.

/*
MESSAGE 
V_Cod_Dwb_File      
C-Impressora        
C-Layout            
V_Cod_Dwb_Output    
i_cdn_cliente_ini   
i_cdn_cliente_fim   
l_log_matiz         
d_dt_emis_ini       
d_dt_emis_fim       
d_dt_vcto_ini       
d_dt_vcto_fim       
rs-tipo             
c_cod_estab_selec   
c_cod_un_selec      
v_log_gerac_planilha
v_cod_arq_planilha  
v_cod_carac_lim     
VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RUN pi_cria_teste.
*/

    FOR EACH espec_docto_financ_acr NO-LOCK:
        IF CAN-FIND (espec_docto
                     WHERE espec_docto.cod_espec_docto = espec_docto_financ_acr.cod_espec_docto
                       AND espec_docto.ind_tip_espec   = "Normal") 
        THEN DO:
             CREATE tt_espec_docto.
             ASSIGN tt_espec_docto.tta_cod_espec_docto = espec_docto_financ_acr.cod_espec_docto.
        END.
    END.

    IF i_cdn_cliente_ini <> i_cdn_cliente_fim 
    THEN DO:
         FOR EACH emscad.cliente NO-LOCK
             WHERE emscad.cliente.cod_empresa  = v_cod_empres_usuar
               AND emscad.cliente.cdn_cliente >= i_cdn_cliente_ini
               AND emscad.cliente.cdn_cliente <= i_cdn_cliente_fim:
             CREATE tt_cliente.
             ASSIGN tt_cliente.cdn_cliente = cliente.cdn_cliente.
         END.
    END.
    ELSE DO:
         IF l_log_matiz = NO
         OR i_cdn_cliente_ini MODULO 2 = 0 /* ** PF ***/
         THEN DO:
              CREATE tt_cliente.
              ASSIGN tt_cliente.cdn_cliente = i_cdn_cliente_ini.
         END.
         ELSE DO:
              FIND emscad.cliente NO-LOCK
                  WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                    AND emscad.cliente.cdn_cliente = i_cdn_cliente_ini NO-ERROR.
              IF AVAIL emscad.cliente 
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
                                 CREATE tt_cliente.
                                 ASSIGN tt_cliente.cdn_cliente = b_cliente.cdn_cliente.
                            END.
                        END.
                   END.
              END.
         END.
    END.

    des_estab_block:
    DO v_num_cont_aux = 1 TO NUM-ENTRIES(c_cod_estab_selec):
        estab_block:
        FOR EACH estabelecimento FIELDS(cod_estab cod_empresa) NO-LOCK
            WHERE estabelecimento.cod_estab = ENTRY(v_num_cont_aux, c_cod_estab_selec):

            IF  NOT CAN-FIND (FIRST tit_acr 
                              WHERE tit_acr.cod_estab = estabelecimento.cod_estab) 
            AND NOT CAN-FIND (FIRST renegoc_acr
                              WHERE renegoc_acr.cod_estab = estabelecimento.cod_estab) 
                THEN NEXT estab_block.

            clien_block:
            FOR EACH tt_cliente:
                IF  NOT CAN-FIND(FIRST tit_acr 
                                 WHERE tit_acr.cod_estab   = estabelecimento.cod_estab
                                   AND tit_acr.cdn_cliente = tt_cliente.cdn_cliente) 
                AND NOT CAN-FIND (FIRST renegoc_acr
                                  WHERE renegoc_acr.cod_estab   = estabelecimento.cod_estab
                                    AND renegoc_acr.cdn_cliente = tt_cliente.cdn_cliente) 
                    THEN NEXT clien_block.

                /* ** Leitura nas Renegociaá‰es - acr360aa ***/
                FOR EACH renegoc_acr NO-LOCK 
                    WHERE renegoc_acr.cod_estab                = estabelecimento.cod_estab
                      AND renegoc_acr.cdn_cliente              = tt_cliente.cdn_cliente
                      AND renegoc_acr.ind_tip_renegoc_acr      = "Substituiá∆o"
                      AND renegoc_acr.ind_sit_renegoc_acr      = "Atualizado"
                      AND renegoc_acr.log_renegoc_acr_estordo  = NO 
                      AND renegoc_acr.dat_transacao           >= d_dt_emis_ini
                      AND renegoc_acr.dat_transacao           <= d_dt_emis_fim:
        
                    ASSIGN v_dat_reneg_orig = 12/31/9999
                           v_dat_reneg_dest = 01/01/0001.

                    /* ** Renegociaá∆o transferindo estabelecimento ***/
                    /* ** Relaciona T°tulos Origem ***/
                    /* ** 505 IF renegoc_acr.log_livre_2 = YES ***/
                    IF renegoc_acr.log_bxa_estab_tit_acr = YES
                    THEN DO:
                         FOR EACH b_estabelecimento NO-LOCK 
                             WHERE b_estabelecimento.cod_empresa = estabelecimento.cod_empresa:    
                             movto_tit_block:
                             FOR EACH movto_tit_acr NO-LOCK   
                                 WHERE movto_tit_acr.cod_estab           = b_estabelecimento.cod_estab
                                   AND movto_tit_acr.cod_refer           = renegoc_acr.cod_refer
                                   AND movto_tit_acr.ind_trans_acr_abrev = "LQRN" USE-INDEX mvtttcr_refer:
                                 /* ** 505 IF ENTRY(8,movto_tit_acr.cod_livre_1,CHR(24)) <> renegoc_acr.cod_estab ***/
                                 IF movto_tit_acr.cod_estab_proces_bxa <> renegoc_acr.cod_estab
                                    THEN NEXT movto_tit_block.
                                 RUN pi_gera_tt_titulos_renegoc_acr.
                             END.
                         END.    
                    END.  
                    ELSE DO:
                         FOR EACH movto_tit_acr NO-LOCK  
                             WHERE movto_tit_acr.cod_estab           = renegoc_acr.cod_estab
                               AND movto_tit_acr.cod_refer           = renegoc_acr.cod_refer
                               AND movto_tit_acr.ind_trans_acr_abrev = "LQRN" USE-INDEX mvtttcr_refer:
                             RUN pi_gera_tt_titulos_renegoc_acr.
                         END.    
                    END.
                    
                    ASSIGN v_dat_reneg_dest = 01/01/0001.

                    /* ** Relaciona T°tulos Gerados ***/
                    FOR EACH movto_tit_acr NO-LOCK  
                        WHERE movto_tit_acr.cod_estab           = renegoc_acr.cod_estab
                          AND movto_tit_acr.cod_refer           = renegoc_acr.cod_refer
                          AND movto_tit_acr.ind_trans_acr_abrev = "REN" USE-INDEX mvtttcr_refer,
                        FIRST tit_acr NO-LOCK 
                        WHERE tit_acr.cod_estab      = movto_tit_acr.cod_estab 
                          AND tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr USE-INDEX titacr_token:    
                    
                        IF tit_acr.dat_vencto_origin > v_dat_reneg_dest
                           THEN ASSIGN v_dat_reneg_dest = tit_acr.dat_vencto_origin.

                        IF rs-tipo = 2 /* ** Visualizaá∆o por UN ***/
                        THEN DO:

                             FOR EACH val_tit_acr OF tit_acr NO-LOCK:

                                 IF LOOKUP(val_tit_acr.cod_unid_negoc,c_cod_un_selec) = 0 
                                    THEN NEXT.

                                 FIND tt_tit_acr NO-LOCK
                                     WHERE tt_tit_acr.cod_estab      = renegoc_acr.cod_estab
                                       AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
                                       AND tt_tit_acr.ind_tip_reg    = "1.Renegociaá∆o" 
                                       AND tt_tit_acr.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                                 IF NOT AVAIL tt_tit_acr 
                                 THEN DO:
                                      FIND emscad.cliente NO-LOCK
                                          WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                            AND emscad.cliente.cdn_cliente = tt_cliente.cdn_cliente NO-ERROR.
               
                                      CREATE tt_tit_acr.
                                      ASSIGN tt_tit_acr.cod_estab        = renegoc_acr.cod_estab   
                                             tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                                             tt_tit_acr.ind_tip_reg      = "1.Renegociaá∆o"
                                             tt_tit_acr.cdn_cliente      = renegoc_acr.cdn_cliente
                                             tt_tit_acr.nom_cliente      = emscad.cliente.nom_abrev
                                             tt_tit_acr.cod_esp          = ""
                                             tt_tit_acr.cod_ser          = ""
                                             tt_tit_acr.cod_tit_acr      = ""
                                             tt_tit_acr.cod_parcela      = ""
                                             tt_tit_acr.cod_unid_negoc   = val_tit_acr.cod_unid_negoc
                                             tt_tit_acr.val_origin       = renegoc_acr.val_tit_acr
                                             tt_tit_acr.dat_vencto_orig  = ?
                                             tt_tit_acr.dat_vencto_atual = ?
                                             tt_tit_acr.num_id_tit_acr   = 0.
                                 END.

                                 FIND tt_tit_acr NO-LOCK
                                     WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
                                       AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
                                       AND tt_tit_acr.ind_tip_reg    = "3.Gerados"
                                       AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
                                       AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
                                       AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
                                       AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
                                       AND tt_tit_acr.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                                 IF NOT AVAIL tt_tit_acr 
                                 THEN DO:
                                      CREATE tt_tit_acr.
                                      ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab
                                             tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                                             tt_tit_acr.ind_tip_reg      = "3.Gerados"
                                             tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                                             tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                                             tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                                             tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                                             tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                                             tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                                             tt_tit_acr.cod_unid_negoc   = val_tit_acr.cod_unid_negoc
                                             tt_tit_acr.val_origin       = tit_acr.val_origin
                                             tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                                             tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                                             tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.
                                 END.

                             END.

                        END.
                        ELSE DO:

                             FIND tt_tit_acr NO-LOCK
                                 WHERE tt_tit_acr.cod_estab      = renegoc_acr.cod_estab
                                   AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
                                   AND tt_tit_acr.ind_tip_reg    = "1.Renegociaá∆o" 
                                   AND tt_tit_acr.cod_unid_negoc = "" NO-ERROR.
                             IF NOT AVAIL tt_tit_acr 
                             THEN DO:
                                  FIND emscad.cliente NO-LOCK
                                      WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                        AND emscad.cliente.cdn_cliente = tt_cliente.cdn_cliente NO-ERROR.
           
                                  CREATE tt_tit_acr.
                                  ASSIGN tt_tit_acr.cod_estab        = renegoc_acr.cod_estab   
                                         tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                                         tt_tit_acr.ind_tip_reg      = "1.Renegociaá∆o"
                                         tt_tit_acr.cdn_cliente      = renegoc_acr.cdn_cliente
                                         tt_tit_acr.nom_cliente      = emscad.cliente.nom_abrev
                                         tt_tit_acr.cod_esp          = ""
                                         tt_tit_acr.cod_ser          = ""
                                         tt_tit_acr.cod_tit_acr      = ""
                                         tt_tit_acr.cod_parcela      = ""
                                         tt_tit_acr.cod_unid_negoc   = ""
                                         tt_tit_acr.val_origin       = renegoc_acr.val_tit_acr
                                         tt_tit_acr.dat_vencto_orig  = ?
                                         tt_tit_acr.dat_vencto_atual = ?
                                         tt_tit_acr.num_id_tit_acr   = 0.
                             END.

                             FIND tt_tit_acr NO-LOCK
                                 WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
                                   AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
                                   AND tt_tit_acr.ind_tip_reg    = "3.Gerados"
                                   AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
                                   AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
                                   AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
                                   AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
                                   AND tt_tit_acr.cod_unid_negoc = " " NO-ERROR.
                             IF NOT AVAIL tt_tit_acr 
                             THEN DO:
                                  CREATE tt_tit_acr.
                                  ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab   
                                         tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                                         tt_tit_acr.ind_tip_reg      = "3.Gerados"
                                         tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                                         tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                                         tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                                         tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                                         tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                                         tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                                         tt_tit_acr.cod_unid_negoc   = " "
                                         tt_tit_acr.val_origin       = tit_acr.val_origin
                                         tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                                         tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                                         tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.
                             END.

                        END.

                    END.
                    /* ** Atualiza datas no registro da Renegociaá∆o - utilizado for each pois na visualizaá∆o por UN tem mais do que um registro ***/
                    FOR EACH tt_tit_acr NO-LOCK
                        WHERE tt_tit_acr.cod_estab   = renegoc_acr.cod_estab
                          AND tt_tit_acr.num_renegoc = renegoc_acr.num_renegoc
                          AND tt_tit_acr.ind_tip_reg = "1.Renegociaá∆o":
                        ASSIGN tt_tit_acr.dat_vencto_orig  = v_dat_reneg_orig
                               tt_tit_acr.dat_vencto_atual = v_dat_reneg_dest.
                    END.
                    FIND tt_tit_acr_movto NO-LOCK
                        WHERE tt_tit_acr_movto.cod_estab      = renegoc_acr.cod_estab
                          AND tt_tit_acr_movto.num_id_tit_acr = 0
                          AND tt_tit_acr_movto.num_renegoc    = renegoc_acr.num_renegoc NO-ERROR.
                    IF AVAIL tt_tit_acr_movto 
                       THEN ASSIGN tt_tit_acr_movto.dat_vencto_ini = v_dat_reneg_orig
                                   tt_tit_acr_movto.dat_vencto_fim = v_dat_reneg_dest.

                END.

                /* ** Leitura na alteraá∆o dos T°tulos ***/
                dat_block:
                DO v_dat_emis_tit_acr = d_dt_emis_ini TO d_dt_emis_fim:

                    FIND FIRST tit_acr NO-LOCK 
                         WHERE tit_acr.cod_estab       = estabelecimento.cod_estab
                           AND tit_acr.cdn_cliente     = tt_cliente.cdn_cliente
                           AND tit_acr.dat_emis_docto >= v_dat_emis_tit_acr NO-ERROR.
                    IF AVAIL tit_acr
                       THEN ASSIGN v_dat_emis_tit_acr = tit_acr.dat_emis_docto.
                       ELSE LEAVE dat_block.

                    tit_block:
                    FOR EACH tit_acr USE-INDEX titacr_cliente NO-LOCK 
                        WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
                          AND tit_acr.cdn_cliente         = tt_cliente.cdn_cliente
                          AND tit_acr.dat_emis_docto      = v_dat_emis_tit_acr
                          AND tit_acr.dat_vencto_tit_acr >= d_dt_vcto_ini
                          AND tit_acr.dat_vencto_tit_acr <= d_dt_vcto_fim:

                        IF tit_acr.dat_vencto_origin = tit_acr.dat_vencto_tit_acr 
                           THEN NEXT tit_block.

                        IF NOT CAN-FIND(FIRST tt_espec_docto
                                        WHERE tt_espec_docto.tta_cod_espec_docto = tit_acr.cod_espec_docto) 
                           THEN NEXT tit_block.

                        IF CAN-FIND (FIRST movto_tit_acr OF tit_acr NO-LOCK
                                     WHERE movto_tit_acr.ind_trans_acr_abrev = 'TRES')
                           THEN NEXT tit_block.

                        IF rs-tipo = 1 /* ** Visualizaá∆o por Estabelecimento ***/
                        THEN DO:

                             FIND tt_tit_acr NO-LOCK
                                 WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
                                   AND tt_tit_acr.num_renegoc    = 0
                                   AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
                                   AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
                                   AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
                                   AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
                                   AND tt_tit_acr.cod_unid_negoc = " " NO-ERROR.
                             IF AVAIL tt_tit_acr 
                                THEN NEXT tit_block.
                             
                             CREATE tt_tit_acr.
                             ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab   
                                    tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                                    tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                                    tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                                    tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                                    tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                                    tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                                    tt_tit_acr.cod_unid_negoc   = " "
                                    tt_tit_acr.val_origin       = tit_acr.val_origin
                                    tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                                    tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                                    tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.
                                    
                        END.

                        IF rs-tipo = 2 /* ** Visualizaá∆o por UN ***/
                        THEN DO:

                             FOR EACH val_tit_acr OF tit_acr NO-LOCK:

                                 IF LOOKUP(val_tit_acr.cod_unid_negoc,c_cod_un_selec) = 0 
                                    THEN NEXT.

                                 FIND tt_tit_acr NO-LOCK
                                     WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
                                       AND tt_tit_acr.num_renegoc    = 0
                                       AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
                                       AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
                                       AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
                                       AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
                                       AND tt_tit_acr.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                                 IF AVAIL tt_tit_acr 
                                    THEN NEXT tit_block.

                                 CREATE tt_tit_acr.
                                 ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab   
                                        tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                                        tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                                        tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                                        tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                                        tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                                        tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                                        tt_tit_acr.cod_unid_negoc   = val_tit_acr.cod_unid_negoc
                                        tt_tit_acr.val_origin       = tit_acr.val_origin
                                        tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                                        tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                                        tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.

                             END.

                        END.

                        FOR EACH movto_tit_acr OF tit_acr NO-LOCK
                            WHERE movto_tit_acr.ind_trans_acr_abrev = "ADVN":

                            FIND histor_movto_tit_acr NO-LOCK 
                                WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                  AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                  AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr 
                                  AND histor_movto_tit_acr.ind_orig_histor_acr  = "Sistema" NO-ERROR.
                            FIND b_histor_movto_tit_acr NO-LOCK 
                                WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                  AND b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                  AND b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr 
                                  AND b_histor_movto_tit_acr.ind_orig_histor_acr  = "Usuario" NO-ERROR.

                            /* ** Filtro Vendor ***/
                            IF AVAIL b_histor_movto_tit_acr 
                            AND b_histor_movto_tit_acr.des_text_histor = "N∆o Valida"
                            AND l_log_vendor = NO
                                THEN NEXT.

                            CREATE tt_tit_acr_movto.
                            ASSIGN tt_tit_acr_movto.cod_estab      = movto_tit_acr.cod_estab
                                   tt_tit_acr_movto.num_id_tit_acr = movto_tit_acr.num_id_tit_acr
                                   tt_tit_acr_movto.num_renegoc    = 0
                                   tt_tit_acr_movto.dat_transacao  = movto_tit_acr.dat_transacao
                                   tt_tit_acr_movto.cod_usuar      = movto_tit_acr.cod_usuario
                                   tt_tit_acr_movto.des_motivo     = IF AVAIL b_histor_movto_tit_acr THEN (IF b_histor_movto_tit_acr.des_text_histor = "N∆o Valida" THEN "Fechamento Vendor" ELSE b_histor_movto_tit_acr.des_text_histor) ELSE "Hist¢rico n∆o Informado"
                                   tt_tit_acr_movto.dat_vencto_ini = IF AVAIL histor_movto_tit_acr   THEN DATE(SUBSTRING(entry(2,histor_movto_tit_acr.des_text_histor,':'), 1, 10)) ELSE 01/01/0001
                                   tt_tit_acr_movto.dat_vencto_fim = IF AVAIL histor_movto_tit_acr   THEN DATE(SUBSTRING(entry(3,histor_movto_tit_acr.des_text_histor,':'), 1, 10)) ELSE 01/01/0001.

                        END.
                    END.
                END.
            END.
        END.
    END.

    FOR EACH tt_tit_acr:
        IF tt_tit_acr.num_renegoc <> 0 
           THEN NEXT.
        FIND FIRST tt_tit_acr_movto
             WHERE tt_tit_acr_movto.num_id_tit_acr = tt_tit_acr.num_id_tit_acr
               AND tt_tit_acr_movto.num_renegoc    = 0 NO-ERROR.
        IF NOT AVAIL tt_tit_acr_movto 
           THEN DELETE tt_tit_acr.
    END.

END.

PROCEDURE pi_imprime_tt.

    DEFINE VARIABLE v_tot_tit_estab   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_media_estab AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_tit_geral   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_media_geral AS DECIMAL     NO-UNDO.


   VIEW STREAM STREAM_1 FRAME f-cabec.
   VIEW STREAM STREAM_1 FRAME f-rodape.

   IF v_log_gerac_planilha = YES 
      THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "Ini").
   
   IF rs-tipo = 1 /* ** Visualizaá∆o por Estabelecimento ***/
   THEN DO:   

        FOR EACH tt_tit_acr USE-INDEX tt_tit
            BREAK BY tt_tit_acr.cod_estab:
    
            IF tt_tit_acr.num_renegoc = 0
            OR tt_tit_acr.ind_tip_reg = '1.Renegociaá∆o'
               THEN ASSIGN v_tot_tit_estab   =  v_tot_tit_estab   + 1
                           v_tot_media_estab = (v_tot_media_estab + (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig))
                           v_tot_tit_geral   =  v_tot_tit_geral   + 1
                           v_tot_media_geral = (v_tot_media_geral + (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig)).
    
            IF FIRST-OF(tt_tit_acr.cod_estab)
            THEN DO:
    
                 FIND estabelecimento NO-LOCK
                     WHERE estabelecimento.cod_estab = tt_tit_acr.cod_estab NO-ERROR.
    
                 IF (LINE-COUNTER(stream_1) + 6) > 59 
                    THEN PAGE STREAM stream_1.
    
                 PUT STREAM STREAM_1 UNFORMATTED
                      SKIP(1)
                      "Estabelecimento: "
                      tt_tit_acr.cod_estab 
                      " - "
                      estabelecimento.nom_abrev
                      SKIP(1).
                 PUT STREAM STREAM_1 UNFORMATTED
                      "Est Renegoc. Tipo           Cliente   Nome            Esp Ser T°tulo     P/ UN  Valor Original  Vcto Orig  Vcto Atual Prazo Usu†rio    Dt Trans   Hist¢rico                      Data De:   Data Para: Prazo"    SKIP
                      "--- -------- -------------- --------- --------------- --- --- ---------- -- --- --------------- ---------- ---------- ----- ---------- ---------- ------------------------------ ---------- ---------- -----"
                       SKIP.
    
            END.
    
            RUN pi_verifica_quebra.
    
            IF v_log_gerac_planilha = YES 
               THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "put_tit").
    
            PUT STREAM STREAM_1 UNFORMATTED 
                 tt_tit_acr.cod_estab        AT 01  FORMAT "x(3)"
                 tt_tit_acr.num_renegoc      TO 12
                 tt_tit_acr.ind_tip_reg      AT 14  FORMAT "x(14)"
                 tt_tit_acr.cdn_cliente      TO 37 
                 tt_tit_acr.nom_cliente      AT 39  FORMAT "x(15)"
                 tt_tit_acr.cod_esp          AT 55  FORMAT "x(03)"
                 tt_tit_acr.cod_ser          AT 59  FORMAT "x(03)"
                 tt_tit_acr.cod_tit_acr      AT 63  FORMAT "x(10)"
                 tt_tit_acr.cod_parcela      AT 74  FORMAT "x(02)"
                 tt_tit_acr.cod_unid_negoc   AT 77  FORMAT "x(03)"
                 tt_tit_acr.val_origin       TO 95  FORMAT "->>>,>>>,>>9.99"
                 tt_tit_acr.dat_vencto_orig  AT 97  FORMAT "99/99/9999"
                 tt_tit_acr.dat_vencto_atual AT 108 FORMAT "99/99/9999"
                 (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig) TO 123 FORMAT "->>>9"
                 SKIP.
    
            FOR EACH tt_tit_acr_movto
                WHERE tt_tit_acr_movto.num_id_tit_acr = tt_tit_acr.num_id_tit_acr
                  AND tt_tit_acr_movto.num_renegoc    = tt_tit_acr.num_renegoc:
    
                RUN pi_verifica_quebra.

                ASSIGN tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~r',' ')
                       tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~n',' ')
                       tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~t',' ').
    
                IF v_log_gerac_planilha = YES 
                   THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "put_hist").
    
                PUT STREAM STREAM_1 UNFORMATTED 
                     tt_tit_acr_movto.cod_usuar      AT 125 FORMAT "x(10)"              
                     tt_tit_acr_movto.dat_transacao  AT 136 FORMAT "99/99/9999"              
                     tt_tit_acr_movto.des_motivo     AT 147 FORMAT "x(30)"              
                     tt_tit_acr_movto.dat_vencto_ini AT 178 FORMAT "99/99/9999"              
                     tt_tit_acr_movto.dat_vencto_fim AT 189 FORMAT "99/99/9999"              
                     (tt_tit_acr_movto.dat_vencto_fim - tt_tit_acr_movto.dat_vencto_ini) TO 204 FORMAT "->>>9"
                     SKIP.
    
            END.
    
            IF LAST-OF(tt_tit_acr.cod_estab)
            THEN DO:
    
                 IF (LINE-COUNTER(stream_1) + 2) > 59 
                    THEN PAGE STREAM stream_1.
    
                 PUT STREAM STREAM_1 UNFORMATTED
                      SKIP(1)
                      "Total T°tulos Estabelecimento: "        AT 01
                      v_tot_tit_estab FORMAT ">>>>>9"          TO 37
                      " - MÇdia Prorrogaá∆o Estabelecimento: " AT 40
                      (v_tot_media_estab / v_tot_tit_estab) FORMAT "->>>>>9.99"       TO 87
                      SKIP.
    
                 ASSIGN v_tot_tit_estab   = 0
                        v_tot_media_estab = 0.
    
            END.
    
        END.
    
        IF (LINE-COUNTER(stream_1) + 2) > 59 
           THEN PAGE STREAM stream_1.
    
        PUT STREAM STREAM_1 UNFORMATTED
             SKIP(1)
             "Total Geral T°tulos: "             AT 01
             v_tot_tit_geral FORMAT ">>>>>9"     TO 27
             " - MÇdia Geral Prorrogaá∆o: "      AT 30
             (v_tot_media_geral / v_tot_tit_geral) FORMAT "->>>>>9.99"  TO 67
             SKIP.

   END.
   IF rs-tipo = 2 /* ** Visualizaá∆o por UN ***/
   THEN DO:   

        FOR EACH tt_tit_acr USE-INDEX tt_tit_un
            BREAK BY tt_tit_acr.cod_unid_negoc:

            IF tt_tit_acr.num_renegoc = 0
            OR tt_tit_acr.ind_tip_reg = '1.Renegociaá∆o'
               THEN ASSIGN v_tot_tit_estab   =  v_tot_tit_estab   + 1
                           v_tot_media_estab = (v_tot_media_estab + (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig))
                           v_tot_tit_geral   =  v_tot_tit_geral   + 1
                           v_tot_media_geral = (v_tot_media_geral + (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig)).

            IF FIRST-OF(tt_tit_acr.cod_unid_negoc)
            THEN DO:

                 FIND unid_negoc NO-LOCK
                     WHERE unid_negoc.cod_unid_negoc = tt_tit_acr.cod_unid_negoc NO-ERROR.

                 IF (LINE-COUNTER(stream_1) + 6) > 59 
                    THEN PAGE STREAM stream_1.

                 PUT STREAM STREAM_1 UNFORMATTED
                      SKIP(1)
                      "Unidade de Neg¢cio: "
                      tt_tit_acr.cod_unid_negoc 
                      " - "
                      unid_negoc.des_unid_negoc
                      SKIP(1).
                 PUT STREAM STREAM_1 UNFORMATTED
                      "Est Renegoc. Tipo           Cliente   Nome            Esp Ser T°tulo     P/ UN  Valor Original  Vcto Orig  Vcto Atual Prazo Usu†rio    Dt Trans   Hist¢rico                      Data De:   Data Para: Prazo"    SKIP
                      "--- -------- -------------- --------- --------------- --- --- ---------- -- --- --------------- ---------- ---------- ----- ---------- ---------- ------------------------------ ---------- ---------- -----"
                       SKIP.

            END.

            RUN pi_verifica_quebra_un.

            IF v_log_gerac_planilha = YES 
               THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "put_tit").

            PUT STREAM STREAM_1 UNFORMATTED 
                 tt_tit_acr.cod_estab        AT 01  FORMAT "x(3)"
                 tt_tit_acr.num_renegoc      TO 12 
                 tt_tit_acr.ind_tip_reg      AT 14  FORMAT "x(14)"
                 tt_tit_acr.cdn_cliente      TO 37  
                 tt_tit_acr.nom_cliente      AT 39  FORMAT "x(15)"
                 tt_tit_acr.cod_esp          AT 55  FORMAT "x(03)"
                 tt_tit_acr.cod_ser          AT 59  FORMAT "x(03)"
                 tt_tit_acr.cod_tit_acr      AT 63  FORMAT "x(10)"
                 tt_tit_acr.cod_parcela      AT 74  FORMAT "x(02)"
                 tt_tit_acr.cod_unid_negoc   AT 77  FORMAT "x(03)"
                 tt_tit_acr.val_origin       TO 95  FORMAT "->>>,>>>,>>9.99"
                 tt_tit_acr.dat_vencto_orig  AT 97  FORMAT "99/99/9999"
                 tt_tit_acr.dat_vencto_atual AT 108 FORMAT "99/99/9999"
                 (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig) TO 123 FORMAT "->>>9"
                 SKIP.

            FOR EACH tt_tit_acr_movto
                WHERE tt_tit_acr_movto.num_id_tit_acr = tt_tit_acr.num_id_tit_acr
                  AND tt_tit_acr_movto.num_renegoc    = tt_tit_acr.num_renegoc:

                RUN pi_verifica_quebra_un.

                ASSIGN tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~r',' ')
                       tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~n',' ')
                       tt_tit_acr_movto.des_motivo = REPLACE(tt_tit_acr_movto.des_motivo,'~t',' ').

                IF v_log_gerac_planilha = YES 
                   THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "put_hist").

                PUT STREAM STREAM_1 UNFORMATTED 
                     tt_tit_acr_movto.cod_usuar      AT 125 FORMAT "x(10)"              
                     tt_tit_acr_movto.dat_transacao  AT 136 FORMAT "99/99/9999"              
                     tt_tit_acr_movto.des_motivo     AT 147 FORMAT "x(30)"              
                     tt_tit_acr_movto.dat_vencto_ini AT 178 FORMAT "99/99/9999"              
                     tt_tit_acr_movto.dat_vencto_fim AT 189 FORMAT "99/99/9999"              
                     (tt_tit_acr_movto.dat_vencto_fim - tt_tit_acr_movto.dat_vencto_ini) TO 204 FORMAT "->>>9"
                     SKIP.

            END.

            IF LAST-OF(tt_tit_acr.cod_unid_negoc)
            THEN DO:

                 IF (LINE-COUNTER(stream_1) + 2) > 59 
                    THEN PAGE STREAM stream_1.

                 PUT STREAM STREAM_1 UNFORMATTED
                      SKIP(1)
                      "Total T°tulos Unidade: "        AT 01
                      v_tot_tit_estab FORMAT ">>>>>9"          TO 37
                      " - MÇdia Prorrogaá∆o Unidade: " AT 40
                      (v_tot_media_estab / v_tot_tit_estab) FORMAT "->>>>>9.99"       TO 87
                      SKIP.

                 ASSIGN v_tot_tit_estab   = 0
                        v_tot_media_estab = 0.

            END.

        END.

        IF (LINE-COUNTER(stream_1) + 2) > 59 
           THEN PAGE STREAM stream_1.

        PUT STREAM STREAM_1 UNFORMATTED
             SKIP(1)
             "Total Geral T°tulos: "             AT 01
             v_tot_tit_geral FORMAT ">>>>>9"     TO 27
             " - MÇdia Geral Prorrogaá∆o: "      AT 30
             (v_tot_media_geral / v_tot_tit_geral) FORMAT "->>>>>9.99"  TO 67
             SKIP.

   END.

   IF v_log_gerac_planilha = YES 
      THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "close").

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */

PROCEDURE pi_verifica_quebra:
    
    IF (LINE-COUNTER(stream_1) + 1) > 59 
    THEN DO:
         PAGE STREAM stream_1.
         PUT STREAM STREAM_1 UNFORMATTED
              SKIP(1)
              "Estabelecimento: "
              tt_tit_acr.cod_estab 
              " - "
              estabelecimento.nom_abrev 
              SKIP(1).
         PUT STREAM STREAM_1 UNFORMATTED
              "Est Renegoc. Tipo           Cliente   Nome            Esp Ser T°tulo     P/ UN  Valor Original  Vcto Orig  Vcto Atual Prazo Usu†rio    Dt Trans   Hist¢rico                      Data De:   Data Para: Prazo"    SKIP
              "--- -------- -------------- --------- --------------- --- --- ---------- -- --- --------------- ---------- ---------- ----- ---------- ---------- ------------------------------ ---------- ---------- -----"
               SKIP.
    END.

END.

PROCEDURE pi_verifica_quebra_un:
    
    IF (LINE-COUNTER(stream_1) + 1) > 59 
    THEN DO:
         PAGE STREAM stream_1.
         PUT STREAM STREAM_1 UNFORMATTED
              SKIP(1)
              "Unidade de Neg¢cio: "
              tt_tit_acr.cod_unid_negoc 
              " - "
              unid_negoc.des_unid_negoc
              SKIP(1).
         PUT STREAM STREAM_1 UNFORMATTED
              "Est Renegoc. Tipo           Cliente   Nome            Esp Ser T°tulo     P/ UN  Valor Original  Vcto Orig  Vcto Atual Prazo Usu†rio    Dt Trans   Hist¢rico                      Data De:   Data Para: Prazo"    SKIP
              "--- -------- -------------- --------- --------------- --- --- ---------- -- --- --------------- ---------- ---------- ----- ---------- ---------- ------------------------------ ---------- ---------- -----"
               SKIP.
    END.

END.

PROCEDURE pi_rpt_aberto_gerac_planilha:

    /************************ Parameter Definition Begin ************************/

    DEF INPUT PARAM p_ind_tipo AS CHARACTER FORMAT "X(10)" NO-UNDO.

    /************************* Parameter Definition End *************************/

    /* ** GERA PLANILHA ***/
    IF p_ind_tipo = "Ini" /*l_INI*/  
    THEN DO:
         /* ** IMPRIME OS LABELS E ABRE A STREAM ***/
         OUTPUT STREAM s_planilha TO VALUE(v_cod_arq_planilha) CONVERT TARGET 'iso8859-1'.
         PUT STREAM s_planilha UNFORMATTED  "Est"            + v_cod_carac_lim +
                                            "Reneg"          + v_cod_carac_lim +
                                            "Tipo"           + v_cod_carac_lim +
                                            "Cliente"        + v_cod_carac_lim +
                                            "Nome"           + v_cod_carac_lim +
                                            "Esp"            + v_cod_carac_lim +
                                            "Ser"            + v_cod_carac_lim +
                                            "T°tulo"         + v_cod_carac_lim +
                                            "P/"             + v_cod_carac_lim +
                                            "UN"             + v_cod_carac_lim +
                                            "Valor Original" + v_cod_carac_lim +
                                            "Vcto Orig"      + v_cod_carac_lim +
                                            "Vcto Atual"     + v_cod_carac_lim +
                                            "Prazo"          + v_cod_carac_lim +
                                            "Usu†rio"        + v_cod_carac_lim +
                                            "Dt Trans"       + v_cod_carac_lim +
                                            "Hist¢rico"      + v_cod_carac_lim +
                                            "Data De:"       + v_cod_carac_lim +
                                            "Data Para:"     + v_cod_carac_lim +
                                            "Prazo" SKIP.
         RETURN.
    END.

    IF p_ind_tipo = "put_tit" 
    THEN DO:
         PUT STREAM s_planilha UNFORMATTED 
              tt_tit_acr.cod_estab        v_cod_carac_lim 
              tt_tit_acr.num_renegoc      v_cod_carac_lim 
              tt_tit_acr.ind_tip_reg      v_cod_carac_lim 
              tt_tit_acr.cdn_cliente      v_cod_carac_lim
              tt_tit_acr.nom_cliente      v_cod_carac_lim
              tt_tit_acr.cod_esp          v_cod_carac_lim
              tt_tit_acr.cod_ser          v_cod_carac_lim
              tt_tit_acr.cod_tit_acr      v_cod_carac_lim
              tt_tit_acr.cod_parcela      v_cod_carac_lim
              tt_tit_acr.cod_unid_negoc   v_cod_carac_lim
              tt_tit_acr.val_origin       v_cod_carac_lim
              tt_tit_acr.dat_vencto_orig  v_cod_carac_lim
              tt_tit_acr.dat_vencto_atual v_cod_carac_lim
              (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig) SKIP.
         RETURN.
    END.

    IF p_ind_tipo = "put_hist" 
    THEN DO:
         PUT STREAM s_planilha UNFORMATTED 
              tt_tit_acr.cod_estab            v_cod_carac_lim
              tt_tit_acr.num_renegoc          v_cod_carac_lim 
              tt_tit_acr.ind_tip_reg          v_cod_carac_lim 
              tt_tit_acr.cdn_cliente          v_cod_carac_lim
              tt_tit_acr.nom_cliente          v_cod_carac_lim
              tt_tit_acr.cod_esp              v_cod_carac_lim
              tt_tit_acr.cod_ser              v_cod_carac_lim
              tt_tit_acr.cod_tit_acr          v_cod_carac_lim
              tt_tit_acr.cod_parcela          v_cod_carac_lim
              tt_tit_acr.cod_unid_negoc       v_cod_carac_lim
              tt_tit_acr.val_origin           v_cod_carac_lim
              tt_tit_acr.dat_vencto_orig      v_cod_carac_lim
              tt_tit_acr.dat_vencto_atual     v_cod_carac_lim
              (tt_tit_acr.dat_vencto_atual - tt_tit_acr.dat_vencto_orig) v_cod_carac_lim
              tt_tit_acr_movto.cod_usuar      v_cod_carac_lim
              tt_tit_acr_movto.dat_transacao  v_cod_carac_lim
              tt_tit_acr_movto.des_motivo     v_cod_carac_lim
              tt_tit_acr_movto.dat_vencto_ini v_cod_carac_lim
              tt_tit_acr_movto.dat_vencto_fim v_cod_carac_lim
              (tt_tit_acr_movto.dat_vencto_fim - tt_tit_acr_movto.dat_vencto_ini)
             SKIP.
         RETURN.
    END.

    IF p_ind_tipo = "close"
    THEN DO:
         OUTPUT STREAM s_planilha CLOSE.
         RETURN.
    END.

END PROCEDURE.


PROCEDURE Pi-Abre-Edit:
  DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
  DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

  GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
  if V_Cod_Key_Value = "" OR 
     V_Cod_Key_Value = ?  THEN 
  DO.
    ASSIGN V_Cod_Key_Value = 'start'.
    PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.  /* End da Procedure Pi-Abre-Edit */

/*IF  I-Num-Ped-Exec-Rpw <> 0 THEN
    RETURN "OK".*/

PROCEDURE pi_gera_tt_titulos_renegoc_acr:

    DEF BUFFER b_movto_tit_acr FOR movto_tit_acr.

    DEF VAR v_cod_estab_tit_acr_pai    AS CHAR.
    DEF VAR v_num_id_movto_tit_acr_pai AS INT.

    FIND b_movto_tit_acr NO-LOCK  
       WHERE b_movto_tit_acr.cod_estab           = movto_tit_acr.cod_estab
         AND b_movto_tit_acr.num_id_tit_acr      = movto_tit_acr.num_id_tit_acr
         AND b_movto_tit_acr.ind_trans_acr_abrev = "TRES" NO-ERROR.
    IF AVAIL b_movto_tit_acr
    THEN DO:
         ASSIGN v_cod_estab_tit_acr_pai    = b_movto_tit_acr.cod_estab_tit_acr_pai
                v_num_id_movto_tit_acr_pai = b_movto_tit_acr.num_id_movto_tit_acr_pai.
         FIND b_movto_tit_acr NO-LOCK  
            WHERE b_movto_tit_acr.cod_estab            = v_cod_estab_tit_acr_pai
              AND b_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr_pai USE-INDEX mvtttcr_token NO-ERROR.
         FIND tit_acr NO-LOCK 
            WHERE tit_acr.cod_estab      = b_movto_tit_acr.cod_estab 
              AND tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr USE-INDEX titacr_token NO-ERROR.
    END.
    ELSE DO:
         FIND tit_acr NO-LOCK 
            WHERE tit_acr.cod_estab      = movto_tit_acr.cod_estab 
              AND tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr USE-INDEX titacr_token NO-ERROR.
    END.

    IF tit_acr.dat_vencto_origin < v_dat_reneg_orig 
       THEN ASSIGN v_dat_reneg_orig = tit_acr.dat_vencto_origin.

    IF tit_acr.dat_vencto_origin > v_dat_reneg_dest
       THEN ASSIGN v_dat_reneg_dest = tit_acr.dat_vencto_origin.

    IF rs-tipo = 2 /* ** Visualizaá∆o por UN ***/
    THEN DO:

         FOR EACH val_tit_acr OF tit_acr NO-LOCK:

             IF LOOKUP(val_tit_acr.cod_unid_negoc,c_cod_un_selec) = 0 
                THEN NEXT.

             FIND tt_tit_acr NO-LOCK
                 WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
                   AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
                   AND tt_tit_acr.ind_tip_reg    = "2.Origem"
                   AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
                   AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
                   AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
                   AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
                   AND tt_tit_acr.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
             IF AVAIL tt_tit_acr 
                THEN NEXT.

             CREATE tt_tit_acr.
             ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab
                    tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                    tt_tit_acr.ind_tip_reg      = "2.Origem"
                    tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                    tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                    tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                    tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                    tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                    tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                    tt_tit_acr.cod_unid_negoc   = val_tit_acr.cod_unid_negoc
                    tt_tit_acr.val_origin       = tit_acr.val_origin
                    tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                    tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                    tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.

         END.

    END.
    ELSE DO:

         FIND tt_tit_acr NO-LOCK
             WHERE tt_tit_acr.cod_estab      = tit_acr.cod_estab  
               AND tt_tit_acr.num_renegoc    = renegoc_acr.num_renegoc
               AND tt_tit_acr.ind_tip_reg    = "2.Origem"
               AND tt_tit_acr.cod_esp        = tit_acr.cod_esp    
               AND tt_tit_acr.cod_ser        = tit_acr.cod_ser    
               AND tt_tit_acr.cod_tit_acr    = tit_acr.cod_tit_acr
               AND tt_tit_acr.cod_parcela    = tit_acr.cod_parcela
               AND tt_tit_acr.cod_unid_negoc = " " NO-ERROR.
         IF AVAIL tt_tit_acr 
            THEN NEXT.

         CREATE tt_tit_acr.
         ASSIGN tt_tit_acr.cod_estab        = tit_acr.cod_estab   
                tt_tit_acr.num_renegoc      = renegoc_acr.num_renegoc
                tt_tit_acr.ind_tip_reg      = "2.Origem"
                tt_tit_acr.cdn_cliente      = tit_acr.cdn_cliente
                tt_tit_acr.nom_cliente      = tit_acr.nom_abrev
                tt_tit_acr.cod_esp          = tit_acr.cod_esp    
                tt_tit_acr.cod_ser          = tit_acr.cod_ser    
                tt_tit_acr.cod_tit_acr      = tit_acr.cod_tit_acr
                tt_tit_acr.cod_parcela      = tit_acr.cod_parcela
                tt_tit_acr.cod_unid_negoc   = " "
                tt_tit_acr.val_origin       = tit_acr.val_origin
                tt_tit_acr.dat_vencto_orig  = tit_acr.dat_vencto_origin
                tt_tit_acr.dat_vencto_atual = tit_acr.dat_vencto_tit
                tt_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr.

    END.

    FIND histor_movto_tit_acr NO-LOCK 
        WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
          AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
          AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr 
          AND histor_movto_tit_acr.ind_orig_histor_acr  = "Usu†rio" NO-ERROR.

    FIND tt_tit_acr_movto NO-LOCK
        WHERE tt_tit_acr_movto.cod_estab      = renegoc_acr.cod_estab
          AND tt_tit_acr_movto.num_id_tit_acr = 0
          AND tt_tit_acr_movto.num_renegoc    = renegoc_acr.num_renegoc NO-ERROR.

    IF AVAIL histor_movto_tit_acr
    THEN DO:

         IF NOT AVAIL tt_tit_acr_movto 
         THEN DO:

              CREATE tt_tit_acr_movto.
              ASSIGN tt_tit_acr_movto.cod_estab      = renegoc_acr.cod_estab
                     tt_tit_acr_movto.num_id_tit_acr = 0
                     tt_tit_acr_movto.num_renegoc    = renegoc_acr.num_renegoc
                     tt_tit_acr_movto.dat_transacao  = movto_tit_acr.dat_transacao
                     tt_tit_acr_movto.cod_usuar      = movto_tit_acr.cod_usuario
                     tt_tit_acr_movto.des_motivo     = IF histor_movto_tit_acr.des_text_histor <> "" THEN histor_movto_tit_acr.des_text_histor ELSE "Hist¢rico n∆o Informado".

         END.
    END.

END PROCEDURE.

PROCEDURE pi_cria_teste:

    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '999'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '993'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '994'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '994'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '994'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '997'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '998'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
        
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '994'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '997'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '998'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '997'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '998'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '997'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '998'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '994'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '996'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '997'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.
    
    CREATE tt_tit_acr.
    ASSIGN tt_tit_acr.cod_estab       = '998'
    tt_tit_acr.cdn_cliente     = 999999999
    tt_tit_acr.nom_cliente     = '123456789012345'
    tt_tit_acr.cod_esp         = '123'
    tt_tit_acr.cod_ser         = '123'
    tt_tit_acr.cod_tit_acr     = '1234567890'
    tt_tit_acr.cod_parcela     = '01'
    tt_tit_acr.cod_unid_negoc  = '123'
    tt_tit_acr.val_origin      = 34567890.99
    tt_tit_acr.dat_vencto_orig = 01/01/0001
    tt_tit_acr.dat_vencto_atual = 12/31/9999.




END.
