/*****************************************************************************
**     Programa.........: esp/acr/esacr012rp.p
**     Descricao .......: Relatorio de Indicaco para Perda
**     Versao...........: 1.00.000
**     Autor............: Catia Schmauch - Gestech
**     Criado...........: 
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/
{esp\acr\esacr012tt.i}
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

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/
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
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 255.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR.


DEFINE INPUT PARAM TABLE FOR tt_tit_acr.
DEFINE INPUT PARAM rs-opcao  as integer .

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr012a"
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
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr012a"
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
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr012a.lst".
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

FIND FIRST EmsUni.Empresa NO-LOCK 
     WHERE Empresa.Cod_Empresa = V_Cod_Empres_Usuar NO-ERROR.
IF AVAIL Empresa
THEN ASSIGN C-Empresa = Empresa.Nom_Razao_Social.
ELSE ASSIGN C-Empresa = "".

ASSIGN C-Programa          = "esacr012a"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relatorio de Indicacao para Perdas"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",255).

{esinc\es0002.i 255}

ASSIGN V_Num_Pag = 1.

RUN piImprimeRelat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat.
    DEF VAR c-cid       LIKE pessoa_fisic.nom_cidade.
    DEF VAR c-uf        LIKE pessoa_jurid.cod_unid_federac.

    VIEW STREAM Stream_1 FRAME fCabec255.
    VIEW STREAM Stream_1 FRAME fRodape255.

    if rs-opcao = 1  then do: /* Nr Titulo */
       for each tt_tit_acr
          where tt_tit_acr.selecionado = yes
          break by tt_tit_acr.vcod_tit_acr:
          disp stream stream_1
               vcod_estab            COLUMN-LABEL 'Est'
               vcod_espec            COLUMN-LABEL 'Esp'   
               vcod_ser              COLUMN-LABEL 'Serie'   
               vcod_tit_acr          COLUMN-LABEL 'Titulo'
               vcod_parcela          COLUMN-LABEL 'Pa'
               vcod_grp_clien        COLUMN-LABEL 'GrpClie'
               vcdn_cliente          COLUMN-LABEL 'Cliente'
               vnom_abrev            COLUMN-LABEL 'Nome Abrev'
               vdat_vencto_tit_acr   COLUMN-LABEL 'Dt Vencto'
               vdat_emis_tit_acr     COLUMN-LABEL 'Dt Emis Tit'
               vval_sdo_tit_acr      COLUMN-LABEL 'Saldo'
               vcont_parcelas        COLUMN-LABEL 'Nr Pa'
               vnum_atras            COLUMN-LABEL 'Num Atras'
               vsit_tit_acr          COLUMN-LABEL 'Regra'
               with width 255 stream-io.       
       end.
    end.
    if rs-opcao = 2  then do: /* Cliente */
       for each tt_tit_acr
          where tt_tit_acr.selecionado = yes
          break by tt_tit_acr.vcdn_cliente:
          disp stream stream_1
               vcod_estab            COLUMN-LABEL 'Est'
               vcod_espec            COLUMN-LABEL 'Esp'   
               vcod_ser              COLUMN-LABEL 'Serie'   
               vcod_tit_acr          COLUMN-LABEL 'Titulo'
               vcod_parcela          COLUMN-LABEL 'Pa'
               vcdn_cliente          COLUMN-LABEL 'Cliente'
               vnom_abrev            COLUMN-LABEL 'Nome Abrev'
               vdat_vencto_tit_acr   COLUMN-LABEL 'Dt Vencto'
               vdat_emis_tit_acr     COLUMN-LABEL 'Dt Emis Tit'
               vval_sdo_tit_acr      COLUMN-LABEL 'Saldo'
               vcont_parcelas        COLUMN-LABEL 'Nr Pa'
               vnum_atras            COLUMN-LABEL 'Num Atras'
               vsit_tit_acr          COLUMN-LABEL 'Regra'
               with width 255 stream-io.       
       end.
    end.
    if rs-opcao = 3  then do: /* Num Tras */
       for each tt_tit_acr
          where tt_tit_acr.selecionado = yes
          break by tt_tit_acr.vnum_atras:
          disp stream stream_1
               vcod_estab            COLUMN-LABEL 'Est'
               vcod_espec            COLUMN-LABEL 'Esp'   
               vcod_ser              COLUMN-LABEL 'Serie'   
               vcod_tit_acr          COLUMN-LABEL 'Titulo'
               vcod_parcela          COLUMN-LABEL 'Pa'
               vcdn_cliente          COLUMN-LABEL 'Cliente'
               vnom_abrev            COLUMN-LABEL 'Nome Abrev'
               vdat_vencto_tit_acr   COLUMN-LABEL 'Dt Vencto'
               vdat_emis_tit_acr     COLUMN-LABEL 'Dt Emis Tit'
               vval_sdo_tit_acr      COLUMN-LABEL 'Saldo'
               vcont_parcelas        COLUMN-LABEL 'Cont Pa'
               vnum_atras            COLUMN-LABEL 'Num Atras'
               vsit_tit_acr          COLUMN-LABEL 'Regra'
               with width 255 stream-io.       
       end.
    end.
    if rs-opcao = 4  then do: /* Dt Vencto */
       for each tt_tit_acr
          where tt_tit_acr.selecionado = yes
          break by tt_tit_acr.vdat_vencto_tit_acr:
          disp stream stream_1
               vcod_estab            COLUMN-LABEL 'Est'
               vcod_espec            COLUMN-LABEL 'Esp'   
               vcod_ser              COLUMN-LABEL 'Serie'   
               vcod_tit_acr          COLUMN-LABEL 'Titulo'
               vcod_parcela          COLUMN-LABEL 'Pa'
               vcdn_cliente          COLUMN-LABEL 'Cliente'
               vnom_abrev            COLUMN-LABEL 'Nome Abrev'
               vdat_vencto_tit_acr   COLUMN-LABEL 'Dt Vencto'
               vdat_emis_tit_acr     COLUMN-LABEL 'Dt Emis Tit'
               vval_sdo_tit_acr      COLUMN-LABEL 'Saldo'
               vcont_parcelas        COLUMN-LABEL 'Cont Pa'
               vnum_atras            COLUMN-LABEL 'Num Atras'
               vsit_tit_acr          COLUMN-LABEL 'Regra'
               with width 255 stream-io.       
       end.
    end.
    if rs-opcao = 5  then do: /* Dt Emissao */
       for each tt_tit_acr
          where tt_tit_acr.selecionado = yes
          break by tt_tit_acr.vdat_emis_tit_acr:
          disp stream stream_1
               vcod_estab            COLUMN-LABEL 'Est'
               vcod_espec            COLUMN-LABEL 'Esp'   
               vcod_ser              COLUMN-LABEL 'Serie'   
               vcod_tit_acr          COLUMN-LABEL 'Titulo'
               vcod_parcela          COLUMN-LABEL 'Pa'
               vcdn_cliente          COLUMN-LABEL 'Cliente'
               vnom_abrev            COLUMN-LABEL 'Nome Abrev'
               vdat_vencto_tit_acr   COLUMN-LABEL 'Dt Vencto'
               vdat_emis_tit_acr     COLUMN-LABEL 'Dt Emis Tit'
               vval_sdo_tit_acr      COLUMN-LABEL 'Saldo'
               vcont_parcelas        COLUMN-LABEL 'Cont Pa'
               vnum_atras            COLUMN-LABEL 'Num Atras'
               vsit_tit_acr          COLUMN-LABEL 'Regra'
               with width 255 stream-io.       
       end.
    end.
    
    
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
