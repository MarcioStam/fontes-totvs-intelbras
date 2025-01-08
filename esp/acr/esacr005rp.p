/*****************************************************************************
**     Programa.........: esp/acr/esacr005rp.p
**     Descricao .......: Relat¢rio Titulos Abertos por Portador
**     Versao...........: 1.00.000
**     Autor............: Joel Ricardo Geisler
**     Criado...........: 30/12/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
{esinc/es0000.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

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

DEF BUFFER b_movto_tit_acr FOR movto_tit_acr.

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec                             AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.

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
DEF VAR v_val_sdo_tit_acr       LIKE tit_acr.val_sdo_tit_acr NO-UNDO.
DEF VAR cDiretoria LIKE regiao.nome-regiao NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 255.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio D¡vidas Cliente".

DEF TEMP-TABLE tt_port
    FIELD nome-regiao       AS CHAR FORMAT "x(20)" LABEL "Diretoria"
    FIELD cod_portador      like emscad.portador.cod_portador
    FIELD cod_cart_bcia     like cart_bcia.cod_cart_bcia
    FIELD cod_grp_clien     like emscad.cliente.cod_grp_clien 
    FIELD cdn_repres        like representante.cdn_repres
    FIELD Ve-05             as dec format ">>,>>>,>>9.99"  
    FIELD Ve-06-30          as dec format ">,>>>,>>9.99"
    FIELD Ve-31-60          as dec format ">,>>>,>>9.99"
    FIELD Ve-61-90          as dec format ">,>>>,>>9.99"
    FIELD Ve-91-180         as dec format ">,>>>,>>9.99"
    FIELD Ve-180            as dec format ">,>>>,>>9.99"
    FIELD Tot-Venc          as dec format ">>,>>>,>>9.99"
    FIELD Av-30             as dec format ">>>>>>,>>9.99"
    FIELD Av-31-60          as dec format ">>,>>>,>>9.99"
    FIELD Av-61-90          as dec format ">>,>>>,>>9.99"
    FIELD Av-90             as dec format ">>,>>>,>>9.99"
    FIELD Tot-A-Venc        as dec format ">>,>>>,>>9.99"
    FIELD Total             as dec format ">>,>>>,>>9.99"
    INDEX portador is primary nome-regiao cod_portador cod_cart_bcia cod_grp_clien
    INDEX cod_cart_bcia  nome-regiao cod_cart_bcia cod_portador cod_grp_clien
    INDEX grupo-cli   nome-regiao cod_grp_clien cod_portador cod_cart_bcia
    INDEX repres      nome-regiao cdn_repres cod_portador cod_cart_bcia.

DEFINE VARIABLE c_cod_estab_ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod_estab_fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEF VAR diretoria_ini   AS CHAR FORMAT "x(40)".
DEF VAR diretoria_fin   AS CHAR FORMAT "x(40)".
DEF VAR gerente_ini     AS INT.
DEF VAR gerente_fin     AS INT.
DEF VAR l_total_dir     as LOG.
DEF VAR i_classifica    as INT.

DEFINE VARIABLE c_classifica        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCdn_repres1_ini    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres1_end    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres2_ini    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres2_end    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres3_ini    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres3_end    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres4_ini    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCdn_repres4_end    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cRepres_1           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRepres_2           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRepres_3           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRepres_4           AS CHARACTER    NO-UNDO.


def var t-ve-05         as dec format ">>,>>>,>>9.99".
def var t-ve-06-30      as dec format ">>,>>>,>>9.99".
def var t-ve-31-60      as dec format ">>,>>>,>>9.99".
def var t-ve-61-90      as dec format ">>,>>>,>>9.99".
def var t-ve-91-180     as dec format ">>,>>>,>>9.99".
def var t-ve-180        as dec format ">>,>>>,>>9.99".
def var t-av-30         as dec format ">>>>>,>>9.99".
def var t-av-31-60      as dec format ">>>>>,>>9.99".
def var t-av-61-90      as dec format ">>>>>,>>9.99".
def var t-av-90         as dec format ">>>>>,>>9.99".
def var t-tot-venc      as dec format ">>,>>>,>>9.99".
def var t-tot-a-venc    as dec format ">>,>>>,>>9.99".
def var t-total         as dec format ">>,>>>,>>9.99".
def var de-dias         as dec format ">>,>>>,>>9.99".
def var de-total        as dec format ">>,>>>,>>9.99".
def var diferenca       AS int.
def var perc-tot-venc   as dec format ">>9.99" LABEL "%".
def var perc-tot-a-venc as dec format ">>9.99" LABEL "%".
def var perc-ve06       as dec format ">>9.99" LABEL "%-ve06".
DEF VAR c-cod-grp-rep   AS CHAR FORMAT "x(7)".
DEF VAR c-des-grp-rep   AS CHAR FORMAT "x(40)".

def var tot-ve-05       as dec format ">>,>>>,>>9.99".
def var tot-ve-06-30    as dec format ">>,>>>,>>9.99".
def var tot-ve-31-60    as dec format ">>,>>>,>>9.99".
def var tot-ve-61-90    as dec format ">>,>>>,>>9.99".
def var tot-ve-91-180   as dec format ">>,>>>,>>9.99".
def var tot-ve-180      as dec format ">>,>>>,>>9.99".
def var tot-av-30       as dec format ">>>>>>,>>9.99".
def var tot-av-31-60    as dec format ">>>>>>,>>9.99".
def var tot-av-61-90    as dec format ">>>>>>,>>9.99".
def var tot-av-90       as dec format ">>>>>>,>>9.99".
def var tot-tot-venc    as dec format ">>,>>>,>>9.99".
def var tot-tot-a-venc  as dec format ">>,>>>,>>9.99".
def var tot-total       as dec format ">>,>>>,>>9.99".

def var tot-ve-05-dir       as dec format ">>,>>>,>>9.99".
def var tot-ve-06-30-dir    as dec format ">>,>>>,>>9.99".
def var tot-ve-31-60-dir    as dec format ">>,>>>,>>9.99".
def var tot-ve-61-90-dir    as dec format ">>,>>>,>>9.99".
def var tot-ve-91-180-dir   as dec format ">>,>>>,>>9.99".
def var tot-ve-180-dir      as dec format ">>,>>>,>>9.99".
def var tot-av-30-dir       as dec format ">>>>>>,>>9.99".
def var tot-av-31-60-dir    as dec format ">>>>>>,>>9.99".
def var tot-av-61-90-dir    as dec format ">>>>>>,>>9.99".
def var tot-av-90-dir       as dec format ">>>>>>,>>9.99".
def var tot-tot-venc-dir    as dec format ">>,>>>,>>9.99".
def var tot-tot-a-venc-dir  as dec format ">>,>>>,>>9.99".
def var tot-total-dir       as dec format ">>,>>>,>>9.99".

/*****  Defini‡Æo das Forms de ImpressÆo  ******/
{esp/acr/esacr005.i}

