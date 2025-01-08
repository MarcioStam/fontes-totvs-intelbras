/*****************************************************************************
** Programa..............: acr900zi1_epc
** Versao................:  1.00.00.000
** Nome Externo..........: esp/epc/epc_acr900zi.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 25/09/2008
*****************************************************************************/

/********************* Temporary Table Definition Begin *********************/

DEF TEMP-TABLE tt_epc_estrategico NO-UNDO 
    FIELD ttv_cod_epc_event                AS CHARACTER FORMAT "x(12)"
    FIELD ttv_cod_epc_parameters           AS CHARACTER FORMAT "x(32)"
    FIELD ttv_cod_epc_msg                  AS CHARACTER FORMAT "x(54)"
    INDEX tt_id_epc                        IS primary
          ttv_cod_epc_parameters           ASCENDING 
          ttv_cod_epc_event                ASCENDING.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

DEF INPUT PARAM p_cod_evento
    AS CHARACTER 
    FORMAT "x(1)"
    NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE  
    FOR tt_epc_estrategico.

/************************* Parameter Definition End *************************/

IF NOT CONNECTED("mgmov") 
   THEN RETURN "OK".

IF p_cod_evento <> "Item Lote" 
   THEN RETURN "OK".

FIND tt_epc_estrategico NO-LOCK
    WHERE tt_epc_estrategico.ttv_cod_epc_parameters = "recid_item_lote"
      AND tt_epc_estrategico.ttv_cod_epc_event      = "Item Lote" NO-ERROR.
IF NOT AVAIL tt_epc_estrategico
   THEN RETURN "OK".

RUN epc/acr900zi_epc.p (INPUT p_cod_evento,
                        INPUT-OUTPUT TABLE tt_epc_estrategico).

RETURN "OK".

/******************************* Main Code End ******************************/
