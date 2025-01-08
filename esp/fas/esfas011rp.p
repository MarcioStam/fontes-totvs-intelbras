/*--------------------------------------------------------------------------------------------------------------------
** Nome Externo .........: esp/fas/esfas011rp.p
** Data Criaá∆o .........: 17/06/2013
** Criado por ...........: Sensus Tecnologia
----------------------------------------------------------------------------------------------------------------------*/

/*---[ Vari†veis Globais ]------------------------------------------------------------*/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar      AS CHARACTER FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE L-Implanta              AS LOGI   INIT NO.
DEFINE NEW GLOBAL SHARED VARIABLE I-Num-Ped-Exec-Rpw      AS INTE   NO-UNDO.   
DEFINE NEW GLOBAL SHARED VARIABLE I-Pais-Impto-Usuario    AS INTE   FORM ">>9" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE L-Rpc                   AS LOGI   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE R-Registro-Atual        AS ROWID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE C-Arquivo-Log           AS CHAR   FORM "x(60)"NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE I-Num-Ped               AS INTE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE H_Prog_Segur_Estab      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE V_Num_Tip_Aces_Usuar    AS INTE   NO-UNDO.     
DEFINE NEW GLOBAL SHARED VARIABLE V_Num_Ped_Exec_Corren   AS INTE   FORM ">>>>>9" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE V_Cod_Dwb_User          AS CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEFINE NEW GLOBAL SHARED VARIABLE C-Dir-Spool-Servid-Exec AS CHAR   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE I-Num-Ped-Exec-Rpw      AS INTE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_pais_empres_usuar AS CHAR FORMAT "x(3)":U LABEL "Pa°s Empresa Usu†rio" COLUMN-LABEL "Pa°s" NO-UNDO.

/*---[ Tabelas Tempor†rias ]----------------------------------------------------------*/
DEFINE TEMP-TABLE ttbem_pat NO-UNDO 
    FIELD num_inventario     LIKE histor_inventario.num_inventario
    FIELD cod_cta_pat        LIKE bem_pat.cod_cta_pat
    FIELD num_bem_pat        LIKE bem_pat.num_bem_pat
    FIELD num_seq_bem_pat    LIKE bem_pat.num_seq_bem_pat
    FIELD cod_ccusto_respons LIKE bem_pat.cod_ccusto_respons
    FIELD cod_unid_negoc     LIKE bem_pat.cod_unid_negoc
    FIELD cod_estab          LIKE bem_pat.cod_estab
    FIELD dat_transf         AS DATE
    FIELD cod_localiz        LIKE bem_pat.cod_localiz.

DEFINE TEMP-TABLE tt_erro NO-UNDO
    field ttv_des_chave_tab as character format "x(40)"    label "Chave"         column-label "Chave"
    field ttv_num_mensagem  as integer   format ">>>>,>>9" label "N£mero"        column-label "N£mero Mensagem"
    field ttv_des_msg_erro  as character format "x(40)"    label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_help      as character format "x(60)"    label "Ajuda"         column-label "Ajuda".

{esp/fas/esfas011.i}
IF NOT valid-handle(v_hdl_api_bem_pat_bxa_transf) THEN run prgfin/fas/fas737zb.py persistent set v_hdl_api_bem_pat_bxa_transf (Input 01) /* prg_api_criacao_movto_bem_pat*/.

