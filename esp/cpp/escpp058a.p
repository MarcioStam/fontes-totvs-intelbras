/* ----------------------------------------------------------------------------
   Programa..: esp\cpp\escpp058a.p
   Objetivo..: Gerar registros para controle do kanban eletronico. Est  sendo 
               chamado a partir da UPC bodi317ef-upc.p, por‚m, pode ser executado 
               separadamente apenas passando os parametros de entrada necess rios
   Data......: 17/11/2011 - Hoepers: desenvolvimento
               17/11/2011 - Hoepers: alterada toda a l¢gica para gerar a pendˆncia 
                                     de Kanban sempre que o faturamento atingir o lote multiplo
---------------------------------------------------------------------------- */

{esp/cpp/escpp058.i}
      
DEF INPUT        PARAM p-log-limpa-tt-sdo AS LOG            NO-UNDO.
DEF INPUT        PARAM p-log-atualizar    AS LOG            NO-UNDO.
DEF INPUT        PARAM p-it-codigo      LIKE item.it-codigo NO-UNDO.
DEF INPUT        PARAM p-qtd-item         AS DEC            NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-saldo.

DEF BUFFER b-int-kanban-eletronico FOR int-kanban-eletronico.

DEF VAR v-qtd-dispon     AS DEC NO-UNDO.
DEF VAR v-qtd-prev-prod  AS DEC NO-UNDO.
DEF VAR v-qtd-produzir   AS DEC NO-UNDO.

/*********************************************************************************/
EMPTY TEMP-TABLE tt-grupo-kanban.
EMPTY TEMP-TABLE tt-unid-kanban.
EMPTY TEMP-TABLE tt-saldo-kanban.
EMPTY TEMP-TABLE tt-emit-kanban.

IF  p-log-limpa-tt-sdo = YES
THEN
    EMPTY TEMP-TABLE tt-saldo.

for first ponto-programa
    where ponto-programa.nome-programa = "escpp058"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo <> ""
    THEN DO:
        CREATE tt-grupo-kanban.
        ASSIGN tt-grupo-kanban.ge-codigo = INT(conteudo-programa.conteudo).
    END.
end.  

for first ponto-programa
    where ponto-programa.nome-programa = "escpp058"
      AND ponto-programa.ponto         = 2,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo <> ""
    THEN DO:
        CREATE tt-unid-kanban.
        ASSIGN tt-unid-kanban.cod_unid_neg = conteudo-programa.conteudo.
    END.
end.

for first ponto-programa
    where ponto-programa.nome-programa = "escpp058"
      AND ponto-programa.ponto         = 3,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                 <> "" AND 
        NUM-ENTRIES(conteudo-programa.conteudo,";") > 2
    THEN DO:
        CREATE tt-saldo-kanban.
        ASSIGN tt-saldo-kanban.cod-estabel = ENTRY(1,conteudo-programa.conteudo,";")
               tt-saldo-kanban.cod-depos   = ENTRY(2,conteudo-programa.conteudo,";")
               tt-saldo-kanban.cod-localiz = ENTRY(3,conteudo-programa.conteudo,";").
    END.
end.

for first ponto-programa
    where ponto-programa.nome-programa = "escpp058"
      AND ponto-programa.ponto         = 4,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                 <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";") > 1
    THEN DO:
        CREATE tt-emit-kanban.
        ASSIGN tt-emit-kanban.cod-estabel  =     ENTRY(1,conteudo-programa.conteudo,";")
               tt-emit-kanban.cod-emitente = INT(ENTRY(2,conteudo-programa.conteudo,";")).
    END.
end.  

ASSIGN v-qtd-dispon = 0.

FIND ITEM NO-LOCK
    WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

IF  AVAIL ITEM
THEN
    RUN pi-item-kanban.
ELSE
    RETURN "nok".


IF  p-log-atualizar = YES AND
    p-qtd-item      > 0
