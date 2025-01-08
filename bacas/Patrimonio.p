DEFINE VARIABLE cod-estabel    AS CHAR NO-UNDO.
DEFINE VARIABLE num-nota       AS CHAR NO-UNDO.
DEFINE VARIABLE cod-serie      AS CHAR NO-UNDO.
DEFINE VARIABLE cod-patrimonio AS INT  NO-UNDO.

REPEAT:
    
    UPDATE cod-estabel    LABEL "Estabelecimento"
           num-nota       LABEL "Numero da nota"
           cod-serie      LABEL "Serie" SKIP(2)
           cod-patrimonio LABEL "Patrimonio" WITH 1 COLUMN.
    
    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel  = cod-estabel
          AND nota-fiscal.serie        = cod-serie
          AND nota-fiscal.nr-nota-fis  = num-nota:

        IF AVAIL nota-fiscal THEN DO:
            
            FIND FIRST ped-fiscal NO-LOCK
                WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
                  AND ped-fiscal.serie       = nota-fiscal.serie
                  AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

            FIND FIRST it-ped-fiscal EXCLUSIVE-LOCK
                WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido NO-ERROR.

            IF AVAIL it-ped-fiscal THEN
                ASSIGN it-ped-fiscal.nr-patrimonio = cod-patrimonio.
        
        END.
    END.
END.


