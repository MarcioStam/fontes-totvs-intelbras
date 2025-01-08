CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-periodo-anterior AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodo-atual    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE da-data            AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini             AS DATETIME NO-UNDO.
DEFINE VARIABLE dt-fim             AS DATETIME NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER NO-UNDO.

{esp/esb/in/msg0296.i}

DEFINE DATASET mensagem FOR cabecalho, conteudo, MSG0296 
   DATA-RELATION FOR conteudo, MSG0296 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0296r1, Produtos, ProdutoItem, NumeroSeries, NumeroSerieItem, resultado
   DATA-RELATION FOR conteudor, MSG0296r1          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0296r1, Produtos           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Produtos, ProdutoItem         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutoItem, NumeroSeries     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR NumeroSeries, NumeroSerieItem RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0296r1, resultado          RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0296R1'
      cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0296R1.

FIND FIRST msg0296 NO-LOCK NO-ERROR.

DEF VAR c-desc-item AS CHAR NO-UNDO.
IF  AVAIL msg0296 THEN DO:

    ASSIGN dt-ini = DATETIME(MONTH (msg0296.DataInicio), 
                             DAY   (msg0296.DataInicio),
                             YEAR  (msg0296.DataInicio),
                             0,  /* hora */
                             0,  /* minutos */
                             0,  /* segundos */
                             0)  /* milisegundos */

           dt-fim = DATETIME(MONTH (msg0296.DataFinal), 
                             DAY   (msg0296.DataFinal),
                             YEAR   (msg0296.DataFinal),
                             23,  /* hora */
                             59,  /* minutos */
                             59,  /* segundos */
                             999) /* milisegundos */.

    ASSIGN i = 0.
    FOR EACH num-serie USE-INDEX data NO-LOCK
        WHERE num-serie.data >= dt-ini
          AND num-serie.data <= dt-fim
          AND num-serie.it-codigo = msg0296.CodigoProduto
          BREAK BY date(num-serie.data)
                BY num-serie.it-codigo:
                IF  i = 0 THEN DO:
                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = num-serie.it-codigo:
                        ASSIGN c-desc-item = ITEM.desc-item.
                    END.

                    CREATE Produtos.
                    CREATE ProdutoItem.
                    ASSIGN ProdutoItem.CodigoProduto = num-serie.it-codigo
                           ProdutoItem.NomeProduto   = c-desc-item.

                    CREATE NumeroSeries.
                END.
                i = i + 1.
                
                CREATE NumeroSerieItem.
                ASSIGN NumeroSerieItem.NumeroSerieProduto = num-serie.n-serie
                       NumeroSerieItem.DataGerado         = num-serie.data.
            
     END.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.
ELSE 
    ASSIGN resultado.Mensagem = "Integra‡Æo ocorrida com sucesso.".

    IF resultado.Mensagem = "" THEN
        ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.


