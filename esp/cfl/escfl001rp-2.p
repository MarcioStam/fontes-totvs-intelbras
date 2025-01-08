/*****************************************************************************
**     Programa.........: esp/cfl/escfl001rp-2.p
**     Descricao .......: Relat¢rio Geraá∆o fluxo de caixa
**     Versao...........: 1.00.000
**     Autor............: Fl†vio Schoenell - Intelbras
**     Criado...........: 17/11/2006
**     Desc. Atualizaá∆o: 
*******************************************************************************/

{esinc/es0000.i}
{esp/es0018.i}

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

def new shared var va as dec.
def new shared var a  as dec.
def new shared var b  as dec.
def new shared var x  as dec.
def new shared var c  as dec.
def new shared var d  as dec.
def new shared var e  as dec.
def new shared var DA as dec.
def new shared var y  as dec.
def new shared var de-cof as dec.
def new shared var de-pis as dec.
DEF NEW SHARED VAR V_Rpt_s_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_s_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_s_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_s_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_s_1_Name       AS CHAR.

DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR Rw-Log-Exec                             AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR c-arquivo-int AS CHAR no-undo.
def var c-estab as char no-undo.
DEF VAR d-data-fim AS DATE NO-UNDO.
def var c-linha as char no-undo.
DEF VAR c-arq-importacao AS CHAR no-undo.
def var i-pto-contr as inte no-undo.
def var de-peso-tot as dec.
def var da-data as date.
def var de-cotacao as dec.
def var v_num_cont as int.
def var v_nom_filename as char.

DEFINE VARIABLE c-nr-pagamento AS CHARACTER   NO-UNDO.

def var v_hdl_api                        as handle          no-undo. /*local*/

def new shared stream s_1.
def var h-acomp         as handle                       no-undo.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

def temp-table tt-param-fluxo no-undo
    field cod-versao-integracao as integer format "999"       /* Valida a versao da api sendo executada */
    field tipo-fluxo            as integer format "9"         /* valida o tipo de atualizacao a ser efetuado (1-Resumido, 2-Detalhado) */                                
    field dt-inicio-fluxo       as date format "99/99/9999"   /* data inicial para geracao de movimento (cb0102) */                                                    
    field dt-ini                as date format "99/99/9999"   /* data inicial para a pesquisa */
    field dt-fim                as date format "99/99/9999"   /* data final   para a pesquisa */
    field cod-estab-ini         as char format "x(03)"        /* estabelecimento inicial da faixa */
    field cod-estab-fim         as char format "x(03)"        /* estabelecimento final da faixa   */
    field cod_unid_negoc_ini    as char format "x(03)"        /* unidade de negocio inicial a compor o fluxo */
    field cod_unid_negoc_fim    as char format "x(03)"        /* unidade de negocio final a compor o fluxo */
    FIELD considera-pd          AS LOGICAL                    /* considera pedidos de venda no fluxo. Alimentado de 
                                                                 acordo com o campo de tela do cf1703aa, no caso do Ems5, e dos
                                                                 parametros de fluxo, no caso do Ems2. */  
    FIELD pr-lib-tit            AS LOGICAL                    /* identifica se serao somados os pedidos suspensos na 
                                                                 carteira de pedidos para o fluxo de caixa. */
    FIELD ped-suspenso          AS LOGICAL                    /* identifica se vao ser somados os pedidos suspensos na 
                                                                 carteira de pedidos para o fluxo de caixa. */
    field tipo-ordem-cc         as integer format "9" 
                                /* 1-Confirmada, 2-Nao Confirm, 3-Ambas */
    field tipo-preco            as integer format "9"
                                /* 1-Reposicao, 
                                   2-Base, 
                                   3-Ultima Entr, 
                                   4-Medio 
                                   5-Preco ON-line
                                   6-Preco Padrao */
    field considera-pv          AS LOGICAL                    /* considera previs∆o de vendas no fluxo. Alimentado de 
                                                                 acordo com o campo de tela do cf1703aa, no caso do Ems5, e dos
                                                                 parametros de fluxo, no caso do Ems2. */
    field cd-plano-pv           AS integer format ">>9".      /* plano de vendas informado na tela do EMS 5 dos parÉmetros do
                                                                 fluxo no EMS 2 */

def {1} temp-table tt-erro no-undo
    field cd-erro  as int
    field modulo   as char format "x(3)"
    field mensagem as char format "x(255)".

def temp-table tt-movto-fluxo no-undo
    field cod-estabel            as char    format "x(03)"
    field data-movto             as date    format "99/99/9999"
    field tp-codigo              as integer format ">>9"
    field cod-gr-forn            as integer format ">9"
    field cod-emitente           as integer format "999999999"
    field tipo-fluxo             as integer format "9"    /* 1-Entrada, 2-Saida */
    field tipo-movto             as integer format "9"    /* 1-Previsto, 2-Realizado */
    field origem                 as integer format "9"
    field mo-codigo              as integer format ">9"
    field cod_unid_negoc         as char    format "x(03)"
    field numero-ordem           as char    format "x(16)" 
    field parcela                as char    format "x(02)"
    field sit-ordem              as integer format ">9" 
    field vl-fluxo               as decimal format "->>>,>>>,>>>,>>9.99"
    field data-fluxo             as date    format "99/99/9999" /* campo novo */
    field it-codigo              as char    format "x(16)"      /* campo novo */
    FIELD nr-sequencia           AS INTEGER FORMAT ">>,>>9"
    field portador               as INTEGER format ">>>>9"
    FIELD modalidade             AS INTEGER FORMAT "9"
    FIELD cod-grupo              AS INTEGER FORMAT "9"
    FIELD nome-abrev             AS CHAR    FORMAT "x(12)"
    FIELD nr-pedcli              AS CHAR    FORMAT "x(12)"
    FIELD nome-emit              AS CHAR    FORMAT "x(40)"
    FIELD referencia             AS CHAR    FORMAT "x(08)"
    INDEX ch-fluxo data-fluxo 
                   tp-codigo 
                   it-codigo
    INDEX ch-orig  origem.


