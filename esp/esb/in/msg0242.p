CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/*                 <MENSAGEM>                                                                      */
/*                   <CABECALHO>                                                                   */
/*                     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                     <NumeroOperacao>gu048488-2015-07-01-2015-07-31-2-fr04965</NumeroOperacao>   */
/*                     <CodigoMensagem>MSG0242</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0242>                                                               */
/*                            <ProcessoImportacao>                                                 */
/*                                <CodigoDespachante></CodigoDespachante>                          */
/*                                <CodigoAgenteCargas></CodigoAgenteCargas>                        */
/*                                <CodigoItinerario>69</CodigoItinerario>                          */
/*                                <CodigoIdioma>POR</CodigoIdioma>                                 */
/*                                <CodigoCorretorCambio></CodigoCorretorCambio>                    */
/*                                <CodigoDespachanteExterior></CodigoDespachanteExterior>          */
/*                                <CodigoSeguradora></CodigoSeguradora>                            */
/*                                <CodigoCorretorSeguro></CodigoCorretorSeguro>                    */
/*                                <NumeroPedidoCompra>275144</NumeroPedidoCompra>                  */
/*                            </ProcessoImportacao>                                                */
/*                         </MSG0242>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0242.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0242, ProcessoImportacao
   DATA-RELATION FOR conteudo, MSG0242           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0242, ProcessoImportacao RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0242R1, resultado
   DATA-RELATION FOR conteudor, MSG0242R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0242R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0242R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0242 NO-ERROR.

CREATE conteudor.
CREATE MSG0242R1.
CREATE resultado.

RUN pi-processo-imp.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-processo-imp:
    DEFINE VARIABLE i-aux     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE r-rowid   AS ROWID       NO-UNDO.
    DEFINE VARIABLE c-return  AS CHARACTER   NO-UNDO.

    FIND FIRST ProcessoImportacao NO-ERROR.

    IF NOT AVAIL ProcessoImportacao THEN DO:
        RUN pi-erro (INPUT "Dados para geraá∆o do processo de importaá∆o n∆o enviados").
        RETURN "NOK".
    END.

    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = ProcessoImportacao.NumeroPedidoCompra NO-ERROR.

    IF NOT AVAIL pedido-compr THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado pedido n£mero: " + STRING(ProcessoImportacao.NumeroPedidoCompra)).
        RETURN "NOK".
    END.

    RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
    RUN openQuery      IN  h-bocx140 (INPUT 1).
        
    RUN verificaPedidoProcesso IN  h-bocx140 (INPUT  pedido-compr.num-pedido, 
                                              OUTPUT i-aux, 
                                              OUTPUT r-rowid).

    FIND FIRST ProcessoImportacao NO-LOCK NO-ERROR.

    /* Zero significa que n∆o existem processos de importaá∆o para esse pedido de compra */
    IF  i-aux = 0 THEN DO:
        
        FOR FIRST emitente-cex NO-LOCK 
            WHERE emitente-cex.cod-emitente = pedido-compr.cod-emitente:
        END.

        IF NOT AVAIL ProcessoImportacao THEN DO:
            RUN pi-erro (INPUT "Dados para geraá∆o do processo de importaá∆o n∆o enviados.").
            RETURN "NOK".
        END.
                 
        CREATE tt-processo-imp.
        ASSIGN tt-processo-imp.cod-estabel                = pedido-compr.end-entrega
               tt-processo-imp.cod-exportador             = pedido-compr.cod-emitente
               tt-processo-imp.cod-fabricante             = pedido-compr.cod-emitente
               tt-processo-imp.cod-idioma                 = ProcessoImportacao.CodigoIdioma     /*IF AVAIL emitente-cex THEN emitente-cex.cod-idioma       ELSE ""*/
               tt-processo-imp.cod-incoterm               = IF AVAIL emitente-cex THEN emitente-cex.cod-incoterm-imp ELSE ""
               tt-processo-imp.cod-itiner                 = ProcessoImportacao.CodigoItinerario /*IF AVAIL emitente-cex THEN emitente-cex.cod-itiner-imp   ELSE 0*/
               tt-processo-imp.cod-transportador          = pedido-compr.cod-transp
               tt-processo-imp.dt-emissao                 = pedido-compr.data-pedido
               tt-processo-imp.estab-fisc                 = pedido-compr.end-entrega
               tt-processo-imp.nr-proc-imp                = STRING(pedido-compr.num-pedido)
               tt-processo-imp.num-pedido                 = pedido-compr.num-pedido
               tt-processo-imp.situacao                   = 1 /* N∆o Embarcado */
               tt-processo-imp.via-transp                 = pedido-compr.via-transp
               tt-processo-imp.cdn-corretor-cambio-import = ProcessoImportacao.CodigoCorretorCambio      /*IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-cambio-import ELSE 0*/
               tt-processo-imp.cdn-despa-exter-import     = ProcessoImportacao.CodigoDespachanteExterior /*IF AVAIL emitente-cex THEN emitente-cex.cdn-despa-exter-import     ELSE 0*/
               tt-processo-imp.cdn-segurad-import         = ProcessoImportacao.CodigoSeguradora          /*IF AVAIL emitente-cex THEN emitente-cex.cdn-segurad-import         ELSE 0*/
               tt-processo-imp.cdn-corretor-import        = ProcessoImportacao.CodigoCorretorSeguro      /*IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-import        ELSE 0*/ 
               tt-processo-imp.cod-agente                 = ProcessoImportacao.CodigoAgenteCargas
               tt-processo-imp.cod-despachante            = ProcessoImportacao.CodigoDespachante.
         
        /* Efetua as validaá‰es e cria o registro */
        RUN validateCreate IN h-bocx140 (INPUT  TABLE tt-processo-imp,
                                         OUTPUT TABLE RowErrors,
                                         OUTPUT r-rowid).        

        IF CAN-FIND (FIRST RowErrors) THEN DO:
            
            FOR EACH RowErrors NO-LOCK:                                                                                                    
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                RETURN "NOK".
            END. 
        END.    
    END.
    /*Altera o processo de importaá∆o*/
    ELSE DO:
        FIND FIRST processo-imp NO-LOCK
             WHERE ROWID(processo-imp) = r-rowid NO-ERROR.
        
        CREATE tt-processo-imp.
        BUFFER-COPY processo-imp TO tt-processo-imp.

        ASSIGN tt-processo-imp.cod-idioma                 = ProcessoImportacao.CodigoIdioma              /*IF AVAIL emitente-cex THEN emitente-cex.cod-idioma       ELSE ""*/         
               tt-processo-imp.cod-itiner                 = ProcessoImportacao.CodigoItinerario          /*IF AVAIL emitente-cex THEN emitente-cex.cod-itiner-imp   ELSE 0*/          
               tt-processo-imp.cdn-corretor-cambio-import = ProcessoImportacao.CodigoCorretorCambio      /*IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-cambio-import ELSE 0*/
               tt-processo-imp.cdn-despa-exter-import     = ProcessoImportacao.CodigoDespachanteExterior /*IF AVAIL emitente-cex THEN emitente-cex.cdn-despa-exter-import     ELSE 0*/
               tt-processo-imp.cdn-segurad-import         = ProcessoImportacao.CodigoSeguradora          /*IF AVAIL emitente-cex THEN emitente-cex.cdn-segurad-import         ELSE 0*/
               tt-processo-imp.cdn-corretor-import        = ProcessoImportacao.CodigoCorretorSeguro      /*IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-import        ELSE 0*/
               tt-processo-imp.cod-agente                 = ProcessoImportacao.CodigoAgenteCargas                                                                                     
               tt-processo-imp.cod-despachante            = ProcessoImportacao.CodigoDespachante.                                                                                     

        RUN validateUpdate IN h-bocx140 (INPUT  TABLE tt-processo-imp,
                                         INPUT ROWID(processo-imp),
                                         OUTPUT TABLE RowErrors).    
        
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:  
                RUN pi-erro (INPUT RowErrors.errorDescription).                
            END. 
            RETURN "NOK".
        END.
    END.

    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.

    /*Altera extens∆o*/
    FIND FIRST int-processo-imp EXCLUSIVE-LOCK
         WHERE int-processo-imp.cod-estabel = tt-processo-imp.cod-estabel
           AND int-processo-imp.nr-proc-imp = tt-processo-imp.nr-proc-imp NO-ERROR.

    IF NOT AVAIL int-processo-imp THEN DO:
        CREATE int-processo-imp.
        ASSIGN int-processo-imp.cod-estabel = tt-processo-imp.cod-estabel
               int-processo-imp.nr-proc-imp = tt-processo-imp.nr-proc-imp.
    END.

    ASSIGN int-processo-imp.NomeDestino = ProcessoImportacao.NomeDestino.

    FIND CURRENT int-processo-imp NO-LOCK.

    RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
