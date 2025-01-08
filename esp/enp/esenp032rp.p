{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-boes727 AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

DEFINE BUFFER b-ITEM FOR ITEM.
DEFINE BUFFER b2-ITEM FOR ITEM.

DEFINE STREAM str-excel.

DEFINE TEMP-TABLE ItemEstrutura NO-UNDO 
    FIELD CodigoProduto          AS CHARACTER  
    FIELD CodigoItemEstrutura    AS CHARACTER  
    FIELD DescricaoItem          LIKE ITEM.desc-item
    FIELD TipoItem               AS CHAR
    FIELD QuantidadeUsada        AS INT
    FIELD TempoGarantia          LIKE int-estrutura.garantia
    FIELD PermiteVenda           LIKE int-estrutura.venda
    FIELD PermiteDiagnostico     AS LOG.

DEFINE TEMP-TABLE tt-estrut-astec NO-UNDO LIKE estrut-astec
       field r-rowid as ROWID.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    FIELD it-codigo-ini    LIKE ITEM.it-codigo
    FIELD it-codigo-fim    LIKE ITEM.it-codigo
    field l-habilitaRtf    as LOG.
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESENP032_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "CodigoProduto;CodigoItemEstrutura;DescricaoItem;TipoItem;QuantidadeUsada;TempoGarantia;PermiteVenda;PermiteDiagnostico" SKIP.

    FOR EACH b2-ITEM NO-LOCK 
       WHERE b2-ITEM.it-codigo >= tt-param.it-codigo-ini
         AND b2-ITEM.it-codigo <= tt-param.it-codigo-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Carregando Item: " + b2-ITEM.it-codigo).

        RUN pi-carga-astec (INPUT b2-ITEM.it-codigo).
        
        RUN pi-carrega-estrutura (INPUT b2-ITEM.it-codigo).
    END.
    
    FOR EACH ItemEstrutura:
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Item: " + ItemEstrutura.CodigoProduto).

        /*ImpressÆo*/
        PUT STREAM str-excel UNFORMATTED string(ItemEstrutura.CodigoProduto      )  + ";" +
                                         string(ItemEstrutura.CodigoItemEstrutura)  + ";" +
                                         string(ItemEstrutura.DescricaoItem      )  + ";" +
                                         string(ItemEstrutura.TipoItem           )  + ";" +
                                         string(ItemEstrutura.QuantidadeUsada    )  + ";" +
                                         string(ItemEstrutura.TempoGarantia      )  + ";" +
                                         string(ItemEstrutura.PermiteVenda       )  + ";" +
                                         string(ItemEstrutura.PermiteDiagnostico )  SKIP.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-carga-astec:
    DEFINE INPUT PARAM p-it-codigo AS CHAR.
    /*Astec padrÆo*/
    RUN esbo/boes727.p PERSISTENT SET h-boes727.
    RUN setConstraintItem IN h-boes727 (INPUT p-it-codigo).
    RUN openQueryStatic   IN h-boes727 (INPUT "Item").
    RUN getBatchRecords   IN h-boes727 (INPUT  ?,
                                        INPUT  ?,
                                        INPUT  ?,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-estrut-astec).

    FOR EACH tt-estrut-astec:

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-estrut-astec.es-codigo:
        END.

        CREATE ItemEstrutura.             
        ASSIGN ItemEstrutura.CodigoProduto       = p-it-codigo
               ItemEstrutura.CodigoItemEstrutura = tt-estrut-astec.es-codigo
               ItemEstrutura.DescricaoItem       = ITEM.desc-item
               ItemEstrutura.QuantidadeUsada     = ROUND(tt-estrut-astec.quantidade,2).

        FOR FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = tt-estrut-astec.it-codigo
              AND int-estrutura.sequencia = tt-estrut-astec.sequencia
              AND int-estrutura.es-codigo = tt-estrut-astec.es-codigo:
               
            ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                   ItemEstrutura.PermiteVenda       = int-estrutura.venda
                   ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.

        END.

        RUN pi-tipo-item.
    END.
    DELETE PROCEDURE h-boes727.
    ASSIGN h-boes727 = ?.

    /*Astec alternativo*/
    FOR EACH altern-astec NO-LOCK
       WHERE altern-astec.it-codigo = p-it-codigo:

        FOR EACH estrutura NO-LOCK
           WHERE estrutura.it-codigo    =  altern-astec.it-altern
             AND estrutura.data-inicio  <= TODAY 
             AND estrutura.data-termino >  TODAY:
            
            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = estrutura.es-codigo:
            END.

            CREATE ItemEstrutura.             
            ASSIGN ItemEstrutura.CodigoProduto       = p-it-codigo
                   ItemEstrutura.CodigoItemEstrutura = estrutura.es-codigo
                   ItemEstrutura.DescricaoItem       = ITEM.desc-item
                   ItemEstrutura.QuantidadeUsada     = round(estrutura.quant-usada,2).
    
            FOR FIRST int-estrutura NO-LOCK
                WHERE int-estrutura.it-codigo = estrutura.it-codigo
                  AND int-estrutura.sequencia = estrutura.sequencia
                  AND int-estrutura.es-codigo = estrutura.es-codigo:
                   
                ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                       ItemEstrutura.PermiteVenda       = int-estrutura.venda
                       ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.
    
            END.

            RUN pi-tipo-item.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-carrega-estrutura:
    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.

    FOR EACH estrutura 
       WHERE estrutura.it-codigo = p-it-codigo 
         AND estrutura.data-inicio <= TODAY 
         AND estrutura.data-termino > TODAY NO-LOCK:

        FOR FIRST b-ITEM NO-LOCK
            WHERE b-ITEM.it-codigo = estrutura.es-codigo:
        END.

        CREATE ItemEstrutura.             
        ASSIGN ItemEstrutura.CodigoProduto       = b2-ITEM.it-codigo
               ItemEstrutura.CodigoItemEstrutura = estrutura.es-codigo
               ItemEstrutura.DescricaoItem       = b-ITEM.desc-item
               ItemEstrutura.QuantidadeUsada     = round(estrutura.quant-usada,2).

        FOR FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = estrutura.it-codigo
              AND int-estrutura.sequencia = estrutura.sequencia
              AND int-estrutura.es-codigo = estrutura.es-codigo:
               
            ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                   ItemEstrutura.PermiteVenda       = int-estrutura.venda
                   ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.

        END.

        RUN pi-tipo-item.
        RUN pi-carrega-estrutura (INPUT estrutura.es-codigo).
    END.
    
END PROCEDURE.

PROCEDURE pi-tipo-item:
    /*Componente*/
     IF ITEM.ge-codigo = 10
     OR ITEM.ge-codigo = 12
     OR ITEM.ge-codigo = 15 THEN
         ASSIGN ItemEstrutura.TipoItem = "993520001".
     /*Acess¢rios*/
     ELSE IF ITEM.ge-codigo = 40 
     OR ITEM.ge-codigo = 42
     OR ITEM.ge-codigo = 45 THEN
         ASSIGN ItemEstrutura.TipoItem = "993520003".
     ELSE IF ITEM.ge-codigo = 20
     OR ITEM.ge-codigo = 25 THEN DO:
         /*Placas*/
         IF ITEM.desc-item BEGINS "PLACA" 
         OR ITEM.desc-item BEGINS "PCI" THEN
             ASSIGN ItemEstrutura.TipoItem = "993520004".
         /*Pe‡as*/
         ELSE 
             ASSIGN ItemEstrutura.TipoItem = "993520002".
     END.
     ELSE 
         ASSIGN ItemEstrutura.TipoItem = "993520001".
END PROCEDURE.
