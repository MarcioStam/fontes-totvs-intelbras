define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD iTipoNota        AS INT
    FIELD ItCodigoIni      LIKE ITEM.it-codigo
    FIELD ItCodigoFim      LIKE ITEM.it-codigo 
    FIELD NrEmbarqueIni    LIKE nota-fiscal.nr-embarque
    FIELD NrEmbarqueFim    LIKE nota-fiscal.nr-embarque 
    FIELD NrNotaFisIni     LIKE nota-fiscal.nr-nota-fis
    FIELD NrNotaFisFim     LIKE nota-fiscal.nr-nota-fis
    FIELD NrVolumeIni      AS INT /*LIKE volume-nf.nr-volume*/
    FIELD NrVolumeFim      AS INT /*LIKE volume-nf.nr-volume*/ 
    FIELD Rastreabilidade  AS INTEGER
    FIELD tipo-volume      AS INTEGER
    FIELD nome-transp-ini  LIKE embarque.nome-transp
    FIELD ImprimeEtiqueta  AS INT
    FIELD i-impressora     AS INT
    FIELD notas-mg         AS INT
    FIELD l-estado         AS LOG
    FIELD c-estado         AS CHAR
    field cod-estabel      as char
    FIELD notas-desconsiderar AS CHARACTER
    FIELD reimpressao      AS LOGICAL
    FIELD l-imprime-barra  AS LOGICAL.

define temp-table tt-digita no-undo
    FIELD nr-embarque   LIKE embarque.nr-embarque
    FIELD dt-embarque   LIKE embarque.dt-embarque
    FIELD identific     LIKE embarque.identific  
    index id nr-embarque.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
