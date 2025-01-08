/**************************************************************************************************
** Descricao.............: Gera tipo de opera‡Æo Vendor Santander - Segmento K - posi‡äes 204 - 208
** Nome Externo..........: esp/edf/edf008ve.p
** Autor.................: Fabiano Zarpe Henke
** Data Geracao..........: 30/09/2008
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

DEF VAR v_tipo_iof AS CHAR NO-UNDO.
DEF VAR v_taxa_cli AS CHAR NO-UNDO.
DEF VAR v_taxa_emp AS CHAR NO-UNDO.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/

/* ** Mapa Vendor Santander - Segmento K - Elemento Caracter¡stica Opera‡Æo ***/
IF  p_cdn_mapa_edi    = 200026
AND p_cdn_segment_edi = 3
AND p_cdn_element_edi = 25 
THEN DO:

    ASSIGN v_tipo_iof = "".
           v_taxa_cli = "0".
           v_taxa_emp = "0".

    /* ** Tipo IOF ***/
    /* ** 2 - Empresa ***/
    /* ** 1 - Cliente ***/
    FIND tt_param_program_formul
        WHERE tt_param_program_formul.tta_cdn_segment_edi = 2
          AND tt_param_program_formul.tta_cdn_element_edi = 14 NO-ERROR.
    IF AVAIL tt_param_program_formul 
       THEN ASSIGN v_tipo_iof = tt_param_program_formul.ttv_des_contdo.
    
    /* ** Taxa Cliente ***/
    FIND tt_param_program_formul
        WHERE tt_param_program_formul.tta_cdn_segment_edi = 2
          AND tt_param_program_formul.tta_cdn_element_edi = 17 NO-ERROR.
    IF AVAIL tt_param_program_formul 
       THEN ASSIGN v_taxa_cli = tt_param_program_formul.ttv_des_contdo.
    
    /* ** Taxa Banco ***/
    FIND tt_param_program_formul
        WHERE tt_param_program_formul.tta_cdn_segment_edi = 2
          AND tt_param_program_formul.tta_cdn_element_edi = 16 NO-ERROR.
    IF AVAIL tt_param_program_formul 
       THEN ASSIGN v_taxa_emp = tt_param_program_formul.ttv_des_contdo.

    /* ** IOFE / EQ ATO / BCO ***/
    IF  v_tipo_iof      = "02"
    AND DEC(v_taxa_cli) < DEC(v_taxa_emp) 
        THEN RETURN "00003".
    
    /* ** IOFC / EQ ATO / BCO ***/
    IF  v_tipo_iof      = "01"
    AND DEC(v_taxa_cli) < DEC(v_taxa_emp) 
        THEN RETURN "00004".
    
    /* ** IOFE / EQ ATO / CLI ***/
    IF  v_tipo_iof      = "02"
    AND DEC(v_taxa_cli) > DEC(v_taxa_emp) 
        THEN RETURN "00005".
    
    /* ** IOFC / EQ ATO / CLI ***/
    IF  v_tipo_iof      = "01"
    AND DEC(v_taxa_cli) > DEC(v_taxa_emp) 
        THEN RETURN "00006".
    
    /* ** IOFE / EQ ATO / BCO = CLI ***/
    IF  v_tipo_iof      = "02"
    AND DEC(v_taxa_cli) = DEC(v_taxa_emp) 
        THEN RETURN "00011".
    
    /* ** IOFC / EQ ATO / BCO = CLI ***/
    IF  v_tipo_iof      = "01"
    AND DEC(v_taxa_cli) = DEC(v_taxa_emp) 
        THEN RETURN "00012".

    RETURN "99999".

END.

/******************************* Main Code End ******************************/
