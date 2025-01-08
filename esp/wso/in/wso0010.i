
/*---------------------------------------------------------------------------*/
define {1} temp-table MsgErro no-undo
/*---------------------------------------------------------------------------*/
    field SeqErro as integer
    field DescErro as character
        index idErro is primary unique SeqErro.

/* ------------------------------------------------------------------ */
/*          TEMP-TABLES PARA CRIA°€O DO PEDIDO NO TOTVS               */
/* -------------------------------------------------------------------*/
/** temp-tables para BO's **/
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

define temp-table tt-ped-venda no-undo like ped-venda
   field r-rowid  as rowid.
define temp-table tt-ped-item no-undo like ped-item
   field r-rowid  as rowid.
define temp-table tt-ped-ent no-undo like ped-ent
   field r-rowid  as rowid.
define temp-table tt-ped-repre no-undo like ped-repre
   field r-rowid  as rowid.
define temp-table tt-ped-antecip no-undo like ped-antecip
   field r-rowid  as rowid.
define temp-table tt-cond-ped no-undo like cond-ped
   field r-rowid  as rowid.

define temp-table tt-ped-vendor no-undo
   field data-base    as date
   field dias-base    as integer format ">>>9"
   field cod-cond-pag as integer format ">9"
   field taxa-cliente as decimal format ">>9.9999".

define temp-table ttEstabPedido no-undo
    field cod-estabel like estabelec.cod-estabel.

define temp-table tt-ped-valid no-undo
    field PedidoCodigo as character
    FIELD contaCodigo  AS CHARACTER.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.