/*---[ importa dados da planilha, carregando temp-tables ]----------------------------*/
DEFINE NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEFINE VARIABLE Rw-Log-Exec AS ROWID NO-UNDO.
DEFINE VARIABLE C-Erro-Rpc  AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEFINE VARIABLE C-Erro-Aux  AS CHAR FORM "x(60)" INIT " " NO-UNDO.

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/
DEFINE VARIABLE V_Cod_Empresa             LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
DEFINE VARIABLE I                         AS   INTE NO-UNDO.
DEFINE VARIABLE V_Cod_Dwb_File            LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEFINE VARIABLE V_Cod_Dwb_Output          LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEFINE VARIABLE C-Impressora              LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEFINE VARIABLE C-Layout                  LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEFINE VARIABLE H-Hacr155                 AS   HANDLE NO-UNDO.
DEFINE VARIABLE V-Cod-Destino-Impres      AS   CHAR   NO-UNDO.
DEFINE VARIABLE V-Num-Reg-Lidos           AS   INTE   NO-UNDO.
DEFINE VARIABLE V-Num-Point               AS   INTE   NO-UNDO.
DEFINE VARIABLE V-Num-Set                 AS   INTE   NO-UNDO.
DEFINE VARIABLE V-Cod-Arquivo             AS   CHAR.
DEFINE VARIABLE V-Num-Tip-Reg             AS   INTE FORM "999".
DEFINE VARIABLE C-Empresa                 AS   CHAR FORM "x(40)"  NO-UNDO.
DEFINE VARIABLE C-Titulo-Relat            AS   CHAR FORM "x(50)"  NO-UNDO.
DEFINE VARIABLE C-Sistema                 AS   CHAR FORM "x(25)"  NO-UNDO.
DEFINE VARIABLE C-Rodape                  AS   CHAR               NO-UNDO.
DEFINE VARIABLE C-Programa                AS   CHAR FORM "x(08)"  NO-UNDO.
DEFINE VARIABLE C-Versao                  AS   CHAR FORM "x(04)"  NO-UNDO.
DEFINE VARIABLE C-Revisao                 AS   CHAR FORM "999"    NO-UNDO.
DEFINE VARIABLE V_Num_Pag                 AS   INTE INIT 1        NO-UNDO.
DEFINE VARIABLE Ch_Linha                  AS   CHAR FORM "x(132)" NO-UNDO.
DEFINE VARIABLE c-dir-arquivo             AS   CHARACTER FORMAT "X(256)"     NO-UNDO.
DEFINE VARIABLE c-cod_motiv_trans_externa LIKE motiv_desmob.cod_motiv_desmob NO-UNDO.
DEFINE VARIABLE c-cod_motiv_trans_interna LIKE motiv_desmob.cod_motiv_desmob NO-UNDO.
DEFINE VARIABLE l-inventario              AS   LOGICAL INIT YES              NO-UNDO.
DEFINE VARIABLE i-linha                   AS   INTEGER                       NO-UNDO.
DEFINE VARIABLE v_cod_indic_econ          AS   CHAR                          NO-UNDO.

DEFINE BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEFINE BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEFINE NEW SHARED VARIABLE V_Rpt_s_1_Lines   AS INTE INIT 60.
DEFINE NEW SHARED VARIABLE V_Rpt_s_1_Columns AS INTE INIT 132.
DEFINE NEW SHARED VARIABLE V_Rpt_s_1_Bottom  AS INTE INIT 60.
DEFINE NEW SHARED VARIABLE V_Rpt_s_1_Page    AS INTE.
DEFINE NEW SHARED VARIABLE V_Rpt_s_1_Name    AS CHAR.

