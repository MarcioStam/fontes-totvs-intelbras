def input param p_cod-item  AS char.
DEF INPUT PARAM p_data-inicial AS DATE.
DEF INPUT PARAM p_data-final   AS DATE.
DEFINE VARIABLE dt-ini             AS DATETIME NO-UNDO.
DEFINE VARIABLE dt-fim             AS DATETIME NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD CodigoProduto             AS CHAR 
    FIELD NomeProduto               AS CHARACTER.

DEFINE TEMP-TABLE NumeroSerieItem NO-UNDO XML-NODE-NAME 'NumeroSerieItem'
    FIELD CodigoProduto             AS CHAR
    FIELD NumeroSerieProduto         AS CHAR
    FIELD DataGerado                 AS DATE.

def input-output parameter table for ProdutoItem.
def input-output parameter table for NumeroSerieItem.

DEF VAR c-desc-item AS CHAR NO-UNDO.
    
ASSIGN dt-ini = DATETIME(MONTH (p_data-inicial), 
                         DAY   (p_data-inicial),
                         YEAR  (p_data-inicial),
                         0,  /* hora */
                         0,  /* minutos */
                         0,  /* segundos */
                         0)  /* milisegundos */

       dt-fim = DATETIME(MONTH (p_data-final), 
                         DAY   (p_data-final),
                         YEAR  (p_data-final),
                         23,  /* hora */
                         59,  /* minutos */
                         59,  /* segundos */
                         999) /* milisegundos */.
    
    
ASSIGN i = 0.

FOR EACH num-serie USE-INDEX data NO-LOCK
        WHERE num-serie.data >= dt-ini
          AND num-serie.data <= dt-fim
          AND num-serie.it-codigo = p_cod-item   
          BREAK BY date(num-serie.data)
                BY num-serie.it-codigo:
                IF  i = 0 THEN DO:
                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = num-serie.it-codigo:
                        ASSIGN c-desc-item = ITEM.desc-item.
                    END.

                    
                    CREATE ProdutoItem.
                    ASSIGN ProdutoItem.CodigoProduto = num-serie.it-codigo
                           ProdutoItem.NomeProduto   = c-desc-item.
                END.
                i = i + 1.
                
                CREATE NumeroSerieItem.
                ASSIGN NumeroSerieItem.CodigoProduto      = num-serie.it-codigo 
                       NumeroSerieItem.NumeroSerieProduto = num-serie.n-serie
                       NumeroSerieItem.DataGerado         = num-serie.data.
END.

