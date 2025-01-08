 /*****************************************************************************
**     Programa.........: esp/apb/esapb022rp.p
**     Descricao .......: Relat¢rio Fedex
**     Versao...........: 1.00.000
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 09/03/2010
*******************************************************************************/

def new global shared var v_cod_usuar_corren          as character    format "x(12)":U   label "Usu rio Corrente"     column-label "Usu rio Corrente" no-undo.

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOGI   INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOGI   NO-UNDO.
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

DEF VAR v_log_gerac_planilha AS LOG.
DEF VAR v_cod_arq_planilha   AS CHAR.
DEF VAR v_cod_carac_lim      AS CHAR.
DEFINE VARIABLE v_nom_usuar AS CHARACTER FORMAT "x(15)"  NO-UNDO.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/
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
DEF VAR Ch_Linha                AS CHAR FORM "x(256)" NO-UNDO.

DEF STREAM Stream_1.
DEF STREAM s_planilha.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEFINE VARIABLE v_dat_ini        LIKE fedex.data-sol      NO-UNDO.
DEFINE VARIABLE v_dat_fim        LIKE fedex.data-sol      NO-UNDO.
DEFINE VARIABLE v_dat_rec_ini    LIKE fedex.dt-rec        NO-UNDO.
DEFINE VARIABLE v_dat_rec_fim    LIKE fedex.dt-rec        NO-UNDO.
DEFINE VARIABLE v_cod_msg_ini    LIKE fedex.cod-mensagem  NO-UNDO.
DEFINE VARIABLE v_cod_msg_fim    LIKE fedex.cod-mensagem  NO-UNDO.
DEFINE VARIABLE v_cod_usuar_ini  LIKE fedex.cod_usuario   NO-UNDO.
DEFINE VARIABLE v_cod_usuar_fim  LIKE fedex.cod_usuario   NO-UNDO.
DEFINE VARIABLE v_cod_conhec_ini LIKE fedex.conhecimento  NO-UNDO.
DEFINE VARIABLE v_cod_conhec_fim LIKE fedex.conhecimento  NO-UNDO.
DEFINE VARIABLE v_cod_transp_ini LIKE fedex.cod-transp    NO-UNDO.
DEFINE VARIABLE v_cod_transp_fim LIKE fedex.cod-transp    NO-UNDO.
DEFINE VARIABLE v_cod_emp_ini    LIKE fedex.empresa       NO-UNDO.
DEFINE VARIABLE v_cod_emp_fim    LIKE fedex.empresa       NO-UNDO.
DEFINE VARIABLE v_cod_estab_ini  LIKE fedex.cod_estab     NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim  LIKE fedex.cod_estab     NO-UNDO.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 215.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR.

