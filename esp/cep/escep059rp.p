{include/i-prgvrs.i ESCEP059 2.04.00.001}

/***********************************************************************
**  Programa..: ESP\CEP\ESCEP059RP.P
**  Autor.....: Gustavo
**  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE    
    FIELD arq-csv          AS CHAR
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-depos        LIKE deposito.cod-depos
    FIELD nome             LIKE deposito.nome
    INDEX id cod-depos.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD cod-estabel   LIKE ITEM.cod-estabel
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD lote-multipl  LIKE item-uni-estab.lote-multipl
    FIELD lote-minimo   LIKE item-uni-estab.lote-minimo    
    FIELD res-for-comp  LIKE item-uni-estab.res-for-comp
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD lote-mul-for  LIKE item-fornec-estab.lote-mul-for
    FIELD lote-min-for  LIKE item-fornec-estab.lote-minimo
    FIELD observacao    AS CHAR
    FIELD cod-comprado  LIKE item-uni-estab.cod-comprado.

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/****************************  Variaveis    ****************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.
    
DEF STREAM s-import.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp         AS HANDLE                                          NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Importa‡Æo"
       c-empresa      = IF AVAIL mgcad.empresa THEN mgcad.empresa.razao-social ELSE ''
       c-programa     = "ESCEP059"
       c-versao       = "2.04"
       c-revisao      = "001".

/****************************  Forms  **********************************/

/***********************************************************************/

FIND FIRST tt-param NO-ERROR.

DO ON STOP UNDO, LEAVE:
    
    OUTPUT TO VALUE (c-dir-arquivo-session + "escep059.csv") CONVERT TARGET "iso8859-1".
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Importando...").
    
    RUN pi-importa.

    RUN pi-finalizar IN h-acomp.

    OUTPUT CLOSE.
    RETURN "OK".
END.

