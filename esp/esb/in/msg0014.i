{esp/esb/esesb000.i}

define temp-table msg0014 no-undo xml-node-name 'MSG0014'
   field idm as int xml-node-type 'hidden'
   field CodigoClassificacao           AS CHAR
   field Nome                          AS CHAR
   field PertenceProgramaCanais        AS LOG INIT YES
   field Situacao                      AS INT INIT 0.

define temp-table msg0014r no-undo xml-node-name 'MSG0014R1'
   field idm as int xml-node-type 'hidden'.
