{esp/es0018.i}
{method/dbotterr.i}
{utp/utapi019.i}
{esp/imp/esimp000.i1}


DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-email       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-pedidos-excluidos NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

DEFINE TEMP-TABLE tt-embarques-excluidos NO-UNDO
    FIELD embarque LIKE embarque-imp.embarque.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field l-elimina-ped    as LOG
    field l-elimina-emb    as LOG
    .

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Buscando ...").

IF tt-param.l-elimina-ped THEN
    RUN pi-elimina-ped.

IF tt-param.l-elimina-emb THEN
    RUN pi-elimina-emb.

RUN pi-finalizar IN h-acomp.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "esimp016":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN c-email = "".

    FOR EACH tt-erro:
        ASSIGN c-email = c-email + tt-erro.mensagem + CHR(13). 
    END.

    
    ASSIGN c-endereco = "".
    FOR EACH tt-prog-ponto:
        ASSIGN c-endereco = IF c-endereco = "" THEN tt-prog-ponto.conteudo ELSE "," + tt-prog-ponto.conteudo.
    END. 

    RUN piEnviaEmailAtendente(INPUT c-endereco,
                              INPUT "Erros exclusÆo Pedidos/Embarques vazios (esimp016)",
                              INPUT c-email).            
END.

OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "esimp016.txt").

FOR EACH tt-pedidos-excluidos:
    PUT UNFORMATTED "pedido: " + string(tt-pedidos-excluidos.num-pedido) SKIP.
END.

FOR EACH tt-embarques-excluidos:
    PUT UNFORMATTED "embarque: " + tt-embarques-excluidos.embarque SKIP.
END.

OUTPUT CLOSE.

RETURN "OK".

PROCEDURE pi-elimina-ped:

    DEFINE VARIABLE h-boin295   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin274vl AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-pedido    AS INTEGER     NO-UNDO.

    RUN inbo/boin295.p PERSISTENT SET h-boin295.
    RUN openQueryStatic IN h-boin295 (INPUT "Main":U).

    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.

    /*ASSIGN i-cont = 0.*/
    blk_for_each:
    FOR EACH pedido-compr 
       WHERE pedido-compr.situacao < 3 NO-LOCK:

        /*Pedido Vazio*/
        IF NOT CAN-FIND (FIRST ordem-compra
                         WHERE ordem-compra.num-pedido = pedido-compr.num-pedido) THEN DO:

            ASSIGN i-pedido = pedido-compr.num-pedido.

            RUN emptyRowErrors    IN h-boin274vl.
            RUN validateSegcc0300 IN h-boin274vl (INPUT 3,
                                                  INPUT pedido-compr.num-pedido).
        
            RUN validaEliminacaoPedidoCompra IN h-boin274vl (INPUT ROWID(pedido)).
            RUN getRowErrors IN h-boin274vl (OUTPUT TABLE RowErrors).
    
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT "Pedido: " + STRING(pedido-compr.num-pedido) + " " + RowErrors.errorDescription).                                                                                                                                                                                       
                    NEXT blk_for_each.
                END. 
            END.

            RUN pi-acompanhar in h-acomp (input "Pedido: " + string(pedido-compr.num-pedido)).

            RUN emptyRowErrors    IN h-boin295.
            RUN validateSegcc0300 IN h-boin295 (INPUT "Delete",
                                                INPUT pedido-compr.emergencial,
                                                INPUT pedido-compr.situacao).
    
            RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT "Pedido: " + STRING(pedido-compr.num-pedido) + " " + RowErrors.errorDescription).                                                                                                                                                                                       
                    NEXT blk_for_each.
                END. 
            END.
    
            /*excluir automaticamente processo de importa‡Æo*/
            RUN pi-elimina-processo-imp (INPUT pedido-compr.num-pedido).
            IF RETURN-VALUE <> "OK" THEN
                NEXT blk_for_each.
    
            IF pedido-compr.situacao = 1 /*Impresso*/ 
            OR pedido-compr.situacao = 2 THEN DO:
                
                IF pedido-compr.situacao = 1 THEN DO: /*Impresso*/
                     RUN emptyRowErrors      IN h-boin295.
                     RUN eliminaPedidoCompra IN h-boin295 (INPUT ROWID(pedido-compr), 
                                                           INPUT "", 
                                                           INPUT "Elimina‡Æo autom tica de pedidos sem ordem.").
                     
                    RUN aprovEletronicaDeletePedido IN h-boin295 (INPUT pedido-compr.num-pedido).
                    RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).

                    IF CAN-FIND (FIRST RowErrors) THEN DO:
                        FOR EACH RowErrors NO-LOCK                                                                                                    
                           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                             AND RowErrors.ErrorSubType = "Error":U:  
                            RUN pi-erro (INPUT "Pedido: " + STRING(pedido-compr.num-pedido) + " " + RowErrors.errorDescription).                                                                                                                                                                                       
                            NEXT blk_for_each.
                        END. 
                    END.
                END.
                ELSE DO: /*NÆo Impresso*/

                    RUN emptyRowErrors              IN h-boin295.
                    RUN aprovEletronicaDeletePedido IN h-boin295 (INPUT pedido-compr.num-pedido).
                    RUN repositionRecord            IN h-boin295 (INPUT ROWID(pedido-compr)).
                    RUN deleteRecord                IN h-boin295.
                    
                    RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
            
                    IF CAN-FIND (FIRST RowErrors) THEN DO:
                        FOR EACH RowErrors NO-LOCK                                                                                                    
                           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                             AND RowErrors.ErrorSubType = "Error":U:  
                            
                            RUN pi-erro (INPUT "Pedido: " + STRING(pedido-compr.num-pedido) + " " + RowErrors.errorDescription).                                                                                                                                                                                       
                            NEXT blk_for_each.
                        END. 
                    END.
                END.
            END.
            CREATE tt-pedidos-excluidos.
            ASSIGN tt-pedidos-excluidos.num-pedido = i-pedido.
        END.
    END.

    DELETE PROCEDURE h-boin295.
    DELETE PROCEDURE h-boin274vl.
