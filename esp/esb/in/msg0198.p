CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>LISTAR_FABRICANTES_ITEM</NumeroOperacao>                    */
/*     <CodigoMensagem>MSG0198</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0198>                                                                   */
/*       <NumeroSerie>C5UE2604632CO</NumeroSerie>                                  */
/*     </MSG0198>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0198.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0198
   DATA-RELATION FOR conteudo, msg0198                   RELATION-FIELDS (idm, idm) NESTED.
   
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0198R1, Produto, resultado
   DATA-RELATION FOR conteudor,  msg0198R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0198R1,  Produto   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0198R1,  resultado RELATION-FIELDS (idm, idm) NESTED.

DEFINE VARIABLE d-maior-data LIKE num-serie-rast.data NO-UNDO.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0198R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0198 NO-ERROR.

CREATE conteudor.
CREATE msg0198R1.
CREATE resultado.

RUN pi-busca-serie.

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

PROCEDURE pi-busca-serie:

    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = MSG0198.NumeroSerie NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = num-serie.it-codigo NO-ERROR.

    IF AVAIL num-serie THEN DO:

        FOR EACH num-serie-rast NO-LOCK 
           WHERE num-serie-rast.n-serie = num-serie.n-serie:

            IF d-maior-data = ?
            OR d-maior-data < num-serie-rast.data THEN DO:
                ASSIGN d-maior-data = num-serie-rast.data.

                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel 
                       AND nota-fiscal.serie       = num-serie-rast.serie
                       AND nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis NO-ERROR.
            END.
        END.

        FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK
             WHERE it-nota-fisc.it-codigo = num-serie.it-codigo NO-ERROR.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        CREATE Produto.
        ASSIGN Produto.CodigoProduto         = num-serie.it-codigo
               Produto.Nome                  = IF AVAIL ITEM THEN ITEM.desc-item ELSE ?
               Produto.DataFabricacao        = DATE(num-serie.data)
               Produto.NumeroNotaFiscal      = IF AVAIL nota-fiscal  THEN nota-fiscal.nr-nota-fis   ELSE ?  
               Produto.CodigoCliente         = IF AVAIL nota-fiscal  THEN nota-fiscal.cod-emitente  ELSE ?      
               Produto.NomeRazaoSocial       = IF AVAIL emitente     THEN emitente.nome-emit        ELSE ?
               Produto.DataEmissao           = IF AVAIL nota-fiscal  THEN nota-fiscal.dt-emis-nota  ELSE ?
               Produto.NumeroPedido          = IF AVAIL nota-fiscal  THEN nota-fiscal.nr-pedcli     ELSE ?
               Produto.NumeroSerie           = IF AVAIL nota-fiscal  THEN nota-fiscal.serie         ELSE ?
               Produto.CpfCnpjCodEstrangeiro = IF AVAIL nota-fiscal  THEN nota-fiscal.cgc           ELSE ?
               Produto.PrecoUnitario         = IF AVAIL it-nota-fisc THEN dec(string(it-nota-fisc.vl-preuni,"zzzzzzzz9.9999"))    ELSE ?
               Produto.AliquotaIPI           = IF AVAIL it-nota-fisc THEN it-nota-fisc.aliquota-ipi ELSE ?
               Produto.ValorIPI              = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-ipi-it    ELSE ?
               Produto.AliquotaICMS          = IF AVAIL it-nota-fisc THEN it-nota-fisc.aliquota-icm ELSE ?
               Produto.ValorICMS             = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-icms-it   ELSE ?.
    END.
    ELSE DO:
        RUN pi-erro (INPUT "NÆo encontrada serie " + STRING(MSG0198.NumeroSerie) + "!").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
