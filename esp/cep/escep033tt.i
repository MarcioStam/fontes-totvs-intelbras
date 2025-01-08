 DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(50)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       AS CHAR
    FIELD c-it-codigo-ini   like item.it-codigo
    FIELD c-it-codigo-fim   like item.it-codigo        
    FIELD i-tipo            AS INTEGER LABEL "Tipo"
    FIELD dt-inicio         AS DATE LABEL "Per¡odo" FORMAT "99/99/9999"
    FIELD dt-final          AS DATE                 FORMAT "99/99/9999"
    FIELD dt-corte          AS DATE LABEL "Data Corte" FORMAT "99/99/9999"
    FIELD i-tipo-consumo    AS INTEGER
    FIELD i-cd-plano        AS INTEGER
    FIELD i-meses           AS INTEGER.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo         like item.it-codigo
    FIELD descricao         like item.desc-item
          INDEX id it-codigo.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
