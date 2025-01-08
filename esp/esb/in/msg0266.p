CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>43354-3-4</NumeroOperacao>                                  */
/*     <CodigoMensagem>MSG0266</CodigoMensagem>                                    */
/*     <LoginUsuario>ma048276</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0266>                                                                   */
/*       <AvaliacaoSolicitacaoInterna>                                             */
/*         <CodigoSolicitacaoInterna>43354</CodigoSolicitacaoInterna>              */
/*         <StatusSolicitacaoInterna>3</StatusSolicitacaoInterna>                  */
/*       </AvaliacaoSolicitacaoInterna>                                            */
/*       <HistoricoSolicitacaoInterna>                                             */
/*         <MatriculaUsuario>ma048276</MatriculaUsuario>                           */
/*         <DataHistorico>2017-01-10</DataHistorico>                               */
/*         <HoraHistorico>14:37:08</HoraHistorico>                                 */
/*         <AcaoHistorico>4</AcaoHistorico>                                        */
/*         <ObservacaoHistorico>teste teste</ObservacaoHistorico>                  */
/*       </HistoricoSolicitacaoInterna>                                            */
/*     </MSG0266>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0266.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0266, HistoricoSolicitacaoInterna, AvaliacaoSolicitacaoInterna
   DATA-RELATION FOR conteudo, msg0266                    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0266, HistoricoSolicitacaoInterna RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0266, AvaliacaoSolicitacaoInterna RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0266R1, resultado
   DATA-RELATION FOR conteudor, msg0266R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0266R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0266R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0266 NO-ERROR.

CREATE conteudor.
CREATE msg0266R1.
CREATE resultado.

RUN pi-grava-pagamento.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

IF VALID-HANDLE(h-boes138)   THEN DO:
    DELETE PROCEDURE h-boes138.
                     h-boes138 = ?.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-grava-pagamento:
    blk_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_pagamento, LEAVE blk_pagamento
    ON STOP  UNDO blk_pagamento, LEAVE blk_pagamento: 

        RUN esbo/boes138.p  PERSISTENT SET h-boes138.
        RUN openQueryStatic IN h-boes138 (INPUT "Main":U).      
    
        RUN emptyRowErrors IN h-boes138.

        FOR EACH AvaliacaoSolicitacaoInterna:
            RUN goToKey IN h-boes138 (INPUT AvaliacaoSolicitacaoInterna.CodigoSolicitacaoInterna).
            
            IF RETURN-VALUE = "OK" THEN DO:
                RUN getRecord      IN h-boes138 (OUTPUT TABLE tt-pagamento).
    
                FIND FIRST tt-pagamento.
    
                RUN pi-popula-tt.
    
                RUN setRecord    IN h-boes138 (INPUT TABLE tt-pagamento).
                RUN updateRecord IN h-boes138.
                RUN getRowErrors IN h-boes138 (OUTPUT TABLE RowErrors).
    
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK                                                                                                    
                       WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                         AND RowErrors.ErrorSubType = "Error":U:  
                        RUN pi-erro (INPUT RowErrors.errorDescription + " " + RowErrors.errorHelp).
                        UNDO blk_pagamento, LEAVE blk_pagamento.
                    END. 
                END.
            END.
            ELSE DO:
                RUN pi-erro (INPUT "No encontrado a SIP informada").       
            END.
    
            FOR EACH HistoricoSolicitacaoInterna:
                RUN pi-gera-historico (INPUT tt-pagamento.nr-pagamento,
                                       INPUT HistoricoSolicitacaoInterna.MatriculaUsuario,
                                       INPUT HistoricoSolicitacaoInterna.DataHistorico,
                                       INPUT HistoricoSolicitacaoInterna.HoraHistorico,
                                       INPUT HistoricoSolicitacaoInterna.AcaoHistorico,
                                       INPUT HistoricoSolicitacaoInterna.ObservacaoHistorico).
            END.
        END.

        IF CAN-FIND (tt-erro) THEN
            UNDO blk_pagamento, LEAVE blk_pagamento.
    END.

    IF CAN-FIND (tt-erro) THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-popula-tt:

    /*Se est alterando para recebida*/
    IF  tt-pagamento.ind-status-solicitacao <> 6
    AND AvaliacaoSolicitacaoInterna.StatusSolicitacaoInterna = 6 THEN DO:
        ASSIGN tt-pagamento.recebido-ap = YES
               tt-pagamento.usuar-receb = cabecalho.LoginUsuario
               tt-pagamento.dat-receb-financ = TODAY.
    END.
    
    ASSIGN tt-pagamento.ind-status-solicitacao = AvaliacaoSolicitacaoInterna.StatusSolicitacaoInterna.

    IF  AvaliacaoSolicitacaoInterna.StatusSolicitacaoInterna = 2
    AND tt-pagamento.data-aprovacao = ? THEN
        ASSIGN tt-pagamento.data-aprovacao = TODAY.

    RETURN "OK".
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

       RUN pi-erro (INPUT "No encontrado a SIP " + STRING(p-nr-pagamento)).
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
