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

{esp/esb/in/msg0291.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0291
   DATA-RELATION FOR conteudo, MSG0291               RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0291_R1, InspecaoAgendada, resultado
   DATA-RELATION FOR conteudor, MSG0291_R1        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0291_R1, InspecaoAgendada RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0291_R1, resultado         RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0291R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0291 NO-ERROR.

CREATE conteudor.
CREATE MSG0291_R1.
CREATE resultado.

RUN pi-retorna-inspecao.

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

PROCEDURE pi-retorna-inspecao:
    DEFINE BUFFER b-historico-inspecao FOR historico-inspecao.

    DEF VAR da-data AS DATE NO-UNDO.


    log-manager:write-message(" pi-retorna-inspecao") .

    FIND FIRST prazo-compra NO-LOCK
         WHERE prazo-compra.numero-ordem = MSG0291.NumeroOrdem 
           AND prazo-compra.parcela      = MSG0291.SequenciaParcela NO-ERROR.

    log-manager:write-message("AVAIL prazo-compra: " + STRING(AVAIL prazo-compra)) .
    IF NOT AVAIL prazo-compra THEN DO:
        RUN pi-erro (INPUT "Parcela " + STRING(MSG0291.SequenciaParcela ) + " n∆o encontrada para a ordem " + STRING(MSG0291.NumeroOrdem)).
        RETURN "NOK".
    END.
    
    IF  NOT CAN-FIND(FIRST historico-inspecao 
                WHERE historico-inspecao.numero-ordem      = MSG0291.NumeroOrdemCompra      
                  AND historico-inspecao.codigoagendamento = MSG0291.CodigoAgendamento 
                  AND historico-inspecao.parcela           = MSG0291.SequenciaParcela ) THEN DO:

        IF   NOT CAN-FIND(FIRST historico-inspecao 
                        WHERE historico-inspecao.numero-ordem      = MSG0291.NumeroOrdemCompra      
                          AND historico-inspecao.parcela           = MSG0291.SequenciaParcela ) THEN DO:

            RUN pi-erro (INPUT "N∆o encontrado hist¢rico para ordem " + STRING(MSG0291.NumeroOrdem)).
            RETURN "NOK".
        END.
    END.

    log-manager:write-message("antes for each historico-inspecao") .
        
    FOR EACH historico-inspecao NO-LOCK
        WHERE historico-inspecao.numero-ordem      = MSG0291.NumeroOrdemCompra      
          AND (IF  MSG0291.CodigoAgendamento <> 0 AND MSG0291.CodigoAgendamento <> ? THEN  
                   historico-inspecao.codigoagendamento = MSG0291.CodigoAgendamento 
               ELSE YES)
          AND historico-inspecao.parcela           = MSG0291.SequenciaParcela
        BY historico-inspecao.codigoagendamento
        BY historico-inspecao.sequencia:           

        log-manager:write-message("criando retorno ordem " + STRING(historico-inspecao.numero-ordem )) .
        CREATE  InspecaoAgendada.
        ASSIGN  InspecaoAgendada.NumeroOrdem             = historico-inspecao.numero-ordem        
                InspecaoAgendada.codigoagendamento       = historico-inspecao.codigoagendamento   
                InspecaoAgendada.SequenciaParcela        = historico-inspecao.parcela             
                InspecaoAgendada.DataAgendamentoInspecao = historico-inspecao.data-prev-inspec     
                InspecaoAgendada.DuracaoAgendamento      = historico-inspecao.duracao-agendamento 
                InspecaoAgendada.DataExecucaoInspecao    = historico-inspecao.data-inspec          
                InspecaoAgendada.DuracaoExecucao         = historico-inspecao.duracao-execucao    
                InspecaoAgendada.StatusInspecao          = historico-inspecao.status-inspec        
                InspecaoAgendada.ObservacoesInspecao     = historico-inspecao.obs-inspec           
                InspecaoAgendada.QuantidadeAgendada      = historico-inspecao.qtd-agendada         
                InspecaoAgendada.QuantidadeInspecionada  = historico-inspecao.qtd-inspecionada     
                InspecaoAgendada.CodigoInspetor          = historico-inspecao.cod-inspetor        
                InspecaoAgendada.NomeInspetor            = historico-inspecao.nome-inspetor       
                InspecaoAgendada.RegiaoInspecao          = historico-inspecao.regiao-inspec       
                InspecaoAgendada.RegistroRemovido        = historico-inspecao.RegistroRemovido        
                InspecaoAgendada.MotivoAcao              = IF historico-inspecao.MotivoAcao = 0        THEN ? ELSE historico-inspecao.MotivoAcao
                InspecaoAgendada.MatriculaUsuario        = IF historico-inspecao.MatriculaUsuario = "" THEN ? ELSE historico-inspecao.MatriculaUsuario  
                InspecaoAgendada.DataHistorico           = IF historico-inspecao.DataHistorico    = ?  THEN ? ELSE historico-inspecao.DataHistorico    
                InspecaoAgendada.HoraHistorico           = IF historico-inspecao.HoraHistorico    = "" THEN ? ELSE historico-inspecao.HoraHistorico   
                InspecaoAgendada.sequencia               = historico-inspecao.sequencia.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