def temp-table tt-valor
    field estab as char format 'x(3)'
    field tipo  as char format "x(6)"
    field docto as char format "x(10)"
    field data  as date format "99/99/9999"
    field cod-emitente like emitente.cod-emitente
    field valor as dec format ">>>,>>>,>>9.99"
    field moeda like moeda.mo-codigo
    field numero-ordem           as char    format "x(16)" 
    field parcela                as char    format "x(02)"
    index data is primary estab tipo data docto.

def temp-table tt-ii
    field peso like item.peso-bruto
    field al-ii like item.aliquota-ipi
    field al-ipi like item.aliquota-ipi
    field valor as dec
    field frete-seguro as dec
    field ii as dec
    field ipi as dec
    field pis as dec
    field cofins as dec
    index codigo is primary al-ii al-ipi.

def temp-table tt_import_movto_fluxo_cx no-undo
    field tta_num_fluxo_cx                 as integer format ">>>>>,>>9" initial 0 label "Fluxo Caixa" column-label "Fluxo Caixa"
    field tta_dat_movto_fluxo_cx           as date format "99/99/9999" initial ? label "Data Movimento" column-label "Data Movimento"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_fluxo_movto_cx           as character format "X(3)" initial "ENT" label "Fluxo Movimento" column-label "Fluxo Movimento"
    field tta_ind_tip_movto_fluxo_cx       as character format "X(2)" initial "PR" label "Tipo Movimento" column-label "Tipo Movimento"
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_val_movto_fluxo_cx           as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Movto" column-label "Valor Movto"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_movto_fluxo_cx    as character format "x(2000)" label "Hist¢rico Movimento" column-label "Hist¢rico Movimento"
    field ttv_rec_movto_fluxo_cx           as recid format ">>>>>>9" initial ?.

def temp-table tt_import_movto_valid_cfl no-undo
    field ttv_rec_movto_fluxo_cx           as recid format ">>>>>>9" initial ?
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

DEFINE VARIABLE h-boin082i AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE tt-cotacao-imp NO-UNDO
    FIELD numero-ordem   like cotacao-item.numero-ordem
    FIELD cod-emitente   like cotacao-item.cod-emitente 
    FIELD it-codigo      like cotacao-item.it-codigo
    FIELD seq-cotac      like cotacao-item.seq-cotac
    FIELD mapa-cotacao   like cotacao-item-cex.mapa-cotacao
    FIELD cod-incoterm   like inco-cx.cod-incoterm
    FIELD cod-pto-contr  like pto-contr.cod-pto-contr
    FIELD cod-fabricante like emitente.cod-emitente
    field cdn-pais-orig  as   integer format ">>,>>9":U
    FIELD regime-import  like pais-aliquota.regime-import
    FIELD class-fiscal   like classif-fisc.class-fiscal
    FIELD aliq-ii        as   decimal format ">>9.99"
    FIELD aliq-ipi       as   decimal format ">>9.99"
    FIELD cod-itiner     like itinerario.cod-itiner
    FIELD i-informa      AS   INTEGER
    FIELD da-entrega-embarque AS DATE
    FIELD r-Rowid AS ROWID.
RUN inbo/boin082i.p PERSISTENT SET h-boin082i.

