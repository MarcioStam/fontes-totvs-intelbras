CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO. */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO. */

/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                                    */
/* <MENSAGEM>                                                                                               */
/*   <CABECALHO>                                                                                            */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor>                          */
/*     <NumeroOperacao>64484-184040-200-false-1-2-231</NumeroOperacao>                                      */
/*     <CodigoMensagem>MSG0254</CodigoMensagem>                                                             */
/*     <LoginUsuario>fe052215</LoginUsuario>                                                                */
/*   </CABECALHO>                                                                                           */
/*   <CONTEUDO>                                                                                             */
/*     <MSG0254>                                                                                            */
/*       <CodigoSolicitacaoInterna>64484</CodigoSolicitacaoInterna>                                         */
/*       <DataEmissao>2021-02-19</DataEmissao>                                                              */
/*       <PrevFechaCambio>2021-03-15</PrevFechaCambio>                                                      */
/*       <Urgente>false</Urgente>                                                                           */
/*       <CodigoFornecedorEMS>184040</CodigoFornecedorEMS>                                                  */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                                                 */
/*       <ValorSolicitacaoInterna>200</ValorSolicitacaoInterna>                                             */
/*       <CodigoMoedaEMS>1</CodigoMoedaEMS>                                                                 */
/*       <TipoSolicitacaoInterna>1</TipoSolicitacaoInterna>                                                 */
/*       <StatusSolicitacaoInterna>2</StatusSolicitacaoInterna>                                             */
/*       <CodigoCondicaoPagamento>231</CodigoCondicaoPagamento>                                             */
/*       <CodigoTipoDespesa>2</CodigoTipoDespesa>                                                           */
/*       <MatriculaResponsavel>ag053281</MatriculaResponsavel>                                              */
/*       <MatriculaComprador>AG054535</MatriculaComprador>                                                  */
/*       <PossuiAnexos>false</PossuiAnexos>                                                                 */
/*       <PagamentoAntecipado>false</PagamentoAntecipado>                                                   */
/*       <CodigoDespachante>235170</CodigoDespachante>                                                      */
/*       <HistoricoSolicitacaoInterna>                                                                      */
/*         <MatriculaUsuario>fe052215</MatriculaUsuario>                                                    */
/*         <DataHistorico>2021-02-23</DataHistorico>                                                        */
/*         <HoraHistorico>09:12:18</HoraHistorico>                                                          */
/*         <AcaoHistorico>3</AcaoHistorico>                                                                 */
/*         <ObservacaoHistorico>Solicitaá∆o foi aprovada parcialmente por Fernanda Meinschein (supervisor). */
/*  aprovado</ObservacaoHistorico>                                                                          */
/*       </HistoricoSolicitacaoInterna>                                                                     */
/*       <HistoricoSolicitacaoInterna>                                                                      */
/*         <MatriculaUsuario>fe052215</MatriculaUsuario>                                                    */
/*         <DataHistorico>2021-02-23</DataHistorico>                                                        */
/*         <HoraHistorico>09:12:18</HoraHistorico>                                                          */
/*         <AcaoHistorico>3</AcaoHistorico>                                                                 */
/*         <ObservacaoHistorico>Solicitaá∆o foi aprovada.</ObservacaoHistorico>                             */
/*       </HistoricoSolicitacaoInterna>                                                                     */
/*     </MSG0254>                                                                                           */
/*   </CONTEUDO>                                                                                            */
/* </MENSAGEM>".                                                                                            */

