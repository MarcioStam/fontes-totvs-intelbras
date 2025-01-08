CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx310   AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                               */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                               */
/*                                                                                                    */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                              */
/*                <MENSAGEM>                                                                          */
/*                    <CABECALHO>                                                                     */
/*                        <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                        <NumeroOperacao>260953-ga046926</NumeroOperacao>                            */
/*                        <CodigoMensagem>MSG0226</CodigoMensagem>                                    */
/*                        <LoginUsuario>gi041250</LoginUsuario>                                       */
/*                    </CABECALHO>                                                                    */
/*                    <CONTEUDO>                                                                      */
/*                       <MSG0220>                                                                    */
/*                           <Despesa>                                                                */
/*                               <NumeroEmbarque>100048</NumeroEmbarque>                              */
/*                               <CodigoEstabelecimento>101</CodigoEstabelecimento>                   */
/*                               <CodigoDespesa>1</CodigoDespesa>                                     */
/*                               <CodigoPontoControle>44</CodigoPontoControle>                        */
/*                               <CodigoFornecedorEMS>5216</CodigoFornecedorEMS>                      */
/*                               <CodigoCondicaoPagamento>1</CodigoCondicaoPagamento>                 */
/*                               <CodigoMoedaEMS>0</CodigoMoedaEMS>                                   */
/*                               <ValorDespesa>232</ValorDespesa>                                     */
/*                           </Despesa>                                                               */
/*                       </MSG0220>                                                                   */
/*                    </CONTEUDO>                                                                     */
/*                </MENSAGEM>".                                                                       */

{esp/esb/in/msg0220.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0220, Despesa
   DATA-RELATION FOR conteudo, MSG0220 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0220, Despesa  RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0220R1, resultado
   DATA-RELATION FOR conteudor, MSG0220R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0220R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0220R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0220 NO-ERROR.

CREATE conteudor.
CREATE MSG0220R1.
CREATE resultado.

RUN pi-gera-despesa-embarque.

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

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE pi-gera-despesa-embarque:

    blk_despesa-embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque
    ON STOP  UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque: 

        RUN cxbo/bocx310.p  PERSISTENT SET h-bocx310.
        RUN openQuery IN h-bocx310 (INPUT 1).
        
        FOR FIRST Despesa:

            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = Despesa.CodigoEstabelecimento NO-ERROR.

            IF NOT AVAIL estabelec THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado estabelecimento: " + STRING(Despesa.CodigoEstabelecimento)).
                RETURN "NOK".
            END.

            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.embarque    = Despesa.NumeroEmbarque 
                   AND embarque-imp.cod-estabel = Despesa.CodigoEstabelecimento NO-ERROR.

            IF NOT AVAIL embarque-imp THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(Despesa.NumeroEmbarque) + " estabelecimento " + STRING(Despesa.CodigoEstabelecimento)).
                RETURN "NOK".
            END.

            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = Despesa.CodigoPontoControle NO-ERROR.

            IF NOT AVAIL pto-contr THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado ponto de controle: " + STRING(Despesa.CodigoPontoControle)).
                RETURN "NOK".
            END.

            IF NOT CAN-FIND (FIRST historico-embarque OF embarque-imp
                             WHERE historico-embarque.cod-pto-contr = Despesa.CodigoPontoControle) THEN DO:

                RUN pi-erro (INPUT "NÆo encontrado ponto de controle: " + STRING(Despesa.CodigoPontoControle) + " no emabrque informado.").
                RETURN "NOK".
            END.

            FIND FIRST desp-imp NO-LOCK
                 WHERE desp-imp.cod-desp = Despesa.CodigoDespesa NO-ERROR.

            IF NOT AVAIL desp-imp THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado despesa de importa‡Æo: " + STRING(Despesa.CodigoDespesa)).
                RETURN "NOK".
            END.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = Despesa.CodigoFornecedorEMS NO-ERROR.

            IF NOT AVAIL emitente THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado fornecedor: " + STRING(Despesa.CodigoFornecedorEMS)).
                RETURN "NOK".
            END.

            FIND FIRST moeda NO-LOCK
                 WHERE moeda.mo-codigo = Despesa.CodigoMoedaEMS NO-ERROR.

            IF NOT AVAIL moeda THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado moeda: " + STRING(Despesa.CodigoMoedaEMS)).
                RETURN "NOK".
            END.

            FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

            FIND FIRST desp-embarque NO-LOCK
                 WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                   AND desp-embarque.embarque          = embarque-imp.embarque
                   AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
                   AND desp-embarque.cod-pto-contr     = Despesa.CodigoPontoControle
                   AND desp-embarque.cod-desp          = Despesa.CodigoDespesa
                   AND desp-embarque.cod-emitente-desp = Despesa.CodigoFornecedorEMS NO-ERROR.

            /*Cria‡Æo*/
            IF NOT AVAIL desp-embarque THEN DO:
                CREATE tt-desp-embarque.                        
                ASSIGN tt-desp-embarque.embarque          = Despesa.NumeroEmbarque         
                       tt-desp-embarque.cod-estabel       = Despesa.CodigoEstabelecimento  
                       tt-desp-embarque.cod-pto-contr     = Despesa.CodigoPontoControle    
                       tt-desp-embarque.cod-itiner        = historico-embarque.cod-itiner
                       tt-desp-embarque.cod-desp          = Despesa.CodigoDespesa          
                       tt-desp-embarque.cod-emitente-desp = Despesa.CodigoFornecedorEMS    
                       tt-desp-embarque.cod-cond-pag      = Despesa.CodigoCondicaoPagamento
                       tt-desp-embarque.mo-codigo         = Despesa.CodigoMoedaEMS         
                       tt-desp-embarque.val-desp          = Despesa.ValorDespesa
                       tt-desp-embarque.descricao         = IF AVAIL desp-imp THEN desp-imp.descricao ELSE "".          

                RUN validateCreate IN h-bocx310 (INPUT  TABLE tt-desp-embarque,
                                                 OUTPUT TABLE RowErrors,
                                                 OUTPUT r-rowid).        
        
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:                                                                                                    
                        RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                        RETURN "NOK".
                    END. 
                END.    

            END.
            /*Altera‡Æo*/
            ELSE DO:
                CREATE tt-desp-embarque.
                BUFFER-COPY desp-embarque TO tt-desp-embarque.

                ASSIGN tt-desp-embarque.cod-cond-pag      = Despesa.CodigoCondicaoPagamento
                       tt-desp-embarque.mo-codigo         = Despesa.CodigoMoedaEMS         
                       tt-desp-embarque.val-desp          = Despesa.ValorDespesa.

                RUN validateUpdate IN h-bocx310 (INPUT  TABLE tt-desp-embarque,
                                                 INPUT  ROWID(desp-embarque),
                                                 OUTPUT TABLE RowErrors). 
    
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).                
                    END. 
                    RETURN "NOK".
                END.            
            END.
            
        END.    

        /*Elimina Handles*/
        IF VALID-HANDLE(h-bocx310) THEN DO:
            DELETE PROCEDURE h-bocx310 NO-ERROR.
            ASSIGN h-bocx310 = ?.
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

    
    
