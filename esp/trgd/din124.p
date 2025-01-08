/********************************************************************************
 ** UPC........: din124.p - UPC DELETE ficha-cq
 ** Data.......: Setembro / 2014
 ** Objetivo...: Eliminar ae-inspecao relacionada a ficha-cq
 ********************************************************************************/
DEF PARAM BUFFER b-ficha-cq FOR ficha-cq.

{esp/es0018.i}

EMPTY TEMP-TABLE tt-prog-ponto.
    
RUN esp/es0018p.p (INPUT "ALM-WMS":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

IF NOT CAN-FIND(FIRST tt-prog-ponto
                WHERE tt-prog-ponto.conteudo = b-ficha-cq.cod-estabel) THEN DO:

    {esp/crm/escrm001.i} /* Definicao de temp-table */
    {esp/crm/escrm001a.i1} /* Definicao de temp-table */
    
    
    FOR EACH ae-inspecao EXCLUSIVE-LOCK
        WHERE ae-inspecao.nr-ficha = b-ficha-cq.nr-ficha:
    
        DELETE ae-inspecao.
    
    END.
END.

RETURN "OK".
                       
