DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-linha   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-erro    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

ASSIGN c-arquivo = "/opt/totvs/spool/planooem.csv":U
       l-erro    = FALSE.

/* Carrega Itens da planilha */
INPUT FROM VALUE(c-arquivo).
REPEAT:
    
    IMPORT UNFORMATTED c-linha.

    IF NOT CAN-FIND (FIRST tt-item
                     WHERE tt-item.it-codigo = ENTRY(1,c-linha,";")) THEN DO:
        CREATE tt-item.
        ASSIGN tt-item.it-codigo    = ENTRY(1,c-linha,";").
    END.

END.
INPUT CLOSE.

/*---[ Principal ]-----------------------------------------------------*/
OUTPUT TO "/opt/totvs/spool/log-planooem.csv":U NO-CONVERT APPEND.
PUT UNFORMATTED
    "Data: " STRING(TODAY, "99/99/9999":U) " - Hora: " STRING(TIME, "HH:MM:SS":U) SKIP
    CAPS("it-codigo;sequencia;es-codigo;dt-inicio;dt-termino") SKIP.

bloco:
DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                ON ENDKEY UNDO bloco, LEAVE bloco:

    FOR EACH tt-item:

        FOR EACH it-altern EXCLUSIVE-LOCK
            WHERE it-altern.it-codigo = tt-item.it-codigo:
            
            DELETE it-altern.
        END. 
        
        FOR EACH  estrutura NO-LOCK
            WHERE estrutura.it-codigo = tt-item.it-codigo:

            IF estrutura.data-inicio > TODAY AND
               estrutura.data-termino <= TODAY THEN NEXT.
            
            IF NOT CAN-FIND (FIRST it-altern
                             WHERE it-altern.it-codigo = estrutura.it-codigo
                               AND it-altern.it-altern = estrutura.es-codigo) THEN DO:
                CREATE it-altern.
                ASSIGN it-altern.it-codigo = estrutura.it-codigo
                       it-altern.it-altern = estrutura.es-codigo.
            END.
            
        END.
        FOR EACH estrutura EXCLUSIVE-LOCK
            WHERE estrutura.it-codigo = tt-item.it-codigo:

            PUT UNFORMATTED
                estrutura.it-codigo   ";"
                estrutura.sequencia   ";"
                estrutura.es-codigo   ";"
                estrutura.qtd-compon  ";"
                estrutura.data-inicio ";"
                estrutura.data-termino SKIP.

            DELETE estrutura.

        END.


    END. /* FOR EACH tt-item: */

    IF  l-erro THEN 
        UNDO bloco, LEAVE bloco.

END. /* DO  TRANSACTION */

OUTPUT CLOSE.

/*-----------------------------------------------------[ Principal ]---*/
