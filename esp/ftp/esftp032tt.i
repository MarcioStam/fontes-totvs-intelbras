define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD dt-data-ini           LIKE nota-fiscal.dt-emis-nota
    FIELD dt-data-fim           LIKE nota-fiscal.dt-emis-nota
    FIELD cod-estabel-ini       LIKE nota-fiscal.cod-estabel
    FIELD cod-estabel-fim       LIKE nota-fiscal.cod-estabel
    FIELD i-cod-rep-ini         LIKE repres.cod-rep
    FIELD i-cod-rep-fim         LIKE repres.cod-rep 
    FIELD i-cod-cli-ini         LIKE emitente.cod-emitente
    FIELD i-cod-cli-fim         LIKE emitente.cod-emitente
    FIELD i-cod-matriz-ini      LIKE emitente.cod-emitente
    FIELD i-cod-matriz-fim      LIKE emitente.cod-emitente
    FIELD i-gr-cli-ini          LIKE emitente.cod-gr-cli
    FIELD i-gr-cli-fim          LIKE emitente.cod-gr-cli
    FIELD c-cgc-ini             LIKE emitente.cgc
    FIELD c-cgc-fim             LIKE emitente.cgc
    FIELD i-familia-ini         AS   CHARACTER
    FIELD i-familia-fim         AS   CHARACTER
    FIELD i-classificacao       AS INTEGER.

DEFINE TEMP-TABLE tt-result NO-UNDO
    FIELD cod-matriz        LIKE emitente.cod-emitente
    FIELD nome-matriz       LIKE emitente.nome-emit
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emit         LIKE emitente.nome-emit
    FIELD rep-matriz        LIKE repres.cod-rep
    FIELD nome-rep-matriz   LIKE repres.nome-abrev             COLUMN-LABEL "Repres."
    FIELD cod-gr-cli        LIKE gr-cli.cod-gr-cli
    FIELD desc-gr-cli       LIKE gr-cli.descricao              COLUMN-LABEL "Gr. Cliente"
    FIELD estado            LIKE emitente.estado
    FIELD cod-familia       LIKE fam-comerc.fm-cod-com
    FIELD desc-sub-familia  LIKE fam-comerc.descricao      COLUMN-LABEL "Familia Comercial"
    FIELD qt-item           LIKE it-nota-fisc.qt-faturada[1]   FORMAT "->>>,>>>,>>9"
    FIELD vl-item           LIKE it-nota-fisc.vl-merc-liq      FORMAT "->>>,>>>,>>9.99"
    FIELD unid-neg          LIKE unid-neg-fat.cod_unid_negoc
    FIELD periodo           AS CHAR FORMAT "x(6)"              COLUMN-LABEL "Per¡odo"
    INDEX ch-pri            AS PRIMARY periodo cod-matriz rep-matriz cod-gr-cli cod-familia unid-neg
    INDEX ch-saida          periodo nome-matriz cod-gr-cli estado cod-familia .

define temp-table tt-digita no-undo
    field cd-gr-com as integer   format ">>9"
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
