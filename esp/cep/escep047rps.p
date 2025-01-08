/*--------------------------------------------------------------------------------
 Programa: espdp044.p
 Autor   : SQLWorks
 Data    : 30/10/2008
--------------------------------------------------------------------------------*/
/* Programa para Atualizacao da Posicao de Estoque no E-Commerce */


define new global shared variable cXMLDirTestFiles as character no-undo.

DEFINE VARIABLE ProdutoCodigoInternoResult  AS LONGCHAR NO-UNDO.

DEFINE VARIABLE hWebService                 AS HANDLE NO-UNDO.
DEFINE VARIABLE hEstoqueSoap                AS HANDLE NO-UNDO.

DEFINE VARIABLE hRetorno                    AS HANDLE      NO-UNDO.
DEFINE VARIABLE hProdutoCodigoResult        AS HANDLE      NO-UNDO.
DEFINE VARIABLE hEstoque                    AS HANDLE      NO-UNDO.
DEFINE VARIABLE hAux                        AS HANDLE      NO-UNDO.
DEFINE VARIABLE hCampos                     AS HANDLE      NO-UNDO.
DEFINE VARIABLE hValor                      AS HANDLE      NO-UNDO.
                                           
DEFINE VARIABLE cont1                       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cont2                       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cont3                       AS INTEGER     NO-UNDO.

procedure conecta:
   define output parameter iStatus as integer   no-undo initial 0.
   define output parameter cStatus as character no-undo initial ''.
   
   if cXMLDirTestFiles <> '' then return.

   FIND FIRST param-b2c NO-LOCK NO-ERROR.

   CREATE SERVER hWebService.
   hWebService:CONNECT("-WSDL '" + param-b2c.url-webservices + "/Estoque.asmx?WSDL'") no-error.
   IF hWebService:CONNECTED() THEN DO:
       RUN EstoqueSoap SET hEstoqueSoap ON hWebService no-error.
       IF ERROR-STATUS:ERROR THEN DO:
           ASSIGN iStatus = 98
                  cStatus = "Erro ao carregar o PortType EstoqueSoap no Web Service Ikeda.".
       END.
   end.
   else do:
      assign iStatus = 99
             cStatus = "Web Service B2C Ikeda nao disponivel para conexao.".
   end.
end procedure.

procedure atualizaEstoque:
   DEFINE INPUT  PARAMETER CodigoInternoProduto        AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER QtdEstoque                  AS INTEGER     NO-UNDO.
   DEFINE INPUT  PARAMETER QtdMinima                   AS INTEGER     NO-UNDO.
   DEFINE OUTPUT PARAMETER iStatus                     AS INTEGER     NO-UNDO INITIAL 0.
   DEFINE OUTPUT PARAMETER cStatus                     AS CHARACTER   NO-UNDO INITIAL ''.

   define variable iQtde as integer no-undo initial 0.

   RUN AlterarProdutoCodigoInterno IN hEstoqueSoap(INPUT CodigoInternoProduto, INPUT QtdEstoque, INPUT QtdMinima, OUTPUT ProdutoCodigoInternoResult) no-error.
   IF ERROR-STATUS:ERROR THEN DO:
       ASSIGN iStatus = 97
              cStatus = "Erro ao carregar o Metodo AlterarProdutoCodigoInterno no Web Service Ikeda.".
   END.

   IF iStatus = 0 THEN DO:
       CREATE X-DOCUMENT hRetorno.
       CREATE X-NODEREF  hProdutoCodigoResult.
       CREATE X-NODEREF  hEstoque.
       CREATE X-NODEREF  hCampos.
       CREATE X-NODEREF  hValor.
       CREATE X-NODEREF  hAux.

       hRetorno:LOAD("LONGCHAR",ProdutoCodigoInternoResult,NO).
       hRetorno:GET-DOCUMENT-ELEMENT(hProdutoCodigoResult).

       REPEAT Cont1 = 1 TO hProdutoCodigoResult:NUM-CHILDREN:
           hProdutoCodigoResult:GET-CHILD(hAux,Cont1).

           IF hAux:NAME = "CodigoMensagem" THEN DO:
               hAux:GET-CHILD(hValor,1).
               iStatus = INT(hValor:NODE-VALUE) NO-ERROR.
           END.
           IF hAux:NAME = "Mensagem" THEN DO:
               hAux:GET-CHILD(hValor,1).
               cStatus = hValor:NODE-VALUE NO-ERROR.
           END.
/*            IF hAux:NAME = "clsEstoque" THEN DO:                                                                               */
/*                REPEAT cont2 = 1 TO hAux:NUM-CHILDREN:                                                                         */
/*                    hAux:GET-CHILD(hCampos,Cont2).                                                                             */
/*                    IF hCampos:SUBTYPE NE 'ELEMENT':U THEN NEXT.                                                               */
/*                    IF hCampos:NUM-CHILDREN < 1 THEN NEXT.                                                                     */
/*                    hCampos:GET-CHILD(hValor, 1).                                                                              */
/*                    CASE hCampos:NAME:                                                                                         */
/*                        WHEN 'LojaCodigo'                       THEN iLojaCodigo                 = INTEGER(hValor:NODE-VALUE). */
/*                        WHEN 'Qtde'                             THEN iQtde                       = INTEGER(hValor:NODE-VALUE). */
/*                        WHEN 'QtdeMinimo'                       THEN iQtdeMinimo                 = INTEGER(hValor:NODE-VALUE). */
/*                        WHEN 'ProdutoCodigo'                    THEN iProdutoCodigo              = INTEGER(hValor:NODE-VALUE). */
/*                        WHEN 'ProdutoValorCaracteristicaCodigo' THEN iProdutoValorCaracteristica = INTEGER(hValor:NODE-VALUE). */
/*                    END CASE.                                                                                                  */
/*                END.                                                                                                           */
/*            END.                                                                                                               */
       END.
   END.

   IF VALID-HANDLE(hRetorno)             THEN DELETE OBJECT hRetorno.
   IF VALID-HANDLE(hProdutoCodigoResult) THEN DELETE OBJECT hProdutoCodigoResult.
   IF VALID-HANDLE(hEstoque)             THEN DELETE OBJECT hEstoque.
   IF VALID-HANDLE(hAux)                 THEN DELETE OBJECT hAux.
   IF VALID-HANDLE(hCampos)              THEN DELETE OBJECT hCampos.
   IF VALID-HANDLE(hValor)               THEN DELETE OBJECT hValor.
end procedure.

procedure desconecta:
   IF hWebService:CONNECTED() THEN hWebService:DISCONNECT().
   IF VALID-HANDLE(hWebService)          THEN DELETE OBJECT hWebService.
end procedure.
