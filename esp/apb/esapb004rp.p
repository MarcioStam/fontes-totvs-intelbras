/*****************************************************************************
**     Programa.........: esp/apb/esapb004rp.p
**     Descricao .......: Relatorio de Comissoes
**     Versao...........: 1.00.000
**     Autor............: Robson Jeorge Moser
**     Criado...........: 25/01/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/
def new global shared var v_cod_empres_usuar      as character format "x(3)":U  label "Empresa"              column-label "Empresa"          no-undo.
def new global shared var v_cod_estab_usuar       as character format "x(3)":U  label "Estabelecimento"      column-label "Estab"            no-undo.
def new global shared var v_cod_grp_usuar_lst     as character format "x(3)":U  label "Grupo Usu†rios"       column-label "Grupo"            no-undo.
def new global shared var v_cod_idiom_usuar       as CHARACTER format "x(8)":U  label "Idioma"               column-label "Idioma"           no-undo.
def new global shared var v_cod_pais_empres_usuar as character format "x(3)":U  label "Pa°s Empresa Usu†rio" column-label "Pa°s"             no-undo.
def new global shared var v_cod_usuar_corren      as character format "x(12)":U label "Usu†rio Corrente"     column-label "Usu†rio Corrente" no-undo.
def new global shared var v_cod_usuar_corren_criptog  as character format "x(16)":U no-undo. 
def new global shared var v5_cod_empres_usuar         as character format 'x(3)' label 'Empresa'              column-label 'Empresa'          no-undo.
def new global shared var v5_cod_estab_usuar          as character format 'x(3)' label 'Estabelecimento'      column-label 'Estab'            no-undo.
def new global shared var v5_cod_grp_usuar_lst        as character label 'Grupo Usu†rios' column-label 'Grupo' no-undo.
def new global shared var v5_cod_idiom_usuar          as character format 'x(8)'          label 'Idioma'       column-label 'Idioma'          no-undo.
def new global shared var v5_cod_pais_empres_usuar    as character format 'x(3)'          label 'Pa°s Empresa Usu†rio' column-label 'Pa°s'    no-undo.
def new global shared var v5_cod_usuar_corren         as character format 'x(12)'         label 'Usu†rio Corrente'     column-label 'Usu†rio Corrente' no-undo.
def new global shared var v5_cod_usuar_corren_criptog as character format 'x(16)' no-undo.

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
DEF VAR c-rodape-var            as char               NO-UNDO.
DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.
DEF VAR c-nota                  AS CHAR FORMAT "X(10)" NO-UNDO.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio de Comiss‰es".

def var repres-ini as INT.
def var repres-fim as INT.
def var gr-fornec-ini as char.
def var gr-fornec-fim as char.
def var data-ini as date format 99/99/9999.
def var data-fim as date format 99/99/9999.
DEF VAR rs-baixa    AS INTEGER.
DEF VAR tg-resumido AS LOGICAL.
DEF VAR tg-envio-email AS LOGICAL.
DEF VAR tg-rel-final-mes AS LOGICAL.
DEF VAR v_nom_e_mail     AS CHAR NO-UNDO.
DEF VAR v_arq_api_ir     AS CHAR NO-UNDO.

def var c_parcela       as char format "99".
def var de_vl_comissao  as dec format "->>,>>>,>>9.99".
def var de_vl_base      as dec format "->>,>>>,>>9.99".
def var de_total_geral  as dec format "->>>,>>>,>>9.99".
def var de_total_base   as dec format "->>>,>>>,>>9.99".
def var de_total_comis  as dec format "->>>,>>>,>>9.99".
def var de_total_saldo  as dec format "->>>,>>>,>>9.99".
def var de_total_ir     as dec format "->>>,>>>,>>9.99".
def var de_total_liq    as dec format "->>>,>>>,>>9.99".
def var l_resumido      as log format "Sim/Nao".
def var c_operacao      as char format "X(3)".
def var de_vl_tmp       as dec format "->>>,>>>,>>9.99".
DEF VAR v_nom_cidade_c       LIKE pessoa_fisic.nom_cidade.
DEF VAR v_cod_unid_federac_c LIKE pessoa_fisic.cod_unid_federac.
DEF VAR v_cod_e_mail         LIKE pessoa_fisic.cod_e_mail.
def var c-valor         as char format "x(14)".
DEF VAR v_arquivo_email AS CHAR FORMAT "x(35)"  NO-UNDO.
DEF VAR v_ct_codigo     LIKE conta-programa.ct-codigo NO-UNDO.
DEF VAR i-seq-ava       AS INTEGER NO-UNDO.
DEF VAR v_num_id_tit_acr LIKE tit_acr.num_id_tit_acr NO-UNDO.
DEF VAR c-ser-docto      LIKE tit_acr.cod_ser_docto.

DEF STREAM Stream_2.

def temp-table tt_imp
    FIELD cdn_fornecedor LIKE emscad.fornecedor.cdn_fornecedor
    FIELD nom_abrev      LIKE emscad.fornecedor.nom_abrev
    field cdn_repres     LIKE representante.cdn_repres
    field nom_abrev_r    LIKE representante.nom_abrev
    field nom_pessoa     LIKE emscad.fornecedor.nom_pessoa
    field cod_ser_docto  LIKE tit_ap.cod_ser_docto column-label "Sr" format "X(03)"
    field cod_tit_ap     LIKE tit_ap.cod_tit_ap  column-label "Docto" format "X(10)"
    field cod_parcela    AS CHAR FORMAT "x(5)" column-label "Parc"
    field dat_vencto_tit_ap LIKE tit_ap.dat_vencto_tit_ap format "99/99/9999" column-label "Dt Vcto"
    field dat_liquidac_tit_ap LIKE tit_ap.dat_liquidac_tit_ap   format "99/99/9999" column-label "Dt Baixa"
    field dat_pedido            as date format "99/99/9999" column-label "Dt Pedido"
    field cdn_cliente           LIKE emscad.cliente.cdn_cliente column-label "Cliente"
    field nom_abrev_c           LIKE emscad.cliente.nom_abrev
    field nom_cidade_c          LIKE pessoa_fisic.nom_cidade
    field cod_unid_federac_c    LIKE  pessoa_fisic.cod_unid_federac
    field cod_grp_clien         LIKE emscad.cliente.cod_grp_clien
    field val_origin_tit_ap     LIKE tit_ap.val_origin_tit_ap format ">>,>>>,>>9.99" 
    field val_perc_comis_repres LIKE repres_tit_acr.val_perc_comis_repres format ">>9.99" 
    field val_base              as dec format ">>,>>>,>>9.99" column-label "Valor Base"
    field cod_e_mail            LIKE pessoa_fisic.cod_e_mail
    index tt-imprime is primary cdn_fornecedor.


/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid        as character format "x(30)"
    field ttv_num_porta_servid        as integer format ">>>>9"
    field ttv_log_exchange        as logical format "Sim/N∆o" initial no
    field ttv_nom_from                as character format "x(50)"
    field ttv_nom_to                as character format "x(50)" label "To"
    field ttv_nom_cc                as character format "x(50)" label "Cc"
    field ttv_nom_subject        as character format "x(30)"
    field ttv_nom_message        as character format "x(50)"
    field ttv_nom_attachfile        as character format "x(30)"
    field ttv_num_imptcia        as integer format "9"
    field ttv_log_envda                as logical format "Sim/N∆o" initial no
    field ttv_log_lida                as logical format "Sim/N∆o" initial no
    field ttv_cod_format_mail   as character format "x(8)"  initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro                as character format "x(10)"
    field ttv_des_erro                as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo        as character format "x(255)".
/* Temp-table para envio de e-mail */                 

/* Temp-table API Alteracao titulo */
{esp/cms/apb767zc.i}

DEF BUFFER b_tit_acr FOR tit_acr.
DEF BUFFER b_tit_ap  FOR tit_ap.

/* relat¢rio comiss∆o ems5 */
form header
    fill("-", 132) format "x(132)" skip
    "INTELBRAS S/A" c-titulo-relat at 50 FORMAT "X(45)"
    "Folha:" at 119 PAGE-NUMBER format ">>>9" skip 
    fill("-", 104) format "x(102)" today format "99/99/9999" /* 112 - 110 */
    "-" string(time, "HH:MM:SS") skip(1)
    with width 134 no-labels no-box page-top frame f-cabec.


form header
    fill("-", 160) format "x(160)" skip
    "INTELBRAS S/A" c-titulo-relat at 64 format "X(45)"
    "Folha:"  at 147 PAGE-NUMBER format ">>>9" skip
    fill("-", 131) format "x(131)" today format "99/99/9999" /* 138 */
    "-" string(time, "HH:MM:SS") skip(1)
    with width 162 no-labels no-box page-top frame f-cabec-var.


form header
    c-rodape format "x(130)"
    with width 132 no-labels no-box page-bottom frame f-rodape.


form header
    c-rodape-var format "x(160)"
    with width 162 no-labels no-box page-bottom frame f-rodape-var.


{esp/es0006a.i} /* Definicao de variaveis para relatorio html */
{esp/es0006.i} /* Controle para geracao de relatorio em html */



FIND FIRST emscad.empresa NO-LOCK 
     WHERE Empresa.Cod_Empresa = V_Cod_Empres_Usuar NO-ERROR.
IF AVAIL Empresa
THEN ASSIGN C-Empresa = Empresa.Nom_Razao_Social.
ELSE ASSIGN C-Empresa = "".

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

/* Conta para AVA IR */
FIND FIRST conta-programa NO-LOCK
    WHERE conta-programa.programa = 'esapb007a'
      AND conta-programa.indice   = 1 NO-ERROR.
