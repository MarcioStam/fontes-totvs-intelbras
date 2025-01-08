/*****************************************************************************
**     Programa.........: esp/es0796arp.p
**     Descricao .......: Relat¢rio Pagamentos Efetuados
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 20/12/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/


DEFINE VARIABLE cCod_empresa    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCdn_cliente    AS INTEGER      NO-UNDO.
DEFINE VARIABLE dtBaixaini      AS DATE         NO-UNDO.
DEFINE VARIABLE dtBaixafim      AS DATE         NO-UNDO.
DEFINE VARIABLE cEspecieini     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cEspeciefim     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPortadorini    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPortadorfim    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE i-tit   LIKE tit_acr.cod_tit_acr.
DEFINE VARIABLE da-tit  LIKE tit_acr.dat_vencto_tit_acr.

DEFINE BUFFER bTit_acr FOR tit_acr.


def temp-table tt-baixa
    field cod-esp       like tit_acr.cod_espec_docto
    field nr-docto      like tit_acr.cod_tit_acr
    field parcela       like tit_acr.cod_parcela label "Pa"
    field tit-vend      LIKE tit_acr.cod_tit_acr label "NF"
    field cod-port      like movto_tit_acr.cod_portador
    field modalidade    like movto_tit_acr.cod_cart_bcia label "M"
    field dt-vencimen   like movto_tit_acr.dat_vencto_tit_acr
    field dt-baixa      like movto_tit_acr.dat_liquidac_tit_acr
    field periodo       as char format "9999/99"
    field vl-baixa      like movto_tit_acr.val_abat_tit_acr
    index tt-baixas is primary unique cod-esp nr-docto parcela dt-baixa.


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

def var v_nom_enterprise as CHARACTER format "x(40)":U no-undo.


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

def new shared var v_rpt_s_1_page as integer.



def frame fPageTop header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 42 format 'x(40)'
    'P gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.


def frame fPageBottom header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec¡ficos Intelbr s - esftp002arp - V:5.00.00.000' SKIP
    with no-box no-labels width 132 page-bottom stream-io.



find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.

if avail empresa then
    assign v_nom_enterprise   = empresa.nom_razao_social.
else
    assign v_nom_enterprise   = 'DATASUL'.


IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "es0796a"
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
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "es0796a"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_List_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_List_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_List_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_List_Param.Cod_Dwb_Print_layout.

    IF NUM-ENTRIES(Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10)) > 8 THEN
        ASSIGN cCod_empresa     = ENTRY(2, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10))
               iCdn_cliente     = INTEGER(ENTRY(3, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10)))
               dtBaixaini       = DATE(ENTRY(4, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10)))
               dtBaixafim       = DATE(ENTRY(5, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10)))
               cEspecieini      = ENTRY(6, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10))
               cEspeciefim      = ENTRY(7, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10))
               cPortadorini     = ENTRY(8, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10))
               cPortadorfim     = ENTRY(9, Dwb_Set_List_Param.Cod_dwb_parameters, CHR(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "es0796a.lst".
      OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET 'iso8859-1'.
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
          END. /* End do - IF AVAIL Ped_Exec */
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
          WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = layout_impres.Num_Id_Layout_Impres
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

ASSIGN C-Programa          = "es0796a"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Pagamentos Efetuados"
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

PROCEDURE Pi_Imprime_Relat:

    RUN pi-gera-tt IN THIS-PROCEDURE.


    FIND emscad.cliente NO-LOCK
        WHERE cliente.cod_empresa = cCod_empresa
          AND cliente.cdn_cliente = iCdn_cliente
        NO-ERROR.
    IF NOT AVAILABLE cliente THEN
        RETURN.

    VIEW STREAM STREAM_1 FRAME fPageTop.
    VIEW STREAM STREAM_1 FRAME fPageBottom.


    disp STREAM Stream_1 cliente.cdn_cliente
         " - "
         cliente.nom_pessoa with no-labels SIDE-LABELS STREAM-IO.

    for each tt-baixa 
        break by tt-baixa.periodo
              by tt-baixa.dt-baixa:

        disp STREAM Stream_1
             tt-baixa.cod-esp
             tt-baixa.nr-docto
             tt-baixa.parcela
             tt-baixa.tit-ven
             tt-baixa.cod-port
             tt-baixa.modalidade
             tt-baixa.dt-vencimen
             tt-baixa.dt-baixa
             tt-baixa.dt-baixa - tt-baixa.dt-vencimen label "DD" format "->>>9"
             tt-baixa.vl-baixa (total by tt-baixa.periodo)
            with width 132 STREAM-IO.

    end.
END PROCEDURE. /* End da PROCEDURE Pi_Imprime_Relat */

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



{esp/acr/esacr002.i}
