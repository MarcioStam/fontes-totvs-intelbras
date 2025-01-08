/*****************************************************************************
**     Programa.........: esp/vdr/esvdr002rp.p
**     Descricao .......: Emissao de Planilha Vendor
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/
{esp/vdr/esvdr002tt.i}
/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid            as character format "x(30)"
    field ttv_num_porta_servid  as integer   format ">>>>9"
    field ttv_log_exchange          as logical   format "Sim/N∆o" initial no
    field ttv_nom_from              as character format "x(50)"
    field ttv_nom_to                as character format "x(50)" label "To"
    field ttv_nom_cc                as character format "x(50)" label "Cc"
    field ttv_nom_subject           as character format "x(30)"
    field ttv_nom_message           as character format "x(50)"
    field ttv_nom_attachfile    as character format "x(30)"
    field ttv_num_imptcia           as integer   format "9"
    field ttv_log_envda             as logical   format "Sim/N∆o" initial no
    field ttv_log_lida              as logical   format "Sim/N∆o" initial no
    field ttv_cod_format_mail   as character format "x(8)"    initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro          as character format "x(10)"
    field ttv_des_erro          as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo       as character format "x(255)".

/* Temp-table para envio de e-mail */
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

DEF INPUT PARAM TABLE FOR tt-plan.      

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
DEF VAR v_nom_enterprise        AS CHAR FORM "x(40)"  NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Emiss∆o Planilha Vendor".

DEF VAR l-tem          AS LOGICAL.
DEF VAR c-msg          AS CHAR FORMAT "X(50)".
DEF VAR c-cli-sem-mail AS CHAR FORMAT "x(2000)".
DEF VAR c-email        LIKE cont-emit.e-mail.
DEF VAR c-mensagem     AS CHAR FORMAT "x(2000)".
DEF VAR de-total       LIKE parc_vendor.val_parc_vendor_orig FORMAT ">>,>>>,>>9.99".
DEF VAR de-tot-ori     LIKE parc_vendor.val_parc_vendor_orig FORMAT ">>,>>>,>>9.99".
DEF VAR mes            AS CHAR FORMAT "x(10)" EXTENT 12 INITIAL
["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"].

def frame f-cabec header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 42 format 'x(40)'
    'P†gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.

def frame f-rodape header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec°ficos Intelbr†s - esvdr002 - V:5.00.00.000' SKIP
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

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esvdr002"
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
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esvdr002"
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
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esvdr002.lst".
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

ASSIGN C-Programa          = "esvdr002"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Emiss∆o Planilha Vendor"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

