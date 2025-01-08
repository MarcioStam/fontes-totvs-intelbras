/**
 * Extrator para BI
 * Fato: Telefonia
 *
 * Autor: Cleto May                                                                           
 */
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact009tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactTelefonia.
define output parameter table for tt-erro.

find first tt-param.

for each fatura-equipamento no-lock
   where fatura-equipamento.mes-ref >= string(year(tt-param.dt-inicial),"9999") + string(month(tt-param.dt-inicial),"99")
   and fatura-equipamento.mes-ref <= string(year(tt-param.dt-final),"9999") + string(month(tt-param.dt-final),"99"):

   if not can-find (first telefonia no-lock
                    where telefonia.cod-estabel = fatura-equipamento.cod-estabel 
                      and telefonia.nr-fatura = fatura-equipamento.nr-fatura 
                      and telefonia.equipamento = fatura-equipamento.equipamento
                      and telefonia.fornecedor = fatura-equipamento.fornecedor
                      and telefonia.mes-ref = fatura-equipamento.mes-ref) then do:
      create ttFactTelefonia.
      assign ttFactTelefonia.CD_Estabelecimento = trim(fatura-equipamento.cod-estabel)
             ttFactTelefonia.CD_Fornecedor      = fatura-equipamento.fornecedor
             ttFactTelefonia.CD_Fatura          = trim(fatura-equipamento.nr-fatura)
             ttFactTelefonia.CD_Equipamento     = trim(fatura-equipamento.equipamento)
             ttFactTelefonia.DT_Periodo         = date(int(substring(fatura-equipamento.mes-ref,5,2)),01,int(substring(fatura-equipamento.mes-ref,1,4)))
             ttFactTelefonia.NM_Valor           = fatura-equipamento.val-fatura
             ttFactTelefonia.DT_Ligacao         = date(int(substring(fatura-equipamento.mes-ref,5,2)),01,int(substring(fatura-equipamento.mes-ref,1,4)))
             ttFactTelefonia.HR_Ligacao         = "00:00:00".
   end.
   else do:
      for each telefonia no-lock
         where telefonia.cod-estabel = fatura-equipamento.cod-estabel 
           and telefonia.nr-fatura = fatura-equipamento.nr-fatura 
           and telefonia.equipamento = fatura-equipamento.equipamento
           and telefonia.fornecedor = fatura-equipamento.fornecedor
           and telefonia.mes-ref = fatura-equipamento.mes-ref,
         first equipamentos of telefonia no-lock:



         create ttFactTelefonia.
         assign ttFactTelefonia.CD_Estabelecimento = trim(telefonia.cod-estabel)
                ttFactTelefonia.CD_Fornecedor      = telefonia.fornecedor
                ttFactTelefonia.CD_Fatura          = trim(telefonia.nr-fatura)
                ttFactTelefonia.CD_Servico         = trim(telefonia.servico)
                ttFactTelefonia.CD_Plano           = trim(telefonia.plano)
                ttFactTelefonia.CD_Equipamento     = trim(telefonia.equipamento)
                ttFactTelefonia.CD_Numero          = trim(telefonia.numero)
                ttFactTelefonia.DT_Periodo         = date(int(substring(telefonia.mes-ref,5,2)),01,int(substring(telefonia.mes-ref,1,4)))
                ttFactTelefonia.NM_Valor           = telefonia.valor.
                 
         if NUM-ENTRIES(telefonia.duracao,":") = 3 and (equipamentos.tipo <> 3 and equipamentos.tipo <> 4) then
            assign ttFactTelefonia.NM_Duracao = (int(entry(1,telefonia.duracao,':')) * 60 * 60) + (int(entry(2,telefonia.duracao,':')) * 60) + int(entry(3,telefonia.duracao,':')).

         if telefonia.data = ? then
            assign ttFactTelefonia.DT_Ligacao = date(int(substring(telefonia.mes-ref,5,2)),01,int(substring(telefonia.mes-ref,1,4)))
                   ttFactTelefonia.HR_Ligacao = "00:00:00".
         else 
            assign ttFactTelefonia.DT_Ligacao = telefonia.data
                   ttFactTelefonia.HR_Ligacao = telefonia.hora.
      end.
   end.
end.
