
DEFINE VARIABLE c-programa                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-programa            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-grupo                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-grupo               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-csv              AS CHARACTER   FORMAT "X(80)" NO-UNDO.
DEFINE VARIABLE idi_dtsul_prog_dtsul_segur AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-fat-mensal
  FIELD ano                 AS INTEGER
  FIELD mes                 AS INTEGER
  FIELD canal               AS INTEGER
  FIELD unid-neg            AS CHAR FORMAT "X(3)"
  FIELD canal-matriz        AS INTEGER
  FIELD guid-canal          AS CHAR FORMAT "X(30)"
  FIELD guid-canal-matriz   AS CHAR FORMAT "X(15)"
  FIELD guid-classificacao  AS CHAR FORMAT "X(15)"
  FIELD guid-categoria      AS CHAR FORMAT "X(15)"
  FIELD guid-regiao         AS CHAR FORMAT "X(15)"
  FIELD segmento            AS CHAR FORMAT "X(2)"
  FIELD vl-faturado         AS DEC FORMAT ">>>>,>>>,>>9.99"
  FIELD vl-devolvido        AS DEC FORMAT ">>>>,>>>,>>9.99"
  FIELD vl-apurado          AS DEC FORMAT ">>>>,>>>,>>9.99"
      INDEX idx1 IS UNIQUE PRIMARY ano 
                                   mes
                                   canal
                                   unid-neg 
                                   segmento
      INDEX idx-canal canal
                      unid-neg
                      guid-classificacao.
                      

DEF OUTPUT PARAM TABLE FOR tt-fat-mensal.

DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".
INPUT FROM "c:\intelbras\canais\faturamento\faturamento.csv".
    
DEF VAR i AS INTEGER NO-UNDO.

REPEAT: 

    IMPORT UNFORMATTED c-linha.

    IF  i <> 0 THEN DO:

        FIND FIRST tt-fat-mensal
            WHERE tt-fat-mensal.ano                = int(entry(1, c-linha, ";"))
              and tt-fat-mensal.mes                = int(entry(2, c-linha, ";"))
              and tt-fat-mensal.canal              = int(entry(3, c-linha, ";"))
              AND tt-fat-mensal.unid-neg           = entry(4, c-linha, ";")  
              AND tt-fat-mensal.segmento           = entry(8, c-linha, ";") NO-ERROR.

        IF  NOT AVAIL tt-fat-mensal THEN
            CREATE tt-fat-mensal.

        
        ASSIGN tt-fat-mensal.ano                = int(entry(1, c-linha, ";"))
               tt-fat-mensal.mes                = int(entry(2, c-linha, ";"))
               tt-fat-mensal.canal              = int(entry(3, c-linha, ";"))
               tt-fat-mensal.unid-neg           = entry(4, c-linha, ";")
               tt-fat-mensal.guid-classificacao = entry(5, c-linha, ";")
               tt-fat-mensal.guid-categoria     = entry(6, c-linha, ";")
               tt-fat-mensal.guid-regiao        = entry(7, c-linha, ";")
               tt-fat-mensal.segmento           = entry(8, c-linha, ";")
               tt-fat-mensal.vl-faturado        = tt-fat-mensal.vl-faturado + dec(entry(9, c-linha, ";"))
               tt-fat-mensal.vl-devolvido       = tt-fat-mensal.vl-devolvido + dec(entry(10, c-linha, ";"))
               tt-fat-mensal.vl-apurado         =  tt-fat-mensal.vl-apurado + dec(entry(11, c-linha, ";"))
               tt-fat-mensal.guid-canal         = entry(12, c-linha, ";")        
               tt-fat-mensal.canal-matriz       = int(entry(13, c-linha, ";"))   
               tt-fat-mensal.guid-canal-matriz  = entry(14, c-linha, ";")        .
    END.        

    i = i + 1.

    IF  c-linha = "" THEN
        LEAVE.
END.              

INPUT CLOSE.

/*                                                    */
/* FOR EACH tt-fat-mensal:                            */
/*                                                    */
/*   DISP  tt-fat-mensal.ano                          */
/*         tt-fat-mensal.mes                          */
/*         tt-fat-mensal.canal                        */
/*         tt-fat-mensal.unid-neg                     */
/*         tt-fat-mensal.canal-matriz                 */
/*         tt-fat-mensal.guid-canal                   */
/*         tt-fat-mensal.guid-canal-matriz            */
/*         tt-fat-mensal.guid-classificacao           */
/*         tt-fat-mensal.guid-categoria               */
/*         tt-fat-mensal.guid-regiao                  */
/*         tt-fat-mensal.segmento                     */
/*         tt-fat-mensal.vl-faturado                  */
/*         tt-fat-mensal.vl-devolvido                 */
/*         tt-fat-mensal.vl-apurado   WITH 1 COLUMN.  */
/*   PAUSE.                                           */
/* END.                                               */
/*                                                    */
