define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel-ini  LIKE estabelec.cod-estabel
    FIELD cod-estabel-fim  LIKE estabelec.cod-estabel
    FIELD dt-emissao-ini LIKE nota-fiscal.dt-saida
    FIELD dt-emissao-fim LIKE nota-fiscal.dt-saida
    FIELD cod-cli-ini      LIKE ped-venda.cod-emitente
    FIELD cod-cli-fim      LIKE ped-venda.cod-emitente
    FIELD cod-transp-ini   LIKE transporte.cod-transp
    FIELD cod-transp-fim   LIKE transporte.cod-transp
    FIELD tb-parametros    AS LOGICAL
    FIELD tb-envia-email   AS LOGICAL
    FIELD lista-conhecimentos AS LOGICAL
    FIELD i-tipo-docto        AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
