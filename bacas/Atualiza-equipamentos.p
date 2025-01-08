DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-cab AS LOGICAL   INIT TRUE  NO-UNDO.

DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-tipo AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-ativo AS LOGICAL     NO-UNDO.

OUTPUT TO c:\temp\atualiza-equipamentos-prod.csv.
INPUT FROM c:\temp\lista-equipamentos-prod.csv.

PUT UNFORMATTED
    'Estab;Equipamento;Tipo Antes;Tipo Depois;Situacao Antes;Situacao Depois' SKIP.

REPEAT :

    IMPORT UNFORMATTED c-linha.

    IF l-cab THEN DO:
        ASSIGN l-cab = FALSE.
        NEXT.
    END.

    ASSIGN c-equipamento = ENTRY(1, c-linha, ";")
           c-cod-estabel = ENTRY(2, c-linha, ";")
           i-tipo        = int(ENTRY(4, c-linha, ";"))
           l-ativo       = IF ENTRY(9, c-linha, ";") = "ativo" THEN TRUE ELSE FALSE.

    FOR FIRST equipamentos EXCLUSIVE-LOCK
        WHERE equipamentos.cod-estabel = c-cod-estabel
        AND   equipamentos.equipamento = c-equipamento:

        PUT UNFORMATTED
            equipamentos.cod-estabel    ";"
            equipamentos.equipamento    ";"
            equipamentos.tipo           ";"
            i-tipo                      ";"
            equipamentos.ind-situacao   ";"
            IF l-ativo THEN '0' ELSE '2' SKIP.

        ASSIGN equipamentos.tipo = i-tipo
               equipamentos.ind-situacao = IF l-ativo THEN 0 ELSE 2.

    END.

    IF NOT AVAIL equipamentos THEN DO:

        PUT UNFORMATTED
            c-cod-estabel    ";"
            c-equipamento    ";"
            "*** EQUIPAMENTO NÇO ENCONTRADO ****" SKIP.

    END.

END.

INPUT CLOSE.
OUTPUT CLOSE.
