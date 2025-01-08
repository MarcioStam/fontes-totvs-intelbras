CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.
/*                                                                                       */
/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                  */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                  */
/*                                                                                       */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                 */
/* <MENSAGEM>                                                                            */
/*   <CABECALHO>                                                                         */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor>       */
/*     <NumeroOperacao>MSG0208</NumeroOperacao>                                          */
/*     <CodigoMensagem>MSG0208</CodigoMensagem>                                          */
/*     <LoginUsuario>ToolSystems</LoginUsuario>                                          */
/*   </CABECALHO>                                                                        */
/*   <CONTEUDO>                                                                          */
/*     <MSG0218>                                                                         */
/*         <ParcelaOrdemCompra>                                                          */
/*             <NumeroOrdemCompra>483910</NumeroOrdemCompra>                             */
/*             <SequenciaParcela>1</SequenciaParcela>                                    */
/*             <DataAgendamentoInspecao>2014-12-12</DataAgendamentoInspecao>             */
/*             <DataExecucaoInspecao>2014-12-12</DataExecucaoInspecao>                   */
/*             <StatusInspecao>8</StatusInspecao>                                        */
/*             <ObservacoesInspecao>Teste observaá‰es inspecionada</ObservacoesInspecao> */
/*             <QuantidadeAgendada>4000</QuantidadeAgendada>                             */
/*             <QuantidadeInspecionada>4000</QuantidadeInspecionada>                     */
/*         </ParcelaOrdemCompra>                                                         */
/*     </MSG0218>                                                                        */
/*   </CONTEUDO>                                                                         */
/* </MENSAGEM>".                                                                         */

