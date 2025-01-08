/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm110.p
**  Autor.....: Gustavo Eduardo Tamanini
**  Data......: Julho/2011 - Desenvolvimento
**  Descricao.: Estrutura Item - B2B/CRM
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO
   FIELD seq          LIKE int-estrutura.sequencia
   FIELD nivel        AS INTEGER
   FIELD it-codigo    LIKE estrutura.it-codigo
   FIELD descricao    AS CHAR FORMAT "X(60)"
   FIELD aliquota-ipi LIKE ITEM.aliquota-ipi
   FIELD preco-venda  LIKE preco-item.preco-venda
   FIELD preco-venda2 AS DECIMAL FORMAT ">>>>>>>>9.99999"
   FIELD preco-venda3 AS DECIMAL FORMAT ">>>>>>>>9.99999"
   INDEX idx_pri IS PRIMARY UNIQUE seq nivel.

DEFINE INPUT  PARAMETER pItem AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-estrutura.

DEFINE VARIABLE cSigla  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cData   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE dtEstr  AS DATE                 NO-UNDO.
DEFINE VARIABLE cNumero AS INTEGER              NO-UNDO.
DEFINE VARIABLE i-seq   AS INTEGER    INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-nivel AS INTEGER    INITIAL 1 NO-UNDO.
DEFINE VARIABLE cItem   LIKE ITEM.it-codigo.

DEFINE VARIABLE c-nr-tabpre AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-garantia AS LOGICAL     NO-UNDO.

DEF BUFFER bitem FOR ITEM.

FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "es0778"
      AND ponto-programa.ponto         = 2,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
      AND conteudo-programa.sequencia    = 101:
    
    ASSIGN c-nr-tabpre =  ENTRY(4,conteudo-programa.conteudo,";":U).
END.

EMPTY TEMP-TABLE tt-estrutura.

FOR EACH estrutura NO-LOCK 
   WHERE estrutura.it-codigo     = pItem
     AND estrutura.data-inicio  <= TODAY           
     AND estrutura.data-termino >  TODAY
     BREAK BY estrutura.it-codigo:
    
    ASSIGN i-seq = i-seq + 1.

    FIND FIRST int-estrutura NO-LOCK
         WHERE int-estrutura.it-codigo = estrutura.it-codigo
           AND int-estrutura.sequencia = estrutura.sequencia
           AND int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

    IF AVAILABLE int-estrutura    AND
       int-estrutura.garantia = 0 THEN DO:
        RUN esp/crm/escrm108a.p (INPUT  int-estrutura.es-codigo,
                                 INPUT  TODAY,
                                 OUTPUT l-garantia).

        IF l-garantia = NO THEN NEXT.
    END.

    IF FIRST-OF(estrutura.it-codigo) THEN DO:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.it-codigo NO-ERROR.

        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq           = 1
               tt-estrutura.nivel         = 1
               tt-estrutura.it-codigo     = ITEM.it-codigo
               tt-estrutura.descricao     = IF AVAIL int-estrutura AND int-estrutura.desc-alt <> "":U THEN int-estrutura.desc-alt ELSE ITEM.desc-item               
               tt-estrutura.aliquota-ipi  = ITEM.aliquota-ipi.

        FIND FIRST preco-item NO-LOCK
             WHERE preco-item.it-codigo  = ITEM.it-codigo 
               AND preco-item.cod-refer  = ""
               AND preco-item.nr-tabpre  = c-nr-tabpre
               AND preco-item.dt-inival <= TODAY
               AND preco-item.situacao   = 1 NO-ERROR.

        IF AVAIL preco-item THEN DO:
            ASSIGN tt-estrutura.preco-venda   = (preco-item.preco-venda - (preco-item.preco-venda * 0.3333))
                   tt-estrutura.preco-venda2  = preco-item.preco-venda
                   tt-estrutura.preco-venda3  = 0.
        END.
    END. 

    FIND FIRST bItem NO-LOCK
         WHERE bItem.it-codigo = estrutura.es-codigo NO-ERROR.

    FIND FIRST preco-item NO-LOCK
         WHERE preco-item.it-codigo  = estrutura.es-codigo
           AND preco-item.cod-refer  = ""
           AND preco-item.nr-tabpre  = c-nr-tabpre
           AND preco-item.dt-inival <= TODAY
           AND preco-item.situacao   = 1 NO-ERROR.

    IF AVAIL preco-item THEN DO:
        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq          = i-seq
               tt-estrutura.nivel        = 2
               tt-estrutura.it-codigo    = estrutura.es-codigo
               tt-estrutura.descricao    = IF AVAIL int-estrutura AND int-estrutura.desc-alt <> "":U THEN int-estrutura.desc-alt ELSE bItem.desc-item 
               tt-estrutura.aliquota-ipi = bItem.aliquota-ipi
               tt-estrutura.preco-venda  = (preco-item.preco-venda - (preco-item.preco-venda * 0.3333))
               tt-estrutura.preco-venda2 = preco-item.preco-venda
               tt-estrutura.preco-venda3 = 0.
    END.

    ASSIGN i-nivel = 2.

    RUN pi-estrutura (INPUT estrutura.es-codigo,
                      INPUT TODAY).

    RELEASE int-estrutura.
