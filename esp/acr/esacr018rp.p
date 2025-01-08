/*****************************************************************************
**     Programa.........: esp/acr/esacr018rp.p
**     Descricao .......: Acerto Previs∆o de Comiss‰es
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualizaá∆o: 
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
DEF VAR l_baixa        AS LOG NO-UNDO.
DEF VAR Ifor_ini       AS INT FORMAT "9999999" INIT 0 NO-UNDO.
DEF VAR Ifor_fim       AS INT FORMAT "9999999" INIT 0 NO-UNDO.
DEF VAR dt_ini         AS DATE FORMAT "99/99/9999" no-undo.
DEF VAR dt_fim         AS DATE FORMAT "99/99/9999" no-undo.
DEF VAR c_dp_ini       AS CHAR FORMAT "X(10)".
DEF VAR c_dp_fim       AS CHAR FORMAT "X(10)".
DEF VAR c_parc_ini     AS CHAR FORMAT "X(2)".
DEF VAR c_parc_fim     AS CHAR FORMAT "X(2)".
DEF VAR l_erro         AS LOG.
DEF VAR da-data        LIKE nota-fiscal.dt-cancel.
DEF VAR da-data1       AS DATE.

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

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Acerto Previs∆o de Comiss‰es".

def frame f-cabec header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 52 format 'x(40)'
    'P†gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.

def frame f-rodape header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec°ficos Intelbr†s - esacr018 - V:5.00.00.000' SKIP
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

IF V_Num_Ped_Exec_Corren > 0 THEN DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr018"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File    = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output  = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora      = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout          = Ped_Exec_Param.Cod_Dwb_Print_Layout
          i_proc            = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          l_baixa           = logical(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)),"yes/no")
          Ifor_ini          = INTEGER(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          Ifor_fim          = INTEGER(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          dt_ini            = DATE(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          dt_fim            = DATE(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c_dp_ini          = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_dp_fim          = ENTRY(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_parc_ini        = ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_parc_fim        = ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr018"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           i_proc           = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l_baixa          = logical(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)),"yes/no") 
           Ifor_ini         = INTEGER(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           Ifor_fim         = INTEGER(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           dt_ini           = DATE(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           dt_fim           = DATE(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c_dp_ini          = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_dp_fim          = ENTRY(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_parc_ini        = ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_parc_fim        = ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)).

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
       C-Titulo-Relat      = "Acerto Previs∆o de Comiss‰es"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */ 

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
        
    RUN elim_tt.


    
    PUT STREAM STREAM_1 "Esp ; Ser ; Titulo     ; Par; Representante   ; Nome Cliente                         ; Gr.Cli.; Fornec.     ; DT Trans   ;            Saldo; DT Canc NF ; Erro       ; Data/Hora  ;" SKIP.
    PUT STREAM STREAM_1 "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP.

    FOR EACH tit_ap NO-LOCK 
        WHERE tit_ap.cod_estab        = v_cod_estab_usuar
        AND   tit_ap.cod_espec_docto  = 'CPE'
        AND   tit_ap.LOG_sdo_tit_ap = YES
        AND   tit_ap.val_sdo_tit_ap  <> 0
        AND   tit_ap.dat_transacao   >= dt_ini
        AND   tit_ap.dat_transacao   <= dt_fim
        AND   tit_ap.cod_tit_ap      >= c_dp_ini
        AND   tit_ap.cod_tit_ap      <= c_dp_fim
        AND   tit_ap.cod_parcela     >= c_parc_ini
        AND   tit_ap.cod_parcela     <= c_parc_fim
        AND   tit_ap.log_tit_ap_estordo = NO 
        AND   tit_ap.cdn_fornecedor  >= Ifor_ini
        AND   tit_ap.cdn_fornecedor  <= Ifor_fim:

        FIND FIRST emscad.fornecedor NO-LOCK 
             WHERE emscad.fornecedor.cod_empresa    = tit_ap.cod_empresa 
               AND emscad.fornecedor.cdn_fornecedor = tit_ap.cdn_fornecedor NO-ERROR.

        FIND FIRST representante
             WHERE representante.cod_empresa = tit_ap.cod_empresa
             AND   representante.num_pessoa = emscad.fornecedor.num_pessoa
             NO-LOCK NO-ERROR.
        IF NOT AVAIL representante THEN NEXT.
        
        FIND FIRST repres_financ OF representante NO-LOCK
             WHERE repres_financ.log_pagto_bloqdo = YES 
             NO-ERROR.
        
        FIND FIRST movto_tit_acr NO-LOCK
             WHERE movto_tit_acr.cod_estab            = v_cod_estab_usuar
             AND   movto_tit_acr.num_id_movto_tit_acr = int(SUBSTR(tit_ap.cod_refer,2,9))
             NO-ERROR.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = movto_tit_acr.cdn_cliente 
             NO-ERROR.

        IF AVAIL repres_financ AND l_baixa = NO or
           NOT AVAIL repres_financ THEN DO:

           FIND FIRST tit_acr OF movto_tit_acr 
                WHERE tit_acr.val_sdo_tit_acr <> 0 NO-LOCK NO-ERROR.

           IF AVAIL tit_acr THEN NEXT.
        END.

        ASSIGN DA-DATA = ?.

        FOR FIRST nota-fiscal NO-LOCK
             WHERE (nota-fiscal.cod-estabel = v_cod_estab_usuar
             AND    nota-fiscal.serie       = "3"
             AND    nota-fiscal.nr-nota-fis = tit_ap.cod_tit_ap) 
              OR   (nota-fiscal.cod-estabel = v_cod_estab_usuar
             AND    nota-fiscal.serie       = "1"
             AND    nota-fiscal.nr-nota-fis = tit_ap.cod_tit_ap)
              OR   (nota-fiscal.cod-estabel = v_cod_estab_usuar
             AND    nota-fiscal.serie       = "5"
             AND    nota-fiscal.nr-nota-fis = tit_ap.cod_tit_ap):
            ASSIGN da-data = nota-fiscal.dt-cancel.
        END.

        ASSIGN cont_fornec   = cont_fornec + 1
               cont_abert    = cont_abert + 1
               val_tot_abert = val_tot_abert + tit_ap.val_sdo_tit_ap.

        DISP cont_abert WITH FRAME a. PAUSE 0.
        PUT STREAM Stream_1
            tit_ap.cod_espec_docto  ' ; '
            tit_ap.cod_ser_docto    ' ; '
            tit_ap.cod_tit_ap       ' ; '
            tit_ap.cod_parcela      ' ; '
            representante.nom_abrev ' ; '
            emitente.nome-emit      ' ; '
            emitente.cod-gr-cli     ' ; '
            tit_ap.cdn_fornec       ' ; '
            tit_ap.dat_transacao    ' ; '
            tit_ap.val_sdo_tit_ap   ' ; '
            da-data                 ' ; '.
            
        IF i_proc = 1 THEN DO:
           RUN api_cria_tt.

           RUN roda_api (OUTPUT l_erro).

           RUN elim_tt.
        END. 

        
        IF i_proc = 1 THEN DO:
           IF l_erro = YES THEN
              PUT STREAM Stream_1 ' ERRO ;'.
           ELSE
              PUT STREAM Stream_1 ' sem ERRO* ;'.
        END.
        ELSE 
            PUT STREAM Stream_1 '      ;'.

        PUT STREAM Stream_1 ' ; 'string(time,'hh:mm:ss') ' ;' SKIP.

    END.
