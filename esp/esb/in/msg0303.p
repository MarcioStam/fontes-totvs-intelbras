CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0303.i}

{esp/pdp/espdp006fn.i}     

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0303, ListaSaldoEstoque, EstoqueProduto
   DATA-RELATION FOR conteudo, msg0303                       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0303, ListaSaldoEstoque              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaSaldoEstoque, EstoqueProduto       RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0303R1, ListaSaldoEstoqueR, EstoqueProdutoR, resultado
   DATA-RELATION FOR conteudor,  msg0303R1               RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0303R1,  ListaSaldoEstoqueR      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaSaldoEstoqueR, EstoqueProdutoR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0303R1,  resultado               RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0303R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0303 NO-ERROR.

CREATE conteudor.
CREATE msg0303R1.
CREATE resultado.

RUN pi-saldo-estoque.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.
ELSE DO:
    CREATE ListaSaldoEstoqueR.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-saldo-estoque:

    DEFINE VARIABLE qt-alocada       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-central-config AS LOGICAL     NO-UNDO.

    FOR EACH EstoqueProduto:

        ASSIGN l-central-config = CAN-FIND(FIRST item-uni-estab USE-INDEX codigo
                                           WHERE item-uni-estab.it-codigo   = EstoqueProduto.CodigoProduto
                                             AND item-uni-estab.cod-estabel = EstoqueProduto.CodigoEstabelecimento
                                             AND item-uni-estab.nr-linha    = 20).

        CREATE EstoqueProdutoR.
        ASSIGN EstoqueProdutoR.CodigoProduto         = EstoqueProduto.CodigoProduto         
               EstoqueProdutoR.CodigoDeposito        = EstoqueProduto.CodigoDeposito        
               EstoqueProdutoR.CodigoEstabelecimento = EstoqueProduto.CodigoEstabelecimento.
      
        //Chamado C2103-1220 - Corrigir valores de retorno ASSIST
        ASSIGN EstoqueProdutoR.QuantidadeSaldo = fnEstoque(EstoqueProduto.CodigoEstabelecimento, 
                                                           EstoqueProduto.CodigoProduto, 
                                                           EstoqueProduto.CodigoDeposito, 
                                                           (IF EstoqueProduto.ConsideraLocalizacao THEN EstoqueProduto.CodigoLocalizacaoMaterial ELSE "*"), 
                                                           l-central-config).               

        ASSIGN qt-alocada = 0.
       
        //Chamado A2105-0306 - Retornar Qtde Alocada ASSIST
        FOR EACH saldo-estoq NO-LOCK
           WHERE saldo-estoq.cod-estabel = EstoqueProduto.CodigoEstabelecimento    
             AND saldo-estoq.it-codigo   = EstoqueProduto.CodigoProduto            
             AND saldo-estoq.cod-depos   = EstoqueProduto.CodigoDeposito:
            ASSIGN qt-alocada = saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped.
        END.
       
        ASSIGN EstoqueProdutoR.SaldoAlocado = qt-alocada.

        /*
        FOR EACH saldo-estoq NO-LOCK
           WHERE saldo-estoq.it-codigo   = EstoqueProduto.CodigoProduto
             AND saldo-estoq.cod-depos   = EstoqueProduto.CodigoDeposito
             AND saldo-estoq.cod-estabel = EstoqueProduto.CodigoEstabelecimento:

            /* Filtra localiza‡Æo conforme chamado 139789 - Nicolas */
            IF EstoqueProduto.ConsideraLocalizacao       = TRUE
            THEN DO:
               IF saldo-estoq.cod-localiz <> EstoqueProduto.CodigoLocalizacaoMaterial THEN NEXT.
            END.

            /*
            ASSIGN EstoqueProdutoR.QuantidadeSaldo = EstoqueProdutoR.QuantidadeSaldo + (saldo-estoq.qtidade-atu  -
                                                                                       (saldo-estoq.qt-alocada   +
                                                                                        saldo-estoq.qt-aloc-prod +
                                                                                        saldo-estoq.qt-aloc-ped)).
            */
            
            // Alteracao na busca da qtde saldo estoque - conforme chamado C2101-1050 - Isac
            ASSIGN EstoqueProdutoR.QuantidadeSaldo = EstoqueProdutoR.QuantidadeSaldo + fnEstoque(EstoqueProduto.CodigoEstabelecimento, 
                                                                                                 EstoqueProduto.CodigoProduto, 
                                                                                                 EstoqueProduto.CodigoDeposito, 
                                                                                                 EstoqueProduto.CodigoLocalizacaoMaterial, 
                                                                                                 l-central-config).        

        END.*/
        
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