PROCEDURE pi-importa:

    /* importa‡Æo parametros de itens para produtos a serem produzidos em Manaus - ipr8000 */
    DISABLE TRIGGERS FOR LOAD OF item-uni-estab.

    DEFINE VARIABLE c-it-codigo    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-res-forn     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-emitente AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-nome-abrev   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lote-multipl AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lote-minimo  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lote-mul-for AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lote-min-for AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-linhas       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-cod-comprado AS CHARACTER   NO-UNDO.

    ASSIGN i-linhas = 0.

    EMPTY TEMP-TABLE tt-item.

    INPUT STREAM s-import FROM VALUE(tt-param.arq-csv).

    REPEAT ON ERROR UNDO, LEAVE
           ON STOP  UNDO, LEAVE TRANSACTION:

        ASSIGN c-it-codigo = ""
               c-res-forn = ""
               c-cod-comprado = "".

        IMPORT STREAM s-import DELIMITER ";"
            c-cod-estabel
            c-it-codigo 
            c-lote-multipl
            c-lote-minimo 
            c-res-forn
            c-cod-emitente
            c-lote-mul-for
            c-lote-min-for
            c-cod-comprado.
                                       
        ASSIGN i-linhas = i-linhas + 1.
        IF i-linhas = 1 THEN NEXT.        

        FIND FIRST emitente 
             WHERE emitente.cod-emitente = INT(c-cod-emitente) 
               AND emitente.identific >= 2 NO-LOCK NO-ERROR.

        CREATE tt-item.
        ASSIGN tt-item.it-codigo    = c-it-codigo
               tt-item.cod-emitente = IF AVAIL emitente   THEN emitente.cod-emitente ELSE INT(c-cod-emitente)
               tt-item.res-for-comp = IF c-res-forn <> "" THEN INT(c-res-forn) ELSE 0 
               tt-item.cod-estabel  = c-cod-estabel               
               tt-item.lote-multipl = DEC(c-lote-multipl)
               tt-item.lote-minimo  = DEC(c-lote-minimo)               
               tt-item.lote-mul-for = DEC(c-lote-mul-for)
               tt-item.lote-min-for = DEC(c-lote-min-for) 
               tt-item.cod-comprado = c-cod-comprado NO-ERROR.
    END.

    INPUT STREAM s-import CLOSE.

    FOR EACH tt-item:

        RUN pi-valida.

        IF tt-item.observacao <> "" THEN
            NEXT.
        
        FOR EACH item-uni-estab 
           WHERE item-uni-estab.it-codigo   = tt-item.it-codigo 
             AND item-uni-estab.cod-estabel = tt-item.cod-estabel EXCLUSIVE-LOCK:
            
            ASSIGN item-uni-estab.res-for-comp = tt-item.res-for-comp
                   item-uni-estab.horiz-fixo   = tt-item.res-for-comp
                   item-uni-estab.lote-multipl = tt-item.lote-multipl
                   item-uni-estab.lote-minimo  = tt-item.lote-minimo.

            ASSIGN OVERLAY(item-uni-estab.char-1,129,3) = TRIM(STRING(tt-item.res-for-comp)). /* horizonte liberacao */   

            IF tt-item.cod-comprado <> "" THEN
               ASSIGN item-uni-estab.cod-comprado = tt-item.cod-comprado.
        END.

        IF tt-item.cod-emitente <> ? THEN DO:
            FOR EACH item-fornec
               WHERE item-fornec.it-codigo    = tt-item.it-codigo
                 AND item-fornec.cod-emitente = tt-item.cod-emitente EXCLUSIVE-LOCK:
                ASSIGN item-fornec.tempo-ressup = tt-item.res-for-comp
                       item-fornec.horiz-fixo   = tt-item.res-for-comp.

            END.

            FOR EACH item-fornec-estab 
               WHERE item-fornec-estab.it-codigo    = tt-item.it-codigo 
                 AND item-fornec-estab.cod-emitente = tt-item.cod-emitente 
                 AND item-fornec-estab.cod-estabel  = tt-item.cod-estabel EXCLUSIVE-LOCK:

                 ASSIGN item-fornec-estab.tempo-ressup = tt-item.res-for-comp
                        item-fornec-estab.horiz-fixo   = tt-item.res-for-comp
                        item-fornec-estab.lote-mul-for = tt-item.lote-mul-for
                        item-fornec-estab.lote-minimo  = tt-item.lote-min-for.

            END.
        END.
    END.  

    RUN pi-imprime.

END PROCEDURE.

