def temp-table tt-aes NO-UNDO
    field nr-ae         AS INTEGER   FORMAT ">>>>>>9"    LABEL "AE"
    field sequencia     AS INTEGER   FORMAT ">>9"        LABEL "SEQ"
    field quantidade    AS INTEGER   FORMAT ">>>,>>9"    LABEL "QTD"
    field data          AS DATE      FORMAT "99/99/9999" LABEL "Data" 
    field cod-depos     AS CHARACTER FORMAT "x(3)"       LABEL "Dep"
    field localizacao   AS CHARACTER FORMAT "x(20)"      LABEL "Local"
    field roteiro       AS INTEGER 
    field it-codigo     AS CHARACTER FORMAT "x(12)"    label "Item".

DEF TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-depos     AS CHARACTER    LABEL "Dep"
    FIELD cod-localiz   AS CHARACTER    LABEL "Local"      FORMAT "x(20)"
    FIELD quantidade    AS DEC          LABEL "Quantidade" FORMAT "->>>>,>>9.99".   

DEF TEMP-TABLE tt-ficha-cq NO-UNDO
    FIELD nr-ficha     AS INTEGER    COLUMN-LABEL "Roteiro"
    FIELD qt-original  AS DECIMAL    COLUMN-LABEL "Recebida"  FORMAT ">>>,>>>,>>9"
    FIELD qt-aprovada  AS DECIMAL    COLUMN-LABEL "Aprovada"  FORMAT ">>>,>>>,>>9"
    FIELD qt-rejeitada AS DECIMAL    COLUMN-LABEL "Rejeitada" FORMAT ">>>,>>>,>>9"
    FIELD qt-apr-cond  AS DECIMAL    COLUMN-LABEL "Apr.Cond." FORMAT ">>>,>>>,>>9" 
    FIELD dt-inspecao  AS DATE       COLUMN-LABEL "Inspecao"
    FIELD narrativa    AS CHARACTER.

DEFINE BUFFER b-tt-aes   FOR tt-aes.
DEFINE BUFFER b-tt-saldo FOR tt-saldo.
