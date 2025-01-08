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
                      
DEF TEMP-TABLE tt-beneficios-canal
    FIELD canal              AS INTEGER
    FIELD unid-neg           AS CHAR FORMAT "!!!"
    FIELD guid-classificacao AS CHAR FORMAT "X(15)"
    FIELD guid-categoria     AS CHAR FORMAT "X(15)"
    FIELD guid-canal         AS CHAR FORMAT "X(15)"
    FIELD guid-beneficio     AS CHAR FORMAT "X(15)"
    FIELD tipo-beneficio     AS INTEGER /* 21-VMC, 22-Stock Rotation, 37-Rebate */
    FIELD exclusividade      AS LOG FORMAT "SIM/NAO"
    FIELD perc-global        AS DEC
    FIELD log-ativo          AS LOG FORMAT "SIM/NÃO"
    FIELD calcular-verba      AS LOG FORMAT "SIM/NÃO"
        INDEX idx1 IS PRIMARY UNIQUE 
            canal
            unid-neg
            guid-classificacao
            guid-categoria
            tipo-beneficio.

DEF TEMP-TABLE tt-retorna-beneficios-canal LIKE tt-beneficios-canal.

RUN esp/esb/importa-csv-beneficios.p (INPUT 187983,
                                      INPUT "ICON",
                                      INPUT "VAD",
                                      INPUT "OURO",
                                      OUTPUT TABLE tt-retorna-beneficios-canal).

FOR EACH tt-retorna-beneficios-canal:

  DISP  tt-retorna-beneficios-canal.canal             
        tt-retorna-beneficios-canal.guid-canal             
        tt-retorna-beneficios-canal.unid-neg          
        tt-retorna-beneficios-canal.guid-classificacao
        tt-retorna-beneficios-canal.guid-categoria    
        tt-retorna-beneficios-canal.guid-beneficio    
        tt-retorna-beneficios-canal.tipo-beneficio    

        tt-retorna-beneficios-canal.perc-global       
        tt-retorna-beneficios-canal.log-ativo         
        tt-retorna-beneficios-canal.calcular-verba    
        tt-retorna-beneficios-canal.exclusividade     WITH 1 COLUMN.     
  PAUSE.
END.
