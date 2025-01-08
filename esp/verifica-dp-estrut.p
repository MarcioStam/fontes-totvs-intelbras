/* parametros */
DEF INPUT PARAMETER c-it-codigo AS CHAR NO-UNDO.
DEF INPUT PARAMETER c-versao AS INT NO-UNDO.
DEF OUTPUT PARAMETER l-item-ativo AS LOGICAL INITIAL YES NO-UNDO.
DEF OUTPUT PARAMETER l-itemob AS CHAR NO-UNDO.

DEFINE VARIABLE p-ativo AS LOGICAL     NO-UNDO.
DEF VAR p-itemob AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-dpestrut NO-UNDO
    FIELD it-codigo LIKE dp-estrut.item-dp
    FIELD versao    LIKE dp-estrut.num-proces-compon
    FIELD es-codigo LIKE dp-estrut.es-codigo
    INDEX chver it-codigo versao es-codigo.
 
ASSIGN l-itemob = "".


FIND FIRST ITEM WHERE ITEM.it-codigo = c-it-codigo
                        NO-LOCK NO-ERROR.
IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
    ASSIGN l-item-ativo = NO
           l-itemob = ITEM.it-codigo. 
          
    RETURN "NOK".
END.

RUN pi-looping (INPUT c-it-codigo, INPUT c-versao).

IF l-item-ativo = NO THEN RETURN "NOK".

FOR EACH tt-dpestrut:
    FIND FIRST ITEM WHERE ITEM.it-codigo = tt-dpestrut.es-codigo
                    NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
        ASSIGN l-item-ativo = NO
               l-itemob = tt-dpestrut.es-codigo.

        RETURN "NOK".
    END. 
END.


PROCEDURE pi-looping:

    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-versao AS INTE NO-UNDO.


    FOR EACH dp-estrut
       WHERE dp-estrut.item-dp = p-it-codigo and
             dp-estrut.num-proces-item = p-versao NO-LOCK:

        IF dp-estrut.data-termino < TODAY THEN NEXT.

        IF dp-estrut.num-proces-compon = 0 THEN DO:
            FIND FIRST estrutura WHERE estrutura.it-codigo = dp-estrut.es-codigo 
                    NO-LOCK NO-ERROR.
            IF AVAIL estrutura THEN DO:
                RUN esp/verifica-estrutura.p (INPUT estrutura.it-codigo,
                                              OUTPUT p-ativo,
                                              OUTPUT p-itemob).
                IF p-ativo = NO THEN DO:
                    ASSIGN l-item-ativo = NO
                           l-itemob = p-itemob.
                    LEAVE.
                END.
            END.
            ELSE DO:
                FIND FIRST ITEM WHERE ITEM.it-codigo = dp-estrut.es-codigo
                                NO-LOCK NO-ERROR.
                IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
                    ASSIGN l-item-ativo = NO
                           l-itemob = dp-estrut.es-codigo.
                    LEAVE.
                END.
            END.

        END.
        ELSE DO:  
            FIND FIRST tt-dpestrut
                 WHERE tt-dpestrut.it-codigo = dp-estrut.item-dp
                   AND tt-dpestrut.versao    = dp-estrut.num-proces-item
                   AND tt-dpestrut.es-codigo = dp-estrut.es-codigo NO-ERROR.
            IF NOT AVAIL tt-dpestrut THEN DO:
                CREATE tt-dpestrut.
                ASSIGN tt-dpestrut.it-codigo = dp-estrut.item-dp
                       tt-dpestrut.versao    = dp-estrut.num-proces-item
                       tt-dpestrut.es-codigo = dp-estrut.es-codigo.

                RUN pi-looping (INPUT dp-estrut.es-codigo, INPUT dp-estrut.num-proces-compon).
            END.
        END. 
    END.
END PROCEDURE.

