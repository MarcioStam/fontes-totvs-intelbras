/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prm1102rp.p                                                                                                                                          **
** Data .........: Outubro de 2020                                                                                                                                      **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Integra‡Æo Notas Fiscais Baixadas pelo Integrador                                                                                                    **
** Revisäes **************************************************************************************************************************************************************
** Autor                Ver.    Data      Cliente     Solicitante     Descri‡Æo                                                                                         **
** Alexandro Carvalho   00.001  09/10/20  CRS         CRS             1) Desenvolvimento inicial do programa                                                            **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

USING OpenEdge.Core.Collections.List.

ROUTINE-LEVEL ON ERROR UNDO, THROW. 

{include/i-prgvrs.i prm1102rp 1.00.00.000}
{prmp/prm1102.i}
{utp/ut-glob.i}
{prmapi/PrmNotaFiscalIntegrador.i}

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE   NO-UNDO.

FUNCTION getNomeArquivo RETURNS CHARACTER (INPUT c-arq AS CHARACTER) FORWARD.

/***--------- Parƒmetros ---------***/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FORM tt-log.cod-proj-int    FORMAT "x(10)"     COLUMN-LABEL "Integrador"   SPACE(1)
     tt-log.tipo            FORMAT "x(15)"     COLUMN-LABEL "Tipo"         SPACE(1)
     tt-log.arquivo         FORMAT "x(80)"     COLUMN-LABEL "Arquivo"      SPACE(1)
     tt-log.cod-estabel     FORMAT "x(5)"      COLUMN-LABEL "Estab"        SPACE(1)
     tt-log.serie           FORMAT "x(5)"      COLUMN-LABEL "S‚rie"        SPACE(1)
     tt-log.nr-nota-fis     FORMAT "x(16)"     COLUMN-LABEL "Nr NF"        SPACE(1)
     tt-log.cod-emitente    FORMAT ">>>>>>>>9" COLUMN-LABEL "Emitente"     SPACE(1)
     tt-log.nat-operacao    FORMAT "x(06)"     COLUMN-LABEL "Natur Oper"   SPACE(1)
     tt-log.msg             FORMAT "x(150)"    COLUMN-LABEL "Mensagem"
    WITH STREAM-IO WIDTH 321 NO-BOX 60 DOWN FRAME f-doc.

{include/i-rpvar.i}

ASSIGN c-titulo-relat = "Gera‡Æo Nota Fiscal Pelo XML Baixado - Projeto Integrador".

FIND FIRST tt-param NO-LOCK NO-ERROR.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT "Processando Notas...").
RUN pi-processa-integracao.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-imprimir-log.
RUN pi-finalizar IN h-acomp.
{include/i-rpclo.i}

RETURN "OK":U.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-processa-integracao:

    DEFINE VARIABLE prmProjetoIntegrador AS CLASS prmapi.PrmProjetoIntegrador    NO-UNDO.    
    DEFINE VARIABLE listaArquivos        AS List                                 NO-UNDO.
    DEFINE VARIABLE c-cod-proj-int       AS CHARACTER                            NO-UNDO.

    FOR EACH prm-projeto-integrador NO-LOCK ON ERROR UNDO, NEXT:
        
        ASSIGN c-cod-proj-int = prm-projeto-integrador.cod-proj-int.
        
        ASSIGN prmProjetoIntegrador = NEW prmapi.PrmProjetoIntegrador(INPUT prm-projeto-integrador.cod-proj-int).
        
        IF tt-param.l-remessa THEN DO:
            ASSIGN listaArquivos = NEW List()
                   listaArquivos = prmProjetoIntegrador:getXMLNaoImportadosRemessa().

            RUN pi-processa-nota-remessa(INPUT c-cod-proj-int,
                                     INPUT listaArquivos).
        END.

        IF tt-param.l-venda THEN DO:
            ASSIGN listaArquivos        = NEW List()
                   listaArquivos        = prmProjetoIntegrador:getXMLNaoImportadosVenda().
            
            RUN pi-processa-nota-venda(INPUT c-cod-proj-int,
                                       INPUT listaArquivos).
        END.

        IF tt-param.l-cancela THEN DO:
            ASSIGN listaArquivos = NEW List()
                   listaArquivos = prmProjetoIntegrador:getXMLNaoImportadosCanc().
                                 
            RUN pi-processa-nota-cancelada(INPUT c-cod-proj-int,
                                           INPUT listaArquivos).
        END.
                                     
        IF tt-param.l-retorno THEN DO:
            ASSIGN listaArquivos = NEW List()
                   listaArquivos = prmProjetoIntegrador:getXMLNaoImportadosRetorno().                               
                                       
            RUN pi-processa-nota-retorno(INPUT c-cod-proj-int,
                                         INPUT listaArquivos).
        END.
                                     
        IF tt-param.l-devolucao THEN DO:
            ASSIGN listaArquivos = NEW List()
                   listaArquivos = prmProjetoIntegrador:getXMLNaoImportadosDevolucao().                               
                                       
            RUN pi-processa-nota-devolucao(INPUT c-cod-proj-int,
                                           INPUT listaArquivos).
        END.
                                     
        CATCH erro AS Progress.Lang.Error:
           CREATE tt-log.
           ASSIGN tt-log.cod-proj-int = c-cod-proj-int
                  tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.
    END.
