define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field NatOperacaoIni   LIKE docum-est.Nat-Operacao
    field NatOperacaoFim   LIKE docum-est.Nat-Operacao
    field CodEmitenteIni   LIKE docum-est.Cod-Emitente
    field CodEmitenteFim   LIKE docum-est.Cod-Emitente
    field DtEmissaoIni     LIKE docum-est.dt-emissao 
    field DtEmissaoFim     LIKE docum-est.dt-emissao 
    field UfIni            LIKE docum-est.uf
    field UfFim            LIKE docum-est.uf.

define temp-table tt-digita no-undo
    field cd-gr-com as integer   format ">>9"
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
