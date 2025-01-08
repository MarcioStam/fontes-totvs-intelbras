define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table ttDimRelacionamentoCliente no-undo
   field CD_Representante     like repres.cod-rep
   field CD_Emitente          like emitente.cod-emitente
   field CD_Unidade_Comercial like unid-comerc.cd-unid-comerc
   field CD_Categoria         like crm-categoria.cd-categ
   field TX_Categoria         like crm-categoria.ds-categ
   field CD_Gerente           like crm-relacionamento-cliente.cod-gerente
   field TX_Gerente           like gerente.nome
   field DT_Inicial           like crm-relacionamento-cliente.dt-vigencia-ini
   field DT_Final             like crm-relacionamento-cliente.dt-vigencia-fim
   index idx_pri is primary unique CD_Representante CD_Emitente CD_Unidade_Comercial CD_Categoria DT_Inicial DT_Final.
