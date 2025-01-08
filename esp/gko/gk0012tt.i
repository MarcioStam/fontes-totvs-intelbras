define temp-table tt-param   no-undo
    field destino               as integer
    field arquivo               as char    format "x(35)"
    field usuario               as char    format "x(12)"
    field data-exec             as date
    field hora-exec             as integer
    FIELD cod-estab-ini         LIKE estabelec.cod-estabel
    FIELD cod-estab-fim         LIKE estabelec.cod-estabel
    field serie-ini             like nota-fiscal.serie
    field serie-fim             like nota-fiscal.serie
    field num-nota-ini          like nota-fiscal.nr-nota-fis
    field num-nota-fim          like nota-fiscal.nr-nota-fis
    field dat-emis-ini          as date    format "99/99/9999"
    field dat-emis-fim          as date    format "99/99/9999"
    field c-diretorio           as character
    field rs-execucao           as INTEGER
    FIELD log-60dias            AS LOGICAL
    FIELD log-reexportar        AS LOGICAL
    FIELD log-correios          AS LOGICAL
    FIELD log-nota-saida        AS LOGICAL
    FIELD log-nota-entrada      as logical.

define temp-table tt-digita no-undo
    field num-nota     like nota-fiscal.nr-nota-fis. 


/***********************************************************
**
**  Defini‡Æo temp-table para passagem de conteudo da tabela
**  conteudo programa
**
************************************************************/

DEF TEMP-TABLE tt-prog-ponto5 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


DEF TEMP-TABLE tt-prog-ponto6 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


DEF TEMP-TABLE tt-prog-ponto7 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


DEF TEMP-TABLE tt-prog-ponto8 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.
