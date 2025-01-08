/* ----------------------------------------------------------------------------
   Programa..: esp\cpp\escpp058a.p
   Objetivo..: Gerar registros para controle do kanban eletronico. Est  sendo 
               chamado a partir da UPC bodi317ef-upc.p, por‚m, pode ser executado 
               separadamente apenas passando os parametros de entrada necess rios
   Data......: 25/10/2011 - Hoepers: desenvolvimento
---------------------------------------------------------------------------- */

{C:\fontes11\bacas\kanban.i}
      
DEF INPUT        PARAM p-log-limpa-tt-sdo AS LOG            NO-UNDO.
DEF INPUT        PARAM p-log-atualizar    AS LOG            NO-UNDO.
DEF INPUT        PARAM p-it-codigo      LIKE ITEM.it-codigo NO-UNDO.
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

IF  p-it-codigo <> "*"
THEN DO: 
    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    IF  AVAIL ITEM
    THEN
        RUN pi-item-kanban.
END.
ELSE DO:
    FOR EACH ITEM NO-LOCK:
        RUN pi-item-kanban.
    END.
END.


IF  p-log-atualizar = YES
THEN DO TRANS ON ERROR UNDO, LEAVE:
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
            FOR EACH  int-kanban-eletronico NO-LOCK
                WHERE int-kanban-eletronico.cod-estabel  = "101"
                  AND int-kanban-eletronico.log-liberado = NO 
                  AND int-kanban-eletronico.it-codigo    = tt-saldo.it-codigo:

                ASSIGN v-qtd-prev-prod = v-qtd-prev-prod + int-kanban-eletronico.qtd-produzir.
            END.

            FIND int-item-uni-estab NO-LOCK
                WHERE int-item-uni-estab.cod-estabel = "101"
                  AND int-item-uni-estab.it-codigo   = tt-saldo.it-codigo NO-ERROR.

            IF  AVAIL int-item-uni-estab                        AND
                      int-item-uni-estab.qtd-lote-multiplo <> 0 AND
                      int-item-uni-estab.qtd-estoq-max     <> 0
            THEN DO:
                IF  int-item-uni-estab.qtd-estoq-max > v-qtd-dispon + v-qtd-prev-prod 
                THEN DO:
                    ASSIGN v-qtd-produzir = int-item-uni-estab.qtd-estoq-max - (v-qtd-dispon + v-qtd-prev-prod).

                    IF  v-qtd-produzir / int-item-uni-estab.qtd-lote-multiplo >= 1
                    THEN DO:
                        FIND LAST b-int-kanban-eletronico EXCLUSIVE-LOCK
                            WHERE b-int-kanban-eletronico.it-codigo    = tt-saldo.it-codigo
                              AND b-int-kanban-eletronico.cod-estabel  = "101" NO-ERROR.

                        IF  NOT AVAIL b-int-kanban-eletronico
                        THEN DO:
                            CREATE int-kanban-eletronico.
                            ASSIGN int-kanban-eletronico.cod-estabel       = "101"
                                   int-kanban-eletronico.it-codigo         = tt-saldo.it-codigo
                                   int-kanban-eletronico.num-seq-kanban    = 1
                                   int-kanban-eletronico.qtd-produzir      = v-qtd-produzir
                                   int-kanban-eletronico.log-dispon-kanban = YES.
                        END.
                        ELSE DO:
                            IF  b-int-kanban-eletronico.log-liberado = YES
                            THEN DO:
                                CREATE int-kanban-eletronico.
                                ASSIGN int-kanban-eletronico.cod-estabel       = b-int-kanban-eletronico.cod-estabel
                                       int-kanban-eletronico.it-codigo         = b-int-kanban-eletronico.it-codigo
                                       int-kanban-eletronico.num-seq-kanban    = b-int-kanban-eletronico.num-seq-kanban + 1
                                       int-kanban-eletronico.qtd-produzir      = v-qtd-produzir
                                       int-kanban-eletronico.log-dispon-kanban = YES.
                            END.
                            ELSE
                                ASSIGN b-int-kanban-eletronico.qtd-produzir = b-int-kanban-eletronico.qtd-produzir + v-qtd-produzir.
                        END.
                    END.
                END.
            END.
        END. /* IF  LAST-OF(tt-saldo.it-codigo) */
    END. /* FOR EACH tt-saldo */
END. /* IF  p-log-atualizar = YES */


PROCEDURE pi-item-kanban:

    FIND FIRST tt-grupo-kanban NO-LOCK
        WHERE  tt-grupo-kanban.ge-codigo = ITEM.ge-codigo NO-ERROR.

    IF  NOT AVAIL tt-grupo-kanban
    THEN
        RETURN.

    bloco-unid-neg:
    FOR EACH tt-unid-kanban NO-LOCK:
        FOR FIRST unid-neg-item NO-LOCK
            WHERE unid-neg-item.it-codigo    = item.it-codigo
              AND unid-neg-item.cod_unid_neg = tt-unid-kanban.cod_unid_neg.
            LEAVE bloco-unid-neg.
        END.
    END.

    IF  NOT AVAIL unid-neg-item
    THEN
        RETURN.

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

