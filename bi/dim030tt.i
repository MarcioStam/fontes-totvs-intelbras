define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table ttDimRelacionamentoItem no-undo
    field CD_Estabelecimento     like item-fornec-estab.cod-estabel
    field CD_Item                like item-fornec-estab.it-codigo
    field CD_Emitente            like item-fornec-estab.cod-emitente
    field CD_Comprador           like item-uni-estab.cod-comprado
    field NM_Quantidade_Politica like int-item-uni-estab.qtd-pol
    index idx_pri is primary unique CD_Estabelecimento CD_Item CD_Emitente.
