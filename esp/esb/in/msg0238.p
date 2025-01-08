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
/*     <NumeroOperacao>ev049717-948288-948291-948295-948298-948</NumeroOperacao>   */
/*     <CodigoMensagem>MSG0238</CodigoMensagem>                                    */
/*     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0238>                                                                   */
/*       <CodigoEstabelecimento>101</CodigoEstabelecimento>                        */
/*       <CodigoPlano>1</CodigoPlano>                                              */
/*       <CodigoProduto>1010010</CodigoProduto>                                    */
/*       <DataInicialPeriodo>2015-11-13</DataInicialPeriodo>                       */
/*       <DataFinalPeriodo>2015-11-20</DataFinalPeriodo>                           */
/*     </MSG0238>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0238.i}




DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0238
   DATA-RELATION FOR conteudo, MSG0238    RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0238R1, MSG_Acao_R1, resultado
   DATA-RELATION FOR conteudor, MSG0238R1     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0238R1, MSG_Acao_R1   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0238R1, resultado     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0238R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0238 NO-ERROR.

CREATE conteudor.
CREATE MSG0238R1.
CREATE resultado.


RUN pi-busca-acao.


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


PROCEDURE pi-busca-acao:

    IF MSG0238.DataInicialPeriodo = ? THEN
        ASSIGN d-data-ini = 01/01/0001.
    ELSE
        ASSIGN d-data-ini = MSG0238.DataInicialPeriodo.

    IF MSG0238.DataFinalPeriodo = ? THEN
        ASSIGN d-data-fim = 12/31/9999.
    ELSE
        ASSIGN d-data-fim = MSG0238.DataFinalPeriodo.

    IF MSG0238.CodigoEstabelecimento = ? OR MSG0238.CodigoEstabelecimento = "" THEN
        ASSIGN c-cod-estab-ini = ""
               c-cod-estab-fim = "ZZZZZ".
    ELSE
        ASSIGN c-cod-estab-ini = MSG0238.CodigoEstabelecimento
               c-cod-estab-fim = MSG0238.CodigoEstabelecimento.

    IF MSG0238.CodigoPlano = ? OR MSG0238.CodigoPlano = 0 THEN
        ASSIGN i-cd-plano-ini = 0
               i-cd-plano-fim = 999.
    ELSE
        ASSIGN i-cd-plano-ini = MSG0238.CodigoPlano
               i-cd-plano-fim = MSG0238.CodigoPlano.

    IF MSG0238.CodigoProduto = ? OR MSG0238.CodigoProduto = "" THEN
        ASSIGN c-cd-produto-ini = ""
               c-cd-produto-fim = "ZZZZZZZZZZZZZZZZ".
    ELSE
        ASSIGN c-cd-produto-ini = MSG0238.CodigoProduto
               c-cd-produto-fim = MSG0238.CodigoProduto.



    FOR EACH int-acao-criticidade-item NO-LOCK
         where int-acao-criticidade-item.cod-estabel >= c-cod-estab-ini       
           AND int-acao-criticidade-item.cod-estabel <= c-cod-estab-fim
           and int-acao-criticidade-item.cd-plano    >= i-cd-plano-ini                
           AND int-acao-criticidade-item.cd-plano    <= i-cd-plano-fim
           and int-acao-criticidade-item.it-codigo   >= c-cd-produto-ini              
           and int-acao-criticidade-item.it-codigo   <= c-cd-produto-fim
           and int-acao-criticidade-item.data-acao   >= d-data-ini     
           and int-acao-criticidade-item.data-acao   <= d-data-fim:


           CREATE MSG_Acao_R1.
           ASSIGN MSG_Acao_R1.CodigoEstabelecimento       = int-acao-criticidade-item.cod-estabel    
                  MSG_Acao_R1.CodigoPlano                 = int-acao-criticidade-item.cd-plano       
                  MSG_Acao_R1.CodigoProduto               = int-acao-criticidade-item.it-codigo      
                  MSG_Acao_R1.DataCalculoCriticidade      = int-acao-criticidade-item.data-calculo   
                  MSG_Acao_R1.SequenciaCalculoCriticidade = int-acao-criticidade-item.sequencia      
                  MSG_Acao_R1.MatriculaUsuario            = int-acao-criticidade-item.autor-acao     
                  MSG_Acao_R1.NomeUsuario                 = int-acao-criticidade-item.nome-autor-acao
                  MSG_Acao_R1.ComentarioAcao              = int-acao-criticidade-item.comentario-acao
                  MSG_Acao_R1.DataComentario              = int-acao-criticidade-item.data-acao      
                  MSG_Acao_R1.HoraComentario              = int-acao-criticidade-item.hora-acao.
                                                            
            FIND FIRST int-criticidade-item NO-LOCK
                 WHERE int-criticidade-item.cod-estabel  = int-acao-criticidade-item.cod-estabel 
                   AND int-criticidade-item.cd-plano     = int-acao-criticidade-item.cd-plano    
                   and int-criticidade-item.it-codigo    = int-acao-criticidade-item.it-codigo   
                   and int-criticidade-item.data-calculo = int-acao-criticidade-item.data-calculo
                   and int-criticidade-item.sequencia    = int-acao-criticidade-item.sequencia NO-ERROR.
    
            IF AVAILABLE int-criticidade-item THEN
                ASSIGN MSG_Acao_R1.NivelCriticidade = int-criticidade-item.nivel-criticidade.

            FIND LAST int-falta-criticidade-item NO-LOCK
                WHERE int-falta-criticidade-item.cod-estabel  = int-acao-criticidade-item.cod-estabel        
                  and int-falta-criticidade-item.cd-plano     = int-acao-criticidade-item.cd-plano           
                  and int-falta-criticidade-item.it-codigo    = int-acao-criticidade-item.it-codigo          
                  and int-falta-criticidade-item.data-calculo = int-acao-criticidade-item.data-calculo       
                  and int-falta-criticidade-item.sequencia    = int-acao-criticidade-item.sequencia NO-ERROR.

            IF AVAILABLE int-falta-criticidade-item THEN
                ASSIGN MSG_Acao_R1.QuantidadeFalta = int-falta-criticidade-item.quantidade-falta.

    END. /* FOR EACH int-acao-criticidade-item */


    RETURN "OK":U.

END PROCEDURE.

