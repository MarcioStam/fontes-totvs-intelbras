define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table ttDimAtendenteResumo no-undo
   field CD_Estabelecimento     like crm-atendente.cod-estabel
   field CD_Unidade_Comercial   like crm-atendente.cd-unid-negoc
   field CD_Representante       like crm-atendente.cod-rep
   field CD_Grupo_Cliente       like crm-atendente.cod-gr-cli
   field CD_Atendente           like crm-atendente.cd-atend
   field TX_Atendente           like atendente.nm-oper
   index idx is primary unique CD_Estabelecimento CD_Unidade_Comercial CD_Representante CD_Grupo_Cliente.
