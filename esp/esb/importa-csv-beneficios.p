DEFINE VARIABLE c-programa                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-programa            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-grupo                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-grupo               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-csv              AS CHARACTER   FORMAT "X(80)" NO-UNDO.
DEFINE VARIABLE idi_dtsul_prog_dtsul_segur AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-beneficios-canal NO-UNDO
    FIELD canal              AS INTEGER
    FIELD unid-neg           AS CHAR FORMAT "!!!!"
    FIELD classificacao AS CHAR FORMAT "X(15)"
    FIELD categoria     AS CHAR FORMAT "X(15)"
    FIELD guid-beneficio     AS CHAR FORMAT "X(15)"
    FIELD tipo-beneficio     AS INTEGER /* 21-VMC, 22-Stock Rotation, 37-Rebate */
    FIELD guid-canal         AS CHAR FORMAT "X(15)"
    FIELD exclusividade      AS LOG FORMAT "SIM/NAO"
    FIELD perc-global        AS DEC
    FIELD perc-custo         AS DEC
    FIELD perc-prov-meta     AS DEC
    FIELD log-ativo          AS LOG FORMAT "SIM/NÇO"
    FIELD calcular-verba      AS LOG FORMAT "SIM/NÇO"
        INDEX idx1 IS PRIMARY UNIQUE 
            canal
            unid-neg
            classificacao
            categoria
            tipo-beneficio.

DEF TEMP-TABLE tt-retorna-beneficios-canal LIKE tt-beneficios-canal.

def input  param p-canal      AS INTEGER. 
def input  param p-unidade    AS CHAR.
def input  param p-classifica AS CHAR.
def input  param p-categoria  AS CHAR. 
def OUTPUT param TABLE FOR tt-retorna-beneficios-canal.

DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".
INPUT FROM "c:\intelbras\canais\faturamento\beneficios.csv".
    
DEF VAR i AS INTEGER NO-UNDO.

REPEAT: 

    IMPORT UNFORMATTED c-linha.

    IF  i <> 0 THEN DO:
        IF  p-canal      = int(entry(1, c-linha, ";"))                                
        AND p-unidade    = entry(2, c-linha, ";")                                   
        AND STRING(p-classifica) = entry(3, c-linha, ";")
        AND STRING(p-categoria)  = entry(4, c-linha, ";")
        THEN DO:

            FIND FIRST tt-retorna-beneficios-canal
                WHERE tt-retorna-beneficios-canal.canal              = int(entry(1, c-linha, ";"))
                  and tt-retorna-beneficios-canal.unid-neg           = entry(2, c-linha, ";")
                  and tt-retorna-beneficios-canal.classificacao      = (IF p-classifica = "?" THEN "?" ELSE entry(3, c-linha, ";"))
                  AND tt-retorna-beneficios-canal.categoria          = (IF p-categoria  = "?" THEN "?" ELSE entry(4, c-linha, ";"))
                  AND tt-retorna-beneficios-canal.tipo-beneficio     = int(entry(6, c-linha, ";") )
               NO-ERROR .
                  
            IF  NOT AVAIL tt-retorna-beneficios-canal THEN DO:

                CREATE tt-retorna-beneficios-canal.
                ASSIGN tt-retorna-beneficios-canal.canal              = int(entry(1, c-linha, ";"))  
                       tt-retorna-beneficios-canal.unid-neg           = entry(2, c-linha, ";")       
                       tt-retorna-beneficios-canal.classificacao      = p-classifica     
                       tt-retorna-beneficios-canal.categoria          = p-categoria     
                       tt-retorna-beneficios-canal.guid-beneficio     = entry(5, c-linha, ";") 
                       tt-retorna-beneficios-canal.tipo-beneficio     = int(entry(6, c-linha, ";"))
                       tt-retorna-beneficios-canal.perc-global        = dec(entry(7, c-linha, ";"))
                       tt-retorna-beneficios-canal.log-ativo          = IF entry(8, c-linha, ";") = "YES"  THEN YES ELSE NO
                       tt-retorna-beneficios-canal.calcular-verba     = IF entry(9, c-linha, ";") = "YES" THEN YES ELSE NO
                       tt-retorna-beneficios-canal.exclusividade      = IF entry(10, c-linha, ";") = "YES" THEN YES ELSE NO
                       tt-retorna-beneficios-canal.perc-custo         = dec(entry(11, c-linha, ";"))
                       tt-retorna-beneficios-canal.perc-prov-meta     = dec(entry(12, c-linha, ";")).

            END.
    
        END.

    END.        

    i = i + 1.

    IF  c-linha = "" THEN
        LEAVE.
END.              

INPUT CLOSE.
