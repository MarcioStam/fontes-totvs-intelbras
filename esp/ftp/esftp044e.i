define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    FIELD fi-cat-ini             like cat.nr-cat
    FIELD fi-cat-fim             like cat.nr-cat
    FIELD fi-sequencia-ini       like cat.sequencia
    FIELD fi-sequencia-fim       like cat.sequencia
    FIELD fi-dt-emissao-ini      like nota-fiscal.dt-emis-nota
    FIELD fi-dt-emissao-fim      like nota-fiscal.dt-emis-nota
    FIELD fi-cliente-ini         like nota-fiscal.cod-emitente
    FIELD fi-cliente-fim         like nota-fiscal.cod-emitente
    field fi-nome-cli-ini        like emitente.nome-emit
    field fi-nome-cli-fim        like emitente.nome-emit    
    FIELD fi-nfe-ini             like nota-fiscal.nr-nota-fis
    FIELD fi-nfe-fim             like nota-fiscal.nr-nota-fis
    field rs-situacao            as integer
    field envia-e-mail           as logical.
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
