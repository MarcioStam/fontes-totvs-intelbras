/*****************************************************************************
**     Programa.........: esp/acr/esacr006brp.p
**     Descricao .......: 
**     Versao...........: 1.00.000
**     Autor............: Chaves - Gestech
**     Criado...........: 
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
{esp\acr\esacr006tt.i}
DEFINE TEMP-TABLE ttRegiao
    FIELD nome-ab-reg     LIKE repres.nome-ab-reg 
    FIELD nome-regiao     LIKE regiao.nome-regiao 
    FIELD val_sdo_tit_acr LIKE tt-tit.val_sdo_tit_acr.

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
def var de-centrais as dec.
def var de-fones as dec.
def var de-export as dec.

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


DEFINE INPUT PARAM da-data-ini as date format "99/99/9999".
DEFINE INPUT PARAM da-data-fim as date format "99/99/9999".
DEFINE INPUT PARAM TABLE FOR tt-tit.

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
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr006b"
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
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr006b"
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
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr006b.lst".
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

ASSIGN C-Programa          = "esacr006b"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Titulos a Abater da Participacao"
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
    DEF VAR c-cid       LIKE pessoa_fisic.nom_cidade.
    DEF VAR c-uf        LIKE pessoa_jurid.cod_unid_federac.

    disp STREAM Stream_1
         da-data-ini label "Data Inicial" skip
         da-data-fim label "Data   Final" 
         with frame f-selecao SIDE-LABELS STREAM-IO.

    assign de-fones = 0
           de-centrais = 0
           de-export = 0.

    for each tt-tit no-lock,
       FIRST emscad.cliente NO-LOCK
       WHERE emscad.cliente.cod_empresa = tt-tit.cod_empresa
       AND   emscad.cliente.cdn_cliente = tt-tit.cdn_cliente,
       FIRST clien_financ NO-LOCK
       WHERE clien_financ.cod_empresa = emscad.cliente.cod_empresa
       AND   clien_financ.cdn_cliente = emscad.cliente.cdn_cliente,
       FIRST grp_clien NO-LOCK
       WHERE grp_clien.cod_grp_clien = emscad.cliente.cod_grp_clien,
       FIRST representante NO-LOCK
       WHERE representante.cod_empresa = clien_financ.cod_empresa
       AND   representante.cdn_repres  = clien_financ.cdn_repres
       break by tt-tit.cdn_cliente
             by tt-tit.dat_vencto_tit_acr
             by tt-tit.cod_tit_acr:
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_jurid.cod_unid_federac.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                ASSIGN c-cid       = pessoa_jurid.nom_cidade
                       c-uf        = pessoa_jurid.cod_unid_federac.
            END.
        END.

       disp STREAM Stream_1
            representante.cdn_repres
            tt-tit.cdn_cliente
            cliente.nom_pessoa
            tt-tit.cod_tit_acr
            tt-tit.cod_parcela
            tt-tit.cod_espec_docto
            tt-tit.dat_vencto_tit_acr
            tt-tit.val_sdo_tit_acr  (total by tt-tit.cdn_cliente) 
            tt-tit.cod_portador
            tt-tit.cod_cart_bcia
            tt-tit.cdn_repres
            tt-tit.nom_abrev
            c-cid /* emitente.cidade */
            c-uf  /* emitente.estado */
            emscad.cliente.cod_grp_clien /*emitente.cod-gr-cli*/
            grp_clien.des_grp_clien
            WITH WIDTH 350 STREAM-IO.
       FOR FIRST repres NO-LOCK 
           WHERE repres.nome-abrev = representante.nom_abrev:
           FOR FIRST regiao NO-LOCK 
               WHERE regiao.nome-ab-reg = repres.nome-ab-reg:
           END.

          FIND FIRST ttRegiao
               WHERE ttRegiao.nome-ab-reg = repres.nome-ab-reg NO-ERROR.
          IF NOT AVAIL ttRegiao THEN
          DO:
              CREATE ttRegiao.
              ASSIGN ttRegiao.nome-ab-reg = repres.nome-ab-reg 
                     ttRegiao.nome-regiao = IF AVAIL regiao THEN 
                         regiao.nome-regiao ELSE "Sem Regiao p[" + representante.nom_abrev + "-" + 
                                                                   repres.nome-ab-reg + "]". 
          END.
          ASSIGN ttRegiao.val_sdo_tit_acr = ttRegiao.val_sdo_tit_acr + tt-tit.val_sdo_tit_acr.

       END.

           /*
           if representante.cdn_repres >= 200 and
              representante.cdn_repres <= 299 then
              assign de-centrais = de-centrais + tt-tit.val_sdo_tit_acr.
           if representante.cdn_repres >= 300 and
              representante.cdn_repres <= 399 then
              assign de-fones = de-fones + tt-tit.val_sdo_tit_acr.
           if representante.cdn_repres >= 500 and
              representante.cdn_repres <= 599 then
              assign de-export = de-export + tt-tit.val_sdo_tit_acr.
           */
   END.


   FOR EACH ttRegiao.
       PUT STREAM Stream_1
           "TOTAL " 
           ttRegiao.nome-ab-reg "-" 
           ttRegiao.nome-regiao "-->" 
           ttRegiao.val_sdo_tit_acr SKIP.
   END.

   /*
   put STREAM Stream_1
       skip(3)
       "Total de   Centrais: " de-centrais " - " de-centrais / 
                  (de-centrais + de-fones + de-export) * 100 "%" skip
       "Total de  Telefones: " de-fones " - " de-fones / 
                  (de-centrais + de-fones + de-export) * 100 "%" skip
       "Total de Exportacao: " de-export " - " de-export / 
                  (de-centrais + de-fones + de-export) * 100 "%" skip
       "Total         Geral: "   (de-centrais + de-fones + de-export).
   */
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