IF AVAIL conta-programa THEN
    ASSIGN v_ct_codigo = conta-programa.ct-codigo.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb004rp"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
    ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File         
           V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output       
           C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer      
           C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout
           rs-baixa         = INTEGER(entry(8,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))  
           tg-resumido      = logical(entry(9,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))  
           tg-envio-email   = logical(entry(10,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))) 
           tg-rel-final-mes = logical(entry(11,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))).
   IF Dwb_Set_List_Param.Cod_Dwb_User MATCHES '*comiss*' THEN DO:
      ASSIGN repres-ini       = 0
             repres-fim       = 999999
             gr-fornec-ini    = ''
             gr-fornec-fim    = 'ZZZ'
             data-ini         = DATE('01/' + STRING(MONTH(TODAY)) + '/' + STRING(YEAR(TODAY)))
             data-fim         = TODAY.
   END.
   ELSE DO:
      ASSIGN repres-ini       = int(entry(2,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
             repres-fim       = int(entry(3,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
             gr-fornec-ini    = entry(4,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))
             gr-fornec-fim    = entry(5,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))
             data-ini         = date(entry(6,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
             data-fim         = date(entry(7,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))).
   END.
  END. /* End do IF AVAIL Ped_Exec_Param */

  FIND FIRST Ped_Exec WHERE Ped_Exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
  IF AVAIL Ped_Exec THEN DO:
     FIND FIRST servid_Exec WHERE servid_Exec.cod_servid_exec = Ped_Exec.cod_servid_exec NO-LOCK NO-ERROR.
     IF AVAIL servid_exec THEN DO:
         IF servid_exec.ind_tip_fila_exec = "unix" THEN
            ASSIGN V_Cod_Dwb_File = servid_Exec.nom_dir_spool + "/" + V_Cod_Dwb_File.
         ELSE
            ASSIGN V_Cod_Dwb_File = servid_Exec.nom_dir_spool + "/" + V_Cod_Dwb_File.
     END.
  END.

END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esapb004rp"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_List_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_List_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_List_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_List_Param.Cod_Dwb_Print_layout
           repres-ini = int(entry(2,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           repres-fim = int(entry(3,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           gr-fornec-ini = entry(4,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))
           gr-fornec-fim = entry(5,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))
           data-ini = date(entry(6,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           data-fim = date(entry(7,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           rs-baixa    = INTEGER(entry(8,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           tg-resumido = logical(entry(9,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           tg-envio-email = logical(entry(10,Dwb_Set_List_Param.cod_dwb_parameters,chr(10)))
           tg-rel-final-mes = logical(entry(11,Dwb_Set_List_Param.cod_dwb_parameters,chr(10))).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */

  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esapb004.lst".
      OUTPUT TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET "iso8859-1".
    END.
    WHEN "Impressora" /*l_Printer*/  THEN 
    DO.
      FIND Imprsor_Usuar NO-LOCK
          WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora
            AND Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User
          USE-INDEX imprsrsr_id NO-ERROR.
      FIND layout_impres NO-LOCK
           WHERE layout_impres.Nom_Impressora    = C-Impressora
             AND layout_impres.Cod_Layout_Impres = C-Layout
           NO-ERROR.
      ASSIGN V_Rpt_Stream_1_Bottom = layout_impres.Num_Lin_Pag /* + V_Rpt_Stream_1_Bottom - V_Rpt_Stream_1_Lines */
             V_Rpt_Stream_1_Lines  = layout_impres.Num_Lin_Pag.

      IF OPSYS = "UNIX" THEN 
      DO.
        IF V_Num_Ped_Exec_Corren <> 0 THEN 
        DO.
          FIND Ped_Exec NO-LOCK
              WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
          IF AVAIL Ped_Exec THEN 
          DO.
            FIND servid_Exec_Imprsor NO-LOCK
                 WHERE servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec
                   AND servid_Exec_Imprsor.Nom_Impressora  = C-Impressora 
                 NO-ERROR.
            IF AVAIL Servid_Exec_Imprsor 
            THEN OUTPUT THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET "iso8859-1".
            ELSE OUTPUT THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET "iso8859-1".
          END. /* End do - IF AVAIL Ped_Exec */
        END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
        ELSE OUTPUT THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                            PAGED 
                            PAGE-SIZE 
                            VALUE(V_Rpt_Stream_1_Lines) 
                            CONVERT TARGET "iso8859-1".
      END. /* End do - IF OPSYS = "UNIX" */
      ELSE OUTPUT TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_Stream_1_Lines) 
                                           CONVERT TARGET "iso8859-1".
      FOR EACH Configur_Layout_Impres NO-LOCK
          WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = layout_impres.Num_Id_Layout_Impres
             BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
        FIND Configur_Tip_imprsor NO-LOCK
             WHERE Configur_Tip_imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
               AND Configur_Tip_imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
               AND Configur_Tip_imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
             NO-ERROR.
        PUT CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
      END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
    END. /* End do - WHEN "Impressora" l_Printer */
    WHEN "Arquivo" /*l_File*/  THEN 
    DO.
      OUTPUT TO VALUE(V_Cod_Dwb_File)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_Stream_1_Lines)
                                           CONVERT TARGET "iso8859-1".
    END. /* End do - WHEN "Arquivo" - l_File  */
  END. /* End do - CASE V_Cod_Dwb_Output */
END. /* End do - DO. -- Que seta a saida da impressao */

ASSIGN C-Programa          = "esapb004"
       C-Versao            = "1.00"
       C-Revisao           = "000"
       C-Titulo-Relat      = "Relatorio de Comissoes"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

/* l¢gica para alimentar a temp-table tt_imp */
IF rs-baixa = 1 THEN DO: /* A Baixar(CPO) */
   ASSIGN C-Titulo-Relat = C-Titulo-Relat + " A Baixar(CPO)".
   RUN pi_a_baixar_cpo. /*aqui*/
END.
ELSE DO:
   IF rs-baixa = 2 THEN DO: /* Liquidadas */
      ASSIGN C-Titulo-Relat = C-Titulo-Relat + " Liquidadas".
      RUN pi_liquidadas_cpo.
   END.
   ELSE DO: /*A Vencer(CPE)*/
      ASSIGN C-Titulo-Relat = C-Titulo-Relat + "  A Vencer(CPE)".
      RUN pi-a-vencer-cpe.
   END.
END.

/* Imprime relat¢rio em formato padr∆o EMS 5 */
RUN Pi_Imprime_Relat.


OUTPUT CLOSE.

IF tg-rel-final-mes THEN DO:
   RUN  pi-roda-api-ava-ir.

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

IF tg-envio-email = NO THEN DO:
    IF V_Cod_Dwb_Output = "Terminal" 
    THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).
END.
ELSE
   OS-DELETE VALUE(V_Cod_Dwb_File).



RETURN "ok".

/* fim do programa */

PROCEDURE Pi_Imprime_Relat.

    ASSIGN c-rodape-var = "INTELBRAS - " + c-sistema + " - " + c-programa + " - V:" + c-versao
                           + "." + c-revisao.
    ASSIGN c-rodape-var = fill("-", 160 - length(c-rodape-var)) + c-rodape-var.


    ASSIGN c-rodape = "INTELBRAS - " + c-sistema + " - " + c-programa + " - V:" + c-versao
                       + "." + c-revisao.
    ASSIGN c-rodape = fill("-", 130 - length(c-rodape)) + c-rodape.


    IF tg-rel-final-mes THEN
       ASSIGN c-titulo-relat = c-titulo-relat + " Realizado".
    ELSE
       ASSIGN c-titulo-relat = c-titulo-relat + " Estimado".

    if tg-resumido = yes then
        view frame f-cabec.
    else
        view frame f-cabec-var.
    
    IF rs-baixa = 1 THEN DO: /* A Baixar(CPO) */
        IF tg-envio-email THEN  /* Envio por e-mail */
           run pi-imp-a-baixar-htm.
        ELSE
           RUN pi-imp-a-baixar.
    END.
    ELSE DO:
        IF rs-baixa = 2 THEN DO: /* Liquidadas */
           IF tg-envio-email THEN
              RUN pi-imp-baixadas-htm.
           ELSE
              RUN pi-imp-baixadas.
        END.
        ELSE DO: /*A Vencer(CPE)*/
           IF tg-envio-email THEN
              RUN pi-imp-a-vencer-cpe-htm.
           ELSE
              RUN pi-imp-a-vencer-cpe.
        END.
    END.
    
    if tg-resumido = yes THEN
        view frame f-rodape.
    else
        view frame f-rodape-var.    


    for each tt_imp:
        delete tt_imp.
    end.

END PROCEDURE. /* End da PROCEDURE Pi_Imprime_Relat */

/* Procedure de neg¢cio  */
procedure pi_liquidadas_cpo.
    for each representante no-lock 
        where representante.cod_empresa = '1'
          and representante.cdn_repres >= repres-ini
          and representante.cdn_repres <= repres-fim,
        EACH emscad.fornecedor NO-LOCK
           WHERE emscad.fornecedor.cod_empresa     = representante.cod_empresa 
             AND emscad.fornecedor.num_pessoa      = representante.num_pessoa
             AND emscad.fornecedor.cod_grp_fornec >= gr-fornec-ini 
             AND emscad.fornecedor.cod_grp_fornec <= gr-fornec-fim, 
        each tit_ap no-lock
             where tit_ap.cod_estab            = "101"
               and tit_ap.cdn_fornecedor       = emscad.fornecedor.cdn_fornecedor  
               AND tit_ap.dat_liquidac_tit_ap <> 12/31/9999
               AND tit_ap.dat_transacao       >= data-ini   
               AND tit_ap.dat_transacao       <= data-fim
               and tit_ap.cod_espec_docto      = "CPO"
               AND tit_ap.val_sdo_tit_ap       = 0
        break by representante.cdn_repres
              by tit_ap.cod_ser_docto 
              by tit_ap.cod_tit_ap
              by tit_ap.cod_parcela:

        FIND FIRST movto_tit_ap OF tit_ap NO-LOCK
            WHERE movto_tit_ap.cod_estab          = '101'
              AND movto_tit_ap.ind_trans_ap_abrev = "IMPL" 
              AND movto_tit_ap.log_movto_estordo  = YES NO-ERROR.
        IF AVAIL movto_tit_ap THEN
            NEXT.

        FIND LAST b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab       = tit_ap.cod_estab  
              AND b_tit_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
              AND b_tit_ap.cod_espec_docto = 'CPE'
              AND b_tit_ap.cod_ser_docto   = tit_ap.cod_ser_docto
              AND b_tit_ap.cod_tit_ap      = ENTRY(1,tit_ap.cod_tit_ap,"-") /*SUBSTR(tit_ap.cod_tit_ap,1,7)*/ NO-ERROR.
        IF AVAIL b_tit_ap THEN
            ASSIGN c_parcela = b_tit_ap.cod_parcela.
        ELSE
            ASSIGN c_parcela = tit_ap.cod_parcela.

        ASSIGN v_num_id_tit_acr = 0
               c-nota           = tit_ap.cod_tit_ap.

        IF tit_ap.cod_ser_docto = "1"  OR tit_ap.cod_ser_docto = "3" OR tit_ap.cod_ser_docto = "4" OR tit_ap.cod_ser_docto = "5" OR tit_ap.cod_ser_docto = "7" then
           ASSIGN c-ser-docto = tit_ap.cod_ser_docto.
        ELSE                                    
           ASSIGN c-ser-docto = "".
        
        FOR EACH int_espec_docto_financ_acr NO-LOCK
            WHERE int_espec_docto_financ_acr.log_gera_comissao = YES:

           FIND FIRST tit_acr NO-LOCK
               WHERE tit_acr.cod_estab     = tit_ap.cod_estab 
               AND tit_acr.cod_ser_docto   = c-ser-docto
               AND tit_acr.cod_espec_docto = int_espec_docto_financ_acr.cod_espec_docto
               AND tit_acr.cod_tit_acr     = ENTRY(1,tit_ap.cod_tit_ap,"-") /*SUBSTR(tit_ap.cod_tit_ap,1,7)*/ 
               AND tit_acr.cod_parcela     = tit_ap.cod_parcela NO-ERROR.
           IF AVAIL tit_acr THEN 
              ASSIGN v_num_id_tit_acr = tit_acr.num_id_tit_acr.
        END.

        FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab       = tit_ap.cod_estab
              AND tit_acr.num_id_tit_acr  = v_num_id_tit_acr NO-ERROR.

        find first nota-fiscal NO-LOCK
            where nota-fiscal.cod-estabel = "101"
              AND nota-fiscal.serie       = "7"
              AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
        if not avail nota-fiscal then
            find first nota-fiscal NO-LOCK
                where nota-fiscal.cod-estabel = "101"
                  AND nota-fiscal.serie       = "5"
                  AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
        if not avail nota-fiscal then
            find first nota-fiscal NO-LOCK
                where nota-fiscal.cod-estabel = "101"
                  AND nota-fiscal.serie       = "3"
                  AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
        if not avail nota-fiscal then
           find first nota-fiscal NO-LOCK 
            WHERE nota-fiscal.cod-estabel = "101"
              AND nota-fiscal.serie       = "1"
              AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.

        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
      
        if not avail ped-venda then do:
            FIND FIRST dupl_vendor NO-LOCK
                WHERE dupl_vendor.num_planilha_vendor = int(tit_acr.cod_tit_acr) NO-ERROR.

            FIND FIRST b_tit_acr NO-LOCK 
               WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                 AND b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                
            IF AVAIL b_tit_acr THEN DO:
               ASSIGN substr(c-nota,1,7) = b_tit_acr.cod_tit_acr.
  
               FIND nota-fiscal NO-LOCK                                                                                                  
                    WHERE nota-fiscal.cod-estabel = b_tit_acr.cod_estab                                                                         
                    AND nota-fiscal.serie         = b_tit_acr.cod_ser_docto                                                                     
                    AND nota-fiscal.nr-nota-fis   = b_tit_acr.cod_tit_acr NO-ERROR.   
            END.
        end.

        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR. 

        FIND FIRST emscad.cliente NO-LOCK 
           WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
            
        FIND FIRST repres_tit_acr NO-LOCK
           WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab 
             AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
             AND repres_tit_acr.cdn_repres     = representante.cdn_repres NO-ERROR.
        IF AVAIL repres_tit_acr THEN DO:
        
           /* Grava e-mail do representante para envio do relat¢rio */
           if  representante.num_pessoa modulo 2 <> 0 then do:
               find pessoa_jurid
                   where pessoa_jurid.num_pessoa_jurid = representante.num_pessoa no-lock no-error.
               if  avail pessoa_jurid then
                   ASSIGN v_cod_e_mail = pessoa_jurid.cod_e_mail.
           end.
           else do:
               find pessoa_fisic
                   where pessoa_fisic.num_pessoa_fisic = representante.num_pessoa no-lock no-error.
               if  avail pessoa_fisic then
                   ASSIGN v_cod_e_mail = pessoa_fisic.cod_e_mail.
           end.               

           /* Grava cidade e estado do cliente para o relat¢rio */
           if  cliente.num_pessoa modulo 2 <> 0
           then do:
               find pessoa_jurid
                   where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_jurid then do:
                   ASSIGN v_nom_cidade_c       = pessoa_jurid.nom_cidade 
                          v_cod_unid_federac_c = pessoa_jurid.cod_unid_federac.
               end.
           end.
           else do:
               find pessoa_fisic
                   where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_fisic then do:
                   ASSIGN v_nom_cidade_c       = pessoa_fisic.nom_cidade 
                          v_cod_unid_federac_c = pessoa_fisic.cod_unid_federac.
               end.
           end.               
                       
           create tt_imp.
           assign tt_imp.cdn_fornecedor        = fornecedor.cdn_fornecedor
                  tt_imp.nom_abrev             = fornecedor.nom_abrev
                  tt_imp.cdn_repres            = representante.cdn_repres
                  tt_imp.nom_abrev_r           = representante.nom_abrev
                  tt_imp.nom_pessoa            = emscad.fornecedor.nom_pessoa
                  tt_imp.cod_ser_docto         = tit_ap.cod_ser_docto
                  tt_imp.cod_tit_ap            = c-nota
                  tt_imp.cod_parcela           = string(tit_ap.cod_parcela,"99") + "/" + c_parcela
                  tt_imp.dat_vencto_tit_ap     = tit_ap.dat_vencto_tit_ap 
                  tt_imp.dat_liquidac_tit_ap   = tit_ap.dat_liquidac_tit_ap 
                  tt_imp.dat_pedido            = if avail ped-venda then
                                                    ped-venda.dt-emissao
                                                 else
                                                    ?
                  tt_imp.cdn_cliente           = tit_acr.cdn_cliente
                  tt_imp.nom_abrev_c           = cliente.nom_abrev
                  tt_imp.nom_cidade_c          = v_nom_cidade_c
                  tt_imp.cod_unid_federac_c    = v_cod_unid_federac_c
                  tt_imp.cod_grp_clien         = cliente.cod_grp_clien
                  tt_imp.cod_e_mail            = v_cod_e_mail
                  tt_imp.val_origin_tit_ap     = tit_ap.val_origin_tit_ap
                  tt_imp.val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres
                  tt_imp.val_base              = (tit_ap.val_origin_tit_ap * 100) / 
                                                  repres_tit_acr.val_perc_comis_repres.

           if repres_tit_acr.val_perc_comis_repres = 0 then
              assign tt_imp.val_origin_tit_ap = 0 
                     tt_imp.val_base          = 0. 
        END.
    end.
end.

PROCEDURE pi_a_baixar_cpo.

    ASSIGN i-seq-ava = 0.

    for each representante no-lock 
        where representante.cod_empresa = '1'
          and representante.cdn_repres >= repres-ini
          and representante.cdn_repres <= repres-fim,
        EACH emscad.fornecedor NO-LOCK
           WHERE emscad.fornecedor.cod_empresa     = representante.cod_empresa 
             AND emscad.fornecedor.num_pessoa      = representante.num_pessoa
             AND emscad.fornecedor.cod_grp_fornec >= gr-fornec-ini
             AND emscad.fornecedor.cod_grp_fornec <= gr-fornec-fim, 
        each tit_ap no-lock
          where tit_ap.cod_estab           = "101"
            and tit_ap.cdn_fornecedor      = emscad.fornecedor.cdn_fornecedor  
            AND tit_ap.dat_liquidac_tit_ap = 12/31/9999
            AND tit_ap.dat_transacao      >= data-ini
            AND tit_ap.dat_transacao      <= data-fim
            and tit_ap.cod_espec_docto     = "CPO"
            AND tit_ap.val_sdo_tit_ap     <> 0
        break by representante.cdn_repres
              by tit_ap.cod_ser_docto 
              by tit_ap.cod_tit_ap
              by tit_ap.cod_parcela:

        FIND FIRST movto_tit_ap OF tit_ap NO-LOCK
            WHERE movto_tit_ap.cod_estab          = '101'
              AND movto_tit_ap.ind_trans_ap_abrev = "IMPL" 
              AND movto_tit_ap.log_movto_estordo  = YES NO-ERROR.
        IF AVAIL movto_tit_ap THEN
            NEXT.

        FIND LAST b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab       = tit_ap.cod_estab  
              AND b_tit_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
              AND b_tit_ap.cod_espec_docto = 'CPE'
              AND b_tit_ap.cod_ser_docto   = tit_ap.cod_ser_docto
              AND b_tit_ap.cod_tit_ap      = SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) NO-ERROR.
        IF AVAIL b_tit_ap THEN
            ASSIGN c_parcela = b_tit_ap.cod_parcela.
        ELSE
            ASSIGN c_parcela = tit_ap.cod_parcela.

        ASSIGN v_num_id_tit_acr = 0
               c-nota           = tit_ap.cod_tit_ap.
        
        IF tit_ap.cod_ser_docto = "1" OR tit_ap.cod_ser_docto = "3" OR tit_ap.cod_ser_docto = "4" OR tit_ap.cod_ser_docto = "5" OR tit_ap.cod_ser_docto = "7" then  
           ASSIGN c-ser-docto = tit_ap.cod_ser_docto.
        ELSE                                    
           ASSIGN c-ser-docto = "".
        
        FOR EACH int_espec_docto_financ_acr NO-LOCK
            WHERE int_espec_docto_financ_acr.log_gera_comissao = YES:

           FIND FIRST tit_acr NO-LOCK
               WHERE tit_acr.cod_estab     = tit_ap.cod_estab 
               AND tit_acr.cod_ser_docto   = c-ser-docto
               AND tit_acr.cod_espec_docto = int_espec_docto_financ_acr.cod_espec_docto
               AND tit_acr.cod_tit_acr     = SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) 
               AND tit_acr.cod_parcela     = tit_ap.cod_parcela NO-ERROR.
           IF AVAIL tit_acr THEN 
              ASSIGN v_num_id_tit_acr = tit_acr.num_id_tit_acr.
        END.
        FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab       = tit_ap.cod_estab
              AND tit_acr.num_id_tit_acr  = v_num_id_tit_acr NO-ERROR.

        /*  EM 20/05 - MARIO FLEITH - ENQUANTO VENDOR NAO ESTIVER NO AR, DESPREZAR TITULO COM ESPECIE "VE"*/
        /* colocado no ar em 19/12/2005 **/

/*        IF tit_acr.ind_tip_espec_docto = 'Vendor' THEN NEXT.                                               */
        
        find first nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = "101"
              AND nota-fiscal.serie       = "7"
              AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
        
        if not avail nota-fiscal then
            find first nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = "101"
                  AND nota-fiscal.serie       = "5"
                  AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
        
        if not avail nota-fiscal then
            find first nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = "101"
                  AND nota-fiscal.serie       = "3"
                  AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.

        if not avail nota-fiscal then
           find first nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = "101"
               AND nota-fiscal.serie       = "1"
               AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
    
        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
    
        if not avail ped-venda then do:
            FIND FIRST dupl_vendor NO-LOCK
                WHERE dupl_vendor.num_planilha_vendor = int(tit_acr.cod_tit_acr) NO-ERROR.

            FIND FIRST b_tit_acr NO-LOCK 
               WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                 AND b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                
            IF AVAIL b_tit_acr THEN DO:
               ASSIGN substr(c-nota,1,7) = b_tit_acr.cod_tit_acr.

               FIND FIRST nota-fiscal NO-LOCK                                                                                                  
                    WHERE nota-fiscal.cod-estabel = b_tit_acr.cod_estab                                                                         
                    AND nota-fiscal.serie       = b_tit_acr.cod_ser_docto                                                                     
                    AND nota-fiscal.nr-nota-fis = b_tit_acr.cod_tit_acr NO-ERROR.   
            END.
        end.
    
        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
    
        FIND FIRST emscad.cliente NO-LOCK 
           WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
        
        FIND FIRST repres_tit_acr NO-LOCK
           WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab 
             AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
             AND repres_tit_acr.cdn_repres     = representante.cdn_repres NO-ERROR.
        
        IF AVAIL repres_tit_acr THEN DO:

            /* Grava e-mail do representante para envio do relat¢rio */
           if representante.num_pessoa modulo 2 <> 0 then do:
              find pessoa_jurid
                   where pessoa_jurid.num_pessoa_jurid = representante.num_pessoa no-lock no-error.
              if  avail pessoa_jurid then
                  ASSIGN v_cod_e_mail = pessoa_jurid.cod_e_mail.
           end.
           else do:
              find pessoa_fisic
                   where pessoa_fisic.num_pessoa_fisic = representante.num_pessoa no-lock no-error.
              if  avail pessoa_fisic then
                  ASSIGN v_cod_e_mail = pessoa_fisic.cod_e_mail.
           end.               

           /* Grava cidade e estado do cliente para o relat¢rio */
           if  cliente.num_pessoa modulo 2 <> 0 then do:
               find pessoa_jurid
                   where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_jurid then do:
                   ASSIGN v_nom_cidade_c       = pessoa_jurid.nom_cidade 
                          v_cod_unid_federac_c = pessoa_jurid.cod_unid_federac.
               end.
           end.
           else do:
               find pessoa_fisic
                   where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_fisic then do:
                   ASSIGN v_nom_cidade_c       = pessoa_fisic.nom_cidade 
                          v_cod_unid_federac_c = pessoa_fisic.cod_unid_federac.
               end.
           end.          
           create tt_imp.
           assign tt_imp.cdn_fornecedor        = fornecedor.cdn_fornecedor
                  tt_imp.nom_abrev             = fornecedor.nom_abrev
                  tt_imp.cdn_repres            = representante.cdn_repres
                  tt_imp.nom_abrev_r           = representante.nom_abrev
                  tt_imp.nom_pessoa            = emscad.fornecedor.nom_pessoa
                  tt_imp.cod_ser_docto         = tit_ap.cod_ser_docto
                  tt_imp.cod_tit_ap            = c-nota
                  tt_imp.cod_parcela           = string(tit_ap.cod_parcela,"99") + "/" + c_parcela
                  tt_imp.dat_vencto_tit_ap     = tit_ap.dat_vencto_tit_ap 
                  tt_imp.dat_liquidac_tit_ap   = tit_ap.dat_liquidac_tit_ap 
                  tt_imp.dat_pedido            = if avail ped-venda then
                                                    ped-venda.dt-emissao
                                                 else
                                                     ?
                  tt_imp.cdn_cliente           = cliente.cdn_cliente
                  tt_imp.nom_abrev_c           = cliente.nom_abrev
                  tt_imp.nom_cidade_c          = v_nom_cidade_c
                  tt_imp.cod_unid_federac_c    = v_cod_unid_federac_c
                  tt_imp.cod_grp_clien         = emscad.cliente.cod_grp_clien
                  tt_imp.cod_e_mail            = v_cod_e_mail
                  tt_imp.val_origin_tit_ap     = tit_ap.val_origin_tit_ap
                  tt_imp.val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres
                  tt_imp.val_base              = (tit_ap.val_origin_tit_ap * 100) / 
                                                  repres_tit_acr.val_perc_comis_repres.
    
           if repres_tit_acr.val_perc_comis_repres = 0 then
              assign tt_imp.val_origin_tit_ap = 0 
                     tt_imp.val_base          = 0. 
               
           IF tg-rel-final-mes THEN DO:
               ASSIGN i-seq-ava = i-seq-ava + 1.
                  RUN pi-gera-tt-ava-ir-cpo.
           END.
        END.
    end.
END. /*PROCEDURE pi_a_baixar_cpo.*/

PROCEDURE pi-imp-baixadas.
        assign de_total_base = 0
               de_total_comis = 0
               de_total_saldo = 0
               de_total_ir    = 0
               de_total_liq   = 0.
               
        for each tt_imp
            break by tt_imp.cdn_repres
                  by tt_imp.cod_ser_docto
                  by tt_imp.cod_tit_ap
                  by tt_imp.cod_parcela:

            if first-of(tt_imp.cdn_repres) then do:
               assign de_vl_comissao = 0
                      de_vl_base = 0.
               put "Repres: " 
                   tt_imp.cdn_repres " - " 
                   tt_imp.nom_pessoa            
                   "(" tt_imp.cdn_fornecedor ")" space(10)
                   "Periodo: " string(data-ini,"99/99/9999") FORMAT "X(10)"
                   " ate " string(data-fim,"99/99/9999") FORMAT "X(10)"
                   SKIP(1).
            end.
 
            assign de_vl_comissao = de_vl_comissao +
                                    tt_imp.val_origin_tit_ap
                   de_vl_base     = if tt_imp.val_perc_comis_repres <> 0 then
                                       de_vl_base + (tt_imp.val_origin_tit_ap * 100) /
                                              tt_imp.val_perc_comis_repres
                                    else
                                       de_vl_base.
                                    
            if not tg-resumido then
               disp tt_imp.cod_ser_docto
                    tt_imp.cod_tit_ap
                    tt_imp.cod_parcela
                    tt_imp.dat_pedido
                    tt_imp.dat_vencto_tit_ap
                    tt_imp.dat_liquidac_tit_ap
                    tt_imp.cdn_cliente 
                    tt_imp.nom_abrev_c format "X(30)"
                    tt_imp.nom_cidade_c
                    tt_imp.cod_unid_federac_c
                    tt_imp.val_base
                    tt_imp.val_perc_comis_repres format ">9.99" 
                    tt_imp.val_origin_tit_ap format ">>,>>>,>>9.99"  column-label "Vl Liquido"
                    with width 250 STREAM-IO.
            
            if last-of(tt_imp.cdn_repres) then do:
               if not tg-resumido then do:
                  put space(129) "Total de Comissao " 
                      de_vl_base "           " de_vl_comissao skip(1).
                  assign de_total_comis = de_total_comis + de_vl_comissao.

                  for each comis-deb-cred no-lock 
                      where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                        and comis-deb-cred.dt-mov >= data-ini 
                        and comis-deb-cred.dt-mov <= data-fim
                        and comis-deb-cred.base-final,
                      first mov-comis no-lock 
                            where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                      if comis-deb-cred.deb-cred then
                         assign c_operacao = "(-)"
                                de_vl_comissao = de_vl_comissao -
                                                 comis-deb-cred.valor.
                      else
                         assign c_operacao = "(+)" 
                                de_vl_comissao = de_vl_comissao +
                                                 comis-deb-cred.valor.
                      
                      put space(34) 
                          comis-deb-cred.historico " "
                          c_operacao " "
                          mov-comis.descricao
                          comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
                  end.
                  
                  assign de_total_saldo = de_total_saldo + de_vl_comissao
                         de_total_ir    = de_total_ir + 
                                          (de_vl_comissao * 0.015).

                  put space(131) "Saldo Bruto                       " 
                      de_vl_comissao skip(1)
                      space(131) "Imposto de Renda (1,5%)           " 
                      de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                     skip.
                   assign de_vl_comissao = de_vl_comissao - 
                                          (de_vl_comissao * 0.015).

                  assign de_total_liq = de_total_liq + de_vl_comissao.

                  put space(131) "Total Liquido                     " 
                      de_vl_comissao skip(2).
                
                  for each comis-deb-cred no-lock 
                      where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                        and comis-deb-cred.dt-mov >= data-ini 
                        and comis-deb-cred.dt-mov <= data-fim
                        and not comis-deb-cred.base-final,
                      first mov-comis no-lock 
                            where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                      if comis-deb-cred.deb-cred then
                         assign c_operacao = "(-)"
                                de_vl_comissao = de_vl_comissao -
                                                 comis-deb-cred.valor.
                      else
                         assign c_operacao = "(+)"
                                de_vl_comissao = de_vl_comissao +
                                                 comis-deb-cred.valor.
                      
                      put space(34) 
                          comis-deb-cred.historico " "
                          c_operacao " "
                          mov-comis.descricao
                          comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
                  end.
                  
                  put space(131) "Total a Receber                   "
                      de_vl_comissao SKIP(2). 
                  assign de_total_geral = de_total_geral + de_vl_comissao
                         de_total_base  = de_total_base + de_vl_base.
                  IF tg-rel-final-mes = YES AND 
                     v_arq_api_ir    <> ''  THEN DO:
                     PUT SKIP(2)
                         '       *** Erro na atualizaá∆o do IR nas CPOs.'    SKIP
                         '           Consultar o arquivo: ' tg-rel-final-mes SKIP.
                  END.
                  page.
               end.
               else do:
                  
                  put " " skip(1)
                      "Total de Comissao " 
                      de_vl_base "           " de_vl_comissao skip(1).
                  assign de_total_base = de_total_base + de_vl_base
                         de_total_comis = de_total_comis + de_vl_comissao.
                         
                  for each comis-deb-cred no-lock 
                      where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                        and comis-deb-cred.dt-mov >= data-ini 
                        and comis-deb-cred.dt-mov <= data-fim
                        and comis-deb-cred.base-final,
                      first mov-comis no-lock 
                            where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                      if comis-deb-cred.deb-cred then
                         assign c_operacao = "(-)"
                                de_vl_comissao = de_vl_comissao -
                                                 comis-deb-cred.valor.
                      else
                         assign c_operacao = "(+)" 
                                de_vl_comissao = de_vl_comissao +
                                                 comis-deb-cred.valor.
                      
                      put space(9) c_operacao " "
                          mov-comis.descricao
                          comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                          comis-deb-cred.historico skip.
                  end.
                 

                  assign de_total_saldo = de_total_saldo + de_vl_comissao
                         de_total_ir    = de_total_ir + 
                                          (de_vl_comissao * 0.015).

                  put space(9) "Saldo Bruto                       " 
                      de_vl_comissao skip(1)
                      space(9) "Imposto de Renda (1,5%)           " 
                      de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                      skip.
                  
                  assign de_vl_comissao = de_vl_comissao - 
                                          (de_vl_comissao * 0.015).
                  assign de_total_liq = de_total_liq + de_vl_comissao.
                  
                  put space(9) "Total Liquido                     " 
                      de_vl_comissao skip(2).
                
                  for each comis-deb-cred no-lock 
                      where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                        and comis-deb-cred.dt-mov >= data-ini 
                        and comis-deb-cred.dt-mov <= data-fim
                        and not comis-deb-cred.base-final,
                      first mov-comis no-lock 
                            where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                      if comis-deb-cred.deb-cred then
                         assign c_operacao = "(-)"
                                de_vl_comissao = de_vl_comissao -
                                                 comis-deb-cred.valor.
                      else
                         assign c_operacao = "(+)"
                                de_vl_comissao = de_vl_comissao +
                                                 comis-deb-cred.valor.
                      
                      put space(9) c_operacao " "
                          mov-comis.descricao
                          comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                          comis-deb-cred.historico skip.
                  end.
              
                  put space(9) "Total a Receber                   "
                      de_vl_comissao skip(3). 
                  
                  IF tg-rel-final-mes = YES AND 
                     v_arq_api_ir    <> ''  THEN DO:
                     PUT SKIP(2)
                         '       *** Erro na atualizaá∆o do IR nas CPOs.'    SKIP
                         '           Consultar o arquivo: ' tg-rel-final-mes SKIP.
                  END.

                  assign de_total_geral = de_total_geral + de_vl_comissao.
               end.
               assign de_vl_comissao = 0
                      de_vl_base = 0.
            end.
        end.
       
        page.
        /***** GERA RESUMO FINAL *******/
        
        put "RESUMO GERAL DO RELATORIO " skip(1)
            "Total de Comissao " 
                      de_total_base "          " de_total_comis skip(1).

        assign c_operacao = "(-)"
               de_vl_tmp = 0.
               
        for each comis-deb-cred no-lock 
            where comis-deb-cred.dt-mov >= data-ini 
              and comis-deb-cred.dt-mov <= data-fim
              and comis-deb-cred.cod-rep >= repres-ini
              and comis-deb-cred.cod-rep <= repres-fim
              and comis-deb-cred.base-final
              and comis-deb-cred.deb-cred,
            first mov-comis no-lock 
                  where mov-comis.cod-mov = comis-deb-cred.cod-mov
            break by comis-deb-cred.cod-mov:
            assign de_vl_tmp = de_vl_tmp + comis-deb-cred.valor.
                      
            if last-of(comis-deb-cred.cod-mov) then do:
               put space(9) c_operacao " "
                   mov-comis.descricao
                   de_vl_tmp skip.
               assign de_vl_tmp = 0.
            end.
        end.

        assign c_operacao = "(+)"
               de_vl_tmp = 0.

        for each comis-deb-cred no-lock 
            where comis-deb-cred.dt-mov >= data-ini 
              and comis-deb-cred.dt-mov <= data-fim
              and comis-deb-cred.cod-rep >= repres-ini
              and comis-deb-cred.cod-rep <= repres-fim
              and comis-deb-cred.base-final
              and not comis-deb-cred.deb-cred,
            first mov-comis no-lock 
                  where mov-comis.cod-mov = comis-deb-cred.cod-mov
            break by comis-deb-cred.cod-mov:
            assign de_vl_tmp = de_vl_tmp + comis-deb-cred.valor.
                      
            if last-of(comis-deb-cred.cod-mov) then do:
               put space(9) c_operacao " "
                   mov-comis.descricao
                   de_vl_tmp skip.
               assign de_vl_tmp = 0.    
            end.
        end.

        put space(9) "Saldo Bruto                       " 
                      de_total_saldo skip(1)
                      space(9) "Imposto de Renda (1,5%)           " 
                      de_total_ir 
                     skip.
        
        put space(9) "Total Liquido                     " de_total_liq skip(2).
                
        assign c_operacao = "(-)"
               de_vl_tmp = 0.

        for each comis-deb-cred no-lock 
            where comis-deb-cred.dt-mov >= data-ini 
              and comis-deb-cred.dt-mov <= data-fim
              and comis-deb-cred.cod-rep >= repres-ini
              and comis-deb-cred.cod-rep <= repres-fim
              and not comis-deb-cred.base-final
              and comis-deb-cred.deb-cred,
            first mov-comis no-lock 
                  where mov-comis.cod-mov = comis-deb-cred.cod-mov
            break by comis-deb-cred.cod-mov:
            
            assign de_vl_tmp = de_vl_tmp + comis-deb-cred.valor.
                      
            if last-of(comis-deb-cred.cod-mov) then do:
                put space(9) c_operacao " "
                    mov-comis.descricao
                    de_vl_tmp skip.
                assign de_vl_tmp = 0.
            end.
        end.
                  
        assign c_operacao = "(+)"
               de_vl_tmp = 0.

        for each comis-deb-cred no-lock 
            where comis-deb-cred.dt-mov >= data-ini 
              and comis-deb-cred.dt-mov <= data-fim
              and comis-deb-cred.cod-rep >= repres-ini
              and comis-deb-cred.cod-rep <= repres-fim
              and not comis-deb-cred.base-final
              and not comis-deb-cred.deb-cred,
            first mov-comis no-lock 
                  where mov-comis.cod-mov = comis-deb-cred.cod-mov
            break by comis-deb-cred.cod-mov:
            
            assign de_vl_tmp = de_vl_tmp + comis-deb-cred.valor.
                      
            if last-of(comis-deb-cred.cod-mov) then do:
                put space(9) c_operacao " "
                    mov-comis.descricao
                    de_vl_tmp skip.
                assign de_vl_tmp = 0.
            end.
        end.
        
        put space(9) "Total a Receber                   "
                     de_total_geral skip(3) SKIP(2). 
        


END. /*PROCEDURE pi-imp-baixadas.*/

PROCEDURE pi-imp-a-baixar.
        
    for each tt_imp
        break by tt_imp.cdn_repres
              by tt_imp.cod_ser_docto
              by tt_imp.cod_tit_ap
              by tt_imp.cod_parcela:
        if first-of(tt_imp.cdn_repres) then do:
           assign de_vl_comissao = 0
                  de_vl_base = 0.
           put "Repres: " 
               tt_imp.cdn_repres " - " 
               tt_imp.nom_pessoa
               "(" tt_imp.cdn_fornecedor ")" space(10)
               "Periodo: " string(data-ini,"99/99/9999") format "X(10)"
               " ate "  string(data-fim,"99/99/9999") format "X(10)"
               skip(1).
        end.

        assign de_vl_comissao = de_vl_comissao +
                                tt_imp.val_origin_tit_ap
               de_vl_base     = if tt_imp.val_perc_comis_repres <> 0 then
                                   de_vl_base + (tt_imp.val_origin_tit_ap * 100) 
                                           / tt_imp.val_perc_comis_repres
                                else
                                   de_vl_base.
        if not tg-resumido then
           disp tt_imp.cod_ser_docto column-label "Sr" format "X(03)"
                tt_imp.cod_tit_ap  column-label "Docto" format "X(10)"
                tt_imp.cod_parcela column-label "Parc"
                tt_imp.dat_pedido format "99/99/9999" column-label "Dt Pedido"
                tt_imp.dat_vencto_tit_ap
                        format "99/99/9999" column-label "Dt Vcto"
                tt_imp.cdn_cliente column-label "Cod"
                tt_imp.nom_abrev_c
                tt_imp.nom_cidade_c column-label "Cidade"
                tt_imp.cod_unid_federac_c column-label "UF"
                tt_imp.cod_grp_clien  column-label "GrpCli"
                (tt_imp.val_origin_tit_ap * 100) / tt_imp.val_perc_comis_repres 
                         format ">>>>>,>>9.99" column-label "Valor Base"
                tt_imp.val_perc_comis_repres format ">>9.99" 
                tt_imp.val_origin_tit_ap format ">>,>>>,>>9.99" column-label "Vl Liquido"
                with width 250 STREAM-IO.
        
        if last-of(tt_imp.cdn_repres) then do:
           if not tg-resumido then do:
               
              put space(81) "Total de Comissao               " 
                  de_vl_base "           " de_vl_comissao skip(1).
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)" 
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                   
                  put space(33) 
                      comis-deb-cred.historico " "
                      c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
              end.
              put space(104) "Saldo Bruto                       " 
                  de_vl_comissao skip(1)
                  space(104) "Imposto de Renda (1,5%)           " 
                  de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                  skip.
              assign de_vl_comissao = de_vl_comissao - 
                                      (de_vl_comissao * 0.015).
              put space(104) "Total Liquido                     " 
                  de_vl_comissao skip(2).
           
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and not comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)"
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                  
                  put space(33) 
                      comis-deb-cred.historico " "
                      c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
              end.
              
              put space(104) "Total a Receber                   "
                  de_vl_comissao SKIP(2). 
              assign de_total_geral = de_total_geral + de_vl_comissao.
              page.
            
           end.
           else do:
              
              put " " skip
                  "Total de Comissao    " 
                  de_vl_base "           " de_vl_comissao skip(1).
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)" 
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                   
                  put space(12) c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                      comis-deb-cred.historico skip.
              end.

              put space(12) "Saldo Bruto                       " 
                  de_vl_comissao skip(1)
                  space(12) "Imposto de Renda (1,5%)           " 
                  de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                  skip.
              assign de_vl_comissao = de_vl_comissao - 
                                      (de_vl_comissao * 0.015).
              put space(12) "Total Liquido                     " 
                  de_vl_comissao skip(2).
           
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and not comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)"
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                  
                  put space(12) c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                      comis-deb-cred.historico skip.
              end.
              
              put space(12) "Total a Receber                   "
                  de_vl_comissao skip(3). 
              assign de_total_geral = de_total_geral + de_vl_comissao.
           
           end.
       end.
    end.
    put "Total geral de comissao em aberto: " de_total_geral.
END. /*procedure pi-imp-a-baixar.*/

/* html */
PROCEDURE pi-imp-a-vencer-cpe-htm.
        assign c-tam-tab = "1000".
        for each tt_imp
            break by tt_imp.cdn_repres
                  by tt_imp.cod_ser_docto
                  by tt_imp.cod_tit_ap
                  by tt_imp.cod_parcela:
            if first-of(tt_imp.cdn_repres) then do:
               assign c-arquivo = "esapb004.html"
                      c-arquivo-2 = "esapb004x.htm"
                      c-texto-html = "".
       
               output to value(c-arquivo).
              
               assign c-texto-html[1] = "Verifique anexo o RELATORIO DE COMISSOES EM ABERTO".
       
               run html-inicio("Relatorio de Comissoes").
 
               assign c-tit-html = "Relatorio de Comissoes A Vencer geradas entre " +
                                   string(data-ini,"99/99/9999") +
                                   " ate " + string(data-fim,"99/99/9999").

               run html-titulo(c-tit-html).
               
               assign c-tit-html = string(tt_imp.cdn_repres) + " - " + 
                                   tt_imp.nom_pessoa + "(" +
                                   string(tt_imp.cdn_fornecedor) + ")".

               run html-titulo(c-tit-html).
               
               run html-ini-tab.             
    
               run html-ini-lin-tab.           

               run html-cab-tab("Esp").    
               run html-cab-tab("Docto").    
               run html-cab-tab("Par").    
               run html-cab-tab("Pedido").
               run html-cab-tab("Vencto").    
               run html-cab-tab("Cod").
               run html-cab-tab("Nome Cliente").
               run html-cab-tab("Cidade").
               run html-cab-tab("UF").
               run html-cab-tab("Vl Base").
               run html-cab-tab("%").
               run html-cab-tab("Vl Liquido").    
               run html-fim-lin-tab.          
 
               assign de_vl_comissao = 0
                      de_vl_base = 0.
            end.

            assign de_vl_comissao = de_vl_comissao +
                                    tt_imp.val_origin_tit_ap
                   de_vl_base     = if tt_imp.val_perc_comis_repres <> 0 then
                                       de_vl_base + (tt_imp.val_origin_tit_ap * 100) /
                                              tt_imp.val_perc_comis_repres
                                    else
                                       de_vl_base.

            run html-ini-lin-tab.
            run html-con-tab(tt_imp.cod_ser_docto, "left").
            run html-con-tab(tt_imp.cod_tit_ap, "right").
            run html-con-tab(tt_imp.cod_parcela, "left").
            run html-con-tab(tt_imp.dat_pedido, "left").
            run html-con-tab(tt_imp.dat_vencto_tit_ap, "left").
            run html-con-tab(tt_imp.cdn_cliente, "right").
            run html-con-tab(tt_imp.nom_abrev_c, "left").
            run html-con-tab(tt_imp.nom_cidade_c, "left").
            run html-con-tab(tt_imp.cod_unid_federac_c, "left").

            assign c-valor = string(tt_imp.val_base,">>>,>>>,>>9.99").
            run html-con-tab(c-valor, "right").

            assign c-valor = string(tt_imp.val_perc_comis_repres,">>9.99").
            run html-con-tab(c-valor, "rigth").

            assign c-valor = string(tt_imp.val_origin_tit_ap,">>>,>>>,>>9.99").
            run html-con-tab(c-valor, "right").

            if last-of(tt_imp.cdn_repres) then do:
               assign c-valor = "<B> " + string(de_vl_base,"->>,>>>,>>9.99") +
                                "</B>".
               
               run html-ini-lin-tab.
               run html-tot-tab(9, " <B> Total da Comissao </B> ", c-valor).
               put '<TD ALIGN= "right"> &nbsp; </TD>'. 
               
               assign c-valor = "<B>" +
                                 string(de_vl_comissao,"->>,>>>,>>9.99") +
                                 "</B>".
                                
               run html-con-tab(c-valor, "right").

               run html-fim-lin-tab.

               for each comis-deb-cred no-lock 
                   where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                     and comis-deb-cred.dt-mov >= data-ini 
                     and comis-deb-cred.dt-mov <= data-fim
                     and comis-deb-cred.base-final,
                   first mov-comis no-lock 
                         where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                   if comis-deb-cred.deb-cred then
                      assign c_operacao = "(-)"
                             de_vl_comissao = de_vl_comissao -
                                              comis-deb-cred.valor.
                   else
                      assign c_operacao = "(+)" 
                             de_vl_comissao = de_vl_comissao +
                                              comis-deb-cred.valor.
                      
                  assign c-valor =
                           string(comis-deb-cred.valor,"->>,>>>,>>9.99").

                  run html-ini-lin-tab.
                  run html-tot-tab(11, c_operacao + mov-comis.descricao + " - "  + comis-deb-cred.historico, c-valor).
                  run html-fim-lin-tab.
               end.

               assign c-valor = "<B> " +
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11," <B> Saldo Bruto </B> ",c-valor).

               assign c-valor = 
                    string((de_vl_comissao * 0.015),"->,>>>,>>9.99").

               run html-ini-lin-tab.
               run html-tot-tab(11, "Imposto de Renda", c-valor).
               run html-fim-lin-tab.

               assign de_vl_comissao = de_vl_comissao - 
                                       (de_vl_comissao * 0.015).

               assign c-valor = "<B> " + 
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11, " <B> Total Liquido </B> ", c-valor).
               run html-fim-lin-tab.

               for each comis-deb-cred no-lock 
                   where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                     and comis-deb-cred.dt-mov >= data-ini 
                     and comis-deb-cred.dt-mov <= data-fim
                     and not comis-deb-cred.base-final,
                   first mov-comis no-lock 
                         where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                   if comis-deb-cred.deb-cred then
                      assign c_operacao = "(-)"
                             de_vl_comissao = de_vl_comissao -
                                              comis-deb-cred.valor.
                   else
                      assign c_operacao = "(+)"
                             de_vl_comissao = de_vl_comissao +
                                              comis-deb-cred.valor.
                      
                  assign c-valor =
                           string(comis-deb-cred.valor,">>>,>>>,>>9.99").

                  run html-ini-lin-tab.
                  run html-tot-tab(11, c_operacao + mov-comis.descricao + " - " + comis-deb-cred.historico, c-valor).
                  run html-fim-lin-tab.

               end.
               assign c-valor = "<B> " + 
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11, "<B> Total a Receber </B> ", c-valor).
               run html-fim-lin-tab.
               output close.

               RUN pi_envio_e_mail.

               assign de_vl_comissao = 0
                      de_vl_base = 0.
            end.
        end.

end. /*PROCEDURE pi-imp-a-baixar-htm.*/

PROCEDURE pi-imp-a-vencer-cpe.
    for each tt_imp
        break by tt_imp.cdn_repres
              by tt_imp.cod_ser_docto
              by tt_imp.cod_tit_ap
              by tt_imp.cod_parcela:
        if first-of(tt_imp.cdn_repres) then do:
           assign de_vl_comissao = 0
                  de_vl_base = 0.
           put "Repres: " 
               tt_imp.cdn_repres " - " 
               tt_imp.nom_pessoa
               "(" tt_imp.cdn_fornecedor ")" space(10)
               "Periodo: " string(data-ini,"99/99/9999") format "X(10)"
               " ate "  string(data-fim,"99/99/9999") format "X(10)"
               skip(1).
        end.

        assign de_vl_comissao = de_vl_comissao +
                                tt_imp.val_origin_tit_ap
               de_vl_base     = if tt_imp.val_perc_comis_repres <> 0 then
                                   de_vl_base + (tt_imp.val_origin_tit_ap * 100) 
                                           / tt_imp.val_perc_comis_repres
                                else
                                   de_vl_base.
        if not tg-resumido then
           disp tt_imp.cod_ser_docto column-label "Sr" format "X(03)"
                tt_imp.cod_tit_ap  column-label "Docto" format "X(10)"
                tt_imp.cod_parcela column-label "Parc"
                tt_imp.dat_pedido format "99/99/9999" column-label "Dt Pedido"
                tt_imp.dat_vencto_tit_ap
                        format "99/99/9999" column-label "Dt Vcto"
                tt_imp.cdn_cliente column-label "Cod"
                tt_imp.nom_abrev_c
                tt_imp.nom_cidade_c column-label "Cidade"
                tt_imp.cod_unid_federac_c column-label "UF"
                tt_imp.cod_grp_clien  column-label "GrpCli"
                (tt_imp.val_origin_tit_ap * 100) / tt_imp.val_perc_comis_repres 
                         format ">>>>>,>>9.99" column-label "Valor Base"
                tt_imp.val_perc_comis_repres format ">>9.99" 
                tt_imp.val_origin_tit_ap format ">>,>>>,>>9.99" column-label "Vl Liquido"
                with width 250 STREAM-IO.
        
        if last-of(tt_imp.cdn_repres) then do:
           if not tg-resumido then do:
               
              put space(81) "Total de Comissao               " 
                  de_vl_base "           " de_vl_comissao skip(1).
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)" 
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                   
                  put space(33) 
                      comis-deb-cred.historico " "
                      c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
              end.
              put space(104) "Saldo Bruto                       " 
                  de_vl_comissao skip(1)
                  space(104) "Imposto de Renda (1,5%)           " 
                  de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                  skip.
              assign de_vl_comissao = de_vl_comissao - 
                                      (de_vl_comissao * 0.015).
              put space(104) "Total Liquido                     " 
                  de_vl_comissao skip(2).
           
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and not comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)"
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                  
                  put space(33) 
                      comis-deb-cred.historico " "
                      c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" skip.
              end.
              
              put space(104) "Total a Receber                   "
                  de_vl_comissao SKIP(2). 
              assign de_total_geral = de_total_geral + de_vl_comissao.
              page.
            
           end.
           else do:
              
              put " " skip
                  "Total de Comissao    " 
                  de_vl_base "           " de_vl_comissao skip(1).
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)" 
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                   
                  put space(12) c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                      comis-deb-cred.historico skip.
              end.

              put space(12) "Saldo Bruto                       " 
                  de_vl_comissao skip(1)
                  space(12) "Imposto de Renda (1,5%)           " 
                  de_vl_comissao * 0.015 format "->>,>>>,>>9.99"
                  skip.
              assign de_vl_comissao = de_vl_comissao - 
                                      (de_vl_comissao * 0.015).
              put space(12) "Total Liquido                     " 
                  de_vl_comissao skip(2).
           
              for each comis-deb-cred no-lock 
                  where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                    and comis-deb-cred.dt-mov >= data-ini 
                    and comis-deb-cred.dt-mov <= data-fim
                    and not comis-deb-cred.base-final,
                  first mov-comis no-lock 
                        where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                  if comis-deb-cred.deb-cred then
                     assign c_operacao = "(-)"
                            de_vl_comissao = de_vl_comissao -
                                             comis-deb-cred.valor.
                  else
                     assign c_operacao = "(+)"
                            de_vl_comissao = de_vl_comissao +
                                             comis-deb-cred.valor.
                  
                  put space(12) c_operacao " "
                      mov-comis.descricao
                      comis-deb-cred.valor format ">>>,>>>,>>9.99" " "
                      comis-deb-cred.historico skip.
              end.
              
              put space(12) "Total a Receber                   "
                  de_vl_comissao skip(3). 
              assign de_total_geral = de_total_geral + de_vl_comissao.
           
           end.
       end.
    end.
    put "Total geral de comissao em aberto: " de_total_geral.