/**************************************************************************/
/* **************** Tratamento para a execuá∆o do programa ****************/
/**************************************************************************/

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "escfl001rp"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File     = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output   = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora       = Ped_Exec_Param.Nom_Dwb_Printer
          c-arquivo-int      = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
          c-estab            = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))
          C-Layout           = Ped_Exec_Param.Cod_Dwb_Print_Layout
          V_Cod_Usuar_Corren = entry(2,V_Cod_Dwb_User,"_").
  END. /* End do IF AVAIL Ped_Exec_Param */

  FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
  IF AVAIL ped_exec THEN DO:
     FIND FIRST servid_exec WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-LOCK NO-ERROR.
     IF AVAIL servid_exec THEN DO:
         IF servid_exec.ind_tip_fila_exec = 'unix' THEN
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + "/" + V_Cod_Dwb_File.
         ELSE
            ASSIGN V_Cod_Dwb_File = servid_exec.nom_dir_spool + "~\" + V_Cod_Dwb_File.
     END.
  END.
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "escfl001rp"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           c-arquivo-int    = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           c-estab          = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout.
  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "escfl001.lst".
      OUTPUT STREAM s_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_s_1_Lines) CONVERT TARGET "iso8859-1".
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
      ASSIGN V_Rpt_s_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_s_1_Bottom - V_Rpt_s_1_Lines */
             V_Rpt_s_1_Lines  = Layout_Impres.Num_Lin_Pag.

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
            THEN OUTPUT STREAM s_1 
                        THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_s_1_Lines) 
                                CONVERT TARGET "iso8859-1".
            ELSE OUTPUT STREAM s_1 
                        THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_s_1_Lines) 
                                CONVERT TARGET "iso8859-1".
          END. /* End do - IF AVAIL ped_Exec */
        END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
        ELSE OUTPUT STREAM s_1 
                    THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                            PAGED 
                            PAGE-SIZE 
                            VALUE(V_Rpt_s_1_Lines) 
                            CONVERT TARGET "iso8859-1".
      END. /* End do - IF OPSYS = "UNIX" */
      ELSE OUTPUT STREAM s_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_s_1_Lines) 
                                           CONVERT TARGET "iso8859-1".
      FOR EACH Configur_Layout_Impres NO-LOCK
          WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
             BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
        FIND Configur_Tip_imprsor NO-LOCK
             WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
               AND Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
               AND Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
             NO-ERROR.
        PUT STREAM s_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
      END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
    END. /* End do - WHEN "Impressora" l_Printer */
    WHEN "Arquivo" /*l_File*/  THEN 
    DO.
      OUTPUT STREAM s_1 TO VALUE(V_Cod_Dwb_File)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_s_1_Lines)
                                           CONVERT TARGET "iso8859-1".
    END. /* End do - WHEN "Arquivo" - l_File  */
  END. /* End do - CASE V_Cod_Dwb_Output */
END. /* End do - DO. -- Que seta a saida da impressao */

/**************************************************************************************************/
/* ****************************************** Main Code *******************************************/
/**************************************************************************************************/

/* ** Localiza estabelecimento informado em tela ***/
find first estabelec
     where estabelec.cod-estab = c-estab no-lock no-error.
if not avail estabelec 
   then return "ok".

/* ** Gera dados dos pedidos em aberto para a geraá∆o da planilha Excel ***/
RUN pi-pedidos.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Geraá∆o_Dados_Impostos_Importaá∆o *}
run pi-inicializar in h-acomp (input  Return-value ).

/* ** Gera Dados para o Fluxo de Caixa ***/
RUN pi-gera-fluxo.
  
IF VALID-HANDLE(h-boin082i) THEN DELETE PROCEDURE h-boin082i.
ASSIGN h-boin082i =?.

/* ** Finaliza impress∆o do relat¢rio da Integraá∆o  ***/
output stream s_1 close.

/* ** Gera planilha Excel ***/
RUN piImprimeRelat.

run pi-finalizar in h-acomp.

/* ** Abre relat¢rio gerado pela integraá∆o ***/
IF V_Cod_Dwb_Output = "Terminal" 
   THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/*************************************************************************************************/
/* ************************************* Fim do Programa *****************************************/
/*************************************************************************************************/


PROCEDURE pi-gera-fluxo:

    RUN fcf-importacao. 

    for each tt-valor:
        IF tt-valor.valor > 0 AND
           tt-valor.data  > today THEN DO:
            create tt_import_movto_fluxo_cx.
            assign tt_import_movto_fluxo_cx.tta_num_fluxo_cx              = 0
                   tt_import_movto_fluxo_cx.tta_dat_movto_fluxo_cx        = tt-valor.data
                   tt_import_movto_fluxo_cx.tta_cod_estab                 = tt-valor.estab
                   tt_import_movto_fluxo_cx.tta_cod_unid_negoc            = "ADM"
                   tt_import_movto_fluxo_cx.tta_cod_tip_fluxo_financ      = "202"
                   tt_import_movto_fluxo_cx.tta_ind_fluxo_movto_cx        = "SAI"
                   tt_import_movto_fluxo_cx.tta_ind_tip_movto_fluxo_cx    = "PR"
                   tt_import_movto_fluxo_cx.tta_cod_modul_dtsul           = "CCP"
                   tt_import_movto_fluxo_cx.tta_val_movto_fluxo_cx        = tt-valor.valor
                   tt_import_movto_fluxo_cx.tta_des_histor_movto_fluxo_cx = tt-valor.tipo + " Embarque: " + tt-valor.docto
                   tt_import_movto_fluxo_cx.ttv_rec_movto_fluxo_cx        = recid(tt_import_movto_fluxo_cx).
        END.
    end.

    /* Chamada da nova API*/
    run prgfin/cfl/cfl724zb.py (Input 1,
                                input-output table tt_import_movto_fluxo_cx,
                                input-output table tt_import_movto_valid_cfl).
    
    /* Realiza a impress∆o*/
    find first tt_import_movto_fluxo_cx no-lock no-error.
    if  avail tt_import_movto_fluxo_cx 
    then do:
         run prgfin/cfl/cfl702zc.py (Input yes,
                                     Input yes,
                                     Input table tt_import_movto_fluxo_cx,
                                     Input table tt_import_movto_valid_cfl).
    end.
END.

