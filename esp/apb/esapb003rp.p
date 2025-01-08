 /*****************************************************************************
**     Programa.........: esp/apb/esapb003rp.p
**     Descricao .......: Relat¢rio Prazo M‚dio Fornecedor
**     Versao...........: 1.00.000
**     Autor............: Joel Ricardo Geisler - Gestech
**     Criado...........: 29/01/2005
**     Desc. Atualiza‡Æo: 
*******************************************************************************/

{esinc\es0000.i}

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

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

def temp-table tt-fornec
    field cdn_fornecedor  like tit_ap.cdn_fornecedor
    field nom_pessoa      like emscad.fornecedor.nom_pessoa
    field cod_tit_ap      like tit_ap.cod_tit_ap
    field cod_espec_docto like tit_ap.cod_espec_docto
    field valor           like tit_ap.val_origin_tit_ap
    field dias            as int
    field pm              LIKE tit_ap.val_origin_tit_ap
    index codigo is primary cdn_fornecedor.

DEFINE VARIABLE v-cdn-fornec-fin LIKE tit_ap.cdn_fornecedor    NO-UNDO.
DEFINE VARIABLE v-cdn-fornec-ini LIKE tit_ap.cdn_fornecedor    NO-UNDO.
DEFINE VARIABLE v-cod-grp-fin    LIKE tit_ap.cod_grp_fornec    NO-UNDO.
DEFINE VARIABLE v-cod-grp-ini    LIKE tit_ap.cod_grp_fornec    NO-UNDO.
DEFINE VARIABLE v-dat-fin        AS DATE FORMAT "99/99/9999":U NO-UNDO.
DEFINE VARIABLE v-dat-ini        AS DATE FORMAT "99/99/9999":U NO-UNDO.
def var de-pm                    like tit_ap.val_origin_tit_ap NO-UNDO.
def var de-total                 like tit_ap.val_origin_tit_ap NO-UNDO.
def var de-pm-geral              like tit_ap.val_origin_tit_ap NO-UNDO.
def var de-total-geral           like tit_ap.val_origin_tit_ap NO-UNDO.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR.

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb003"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer
          v-cdn-fornec-ini = INT(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
          v-cdn-fornec-fin = INT(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          v-cod-grp-ini    = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
          v-cod-grp-fin    = ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
          v-dat-ini        = DATE(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
          v-dat-fin        = DATE(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
          C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout.
  END. /* End do IF AVAIL Ped_Exec_Param */


    FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
  IF AVAIL ped_exec THEN DO:
     FIND FIRST servid_exec WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-LOCK NO-ERROR.
     IF AVAIL servid_exec THEN DO:
         IF servid_exec.ind_tip_fila_exec = 'unix' THEN
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '/' + V_Cod_Dwb_File.
         ELSE
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + '\' + V_Cod_Dwb_File.
     END.
  END.



END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb003rp"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           v-cdn-fornec-ini = INT(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v-cdn-fornec-fin = INT(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           v-cod-grp-ini    = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v-cod-grp-fin    = ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v-dat-ini        = DATE(ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           v-dat-fin        = DATE(ENTRY(7,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esapb003.lst".
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

ASSIGN C-Programa          = "esapb003"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Prazo M‚dio Fornecedor"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       C-Empresa           = "Intelbras".

       Ch_Linha            = FILL("-",132).

{esinc\es0002.i 132}

ASSIGN V_Num_Pag = 1.

RUN piGeraTt.      /* Grava informa‡äes para impressÆo */
RUN piImprimeRelat.  /* Imprime relat¢rio em formato padrÆo EMS 5 */

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat.
    VIEW STREAM Stream_1 FRAME fCabec132.
    VIEW STREAM Stream_1 FRAME fRodape132.

    for each tt-fornec 
       break by tt-fornec.cdn_fornecedor:
        if first(tt-fornec.cdn_fornecedor) THEN
            assign de-total-geral = 0
                   de-pm-geral  = 0.
        if first-of(tt-fornec.cdn_fornecedor) then DO:
            assign de-total = 0
                   de-pm    = 0.

            DISP STREAM Stream_1
                 tt-fornec.cdn_fornecedor
                 tt-fornec.nom_pessoa
                WITH WIDTH 200 STREAM-IO.

        END.
        assign de-total       = de-total       + tt-fornec.valor
               de-pm          = de-pm          + tt-fornec.pm
               de-total-geral = de-total-geral + tt-fornec.valor
               de-pm-geral    = de-pm-geral    + tt-fornec.pm.
        DISP STREAM Stream_1
             tt-fornec.cdn_fornecedor
             tt-fornec.nom_pessoa
             tt-fornec.cod_espec_docto
             tt-fornec.cod_tit_ap
             tt-fornec.valor
             tt-fornec.dias
            WITH WIDTH 200 STREAM-IO.
        
        if last-of(tt-fornec.cdn_fornecedor) then
            disp STREAM Stream_1
                 de-pm / de-total format ">>>,>>>,>>9.99" column-label "PMP" with width 132.
        if last(tt-fornec.cdn_fornecedor) then
            disp STREAM Stream_1
                 de-pm-geral / de-total-geral format ">>>,>>>,>>9.99" column-label "PMP Geral" with width 132.
    end.

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */

PROCEDURE piGeraTt.
    for each espec_docto
       where espec_docto.ind_tip_espec_docto = "NORMAL", /* Joel 29/01/2005 */
        each tit_ap no-lock
       where tit_ap.cod_espec_docto = espec_docto.cod_espec_docto
         and tit_ap.cod_empresa     = "1"
         and tit_ap.cod_estab       = "101"
         and tit_ap.dat_emis_docto >= v-dat-ini
         and tit_ap.dat_emis_docto <= v-dat-fin,
        each emscad.fornecedor no-lock
       where emscad.fornecedor.cdn_fornecedor   = tit_ap.cdn_fornecedor
         and emscad.fornecedor.cdn_fornecedor  >= v-cdn-fornec-ini
         and emscad.fornecedor.cdn_fornecedor  <= v-cdn-fornec-fin
         and emscad.fornecedor.cod_grp_fornec  >= v-cod-grp-ini   
         and emscad.fornecedor.cod_grp_fornec  <= v-cod-grp-fin:  
        create tt-fornec.
        assign tt-fornec.cdn_fornecedor  = tit_ap.cdn_fornecedor                           
               tt-fornec.nom_pessoa      = emscad.fornecedor.nom_pessoa                           
               tt-fornec.valor           = tit_ap.val_origin_tit_ap                        
               tt-fornec.dias            = tit_ap.dat_vencto_tit_ap - tit_ap.dat_emis_docto
               tt-fornec.cod_tit_ap      = tit_ap.cod_tit_ap                               
               tt-fornec.cod_espec_docto = tit_ap.cod_espec_docto                          
               tt-fornec.pm              = tt-fornec.valor * tt-fornec.dias.
    end.
END PROCEDURE. /* End da PROCEDURE RUN piGeraTt. */

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
