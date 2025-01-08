/**
 * Extrator para BI
 * DimensÆo: Atendente Resumo
 *
 * Autor: Cleto May
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/dim031tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttDimAtendenteResumo.

for each crm-atendente no-lock:
   find FIRST atendente NO-LOCK
      where atendente.cd-oper = crm-atendente.cd-atend no-error.

   if not available (atendente) then do:
      run createError("Atendente " + string(crm-atendente.cd-atend) + " nÆo encontrado - " + crm-atendente.cod-estabel + ', ' + string(crm-atendente.cod-rep) + ', ' + crm-atendente.cd-unid-negoc).
      next.
   end.      
   
   if not can-find (ttDimAtendenteResumo 
                       where ttDimAtendenteResumo.CD_Estabelecimento   = crm-atendente.cod-estabel
                         and ttDimAtendenteResumo.CD_Representante     = crm-atendente.cod-rep
                         and ttDimAtendenteResumo.CD_Unidade_Comercial = crm-atendente.cd-unid-negoc
                         and ttDimAtendenteResumo.CD_Grupo_Cliente     = crm-atendente.cod-gr-cli) then do:
      create ttDimAtendenteResumo.
      assign ttDimAtendenteResumo.CD_Estabelecimento   = crm-atendente.cod-estabel
             ttDimAtendenteResumo.CD_Representante     = crm-atendente.cod-rep
             ttDimAtendenteResumo.CD_Unidade_Comercial = crm-atendente.cd-unid-negoc
             ttDimAtendenteResumo.CD_Grupo_Cliente     = crm-atendente.cod-gr-cli
             ttDimAtendenteResumo.CD_Atendente         = crm-atendente.cd-atend
             ttDimAtendenteResumo.TX_Atendente         = atendente.nm-oper.
   end.
end.                                                                       