END. /*PROCEDURE pi-imp-a-vencer-cpe.*/

PROCEDURE pi-imp-a-baixar-htm.
        assign c-tam-tab = "1000".
        for each tt_imp
            break by tt_imp.cdn_repres
                  by tt_imp.cod_ser_docto
                  by tt_imp.cod_tit_ap
                  by tt_imp.cod_parcela:
            if first-of(tt_imp.cdn_repres) then do:
               assign c-arquivo = "esapb004.html"
                      c-arquivo-2 = "esapb004x.htm"
                      c-texto-html = "".
       
               output to value(c-arquivo).
              
               assign c-texto-html[1] = "Verifique anexo o RELATORIO DE COMISSOES EM ABERTO".
       
               run html-inicio("Relatorio de Comissoes").
 
               assign c-tit-html = "Relatorio de Comissoes de " +
                                   string(data-ini,"99/99/9999") +
                                   " ate " + string(data-fim,"99/99/9999").

               run html-titulo(c-tit-html).
               
               assign c-tit-html = string(tt_imp.cdn_repres) + " - " + 
                                   tt_imp.nom_pessoa + "(" +
                                   string(tt_imp.cdn_fornecedor) + ")".

               run html-titulo(c-tit-html).
               
               run html-ini-tab.             
    
               run html-ini-lin-tab.           

               run html-cab-tab("Esp").    
               run html-cab-tab("Docto").    
               run html-cab-tab("Par").    
               run html-cab-tab("Pedido").
               run html-cab-tab("Vencto").    
               run html-cab-tab("Cod").
               run html-cab-tab("Nome Cliente").
               run html-cab-tab("Cidade").
               run html-cab-tab("UF").
               run html-cab-tab("Vl Base").
               run html-cab-tab("%").
               run html-cab-tab("Vl Liquido").    
               run html-fim-lin-tab.          
 
               assign de_vl_comissao = 0
                      de_vl_base = 0.
            end.

            assign de_vl_comissao = de_vl_comissao +
                                    tt_imp.val_origin_tit_ap
                   de_vl_base     = if tt_imp.val_perc_comis_repres <> 0 then
                                       de_vl_base + (tt_imp.val_origin_tit_ap * 100) /
                                              tt_imp.val_perc_comis_repres
                                    else
                                       de_vl_base.

            run html-ini-lin-tab.
            run html-con-tab(tt_imp.cod_ser_docto, "left").
            run html-con-tab(tt_imp.cod_tit_ap, "right").
            run html-con-tab(tt_imp.cod_parcela, "left").
            run html-con-tab(tt_imp.dat_pedido, "left").
            run html-con-tab(tt_imp.dat_vencto_tit_ap, "left").
            run html-con-tab(tt_imp.cdn_cliente, "right").
            run html-con-tab(tt_imp.nom_abrev_c, "left").
            run html-con-tab(tt_imp.nom_cidade_c, "left").
            run html-con-tab(tt_imp.cod_unid_federac_c, "left").

            assign c-valor = string(tt_imp.val_base,">>>,>>>,>>9.99").
            run html-con-tab(c-valor, "right").

            assign c-valor = string(tt_imp.val_perc_comis_repres,">>9.99").
            run html-con-tab(c-valor, "rigth").

            assign c-valor = string(tt_imp.val_origin_tit_ap,">>>,>>>,>>9.99").
            run html-con-tab(c-valor, "right").

            if last-of(tt_imp.cdn_repres) then do:
               assign c-valor = "<B> " + string(de_vl_base,"->>,>>>,>>9.99") +
                                "</B>".
               
               run html-ini-lin-tab.
               run html-tot-tab(9, " <B> Total da Comissao </B> ", c-valor).
               put '<TD ALIGN= "right"> &nbsp; </TD>'. 
               
               assign c-valor = "<B>" +
                                 string(de_vl_comissao,"->>,>>>,>>9.99") +
                                 "</B>".
                                
               run html-con-tab(c-valor, "right").

               run html-fim-lin-tab.

               for each comis-deb-cred no-lock 
                   where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                     and comis-deb-cred.dt-mov >= data-ini 
                     and comis-deb-cred.dt-mov <= data-fim
                     and comis-deb-cred.base-final,
                   first mov-comis no-lock 
                         where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                   if comis-deb-cred.deb-cred then
                      assign c_operacao = "(-)"
                             de_vl_comissao = de_vl_comissao -
                                              comis-deb-cred.valor.
                   else
                      assign c_operacao = "(+)" 
                             de_vl_comissao = de_vl_comissao +
                                              comis-deb-cred.valor.
                      
                  assign c-valor =
                           string(comis-deb-cred.valor,"->>,>>>,>>9.99").

                  run html-ini-lin-tab.
                  run html-tot-tab(11, c_operacao + mov-comis.descricao + " - "  + comis-deb-cred.historico, c-valor).
                  run html-fim-lin-tab.
               end.

               assign c-valor = "<B> " +
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11," <B> Saldo Bruto </B> ",c-valor).

               assign c-valor = 
                    string((de_vl_comissao * 0.015),"->,>>>,>>9.99").

               run html-ini-lin-tab.
               run html-tot-tab(11, "Imposto de Renda", c-valor).
               run html-fim-lin-tab.

               assign de_vl_comissao = de_vl_comissao - 
                                       (de_vl_comissao * 0.015).

               assign c-valor = "<B> " + 
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11, " <B> Total Liquido </B> ", c-valor).
               run html-fim-lin-tab.

               for each comis-deb-cred no-lock 
                   where comis-deb-cred.cod-rep = tt_imp.cdn_repres
                     and comis-deb-cred.dt-mov >= data-ini 
                     and comis-deb-cred.dt-mov <= data-fim
                     and not comis-deb-cred.base-final,
                   first mov-comis no-lock 
                         where mov-comis.cod-mov = comis-deb-cred.cod-mov:
                   if comis-deb-cred.deb-cred then
                      assign c_operacao = "(-)"
                             de_vl_comissao = de_vl_comissao -
                                              comis-deb-cred.valor.
                   else
                      assign c_operacao = "(+)"
                             de_vl_comissao = de_vl_comissao +
                                              comis-deb-cred.valor.
                      
                  assign c-valor =
                           string(comis-deb-cred.valor,">>>,>>>,>>9.99").

                  run html-ini-lin-tab.
                  run html-tot-tab(11, c_operacao + mov-comis.descricao + " - " + comis-deb-cred.historico, c-valor).
                  run html-fim-lin-tab.

               end.
               assign c-valor = "<B> " + 
                                string(de_vl_comissao,"->>,>>>,>>9.99") +
                                "</B>".

               run html-ini-lin-tab.
               run html-tot-tab(11, "<B> Total a Receber </B> ", c-valor).
               run html-fim-lin-tab.
               output close.

               RUN pi_envio_e_mail.

               assign de_vl_comissao = 0
                      de_vl_base = 0.
            end.
        end.