END PROCEDURE.

PROCEDURE pi-elimina-emb:
    
    DEFINE VARIABLE h-bocx220  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE r-row      AS ROWID       NO-UNDO.
    DEFINE VARIABLE c-embarque AS CHARACTER   NO-UNDO.

    RUN cxbo/bocx220.p  PERSISTENT SET h-bocx220.
    RUN openQuery IN h-bocx220 (INPUT 1).
    
    /*ASSIGN i-cont = 0.*/
    FOR EACH embarque-imp 
       WHERE embarque-imp.situacao = 1 NO-LOCK:

        {esp/imp/esimp000.i}
        FIND FIRST tt-emb NO-ERROR.
        IF AVAIL tt-emb AND tt-emb.situacao = 97 THEN NEXT. /* Manut */

        IF CAN-FIND (FIRST ordens-embarque OF embarque-imp) THEN
            NEXT.

        IF CAN-FIND (FIRST invoice-emb-imp OF embarque-imp) THEN
            NEXT.

        IF CAN-FIND (FIRST ext-embarque-imp OF embarque-imp
                     WHERE ext-embarque-imp.PossuiAnexo) THEN
            NEXT.

        IF CAN-FIND (FIRST pagamento-invoice NO-LOCK
                     WHERE pagamento-invoice.embarque = embarque-imp.embarque) THEN
            NEXT.

        RUN pi-acompanhar in h-acomp (input "Embarque: " + string(embarque-imp.embarque)).

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
               AND historico-embarque.embarque    = embarque-imp.embarque
               AND historico-embarque.dt-efetiva  <> ? NO-ERROR.

        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.embarque = embarque-imp.embarque NO-ERROR.

        IF NOT AVAIL historico-embarque AND
           NOT AVAIL ordens-embarque   THEN DO:
            for each decl-hist-embarq-imp
                where decl-hist-embarq-imp.cod-estabel = embarque-imp.cod-estabel
                  and decl-hist-embarq-imp.embarque    = embarque-imp.embarque   exclusive-lock:
                delete decl-hist-embarq-imp.
            end.

            for each historico-embarque
                where historico-embarque.cod-estabel = embarque-imp.cod-estabel
                  and historico-embarque.embarque    = embarque-imp.embarque   exclusive-lock:
                delete historico-embarque.
            end.

            for each desp-embarque
                where desp-embarque.cod-estabel = embarque-imp.cod-estabel
                  and desp-embarque.embarque    = embarque-imp.embarque   exclusive-lock:
                delete desp-embarque.
            end.

            for each invoice-emb-imp
                where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
                  and invoice-emb-imp.embarque    = embarque-imp.embarque    exclusive-lock:
                delete invoice-emb-imp.
            end.
        END.

        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
            WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
            AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  AVAIL  ext-embarque-imp THEN DO:
            DELETE ext-embarque-imp.
        END.

        ASSIGN c-embarque = embarque-imp.embarque.

        ASSIGN r-row = ROWID(embarque-imp).
        
        RUN validateDelete IN h-bocx220 (INPUT-OUTPUT r-row,
                                         OUTPUT TABLE RowErrors).    
        
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:                                                                                                    
                RUN pi-erro (INPUT "Embarque: " + STRING(embarque-imp.embarque) + " Estabelecimento: " + embarque-imp.cod-estabel + " " + RowErrors.errorDescription).
            END. 
        END.   

        CREATE tt-embarques-excluidos.
        ASSIGN tt-embarques-excluidos.embarque = c-embarque.
    END.

    DELETE PROCEDURE h-bocx220.

END PROCEDURE.

PROCEDURE pi-elimina-processo-imp:
    DEFINE INPUT PARAM p-num-pedido LIKE pedido-compr.num-pedido.
    DEFINE VARIABLE r-row     AS ROWID       NO-UNDO.
    DEFINE VARIABLE h-bocx140 AS HANDLE      NO-UNDO.
    
    FIND FIRST processo-imp NO-LOCK
         WHERE processo-imp.num-pedido = p-num-pedido NO-ERROR.

    /*Se n’o possui processo de importa»’o retorna*/
    IF NOT AVAIL processo-imp THEN DO:
        RETURN "OK".
    END.

    RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
    RUN openQuery      IN  h-bocx140 (INPUT 1).

    ASSIGN r-row = ROWID(processo-imp).

    RUN validateDelete IN h-bocx140 (INPUT-OUTPUT r-row,
                                     OUTPUT TABLE RowErrors).    

    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.

    IF CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK:  
            RUN pi-erro (INPUT "Pedido: " + STRING(p-num-pedido) + " " + RowErrors.errorDescription).                
        END. 
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE piEnviaEmailAtendente :
    
    DEFINE INPUT  PARAM pDestino   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-utapi019     AS HANDLE    NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                 /* Destinatÿrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = ""                       /* Arquivo Temporÿrio */
           tt-envio2.formato           = "TEXTO".
    
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem    = 1
           tt-mensagem.mensagem        = pDescEmail + CHR(13). /* Mensagem */
    
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 
    
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