PROCEDURE pi-pedidos:

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    /* ** Localiza os pedidos em aberto, mesma l¢gica do produto padr∆o ***/
    create tt-param-fluxo.
    assign tt-param-fluxo.cod-versao-integracao = 2
           tt-param-fluxo.tipo-ordem-cc         = 1
           tt-param-fluxo.tipo-preco            = 4
           tt-param-fluxo.tipo-fluxo            = 0
           tt-param-fluxo.dt-ini                = today
           tt-param-fluxo.dt-fim                = today + 360
           tt-param-fluxo.cod-estab-ini         = c-estab
           tt-param-fluxo.cod-estab-fim         = c-estab
           tt-param-fluxo.cod_unid_negoc_ini    = ""
           tt-param-fluxo.cod_unid_negoc_fim    = "ZZZ"
           tt-param-fluxo.dt-inicio-fluxo       = 01/01/2005.
    
    /* Chamada do programa do EMS2 - Evolu°do */
    run ccp/ccapi011a.p persistent set v_hdl_api.
    run execute in v_hdl_api (INPUT TABLE tt-param-fluxo,
                              OUTPUT TABLE tt-movto-fluxo,
                              OUTPUT TABLE tt-erro).
    delete procedure v_hdl_api.

    FOR EACH tt-movto-fluxo
        USE-INDEX ch-orig:

        find ordem-compra where ordem-compra.numero-ordem = int(tt-movto-fluxo.numero-ordem) no-lock no-error.
        if not avail ordem-compra then next.
        
        FIND cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-ERROR.
        IF AVAIL cond-pagto THEN DO:
           FIND FIRST int-cond-pagto 
                WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
            IF AVAIL int-cond-pagto 
                 AND substring(int-cond-pagto.char-1,2,1) = "S" THEN DO:
                ASSIGN tt-movto-fluxo.data-fluxo = tt-movto-fluxo.data-fluxo - 2.
    
                IF WEEKDAY(tt-movto-fluxo.data-fluxo) = 1 OR
                   WEEKDAY(tt-movto-fluxo.data-fluxo) = 7 THEN
                    ASSIGN tt-movto-fluxo.data-fluxo = tt-movto-fluxo.data-fluxo - 2.

                /* Se a data de vencimento for em um final de semana ou feriado, antecipa */
                find dia_calend_glob no-lock
                    where dia_calend_glob.cod_calend = "Fiscal"
                    and   dia_calend_glob.dat_calend = tt-movto-fluxo.data-fluxo no-error.
                if avail dia_calend_glob 
                AND dia_calend_glob.log_dia_util = NO 
                    then assign tt-movto-fluxo.data-fluxo = tt-movto-fluxo.data-fluxo - 1.

            END.
        END.

        /* ** Indica que o valor retornou da API de Pedidos ***/
        ASSIGN tt-movto-fluxo.referencia = "Pedido".
        
        /* ** Traduz o tipo de Fluxo Financeiro ***/
        find trad_fluxo_ext no-lock
            where trad_fluxo_ext.cod_matriz_trad_fluxo_ext = 'EMS'
            and   trad_fluxo_ext.cod_fluxo_financ_ext      = string(tt-movto-fluxo.tp-codigo)no-error.
        if avail trad_fluxo_ext 
           THEN assign tt-movto-fluxo.tp-codigo = int(trad_fluxo_ext.cod_tip_fluxo_financ).

        /* ** Converte valor pela Cotaá∆o ***/
        if tt-movto-fluxo.mo-codigo = 0 
           then assign de-cotacao = 1.
           else run pi-busca-cotacao-imp(tt-movto-fluxo.data-fluxo, tt-movto-fluxo.mo-codigo).
        assign tt-movto-fluxo.vl-fluxo = tt-movto-fluxo.vl-fluxo * de-cotacao.
    
    END.

END. 

