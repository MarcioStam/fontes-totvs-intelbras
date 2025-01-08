define temp-table tt-param no-undo
    field destino         AS integer
    field arquivo         AS char format "x(35)":U
    field usuario         AS char format "x(12)":U
    field data-exec       AS date
    field hora-exec       AS integer
    field modelo          AS char format "x(35)":U
    FIELD data-emis-ini   AS DATE
    FIELD data-emis-fim   AS DATE
    FIELD nr-num-nota-ini AS CHAR
    FIELD nr-num-nota-fim AS CHAR
    FIELD serie-ini       AS CHAR
    FIELD serie-fim       AS CHAR
    FIELD cod-estabel-ini AS CHAR
    FIELD cod-estabel-fim AS CHAR
    FIELD conta_pat_ini  AS CHAR
    FIELD conta_pat_fim  AS CHAR
    FIELD num_bem_pat_ini AS INT
    FIELD num_bem_pat_fim AS INT.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
