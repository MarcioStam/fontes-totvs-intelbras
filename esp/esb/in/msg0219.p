CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx230a   AS HANDLE      NO-UNDO.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                                      */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                                      */
/*                                                                                                           */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                                     */
/* <MENSAGEM>                                                                                                */
/*   <CABECALHO>                                                                                             */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor>                           */
/*     <NumeroOperacao>378522l-104-68-7-2019-02-22</NumeroOperacao>                                          */
/*     <CodigoMensagem>MSG0219</CodigoMensagem>                                                              */
/*     <LoginUsuario>an052591</LoginUsuario>                                                                 */
/*   </CABECALHO>                                                                                            */
/*   <CONTEUDO>                                                                                              */
/*     <MSG0219>                                                                                             */
/*       <PontoControle>                                                                                     */
/*         <NumeroEmbarque>378522l</NumeroEmbarque>                                                          */
/*         <CodigoEstabelecimento>104</CodigoEstabelecimento>                                                */
/*         <CodigoPontoControle>68</CodigoPontoControle>                                                     */
/*         <SequenciaPontoControle>7</SequenciaPontoControle>                                                */
/*         <DataPrevOriginalPontoControle>2019-02-22</DataPrevOriginalPontoControle>                         */
/*         <DataEfetivaPontoControle>2020-09-03</DataEfetivaPontoControle>                                   */
/*         <VeiculoTransporte>MAERSK LETICIA</VeiculoTransporte>                                             */
/*         <ObservacoesPontoControle xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' /> */
/*         <TipoEfetivacao>2</TipoEfetivacao>                                                                */
/*       </PontoControle>                                                                                    */
/*       <PontoControle>                                                                                     */
/*         <NumeroEmbarque>378522m</NumeroEmbarque>                                                          */
/*         <CodigoEstabelecimento>104</CodigoEstabelecimento>                                                */
/*         <CodigoPontoControle>68</CodigoPontoControle>                                                     */
/*         <SequenciaPontoControle>7</SequenciaPontoControle>                                                */
/*         <DataPrevOriginalPontoControle>2019-03-14</DataPrevOriginalPontoControle>                         */
/*         <DataEfetivaPontoControle>2020-09-03</DataEfetivaPontoControle>                                   */
/*         <VeiculoTransporte>MOL LONDRINA</VeiculoTransporte>                                               */
/*         <ObservacoesPontoControle xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' /> */
/*         <TipoEfetivacao>2</TipoEfetivacao>                                                                */
/*       </PontoControle>                                                                                    */
/*     </MSG0219>                                                                                            */
/*   </CONTEUDO>                                                                                             */
/* </MENSAGEM>".                                                                                             */

