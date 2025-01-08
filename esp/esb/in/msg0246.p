CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx220   AS HANDLE      NO-UNDO.

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
/*                       <msg0246>                                                                    */
/*                           <NumeroEmbarque>123321</NumeroEmbarque>                                  */
/*                           <CodigoEstabelecimento>107</CodigoEstabelecimento>                       */
/*                       </msg0246>                                                                   */
/*                    </CONTEUDO>                                                                     */
/*                </MENSAGEM>".                                                                       */

{esp/esb/in/msg0246.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0246
   DATA-RELATION FOR conteudo, msg0246 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0246R1, resultado
   DATA-RELATION FOR conteudor, msg0246R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0246R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0246R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0246 NO-ERROR.

CREATE conteudor.
CREATE msg0246R1.
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

/*Elimina Handles*/
IF VALID-HANDLE(h-bocx220) THEN DO:
    DELETE PROCEDURE h-bocx220 NO-ERROR.
    ASSIGN h-bocx220 = ?.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-despesa-embarque:

    blk_despesa-embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque
    ON STOP  UNDO blk_despesa-embarque, LEAVE blk_despesa-embarque: 

        RUN cxbo/bocx220.p  PERSISTENT SET h-bocx220.
        RUN openQuery IN h-bocx220 (INPUT 1).

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque    = msg0246.NumeroEmbarque 
               AND embarque-imp.cod-estabel = msg0246.CodigoEstabelecimento NO-ERROR.

        IF NOT AVAIL embarque-imp THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(msg0246.NumeroEmbarque) + " estabelecimento " + STRING(msg0246.CodigoEstabelecimento)).
            RETURN "NOK".
        END.

        ASSIGN r-row = ROWID (embarque-imp).
        
        RUN validateDelete IN h-bocx220 (INPUT-OUTPUT r-row,
                                         OUTPUT TABLE RowErrors).    
        
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:                                                                                                    
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                RETURN "NOK".
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

    
    
