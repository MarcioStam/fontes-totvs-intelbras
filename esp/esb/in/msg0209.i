{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0209 NO-UNDO XML-NODE-NAME 'MSG0209'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE MSG_Parcela NO-UNDO XML-NODE-NAME 'ParcelaAlterada'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra         LIKE prazo-compra.numero-ordem
   FIELD SequenciaParcela          LIKE prazo-compra.sequencia INITIAL ?
   FIELD DataParcela               LIKE prazo-compra.data-entrega
   FIELD QuantidadeParcela         LIKE prazo-compra.quantidade
   FIELD SequenciaParcelaOriginal  LIKE prazo-compra.sequencia
   FIELD NumeroEmbarque            LIKE embarque-imp.embarque  INITIAL ?
   FIELD MotivoAlteracao           AS INT
   FIELD ParcelaAnalisada          AS LOG
   FIELD EmbarcarParcela           AS LOG
   FIELD SituacaoMovimentoParcela  AS INT INITIAL ?
   FIELD Observacoes               AS CHAR. 

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0209R1 NO-UNDO XML-NODE-NAME 'MSG0209R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ParcelaAlteradaResultado_R1 NO-UNDO XML-NODE-NAME 'ParcelaAlteradaResultado'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra LIKE prazo-compra.numero-ordem
   FIELD SequenciaParcela  LIKE prazo-compra.parcela
   FIELD NumeroEmbarque    LIKE embarque-imp.embarque.



/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-ordens-pedido NO-UNDO
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    INDEX ch-pri IS PRIMARY UNIQUE numero-ordem.

DEFINE TEMP-TABLE tt-licenciam-import-oc NO-UNDO LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-licenciam-import-oc-aux NO-UNDO LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.
