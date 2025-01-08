/*****************************************************************************
**     Programa.........: esp/es0251rp.p
**     Descricao .......: Emiss∆o DARF
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 21/01/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

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

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
DEF VAR I                       AS INTE NO-UNDO.
DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_File_2        LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR V_Cod_Dwb_Output_2      LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Impressora_2          LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR C-Layout_2              LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
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
DEF STREAM STREAM_2.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 64.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 200.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 64.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relaá∆o de Documentos - DARF".


def temp-table tt-ap
    field cod-esp         like tit_ap.cod_espec_docto
    field cdn_fornec      like fornec_financ.cdn_fornec
    field cdn_fornec_orig like fornec_financ.cdn_fornec
    field ep-codigo       like tit_ap.cod_empresa
    field cod-estabel     like tit_ap.cod_estab
    field nome-abrev      like emscad.fornecedor.nom_abrev
    field nome-abrev_orig like emscad.fornecedor.nom_pessoa
    field nr-docto        like tit_ap.cod_tit_ap
    field parcela         like tit_ap.cod_parcela
    field dt-transacao    like tit_ap.dat_transacao
    field dt-vencimen     like tit_ap.dat_vencto_tit_ap
    field dt-liquidac     like tit_ap.dat_liquidac
    field valor-original  like tit_ap.val_origin_tit_ap
    field valor-saldo     like tit_ap.val_sdo_tit_ap
    field cod-retencao    LIKE classif_impto.cod_classif_impto
    field serie           like tit_ap.cod_ser_docto
    field l-ok            as char format "x(1)"
    FIELD valor-rendto    LIKE compl_impto_retid_ap.val_rendto_tribut
    index codigo is primary cod-retencao dt-transacao.


DEF INPUT PARAM TABLE FOR tt-ap.
DEF INPUT PARAM dt-apura AS DATE FORMAT "99/99/9999".
DEF INPUT PARAM dt-vencto AS DATE FORMAT "99/99/9999".
DEF INPUT PARAM c-texto AS CHAR.

def var de-valor as dec.
def var de-valor-1 as dec.

def frame f_header header
    "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    "P†gina: " at 183 (page-number (Stream_1)) to 194 format ">>9" skip
    c-empresa at 1 format "x(40)"
    fill(" ", 40 - length(trim(V_Rpt_Stream_1_Name))) + trim(V_Rpt_Stream_1_Name) to 194 format "x(40)" skip
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    TODAY at 173 format "99/99/9999"
    "-" at 184
    String(TIME,"HH:MM:SS") at 187 skip (1)
    with no-box no-labels width 200 page-top stream-io.
  
def frame f_footer header
    skip (1)
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    "ESAPB001RP" at 173
    "-" at 184
    "1.00.000" at 187 skip
    with no-box no-labels width 200 page-bottom stream-io.


RUN pi-param-relat.
RUN pi-param-relat2.

ASSIGN C-Programa          = "esapb001rp"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relaá∆o de Documentos - DARF"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",200).

ASSIGN V_Num_Pag = 1.

VIEW STREAM Stream_1 FRAME f_header.
VIEW STREAM Stream_1 FRAME f_footer.
RUN Pi_Imprime_Relat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */

OUTPUT STREAM STREAM_2 CLOSE.
OUTPUT STREAM Stream_1 CLOSE.


IF V_Cod_Dwb_Output = "Terminal" 
    THEN RUN pi_show_report_2 (INPUT V_Cod_Dwb_File).

IF V_Cod_Dwb_Output_2 = "3" 
    THEN RUN pi_show_report_2 (INPUT V_Cod_Dwb_File_2).

RETURN "ok".

/* fim do programa */

PROCEDURE Pi_Imprime_Relat.
        assign de-valor = 0
               de-valor-1 = 0.
    
        for each tt-ap
            where tt-ap.l-ok = "*"
            BREAK BY tt-ap.cod-retencao:
                assign de-valor = de-valor + tt-ap.valor-saldo
                       de-valor-1 = de-valor-1 + tt-ap.valor-saldo.

                disp STREAM Stream_1 tt-ap.cod-retencao COLUMN-LABEL "Imp"
                     tt-ap.cod-esp      FORMAT 'x(2)' COLUMN-LABEL 'Esp'
                     tt-ap.cdn_fornec   COLUMN-LABEL 'Forn'
                     tt-ap.nome-abrev  
                     tt-ap.cod-estabel  COLUMN-LABEL 'Est'
                     tt-ap.serie        COLUMN-LABEL 'Ser'
                     tt-ap.nr-docto     
                     tt-ap.parcela     
                     tt-ap.dt-transacao
                     tt-ap.dt-liquidac  COLUMN-LABEL 'Dt Pgto'
                     tt-ap.dt-vencimen 
                     tt-ap.valor-rendto
                     tt-ap.valor-original
                     tt-ap.valor-saldo 
                     tt-ap.cdn_fornec_orig COLUMN-LABEL 'Forn. Orig'
                     tt-ap.nome-abrev_orig COLUMN-LABEL 'Nome Forn. Orig' FORMAT "x(35)"
                    with width 200 STREAM-IO.
                    
                IF LAST-OF(tt-ap.cod-retencao) THEN DO:
                   PUT STREAM Stream_1 SKIP
                       '-----------'                  AT 131
                       'Total do Codigo de Retená∆o ' AT 094 
                        tt-ap.cod-retencao            AT 122
                        'R$ '                         AT 127
                        de-valor                      AT 132
                        SKIP(2).
                   RUN pi_imprime_darf.
                   ASSIGN de-valor = 0.
                END.

        end.
    
        put STREAM Stream_1 skip(2) "Valor Total deste DARF : " de-valor-1 skip(2) "".

