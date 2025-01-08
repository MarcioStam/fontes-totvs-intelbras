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
/*                     <CodigoMensagem>MSG0252</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0252>                                                               */
/*                             <CodigoProduto>1015396</CodigoProduto>                              */
/*                         </MSG0252>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0252.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0252
   DATA-RELATION FOR conteudo, MSG0252      RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0252R1, ItemFabricante, resultado
   DATA-RELATION FOR conteudor, MSG0252R1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0252R1, ItemFabricante  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0252R1, resultado       RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0252R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0252 NO-ERROR.

CREATE conteudor.
CREATE MSG0252R1.
CREATE resultado.

RUN busca-fabricantes-item.

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

PROCEDURE busca-fabricantes-item:

     FIND FIRST ITEM NO-LOCK
          WHERE ITEM.it-codigo = msg0252.CodigoProduto NO-ERROR.

     IF NOT AVAIL ITEM THEN DO:
         RUN pi-erro (INPUT "Item: " + string(msg0252.CodigoProduto) + " n∆o cadastrado.").
         RETURN "NOK".
     END.

     ASSIGN MSG0252R1.CodigoProduto = ITEM.it-codigo.

     blk-leitura:
     FOR EACH item-fabric NO-LOCK
        WHERE item-fabric.it-codigo = ITEM.it-codigo:

         FIND FIRST fabricante NO-LOCK
              WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.

         IF NOT AVAIL fabricante THEN
             NEXT.

         CREATE ItemFabricante.
         ASSIGN ItemFabricante.CodigoFabricante         = fabricante.cod-fabric
                ItemFabricante.NomeFabricante           = fabricante.nome-abrev
                ItemFabricante.PartNumberItemFabricante = item-fabric.it-fabric.
                
     END.

     RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