end. /*PROCEDURE pi-imp-a-baixar-htm.*/

PROCEDURE pi-imp-baixadas-htm.
    assign c-tam-tab = "1000".
    for each tt_imp
        break by tt_imp.cdn_repres
              by tt_imp.cod_ser_docto
              by tt_imp.cod_tit_ap
              by tt_imp.cod_parcela:
        if first-of(tt_imp.cdn_repres) then do:
           assign c-arquivo = "esapb004.html"
                  c-arquivo-2 = "esapb004x.htm"
                  c-texto-html = "".
   
           output to value(c-arquivo).
          
           assign c-texto-html[1] = "Verifique anexo o RELATORIO DE FECHAMENTO DE COMISSOES A PAGAR".
   
           run html-inicio("Relatorio de Comissoes").

           assign c-tit-html = "Relatorio de Fechamento de Comissoes de " +
                               string(data-ini,"99/99/9999") +
                               " ate " + string(data-fim,"99/99/9999").

           run html-titulo(c-tit-html).
           
           assign c-tit-html = string(tt_imp.cdn_repres) + " - " + 
                               tt_imp.nom_pessoa + "(" +
                               string(tt_imp.cdn_fornecedor) + ")".

           run html-titulo(c-tit-html).
           
           run html-ini-tab.             

           run html-ini-lin-tab.           

           run html-cab-tab("Esp").    
           run html-cab-tab("Docto").    
           run html-cab-tab("Par").    
           run html-cab-tab("Pedido").
           run html-cab-tab("Vencto").    
           run html-cab-tab("Baixa").    
           run html-cab-tab("Cod").
           run html-cab-tab("Nome Cliente").
           run html-cab-tab("Cidade").
           run html-cab-tab("UF").
           run html-cab-tab("Vl Base").    
           run html-cab-tab("%").
           run html-cab-tab("Vl Liquido").
           run html-fim-lin-tab.          

           assign de_vl_comissao = 0
                  de_vl_base = 0.
        end.

        assign de_vl_comissao = de_vl_comissao +
                                tt_imp.val_origin_tit_ap
               de_vl_base     = de_vl_base + (tt_imp.val_origin_tit_ap * 100) /
                                tt_imp.val_perc_comis_repres.
                                
        run html-ini-lin-tab.
        run html-con-tab(tt_imp.cod_ser_docto, "left").
        run html-con-tab(tt_imp.cod_tit_ap, "right").
        run html-con-tab(tt_imp.cod_parcela, "left").
        run html-con-tab(tt_imp.dat_pedido, "left").
        run html-con-tab(tt_imp.dat_vencto_tit_ap, "left").
        run html-con-tab(tt_imp.dat_liquidac_tit_ap, "left").
        run html-con-tab(tt_imp.cdn_cliente, "right").
        run html-con-tab(tt_imp.nom_abrev_c, "left").
        run html-con-tab(tt_imp.nom_cidade_c, "left").
        run html-con-tab(tt_imp.cod_unid_federac_c, "left").

        assign c-valor = string((tt_imp.val_origin_tit_ap * 100) /
                         tt_imp.val_perc_comis_repres,">>>,>>>,>>9.99").
        run html-con-tab(c-valor, "right").

        assign c-valor = string(tt_imp.val_perc_comis_repres,">>9.99").
        run html-con-tab(c-valor, "rigth").

        assign c-valor = string(tt_imp.val_origin_tit_ap,">>>,>>>,>>9.99").
        run html-con-tab(c-valor, "right").
           
        if last-of(tt_imp.cdn_repres) then do:

           assign c-valor = "<B> " + string(de_vl_base,"->>,>>>,>>9.99") +
                            "</B>".
           
           run html-ini-lin-tab.
           run html-tot-tab(10, " <B> Total da Comissao </B> ", c-valor).
           put '<TD ALIGN= "right"> &nbsp; </TD>'.
           
           assign c-valor = "<B> " +
                            string(de_vl_comissao,"->>,>>>,>>9.99") +
                            "</B>".

           run html-con-tab(c-valor, "right").
           
           run html-fim-lin-tab.

           for each comis-deb-cred no-lock 
               where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                 and comis-deb-cred.dt-mov >= data-ini 
                 and comis-deb-cred.dt-mov <= data-fim
                 and comis-deb-cred.base-final,
               first mov-comis no-lock 
                     where mov-comis.cod-mov = comis-deb-cred.cod-mov:
               if comis-deb-cred.deb-cred then
                  assign c_operacao = "(-)"
                         de_vl_comissao = de_vl_comissao -
                                          comis-deb-cred.valor.
               else
                  assign c_operacao = "(+)" 
                         de_vl_comissao = de_vl_comissao +
                                          comis-deb-cred.valor.
                  
              assign c-valor =  
                        string(comis-deb-cred.valor,"->>,>>>,>>9.99").

              run html-ini-lin-tab.
              run html-tot-tab(12, c_operacao + mov-comis.descricao + " - "  + comis-deb-cred.historico, c-valor).
              run html-fim-lin-tab.

           end.

           assign c-valor = "<B>" +
                            string(de_vl_comissao,"->>,>>>,>>9.99") +
                            "</B>".

           run html-ini-lin-tab.
           run html-tot-tab(12," <B> Saldo Bruto </B> ",c-valor).

           assign c-valor = 
                string((de_vl_comissao * 0.015),"->,>>>,>>9.99").

           run html-ini-lin-tab.
           run html-tot-tab(12, "Imposto de Renda", c-valor).
           run html-fim-lin-tab.

           assign de_vl_comissao = de_vl_comissao - 
                                   (de_vl_comissao * 0.015).

           assign c-valor = "<B>" + 
                            string(de_vl_comissao,"->>,>>>,>>9.99") +
                            "</B>".

           run html-ini-lin-tab.
           run html-tot-tab(12, " <B> Total Liquido </B>", c-valor).
           run html-fim-lin-tab.

           for each comis-deb-cred no-lock 
               where comis-deb-cred.cod-rep = tt_imp.cdn_repres 
                 and comis-deb-cred.dt-mov >= data-ini 
                 and comis-deb-cred.dt-mov <= data-fim
                 and not comis-deb-cred.base-final,
               first mov-comis no-lock 
                     where mov-comis.cod-mov = comis-deb-cred.cod-mov:
               if comis-deb-cred.deb-cred then
                  assign c_operacao = "(-)"
                         de_vl_comissao = de_vl_comissao -
                                          comis-deb-cred.valor.
               else
                  assign c_operacao = "(+)"
                         de_vl_comissao = de_vl_comissao +
                                          comis-deb-cred.valor.
                  
              assign c-valor =
                       string(comis-deb-cred.valor,">>>,>>>,>>9.99").

              run html-ini-lin-tab.
              run html-tot-tab(12, c_operacao + mov-comis.descricao + " - "  + comis-deb-cred.historico, c-valor).
              run html-fim-lin-tab.
           end.

           assign c-valor = "<B>" + 
                            string(de_vl_comissao,"->>,>>>,>>9.99") +
                            "</B>".

           run html-ini-lin-tab.
           run html-tot-tab(12, "<B>Total a Receber</B>", c-valor).
           run html-fim-lin-tab.
           output close.

           RUN pi_envio_e_mail.
           assign de_vl_comissao = 0
                  de_vl_base = 0.

        end.
    end.