END PROCEDURE. /* End da PROCEDURE Pi_Imprime_Relat */


PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE. /* pi_show_report_2 */

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

PROCEDURE pi_imprime_darf:

PUT STREAM STREAM_2 SKIP(1).

disp STREAM stream_2 dt-apura   at 120  skip(1)
     "82.901.000/0001-27" at 120 skip(1)
     tt-ap.cod-retencao   at 120 skip(1)
     string(month(dt-apura),"99") + "/" +
     string(year(dt-apura),"9999") at 120 skip(1)
     "INTELBRAS S/A     281-9526" at 20
     dt-vencto                    at 120 skip(1)
     c-texto FORMAT "X(60)" AT 6 
     STRING(de-valor) at 120 skip(5)
     STRING(de-valor) at 120 skip(5)
     with no-labels STREAM-IO width 172.
     
END PROCEDURE.

PROCEDURE pi-param-relat:

    FIND FIRST EmsUni.Empresa NO-LOCK 
         WHERE Empresa.Cod_Empresa = V_Cod_Empres_Usuar NO-ERROR.
    IF AVAIL Empresa
    THEN ASSIGN C-Empresa = Empresa.Nom_Razao_Social.
    ELSE ASSIGN C-Empresa = "".
    
    IF V_Cod_Dwb_User = "" 
    THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.
    
      FIND Dwb_Set_List_Param NO-LOCK
           WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb001"
             AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
           NO-ERROR.
      IF AVAIL Dwb_Set_List_Param THEN 
      DO.
        ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
               V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
               C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
               C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout.
      END. /* End do IF AVAIL Ped_Exec_Param */
    
    DO.   /* seta a saida da impressao */
      CASE V_Cod_Dwb_Output:
        WHEN "Terminal" /*l_Terminal*/  THEN 
        DO.
          ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esapb001.lst".
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
    
          
          OUTPUT STREAM Stream_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                               PAGED 
                                               PAGE-SIZE 
                                               VALUE(V_Rpt_Stream_1_Lines) 
                                               CONVERT TARGET 'ibm850'.
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

END PROCEDURE.

PROCEDURE pi-param-relat2:
    
      FIND Dwb_Set_List_Param NO-LOCK
           WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb001"
             AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
           NO-ERROR.
      IF AVAIL Dwb_Set_List_Param THEN 
      DO.      
        ASSIGN V_Cod_Dwb_File_2   = entry(2,Dwb_Set_list_Param.Cod_Dwb_parameters,CHR(10))
               V_Cod_Dwb_Output_2 = entry(1,Dwb_Set_list_Param.Cod_Dwb_parameters,CHR(10))
               C-Impressora_2     = entry(3,Dwb_Set_list_Param.Cod_Dwb_parameters,CHR(10))
               C-Layout_2         = entry(4,Dwb_Set_list_Param.Cod_Dwb_parameters,CHR(10)).
      END. /* End do IF AVAIL Ped_Exec_Param */

    DO.   /* seta a saida da impressao */
      CASE V_Cod_Dwb_Output_2:
        WHEN "3" /*l_Terminal*/  THEN 
        DO.
          ASSIGN V_Cod_Dwb_File_2   = session:temp-directory + "esapb001-darf.lst".
          OUTPUT STREAM Stream_2 TO VALUE(V_Cod_Dwb_File_2) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET 'iso8859-1'.
        END.
        WHEN "1" /*l_Printer*/  THEN 
        DO.

          FIND Imprsor_Usuar NO-LOCK
              WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora_2
                AND Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User
              USE-INDEX imprsrsr_id NO-ERROR.
          FIND layout_impres NO-LOCK
               WHERE Layout_Impres.Nom_Impressora    = C-Impressora_2
                 AND Layout_Impres.Cod_Layout_Impres = C-Layout_2
               NO-ERROR.
          ASSIGN V_Rpt_Stream_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_Stream_1_Bottom - V_Rpt_Stream_1_Lines */
                 V_Rpt_Stream_1_Lines  = Layout_Impres.Num_Lin_Pag.
    

          OUTPUT STREAM Stream_2 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
/*                                               PAGED 
                                               PAGE-SIZE 
                                               VALUE(V_Rpt_Stream_1_Lines) */
                                               CONVERT TARGET 'iso8859-1'.
          FOR EACH Configur_Layout_Impres NO-LOCK
              WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
                 BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
            FIND Configur_Tip_imprsor NO-LOCK
                 WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
                   AND Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
                   AND Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
                 NO-ERROR.
            PUT STREAM Stream_2 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
          END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
        END. /* End do - WHEN "Impressora" l_Printer */
        WHEN "2" /*l_File*/  THEN 
        DO.
          OUTPUT STREAM Stream_2 TO VALUE(V_Cod_Dwb_File_2)
                                               PAGED 
                                               PAGE-SIZE 
                                               VALUE(V_Rpt_Stream_1_Lines)
                                               CONVERT TARGET 'iso8859-1'.
        END. /* End do - WHEN "Arquivo" - l_File  */
      END. /* End do - CASE V_Cod_Dwb_Output */
    END. /* End do - DO. -- Que seta a saida da impressao */

END PROCEDURE.

RETURN "OK".
