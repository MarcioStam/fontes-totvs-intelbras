define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table tt-vpc no-undo
   field cod-estabel    like vpc.cod-estabel
   field nr-vpc         like vpc.nr-vpc
   field cod-emitente   like emitente.cod-emitente
   field cod-rep        like emitente.cod-rep
   field pais           like emitente.pais
   field estado         like emitente.estado
   field cidade         like emitente.cidade
   field cod_unid_negoc like vpc.cod-unid-negoc
   field tipo-acordo    like vpc.tipo-acordo
   field tipo-verba     like vpc.tipo-verba
   field data-trans     like vpc.data-trans
   field cod-esp        like vpc.cod-esp
   field serie-docto    like vpc.serie-docto
   field nro-docto      like vpc.nro-docto
   field parc-docto     as character
   field vl-vpc         as decimal
   index ch-pri is primary unique nr-vpc.
