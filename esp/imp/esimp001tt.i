def {1} SHARED temp-table tt-perc
    field reg as recid
    field it-codigo like item.it-codigo
    field numero-ordem like ordens-embarque.numero-ordem
    field perc-bruto as dec format ">>9.9999" label "% Bruto"
    field perc-liq   as dec format ">>9.9999" label "% Liq."
    field peso-liq   like item.peso-liquido
    field peso-bruto like item.peso-bruto
    field novo-peso-liq like item.peso-liquido
    field novo-peso-bruto like item.peso-bruto
    field quantidade like ordens-embarque.quantidade.
