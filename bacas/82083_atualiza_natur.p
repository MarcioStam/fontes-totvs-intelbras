DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-operacao   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-cons-averb-seg AS LOG         NO-UNDO.

OUTPUT TO c:\temp\naturezas_atualizadas.csv.
INPUT FROM c:\temp\lista_naturezas.csv.

REPEAT :
    IMPORT UNFORMATTED c-linha.

    ASSIGN c-nat-operacao   = ENTRY(1, c-linha, ";")
           l-cons-averb-seg = IF ENTRY(2, c-linha, ";") = "sim" OR ENTRY(2, c-linha, ";") = "yes" THEN YES ELSE NO.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = c-nat-operacao NO-ERROR.

    IF AVAIL natur-oper THEN DO:
        FIND FIRST int-natur-oper EXCLUSIVE-LOCK
             WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.

        IF NOT AVAIL int-natur-oper THEN DO:
            CREATE int-natur-oper.
            ASSIGN int-natur-oper.nat-operacao = natur-oper.nat-operacao.
        END.

        ASSIGN int-natur-oper.cons-averb-seg = l-cons-averb-seg.

        PUT UNFORMATTED
            int-natur-oper.nat-operacao           ";"
            string(int-natur-oper.cons-averb-seg) ";" SKIP.
    END.
    ELSE DO:
        PUT UNFORMATTED
            "** Natureza " + c-nat-operacao + " n∆o cadastrada;" SKIP.
    END.
END.

INPUT CLOSE.
OUTPUT CLOSE.
