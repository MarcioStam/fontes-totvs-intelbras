def temp-table tt-fda-lote-avancad no-undo like fda-lote-avancad
    field i-tipo-estado-inicial as int
    field r-rowid               as rowid
    field i-seq                 as integer
    field nr-trans              like movto-estoq.nr-trans
    field l-atualizado          as log.

def temp-table tt-fda-lote-histor no-undo like fda-lote-histor
    field l-atualizado as log
    field r-rowid      as rowid
    field i-seq        as integer.
