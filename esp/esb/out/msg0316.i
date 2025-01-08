{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0316 NO-UNDO XML-NODE-NAME 'MSG0316'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CpfCnpjCodEstrangeiro            AS CHAR
   FIELD CodigoGrupoCobranca              AS INT.

DEFINE TEMP-TABLE msg0316r1 NO-UNDO XML-NODE-NAME 'MSG0316R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD StatusAvaliacao                  AS CHAR
   FIELD LimiteAdotado                    AS DEC FORMAT ">>>,>>>,>>>,>>9.99" /*LIKE val_tit_acr.val_origin_tit_acr DECIMALS 2*/
   FIELD LimiteDisponivel                 AS DEC FORMAT ">>>,>>>,>>>,>>9.99" /*LIKE val_tit_acr.val_origin_tit_acr DECIMALS 2*/
   FIELD DataValidade                     AS CHAR FORMAT "x(20)"
   FIELD Observacao                       AS CHAR.
