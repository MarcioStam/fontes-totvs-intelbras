{esp/esb/esesb000.i}

define temp-table msg0098 no-undo xml-node-name 'MSG0098'
   field idm as int xml-node-type 'hidden'.

define temp-table msg0098-ClienteItem no-undo xml-node-name 'ClienteItem'
   field idm as int xml-node-type 'hidden'
   field CodigoConta AS CHAR.

define temp-table msg0098r1 no-undo xml-node-name 'MSG0098R1'
   field idm as int xml-node-type 'hidden'.

define temp-table msg0098r1-ClientesItens no-undo xml-node-name 'ClientesItens'
   field idm as int xml-node-type 'hidden'.

define temp-table msg0098r1-ClienteItem no-undo xml-node-name 'ClienteItem'
   field idm                         as int xml-node-type 'hidden'
   field idm-canal-item              as int xml-node-type 'hidden'
   FIELD CodigoConta                 AS CHAR
   FIELD NomeCliente                 AS CHAR
   FIELD CNPJ                        AS CHAR.

define temp-table msg0098r1-TitulosItens no-undo xml-node-name 'TitulosItens'
   field idm-canal-item              as int xml-node-type 'hidden'.

define temp-table msg0098r1-TituloItem no-undo xml-node-name 'TituloItem'
   field idm-canal-item              as int xml-node-type 'hidden'
   FIELD  NumeroTitulo                AS CHAR
   FIELD  Carteira                    AS CHAR
   FIELD  DataEmissao                 AS DATE FORMAT "99/99/9999"
   FIELD  DataIndicacaoPerdaDedutivel AS DATE FORMAT "99/99/9999"
   FIELD  DataLiquidacao              AS DATE FORMAT "99/99/9999"
   FIELD  DataVencimento              AS DATE FORMAT "99/99/9999"
   FIELD  DataVencimentoOriginal      AS DATE FORMAT "99/99/9999"
   FIELD  Especie                     AS CHAR 
   FIELD  TipoEspecie                 AS CHAR
   FIELD  NumeroSerie                 AS CHAR
   FIELD  CodigoEstabelecimento       AS CHAR
   FIELD  NomeEstabelecimento         AS CHAR
   FIELD  Moeda                       AS CHAR
   FIELD  NumeroBancario              AS CHAR
   FIELD  NumeroParcela               AS CHAR
   FIELD  CodigoPortador              AS INT
   FIELD  NomePortador                AS CHAR
   FIELD  CodigoRepresentante         AS INT
   FIELD  NomeRepresentante           AS CHAR
   FIELD  TituloEmCobranca            AS LOGICAL
   FIELD  ValorOriginal               AS DEC DECIMALS 4
   FIELD  ValorSaldo                  AS DEC DECIMALS 4
   FIELD  NumeroDiasAtraso            AS INT.
