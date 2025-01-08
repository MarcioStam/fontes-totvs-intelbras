{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0303 NO-UNDO XML-NODE-NAME 'MSG0303'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

DEFINE TEMP-TABLE ListaSaldoEstoque NO-UNDO XML-NODE-NAME 'ListaSaldoEstoque'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

DEFINE TEMP-TABLE EstoqueProduto NO-UNDO XML-NODE-NAME 'EstoqueProduto'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE saldo-estoq.it-codigo
   FIELD CodigoDeposito        LIKE saldo-estoq.cod-depos
   FIELD CodigoEstabelecimento LIKE saldo-estoq.cod-estabel     
   FIELD ConsideraLocalizacao  AS   LOG
   FIELD CodigoLocalizacaoMaterial AS CHAR.   

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0303R1 NO-UNDO XML-NODE-NAME 'MSG0303R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ListaSaldoEstoqueR NO-UNDO XML-NODE-NAME 'ListaSaldoEstoque'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

DEFINE TEMP-TABLE EstoqueProdutoR NO-UNDO XML-NODE-NAME 'EstoqueProduto'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE saldo-estoq.it-codigo
   FIELD CodigoDeposito        LIKE saldo-estoq.cod-depos
   FIELD QuantidadeSaldo       AS DEC
   FIELD CodigoEstabelecimento LIKE saldo-estoq.cod-estabel     
   FIELD SaldoAlocado          AS DEC
   .
/*Outras temp tables*/
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
