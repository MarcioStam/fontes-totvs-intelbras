define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    field fi-cod-estab-ini as char format "x(03)":U
    field fi-cod-estab-fim as char format "x(03)":U
    FIELD dt-emis-ini      AS DATE FORMAT "99/99/9999"
    FIELD dt-emis-fim      AS DATE FORMAT "99/99/9999"
    FIELD de-ali-1         AS DEC FORMAT ">>9,99"
    FIELD de-ali-2         AS DEC FORMAT ">>9,99"
    FIELD de-ali-3         AS DEC FORMAT ">>9,99"
    FIELD de-ali-4         AS DEC FORMAT ">>9,99"
    FIELD de-ali-5         AS DEC FORMAT ">>9,99"
    FIELD de-perc-int      AS DEC FORMAT ">>9,99"
    FIELD de-convenio-1    AS DEC FORMAT ">>9,99"
    FIELD de-convenio-2a   AS DEC FORMAT ">>9,99"
    FIELD de-convenio-2b   AS DEC FORMAT ">>9,99"
    FIELD de-convenio-sc   AS DEC FORMAT ">>9,99"
    FIELD de-deposito      AS DEC FORMAT ">>9,99"
    FIELD de-pis-cofins    AS DEC FORMAT ">>9,99"
    field cod-estabel      as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