IF V_Cod_Dwb_User = '' THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF  V_Num_Ped_Exec_Corren > 0 THEN DO.
    FIND Ped_Exec_Param NO-LOCK
        WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
    IF  AVAIL Ped_Exec_Param THEN DO.
        FIND Dwb_Set_List_Param NO-LOCK
            WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas011rp'
            AND   Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
        
        ASSIGN V_Cod_Dwb_File            = Ped_Exec_Param.Cod_Dwb_File
               V_Cod_Dwb_Output          = Ped_Exec_Param.Cod_Dwb_Output
               C-Impressora              = Ped_Exec_Param.Nom_Dwb_Printer
               C-Layout                  = Ped_Exec_Param.Cod_Dwb_Print_Layout
               c-dir-arquivo             = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               c-cod_motiv_trans_externa = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               c-cod_motiv_trans_interna = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               l-inventario              = LOGICAL(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.
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
        WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas011rp'
        AND   Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
    IF  AVAIL Dwb_Set_List_Param THEN DO.
        ASSIGN V_Cod_Dwb_File            = Dwb_Set_list_Param.Cod_Dwb_File             
               V_Cod_Dwb_Output          = Dwb_Set_list_Param.Cod_Dwb_Output           
               C-Impressora              = Dwb_Set_list_Param.nom_Dwb_Printer
               C-Layout                  = dwb_set_list_param.Cod_dwb_print_layout
               c-dir-arquivo             = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               c-cod_motiv_trans_externa = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               c-cod_motiv_trans_interna = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))          
               l-inventario              = LOGICAL(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.
    END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN DO.
         ASSIGN V_Cod_Dwb_File   = session:temp-directory + 'esfas011.lst'.
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
                 WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor      = Layout_Impres.Cod_Tip_Imprsor
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

ASSIGN C-Programa           = "esfas011"
       C-Versao             = "1.00"
       C-Revisao            = "001"
       C-Titulo-Relat       = "Log Ocorràncias - Invent†rio"
       V_Rpt_s_1_Name       = C-Titulo-Relat
       C-Sistema            = "ESP"
       C-Empresa            = "Intelbras"
       Ch_Linha             = FILL("-",132)
       v_ind_message_output = "Em Arquivo":U
       i-linha              = 0.

DEF FRAME fCabec132 HEADER 
    FILL("-",150)           AT 001 FORMAT "x(150)" SKIP
    c-empresa               AT 001 FORMAT "x(040)"
    c-titulo-relat          AT 055 FORMAT "x(042)"
    "P†gina: "              AT 135 (page-number (s_1)) to 150 format ">>9" skip
    FILL("-",128)           AT 001 FORMAT "x(128)"
    TODAY                   AT 130 FORMAT "99/99/9999"
    "-"                     AT 141
    String(TIME,"HH:MM:SS") AT 143 skip (1)
    with no-box no-labels width 150 page-top stream-io.

DEF FRAME fRodape132 HEADER 
    skip (1) FILL("-",127) AT 001 FORMAT "x(127)"
    C-Programa             AT 130 FORMAT 'x(008)' 
    "-"                    AT 140
    "1.00.000"             AT 143 SKIP
    with no-box no-labels width 150 page-bottom stream-io.

ASSIGN V_Num_Pag = 1.

/*---[ PROCEDURES ]-----------------------------------------------------------------*/
EMPTY TEMP-TABLE tt_erro NO-ERROR.

if v_cod_usuar_corren begins 'es_'
then do:
     assign v_cod_usuar_corren = entry(2,v_cod_usuar_corren,"_").
end.

RUN pi-carrega-arquivo.
RUN pi-movimenta-bem.

OUTPUT STREAM s_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".


/*---[ pi-carrega-arquivo ]-----------------------------------------------------------*/
PROCEDURE pi-carrega-arquivo:

    /* limpa temp-tables */
    EMPTY TEMP-TABLE ttbem_pat.
    
    IF  SEARCH(c-dir-arquivo) <> ? THEN DO:
        INPUT FROM VALUE(c-dir-arquivo) NO-CONVERT NO-ECHO.
        
        REPEAT:
            ASSIGN i-linha = i-linha + 1.

            IF  i-linha > 1 THEN DO:
                CREATE ttbem_pat.
                IMPORT DELIMITER ";"
                       ttbem_pat.num_inventario    
                       ttbem_pat.cod_cta_pat       
                       ttbem_pat.num_bem_pat       
                       ttbem_pat.num_seq_bem_pat   
                       ttbem_pat.cod_ccusto_respons
                       ttbem_pat.cod_unid_negoc
                       ttbem_pat.cod_estab 
                       ttbem_pat.dat_transf 
                       ttbem_pat.cod_localiz NO-ERROR.
            END. /* IF  i-linha > 1 THEN DO: */
        END. /* REPEAT: */

        INPUT CLOSE.

        FOR EACH ttbem_pat WHERE ttbem_pat.num_inventario = 0 OR ttbem_pat.cod_cta_pat = "":
            DELETE ttbem_pat.
        END. /* FOR EACH ttbem_pat */

    END. /* IF  SEARCH(c-dir-arquivo) <> ? */

END PROCEDURE. /* PROCEDURE pi-carrega-arquivo: */

/*---[ pi-movimenta-bem ]-----------------------------------------------------------*/
PROCEDURE pi-movimenta-bem:
    VIEW STREAM S_1 FRAME fCabec132.
    VIEW STREAM S_1 FRAME fRodape132.

    blk_bem:
    FOR EACH ttbem_pat:
        FIND FIRST bem_pat NO-LOCK
            WHERE  bem_pat.cod_empresa     = v_cod_empres_usuar
            AND    bem_pat.cod_cta_pat     = ttbem_pat.cod_cta_pat    
            AND    bem_pat.num_bem_pat     = ttbem_pat.num_bem_pat    
            AND    bem_pat.num_seq_bem_pat = ttbem_pat.num_seq_bem_pat NO-ERROR.
        IF  AVAIL  bem_pat 
        THEN DO:

            IF ttbem_pat.cod_localiz <> ""
            THEN DO:
                 FIND emscad.localizacao NO-LOCK
                     WHERE emscad.localizacao.cod_estab   = ttbem_pat.cod_estab
                       AND emscad.localizacao.cod_localiz = ttbem_pat.cod_localiz NO-ERROR.
                 IF NOT AVAIL emscad.localizacao 
                 THEN DO:
                      CREATE tt_erro.
                      ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                         STRING(bem_pat.cod_empresa     ) + "/" + 
                                                         STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                         STRING(bem_pat.num_bem_pat     ) + "/" +
                                                         STRING(bem_pat.num_seq_bem_pat )
                             tt_erro.ttv_num_mensagem  = 0
                             tt_erro.ttv_des_msg_erro  = "Localizaá∆o n∆o existe no estabelecimento informado!"
                             tt_erro.ttv_des_help      = "Localizaá∆o " + ttbem_pat.cod_localiz + " n∆o encontrada no estabelecimento " + ttbem_pat.cod_estab + ".".
                      NEXT.
                 END.

                 IF ttbem_pat.cod_cta_pat = "PROJ. ANDAM. INTAN"
                 OR ttbem_pat.cod_cta_pat = "PROJETOS EM ANDAME"
                 OR ttbem_pat.cod_cta_pat = "BENFEITORIA TERCER"
                 OR ttbem_pat.cod_cta_pat = "VEICULOS"
                 OR ttbem_pat.cod_cta_pat = "BENS EM LOC (EMBR)"
                 OR ttbem_pat.cod_cta_pat = "BENS EM LOC (TELE)"
                 OR ttbem_pat.cod_cta_pat = "BENS EM LOCACAO"
                 OR ttbem_pat.cod_cta_pat = "BENS EM LOCAÄ«O SO"
                 OR ttbem_pat.cod_cta_pat = "BENS LOC. TESB"
                 OR ttbem_pat.cod_cta_pat = "BENS LOCACAO TECNI"
                 THEN DO:
                      CREATE tt_erro.
                      ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                         STRING(bem_pat.cod_empresa     ) + "/" + 
                                                         STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                         STRING(bem_pat.num_bem_pat     ) + "/" +
                                                         STRING(bem_pat.num_seq_bem_pat )
                             tt_erro.ttv_num_mensagem  = 0
                             tt_erro.ttv_des_msg_erro  = "Localizaá∆o n∆o dever† ser informada!"
                             tt_erro.ttv_des_help      = "Localizaá∆o " + ttbem_pat.cod_localiz + " n∆o dever† ser informada para a conta patrimonial " + ttbem_pat.cod_cta_pat + ".".
                      NEXT.
                 END.

            END.
            ELSE DO:
                 FIND emscad.localizacao NO-LOCK
                     WHERE emscad.localizacao.cod_estab   = ttbem_pat.cod_estab
                       AND emscad.localizacao.cod_localiz = bem_pat.cod_localiz NO-ERROR.
                 IF  NOT AVAIL emscad.localizacao
                 AND bem_pat.cod_localiz <> ""
                 THEN DO:
                      CREATE tt_erro.
                      ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                         STRING(bem_pat.cod_empresa     ) + "/" + 
                                                         STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                         STRING(bem_pat.num_bem_pat     ) + "/" +
                                                         STRING(bem_pat.num_seq_bem_pat )
                             tt_erro.ttv_num_mensagem  = 0
                             tt_erro.ttv_des_msg_erro  = "Localizaá∆o n∆o existe no estabelecimento informado!"
                             tt_erro.ttv_des_help      = "Localizaá∆o " + bem_pat.cod_localiz + " n∆o encontrada no estabelecimento " + ttbem_pat.cod_estab + ".".
                      NEXT.
                 END.
            END.

            RUN pi_historico.
            IF RETURN-VALUE <> "OK" 
               THEN NEXT.

            IF  (bem_pat.cod_ccusto_respons <> ttbem_pat.cod_ccusto_respons
            OR   bem_pat.cod_unid_negoc     <> ttbem_pat.cod_unid_negoc
            OR   bem_pat.cod_estab          <> ttbem_pat.cod_estab
            OR   bem_pat.cod_localiz        <> ttbem_pat.cod_localiz) THEN DO:
            
                FIND FIRST emscad.pais NO-LOCK
                    WHERE emscad.pais.cod_pais = "BRA" NO-ERROR.
                
                IF AVAIL emscad.pais THEN DO:
                    RUN pi_retornar_indic_econ_finalid (INPUT emscad.pais.cod_finalid_econ,
                                                        INPUT ttbem_pat.dat_transf,
                                                        OUTPUT v_cod_indic_econ).


                    IF  v_cod_indic_econ = "" THEN DO:
                        CREATE tt_erro.
                        ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                           STRING(bem_pat.cod_empresa     ) + "/" + 
                                                           STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                           STRING(bem_pat.num_bem_pat     ) + "/" +
                                                           STRING(bem_pat.num_seq_bem_pat )
                               tt_erro.ttv_num_mensagem  = 0
                               tt_erro.ttv_des_msg_erro  = "Indicador econìmico n∆o localizado !"
                               tt_erro.ttv_des_help      = "Indicador econìmico " + emscad.pais.cod_finalid_econ + " do pa°s " + emscad.pais.cod_pais + " n∆o localizado.".
                        NEXT.
                    END.
                END.
                ELSE DO:
                      CREATE tt_erro.
                      ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                         STRING(bem_pat.cod_empresa     ) + "/" + 
                                                         STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                         STRING(bem_pat.num_bem_pat     ) + "/" +
                                                         STRING(bem_pat.num_seq_bem_pat )
                             tt_erro.ttv_num_mensagem  = 0
                             tt_erro.ttv_des_msg_erro  = "Pa°s da empresa n∆o localizada !"
                             tt_erro.ttv_des_help      = "Pa°s " + "BRA" + " n∆o localizado.".
                      NEXT.
                END.

                CREATE tt_movto_bem_pat_api_aux.
                ASSIGN tt_movto_bem_pat_api_aux.tta_cod_empresa            = v_cod_empres_usuar
                       tt_movto_bem_pat_api_aux.tta_cod_cta_pat            = ttbem_pat.cod_cta_pat    
                       tt_movto_bem_pat_api_aux.tta_num_bem_pat            = ttbem_pat.num_bem_pat    
                       tt_movto_bem_pat_api_aux.tta_num_seq_bem_pat        = ttbem_pat.num_seq_bem_pat
                       tt_movto_bem_pat_api_aux.tta_dat_movto_bem_pat      = ttbem_pat.dat_transf
                       tt_movto_bem_pat_api_aux.tta_ind_trans_calc_bem_pat = "Baixa":U 
                       tt_movto_bem_pat_api_aux.tta_ind_orig_calc_bem_pat  = "Transferància":U 
                       tt_movto_bem_pat_api_aux.ttv_ind_tip_movto_bem_pat  = "Por Percentual" 
                       tt_movto_bem_pat_api_aux.tta_cod_estab              = ttbem_pat.cod_estab
                       tt_movto_bem_pat_api_aux.tta_cod_indic_econ         = v_cod_indic_econ
                       tt_movto_bem_pat_api_aux.tta_cod_plano_ccusto       = bem_pat.cod_plano_ccusto
                       tt_movto_bem_pat_api_aux.tta_cod_localiz            = ttbem_pat.cod_localiz
                       tt_movto_bem_pat_api_aux.tta_cod_ccusto_respons     = ttbem_pat.cod_ccusto_respons
                       tt_movto_bem_pat_api_aux.tta_cod_unid_negoc         = ttbem_pat.cod_unid_negoc
                       tt_movto_bem_pat_api_aux.tta_num_pessoa_jurid       = bem_pat.num_pessoa_jurid.
                       
                IF bem_pat.cod_ccusto_respons <> ttbem_pat.cod_ccusto_respons
                OR bem_pat.cod_localiz        <> ttbem_pat.cod_localiz
                   THEN ASSIGN tt_movto_bem_pat_api_aux.tta_cod_motiv_desmob = c-cod_motiv_trans_interna.
                    
                IF bem_pat.cod_unid_negoc <> ttbem_pat.cod_unid_negoc
                OR bem_pat.cod_estab      <> ttbem_pat.cod_estab 
                   THEN ASSIGN tt_movto_bem_pat_api_aux.tta_cod_motiv_desmob = c-cod_motiv_trans_externa.
    
                RUN pi_api_criacao_movto_bem_pat IN v_hdl_api_bem_pat_bxa_transf (INPUT "", /* indicador de tratamento de erros */
                                                                                  INPUT-OUTPUT TABLE bftt_movto_bem_pat_api_aux).
    
                FOR FIRST bftt_movto_bem_pat_api_aux
                    WHERE bftt_movto_bem_pat_api_aux.tta_cod_empresa     = v_cod_empres_usuar       
                      AND bftt_movto_bem_pat_api_aux.tta_cod_cta_pat     = ttbem_pat.cod_cta_pat    
                      AND bftt_movto_bem_pat_api_aux.tta_num_bem_pat     = ttbem_pat.num_bem_pat    
                      AND bftt_movto_bem_pat_api_aux.tta_num_seq_bem_pat = ttbem_pat.num_seq_bem_pat: 
                END.
                IF  bftt_movto_bem_pat_api_aux.ttv_des_erro_api_movto_bem_pat <> "" 
                THEN DO:
                     CREATE tt_erro.
                     ASSIGN tt_erro.ttv_des_chave_tab = STRING(v_cod_empres_usuar)    + "/" + 
                                                        STRING(ttbem_pat.cod_cta_pat) + "/" +
                                                        STRING(ttbem_pat.num_bem_pat) + "/" +
                                                        STRING(ttbem_pat.num_seq_bem_pat)
                            tt_erro.ttv_num_mensagem  = 0
                            tt_erro.ttv_des_msg_erro  = ""
                            tt_erro.ttv_des_help      = TRIM(bftt_movto_bem_pat_api_aux.ttv_des_erro_api_movto_bem_pat). 

                     FIND histor_inventario EXCLUSIVE-LOCK
                          WHERE histor_inventario.num_inventario  = ttbem_pat.num_inventario
                            AND histor_inventario.cod_empresa     = v_cod_empres_usuar     
                            AND histor_inventario.cod_cta_pat     = ttbem_pat.cod_cta_pat     
                            AND histor_inventario.num_bem_pat     = ttbem_pat.num_bem_pat     
                            AND histor_inventario.num_seq_bem_pat = ttbem_pat.num_seq_bem_pat NO-ERROR.
                     IF AVAIL histor_inventario 
                        THEN ASSIGN histor_inventario.cod_livre_2 = "Bem Patrimonial n∆o Transferido, erro API: " + TRIM(bftt_movto_bem_pat_api_aux.ttv_des_erro_api_movto_bem_pat).

                END. /* IF  tt_movto_bem_pat_api_aux.ttv_des_erro_api_movto_bem_pat <> "" then do: */
    
            END. /* IF  bem_pat.cod_ccusto_respons <> ... */

        END. /* IF  AVAIL  bem_pat THEN DO: */
        ELSE DO:

             create tt_erro.
             assign tt_erro.ttv_des_chave_tab = string(v_cod_empres_usuar)    + "/" + 
                                                string(ttbem_pat.cod_cta_pat) + "/" +
                                                string(ttbem_pat.num_bem_pat) + "/" +
                                                string(ttbem_pat.num_seq_bem_pat)
                    tt_erro.ttv_num_mensagem  = 233.
             
             run pi_messages (input 'msg', input 233, input '').
             assign tt_erro.ttv_des_msg_erro = trim(return-value).
             
             run pi_messages (input 'help', input 233, input '').
             assign tt_erro.ttv_des_help = trim(return-value). 

        END. /* ELSE DO: */
    
    END. /* FOR EACH ttbem_pat: */
    
    IF  CAN-FIND(FIRST tt_erro) THEN DO:
        PUT STREAM s_1 UNFORMATTED 
            "    ERRO MENSAGEM                                 HELP                                                         CHAVE REGISTRO" SKIP
            "-------- ---------------------------------------- ------------------------------------------------------------ ----------------------------------------" SKIP.

        FOR EACH tt_erro BY tt_erro.ttv_des_msg_erro:
            PUT STREAM s_1 UNFORMATTED 
                tt_erro.ttv_num_mensagem  TO 008 FORMAT ">>>>,>>9":U
                tt_erro.ttv_des_msg_erro  AT 010 FORMAT "x(40)":U
                tt_erro.ttv_des_help      AT 051 FORMAT "x(60)":U
                tt_erro.ttv_des_chave_tab AT 112 FORMAT "x(40)":U SKIP.
        END. /* FOR EACH tt_erro: */
    END. /* IF  CAN-FIND(FIRST tt_erro) THEN DO: */
    ELSE PUT STREAM s_1 UNFORMATTED "--> N∆o houveram inconsistàncias. Transferàncias efetuadas com sucesso.":U SKIP.

    /* Elimina Handle das API's */
    if  valid-handle(v_hdl_api_bem_pat_bxa_transf) then do:
        delete procedure v_hdl_api_bem_pat_bxa_transf.
        assign v_hdl_api_bem_pat_bxa_transf = ?.
    end. /* if  valid-handle(v_hdl_api_bem_pat_bxa_transf) */

    RELEASE bem_pat.
    RELEASE movto_bem_pat.

END. /* PROCEDURE pi-movimenta-bem:*/

PROCEDURE pi_historico:

    IF l-inventario 
    THEN DO:
         IF CAN-FIND(FIRST histor_inventario
                     WHERE histor_inventario.num_inventario  = ttbem_pat.num_inventario
                     AND   histor_inventario.cod_empresa     = bem_pat.cod_empresa    
                     AND   histor_inventario.cod_cta_pat     = bem_pat.cod_cta_pat    
                     AND   histor_inventario.num_bem_pat     = bem_pat.num_bem_pat    
                     AND   histor_inventario.num_seq_bem_pat = bem_pat.num_seq_bem_pat) 
         THEN DO:
              CREATE tt_erro.
              ASSIGN tt_erro.ttv_des_chave_tab = STRING(ttbem_pat.num_inventario) + "/" + 
                                                 STRING(bem_pat.cod_empresa     ) + "/" + 
                                                 STRING(bem_pat.cod_cta_pat     ) + "/" +
                                                 STRING(bem_pat.num_bem_pat     ) + "/" +
                                                 STRING(bem_pat.num_seq_bem_pat )
                     tt_erro.ttv_num_mensagem  = 0
                     tt_erro.ttv_des_msg_erro  = "Hist¢rico de Invent†rio j† existente!"
                     tt_erro.ttv_des_help      = "J† existe ocorrància na tabela com a mesma chave.".
              RETURN "NEXT".
         END. /* IF  CAN-FIND(FIRST histor_inventario */
         ELSE DO:
              /* Sempre criar */
              CREATE histor_inventario.
              ASSIGN histor_inventario.num_inventario        = ttbem_pat.num_inventario
                     histor_inventario.cod_empresa           = bem_pat.cod_empresa    
                     histor_inventario.cod_cta_pat           = bem_pat.cod_cta_pat    
                     histor_inventario.num_bem_pat           = bem_pat.num_bem_pat    
                     histor_inventario.num_seq_bem_pat       = bem_pat.num_seq_bem_pat
                     histor_inventario.cod_ccusto_respons    = ttbem_pat.cod_ccusto_respons
                     histor_inventario.cod_unid_negoc        = ttbem_pat.cod_unid_negoc 
                     histor_inventario.cod_livre_1           = ttbem_pat.cod_estab
                     histor_inventario.cod_usuar_ult_atualiz = v_cod_usuar_corren
                     histor_inventario.dat_ult_atualiz       = TODAY
                     histor_inventario.hra_ult_atualiz       = replace(string(TIME, "HH:MM:SS"), ":", "")
                     histor_inventario.dat_transf            = ttbem_pat.dat_transf.


              IF bem_pat.val_perc_bxa = 100 /* Bem totalmente baixado  */              
              THEN DO:
                   CREATE tt_erro.
                   ASSIGN tt_erro.ttv_des_chave_tab = STRING(v_cod_empres_usuar)    + "/" + 
                                                      STRING(ttbem_pat.cod_cta_pat) + "/" +
                                                      STRING(ttbem_pat.num_bem_pat) + "/" +
                                                      STRING(ttbem_pat.num_seq_bem_pat)
                          tt_erro.ttv_num_mensagem  = 0
                          tt_erro.ttv_des_msg_erro  = "Bem Patrimonial totalmente baixado."
                          tt_erro.ttv_des_help      = "Bens totalmente baixados n∆o ser∆o alterados por esta rotina.".
                   ASSIGN histor_inventario.cod_livre_2 = "Bem Patrimonial n∆o Transferido, est† com a situaá∆o Totalmente Baixado.".

                   RETURN "NEXT".
              END.
              
              /*---[ Alocaá∆o de Bens ]-----------------------------------------*/
              IF CAN-FIND(FIRST aloc_bem 
                          WHERE aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                          AND   aloc_bem.val_perc_aprop > 0) 
              THEN DO:
                   CREATE tt_erro.
                   ASSIGN tt_erro.ttv_des_chave_tab = STRING(v_cod_empres_usuar)    + "/" + 
                                                      STRING(ttbem_pat.cod_cta_pat) + "/" +
                                                      STRING(ttbem_pat.num_bem_pat) + "/" +
                                                      STRING(ttbem_pat.num_seq_bem_pat)
                          tt_erro.ttv_num_mensagem  = 0
                          tt_erro.ttv_des_msg_erro  = "Bem Patrimonial possui alocaá∆o parcial."
                          tt_erro.ttv_des_help      = "Bens alocados parcialmente n∆o ser∆o alterados por esta rotina.".
                   ASSIGN histor_inventario.cod_livre_2 = "Bem Patrimonial n∆o Transferido, possui alocaá∆o parcial.".

                   RETURN "NEXT".
              END.
              /*-----------------------------------------[ Alocaá∆o de Bens ]---*/
            
              IF  CAN-FIND(FIRST movto_bem_pat
                           WHERE movto_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                           AND   movto_bem_pat.dat_movto_bem_pat      = ttbem_pat.dat_transf
                           AND   movto_bem_pat.ind_trans_calc_bem_pat = "Baixa":U 
                           AND   movto_bem_pat.ind_orig_calc_bem_pat  = "Transferància":U) 
              THEN DO:
                   CREATE tt_erro.
                   ASSIGN tt_erro.ttv_des_chave_tab = STRING(v_cod_empres_usuar)    + "/" + 
                                                      STRING(ttbem_pat.cod_cta_pat) + "/" +
                                                      STRING(ttbem_pat.num_bem_pat) + "/" +
                                                      STRING(ttbem_pat.num_seq_bem_pat)
                          tt_erro.ttv_num_mensagem  = 0
                          tt_erro.ttv_des_msg_erro  = "Bem Patrimonial possui Transferància."
                          tt_erro.ttv_des_help      = "Bem Patrimonial j† possui movimento de Transferància na data de invent†rio informada.".
                   ASSIGN histor_inventario.cod_livre_2 = "Bem Patrimonial n∆o Transferido, j† possui movimento de Transferància na data de invent†rio informada.".

                   RETURN "NEXT".
              END.
                 
         END. /* ELSE do: */

    END. /* IF  l-inventario THEN DO: */

    RETURN "OK".

END.

/*---[ Pi-Abre-Edit ]-----------------------------------------------------------------*/
PROCEDURE Pi-Abre-Edit:
     DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
     DEFINE VARIABLE V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

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

    def input param c_action    as char    NO-UNDO.
    def input param i_msg       as integer NO-UNDO.
    def input param c_param     as char    NO-UNDO.

    DEFINE VARIABLE c_prg_msg           as char    NO-UNDO.

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


PROCEDURE pi_retornar_indic_econ_finalid:
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ        = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid  >  p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
