define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table ttDimRegiao no-undo
   field CD_Pais   like mgcad.cidade.pais
   field CD_Estado as character
   field TX_Estado like mgcad.cidade.estado
   field CD_Cidade like mgcad.cidade.cidade
   field CD_IBGE   like mgcad.cidade.cdn-domic-fisc
   field TX_Regiao as character
   field CD_Regiao as character
   index idx_pri is primary unique CD_Pais CD_Estado CD_Cidade.
