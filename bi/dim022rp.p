/**
 * Extrator para BI
 * DimensÆo: Emitente
 *
 * Autor: Felipe Braun Azambuja
 * Altera‡äes: Cleto May
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/dim022tt.i}

define input  parameter table for tt-param.
define output parameter table for ttDimRelacionamentoCliente.

for each crm-relacionamento-cliente no-lock,
   first crm-categoria no-lock
      where crm-categoria.cd-categoria = crm-relacionamento-cliente.cd-categoria,
   first unid-comerc no-lock
      where unid-comerc.cd-unid-comerc = int(crm-relacionamento-cliente.cd-unid-negoc)
   by crm-relacionamento-cliente.cod-emitente
   by crm-relacionamento-cliente.seq desc:

   find ttDimRelacionamentoCliente
      where ttDimRelacionamentoCliente.CD_Representante     = crm-relacionamento-cliente.cod-rep
        and ttDimRelacionamentoCliente.CD_Emitente          = crm-relacionamento-cliente.cod-emitente
        and ttDimRelacionamentoCliente.CD_Unidade_Comercial = unid-comerc.cd-unid-comerc
        and ttDimRelacionamentoCliente.CD_Categoria         = crm-categoria.cd-categ
        and ttDimRelacionamentoCliente.DT_Inicial           = crm-relacionamento-cliente.dt-vigencia-ini
        and ttDimRelacionamentoCliente.DT_Final             = crm-relacionamento-cliente.dt-vigencia-fim no-error.

   if not available (ttDimRelacionamentoCliente) then do:
      find first gerente
          where gerente.cod-gerente = crm-relacionamento-cliente.cod-gerente no-lock no-error.

      create ttDimRelacionamentoCliente.
      assign ttDimRelacionamentoCliente.CD_Representante     = crm-relacionamento-cliente.cod-rep
             ttDimRelacionamentoCliente.CD_Emitente          = crm-relacionamento-cliente.cod-emitente
             ttDimRelacionamentoCliente.CD_Unidade_Comercial = unid-comerc.cd-unid-comerc
             ttDimRelacionamentoCliente.CD_Categoria         = crm-categoria.cd-categ
             ttDimRelacionamentoCliente.TX_Categoria         = crm-categoria.ds-categ
             ttDimRelacionamentoCliente.CD_Gerente           = crm-relacionamento-cliente.cod-gerente
             ttDimRelacionamentoCliente.DT_Inicial           = crm-relacionamento-cliente.dt-vigencia-ini
             ttDimRelacionamentoCliente.DT_Final             = crm-relacionamento-cliente.dt-vigencia-fim
             ttDimRelacionamentoCliente.TX_Gerente           = if available gerente then gerente.nome else "":U.
   end.
end.
