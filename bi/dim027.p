/**
 * Extrator para BI
 * Dimens∆o: Equipamentos
 *
 * Autor: Cleto May
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttEquipamento
&scoped-define ARQUIVO_TXT DimEquipamento

{bi/esbi000.i}
{include/i-freeac.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}

/**
 * Leitura do XML
 */
define variable c-xml as character no-undo.
assign c-xml = entry(2,session:parameter).
file-info:file-name = c-xml.
if (index(file-info:file-type, 'f') = 0) then
   leave.
{bi/esbi001.i c-xml}

/** Valida diret¢rio de sa°da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.


/**
 * Regra de neg¢cio a partir daqui
 */
def temp-table ttEquipamento no-undo                    
   field CD_Estabelecimento like equipamentos.cod-estabel
   field CD_Equipamento     like equipamentos.equipamento
   field CD_Conta           like equipamentos.ct-codigo
   field CD_Usuario         like equipamentos.cod-usuario
   field CD_Gestor          like equipamentos.gestor-cobranca
   field CD_Utilizacao      like equipamentos.ind-utiliz
   field CD_Situacao        like equipamentos.ind-situacao
   field CD_Cobranca        like equipamentos.ind-cobranca
   field TX_Utilizacao      as character
   field TX_Situacao        as character
   field TX_Cobranca        as character
   field TX_Equipamento     like equipamentos.descricao     
   field TX_Tipo            like tipo-equipamentos.descricao
   field TX_Conta           as character.

/******************************************************************************************/


run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
EMPTY TEMP-TABLE tt_log_erro.

for each equipamentos no-lock,
   first tipo-equipamentos no-lock
   where tipo-equipamentos.codigo = equipamentos.tipo,
   first fornec-equipamentos no-lock
   where fornec-equipamentos.fornecedor = equipamentos.fornecedor:

    ASSIGN v_cod_conta = equipamentos.ct-codigo.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl
                                            (input        i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                             input        "",                       /* PLANO DE CONTAS */
                                             input-output v_cod_conta,              /* CONTA */
                                             input        TODAY,                    /* DATA TRANSACAO */   
                                             output       v_des_titulo_conta,       /* DESCRICAO CONTA */
                                             output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                             output       v_num_sit_cta_ctbl,       /* SITUAÄ«O DA CONTA */
                                             output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                             output table tt_log_erro).             /* ERROS */
    create ttEquipamento.
    assign ttEquipamento.CD_Estabelecimento = equipamentos.cod-estabel
           ttEquipamento.CD_Equipamento     = equipamentos.equipamento
           ttEquipamento.TX_Equipamento     = equipamentos.descricao
           ttEquipamento.CD_Conta           = equipamentos.ct-codigo
           ttEquipamento.CD_Gestor          = (if equipamentos.gestor-cobranca  = 0 then ? else equipamentos.gestor-cobranca)
           ttEquipamento.CD_Utilizacao      = equipamentos.ind-utiliz
           ttEquipamento.CD_Situacao        = equipamentos.ind-situacao
           ttEquipamento.CD_Cobranca        = equipamentos.ind-cobranca
           ttEquipamento.TX_Utilizacao      = (if equipamentos.ind-utiliz   = 1 then 'Celular' else if equipamentos.ind-utiliz = 2 then 'Chip' else if equipamentos.ind-utiliz = 0 then 'Ambos' else 'N∆o encontrado')
           ttEquipamento.TX_Situacao        = (if equipamentos.ind-situacao = 0 then 'Ativo' else if equipamentos.ind-situacao = 1 then 'Bloqueado' else if equipamentos.ind-situacao = 2 then 'Cancelado' else 'N∆o encontrado')
           ttEquipamento.TX_Cobranca        = (if equipamentos.ind-cobranca = 0 then "Nenhum" else if equipamentos.ind-cobranca = 1 then "Tarifador" else if equipamentos.ind-cobranca = 2 then "Excel" else "N∆o encontrador")    
           ttEquipamento.CD_Usuario         = (if equipamentos.cod-usuario  = 0 then ? else equipamentos.cod-usuario)
           ttEquipamento.TX_Equipamento     = equipamentos.descricao
           ttEquipamento.TX_Conta           = v_des_titulo_conta
           ttEquipamento.TX_Tipo            = tipo-equipamentos.descricao.
end.

if valid-handle(h_api_cta_ctbl) 
then
    delete object h_api_cta_ctbl.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
