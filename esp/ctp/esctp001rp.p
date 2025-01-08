/*****************************************************************************
**     Programa.........: esctp001rp.p
**     Descricao .......: Conciliaá∆o da Transitoria de Fornecedores
**     Versao...........: 1.00.000
**     Autor............: Catia Schmauch - Gestech
**     Criado...........: 03/02/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

DEFINE TEMP-TABLE tt-log NO-UNDO
    FIELD num-linha     AS INTEGER
    FIELD linha         AS CHARACTER FORMAT 'x(130)'
    INDEX id-linha num-linha.


DEFINE TEMP-TABLE ttRat_ctbl            NO-UNDO LIKE rat_ctbl.
DEFINE TEMP-TABLE ttItem_rat_ctbl       NO-UNDO LIKE item_rat_ctbl.
DEFINE TEMP-TABLE ttRat_ctbl_orig       NO-UNDO LIKE rat_ctbl_orig.
DEFINE TEMP-TABLE ttRat_ctbl_dest       NO-UNDO LIKE rat_ctbl_dest.
DEFINE TEMP-TABLE ttRat_ctbl_dest_mapa  NO-UNDO LIKE rat_ctbl_dest_mapa.

{esinc\es0000.i}


DEFINE VARIABLE i-opcao             AS INTEGER      NO-UNDO. /* 1-importacao, 2-exportacao */
DEFINE VARIABLE cCod_empresa_ini    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCod_empresa_end    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCod_rat_ctbl_ini   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCod_rat_ctbl_end   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cArquivo            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-linha             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-linha             AS INTEGER      NO-UNDO.


/*
DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOGI   INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOGI   NO-UNDO.
DEF NEW GLOBAL SHARED VAR R-Registro-Atual        AS   ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR C-Arquivo-Log           AS   CHAR   FORM "x(60)"NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped               AS   INTE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR H_Prog_Segur_Estab      AS   HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Num_Tip_Aces_Usuar    AS   INTE   NO-UNDO.     
DEF NEW GLOBAL SHARED VAR C-Dir-Spool-Servid-Exec AS   CHAR   NO-UNDO.
*/
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */

/*
DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
DEF VAR I                       AS INTE NO-UNDO.
DEF VAR H-Hacr155               AS HANDLE NO-UNDO.
DEF VAR V-Cod-Destino-Impres    AS CHAR   NO-UNDO.
DEF VAR V-Num-Reg-Lidos         AS INTE   NO-UNDO.
DEF VAR V-Num-Point             AS INTE   NO-UNDO.
DEF VAR V-Num-Set               AS INTE   NO-UNDO.
DEF VAR V-Cod-Arquivo           AS CHAR.
DEF VAR V-Num-Tip-Reg           AS INTE FORM "999".
DEF VAR C-Rodape                AS CHAR               NO-UNDO.
*/
DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Sistema               AS CHAR FORM "x(25)"  NO-UNDO.
DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR C-Titulo-Relat          AS CHAR FORM "x(50)"  NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR C-Empresa               AS CHAR FORM "x(40)"  NO-UNDO.

DEF STREAM Stream_1.
DEFINE STREAM str-out.
DEFINE STREAM str-in.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio D°vidas Cliente".
/*
DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
*/
/*****  Definiá∆o das Forms de Impress∆o  ******/

FIND FIRST EmsUni.Empresa NO-LOCK 
     WHERE Empresa.Cod_Empresa = V_Cod_Empres_Usuar NO-ERROR.
