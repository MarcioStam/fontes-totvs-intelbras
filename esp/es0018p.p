/***********************************************************************
**  Programa..: ESP\ES0018.P
**  Autor.....: Anderson Silvano
**  Data......: Setembro/2005 - Desenvolvimento
**  Descricao.: Programa de retorno de valores da tabela Conteudo-programa
**  Vers∆o....: 001 22/09/2005
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}

/****************************  Definitions  ****************************/
DEF INPUT  PARAM p-nome-programa    LIKE ponto-programa.nome-programa.
DEF INPUT  PARAM p-ponto            LIKE ponto-programa.ponto.
DEF INPUT  PARAM p-sequencia        LIKE conteudo-programa.sequencia.
DEF INPUT  PARAM p-conteudo         LIKE conteudo-programa.conteudo.
DEF OUTPUT PARAM TABLE FOR tt-prog-ponto.
EMPTY TEMP-TABLE tt-prog-ponto.

FIND FIRST ponto-programa NO-LOCK
     WHERE ponto-programa.nome-programa = p-nome-programa
     AND   ponto-programa.ponto         = p-ponto NO-ERROR.
IF AVAIL ponto-programa THEN DO:

    IF p-sequencia = 0 THEN
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            IF p-conteudo NE "" 
            AND conteudo-programa.conteudo NE p-conteudo THEN NEXT.
            
            CREATE tt-prog-ponto.
            ASSIGN tt-prog-ponto.nome-programa = ponto-programa.nome-programa  
                   tt-prog-ponto.ponto         = ponto-programa.ponto          
                   tt-prog-ponto.sequencia     = conteudo-programa.sequencia      
                   tt-prog-ponto.conteudo      = conteudo-programa.conteudo.       
        END.
    ELSE DO:
        FIND FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND   conteudo-programa.sequencia    = p-sequencia NO-ERROR.
        IF AVAIL conteudo-programa THEN DO:
            IF p-conteudo NE "" 
            AND conteudo-programa.conteudo NE p-conteudo THEN NEXT.
            CREATE tt-prog-ponto.
            ASSIGN tt-prog-ponto.nome-programa = ponto-programa.nome-programa  
                   tt-prog-ponto.ponto         = ponto-programa.ponto          
                   tt-prog-ponto.sequencia     = conteudo-programa.sequencia      
                   tt-prog-ponto.conteudo      = conteudo-programa.conteudo.       
        END.
    END.

END.