IF V_Cod_Dwb_User = '' 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esapb022rp'
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.

    ASSIGN V_Cod_Dwb_File       = Ped_Exec_Param.Cod_Dwb_File
           V_Cod_Dwb_Output     = Ped_Exec_Param.Cod_Dwb_Output
           C-Impressora         = Ped_Exec_Param.Nom_Dwb_Printer
           C-Layout             = Ped_Exec_Param.Cod_Dwb_Print_Layout
           v_dat_ini            = DATE(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_dat_fim            = DATE(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_msg_ini        = INT(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_msg_fim        = INT(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_usuar_ini      = ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_usuar_fim      = ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_conhec_ini     = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_conhec_fim     = ENTRY(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_transp_ini     = INT(ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_transp_fim     = INT(ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_emp_ini        = ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_emp_fim        = ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_log_gerac_planilha = (ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           v_cod_arq_planilha   = ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_carac_lim      = ENTRY(16,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_estab_ini      = ENTRY(17,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           v_cod_estab_fim      = ENTRY(18,dwb_set_list_param.cod_dwb_parameters,CHR(10)) 
           v_dat_rec_ini        = date(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           v_dat_rec_fim        = date(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.

  END. /* End do IF AVAIL Ped_Exec_Param */


  FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
  IF AVAIL ped_exec THEN DO:
     FIND FIRST servid_exec WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-LOCK NO-ERROR.
     IF AVAIL servid_exec THEN DO:
         IF servid_exec.ind_tip_fila_exec = 'unix' THEN
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '/' + V_Cod_Dwb_File.
         ELSE
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '~\' + V_Cod_Dwb_File.
     END.
  END.

END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esapb022rp'
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File       = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output     = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora         = Dwb_Set_list_Param.nom_Dwb_Printer
           C-Layout             = dwb_set_list_param.Cod_dwb_print_layout
           v_dat_ini            = DATE(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_dat_fim            = DATE(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_msg_ini        = INT(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_msg_fim        = INT(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_usuar_ini      = ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_usuar_fim      = ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_conhec_ini     = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_conhec_fim     = ENTRY(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_transp_ini     = INT(ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_transp_fim     = INT(ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v_cod_emp_ini        = ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_emp_fim        = ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10))  
           v_log_gerac_planilha = (ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           v_cod_arq_planilha   = ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_carac_lim      = ENTRY(16,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_estab_ini      = ENTRY(17,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           v_cod_Estab_fim      = ENTRY(18,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           v_dat_rec_ini        = date(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           v_dat_rec_fim        = date(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.


  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + 'esapb022.lst'.
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

ASSIGN C-Programa          = "ESAPB022"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Courrier"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       C-Empresa           = "Intelbras"
       Ch_Linha            = FILL("-",256).

def frame fCabec256 header
    fill("-",256) AT 1 FORMAT "x(256)" SKIP
    c-empresa at 1 format "x(40)"
    c-titulo-relat AT 99 FORMAT "x(20)"
    "P gina: " at 242 (page-number (Stream_1)) to 256 format ">>9" 
    skip
    fill("-",233) AT 1 FORMAT "x(233)"
    TODAY AT 235 FORMAT "99/99/9999"
    "-" at 246
    String(TIME,"HH:MM:SS") at 249 skip (1)
    with no-box no-labels width 256 page-top stream-io.
  
def frame fRodape256 header
    skip (1)
    fill("-",237) FORMAT "x(237)" AT 1
    C-Programa FORMAT 'x(08)' at 238
    "-" at 247
    "1.00.000" at 249 skip
    with no-box no-labels width 256 page-bottom stream-io.

ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat.

    IF v_log_gerac_planilha = YES 
       THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "Ini").

    VIEW STREAM Stream_1 FRAME fCabec256.
    VIEW STREAM Stream_1 FRAME fRodape256.

    FOR EACH fedex NO-LOCK:

        IF fedex.data-sol     < v_dat_ini
        OR fedex.data-sol     > v_dat_fim
        OR fedex.dt-rec       < v_dat_rec_ini
        OR fedex.dt-rec       > v_dat_rec_fim
        OR fedex.cod-mensagem < v_cod_msg_ini
        OR fedex.cod-mensagem > v_cod_msg_fim
        OR fedex.cod_usuario  < v_cod_usuar_ini
        OR fedex.cod_usuario  > v_cod_usuar_fim
        OR fedex.conhecimento < v_cod_conhec_ini
        OR fedex.conhecimento > v_cod_conhec_fim
        OR fedex.cod-transp   < v_cod_transp_ini
        OR fedex.cod-transp   > v_cod_transp_fim
        OR fedex.empresa      < v_cod_emp_ini
        OR fedex.empresa      > v_cod_emp_fim
        OR fedex.cod_estab    < v_cod_estab_ini
        OR fedex.cod_estab    > v_cod_estab_fim
           THEN NEXT.

        FIND usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = fedex.cod_usuario NO-ERROR.
        IF AVAIL usuar_mestre 
           THEN ASSIGN v_nom_usuar = usuar_mestre.nom_usuario.
           ELSE ASSIGN v_nom_usuar = "Eliminado".

        IF v_log_gerac_planilha = YES 
        THEN DO:
             RUN pi_rpt_aberto_gerac_planilha (INPUT "put_tit").
             RUN pi_rpt_aberto_gerac_planilha (INPUT "put_rateio").
        END.

        DISP STREAM Stream_1
                    fedex.data-sol      LABEL "Data Solic"
                    fedex.cod-mensagem  LABEL "Mot"
                    fedex.cod_usuario   LABEL "Usu rio"
                    v_nom_usuar         LABEL "Nome"
                    fedex.conhecimento  LABEL "Conhecimento"
                    fedex.tipo          LABEL "Tipo"
                    fedex.cod-transp    LABEL "Transp"
                    fedex.empresa       LABEL "Empresa"  FORMAT "x(25)"
                    fedex.cod_estab     LABEL "Estab" FORMAT "X(3)"
                    fedex.material      LABEL "Material" FORMAT "x(45)"
                    fedex.lancado-frete LABEL "Imp"
                    fedex.valor-frete   LABEL "Valor"
                    fedex.lancado-imp   LABEL "Frete"
                    fedex.valor-imp     LABEL "Valor"               
                    fedex.recebido      LABEL "Rec"
                    fedex.dt-rec        LABEL "Data Receb"
                    fedex.encerrado     LABEL "Enc"
                    fedex.duties        LABEL "Impto S/R/T"
                    fedex.freight       LABEL "Frete S/R/T"
                    WITH WIDTH 256 NO-LABEL STREAM-IO.

    END.

    IF v_log_gerac_planilha = YES 
       THEN RUN pi_rpt_aberto_gerac_planilha (INPUT "close").

END PROCEDURE.

PROCEDURE pi_rpt_aberto_gerac_planilha:

    /************************ Parameter Definition Begin ************************/

    DEF INPUT PARAM p_ind_tipo AS CHARACTER FORMAT "X(10)" NO-UNDO.

    /************************* Parameter Definition End *************************/

    /* ** GERA PLANILHA ***/
    IF p_ind_tipo = "Ini" /*l_INI*/  
    THEN DO:
         /* ** IMPRIME OS LABELS E ABRE A STREAM ***/
         OUTPUT STREAM s_planilha TO VALUE(v_cod_arq_planilha) CONVERT TARGET 'iso8859-1'.
         PUT STREAM s_planilha UNFORMATTED  "Nivel"        v_cod_carac_lim
                                            "Data Solic"   v_cod_carac_lim
                                            "Mot"          v_cod_carac_lim
                                            "Usu rio"      v_cod_carac_lim
                                            "Nome"         v_cod_carac_lim
                                            "Conhecimento" v_cod_carac_lim
                                            "Tipo"         v_cod_carac_lim
                                            "Transp"       v_cod_carac_lim
                                            "Empresa"      v_cod_carac_lim
                                            "Estab"        v_cod_carac_lim
                                            "Material"     v_cod_carac_lim
                                            "Imp"          v_cod_carac_lim
                                            "Valor"        v_cod_carac_lim
                                            "Frete"        v_cod_carac_lim
                                            "Valor"        v_cod_carac_lim
                                            "Rec"          v_cod_carac_lim
                                            "Data Receb"   v_cod_carac_lim
                                            "Enc"          v_cod_carac_lim
                                            "Fat Frete"    v_cod_carac_lim
                                            "Emit Frete"   v_cod_carac_lim
                                            "Emis Frete"   v_cod_carac_lim
                                            "Vcto Frete"   v_cod_carac_lim
                                            "AP Frete"     v_cod_carac_lim
                                            "Fat Imp"      v_cod_carac_lim
                                            "Emit Imp"     v_cod_carac_lim
                                            "Emis Frete"   v_cod_carac_lim
                                            "Vcto Frete"   v_cod_carac_lim
                                            "AP Frete"     v_cod_carac_lim    
                                            "Cta Ctbl"     v_cod_carac_lim
                                            "CCusto"       v_cod_carac_lim
                                            "UN"           v_cod_carac_lim
                                            "% Rateio"     v_cod_carac_lim
                                            "Impto S/R/T"  v_cod_carac_lim
                                            "Frete S/R/T"  v_cod_carac_lim SKIP.
         RETURN.
    END.

    IF p_ind_tipo = "put_tit" 
    THEN DO:
         PUT STREAM s_planilha UNFORMATTED 
                    "Fedex"                v_cod_carac_lim 
                    fedex.data-sol         v_cod_carac_lim 
                    fedex.cod-mensagem     v_cod_carac_lim 
                    fedex.cod_usuario      v_cod_carac_lim 
                    v_nom_usuar            v_cod_carac_lim 
                    fedex.conhecimento     v_cod_carac_lim 
                    fedex.tipo             v_cod_carac_lim 
                    fedex.cod-transp       v_cod_carac_lim 
                    fedex.empresa          v_cod_carac_lim
                    fedex.cod_estab        v_cod_carac_lim
                    fedex.material         v_cod_carac_lim 
                    fedex.lancado-frete    v_cod_carac_lim 
                    fedex.valor-frete      v_cod_carac_lim 
                    fedex.lancado-imp      v_cod_carac_lim 
                    fedex.valor-imp        v_cod_carac_lim 
                    fedex.recebido         v_cod_carac_lim
                    fedex.dt-rec           v_cod_carac_lim
                    fedex.encerrado        v_cod_carac_lim 
                    fedex.fatura-frete     v_cod_carac_lim 
                    fedex.cod-emit-frete   v_cod_carac_lim
                    fedex.dt-emis-frete    v_cod_carac_lim
                    fedex.dt-venc-frete    v_cod_carac_lim
                    fedex.dt-ap-frete      v_cod_carac_lim
                    fedex.fatura-imp       v_cod_carac_lim
                    fedex.cod-emitente-imp v_cod_carac_lim
                    fedex.dt-emis-imp      v_cod_carac_lim
                    fedex.dt-venc-imp      v_cod_carac_lim 
                    fedex.dt-ap-imp        v_cod_carac_lim 
                    v_cod_carac_lim v_cod_carac_lim v_cod_carac_lim v_cod_carac_lim
                    fedex.duties           v_cod_carac_lim
                    fedex.freight SKIP.
         RETURN.
    END.

    IF p_ind_tipo = "put_rateio" 
    THEN DO:
         FOR EACH fedex-rateio OF fedex NO-LOCK:
             PUT STREAM s_planilha UNFORMATTED 
                        "Rateio"                     v_cod_carac_lim 
                        fedex.data-sol               v_cod_carac_lim 
                        fedex.cod-mensagem           v_cod_carac_lim 
                        fedex.cod_usuario            v_cod_carac_lim 
                        v_nom_usuar                  v_cod_carac_lim 
                        fedex.conhecimento           v_cod_carac_lim 
                        fedex.tipo                   v_cod_carac_lim 
                        fedex.cod-transp             v_cod_carac_lim 
                        fedex.empresa                v_cod_carac_lim 
                        fedex.cod_estab              v_cod_carac_lim
                        fedex.material               v_cod_carac_lim 
                        fedex.lancado-frete          v_cod_carac_lim 
                        fedex.valor-frete            v_cod_carac_lim 
                        fedex.lancado-imp            v_cod_carac_lim 
                        fedex.valor-imp              v_cod_carac_lim 
                        fedex.recebido               v_cod_carac_lim
                        fedex.dt-rec                 v_cod_carac_lim
                        fedex.encerrado              v_cod_carac_lim 
                        fedex.fatura-frete           v_cod_carac_lim 
                        fedex.cod-emit-frete         v_cod_carac_lim
                        fedex.dt-emis-frete          v_cod_carac_lim
                        fedex.dt-venc-frete          v_cod_carac_lim
                        fedex.dt-ap-frete            v_cod_carac_lim
                        fedex.fatura-imp             v_cod_carac_lim
                        fedex.cod-emitente-imp       v_cod_carac_lim
                        fedex.dt-emis-imp            v_cod_carac_lim
                        fedex.dt-venc-imp            v_cod_carac_lim 
                        fedex.dt-ap-imp              v_cod_carac_lim       
                        fedex-rateio.cod_cta_ctbl    v_cod_carac_lim 
                        fedex-rateio.cod_ccusto      v_cod_carac_lim  
                        fedex-rateio.cod_unid_negoc  v_cod_carac_lim 
                        fedex-rateio.perc_aprop_ctbl v_cod_carac_lim
                        fedex.duties                 v_cod_carac_lim
                        fedex.freight SKIP.
         END.
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
     END.

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.