PROCEDURE fcf-importacao.
        DEF VAR i-parcela LIKE prazo-compra.parcela NO-UNDO.
        DEF VAR i-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
        DEFINE VARIABLE de-aliq-ii AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-aliq-ipi AS DECIMAL     NO-UNDO.

    /* VALOR FOB */    
    for each embarque-imp no-lock
       where embarque-imp.situacao    = 1
         and embarque-imp.cod-estabel = c-estab:

        find first ordens-embarque of embarque-imp no-lock no-error.
        if not avail ordens-embarque 
           then next.
       
        /* verifica se o embarque e fedex - tem ponto de controle 45 (101) ou 59 (102) - liberacao courier */
        if embarque-imp.cod-estabel = "101" 
           then assign i-pto-contr = 45.
        else if embarque-imp.cod-estabel = "102" 
                then assign i-pto-contr = 59.

        find first historico-embarque of embarque-imp no-lock
             where historico-embarque.cod-pto-contr = i-pto-contr no-error.
        if avail historico-embarque 
           then next.
         
        find first historico-embarque of embarque-imp NO-LOCK NO-ERROR.
        IF NOT AVAIL historico-embarque  
           THEN NEXT.       
        
        /* II e IPI */ 
        find itinerario no-lock 
             where itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

        find historico-embarque of embarque-imp no-lock
             where historico-embarque.cod-pto-contr = itinerario.pto-desembarque no-error.
        if not avail historico-embarque 
           then next.

        if historico-embarque.dt-ult-prev <= today 
           then next.
        
        for each tt-ii:
            delete tt-ii.
        end.
     
        run pi-acompanhar in h-acomp ( input ordens-embarque.numero-ordem ).

        ASSIGN i-parcela = 0
               i-numero-ordem = 0.

        for each ordens-embarque of embarque-imp no-lock:

            IF i-parcela = 0 THEN
                ASSIGN i-parcela = ordens-embarque.parcela
                       i-numero-ordem = ordens-embarque.numero-ordem.

            find ordem-compra where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
            IF NOT AVAIL ordem-compra 
               THEN NEXT.

            find FIRST cotacao-item 
                 where cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                   and cotacao-item.cot-aprovada no-lock no-error. 
             find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
             find classif-fisc where classif-fisc.class-fiscal = substring(cotacao-item.char-1,81,20) no-lock no-error.
             if not avail classif-fisc 
             then do:
                  find classif-fisc where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.
             end.

             if  AVAILABLE item AND item.aliquota-ii > 100 
             then do:
                  put "ERRO NA ALIQUOTA DO II. ORDEM: " cotacao-item.numero-ordem " VERIFIQUE " SKIP.
             end.
             
             FIND emitente NO-LOCK
                 WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                 NO-ERROR.
             IF AVAIL emitente THEN DO:
                 IF emitente.pais = "Brasil" THEN DO:
                     IF ITEM.ge-codigo = 0 THEN DO:
                         FIND tt-ii
                             WHERE tt-ii.al-ii  = 0
                               AND tt-ii.al-ipi = cotacao-item.aliquota-ipi NO-ERROR.
                         IF NOT AVAIL tt-ii THEN DO:
                             CREATE tt-ii.
                             ASSIGN tt-ii.al-ii  = 0
                                    tt-ii.al-ipi = cotacao-item.aliquota-ipi.
                         END.
                     END.
                     ELSE DO:
                         FIND tt-ii
                             WHERE tt-ii.al-ii  = 0
                               AND tt-ii.al-ipi = (IF AVAILABLE item THEN item.aliquota-ipi ELSE 0) NO-ERROR.
                         IF NOT AVAIL tt-ii THEN DO:
                             CREATE tt-ii.
                             ASSIGN tt-ii.al-ii  = 0
                                    tt-ii.al-ipi = IF AVAILABLE item THEN item.aliquota-ipi ELSE 0.
                         END.
                     END.
                 END.
                 ELSE DO:
                     IF ITEM.ge-codigo = 0 THEN DO:

                         run setConstraintRowid in h-boin082i (input ROWID(cotacao-item)) no-error.
                         run openQueryStatic in h-boin082i (input "Rowid":U) no-error.
                         
                         run calculateII_IPI in h-boin082i (input  cotacao-item.it-codigo,   
                                                            input  cotacao-item.numero-ordem,
                                                            input  cotacao-item.aliquota-ipi,
                                                            input  SUBSTRING(cotacao-item.char-1,81,8),
                                                            input  cotacao-item.cdn-pais-orig,             
                                                            input  cotacao-item.regime-impot,
                                                            output de-aliq-ii, 
                                                            output de-aliq-ipi).

                         FIND tt-ii
                             WHERE tt-ii.al-ii  = de-aliq-ii
                               AND tt-ii.al-ipi = de-aliq-ipi NO-ERROR.
                         IF NOT AVAIL tt-ii THEN DO:
                             CREATE tt-ii.
                             ASSIGN tt-ii.al-ii  = de-aliq-ii
                                    tt-ii.al-ipi = de-aliq-ipi.
                         END.
                     END.
                     ELSE DO:
                         find tt-ii
                              where tt-ii.al-ii  = (IF AVAILABLE item THEN DEC(SUBSTRING(ITEM.char-2,22,6)) ELSE 0)
                                and tt-ii.al-ipi = (IF AVAILABLE item THEN item.aliquota-ipi ELSE 0) no-error.
                         if not avail tt-ii 
                         then do:
                              create tt-ii.
                              assign tt-ii.al-ii = (IF AVAILABLE item THEN DEC(SUBSTRING(ITEM.char-2,22,6)) ELSE 0)
                                     tt-ii.al-ipi = (IF AVAILABLE item THEN item.aliquota-ipi ELSE 0).
                         end.
                     END.
                 END.
             END.
             
             assign da-data = if historico-embarque.dt-efetiva <> ? then historico-embarque.dt-efetiva 
                              else historico-embarque.dt-ult-prev.
             run pi-busca-cotacao-imp(da-data,ordem-compra.mo-codigo).
                              
             assign tt-ii.valor = tt-ii.valor + ordem-compra.preco-unit * ordens-embarque.quantidade * de-cotacao.
             
             assign tt-ii.peso = ordens-embarque.quantidade * item.peso-bruto.
             if tt-ii.peso = 0 
                then assign tt-ii.peso = ordens-embarque.quantidade.             
            
        end.    
    
        assign de-peso-tot = 0.
        
        for each tt-ii:
            assign de-peso-tot = de-peso-tot + tt-ii.peso.
        end.
        if de-peso-tot <= 0 then assign de-peso-tot = 1.    

        for each desp-embarque no-lock
           where desp-embarque.cod-estabel = embarque-imp.cod-estabel
             and desp-embarque.embarque    = embarque-imp.embarque
             and (desp-embarque.cod-desp   = 3
              or  desp-embarque.cod-desp   = 22):
              run pi-busca-cotacao-imp(da-data,desp-embarque.mo-codigo).
              for each tt-ii:
                  assign tt-ii.frete-seguro = tt-ii.frete-seguro +
                         (desp-embarque.val-desp * de-cotacao) * 
                         (tt-ii.peso / de-peso-tot) .
              end.
        end.       


        for each tt-ii:
             assign tt-ii.ii = (tt-ii.valor + tt-ii.frete-seguro) *   /* Frete e seguro Ç acrescido ao valor da ordem para calcular o valor do II e IPI */
                                tt-ii.al-ii / 100
                    tt-ii.ipi = (tt-ii.valor + tt-ii.frete-seguro + tt-ii.ii)
                              * tt-ii.al-ipi / 100 .
             find tt-valor
               where tt-valor.estab = embarque-imp.cod-estabel
                 and tt-valor.tipo  = "II"
                 and tt-valor.docto = embarque-imp.embarque
                 and tt-valor.data  = historico-embarque.dt-ult-prev no-error.
            if not avail tt-valor then do:
                 create tt-valor.
                 assign tt-valor.estab        = embarque-imp.cod-estabel
                        tt-valor.tipo         = "II"
                        tt-valor.docto        = embarque-imp.embarque
                        tt-valor.data         = historico-embarque.dt-ult-prev
                        tt-valor.cod-emitente = ordem-compra.cod-emitente
                        tt-valor.moeda        = 0
                        tt-valor.numero-ordem = string(i-numero-ordem)
                        tt-valor.parcela      = string(i-parcela).
            end.
       
            assign tt-valor.valor = tt-valor.valor + tt-ii.ii.
    
            find tt-valor
                 where tt-valor.estab = embarque-imp.cod-estabel
                   and tt-valor.tipo  = "IPI"
                   and tt-valor.docto = embarque-imp.embarque
                   and tt-valor.data  = historico-embarque.dt-ult-prev no-error.
            if not avail tt-valor 
            then do:
                 create tt-valor.
                 assign tt-valor.estab        = embarque-imp.cod-estabel
                        tt-valor.tipo         = "IPI"
                        tt-valor.docto        = embarque-imp.embarque
                        tt-valor.data         = historico-embarque.dt-ult-prev
                        tt-valor.cod-emitente = ordem-compra.cod-emitente
                        tt-valor.moeda        = 0
                        tt-valor.numero-ordem = string(i-numero-ordem)
                        tt-valor.parcela      = string(i-parcela).
            end.
            
            assign tt-valor.valor = tt-valor.valor + tt-ii.ipi.

            assign va = tt-ii.valor + tt-ii.frete-seguro
                    a = tt-ii.al-ii / 100
                    b = tt-ii.al-ipi / 100
                    DA = 0.
            
            assign c = 1.65 / 100
                   d = 7.60 / 100
                   e = 17 / 100.

            assign x = (  ( 1 + e * ( a + b * ( 1 + a) ) ) / (1 - c - d - e) )
                   y = ( e / ( 1 - c - d - e) ).

            assign de-cof = d * (VA * x + DA * Y)
                   de-pis = c * (VA * x + DA * Y).           

            find tt-valor
                 where tt-valor.estab = embarque-imp.cod-estabel
                   and tt-valor.tipo  = "PIS"
                   and tt-valor.docto = embarque-imp.embarque
                   and tt-valor.data  = historico-embarque.dt-ult-prev no-error.
            if not avail tt-valor 
            then do:
                 create tt-valor.
                 assign tt-valor.estab        = embarque-imp.cod-estabel
                        tt-valor.tipo         = "PIS"
                        tt-valor.docto        = embarque-imp.embarque
                        tt-valor.data         = historico-embarque.dt-ult-prev
                        tt-valor.cod-emitente = ordem-compra.cod-emitente
                        tt-valor.moeda        = 0
                        tt-valor.numero-ordem = string(i-numero-ordem)
                        tt-valor.parcela      = string(i-parcela).
            end.
            
            assign tt-valor.valor = tt-valor.valor + de-pis.

            find tt-valor
                 where tt-valor.estab = embarque-imp.cod-estabel
                   and tt-valor.tipo  = "COF"
                   and tt-valor.docto = embarque-imp.embarque
                   and tt-valor.data  = historico-embarque.dt-ult-prev no-error.
            if not avail tt-valor 
            then do:
                 create tt-valor.
                 assign tt-valor.estab        = embarque-imp.cod-estabel
                        tt-valor.tipo         = "COF"
                        tt-valor.docto        = embarque-imp.embarque
                        tt-valor.data         = historico-embarque.dt-ult-prev
                        tt-valor.cod-emitente = ordem-compra.cod-emitente
                        tt-valor.moeda        = 0
                        tt-valor.numero-ordem = string(i-numero-ordem)
                        tt-valor.parcela      = string(i-parcela).
            end.
            
            assign tt-valor.valor = tt-valor.valor + de-cof.
        end.       

        /* ** Valores Antecipados ***/
        for each ordens-embarque of embarque-imp no-lock:

              FIND ordem-compra where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
              IF NOT AVAIL ordem-compra 
                 THEN NEXT.

              find FIRST cotacao-item 
                   where cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                     and cotacao-item.cot-aprovada no-lock no-error. 
    
              FIND cond-pagto NO-LOCK
                   WHERE cond-pagto.cod-cond-pag = cotacao-item.cod-cond-pag NO-ERROR.
    
              IF NOT AVAIL cond-pagto 
                 THEN next.
    
              IF cond-pagto.cod-vencto <> 3 
                 THEN NEXT.
    
               FIND FIRST historico-embarque NO-LOCK
                    WHERE historico-embarque.cod-estabel   = c-estab
                      AND historico-embarque.embarque      = embarque-imp.embarque
                      AND historico-embarque.cod-itiner    = cotacao-item.int-1
                      AND historico-embarque.cod-pto-contr = INT(substr(cotacao-item.char-1,41,20)) NO-ERROR.
               IF NOT AVAIL historico-embarque 
                  THEN NEXT.
    
               assign da-data = if historico-embarque.dt-efetiva <> ? 
                                   then historico-embarque.dt-efetiva 
                                   else historico-embarque.dt-ult-prev.
    
               ASSIGN da-data = da-data - cond-pagto.nr-dias-ante.
    
               run pi-busca-cotacao-imp(da-data,ordem-compra.mo-codigo).
    
               find tt-valor
                       where tt-valor.estab = embarque-imp.cod-estabel
                         and tt-valor.tipo  = "FOB"
                         and tt-valor.docto = embarque-imp.embarque
                         and tt-valor.data  = da-data no-error.
               if not avail tt-valor 
               then do:
                    create tt-valor.
                    assign tt-valor.estab        = embarque-imp.cod-estabel
                           tt-valor.tipo         = "FOB"
                           tt-valor.docto        = embarque-imp.embarque
                           tt-valor.data         = da-data
                           tt-valor.cod-emitente = ordem-compra.cod-emitente
                           tt-valor.moeda        = ordem-compra.mo-codigo
                           tt-valor.numero-ordem = string(ordem-compra.numero-ordem)
                           tt-valor.parcela      = STRING(ordens-embarque.parcela).
               end.
               assign tt-valor.valor = tt-valor.valor + ordem-compra.preco-unit * ordens-embarque.quantidade * de-cotacao.
        end.    
        
    end.
    
    /* DESPESAS - serao obtidas diretamente no contas a pagar */
        
    /* joga vencimentos para segunda */
    for each tt-valor:
        if weekday(tt-valor.data) = 1 
           then assign tt-valor.data = tt-valor.data + 1.
        if weekday(tt-valor.data) = 7 
           then assign tt-valor.data = tt-valor.data + 2.         
    end.

    /* ** Cria temp-table para que seja convertido em .csv ***/
    for each tt-valor:
       IF  tt-valor.valor > 0 and tt-valor.data  > today THEN DO:
           create tt-movto-fluxo.
           assign tt-movto-fluxo.data-fluxo   = tt-valor.data
                  tt-movto-fluxo.vl-fluxo     = tt-valor.valor
                  tt-movto-fluxo.numero-ordem = tt-valor.numero-ordem
                  tt-movto-fluxo.parcela      = tt-valor.parcela
                  tt-movto-fluxo.mo-codigo    = tt-valor.moeda
                  tt-movto-fluxo.referencia   = tt-valor.tipo
                  tt-movto-fluxo.nr-pedcli    = tt-valor.docto
                  tt-movto-fluxo.tp-codigo    = 202.
       END.
    end.
