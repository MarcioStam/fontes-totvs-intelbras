{esp/esb/esesb000.i}

define temp-table msg0016 no-undo xml-node-name 'MSG0016'
   field idm as int xml-node-type 'hidden'
   field CodigoSubclassificacao        AS CHAR
   field Nome                          AS CHAR
   field classificacao                 AS CHAR
   field Situacao                      AS INT INIT 0.

define temp-table msg0016r no-undo xml-node-name 'MSG0016R1'
   field idm as int xml-node-type 'hidden'.
