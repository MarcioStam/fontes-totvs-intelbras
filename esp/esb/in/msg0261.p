CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>LISTAR_FABRICANTES_ITEM</NumeroOperacao>                    */
/*     <CodigoMensagem>MSG0261</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0261>                                                                   */
/*       <DataInicialPeriodo>2013-11-26</DataInicialPeriodo>                       */
/*       <DataFinalPeriodo>2013-12-26</DataFinalPeriodo>                           */
/*     </MSG0261>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0261.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0261
   DATA-RELATION FOR conteudo, msg0261                       RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0261R1, SwiftItem, SwiftPagamento, resultado
   DATA-RELATION FOR conteudor,  msg0261R1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0261R1,  SwiftItem       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SwiftItem, SwiftPagamento   RELATION-FIELDS (CodigoSwift, CodigoSwift) NESTED
   DATA-RELATION FOR msg0261R1,  resultado       RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0261R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0261 NO-ERROR.

CREATE conteudor.
CREATE msg0261R1.
CREATE resultado.

RUN pi-busca-swift.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-busca-swift:

    IF msg0261.CodigoSwift <> ? THEN DO:
        FOR EACH pagamento NO-LOCK
           WHERE pagamento.swift = msg0261.CodigoSwift:

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.

            RUN pi-cria-retorno.

        END.
    END.
    ELSE IF msg0261.CodigoSolicitacaoInterna <> ? THEN DO:
        FOR EACH pagamento NO-LOCK
           WHERE pagamento.nr-pagamento = msg0261.CodigoSolicitacaoInterna
             AND pagamento.swift <> "":

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.

            RUN pi-cria-retorno.

        END.
    END.
    ELSE IF msg0261.DataInicialPeriodo <> ? THEN DO:
        FOR EACH pagamento NO-LOCK
           WHERE pagamento.data-swift >= msg0261.DataInicialPeriodo
             AND pagamento.data-swift <= msg0261.DataFinalPeriodo
             AND pagamento.swift <> "":

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.

            RUN pi-cria-retorno.

        END.
    END.
    ELSE IF msg0261.MatriculaResponsavel <> ? THEN DO:
        FOR EACH pagamento NO-LOCK
           WHERE pagamento.usuar-receb = msg0261.MatriculaResponsavel
             AND pagamento.swift <> "":

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.

            RUN pi-cria-retorno.

        END.
    END.
    ELSE DO:
        FOR EACH pagamento 
           WHERE pagamento.swift <> "" NO-LOCK:

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.

            RUN pi-cria-retorno.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-filtros:

    IF msg0261.CodigoSwift <> ? THEN DO:
        IF msg0261.CodigoSwift <> pagamento.swift THEN
            RETURN "NOK".
    END.

    IF msg0261.CodigoSolicitacaoInterna <> ? THEN DO:
        IF msg0261.CodigoSolicitacaoInterna <> pagamento.nr-pagamento THEN
            RETURN "NOK".
    END.

    IF msg0261.CodigoFornecedorEMS <> ? THEN DO:
        IF msg0261.CodigoFornecedorEMS <> pagamento.cod-emitente THEN
            RETURN "NOK".
    END.

    IF msg0261.CodigoEstabelecimento <> ? THEN DO:
        IF msg0261.CodigoEstabelecimento <> pagamento.cod-estabel THEN
            RETURN "NOK".
    END.

    IF msg0261.MatriculaResponsavel <> ? THEN DO:
        IF msg0261.MatriculaResponsavel <> pagamento.usuar-receb THEN
            RETURN "NOK".
    END.

    IF msg0261.CodigoCondicaoPagamento <> ? THEN DO:
        IF msg0261.CodigoCondicaoPagamento <> pagamento.cod-cond-pag THEN
            RETURN "NOK".
    END.

    IF msg0261.DataInicialPeriodo <> ? THEN DO:
        IF  NOT (pagamento.data-swif >= msg0261.DataInicialPeriodo
        AND pagamento.data-swift <= msg0261.DataFinalPeriodo) THEN
            RETURN "NOK".
    END.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-retorno:

    IF NOT CAN-FIND (FIRST SwiftItem
                     WHERE SwiftItem.CodigoSwift = pagamento.swift) THEN DO:
        CREATE SwiftItem.
        ASSIGN SwiftItem.CodigoSwift = pagamento.swift
               SwiftItem.DataSwift   = pagamento.data-swift.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = pagamento.cod-emitente NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = pagamento.usuar-receb NO-ERROR.

    CREATE SwiftPagamento.
    ASSIGN SwiftPagamento.CodigoSwift              = pagamento.swift        
           SwiftPagamento.CodigoSolicitacaoInterna = pagamento.nr-pagamento 
           SwiftPagamento.CodigoFornecedorEMS      = pagamento.cod-emitente 
           SwiftPagamento.NomeAbreviadoFornecedor  = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""   .

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
