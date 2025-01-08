/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm113.p
**  Autor.....: Emerson Colla
**  Data......: Agosto/2011 - Desenvolvimento
**  Descricao.: Pre‡o Item - Portal Astec/CRM
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO
   FIELD seq            like int-estrutura.sequencia
   FIELD nivel          AS INTEGER
   FIELD it-codigo      LIKE estrutura.it-codigo
   FIELD descricao      AS CHAR FORMAT "X(60)"
   FIELD it-pai         LIKE estrutura.it-codigo
   FIELD local-montag   AS CHARACTER FORMAT "x(55)"
   INDEX idx_pri IS PRIMARY UNIQUE seq nivel
   INDEX it it-codigo.

DEFINE TEMP-TABLE tt-item UNDO
    FIELD it-codigo     LIKE preco-item.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    INDEX des AS WORD-INDEX desc-item.

DEFINE INPUT  PARAMETER pItem   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pDesc   AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE   FOR tt-estrutura.

DEFINE VARIABLE i-seq   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE i-nivel AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE p-venda AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-item-nivel-0 AS CHARACTER   NO-UNDO.
DEF BUFFER bitem FOR ITEM.

EMPTY TEMP-TABLE tt-estrutura.
ASSIGN i-seq = 0
       i-nivel = 0.

/** Busca Todos os Itens da Tabela de Pre‡o **/
IF pItem = "" AND
   pDesc = "" THEN DO:

    FOR EACH preco-item WHERE preco-item.nr-tabpre = "ASTEC 02" NO-LOCK:
        FIND FIRST ITEM WHERE ITEM.it-codigo = preco-item.it-codigo NO-LOCK NO-ERROR.

        ASSIGN i-seq = i-seq + 1.
        
        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq            = i-seq
               tt-estrutura.nivel          = 0
               tt-estrutura.it-codigo      = preco-item.it-codigo
               tt-estrutura.descricao      = ITEM.desc-item
               tt-estrutura.it-pai         = "".
               
    END.
END.

/** Busca Item na Tabela de Pre‡o pela descri‡Æo **/
IF pItem = "" AND
   pDesc <> "" THEN DO:

    EMPTY TEMP-TABLE tt-item.
    FOR EACH preco-item WHERE preco-item.nr-tabpre = "ASTEC 02" NO-LOCK:
        FIND FIRST item WHERE item.it-codigo = preco-item.it-codigo NO-LOCK NO-ERROR.
        
        CREATE tt-item.
        ASSIGN tt-item.it-codigo    = preco-item.it-codigo
               tt-item.desc-item    = item.desc-item.
    END.

    ASSIGN pDesc = "*" + pDesc + "*".
    
    FOR EACH tt-item WHERE tt-item.desc-item MATCHES pDesc NO-LOCK:

        ASSIGN i-seq = i-seq + 1.

        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq            = i-seq
               tt-estrutura.nivel          = 0
               tt-estrutura.it-codigo      = tt-item.it-codigo
               tt-estrutura.descricao      = tt-item.desc-item
               tt-estrutura.it-pai         = "".
        
    END.
END.

/** Busca Estrutura do Item respeitando o campo int-estrutura.venda | este campo ‚ parametrizado no programa esenp014.w **/
IF pItem <> "" THEN DO:
    FIND FIRST ITEM no-lock
        WHERE item.it-codigo = pItem NO-ERROR.
    IF NOT AVAIL ITEM THEN RETURN 'NOK'.
    
    CREATE tt-estrutura.             
    ASSIGN tt-estrutura.seq            = 1
           tt-estrutura.nivel          = 0
           tt-estrutura.it-codigo      = ITEM.it-codigo
           tt-estrutura.descricao      = ITEM.desc-item
           tt-estrutura.it-pai         = "".
/*
    IF  ITEM.ge-codigo = 45 /* produtos acabados - OEM */ THEN DO:
        FIND FIRST it-altern NO-LOCK
            WHERE  it-altern.it-codigo = pItem
              AND  it-altern.it-altern BEGINS "222" NO-ERROR.

        IF  AVAIL  it-altern THEN ASSIGN pItem = it-altern.it-altern.
    END. /* IF  ITEM.ge-codigo ... */
