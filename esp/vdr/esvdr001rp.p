/*****************************************************************************
**     Programa.........: vdr/esvdr001.p
**     Descricao .......: Relatorio de t¡tulos vendor a negociar
**     Versao...........: 1.00.000
**     Autor............: Claudiney
**     Criado...........: 02/01/2007
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
{esp/vdr/esvdr001tt.i}
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
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.
DEF VAR D-total-cond            as dec form ">>,>>>,>>9.99" no-undo.
DEF VAR D-total-perc            as dec form ">>,>>>,>>9.99" no-undo.
DEF VAR D-total-ger             as dec form ">>,>>>,>>9.99" no-undo.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio D¡vidas Cliente".

def var v_nom_enterprise as CHARACTER format "x(40)":U no-undo.
DEF VAR c-cod-estab  AS CHAR FORMAT "X(3)".
def var dt-base-ini  AS DATE FORMAT 99/99/9999.
def var dt-base-fim  AS DATE FORMAT 99/99/9999.
def var c-port-ini   AS CHAR FORMAT "X(5)".
def var c-port-fim   AS CHAR FORMAT "X(5)".
def var i-emit-ini   AS INT FORMAT "99999999".
def var i-emit-fim   AS INT FORMAT "99999999".
def var dt-emis-ini  AS DATE FORMAT "99/99/9999".
def var dt-emis-fim  AS DATE FORMAT "99/99/9999".

def frame fPageTop header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 60 format 'x(40)'
    'P gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.


def frame fPageBottom header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec¡ficos Intelbras - esvdr001rp - V:5.00.00.000' SKIP
    with no-box no-labels width 132 page-bottom stream-io.


find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.

if avail empresa then
    assign v_nom_enterprise   = empresa.nom_razao_social.
else
    assign v_nom_enterprise   = 'DATASUL'.

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esvdr001"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout
          c-cod-estab      = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
          dt-base-ini      = DATE(entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          dt-base-fim      = DATE(entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c-port-ini       = entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c-port-fim       = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
          i-emit-ini       = int(entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          i-emit-fim       = INT(entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          dt-emis-ini      = DATE(entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          dt-emis-fim      = DATE(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))).
          
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esvdr001"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           c-cod-estab      = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           dt-base-ini      = DATE(entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           dt-base-fim      = DATE(entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c-port-ini       = entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c-port-fim       = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           i-emit-ini       = int(entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           i-emit-fim       = INT(entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           dt-emis-ini      = DATE(entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           dt-emis-fim      = DATE(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))).
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esvdr001.lst".
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

ASSIGN C-Programa          = "esvdr001"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Titulos de vendor … negociar"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN Pi_Imprime_Relat.  /* Imprime relat¢rio em formato padrÆo EMS 5 */

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

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

PROCEDURE Pi_Imprime_Relat.
   
    VIEW STREAM STREAM_1 FRAME fPageTop.
    VIEW STREAM STREAM_1 FRAME fPageBottom.
    
    FOR EACH dupl_vendor no-lock
       WHERE dupl_vendor.cod_estab_tit_acr       = c-cod-estab
       AND   dupl_vendor.log_compon_planilha     = no       
       AND   dupl_vendor.cdn_cliente            >= i-emit-ini
       AND   dupl_vendor.cdn_cliente            <= i-emit-fim
       AND   dupl_vendor.dat_base_fechto_vendor >= dt-base-ini
       AND   dupl_vendor.dat_base_fechto_vendor <= dt-base-fim,
       FIRST tit_acr OF dupl_vendor NO-LOCK
             WHERE tit_acr.cod_portador    >= c-port-ini
             AND   tit_acr.cod_portador    <= c-port-fim
             AND   tit_acr.dat_emis_docto  >= dt-emis-ini
             AND   tit_acr.dat_emis_docto  <= dt-emis-fim
             AND   tit_acr.log_sdo_tit_acr  = yes,
       FIRST emitente NO-LOCK
          WHERE emitente.cod-emitente = dupl_vendor.cdn_cliente
       BREAK BY dupl_vendor.cod_cond_pagto_vendor
             BY dupl_vendor.val_cotac_tax_vendor_clien
             BY dupl_vendor.cdn_cliente:

       IF FIRST-OF(dupl_vendor.cod_cond_pagto_vendor) THEN do:
           FIND FIRST cond-pagto NO-LOCK
                WHERE cond-pagto.cod-cond-pag = int(dupl_vendor.cod_cond_pagto_vendor) NO-ERROR.
           DISP STREAM Stream_1 
               dupl_vendor.cod_cond_pagto_vendor FORMAT "X(3)" LABEL "Condi‡Æo de pagamento "
               " - "
               cond-pagto.descricao NO-LABEL WITH FRAME a SIDE-LABELS.
       end.
       
       assign D-total-cond = D-total-cond + dupl_vendor.val_origin_dupl_vendor
              D-total-perc = D-total-perc + dupl_vendor.val_origin_dupl_vendor
              D-total-ger  = D-total-ger  + dupl_vendor.val_origin_dupl_vendor.
       
       DISP STREAM STREAM_1
            dupl_vendor.val_cotac_tax_vendor_clien COLUMN-LABEL "Taxa Cliente"
            dupl_vendor.dat_base_fechto_vendor
            dupl_vendor.cdn_cliente
            emitente.nome-abrev
            tit_acr.cod_portador COLUMN-LABEL "Port"
            tit_acr.cod_estab COLUMN-LABEL "Est" FORMAT "X(3)"
            tit_acr.cod_espec_docto COLUMN-LABEL "Esp"
            tit_acr.cod_ser_docto COLUMN-LABEL "Ser"
            tit_acr.cod_tit_acr
            tit_acr.cod_parcela
            tit_acr.dat_emis_docto
            dupl_vendor.val_origin_dupl_vendor WITH WIDTH 180 STREAM-IO. 

       IF LAST-OF(dupl_vendor.val_cotac_tax_vendor_clien) THEN do:
           PUT STREAM Stream_1 fill(" ", 98) format "x(98)" "--------------" skip
               fill(" ", 60) format "x(60)"
               "TOTAL TAXA CLIENTE - " dupl_vendor.val_cotac_tax_vendor_clien " :  " D-total-perc skip.
           assign D-total-perc = 0.
       end.

       IF LAST-OF(dupl_vendor.cod_cond_pagto_vendor) THEN do:
           PUT STREAM Stream_1 fill(" ", 60) format "x(60)"
               "TOTAL CONDI€ÇO DE PAGAMENTO   - " dupl_vendor.cod_cond_pagto_vendor " :  " D-total-cond.
           assign D-total-cond = 0.
       end.
       

   END.
   
   PUT STREAM Stream_1 SKIP
   fill(" ", 98) format "x(98)" "--------------" skip fill(" ", 83) format "x(83)"
        "TOTAL GERAL  :  " D-total-ger.
   assign D-total-ger = 0.

END PROCEDURE. /* End da PROCEDURE Pi_Imprime_Relat */


IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".

