define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table tt-unid no-undo
   field cod_unid_negoc as character format 'x(3)'
   field perc-unid-neg  as decimal   format '>>9.9999'
   index idx_pri is primary unique cod_unid_negoc.

define temp-table ttFactCotaRepresentante no-undo
   field CD_Estabelecimento   like cota-representante.cod-estabel
   field CD_Representante     like cota-representante.cod-rep
   field CD_Familia_Comercial like cota-representante.fm-cod-com
   field CD_Item              like cota-representante.it-codigo
   field CD_Unidade_Negocio   like unid-neg-fam.cod_unid_negoc
   field DT_Cota              as date
   field NM_Orcamento         like cota-representante.qt-orcamento
   field NM_Representante     like cota-representante.qt-representante
   field NM_Vl_Representante  as decimal
   field CD_Grupo_Estoque     like item.ge-codigo
   field TX_Grupo_Estoque     like grup-estoq.descricao
   field TX_Unidade           like fam-com-item.descricao
   field TX_Segmento          like fam-com-item.descricao
   field TX_Familia           like fam-com-item.descricao
   field TX_Subfamilia        like fam-com-item.descricao
   field TX_Origem            like fam-com-item.descricao
   field CD_Pais              like mgcad.cidade.pais
   field CD_Estado            like mgcad.cidade.estado
   field CD_Cidade            like mgcad.cidade.cidade
   index idx_pri is primary unique CD_Estabelecimento CD_Representante CD_Familia_Comercial CD_Item DT_Cota CD_Pais CD_Estado CD_Cidade.