END. /*PROCEDURE pi-imp-baixadas-htm.*/
/* Procedure de neg¢cio */

PROCEDURE pi_envio_e_mail:
    
    FIND FIRST param-global NO-LOCK WHERE param-global.empresa-prin = "1" NO-ERROR.
    
    IF tt_imp.cod_e_mail = "" THEN DO:
        
        IF tg-rel-final-mes THEN
           ASSIGN v_nom_e_mail = "joelma@intelbras.com.br,claison@intelbras.com.br".
        ELSE
           ASSIGN v_nom_e_mail = "joelma@intelbras.com.br".

        ASSIGN v_nom_e_mail = REPLACE(v_nom_e_mail,' ','').

        /* envio de e-mail com erro (sem cadastro de e-mail para o representante) */
        create tt_mail_fax.
        assign tt_mail_fax.ttv_nom_servid       = param-global.serv-mail  
               tt_mail_fax.ttv_num_porta_servid = param-global.porta-mail 
               tt_mail_fax.ttv_nom_to           = v_nom_e_mail /*+ ",claudiney@intelbras.com.br,mario.fleith@datasul.com.br" em 17/06 Mario Fleith*/
               tt_mail_fax.ttv_nom_cc           = ""
               tt_mail_fax.ttv_nom_from         = "joelma@intelbras.com.br"
               tt_mail_fax.ttv_nom_subject      = "Representante sem e-mail" + string(tt_imp.cdn_repres,">>>>9")
               tt_mail_fax.ttv_nom_message      = c-texto-html[1]
               tt_mail_fax.ttv_nom_attachfile   = session:TEMP-DIRECTORY + c-arquivo
               tt_mail_fax.ttv_num_imptcia      = 2
               tt_mail_fax.ttv_cod_format_mail  = "texto".
    END.
    ELSE DO:
        
        IF tg-rel-final-mes THEN
           ASSIGN v_nom_e_mail = tt_imp.cod_e_mail + ",claison@intelbras.com.br,joelma@intelbras.com.br".
        ELSE
           ASSIGN v_nom_e_mail = tt_imp.cod_e_mail. /* + ",claudiney@intelbras.com.br,claudineyk@gmail.com". */

        ASSIGN v_nom_e_mail = REPLACE(v_nom_e_mail,' ','').

        /* envio de e-mail normal */
        create tt_mail_fax.
        assign tt_mail_fax.ttv_nom_servid       = param-global.serv-mail   
               tt_mail_fax.ttv_num_porta_servid = param-global.porta-mail  
               tt_mail_fax.ttv_nom_to           = v_nom_e_mail /*+ ",claudiney@intelbras.com.br,mario.fleith@datasul.com.br" em 17/06 Mario Fleith*/
               tt_mail_fax.ttv_nom_cc           = ""
               tt_mail_fax.ttv_nom_from         = "joelma@intelbras.com.br"
               tt_mail_fax.ttv_nom_subject      = "Relat¢rio de Comiss∆o de Representante" + string(tt_imp.cdn_repres,">>>>9")
               tt_mail_fax.ttv_nom_message      = c-texto-html[1]
               tt_mail_fax.ttv_nom_attachfile   = session:TEMP-DIRECTORY + c-arquivo 
               tt_mail_fax.ttv_num_imptcia      = 2
               tt_mail_fax.ttv_cod_format_mail  = "texto".
        IF Dwb_Set_List_Param.Cod_Dwb_User MATCHES '*comiss*' THEN DO:
           ASSIGN tt_mail_fax.ttv_nom_subject    = "Relat¢rio de Comiss∆o de Representante" + string(tt_imp.cdn_repres,">>>>9") + " (Acompanhamento Di†rio - Màs " + STRING(YEAR(data-ini))  + "/" + STRING(MONTH(data-ini),'99') + ")".
        END.
        ELSE DO:
           IF tg-rel-final-mes = YES THEN DO:
              ASSIGN tt_mail_fax.ttv_nom_subject = "Relat¢rio de Comiss∆o de Representante" + string(tt_imp.cdn_repres,">>>>9") + " (Fechamento Mensal - Màs " + STRING(YEAR(data-ini))  + "/" + STRING(MONTH(data-ini),'99') + ")".
           END.
           ELSE DO:
              IF rs-baixa = 3 THEN
                 ASSIGN tt_mail_fax.ttv_nom_subject = "Relat¢rio de Comiss∆o de Representante" + string(tt_imp.cdn_repres,">>>>9") + "( A Vencer geradas entre: " + STRING(data-ini) + " a " + STRING(data-fim) + " )".
              ELSE
                 ASSIGN tt_mail_fax.ttv_nom_subject = "Relat¢rio de Comiss∆o de Representante" + string(tt_imp.cdn_repres,">>>>9").
           END.
              
        END.
    END.

    run prgtec/btb/btb916za.r (input "1",
                                input  table tt_mail_fax,
                                output table tt_erros_mail_fax).

    /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
    IF CAN-FIND(tt_erros_mail_fax) THEN DO:
        
        ASSIGN v_arquivo_email = session:TEMP-DIRECTORY +  STRING('log_erro_email') + STRING(DAY(TODAY), "99") + STRING(MONTH(today),"99") + '.txt'.
        
        OUTPUT STREAM stream_2 TO  VALUE(v_arquivo_email) APPEND.

        PUT STREAM stream_2 SKIP(2)'Ocorreram o(s) seguinte(s) erro(s) na API de envio de email referente a rotina de comiss∆o:' SKIP(2).     

        FOR EACH tt_erros_mail_fax NO-LOCK:                                                                                                   
          PUT STREAM Stream_2  "Erro: "       tt_erros_mail_fax.ttv_cod_erro  " ; "                                                      
                               "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro      " ; "                                                      
                               "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo  " ; " skip.                                
        END.                                                                                                                                              
        OUTPUT STREAM Stream_2 CLOSE.
    END.

    FOR EACH tt_mail_fax:
        DELETE tt_mail_fax.
    END.
    
