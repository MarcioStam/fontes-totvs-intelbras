{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0100 NO-UNDO XML-NODE-NAME 'MSG0100'
   FIELD idm                         AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD Conta                       AS CHAR
   FIELD Classificacao               AS CHAR INITIAL ?
   FIELD UnidadeNegocio              AS CHAR
   FIELD Exclusivo                   AS LOG
   FIELD Bloqueado                   AS LOG.
   
   
DEFINE TEMP-TABLE msg0100r NO-UNDO XML-NODE-NAME 'MSG0100R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutosItens NO-UNDO XML-NODE-NAME 'ProdutosItens'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD TemCache                 AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Solu‡Æo */







