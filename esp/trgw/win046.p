/********************************************************************************
 ** UPC........: win046.p - UPC WRITE classif-fiscal
 ** Data.......: Setembro / 2015
 ** Objetivo...: Cria tabela ncm-origem
 ********************************************************************************/

DEF PARAM BUFFER b-classif-fisc      FOR classif-fisc.
DEF PARAM BUFFER b-old-classif-fisc  FOR classif-fisc.

DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

ASSIGN i-cont = 0.

IF AVAIL b-classif-fisc THEN DO:
    DO i-cont = 0 TO 8: /*Codigos de Origens do Item*/
    
        IF NOT CAN-FIND (FIRST ncm-origem NO-LOCK
                         WHERE ncm-origem.cod-ncm     = b-classif-fisc.class-fiscal
                           AND ncm-origem.codigo-orig = i-cont) THEN DO:

            CREATE ncm-origem.
            ASSIGN ncm-origem.cod-ncm     = b-classif-fisc.class-fiscal
                   ncm-origem.codigo-orig = i-cont.           
        END.  
    END.
END.
    
    