END PROCEDURE. /*PROCEDURE pi_envio_e_mail:*/

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


PROCEDURE pi-gera-tt-ava-ir-cpo:

    DEF VAR v_cod_refer AS CHAR NO-UNDO. 

    IF tit_ap.val_origin_tit_ap <> tit_ap.val_sdo_tit_ap THEN
       NEXT.

    IF tit_ap.val_sdo_tit_ap = 0 THEN 
       NEXT.

    RUN pi-referencia (OUTPUT v_cod_refer).

    /*Cria temp-table com as informaªÑes dos t≠tulos para alteraªío no APB. */       
    CREATE tt_tit_ap_alteracao_base_1.
    ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             =  'adm' /* v_cod_usuar_corren no batch est† es_super_numpedido */
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
           tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap               =  IF tit_ap.val_sdo_tit_ap <= 0.33 THEN tit_ap.val_sdo_tit_ap - 0.01 ELSE tit_ap.val_origin_tit_ap - ROUND((tit_ap.val_origin_tit_ap * 0.015),2)
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



    FIND FIRST plano_cta_ctbl NO-LOCK NO-ERROR.

    CREATE tt_tit_ap_alteracao_rateio.
    ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap           = RECID(tt_tit_ap_alteracao_base_1)
           tt_tit_ap_alteracao_rateio.tta_cod_estab            = v_cod_estab_usuar
           tt_tit_ap_alteracao_rateio.tta_cod_refer            = v_cod_refer
           tt_tit_ap_alteracao_rateio.tta_num_seq_refer        = int(i-seq-ava)
           tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ = ''
           tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl   = IF AVAIL plano_cta_ctbl THEN plano_cta_ctbl.cod_plano_cta_ctbl ELSE ''
           tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl         = v_ct_codigo
           tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc       = ''
           tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto     = '' 
           tt_tit_ap_alteracao_rateio.tta_cod_ccusto           = ''
           tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl       = IF tit_ap.val_sdo_tit_ap <= 0.33 THEN 0.01 ELSE ROUND((tit_ap.val_origin_tit_ap * 0.015),2)
           tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat          = 'Valor'
           tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        = tit_ap.num_id_tit_ap.

