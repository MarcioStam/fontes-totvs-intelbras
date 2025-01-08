/*--------------------------------------------------------------------------------------------------------------------
** Nome Externo .........: esp/fas/esfas012rp.p
** Data Cria‡Æo .........: 17/06/2013
** Criado por ...........: Sensus Tecnologia
----------------------------------------------------------------------------------------------------------------------*/

/*---[ Vari veis Globais ]------------------------------------------------------------*/
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHARACTER FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren      AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Implanta              AS LOGI   INIT NO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS LOGI   NO-UNDO.
DEF NEW GLOBAL SHARED VAR R-Registro-Atual        AS ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR C-Arquivo-Log           AS CHAR   FORM "x(60)"NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped               AS INTE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR H_Prog_Segur_Estab      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Num_Tip_Aces_Usuar    AS INTE   NO-UNDO.     
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR C-Dir-Spool-Servid-Exec AS CHAR   NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS INTE   NO-UNDO.

DEFINE NEW SHARED STREAM s_1.

/*---[ Tabelas Tempor rias ]----------------------------------------------------------*/
def temp-table tt_erro no-undo
    field ttv_des_chave_tab as character format "x(40)"    label "Chave"         column-label "Chave"
    field ttv_num_mensagem  as integer   format ">>>>,>>9" label "N£mero"        column-label "N£mero Mensagem"
    field ttv_des_msg_erro  as character format "x(40)"    label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_help      as character format "x(60)"    label "Ajuda"         column-label "Ajuda".


/*---[ importa dados da planilha, carregando temp-tables ]----------------------------*/
DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc  AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux  AS CHAR FORM "x(60)" INIT " " NO-UNDO.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/
DEF VAR V_Cod_Empresa              LIKE emscad.empresa.Cod_Empresa NO-UNDO.
DEF VAR I                          AS   INTE NO-UNDO.
DEF VAR V_Cod_Dwb_File             LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output           LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora               LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                   LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR H-Hacr155                  AS   HANDLE NO-UNDO.
DEF VAR V-Cod-Destino-Impres       AS   CHAR   NO-UNDO.
DEF VAR V-Num-Reg-Lidos            AS   INTE   NO-UNDO.
DEF VAR V-Num-Point                AS   INTE   NO-UNDO.
DEF VAR V-Num-Set                  AS   INTE   NO-UNDO.
DEF VAR V-Cod-Arquivo              AS   CHAR.
DEF VAR V-Num-Tip-Reg              AS   INTE FORM "999".
DEF VAR C-Empresa                  AS   CHAR FORM "x(40)"  NO-UNDO.
DEF VAR C-Titulo-Relat             AS   CHAR FORM "x(50)"  NO-UNDO.
DEF VAR C-Sistema                  AS   CHAR FORM "x(25)"  NO-UNDO.
DEF VAR C-Rodape                   AS   CHAR               NO-UNDO.
DEF VAR C-Programa                 AS   CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Versao                   AS   CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao                  AS   CHAR FORM "999"    NO-UNDO.
DEF VAR V_Num_Pag                  AS   INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                   AS   CHAR FORM "x(132)" NO-UNDO.
DEF VAR ccod_estab_ini             like bem_pat.cod_estab                no-undo.
DEF VAR ccod_estab_fim             like bem_pat.cod_estab                no-undo.
DEF VAR ccod_cta_pat_ini           like bem_pat.cod_cta_pat              no-undo.
DEF VAR ccod_cta_pat_fim           like bem_pat.cod_cta_pat              no-undo.
DEF VAR ccod_ccusto_atual_ini      like bem_pat.cod_ccusto_respons       no-undo.
DEF VAR ccod_ccusto_atual_fim      like bem_pat.cod_ccusto_respons       no-undo.
DEF VAR ccod_ccusto_inventario_ini like bem_pat.cod_ccusto_respons       no-undo.
DEF VAR ccod_ccusto_inventario_fim like bem_pat.cod_ccusto_respons       no-undo.
DEF VAR inum_inventario_ini        like histor_inventario.num_inventario no-undo.
DEF VAR inum_inventario_fim        like histor_inventario.num_inventario no-undo.
DEF VAR ddat_inventario_ini        like histor_inventario.dat_trans      no-undo. 
DEF VAR ddat_inventario_fim        like histor_inventario.dat_trans      no-undo.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_s_1_Lines   AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_s_1_Columns AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_s_1_Bottom  AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_s_1_Page    AS INTE.
DEF NEW SHARED VAR V_Rpt_s_1_Name    AS CHAR.

