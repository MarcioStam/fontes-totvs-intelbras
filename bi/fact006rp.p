/**
 * Extrator para BI
 * Fato: Cota de Representante
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact006tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactCotaRepresentante.
define output parameter table for tt-erro.

find first tt-param.

define variable c-periodo-ini    as character no-undo.
define variable c-periodo-fim    as character no-undo.
define variable i                as integer   no-undo.
define variable d-vl-medio       as decimal   no-undo.
define variable c-pais           as character no-undo.
define variable c-estado         as character no-undo.
define variable c-cidade         as character no-undo.
define variable c-unid-negoc     as character no-undo.

assign c-periodo-ini  = string(year(tt-param.dt-inicial), '9999') + string(month(tt-param.dt-inicial), '99')
       c-periodo-fim  = string(year(tt-param.dt-final), '9999') + string(month(tt-param.dt-final), '99').

for each cota-representante no-lock
   where cota-representante.periodo >= c-periodo-ini
     and cota-representante.periodo <= c-periodo-fim:

   if (cota-representante.it-codigo <> ?) and (cota-representante.it-codigo <> '') then
      find item no-lock
         where item.it-codigo = cota-representante.it-codigo no-error.

   if available (item) and (item.it-codigo <> '') then
      find fam-comerc no-lock
         where fam-comerc.fm-cod-com = item.fm-cod-com no-error.
   else
      find fam-comerc no-lock
         where fam-comerc.fm-cod-com = cota-representante.fm-cod-com no-error.

   /*
   if (cota-representante.it-codigo <> ?) and (cota-representante.it-codigo <> '') then do:
      find item-estab no-lock
         where item-estab.it-codigo   = cota-representante.it-codigo
           and item-estab.cod-estabel = cota-representante.cod-estabel no-error.
      if available item-estab then
         assign d-vl-medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
      else
         assign d-vl-medio = 0.
   end.
   else
      assign d-vl-medio = 0.
   */

   /** Regi∆o **/
   if (cota-representante.cd-uf <> ?) and (cota-representante.cd-uf <> '') then do:
      find mgcad.cidade no-lock
         where mgcad.cidade.pais   = 'Brasil'
           and mgcad.cidade.estado = cota-representante.cd-uf
           and mgcad.cidade.cidade = (if cota-representante.cd-uf = 'AC' then 'RIO BRANCO'
                                       else if cota-representante.cd-uf = 'AL' then 'MACEIO'
                                       else if cota-representante.cd-uf = 'AM' then 'MANAUS'
                                       else if cota-representante.cd-uf = 'AP' then 'MACAPA'
                                       else if cota-representante.cd-uf = 'BA' then 'SALVADOR'
                                       else if cota-representante.cd-uf = 'CE' then 'FORTALEZA'
                                       else if cota-representante.cd-uf = 'DF' then 'BRASILIA'
                                       else if cota-representante.cd-uf = 'ES' then 'VITORIA'
                                       else if cota-representante.cd-uf = 'GO' then 'GOIANIA'
                                       else if cota-representante.cd-uf = 'MA' then 'SAO LUIS'
                                       else if cota-representante.cd-uf = 'MG' then 'BELO HORIZONTE'
                                       else if cota-representante.cd-uf = 'MT' then 'CUIABA'
                                       else if cota-representante.cd-uf = 'MS' then 'CAMPO GRANDE'
                                       else if cota-representante.cd-uf = 'PA' then 'BELEM'
                                       else if cota-representante.cd-uf = 'PB' then 'JOAO PESSOA'
                                       else if cota-representante.cd-uf = 'PE' then 'RECIFE'
                                       else if cota-representante.cd-uf = 'PI' then 'TERESINA'
                                       else if cota-representante.cd-uf = 'PR' then 'CURITIBA'
                                       else if cota-representante.cd-uf = 'RJ' then 'RIO DE JANEIRO'
                                       else if cota-representante.cd-uf = 'RN' then 'NATAL'
                                       else if cota-representante.cd-uf = 'RO' then 'PORTO VELHO'
                                       else if cota-representante.cd-uf = 'RR' then 'BOA VISTA'
                                       else if cota-representante.cd-uf = 'RS' then 'PORTO ALEGRE'
                                       else if cota-representante.cd-uf = 'SC' then 'FLORIANOPOLIS'
                                       else if cota-representante.cd-uf = 'SE' then 'ARACAJU'
                                       else if cota-representante.cd-uf = 'SP' then 'SAO PAULO'
                                       else 'PALMAS') no-error.

      if available mgcad.cidade then
         assign c-pais   = fn-free-accent(upper(trim(mgcad.cidade.pais)))
                c-estado = fn-free-accent(upper(trim(mgcad.cidade.estado)))
                c-cidade = fn-free-accent(upper(trim(mgcad.cidade.cidade))).
      else
         assign c-pais   = ''
                c-estado = ''
                c-cidade = ''.

   end.
   else
      assign c-pais   = ''
             c-estado = ''
             c-cidade = ''.
         
   /** Unidade de neg¢cio **/
   if not available item and available fam-comerc then
      find first item no-lock
         where item.fm-cod-com = fam-comerc.fm-cod-com
           and item.cod-unid-negoc <> '' no-error.

   find item-uni-estab no-lock
      where item-uni-estab.it-codigo   = item.it-codigo
        and item-uni-estab.cod-estabel = cota-representante.cod-estabel no-error.

   if available item-uni-estab and item-uni-estab.cod-unid-negoc <> '' and item-uni-estab.cod-unid-negoc <> ? then
      assign c-unid-negoc = item-uni-estab.cod-unid-negoc.
   else do:
      if available item and item.cod-unid-negoc <> '' and item.cod-unid-negoc <> ? then
         assign c-unid-negoc = item.cod-unid-negoc.
      else
         assign c-unid-negoc = 'INV'.
   end.
      
   create ttFactCotaRepresentante.
   assign ttFactCotaRepresentante.CD_Estabelecimento   = cota-representante.cod-estabel
          ttFactCotaRepresentante.CD_Representante     = cota-representante.cod-rep
          ttFactCotaRepresentante.CD_Familia_Comercial = cota-representante.fm-cod-com
          ttFactCotaRepresentante.CD_Item              = (if cota-representante.it-codigo = ? then 'FM-' + cota-representante.fm-cod-com else cota-representante.it-codigo)
          ttFactCotaRepresentante.CD_Unidade_Negocio   = upper(c-unid-negoc)
          ttFactCotaRepresentante.DT_Cota              = date(integer(substring(cota-representante.periodo, 5)), 1, integer(substring(cota-representante.periodo, 1, 4)))
          ttFactCotaRepresentante.NM_Orcamento         = cota-representante.qt-orcamento
          ttFactCotaRepresentante.NM_Representante     = cota-representante.qt-representante
          ttFactCotaRepresentante.NM_Vl_Representante  = ttFactCotaRepresentante.NM_Representante * cota-representante.valor
          ttFactCotaRepresentante.CD_Pais              = c-pais
          ttFactCotaRepresentante.CD_Estado            = c-estado
          ttFactCotaRepresentante.CD_Cidade            = c-cidade.

   /** Tratamento da fam°lia comercial **/
   if available (fam-comerc) and can-find (first fam-com-item
                                           where fam-com-item.fm-cod-com = fam-comerc.fm-cod-com) then do:
      repeat i = 1 to 8:
         if (i = 1) or
            (i = 3) or
            (i = 6) then
            next.
   
         find fam-com-item no-lock
            where fam-com-item.fm-cod-com = substring(item.fm-cod-com, 1, i) no-error.
   
         if not available (fam-com-item) then
            next.
   
         case i:
            when 4 then
               assign ttFactCotaRepresentante.TX_Segmento = fam-com-item.descricao.
            when 2 then
               assign ttFactCotaRepresentante.TX_Unidade = fam-com-item.descricao.
            when 5 then
               assign ttFactCotaRepresentante.TX_Familia = fam-com-item.descricao.
            when 7 then
               assign ttFactCotaRepresentante.TX_Subfamilia = fam-com-item.descricao.
            when 8 then
               assign ttFactCotaRepresentante.TX_Origem = fam-com-item.descricao.
         end case.
      end.
   end.
   /** Tratamento do Grupo de estoque **/
   find grup-estoq no-lock
      where grup-estoq.ge-codigo = 40 no-error.

   if available (grup-estoq) then
      assign ttFactCotaRepresentante.TX_Grupo_Estoque = grup-estoq.descricao.

end.
