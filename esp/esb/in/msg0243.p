CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/*                 <MENSAGEM>                                                                      */
/*                   <CABECALHO>                                                                   */
/*                     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                     <NumeroOperacao>gu048488-2015-07-01-2015-07-31-2-fr04965</NumeroOperacao>   */
/*                     <CodigoMensagem>MSG0243</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0243>                                                               */
/*                            <NumeroPedidoCompra>298344</NumeroPedidoCompra>                      */
/*                         </MSG0243>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0243.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0243
   DATA-RELATION FOR conteudo, MSG0243           RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0243R1, resultado
   DATA-RELATION FOR conteudor, MSG0243R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0243R1, resultado RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0243R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0243 NO-ERROR.

CREATE conteudor.
CREATE MSG0243R1.
CREATE resultado.

RUN pi-elimina-processo-imp.

IF VALID-HANDLE (h-bocx140) THEN DO:
    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.
END.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-elimina-processo-imp:
    DEFINE VARIABLE r-row AS ROWID       NO-UNDO.

    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = MSG0243.NumeroPedidoCompra NO-ERROR.

    IF NOT AVAIL pedido-compr THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado pedido n£mero: " + STRING(MSG0243.NumeroPedidoCompra)).
        RETURN "NOK".
    END.

    FIND FIRST processo-imp NO-LOCK
         WHERE processo-imp.cod-estabel = pedido-compr.cod-estabel
           AND processo-imp.num-pedido  = pedido-compr.num-pedido NO-ERROR.

    IF NOT AVAIL processo-imp THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado processo de importaá∆o para o pedido n£mero: " + STRING(MSG0243.NumeroPedidoCompra)).
        RETURN "NOK".
    END.

    ASSIGN r-row = ROWID(processo-imp).

    RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
    RUN openQuery      IN  h-bocx140 (INPUT 1).

    RUN validateDelete IN h-bocx140 (INPUT-OUTPUT r-row,
                                     OUTPUT TABLE RowErrors).    
        
    IF CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK:  
            /*Retorno da BO n∆o est† trazendo o Help, feito tratamento para mostrar*/
            
            IF RowErrors.ErrorNumber = 27956 THEN
                RUN pi-erro (INPUT RowErrors.errorDescription + " Processo de Importaá∆o tem relacionamentos ativos com o Embarque, portanto n∆o dever† ser eliminado.").                
            ELSE 
                RUN pi-erro (INPUT RowErrors.errorDescription + " " + RowErrors.errorHelp).                
        END. 
        RETURN "NOK".
    END.
    
    RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
