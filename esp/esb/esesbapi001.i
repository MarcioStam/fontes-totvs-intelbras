def temp-table tt-titulos-canal no-undo
  FIELD  Matriz                      AS INTE
  FIELD  CodigoCliente               AS INTE
  FIELD  NomeCliente                 AS CHAR
  FIELD  CNPJ                        AS CHAR
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
  FIELD  NumeroDiasAtraso            AS INT
    INDEX idx-dias-atraso CodigoCliente ASC
                          NumeroDiasAtraso DESC . 