PROCEDURE piImprimeRelat.

    FOR EACH tt-enviado:
       DELETE tt-enviado.
    END.
    FOR EACH tt-nao-env:
       DELETE tt-nao-env.
    END.
    
    FOR EACH tt-plan
        BREAK BY tt-plan.num_planilha_vendor:

        RUN monta-planilha.

        IF l-tem THEN DO:

            FOR EACH tt_mail_fax:
                DELETE tt_mail_fax.
            END.
            FOR EACH tt_erros_mail_fax:
                DELETE tt_erros_mail_fax.
            END.

            ASSIGN c-msg = "A/C Contas a Pagar - Vendor - " + STRING(tt-plan.num_planilha_vendor).

            /***** ativar parte de e-mail ******/ 
            CREATE tt_mail_fax.
            ASSIGN tt_mail_fax.ttv_nom_to           = c-email
                   tt_mail_fax.ttv_nom_subject      = c-msg
                   tt_mail_fax.ttv_nom_message      = c-mensagem
                   tt_mail_fax.ttv_nom_attachfile   = ""    
                   tt_mail_fax.ttv_num_imptcia      = 2
                   tt_mail_fax.ttv_cod_format_mail  = "texto".

            FOR FIRST usuar_mestre NO-LOCK 
                WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
                ASSIGN tt_mail_fax.ttv_nom_from = IF usuar_mestre.cod_e_mail_local = "" THEN "Financeiro@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.
            END.
            
            run prgtec\btb\btb916za.py (input "1",
                                        input  table tt_mail_fax,
                                        output table tt_erros_mail_fax).

            /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
            IF  CAN-FIND(tt_erros_mail_fax) THEN DO:
                FIND FIRST tt_erros_mail_fax NO-LOCK NO-ERROR.

                IF AVAIL tt_erros_mail_fax THEN
                    MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                            "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                            "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo                          
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END. 
        END.
        ELSE DO:
           /***** ENVIA E-MAIL PARA O ESCRITORIO QDO NAO CONSEGUE ENVIAR E-MAIL PARA O CLIENTE ****/
    
           FIND FIRST repres NO-LOCK 
               WHERE repres.cod-rep = emitente.cod-rep 
               AND   repres.e-mail    <> "" NO-ERROR.

           IF AVAIL repres THEN DO:

               FOR EACH tt_mail_fax:
                   DELETE tt_mail_fax.
               END.
               FOR EACH tt_erros_mail_fax:
                   DELETE tt_erros_mail_fax.
               END.
    
               ASSIGN c-cli-sem-mail = "O Cliente "       +
                                       emitente.nome-emit + " n∆o possue e-mail cadastrado." + CHR(10) +
                                       "Pedimos que vocà envie o e-mail deste " +
                                       "cliente para o endereco leticia.santos@intelbras.com.br.". 

               ASSIGN c-msg = "A/C Contas a Pagar - Vendor - " + STRING(tt-plan.num_planilha_vendor). 

               CREATE tt_mail_fax.
               ASSIGN tt_mail_fax.ttv_nom_to           = repres.e-mail
                      tt_mail_fax.ttv_nom_subject      = c-msg
                      tt_mail_fax.ttv_nom_message      = c-cli-sem-mail
                      tt_mail_fax.ttv_nom_attachfile   = ""    
                      tt_mail_fax.ttv_num_imptcia      = 2
                      tt_mail_fax.ttv_cod_format_mail  = "texto".

               FOR FIRST usuar_mestre NO-LOCK 
                   WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
                   ASSIGN tt_mail_fax.ttv_nom_from = IF usuar_mestre.cod_e_mail_local = "" THEN "Financeiro@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.
               END.

               run prgtec\btb\btb916za.py (input "1",
                                           input  table tt_mail_fax,
                                           output table tt_erros_mail_fax).

               /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
               IF  CAN-FIND(tt_erros_mail_fax) THEN DO:
                   FIND FIRST tt_erros_mail_fax NO-LOCK NO-ERROR.
                   IF AVAIL tt_erros_mail_fax THEN
                       MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                               "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                               "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo                          
                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
               END. 
           END.
        END.  
    END.

    VIEW STREAM STREAM_1 FRAME f-cabec.
    VIEW STREAM STREAM_1 FRAME f-rodape.

    DISP STREAM STREAM_1 "E-mail enviados com sucesso" WITH FRAME f-suc STREAM-IO.

    FOR EACH tt-enviado
       BREAK BY tt-enviado.cdn_repres:

         IF FIRST-OF(tt-enviado.cdn_repres) then do:

            FIND repres NO-LOCK 
                WHERE repres.cod-rep  = tt-enviado.cdn_repres NO-ERROR.
            IF AVAIL repres THEN
                DISP STREAM STREAM_1
                     tt-enviado.cdn_repres "-" repres.nome 
                     WITH NO-LABELS FRAME f-rep STREAM-IO. 
            ELSE 
                DISP STREAM STREAM_1
                     tt-enviado.cdn_repres
                     WITH NO-LABELS FRAME f-rep STREAM-IO. 
         END.

         DISP STREAM STREAM_1
              emitente.cod-emitente
              emitente.nome-emit
              tt-enviado.e-mail      FORMAT "X(130)"
              tt-enviado.num_planilha_vendor WITH FRAME f-enviado NO-LABELS WIDTH 132 STREAM-IO.
         DOWN STREAM STREAM_1 WITH FRAME f-enviado.
    END.

    DISP STREAM STREAM_1 "Planilhas n∆o enviadas por falta de informaá∆o" WITH FRAME f-erro STREAM-IO.
    
    FOR EACH tt-nao-env
      BREAK BY tt-nao-env.cdn_repres:

      IF FIRST-OF(tt-nao-env.cdn_repres) THEN DO:

         FIND repres NO-LOCK
             WHERE repres.cod-rep = tt-nao-env.cdn_repres NO-ERROR.

         IF AVAIL repres THEN
             DISP STREAM STREAM_1 
                  tt-nao-env.cdn_repres "-" repres.nome 
                  WITH NO-LABELS FRAME f-rep2 STREAM-IO. 
         ELSE 
             DISP STREAM STREAM_1 
                  tt-nao-env.cdn_repres 
                  WITH NO-LABELS FRAME f-rep2 STREAM-IO. 
      END.

      FIND emitente NO-LOCK
           WHERE emitente.cod-emitente = tt-nao-env.cdn_cliente.

      DISP STREAM STREAM_1
           emitente.cod-emitente
           emitente.nome-emit
           emitente.telefone[1]
           tt-nao-env.num_planilha_vendor WITH FRAME f-nao-env STREAM-IO NO-LABELS WIDTH 132.
      DOWN STREAM STREAM_1 WITH FRAME f-nao-env.
    END.

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */


