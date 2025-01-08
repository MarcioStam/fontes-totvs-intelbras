{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0097 NO-UNDO XML-NODE-NAME 'MSG0097'
   FIELD idm                         AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoTitulo                LIKE tit_acr.num_id_tit_acr
   FIELD TipoCliente                 AS CHAR
   FIELD CpfCnpjCodEstrangeiro       LIKE pessoa_jurid.cod_id_feder
   FIELD NumeroTitulo                LIKE tit_acr.cod_tit_acr
   FIELD DataEmissao                 AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD DataVencimentoProrrogado    AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD DataVencimentoOriginal      AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD NumeroParcela               LIKE tit_acr.cod_parcela
   FIELD ValorOriginal               LIKE val_tit_acr.val_origin_tit_acr DECIMALS 2
   FIELD NumeroBoleto                LIKE tit_acr.cod_tit_acr_bco
   FIELD NumeroNotaFiscal            LIKE nota-fiscal.nr-nota-fis.   
   
DEFINE TEMP-TABLE ListaCategoria NO-UNDO XML-NODE-NAME 'ListaCategoria'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoCategoriaDEPS         AS CHAR FORMAT "x(50)".

DEFINE TEMP-TABLE MovimentosGerais NO-UNDO XML-NODE-NAME 'MovimentosGerais'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoTipoMovimento         AS CHAR FORMAT "x(50)"
   FIELD NomeDocumento               LIKE pessoa_jurid.cod_id_feder
   FIELD DataMovimento               AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD ValorMovimento              LIKE val_tit_acr.val_sdo_tit_acr DECIMALS 2.

DEFINE TEMP-TABLE MovimentosBaixas NO-UNDO XML-NODE-NAME 'MovimentosBaixas'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoTipoMovimento         AS CHAR FORMAT "x(50)"
   FIELD NomeDocumento               LIKE pessoa_jurid.cod_id_feder
   FIELD DataMovimento               AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD ValorMovimento              LIKE val_tit_acr.val_sdo_tit_acr DECIMALS 2.

DEFINE TEMP-TABLE CadastrosComplementares NO-UNDO XML-NODE-NAME 'CadastrosComplementares'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE CategoriaItem NO-UNDO XML-NODE-NAME 'CategoriaItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeCategoria               AS CHAR FORMAT "x(100)"
   FIELD CodigoCategoriaDEPS         AS CHAR FORMAT "x(50)"
   FIELD NomeParametrizacao          AS CHAR FORMAT "x(100)"
   FIELD TipoRelacionamento          AS INT
   FIELD ContaInadimplencia          AS INT
   FIELD ContaPagamento              AS INT.

DEFINE TEMP-TABLE msg0097r NO-UNDO XML-NODE-NAME 'msg0097R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
