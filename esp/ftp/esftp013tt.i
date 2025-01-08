define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      LIKE estabelec.cod-estabel
    field i-carteira       AS CHAR FORMAT "x(03)"
    field i-portador       AS CHAR FORMAT "x(05)"
    field c-esp            AS CHAR FORMAT "x(03)"
    field i-nr-titulo-ini  AS CHAR FORMAT "x(10)"
    field i-nr-titulo-fim  AS CHAR FORMAT "x(10)"
    field da-dt-ini        AS DATE 
    field da-dt-fim        AS DATE 
    field l-imp-reimp      AS LOGICAL. /* Y - ImpressÆo / N - ReimpressÆo */
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
