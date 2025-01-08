{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0311 NO-UNDO XML-NODE-NAME 'MSG0311'
   FIELD idm                          AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD Codigo                       LIKE tit_acr.num_id_tit_acr
   FIELD TipoCliente                  AS CHAR
   FIELD CpfCnpjCodEstrangeiro        LIKE pessoa_jurid.cod_id_feder
   FIELD DataEmissao                  AS CHAR FORMAT "x(20)"
   FIELD NumeroNotaFiscalComplementar LIKE tit_acr.cod_tit_acr
   FIELD TipoNotaFiscalComplementar   AS INT
   FIELD ValorTotal                   LIKE val_tit_acr.val_sdo_tit_acr
   FIELD ValorSaldo                   LIKE val_tit_acr.val_sdo_tit_acr
   FIELD NumeroNotaFiscal             LIKE tit_acr.cod_tit_acr.
   
DEFINE TEMP-TABLE ListaCategoria NO-UNDO XML-NODE-NAME 'ListaCategoria'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoCategoriaDEPS         AS CHAR FORMAT "x(50)".

DEFINE TEMP-TABLE msg0311r NO-UNDO XML-NODE-NAME 'MSG0311R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
