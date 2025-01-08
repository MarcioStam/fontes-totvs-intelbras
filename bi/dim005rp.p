/**
 * Extrator para BI
 * Dimens∆o: Regi∆o
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/dim005tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttDimRegiao.
define output parameter table for tt-erro.

define variable c-uf       as character no-undo.
define variable c-pais     as character no-undo.
define variable c-estado   as character no-undo.
define variable c-cidade   as character no-undo.
define variable c-regiao   as character no-undo.
define variable c-abrev    as character no-undo.

for each mgcad.cidade no-lock:
   find first unid-feder no-lock
      where unid-feder.estado = cidade.estado 
        and unid-feder.pais   = cidade.pais no-error.

   assign c-pais   = fn-free-accent(upper(trim(cidade.pais)))
          c-estado = fn-free-accent(upper(trim(unid-feder.no-estado)))
          c-cidade = fn-free-accent(upper(trim(cidade.cidade)))
          c-uf     = upper(trim(cidade.estado)).

   if (c-pais = 'BRASIL') then do:
      if c-uf = 'PR' or c-uf = 'SC' or c-uf = 'RS' then
         assign c-regiao = 'Regi∆o Sul'
                c-abrev  = 'S'.
      else if c-uf = 'SP' or c-uf = 'RJ' or c-uf = 'ES' or c-uf = 'MG' then
         assign c-regiao = 'Regi∆o Sudeste'
                c-abrev  = 'SE'.
      else if c-uf = 'AM' or c-uf = 'PA' or c-uf = 'RR' or c-uf = 'TO' or c-uf = 'AC' or c-uf = 'RO' or c-uf = 'AP' then
         assign c-regiao = 'Regi∆o Norte'
                c-abrev  = 'N'.
      else if c-uf = 'PE' or c-uf = 'PB' or c-uf = 'RN' or c-uf = 'SE' or c-uf = 'PI' or c-uf = 'MA' or c-uf = 'CE' or c-uf = 'BA' or c-uf = 'AL' then
         assign c-regiao = 'Regi∆o Nordeste'
                c-abrev  = 'NE'.
      else if c-uf = 'MT' or c-uf = 'MS' or c-uf = 'DF' or c-uf = 'GO' then
         assign c-regiao = 'Regi∆o Centro-Oeste'
                c-abrev  = 'CO'.
      else
         assign c-regiao = 'Desconhecido'
                c-abrev  = '?'.
   end.
   else if c-uf = 'EX' then
      assign c-regiao = 'Exterior'
             c-abrev  = 'EX'.
   else
      assign c-regiao = 'Desconhecido'
             c-abrev  = '?'.

   create ttDimRegiao.
   assign ttDimRegiao.CD_Pais   = c-pais
          ttDimRegiao.CD_Estado = c-uf
          ttDimRegiao.TX_Estado = c-estado
          ttDimRegiao.CD_Cidade = c-cidade
          ttDimRegiao.CD_IBGE   = mgcad.cidade.cdn-munpio-ibge
          ttDimRegiao.TX_Regiao = c-regiao
          ttDimRegiao.CD_Regiao = c-abrev.
end.