END PROCEDURE. /*PROCEDURE pi-gera-tt-ava-ir-cpo:*/


PROCEDURE pi-referencia :
    
    DEF OUTPUT PARAM p_cod_refer LIKE movto_tit_ap.cod_refer NO-UNDO.

    DEF VAR v_data_aux  AS CHAR            NO-UNDO.
    DEF VAR v_num_aux   AS INTEGER         NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER         NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER         NO-UNDO. 
    DEF VAR v_cod_refer  LIKE movto_tit_ap.cod_refer NO-UNDO.

    REPEAT:
      ASSIGN v_cod_refer = 'IR'.
      DO v_num_cont = 1 TO 8:
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
    
END PROCEDURE. /*PROCEDURE pi-referencia :*/

PROCEDURE pi-roda-api-ava-ir:
    ASSIGN v_arq_api_ir = ''.
    /* alteraá∆o de t°tulo */
    FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.
    IF AVAIL tt_tit_ap_alteracao_base_1 THEN 
    DO:
     FIND FIRST tt_tit_ap_alteracao_rateio NO-LOCK
        WHERE tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap = RECID(tt_tit_ap_alteracao_base_1) NO-ERROR.

     /*MESSAGE 'AVAIL tt_tit_ap_alteracao_base_1 ' AVAIL tt_tit_ap_alteracao_base_1 SKIP
             'avail tt_tit_ap_alteracao_rateio ' AVAIL tt_tit_ap_alteracao_rateio SKIP
             'tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl ' tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl SKIP
             'tit_ap.val_sdo_tit_ap                         ' tit_ap.val_sdo_tit_ap SKIP
             'tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap ' tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap SKIP
         VIEW-AS ALERT-BOX.*/

     RUN prgfin/apb/apb767zc.py (INPUT 1,
                                 INPUT "APB",
                                 INPUT '',        /*cod_matriz_trad_org_ext*/
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                 OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

    END.
    /*FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN
       MESSAGE 'ERRO???' skip(2) 'avail tt_log_erros_tit_ap_alteracao' AVAIL tt_log_erros_tit_ap_alteracao SKIP 
                /*"Fornec:    " tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  SKIP
                "Espec:     " tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto SKIP
                "SÇrie:     " tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   SKIP 
                "T°tulo:    " tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      SKIP 
                "Parc:      " tt_log_erros_tit_ap_alteracao.tta_cod_parcela     SKIP
                "Num Msg:   " tt_log_erros_tit_ap_alteracao.ttv_num_mensagem    SKIP
                "Desc Msg:  " tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro    SKIP
                "Ajuda Msg: " string(tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda,'x(50)')   SKIP
        
               'tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor  ' tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor  SKIP
               'tt_tit_ap_alteracao_base_1.tta_cod_espec_docto ' tt_tit_ap_alteracao_base_1.tta_cod_espec_docto SKIP
               'tt_tit_ap_alteracao_base_1.tta_cod_ser_docto   ' tt_tit_ap_alteracao_base_1.tta_cod_ser_docto   SKIP
               'tt_tit_ap_alteracao_base_1.tta_cod_tit_ap      ' tt_tit_ap_alteracao_base_1.tta_cod_tit_ap      SKIP
               'tt_tit_ap_alteracao_base_1.tta_cod_parcela     ' tt_tit_ap_alteracao_base_1.tta_cod_parcela     SKIP*/
        VIEW-AS ALERT-BOX.*/

    /* Moser verificar como fazer o tratamento de erro para execuá∆o batch */
    FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN 
    DO:
      /*MESSAGE 'ERRO ' VIEW-AS ALERT-BOX.*/
      ASSIGN v_arq_api_ir = session:temp-directory + "erro_ava_ir.txt".
      OUTPUT TO VALUE(v_arq_api_ir).

      /* Erros na execuá∆o da API */
      PUT 'Ocorreram o(s) seguinte(s) erro(s) na ALTERAÄ«O (AVA) do novo t°tulo de comiss∆o no Contas a Pagar:' SKIP. 
      FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK:
        PUT   "Estab: "     tt_log_erros_tit_ap_alteracao.tta_cod_estab       " ; "       
                             "Fornec: "    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  " ; "     
                             "Espec: "     tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto " ; "    
                             "SÇrie "      tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   " ; "    
                             "T°tulo: "    tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      " ; "    
                             "Parc: "      tt_log_erros_tit_ap_alteracao.tta_cod_parcela     " ; "    
                             "Num Msg: "   tt_log_erros_tit_ap_alteracao.ttv_num_mensagem    " ; "       
                             "Desc Msg: "  tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro    " ; "       
                             "Ajuda Msg: " tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
      END.
      OUTPUT CLOSE.
      
    END.
 
END PROCEDURE. /*PROCEDURE pi-roda-api-ava-ir:*/

PROCEDURE pi-a-vencer-cpe.

    ASSIGN i-seq-ava = 0.
    for each representante no-lock 
        where representante.cod_empresa = '1'
          and representante.cdn_repres >= repres-ini
          and representante.cdn_repres <= repres-fim,
        EACH emscad.fornecedor NO-LOCK
           WHERE emscad.fornecedor.cod_empresa     = representante.cod_empresa 
             AND emscad.fornecedor.num_pessoa      = representante.num_pessoa
             AND emscad.fornecedor.cod_grp_fornec >= gr-fornec-ini
             AND emscad.fornecedor.cod_grp_fornec <= gr-fornec-fim, 
        each tit_ap no-lock
          where tit_ap.cod_estab           = "101"
            and tit_ap.cdn_fornecedor      = emscad.fornecedor.cdn_fornecedor  
            AND tit_ap.dat_liquidac_tit_ap = 12/31/9999
            AND tit_ap.dat_transacao      >= data-ini
            AND tit_ap.dat_transacao      <= data-fim
            and tit_ap.cod_espec_docto     = "CPE"
            AND tit_ap.val_sdo_tit_ap     <> 0
        break by representante.cdn_repres
              by tit_ap.cod_ser_docto 
              by tit_ap.cod_tit_ap
              by tit_ap.cod_parcela:

        FIND FIRST movto_tit_ap OF tit_ap NO-LOCK
            WHERE movto_tit_ap.cod_estab          = '101'
              AND movto_tit_ap.ind_trans_ap_abrev = "IMPL" 
              AND movto_tit_ap.log_movto_estordo  = YES NO-ERROR.

        IF AVAIL movto_tit_ap THEN NEXT.

        FIND LAST b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab       = tit_ap.cod_estab  
              AND b_tit_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
              AND b_tit_ap.cod_espec_docto = 'CPE'
              AND b_tit_ap.cod_ser_docto   = tit_ap.cod_ser_docto
              AND b_tit_ap.cod_tit_ap      = SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) NO-ERROR.
        IF AVAIL b_tit_ap THEN
            ASSIGN c_parcela = b_tit_ap.cod_parcela.
        ELSE
            ASSIGN c_parcela = tit_ap.cod_parcela.

        ASSIGN v_num_id_tit_acr = 0
               c-nota           = tit_ap.cod_tit_ap.

        IF tit_ap.cod_ser_docto = "1" OR tit_ap.cod_ser_docto = "3" OR tit_ap.cod_ser_docto = "4" OR tit_ap.cod_ser_docto = "5" OR tit_ap.cod_ser_docto = "7" then  
           ASSIGN c-ser-docto = tit_ap.cod_ser_docto.
        ELSE                                    
           ASSIGN c-ser-docto = "".
        
        FOR EACH int_espec_docto_financ_acr NO-LOCK
            WHERE int_espec_docto_financ_acr.log_gera_comissao = YES:

           FIND FIRST tit_acr NO-LOCK
               WHERE tit_acr.cod_estab     = tit_ap.cod_estab 
               AND tit_acr.cod_ser_docto   = c-ser-docto 
               AND tit_acr.cod_espec_docto = int_espec_docto_financ_acr.cod_espec_docto
               AND tit_acr.cod_tit_acr     = SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) 
               AND tit_acr.cod_parcela     = tit_ap.cod_parcela NO-ERROR.
           IF AVAIL tit_acr THEN 
              ASSIGN v_num_id_tit_acr = tit_acr.num_id_tit_acr.
        END.

        FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab       = tit_ap.cod_estab
              AND tit_acr.num_id_tit_acr  = v_num_id_tit_acr NO-ERROR.

        IF NOT AVAIL tit_acr THEN DO:
           NEXT.
        END.
        
        /*  EM 20/05 - MARIO FLEITH - ENQUANTO VENDOR NAO ESTIVER NO AR, DESPREZAR TITULO COM ESPECIE "VE"*/
        /*  colocado no ar em 19/12/2005   *****/

        /* IF tit_acr.ind_tip_espec_docto = 'Vendor' THEN NEXT. */

        find first nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = "101"
              AND nota-fiscal.serie       = tit_acr.cod_ser_docto
              AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
