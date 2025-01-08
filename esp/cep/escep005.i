/*****************************************************************************
**
**   Programa: esp/cep/escep005.i
**   Funcao..: Defini‡Æo de temp-table do ESCEP005rp
**   Data....: 26/09/05
**
******************************************************************************/

DEF NEW GLOBAL SHARED TEMP-TABLE tt-ae
    FIELD nr-ae         AS INT  FORMAT ">>>>>>9"    LABEL "AE"
    FIELD sequencia     AS INT  FORMAT ">>9"        LABEL "Seq"
    FIELD quantidade    AS INT  FORMAT ">>>,>>9"    LABEL "QTD"
    FIELD data          LIKE ae-item.data           LABEL "Data" 
    FIELD cod-depos     AS CHAR FORMAT "x(3)"       LABEL "Dep"
    FIELD localizacao   LIKE ae-item.localizacao    LABEL "Local"
    FIELD roteiro       LIKE ae-item.roteiro.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD cod-estabel      AS CHAR
    FIELD l-imprime        AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
