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
/*                     <CodigoMensagem>MSG0245</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0245>                                                               */
/*                             <CodigoFornecedorEMS>161953</CodigoFornecedorEMS>                   */
/*                         </MSG0245>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0245.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0245
   DATA-RELATION FOR conteudo, MSG0245      RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0245R1, ItensFornecedor, resultado
   DATA-RELATION FOR conteudor, MSG0245R1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0245R1, ItensFornecedor RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0245R1, resultado       RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0245R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0245 NO-ERROR.

CREATE conteudor.
CREATE MSG0245R1.
CREATE resultado.

RUN busca-itens-fornecedor.

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

PROCEDURE busca-itens-fornecedor:

     FIND FIRST emitente NO-LOCK
          WHERE emitente.cod-emitente = msg0245.CodigoFornecedorEMS NO-ERROR.

     IF NOT AVAIL emitente THEN
         RUN pi-erro (INPUT "Emitente: " + string(msg0245.CodigoFornecedorEMS) + " nÆo cadastrado.").

     ASSIGN MSG0245R1.CodigoFornecedorEMS = emitente.cod-emitente.

     blk-leitura:
     FOR EACH  item-fornec-estab NO-LOCK 
         WHERE item-fornec-estab.cod-emitente = emitente.cod-emitente
           AND item-fornec-estab.ativo        = YES   
           AND item-fornec-estab.perc-compra  > 0,
         FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = item-fornec-estab.it-codigo:

         /*Filtro part number*/
         IF msg0245.PartNumberItemFabricante <> ? and
            msg0245.PartNumberItemFabricante <> "" THEN DO:
             FIND FIRST item-fabric NO-LOCK
                  WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo 
                    AND item-fabric.cod-fabric = INT(item-fornec-estab.item-do-for)                             
                    AND item-fabric.estado     = YES /* Ativo */ 
                    AND item-fabric.it-fabric  = msg0245.PartNumberItemFabricante NO-ERROR.

             IF NOT AVAIL item-fabric THEN
                 NEXT blk-leitura.
         END.

         /*Filtro Produto*/
         IF  msg0245.CodigoProduto <> ? 
         AND msg0245.CodigoProduto <> ""
         AND msg0245.CodigoProduto <> item-fornec-estab.it-codigo THEN DO:
             NEXT blk-leitura.
         END.

         /*Cria retorno*/
         IF NOT CAN-FIND (FIRST ItensFornecedor
                          WHERE ItensFornecedor.CodigoProduto = ITEM.it-codigo) THEN DO:

             CREATE ItensFornecedor.
             ASSIGN ItensFornecedor.CodigoProduto         = ITEM.it-codigo
                    ItensFornecedor.CodigoFamiliaMaterial = ITEM.fm-codigo.
         END.
     END.

     RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
