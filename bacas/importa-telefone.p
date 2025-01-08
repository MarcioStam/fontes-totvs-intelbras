DEF VAR v-arq AS CHAR FORMAT "x(10)".
DEF VAR v-caminho AS CHAR.
DEF VAR c-linha AS CHAR.

UPDATE v-arq.

ASSIGN v-caminho = "c:\temp\telefone\" + v-arq + ".csv".


INPUT FROM VALUE(v-caminho) CONVERT SOURCE "iso8859-1".

REPEAT:
    IMPORT UNFORMATTED c-linha.
    
    FOR FIRST item-ean
        WHERE item-ean.it-codigo = entry(1, c-linha, ";") EXCLUSIVE-LOCK:

        CASE v-arq:
            WHEN "fone-0006" THEN
                ASSIGN item-ean.fone = "Suporte: (48) 2106-0006".
            WHEN "fone-0071" THEN
                ASSIGN item-ean.fone = "Suporte: (48) 2106-0071".
            WHEN "fone-0072" THEN
                ASSIGN item-ean.fone = "Suporte: (48) 2106-0072".

        END CASE.
    END.
    
END.
INPUT CLOSE.


