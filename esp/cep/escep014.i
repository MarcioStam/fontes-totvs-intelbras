/* Fl vio Schoenell
  Defini‡Æo das tabelas tempor rias para uso no programa indicador de MP
  06/03/2006
*/

def temp-table tt-produto
    field it-codigo     like item.it-codigo
    field quantidade    as dec format ">>>>>>>9.999999"
    field mes           as int
    field ano           as int
    index codigo is primary it-codigo.

def temp-table tt-estrutura
    field it-codigo     like item.it-codigo
    field es-codigo     like item.it-codigo
    field quantidade    as dec format ">>>>>>>9.999999"
    FIELD mes           AS INT
    FIELD ano           AS INT
    index codigo is primary it-codigo es-codigo.

def temp-table tt-item-mp
    field it-codigo     like item.it-codigo
    field val-unit      as dec format ">>>,>>>,>>9.999999"
    field data-ue       as date
    field taxa          as dec format ">>9.999999"
    field val-unit-us   as dec format ">>>,>>>,>>9.999999"
    FIELD mes           AS INT 
    FIELD ano           AS INT
    index codigo is primary it-codigo.

def temp-table tt-produto-base
    field it-codigo     like item.it-codigo
    field quantidade    as dec format ">>>>>>>9.999999"
    field mes           as int
    field ano           as int
    FIELD fora          AS LOG INIT NO
    index codigo is primary it-codigo.

def temp-table tt-estrutura-base
    field it-codigo     like item.it-codigo
    field es-codigo     like item.it-codigo
    field quantidade    as dec format ">>>>>>>9.999999"
    FIELD fora          AS LOG INIT NO
    index codigo is primary it-codigo es-codigo.

def temp-table tt-item-mp-base
    field it-codigo     like item.it-codigo
    field val-unit      as dec format ">>>,>>>,>>9.999999"
    field data-ue       as date
    field taxa          as dec format ">>9.999999"
    field val-unit-us   as dec format ">>>,>>>,>>9.999999"
    FIELD mes           AS INT 
    FIELD ano           AS INT
    index codigo is primary it-codigo.

DEF TEMP-TABLE tt-geral
    FIELD mes           AS INT
    FIELD ano           AS INT
    FIELD descricao     AS CHAR
    FIELD val-unit      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-base      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-tot       AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD base-tot      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-base-tot  AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD qtd           AS DEC  
    INDEX periodo IS PRIMARY mes ano.

DEF TEMP-TABLE tt-grupo
    FIELD mes           AS INT
    FIELD ano           AS INT
    FIELD descricao     AS CHAR
    FIELD val-unit      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-base      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-tot       AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD base-tot      AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD val-base-tot  AS DEC FORMAT "->>>,>>>,>>9.999999"
    FIELD qtd           AS DEC  
    INDEX periodo IS PRIMARY mes ano.

DEF TEMP-TABLE tt-produto-tot
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD qtd         AS DEC EXTENT 12
    FIELD valor       AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-base  AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX codigo IS PRIMARY it-codigo.

DEF TEMP-TABLE tt-grupo-tot
    FIELD cod-grupo   AS int
    FIELD valor       AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-base  AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX codigo IS PRIMARY cod-grupo.

DEF TEMP-TABLE tt-item-mp-tot
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD es-codigo LIKE ITEM.it-codigo
    FIELD val-unit    AS DEC EXTENT 12
    FIELD qtd         AS DEC EXTENT 12
    FIELD valor       AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-base  AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX codigo IS PRIMARY it-codigo.
 
DEF TEMP-TABLE tt-geral-tot
    FIELD valor       AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-base  AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12.

DEF TEMP-TABLE tt-periodo
    FIELD mes AS CHAR
    FIELD ano AS CHAR.

DEF TEMP-TABLE tt-rel-item
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD origem AS INT
    INDEX codigo IS PRIMARY origem it-codigo.

