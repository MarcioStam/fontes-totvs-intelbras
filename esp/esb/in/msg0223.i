{esp/esb/esesb000.i}
{cdp/cdcfgmat.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0223 NO-UNDO XML-NODE-NAME 'MSG0223'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra        LIKE prazo-compra.numero-ordem
   FIELD MotivoAlteracao          AS INT INITIAL ?
   FIELD Observacoes              AS CHAR.

DEFINE TEMP-TABLE ParcelaManual NO-UNDO XML-NODE-NAME 'ParcelaManual'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD SequenciaParcela         LIKE prazo-compra.parcela INITIAL ?
   FIELD DataParcela              LIKE prazo-compra.data-entrega
   FIELD QuantidadeParcela        LIKE prazo-compra.quantidade
   FIELD NumeroNotaFiscalPrevista LIKE int-prazo-compra.nro-docto
   FIELD SerieNotaFiscalPrevista  LIKE int-prazo-compra.serie-docto.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0223R1 NO-UNDO XML-NODE-NAME 'MSG0223R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra        LIKE prazo-compra.numero-ordem.

DEFINE TEMP-TABLE ParcelaManualR NO-UNDO XML-NODE-NAME 'ParcelaManual'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD SequenciaParcela  LIKE prazo-compra.parcela.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
{ccp/ccapi202.i}  /*tt-ordem-compra tt-prazo-compra*/
{cdp/cdapi300.i1} /*tt-erros-geral*/
{ccp/ccapi207.i}  /*tt-cotacao-item*/  
DEFINE BUFFER b-prazo-compra FOR prazo-compra.
DEFINE VARIABLE c-usuario-log LIKE usuar_mestre.cod_usuar.
DEFINE VARIABLE TotalOrdem    LIKE ordem-compra.qt-solic.
DEFINE VARIABLE parcela-aux   AS INTEGER     NO-UNDO.
