/* ** EPC para criar arquivo vendor bradesco com dois header - edu718zd ***/

/*****************************************************************************
** Nome Externo..........: esp/edf/edf237zd.p
** Versao................:  1.00.00.000
** Data Cria‡Æo..........: 02/10/2008
** Autor.................: Fabiano Zarpe Henke
*****************************************************************************/

/********************* Temporary Table Definition Begin *********************/

def shared temp-table tt_mapeamento_edi no-undo
    field tta_cdn_proces_edi               as Integer format ">>>>>>>9" initial 0 label "Processo" column-label "Processo"
    field tta_hra_inic_ativid_edi          as Character format "99:99:99" initial "00:00:00" label "Hora Inicio" column-label "Hora Inicio"
    field tta_hra_fim_ativid_edi           as Character format "99:99:99" initial "00:00:00" label "Hora Fim" column-label "Hora Fim"
    index tt_id                            is primary unique
          tta_cdn_proces_edi               ascending
    .

define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def input param p_cod_event  as char  no-undo.
def input-output param table for tt_epc.

/************************* Parameter Definition End *************************/

/************************* Variable Definition Begin ************************/

def buffer b_proces_edi for proces_edi.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def var v_dsl_dados_edi_9999
    as Character
    format "x(15000)":U
    no-undo.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/

disable triggers for load of reg_proces_saida_edi.

main_block:
do on endkey undo main_block, leave main_block
                on error undo main_block, leave main_block.

    IF p_cod_event = 'before_record' 
    THEN DO:

         FIND tt_mapeamento_edi NO-LOCK NO-ERROR.
         IF NOT AVAIL tt_mapeamento_edi 
            THEN RETURN "OK".

         FIND b_proces_edi NO-LOCK
             WHERE b_proces_edi.cdn_proces_edi = tt_mapeamento_edi.tta_cdn_proces_edi NO-ERROR.
         IF NOT AVAIL b_proces_edi 
            THEN RETURN "OK".

         IF b_proces_edi.cdn_mapa_dest_edi <> 200019
         OR b_proces_edi.cdn_parcei_edi    <> 200237
         OR b_proces_edi.cdn_trans_edi     <> 1300
            THEN RETURN "OK".

         FIND tt_epc
             WHERE tt_epc.cod_event     = 'before_record'
               AND tt_epc.cod_parameter = 'cdn_segment_edi'
               AND (tt_epc.val_parameter = "1" /*Header Lote*/ OR
                    tt_epc.val_parameter = "5" /*Trailler Lote*/) NO-ERROR.
         IF NOT AVAIL tt_epc 
            THEN RETURN "OK".

        IF tt_epc.val_parameter = "1" 
        THEN DO:

             FIND tt_epc
                 WHERE tt_epc.cod_event     = 'before_record'
                   AND tt_epc.cod_parameter = 'dsl_dados_edi' NO-ERROR.
             IF NOT AVAIL tt_epc 
                THEN RETURN "OK".

             ASSIGN v_dsl_dados_edi_9999 = "23700000         2" + SUBSTRING(tt_epc.val_parameter, 19, 84) + "BRADESCO                                1" + 
                                           REPLACE(STRING(TODAY, "99/99/9999"), "/", "") + REPLACE(STRING(TIME,"hh:mm:ss"),":","") + 
                                           SUBSTRING(tt_epc.val_parameter, 105, 6) + "06001600" + FILL(" ",69).
             CREATE reg_proces_saida_edi.
             ASSIGN reg_proces_saida_edi.cdn_proces_edi             = b_proces_edi.cdn_proces_edi
                    reg_proces_saida_edi.cdn_seq_reg_proces_edi     = 0 /*-1*/
                    reg_proces_saida_edi.dsl_dados_saida_edi        = v_dsl_dados_edi_9999
                    reg_proces_saida_edi.cod_usuar_ult_atualiz      = v_cod_usuar_corren
                    reg_proces_saida_edi.dat_ult_atualiz            = TODAY 
                    reg_proces_saida_edi.hra_ult_atualiz            = REPLACE(STRING(TIME,"hh:mm:ss"),":","").

        END.

        IF tt_epc.val_parameter = "5" 
        THEN DO:

             FIND tt_epc
                 WHERE tt_epc.cod_event     = 'before_record'
                   AND tt_epc.cod_parameter = 'dsl_dados_edi' NO-ERROR.
             IF NOT AVAIL tt_epc 
                THEN RETURN "OK".

             ASSIGN v_dsl_dados_edi_9999 = "23799999         000001" + STRING((INT(SUBSTRING(tt_epc.val_parameter, 18, 6)) + 1), "999999") + "000001" + FILL(" ",205).
             CREATE reg_proces_saida_edi.
             ASSIGN reg_proces_saida_edi.cdn_proces_edi             = b_proces_edi.cdn_proces_edi
                    reg_proces_saida_edi.cdn_seq_reg_proces_edi     = 10000
                    reg_proces_saida_edi.dsl_dados_saida_edi        = v_dsl_dados_edi_9999
                    reg_proces_saida_edi.cod_usuar_ult_atualiz      = v_cod_usuar_corren
                    reg_proces_saida_edi.dat_ult_atualiz            = TODAY 
                    reg_proces_saida_edi.hra_ult_atualiz            = REPLACE(STRING(TIME,"hh:mm:ss"),":","").

        END.

    END.

    RETURN 'OK'.

end.

/******************************* Main Code End ******************************/