{esp/esb/in/msg0254.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0254, HistoricoSolicitacaoInterna
   DATA-RELATION FOR conteudo, msg0254 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0254R1, resultado
   DATA-RELATION FOR conteudor, msg0254R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0254R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0254R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0254 NO-ERROR.

CREATE conteudor.
CREATE msg0254R1.
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

        /*Criaá∆o*/
        IF msg0254.CodigoSolicitacaoInterna = ? THEN DO:

            CREATE tt-pagamento.

            RUN pi-popula-tt.

            RUN emptyRowErrors IN h-boes138.
            RUN setRecord      IN h-boes138 (INPUT TABLE tt-pagamento).
            RUN createRecord   IN h-boes138.
            RUN getRowErrors   IN h-boes138 (OUTPUT TABLE RowErrors).

            IF CAN-FIND (FIRST RowErrors) THEN DO:
                
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription + " " + RowErrors.errorHelp).                                                                                                                                                                                       
                    UNDO blk_pagamento, LEAVE blk_pagamento.
                END. 
            END.

            RUN getRecord IN h-boes138 (OUTPUT TABLE tt-pagamento).

            FIND FIRST tt-pagamento.

            ASSIGN msg0254R1.CodigoSolicitacaoInterna = tt-pagamento.nr-pagamento.
        END.
        /*Alteraá∆o*/
        ELSE DO:
            ASSIGN msg0254R1.CodigoSolicitacaoInterna = msg0254.CodigoSolicitacaoInterna.

            RUN emptyRowErrors IN h-boes138.
            RUN goToKey        IN h-boes138 (INPUT msg0254.CodigoSolicitacaoInterna).
    
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
                RUN pi-erro (INPUT "N∆o encontrado a SIP informada").       
            END.
        END.
    END.

    IF CAN-FIND (tt-erro) THEN
        RETURN "NOK".

    FOR EACH HistoricoSolicitacaoInterna:
        RUN pi-gera-historico (INPUT tt-pagamento.nr-pagamento,
                               INPUT HistoricoSolicitacaoInterna.MatriculaUsuario,
                               INPUT HistoricoSolicitacaoInterna.DataHistorico,
                               INPUT HistoricoSolicitacaoInterna.HoraHistorico,
                               INPUT HistoricoSolicitacaoInterna.AcaoHistorico,
                               INPUT HistoricoSolicitacaoInterna.ObservacaoHistorico).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-popula-tt:

     ASSIGN tt-pagamento.nr-pagamento           = msg0254.CodigoSolicitacaoInterna     
            tt-pagamento.data-ci                = msg0254.DataEmissao                  
            tt-pagamento.dt-prev-fecha-cam      = IF msg0254.TipoSolicitacaoInterna <> 1 THEN msg0254.PrevFechaCambio ELSE tt-pagamento.dt-prev-fecha-cam /*Para Tipo Importaá∆o Ç calculado no momento da inclus∆o da fatura*/
            tt-pagamento.log-urgente            = msg0254.Urgente                      
            tt-pagamento.cod-emitente           = msg0254.CodigoFornecedorEMS          
            tt-pagamento.cod-estabel            = msg0254.CodigoEstabelecimento        
            tt-pagamento.valor-pag              = msg0254.ValorSolicitacaoInterna      
            tt-pagamento.cod-moeda              = msg0254.CodigoMoedaEMS               
            tt-pagamento.tipo-ci                = msg0254.TipoSolicitacaoInterna       
            tt-pagamento.ind-status-solicitacao = msg0254.StatusSolicitacaoInterna     
            tt-pagamento.cod-cond-pag           = msg0254.CodigoCondicaoPagamento      
            tt-pagamento.tipo-despesa           = msg0254.CodigoTipoDespesa            
            tt-pagamento.usuario                = msg0254.MatriculaResponsavel         
            tt-pagamento.cod-comprador          = msg0254.MatriculaComprador                                                   
            tt-pagamento.log-possui-anexos      = msg0254.PossuiAnexos
            tt-pagamento.txt-observacao         = msg0254.Observacoes                  
            tt-pagamento.log-pag-antecipado     = /*IF msg0254.TipoSolicitacaoInterna <> 1 THEN*/ msg0254.PagamentoAntecipado /*ELSE tt-pagamento.log-pag-antecipado*/ /*Para Tipo Importaá∆o Ç calculado no momento da inclus∆o da fatura*/
            tt-pagamento.historico              = msg0254.HistoricoSolicitacaoInterna
            tt-pagamento.cod-despachante        = msg0254.CodigoDespachante.


    IF  msg0254.StatusSolicitacaoInterna = 2 THEN DO:
        IF CAN-FIND (FIRST HistoricoSolicitacaoInterna 
                     WHERE HistoricoSolicitacaoInterna.AcaoHistorico = 3) THEN DO:
           IF tt-pagamento.data-aprovacao <> ? THEN
              ASSIGN tt-pagamento.log-reaprovada = YES.  
           
           ASSIGN tt-pagamento.data-aprovacao = TODAY.
        END.
        
    END.

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

       RUN pi-erro (INPUT "N∆o encontrado a SIP " + STRING(p-nr-pagamento)).
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
