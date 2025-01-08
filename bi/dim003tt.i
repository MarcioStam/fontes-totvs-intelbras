define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table ttDimItem no-undo
   field CD_Item              like item.it-codigo
   field TX_Item              like item.desc-item
   field CD_Grupo_Estoque     like item.ge-codigo
   field TX_Grupo_Estoque     like grup-estoq.descricao
   field CD_Familia_Comercial like item.fm-cod-com
   field TX_Unidade           like fam-com-item.descricao
   field TX_Segmento          like fam-com-item.descricao
   field TX_Familia           like fam-com-item.descricao
   field TX_Subfamilia        like fam-com-item.descricao
   field TX_Origem            like fam-com-item.descricao
   field CD_Unidade_Medida    like item.un
   field TX_Unidade_Medida    like tab-unidade.descricao
   field CD_Tipo_Controle     as char
   field CD_Unidade_Negocio   like item-uni-estab.cod-unid-neg
   field CD_Segmento          as character
   field CD_Familia           as character
   field CD_Subfamilia        as character
   FIELD CD_EAN               AS DEC DECIMALS 0
   index idx_pri is primary unique CD_Item.
