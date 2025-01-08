/************************************************************************************
** Programa..: esp/acr/upc_acr001.py
** Autor.....: Mario F. Fleith Jr.
** Objetivo..: Saida EPC para dados da Remessa
** Data......: 13/01/2005
** Saida EPC.: programa acr757. fnc_enviar_msg_cobr_edi
** Objetivo..: 1) Enviar numero do titulo/parcela no campo numero da empresa
************************************************************************************/

define temp-table tt_epc no-undo
    field cod_event        as character /** tudo igual **/
    field cod_parameter    as character /** estabelecimento,n£mero do t¡tulo**/
    field val_parameter    as character /** mat,num_id_tit_acr **/
    index id is primary cod_parameter cod_event ascending.

define input        parameter p_ind_event as character no-undo.
define input-output parameter table for tt_epc.

define var v_cod_estab      like tit_acr.cod_estab.
define var v_num_id_tit_acr like tit_acr.num_id_tit_acr.

def buffer bimp_movto_tit_acr for movto_tit_acr.
def buffer bref_movto_tit_acr for movto_tit_acr.

/*** captura dos parametros para acerto numero do titulo ***/
find tt_epc
     where tt_epc.cod_event     = "Envio T¡tulo" 
       and tt_epc.cod_parameter = "Estabelecimento" no-error.
if avail tt_epc 
   then assign v_cod_estab = tt_epc.val_parameter.

find tt_epc
     where tt_epc.cod_event     = "Envio T¡tulo" 
       and tt_epc.cod_parameter = "N£mero do T¡tulo" no-error.
if avail tt_epc 
   then assign v_num_id_tit_acr = int(tt_epc.val_parameter).

/*** atualizacao do campo numero do cedente ****/
find tt_epc
     where tt_epc.cod_event      = "Envio T¡tulo"
       and tt_epc.cod_parameter  = "C¢digo do T¡tulo" no-lock no-error.
if avail tt_epc 
then do:
     find tit_acr 
          where tit_acr.cod_estab      = v_cod_estab 
            and tit_acr.num_id_tit_acr = v_num_id_tit_acr no-lock no-error.
     
     if avail tit_acr 
        then assign tt_epc.val_parameter = substring(tit_acr.cod_espec_docto,1,2) + 
                                           substring(tit_acr.cod_tit_acr,2,6)     + 
                                           substring(tit_acr.cod_parcela,1,2).
end.

/* Tratado como Abatimento via programa f¢rmula
/*****************************************************************************
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 11/02/2010
*****************************************************************************/
/* ** Calcula 4% de desconto para o cliente Angeloni referente ao acordo comercial ***/
DEF BUFFER b_tit_acr     FOR tit_acr.
DEF BUFFER b_val_tit_acr FOR val_tit_acr.
DEF BUFFER b_cliente     FOR emscad.cliente.

DEF VAR v_val_tot_unid   AS DEC  NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

IF p_ind_event <> "Calculo Desconto - Unimed" 
   THEN RETURN "OK".

FIND tt_epc NO-LOCK
    WHERE tt_epc.cod_parameter = "C¢digo do Estabelecimento"
      AND tt_epc.cod_event     = "Calculo Desconto - Unimed" NO-ERROR.
IF NOT AVAIL tt_epc
   THEN RETURN "OK".
ASSIGN v_cod_estab = tt_epc.val_parameter.

FIND tt_epc NO-LOCK
    WHERE tt_epc.cod_parameter = "Num Id Titulo"
      AND tt_epc.cod_event     = "Calculo Desconto - Unimed" NO-ERROR.
IF NOT AVAIL tt_epc
   THEN RETURN "OK".
ASSIGN v_num_id_tit_acr = INT(tt_epc.val_parameter).

FIND b_tit_acr NO-LOCK
    WHERE b_tit_acr.cod_estab      = v_cod_estab
      AND b_tit_acr.num_id_tit_acr = v_num_id_tit_acr NO-ERROR.
IF NOT AVAIL b_tit_acr 
   THEN RETURN "OK".

/* ** Verifica se o cliente pertence ao grupo Angeloni ***/
FIND b_cliente NO-LOCK
    WHERE b_cliente.cod_empresa = v_cod_empres_usuar
      AND b_cliente.cdn_cliente = b_tit_acr.cdn_cliente NO-ERROR.
IF NOT AVAIL b_cliente 
   THEN RETURN "OK".
IF NOT b_cliente.cod_id_feder BEGINS "83646984" 
   THEN RETURN "OK".

/* ** O percentual de desconto somente ser  concedido para a UN TER e COM ***/
IF NOT CAN-FIND(FIRST b_val_tit_acr OF b_tit_acr NO-LOCK
                WHERE b_val_tit_acr.cod_unid_negoc = "TER"
                   OR b_val_tit_acr.cod_unid_negoc = "COM")
   THEN RETURN "OK".

/* ** considerar o valor original, repeitando o valor faturado e calculando proporcional ao saldo ***/
FOR EACH b_val_tit_acr OF b_tit_acr NO-LOCK
    WHERE b_val_tit_acr.cod_unid_negoc = "TER"
       OR b_val_tit_acr.cod_unid_negoc = "COM":
    ASSIGN v_val_tot_unid = v_val_tot_unid + b_val_tit_acr.val_origin_tit_acr.
END.

CREATE tt_epc.
ASSIGN tt_epc.cod_event     = "Calculo Desconto - Unimed"
       tt_epc.cod_parameter = "Desconto"
       tt_epc.val_parameter = string(round(v_val_tot_unid * 0.04, 2)).

RETURN "OK".

/******************************* Main Code End ******************************/
*/
