/*****************************************************************************
** Nome Externo..........: esp/edf/edf237.p
** Versao................:  1.00.00.000
** Data Cria‡Æo..........: 02/10/2008
** Autor.................: Fabiano Zarpe Henke
*****************************************************************************/

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
DEF VAR v_cont AS INT NO-UNDO.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/

IF  p_cdn_segment_edi = 5
AND p_cdn_element_edi = 5 THEN DO:
    FIND LAST proces_edi NO-LOCK NO-ERROR.
    FOR EACH reg_proces_saida_edi NO-LOCK
        WHERE reg_proces_saida_edi.cdn_proces_edi = proces_edi.cdn_proces_edi:
        ASSIGN v_cont = v_cont + 1.
    END.
    ASSIGN v_cont = v_cont + 1.
    RETURN string(v_cont).
END.

/******************************* Main Code End ******************************/
