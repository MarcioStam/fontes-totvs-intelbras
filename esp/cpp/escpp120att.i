define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD dDataIni AS      DATE
    FIELD dDatafim AS      DATE
    FIELD cItemIni AS      CHAR
    FIELD cItemFim AS      CHAR
    FIELD iPedido  AS      INT.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.
