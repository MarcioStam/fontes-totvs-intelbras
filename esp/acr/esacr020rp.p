/*****************************************************************************
**     Programa.........: esp/acr/esacr020rp.p
**     Descricao .......: Acerto PrevisÆo de Comissäes
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/

DEF VAR cont_abert     AS INT INITIAL 0.
DEF VAR cont_dif       AS INT INITIAL 0.
DEF VAR cont_fornec    AS INT INITIAL 0.
DEF VAR val_tot_abert  LIKE tit_ap.val_sdo_tit_ap.
DEF VAR v_cod_refer    AS CHAR NO-UNDO. 
DEF VAR v_nom_arq      AS CHAR INITIAL 'c:\temp\ava_CPO.txt'.
DEF VAR v_nom_arq_erro AS CHAR INITIAL 'c:\temp\ava_CPO_erro.txt'.
DEF VAR i_proc         AS INT  INITIAL 1.
DEF VAR l_erro         AS LOG.
DEF VAR da-data        LIKE nota-fiscal.dt-cancel.
DEF VAR da-data1       AS DATE.
DEF VAR c-ser-docto    LIKE tit_ap.cod_ser_docto.

/* Temp-table API Alteracao titulo */
{esp/cms/apb767zc.i}

DEF STREAM s_acom.
DEF STREAM s_erro.

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
    label "Grupo Usu rios"
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
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
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
    label 'Grupo Usu rios' 
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
    label 'Pa¡s Empresa Usu rio'
    column-label 'Pa¡s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu rio Corrente'
    column-label 'Usu rio Corrente'
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

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/

DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
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

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Acerto PrevisÆo de Comissäes".

def frame f-cabec header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 52 format 'x(40)'
    'P gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.

def frame f-rodape header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec¡ficos Intelbr s - esacr018 - V:5.00.00.000' SKIP
    with no-box no-labels width 132 page-bottom stream-io.

FIND emscad.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF AVAIL empresa THEN
    ASSIGN v_nom_enterprise   = empresa.nom_razao_social.
ELSE
    ASSIGN v_nom_enterprise   = 'DATASUL'.

ASSIGN C-Empresa = "XXXXXXXXXXXXXXX".

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr020"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File    = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output  = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora      = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout          = Ped_Exec_Param.Cod_Dwb_Print_Layout
          i_proc            = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr020"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           i_proc           = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr018.lst".
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
                                     
ASSIGN C-Programa          = "esacr018"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Acerto PrevisÆo de Comissäes"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.  /* Imprime relat¢rio em formato padrÆo EMS 5 */ 

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

OUTPUT STREAM s_erro TO VALUE(v_nom_arq_erro).
   
PROCEDURE piImprimeRelat:
    VIEW STREAM STREAM_1 FRAME f-cabec.
    VIEW STREAM STREAM_1 FRAME f-rodape.
    
    IF i_proc = 2 THEN
       PUT STREAM Stream_1
           ' Pesquisa ' SKIP.
    ELSE 
       PUT STREAM Stream_1
           ' Processando ... ' string(time,'hh:mm:ss') ' ' SKIP.
    
    PUT STREAM Stream_1
        "Esp ; Ser ; Titulo     ; Pr ; Dt Transac ; Dt  Vencto ; Repres  ; Nome Represent  ; Cliente     ; Nome Cliente    ; Fornecedor  ; Nome Fornecedor ; %Comis ;   Saldo Titulo ; Sdo ;" SKIP.
    FOR EACH tit_acr FIELDS(tit_acr.cod_estab       tit_acr.num_id_tit_acr  tit_acr.cod_portador 
                            tit_acr.cod_espec_docto tit_acr.cod_ser_docto   tit_acr.cod_tit_acr 
                            tit_acr.cod_parcela     tit_acr.dat_transacao   tit_acr.dat_vencto_tit_acr 
                            tit_acr.val_sdo_tit_acr tit_acr.LOG_sdo_tit_acr tit_acr.cdn_cliente
                            tit_acr.nom_abrev) NO-LOCK
        WHERE tit_acr.cod_estab       = v_cod_estab_usuar
        AND   tit_acr.LOG_sdo_tit_acr = YES 
        AND   tit_acr.LOG_tit_acr_estordo = NO,
        EACH repres_tit_acr fields(repres_tit_acr.cod_empresa repres_tit_acr.cdn_repres repres_tit_acr.val_perc_comis_repres) NO-LOCK
             WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
             AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
             AND repres_tit_acr.val_perc_comis_repres > 0:
    
        IF tit_acr.cod_espec_docto = "dm" OR tit_acr.cod_espec_docto = "vem" then
           ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
        ELSE                                    
           ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
    
        FIND FIRST representante NO-LOCK
             WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
             AND representante.cdn_repres    = repres_tit_acr.cdn_repres NO-ERROR.
    
        FIND FIRST emscad.fornecedor NO-LOCK 
             WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
             AND emscad.fornecedor.num_pessoa    = representante.num_pessoa 
             USE-INDEX frncdr_empr_pessoa NO-ERROR.
        
        IF CAN-find(FIRST tit_ap NO-LOCK                                                                                                 
             WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
             AND   tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
             AND   tit_ap.cod_espec_docto = "CPE"                                                                                 
             AND   tit_ap.cod_ser_docto   = c-ser-docto
             AND   tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr                                                                   
             AND   tit_ap.cod_parcela     = tit_acr.cod_parcela) THEN 
           NEXT.
           
        /*Valida Representante - Mario Fleith 02/06/2005*/
        FIND FIRST repres_financ OF representante NO-LOCK
             WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.
        IF AVAIL repres_financ THEN 
           NEXT.
    
           /*valida portador*/
        FIND FIRST int-portador NO-LOCK
             WHERE int-portador.cod_portador = tit_acr.cod_portador
             AND int-portador.log_considera_comissao = YES NO-ERROR.
        IF NOT AVAIL int-portador THEN
           NEXT.
    
        FIND FIRST int_espec_docto_financ_acr NO-LOCK
             WHERE int_espec_docto_financ_acr.cod_espec_docto = tit_acr.cod_espec_docto
             AND   int_espec_docto_financ_acr.log_gera_comissao = YES NO-ERROR.
        IF NOT AVAIL int_espec_docto_financ_acr THEN
           NEXT.
        
        IF i_proc = 1 THEN DO:
           FIND FIRST movto_tit_acr OF tit_acr NO-LOCK 
                WHERE movto_tit_acr.ind_trans_acr_abrev = "impl" NO-ERROR.

           RUN esp/cms/escms001.p (RECID(movto_tit_acr),         
                                   INPUT "").                       
        END.
        PUT STREAM Stream_1
            tit_acr.cod_espec_docto    ' ; '
            tit_acr.cod_ser_docto      ' ; '
            tit_acr.cod_tit_acr        ' ; '
            tit_acr.cod_parcela        ' ; '
            tit_acr.dat_transacao      ' ; '
            tit_acr.dat_vencto_tit_acr ' ; '
            repres_tit_acr.cdn_repres  ' ; '
            representante.nom_abrev    ' ; '
            tit_acr.cdn_cliente        ' ; ' 
            tit_acr.nom_abrev          ' ; '
            emscad.fornecedor.cdn_fornecedor ' ; '
            emscad.fornecedor.nom_abrev  ' ; '
            repres_tit_acr.val_perc_comis_repres ' ; '
            tit_acr.val_sdo_tit_acr    ' ; ' 
            tit_acr.LOG_sdo_tit_acr    ' ; ' SKIP.
        LEAVE.
    END.
END.

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

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".