PROCEDURE pi-valida:
 

    IF tt-item.lote-mul-for > 9999999.9999 THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Quantidade lote m£ltiplo item informado ultrapassa tamanho de campo padrÆo TOTVS. ". 
    END.
    
    IF tt-item.lote-min-for > 9999999.9999  THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Quantidade lote m¡nimo item informado ultrapassa tamanho de campo padrÆo TOTVS. ". 
    END.

    IF tt-item.res-for-comp > 999 THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Tempo ressuprimento item informado ultrapassa tamanho de campo padrÆo TOTVS. ". 
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-item.cod-emitente
           AND emitente.identific >= 2 NO-ERROR.

    IF  NOT AVAIL emitente 
    AND tt-item.cod-emitente <> ? THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Fornecedor " + STRING(tt-item.cod-emitente) + " inexistente. ". 
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Item " + tt-item.it-codigo + " inexistente. ". 
    END.
    
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.it-codigo   = tt-item.it-codigo
           AND item-uni-estab.cod-estabel = tt-item.cod-estabel NO-ERROR.

    IF NOT AVAIL item-uni-estab THEN DO:
        ASSIGN tt-item.observacao = tt-item.observacao + "Relacionamento item " +  tt-item.it-codigo + " e estabelecimento " + tt-item.cod-estabel + " inexistente. ". 
    END.

    IF tt-item.cod-emitente <> ? THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = tt-item.it-codigo
               AND item-fornec.cod-emitente = tt-item.cod-emitente NO-ERROR.

        IF NOT AVAIL item-fornec THEN DO:
            ASSIGN tt-item.observacao = tt-item.observacao + "Relacionamento do item " + tt-item.it-codigo + " e fornecedor " + STRING(tt-item.cod-emitente) + " inexistente. ". 
        END.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = tt-item.it-codigo 
               AND item-fornec-estab.cod-emitente = tt-item.cod-emitente
               AND item-fornec-estab.cod-estabel  = tt-item.cod-estabel NO-ERROR.

        IF NOT AVAIL item-fornec-estab THEN DO:
            ASSIGN tt-item.observacao = tt-item.observacao + "Relacionamento item " + tt-item.it-codigo + " e fornecedor " + STRING(tt-item.cod-emitente) + " e estabelecimento " + tt-item.cod-estabel + " inexistente. ". 
        END.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = tt-item.it-codigo 
               AND item-fornec-estab.cod-emitente = tt-item.cod-emitente
               AND item-fornec-estab.cod-estabel  = tt-item.cod-estabel NO-ERROR.

        IF  AVAIL item-fornec-estab 
        AND NOT item-fornec-estab.ativo THEN DO:
            ASSIGN tt-item.observacao = tt-item.observacao + "Relacionamento item " + tt-item.it-codigo + " e fornecedor " + STRING(tt-item.cod-emitente) + " e estabelecimento " + tt-item.cod-estabel + " inativo. ". 
        END.

    END.

    IF tt-item.cod-comprado <> "" THEN DO:
       FIND FIRST usuar-mater NO-LOCK
            WHERE usuar-mater.cod-usuario = tt-item.cod-comprado NO-ERROR.
       IF NOT AVAIL usuar-mater THEN DO:
          ASSIGN tt-item.observacao = tt-item.observacao + "Comprador inexistente. ". 
       END.
    END.
    
END PROCEDURE.

PROCEDURE pi-imprime:
    PUT UNFORMATTED "Sem erro:" SKIP.
    PUT UNFORMATTED "Estab;Item;Lote Multiplo;Lote Minimo;Tempo Ressupr;Cod Fornec;Lote Multiplo;Lote Minimo;Comprador" SKIP.
    FOR EACH tt-item
       WHERE tt-item.observacao = "":

        PUT UNFORMATTED tt-item.cod-estabel + ";" + tt-item.it-codigo + ";" + STRING(tt-item.lote-multipl) + ";" + STRING(tt-item.lote-minimo) + ";" + STRING(tt-item.res-for-comp) + ";" + STRING(tt-item.cod-emitente) + ";" + STRING(tt-item.lote-mul-for) + ";" + STRING(tt-item.lote-min-for) + ";" + STRING(tt-item.cod-comprado) SKIP.
    END.

    PUT SKIP(2).

    PUT UNFORMATTED "Com erro:" SKIP.
    PUT UNFORMATTED "Estab;Item;Lote Multiplo;Lote Minimo;Tempo Ressupr;Cod Fornec;Lote Multiplo;Lote Minimo;Comprador;Erros" SKIP.
    FOR EACH tt-item
       WHERE tt-item.observacao <> "":
        PUT UNFORMATTED tt-item.cod-estabel + ";" + tt-item.it-codigo + ";" + STRING(tt-item.lote-multipl) + ";" + STRING(tt-item.lote-minimo) + ";" + STRING(tt-item.res-for-comp) + ";" + STRING(tt-item.cod-emitente) + ";" + STRING(tt-item.lote-mul-for) + ";" + STRING(tt-item.lote-min-for) + ";" + STRING(tt-item.cod-comprado) + ";" + tt-item.observacao SKIP.    
    END.

    DOS SILENT START excel VALUE(c-dir-arquivo-session + "escep059.csv").
END PROCEDURE.