PROCEDURE monta-planilha.

    ASSIGN de-total   = 0
           de-tot-ori = 0
           l-tem      = NO.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-plan.cdn_cliente NO-ERROR.

    FIND FIRST emscad.portador NO-LOCK
         WHERE emscad.portador.cod_portador = tt-plan.cod_portador NO-ERROR.

    FIND FIRST emscad.cliente NO-LOCK
        WHERE emscad.cliente.cdn_cliente = tt-plan.cdn_cliente NO-ERROR.

    IF AVAIL emscad.cliente THEN DO:
        RUN esp/acr/esacr003b.p (INPUT emscad.cliente.num_pessoa,
                                 OUTPUT c-email).   /* Programa para buscar e-mail do cliente */
        ASSIGN c-email = TRIM(c-email).
        IF c-email <> "" THEN
            ASSIGN l-tem = YES.
    END.

    IF l-tem THEN DO:
        CREATE tt-enviado.
        ASSIGN tt-enviado.cdn_repres          = emitente.cod-rep
               tt-enviado.cdn_cliente         = emitente.cod-emitente
               tt-enviado.e-mail              = c-email
               tt-enviado.num_planilha_vendor = tt-plan.num_planilha_vendor.
    END.
    ELSE DO:
        CREATE tt-nao-env.
        ASSIGN tt-nao-env.cdn_repres          = emitente.cod-rep
               tt-nao-env.cdn_cliente         = emitente.cod-emitente
               tt-nao-env.num_planilha_vendor = tt-plan.num_planilha_vendor.
    END.

    ASSIGN c-mensagem = "CARTA PARA SIMPLES CONFER“NCIA - ESTE N«O ê UM DOCUMENTO DE COBRANÄA" + CHR(10) + CHR(10) +
                        "Planilha No. " + STRING(tt-plan.num_planilha_vendor)              +
                        "  Solicitaá∆o de Financiamento - Vendor   1a. Via"      + CHR(10) + CHR(10) +
                        "FORNECEDOR Intelbras S/A - Ind.Tel.Eletr.Brasileira"              + CHR(10) +
                        "ENDERECO   Rodovia BR 101 - Km 210 - Area Industrial  Sao JosÇ  SC CEP 88014.800"  + CHR(10) +
                        "CNPJ       82.901.000/0001-27"                          + CHR(10) + CHR(10) +
                        "CREDITADA "                                                       + CHR(10) +  
                        emitente.nome-emit + "(" + STRING(emitente.cod-emitente) + ")"     + CHR(10) +
                        "ENDERECO  " + emitente.endereco                                   + CHR(10) +
                        "          " + emitente.cidade + "  " + 
                        emitente.estado  + "  CEP " + STRING(emitente.cep)                 + CHR(10) +
                        "CNPJ      " + STRING(emitente.cgc,"99.999.999/9999-99") + CHR(10) + CHR(10) +
                        portador.nom_pessoa                                                + CHR(10) +
                        "CNPJ      " + STRING(portador.cod_id_feder,"99.999.999/9999-99")  + CHR(10) + CHR(10) +
                        "Duplicata"  +
                        CHR(10) + CHR(10)       +
                        "Esp Docto/P    Emiss∆o       Vl.Original" + 
                        CHR(10)                                    +
                        "--- ---------- ---------- --------------".                                 

    FOR EACH dupl_vendor NO-LOCK 
        WHERE dupl_vendor.num_planilha_vendor = tt-plan.num_planilha_vendor,
        FIRST tit_acr NO-LOCK
        WHERE tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
        AND   tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr:

        ASSIGN c-mensagem = c-mensagem                                      + 
                            CHR(10)                                         +                           
                            tit_acr.cod_espec_docto                         + "  " +
                            tit_acr.cod_tit_acr                             + " "  +
                            tit_acr.cod_parcela                             + " "  +
                            STRING(dupl_vendor.dat_emis_docto,"99/99/9999") + " "  +
                            STRING(dupl_vendor.val_origin_dupl_vendor,">>>,>>>,>>9.99").
    END.

    ASSIGN c-mensagem = c-mensagem                            +
                        CHR(10) + CHR(10)                     +
                        "Parcelas da Negociaá∆o"              +
                        CHR(10) + CHR(10)                     +
                        "Esp Docto Parc Vencimento Valor Original  Valor Cliente"  +
                        CHR(10)                                                    + 
                        "--- ----- ---- ---------- -------------- --------------".

    FOR EACH parc_vendor NO-LOCK
        WHERE parc_vendor.cod_estab           = tt-plan.cod_estab
        AND   parc_vendor.num_planilha_vendor = tt-plan.num_planilha_vendor,
        FIRST tit_acr NO-LOCK
        WHERE tit_acr.cod_estab       = parc_vendor.cod_estab_tit_acr
        AND   tit_acr.num_id_tit_acr  = parc_vendor.num_id_tit_acr
        AND   tit_acr.cod_espec_docto = "VE":

        ASSIGN c-mensagem = c-mensagem + CHR(10)     +
                            tit_acr.cod_espec_docto  + "  " +
                            tit_acr.cod_tit_acr      + " "  +
                            tit_acr.cod_parcela      + " "  +
                            STRING(tit_acr.dat_vencto_tit_acr,"99/99/9999")            + " " +
                            STRING(parc_vendor.val_parc_vendor_orig,">>>,>>>,>>9.99")  + " " +
                            STRING(parc_vendor.val_parc_vendor_clien,">>>,>>>,>>9.99").

        ASSIGN de-total   = de-total   + parc_vendor.val_parc_vendor_clien
               de-tot-ori = de-tot-ori + parc_vendor.val_parc_vendor_orig.      
    END.

    ASSIGN c-mensagem = c-mensagem   + 
                        CHR(10)      + CHR(10) +
                        "              Total....." + STRING(de-tot-ori,">>>,>>>,>>9.99")    + " " + 
                        STRING(de-total,">>>,>>>,>>9.99") +
                        CHR(10)      + CHR(10) + CHR(10)   +
                        "Sao JosÇ, " + STRING(DAY(TODAY),">9") + " de " + TRIM(mes[MONTH(TODAY)]) + " de " + 
                        STRING(YEAR(TODAY),"9999") +
                        CHR(10)      + CHR(10) + 
                        "Caso n∆o receba o boleto banc†rio, favor entrar em contato." + CHR(10) +
                        "e-mail..: leticia.santos@intelbras.com.br"                   + CHR(10) +
                        "Fax.....: (0xx48) 3281-9539 "                                + CHR(10) +
                        "Telefone: (0xx48) 3281-9628 ". 
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
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */
  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).

END PROCEDURE.  /* End da Procedure Pi-Abre-Edit */

