DEFINE VARIABLE c-programa                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-programa            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-grupo                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-grupo               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-csv              AS CHARACTER   FORMAT "X(80)" NO-UNDO.
DEFINE VARIABLE idi_dtsul_prog_dtsul_segur AS INTEGER     NO-UNDO.


DEF TEMP-TABLE tt-canal-categoria
    FIELD canal               AS INTEGER
    FIELD unid-neg            AS CHAR FORMAT "!!!"
    FIELD guid-classificacao  AS CHAR FORMAT "X(15)"
    FIELD guid-categoria      AS CHAR FORMAT "X(15)"
    FIELD guid-canal          AS CHAR FORMAT "X(15)"
        INDEX idx-canal-categoria IS PRIMARY UNIQUE
                canal     
                unid-neg         
                guid-classificacao 
                guid-categoria  
        INDEX idx-categoria
                unid-neg         
                guid-classificacao 
                guid-categoria     .

define temp-table resultado no-undo xml-node-name 'Resultado'
   field idm as int xml-node-type 'hidden'
   field Sucesso as log initial yes
   field CodigoErro as int
   field Mensagem as CHAR INITIAL "".

def input  param p-canal      AS INTEGER. 
def input  param p-guid-canal AS CHAR. 
DEF OUTPUT PARAM TABLE FOR resultado.
DEF OUTPUT PARAM TABLE FOR tt-canal-categoria.

DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".
INPUT FROM "c:\intelbras\canais\faturamento\categorias.csv".
    
DEF VAR i AS INTEGER NO-UNDO.

REPEAT: 

    IMPORT UNFORMATTED c-linha.

    IF  i <> 0  THEN DO:
        
        IF   int(entry(1, c-linha, ";")) = p-canal THEN
        DO:
            CREATE tt-canal-categoria.
            ASSIGN tt-canal-categoria.canal                    = int(entry(1, c-linha, ";"))
                   tt-canal-categoria.guid-canal               = entry(1, c-linha, ";")
                   tt-canal-categoria.unid-neg                 = entry(2, c-linha, ";")
                   tt-canal-categoria.guid-classificacao       = entry(3, c-linha, ";") 
                   tt-canal-categoria.guid-categoria           = entry(4, c-linha, ";") .

         END.


    END.
    i = i + 1.

    IF  c-linha = "" THEN
        LEAVE.
END.            

CREATE resultado.
ASSIGN resultado.sucesso = YES.

INPUT CLOSE.