END PROCEDURE.


PROCEDURE roda_api:

    DEF OUTPUT PARAM p_erro AS LOG INITIAL NO NO-UNDO.

    IF i_proc = 1 THEN DO:
        FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.                    
        IF AVAIL tt_tit_ap_alteracao_base_1 THEN DO:                                                                        
         RUN prgfin/apb/apb767zc.py (INPUT 1,                                      
                                     INPUT "APB",                                  
                                     INPUT '',        /*cod_matriz_trad_org_ext*/  
                                     INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                     INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                     OUTPUT TABLE tt_log_erros_tit_ap_alteracao).  
                                                                                   
        END.
    
        FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK 
            WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542 NO-ERROR.

        IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
           ASSIGN p_erro = YES.
           FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK
               WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542:
               PUT STREAM s_erro
                   tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor                ' ; '
                   tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto               ' ; '
                   tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto                 ' ; '
                   tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap                    ' ; '
                   tt_log_erros_tit_ap_alteracao.tta_cod_parcela                   ' ; '
                   tt_log_erros_tit_ap_alteracao.ttv_num_mensagem                  ' ; '
                   tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro                  ' ; '
                   STRING(tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda,'x(50)') ' ; '
                   SKIP.
               DELETE tt_log_erros_tit_ap_alteracao.
           END.
        END.
        ELSE 
           ASSIGN p_erro = NO.
    END.
END. /*roda_api*/

PROCEDURE elim_tt:
   FOR EACH tt_tit_ap_alteracao_base_1:
       DELETE tt_tit_ap_alteracao_base_1.
   END.

   FOR EACH tt_tit_ap_alteracao_rateio:
       DELETE tt_tit_ap_alteracao_rateio.
   END.

   FOR EACH tt_log_erros_tit_ap_alteracao:
       DELETE tt_log_erros_tit_ap_alteracao.
   END.