{esp/esb/in/msg0218.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0218, MSG_ParcelaOrdemCompra
   DATA-RELATION FOR conteudo, MSG0218           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0218, MSG_ParcelaOrdemCompra RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0218_R1, resultado
   DATA-RELATION FOR conteudor, MSG0218_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0218_R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0218R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0218 NO-ERROR.

CREATE conteudor.
CREATE MSG0218_R1.
CREATE resultado.

RUN pi-altera-inspecao.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-altera-inspecao:
    DEFINE BUFFER b-historico-inspecao FOR historico-inspecao.

    DEF VAR da-data AS DATE NO-UNDO.

    FOR EACH MSG_ParcelaOrdemCompra:

        /* validar data limite inspeá∆o*/
        FIND LAST ordens-embarque NO-LOCK
            WHERE ordens-embarque.numero-ordem = MSG_ParcelaOrdemCompra.NumeroOrdem     
              AND ordens-embarque.parcela      = MSG_ParcelaOrdemCompra.SequenciaParcela NO-ERROR.
    
        IF  AVAIL ordens-embarque THEN DO:
            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                   AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.
    
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
                   AND historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                   AND historico-embarque.embarque      = ordens-embarque.embarque NO-ERROR.
        END.
    
    
        IF  AVAIL historico-embarque THEN
            IF  historico-embarque.dt-efetiva <> ? THEN
                ASSIGN da-data = historico-embarque.dt-efetiva - 10.
            ELSE 
                ASSIGN da-data = historico-embarque.dt-ult-previsao - 10.
       ELSE 
           ASSIGN da-data = ?.
    
    
        IF  da-data <> ? THEN
            FOR EACH b-historico-inspecao NO-LOCK
                 WHERE b-historico-inspecao.numero-ordem      = MSG_ParcelaOrdemCompra.NumeroOrdem     
                   AND b-historico-inspecao.codigoagendamento = MSG_ParcelaOrdemCompra.CodigoAgendamento     
                   AND b-historico-inspecao.parcela           = MSG_ParcelaOrdemCompra.SequenciaParcela:
                 
                IF   b-historico-inspecao.data-inspec  > da-data THEN DO:
                     RUN pi-erro (INPUT "Ordem " + STRING(MSG_ParcelaOrdemCompra.NumeroOrdem) + 
                                        " - Parcela: " + STRING(MSG_ParcelaOrdemCompra.SequenciaParcela ) + " - " + 
                                        "Cod. Agendamento: " + STRING(MSG_ParcelaOrdemCompra.CodigoAgendamento) + " possui data de inspeá∆o maior que a data limite " + STRING(da-data, "99/99/9999" )
                                   ).
                     RETURN "NOK".                                                                                 
                 END.
            END.
    END.

    FOR EACH MSG_ParcelaOrdemCompra:
        FIND FIRST prazo-compra NO-LOCK
             WHERE prazo-compra.numero-ordem = MSG_ParcelaOrdemCompra.NumeroOrdem 
               AND prazo-compra.parcela      = MSG_ParcelaOrdemCompra.SequenciaParcela NO-ERROR.
    
        IF NOT AVAIL prazo-compra THEN DO:
            RUN pi-erro (INPUT "Parcela " + STRING(MSG_ParcelaOrdemCompra.SequenciaParcela ) + " n∆o encontrada para a ordem " + STRING(MSG_ParcelaOrdemCompra.NumeroOrdem)).
            RETURN "NOK".
        END.
        
        FIND LAST b-historico-inspecao NO-LOCK
            WHERE b-historico-inspecao.numero-ordem      = MSG_ParcelaOrdemCompra.NumeroOrdem     
              AND b-historico-inspecao.codigoagendamento = MSG_ParcelaOrdemCompra.CodigoAgendamento     
              AND b-historico-inspecao.parcela           = MSG_ParcelaOrdemCompra.SequenciaParcela NO-ERROR.

        CREATE historico-inspecao.
        ASSIGN historico-inspecao.numero-ordem        = MSG_ParcelaOrdemCompra.NumeroOrdem     
               historico-inspecao.codigoagendamento   = MSG_ParcelaOrdemCompra.codigoagendamento     
               historico-inspecao.parcela             = MSG_ParcelaOrdemCompra.SequenciaParcela
               historico-inspecao.sequencia           = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.sequencia + 1 ELSE 1
               historico-inspecao.data-prev-inspec    = MSG_ParcelaOrdemCompra.DataAgendamentoInspecao  
               historico-inspecao.duracao-agendamento = MSG_ParcelaOrdemCompra.DuracaoAgendamento  
               historico-inspecao.data-inspec         = MSG_ParcelaOrdemCompra.DataExecucaoInspecao     
               historico-inspecao.duracao-execucao    = MSG_ParcelaOrdemCompra.DuracaoExecucao     
               historico-inspecao.status-inspec       = MSG_ParcelaOrdemCompra.StatusInspecao           
               historico-inspecao.obs-inspec          = MSG_ParcelaOrdemCompra.ObservacoesInspecao      
               historico-inspecao.qtd-agendada        = MSG_ParcelaOrdemCompra.QuantidadeAgendada       
               historico-inspecao.qtd-inspecionada    = MSG_ParcelaOrdemCompra.QuantidadeInspecionada   
               historico-inspecao.cod-inspetor        = MSG_ParcelaOrdemCompra.CodigoInspetor
               historico-inspecao.nome-inspetor       = MSG_ParcelaOrdemCompra.NomeInspetor
               historico-inspecao.regiao-inspec       = MSG_ParcelaOrdemCompra.RegiaoInspecao
               historico-inspecao.data-transacao      = TODAY
               historico-inspecao.RegistroRemovido    = MSG_ParcelaOrdemCompra.RegistroRemovido
               historico-inspecao.MotivoAcao          = MSG_ParcelaOrdemCompra.MotivoAcao
               historico-inspecao.MatriculaUsuario    = MSG_ParcelaOrdemCompra.MatriculaUsuario
               historico-inspecao.DataHistorico       = MSG_ParcelaOrdemCompra.DataHistorico
               historico-inspecao.HoraHistorico       = MSG_ParcelaOrdemCompra.HoraHistorico.

    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