FIND FIRST emscad.empresa NO-LOCK 
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
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr005"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout.

   ASSIGN diretoria_ini    = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
          diretoria_fin    = entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
          gerente_ini      = INTEGER(entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          gerente_fin      = INTEGER(entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          l_total_dir      = (entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'YES')
          i_classifica     = INTEGER(entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c_classifica     = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres1_ini = INTEGER(entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres1_end = INTEGER(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_1        = entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres2_ini = INTEGER(entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres2_end = INTEGER(entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_2        = entry(14,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres3_ini = INTEGER(entry(15,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres3_end = INTEGER(entry(16,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_3        = entry(17,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres4_ini = INTEGER(entry(18,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres4_end = INTEGER(entry(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_4        = entry(20,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_estab_ini  = entry(21,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_estab_fim  = entry(22,dwb_set_list_param.cod_dwb_parameters,chr(10))
       NO-ERROR.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr005"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
   ASSIGN V_Cod_Dwb_File   = dwb_set_list_param.Cod_Dwb_File
          V_Cod_Dwb_Output = dwb_set_list_param.Cod_Dwb_Output
          C-Impressora     = dwb_set_list_param.Nom_Dwb_Printer
          C-Layout         = dwb_set_list_param.Cod_Dwb_Print_Layout.

   ASSIGN diretoria_ini    = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
          diretoria_fin    = entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
          gerente_ini      = INTEGER(entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          gerente_fin      = INTEGER(entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          l_total_dir      = (entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'YES')
          i_classifica     = INTEGER(entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c_classifica     = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres1_ini = INTEGER(entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres1_end = INTEGER(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_1        = entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres2_ini = INTEGER(entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres2_end = INTEGER(entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_2        = entry(14,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres3_ini = INTEGER(entry(15,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres3_end = INTEGER(entry(16,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_3        = entry(17,dwb_set_list_param.cod_dwb_parameters,chr(10))
          iCdn_repres4_ini = INTEGER(entry(18,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          iCdn_repres4_end = INTEGER(entry(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          cRepres_4        = entry(20,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_estab_ini  = entry(21,dwb_set_list_param.cod_dwb_parameters,chr(10))
          c_cod_estab_fim  = entry(22,dwb_set_list_param.cod_dwb_parameters,chr(10))
       NO-ERROR.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr005.lst".
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

ASSIGN C-Programa          = "ESACR005"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Relat¢rio Titulos Abertos por Portador - Classificado por " + c_classifica
       V_Rpt_Stream_1_Name = C-Titulo-Relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",255).

ASSIGN V_Num_Pag = 1.
RUN Pi_Grava_tt_Port.
RUN Pi_Imprime_Cabecalho (INPUT NO).
RUN Pi_Imprime_Relat.  
RUN Pi_Imprime_Rodape. 

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE Pi_Grava_Tt_Port.
    
    DEF VAR v_cod_arq AS CHAR.

    assign t-ve-05        = 0
           t-ve-06-30     = 0
           t-ve-31-60     = 0
           t-ve-61-90     = 0
           t-ve-91-180    = 0
           t-ve-180       = 0
           t-av-30        = 0
           t-av-31-60     = 0
           t-av-61-90     = 0
           t-av-90        = 0
           t-total        = 0
           t-tot-venc     = 0
           t-tot-a-venc   = 0.
    ASSIGN cDiretoria = "".

    /* ASSIGN v_cod_arq = session:temp-directory + "esacr005.txt". */
    ASSIGN v_cod_arq = c-dir-arquivo-session + "esacr005.txt".

    OUTPUT TO VALUE(v_cod_arq).

/*    FOR EACH  tit_acr USE-INDEX titacr_sdo_perdas NO-LOCK
        WHERE tit_acr.cod_estab                  = v_cod_estab_usuar
        AND   tit_acr.log_sdo_tit_acr            = YES
        AND   tit_acr.cdn_repres                >= gerente_ini 
        AND   tit_acr.cdn_repres                <= gerente_fin,
        FIRST representante NO-LOCK
        WHERE representante.cdn_repres           = tit_acr.cdn_repres
        /*
        AND   representante.cdn_repres          >= gerente_ini
        AND   representante.cdn_repres          <= gerente_fin
        */
        ,
        FIRST grp_repres NO-LOCK
        WHERE grp_repres.cod_grp_repres          = representante.cod_grp_repres
        AND   grp_repres.des_grp_repres         >= diretoria_ini
        AND   grp_repres.des_grp_repres         <= diretoria_fin: 
  */

    FOR each representante NO-LOCK
        WHERE representante.cod_empresa  = v_cod_empres_usuar
          AND representante.cdn_repres  >= gerente_ini
          AND representante.cdn_repres  <= gerente_fin,
        FIRST grp_repres NO-LOCK
              WHERE grp_repres.cod_grp_repres          = representante.cod_grp_repres
              AND   grp_repres.des_grp_repres         >= diretoria_ini
              AND   grp_repres.des_grp_repres         <= diretoria_fin,
        EACH estabelecimento NO-LOCK
             WHERE estabelecimento.cod_empres = v_cod_empres_usuar
               AND estabelecimento.cod_estab >= c_cod_estab_ini
               AND estabelecimento.cod_estab <= c_cod_estab_fim,
        EACH  tit_acr NO-LOCK
              WHERE tit_acr.cod_estab                  = estabelecimento.cod_estab
              AND   tit_acr.log_sdo_tit_acr            = YES
              AND   tit_acr.cdn_repres                 = representante.cdn_repres:

        IF tit_acr.ind_tip_espec_docto = "Antecipa‡Æo" THEN
            NEXT.

        if i_classifica = 1 or i_classifica = 2 then do:
           if l_total_dir then do:
              /*
              IF AVAIL regiao THEN
                   ASSIGN cDiretoria = if      regiao.nome-ab-reg begins "2" then "UN NEG - CENTRAIS" 
                                    else if regiao.nome-ab-reg begins "3" then "UN NEG - TERMINAIS"
                                    else if regiao.nome-ab-reg begins "7" then "EXPORTACAO"
                                    else regiao.nome-regiao no-error.
              ELSE ASSIGN cDiretoria = "S/REG P[" + representante.nom_abrev + "]".
              */
              RUN piTrataDiretoria.

              /* CHAVES
              IF  representante.cdn_repres >= 5000 THEN
                   ASSIGN cDiretoria = "EXPORTACAO".
              ELSE IF (representante.cod_grp_repres = '02' OR 
                       representante.cod_grp_repres = '03' OR 
                       representante.cod_grp_repres = '13' OR 
                       representante.cod_grp_repres = '14') THEN
                   ASSIGN cDiretoria = "TELEFONES".
              ELSE ASSIGN cDiretoria = "CENTRAIS".
              */
               
              find tt_port  
                   where tt_port.cod_portador   = tit_acr.cod_portador
                     and tt_port.cod_cart_bcia  = tit_acr.cod_cart_bcia
                     and tt_port.nome-regiao    = cDiretoria no-error.
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cod_portador  = tit_acr.cod_portador
                        tt_port.cod_cart_bcia = tit_acr.cod_cart_bcia
                        tt_port.nome-regiao   = cDiretoria.
              end.
           end.
           else do:
              find tt_port  
                   where tt_port.cod_portador  = tit_acr.cod_portador
                     and tt_port.cod_cart_bcia = tit_acr.cod_cart_bcia 
                     and tt_port.nome-regiao   = "" no-error.
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cod_portador  = tit_acr.cod_portador
                        tt_port.cod_cart_bcia = tit_acr.cod_cart_bcia
                        tt_port.nome-regiao = "".
              end.
           end.
        end.

        if i_classifica = 3 then do:
            
           FOR FIRST emscad.cliente field(cod_empresa cod_grp_clien)NO-LOCK
                WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                  AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente.
           END.

           if l_total_dir then do:
              /*
              IF AVAIL regiao THEN
                   ASSIGN cDiretoria = if      regiao.nome-ab-reg begins "2" then "UN NEG - CENTRAIS" 
                                    else if regiao.nome-ab-reg begins "3" then "UN NEG - TERMINAIS"
                                    else if regiao.nome-ab-reg begins "7" then "EXPORTACAO"
                                    else regiao.nome-regiao no-error.
              ELSE ASSIGN cDiretoria = "S/REG P[" + representante.nom_abrev + "]".
              */
              RUN piTrataDiretoria.

              find tt_port  
                   where tt_port.cod_grp_clien = emscad.cliente.cod_grp_clien 
                     and tt_port.nome-regiao   = cDiretoria no-error.
                     
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cod_grp_clien = emscad.cliente.cod_grp_clien
                        tt_port.nome-regiao   = cDiretoria.
              end.
           end.
           else do:
              find tt_port  
                   where tt_port.cod_grp_clien = emscad.cliente.cod_grp_clien no-error.
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cod_grp_clien = emscad.cliente.cod_grp_clien.
              end.
           end.
        end.

        if i_classifica = 4 then do:
           if l_total_dir then do:
              /*
              IF AVAIL regiao THEN
                   ASSIGN cDiretoria = if      regiao.nome-ab-reg begins "2" then "UN NEG - CENTRAIS" 
                                    else if regiao.nome-ab-reg begins "3" then "UN NEG - TERMINAIS"
                                    else if regiao.nome-ab-reg begins "7" then "EXPORTACAO"
                                    else regiao.nome-regiao no-error.
              ELSE ASSIGN cDiretoria = "S/REG P[" + representante.nom_abrev + "]".
              */

              RUN piTrataDiretoria.


              find tt_port  
                   where tt_port.cdn_repres  = tit_acr.cdn_repres
                     and tt_port.nome-regiao = cDiretoria no-error .
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cdn_repres  = tit_acr.cdn_repres
                        tt_port.nome-regiao = cDiretoria no-error .
              end.
           end.
           else do:
              find tt_port  
                   where tt_port.cdn_repres = tit_acr.cdn_repres no-error.
              if not avail tt_port then do:
                 create tt_port.
                 assign tt_port.cdn_repres = tit_acr.cdn_repres.
              end.
           end.
        end.
        
        if i_classifica = 5 then do:
           find tt_port  
                where tt_port.cod_portador  = tit_acr.cod_portador
                  and tt_port.cod_cart_bcia = tit_acr.cod_cart_bcia 
                  and tt_port.nome-regiao   = "" 
                  and tt_port.cdn_repres    = tit_acr.cdn_repres no-error.
           if not avail tt_port then do:
              create tt_port.
              assign tt_port.cod_portador   = tit_acr.cod_portador
                     tt_port.cod_cart_bcia  = tit_acr.cod_cart_bcia
                     tt_port.cdn_repres     = tit_acr.cdn_repres.
           end.
        end.

        /*- Inicio da rotina Alderico -  Essa rotina era do Magnus e dia 30/12/2004 foi passada para EMS */
        if tit_acr.cod_espec_docto      = "VD" and 
           tit_acr.dat_vencto_tit_acr   = tit_acr.dat_emis_docto then do:
            FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
                FIND FIRST movto_tit_acr NO-LOCK
                   where movto_tit_acr.cod_estab              = relacto_tit_acr.cod_estab
                     and movto_tit_acr.num_id_tit_acr         = relacto_tit_acr.num_id_tit_acr_pai
                     and movto_tit_acr.num_id_movto_tit_acr   = relacto_tit_acr.num_id_movto_tit_acr_pai NO-ERROR.
                IF AVAIL movto_tit_acr THEN
                  ASSIGN diferenca = (today - movto_tit_acr.dat_vencto_tit_acr).
        end.
        ELSE assign diferenca = (today - tit_acr.dat_vencto_tit_acr).
        
        PUT tit_acr.num_id_tit_acr " - " tit_acr.val_sdo_tit_acr " - " diferenca SKIP.

        IF tit_acr.cod_indic_econ <> "REAL" THEN DO:
            FIND cotac_parid no-lock 
                 WHERE cotac_parid.cod_indic_econ_base  = "Real"
                 AND   cotac_parid.cod_indic_econ_idx   = tit_acr.cod_indic_econ
                 AND   cotac_parid.dat_cotac_indic_econ = TODAY
                 AND   cotac_parid.ind_tip_cotac_parid  = "Real" NO-ERROR.
            IF AVAIL cotac_parid THEN
                 ASSIGN v_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr * TRUNCATE(cotac_parid.val_cotac_indic_econ,1).
            ELSE ASSIGN v_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr.
        END.
        ELSE ASSIGN v_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr.

               
        /*
        DISP tit_acr.cod_tit_acr
             tit_acr.cod_indic_econ
             tit_acr.val_sdo_tit_acr
             TRUNCATE(cotac_parid.val_cotac_indic_econ,1)
             tit_acr.val_sdo_tit_acr * TRUNCATE(cotac_parid.val_cotac_indic_econ,1).
        */
        /*-- Fim da Rotina --*/
        if diferenca < 6 and diferenca > 0 then 
            ASSIGN tt_port.ve-05 = tt_port.ve-05         + v_val_sdo_tit_acr. 
        if diferenca >= 6 and diferenca <= 30 then 
            ASSIGN tt_port.ve-06-30 = tt_port.ve-06-30   + v_val_sdo_tit_acr.
        if diferenca >= 31 and diferenca <= 60 then 
            ASSIGN tt_port.ve-31-60 = tt_port.ve-31-60   + v_val_sdo_tit_acr.
        if diferenca >= 61 and diferenca <= 90 then  
            ASSIGN tt_port.ve-61-90 = tt_port.ve-61-90   + v_val_sdo_tit_acr.
        if diferenca >= 91 and diferenca <= 180 then 
            ASSIGN tt_port.ve-91-180 = tt_port.ve-91-180 + v_val_sdo_tit_acr.
        if diferenca > 180 then 
            ASSIGN tt_port.ve-180 = tt_port.ve-180       + v_val_sdo_tit_acr.
        if diferenca <= 0 and diferenca >= -30 then 
            ASSIGN tt_port.av-30 = tt_port.av-30         + v_val_sdo_tit_acr.
        if diferenca < -30 and diferenca >= -60 then 
            assign tt_port.av-31-60 = tt_port.av-31-60   + v_val_sdo_tit_acr.
        if diferenca < -60 and diferenca >= -90 then 
            assign tt_port.av-61-90 = tt_port.av-61-90   + v_val_sdo_tit_acr.
        if diferenca < -90 then 
            assign tt_port.av-90 = tt_port.av-90         + v_val_sdo_tit_acr.

    END.

    OUTPUT CLOSE.

END PROCEDURE. /* End da PROCEDURE Pi_Grava_Port */

PROCEDURE Pi_Imprime_Relat:

    FOR EACH tt_port:
        ASSIGN tt_port.TOTAL      = tt_port.ve-05     + tt_port.ve-06-30 +
                                    tt_port.ve-31-60  + tt_port.ve-61-90 +
                                    tt_port.ve-91-180 + tt_port.ve-180 +
                                    tt_port.av-30     + tt_port.av-31-60 +
                                    tt_port.av-61-90  + tt_port.av-90
               tt_port.tot-venc   = tt_port.ve-05     + tt_port.ve-06-30 +
                                    tt_port.ve-31-60  + tt_port.ve-61-90 +
                                    tt_port.ve-91-180 + tt_port.ve-180
               tt_port.tot-a-venc = tt_port.av-30     + tt_port.av-31-60 +
                                    tt_port.av-61-90  + tt_port.av-90
                                    
               t-ve-05      = t-ve-05      + tt_port.ve-05
               t-ve-06-30   = t-ve-06-30   + tt_port.ve-06-30
               t-ve-31-60   = t-ve-31-60   + tt_port.ve-31-60
               t-ve-61-90   = t-ve-61-90   + tt_port.ve-61-90
               t-ve-91-180  = t-ve-91-180  + tt_port.ve-91-180
               t-ve-180     = t-ve-180     + tt_port.ve-180
               t-av-30      = t-av-30      + tt_port.av-30
               t-av-31-60   = t-av-31-60   + tt_port.av-31-60
               t-av-61-90   = t-av-61-90   + tt_port.av-61-90
               t-av-90      = t-av-90      + tt_port.av-90
               
               t-total      = t-total      + tt_port.total
               t-tot-venc   = t-tot-venc   + tt_port.tot-venc
               t-tot-a-venc = t-tot-a-venc + tt_port.tot-a-venc.
    END.

    if i_classifica = 1 then
       if l_total_dir then
          run pi-portador-super.
       else
          run pi-portador.
          
    if i_classifica = 2 then
       if l_total_dir then
          run pi-carteira-super.
       else
          run pi-carteira.
          
    if i_classifica = 3 then
       if l_total_dir then
          run pi-grupo-cli-super.
       else
          run pi-grupo-cli.

    if i_classifica = 4 then
       if l_total_dir then
          run pi-rep-super.
       else
          run pi-rep.

    if i_classifica = 5 then
       run pi-rep-por-mod.

END PROCEDURE.

procedure pi-portador-super.
   for each tt_port
       break by tt_port.nome-regiao  
             by tt_port.cod_portador 
             by tt_port.cod_cart_bcia
             by tt_port.cod_grp_clien:

       FIND FIRST emscad.portador NO-LOCK 
           WHERE emscad.portador.cod_portador  = tt_port.cod_portador NO-ERROR.

/*       FIND FIRST cart_bcia NO-LOCK
           WHERE cart_bcia.cod_cart_bcia = tt_port.cod_cart_bcia no-error.
  */
       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc * 100 / t-tot-venc.

       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       ASSIGN tot-ve-05-dir      = tot-ve-05-dir      + tt_port.ve-05     
              tot-ve-06-30-dir   = tot-ve-06-30-dir   + tt_port.ve-06-30  
              tot-ve-31-60-dir   = tot-ve-31-60-dir   + tt_port.ve-31-60  
              tot-ve-61-90-dir   = tot-ve-61-90-dir   + tt_port.ve-61-90  
              tot-ve-91-180-dir  = tot-ve-91-180-dir  + tt_port.ve-91-180 
              tot-ve-180-dir     = tot-ve-180-dir     + tt_port.ve-180    
              tot-tot-venc-dir   = tot-tot-venc-dir   + tt_port.tot-venc  
              tot-av-30-dir      = tot-av-30-dir      + tt_port.av-30     
              tot-av-31-60-dir   = tot-av-31-60-dir   + tt_port.av-31-60  
              tot-av-61-90-dir   = tot-av-61-90-dir   + tt_port.av-61-90  
              tot-av-90-dir      = tot-av-90-dir      + tt_port.av-90     
              tot-tot-a-venc-dir = tot-tot-a-venc-dir + tt_port.tot-a-venc
              tot-total-dir      = tot-total-dir      + tt_port.total.     

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       DISP STREAM Stream_1 
            tt_port.nome-regiao  
            tt_port.cod_portador 
            tt_port.cod_cart_bcia
            emscad.portador.nom_abrev      when avail portador 
            tt_port.ve-05           
            tt_port.ve-06-30        
            tt_port.ve-31-60        
            tt_port.ve-61-90        
            tt_port.ve-91-180       
            tt_port.ve-180          
            tt_port.tot-venc        
            perc-tot-venc
            tt_port.av-30           
            tt_port.av-31-60        
            tt_port.av-61-90        
            tt_port.av-90           
            tt_port.tot-a-venc      
            perc-tot-a-venc
            tt_port.total 
            WITH FRAME f-imprime DOWN.
        DOWN STREAM Stream_1 WITH FRAME f-imprime.

        IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
        END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

        IF LAST-OF(tt_port.cod_portador) THEN DO:
            /*
            PUT STREAM Stream_1 UNFORMATTED 
                FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
            DISP STREAM STREAM_1
                 tot-ve-05      
                 tot-ve-06-30   
                 tot-ve-31-60   
                 tot-ve-61-90   
                 tot-ve-91-180  
                 tot-ve-180     
                 tot-tot-venc   
                 tot-av-30      
                 tot-av-31-60   
                 tot-av-61-90   
                 tot-av-90      
                 tot-tot-a-venc 
                 tot-total      
                 WITH FRAME f-tot-impr DOWN. 
            PUT STREAM Stream_1 SKIP(1).

            ASSIGN tot-ve-05      = 0
                   tot-ve-06-30   = 0
                   tot-ve-31-60   = 0
                   tot-ve-61-90   = 0
                   tot-ve-91-180  = 0
                   tot-ve-180     = 0
                   tot-av-30      = 0
                   tot-av-31-60   = 0
                   tot-av-61-90   = 0
                   tot-av-90      = 0
                   tot-tot-venc   = 0
                   tot-tot-a-venc = 0
                   tot-total      = 0. 
        END.
        IF LAST-OF(tt_port.nome-regiao) THEN DO:

            IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
                ASSIGN V_Num_Pag = V_Num_Pag + 1.
                RUN Pi_Imprime_Cabecalho (INPUT YES).
            END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
            /*
            PUT STREAM Stream_1 UNFORMATTED 
                FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
            DISP STREAM STREAM_1
                 tot-ve-05-dir      
                 tot-ve-06-30-dir   
                 tot-ve-31-60-dir   
                 tot-ve-61-90-dir   
                 tot-ve-91-180-dir  
                 tot-ve-180-dir     
                 tot-tot-venc-dir   
                 tot-av-30-dir      
                 tot-av-31-60-dir   
                 tot-av-61-90-dir   
                 tot-av-90-dir      
                 tot-tot-a-venc-dir 
                 tot-total-dir      
                 WITH FRAME f-tot-dir DOWN. 
            PUT STREAM Stream_1 SKIP(1).

            ASSIGN tot-ve-05-dir      = 0
                   tot-ve-06-30-dir   = 0
                   tot-ve-31-60-dir   = 0
                   tot-ve-61-90-dir   = 0
                   tot-ve-91-180-dir  = 0
                   tot-ve-180-dir     = 0
                   tot-av-30-dir      = 0
                   tot-av-31-60-dir   = 0
                   tot-av-61-90-dir   = 0
                   tot-av-90-dir      = 0
                   tot-tot-venc-dir   = 0
                   tot-tot-a-venc-dir = 0
                   tot-total-dir      = 0. 
        END.
   end.
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05      
            t-ve-06-30   
            t-ve-31-60   
            t-ve-61-90   
            t-ve-91-180  
            t-ve-180     
            t-tot-venc   
            t-av-30      
            t-av-31-60   
            t-av-61-90   
            t-av-90      
            t-tot-a-venc 
            t-total      
            WITH FRAME f-total DOWN. 
   PUT STREAM Stream_1 SKIP(1).

   run pi-percentuais.
end.

procedure pi-portador.
   for each tt_port
       break by tt_port.nome-regiao
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia
             by tt_port.cod_grp_clien:

       find first emscad.portador no-lock
           where emscad.portador.cod_portador = tt_port.cod_portador NO-ERROR.

/*       FIND FIRST cart_bcia NO-LOCK
           WHERE cart_bcia.cod_cart_bcia = tt_port.cod_cart_bcia no-error.
  */
       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc * 100 / t-tot-venc.

       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       DISP STREAM Stream_1 
            tt_port.nome-regiao  
            tt_port.cod_portador 
            tt_port.cod_cart_bcia
            emscad.portador.nom_abrev      when avail portador 
            tt_port.ve-05           
            tt_port.ve-06-30        
            tt_port.ve-31-60        
            tt_port.ve-61-90        
            tt_port.ve-91-180       
            tt_port.ve-180          
            tt_port.tot-venc        
            perc-tot-venc
            tt_port.av-30           
            tt_port.av-31-60        
            tt_port.av-61-90        
            tt_port.av-90           
            tt_port.tot-a-venc      
            perc-tot-a-venc
            tt_port.total 
            WITH FRAME f-imprime DOWN.
        DOWN STREAM Stream_1 WITH FRAME f-imprime.

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       IF LAST-OF(tt_port.cod_portador) THEN DO:
           /*
           PUT STREAM Stream_1 UNFORMATTED 
               FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
           DISP STREAM STREAM_1
                tot-ve-05      
                tot-ve-06-30   
                tot-ve-31-60   
                tot-ve-61-90   
                tot-ve-91-180  
                tot-ve-180     
                tot-tot-venc   
                tot-av-30      
                tot-av-31-60   
                tot-av-61-90   
                tot-av-90      
                tot-tot-a-venc 
                tot-total      
                WITH FRAME f-tot-impr DOWN. 
           PUT STREAM Stream_1 SKIP(1).

           ASSIGN tot-ve-05      = 0
                  tot-ve-06-30   = 0
                  tot-ve-31-60   = 0
                  tot-ve-61-90   = 0
                  tot-ve-91-180  = 0
                  tot-ve-180     = 0
                  tot-av-30      = 0
                  tot-av-31-60   = 0
                  tot-av-61-90   = 0
                  tot-av-90      = 0
                  tot-tot-venc   = 0
                  tot-tot-a-venc = 0
                  tot-total      = 0. 
       END.
   END.
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05      
            t-ve-06-30   
            t-ve-31-60   
            t-ve-61-90   
            t-ve-91-180  
            t-ve-180     
            t-tot-venc   
            t-av-30      
            t-av-31-60   
            t-av-61-90   
            t-av-90      
            t-tot-a-venc 
            t-total      
            WITH FRAME f-total DOWN. 
   PUT STREAM Stream_1 SKIP(1).
   run pi-percentuais.
end.


procedure pi-carteira.
   for each tt_port
       break by tt_port.nome-regiao 
             by tt_port.cod_cart_bcia
             by tt_port.cod_portador:

       find emscad.portador NO-LOCK
            where emscad.portador.cod_portador = tt_port.cod_portador NO-ERROR.

/*       FIND cart_bcia NO-LOCK
           WHERE cart_bcia.cod_cart_bcia = tt_port.cod_cart_bcia no-error.
  */
       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc * 100 / t-tot-venc.

       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       DISP STREAM Stream_1
            tt_port.nome-regiao 
            tt_port.cod_portador 
            tt_port.cod_cart_bcia 
            portador.nom_abrev when avail portador
            tt_port.ve-05
            tt_port.ve-06-30  
            tt_port.ve-31-60  
            tt_port.ve-61-90  
            tt_port.ve-91-180  
            tt_port.ve-180  
            tt_port.tot-venc 
            perc-tot-venc
            tt_port.av-30  
            tt_port.av-31-60  
            tt_port.av-61-90  
            tt_port.av-90  
            tt_port.tot-a-venc 
            perc-tot-a-venc
            tt_port.total  
            WITH FRAME f-imprime DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-imprime.
       
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       IF LAST-OF(tt_port.cod_cart_bcia) THEN DO:
           /*
           PUT STREAM Stream_1 UNFORMATTED 
               FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/

           DISP STREAM STREAM_1
                tot-ve-05     
                tot-ve-06-30  
                tot-ve-31-60  
                tot-ve-61-90  
                tot-ve-91-180 
                tot-ve-180    
                tot-tot-venc  
                tot-av-30     
                tot-av-31-60  
                tot-av-61-90  
                tot-av-90     
                tot-tot-a-venc
                tot-total     
                WITH FRAME f-tot-impr DOWN. 
           PUT STREAM Stream_1 SKIP(1).

           ASSIGN tot-ve-05      = 0
                  tot-ve-06-30   = 0
                  tot-ve-31-60   = 0
                  tot-ve-61-90   = 0
                  tot-ve-91-180  = 0
                  tot-ve-180     = 0
                  tot-av-30      = 0
                  tot-av-31-60   = 0
                  tot-av-61-90   = 0
                  tot-av-90      = 0
                  tot-tot-venc   = 0
                  tot-tot-a-venc = 0
                  tot-total      = 0. 
       END.
   end.
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05      
            t-ve-06-30   
            t-ve-31-60   
            t-ve-61-90   
            t-ve-91-180  
            t-ve-180     
            t-tot-venc   
            t-av-30      
            t-av-31-60   
            t-av-61-90   
            t-av-90      
            t-tot-a-venc 
            t-total      
            WITH FRAME f-total DOWN. 
   PUT STREAM Stream_1 SKIP(1).
   run pi-percentuais.
end.

procedure pi-carteira-super.
   for each tt_port
       break by tt_port.nome-regiao 
             by tt_port.cod_cart_bcia
             by tt_port.cod_portador:

       find emscad.portador 
            where emscad.portador.cod_portador = tt_port.cod_portador NO-ERROR.

/*       FIND cart_bcia NO-LOCK
           WHERE cart_bcia.cod_cart_bcia = tt_port.cod_cart_bcia no-error.
  */
       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc.
                      
       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       ASSIGN tot-ve-05-dir      = tot-ve-05-dir      + tt_port.ve-05     
              tot-ve-06-30-dir   = tot-ve-06-30-dir   + tt_port.ve-06-30  
              tot-ve-31-60-dir   = tot-ve-31-60-dir   + tt_port.ve-31-60  
              tot-ve-61-90-dir   = tot-ve-61-90-dir   + tt_port.ve-61-90  
              tot-ve-91-180-dir  = tot-ve-91-180-dir  + tt_port.ve-91-180 
              tot-ve-180-dir     = tot-ve-180-dir     + tt_port.ve-180    
              tot-tot-venc-dir   = tot-tot-venc-dir   + tt_port.tot-venc  
              tot-av-30-dir      = tot-av-30-dir      + tt_port.av-30     
              tot-av-31-60-dir   = tot-av-31-60-dir   + tt_port.av-31-60  
              tot-av-61-90-dir   = tot-av-61-90-dir   + tt_port.av-61-90  
              tot-av-90-dir      = tot-av-90-dir      + tt_port.av-90     
              tot-tot-a-venc-dir = tot-tot-a-venc-dir + tt_port.tot-a-venc
              tot-total-dir      = tot-total-dir      + tt_port.total.     

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       DISP STREAM Stream_1
            tt_port.nome-regiao 
            tt_port.cod_portador 
            tt_port.cod_cart_bcia 
            portador.nom_abrev when avail portador
            tt_port.ve-05
            tt_port.ve-06-30  
            tt_port.ve-31-60  
            tt_port.ve-61-90  
            tt_port.ve-91-180  
            tt_port.ve-180  
            tt_port.tot-venc 
            perc-tot-venc
            tt_port.av-30  
            tt_port.av-31-60  
            tt_port.av-61-90  
            tt_port.av-90  
            tt_port.tot-a-venc 
            perc-tot-a-venc
            tt_port.total  
            WITH FRAME f-imprime DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-imprime.
       
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
       IF LAST-OF(tt_port.cod_cart_bcia) THEN DO:
           /*
           PUT STREAM Stream_1 UNFORMATTED 
               FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
           DISP STREAM STREAM_1
                tot-ve-05     
                tot-ve-06-30  
                tot-ve-31-60  
                tot-ve-61-90  
                tot-ve-91-180 
                tot-ve-180    
                tot-tot-venc  
                tot-av-30     
                tot-av-31-60  
                tot-av-61-90  
                tot-av-90     
                tot-tot-a-venc
                tot-total     
                WITH FRAME f-tot-impr DOWN. 
           PUT STREAM Stream_1 SKIP(1).

           ASSIGN tot-ve-05      = 0
                  tot-ve-06-30   = 0
                  tot-ve-31-60   = 0
                  tot-ve-61-90   = 0
                  tot-ve-91-180  = 0
                  tot-ve-180     = 0
                  tot-av-30      = 0
                  tot-av-31-60   = 0
                  tot-av-61-90   = 0
                  tot-av-90      = 0
                  tot-tot-venc   = 0
                  tot-tot-a-venc = 0
                  tot-total      = 0. 
       END.
       IF LAST-OF(tt_port.nome-regiao) THEN DO:
            IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
                ASSIGN V_Num_Pag = V_Num_Pag + 1.
                RUN Pi_Imprime_Cabecalho (INPUT YES).
            END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
            /*PUT STREAM Stream_1 UNFORMATTED 
                FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
            DISP STREAM STREAM_1
                 tot-ve-05-dir      
                 tot-ve-06-30-dir   
                 tot-ve-31-60-dir   
                 tot-ve-61-90-dir   
                 tot-ve-91-180-dir  
                 tot-ve-180-dir     
                 tot-tot-venc-dir   
                 tot-av-30-dir      
                 tot-av-31-60-dir   
                 tot-av-61-90-dir   
                 tot-av-90-dir      
                 tot-tot-a-venc-dir 
                 tot-total-dir      
                 WITH FRAME f-tot-dir DOWN. 
            PUT STREAM Stream_1 SKIP(1).

            ASSIGN tot-ve-05-dir      = 0
                   tot-ve-06-30-dir   = 0
                   tot-ve-31-60-dir   = 0
                   tot-ve-61-90-dir   = 0
                   tot-ve-91-180-dir  = 0
                   tot-ve-180-dir     = 0
                   tot-av-30-dir      = 0
                   tot-av-31-60-dir   = 0
                   tot-av-61-90-dir   = 0
                   tot-av-90-dir      = 0
                   tot-tot-venc-dir   = 0
                   tot-tot-a-venc-dir = 0
                   tot-total-dir      = 0. 
        END.
   end.
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05      
            t-ve-06-30   
            t-ve-31-60   
            t-ve-61-90   
            t-ve-91-180  
            t-ve-180     
            t-tot-venc   
            t-av-30      
            t-av-31-60   
            t-av-61-90   
            t-av-90      
            t-tot-a-venc 
            t-total      
            WITH FRAME f-total DOWN. 
   PUT STREAM Stream_1 SKIP(1).
   run pi-percentuais.
end.

procedure pi-grupo-cli.
   for each tt_port,
       first grp_clien no-lock
             where grp_clien.cod_grp_clien = tt_port.cod_grp_clien
       break by tt_port.nome-regiao 
             by tt_port.cod_grp_clien
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia:

       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc
              perc-ve06        = (tt_port.tot-venc - tt_port.ve-05) * 100 / (t-tot-venc - t-ve-05)
              c-des-grp-rep    = IF AVAIL grp_clien THEN grp_clien.des_grp_clien ELSE ""
              c-cod-grp-rep    = tt_port.cod_grp_clien.  

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */               
       DISP STREAM stream_1
            tt_port.nome-regiao     
            c-cod-grp-rep   
            c-des-grp-rep
            tt_port.Ve-05           
            tt_port.Ve-06-30        
            tt_port.Ve-31-60        
            tt_port.Ve-61-90        
            tt_port.Ve-91-180       
            tt_port.Ve-180          
            tt_port.Tot-Venc        
            perc-tot-venc           
            perc-ve06               
            tt_port.Av-30           
            tt_port.Av-31-60        
            tt_port.Av-61-90        
            tt_port.Av-90           
            tt_port.Tot-A-Venc      
            perc-tot-a-venc         
            tt_port.Total           
            WITH FRAME f-impr-grp-rep DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-impr-grp-rep.
   end.
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05         
            t-ve-06-30      
            t-ve-31-60      
            t-ve-61-90      
            t-ve-91-180     
            t-ve-180        
            t-tot-venc      
            t-av-30         
            t-av-31-60      
            t-av-61-90      
            t-av-90         
            t-tot-a-venc    
            t-total         
            WITH FRAME f-tot-grp-rep DOWN. 
   PUT STREAM Stream_1 SKIP.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   DISP STREAM STREAM_1
       " Percentuais em Relacao ao TOTAL GERAL " 
       (t-ve-05 * 100)      / t-total format ">>9.99%" TO 64 
       (t-ve-06-30 * 100)   / t-total format ">>9.99%" TO 78 
       (t-ve-31-60 * 100)   / t-total format ">>9.99%" TO 91 
       (t-ve-61-90 * 100)   / t-total format ">>9.99%" TO 104 
       (t-ve-91-180 * 100)  / t-total format ">>9.99%" TO 117
       (t-ve-180 * 100)     / t-total format ">>9.99%" TO 130
       (t-tot-venc * 100)   / t-total format ">>9.99%" TO 144
       (t-av-30 * 100)      / t-total format ">>9.99%" TO 173
       (t-av-31-60 * 100)   / t-total format ">>9.99%" TO 186
       (t-av-61-90 * 100)   / t-total format ">>9.99%" TO 199
       (t-av-90 * 100)      / t-total format ">>9.99%" TO 213
       (t-tot-a-venc * 100) / t-total format ">>9.99%" TO 227
        SKIP(1)                                           
       with width 255.                                    

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180.
   PUT STREAM STREAM_1         
       " Inadimplencia de 06 a 180 dias R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).
        
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180 + t-ve-180.
   put STREAM STREAM_1          
       " Inadimplencia acima de 5 dias  R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).
END.

procedure pi-grupo-cli-super.
   assign de-dias = 0
          de-total = 0.
          
   for each tt_port,
       first grp_clien no-lock
             where grp_clien.cod_grp_clien = tt_port.cod_grp_clien
       break by tt_port.nome-regiao 
             by tt_port.cod_grp_clien
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia:

       ASSIGN tot-ve-05-dir      = tot-ve-05-dir      + tt_port.ve-05     
              tot-ve-06-30-dir   = tot-ve-06-30-dir   + tt_port.ve-06-30  
              tot-ve-31-60-dir   = tot-ve-31-60-dir   + tt_port.ve-31-60  
              tot-ve-61-90-dir   = tot-ve-61-90-dir   + tt_port.ve-61-90  
              tot-ve-91-180-dir  = tot-ve-91-180-dir  + tt_port.ve-91-180 
              tot-ve-180-dir     = tot-ve-180-dir     + tt_port.ve-180    
              tot-tot-venc-dir   = tot-tot-venc-dir   + tt_port.tot-venc  
              tot-av-30-dir      = tot-av-30-dir      + tt_port.av-30     
              tot-av-31-60-dir   = tot-av-31-60-dir   + tt_port.av-31-60  
              tot-av-61-90-dir   = tot-av-61-90-dir   + tt_port.av-61-90  
              tot-av-90-dir      = tot-av-90-dir      + tt_port.av-90     
              tot-tot-a-venc-dir = tot-tot-a-venc-dir + tt_port.tot-a-venc
              tot-total-dir      = tot-total-dir      + tt_port.total.
            
       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc
              perc-ve06        = (tt_port.tot-venc - tt_port.ve-05) * 100 / (t-tot-venc - t-ve-05)
              c-des-grp-rep    = IF AVAIL grp_clien THEN grp_clien.des_grp_clien ELSE ""
              c-cod-grp-rep    = tt_port.cod_grp_clien.  
        
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */                       

       DISP STREAM stream_1
            tt_port.nome-regiao     
            c-cod-grp-rep   
            c-des-grp-rep
            tt_port.Ve-05           
            tt_port.Ve-06-30        
            tt_port.Ve-31-60        
            tt_port.Ve-61-90        
            tt_port.Ve-91-180       
            tt_port.Ve-180          
            tt_port.Tot-Venc        
            perc-tot-venc           
            perc-ve06               
            tt_port.Av-30           
            tt_port.Av-31-60        
            tt_port.Av-61-90        
            tt_port.Av-90           
            tt_port.Tot-A-Venc      
            perc-tot-a-venc         
            tt_port.Total           
            WITH FRAME f-impr-grp-rep DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-impr-grp-rep.

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       if LAST-OF(tt_port.nome-regiao) then do:
          /*PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
          DISP STREAM STREAM_1
               tot-ve-05-dir      
               tot-ve-06-30-dir   
               tot-ve-31-60-dir   
               tot-ve-61-90-dir   
               tot-ve-91-180-dir  
               tot-ve-180-dir     
               tot-tot-venc-dir   
               tot-av-30-dir      
               tot-av-31-60-dir   
               tot-av-61-90-dir   
               tot-av-90-dir      
               tot-tot-a-venc-dir 
               tot-total-dir      
               WITH FRAME f-tot-grp-rep-dir DOWN. 
          PUT STREAM Stream_1 SKIP.

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          DISP STREAM STREAM_1
              "  Percentuais em Relacao ao TOTAL DA DIRETORIA "
              (tot-ve-05-dir      * 100) / tot-total-dir format ">>9.99%" TO 64
              (tot-ve-06-30-dir   * 100) / tot-total-dir format ">>9.99%" TO 78
              (tot-ve-31-60-dir   * 100) / tot-total-dir format ">>9.99%" TO 91
              (tot-ve-61-90-dir   * 100) / tot-total-dir format ">>9.99%" TO 104
              (tot-ve-91-180-dir  * 100) / tot-total-dir format ">>9.99%" TO 117
              (tot-ve-180-dir     * 100) / tot-total-dir format ">>9.99%" TO 130
              (tot-tot-venc-dir   * 100) / tot-total-dir format ">>9.99%" TO 144
              (tot-av-30-dir      * 100) / tot-total-dir format ">>9.99%" TO 173
              (tot-av-31-60-dir   * 100) / tot-total-dir format ">>9.99%" TO 186
              (tot-av-61-90-dir   * 100) / tot-total-dir format ">>9.99%" TO 199
              (tot-av-90-dir      * 100) / tot-total-dir format ">>9.99%" TO 213
              (tot-tot-a-venc-dir * 100) / tot-total-dir format ">>9.99%" TO 227 SKIP(1)
              with width 255.

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
          
          ASSIGN de-dias = tot-ve-06-30-dir + tot-ve-31-60-dir + tot-ve-61-90-dir + tot-ve-91-180-dir.
          PUT STREAM STREAM_1
              "  Inadimplencia de 06 a 180 dias R$ " de-dias 
              "  Percentual: " (de-dias * 100) / tot-total-dir format ">>9.99%" skip(1).

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          assign de-dias = de-dias + tot-ve-180-dir.
          PUT STREAM STREAM_1
              "  Inadimplencia acima de  5 dias R$ " de-dias 
              "  Percentual: " (de-dias * 100) / tot-total-dir format ">>9.99%" skip.
          PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP(1).

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          ASSIGN tot-ve-05-dir      = 0
                 tot-ve-06-30-dir   = 0
                 tot-ve-31-60-dir   = 0
                 tot-ve-61-90-dir   = 0
                 tot-ve-91-180-dir  = 0
                 tot-ve-180-dir     = 0
                 tot-av-30-dir      = 0
                 tot-av-31-60-dir   = 0
                 tot-av-61-90-dir   = 0
                 tot-av-90-dir      = 0
                 tot-tot-venc-dir   = 0
                 tot-tot-a-venc-dir = 0
                 tot-total-dir      = 0. 
       end. 
   end.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   DISP STREAM STREAM_1
            t-ve-05         
            t-ve-06-30      
            t-ve-31-60      
            t-ve-61-90      
            t-ve-91-180     
            t-ve-180        
            t-tot-venc      
            t-av-30         
            t-av-31-60      
            t-av-61-90      
            t-av-90         
            t-tot-a-venc    
            t-total         
            WITH FRAME f-tot-grp-rep DOWN. 
   PUT STREAM Stream_1 SKIP.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   DISP STREAM STREAM_1
        "  Percentuais em Relacao ao TOTAL GERAL " 
        (t-ve-05      * 100) / t-total format ">>9.99%" TO 64 
        (t-ve-06-30   * 100) / t-total format ">>9.99%" TO 78 
        (t-ve-31-60   * 100) / t-total format ">>9.99%" TO 91 
        (t-ve-61-90   * 100) / t-total format ">>9.99%" TO 104
        (t-ve-91-180  * 100) / t-total format ">>9.99%" TO 117
        (t-ve-180     * 100) / t-total format ">>9.99%" TO 130
        (t-tot-venc   * 100) / t-total format ">>9.99%" TO 144
        (t-av-30      * 100) / t-total format ">>9.99%" TO 173
        (t-av-31-60   * 100) / t-total format ">>9.99%" TO 186
        (t-av-61-90   * 100) / t-total format ">>9.99%" TO 199
        (t-av-90      * 100) / t-total format ">>9.99%" TO 213
        (t-tot-a-venc * 100) / t-total format ">>9.99%" TO 227
       SKIP(1)
       with width 255.                

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180.
   PUT STREAM STREAM_1
        "  Inadimplencia de 06 a 180 dias R$ " de-dias 
        "  Percentual: " (de-dias * 100) / t-total format ">>9.99%"
        skip(1).

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180 + t-ve-180.
   PUT STREAM STREAM_1
        "  Inadimplencia acima de  5 dias R$ " de-dias 
        "  Percentual: " (de-dias * 100) / t-total format ">>9.99%"
        skip(1).

end.

procedure pi-rep.

   for each tt_port,
       first representante no-lock
       where representante.cod_empresa = v_cod_empres_usuar
         and representante.cdn_repres  = tt_port.cdn_repres
       break by tt_port.nome-regiao 
             by tt_port.cdn_repres
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia:

       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc
              perc-ve06        = (tt_port.tot-venc - tt_port.ve-05) * 100 / (t-tot-venc - t-ve-05)
              c-des-grp-rep    = IF AVAIL representante THEN representante.nom_abrev ELSE "".
              c-cod-grp-rep    = string(tt_port.cdn_repres).  
                      
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */ 
        
       DISP STREAM stream_1
            tt_port.nome-regiao     
            c-cod-grp-rep   
            c-des-grp-rep 
            tt_port.Ve-05           
            tt_port.Ve-06-30        
            tt_port.Ve-31-60        
            tt_port.Ve-61-90        
            tt_port.Ve-91-180       
            tt_port.Ve-180          
            tt_port.Tot-Venc        
            perc-tot-venc           
            perc-ve06               
            tt_port.Av-30           
            tt_port.Av-31-60        
            tt_port.Av-61-90        
            tt_port.Av-90           
            tt_port.Tot-A-Venc      
            perc-tot-a-venc         
            tt_port.Total           
            WITH FRAME f-impr-grp-rep DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-impr-grp-rep.

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   END.
   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05         
            t-ve-06-30      
            t-ve-31-60      
            t-ve-61-90      
            t-ve-91-180     
            t-ve-180        
            t-tot-venc      
            t-av-30         
            t-av-31-60      
            t-av-61-90      
            t-av-90         
            t-tot-a-venc    
            t-total         
            WITH FRAME f-tot-grp-rep DOWN. 
   PUT STREAM Stream_1 SKIP.
   
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   DISP STREAM STREAM_1
        " Percentuais em Relacao ao TOTAL GERAL " 
        (t-ve-05 * 100)      / t-total format ">>9.99%" TO 64 
        (t-ve-06-30 * 100)   / t-total format ">>9.99%" TO 78 
        (t-ve-31-60 * 100)   / t-total format ">>9.99%" TO 91 
        (t-ve-61-90 * 100)   / t-total format ">>9.99%" TO 104 
        (t-ve-91-180 * 100)  / t-total format ">>9.99%" TO 117
        (t-ve-180 * 100)     / t-total format ">>9.99%" TO 130
        (t-tot-venc * 100)   / t-total format ">>9.99%" TO 144
        (t-av-30 * 100)      / t-total format ">>9.99%" TO 173
        (t-av-31-60 * 100)   / t-total format ">>9.99%" TO 186
        (t-av-61-90 * 100)   / t-total format ">>9.99%" TO 199
        (t-av-90 * 100)      / t-total format ">>9.99%" TO 213
        (t-tot-a-venc * 100) / t-total format ">>9.99%" TO 227
         SKIP(1)                                           
        with width 255.                                    

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180.
   PUT STREAM STREAM_1         
       " Inadimplencia de 06 a 180 dias R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).
        
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180 + t-ve-180.
   put STREAM STREAM_1          
       " Inadimplencia acima de 5 dias  R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).

end.

procedure pi-rep-super.
   assign de-dias = 0
          de-total = 0.
          
   for each tt_port,
       first representante no-lock
       where representante.cod_empresa = v_cod_empres_usuar
         and representante.cdn_repres  = tt_port.cdn_repres
       break by tt_port.nome-regiao 
             by tt_port.cdn_repres
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia:

       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc
              perc-ve06        = (tt_port.tot-venc - tt_port.ve-05) * 100 / (t-tot-venc - t-ve-05)
              c-des-grp-rep    = IF AVAIL representante THEN representante.nom_abrev ELSE "".
              c-cod-grp-rep    = string(tt_port.cdn_repres).  

       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       ASSIGN tot-ve-05-dir      = tot-ve-05-dir      + tt_port.ve-05     
              tot-ve-06-30-dir   = tot-ve-06-30-dir   + tt_port.ve-06-30  
              tot-ve-31-60-dir   = tot-ve-31-60-dir   + tt_port.ve-31-60  
              tot-ve-61-90-dir   = tot-ve-61-90-dir   + tt_port.ve-61-90  
              tot-ve-91-180-dir  = tot-ve-91-180-dir  + tt_port.ve-91-180 
              tot-ve-180-dir     = tot-ve-180-dir     + tt_port.ve-180    
              tot-tot-venc-dir   = tot-tot-venc-dir   + tt_port.tot-venc  
              tot-av-30-dir      = tot-av-30-dir      + tt_port.av-30     
              tot-av-31-60-dir   = tot-av-31-60-dir   + tt_port.av-31-60  
              tot-av-61-90-dir   = tot-av-61-90-dir   + tt_port.av-61-90  
              tot-av-90-dir      = tot-av-90-dir      + tt_port.av-90     
              tot-tot-a-venc-dir = tot-tot-a-venc-dir + tt_port.tot-a-venc
              tot-total-dir      = tot-total-dir      + tt_port.total.      
                      
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       DISP STREAM stream_1
            tt_port.nome-regiao     
            c-cod-grp-rep   
            c-des-grp-rep 
            tt_port.Ve-05           
            tt_port.Ve-06-30        
            tt_port.Ve-31-60        
            tt_port.Ve-61-90        
            tt_port.Ve-91-180       
            tt_port.Ve-180          
            tt_port.Tot-Venc        
            perc-tot-venc           
            perc-ve06               
            tt_port.Av-30           
            tt_port.Av-31-60        
            tt_port.Av-61-90        
            tt_port.Av-90           
            tt_port.Tot-A-Venc      
            perc-tot-a-venc         
            tt_port.Total           
            WITH FRAME f-impr-grp-rep DOWN.
       DOWN STREAM Stream_1 WITH FRAME f-impr-grp-rep.

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       if last-of(tt_port.cdn_repres) then do:
          /*
          PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
          DISP STREAM STREAM_1
               tot-ve-05      
               tot-ve-06-30   
               tot-ve-31-60   
               tot-ve-61-90   
               tot-ve-91-180  
               tot-ve-180     
               tot-tot-venc   
               tot-av-30      
               tot-av-31-60   
               tot-av-61-90   
               tot-av-90      
               tot-tot-a-venc 
               tot-total      
               WITH FRAME f-tot-grp-rep-impr DOWN. 
          PUT STREAM Stream_1 SKIP.
          
          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
             ASSIGN V_Num_Pag = V_Num_Pag + 1.
             RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          DISP STREAM STREAM_1
              " Percentuais em Relacao ao TOTAL DO GERENTE "
              (tot-ve-05      * 100) / tot-total format ">>9.99%" TO 64
              (tot-ve-06-30   * 100) / tot-total format ">>9.99%" TO 78
              (tot-ve-31-60   * 100) / tot-total format ">>9.99%" TO 91
              (tot-ve-61-90   * 100) / tot-total format ">>9.99%" TO 104
              (tot-ve-91-180  * 100) / tot-total format ">>9.99%" TO 117
              (tot-ve-180     * 100) / tot-total format ">>9.99%" TO 130
              (tot-tot-venc   * 100) / tot-total format ">>9.99%" TO 144
              (tot-av-30      * 100) / tot-total format ">>9.99%" TO 173
              (tot-av-31-60   * 100) / tot-total format ">>9.99%" TO 186
              (tot-av-61-90   * 100) / tot-total format ">>9.99%" TO 199
              (tot-av-90      * 100) / tot-total format ">>9.99%" TO 213
              (tot-tot-a-venc * 100) / tot-total format ">>9.99%" TO 227 SKIP(1)
              WITH WIDTH 255.

          ASSIGN tot-ve-05      = 0
                 tot-ve-06-30   = 0
                 tot-ve-31-60   = 0
                 tot-ve-61-90   = 0
                 tot-ve-91-180  = 0
                 tot-ve-180     = 0
                 tot-av-30      = 0
                 tot-av-31-60   = 0
                 tot-av-61-90   = 0
                 tot-av-90      = 0
                 tot-tot-venc   = 0
                 tot-tot-a-venc = 0
                 tot-total      = 0. 
       end.

       IF LAST-OF(tt_port.nome-regiao) then do:

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
          
          /*
          PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
          DISP STREAM STREAM_1
               tot-ve-05-dir      
               tot-ve-06-30-dir   
               tot-ve-31-60-dir   
               tot-ve-61-90-dir   
               tot-ve-91-180-dir  
               tot-ve-180-dir     
               tot-tot-venc-dir   
               tot-av-30-dir      
               tot-av-31-60-dir   
               tot-av-61-90-dir   
               tot-av-90-dir      
               tot-tot-a-venc-dir 
               tot-total-dir      
               WITH FRAME f-tot-grp-rep-dir DOWN. 
          
          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          PUT STREAM Stream_1 SKIP(1)
              " Percentuais em Relacao ao TOTAL DO DIRETORIA "
              (tot-ve-05-dir      * 100) / tot-total-dir format ">>9.99%" TO 61
              (tot-ve-06-30-dir   * 100) / tot-total-dir format ">>9.99%" TO 75
              (tot-ve-31-60-dir   * 100) / tot-total-dir format ">>9.99%" TO 88
              (tot-ve-61-90-dir   * 100) / tot-total-dir format ">>9.99%" TO 101
              (tot-ve-91-180-dir  * 100) / tot-total-dir format ">>9.99%" TO 114
              (tot-ve-180-dir     * 100) / tot-total-dir format ">>9.99%" TO 127
              (tot-tot-venc-dir   * 100) / tot-total-dir format ">>9.99%" TO 141
              (tot-av-30-dir      * 100) / tot-total-dir format ">>9.99%" TO 170
              (tot-av-31-60-dir   * 100) / tot-total-dir format ">>9.99%" TO 183
              (tot-av-61-90-dir   * 100) / tot-total-dir format ">>9.99%" TO 196
              (tot-av-90-dir      * 100) / tot-total-dir format ">>9.99%" TO 210
              (tot-tot-a-venc-dir * 100) / tot-total-dir format ">>9.99%" TO 224.
          PUT STREAM STREAM_1 SKIP(1).

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          ASSIGN de-dias = tot-ve-06-30-dir + tot-ve-31-60-dir + tot-ve-61-90-dir + tot-ve-91-180-dir.
          PUT STREAM STREAM_1
              " Inadimplencia de 06 a 180 dias R$ " de-dias 
              " Percentual: " (de-dias * 100) / tot-total-dir format ">>9.99%" skip(1).

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          assign de-dias = de-dias + tot-ve-180-dir.
          PUT STREAM STREAM_1
              " Inadimplencia acima de  5 dias R$ " de-dias 
              " Percentual: " (de-dias * 100) / tot-total-dir format ">>9.99%" skip(1).
          /* PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP(1).*/
              
          
          ASSIGN tot-ve-05-dir      = 0
                 tot-ve-06-30-dir   = 0
                 tot-ve-31-60-dir   = 0
                 tot-ve-61-90-dir   = 0
                 tot-ve-91-180-dir  = 0
                 tot-ve-180-dir     = 0
                 tot-tot-venc-dir   = 0
                 tot-av-30-dir      = 0
                 tot-av-31-60-dir   = 0
                 tot-av-61-90-dir   = 0
                 tot-av-90-dir      = 0
                 tot-tot-a-venc-dir = 0
                 tot-total-dir      = 0.

       end. 

   end.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   /*
   PUT STREAM Stream_1 UNFORMATTED 
       SKIP
       FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
   DISP STREAM STREAM_1
            t-ve-05         
            t-ve-06-30      
            t-ve-31-60      
            t-ve-61-90      
            t-ve-91-180     
            t-ve-180        
            t-tot-venc      
            t-av-30         
            t-av-31-60      
            t-av-61-90      
            t-av-90         
            t-tot-a-venc    
            t-total         
            WITH FRAME f-tot-grp-rep DOWN. 
   PUT STREAM Stream_1 SKIP.
   
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   DISP STREAM STREAM_1
        " Percentuais em Relacao ao TOTAL GERAL " 
        (t-ve-05 * 100)      / t-total format ">>9.99%" TO 64 
        (t-ve-06-30 * 100)   / t-total format ">>9.99%" TO 78 
        (t-ve-31-60 * 100)   / t-total format ">>9.99%" TO 91 
        (t-ve-61-90 * 100)   / t-total format ">>9.99%" TO 104 
        (t-ve-91-180 * 100)  / t-total format ">>9.99%" TO 117
        (t-ve-180 * 100)     / t-total format ">>9.99%" TO 130
        (t-tot-venc * 100)   / t-total format ">>9.99%" TO 144
        (t-av-30 * 100)      / t-total format ">>9.99%" TO 173
        (t-av-31-60 * 100)   / t-total format ">>9.99%" TO 186
        (t-av-61-90 * 100)   / t-total format ">>9.99%" TO 199
        (t-av-90 * 100)      / t-total format ">>9.99%" TO 213
        (t-tot-a-venc * 100) / t-total format ">>9.99%" TO 227
         SKIP(1)                                           
        with width 255.                                    

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180.
   PUT STREAM STREAM_1         
       " Inadimplencia de 06 a 180 dias R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).
        
   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   assign de-dias = t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180 + t-ve-180.
   put STREAM STREAM_1          
       " Inadimplencia acima de 5 dias  R$ " de-dias 
       " Percentual: " (de-dias * 100) / t-total format ">>9.99%"
       skip(1).

end.

procedure pi-rep-por-mod.
   for each tt_port
       break by tt_port.cdn_repres  
             by tt_port.cod_portador
             by tt_port.cod_cart_bcia
             by tt_port.cod_grp_clien:
                     
       find first representante no-lock 
            where representante.cod_empresa = v_cod_empres_usuar
              and representante.cdn_repres  = tt_port.cdn_repres no-error.
       IF NOT AVAIL representante THEN
           NEXT.

       IF FIRST-OF(tt_port.cdn_repres) then do:
           IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
               ASSIGN V_Num_Pag = V_Num_Pag + 1.
               RUN Pi_Imprime_Cabecalho (INPUT YES).
           END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

           DISP STREAM STREAM_1  
                representante.cdn_repres
                representante.nom_pessoa 
                WITH FRAME f-repres DOWN.
           DOWN STREAM Stream_1 WITH FRAME f-repres.
       END.
       
       find first emscad.portador no-lock
           where emscad.portador.cod_portador = tt_port.cod_portador NO-ERROR.

       ASSIGN perc-tot-a-venc  = tt_port.tot-a-venc * 100 / t-tot-a-venc
              perc-tot-venc    = tt_port.tot-venc   * 100 / t-tot-venc.

       ASSIGN tot-ve-05      = tot-ve-05      + tt_port.ve-05     
              tot-ve-06-30   = tot-ve-06-30   + tt_port.ve-06-30  
              tot-ve-31-60   = tot-ve-31-60   + tt_port.ve-31-60  
              tot-ve-61-90   = tot-ve-61-90   + tt_port.ve-61-90  
              tot-ve-91-180  = tot-ve-91-180  + tt_port.ve-91-180 
              tot-ve-180     = tot-ve-180     + tt_port.ve-180    
              tot-tot-venc   = tot-tot-venc   + tt_port.tot-venc  
              tot-av-30      = tot-av-30      + tt_port.av-30   
              tot-av-31-60   = tot-av-31-60   + tt_port.av-31-60  
              tot-av-61-90   = tot-av-61-90   + tt_port.av-61-90  
              tot-av-90      = tot-av-90      + tt_port.av-90     
              tot-tot-a-venc = tot-tot-a-venc + tt_port.tot-a-venc
              tot-total      = tot-total      + tt_port.total.     

       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       DISP STREAM Stream_1 
            tt_port.nome-regiao  
            tt_port.cod_portador 
            tt_port.cod_cart_bcia
            emscad.portador.nom_abrev      when avail portador 
            tt_port.ve-05           
            tt_port.ve-06-30        
            tt_port.ve-31-60        
            tt_port.ve-61-90        
            tt_port.ve-91-180       
            tt_port.ve-180          
            tt_port.tot-venc        
            perc-tot-venc
            tt_port.av-30           
            tt_port.av-31-60        
            tt_port.av-61-90        
            tt_port.av-90           
            tt_port.tot-a-venc      
            perc-tot-a-venc
            tt_port.total 
            WITH FRAME f-imprime DOWN.
        DOWN STREAM Stream_1 WITH FRAME f-imprime.
       
       IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
           ASSIGN V_Num_Pag = V_Num_Pag + 1.
           RUN Pi_Imprime_Cabecalho (INPUT YES).
       END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

       if last-of(tt_port.cdn_repres) then do:
          /*
          PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP.*/
          DISP STREAM STREAM_1
               tot-ve-05      
               tot-ve-06-30   
               tot-ve-31-60   
               tot-ve-61-90   
               tot-ve-91-180  
               tot-ve-180     
               tot-tot-venc   
               tot-av-30      
               tot-av-31-60   
               tot-av-61-90   
               tot-av-90      
               tot-tot-a-venc 
               tot-total      
               WITH FRAME f-tot-impr DOWN. 
          PUT STREAM Stream_1 SKIP.
          
          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
             ASSIGN V_Num_Pag = V_Num_Pag + 1.
             RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          DISP STREAM STREAM_1
              " Percentuais em Relacao ao TOTAL DO GERENTE "
              (tot-ve-05      * 100) / tot-total format ">>9.99%" TO 64 
              (tot-ve-06-30   * 100) / tot-total format ">>9.99%" TO 77 
              (tot-ve-31-60   * 100) / tot-total format ">>9.99%" TO 90 
              (tot-ve-61-90   * 100) / tot-total format ">>9.99%" TO 103
              (tot-ve-91-180  * 100) / tot-total format ">>9.99%" TO 116
              (tot-ve-180     * 100) / tot-total format ">>9.99%" TO 129
              (tot-tot-venc   * 100) / tot-total format ">>9.99%" TO 143
              (tot-av-30      * 100) / tot-total format ">>9.99%" TO 164
              (tot-av-31-60   * 100) / tot-total format ">>9.99%" TO 177
              (tot-av-61-90   * 100) / tot-total format ">>9.99%" TO 190
              (tot-av-90      * 100) / tot-total format ">>9.99%" TO 203
              (tot-tot-a-venc * 100) / tot-total format ">>9.99%" TO 217 SKIP(1)
              WITH WIDTH 255.

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          ASSIGN de-dias = tot-ve-06-30 + tot-ve-31-60 + tot-ve-61-90 + tot-ve-91-180.
          PUT STREAM STREAM_1
              " Inadimplencia de 06 a 180 dias R$ " de-dias 
              " Percentual: " (de-dias * 100) / tot-total format ">>9.99%" skip(1).

          IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
              ASSIGN V_Num_Pag = V_Num_Pag + 1.
              RUN Pi_Imprime_Cabecalho (INPUT YES).
          END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

          assign de-dias = de-dias + tot-ve-180.
          PUT STREAM STREAM_1
              " Inadimplencia acima de  5 dias R$ " de-dias 
              " Percentual: " (de-dias * 100) / tot-total format ">>9.99%" skip(1).
          PUT STREAM Stream_1 UNFORMATTED 
              FILL("-",255) FORM "x(255)"          AT 01 SKIP.
              
          ASSIGN tot-ve-05      = 0
                 tot-ve-06-30   = 0
                 tot-ve-31-60   = 0
                 tot-ve-61-90   = 0
                 tot-ve-91-180  = 0
                 tot-ve-180     = 0
                 tot-av-30      = 0
                 tot-av-31-60   = 0
                 tot-av-61-90   = 0
                 tot-av-90      = 0
                 tot-tot-venc   = 0
                 tot-tot-a-venc = 0
                 tot-total      = 0. 

      end.
   end.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       RUN Pi_Imprime_Cabecalho (INPUT YES).
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */
   
   DISP STREAM STREAM_1
            t-ve-05         
            t-ve-06-30      
            t-ve-31-60      
            t-ve-61-90      
            t-ve-91-180     
            t-ve-180        
            t-tot-venc      
            t-av-30         
            t-av-31-60      
            t-av-61-90      
            t-av-90         
            t-tot-a-venc    
            t-total         
            WITH FRAME f-total DOWN. 
   PUT STREAM Stream_1 SKIP.
   RUN pi-percentuais.
end.

procedure pi-percentuais.

   IF LINE-COUNTER(Stream_1) >= (V_Rpt_Stream_1_Lines - 4) THEN DO:
       ASSIGN V_Num_Pag = V_Num_Pag + 1.
       /*RUN Pi_Imprime_Cabecalho (INPUT YES).*/
   END. /* End do - IF LINE-COUNTER(Stream_1) = 77 */

   DISP STREAM STREAM_1 
        "   Percentuais em Relacao ao TOTAL GERAL "
        (t-ve-05 * 100) / t-total      format ">>9.99%" TO 65 
        (t-ve-06-30 * 100) / t-total   format ">>9.99%" TO 78 
        (t-ve-31-60 * 100) / t-total   format ">>9.99%" TO 91 
        (t-ve-61-90 * 100) / t-total   format ">>9.99%" TO 104 
        (t-ve-91-180 * 100) / t-total  format ">>9.99%" TO 117
        (t-ve-180 * 100) / t-total     format ">>9.99%" TO 130
        (t-tot-venc * 100) / t-total   format ">>9.99%" TO 144
        (t-av-30 * 100) / t-total      format ">>9.99%" TO 165
        (t-av-31-60 * 100) / t-total   format ">>9.99%" TO 178
        (t-av-61-90 * 100) / t-total   format ">>9.99%" TO 191
        (t-av-90 * 100) / t-total      format ">>9.99%" TO 204
        (t-tot-a-venc * 100) / t-total format ">>9.99%" TO 218 
        SKIP(1)
        "   Inadimplencia de 06 a 180 dias R$ "              
        t-ve-06-30 + t-ve-31-60 + t-ve-61-90 +              
        t-ve-91-180 format ">>>,>>>,>>9.99"
        "  Percentual: " ((t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180) *
        100) / t-total format ">>9.99%" 
        SKIP(1)
        "   Inadimplencia acima de  5 dias R$ " 
        t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + 
        t-ve-91-180 + t-ve-180 format ">>>,>>>,>>9.99"
        "  Percentual: " ((t-ve-06-30 + t-ve-31-60 + t-ve-61-90 + t-ve-91-180 + t-ve-180) *
        100) / t-total format ">>9.99%"
        with width 255.

end.

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

PROCEDURE Pi_Imprime_Cabecalho.
    
  DEF INPUT PARAM P_Log_Pula      AS LOGI NO-UNDO.

  IF P_Log_Pula THEN DO:
      IF V_Rpt_Stream_1_Bottom - LINE-COUNTER(Stream_1) > 0  THEN 
          PUT STREAM Stream_1 SKIP(V_Rpt_Stream_1_Bottom - LINE-COUNTER(Stream_1)).
      RUN Pi_Imprime_Rodape.
      PAGE STREAM Stream_1.
  END. /* End do - IF P_Log_Pula */

  PUT STREAM Stream_1 UNFORMATTED FILL("-",255) FORM "x(255)"          AT 01 SKIP
                                  C-Empresa                            AT 01
                                  V_Rpt_Stream_1_Name                  AT 110 
                                  "Pag: "                              AT 247
                                  V_Num_Pag                            TO 255 FORM ">>>9" SKIP
                                  FILL("-",230) FORM "x(230)"          
                                  TODAY FORM "99/99/9999"              TO 244
                                  " - "
                                  String(TIME,"HH:MM:SS")              TO 255.

  IF i_classifica = 1 OR i_classifica = 2 OR i_classifica = 5 THEN DO:
      PUT STREAM Stream_1 UNFORMATTED IF i_classifica = 5 THEN ""
                                                          ELSE "Diretoria" AT 01 
                                      "Port"                        AT 21 
                                      "/Cart"                       AT 27 
                                      "Nome Abrev"                  AT 33  
                                      "Ve-05"                       TO 61 
                                      "Ve-06-30"                    TO 74 
                                      "Ve-31-60"                    TO 87 
                                      "Ve-61-90"                    TO 100 
                                      "Ve-91-180"                   TO 113
                                      "Ve-180"                      TO 126
                                      "Tot-Venc"                    TO 140
                                      "%"                           TO 147
                                      "Av-30"                       TO 161
                                      "Av-31-60"                    TO 174
                                      "Av-61-90"                    TO 187
                                      "Av-90"                       TO 200
                                      "Tot-A-Venc"                  TO 214
                                      "%"                           TO 221
                                      "Total"                       TO 235
                                      FILL("-",255) FORM "x(255)"   AT 01 SKIP .
  END.
  ELSE
      PUT STREAM Stream_1 UNFORMATTED "Diretoria"                    AT 01 
                                      IF i_classifica = 3 THEN "Grp" 
                                                          ELSE "Rep" AT 21 
                                      "Nome Abrev"                   AT 29 
                                      "Ve-05"                        TO 61 
                                      "Ve-06-30"                     TO 74 
                                      "Ve-31-60"                     TO 87 
                                      "Ve-61-90"                     TO 100
                                      "Ve-91-180"                    TO 113
                                      "Ve-180"                       TO 126
                                      "Tot-Venc"                     TO 140
                                      "%"                            TO 147
                                      "%-ve60"                       TO 156
                                      "Av-30"                        TO 169
                                      "Av-31-60"                     TO 182
                                      "Av-61-90"                     TO 195
                                      "Av-90"                        TO 209
                                      "Tot-A-Venc"                   TO 223
                                      "%"                            TO 230
                                      "Total"                        TO 244
                                      FILL("-",255) FORM "x(255)"   AT 01 SKIP.
  
END PROCEDURE. /* End da PROCEDURE Pi_Imprime_Cabecalho */

PROCEDURE Pi_Imprime_Rodape.
  IF V_Rpt_Stream_1_Bottom - LINE-COUNTER(Stream_1) > 0 
  THEN PUT STREAM Stream_1 SKIP(V_Rpt_Stream_1_Bottom - LINE-COUNTER(Stream_1)).

  PUT STREAM Stream_1 UNFORMATTED FILL("-",205)  FORM "x(205)"
                                  "Intelbras - Espec¡ficos - ESACR005RP - V:1.00.000" to 255 SKIP.
END PROCEDURE. /* End da Procedure Pi_Imprime_Rodape */

PROCEDURE piTrataDiretoria:
    /*L¢gica Original para a busca da diretoria*/
    IF  representante.cdn_repres >= 5000 THEN
         ASSIGN cDiretoria = "EXPORTACAO".
    ELSE IF (representante.cod_grp_repres = '02' OR 
             representante.cod_grp_repres = '03' OR 
             representante.cod_grp_repres = '13' OR 
             representante.cod_grp_repres = '14') THEN
         ASSIGN cDiretoria = "TELEFONES".
    ELSE ASSIGN cDiretoria = "CENTRAIS".

    IF   representante.cdn_repres >= iCdn_repres1_ini AND 
         representante.cdn_repres <= iCdn_repres1_end THEN 
         ASSIGN cDiretoria = cRepres_1.
    ELSE IF representante.cdn_repres >= iCdn_repres2_ini AND 
            representante.cdn_repres <= iCdn_repres2_end THEN 
         ASSIGN cDiretoria = cRepres_2.
    ELSE IF representante.cdn_repres >= iCdn_repres3_ini AND 
            representante.cdn_repres <= iCdn_repres3_end THEN 
         ASSIGN cDiretoria = cRepres_3.
    ELSE IF representante.cdn_repres >= iCdn_repres4_ini AND 
            representante.cdn_repres <= iCdn_repres4_end THEN 
         ASSIGN cDiretoria = cRepres_4.
END PROCEDURE.

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".

