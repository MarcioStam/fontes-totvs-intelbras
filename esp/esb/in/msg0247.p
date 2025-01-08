CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx230a   AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>325791b-101-159</NumeroOperacao>                            */
/*     <CodigoMensagem>MSG0247</CodigoMensagem>                                    */
/*     <LoginUsuario>gi041250</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0247>                                                                   */
/*       <NumeroEmbarque>325791b</NumeroEmbarque>                                  */
/*       <CodigoEstabelecimento>101</CodigoEstabelecimento>                        */
/*       <CodigoPontoControle>159</CodigoPontoControle>                            */
/*     </MSG0247>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0247.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0247
   DATA-RELATION FOR conteudo, msg0247 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0247R1, PontoControle, resultado
   DATA-RELATION FOR conteudor, msg0247R1     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0247R1, PontoControle RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0247R1, resultado     RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0247R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0247 NO-ERROR.

CREATE conteudor.
CREATE msg0247R1.
CREATE resultado.

RUN pi-desvincula-ponto-controle.

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

PROCEDURE pi-desvincula-ponto-controle:
    DEFINE VARIABLE l-recebimento AS LOGICAL     NO-UNDO.

    blk_despesa-embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque
    ON STOP  UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque: 

        RUN cxbo/bocx230a.p  PERSISTENT SET h-bocx230a.
        RUN openQuery IN h-bocx230a (INPUT 1).

        /*Por default retorna o mesmo que a entrada*/
            ASSIGN MSG0247R1.NumeroEmbarque        = msg0247.NumeroEmbarque        
                   MSG0247R1.CodigoEstabelecimento = msg0247.CodigoEstabelecimento.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque    = msg0247.NumeroEmbarque 
               AND embarque-imp.cod-estabel = msg0247.CodigoEstabelecimento NO-ERROR.

        IF NOT AVAIL embarque-imp THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(msg0247.NumeroEmbarque) + " estabelecimento " + STRING(msg0247.CodigoEstabelecimento)).
            RETURN "NOK".
        END.
        
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel       = embarque-imp.cod-estabel
               AND historico-embarque.embarque          = embarque-imp.embarque
               AND historico-embarque.cod-itiner        = historico-embarque.cod-itiner
               AND historico-embarque.cod-pto-contr     = msg0247.CodigoPontoControle NO-ERROR.

        IF NOT AVAIL historico-embarque THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado historico do embarque para a chave informada").
            RETURN "NOK".
        END.

        ASSIGN r-row = ROWID(historico-embarque).

        RUN setRecalcula   IN h-bocx230a (INPUT historico-embarque.log-1).

        RUN validateDelete IN h-bocx230a (INPUT-OUTPUT r-row,
                                         OUTPUT TABLE RowErrors).    

        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:                                                                                                    
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                RETURN "NOK".
            END. 
        END.             

        /*Elimina Handles*/
        IF VALID-HANDLE(h-bocx230a) THEN DO:
            DELETE PROCEDURE h-bocx230a NO-ERROR.
            ASSIGN h-bocx230a = ?.
        END.

        /*Monta retorno*/
        ASSIGN MSG0247R1.NumeroEmbarque        = embarque-imp.embarque   
               MSG0247R1.CodigoEstabelecimento = embarque-imp.cod-estabel.

        IF NOT VALID-HANDLE(h-bocx384) THEN
            RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.

        IF NOT VALID-HANDLE(h-bocx120) THEN
            RUN cxbo/bocx120.p PERSISTENT SET h-bocx120.                             

        FOR EACH historico-embarque OF embarque-imp NO-LOCK:
            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

            ASSIGN l-integra-di = NO.
            RUN validaIntegraPtoDi IN h-bocx384 (INPUT historico-embarque.embarque,
                                                 INPUT historico-embarque.cod-estabel,
                                                 INPUT historico-embarque.cod-pto-contr,
                                                 OUTPUT l-integra-di).

            FOR FIRST pto-itiner NO-LOCK
                WHERE pto-itiner.cod-itiner    = historico-embarque.cod-itiner
                AND   pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr:

                RUN setalocais IN h-bocx120 (INPUT ROWID(pto-itiner),
                                             OUTPUT l-eadi,
                                             OUTPUT l-recebimento,
                                             OUTPUT clocal).
            END.

            CREATE PontoControle.
            ASSIGN PontoControle.CodigoPontoControle             = historico-embarque.cod-pto-contr   
                   PontoControle.SequenciaPontoControle          = historico-embarque.sequencia       
                   PontoControle.DescricaoPontoControle          = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
                   PontoControle.DataPrevOriginalPontoControle   = historico-embarque.dt-previsao     
                   PontoControle.DataUltimaPrevisaoPontoControle = historico-embarque.dt-ult-previsao 
                   PontoControle.IntegrouDI                      = l-integra-di
                   PontoControle.DataEfetivaPontoControle        = historico-embarque.dt-efetiva      
                   PontoControle.VeiculoTransporte               = historico-embarque.id-meio-transp  
                   PontoControle.ObservacoesPontoControle        = historico-embarque.observacao.    

            IF l-eadi THEN
                ASSIGN PontoControle.CodigoTipoPontoControle = 4. /* EADI */
            ELSE DO:

                run getParameterLI in h-bocx120 (output l-solicita-li).

                IF l-solicita-li THEN
                    ASSIGN PontoControle.CodigoTipoPontoControle = 2. /* Solicita»’o de LI */
                ELSE DO:

                    CASE clocal:
                        WHEN "despacho" THEN
                            ASSIGN PontoControle.CodigoTipoPontoControle = 1. /* Despacho */
                        WHEN "embarque" THEN
                            ASSIGN PontoControle.CodigoTipoPontoControle = 3. /* Embarque */
                        WHEN "desembarque" THEN
                            ASSIGN PontoControle.CodigoTipoPontoControle = 5. /* Nacionalizacao */
                        WHEN "chegada" THEN
                            ASSIGN PontoControle.CodigoTipoPontoControle = 6. /* Chegada */
                        OTHERWISE
                            ASSIGN PontoControle.CodigoTipoPontoControle = ?. 
                    END CASE.
                END.
            END.
        END.

        DELETE PROCEDURE h-bocx384.
        ASSIGN h-bocx384 = ?.
        DELETE PROCEDURE h-bocx120.
        ASSIGN h-bocx120 = ?.
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

    
    
