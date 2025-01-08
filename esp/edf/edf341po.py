/*****************************************************************************
** Programa..............: Finalidade Dep¢sito Poupan‡a
** Versao................:  1.00.00.000
** Nome Externo..........: esp/edf/edf341po.py
** Data Geracao..........: 08/03/2013
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

/****************************** Main Code Begin *****************************/

/* ** Finalidade Poupan‡a ***/
if  p_cdn_segment_edi = 309 
and p_cdn_element_edi = 6218 
then do:

     find tt_param_program_formul no-lock
        where tt_param_program_formul.tta_cdn_segment_edi = 289 
          and tt_param_program_formul.tta_cdn_element_edi = 3928 no-error.

     if entry(3, tt_param_program_formul.ttv_des_contdo, ';') = "N" /*l_n*/   
     then do:
          find first item_bord_ap no-lock
               where item_bord_ap.cod_estab_bord      =     entry(1, tt_param_program_formul.ttv_des_contdo, ';')
                 and item_bord_ap.num_id_item_bord_ap = int(entry(2, tt_param_program_formul.ttv_des_contdo, ';')) no-error.
      end.
      else do:
           find first item_bord_ap_agrup no-lock
                where item_bord_ap_agrup.cod_estab_bord            =      entry(1, tt_param_program_formul.ttv_des_contdo, ';')
                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2, tt_param_program_formul.ttv_des_contdo, ';')) no-error.
           if avail item_bord_ap_agrup 
           then do:
                find first item_bord_ap no-lock
                     where item_bord_ap.cod_estab_bord            = item_bord_ap_agrup.cod_estab_bord
                       and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap no-error.
           end.
      end.

      if avail item_bord_ap
      and item_bord_ap.cod_forma_pagto = '25'
          then return '11'.
          else return ''.

end.

return ''.

/******************************* Main Code End ******************************/
