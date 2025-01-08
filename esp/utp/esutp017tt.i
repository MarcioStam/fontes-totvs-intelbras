DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD periodo           AS CHARACTER
    FIELD equip-ini         AS CHARACTER
    FIELD equip-fim         AS CHARACTER
    FIELD fornecedor        AS INTEGER
    FIELD remetente         AS CHARACTER
    FIELD cod-usuario       AS CHARACTER
    FIELD diretorio         AS CHARACTER
    FIELD acima-limite      AS LOGICAL
    FIELD envia-email       AS LOGICAL
    FIELD relatorio         AS INTEGER
    FIELD reais-minuto      AS DECIMAL. 

define temp-table tt-digita no-undo
    field campo AS CHARACTER
    index id campo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
