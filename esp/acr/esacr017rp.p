/*****************************************************************************
**     Programa.........: esp/acr/esacr017rp.p
**     Descricao .......: Relat¢rio de Pagamentos Efetuados
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/

def temp-table tt-baixa                    
    FIELD cod_estab      LIKE tit_acr.cod_estab
    FIELD cdn_cliente    LIKE tit_acr.cdn_cliente 
    FIELD nom_cliente    LIKE emscad.cliente.nom_abrev FORMAT "x(12)"
    FIELD cod_ser_docto  LIKE tit_acr.cod_ser_docto
    FIELD cdn_repres     LIKE tit_acr.cdn_repres
    FIELD nom_repres     LIKE representante.nom_abrev FORMAT "x(12)"
    FIELD val_perc_comis LIKE repres_tit_acr.val_perc_comis_repres
    field cod-esp        LIKE tit_acr.cod_espec_docto
    field nr-docto       LIKE tit_acr.cod_tit_acr
    FIELD cod-docto      LIKE tit_acr.cod_tit_acr
    field parcela        LIKE tit_acr.cod_parcela label "Pa"
    field tit-vend       AS   int format "999999" label "NF"
    field cod-port       LIKE movto_tit_acr.cod_portador                   
    field modalidade     LIKE movto_tit_acr.cod_cart_bcia label "M"
    field dt-vencimen    LIKE movto_tit_acr.dat_vencto_tit_acr
    field dt-baixa       LIKE movto_tit_acr.dat_transacao
    field periodo        AS char format "9999/99"
    field vl-baixa       LIKE movto_tit_acr.val_movto_tit_acr
    FIELD obs            AS CHAR FORMAT "X(23)"
    index tt-baixas is primary cod_estab cod-esp cod_ser_docto cdn_repres nr-docto parcela dt-baixa.

def temp-table tt-baixa-geral
    FIELD cod_estab      LIKE tit_acr.cod_estab
    FIELD cdn_cliente    LIKE tit_acr.cdn_cliente 
    FIELD nom_cliente    LIKE emscad.cliente.nom_abrev
    FIELD cod_ser_docto  LIKE tit_acr.cod_ser_docto
    FIELD cdn_repres     LIKE tit_acr.cdn_repres
    FIELD nom_repres     LIKE representante.nom_abrev
    FIELD val_perc_comis LIKE repres_tit_acr.val_perc_comis_repres
    field cod-esp        LIKE tit_acr.cod_espec_docto
    field nr-docto       LIKE tit_acr.cod_tit_acr
    FIELD cod-docto      LIKE tit_acr.cod_tit_acr
    field parcela        LIKE tit_acr.cod_parcela label "Pa"
    field tit-vend       AS   int format "999999" label "NF"
    field cod-port       LIKE movto_tit_acr.cod_portador                   
    field modalidade     LIKE movto_tit_acr.cod_cart_bcia label "M"
    field dt-vencimen    LIKE movto_tit_acr.dat_vencto_tit_acr
    field dt-baixa       LIKE movto_tit_acr.dat_transacao
    field periodo        AS char format "9999/99"
    field vl-baixa       LIKE movto_tit_acr.val_movto_tit_acr
    FIELD obs            AS CHAR FORMAT "X(23)"
    index tt-baixas is primary cod_estab cod-esp cod_ser_docto nr-docto parcela dt-baixa.

def var i-tit          like tit_acr.num_id_tit_acr.
def var da-tit         like tit_acr.dat_vencto_tit_acr.
DEF VAR de-acrescimos  AS DEC.

DEF VAR d-fator        AS DEC.
DEF VAR d-data         AS DATE.

DEF BUFFER b_tit_acr        FOR tit_acr.
DEF BUFFER b_tit_acr2       FOR tit_acr.
DEF BUFFER b_movto_tit_acr  FOR movto_tit_acr.

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

/************** Fim de variaveis de selecao *******/

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOG    INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOG    NO-UNDO.
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

DEF VAR v_nom_enterprise        AS CHAR FORM "x(40)"  NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio de Pagamentos Efetuados".


