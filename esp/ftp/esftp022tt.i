define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field DtEmissaoIni     LIKE nota-fiscal.Dt-Emis-nota
    field DtEmissaoFim     LIKE nota-fiscal.Dt-Emis-nota
    field EstadoIni        LIKE nota-fiscal.Estado
    field EstadoFim        LIKE nota-fiscal.Estado
    field NatOperacaoIni   LIKE nota-fiscal.Nat-Operacao
    field NatOperacaoFim   LIKE nota-fiscal.Nat-Operacao
    field TipoImpressao    AS   INT
    field cod-estabel-ini  like nota-fiscal.cod-estabel
    field cod-estabel-fim  like nota-fiscal.cod-estabel.

    

define temp-table tt-digita no-undo
    field cd-gr-com as integer   format ">>9"
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
