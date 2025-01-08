/*****************************************************************************
** Programa..............: epc_acr726zm
** Versao................:  1.00.00.000
** Nome Externo..........: esp/epc/acr726zm_epc.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 08/10/2009
*****************************************************************************/

/********************* Temporary Table Definition Begin *********************/

define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_cod_evento
    as character
    format "x(1)"
    no-undo.
def input-output param table 
    for tt_epc.

/************************* Parameter Definition End *************************/

/****************************** Main Code Begin *****************************/

DEF BUFFER b_item_lote_liquidac_acr FOR item_lote_liquidac_acr.
DEF BUFFER b_portador               FOR emscad.portador.

IF p_cod_evento <> "Calculo Juros"
   THEN RETURN "OK".

FIND tt_epc NO-LOCK
    WHERE tt_epc.cod_event     = "Calculo Juros"
      AND tt_epc.cod_parameter = "Registro" NO-ERROR.
IF NOT AVAIL tt_epc
   THEN RETURN "OK".

FIND b_item_lote_liquidac_acr NO-LOCK
    WHERE RECID(b_item_lote_liquidac_acr) = INT64(tt_epc.val_parameter) NO-ERROR.
IF NOT AVAIL b_item_lote_liquidac_acr
   THEN RETURN "OK".

FIND b_portador NO-LOCK
    WHERE b_portador.cod_portador = b_item_lote_liquidac_acr.cod_portador NO-ERROR.
IF NOT AVAIL b_portador
OR b_portador.ind_tip_portad <> "Administradora" 
   THEN RETURN "OK".

FIND tt_epc NO-LOCK
    WHERE tt_epc.cod_event     = "Calculo Juros"
      AND tt_epc.cod_parameter = "Juros" NO-ERROR.
IF NOT AVAIL tt_epc 
THEN DO:
     CREATE tt_epc.
     ASSIGN tt_epc.cod_event     = "Calculo Juros"
            tt_epc.cod_parameter = "Juros".
END.

ASSIGN tt_epc.val_parameter = string("0") /* ** Retorna 0 para portador igual a administradora ***/.

RETURN "OK".

/******************************* Main Code End ******************************/

