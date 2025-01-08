{esp/esb/esesb000.i}

define temp-table msg0137 no-undo xml-node-name 'MSG0137'
   field idm as int xml-node-type 'hidden'
   field CodigoRelacionamentoCanal AS CHAR
   field Nome                      AS CHAR
   FIELD CodigoConta               AS CHAR
   FIELD CodigoRepresentante       AS INTEGER
   FIELD CodigoAssistente          AS INTEGER
   FIELD CodigoAssistenteCRM       AS CHAR 
   FIELD CodigoSupervisor          AS CHAR
   FIELD CodigoSupervisorEMS       AS CHAR
   FIELD DataInicial               AS DATE FORMAT "99/99/9999"
   FIELD DataFinal                 AS DATE FORMAT "99/99/9999"
   FIELD Situacao                  AS INTEGER.


define temp-table msg0137r1 no-undo xml-node-name 'MSG0137R1'
   field idm as int xml-node-type 'hidden'.