END.

procedure pi-busca-cotacao-imp.
    def input parameter da-data as date.
    def input parameter i-moeda as int.
    
    find cotacao no-lock
         where cotacao.mo-codigo   = i-moeda
           and cotacao.ano-periodo = string(year(da-data),"9999") + string(month(da-data),"99") no-error.
   if avail cotacao and cotacao.cotacao[day(da-data)] <> 0 then do:
      assign de-cotacao = cotacao.cotacao[day(da-data)].
   end.
   else
      assign de-cotacao = 1.


end.

PROCEDURE piImprimeRelat.

    DEF VAR c-arquivo AS CHAR no-undo.

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "UNIX":U THEN
        RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
    ELSE
        RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN c-arquivo = c-arquivo + "fluxo":U + c-estab + "-":U + TRIM(STRING(TODAY, "99999999":U)) + ".csv":U.

    OUTPUT STREAM s_1 to value(c-arquivo).    
    
    for each tt-erro:
        put STREAM s_1 unformatted "Erro: " mensagem skip.
    end.

    put stream S_1
        "Data"
        ";"
        "Ordem"
        ";"
        "parcela" 
        ";"
        "Valor"   
        ";"
        "moeda"
        ";"
        "pedido"  
        ";"
        "Comprador"
        ";"
        "Cod For"
        ";"
        "Fornecedor"
        ";"
        "Origem Lancamento"
        ";"
        "Entrega"
        ";"
        "cond-pag"    
        ";"
        "descricao"   
        ";"
        "cod-cond"    
        ";"
        "nr-parc" 
        ";"
        "dias cond"
        ";"
        "Tipo Fluxo"
        ";"
        "Situacao"
        ";"
        "pto-controle"
        ";"
        "Descricao do Pto contr."
        ";"
        "embarque"    
        ";"
        "data orig"   
        ";"
        "data ult-prev"
        ";"
        "data-efetiva"
        ";"
        "CI"
         skip.

    
    FOR EACH tt-movto-fluxo:

        find ordem-compra where ordem-compra.numero-ordem = int(tt-movto-fluxo.numero-ordem) no-lock no-error.
        if not avail ordem-compra then next.
        
        find pedido-compr no-lock
             where pedido-compr.num-pedido = ordem-compra.num-pedido no-error.    
        if not avail pedido-compr then next.
        
        run pi-acompanhar in h-acomp ( input "Imprimindo " + tt-movto-fluxo.numero-ordem). 

        put stream S_1
             tt-movto-fluxo.data-fluxo
             ";"
             ordem-compra.numero-ordem
             ";"
             tt-movto-fluxo.parcela
             ";"
             tt-movto-fluxo.vl-fluxo
             ";"
             tt-movto-fluxo.mo-codigo
             ";"
             ordem-compra.num-pedido
             ";".             
             
         find first usuar_mestre no-lock 
             where usuar_mestre.cod_usuario = pedido-compr.responsavel no-error.
         if avail usuar_mestre 
             THEN put stream S_1 usuar_mestre.nom_usuario  ";".
             else put stream S_1 pedido-compr.responsavel ";" ";".
         
         find emitente no-lock
              where emitente.cod-emitente = pedido-compr.cod-emitente .
         put stream S_1 emitente.cod-emitente ";" emitente.nome-abrev ";".
             
         PUT STREAM s_1 tt-movto-fluxo.referencia ";".

         find FIRST prazo-compra no-lock
              where prazo-compra.numero-ordem =  int(tt-movto-fluxo.numero-ordem)
                and prazo-compra.parcela      =  int(tt-movto-fluxo.parcela) NO-ERROR.
         
         IF AVAIL prazo-compra 
            THEN put stream S_1 prazo-compra.data-entrega ";". 
            ELSE PUT STREAM S_1 ";".
     
         put stream S_1 pedido-compr.cod-cond-pag ";".

         FIND cond-pagto NO-LOCK
              WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.
         IF AVAIL cond-pagto THEN
             put   stream S_1 cond-pagto.descricao
                   ";"
                   cond-pagto.cod-vencto 
                   ";"
                   cond-pagto.num-parcelas
                   ";"
                   cond-pagto.prazos[1]
                   ";"
                   tt-movto-fluxo.tp-codigo 
                   ";" 
                   "OK"
                   ";" .               
           ELSE
                   put   stream S_1 
                   ";"
                   ";"
                   ";"
                   ";"
                   ";" 
                   ";" .               

