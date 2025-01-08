define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    FIELD cod-estabel      AS CHAR
    FIELD cod-local        AS CHAR
    FIELD itCodigoIni      AS CHAR
    FIELD itCodigoFim      AS CHAR
    FIELD situacao         AS INT
    FIELD fil-situacao     AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
