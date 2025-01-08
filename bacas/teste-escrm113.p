
DEFINE TEMP-TABLE tt-estrutura NO-UNDO
   FIELD seq            like int-estrutura.sequencia
   FIELD nivel          AS INTEGER
   FIELD it-codigo      LIKE estrutura.it-codigo
   FIELD descricao      AS CHAR FORMAT "X(60)"
   FIELD it-pai         LIKE estrutura.it-codigo
   FIELD local-montag   AS CHARACTER FORMAT "x(55)"
   INDEX idx_pri IS PRIMARY UNIQUE seq nivel
   INDEX it it-codigo.

RUN esp/crm/escrm113.r (INPUT "4390164",
                        INPUT "",
                        OUTPUT TABLE tt-estrutura).

FOR EACH tt-estrutura
    WHERE tt-estrutura.it-codigo = "4990294" NO-LOCK:
    DISP tt-estrutura.it-pai        format "X(10)"
         tt-estrutura.it-codigo     format "X(10)"
         tt-estrutura.local-montag  format "X(10)"
        SKIP.
END.
