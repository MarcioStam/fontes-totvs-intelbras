define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    FIELD cod-estabel      AS CHAR  FORMAT "X(03)" LABEL "Estabelecimento"
    FIELD cod-depos        AS CHAR  FORMAT "X(03)" LABEL "Dep¢sito"
    FIELD arq-csv          AS CHAR  FORMAT "X(50)" LABEL "Arquivo CSV".                                    
