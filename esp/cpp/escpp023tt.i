define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field ep-codigo        like mgcad.empresa.ep-codigo
    FIELD cod-item         LIKE item.it-codigo
    FIELD c-descricao      AS CHAR format "X(36)"
    FIELD Ident            AS INT
    FIELD l-parcial        AS LOGICAL /*utilizado pra imprimir somente alguns componentes*/ .


define temp-table tt-digita no-undo
    field selecionado as logical
    field componente as character format "x(16)"
    field descricao as character format "x(60)"
    index id componente
    index sel selecionado.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.



def new shared temp-table tt-seq
    field montadora        like monta-estrutura.montadora
    field posicao          as char format "X(35)"
    field it-codigo        like monta-estrutura.it-codigo
    index tt-seq is primary unique montadora posicao it-codigo.



def var i-centro          as int.
def var i-ind             as int.
def var c-descricao1      as char format "X(35)".
def var c-posicao         as char extent 3 format "X(35)".
def var c-desc-componente as char extent 3 format "X(35)". 
def var c-desc-componente-2 as char extent 3 format "X(35)". 
def var i-montadora       as int  extent 3  format ">>".
def var c-desc-acabado    as char extent 3 format "X(35)".
def var c-item            as char extent 3 format "X(09)".
def var c-traco           as char format "x(80)".
def var c-desc-temp       as char format "X(35)".
def var c-desc-temp-2     as char format "X(35)".
def var l-tp-etiqueta     as log format "Pequena/Grande".
def var c-dt-ult-alter    as char format "x(10)".