END.

FOR EACH tt-estrutura:
    IF tt-estrutura.nivel = 0 THEN NEXT.

    FIND FIRST prod-composto
        WHERE prod-composto.it-codigo-pai = tt-estrutura.it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE prod-composto THEN DO:
        FIND FIRST item
            WHERE item.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.

        ASSIGN tt-estrutura.it-codigo = prod-composto.it-codigo-filho
               tt-estrutura.descricao = IF AVAILABLE item THEN item.desc-item ELSE tt-estrutura.descricao.
    END.
END.

PROCEDURE pi-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo  AS CHARACTER.
    DEFINE INPUT PARAMETER p-data       AS DATE.

    FOR EACH estrutura 
       WHERE estrutura.it-codigo    = p-it-codigo  
         AND estrutura.data-inicio <= p-data
         AND estrutura.data-termino > p-data NO-LOCK:

        ASSIGN i-nivel = i-nivel + 1
               i-seq   = i-seq   + 1.

        FIND FIRST int-estrutura NO-LOCK
             WHERE int-estrutura.it-codigo = estrutura.it-codigo
               AND int-estrutura.sequencia = estrutura.sequencia
               AND int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

        IF AVAIL int-estrutura THEN DO:
            IF int-estrutura.garantia = 0 THEN DO:
                RUN esp/crm/escrm108a.p (INPUT  int-estrutura.es-codigo,
                                         INPUT  p-data,
                                         OUTPUT l-garantia).

                IF l-garantia = NO THEN NEXT.
            END.

            FOR FIRST ITEM
                WHERE ITEM.it-codigo = int-estrutura.es-codigo:
            END.

            FIND FIRST preco-item NO-LOCK
                 WHERE preco-item.it-codigo  = int-estrutura.es-codigo
                   AND preco-item.cod-refer  = ""
                   AND preco-item.nr-tabpre  = c-nr-tabpre
                   AND preco-item.dt-inival <= TODAY
                   AND preco-item.situacao   = 1 NO-ERROR.

            IF AVAIL preco-item THEN DO:
                CREATE tt-estrutura.             
                ASSIGN tt-estrutura.seq          = i-seq
                       tt-estrutura.nivel        = i-nivel
                       tt-estrutura.it-codigo    = int-estrutura.es-codigo
                       tt-estrutura.descricao    = IF int-estrutura.desc-alt <> "" THEN int-estrutura.desc-alt ELSE ITEM.desc-item
                       tt-estrutura.aliquota-ipi = ITEM.aliquota-ipi
                       tt-estrutura.preco-venda  = (preco-item.preco-venda - (preco-item.preco-venda * 0.3333))
                       tt-estrutura.preco-venda2 = preco-item.preco-venda
                       tt-estrutura.preco-venda3 = 0.
            END.
        END.

        RUN pi-estrutura (INPUT estrutura.es-codigo,
                          INPUT p-data).

        RELEASE int-estrutura.

        ASSIGN i-nivel = i-nivel - 1.
    END.

    RETURN "OK":U.

END PROCEDURE.

IF  CAN-FIND(FIRST tt-estrutura) THEN
    RETURN 'OK'.
ELSE
    RETURN 'NOK'.

