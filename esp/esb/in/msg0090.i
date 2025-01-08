{esp/esb/esesb000.i}

define temp-table msg0090 no-undo xml-node-name 'MSG0090'
   field idm as int xml-node-type 'hidden'
   field CodigoConta as CHAR.

define temp-table msg0090r no-undo xml-node-name 'MSG0090R1'
   field idm as int xml-node-type 'hidden'
   field LimiteIntelbras           as dec 
   field LimiteUtilizadoIntelbras  as dec
   field LimiteDisponivelIntelbras as dec
   field LimiteIntelbrasClub       as dec
   field LimiteUtilizadoClub       as dec
   field LimiteDisponivelClub      as dec.
