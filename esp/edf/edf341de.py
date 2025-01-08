/*****************************************************************************
** Programa..............: Data de Desconto
** Versao................:  1.00.00.000
** Nome Externo..........: esp/edf/edf341de.py
** Data Geracao..........: 03/03/2010
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

def var v_return   as char no-undo.
def var v_val_desc as dec  no-undo.

/************************** Variable Definition End *************************/

/****************************** Main Code Begin *****************************/

/* --- Instru‡Æo Bancaria ---*/
find tt_param_program_formul
    where tt_param_program_formul.tta_cdn_segment_edi = 292
      and tt_param_program_formul.tta_cdn_element_edi = 3705 no-error. /* Data Desconto   */
assign v_return = "000000".

find tt_param_program_formul
    where tt_param_program_formul.tta_cdn_segment_edi = 292
      and tt_param_program_formul.tta_cdn_element_edi = 4423 no-error. /* Valor Desconto  */
assign v_val_desc = dec(tt_param_program_formul.ttv_des_contdo) no-error.

if v_val_desc <> 0
then do:
     find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 292
           and tt_param_program_formul.tta_cdn_element_edi = 3606 no-error. /* Data Vencimento */
     assign v_return = string(date(tt_param_program_formul.ttv_des_contdo), "999999").
end.

return v_return.

/******************************* Main Code End ******************************/