END.

PROCEDURE api_cria_tt:

    RUN pi-referencia (OUTPUT v_cod_refer).
    
    CREATE tt_tit_ap_alteracao_base_1.
    ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             = v_cod_usuar_corren 
           tt_tit_ap_alteracao_base_1.tta_cod_empresa                  =  v_cod_empres_usuar
           tt_tit_ap_alteracao_base_1.tta_cod_estab                    =  tit_ap.cod_estab
           tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap                =  tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                   =  RECID(tt_tit_ap_alteracao_base_1)
           tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor               =  tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_1.tta_cod_espec_docto              =  tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_1.tta_cod_ser_docto                =  tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                   =  tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_1.tta_cod_parcela                  =  tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_1.ttv_dat_transacao                =  TODAY
           tt_tit_ap_alteracao_base_1.ttv_cod_refer                    =  v_cod_refer
           tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap               =  0
           tt_tit_ap_alteracao_base_1.tta_dat_emis_docto               =  ?
           tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap            =  ?
           tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto               =  ?
           tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto                =  ?                  
           tt_tit_ap_alteracao_base_1.tta_num_dias_atraso              =  tit_ap.num_dias_atraso
           tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso        =  tit_ap.val_perc_multa_atraso
           tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso         =  tit_ap.val_juros_dia_atraso
           tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso    =  tit_ap.val_perc_juros_dia_atraso
           tt_tit_ap_alteracao_base_1.tta_dat_desconto                 =  ?
           tt_tit_ap_alteracao_base_1.tta_val_perc_desc                =  tit_ap.val_perc_desc      
           tt_tit_ap_alteracao_base_1.tta_val_desconto                 =  tit_ap.val_desconto   
           tt_tit_ap_alteracao_base_1.tta_cod_portador                 =  tit_ap.cod_portador     
           tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov             =  ""                 
           tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo             =  tit_ap.log_pagto_bloqdo
           tt_tit_ap_alteracao_base_1.tta_cod_seguradora               =  tit_ap.cod_seguradora  
           tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro              =  tit_ap.cod_apol_seguro
           tt_tit_ap_alteracao_base_1.tta_cod_arrendador               =  tit_ap.cod_arrendador   
           tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas             =  tit_ap.cod_contrat_leas  
           tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto          =  tit_ap.ind_tip_espec_docto 
           tt_tit_ap_alteracao_base_1.tta_cod_indic_econ               =  tit_ap.cod_indic_econ  
           tt_tit_ap_alteracao_base_1.tta_num_seq_refer                =  2
           tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap   =  "Alteraá∆o"
           tt_tit_ap_alteracao_base_1.ttv_wgh_lista                    =  ?           
           tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores  =  NO                 
           tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor        =  ""
           tt_tit_ap_alteracao_base_1.tta_cod_histor_padr              =  ""
           tt_tit_ap_alteracao_base_1.tta_des_histor_padr              =  ''
           tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               =  tit_ap.ind_sit_tit_ap    
           tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              =  tit_ap.cod_forma_pagto   
           tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                =  "" .
END. /*api_cria_tt*/

PROCEDURE pi-referencia :
    
    DEF OUTPUT PARAM p_cod_refer LIKE movto_tit_ap.cod_refer NO-UNDO.

    DEF VAR v_data_aux  AS CHAR            NO-UNDO.
    DEF VAR v_num_aux   AS INTEGER         NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER         NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER         NO-UNDO. 
    DEF VAR v_cod_refer  LIKE movto_tit_ap.cod_refer NO-UNDO.

    REPEAT:
      ASSIGN v_cod_refer = 'CMS'.
      DO v_num_cont = 1 TO 7:
         ASSIGN v_num_aux_2 = integer(this-procedure:handle)
                v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
                v_cod_refer = v_cod_refer + chr(v_num_aux).    
      END.
             
      FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK
           WHERE tt_tit_ap_alteracao_base_1.tta_cod_estab_ext = tit_ap.cod_estab                                                                                           
             AND tt_tit_ap_alteracao_base_1.ttv_cod_refer     = v_cod_refer NO-ERROR.
      FIND FIRST movto_tit_ap                                                                                                                                            
           WHERE movto_tit_ap.cod_estab   = tit_ap.cod_estab
             AND movto_tit_ap.cod_refer =  v_cod_refer NO-LOCK NO-ERROR.
      IF NOT AVAIL movto_tit_ap AND NOT AVAIL  tt_tit_ap_alteracao_base_1 THEN                                                                                              
        LEAVE.
    END.
    ASSIGN p_cod_refer = v_cod_refer.
    
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

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".