{esp/esb/in/msg0219.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0219, PontoControle
   DATA-RELATION FOR conteudo, MSG0219      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0219, PontoControle RELATION-FIELDS (idm, idm) NESTED.
       

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0219R1, PontoControleR, resultado
   DATA-RELATION FOR conteudor, MSG0219R1      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0219R1, PontoControleR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0219R1, resultado      RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0219R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0219 NO-ERROR.

CREATE conteudor.
CREATE MSG0219R1.
CREATE resultado.

RUN pi-ponto-controle.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

/*Elimina Handles*/
IF VALID-HANDLE(h-bocx230a) THEN DO:
    DELETE PROCEDURE h-bocx230a NO-ERROR.
    ASSIGN h-bocx230a = ?.
END.

IF VALID-HANDLE(h-bocx384) THEN DO:
    DELETE PROCEDURE h-bocx384 NO-ERROR.
    ASSIGN h-bocx384 = ?.
END.

IF VALID-HANDLE(h-bocx120) THEN DO:
    DELETE PROCEDURE h-bocx120 NO-ERROR.
    ASSIGN h-bocx120 = ?.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE pi-ponto-controle:
    DEFINE VARIABLE l-recebimento AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

    FOR EACH PontoControle:
        i-cont = i-cont + 1.
    END.

    RUN cxbo/bocx230a.p  PERSISTENT SET h-bocx230a.

    blk_ponto-controle:
    DO TRANSACTION
    ON ERROR UNDO blk_ponto-controle, LEAVE blk_ponto-controle
    ON STOP  UNDO blk_ponto-controle, LEAVE blk_ponto-controle: 
    
        FOR EACH PontoControle:
            /*RUN cxbo/bocx230a.p  PERSISTENT SET h-bocx230a.*/
            
            EMPTY TEMP-TABLE tt-historico-embarque.
            RUN openQuery IN h-bocx230a (INPUT 1).
    
            /*Por default retorna o mesmo que a entrada*/
            IF i-cont = 1 THEN
                ASSIGN MSG0219R1.NumeroEmbarque        = PontoControle.NumeroEmbarque        
                       MSG0219R1.CodigoEstabelecimento = PontoControle.CodigoEstabelecimento.
    
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = PontoControle.CodigoEstabelecimento NO-ERROR.
    
            IF NOT AVAIL estabelec THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado estabelecimento: " + STRING(PontoControle.CodigoEstabelecimento)).
                RETURN "NOK".
            END.
    
            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.embarque    = PontoControle.NumeroEmbarque
                   AND embarque-imp.cod-estabel = PontoControle.CodigoEstabelecimento NO-ERROR.
    
            IF NOT AVAIL embarque-imp THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(PontoControle.NumeroEmbarque) + " estabelecimento " + STRING(PontoControle.CodigoEstabelecimento)).
                RETURN "NOK".
            END.
    
            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = PontoControle.CodigoPontoControle NO-ERROR.
    
            IF NOT AVAIL pto-contr THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado ponto de controle: " + STRING(PontoControle.CodigoPontoControle)).
                RETURN "NOK".
            END.
    
            IF PontoControle.TipoEfetivacao = "2" THEN DO:
                FIND LAST historico-embarque NO-LOCK
                    WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                      AND historico-embarque.embarque      = embarque-imp.embarque
                      AND historico-embarque.dt-efetiva   <> ? NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST historico-embarque NO-LOCK
                     WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                       AND historico-embarque.embarque      = embarque-imp.embarque
                       AND historico-embarque.sequencia     = PontoControle.SequenciaPontoControle 
                       AND historico-embarque.cod-pto-contr = PontoControle.CodigoPontoControle NO-ERROR.
            END.
    
            FIND FIRST pto-itiner NO-LOCK
                 WHERE pto-itiner.cod-itiner    = historico-embarque.cod-itiner
                   AND pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.
    
            FIND FIRST b-historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

            IF  PontoControle.TipoEfetivacao = "2" 
            AND NOT AVAIL historico-embarque THEN DO:
                RUN pi-erro (INPUT "NÆo ‚ poss¡vel alterar a data do ultimo ponto de controle efetivado.").                                                                                                                                                                                       
                RETURN "NOK".
            END.
    
            IF NOT AVAIL b-historico-embarque  THEN DO:
                RUN pi-erro (INPUT "NÆo ‚ poss¡vel incluir pontos de controle em um embarque vazio.").                                                                                                                                                                                       
                RETURN "NOK".
            END.
    
            /*Cria‡Æo*/
            IF NOT AVAIL historico-embarque THEN DO:
                CREATE tt-historico-embarque.                        
                ASSIGN tt-historico-embarque.embarque        = PontoControle.NumeroEmbarque                    
                       tt-historico-embarque.cod-estabel     = PontoControle.CodigoEstabelecimento  
                       tt-historico-embarque.cod-itiner      = b-historico-embarque.cod-itiner  
                       tt-historico-embarque.cod-pto-contr   = PontoControle.CodigoPontoControle               
                       tt-historico-embarque.sequencia       = PontoControle.SequenciaPontoControle            
                       tt-historico-embarque.dt-previsao     = PontoControle.DataPrevOriginalPontoControle     
                       tt-historico-embarque.dt-ult-previsao = PontoControle.DataUltimaPrevisaoPontoControle    
                       tt-historico-embarque.dt-efetiva      = PontoControle.DataEfetivaPontoControle          
                       tt-historico-embarque.id-meio-transp  = PontoControle.VeiculoTransporte                 
                       tt-historico-embarque.observacao      = PontoControle.ObservacoesPontoControle
                       tt-historico-embarque.descricao       = IF AVAIL pto-contr  THEN pto-contr.descricao ELSE ""
                       tt-historico-embarque.nr-dias         = IF AVAIL pto-itiner THEN pto-itiner.nr-dias  ELSE 0
                       tt-historico-embarque.log-1           = IF AVAIL pto-contr  THEN NOT pto-contr.log-1 ELSE NO.
    
                RUN setRecalcula   IN h-bocx230a (INPUT tt-historico-embarque.log-1).
    
                RUN validateCreate IN h-bocx230a (INPUT  TABLE tt-historico-embarque,
                                                  OUTPUT TABLE RowErrors,
                                                  OUTPUT r-rowid).        
    
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:                                                                                                    
                        RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    END. 
                    RETURN "NOK".
                END.    
    
            END.
            /*Altera‡Æo*/
            ELSE DO:
                CREATE tt-historico-embarque.
                BUFFER-COPY historico-embarque TO tt-historico-embarque.
    
                IF PontoControle.TipoEfetivacao = "2" THEN DO:
                    ASSIGN tt-historico-embarque.dt-efetiva      = PontoControle.DataEfetivaPontoControle
                           tt-historico-embarque.r-rowid         = ROWID(historico-embarque).
                END.
                ELSE DO:
                    ASSIGN tt-historico-embarque.dt-efetiva      = PontoControle.DataEfetivaPontoControle          
                           tt-historico-embarque.dt-ult-previsao = IF PontoControle.DataUltimaPrevisaoPontoControle <> ? THEN PontoControle.DataUltimaPrevisaoPontoControle ELSE tt-historico-embarque.dt-ult-previsao
                           tt-historico-embarque.id-meio-transp  = PontoControle.VeiculoTransporte                 
                           tt-historico-embarque.observacao      = PontoControle.ObservacoesPontoControle
                           tt-historico-embarque.r-rowid         = ROWID(historico-embarque).
                END.
    
                RUN setRecalcula   IN h-bocx230a (INPUT tt-historico-embarque.log-1).
    
                RUN validateUpdate IN h-bocx230a (INPUT  TABLE tt-historico-embarque,
                                                  INPUT  ROWID(historico-embarque),
                                                  OUTPUT TABLE RowErrors). 
                
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).                
                    END. 
                    RETURN "NOK".
                END.            
            END.
    
            /*Monta retorno*/
            IF  i-cont = 1 THEN DO:
                ASSIGN MSG0219R1.NumeroEmbarque        = embarque-imp.embarque   
                       MSG0219R1.CodigoEstabelecimento = embarque-imp.cod-estabel.
    
                IF NOT VALID-HANDLE(h-bocx384) THEN
                    RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.
        
                IF NOT VALID-HANDLE(h-bocx120) THEN
                    RUN cxbo/bocx120.p PERSISTENT SET h-bocx120.                             
        
                FOR EACH historico-embarque OF embarque-imp NO-LOCK:
                    FIND FIRST pto-contr NO-LOCK
                         WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.
        
                    ASSIGN l-integra-di = NO.
                    RUN validaIntegraPtoDi IN h-bocx384 (INPUT  historico-embarque.embarque,
                                                         INPUT  historico-embarque.cod-estabel,
                                                         INPUT  historico-embarque.cod-pto-contr,
                                                         OUTPUT l-integra-di).

                    ASSIGN clocal = "".
        
                    FOR FIRST pto-itiner NO-LOCK
                        WHERE pto-itiner.cod-itiner    = historico-embarque.cod-itiner
                        AND   pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr:
        
                        /*
                        RUN setalocais IN h-bocx120 (INPUT ROWID(pto-itiner),
                                                     OUTPUT l-eadi,
                                                     OUTPUT l-recebimento,
                                                     OUTPUT clocal).
                        */

                        FIND FIRST itinerario NO-LOCK
                             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

                        if  itinerario.pto-despacho = pto-itiner.cod-pto-contr 
                        then assign 
                          cLocal = "Despacho". //1

                        if  itinerario.pto-embarque = pto-itiner.cod-pto-contr 
                        then assign 
                           cLocal = "Embarque". //2

                        if itinerario.pto-chegada     = pto-itiner.cod-pto-contr 
                        then assign 
                           cLocal = "Chegada". //7

                        if itinerario.pto-desembarque  = pto-itiner.cod-pto-contr 
                        then assign 
                           cLocal = "Desembarque". //5

                        if itinerario.int-1 = pto-itiner.cod-pto-contr 
                        then assign 
                           l-eadi = yes. //4

                        FIND FIRST int-itinerario NO-LOCK
                             WHERE int-itinerario.cod-itiner = historico-embarque.cod-itiner
                             NO-ERROR.
                        IF AVAIL int-itinerario
                        THEN DO:
                            IF int-itinerario.cdn-pto-liberacao = pto-itiner.cod-pto-contr            
                            then assign 
                               cLocal = "Liberacao". //8
                            IF int-itinerario.cdn-pto-instrucao = pto-itiner.cod-pto-contr            
                            then assign 
                               cLocal = "Instrucao". //9
                        END.


                    END.
        
                    CREATE PontoControleR.
                    ASSIGN PontoControleR.CodigoPontoControle             = historico-embarque.cod-pto-contr   
                           PontoControleR.SequenciaPontoControle          = historico-embarque.sequencia       
                           PontoControleR.DescricaoPontoControle          = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
                           PontoControleR.DataPrevOriginalPontoControle   = historico-embarque.dt-previsao     
                           PontoControleR.DataUltimaPrevisaoPontoControle = historico-embarque.dt-ult-previsao 
                           PontoControleR.IntegrouDI                      = l-integra-di
                           PontoControleR.DataEfetivaPontoControle        = historico-embarque.dt-efetiva      
                           PontoControleR.VeiculoTransporte               = historico-embarque.id-meio-transp  
                           PontoControleR.ObservacoesPontoControle        = historico-embarque.observacao.     
        
                    IF l-eadi THEN
                        ASSIGN PontoControleR.CodigoTipoPontoControle = 4. /* EADI */
                    ELSE DO:
        
                        run getParameterLI in h-bocx120 (output l-solicita-li).
        
                        IF l-solicita-li THEN
                            ASSIGN PontoControleR.CodigoTipoPontoControle = 2. /* Solicita»’o de LI */
                        ELSE DO:
                            CASE clocal:
                                 WHEN "despacho" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 1. /* Despacho */
                                 WHEN "embarque" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 3. /* Embarque */
                                 WHEN "desembarque" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 5. /* Nacionalizacao */
                                 WHEN "entrada" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 6. /* Ponto de Entrada */
                                 WHEN "chegada" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 7. /* Ponto de Chegada */
                                 WHEN "Liberacao" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 8. /* Ponto de Libera‡Æo */
                                 WHEN "Instrucao" THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 9. /* Ponto de Instru‡Æo */
                                 WHEN "invoice"THEN
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = 10. /* Ponto Invoice */
                                 OTHERWISE
                                      ASSIGN PontoControleR.CodigoTipoPontoControle = ?.
                            END CASE.
                        END.
                    END.
                END.
            END.
        END.
    END.
    
    IF NOT CAN-FIND (FIRST tt-erro) THEN
        RETURN "OK".
    ELSE 
        RETURN "NOK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