/*        if not avail nota-fiscal then
           find first nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = "101"
                AND   nota-fiscal.serie       = "1"
                AND   nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr no-error.
  */  
        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
    
        if not avail ped-venda then do:
           FIND FIRST dupl_vendor NO-LOCK
                WHERE dupl_vendor.num_planilha_vendor = int(tit_acr.cod_tit_acr) NO-ERROR.

           FIND FIRST b_tit_acr NO-LOCK 
                WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                AND   b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                
           IF AVAIL b_tit_acr THEN DO:
              ASSIGN substr(c-nota,1,7) = b_tit_acr.cod_tit_acr.
               
              FIND FIRST nota-fiscal NO-LOCK                                                                                                  
                   WHERE nota-fiscal.cod-estabel = b_tit_acr.cod_estab                                                                         
                   AND   nota-fiscal.serie       = b_tit_acr.cod_ser_docto                                                                     
                   AND   nota-fiscal.nr-nota-fis = b_tit_acr.cod_tit_acr NO-ERROR.   
            END.
        end. /*if not avail ped-venda then do:*/
    
        find first ped-venda no-lock 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
              AND ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
    
        FIND FIRST emscad.cliente NO-LOCK 
           WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
    
        FIND FIRST repres_tit_acr NO-LOCK
           WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab 
             AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
             AND repres_tit_acr.cdn_repres     = representante.cdn_repres NO-ERROR.

        IF AVAIL repres_tit_acr THEN DO:

            /* Grava e-mail do representante para envio do relat¢rio */
            if  representante.num_pessoa modulo 2 <> 0 then do:
                find pessoa_jurid
                    where pessoa_jurid.num_pessoa_jurid = representante.num_pessoa no-lock no-error.
                if  avail pessoa_jurid then
                    ASSIGN v_cod_e_mail = pessoa_jurid.cod_e_mail.
            end.
            else do:
                find pessoa_fisic
                    where pessoa_fisic.num_pessoa_fisic = representante.num_pessoa no-lock no-error.
                if  avail pessoa_fisic then
                    ASSIGN v_cod_e_mail = pessoa_fisic.cod_e_mail.
            end.               

           /* Grava cidade e estado do cliente para o relat¢rio */
           if  cliente.num_pessoa modulo 2 <> 0 then do:
               find pessoa_jurid
                   where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_jurid then do:
                   ASSIGN v_nom_cidade_c       = pessoa_jurid.nom_cidade 
                          v_cod_unid_federac_c = pessoa_jurid.cod_unid_federac.
               end.
           end.
           else do:
               find pessoa_fisic
                   where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa no-lock no-error.
               if  avail pessoa_fisic then do:
                   ASSIGN v_nom_cidade_c       = pessoa_fisic.nom_cidade 
                          v_cod_unid_federac_c = pessoa_fisic.cod_unid_federac.
               end.
           end.               
    
           create tt_imp.
           assign tt_imp.cdn_fornecedor        = fornecedor.cdn_fornecedor
                  tt_imp.nom_abrev             = fornecedor.nom_abrev
                  tt_imp.cdn_repres            = representante.cdn_repres
                  tt_imp.nom_abrev_r           = representante.nom_abrev
                  tt_imp.nom_pessoa            = emscad.fornecedor.nom_pessoa
                  tt_imp.cod_ser_docto         = tit_ap.cod_ser_docto
                  tt_imp.cod_tit_ap            = c-nota
                  tt_imp.cod_parcela           = string(tit_ap.cod_parcela,"99") + "/" + c_parcela
                  tt_imp.dat_vencto_tit_ap     = tit_ap.dat_vencto_tit_ap 
                  tt_imp.dat_liquidac_tit_ap   = tit_ap.dat_liquidac_tit_ap 
                  tt_imp.dat_pedido            = if avail ped-venda then
                                                    ped-venda.dt-emissao
                                                 else
                                                     ?
                  tt_imp.cdn_cliente           = cliente.cdn_cliente
                  tt_imp.nom_abrev_c           = cliente.nom_abrev
                  tt_imp.nom_cidade_c          = v_nom_cidade_c
                  tt_imp.cod_unid_federac_c    = v_cod_unid_federac_c
                  tt_imp.cod_grp_clien         = emscad.cliente.cod_grp_clien
                  tt_imp.cod_e_mail            = v_cod_e_mail
                  tt_imp.val_origin_tit_ap     = tit_ap.val_sdo_tit_ap
                  tt_imp.val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres
                  tt_imp.val_base              = (tit_ap.val_sdo_tit_ap * 100) / 
                                                  repres_tit_acr.val_perc_comis_repres.
    
           IF repres_tit_acr.val_perc_comis_repres = 0 THEN
              ASSIGN tt_imp.val_origin_tit_ap = 0 
                     tt_imp.val_base          = 0. 

        END. /*IF AVAIL repres_tit_acr THEN DO:*/
    END. /*for each representante no-lock */
END. /*PROCEDURE pi-a-vencer-cpe.*/

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".
