 /*****************************************************************************
**     Programa.........: esp/fas/esfas007rp.p
**     Descricao .......: Relat¢rio Complemento Bem Patrimonial
**     Versao...........: 1.00.000
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 10/03/2010
*******************************************************************************/

def new global shared var v_cod_usuar_corren          as character    format "x(12)":U   label "Usu rio Corrente"     column-label "Usu rio Corrente" no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

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

/*---[ Para conexÆo de outro banco ]-------------------------------------------------------------------*/
DEFINE TEMP-TABLE tt_erros_conexao NO-UNDO 
    FIELD ttv_cdn_erro AS INTEGER   FORMAT ">>>,>>9":U
    FIELD ttv_des_erro AS CHARACTER FORMAT "x(50)":U LABEL "Inconsistˆncia":U COLUMN-LABEL "Inconsistˆncia":U.

DEFINE VARIABLE v_hdl_btb_connect AS HANDLE  NO-UNDO.
DEFINE VARIABLE v_log_sucesso     AS LOGICAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar  AS CHARACTER FORMAT "x(03)":U LABEL "Empresa":U COLUMN-LABEL "Empresa":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_produt_corren AS CHARACTER FORMAT "x(50)":U NO-UNDO.
/*-------------------------------------------------------------------[ Para conexÆo de outro banco ]---*/

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec                             AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.

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
DEF VAR Ch_Linha                AS CHAR FORM "x(132)" NO-UNDO.

DEF VAR v_class_fiscal         LIKE int_bem_pat_nf.class-fiscal   NO-UNDO.
DEF VAR v_ind_terceiro         LIKE int_bem_pat_nf.ind-terceiro   NO-UNDO.
DEF VAR v_n_serie_bem          LIKE int_bem_pat_nf.serie          NO-UNDO.
DEF VAR v_val_icms             LIKE int_bem_pat_nf.val-icms       NO-UNDO.
DEF VAR v_nf_emprestimo        LIKE int_bem_pat_nf.nr-nota-fis    NO-UNDO.
DEF VAR v_dat_emprestimo       LIKE int_bem_pat_nf.dt-emis-nota   NO-UNDO.
DEF VAR v_cod_cc               LIKE bem_pat.cod_ccusto_respons    NO-UNDO.
DEF VAR v_cod_un               LIKE bem_pat.cod_unid_negoc        NO-UNDO.
DEF VAR c-cod-estab            LIKE int_bem_pat_nf.cod-estabel    NO-UNDO.
DEF VAR c-serie                LIKE int_bem_pat_nf.serie          NO-UNDO.
DEF VAR c-nr-nota              LIKE int_bem_pat_nf.nr-nota-fis    NO-UNDO.
DEF VAR i-seq-item-nf          LIKE int_bem_pat_nf.nr-seq-fat     NO-UNDO.
DEF VAR c-item                 LIKE int_bem_pat_nf.it-codigo      NO-UNDO.
DEF VAR c-nat-item             AS CHAR                            NO-UNDO.
DEF VAR c-desc-nat-item        AS CHAR                            NO-UNDO.
DEF VAR i-cod-emitente         AS INTEGER                         NO-UNDO.
DEF VAR c-nome-destinatario    AS CHAR                            NO-UNDO.
DEF VAR c-da-remessa           AS CHAR                            NO-UNDO.
DEF VAR c-da-retorno           AS CHAR                            NO-UNDO.
DEF VAR c-data-retorno         AS CHAR                            NO-UNDO.
DEF VAR c-estab-retorno        AS CHAR                            NO-UNDO.
DEF VAR c-serie-docto-retorno  AS CHAR                            NO-UNDO.
DEF VAR c-nro-docto-retorno    AS CHAR                            NO-UNDO.
DEF VAR c-nat-operacao-retorno AS CHAR                            NO-UNDO.
DEF VAR v_val_deprec           AS DEC FORMAT "ZZZ,ZZZ,ZZZ,ZZ9.99" NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.
DEF BUFFER b_sdo_bem_pat        FOR sdo_bem_pat.

