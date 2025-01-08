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
/*                     <CodigoMensagem>msg0240</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <msg0240>                                                               */
/*                             <CodigoItinerario>1</CodigoItinerario>                              */
/*                         </msg0240>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0240.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0240
   DATA-RELATION FOR conteudo, msg0240      RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0240R1, ItinerarioR1, PontoControleItinerario, resultado
   DATA-RELATION FOR conteudor, msg0240R1                  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0240R1, ItinerarioR1               RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ItinerarioR1, PontoControleItinerario RELATION-FIELDS (CodigoItinerario, CodigoItinerario) NESTED
   DATA-RELATION FOR msg0240R1, resultado                  RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0240R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0240 NO-ERROR.

CREATE conteudor.
CREATE msg0240R1.
CREATE resultado.

RUN detalhar-itinerario.

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

PROCEDURE detalhar-itinerario:

    RUN esp/es0018p.p (INPUT "CD2567", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).  

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = msg0240.CodigoItinerario NO-ERROR.

    IF NOT AVAIL itinerario THEN DO:
        RUN pi-erro (INPUT "Itiner†rio: " + STRING(msg0240.CodigoItinerario) + " n∆o cadastrado!").
        RETURN "NOK".
    END.

    CREATE ItinerarioR1.
    ASSIGN ItinerarioR1.CodigoItinerario          = itinerario.cod-itiner                            
           ItinerarioR1.DescricaoItinerario       = itinerario.descricao                             
           ItinerarioR1.Distancia                 = itinerario.distancia                             
           ItinerarioR1.DiasTrajeto               = itinerario.nr-dias                               
           ItinerarioR1.CodigoPontoDespacho       = itinerario.pto-despacho                          
           ItinerarioR1.CodigoPontoSolicitaLI     = itinerario.cdn-pto-solic-licenciam-import        
           ItinerarioR1.CodigoPontoEmbarque       = itinerario.pto-embarque                          
           ItinerarioR1.CodigoPontoEADI           = itinerario.pto-eadi                              
           ItinerarioR1.CodigoPontoNacionalizacao = itinerario.pto-desembarque                       
           ItinerarioR1.CodigoPontoChegada        = itinerario.pto-chegada.                    

    IF CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = string(itinerario.cod-itiner)) THEN
        ASSIGN ItinerarioR1.ItinerarioBackToBack = YES.
    ELSE 
        ASSIGN ItinerarioR1.ItinerarioBackToBack = NO.

    FOR EACH pto-itiner NO-LOCK
        WHERE pto-itiner.cod-itiner = itinerario.cod-itiner:

        FIND FIRST pto-contr NO-LOCK
             WHERE pto-contr.cod-pto-contr = pto-itiner.cod-pto-contr NO-ERROR.

        CREATE PontoControleItinerario.
        ASSIGN PontoControleItinerario.CodigoItinerario       = itinerario.cod-itiner 
               PontoControleItinerario.CodigoPontoControle    = pto-itiner.cod-pto-contr   
               PontoControleItinerario.SequenciaPontoControle = pto-itiner.sequencia       
               PontoControleItinerario.DescricaoPontoControle = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
               PontoControleItinerario.Distancia              = pto-itiner.distancia       
               PontoControleItinerario.DiasTrajeto            = pto-itiner.nr-dias.        

    END.

    RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