END PROCEDURE.

PROCEDURE pi-processa-nota-venda:
    
    DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pListaArquivos AS List      NO-UNDO.
    
    DEFINE VARIABLE nf              AS CLASS prmapi.NotaVendaIntegrador NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE rw-nota-fiscal  AS ROWID                            NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER                        NO-UNDO.
    
    DO i = 1 TO pListaArquivos:SIZE ON ERROR UNDO, NEXT:
                        
        ASSIGN c-arquivo = pListaArquivos:Get(INPUT i):ToString().                
        
        RUN pi-acompanhar IN h-acomp(INPUT "Nota de Venda: " + getNomeArquivo(c-arquivo)).                                                                                        
        nf = NEW prmapi.NotaVendaIntegrador(INPUT p-cod-proj-int).                                        
        ASSIGN rw-nota-fiscal = nf:GerarNFPeloArquivoXML(INPUT c-arquivo, 
                                                         INPUT 1 /*1 - VENDA*/).               
        
        FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-LOCK NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "VENDA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "Nota fiscal criada com sucesso."
                   tt-log.cod-estabel  = nota-fiscal.cod-estabel
                   tt-log.serie        = nota-fiscal.serie
                   tt-log.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   tt-log.cod-emitente = nota-fiscal.cod-emitente
                   tt-log.nat-operacao = nota-fiscal.nat-operacao.
        END.
        ELSE DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "VENDA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "NÆo ocorreram erros, por‚m a nota nÆo foi gerada.".            
        END.            
        
        CATCH erro AS Progress.Lang.Error :            
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "VENDA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.            
    END.
END PROCEDURE.

PROCEDURE pi-processa-nota-cancelada:
    
    DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pListaArquivos AS List      NO-UNDO.
    
    DEFINE VARIABLE nf              AS CLASS prmapi.NotaCancIntegrador  NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE rw-nota-fiscal  AS ROWID                            NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER                        NO-UNDO.
    
    DO i = 1 TO pListaArquivos:SIZE ON ERROR UNDO, NEXT:
                        
        ASSIGN c-arquivo = pListaArquivos:Get(INPUT i):ToString().                
        
        IF INDEX(c-arquivo, "110111-procEventoNFe") <= 0 THEN
            NEXT.
        
        RUN pi-acompanhar IN h-acomp(INPUT "Nota Cancelada: " + getNomeArquivo(c-arquivo)).                                                                                        
        nf = NEW prmapi.NotaCancIntegrador(INPUT p-cod-proj-int).                                        
        ASSIGN rw-nota-fiscal = nf:GerarNFPeloArquivoXML(INPUT c-arquivo).               
        
        FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-LOCK NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "CANCELADA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "Nota fiscal cancelada com sucesso."
                   tt-log.cod-estabel  = nota-fiscal.cod-estabel
                   tt-log.serie        = nota-fiscal.serie
                   tt-log.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   tt-log.cod-emitente = nota-fiscal.cod-emitente
                   tt-log.nat-operacao = nota-fiscal.nat-operacao.
        END.
        ELSE DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "CANCELADA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "NÆo ocorreram erros, por‚m a nota nÆo foi cancelada.".            
        END.            
        
        CATCH erro AS Progress.Lang.Error:            
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "CANCELADA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.            
    END.
END.

PROCEDURE pi-processa-nota-remessa:
    
    DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pListaArquivos AS List      NO-UNDO.
    
    DEFINE VARIABLE nf              AS CLASS prmapi.NotaVendaIntegrador NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE rw-nota-fiscal  AS ROWID                            NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER                        NO-UNDO.
    
    DO i = 1 TO pListaArquivos:SIZE ON ERROR UNDO, NEXT:
                        
        ASSIGN c-arquivo = pListaArquivos:Get(INPUT i):ToString().                
        
        RUN pi-acompanhar IN h-acomp(INPUT "Nota de Remessa: " + getNomeArquivo(c-arquivo)).                                                                                        
        nf = NEW prmapi.NotaVendaIntegrador(INPUT p-cod-proj-int).                                        
        ASSIGN rw-nota-fiscal = nf:GerarNFPeloArquivoXML(INPUT c-arquivo, INPUT 3 /*3 - REMESSA*/).               
        
        FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-LOCK NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "REMESSA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "Nota fiscal criada com sucesso."
                   tt-log.cod-estabel  = nota-fiscal.cod-estabel
                   tt-log.serie        = nota-fiscal.serie
                   tt-log.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   tt-log.cod-emitente = nota-fiscal.cod-emitente
                   tt-log.nat-operacao = nota-fiscal.nat-operacao.
        END.
        ELSE DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "REMESSA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "NÆo ocorreram erros, por‚m a nota nÆo foi gerada.".            
        END.            
        
        CATCH erro AS Progress.Lang.Error:            
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "REMESSA"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.            
    END.
