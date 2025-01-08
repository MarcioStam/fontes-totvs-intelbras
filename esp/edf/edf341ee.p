/*********************************************************************************
** Programa..............: Valor Abatimento - Angeloni
** Versao................:  1.00.00.000
** Nome Externo..........: esp/edf/edf341ee.p
** Data Geracao..........: 31/03/2010
** Descri‡Æo.............: Calcula 4% de Abatimento referente ao acordo comercial
*********************************************************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_param_program_formul no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field tta_cdn_element_edi              as Integer format ">>>>>9" initial 0 label "Elemento" column-label "Elemento"
    field tta_des_label_utiliz_formul_edi  as character format "x(10)" label "Label Utiliz Formula" column-label "Label Utiliz Formula"
    field ttv_des_contdo                   as character format "x(100)" label "Conteudo" column-label "Conteudo"
    index tt_param_program_formul_id       is primary
          tta_cdn_segment_edi              ascending
          tta_cdn_element_edi              ascending.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_cdn_mapa_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_segment_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_element_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param table 
    for tt_param_program_formul.

/************************* Parameter Definition End *************************/

/************************* Variable Definition Begin ************************/

DEF VAR v_val_tot_unid   AS DEC  NO-UNDO.
DEF VAR v_val_abat_exist AS DEC  NO-UNDO.
DEF VAR v_cod_chave_tit  AS CHAR NO-UNDO.

/************************** Variable Definition End *************************/

/****************************** Main Code Begin *****************************/

/* ** Localiza Valor de Abatimento j  existente ***/
FIND tt_param_program_formul
   WHERE tt_param_program_formul.tta_cdn_segment_edi = 292
     AND tt_param_program_formul.tta_cdn_element_edi = 4425 NO-ERROR.    
ASSIGN v_val_abat_exist = DEC(tt_param_program_formul.ttv_des_contdo).

/* Chamado: 141199 - retirar tratamento abatimento da verba do Angeloni

/*** ID Federal - Somente cliente Angeloni ***/
FIND tt_param_program_formul
    WHERE tt_param_program_formul.tta_cdn_segment_edi = 292
      AND tt_param_program_formul.tta_cdn_element_edi = 84 NO-ERROR.    
IF STRING(tt_param_program_formul.ttv_des_contdo) BEGINS "83646984" 
THEN DO:
     
     /* ** Seu N£mero - Tratar se ‚ ocorrˆncia de implanta‡Æo ***/
     FIND tt_param_program_formul
         WHERE tt_param_program_formul.tta_cdn_segment_edi = 292
           AND tt_param_program_formul.tta_cdn_element_edi = 3928 NO-ERROR.    
     ASSIGN v_cod_chave_tit = STRING(tt_param_program_formul.ttv_des_contdo).

     FIND movto_ocor_bcia NO-LOCK 
         WHERE movto_ocor_bcia.cod_estab              =     ENTRY(1, v_cod_chave_tit, ";")
           AND movto_ocor_bcia.num_id_movto_ocor_bcia = INT(ENTRY(3, v_cod_chave_tit, ";")) NO-ERROR.
     IF  AVAIL movto_ocor_bcia
     AND movto_ocor_bcia.ind_tip_ocor_bcia = "Implanta‡Æo" 
     THEN DO:

          FIND movto_tit_acr NO-LOCK 
              WHERE movto_tit_acr.cod_estab            =     ENTRY(1, v_cod_chave_tit, ";")
                AND movto_tit_acr.num_id_movto_tit_acr = INT(ENTRY(2, v_cod_chave_tit, ";")) NO-ERROR.
          IF AVAIL movto_tit_acr 
          THEN DO:
   
               /* ** Considerar o valor original, repeitando o valor faturado e calculando proporcional ao saldo ***/
               ASSIGN v_val_tot_unid = 0.
               FOR EACH val_tit_acr NO-LOCK
                   WHERE val_tit_acr.cod_estab        = movto_tit_acr.cod_estab
                     AND val_tit_acr.num_id_tit_acr   = movto_tit_acr.num_id_tit_acr
                     AND val_tit_acr.cod_finalid_econ = "Corrente"
                     AND (val_tit_acr.cod_unid_negoc  = "TER"
                      OR val_tit_acr.cod_unid_negoc   = "COM"):
                   ASSIGN v_val_tot_unid = v_val_tot_unid + val_tit_acr.val_origin_tit_acr.
               END.
               
               IF v_val_tot_unid > 0
                  THEN RETURN STRING((ROUND(v_val_tot_unid * 0.04, 2) * 100) + v_val_abat_exist, "9999999999999").

          END.
     END.
END.
*/

RETURN STRING(v_val_abat_exist, "9999999999999").
