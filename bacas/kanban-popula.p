
{C:\fontes11\bacas\kanban.i}

DEFINE VARIABLE c-itens AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.


ASSIGN c-itens = "4080051,4080055,4080057,4080058,4040060,4040095,4040094,4040062,4040503,4041623,4041666,4041658,4080086,4080085,4090400,4090401,4090402,4090403,4090404,4013330,4013341,4013310".


DO TRANS ON ERROR UNDO, LEAVE:

    DO i-aux = 1 TO NUM-ENTRIES(c-itens, ","):

        FOR EACH int-kanban-eletronico EXCLUSIVE-LOCK
            WHERE int-kanban-eletronico.it-codigo = ENTRY(i-aux, c-itens, ","):

            DELETE int-kanban-eletronico.

        END.

        RUN C:\fontes11\bacas\kanban.p (INPUT "yes", /* limpar temp-table saldo */
                                        INPUT "yes", /* atualizar base */
                                        INPUT ENTRY(i-aux, c-itens, ","),
                                        INPUT-OUTPUT TABLE tt-saldo).
        
    END.

END.



MESSAGE "Finalizou"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