DEFINE VARIABLE v_cod_estab_ini   LIKE bem_pat.cod_estab   NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim   LIKE bem_pat.cod_estab   NO-UNDO.
DEFINE VARIABLE v_cod_cta_pat_ini LIKE bem_pat.cod_cta_pat NO-UNDO.
DEFINE VARIABLE v_cod_cta_pat_fim LIKE bem_pat.cod_cta_pat NO-UNDO.
DEFINE VARIABLE v_num_bem_pat_ini LIKE bem_pat.num_bem_pat NO-UNDO.
DEFINE VARIABLE v_num_bem_pat_fim LIKE bem_pat.num_bem_pat NO-UNDO.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
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
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas007rp'
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.

    ASSIGN V_Cod_Dwb_File    = Ped_Exec_Param.Cod_Dwb_File
           V_Cod_Dwb_Output  = Ped_Exec_Param.Cod_Dwb_Output
           C-Impressora      = Ped_Exec_Param.Nom_Dwb_Printer
           C-Layout          = Ped_Exec_Param.Cod_Dwb_Print_Layout
           v_cod_estab_ini   =     ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_estab_fim   =     ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_cta_pat_ini =     ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_cta_pat_fim =     ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_num_bem_pat_ini = INT(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           v_num_bem_pat_fim = INT(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.

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
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = 'esfas007rp'
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File    = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output  = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora      = Dwb_Set_list_Param.nom_Dwb_Printer
           C-Layout          = dwb_set_list_param.Cod_dwb_print_layout
           v_cod_estab_ini   =     ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_estab_fim   =     ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_cta_pat_ini =     ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_cta_pat_fim =     ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_num_bem_pat_ini = INT(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           v_num_bem_pat_fim = INT(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + 'esfas007.lst'.
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

ASSIGN C-Programa          = "esfas007"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Complemento Bem Patrimonial"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       C-Empresa           = "Intelbras"
       Ch_Linha            = FILL("-",132).

def frame fCabec132 header
    fill("-",150) AT 1 FORMAT "x(150)" SKIP
    c-empresa at 1 format "x(40)"
    c-titulo-relat AT 42 FORMAT "x(42)"
    "P gina: " at 135 (page-number (Stream_1)) to 150 format ">>9" 
    skip
    fill("-",128) AT 1 FORMAT "x(128)"
    TODAY AT 130 FORMAT "99/99/9999"
    "-" at 141
    String(TIME,"HH:MM:SS") at 143 skip (1)
    with no-box no-labels width 150 page-top stream-io.
  
def frame fRodape132 header
    skip (1)
    fill("-",127) FORMAT "x(127)" AT 1
    C-Programa FORMAT 'x(08)' at 130
    "-" at 140
    "1.00.000" at 143 SKIP
    with no-box no-labels width 150 page-bottom stream-io.



ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat.

    PUT STREAM Stream_1 UNFORMATTED "Estab;Cta Patrimonial;Bem;Seq;Descri‡Æo;Dt Aquisi‡Æo;Est NF;S‚rie;NF Empr‚stimo;Cliente;Nome Cliente;Data Emprestimo;Seq Fat;Item;Nat Oper Item;Descri‡Æo Item;Class Fiscal;Ind Terceiro;Vl ICMS;Vl Original;Unid Negoc;Centro Custo Resp;Serie Doc Entr;Nr Docto Entr;Saldo Deprec IFRS" SKIP.
    
    FOR EACH bem_pat
        WHERE bem_pat.cod_estab   >= v_cod_estab_ini
        AND   bem_pat.cod_estab   <= v_cod_estab_fim
        AND   bem_pat.cod_cta_pat >= v_cod_cta_pat_ini
        AND   bem_pat.cod_cta_pat <= v_cod_cta_pat_fim
        AND   bem_pat.num_bem_pat >= v_num_bem_pat_ini
        AND   bem_pat.num_bem_pat <= v_num_bem_pat_fim NO-LOCK:
        
        IF  bem_pat.val_perc_bxa >= 100 THEN /* ignorar bens totalmente baixados */
            NEXT.

        ASSIGN v_class_fiscal   = ""
               v_ind_terceiro   = ""
               v_n_serie_bem    = ""
               v_val_icms       = 0
               v_nf_emprestimo  = ""
               v_dat_emprestimo = ?
               v_cod_cc         = bem_pat.cod_ccusto_respons
               v_cod_un         = bem_pat.cod_unid_negoc
               v_val_deprec     = 0.

        FIND LAST b_sdo_bem_pat OF bem_pat 
            WHERE b_sdo_bem_pat.cod_cenar_ctbl = "IFRS" NO-LOCK NO-ERROR.
    
        IF  AVAIL b_sdo_bem_pat THEN DO:
    
            FOR EACH sdo_bem_pat OF bem_pat NO-LOCK
                WHERE sdo_bem_pat.cod_cenar_ctbl  = "IFRS"
                AND   sdo_bem_pat.dat_sdo_bem_pat = b_sdo_bem_pat.dat_sdo_bem_pat:
                
                ASSIGN v_val_deprec = v_val_deprec                         +
                                     (sdo_bem_pat.val_origin_corrig        - 
                                    ((sdo_bem_pat.val_dpr_val_origin       +
                                      sdo_bem_pat.val_dpr_cm               +
                                      sdo_bem_pat.val_cm_dpr)              +
                                     (sdo_bem_pat.val_dpr_val_origin_amort +
                                      sdo_bem_pat.val_dpr_cm_amort         +
                                      sdo_bem_pat.val_cm_dpr_amort))).
            END.
        END.

        FOR EACH int_bem_pat_nf
            WHERE int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat
            AND   int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat
            AND   int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat NO-LOCK:

            IF  NOT CAN-FIND (FIRST bem_pat_item_docto_entr OF bem_pat) THEN DO:
                ASSIGN v_ind_terceiro   = int_bem_pat_nf.ind-terceiro
                       v_val_icms       = int_bem_pat_nf.val-icms
                       v_nf_emprestimo  = int_bem_pat_nf.nr-nota-fis
                       v_dat_emprestimo = int_bem_pat_nf.dt-emis-nota. 

                ASSIGN c-cod-estab             = ""
                       c-serie                 = ""
                       c-nr-nota               = ""
                       i-seq-item-nf           = 0
                       c-item                  = ""
                       c-nat-item              = ""
                       c-desc-nat-item         = ""
                       i-cod-emitente          = 0
                       c-nome-destinatario     = ""
                       c-da-remessa            = ""
                       c-da-retorno            = ""
                       c-data-retorno          = ""
                       c-estab-retorno         = ""
                       c-serie-docto-retorno   = ""
                       c-nro-docto-retorno     = ""
                       c-nat-operacao-retorno  = "".

                FIND FIRST it-nota-fisc
                    WHERE it-nota-fisc.cod-estabel  = int_bem_pat_nf.cod-estabel 
                    AND   it-nota-fisc.serie        = int_bem_pat_nf.serie       
                    AND   it-nota-fisc.nr-nota-fis  = int_bem_pat_nf.nr-nota-fis 
                    AND   it-nota-fisc.nr-seq-fat   = int_bem_pat_nf.nr-seq-fat  
                    AND   it-nota-fisc.it-codigo    = int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.

                FIND nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.

                IF  AVAIL it-nota-fisc THEN DO:
                    FIND FIRST natur-oper
                        WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.

                    IF  AVAIL natur-oper THEN
                        ASSIGN c-desc-nat-item = natur-oper.nat-operacao.

                    FIND FIRST emitente
                        WHERE emitente.cod-emitente = int_bem_pat_nf.cod-emitente NO-LOCK NO-ERROR.

                    IF  AVAIL emitente THEN
                        ASSIGN i-cod-emitente      = emitente.cod-emitente
                               c-nome-destinatario = emitente.nome-emit.

                    ASSIGN c-nat-item      = it-nota-fisc.nat-operacao
                           c-desc-nat-item = natur-oper.denominacao.

                    IF  nota-fiscal.dt-saida <> ? THEN
                        c-da-remessa = string(nota-fiscal.dt-saida, "99/99/9999").
                    ELSE
                        c-da-remessa = string(nota-fiscal.dt-emis-nota, "99/99/9999").

                END.

                ASSIGN c-cod-estab     = int_bem_pat_nf.cod-estabel
                       c-serie         = int_bem_pat_nf.serie
                       c-nr-nota       = int_bem_pat_nf.nr-nota-fis
                       i-seq-item-nf   = int_bem_pat_nf.nr-seq-fat
                       c-item          = int_bem_pat_nf.it-codigo
                       v_class_fiscal  = int_bem_pat_nf.class-fiscal.

                RUN pi-busca-data-retorno (output c-data-retorno        ,
                                           output c-estab-retorno       ,
                                           output c-serie-docto-retorno ,
                                           output c-nro-docto-retorno   ,
                                           output c-nat-operacao-retorno). 

                ASSIGN v_rec_bem_pat_epc = RECID(bem_pat).

                PUT STREAM Stream_1 UNFORMATTED bem_pat.cod_estab         ";"
                                                bem_pat.cod_cta_pat       ";"
                                                bem_pat.num_bem_pat       ";"
                                                bem_pat.num_seq_bem_pat   ";"
                                                bem_pat.des_bem_pat       ";"
                                                bem_pat.dat_aquis_bem_pat ";"
                                                c-cod-estab               ";"
                                                c-serie                   ";"
                                                v_nf_emprestimo           ";"
                                                i-cod-emitente            ";"
                                                c-nome-destinatario       ";"
                                                IF v_dat_emprestimo = ? THEN "" ELSE STRING(v_dat_emprestimo, "99/99/9999") ";"
                                                i-seq-item-nf             ";"
                                                c-item                    ";"
                                                c-nat-item                ";"
                                                c-desc-nat-item           ";"
                                                v_class_fiscal            ";"
                                                v_ind_terceiro            ";"
                                                /*
                                                c-da-remessa              ";"
                                                c-data-retorno            ";" 
                                                c-estab-retorno           ";" 
                                                c-serie-docto-retorno     ";" 
                                                c-nro-docto-retorno       ";" 
                                                c-nat-operacao-retorno    ";" 
                                                */
                                                v_val_icms                ";"
                                                bem_pat.val_original      ";"
                                                v_cod_un                  ";"
                                                v_cod_cc                  ";;;"
                                                v_val_deprec
                                                SKIP.    
            END.
            ELSE DO:

                if  not can-find(first bem_pat_item_docto_entr no-lock
                    where bem_pat_item_docto_entr.num_id_bem_pat = bem_pat.num_id_bem_pat
                    and   bem_pat_item_docto_entr.num_seq_incorp_bem_pat = if avail incorp_bem_pat then incorp_bem_pat.num_seq_incorp_bem_pat else 0) then do:

                    find first movto_bem_pat no-lock
                        where movto_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                        and   movto_bem_pat.ind_trans_calc_bem_pat = "Implanta‡Æo"
                        and  (movto_bem_pat.ind_orig_calc_bem_pat  = "Desmembramento" 
                        or    movto_bem_pat.ind_orig_calc_bem_pat  = "Reclassifica‡Æo") no-error.

                    if  avail movto_bem_pat 
                    and movto_bem_pat.num_id_bem_pat_orig <> 0 then do:
                        
                        for each bem_pat_item_docto_entr no-lock
                            where bem_pat_item_docto_entr.num_id_bem_pat         = movto_bem_pat.num_id_bem_pat_orig
                            and   bem_pat_item_docto_entr.num_seq_incorp_bem_pat = if avail incorp_bem_pat then incorp_bem_pat.num_seq_incorp_bem_pat else 0:
                            
                            RUN pi_docto_entrada.
                        END.
                    end.
                    else do:
                        for each bem_pat_item_docto_entr no-lock
                            where bem_pat_item_docto_entr.num_id_bem_pat         = bem_pat.num_id_bem_pat
                            and   bem_pat_item_docto_entr.num_seq_incorp_bem_pat = if avail incorp_bem_pat then incorp_bem_pat.num_seq_incorp_bem_pat else 0:

                            RUN pi_docto_entrada.
                        END.
                    end.
                end.
                else do:
                    for each bem_pat_item_docto_entr no-lock
                        where bem_pat_item_docto_entr.num_id_bem_pat         = bem_pat.num_id_bem_pat
                        and   bem_pat_item_docto_entr.num_seq_incorp_bem_pat = if avail incorp_bem_pat then incorp_bem_pat.num_seq_incorp_bem_pat else 0:

                        RUN pi_docto_entrada.
                    END.
                end.

            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_docto_entrada:
    ASSIGN v_ind_terceiro   = int_bem_pat_nf.ind-terceiro
           v_val_icms       = int_bem_pat_nf.val-icms
           v_nf_emprestimo  = int_bem_pat_nf.nr-nota-fis
           v_dat_emprestimo = int_bem_pat_nf.dt-emis-nota. 

    ASSIGN c-cod-estab             = ""
           c-serie                 = ""
           c-nr-nota               = ""
           i-seq-item-nf           = 0
           c-item                  = ""
           c-nat-item              = ""
           c-desc-nat-item         = ""
           i-cod-emitente          = 0
           c-nome-destinatario     = ""
           c-da-remessa            = ""
           c-da-retorno            = ""
           c-data-retorno          = ""
           c-estab-retorno         = ""
           c-serie-docto-retorno   = ""
           c-nro-docto-retorno     = ""
           c-nat-operacao-retorno  = "".

    FIND FIRST it-nota-fisc
        WHERE it-nota-fisc.cod-estabel  = int_bem_pat_nf.cod-estabel 
        AND   it-nota-fisc.serie        = int_bem_pat_nf.serie       
        AND   it-nota-fisc.nr-nota-fis  = int_bem_pat_nf.nr-nota-fis 
        AND   it-nota-fisc.nr-seq-fat   = int_bem_pat_nf.nr-seq-fat  
        AND   it-nota-fisc.it-codigo    = int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.

    FIND nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.

    IF  AVAIL it-nota-fisc THEN DO:
        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.

        IF  AVAIL natur-oper THEN
            ASSIGN c-desc-nat-item = natur-oper.nat-operacao.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = int_bem_pat_nf.cod-emitente NO-LOCK NO-ERROR.

        IF  AVAIL emitente THEN
            ASSIGN i-cod-emitente      = emitente.cod-emitente
                   c-nome-destinatario = emitente.nome-emit.

        ASSIGN c-nat-item      = it-nota-fisc.nat-operacao
               c-desc-nat-item = natur-oper.denominacao.

        IF  nota-fiscal.dt-saida <> ? THEN
            c-da-remessa = string(nota-fiscal.dt-saida, "99/99/9999").
        ELSE
            c-da-remessa = string(nota-fiscal.dt-emis-nota, "99/99/9999").

    END.

    ASSIGN c-cod-estab     = int_bem_pat_nf.cod-estabel
           c-serie         = int_bem_pat_nf.serie
           c-nr-nota       = int_bem_pat_nf.nr-nota-fis
           i-seq-item-nf   = int_bem_pat_nf.nr-seq-fat
           c-item          = int_bem_pat_nf.it-codigo
           v_class_fiscal  = int_bem_pat_nf.class-fiscal.

    RUN pi-busca-data-retorno (output c-data-retorno        ,
                               output c-estab-retorno       ,
                               output c-serie-docto-retorno ,
                               output c-nro-docto-retorno   ,
                               output c-nat-operacao-retorno). 

    ASSIGN v_rec_bem_pat_epc = RECID(bem_pat).

    PUT STREAM Stream_1 UNFORMATTED bem_pat.cod_estab         ";"
                                    bem_pat.cod_cta_pat       ";"
                                    bem_pat.num_bem_pat       ";"
                                    bem_pat.num_seq_bem_pat   ";"
                                    bem_pat.des_bem_pat       ";"
                                    bem_pat.dat_aquis_bem_pat ";"
                                    c-cod-estab               ";"
                                    c-serie                   ";"
                                    v_nf_emprestimo           ";"
                                    i-cod-emitente            ";"
                                    c-nome-destinatario       ";"
                                    IF v_dat_emprestimo = ? THEN "" ELSE STRING(v_dat_emprestimo, "99/99/9999") ";"
                                    i-seq-item-nf             ";"
                                    c-item                    ";"
                                    c-nat-item                ";"
                                    c-desc-nat-item           ";"
                                    v_class_fiscal            ";"
                                    v_ind_terceiro            ";"
                                    /*
                                    c-da-remessa              ";"
                                    c-data-retorno            ";" 
                                    c-estab-retorno           ";" 
                                    c-serie-docto-retorno     ";" 
                                    c-nro-docto-retorno       ";" 
                                    c-nat-operacao-retorno    ";" 
                                    */
                                    v_val_icms                ";"
                                    bem_pat.val_original      ";"
                                    v_cod_un                  ";"
                                    v_cod_cc                  ";"
                                    bem_pat_item_docto_entr.cod_ser_nota   ";"
                                    bem_pat_item_docto_entr.cod_docto_entr ";"
                                    v_val_deprec                                                        
                                    SKIP.    
END PROCEDURE.

PROCEDURE pi-busca-data-retorno:

    DEF OUTPUT PARAM p-data-retorno         AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-estab-retorno        AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-serie-docto-retorno  AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-nro-docto-retorno    AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-nat-operacao-retorno AS CHAR NO-UNDO.

    FOR EACH saldo-terc NO-LOCK USE-INDEX documento 
        WHERE saldo-terc.serie-docto  = it-nota-fisc.serie
          AND saldo-terc.nro-docto    = it-nota-fisc.nr-nota-fis
          AND saldo-terc.cod-emitente = nota-fiscal.cod-emitente
          AND saldo-terc.nat-operacao = it-nota-fisc.nat-operacao
          AND saldo-terc.it-codigo    = it-nota-fisc.it-codigo
          AND saldo-terc.cod-refer    = it-nota-fisc.cod-refer
          AND saldo-terc.sequencia    = it-nota-fisc.nr-seq-fat:
        FOR EACH componente NO-LOCK
           WHERE componente.cod-emitente = saldo-terc.cod-emitente
             AND componente.it-codigo    = saldo-terc.it-codigo
             AND componente.cod-refer    = saldo-terc.cod-refer
             AND (  /* ** Envio ***/
                    (componente.serie-docto  = saldo-terc.serie-docto  AND
                     componente.nro-docto    = saldo-terc.nro-docto    AND
                     componente.nat-operacao = saldo-terc.nat-operacao AND
                     componente.sequencia    = saldo-terc.sequencia)
                  OR /* ** Retorno ***/
                    (componente.serie-comp = saldo-terc.serie-docto   AND
                     componente.nro-comp   = saldo-terc.nro-docto     AND
                     componente.nat-comp   = saldo-terc.nat-operacao  AND
                     componente.seq-comp   = saldo-terc.sequencia)
                 ):

            IF  componente.componente = 2 THEN /**/
                ASSIGN p-data-retorno         = string(componente.dt-retorno, "99/99/9999")
                       p-estab-retorno        = saldo-terc.cod-estabel
                       p-serie-docto-retorno  = componente.serie-docto
                       p-nro-docto-retorno    = componente.nro-docto
                       p-nat-operacao-retorno = componente.nat-operacao.
        END.
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
     END.

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.

/* IF I-Num-Ped-Exec-Rpw <> 0 */
/* THEN RETURN "OK".          */