IF V_Cod_Dwb_User = '' THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF  V_Num_Ped_Exec_Corren > 0 THEN DO.
    FIND Ped_Exec_Param NO-LOCK
        WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
    IF  AVAIL Ped_Exec_Param THEN DO.
        FIND Dwb_Set_List_Param NO-LOCK
            WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas012rp'
            AND   Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
        
        ASSIGN V_Cod_Dwb_File             = Ped_Exec_Param.Cod_Dwb_File
               V_Cod_Dwb_Output           = Ped_Exec_Param.Cod_Dwb_Output
               C-Impressora               = Ped_Exec_Param.Nom_Dwb_Printer
               C-Layout                   = Ped_Exec_Param.Cod_Dwb_Print_Layout
               ccod_estab_ini             =         ENTRY(2, dwb_set_list_param.cod_dwb_parameters,chr(10))          
               ccod_estab_fim             =         ENTRY(3, dwb_set_list_param.cod_dwb_parameters,chr(10))          
               ccod_cta_pat_ini           =         ENTRY(4, dwb_set_list_param.cod_dwb_parameters,chr(10))          
               ccod_cta_pat_fim           =         ENTRY(5, dwb_set_list_param.cod_dwb_parameters,chr(10))    
               ccod_ccusto_atual_ini      =         ENTRY(6, dwb_set_list_param.cod_dwb_parameters,chr(10)) 
               ccod_ccusto_atual_fim      =         ENTRY(7, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_inventario_ini =         ENTRY(8, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_inventario_fim =         ENTRY(9, dwb_set_list_param.cod_dwb_parameters,chr(10))
               inum_inventario_ini        = integer(ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               inum_inventario_fim        = integer(ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               ddat_inventario_ini        =    date(ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               ddat_inventario_fim        =    date(ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               NO-ERROR.                                                                                  

    END. /* End do IF AVAIL Ped_Exec_Param */
    
    FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
    IF  AVAIL ped_exec THEN DO:
        FIND FIRST servid_exec WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-LOCK NO-ERROR.
        IF  AVAIL servid_exec THEN DO:
            IF  servid_exec.ind_tip_fila_exec = 'unix' 
            THEN ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '/' + V_Cod_Dwb_File.
            ELSE ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '~\' + V_Cod_Dwb_File.
        END. /* IF  AVAIL servid_exec THEN DO: */
    END. /* IF  AVAIL ped_exec THEN DO: */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE DO.
    FIND Dwb_Set_List_Param NO-LOCK
        WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas012rp'
        AND   Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
    IF  AVAIL Dwb_Set_List_Param THEN DO.
        ASSIGN V_Cod_Dwb_File             = Dwb_Set_list_Param.Cod_Dwb_File             
               V_Cod_Dwb_Output           = Dwb_Set_list_Param.Cod_Dwb_Output           
               C-Impressora               = Dwb_Set_list_Param.nom_Dwb_Printer
               C-Layout                   = dwb_set_list_param.Cod_dwb_print_layout
               ccod_estab_ini             =         ENTRY(2, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_estab_fim             =         ENTRY(3, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_cta_pat_ini           =         ENTRY(4, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_cta_pat_fim           =         ENTRY(5, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_atual_ini      =         ENTRY(6, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_atual_fim      =         ENTRY(7, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_inventario_ini =         ENTRY(8, dwb_set_list_param.cod_dwb_parameters,chr(10))
               ccod_ccusto_inventario_fim =         ENTRY(9, dwb_set_list_param.cod_dwb_parameters,chr(10))
               inum_inventario_ini        = integer(ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               inum_inventario_fim        = integer(ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               ddat_inventario_ini        =    date(ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               ddat_inventario_fim        =    date(ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
               NO-ERROR.                                                                                  
    END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN DO.
         ASSIGN V_Cod_Dwb_File   = session:temp-directory + 'esfas012.lst'.
         OUTPUT STREAM s_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.
    END.
    WHEN "Impressora" /*l_Printer*/  THEN DO.
         FIND Imprsor_Usuar NO-LOCK
             WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora
             AND   Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User USE-INDEX imprsrsr_id NO-ERROR.
         FIND layout_impres NO-LOCK
             WHERE Layout_Impres.Nom_Impressora    = C-Impressora
             AND   Layout_Impres.Cod_Layout_Impres = C-Layout NO-ERROR.
         ASSIGN V_Rpt_s_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_s_1_Bottom - V_Rpt_s_1_Lines */
                V_Rpt_s_1_Lines  = Layout_Impres.Num_Lin_Pag.

         IF  OPSYS = "UNIX" THEN DO.
             IF  V_Num_Ped_Exec_Corren <> 0 THEN DO.
                 FIND Ped_Exec NO-LOCK
                     WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
                 IF  AVAIL Ped_Exec THEN DO.
                     FIND Servid_Exec_Imprsor NO-LOCK
                         WHERE Servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec
                         AND   Servid_Exec_Imprsor.Nom_Impressora  = C-Impressora NO-ERROR.
                     IF  AVAIL Servid_Exec_Imprsor 
                     THEN OUTPUT STREAM s_1 THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.
                     ELSE OUTPUT STREAM s_1 THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)       PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.
                 END. /* End do - IF AVAIL ped_Exec */
             END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
             ELSE OUTPUT STREAM s_1 THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.
         END. /* End do - IF OPSYS = "UNIX" */
         ELSE OUTPUT STREAM s_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.

         FOR EACH  Configur_Layout_Impres NO-LOCK
             WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
             FIND Configur_Tip_imprsor NO-LOCK
                 WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
                 AND   Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
                 AND   Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor NO-ERROR.
             
             PUT STREAM s_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
         END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
    END. /* End do - WHEN "Impressora" l_Printer */
    WHEN "Arquivo" /*l_File*/  THEN DO.
         OUTPUT STREAM s_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET 'iso8859-1'.
    END. /* End do - WHEN "Arquivo" - l_File  */
  END. /* End do - CASE V_Cod_Dwb_Output */
END. /* End do - DO. -- Que seta a saida da impressao */

ASSIGN C-Programa     = "esfas012"
       C-Versao       = "1.00"
       C-Revisao      = "001"
       C-Titulo-Relat = "Hist¢rico de Invent rios"
       V_Rpt_s_1_Name = C-Titulo-Relat
       C-Sistema      = "ESP"
       C-Empresa      = "Intelbras"
       Ch_Linha       = FILL("-",132).


/*---[ PROCEDURES ]-----------------------------------------------------------------*/
EMPTY TEMP-TABLE tt_erro NO-ERROR.
RUN pi-relatorio.

OUTPUT STREAM s_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/*---[ pi-relatorio ]-----------------------------------------------------------*/
PROCEDURE pi-relatorio:

    PUT STREAM s_1 UNFORMATTED "Emp;Cta Patrimonial;Bem;Seq.;Descri‡Æo;Estab Atual;Estab Inv.;CCusto Atual;CCusto Inv.;UN Atual;UN Inv.;Nr.Invent;Dt.Transf.;Usuar.Ult.Atual;Dt.Ult.Atual;Hr.Ult.Atual;Hist¢rico":U SKIP.
    
    blk_bem:
    FOR EACH  bem_pat NO-LOCK
        WHERE bem_pat.cod_empresa  = v_cod_empres_usuar
        AND   bem_pat.cod_estab   >= ccod_estab_ini
        AND   bem_pat.cod_estab   <= ccod_estab_fim
        AND   bem_pat.cod_cta_pat >= ccod_cta_pat_ini
        AND   bem_pat.cod_cta_pat <= ccod_cta_pat_fim
        AND   bem_pat.cod_ccusto_respons >= ccod_ccusto_atual_ini
        AND   bem_pat.cod_ccusto_respons <= ccod_ccusto_atual_fim:

        blk_hist:
        FOR EACH  histor_inventario NO-LOCK
            WHERE histor_inventario.cod_empresa         = bem_pat.cod_empresa
            AND   histor_inventario.cod_cta_pat         = bem_pat.cod_cta_pat
            AND   histor_inventario.num_bem_pat         = bem_pat.num_bem_pat
            AND   histor_inventario.num_seq_bem_pat     = bem_pat.num_seq_bem_pat:

            IF  histor_inventario.cod_ccusto_respons < ccod_ccusto_inventario_ini
            OR  histor_inventario.cod_ccusto_respons > ccod_ccusto_inventario_fim THEN NEXT blk_hist.

            IF  histor_inventario.num_inventario < inum_inventario_ini
            OR  histor_inventario.num_inventario > inum_inventario_fim THEN NEXT blk_hist.

            IF  histor_inventario.dat_trans < ddat_inventario_ini
            OR  histor_inventario.dat_trans > ddat_inventario_fim THEN NEXT blk_hist.
        
            PUT STREAM s_1 UNFORMATTED
                histor_inventario.cod_empresa           ";"
                histor_inventario.cod_cta_pat           ";"
                histor_inventario.num_bem_pat           ";"
                histor_inventario.num_seq_bem_pat       ";"
                bem_pat.des_bem_pat                     ";"
                bem_pat.cod_estab                       ";"
                histor_inventario.cod_livre_1           ";"
                bem_pat.cod_ccusto_respons              ";"
                histor_inventario.cod_ccusto_respons    ";"
                bem_pat.cod_unid_negoc                  ";"
                histor_inventario.cod_unid_negoc        ";"
                histor_inventario.num_inventario        ";"
                STRING(histor_inventario.dat_transf, "99/99/9999")      ";"
                histor_inventario.cod_usuar_ult_atualiz ";"
                STRING(histor_inventario.dat_ult_atualiz, "99/99/9999") ";"
                STRING(histor_inventario.hra_ult_atualiz, "99:99:9999") ";"
                histor_inventario.cod_livre_2           SKIP.

        END.
    END. /* FOR EACH  bem_pat NO-LOCK */

END. /* PROCEDURE pi-relatorio:*/

/*---[ Pi-Abre-Edit ]-----------------------------------------------------------------*/
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

  OS-COMMAND NO-WAIT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE. /* PROCEDURE Pi-Abre-Edit: */

/*---[ pi_messages ]------------------------------------------------------------------*/
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
                "Programa Mensagem" c_prg_msg "n’o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