THEN DO TRANS ON ERROR UNDO, LEAVE:

    FIND LAST b-int-kanban-eletronico EXCLUSIVE-LOCK
        WHERE b-int-kanban-eletronico.it-codigo    = p-it-codigo
          AND b-int-kanban-eletronico.cod-estabel  = "101" NO-ERROR.

    IF  NOT AVAIL b-int-kanban-eletronico
    THEN DO:
        CREATE int-kanban-eletronico.
        ASSIGN int-kanban-eletronico.cod-estabel    = "101"
               int-kanban-eletronico.it-codigo      = p-it-codigo
               int-kanban-eletronico.num-seq-kanban = 1
               int-kanban-eletronico.qtd-fat-pend   = p-qtd-item.
    END.
    ELSE DO:
        IF  b-int-kanban-eletronico.log-liberado = YES
        THEN DO:
            CREATE int-kanban-eletronico.
            ASSIGN int-kanban-eletronico.cod-estabel    = b-int-kanban-eletronico.cod-estabel
                   int-kanban-eletronico.it-codigo      = b-int-kanban-eletronico.it-codigo
                   int-kanban-eletronico.num-seq-kanban = b-int-kanban-eletronico.num-seq-kanban + 1
                   int-kanban-eletronico.qtd-fat-pend   = b-int-kanban-eletronico.qtd-fat-pend   + p-qtd-item
                   b-int-kanban-eletronico.qtd-fat-pend = 0.
        END.
        ELSE
            ASSIGN b-int-kanban-eletronico.qtd-fat-pend = b-int-kanban-eletronico.qtd-fat-pend + p-qtd-item.
    END.

    FOR EACH tt-saldo
        BREAK BY tt-saldo.it-codigo:

        IF  FIRST-OF(tt-saldo.it-codigo)
        THEN
            ASSIGN v-qtd-dispon    = 0
                   v-qtd-prev-prod = 0
                   v-qtd-produzir  = 0.

        ASSIGN v-qtd-dispon = v-qtd-dispon + tt-saldo.qtd-saldo + tt-saldo.qtd-transito.

        IF  LAST-OF(tt-saldo.it-codigo)
        THEN DO:
            FIND int-item-uni-estab NO-LOCK
                WHERE int-item-uni-estab.cod-estabel = "101"
                  AND int-item-uni-estab.it-codigo   = tt-saldo.it-codigo NO-ERROR.

            IF  AVAIL int-item-uni-estab                        AND
                      int-item-uni-estab.qtd-lote-multiplo <> 0 AND
                      int-item-uni-estab.qtd-estoq-max     <> 0 AND
                      int-item-uni-estab.qtd-estoq-max      > v-qtd-dispon
            THEN DO:
                FIND LAST int-kanban-eletronico EXCLUSIVE-LOCK
                    WHERE int-kanban-eletronico.it-codigo    = tt-saldo.it-codigo
                      AND int-kanban-eletronico.cod-estabel  = "101" NO-ERROR.

                IF  int-kanban-eletronico.qtd-fat-pend >= int-item-uni-estab.qtd-lote-multiplo
                THEN DO:
                    IF  int-kanban-eletronico.qtd-fat-pend <= int-item-uni-estab.qtd-estoq-max - v-qtd-dispon
                    THEN
                        ASSIGN int-kanban-eletronico.log-dispon-kanban = YES
                               int-kanban-eletronico.qtd-produzir      = int-kanban-eletronico.qtd-produzir + ((TRUNCATE(int-kanban-eletronico.qtd-fat-pend / int-item-uni-estab.qtd-lote-multiplo,0)) * int-item-uni-estab.qtd-lote-multiplo)
                               int-kanban-eletronico.qtd-fat-pend      = int-kanban-eletronico.qtd-fat-pend MODULO int-item-uni-estab.qtd-lote-multiplo.
                    ELSE DO:
                        ASSIGN int-kanban-eletronico.log-dispon-kanban = YES
                               int-kanban-eletronico.qtd-produzir      = int-kanban-eletronico.qtd-produzir + ((TRUNCATE(INT(int-item-uni-estab.qtd-estoq-max - v-qtd-dispon) / int-item-uni-estab.qtd-lote-multiplo,0)) * int-item-uni-estab.qtd-lote-multiplo)
                               int-kanban-eletronico.qtd-fat-pend      = int-kanban-eletronico.qtd-fat-pend - ((TRUNCATE(INT(int-item-uni-estab.qtd-estoq-max - v-qtd-dispon) / int-item-uni-estab.qtd-lote-multiplo,0)) * int-item-uni-estab.qtd-lote-multiplo).
                    END.
                END.
            END.
        END. /* IF  LAST-OF(tt-saldo.it-codigo) */
    END. /* FOR EACH tt-saldo */
END. /* IF  p-log-atualizar = YES */


