DEF VAR c-arquivoE AS CHAR NO-UNDO.
DEF VAR c-arquivoS AS CHAR NO-UNDO.
DEF VAR c-linha    AS CHAR NO-UNDO.


ASSIGN c-arquivoE = "C:\temp\Telefones.csv".
INPUT FROM value(c-arquivoE) CONVERT SOURCE "iso8859-1".

ASSIGN c-arquivoS = "C:\temp\Telefones-b.csv".
OUTPUT TO VALUE (c-arquivoS) CONVERT TARGET "iso8859-1".

REPEAT:
    IMPORT UNFORMATTED c-linha.

    FOR FIRST item-ean WHERE item-ean.it-codigo = ENTRY(1, c-linha, ";")EXCLUSIVE-LOCK: 
    
        PUT UNFORMATTED item-ean.it-codigo ";"  
                        item-ean.fone   SKIP.
        
        ASSIGN item-ean.fone = ENTRY(2,c-linha,";").
    
    END.

    RELEASE item-ean.

END.

INPUT CLOSE.
OUTPUT CLOSE.




