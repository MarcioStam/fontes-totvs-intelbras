define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD dt-ini     as date
    FIELD dt-fim     as date
    FIELD cod-rep-ini like repres.cod-rep
    FIELD cod-rep-fim like repres.cod-rep
    FIELD cod-mov-ini like mov-comis.cod-mov
    FIELD cod-mov-fim like mov-comis.cod-mov.


    /*
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/
    */