END.

PROCEDURE pi-processa-nota-retorno:
    
    DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pListaArquivos AS List      NO-UNDO.
    
    DEFINE VARIABLE nf              AS CLASS prmapi.NotaRecebimentoIntegrador NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                                NO-UNDO.
    DEFINE VARIABLE rw-docum-est    AS ROWID                                  NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER                              NO-UNDO.
    
    DO i = 1 TO pListaArquivos:SIZE ON ERROR UNDO, NEXT:
                        
        ASSIGN c-arquivo = pListaArquivos:Get(INPUT i):ToString().                
        
        RUN pi-acompanhar IN h-acomp(INPUT "Nota de Retorno: " + getNomeArquivo(c-arquivo)).                                                                                        
        nf = NEW prmapi.NotaRecebimentoIntegrador(INPUT p-cod-proj-int).                                        
        ASSIGN rw-docum-est = nf:GerarNFPeloArquivoXML(INPUT c-arquivo, 
                                                       INPUT v_cod_usuar_corren,
                                                       INPUT 4 /*4 - RETORNO*/).               
        
        FIND FIRST docum-est WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.
        IF AVAILABLE(docum-est) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "RETORNO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "Nota fiscal criada com sucesso."
                   tt-log.cod-estabel  = docum-est.cod-estabel
                   tt-log.serie        = docum-est.serie-docto
                   tt-log.nr-nota-fis  = docum-est.nro-docto
                   tt-log.cod-emitente = docum-est.cod-emitente
                   tt-log.nat-operacao = docum-est.nat-operacao.
        END.
        ELSE DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "RETORNO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "NÆo ocorreram erros, por‚m a nota nÆo foi gerada.".            
        END.            
        
        CATCH erro AS Progress.Lang.Error:            
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "RETORNO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.            
    END.
END.

PROCEDURE pi-processa-nota-devolucao:
    
    DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pListaArquivos AS List      NO-UNDO.
    
    DEFINE VARIABLE nf              AS CLASS prmapi.NotaRecebimentoIntegrador NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                                NO-UNDO.
    DEFINE VARIABLE rw-docum-est    AS ROWID                                  NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER                              NO-UNDO.
    
    DO i = 1 TO pListaArquivos:SIZE ON ERROR UNDO, NEXT:
                        
        ASSIGN c-arquivo = pListaArquivos:Get(INPUT i):ToString().                
        
        RUN pi-acompanhar IN h-acomp(INPUT "Nota de Devolu‡Æo: " + getNomeArquivo(c-arquivo)).                                                                                        
        nf = NEW prmapi.NotaRecebimentoIntegrador(INPUT p-cod-proj-int).                                        
        ASSIGN rw-docum-est = nf:GerarNFPeloArquivoXML(INPUT c-arquivo,
                                                       INPUT v_cod_usuar_corren,
                                                       INPUT 5 /*5 - DEVOLU€ÇO*/).               
        
        FIND FIRST docum-est WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.
        IF AVAILABLE(docum-est) THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "DEVOLU€ÇO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "Nota fiscal criada com sucesso."
                   tt-log.cod-estabel  = docum-est.cod-estabel
                   tt-log.serie        = docum-est.serie-docto
                   tt-log.nr-nota-fis  = docum-est.nro-docto
                   tt-log.cod-emitente = docum-est.cod-emitente
                   tt-log.nat-operacao = docum-est.nat-operacao.
        END.
        ELSE DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "DEVOLU€ÇO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = "NÆo ocorreram erros, por‚m a nota nÆo foi gerada.".            
        END.            
        
        CATCH erro AS Progress.Lang.Error:            
            CREATE tt-log.
            ASSIGN tt-log.cod-proj-int = p-cod-proj-int
                   tt-log.tipo         = "DEVOLU€ÇO"
                   tt-log.arquivo      = getNomeArquivo(c-arquivo)
                   tt-log.msg          = STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).          
        END CATCH.            
    END.
END.

PROCEDURE pi-imprimir-log:

    FOR EACH tt-log NO-LOCK:  
              
        DISPLAY tt-log.cod-proj-int
                tt-log.tipo
                tt-log.arquivo
                tt-log.cod-estabel
                tt-log.serie      
                tt-log.nr-nota-fis
                tt-log.cod-emitente
                tt-log.nat-operacao
                tt-log.msg 
            WITH FRAME f-doc.
        DOWN WITH FRAME f-doc.                  
    END.
END PROCEDURE.

FUNCTION getNomeArquivo RETURNS CHARACTER (INPUT c-arq AS CHARACTER):
    
    DEFINE VARIABLE c-arq-aux AS CHARACTER NO-UNDO.
    
    ASSIGN c-arq-aux = REPLACE(c-arq, "\", "/")
           c-arq-aux = ENTRY(NUM-ENTRIES(c-arq-aux, "/"), c-arq-aux, "/").
           
    RETURN c-arq-aux.
END FUNCTION.