PROCEDURE pi-item-kanban:

    IF  p-qtd-item > 0 
    THEN DO:
        FIND FIRST tt-grupo-kanban NO-LOCK
            WHERE  tt-grupo-kanban.ge-codigo = ITEM.ge-codigo NO-ERROR.
    
        IF  NOT AVAIL tt-grupo-kanban
        THEN
            RETURN.
    
        bloco-unid-neg:
        FOR EACH tt-unid-kanban NO-LOCK:

            FIND FIRST item-uni-estab NO-LOCK
                WHERE  item-uni-estab.it-codigo    = ITEM.it-codigo
                  AND  item-uni-estab.cod-estabel  = "101"
                  AND  item-uni-estab.cod-unid-neg = tt-unid-kanban.cod_unid_neg NO-ERROR.
        
            IF  AVAIL item-uni-estab
            THEN
                LEAVE bloco-unid-neg.
        END.
    
        IF  NOT AVAIL item-uni-estab
        THEN
            RETURN.
    
        FIND FIRST tt-saldo EXCLUSIVE-LOCK 
            WHERE  tt-saldo.cod-estabel = ""
              AND  tt-saldo.cod-depos   = ""  
              AND  tt-saldo.it-codigo   = p-it-codigo NO-ERROR.
    
        IF  NOT AVAIL tt-saldo
        THEN DO:
            CREATE tt-saldo.
            ASSIGN tt-saldo.cod-estabel = ""      
                   tt-saldo.cod-depos   = ""         
                   tt-saldo.it-codigo   = p-it-codigo.
        END.
    END. /* IF  p-qtd-item > 0 */

    /* Ler Quantidades em Transito */
    FOR EACH tt-emit-kanban NO-LOCK:
        FOR EACH  saldo-terc NO-LOCK
            WHERE saldo-terc.cod-estabel    = tt-emit-kanban.cod-estabel 
              AND saldo-terc.cod-emitente   = tt-emit-kanban.cod-emitente
              AND saldo-terc.it-codigo      = ITEM.it-codigo
              AND saldo-terc.tipo-sal-terc  = 3 /* transito */
              AND saldo-terc.quantidade    <> 0:

            FIND FIRST tt-saldo EXCLUSIVE-LOCK 
                WHERE  tt-saldo.cod-estabel = saldo-terc.cod-estabel
                  AND  tt-saldo.cod-depos   = ""  
                  AND  tt-saldo.it-codigo   = saldo-terc.it-codigo NO-ERROR.

            IF  NOT AVAIL tt-saldo
            THEN DO:
                CREATE tt-saldo.
                ASSIGN tt-saldo.cod-estabel = saldo-terc.cod-estabel
                       tt-saldo.cod-depos   = ""  
                       tt-saldo.it-codigo   = saldo-terc.it-codigo.
            END.

            FOR EACH componente OF saldo-terc NO-LOCK:
                ASSIGN tt-saldo.qtd-transito = tt-saldo.qtd-transito + componente.quantidade.
            END.
        END.
    END.


    /* Ler quantidades em estoque */

    FOR EACH tt-saldo-kanban NO-LOCK:
        FOR EACH  saldo-estoq NO-LOCK
           WHERE  saldo-estoq.cod-estabel     = tt-saldo-kanban.cod-estabel
             AND  saldo-estoq.cod-depos       = tt-saldo-kanban.cod-depos  
             AND  saldo-estoq.it-codigo       = ITEM.it-codigo    
             AND  saldo-estoq.qtidade-atu    <> 0
             AND (saldo-estoq.cod-localiz     = tt-saldo-kanban.cod-localiz
              OR  tt-saldo-kanban.cod-localiz = "*"):

            FIND FIRST tt-saldo EXCLUSIVE-LOCK 
                WHERE  tt-saldo.cod-estabel = saldo-estoq.cod-estabel
                  AND  tt-saldo.cod-depos   = saldo-estoq.cod-depos  
                  AND  tt-saldo.it-codigo   = saldo-estoq.it-codigo NO-ERROR.

            IF  NOT AVAIL tt-saldo
            THEN DO:
                CREATE tt-saldo.
                ASSIGN tt-saldo.cod-estabel = saldo-estoq.cod-estabel
                       tt-saldo.cod-depos   = saldo-estoq.cod-depos  
                       tt-saldo.it-codigo   = saldo-estoq.it-codigo.
            END.
                
            ASSIGN tt-saldo.qtd-saldo   = tt-saldo.qtd-saldo   + (saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped)
                   tt-saldo.qtd-alocada = tt-saldo.qtd-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-alocada   + saldo-estoq.qt-aloc-ped.
        END.
    END.

    RETURN "ok".
END PROCEDURE.

RETURN "ok".

