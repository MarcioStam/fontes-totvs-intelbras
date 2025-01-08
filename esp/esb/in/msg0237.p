CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>MSG0237</NumeroOperacao>                                    */
/*     <CodigoMensagem>MSG0237</CodigoMensagem>                                    */
/*     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0237>                                                                   */
/*       <Acoes>                                                                   */
/*          <CodigoEstabelecimento>101</CodigoEstabelecimento>                     */
/*          <CodigoPlano>1</CodigoPlano>                                           */
/*          <CodigoProduto>1010015</CodigoProduto>                                 */
/*          <DataCalculoCriticidade>2015-11-13</DataCalculoCriticidade>            */
/*          <SequenciaCalculoCriticidade>1</SequenciaCalculoCriticidade>           */
/*          <MatriculaUsuario>ve888004</MatriculaUsuario>                          */
/*          <NomeUsuario>Juliano</NomeUsuario>                                     */
/*          <ComentarioAcao>Teste</ComentarioAcao>                                 */
/*       </Acoes>                                                                  */
/*     </MSG0237>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0237.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0237, MSG_Acoes
   DATA-RELATION FOR conteudo, MSG0237    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0237, MSG_Acoes   RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0237R1, resultado
   DATA-RELATION FOR conteudor, MSG0237R1     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0237R1, resultado     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0237R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0237 NO-ERROR.

CREATE conteudor.
CREATE MSG0237R1.
CREATE resultado.

RUN pi-salva-acao-hist.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-salva-acao-hist:

    DEFINE BUFFER b-int-acao-criticidade-item FOR int-acao-criticidade-item.


    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:

        FOR EACH MSG_Acoes:
            
            /* Verifica existencia do registro da criticidade do item */
            FIND FIRST int-criticidade-item NO-LOCK
                 WHERE int-criticidade-item.cod-estabel  = MSG_Acoes.CodigoEstabelecimento      
                   AND int-criticidade-item.cd-plano     = MSG_Acoes.CodigoPlano                
                   and int-criticidade-item.it-codigo    = MSG_Acoes.CodigoProduto              
                   and int-criticidade-item.data-calculo = MSG_Acoes.DataCalculoCriticidade
                   and int-criticidade-item.sequencia    = MSG_Acoes.SequenciaCalculoCriticidade NO-ERROR.
    
            /*
            LOG-MANAGER:WRITE-MESSAGE("MSG_Acoes.CodigoEstabelecimento " + string(MSG_Acoes.CodigoEstabelecimento)).
            LOG-MANAGER:WRITE-MESSAGE("MSG_Acoes.CodigoPlano " + string(MSG_Acoes.CodigoPlano)).
            LOG-MANAGER:WRITE-MESSAGE("MSG_Acoes.CodigoProduto " + string(MSG_Acoes.CodigoProduto)).
            LOG-MANAGER:WRITE-MESSAGE("MSG_Acoes.DataCalculoCriticidade " + string(MSG_Acoes.DataCalculoCriticidade)).
            LOG-MANAGER:WRITE-MESSAGE("MSG_Acoes.SequenciaCalculoCriticidade " + string(MSG_Acoes.SequenciaCalculoCriticidade)).
            LOG-MANAGER:WRITE-MESSAGE("AVAILABLE int-criticidade-item " + string(AVAILABLE int-criticidade-item)).
            */
    
            IF NOT AVAILABLE int-criticidade-item THEN DO:
                RUN pi-erro (INPUT "C†lculo n∆o realizado para esta data.").
                RETURN "NOK".
            END.
    
            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_principal, LEAVE blk_principal.
            END.

            FIND LAST b-int-acao-criticidade-item NO-LOCK
                 where b-int-acao-criticidade-item.cod-estabel  = int-criticidade-item.cod-estabel      
                   and b-int-acao-criticidade-item.cd-plano     = int-criticidade-item.cd-plano         
                   and b-int-acao-criticidade-item.it-codigo    = int-criticidade-item.it-codigo        
                   and b-int-acao-criticidade-item.data-calculo = int-criticidade-item.data-calculo     
                   and b-int-acao-criticidade-item.sequencia    = int-criticidade-item.sequencia NO-ERROR.

            CREATE int-acao-criticidade-item.
            ASSIGN int-acao-criticidade-item.cod-estabel     = int-criticidade-item.cod-estabel      
                   int-acao-criticidade-item.cd-plano        = int-criticidade-item.cd-plano         
                   int-acao-criticidade-item.it-codigo       = int-criticidade-item.it-codigo        
                   int-acao-criticidade-item.data-calculo    = int-criticidade-item.data-calculo     
                   int-acao-criticidade-item.sequencia       = int-criticidade-item.sequencia        
                   int-acao-criticidade-item.sequencia-acao  = IF NOT AVAIL b-int-acao-criticidade-item THEN 1 ELSE b-int-acao-criticidade-item.sequencia-acao + 1
                   int-acao-criticidade-item.autor-acao      = MSG_Acoes.MatriculaUsuario
                   int-acao-criticidade-item.nome-autor-acao = MSG_Acoes.NomeUsuario
                   int-acao-criticidade-item.comentario-acao = MSG_Acoes.ComentarioAcao
                   int-acao-criticidade-item.data-acao       = TODAY
                   int-acao-criticidade-item.hora-acao       = STRING(TIME, "HH:MM:SS").

        END. /* FOR EACH MSG_Acoes */
    END. /* blk_principal */

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