*/

    /* Astec - Carlos Daniel, 22/02/2016*/
    FOR EACH estrut-astec NO-LOCK
        WHERE estrut-astec.it-codigo = pItem:
    
        RUN pi-cria-tt-estrutura (INPUT estrut-astec.it-codigo,
                                  INPUT estrut-astec.sequencia,
                                  INPUT estrut-astec.es-codigo,
                                  INPUT TODAY,
                                  INPUT 1, 
                                  INPUT estrut-astec.quantidade,
                                  INPUT "").
        
    
    END.

    FOR EACH altern-astec NO-LOCK
        WHERE altern-astec.it-codigo = pItem:
    
        RUN pi-estrutura (INPUT altern-astec.it-altern,
                          INPUT TODAY).
    
    END.

    FOR EACH estrutura NO-LOCK 
        WHERE estrutura.it-codigo = pItem
        AND estrutura.data-inicio <= TODAY           
        AND estrutura.data-termino > TODAY
        BREAK BY estrutura.it-codigo:
    
        FIND FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = estrutura.it-codigo
            AND int-estrutura.sequencia = estrutura.sequencia
            AND int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.
    
        IF int-estrutura.venda = NO THEN DO:
            RUN esp/crm/escrm113a.p (INPUT  estrutura.es-codigo,
                                     INPUT  TODAY,
                                     OUTPUT p-venda).
            IF p-venda = NO THEN NEXT.
        END.
    
        FIND FIRST bITEM no-lock
            WHERE bitem.it-codigo = estrutura.es-codigo NO-ERROR.
    
        ASSIGN i-seq = i-seq + 1.
    
        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq            = i-seq
               tt-estrutura.nivel          = 1
               tt-estrutura.it-codigo      = estrutura.es-codigo
               tt-estrutura.descricao      = IF AVAIL int-estrutura AND int-estrutura.desc-alt <> "":U THEN int-estrutura.desc-alt ELSE bITEM.desc-item
               tt-estrutura.it-pai         = estrutura.it-codigo
               tt-estrutura.local-montag   = estrutura.local-montag.
               
        ASSIGN i-nivel = 1.
    
        RUN pi-estrutura (INPUT estrutura.es-codigo,
                          INPUT TODAY).
    
        RELEASE int-estrutura.
    END.

    /*comentado conforme chamado 81197*/
    /*FOR EACH tt-estrutura:
        IF tt-estrutura.nivel = 0 THEN DO: 
            ASSIGN c-item-nivel-0 = tt-estrutura.it-codigo.
            NEXT.
        END.
    
        FIND FIRST prod-substituto
            WHERE prod-substituto.it-prod-final = c-item-nivel-0
              AND prod-substituto.it-codigo-pai = tt-estrutura.it-codigo NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE prod-substituto THEN 
            FIND FIRST prod-substituto
                WHERE prod-substituto.it-prod-final = ""
                  AND prod-substituto.it-codigo-pai = tt-estrutura.it-codigo NO-LOCK NO-ERROR.
    
        IF AVAILABLE prod-substituto THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = prod-substituto.it-codigo-filho NO-LOCK NO-ERROR.
    
            ASSIGN tt-estrutura.it-codigo = prod-substituto.it-codigo-filho
                   tt-estrutura.descricao = IF AVAILABLE item THEN item.desc-item ELSE tt-estrutura.descricao.
        END.
    END.*/
END.


PROCEDURE pi-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo  AS CHARACTER.
    DEFINE INPUT PARAMETER p-data       AS DATE.

    FOR EACH estrutura 
       WHERE estrutura.it-codigo    = p-it-codigo  
         AND estrutura.data-inicio <= p-data
         AND estrutura.data-termino > p-data NO-LOCK:

        FIND FIRST int-estrutura NO-LOCK
             WHERE int-estrutura.it-codigo = estrutura.it-codigo
               AND int-estrutura.sequencia = estrutura.sequencia
               AND int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.
        
        IF AVAIL int-estrutura THEN DO:
            IF int-estrutura.venda = NO THEN DO:
                RUN esp/crm/escrm113a.p (INPUT  estrutura.es-codigo,
                                         INPUT  p-data,
                                         OUTPUT p-venda).
                IF p-venda = NO THEN NEXT.
            END.

            FIND FIRST ITEM WHERE ITEM.it-codigo = int-estrutura.es-codigo NO-LOCK NO-ERROR.
            
            ASSIGN i-nivel = i-nivel + 1
                   i-seq   = i-seq   + 1.

            CREATE tt-estrutura.             
            ASSIGN tt-estrutura.seq            = i-seq
                   tt-estrutura.nivel          = i-nivel
                   tt-estrutura.it-codigo      = int-estrutura.es-codigo
                   tt-estrutura.descricao      = IF int-estrutura.desc-alt <> "" THEN int-estrutura.desc-alt ELSE ITEM.desc-item
                   tt-estrutura.it-pai         = int-estrutura.it-codigo
                   tt-estrutura.local-montag   = estrutura.local-montag.
            
        END.

        RUN pi-estrutura (INPUT estrutura.es-codigo,
                          INPUT p-data).

        RELEASE int-estrutura.

        ASSIGN i-nivel = i-nivel - 1.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-tt-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia      AS INT      NO-UNDO.
    DEFINE INPUT PARAMETER p-es-codigo      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-data           AS DATE     NO-UNDO.
    DEFINE INPUT PARAMETER p-qt-usada-pai   AS DECIMAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-quant-usada    AS DECIMAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-local-montag   AS CHAR     NO-UNDO.


    FIND FIRST int-estrutura NO-LOCK
         WHERE int-estrutura.it-codigo = p-it-codigo
           AND int-estrutura.sequencia = p-sequencia
           AND int-estrutura.es-codigo = p-es-codigo NO-ERROR.
    
    IF AVAIL int-estrutura THEN DO:

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = int-estrutura.es-codigo:
            FOR FIRST int-item NO-LOCK
                WHERE int-item.it-codigo = item.it-codigo:
            END.
        END.

        ASSIGN i-nivel = i-nivel + 1
               i-seq   = i-seq   + 1.

        CREATE tt-estrutura.             
        ASSIGN tt-estrutura.seq            = i-seq
               tt-estrutura.nivel          = i-nivel
               tt-estrutura.it-codigo      = int-estrutura.es-codigo
               tt-estrutura.descricao      = IF int-estrutura.desc-alt <> "" THEN int-estrutura.desc-alt ELSE item.desc-item
               tt-estrutura.it-pai         = int-estrutura.it-codigo
               tt-estrutura.local-montag   = p-local-montag.
    END.

    RETURN "NOK":u.

END PROCEDURE.

DELETE WIDGET-POOL.

RETURN "OK".
