CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version=~"1.0~" encoding=~"UTF-8~"?>                       */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>MCS-42143</NumeroOperacao>                                  */
/*     <CodigoMensagem>MSG0259</CodigoMensagem>                                    */
/*     <LoginUsuario>msi.marcelo</LoginUsuario>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0259>                                                                   */
/*       <CodigoSolicitacaoInterna>42140</CodigoSolicitacaoInterna>                */
/*     </MSG0259>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0259.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0259
   DATA-RELATION FOR conteudo, msg0259 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0259R1, resultado
   DATA-RELATION FOR conteudor, msg0259R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0259R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0259R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0259 NO-ERROR.

CREATE conteudor.
CREATE msg0259R1.
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

    blk_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_pagamento, LEAVE blk_pagamento
    ON STOP  UNDO blk_pagamento, LEAVE blk_pagamento: 

        RUN esbo/boes138.p  PERSISTENT SET h-boes138.
        RUN openQueryStatic IN h-boes138 (INPUT "Main":U).

        FIND FIRST pagamento NO-LOCK
             WHERE pagamento.nr-pagamento = msg0259.CodigoSolicitacaoInterna NO-ERROR.

        IF NOT AVAIL pagamento THEN DO:
            RUN pi-erro (INPUT "NÆo encontrada SIP: " + STRING(msg0259.CodigoSolicitacaoInterna)).
            RETURN "NOK".
        END.
        
        ASSIGN r-row = ROWID(pagamento).

        RUN validateDelete IN h-boes138 (INPUT-OUTPUT r-row,
                                         OUTPUT TABLE RowErrors).    

        IF CAN-FIND (FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL") THEN DO:
           
            FOR EACH RowErrors 
                WHERE RowErrors.ErrorType <> "INTERNAL" NO-LOCK:     
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                RETURN "NOK".
            END. 
        END.             

        /*Elimina Handles*/
        IF VALID-HANDLE(h-boes138) THEN DO:
            DELETE PROCEDURE h-boes138 NO-ERROR.
            ASSIGN h-boes138 = ?.
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

    
    
