
/********************************************************************************************/
/* Programa...: esp/esb/in/msg0014.p - REGISTRA_CLASSIFICAÄ«O CANAL                         */
/* Autor......: Gustavo Eckel                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver um cadastro ou atualizaá∆o                   */
/*              de Regiao Geografica.                                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE var iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE var oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-16'?>                          */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>8F4E5DB0-466C-4ED5-9B67-257D5620E67E</IdentidadeEmissor> */
/*     <NumeroOperacao>CONSULTA_TABELA_DE_PRECO</NumeroOperacao>                   */
/*     <CodigoMensagem>MSG0302</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0302>                                                                   */
/*       <TabelaPrecoEMS>ICON 101</TabelaPrecoEMS>                                 */
/*       <ListaItensTabelaPreco>                                                   */
/*         <ItemTabelaPreco>                                                       */
/*           <CodigoProduto>4760029</CodigoProduto>                                */
/*           <Quantidade>2.50000</Quantidade>                                      */
/*         </ItemTabelaPreco>                                                      */
/*       </ListaItensTabelaPreco>                                                  */
/*     </MSG0302>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0302.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0302, ListaItensTabelaPreco, ItemTabelaPreco
   DATA-RELATION FOR conteudo, msg0302                      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0302, ListaItensTabelaPreco         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaItensTabelaPreco, ItemTabelaPreco RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0302r, ListaItensTabelaPrecoR, ItemTabelaPrecoR, resultado
   DATA-RELATION FOR conteudor, msg0302r                      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0302r, ListaItensTabelaPrecoR        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaItensTabelaPrecoR, ItemTabelaPrecoR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0302r, resultado                      RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-regiao-geografica FOR int-regiao-geografica.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0302R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0302 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0302r.

RUN pi-tabela-preco.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem    = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                            */
/* create x-document hDoc.                                                                 */
/* hDoc:LOAD("longchar", oXML, NO).                                                        */
/* hDoc:SAVE("file","C:/temp/oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-tabela-preco:

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST tb-preco NO-LOCK
         WHERE tb-preco.nr-tabpre = msg0302.TabelaPrecoEMS NO-ERROR.

    IF NOT AVAIL tb-preco THEN DO:
        RUN pi-erro (INPUT "Tabela de preáos n∆o cadastrada.    ").
        RETURN "NOK".
    END.

    IF  AVAIL tb-preco 
    AND tb-preco.situacao <> 1 THEN DO:
        RUN pi-erro (INPUT "Tabela de preáos encontra-se inativa.").
        RETURN "NOK".
    END.
    
    IF  AVAIL tb-preco 
    AND (TODAY < tb-preco.dt-inival OR TODAY > tb-preco.dt-fimval) THEN DO:
        RUN pi-erro (INPUT "Tabela de preáos est† fora das datas de validade.").
        RETURN "NOK".
    END.

    FOR EACH ItemTabelaPreco:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ItemTabelaPreco.CodigoProduto NO-ERROR.

        FIND FIRST preco-item NO-LOCK
             WHERE preco-item.nr-tabpre    = tb-preco.nr-tabpre
               AND preco-item.it-codigo    = ItemTabelaPreco.CodigoProduto
               AND preco-item.cod-refer    = ""
               AND preco-item.cod-unid-med = ITEM.un 
               AND preco-item.dt-inival    <= TODAY
               AND preco-item.quant-min    >= ItemTabelaPreco.Quantidade NO-ERROR.

        IF NOT AVAIL preco-item THEN
            FIND FIRST preco-item NO-LOCK
                 WHERE preco-item.nr-tabpre    = tb-preco.nr-tabpre
                   AND preco-item.it-codigo    = ItemTabelaPreco.CodigoProduto
                   AND preco-item.cod-refer    = ""
                   AND preco-item.cod-unid-med = ITEM.un 
                   AND preco-item.dt-inival    <= TODAY NO-ERROR.

        IF NOT AVAIL preco-item THEN DO:
            RUN pi-erro (INPUT "Tabela de preáos est† fora das datas de validade.").
            RETURN "NOK".   
        END.

        IF preco-item.situacao <> 1 THEN DO:
            RUN pi-erro (INPUT "Item n∆o est† ativo para a tabela de preáos solicitada.").
            RETURN "NOK".   
        END.

        IF NOT CAN-FIND (FIRST ListaItensTabelaPrecoR) THEN
            CREATE ListaItensTabelaPrecoR.

        CREATE ItemTabelaPrecoR.
        ASSIGN ItemTabelaPrecoR.CodigoProduto        = preco-item.it-codigo       
               ItemTabelaPrecoR.Quantidade           = ItemTabelaPreco.Quantidade
               ItemTabelaPrecoR.ValorUnitario        = preco-item.preco-venda  
               ItemTabelaPrecoR.ValorTotalSemImposto = preco-item.preco-venda  
               ItemTabelaPrecoR.PercentualDesconto   = preco-item.desco-quant.    

    END.

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

