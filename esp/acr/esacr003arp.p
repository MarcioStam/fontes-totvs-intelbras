/*****************************************************************************
**     Programa.........: esp/acr/esacr003arp.p
**     Descricao .......: Relat¢rio D¡vidas Cliente
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 09/12/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
{esp\acr\esacr003tt.i}

form
    tt_Cliente.cdn_cliente                      label "Cliente" 
    tt_Cliente.nom_pessoa               no-label 
    tt_Cliente.cod_telefone                     label "Tel" skip
    tt_Cliente.nom_cidade                       label "Cidade" 
    tt_Cliente.des_grp_clien    format "X(15)"  label "Gr"
    tt_Cliente.cod_unid_federac                 label " UF"
    tt_Cliente.nom_abrev_repres                 label "Repres"
    with row 3 no-box width 80 overlay side-labels frame f-emitente STREAM-IO.

form     
    tt_Cliente.d-saldo       label "TOTAL ORIGINAL"
    tt_Cliente.d-saldoc      label "TOTAL CLIENTE"
    tt_Cliente.d-credito     label "CREDITO"
    '                '
    tt_Cliente.d-vl-cartorio FORMAT '-ZZ,ZZ9.99' LABEL "TOTAL CARTORIO" SKIP
    tt_Cliente.d-vecdo       LABEL "TOTAL VENCIDO"
    tt_Cliente.d-avcer       LABEL "TOTAL A VENCER"
    with row 18 width 180 overlay side-labels frame f-tot STREAM-IO. 

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

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio D¡vidas Cliente".

DEFINE INPUT PARAM TABLE FOR tt_saldo.
DEFINE INPUT PARAM TABLE FOR tt_Cliente.
DEFINE INPUT PARAM rs-opcao AS INTEGER.

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
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr003a"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr003a"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr003a.lst".
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

ASSIGN C-Programa          = "esacr003a"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio D¡vidas Cliente"
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

PROCEDURE piImprimeRelat.
    
    /*
    IF INPUT FRAME {&FRAME-NAME} rs-opcao = 1 THEN
         OPEN QUERY {&SELF-NAME} FOR EACH tt_saldo USE-INDEX ix-dt-venc NO-LOCK INDEXED-REPOSITION.
    ELSE OPEN QUERY {&SELF-NAME} FOR EACH tt_saldo USE-INDEX ix-tit     NO-LOCK INDEXED-REPOSITION.
    */
    FOR FIRST tt_Cliente.
        DISP STREAM Stream_1
             tt_Cliente.cdn_cliente 
             tt_Cliente.nom_pessoa  
             tt_Cliente.cod_telefone
             tt_Cliente.nom_cidade  
             tt_Cliente.des_grp_clien
             tt_Cliente.cod_unid_federac
             tt_Cliente.nom_abrev_repres
             with frame f-emitente.
    END.
    
    IF rs-opcao = 2 THEN DO:
       FOR EACH tt_saldo USE-INDEX ix-tit NO-LOCK:
           DISP STREAM Stream_1 
                 tt_saldo.cod_espec_docto        COLUMN-LABEL "Esp"
                 tt_saldo.cod_ser_docto          COLUMN-LABEL "Serie"
                 tt_saldo.cod_tit_acr            COLUMN-LABEL "T¡tulo"
                 tt_saldo.cod_parcela            COLUMN-LABEL "/P"
                 tt_saldo.dat_emis_docto         COLUMN-LABEL "EmissÆo"
                 tt_saldo.dat_vencto_tit_acr     COLUMN-LABEL "Vencto"
                 tt_saldo.val_origin_tit_acr     COLUMN-LABEL "Vl. Orig."
                 tt_saldo.val_sdo_tit_acr        COLUMN-LABEL "Vl. Cli."
                 tt_saldo.num_planinha_vendor    COLUMN-LABEL "Vendor"
                 tt_saldo.num_atr                COLUMN-LABEL "Atr s"   FORMAT '->>>9'
                 tt_saldo.cod_portador           COLUMN-LABEL "Por"
                 tt_saldo.cod_cart_bcia          COLUMN-LABEL "Cart"
                 tt_saldo.cod_tit_acr_bco        COLUMN-LABEL "Num Banco"
                 tt_saldo.val_desp_cartorio      COLUMN-LABEL "Vl. Cart¢rio"
                 /**** Em 28/01/2005 - Mario Fleith - Solicitado pela Ione
                 tt_saldo.cod_boleto_impresso    COLUMN-LABEL "Boleto Impresso"    
                 tt_saldo.cod_perda              COLUMN-LABEL "Indic. Perda"
                 tt_saldo.ind_sit_envio          COLUMN-LABEL "Status Envio"
                 Em 28/01/2005 - Mario Fleith - Solicitado pela Ione****/
                WITH WIDTH 200 STREAM-IO DOWN.
       END.
    END.
    ELSE DO:
       FOR EACH tt_saldo USE-INDEX ix-dt-venc NO-LOCK:
           DISP STREAM Stream_1 
                 tt_saldo.cod_espec_docto        COLUMN-LABEL "Esp"
                 tt_saldo.cod_ser_docto          COLUMN-LABEL "Serie"
                 tt_saldo.cod_tit_acr            COLUMN-LABEL "T¡tulo"
                 tt_saldo.cod_parcela            COLUMN-LABEL "/P"
                 tt_saldo.dat_emis_docto         COLUMN-LABEL "EmissÆo"
                 tt_saldo.dat_vencto_tit_acr     COLUMN-LABEL "Vencto"
                 tt_saldo.val_origin_tit_acr     COLUMN-LABEL "Vl. Orig."
                 tt_saldo.val_sdo_tit_acr        COLUMN-LABEL "Vl. Cli."
                 tt_saldo.num_planinha_vendor    COLUMN-LABEL "Vendor"
                 tt_saldo.num_atr                COLUMN-LABEL "Atr s"    FORMAT '->>>9'
                 tt_saldo.cod_portador           COLUMN-LABEL "Por"
                 tt_saldo.cod_cart_bcia          COLUMN-LABEL "Cart"
                 tt_saldo.cod_tit_acr_bco        COLUMN-LABEL "Num Banco"
                 tt_saldo.val_desp_cartorio      COLUMN-LABEL "Vl. Cart¢rio"
                 /**** Em 28/01/2005 - Mario Fleith - Solicitado pela Ione
                 tt_saldo.cod_boleto_impresso    COLUMN-LABEL "Boleto Impresso"    
                 tt_saldo.cod_perda              COLUMN-LABEL "Indic. Perda"
                 tt_saldo.ind_sit_envio          COLUMN-LABEL "Status Envio"
                 Em 28/01/2005 - Mario Fleith - Solicitado pela Ione******/
                WITH WIDTH 200 STREAM-IO DOWN.
       END.
    END.

    FOR FIRST tt_Cliente:
        DISP STREAM Stream_1 
             tt_Cliente.d-saldo  
             tt_Cliente.d-saldoc 
             tt_Cliente.d-credito
             tt_Cliente.d-vl-cartorio
             tt_Cliente.d-vecdo
             tt_Cliente.d-avcer
             WITH FRAME f-tot.
    END.
    
    PUT STREAM Stream_1 SKIP(2)
        'Usu rio Execu‡Æo: ' CAPS(v_cod_usuar_corren) ' Hora Execu‡Æo: ' STRING(TIME,'hh:mm:ss') ' Data Execu‡Æo: ' TODAY FORMAT '99/99/9999' ' ESACR003rp.p'.


END PROCEDURE. /* End da PROCEDURE piImprimeRelat */

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
