CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO. */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO. */

/* ASSIGN iXml = "<?xml version='1.0' encoding='ISO-8859-1' ?>                         */
/* <MENSAGEM xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>                    */
/*     <CABECALHO>                                                                     */
/*         <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor> */
/*         <NumeroOperacao>MSG_ListarEstruturaItem</NumeroOperacao>                    */
/*         <CodigoMensagem>MSG_ListarEstruturaItem</CodigoMensagem>                    */
/*         <LoginUsuario />                                                            */
/*     </CABECALHO>                                                                    */
/*     <CONTEUDO>                                                                       */
/*         <MSG_ListarEstruturaItem>                                                   */
/*             <Item>                                                                  */
/*                 <CodigoProduto>4000026</CodigoProduto>                              */
/*             </Item>                                                                 */
/*             <Item>                                                                  */
/*                 <CodigoProduto>4560009</CodigoProduto>                              */
/*                 <CodigoEstabelecimento>105</CodigoEstabelecimento>                  */
/*             </Item>                                                                 */
/*         </MSG_ListarEstruturaItem>                                                  */
/*     </CONTEUDO>                                                                     */
/* </MENSAGEM>".                                                                       */


{esp/esb/in/msg0221.i}

DEFINE BUFFER b-tt-estrutura FOR tt-estrutura.

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, MSG0221, PesquisaEstrutura
   DATA-RELATION FOR conteudo, MSG0221      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0221, PesquisaEstrutura RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0221R1, EstruturaItem_R, SparePart, Acessorio, Componente, Resultado
   DATA-RELATION FOR conteudor, MSG0221R1        RELATION-FIELDS (idm, idm)                     NESTED
   DATA-RELATION FOR MSG0221R1, EstruturaItem_R  RELATION-FIELDS (idm, idm)                     NESTED
   DATA-RELATION FOR EstruturaItem_R, SparePart  RELATION-FIELDS (CodigoProduto, CodigoProduto) NESTED
   DATA-RELATION FOR EstruturaItem_R, Acessorio  RELATION-FIELDS (CodigoProduto, CodigoProduto) NESTED
   DATA-RELATION FOR EstruturaItem_R, Componente RELATION-FIELDS (CodigoProduto, CodigoProduto) NESTED
   DATA-RELATION FOR MSG0221R1, resultado        RELATION-FIELDS (idm, idm)                     NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0221R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0221 NO-ERROR.

CREATE conteudor.
CREATE MSG0221R1.
CREATE Resultado.

RUN pi-gera-estrutura.

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

PROCEDURE pi-gera-estrutura:

    FOR EACH PesquisaEstrutura:

        IF NOT CAN-FIND (FIRST EstruturaItem_R
                         WHERE EstruturaItem_R.CodigoProduto = it-altern.it-codigo) THEN DO:

            CREATE EstruturaItem_R.
            ASSIGN EstruturaItem_R.CodigoProduto         = PesquisaEstrutura.CodigoProduto
                   EstruturaItem_R.CodigoEstabelecimento = IF  PesquisaEstrutura.CodigoEstabelecimento <> "" 
                                                           AND PesquisaEstrutura.CodigoEstabelecimento <> "0" THEN PesquisaEstrutura.CodigoEstabelecimento 
                                                           ELSE ?.

        END.

        FOR EACH it-altern NO-LOCK
            WHERE it-altern.it-codigo = PesquisaEstrutura.CodigoProduto:
            
            IF it-altern.it-altern BEGINS "222" THEN DO:

                FOR EACH estrutura NO-LOCK
                    WHERE estrutura.it-codigo = it-altern.it-altern:

                    /*SparePart*/
                    IF estrutura.es-codigo BEGINS "188" THEN DO:
                        CREATE SparePart.
                        ASSIGN SparePart.CodigoProduto   = it-altern.it-codigo
                               SparePart.CodigoSparePart = estrutura.es-codigo.
                    END.

                    /*Acessorio*/
                    ELSE IF estrutura.es-codigo BEGINS "4"  THEN DO:
                        CREATE Acessorio.
                        ASSIGN Acessorio.CodigoProduto   = it-altern.it-codigo
                               Acessorio.CodigoAcessorio = estrutura.es-codigo.
                    END.

                    /*Componente*/
                    ELSE IF estrutura.es-codigo BEGINS "3"  THEN DO:
                        CREATE Componente.
                        ASSIGN Componente.CodigoProduto    = EstruturaItem_R.CodigoProduto
                               Componente.CodigoComponente = estrutura.es-codigo.
                    END.
                END.
            END.
        END.

        EMPTY TEMP-TABLE tt-estrutura.
        RUN pi-carrega-estrutura (INPUT PesquisaEstrutura.CodigoProduto).
        
        FOR EACH tt-estrutura BY tt-estrutura.es-codigo:
    
            FIND item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = tt-estrutura.es-codigo
                  AND item-uni-estab.cod-estabel = PesquisaEstrutura.CodigoEstabelecimento NO-ERROR.
    
            IF  AVAIL item-uni-estab 
                  AND item-uni-estab.tp-desp-padrao = 2 /* Importa‡Æo */
            AND NOT CAN-FIND (FIRST b-tt-estrutura /*Ultimo n¡vel*/
                              WHERE b-tt-estrutura.it-codigo = tt-estrutura.es-codigo) THEN DO:

                IF NOT CAN-FIND (FIRST Componente
                                 WHERE Componente.CodigoProduto    = EstruturaItem_R.CodigoProduto
                                   AND Componente.CodigoComponente = tt-estrutura.es-codigo) THEN DO:

                    CREATE Componente.
                    ASSIGN Componente.CodigoProduto    = EstruturaItem_R.CodigoProduto
                           Componente.CodigoComponente = tt-estrutura.es-codigo.
                END.
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-carrega-estrutura:
    DEF INPUT PARAM p-item-pai  LIKE estrutura.it-codigo NO-UNDO.

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    FOR EACH estrutura NO-LOCK
       WHERE estrutura.it-codigo    = p-item-pai
         AND estrutura.data-inicio <= TODAY
         AND estrutura.data-termino > TODAY:

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.
        
        IF NOT AVAIL ITEM THEN 
            NEXT.

        FIND FIRST tt-estrutura
             WHERE tt-estrutura.it-codigo = estrutura.it-codigo
               AND tt-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

        IF NOT AVAIL tt-estrutura THEN DO:
            CREATE tt-estrutura.
            ASSIGN tt-estrutura.it-codigo = estrutura.it-codigo
                   tt-estrutura.es-codigo = estrutura.es-codigo
                   i-seq                  = i-seq + 10
                   tt-estrutura.sequencia = i-seq.
        END.
        
        RUN pi-carrega-estrutura (INPUT estrutura.es-codigo).
    END.

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
