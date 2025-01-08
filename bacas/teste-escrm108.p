
DEFINE TEMP-TABLE tt-estrutura NO-UNDO
   FIELD seq            like int-estrutura.sequencia
   FIELD nivel          AS INTEGER
   FIELD it-codigo      LIKE estrutura.it-codigo
   FIELD descricao      AS CHAR FORMAT "X(60)"
   FIELD it-pai         LIKE estrutura.it-codigo
   FIELD quant-usada    AS DECIMAL FORMAT "->>,>>9.9999999999"
   FIELD local-montag   AS CHARACTER FORMAT "x(55)"
   FIELD garantia       AS INTEGER
   FIELD venda          AS LOGICAL
   FIELD permite-os     AS LOGICAL
   FIELD data-fabric    AS DATETIME
   INDEX idx_pri IS PRIMARY UNIQUE seq nivel.

RUN esp/crm/escrm108.r (INPUT "",
                        INPUT "4562109",
                        OUTPUT TABLE tt-estrutura).

FOR EACH tt-estrutura NO-LOCK:
    DISP tt-estrutura.it-codigo 
         tt-estrutura.descricao 
         tt-estrutura.it-pai 
        SKIP.
END.

