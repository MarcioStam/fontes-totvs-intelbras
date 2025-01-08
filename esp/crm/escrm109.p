/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm109.p
**  Autor.....: Gustavo Eduardo Tamanini
**  Data......: Junho/2011 - Desenvolvimento
**  Descricao.: Item Tabela Preco
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-preco-item NO-UNDO
    FIELD it-codigo    LIKE preco-item.it-codigo  
    FIELD descricao    LIKE ITEM.desc-item
    FIELD preco-venda  LIKE preco-item.preco-venda
    FIELD preco-venda2 AS DECIMAL FORMAT ">>>>>>>>9.99999"
    FIELD preco-venda3 AS DECIMAL FORMAT ">>>>>>>>9.99999"
    INDEX idx_pri IS PRIMARY UNIQUE it-codigo.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEFINE OUTPUT PARAMETER TABLE FOR tt-preco-item.

EMPTY TEMP-TABLE tt-preco-item.

RUN esp/es0018p.p (INPUT "es0778", /* Nome do programa */
                   INPUT 2,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST param-global NO-LOCK.

FOR EACH estabelec
    WHERE estabelec.cod-estabel = "101" NO-LOCK:

    FIND FIRST tt-prog-ponto WHERE tt-prog-ponto.sequencia = INT(estabelec.cod-estabel) NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-prog-ponto THEN NEXT.

    FOR EACH preco-item NO-LOCK USE-INDEX ch-tabitem
        WHERE preco-item.nr-tabpre   = ENTRY(4,tt-prog-ponto.conteudo,";")
          AND preco-item.quant-min  >= 0
          AND preco-item.cod-refer   = ''
          AND preco-item.situacao    = 1
          AND preco-item.dt-inival  <= today
          AND preco-item.preco-venda > 0,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = preco-item.it-codigo
        BREAK BY preco-item.it-codigo:
        
        IF NOT CAN-FIND(FIRST tt-preco-item
                        WHERE tt-preco-item.it-codigo = preco-item.it-codigo) THEN DO:
            CREATE tt-preco-item.
            ASSIGN tt-preco-item.it-codigo    = preco-item.it-codigo                    
                   tt-preco-item.descricao    = ITEM.desc-item
                   tt-preco-item.preco-venda  = (preco-item.preco-venda - (preco-item.preco-venda * 0.3333))
                   tt-preco-item.preco-venda2 = preco-item.preco-venda
                   tt-preco-item.preco-venda3 = 0.
        END.
    END.
END.

IF  CAN-FIND(FIRST tt-preco-item) THEN
    RETURN 'ok'.
ELSE
    RETURN 'nok'.