DEF VAR c_cod_estab_ini         LIKE movto_tit_acr.cod_estab. 
DEF VAR c_cod_estab_fim         LIKE movto_tit_acr.cod_estab. 
DEF VAR i_cdn_cliente_ini       LIKE movto_tit_acr.cdn_cliente. 
DEF VAR i_cdn_cliente_fim       LIKE movto_tit_acr.cdn_cliente. 
DEF VAR d_dt_baixa_ini          LIKE movto_tit_acr.dat_liquidac_tit_acr.
DEF VAR d_dt_baixa_fim          LIKE movto_tit_acr.dat_liquidac_tit_acr.
DEF VAR c_cod_espec_docto_ini   LIKE movto_tit_acr.cod_espec_docto.
DEF VAR c_cod_espec_docto_fim   LIKE movto_tit_acr.cod_espec_docto.
DEF VAR c_cod_portador_ini      LIKE movto_tit_acr.cod_portador.
DEF VAR c_cod_portador_fim      LIKE movto_tit_acr.cod_portador.
DEF VAR i_cdn_repres_ini        LIKE tit_acr.cdn_repres.
DEF VAR i_cdn_repres_fim        LIKE tit_acr.cdn_repres.
DEF VAR i_tipo                  AS INT.

def frame f-cabec header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 52 format 'x(40)'
    'P gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.

