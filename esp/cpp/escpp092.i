
define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char format "x(35)":U
    field usuario               as char format "x(12)":U
    field data-exec             as date
    field hora-exec             as integer
    field modelo                AS char format "x(35)":U
    FIELD cod-fornec            AS INTEGER
    FIELD cod-emitente          AS INTEGER
    FIELD natureza              AS INTEGER
    FIELD ped-emergenc          AS LOGICAL
    FIELD imprime-ped           AS LOGICAL
    FIELD processo              AS INTEGER
    FIELD frete                 AS INTEGER
    FIELD cod-transp            AS INTEGER
    FIELD via-transp            AS INTEGER
    FIELD cod-estab-entrega     AS CHAR
    FIELD cod-estab-cobranca    AS CHAR
    FIELD cod-cond-pag          AS INTEGER
    FIELD responsavel           AS CHAR
    FIELD cod-mensagem          AS INTEGER
    FIELD cod-estab-gestor      AS CHAR
    FIELD nr-lin-prod           AS INTEGER
    FIELD cod-depos             AS CHAR
    FIELD ct-codigo             AS CHAR
    FIELD sc-codigo             AS CHAR.

define temp-table tt-digita no-undo
    field it-codigo     AS CHAR     FORMAT "X(07)"
    FIELD desc-item     AS CHAR     FORMAT "X(80)"
    FIELD quantidade    AS DEC      FORMAT ">>>,>>>,>>9.9999"
    FIELD preco         AS DEC      FORMAT ">>>,>>>,>>9.9999"
    index id it-codigo.


def temp-table tt-raw-digita
   field raw-digita      as raw.

/*
def temp-table ttcomponente no-undo
   field sequencia     like estrutura.sequencia 
   field es-codigo     like estrutura.es-codigo 
   field desc-item     like item.desc-item
   field quant-est     like estrutura.quant-usada
   field quant-solic   like estrutura.quant-usada label "Qt Solic" help "Quantidade a ser comprada"
   field un            like item.un
   field preco-unit    like cotacao-item.preco-unit format ">>>,>>>,>>9.99999"
   field inclui-ipi    as logical format "Sim/NÆo" label "Inclui IPI?"     help "Informe se o pre‡o informado inclui IPI"
   field numero-ordem  like ordem-compra.numero-ordem
   field parcela       like prazo-compra.parcela
   FIELD cod-emitente  LIKE item-fornec-estab.cod-emitente
   FIELD nome-abrev    LIKE emitente.nome-abrev
   FIELD lote-minimo   LIKE item-fornec-estab.lote-minimo
   FIELD lote-mul-for  LIKE item-fornec-estab.lote-mul-for
   FIELD cod-situacao    AS INT
   FIELD des-situacao    AS CHAR
   index idx_comp 
            sequencia 
            es-codigo.
            */
   
DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura.

