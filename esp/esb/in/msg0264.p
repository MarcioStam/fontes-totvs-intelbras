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
/*     <CodigoMensagem>MSG0264</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0264>                                                                   */
/*       <DataInicialPeriodo>2013-11-26</DataInicialPeriodo>                       */
/*       <DataFinalPeriodo>2013-12-26</DataFinalPeriodo>                           */
/*     </MSG0264>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0264.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0264, SolicitacaoInternaSwift, HistoricoSolicitacaoInterna
   DATA-RELATION FOR conteudo, msg0264                   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0264,SolicitacaoInternaSwift     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0264,HistoricoSolicitacaoInterna RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0264R1, resultado
   DATA-RELATION FOR conteudor,  msg0264R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0264R1,  resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0264R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0264 NO-ERROR.

CREATE conteudor.
CREATE msg0264R1.
CREATE resultado.

RUN pi-salva-swift.

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

PROCEDURE pi-salva-swift:

    blk_swift:
    DO TRANSACTION
    ON ERROR UNDO blk_swift, LEAVE blk_swift
    ON STOP  UNDO blk_swift, LEAVE blk_swift: 
    
        FOR EACH SolicitacaoInternaSwift:
            FIND FIRST pagamento NO-LOCK
                 WHERE pagamento.nr-pagamento = SolicitacaoInternaSwift.CodigoSolicitacaoInterna NO-ERROR.
    
            IF AVAIL pagamento THEN DO:
                FIND CURRENT pagamento EXCLUSIVE-LOCK NO-ERROR.

                ASSIGN pagamento.swift      = ""
                       pagamento.data-swift = ?
                       pagamento.ind-status-solicitacao = 2 /*Aprovado*/.

                FOR EACH HistoricoSolicitacaoInterna:
                    RUN pi-gera-historico (INPUT pagamento.nr-pagamento,
                                           INPUT HistoricoSolicitacaoInterna.MatriculaUsuario,
                                           INPUT HistoricoSolicitacaoInterna.DataHistorico,
                                           INPUT HistoricoSolicitacaoInterna.HoraHistorico,
                                           INPUT HistoricoSolicitacaoInterna.AcaoHistorico,
                                           INPUT HistoricoSolicitacaoInterna.ObservacaoHistorico).
                END.

                RELEASE pagamento.
            END.
            ELSE DO:
                RUN pi-erro (INPUT "NÆo encontrada SIP " + STRING(SolicitacaoInternaSwift.CodigoSolicitacaoInterna)).
            END.
        END.

        IF CAN-FIND (FIRST tt-erro) THEN
            UNDO blk_swift, LEAVE blk_swift.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gera-historico:
    DEFINE INPUT PARAM p-nr-pagamento  AS INT.
    DEFINE INPUT PARAM p-cod-usuario   AS CHAR.
    DEFINE INPUT PARAM p-dat-hist      AS DATE.
    DEFINE INPUT PARAM p-hor-hist      AS CHAR.
    DEFINE INPUT PARAM p-ind-acao      AS INT.
    DEFINE INPUT PARAM p-txt-historico AS CHAR.

    DEFINE VARIABLE i-num-seq-hist AS INTEGER     NO-UNDO.

    FIND LAST int-hist-pagamento NO-LOCK
        WHERE int-hist-pagamento.nr-pagamento = p-nr-pagamento NO-ERROR.

    IF AVAIL int-hist-pagamento THEN
        ASSIGN i-num-seq-hist = int-hist-pagamento.num-seq-hist + 1.
    ELSE 
        ASSIGN i-num-seq-hist = 1.

   IF NOT CAN-FIND (FIRST pagamento 
                    WHERE pagamento.nr-pagamento = p-nr-pagamento) THEN DO:

       RUN pi-erro (INPUT "NÆo encontrado a SIP " + STRING(p-nr-pagamento)).
       RETURN "NOK".
   END.

   CREATE int-hist-pagamento.
   ASSIGN int-hist-pagamento.nr-pagamento  = p-nr-pagamento
          int-hist-pagamento.num-seq-hist  = i-num-seq-hist
          int-hist-pagamento.cod-usuario   = p-cod-usuario  
          int-hist-pagamento.dat-hist      = p-dat-hist     
          int-hist-pagamento.hor-hist      = p-hor-hist     
          int-hist-pagamento.ind-acao      = p-ind-acao     
          int-hist-pagamento.txt-historico = p-txt-historico.

   RELEASE int-hist-pagamento.

   RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