IF AVAIL Empresa
THEN ASSIGN C-Empresa = Empresa.Nom_Razao_Social.
ELSE ASSIGN C-Empresa = "".

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esctp001rp"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File    = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output  = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora      = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout          = Ped_Exec_Param.Cod_Dwb_Print_Layout.

   ASSIGN i-opcao           = INTEGER(ENTRY(02, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))) NO-ERROR.
   ASSIGN cCod_empresa_ini  =         ENTRY(03, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
   ASSIGN cCod_empresa_end  =         ENTRY(04, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
   ASSIGN cCod_rat_ctbl_ini =         ENTRY(05, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
   ASSIGN cCod_rat_ctbl_end =         ENTRY(06, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
   ASSIGN cArquivo          =         ENTRY(07, Ped_Exec_Param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esctp001rp"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout.

    ASSIGN i-opcao           = INTEGER(ENTRY(02, dwb_set_list_param.Cod_dwb_parameters, CHR(10))) NO-ERROR.
    ASSIGN cCod_empresa_ini  =         ENTRY(03, dwb_set_list_param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
    ASSIGN cCod_empresa_end  =         ENTRY(04, dwb_set_list_param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
    ASSIGN cCod_rat_ctbl_ini =         ENTRY(05, dwb_set_list_param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
    ASSIGN cCod_rat_ctbl_end =         ENTRY(06, dwb_set_list_param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
    ASSIGN cArquivo          =         ENTRY(07, dwb_set_list_param.Cod_dwb_parameters, CHR(10))  NO-ERROR.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */



DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esctp001.lst".
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

ASSIGN C-Programa          = "esctp001"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Importaá∆o/Exportaá∆o Rateios"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

{esinc\es0002.i 132}

FUNCTION fnLinha RETURNS INTEGER ():
    ASSIGN i-linha = i-linha + 1.
    RETURN i-linha.
END FUNCTION.



RUN PiMontaRelat IN THIS-PROCEDURE.
RUN PiImprimeRelat IN THIS-PROCEDURE.
OUTPUT STREAM Stream_1 CLOSE.
IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".
/* fim do programa */





PROCEDURE PiMontaRelat:

    IF i-opcao = 1 THEN
        RUN pi-exporta-dados IN THIS-PROCEDURE.
    ELSE
        RUN pi-importa-dados IN THIS-PROCEDURE.

END PROCEDURE.



PROCEDURE pi-exporta-dados:

    OUTPUT STREAM str-out TO VALUE(cArquivo) CONVERT TARGET 'iso8859-1'.

    FOR EACH rat_ctbl NO-LOCK
        WHERE rat_ctbl.cod_empresa  >= cCod_empresa_ini
          AND rat_ctbl.cod_empresa  <= cCod_empresa_end
          AND rat_ctbl.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND rat_ctbl.cod_rat_ctbl <= cCod_rat_ctbl_end:

        PUT STREAM str-out UNFORMATTED
/*             'RATEIO'                ';' */
/*             rat_ctbl.cod_empresa    ';' */
            rat_ctbl.cod_rat_ctbl   ';'
            rat_ctbl.des_rat_ctbl   /*';'*/
/*             rat_ctbl.cod_cenar_ctbl ';' */
/*             rat_ctbl.dat_inic_valid ';' */
/*             rat_ctbl.dat_fim_valid  ';' */
/*             REPLACE(REPLACE(rat_ctbl.des_anot_tab, CHR(10), CHR(3)), CHR(13), CHR(3)) /*quebras*/ ';' */
/*             rat_ctbl.dat_livre_1 */
                SKIP.


        FOR EACH item_rat_ctbl NO-LOCK
            WHERE item_rat_ctbl.cod_empresa = rat_ctbl.cod_empresa
              AND item_rat_ctbl.cod_rat_ctbl = rat_ctbl.cod_rat_ctbl :

            PUT STREAM str-out UNFORMATTED
                FILL(' ;', 2)
/*                 'IT-RAT'                                ';' */
/*                 item_rat_ctbl.cod_empresa               ';' */
/*                 item_rat_ctbl.cod_rat_ctbl              ';' */
                item_rat_ctbl.num_seq_rat_ctbl          ';'
                STRING(item_rat_ctbl.log_gera_lancto_ctbl_orig, 'Sim/N∆o') ';'
                item_rat_ctbl.cod_histor_padr           /*';'*/
/*                 item_rat_ctbl.cod_tip_lancto_ctbl       ';' */
/*                 item_rat_ctbl.dat_livre_1                   */
                  SKIP.

            FOR EACH rat_ctbl_orig NO-LOCK OF item_rat_ctbl:
                PUT STREAM str-out UNFORMATTED
                    FILL(' ;', 5)
/*                     'ORI-IT'                                ';' */
/*                     rat_ctbl_orig.cod_empresa               ';' */
/*                     rat_ctbl_orig.cod_rat_ctbl              ';' */
/*                     rat_ctbl_orig.num_seq_rat_ctbl          ';' */
                    rat_ctbl_orig.num_ord_seq_rat_ctbl      ';'
                    rat_ctbl_orig.cod_plano_cta_ctbl        ';'
                    rat_ctbl_orig.cod_cta_ctbl_inic         ';'
                    rat_ctbl_orig.cod_cta_ctbl_fim          ';'
/*                     rat_ctbl_orig.cod_cta_ctbl_pfixa        ';' */
                    rat_ctbl_orig.cod_plano_ccusto          ';'
                    rat_ctbl_orig.cod_ccusto_inic           ';'
                    rat_ctbl_orig.cod_ccusto_fim            ';'
/*                     rat_ctbl_orig.cod_ccusto_pfixa          ';' */
/*                     rat_ctbl_orig.cod_proj_financ_inic      ';' */
/*                     rat_ctbl_orig.cod_proj_financ_fim       ';' */
/*                     rat_ctbl_orig.cod_proj_financ_pfixa     ';' */
                    rat_ctbl_orig.cod_estab_inic            ';'
                    rat_ctbl_orig.cod_estab_fim             ';'
                    rat_ctbl_orig.cod_unid_negoc_inic       ';'
                    rat_ctbl_orig.cod_unid_negoc_fim        ';'
                    rat_ctbl_orig.val_perc_rat_ctbl         /*';'*/
/*                     rat_ctbl_orig.cod_cta_ctbl_excec        ';' */
/*                     rat_ctbl_orig.cod_ccusto_excec          ';' */
/*                     rat_ctbl_orig.ind_espec_cta_ctbl_consid ';' */
/*                     rat_ctbl_orig.log_ccusto_sint           ';' */
/*                     rat_ctbl_orig.dat_livre_1                   */
                    SKIP.
            END.


            FOR EACH rat_ctbl_dest NO-LOCK OF item_rat_ctbl:
                PUT STREAM str-out UNFORMATTED
                    FILL(' ;', 17)
/*                     'DES-IT'                                ';' */
/*                     rat_ctbl_dest.cod_empresa               ';' */
/*                     rat_ctbl_dest.cod_rat_ctbl              ';' */
/*                     rat_ctbl_dest.num_seq_rat_ctbl          ';' */
                    rat_ctbl_dest.num_ord_seq_rat_ctbl      ';'
                    rat_ctbl_dest.ind_rat_ctbl_dest_cta     ';'
                    rat_ctbl_dest.cod_plano_cta_ctbl        ';'
                    rat_ctbl_dest.cod_cta_ctbl              ';'
                    rat_ctbl_dest.ind_rat_ctbl_dest_estab   ';'
                    rat_ctbl_dest.cod_estab                 ';'
                    rat_ctbl_dest.ind_rat_ctbl_dest_negoc   ';'
                    rat_ctbl_dest.cod_unid_negoc            ';'
/*                     rat_ctbl_dest.ind_rat_ctbl_dest_proj    ';' */
/*                     rat_ctbl_dest.cod_proj_financ           ';' */
                    rat_ctbl_dest.ind_rat_ctbl_dest_ccusto  ';'
                    rat_ctbl_dest.cod_plano_ccusto          ';'
                    rat_ctbl_dest.cod_ccusto                ';'
/*                     rat_ctbl_dest.ind_direc_abc             ';' */
/*                     rat_ctbl_dest.ind_control_direc_abc     ';' */
                    STRING (rat_ctbl_dest.log_inverte_natur_ctbl, 'Sim/N∆o')    ';'
                    rat_ctbl_dest.val_perc_rat_ctbl         ';'
                    rat_ctbl_dest.cod_histor_padr           /*';'*/
/*                     rat_ctbl_dest.dat_livre_1 */
                    SKIP.

                FOR EACH rat_ctbl_dest_mapa NO-LOCK OF rat_ctbl_dest:
                    PUT STREAM str-out UNFORMATTED
                        FILL(' ;', 31)
/*                         'MAP-IT'                                ';' */
/*                         rat_ctbl_dest_mapa.cod_empresa          ';' */
/*                         rat_ctbl_dest_mapa.cod_rat_ctbl         ';' */
/*                         rat_ctbl_dest_mapa.num_seq_rat_ctbl     ';' */
/*                         rat_ctbl_dest_mapa.num_ord_seq_rat_ctbl ';' */
                        rat_ctbl_dest_mapa.cod_estab            ';'
                        rat_ctbl_dest_mapa.cod_mapa_distrib_ccusto /*';'*/
/*                         rat_ctbl_dest_mapa.dat_livre_1 */
                        SKIP.
                END.

            END.

        END.

    END.

    OUTPUT STREAM str-out CLOSE.


    CREATE tt-log.
    ASSIGN tt-log.num-linha = 0
           tt-log.linha     = 'Gerado arquivo de exportaá∆o de Rateios ' + cArquivo.

END PROCEDURE.


PROCEDURE pi-importa-dados:


    INPUT STREAM str-in FROM VALUE(cArquivo) CONVERT SOURCE 'iso8859-1'.

    REPEAT:

        IMPORT STREAM str-in UNFORMATTED c-linha.



        IF NUM-ENTRIES(c-linha, ';') >= 02 AND TRIM(ENTRY(01, c-linha, ';')) <> '' THEN DO:

            FIND ttRat_ctbl EXCLUSIVE-LOCK
                WHERE ttRat_ctbl.cod_empresa                = v_cod_empres_usuar
                  AND ttRat_ctbl.cod_rat_ctbl               = TRIM(ENTRY(01, c-linha, ';'))
                NO-ERROR.

            IF NOT AVAILABLE ttRat_ctbl THEN
                CREATE ttRat_ctbl.

            ASSIGN ttRat_ctbl.cod_empresa                   = v_cod_empres_usuar
                   ttRat_ctbl.cod_rat_ctbl                  = TRIM(ENTRY(01, c-linha, ';'))
                   ttRat_ctbl.des_rat_ctbl                  = TRIM(ENTRY(02, c-linha, ';')).
/* valores gerados automaticamente pelas triggers
ttRat_ctbl.dat_inic_valid
ttRat_ctbl.dat_fim_valid */
/* valor nao atribuido
ttRat_ctbl.cod_cenar_ctbl */
        END.


        IF NUM-ENTRIES(c-linha, ';') >= 05 AND TRIM(ENTRY(03, c-linha, ';')) <> '' AND AVAILABLE ttRat_ctbl THEN DO:

            FIND ttItem_rat_ctbl EXCLUSIVE-LOCK
                WHERE ttItem_rat_ctbl.cod_empresa           = v_cod_empres_usuar
                  AND ttItem_rat_ctbl.cod_rat_ctbl          = ttRat_ctbl.cod_rat_ctbl
                  AND ttItem_rat_ctbl.num_seq_rat_ctbl      = INTEGER(ENTRY(03, c-linha, ';'))
                NO-ERROR.

            IF NOT AVAILABLE ttItem_rat_ctbl THEN
                CREATE ttItem_rat_ctbl.

            ASSIGN ttItem_rat_ctbl.cod_empresa              = v_cod_empres_usuar
                   ttItem_rat_ctbl.cod_rat_ctbl             = ttRat_ctbl.cod_rat_ctbl
                   ttItem_rat_ctbl.num_seq_rat_ctbl         = INTEGER(ENTRY(03, c-linha, ';'))
                   ttItem_rat_ctbl.log_gera_lancto_ctbl_orig = (TRIM(ENTRY(04, c-linha, ';')) = 'YES' OR TRIM(ENTRY(04, c-linha, ';')) = 'Sim')
                   ttItem_rat_ctbl.cod_histor_padr          = TRIM(ENTRY(05, c-linha, ';')).
/* valores gerados automaticamente pelas triggers
ttItem_rat_ctbl.dat_livre_1 */
/* valor nao atribuido
ttItem_rat_ctbl.cod_tip_lancto_ctbl */
        END.


        IF NUM-ENTRIES(c-linha, ';') >= 17 AND TRIM(ENTRY(06, c-linha, ';')) <> '' AND AVAILABLE ttItem_rat_ctbl /* em 18/03 Cforme solicitacao Josias AND DECIMAL(ENTRY(17, c-linha, ';')) <> 0 /*MARIO FLEITH EM 28/02/2005*/*/ THEN DO:

            FIND ttRat_ctbl_orig EXCLUSIVE-LOCK
                WHERE ttRat_ctbl_orig.cod_empresa           = v_cod_empres_usuar
                  AND ttRat_ctbl_orig.cod_rat_ctbl          = ttItem_rat_ctbl.cod_rat_ctbl
                  AND ttRat_ctbl_orig.num_seq_rat_ctbl      = ttItem_rat_ctbl.num_seq_rat_ctbl
                  AND ttRat_ctbl_orig.num_ord_seq_rat_ctbl  = INTEGER(ENTRY(06, c-linha, ';'))
                NO-ERROR.

            IF NOT AVAILABLE ttRat_ctbl_orig THEN
                CREATE ttRat_ctbl_orig.

            ASSIGN ttRat_ctbl_orig.cod_empresa               = v_cod_empres_usuar
                   ttRat_ctbl_orig.cod_rat_ctbl              = ttItem_rat_ctbl.cod_rat_ctbl
                   ttRat_ctbl_orig.num_seq_rat_ctbl          = ttItem_rat_ctbl.num_seq_rat_ctbl
                   ttRat_ctbl_orig.num_ord_seq_rat_ctbl      = INTEGER(ENTRY(06, c-linha, ';'))
                   ttRat_ctbl_orig.cod_plano_cta_ctbl        = TRIM(ENTRY(07, c-linha, ';'))
                   ttRat_ctbl_orig.cod_cta_ctbl_inic         = TRIM(ENTRY(08, c-linha, ';'))
                   ttRat_ctbl_orig.cod_cta_ctbl_fim          = TRIM(ENTRY(09, c-linha, ';'))
                   ttRat_ctbl_orig.cod_plano_ccusto          = TRIM(ENTRY(10, c-linha, ';'))
                   ttRat_ctbl_orig.cod_ccusto_inic           = TRIM(ENTRY(11, c-linha, ';'))
                   ttRat_ctbl_orig.cod_ccusto_fim            = TRIM(ENTRY(12, c-linha, ';'))
                   ttRat_ctbl_orig.cod_proj_financ_inic      = ''
                   ttRat_ctbl_orig.cod_proj_financ_fim       = 'ZZZZZZZZZZZZZZZZZZZZ'
                   ttRat_ctbl_orig.cod_estab_inic            = TRIM(ENTRY(13, c-linha, ';'))
                   ttRat_ctbl_orig.cod_estab_fim             = TRIM(ENTRY(14, c-linha, ';'))
                   ttRat_ctbl_orig.cod_unid_negoc_inic       = TRIM(ENTRY(15, c-linha, ';'))
                   ttRat_ctbl_orig.cod_unid_negoc_fim        = TRIM(ENTRY(16, c-linha, ';'))
                   ttRat_ctbl_orig.val_perc_rat_ctbl         = DECIMAL(ENTRY(17, c-linha, ';'))
                   ttRat_ctbl_orig.cod_cta_ctbl_pfixa        = "########"    /*MARIO FLEITH EM 28/02/2005*/
                   ttRat_ctbl_orig.cod_ccusto_pfixa          = '#####'.      /*MARIO FLEITH EM 28/02/2005*/
                


/* valores gerados automaticamente pelas triggers
ttRat_ctbl_orig.cod_cta_ctbl_pfixa
ttRat_ctbl_orig.cod_ccusto_pfixa
ttRat_ctbl_orig.cod_proj_financ_pfixa
ttRat_ctbl_orig.cod_cta_ctbl_excec
ttRat_ctbl_orig.cod_ccusto_excec
ttRat_ctbl_orig.ind_espec_cta_ctbl_consid
ttRat_ctbl_orig.log_ccusto_sint
ttRat_ctbl_orig.dat_livre_1  */
        END.


        IF NUM-ENTRIES(c-linha, ';') >= 31 AND TRIM(ENTRY(18, c-linha, ';')) <> '' AND AVAILABLE ttItem_rat_ctbl /* em 18/03 Cforme solicitacao Josias AND DECIMAL(ENTRY(30, c-linha, ';')) <> 0 /*MARIO FLEITH EM 28/02/2005*/*/ THEN DO:
            FIND ttRat_ctbl_dest EXCLUSIVE-LOCK
                WHERE ttRat_ctbl_dest.cod_empresa           = v_cod_empres_usuar
                  AND ttRat_ctbl_dest.cod_rat_ctbl          = ttItem_rat_ctbl.cod_rat_ctbl
                  AND ttRat_ctbl_dest.num_seq_rat_ctbl      = ttItem_rat_ctbl.num_seq_rat_ctbl
                  AND ttRat_ctbl_dest.num_ord_seq_rat_ctbl  = INTEGER(ENTRY(18, c-linha, ';'))
                NO-ERROR.
            IF NOT AVAILABLE ttRat_ctbl_dest THEN
                CREATE ttRat_ctbl_dest.
            ASSIGN ttRat_ctbl_dest.cod_empresa               = v_cod_empres_usuar
                   ttRat_ctbl_dest.cod_rat_ctbl              = ttItem_rat_ctbl.cod_rat_ctbl
                   ttRat_ctbl_dest.num_seq_rat_ctbl          = ttItem_rat_ctbl.num_seq_rat_ctbl
                   ttRat_ctbl_dest.num_ord_seq_rat_ctbl      = INTEGER(ENTRY(18, c-linha, ';'))
                   ttRat_ctbl_dest.ind_rat_ctbl_dest_cta     = TRIM(ENTRY(19, c-linha, ';'))
                   ttRat_ctbl_dest.cod_plano_cta_ctbl        = TRIM(ENTRY(20, c-linha, ';'))
                   ttRat_ctbl_dest.cod_cta_ctbl              = TRIM(ENTRY(21, c-linha, ';'))
                   ttRat_ctbl_dest.ind_rat_ctbl_dest_estab   = TRIM(ENTRY(22, c-linha, ';'))
                   ttRat_ctbl_dest.cod_estab                 = TRIM(ENTRY(23, c-linha, ';'))
                   ttRat_ctbl_dest.ind_rat_ctbl_dest_negoc   = TRIM(ENTRY(24, c-linha, ';'))
                   ttRat_ctbl_dest.cod_unid_negoc            = TRIM(ENTRY(25, c-linha, ';'))
                   ttRat_ctbl_dest.ind_rat_ctbl_dest_ccusto  = TRIM(ENTRY(26, c-linha, ';'))
                   ttRat_ctbl_dest.cod_plano_ccusto          = TRIM(ENTRY(27, c-linha, ';'))
                   ttRat_ctbl_dest.cod_ccusto                = TRIM(ENTRY(28, c-linha, ';'))
                   ttRat_ctbl_dest.log_inverte_natur_ctbl    = (TRIM(ENTRY(29, c-linha, ';')) = 'YES' OR TRIM(ENTRY(29, c-linha, ';')) = 'Sim')
                   ttRat_ctbl_dest.val_perc_rat_ctbl         = DECIMAL(ENTRY(30, c-linha, ';'))
                   ttRat_ctbl_dest.cod_histor_padr           = TRIM(ENTRY(31, c-linha, ';'))
                   ttRat_ctbl_dest.ind_rat_ctbl_dest_proj    = 'MantÇm Original'. /*Mario Fleith em 28/02/2005 a pedidos do Josias*/
/* valores gerados automaticamente pelas triggers
ttRat_ctbl_dest.ind_rat_ctbl_dest_proj
ttRat_ctbl_dest.dat_livre_1 */
/* valor nao atribuido
ttRat_ctbl_dest.cod_proj_financ
ttRat_ctbl_dest.ind_direc_abc
ttRat_ctbl_dest.ind_control_direc_abc */
        END.

        IF NUM-ENTRIES(c-linha, ';') >= 33 AND TRIM(ENTRY(32, c-linha, ';')) <> '' AND AVAILABLE ttRat_ctbl_dest THEN DO:

            FIND ttRat_ctbl_dest_mapa EXCLUSIVE-LOCK
                WHERE ttRat_ctbl_dest_mapa.cod_empresa           = v_cod_empres_usuar
                  AND ttRat_ctbl_dest_mapa.cod_rat_ctbl          = ttRat_ctbl_dest.cod_rat_ctbl
                  AND ttRat_ctbl_dest_mapa.num_seq_rat_ctbl      = ttRat_ctbl_dest.num_seq_rat_ctbl
                  AND ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl  = ttRat_ctbl_dest.num_ord_seq_rat_ctbl
                  AND ttRat_ctbl_dest_mapa.cod_estab             = TRIM(ENTRY(32, c-linha, ';'))
                  AND ttRat_ctbl_dest_mapa.cod_mapa_distrib_ccusto = TRIM(ENTRY(33, c-linha, ';'))
                NO-ERROR.
            IF NOT AVAILABLE ttRat_ctbl_dest_mapa THEN
                CREATE ttRat_ctbl_dest_mapa.
            ASSIGN ttRat_ctbl_dest_mapa.cod_empresa          = v_cod_empres_usuar
                   ttRat_ctbl_dest_mapa.cod_rat_ctbl         = ttRat_ctbl_dest.cod_rat_ctbl
                   ttRat_ctbl_dest_mapa.num_seq_rat_ctbl     = ttRat_ctbl_dest.num_seq_rat_ctbl
                   ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl = ttRat_ctbl_dest.num_ord_seq_rat_ctbl
                   ttRat_ctbl_dest_mapa.cod_estab            = TRIM(ENTRY(32, c-linha, ';'))
                   ttRat_ctbl_dest_mapa.cod_mapa_distrib_ccusto = TRIM(ENTRY(33, c-linha, ';')).
/* valores gerados automaticamente pelas triggers
ttRat_ctbl_dest_mapa.dat_livre_1 */
        END.

    END.

    INPUT STREAM str-in CLOSE.



    DO TRANSACTION ON ERROR UNDO, LEAVE:
        RUN carregaRateios  IN THIS-PROCEDURE.
        IF RETURN-VALUE = 'NOK' THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = 0
                   tt-log.linha     = 'Ocorreram erros durante a carga das informaá‰es obtidas do arquivo.'.
            UNDO, LEAVE.
        END.

        RUN validaRateios   IN THIS-PROCEDURE.
/*         IF RETURN-VALUE = 'NOK' THEN */
/*             UNDO, LEAVE.             */
    END.

    IF NOT CAN-FIND(FIRST tt-log) THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.num-linha = fnLinha().
        ASSIGN tt-log.linha = 'As informaá‰es foram importadas com sucesso! Verifique o programa de Manutená∆o de Rateios.'.
    END.


    RETURN 'OK'.
END PROCEDURE.



PROCEDURE carregaRateios:

    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEFINE VARIABLE lRegIgual   AS LOGICAL      NO-UNDO.


    FOR EACH ttRat_ctbl NO-LOCK
        WHERE ttRat_ctbl.cod_empresa  >= cCod_empresa_ini
          AND ttRat_ctbl.cod_empresa  <= cCod_empresa_end
          AND ttRat_ctbl.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND ttRat_ctbl.cod_rat_ctbl <= cCod_rat_ctbl_end
        ON ERROR UNDO, RETURN 'NOK':
        FIND rat_ctbl OF ttRat_ctbl NO-ERROR.
        IF NOT AVAILABLE rat_ctbl THEN
            CREATE rat_ctbl.
        BUFFER-COPY ttRat_ctbl TO rat_ctbl.
    END.


    FOR EACH ttItem_rat_ctbl NO-LOCK
        WHERE ttItem_rat_ctbl.cod_empresa  >= cCod_empresa_ini
          AND ttItem_rat_ctbl.cod_empresa  <= cCod_empresa_end
          AND ttItem_rat_ctbl.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND ttItem_rat_ctbl.cod_rat_ctbl <= cCod_rat_ctbl_end
        ON ERROR UNDO, RETURN 'NOK':

        IF NOT CAN-FIND(rat_ctbl OF ttItem_rat_ctbl) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Matriz de Rateio para o Item ' + ttItem_rat_ctbl.cod_empresa + '/' + 
                                      ttItem_rat_ctbl.cod_rat_ctbl + '/' + STRING(ttItem_rat_ctbl.num_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.

        FIND item_rat_ctbl EXCLUSIVE-LOCK
            WHERE item_rat_ctbl.cod_empresa      = ttItem_rat_ctbl.cod_empresa
              AND item_rat_ctbl.cod_rat_ctbl     = ttItem_rat_ctbl.cod_rat_ctbl
              AND item_rat_ctbl.num_seq_rat_ctbl = ttItem_rat_ctbl.num_seq_rat_ctbl
            NO-ERROR.
        IF NOT AVAILABLE item_rat_ctbl THEN
            CREATE item_rat_ctbl.
        BUFFER-COPY ttItem_rat_ctbl TO item_rat_ctbl.
    END.


    FOR EACH ttRat_ctbl_orig NO-LOCK
        WHERE ttRat_ctbl_orig.cod_empresa  >= cCod_empresa_ini
          AND ttRat_ctbl_orig.cod_empresa  <= cCod_empresa_end
          AND ttRat_ctbl_orig.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND ttRat_ctbl_orig.cod_rat_ctbl <= cCod_rat_ctbl_end
        ON ERROR UNDO, RETURN 'NOK':

        IF NOT CAN-FIND(rat_ctbl OF ttRat_ctbl_orig) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Matriz de Rateio para a Origem do Item ' + ttRat_ctbl_orig.cod_empresa + '/' + 
                                      ttRat_ctbl_orig.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_orig.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_orig.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.

        IF NOT CAN-FIND(item_rat_ctbl OF ttRat_ctbl_orig) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Item de Rateio para a Origem ' + ttRat_ctbl_orig.cod_empresa + '/' + 
                                      ttRat_ctbl_orig.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_orig.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_orig.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.


        FIND rat_ctbl_orig EXCLUSIVE-LOCK
            WHERE rat_ctbl_orig.cod_empresa      = ttRat_ctbl_orig.cod_empresa
              AND rat_ctbl_orig.cod_rat_ctbl     = ttRat_ctbl_orig.cod_rat_ctbl
              AND rat_ctbl_orig.num_seq_rat_ctbl = ttRat_ctbl_orig.num_seq_rat_ctbl
              AND rat_ctbl_orig.num_ord_seq_rat_ctbl = ttRat_ctbl_orig.num_ord_seq_rat_ctbl
            NO-ERROR.
        IF NOT AVAILABLE rat_ctbl_orig THEN
            CREATE rat_ctbl_orig.
        BUFFER-COPY ttRat_ctbl_orig TO rat_ctbl_orig.


        /*foráa validaá‰es valores*/
        IF NOT CAN-FIND(ttItem_rat_ctbl
                        WHERE ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_orig.cod_empresa
                          AND ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_orig.cod_rat_ctbl
                          AND ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_orig.num_seq_rat_ctbl) THEN DO:
            CREATE ttItem_rat_ctbl.
            ASSIGN ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_orig.cod_empresa
                   ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_orig.cod_rat_ctbl
                   ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_orig.num_seq_rat_ctbl.
        END.

    END.


    FOR EACH ttRat_ctbl_dest NO-LOCK
        WHERE ttRat_ctbl_dest.cod_empresa  >= cCod_empresa_ini
          AND ttRat_ctbl_dest.cod_empresa  <= cCod_empresa_end
          AND ttRat_ctbl_dest.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND ttRat_ctbl_dest.cod_rat_ctbl <= cCod_rat_ctbl_end
        ON ERROR UNDO, RETURN 'NOK':

        IF NOT CAN-FIND(rat_ctbl OF ttRat_ctbl_dest) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Matriz de Rateio para o Destino do Item ' + ttRat_ctbl_dest.cod_empresa + '/' + 
                                      ttRat_ctbl_dest.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_dest.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_dest.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.

        IF NOT CAN-FIND(item_rat_ctbl OF ttRat_ctbl_dest) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Item de Rateio para o Destino ' + ttRat_ctbl_dest.cod_empresa + '/' + 
                                      ttRat_ctbl_dest.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_dest.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_dest.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.


        FIND rat_ctbl_dest EXCLUSIVE-LOCK
            WHERE rat_ctbl_dest.cod_empresa      = ttRat_ctbl_dest.cod_empresa
              AND rat_ctbl_dest.cod_rat_ctbl     = ttRat_ctbl_dest.cod_rat_ctbl
              AND rat_ctbl_dest.num_seq_rat_ctbl = ttRat_ctbl_dest.num_seq_rat_ctbl
              AND rat_ctbl_dest.num_ord_seq_rat_ctbl = ttRat_ctbl_dest.num_ord_seq_rat_ctbl
            NO-ERROR.
        IF NOT AVAILABLE rat_ctbl_dest THEN
            CREATE rat_ctbl_dest.
        BUFFER-COPY ttRat_ctbl_dest TO rat_ctbl_dest.


        /*foráa validaá‰es valores*/
        IF NOT CAN-FIND(ttItem_rat_ctbl
                        WHERE ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_dest.cod_empresa
                          AND ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_dest.cod_rat_ctbl
                          AND ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_dest.num_seq_rat_ctbl) THEN DO:
            CREATE ttItem_rat_ctbl.
            ASSIGN ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_dest.cod_empresa
                   ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_dest.cod_rat_ctbl
                   ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_dest.num_seq_rat_ctbl.
        END.

    END.


    FOR EACH ttRat_ctbl_dest_mapa NO-LOCK
        WHERE ttRat_ctbl_dest_mapa.cod_empresa  >= cCod_empresa_ini
          AND ttRat_ctbl_dest_mapa.cod_empresa  <= cCod_empresa_end
          AND ttRat_ctbl_dest_mapa.cod_rat_ctbl >= cCod_rat_ctbl_ini
          AND ttRat_ctbl_dest_mapa.cod_rat_ctbl <= cCod_rat_ctbl_end
        ON ERROR UNDO, RETURN 'NOK':

        IF NOT CAN-FIND(rat_ctbl OF ttRat_ctbl_dest_mapa) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Matriz de Rateio para o Mapa de Centro de Custo do Item ' + ttRat_ctbl_dest_mapa.cod_empresa + '/' + 
                                      ttRat_ctbl_dest_mapa.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_dest_mapa.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.

        IF NOT CAN-FIND(item_rat_ctbl OF ttRat_ctbl_dest_mapa) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Item de Rateio para o Mapa de Centro de Custo do Item ' + ttRat_ctbl_dest_mapa.cod_empresa + '/' + 
                                      ttRat_ctbl_dest_mapa.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_dest_mapa.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.

        IF NOT CAN-FIND(rat_ctbl_dest OF ttRat_ctbl_dest_mapa) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'N∆o encontrado Destino do Item de Rateio para o Mapa de Centro de Custo do Item ' + ttRat_ctbl_dest_mapa.cod_empresa + '/' + 
                                      ttRat_ctbl_dest_mapa.cod_rat_ctbl + '/' + STRING(ttRat_ctbl_dest_mapa.num_seq_rat_ctbl) +
                                      '/' + STRING(ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl)
                   lErro = YES.
            NEXT.
        END.


        FIND rat_ctbl_dest_mapa EXCLUSIVE-LOCK
            WHERE rat_ctbl_dest_mapa.cod_empresa      = ttRat_ctbl_dest_mapa.cod_empresa
              AND rat_ctbl_dest_mapa.cod_rat_ctbl     = ttRat_ctbl_dest_mapa.cod_rat_ctbl
              AND rat_ctbl_dest_mapa.num_seq_rat_ctbl = ttRat_ctbl_dest_mapa.num_seq_rat_ctbl
              AND rat_ctbl_dest_mapa.num_ord_seq_rat_ctbl = ttRat_ctbl_dest_mapa.num_ord_seq_rat_ctbl
            NO-ERROR.
        IF NOT AVAILABLE rat_ctbl_dest_mapa THEN
            CREATE rat_ctbl_dest_mapa.
        BUFFER-COPY ttRat_ctbl_dest_mapa TO rat_ctbl_dest_mapa.


        /*foráa validaá‰es valores*/
        IF NOT CAN-FIND(ttItem_rat_ctbl
                        WHERE ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_dest_mapa.cod_empresa
                          AND ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_dest_mapa.cod_rat_ctbl
                          AND ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_dest_mapa.num_seq_rat_ctbl) THEN DO:
            CREATE ttItem_rat_ctbl.
            ASSIGN ttItem_rat_ctbl.cod_empresa      = ttRat_ctbl_dest_mapa.cod_empresa
                   ttItem_rat_ctbl.cod_rat_ctbl     = ttRat_ctbl_dest_mapa.cod_rat_ctbl
                   ttItem_rat_ctbl.num_seq_rat_ctbl = ttRat_ctbl_dest_mapa.num_seq_rat_ctbl.
        END.

    END.


    IF lErro THEN
        RETURN 'NOK'.
    ELSE
        RETURN 'OK'.
END PROCEDURE.


PROCEDURE validaRateios:

    DEFINE VARIABLE v_val_origem    AS DECIMAL      NO-UNDO DECIMALS 4.
    DEFINE VARIABLE v_val_destino   AS DECIMAL      NO-UNDO DECIMALS 4.
    DEFINE VARIABLE lErro           AS LOGICAL      NO-UNDO INITIAL NO.


    FOR EACH ttItem_rat_ctbl NO-LOCK
            WHERE ttItem_rat_ctbl.cod_empresa  >= cCod_empresa_ini
              AND ttItem_rat_ctbl.cod_empresa  <= cCod_empresa_end
              AND ttItem_rat_ctbl.cod_rat_ctbl >= cCod_rat_ctbl_ini
              AND ttItem_rat_ctbl.cod_rat_ctbl <= cCod_rat_ctbl_end ,
        FIRST item_rat_ctbl NO-LOCK
            WHERE item_rat_ctbl.cod_empresa     = ttItem_rat_ctbl.cod_empresa
              AND item_rat_ctbl.cod_rat_ctbl    = ttItem_rat_ctbl.cod_rat_ctbl
              AND item_rat_ctbl.num_seq_rat_ctbl = ttItem_rat_ctbl.num_seq_rat_ctbl:

        IF item_rat_ctbl.log_gera_lancto_ctbl_orig THEN
            ASSIGN v_val_origem = 100.
        ELSE
            ASSIGN v_val_origem = 0.

        ASSIGN v_val_destino = 0.


        FOR EACH rat_ctbl_dest NO-LOCK OF item_rat_ctbl:

            IF rat_ctbl_dest.log_inverte_natur_ctbl THEN
                ASSIGN v_val_origem  = v_val_origem  + rat_ctbl_dest.val_perc_rat_ctbl.
            ELSE
                ASSIGN v_val_destino = v_val_destino + rat_ctbl_dest.val_perc_rat_ctbl.

        END.


        IF v_val_origem <> v_val_destino THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = 'Rateio n∆o confere entre Origem e Destino na tentativa de importar o seguinte item:'.

            CREATE tt-log.
            ASSIGN tt-log.num-linha = fnLinha().
            ASSIGN tt-log.linha     = ' - Empresa '   + item_rat_ctbl.cod_empresa  +
                                        ' Rateio '    + item_rat_ctbl.cod_rat_ctbl +
                                        ' Item ' + STRING(item_rat_ctbl.num_seq_rat_ctbl).

            ASSIGN lErro = YES.
        END.

    END.

    IF lErro THEN
        RETURN 'NOK'.
    ELSE
        RETURN 'OK'.

END PROCEDURE.


PROCEDURE PiImprimeRelat:


    VIEW STREAM Stream_1 FRAME fCabec132.
    VIEW STREAM Stream_1 FRAME fRodape132.


    FOR EACH tt-log NO-LOCK:
        DISPLAY STREAM Stream_1 tt-log.linha WITH WIDTH 132 NO-LABEL STREAM-IO NO-BOX.
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


IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".

