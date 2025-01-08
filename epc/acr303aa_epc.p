/*****************************************************************************
** Programa: epc\acr303aa_epc.p - rpt_tit_acr_em_aberto
** VersÆo..: 1.00
** Data....: 26/01/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: EPC para fazer a chamada da valida‡Æo da faixa Grupo de Cobran‡a
*****************************************************************************/

/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID              NO-UNDO.

/*--- Defini‡Æo das Vari veis Globais ---*/
DEFINE VARIABLE g-cod-grp-cobr-ini-acr303za  AS INTEGER        NO-UNDO.
DEFINE VARIABLE g-cod-grp-cobr-fim-acr303za  AS INTEGER        NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

/*--- Bloco Principal ---*/
IF  p-ind-event = "VALIDA TITULO" THEN DO:

    IF NOT AVAIL dwb_rpt_param 
       THEN FIND dwb_rpt_param NO-LOCK
               WHERE dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                 AND dwb_rpt_param.cod_dwb_program = "rel_tit_acr_em_aber" NO-ERROR.
    IF NUM-ENTRIES(dwb_rpt_param.cod_livre_1, CHR(10)) > 1 
       THEN ASSIGN g-cod-grp-cobr-ini-acr303za = INT(ENTRY(1, dwb_rpt_param.cod_livre_1, CHR(10)))
                   g-cod-grp-cobr-fim-acr303za = INT(ENTRY(2, dwb_rpt_param.cod_livre_1, CHR(10))).


    RUN epc/epc_valida_titulo.p (INPUT p-rec-table,
                                 INPUT g-cod-grp-cobr-ini-acr303za,
                                 INPUT g-cod-grp-cobr-fim-acr303za).
    RETURN RETURN-VALUE.

END.

