{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0310 NO-UNDO XML-NODE-NAME 'MSG0310'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroPedido           LIKE ped-venda.nr-pedido
    FIELD TipoCliente            AS CHAR /*Se emitente.natureza = 1 gravar "F", se igual a 2 gravar "J".*/
    FIELD CpfCnpjCodEstrangeiro  LIKE emitente.cgc
    FIELD NumeroPedidoCliente    LIKE ped-venda.nr-pedcli 
    FIELD DataEmissao            LIKE ped-venda.dt-emissao 
    FIELD DataPrimeiroVencimento LIKE ped-venda.dt-entrega-prim
    FIELD ValorTotal             LIKE ped-venda.vl-tot-ped
    FIELD ValorEntrada           LIKE ped-antecip.vl-antecip[1]  
    FIELD ValorLiquido           LIKE ped-venda.vl-liq-ped
    FIELD ValorSaldo             AS DEC 
  /*FIELD TipoRepresentante      LIKE 
    FIELD CpfCnpjRepresentante   LIKE */
    FIELD CodigoTipoPagamento    AS INT 
    FIELD DataAtualizaSituacao   AS DATE 
    FIELD DataFaturamento        AS DATE 
    FIELD DiasEntreParcelas      AS INT 
    FIELD PrazoPedido            LIKE cond-pagto.descricao
    FIELD NumeroParcelas         AS INT 
    FIELD StatusAvaliacao        AS CHAR. 

DEFINE TEMP-TABLE ListaCategoria NO-UNDO XML-NODE-NAME 'ListaCategoria'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoCategoriaDEPS    AS CHAR
    FIELD RegistroRemovido       AS LOG.

DEFINE TEMP-TABLE InformacoesComplementares NO-UNDO XML-NODE-NAME 'InformacoesComplementares'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD Descricao              AS CHAR
    FIELD DataHoraCriacao        AS CHAR FORMAT "x(20)" /*DATETIME*/
    FIELD Login                  AS CHAR.

DEFINE TEMP-TABLE ListaMotivo NO-UNDO XML-NODE-NAME 'ListaMotivo'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoMotivo           AS CHAR
    FIELD RegistroRemovido       AS LOG.

DEFINE TEMP-TABLE CadastrosComplementares NO-UNDO XML-NODE-NAME 'CadastrosComplementares'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE CategoriaItem NO-UNDO XML-NODE-NAME 'CategoriaItem'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD NomeCategoria          AS CHAR
    FIELD CodigoCategoriaDEPS    AS CHAR
    FIELD NomeParametrizacao     AS CHAR
    FIELD AprovadoAutomacao      AS INT
    FIELD bloqueadoAutomacao     AS INT.

                                          
DEFINE TEMP-TABLE msg0310r NO-UNDO XML-NODE-NAME 'MSG0310R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroPedido     LIKE ped-venda.nr-pedido
    FIELD StatusAvaliacao  AS CHAR
    FIELD DescricaoParecer AS CHAR.

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-origem-inegr AS INT /*1 - Pedido, 2 - Faturamento*/.