/*        if tt-movto-fluxo.mo-codigo <> 0 then do:*/
             find FIRST cotacao-item 
                  WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                    AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
             IF AVAIL cotacao-item THEN DO:
                  put stream S_1 substring(cotacao-item.char-1,41,20) ";" .
                  find pto-contr where pto-contr.cod-pto-contr = int(substring(cotacao-item.char-1,41,20)) no-lock no-error.
             END.
             if avail pto-contr then 
                put  stream S_1 pto-contr.descricao ";".
             else put stream S_1 "Erro no ponto de controle" ";".
    
             FOR EACH ordens-embarque of ordem-compra 
                 where ordens-embarque.parcela = int(tt-movto-fluxo.parcela)
/*
                WHERE ordens-embarque.cod-estabel = c-estab 
                  AND ordens-embarque.embarque = tt-movto-fluxo.nr-pedcli*/ no-lock: /*Rever*/
                    put stream S_1 ordens-embarque.embarque ";".

                    find FIRST historico-embarque no-lock
                         WHERE historico-embarque.cod-estabel = c-estab 
                           AND historico-embarque.embarque = ordens-embarque.embarque 
                           and historico-embarque.cod-pto-contr = pto-contr.cod-pto-contr NO-ERROR.
                    IF AVAIL historico-embarque THEN
                        put stream S_1  historico-embarque.dt-previsao
                             ";"
                             historico-embarque.dt-ult-prev
                             ";"
                             historico-embarque.dt-efetiva .
                    ELSE
                        put stream S_1  
                             ";"
                             ";".

                    ASSIGN c-nr-pagamento = "".
                    FOR EACH pagamento-invoice NO-LOCK
                       WHERE pagamento-invoice.embarque = ordens-embarque.embarque:
                        
                        IF LOOKUP(STRING(pagamento-invoice.nr-pagamento),c-nr-pagamento,",") <> 0 THEN NEXT.

                        IF c-nr-pagamento = "" THEN
                            ASSIGN c-nr-pagamento = STRING(pagamento-invoice.nr-pagamento).
                        ELSE 
                            ASSIGN c-nr-pagamento = c-nr-pagamento + "," + STRING(pagamento-invoice.nr-pagamento).
                    END.
                    PUT STREAM S_1 UNFORMATTED ";" c-nr-pagamento.
             end.
/*        end.*/

        put stream S_1 skip.
    
    END.

    /* ** Finaliza Geraá∆o da Planilha  ***/
    output stream s_1 close.

END PROCEDURE.


PROCEDURE Pi-Abre-Edit:

     DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
     DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

    get-key-value section "EMS" key "Show-Report-Program" value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = "notepad.exe".
        put-key-value section "EMS" key "Show-Report-Program" value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL "kernel32.dll":
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.
  
END PROCEDURE.