def frame f-rodape header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec¡ficos Intelbr s - esacr017 - V:5.00.00.000' SKIP
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
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr017"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File        = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output      = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora          = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout              = Ped_Exec_Param.Cod_Dwb_Print_Layout
          i_cdn_cliente_ini     = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          i_cdn_cliente_fim     = INTEGER(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          d_dt_baixa_ini        = DATE(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))    
          d_dt_baixa_fim        = DATE(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c_cod_espec_docto_ini = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))         
          c_cod_espec_docto_fim = entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_portador_ini    = entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_portador_fim    = entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
          i_cdn_repres_ini      = INTEGER(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
          i_cdn_repres_fim      = INTEGER(entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          i_tipo                = INTEGER(entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c_cod_estab_ini       = entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_estab_fim       = entry(14,dwb_set_list_param.cod_dwb_parameters,chr(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr017"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File        = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output      = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora          = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout              = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           i_cdn_cliente_ini     = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           i_cdn_cliente_fim     = INTEGER(ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           d_dt_baixa_ini        = DATE(ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))    
           d_dt_baixa_fim        = DATE(ENTRY(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c_cod_espec_docto_ini = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))         
           c_cod_espec_docto_fim = entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_cod_portador_ini    = entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_cod_portador_fim    = entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           i_cdn_repres_ini      = INTEGER(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
           i_cdn_repres_fim      = INTEGER(entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           i_tipo                = INTEGER(entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c_cod_estab_ini       = entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c_cod_estab_fim       = entry(14,dwb_set_list_param.cod_dwb_parameters,chr(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr017.lst".
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
                                     
ASSIGN C-Programa          = "esacr017"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio de Pagamentos Efetuados"
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

IF i_tipo = 1 THEN
    RUN piMostra.
ELSE 
    RUN piMostraComiss.

IF i_tipo = 1 THEN
    RUN piImprimeRelat.  /* Imprime relat¢rio em formato padrÆo EMS 5 */ 
ELSE 
    RUN piImprimeRelatComiss.

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat.

   VIEW STREAM STREAM_1 FRAME f-cabec.
   VIEW STREAM STREAM_1 FRAME f-rodape.

   FOR EACH tt-baixa:
       FIND FIRST tt-baixa-geral
            WHERE tt-baixa-geral.cod_estab     = tt-baixa.cod_estab
              AND tt-baixa-geral.cdn_cliente   = tt-baixa.cdn_cliente
              AND tt-baixa-geral.cod-esp       = tt-baixa.cod-esp
              AND tt-baixa-geral.cod_ser_docto = tt-baixa.cod_ser_docto
              AND tt-baixa-geral.nr-docto      = tt-baixa.nr-docto 
              AND tt-baixa-geral.parcela       = tt-baixa.parcela 
              AND tt-baixa-geral.dt-baixa      = tt-baixa.dt-baixa no-error.
       IF NOT AVAIL tt-baixa-geral THEN DO:
          CREATE tt-baixa-geral.
          ASSIGN tt-baixa-geral.cod_estab        = tt-baixa.cod_estab
                 tt-baixa-geral.cdn_cliente      = tt-baixa.cdn_cliente     
                 tt-baixa-geral.nom_cliente      = tt-baixa.nom_cliente     
                 tt-baixa-geral.cod_ser_docto    = tt-baixa.cod_ser_docto   
                 tt-baixa-geral.cdn_repres       = tt-baixa.cdn_repres      
                 tt-baixa-geral.nom_repres       = tt-baixa.nom_repres      
                 tt-baixa-geral.val_perc_comis   = tt-baixa.val_perc_comis  
                 tt-baixa-geral.cod-esp          = tt-baixa.cod-esp         
                 tt-baixa-geral.nr-docto         = tt-baixa.nr-docto        
                 tt-baixa-geral.cod-docto        = tt-baixa.cod-docto       
                 tt-baixa-geral.parcela          = tt-baixa.parcela         
                 tt-baixa-geral.tit-vend         = tt-baixa.tit-vend        
                 tt-baixa-geral.cod-port         = tt-baixa.cod-port        
                 tt-baixa-geral.modalidade       = tt-baixa.modalidade      
                 tt-baixa-geral.dt-vencimen      = tt-baixa.dt-vencimen     
                 tt-baixa-geral.dt-baixa         = tt-baixa.dt-baixa        
                 tt-baixa-geral.periodo          = tt-baixa.periodo         
                 tt-baixa-geral.vl-baixa         = tt-baixa.vl-baixa
                 tt-baixa-geral.obs              = tt-baixa.obs.        
       END.
   END.

   FOR EACH tt-baixa-geral 
       BREAK BY tt-baixa-geral.cdn_cliente
             BY tt-baixa-geral.periodo
             BY tt-baixa-geral.dt-baixa:

       IF FIRST-OF(tt-baixa-geral.cdn_cliente) THEN DO:
           FIND FIRST emscad.cliente NO-LOCK
               WHERE cliente.cdn_cliente = tt-baixa-geral.cdn_cliente NO-ERROR.
           IF AVAIL cliente THEN
               DISP STREAM STREAM_1
                    "Cliente: "
                    cliente.cdn_cliente 
                    " - "
                    cliente.nom_abrev 
                    WITH NO-BOX NO-LABELS WIDTH 132 STREAM-IO FRAME f-cliente.      
       END.

        DISP STREAM STREAM_1 
             tt-baixa-geral.cod_estab     COLUMN-LABEL "Est"
             tt-baixa-geral.cod-esp
             tt-baixa-geral.cod_ser_docto COLUMN-LABEL "Ser"
             tt-baixa-geral.cod-docto
             tt-baixa-geral.parcela
             tt-baixa-geral.tit-ven 
             tt-baixa-geral.cod-port
             tt-baixa-geral.modalidade
             tt-baixa-geral.dt-vencimen
             tt-baixa-geral.dt-baixa
             tt-baixa-geral.dt-baixa - tt-baixa-geral.dt-vencimen LABEL "DD" FORMAT "->>>9"
             tt-baixa-geral.vl-baixa (TOTAL BY tt-baixa-geral.periodo)
             tt-baixa-geral.obs
             WITH NO-BOX WIDTH 132 DOWN STREAM-IO FRAME f-dados.
   END.

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */

PROCEDURE piImprimeRelatComiss.

   VIEW STREAM STREAM_1 FRAME f-cabec.
   VIEW STREAM STREAM_1 FRAME f-rodape.

   FOR EACH tt-baixa 
       BREAK BY tt-baixa.cdn_cliente
             BY tt-baixa.periodo
             BY tt-baixa.dt-baixa:

        DISP STREAM STREAM_1
             tt-baixa.cod_estab         COLUMN-LABEL "Est"
             tt-baixa.cod-esp           COLUMN-LABEL "Esp"
             tt-baixa.cod_ser_docto     COLUMN-LABEL "Ser"
             tt-baixa.cod-docto
             tt-baixa.parcela           COLUMN-LABEL "Pa"
             tt-baixa.tit-ven
             tt-baixa.cdn_cliente       COLUMN-LABEL "Cliente"
             tt-baixa.nom_cliente       COLUMN-LABEL "Nome Cliente"
             tt-baixa.cdn_repres        COLUMN-LABEL "Repres"
             tt-baixa.nom_repres        COLUMN-LABEL "Nome Repres"
             tt-baixa.val_perc_comis    COLUMN-LABEL "%Comis"
             tt-baixa.dt-vencimen
             tt-baixa.dt-baixa
             tt-baixa.dt-baixa - tt-baixa.dt-vencimen LABEL "DD" FORMAT "->>>9"
             tt-baixa.vl-baixa 
             WITH NO-BOX WIDTH 132 DOWN STREAM-IO FRAME f-dados.
        DOWN STREAM STREAM_1 WITH FRAME f-dados.
   END.                       

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */


PROCEDURE pi-grava-tt-baixa.

      FIND FIRST tt-baixa
           WHERE tt-baixa.cod_estab     = tit_acr.cod_estab
             AND tt-baixa.cdn_cliente   = tit_acr.cdn_cliente
             AND tt-baixa.cod-esp       = movto_tit_acr.cod_espec_docto
             AND tt-baixa.cod_ser_docto = tit_acr.cod_ser_docto
             AND tt-baixa.nr-docto      = tit_acr.cod_tit_acr 
             AND tt-baixa.parcela       = tit_acr.cod_parcela 
             AND tt-baixa.cdn_repres    = repres_tit_acr.cdn_repres
             AND tt-baixa.dt-baixa      = movto_tit_acr.dat_transacao no-error.
      IF NOT AVAIL tt-baixa then do:

         CREATE tt-baixa.
         ASSIGN tt-baixa.cod_estab     = tit_acr.cod_estab
                tt-baixa.cdn_cliente   = tit_acr.cdn_cliente
                tt-baixa.cod-esp       = movto_tit_acr.cod_espec_docto
                tt-baixa.cod_ser_docto = tit_acr.cod_ser_docto
                tt-baixa.nr-docto      = tit_acr.cod_tit_acr
                tt-baixa.cod-docto     = tit_acr.cod_tit_acr
                tt-baixa.cdn_repres    = repres_tit_acr.cdn_repres
                tt-baixa.tit-ven       = i-tit
                tt-baixa.parcela       = tit_acr.cod_parcela
                tt-baixa.dt-baixa      = movto_tit_acr.dat_transacao
                tt-baixa.periodo       = STRING(YEAR(movto_tit_acr.dat_transacao),"9999") + 
                                         STRING(MONTH(movto_tit_acr.dat_transacao),"99").
         
         FIND FIRST representante NO-LOCK
             WHERE representante.cdn_repres = repres_tit_acr.cdn_repres NO-ERROR.
         ASSIGN tt-baixa.nom_repres = IF AVAIL representante THEN representante.nom_abrev ELSE "".

         FIND FIRST emscad.cliente NO-LOCK 
             WHERE cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
         ASSIGN tt-baixa.nom_cliente = IF AVAIL cliente THEN cliente.nom_abrev ELSE "".

      END.
      
      ASSIGN tt-baixa.dt-vencimen    = da-tit
             tt-baixa.cod-port       = movto_tit_acr.cod_portador
             tt-baixa.modalidade     = movto_tit_acr.cod_cart_bcia
             tt-baixa.val_perc_comis = repres_tit_acr.val_perc_comis_repres
             tt-baixa.obs            = IF AVAIL b_movto_tit_acr THEN
                                          b_tit_acr.cod_espec_docto + "-" +
                                          b_tit_acr.cod_ser_docto + "-" +
                                          b_tit_acr.cod_tit_acr + "-" +
                                          b_tit_acr.cod_parcela
                                       ELSE
                                          movto_tit_acr.ind_trans_acr.

      ASSIGN de-acrescimos = (movto_tit_acr.val_abat_tit_acr         -
                              movto_tit_acr.val_desconto             +
                              movto_tit_acr.val_despes_bcia          +
                              movto_tit_acr.val_despes_financ        +
                              movto_tit_acr.val_juros                +
                              movto_tit_acr.val_multa_tit_acr). 

      IF tt-baixa.cod-esp = "VE" THEN DO:
          FIND FIRST parc_vendor NO-LOCK
              WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
          IF AVAIL parc_vendor THEN 
            ASSIGN tt-baixa.vl-baixa  = tt-baixa.vl-baixa + ((parc_vendor.val_parc_vendor_clien + de-acrescimos) * d-fator).
          ELSE
            ASSIGN tt-baixa.vl-baixa  = tt-baixa.vl-baixa + ((movto_tit_acr.val_movto_tit_acr + de-acrescimos) * d-fator).
      END.
      ELSE 
          ASSIGN tt-baixa.vl-baixa    = tt-baixa.vl-baixa + ((movto_tit_acr.val_movto_tit_acr + de-acrescimos) * d-fator).
          
END.

PROCEDURE piMostra.

   EMPTY TEMP-TABLE tt-baixa.

   FOR EACH estabelecimento NO-LOCK
       WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
         AND estabelecimento.cod_estab  >= c_cod_estab_ini
         AND estabelecimento.cod_estab  <= c_cod_estab_fim:

       DO d-data = d_dt_baixa_ini TO d_dt_baixa_fim:
           FOR EACH movto_tit_acr NO-LOCK
               WHERE movto_tit_acr.cod_estab        = estabelecimento.cod_estab
                 AND movto_tit_acr.dat_transacao    = d-data
                 AND movto_tit_acr.cdn_cliente     >= i_cdn_cliente_ini
                 AND movto_tit_acr.cdn_cliente     <= i_cdn_cliente_fim 
                 AND movto_tit_acr.cod_espec_docto >= c_cod_espec_docto_ini
                 AND movto_tit_acr.cod_espec_docto <= c_cod_espec_docto_fim
                 AND movto_tit_acr.cod_portador    >= c_cod_portador_ini
                 AND movto_tit_acr.cod_portador    <= c_cod_portador_fim
                 AND (movto_tit_acr.cod_espec_docto = "DP" 
                  OR  movto_tit_acr.cod_espec_docto = "dm"
                  OR  movto_tit_acr.cod_espec_docto = "ve"
                  OR  movto_tit_acr.cod_espec_docto = "vd")
                 AND movto_tit_acr.cod_motiv_movto_tit_acr = ""
                 AND movto_tit_acr.ind_trans_acr BEGINS "liq",
               FIRST tit_acr OF movto_tit_acr,
                EACH repres_tit_acr NO-LOCK
               WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
               AND   repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
               AND   repres_tit_acr.cdn_repres    >= i_cdn_repres_ini
               AND   repres_tit_acr.cdn_repres    <= i_cdn_repres_fim:
    
               ASSIGN i-tit   = 0
                      d-fator = 1. 
    
               FIND FIRST b_movto_tit_acr NO-LOCK
                    WHERE b_movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
                    AND   b_movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
     
               IF AVAIL b_movto_tit_acr THEN DO:
                    FIND FIRST b_tit_acr OF b_movto_tit_acr NO-LOCK NO-ERROR.
    
                    IF   b_tit_acr.ind_tip_espec_docto = 'Antecipa‡Æo' 
                    AND (b_tit_acr.ind_orig_tit_acr    = 'REC'        
                    OR   b_tit_acr.ind_orig_tit_acr    = 'ACR') THEN NEXT.
           
                    IF b_tit_acr.ind_orig_tit_acr = 'REC' 
                    OR b_tit_acr.cod_portador     = '' THEN NEXT.
    
               END.
    
               IF movto_tit_acr.cod_espec_docto = "DP" 
               OR movto_tit_acr.cod_espec_docto = "DM" THEN DO:
                  
                  FIND FIRST cart_bcia NO-LOCK
                      WHERE cart_bcia.cod_cart_bcia     = tit_acr.cod_cart_bcia
                      AND   cart_bcia.ind_tip_cart_bcia = "vendor" NO-ERROR.
                  IF AVAIL cart_bcia THEN NEXT.
                  
                  ASSIGN i-tit  = INT(tit_acr.cod_tit_acr)
                         da-tit =  tit_acr.dat_vencto_tit_acr.
                  RUN pi-grava-tt-baixa.
               END.
    
               IF movto_tit_acr.cod_espec_docto = "VE" THEN DO:
    
                  FIND FIRST b_tit_acr NO-LOCK
                       WHERE b_tit_acr.cod_estab          = movto_tit_acr.cod_estab
                         AND b_tit_acr.cod_espec_docto    = "VD"
                         AND b_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                         AND b_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                         AND b_tit_acr.cod_parcela        = tit_acr.cod_parcela NO-ERROR.
                  IF AVAIL b_tit_acr THEN NEXT.
    
                  FIND FIRST dupl_vendor NO-LOCK
                       WHERE dupl_vendor.cod_estab           = tit_acr.cod_estab
                         AND dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
                  IF AVAIL dupl_vendor THEN DO:
                      FIND FIRST b_tit_acr NO-LOCK
                           WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                             AND b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                      IF AVAIL b_tit_acr THEN  
                          ASSIGN i-tit  = INT(b_tit_acr.cod_tit_acr)
                                 da-tit = tit_acr.dat_vencto_tit_acr.  /* antes era b_tit_acr.dat_vencto_tit_acr */
                  END.
    
                  RUN pi-grava-tt-baixa.
               END.
    
               IF movto_tit_acr.cod_espec_docto = "VD" THEN DO:
    
                  FIND FIRST dupl_vendor NO-LOCK
                       WHERE dupl_vendor.cod_estab           = tit_acr.cod_estab
                         AND dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
                  IF AVAIL dupl_vendor THEN DO:
                      FIND FIRST b_tit_acr
                           WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                           AND   b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                      IF AVAIL b_tit_acr THEN
                          ASSIGN i-tit  = INT(b_tit_acr.cod_tit_acr)
                                 da-tit = b_tit_acr.dat_vencto_tit_acr.
                  END.
                  RUN pi-grava-tt-baixa.
    
               END.
           END.
       END.
   END.
END.


PROCEDURE piMostraComiss:

    EMPTY TEMP-TABLE tt-baixa.

   FOR EACH estabelecimento NO-LOCK
       WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
         AND estabelecimento.cod_estab  >= c_cod_estab_ini
         AND estabelecimento.cod_estab  <= c_cod_estab_fim:

        DO d-data = d_dt_baixa_ini TO d_dt_baixa_fim:
            FOR EACH movto_tit_acr NO-LOCK 
                   WHERE movto_tit_acr.cod_estab                 = estabelecimento.cod_estab
                   AND   movto_tit_acr.dat_transacao             = d-data
                   AND   movto_tit_acr.cdn_cliente              >= i_cdn_cliente_ini
                   AND   movto_tit_acr.cdn_cliente              <= i_cdn_cliente_fim
                   AND   movto_tit_acr.cod_espec_docto          >= c_cod_espec_docto_ini
                   AND   movto_tit_acr.cod_espec_docto          <= c_cod_espec_docto_fim
                   AND   movto_tit_acr.cod_portador             >= c_cod_portador_ini
                   AND   movto_tit_acr.cod_portador             <= c_cod_portador_fim
                   AND   movto_tit_acr.cod_motiv_movto_tit_acr   = ""
                   AND   movto_tit_acr.ind_trans_acr BEGINS "liq"
                   AND   NOT movto_tit_acr.log_movto_estordo, 
                   FIRST tit_acr OF movto_tit_acr NO-LOCK, 
                   FIRST INT_espec_docto_financ_acr NO-LOCK
                         WHERE INT_espec_docto_financ_acr.cod_espec_docto = tit_acr.cod_espec_docto 
                         AND   INT_espec_docto_financ_acr.LOG_gera_comissao,
                   EACH repres_tit_acr NO-LOCK
                        WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
                        AND   repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                        AND   repres_tit_acr.cdn_repres    >= i_cdn_repres_ini
                        AND   repres_tit_acr.cdn_repres    <= i_cdn_repres_fim:
    
                   IF movto_tit_acr.log_liquidac_contra_antecip THEN DO:
                      
                      FIND FIRST b_movto_tit_acr NO-LOCK
                           WHERE b_movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab_tit_acr
                           AND   b_movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
    
                      FIND FIRST b_tit_acr OF b_movto_tit_acr NO-LOCK NO-ERROR.
    
                      IF   b_tit_acr.ind_tip_espec_docto = 'Antecipa‡Æo' 
                      AND (b_tit_acr.ind_orig_tit_acr    = 'REC'        
                      OR   b_tit_acr.ind_orig_tit_acr    = 'ACR') THEN NEXT.
    
                      IF b_tit_acr.ind_orig_tit_acr = 'REC' 
                      OR b_tit_acr.cod_portador     = '' THEN NEXT.
                   END.
    
                   /************ testando ***********/
    
                   FIND FIRST b_movto_tit_acr NO-LOCK
                        WHERE b_movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
                        AND   b_movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                   IF AVAIL b_movto_tit_acr THEN DO:
    
                        FIND FIRST b_tit_acr OF b_movto_tit_acr NO-LOCK NO-ERROR.
    
                        IF   b_tit_acr.ind_tip_espec_docto = 'Antecipa‡Æo' 
                        AND (b_tit_acr.ind_orig_tit_acr    = 'REC'        
                        OR   b_tit_acr.ind_orig_tit_acr    = 'ACR') THEN NEXT.
    
                        IF b_tit_acr.ind_orig_tit_acr = 'REC' 
                        OR b_tit_acr.cod_portador     = '' THEN NEXT.
                   END.
    
                   /************ fim testando **********/
    
                   IF movto_tit_acr.cod_espec_docto = "DP" 
                   OR movto_tit_acr.cod_espec_docto = "DM" THEN DO:
                      FIND FIRST cart_bcia NO-LOCK
                          WHERE cart_bcia.cod_cart_bcia     = tit_acr.cod_cart_bcia
                          AND   cart_bcia.ind_tip_cart_bcia = "vendor" NO-ERROR.
                      IF AVAIL cart_bcia THEN NEXT.
                   END.
    
                   ASSIGN d-fator = 1
                          i-tit   = INT(tit_acr.cod_tit_acr)
                          da-tit  = tit_acr.dat_vencto_tit_acr.
    
                   CASE tit_acr.cod_espec_docto:
                       WHEN "VE" THEN DO:
    
                           FIND FIRST dupl_vendor NO-LOCK
                                WHERE dupl_vendor.cod_estab           = tit_acr.cod_estab
                                  AND dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
                           IF AVAIL dupl_vendor THEN DO:
                               FIND FIRST b_tit_acr
                                    WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                                    AND   b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                               IF AVAIL b_tit_acr THEN
                                   ASSIGN i-tit  = INT(b_tit_acr.cod_tit_acr)
                                          da-tit = tit_acr.dat_vencto_tit_acr. /* antes era b_tit_acr.dat_vencto_tit_acr */
                           END.
                           
                           /*FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
    
                           FIND FIRST b_tit_acr NO-LOCK
                                WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                  AND b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                           IF AVAIL b_tit_acr THEN 
                              ASSIGN d-fator = b_tit_acr.val_liq_tit_acr / b_tit_acr.val_origin_tit_acr.*/
                           
                           FIND FIRST parc_vendor NO-LOCK
                               WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                 AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
                           IF AVAIL parc_vendor THEN 
                               ASSIGN d-fator = parc_vendor.val_parc_vendor_orig / parc_vendor.val_parc_vendor_clien.
                               
                       END.
                       WHEN "VD" THEN DO:
                           FIND FIRST dupl_vendor NO-LOCK
                                WHERE dupl_vendor.cod_estab           = tit_acr.cod_estab
                                  AND dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
                           IF AVAIL dupl_vendor THEN DO:
                               FIND FIRST b_tit_acr
                                    WHERE b_tit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
                                    AND   b_tit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                               IF AVAIL b_tit_acr THEN
                                   ASSIGN i-tit  = INT(b_tit_acr.cod_tit_acr)
                                          da-tit = b_tit_acr.dat_vencto_tit_acr.
                           END.
    
                           FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
    
                           FIND FIRST b_tit_acr NO-LOCK
                                WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                  AND b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                           IF AVAIL b_tit_acr THEN DO:
                                FIND FIRST relacto_tit_acr OF b_tit_acr NO-LOCK NO-ERROR.
                                    FIND FIRST b_tit_acr2 NO-LOCK
                                         WHERE b_tit_acr2.cod_estab      = relacto_tit_acr.cod_estab
                                           AND b_tit_acr2.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                                    IF AVAIL b_tit_acr2 THEN
                                        ASSIGN d-fator = b_tit_acr2.val_liq_tit_acr / b_tit_acr2.val_origin_tit_acr.
                           END.
                       END.
                       OTHERWISE 
                           ASSIGN d-fator = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr.
                   END CASE.
    
                   RUN pi-grava-tt-baixa.
            END.    
        END.
   END.
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

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".
