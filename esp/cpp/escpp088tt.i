define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    FIELD it-codigo-ini    AS char
    FIELD it-codigo-fim    AS char
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

/* define temp-table tt-digita no-undo                      */
/*     field ordem            as integer   format ">>>>9":U */
/*     field exemplo          as character format "x(30)":U */
/*     index id ordem.                                      */
/*                                                          */
/* define buffer b-tt-digita for tt-digita.                 */

def temp-table tt-raw-digita
   field raw-digita      as raw.
