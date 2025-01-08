/**
 * Extrator para BI
 * Fato: VPC
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact008tt.i}

define input  parameter table for tt-param.
define output parameter table for tt-vpc.

find first tt-param.

define variable c-pais     as character no-undo.
define variable c-estado   as character no-undo.
define variable c-cidade   as character no-undo.

for each vpc no-lock
   where (vpc.situacao = 1
      or  vpc.situacao = 2)
     and  vpc.data-trans >= tt-param.dt-inicial
     and  vpc.data-trans <= tt-param.dt-final
     and  can-find (first tipo-acordo no-lock
                    where tipo-acordo.codigo = vpc.tipo-acordo)
     and  can-find (first tipo-verba no-lock
                    where tipo-verba.codigo = vpc.tipo-verba),
   first emitente no-lock
      where emitente.cod-emitente = vpc.cod-emitente:

   /** Cria registro na temp-table **/
   create tt-vpc.
   assign tt-vpc.cod-estabel    = vpc.cod-estabel
          tt-vpc.nr-vpc         = vpc.nr-vpc
          tt-vpc.cod-emitente   = emitente.cod-emitente
          tt-vpc.cod-rep        = emitente.cod-rep
          tt-vpc.pais           = c-pais
          tt-vpc.estado         = c-estado
          tt-vpc.cidade         = c-cidade
          tt-vpc.cod_unid_negoc = vpc.cod-unid-negoc
          tt-vpc.tipo-acordo    = vpc.tipo-acordo
          tt-vpc.tipo-verba     = vpc.tipo-verba
          tt-vpc.data-trans     = vpc.data-trans
          tt-vpc.cod-esp        = vpc.cod-esp
          tt-vpc.serie-docto    = vpc.serie-docto
          tt-vpc.nro-docto      = vpc.nro-docto
          tt-vpc.parc-docto     = '01'
          tt-vpc.vl-vpc         = vpc.valor.
end.
