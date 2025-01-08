/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm108.p
**  Autor.....: Silvio Ferrari
**  Data......: Abril/2011 - Desenvolvimento
**  Descricao.: Estrutura Item - B2B/CRM
**  As partes comentadas do fonte foi a pedido do Jackson (P¢s Venda)
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

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

DEFINE INPUT  PARAMETER pSerie  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pItem   AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE   FOR tt-estrutura.
DEFINE VARIABLE c-item-nivel-0 AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cSigla  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cData   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dtEstr  AS DATE        NO-UNDO.
DEFINE VARIABLE cNumero AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq   AS INTEGER    INITIAL 2 NO-UNDO.
DEFINE VARIABLE i-nivel AS INTEGER    INITIAL 1 NO-UNDO.
DEFINE VARIABLE cItem   LIKE ITEM.it-codigo NO-UNDO.
DEFINE VARIABLE cItemOrigem LIKE ITEM.it-codigo NO-UNDO.

DEFINE VARIABLE v-data-fabric AS DATETIME    NO-UNDO INITIAL ?.

DEF VAR p-garantia AS LOGICAL NO-UNDO.
DEF VAR i-checa AS INTEGER NO-UNDO.

DEF VAR i-garant-produto AS INTEGER NO-UNDO INITIAL 0.

DEF BUFFER bitem FOR ITEM.
DEF BUFFER bestrutura FOR estrutura.
DEF BUFFER bint-item FOR int-item.

EMPTY TEMP-TABLE tt-estrutura.

/** Estrutura pela S‚rie **/
IF pSerie <> "" THEN DO:
    
    ASSIGN cItem = "".

    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.n-serie = pSerie:

        ASSIGN cItem         = num-serie.it-codigo
               v-data-fabric = num-serie.data.

    END.
    
END.

IF cItem = "" AND
   pItem = "" THEN NEXT.

IF cItem <> "" THEN
    ASSIGN cItemOrigem = cItem.
ELSE
    ASSIGN cItemOrigem = pItem.


IF cItem = "" THEN
    ASSIGN cItem = pItem.


FIND FIRST ITEM no-lock
    WHERE  ITEM.it-codigo = cItem NO-ERROR.
IF  AVAIL  ITEM THEN DO:

    FIND FIRST int-item NO-LOCK
    WHERE  int-item.it-codigo = cItem NO-ERROR.

    /*
    IF  ITEM.ge-codigo = 45 /* produtos acabados - OEM */ THEN DO:

        FIND FIRST it-altern NO-LOCK
            WHERE  it-altern.it-codigo = cItem
              AND  it-altern.it-altern BEGINS "222" NO-ERROR.

        IF  AVAIL  it-altern THEN ASSIGN cItem = it-altern.it-altern.

    END. /* IF  ITEM.ge-codigo ... */
    */

END. /* IF  AVAIL  ITEM THEN ... */

CREATE tt-estrutura.             
ASSIGN tt-estrutura.seq            = 1
       tt-estrutura.nivel          = 0
       tt-estrutura.it-codigo      = ITEM.it-codigo
       tt-estrutura.descricao      = ITEM.desc-item
       tt-estrutura.it-pai         = ""
       tt-estrutura.permite-os     = IF AVAIL int-item THEN int-item.log1 ELSE NO
       tt-estrutura.data-fabric    = v-data-fabric.

IF substring(int-item.char1,1,3) = "SIM" THEN DO:
    CREATE tt-estrutura.             
    ASSIGN tt-estrutura.seq            = 2
           tt-estrutura.nivel          = 1
           tt-estrutura.it-codigo      = ITEM.it-codigo
           tt-estrutura.descricao      = ITEM.desc-item
           tt-estrutura.quant-usada    = 1
           tt-estrutura.it-pai         = ""
           tt-estrutura.permite-os     = IF AVAIL int-item THEN int-item.log1 ELSE NO
           tt-estrutura.data-fabric    = v-data-fabric.
END.

ASSIGN i-nivel = 0.

RUN pi-estrutura (INPUT cItem,
                  INPUT 1,
                  INPUT TODAY).

/* Astec */
FOR EACH estrut-astec NO-LOCK
    WHERE estrut-astec.it-codigo = cItem:

    RUN pi-cria-tt-estrutura (INPUT estrut-astec.it-codigo,
                              INPUT estrut-astec.sequencia,
                              INPUT estrut-astec.es-codigo,
                              INPUT TODAY,
                              INPUT 1, 
                              INPUT estrut-astec.quantidade,
                              INPUT "").
    

END.

FOR EACH altern-astec NO-LOCK
    WHERE altern-astec.it-codigo = cItem:

    RUN pi-estrutura (INPUT altern-astec.it-altern,
                      INPUT 1,
                      INPUT TODAY).

END.


FOR EACH tt-estrutura:

    IF tt-estrutura.nivel = 0 THEN DO: 
        ASSIGN c-item-nivel-0 = tt-estrutura.it-codigo.
        NEXT.
    END.

    IF i-garant-produto < tt-estrutura.garantia THEN
        ASSIGN i-garant-produto = tt-estrutura.garantia.

END.

FIND FIRST int-item NO-LOCK
     WHERE int-item.it-codigo = cItemOrigem 
       AND substring(int-item.char1,1,3) = "SIM" NO-ERROR.
IF AVAIL int-item THEN DO:

    IF int-item.int2 <> 0 THEN
        ASSIGN i-garant-produto = int-item.int2.
    
    FIND FIRST tt-estrutura
        WHERE tt-estrutura.seq = 2
          AND tt-estrutura.nivel = 1 NO-ERROR.
    IF AVAIL tt-estrutura THEN
        ASSIGN tt-estrutura.garantia = i-garant-produto.
    
END.

PROCEDURE pi-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo    AS CHARACTER.
    DEFINE INPUT PARAMETER p-qt-usada-pai LIKE estrutura.quant-usada NO-UNDO.
    DEFINE INPUT PARAMETER p-data         AS DATE.

    FOR EACH estrutura 
       WHERE estrutura.it-codigo    = p-it-codigo  
         AND estrutura.data-inicio <= p-data
         AND estrutura.data-termino > p-data NO-LOCK:

        RUN pi-cria-tt-estrutura (INPUT estrutura.it-codigo,
                                  INPUT estrutura.sequencia,
                                  INPUT estrutura.es-codigo,
                                  INPUT p-data,
                                  INPUT p-qt-usada-pai,
                                  INPUT estrutura.quant-usada,
                                  INPUT estrutura.local-montag).

        RUN pi-estrutura (INPUT estrutura.es-codigo,
                          INPUT tt-estrutura.quant-usada,
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

        IF int-estrutura.garantia = 0 THEN DO:
            RUN esp/crm/escrm108a.p (INPUT  p-es-codigo,
                                     INPUT  p-data,
                                     OUTPUT p-garantia).

            IF p-garantia = NO THEN NEXT.
        END.

        

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
               tt-estrutura.quant-usada    = ROUND((p-quant-usada * p-qt-usada-pai),4)
               tt-estrutura.local-montag   = p-local-montag
               tt-estrutura.garantia       = int-estrutura.garantia
               tt-estrutura.venda          = int-estrutura.venda
               tt-estrutura.permite-os     = IF AVAIL int-item THEN int-item.log1 ELSE NO.
    END.



    RETURN "NOK":u.

END PROCEDURE.



DELETE WIDGET-POOL.

RETURN "OK".

