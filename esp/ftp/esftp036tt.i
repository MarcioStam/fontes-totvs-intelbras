define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel-ini  LIKE estabelec.cod-estabel
    FIELD cod-estabel-fim  LIKE estabelec.cod-estabel
    FIELD cod-emitente-ini LIKE emitente.cod-emitente
    FIELD cod-emitente-fim LIKE emitente.cod-emitente
    FIELD cgc-ini          LIKE emitente.cgc
    FIELD cgc-fim          LIKE emitente.cgc
    FIELD dt-devol-ini     LIKE devol-cli.dt-devol
    FIELD dt-devol-fim     LIKE devol-cli.dt-devol
    FIELD cod-gr-cob-ini   LIKE int-emitente.cod-gr-cob
    FIELD cod-gr-cob-fim   LIKE int-emitente.cod-gr-cob
    FIELD nro-docto-ini    LIKE devol-cli.nro-docto
    FIELD nro-docto-fim    LIKE devol-cli.nro-docto
    FIELD nr-nota-fis-ini  LIKE devol-cli.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE devol-cli.nr-nota-fis
    FIELD det-cta-receber  AS LOGICAL.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
