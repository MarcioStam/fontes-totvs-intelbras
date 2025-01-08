/***********************************************************************
**  Programa..: upc\btb910za-upc.i
**  Autor.....: Giovane Alves
**  Data......: Dezembro/2007 - Desenvolvimento
**  Descricao.: Inclua esta include em todos os programas que 
**              necessitarem do c¢digo do estabelecimento
**  Versão....: 001 - 06/12/2007    Desenvolvimento Programa
**              002 - 23/08/2013 - Hoepers - Utilzar nova vari vel global do estabelecimento, padrÆo TOTVS 11 
************************************************************************/

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR v2_cod_estab_usuar AS CHARACTER NO-UNDO.

DEFINE VARIABLE v_cod_conta             AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_des_titulo_conta      AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl      AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl      AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_cod_ccusto            AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_des_titulo_ccusto     AS CHARACTER NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl          AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_api_ccusto            AS HANDLE    NO-UNDO.
DEFINE VARIABLE p_log_ccusto            AS LOG       NO-UNDO.
DEFINE VARIABLE v_cod_format_cta_ctbl   AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_cod_format_ccusto     AS CHARACTER NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistˆncia".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_plano_ccusto             as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo                   as character format "x(40)"
    index tt_id                           
          ttv_cod_empresa                  ascending
          ttv_cod_plano_ccusto             ascending
          ttv_cod_ccusto                   ascending.

