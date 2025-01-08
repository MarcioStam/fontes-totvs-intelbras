CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx310   AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>328511-104-30-79-173778</NumeroOperacao>                    */
/*     <CodigoMensagem>MSG0248</CodigoMensagem>                                    */
/*     <LoginUsuario>caroline.silveira@pinho.com.br</LoginUsuario>                 */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0248>                                                                   */
/*       <NumeroEmbarque>328511</NumeroEmbarque>                                   */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*       <CodigoPontoControle>30</CodigoPontoControle>                             */
/*       <CodigoDespesa>79</CodigoDespesa>                                         */
/*       <CodigoFornecedorEMS>173778</CodigoFornecedorEMS>                         */
/*     </MSG0248>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0248.i}
DEFINE VARIABLE l-forma-preco-compra AS LOGICAL     NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0248
   DATA-RELATION FOR conteudo, msg0248 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0248R1, resultado
   DATA-RELATION FOR conteudor, msg0248R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0248R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0248R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0248 NO-ERROR.

CREATE conteudor.
CREATE msg0248R1.
CREATE resultado.

RUN pi-elimina-despesa-embarque.

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

PROCEDURE pi-elimina-despesa-embarque:

    blk_despesa-embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque
    ON STOP  UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque: 

        RUN cxbo/bocx310.p  PERSISTENT SET h-bocx310.
        RUN openQuery IN h-bocx310 (INPUT 1).

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque    = msg0248.NumeroEmbarque 
               AND embarque-imp.cod-estabel = msg0248.CodigoEstabelecimento NO-ERROR.

        IF NOT AVAIL embarque-imp THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(msg0248.NumeroEmbarque) + " estabelecimento " + STRING(msg0248.CodigoEstabelecimento)).
            RETURN "NOK".
        END.
        
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

        FIND FIRST desp-embarque NO-LOCK
             WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
               AND desp-embarque.embarque          = embarque-imp.embarque
               AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
               AND desp-embarque.cod-pto-contr     = msg0248.CodigoPontoControle
               AND desp-embarque.cod-desp          = msg0248.CodigoDespesa
               AND desp-embarque.cod-emitente-desp = msg0248.CodigoFornecedorEMS NO-ERROR.

        IF NOT AVAIL desp-embarque THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado despesa do embarque para a chave informada").
            RETURN "NOK".
        END.

        ASSIGN r-row = ROWID(desp-embarque).

        RUN setConstraint2 IN h-bocx310 (INPUT desp-embarque.cod-estabel,
                                         INPUT desp-embarque.embarque,
                                         INPUT desp-embarque.cod-itiner,
                                         INPUT desp-embarque.cod-pto-contr).

        RUN openQuery IN h-bocx310 (INPUT 2).

        /*Chama a VerificaFormaPrecoCompra s¢ para posicionar a RowObject a BO n tem gotokey...*/
        CREATE tt-desp-embarque.
        BUFFER-COPY desp-embarque TO tt-desp-embarque.
        ASSIGN tt-desp-embarque.r-rowid = r-row.

        RUN VerificaFormaPrecoCompra IN h-bocx310 (INPUT TABLE tt-desp-embarque,
                                                   OUTPUT l-forma-preco-compra).

        RUN validateDelete IN h-bocx310 (INPUT-OUTPUT r-row,
                                         OUTPUT TABLE RowErrors).    

        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:                                                                                                    
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                RETURN "NOK".
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

    
    
