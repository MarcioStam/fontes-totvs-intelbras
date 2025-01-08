
DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-saida
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD desc-item LIKE ITEM.desc-item
    FIELD class-fiscal LIKE ITEM.class-fiscal.



INPUT FROM /opt/totvs/spool/Itens_2011.csv.

REPEAT :

    IMPORT c-it-codigo.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = c-it-codigo:

        IF ITEM.compr-fabric = 2 THEN
            RUN pi-desce-estrutura (INPUT c-it-codigo).
        ELSE 
            RUN pi-cria-tt.

    END.

END.

INPUT CLOSE.


OUTPUT TO /opt/totvs/spool/itens-receita-federal.csv.

FOR EACH tt-saida
    BY tt-saida.it-codigo:


    PUT UNFORMATTED
        tt-saida.it-codigo + ";" +
        tt-saida.desc-item + ";" + 
        tt-saida.class-fiscal SKIP.
    

END.

OUTPUT CLOSE.



PROCEDURE pi-desce-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo     = p-it-codigo
        AND   estrutura.data-inicio  >= 01/01/2011
        AND   estrutura.data-termino <= 12/31/2011:

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = estrutura.es-codigo:

            IF item.compr-fabric = 2 THEN
                RUN pi-desce-estrutura (INPUT estrutura.es-codigo).
            ELSE
                RUN pi-cria-tt.

        END.

    END.


END PROCEDURE.


PROCEDURE pi-cria-tt:

    FOR FIRST tt-saida
        WHERE tt-saida.it-codigo = ITEM.it-codigo:
    END.

    IF NOT AVAIL tt-saida THEN DO:

        CREATE tt-saida.
        ASSIGN tt-saida.it-codigo = ITEM.it-codigo
               tt-saida.desc-item = ITEM.desc-item
               tt-saida.class-fiscal = ITEM.class-fiscal.

    END.



END PROCEDURE.
