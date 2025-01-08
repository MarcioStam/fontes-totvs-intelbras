  /*tt-erro*/ 
{cdp/cd0666.i}
{esp/es0018.i}

DEFINE INPUT PARAM p-usuario        LIKE usuar_mestre.cod_usuar.
DEFINE INPUT PARAM p-r-ped-venda    AS ROWID.
DEFINE INPUT PARAM p-r-ped-item     AS ROWID.
DEFINE INPUT PARAM p-cod-depos      LIKE deposito.cod-depos.
DEFINE INPUT PARAM p-localizacao    LIKE mgcad.localizacao.cod-localiz.
DEFINE INPUT PARAM p-qtd-alocar     AS DECIMAL.
DEFINE INPUT PARAM p-unid-negoc     LIKE unid-negoc.cod-unid-negoc.

DEFINE VARIABLE v-qtd-alocar-aux   AS DECIMAL.
DEFINE VARIABLE v-qtd-alocar-param AS DECIMAL.
DEFINE VARIABLE de-saldo           AS DECIMAL     NO-UNDO.

DEFINE OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE qtd-total-disponivel      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE qtd-centrais-configuradas AS DECIMAL     NO-UNDO.
DEFINE VARIABLE qtd-para-transferir       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c_cod_estab_usuar         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vQtTransferida            AS INTEGER     NO-UNDO.
DEFINE VARIABLE cReturn                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hShowMsg                  AS HANDLE      NO-UNDO.

DEFINE BUFFER bsaldo-estoq FOR saldo-estoq.
DEFINE BUFFER b-ped-item   FOR ped-item.

DEF TEMP-TABLE tt-usuarios-reserva NO-UNDO
    FIELD usuario AS CHAR.


DEF TEMP-TABLE tt-reserva-user NO-UNDO
    FIELD usuario   AS CHAR FORMAT "x(12)"
    FIELD qt-reserva AS INTEGER .

/*tt-item*/
{esapi/esapi002tt.i}
/*fnEstoque*/
{esp/pdp/espdp091fn.i}
DEFINE TEMP-TABLE tt-AtuErro LIKE tt-erro.              
{upc/pd4000k-upce.i}  
{method/dbotterr.i}


blk_princial:
DO TRANSACTION ON ERROR UNDO blk_princial, LEAVE blk_princial:

    RUN pi-aloca-estoque.

    IF RETURN-VALUE <> "OK" THEN
        UNDO blk_princial, LEAVE blk_princial.

    RETURN "OK".
END.

PROCEDURE pi-aloca-estoque:
    DEFINE VARIABLE v-nr-ord-produ     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-msg-erro         AS CHAR        NO-UNDO.
    DEFINE VARIABLE l-produziu-central AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE h-pdapi002         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-esapi018         AS HANDLE      NO-UNDO.

    RUN pi-valida-alocacao.

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    ASSIGN qtd-para-transferir = p-qtd-alocar - qtd-total-disponivel.

    /* Reporte */
    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
          AND item-uni-estab.it-codigo   = ped-item.it-codigo
          AND item-uni-estab.nr-linha    = 20:
    END.

    ASSIGN cReturn = "".

    IF AVAIL item-uni-estab THEN DO:
        /*Centrais montadas*/
        ASSIGN qtd-centrais-configuradas = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, p-cod-depos, p-localizacao, YES).
        /*N∆o possui centrais montadas o suficiente para atender, precisa gerar ordem de produá∆o*/
        IF  qtd-centrais-configuradas < p-qtd-alocar 
        /*Possui placas o suficiente para produzir o que falta*/
        AND (qtd-total-disponivel - qtd-centrais-configuradas) >= (p-qtd-alocar - qtd-centrais-configuradas) THEN DO:
            
            ASSIGN v-nr-ord-produ = 0
                   v-msg-erro     = "".

            RUN esp/pdp/espdp091a.p(INPUT ped-venda.cod-estabel,
                                    INPUT ROWID(ped-ent),
                                    INPUT p-qtd-alocar - qtd-centrais-configuradas,
                                    INPUT p-cod-depos,
                                    INPUT p-localizacao,
                                    OUTPUT v-nr-ord-produ,
                                    OUTPUT v-msg-erro).

            IF  v-msg-erro <> "" 
            AND v-msg-erro <> "OK" THEN DO:

                RUN pi-cria-erro (INPUT 17091,
                                  INPUT "ITEM " + ped-item.it-codigo + ". " + v-msg-erro).

                RETURN "NOK".
            END.
            ASSIGN l-produziu-central = YES.
        END.
    END.
    ELSE DO:
        FIND FIRST param-depos NO-LOCK 
             WHERE param-depos.cod-estabel = ped-venda.cod-estabel
               AND param-depos.cod-depos   = p-cod-depos NO-ERROR.

        /*Se Ç dep¢sito com AE e n∆o possui saldo na localizaá∆o branco, tenta transferir de outra localizaá∆o*/

        IF  AVAIL param-depos
        AND param-depos.cria-ae  = YES 
        AND p-localizacao = "" 
        AND qtd-total-disponivel < p-qtd-alocar THEN DO:
        
           ASSIGN c_cod_estab_usuar = ped-venda.cod-estabel.

           DO WHILE qtd-para-transferir > 0:
               
               RUN piTransfereMaterial.
               
               IF NOT CAN-FIND(FIRST tt-erro) THEN
                   ASSIGN qtd-para-transferir = qtd-para-transferir - vQtTransferida.
               ELSE 
                   ASSIGN qtd-para-transferir = 0.
           END.
        END.
        ELSE IF qtd-total-disponivel < p-qtd-alocar THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "ITEM " + ped-item.it-codigo + " sem saldo em estoque suficiente na localizaá∆o " + p-localizacao).
        END.
    END.
    
    IF  CAN-FIND(FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    IF cReturn = "OK" THEN DO:
        FIND FIRST int-ped-item EXCLUSIVE-LOCK 
             WHERE int-ped-item.nome-abrev      = ped-venda.nome-abrev  
               AND int-ped-item.nr-pedcli       = ped-venda.nr-pedcli        
               AND int-ped-item.nr-sequencia    = ped-item.nr-sequencia     
               AND int-ped-item.it-codigo       = ped-item.it-codigo        
               AND int-ped-item.cod-refer       = ped-item.cod-refer    NO-ERROR.

        IF NOT AVAIL int-ped-item  THEN DO:
           CREATE int-ped-item.
           ASSIGN int-ped-item.nome-abrev   = ped-venda.nome-abrev   
                  int-ped-item.nr-pedcli    = ped-venda.nr-pedcli    
                  int-ped-item.nr-sequencia = ped-item.nr-sequencia     
                  int-ped-item.it-codigo    = ped-item.it-codigo        
                  int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.
        END.

        ASSIGN int-ped-item.log-transferido = YES.

        FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
        RELEASE int-ped-item.
    END.
    
    /*  Reporte */
    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
          AND item-uni-estab.it-codigo   = ped-item.it-codigo
          AND item-uni-estab.nr-linha    = 20:
    END.

    IF AVAIL item-uni-estab THEN DO: /* Centrais */
        FIND FIRST deposito NO-LOCK 
             WHERE deposito.cod-depos = p-cod-depos NO-ERROR.

        IF  AVAIL deposito
        AND deposito.log-gera-wms  = YES THEN DO:
            
            FOR FIRST saldo-estoq NO-LOCK
                WHERE saldo-estoq.cod-estabel = ped-venda.cod-estabel
                AND   saldo-estoq.it-codigo   = ped-item.it-codigo
                AND   saldo-estoq.cod-depos   = p-cod-depos
                AND   saldo-estoq.cod-localiz = p-localizacao:
            END.

            IF  l-produziu-central THEN DO:
                FIND CURRENT saldo-estoq EXCLUSIVE-LOCK NO-ERROR.
                
                ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - (p-qtd-alocar - qtd-centrais-configuradas).

                FIND CURRENT saldo-estoq NO-LOCK NO-ERROR.
                RELEASE saldo-estoq.
            END.
            
        END.
    END.
    
    ASSIGN qtd-total-disponivel = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, p-cod-depos, p-localizacao, NO).
    
    IF qtd-total-disponivel >= p-qtd-alocar THEN DO:

        ASSIGN v-qtd-alocar-aux = p-qtd-alocar.

        blk_saldo:
        FOR EACH saldo-estoq NO-LOCK
           WHERE saldo-estoq.cod-estabel = ped-venda.cod-estabel
             AND saldo-estoq.it-codigo   = ped-item.it-codigo
             AND saldo-estoq.cod-depos   = p-cod-depos
             AND saldo-estoq.cod-localiz = p-localizacao
              BY saldo-estoq.dt-vali-lote:

            /*Se j† existe alocaá∆o deste item do pedido em outro dep¢sito bloqueia*/
            FIND FIRST ped-saldo NO-LOCK
                 WHERE ped-saldo.cod-estabel = saldo-estoq.cod-estabel
                   AND ped-saldo.nome-abrev  = ped-ent.nome-abrev     
                   AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli      
                   AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia   
                   AND ped-saldo.it-codigo   = ped-ent.it-codigo      
                   AND ped-saldo.cod-refer   = ped-ent.cod-refer      
                   AND ped-saldo.nr-entrega  = ped-ent.nr-entrega
                   AND ped-saldo.cod-depos  <> p-cod-depos NO-ERROR.
    
            IF AVAIL ped-saldo THEN DO:
                RUN pi-cria-erro (INPUT 17091,
                                  INPUT "J† existe alocaá∆o do item " + ped-ent.it-codigo + " para o dep¢sito " + ped-saldo.cod-depos + "~~" + "N∆o Ç poss°vel alocar no dep¢sito " + p-cod-depos).
                RETURN "NOK".
            END.
            
            ASSIGN de-saldo = saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod.

            IF de-saldo >= v-qtd-alocar-aux THEN
                ASSIGN v-qtd-alocar-param = v-qtd-alocar-aux
                       v-qtd-alocar-aux   = 0.
            ELSE 
                ASSIGN v-qtd-alocar-param = de-saldo
                       v-qtd-alocar-aux   = v-qtd-alocar-aux - de-saldo.

            RUN pdp/pdapi002.p PERSISTENT SET h-pdapi002.
            RUN pi-aloca-fisica-man in h-pdapi002 (INPUT ROWID(ped-ent),
                                                   INPUT-OUTPUT v-qtd-alocar-param, 
                                                   INPUT ROWID(saldo-estoq)).

            IF RETURN-VALUE = "NOK" THEN DO:
                RUN pi-cria-erro (INPUT 17091,
                                  INPUT "ITEM " + ped-item.it-codigo + ". N∆o foi possivel efetuar a alocaá∆o f°sica do material!").
    
                RUN pi-retorna-erro IN h-pdapi002(OUTPUT TABLE tt-erro).
    
                DELETE PROCEDURE h-pdapi002.
                ASSIGN h-pdapi002 = ?.
                
                RETURN "NOK".
            END.
    
            DELETE PROCEDURE h-pdapi002.
            ASSIGN h-pdapi002 = ?.

            IF v-qtd-alocar-aux = 0 THEN
                LEAVE blk_saldo.
        END.
    END.
    ELSE DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Transferància/Reporte n∆o efetuada!~~N∆o h† saldo suficiente no dep¢sito " + p-cod-depos + " para atender a alocaá∆o!").

        RETURN "NOK".
    END.

    IF CAN-FIND(FIRST int-ped-item-astec
                WHERE int-ped-item-astec.nome-abrev   = ped-item.nome-abrev
                  AND int-ped-item-astec.nr-pedcli    = ped-item.nr-pedcli
                  AND int-ped-item-astec.nr-sequencia = ped-item.nr-sequencia
                  AND int-ped-item-astec.it-codigo    = ped-item.it-codigo) THEN DO:

        
        EMPTY TEMP-TABLE RowErrors.
     
        IF  NOT VALID-HANDLE(h-esapi018)                  
        OR  h-esapi018:TYPE      <> "PROCEDURE":U         
        OR (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  
        AND h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
             RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN DO:
            RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ped-item.nome-abrev,
                                                           INPUT ped-item.nr-pedcli,
                                                           INPUT ped-item.nr-sequencia,
                                                           INPUT ped-item.it-codigo,
                                                           INPUT 1,
                                                           INPUT p-qtd-alocar).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
            END.
            ELSE DO:
                FIND FIRST b-ped-item NO-LOCK
                     WHERE b-ped-item.nome-abrev   = ped-item.nome-abrev   
                       AND b-ped-item.nr-pedcli    = ped-item.nr-pedcli    
                       AND b-ped-item.nr-sequencia = ped-item.nr-sequencia
                       AND b-ped-item.it-codigo    = ped-item.it-codigo
                       AND b-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.

                IF AVAIL b-ped-item THEN DO:

                    FOR EACH int-ped-item-astec EXCLUSIVE-LOCK
                       WHERE int-ped-item-astec.nome-abrev   = b-ped-item.nome-abrev
                         AND int-ped-item-astec.nr-pedcli    = b-ped-item.nr-pedcli
                         AND int-ped-item-astec.nr-sequencia = b-ped-item.nr-sequencia
                         AND int-ped-item-astec.it-codigo    = b-ped-item.it-codigo:

                        IF b-ped-item.qt-log-aloca <> 0 THEN
                            ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                        IF b-ped-item.qt-alocada   <> 0 THEN
                            ASSIGN int-ped-item-astec.qt-alocada = int-ped-item-astec.qt-pedida.

                        IF  b-ped-item.qt-log-aloca = 0 
                        AND b-ped-item.qt-alocada   = 0 THEN
                            ASSIGN int-ped-item-astec.qt-alocada = 0.

                    END. 
                END. 
            END.
        END.

        IF VALID-HANDLE(h-esapi018) THEN
            RUN destroy IN h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN
            DELETE PROCEDURE h-esapi018.

        ASSIGN h-esapi018 = ?.

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                RUN pi-cria-erro (INPUT RowErrors.ErrorNumber,
                                  INPUT RowErrors.ErrorDescription).
            END.

            RETURN "NOK".
        END.
    END.
    
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-valida-alocacao:
    DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-usuar-reservas    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-help-reservas     AS CHARACTER FORMAT "x(300)"   NO-UNDO.
    DEFINE VARIABLE l-wms-estab-ativo   AS LOGICAL NO-UNDO.

    FIND FIRST ped-venda NO-LOCK
         WHERE ROWID(ped-venda) = p-r-ped-venda NO-ERROR.

    FIND FIRST ped-item OF ped-venda NO-LOCK
         WHERE ROWID(ped-item) = p-r-ped-item NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

    EMPTY TEMP-TABLE tt-prog-ponto.
    EMPTY TEMP-TABLE tt-usuarios-reserva.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-usuarios-reserva.
            ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
        END.
    END.

    /*Popula vari†avel para nao precisar chamar a funcao muitas vezes */
    ASSIGN qtd-total-disponivel = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, p-cod-depos, p-localizacao, NO).

    IF p-qtd-alocar <= 0 THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Quantidade para alocar n∆o pode ser negativa!").
    END.

    IF p-qtd-alocar > ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Quantidade para alocar n∆o pode ser maior que o saldo do pedido!").
    END.

    IF NOT AVAIL ped-venda THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "N∆o encontrado pedido!").
    END.

    IF NOT AVAIL ped-item THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "N∆o encontrado item pedido!").
    END.

    IF (p-cod-depos = "wex"
    OR  p-cod-depos = "wec")
    AND p-qtd-alocar MOD ITEM.lote-mulven <> 0 THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Quantidade a alocar " + STRING(p-qtd-alocar) + " n∆o confere com o lote m£ltiplo " + STRING(ITEM.lote-mulven)).
    END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "bodi317va",
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND ENTRY(2, conteudo-programa.conteudo, ";") = ped-venda.cod-estabel:

        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Estabelecimento bloqueado para Alocaá∆o e Faturamento").
    END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp091"
          AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia = INT(ped-venda.tp-pedido):

        IF INDEX(conteudo-programa.conteudo,p-usuario) = 0 THEN DO:

            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
        END.
    END.

    FIND FIRST permissao-alocacao NO-LOCK
         WHERE permissao-alocacao.it-codigo = ped-item.it-codigo NO-ERROR.

    IF  AVAIL permissao-alocacao 
    AND permissao-alocacao.usuario <> p-usuario THEN DO:

        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Usu†rio sem permiss∆o para alocaá∆o deste item. Este item esta bloqueado pelo usuario : " + permissao-alocacao.usuario).
        
    END.

    EMPTY TEMP-TABLE tt-reserva-user.
    FOR EACH reservas-ast
        WHERE reservas-ast.cod-depos    = p-cod-depos
        AND   reservas-ast.it-codigo    = ped-item.it-codigo
        AND   reservas-ast.cod-estabel  = ped-venda.cod-estabel 
        AND   reservas-ast.dt-reserva  <= TODAY NO-LOCK:

        IF  AVAIL int-ped-venda2
        AND int-ped-venda2.PedidoeCommerce <> "" THEN DO:
            /*Caso existam reservas mas os usu†rio reservam para VTEX*/
            IF  CAN-FIND(FIRST tt-usuarios-reserva
                         WHERE tt-usuarios-reserva.usuario = reservas-ast.cd-usuario) THEN
                NEXT.
        END.

        IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
            CREATE tt-reserva-user.
            ASSIGN tt-reserva-user.usuario    = reservas-ast.cd-usuario 
                   tt-reserva-user.qt-reserva = reservas-ast.qt-reserva
                   d-qtde-reservas-ast         = d-qtde-reservas-ast + reservas-ast.qt-reserva.
        END.
    END.

    FOR EACH tt-reserva-user:
        ASSIGN c-help-reservas = c-help-reservas +  chr(10) + "Usu†rio: " + tt-reserva-user.usuario + "  -  Quantidade: " + STRING(tt-reserva-user.qt-reserva).
    END.
    IF d-qtde-reservas-ast > 0 THEN DO:
        IF fnEstoque(ped-venda.cod-estabel,ped-item.it-codigo, p-cod-depos, "*", NO) < (d-qtde-reservas-ast + p-qtd-alocar) THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "ITEM " + ped-item.it-codigo + ". H† reservas de saldo no programa espdp080, Entrar em contato com o respons†vel pela reserva: " +  c-help-reservas).
        END. 
    END.

    FIND FIRST ped-ent NO-LOCK 
         WHERE ped-ent.nome-abrev   = ped-item.nome-abrev  
           AND ped-ent.nr-pedcli    = ped-item.nr-pedcli   
           AND ped-ent.nr-sequencia = ped-item.nr-sequencia
           AND ped-ent.it-codigo    = ped-item.it-codigo   
           AND ped-ent.cod-refer    = ped-item.cod-refer NO-ERROR.

    IF NOT AVAIL ped-ent THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "N∆o encontrado Entregas do Item Pedido").

    END.    

/*     /*estava passando aqui ap¢s a criaá∆o da trava*/                                                                                                                                                                                 */
/*     IF OPSYS <> "UNIX" THEN DO:                                                                                                                                                                                                          */
/*         FOR EACH ponto-programa NO-LOCK                                                                                                                                                                                                  */
/*            WHERE ponto-programa.nome-programa = "espdp091"                                                                                                                                                                               */
/*              AND ponto-programa.ponto         = 10,                                                                                                                                                                                      */
/*             EACH conteudo-programa NO-LOCK                                                                                                                                                                                               */
/*            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                                                                                                                           */
/*                                                                                                                                                                                                                                          */
/*             IF  ped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")                                                                                                                                                          */
/*             AND ped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:                                                                                                                                                 */
/*                                                                                                                                                                                                                                          */
/*                 IF entry(4,conteudo-programa.conteudo, ";") = "" THEN DO:                                                                                                                                                                */
/*                     RUN pi-cria-erro (INPUT 17091,                                                                                                                                                                                       */
/*                                       INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";")).                                                                  */
/*                 END.                                                                                                                                                                                                                     */
/*                 ELSE DO:                                                                                                                                                                                                                 */
/*                     IF p-unid-negoc = entry(4,conteudo-programa.conteudo, ";") THEN DO:                                                                                                                                                  */
/*                         RUN pi-cria-erro (INPUT 17091,                                                                                                                                                                                   */
/*                                           INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") + ' - Unid Neg ' +  entry(4,conteudo-programa.conteudo, ";")). */
/*                     END.                                                                                                                                                                                                                 */
/*                 END.                                                                                                                                                                                                                     */
/*             END.                                                                                                                                                                                                                         */
/*         END.                                                                                                                                                                                                                             */
/*     END.                                                                                                                                                                                                                                 */

    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos = p-cod-depos NO-ERROR.

    IF NOT AVAIL deposito THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Dep¢sito " + p-cod-depos + " n∆o cadastrado.")).
    END.

    IF deposito.alocado = NO THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Deposito informado n∆o permite Alocaá∆o, verifique atravÇs do programa cd0601").
    END.

    RUN esp/wmp/eswmpapi006.p( INPUT ped-venda.cod-estabel, OUTPUT l-wms-estab-ativo).
    /*
    IDBA Bruno ->> M2403-017 Trava faturamento dep¢sito EXP 
    IF  l-wms-estab-ativo
    AND p-cod-depos           = 'EXP' THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "Alocacao Bloqueada para o deposito EXP com estabelecimento " + ped-venda.cod-estabel + "!" + "~~" + "Deposito bloqueado devido a implantacao do WMS!").
        
    END.*/ 

    FOR FIRST ponto-programa                                            
        WHERE ponto-programa.nome-programa = "espdp091"                        
          AND ponto-programa.ponto = 5:

        IF NOT CAN-FIND (FIRST conteudo-programa 
                         WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
                           AND ENTRY(2,conteudo-programa.conteudo) = p-usuario
                           AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos) THEN DO:

            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Usu†rio " + p-usuario + " sem permiss∆o para alocar no dep¢sito " +  p-cod-depos).
            
        END.
    END.

    IF p-localizacao <> "" THEN DO:
        FIND FIRST mgcad.localizacao NO-LOCK
             WHERE localizacao.cod-estabel = ped-venda.cod-estabel
               AND localizacao.cod-depos   = p-cod-depos
               AND localizacao.cod-localiz = p-localizacao NO-ERROR.
      
        IF NOT AVAIL localizacao THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Localizaá∆o n∆o encontrada!" + "~~" + "N∆o encontrada localizaá∆o " + p-localizacao + " para o dep¢sito " + p-cod-depos).
        END.

        IF p-cod-depos = "EXP" 
        OR p-cod-depos = "WEX"
        OR p-cod-depos = "WEC" THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "N∆o Ç permitido alocar em dep¢sito de expediá∆o com localizaá∆o diferente de branco!").
        END.
    END.

    FIND FIRST int-ped-venda NO-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    IF AVAILABLE int-ped-venda THEN DO:
        IF  SUBSTRING(int-ped-venda.char-1, 11, 1)  = "S":U 
        AND p-cod-depos <> "tnf":U THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Pedidos de troca de nota s¢ podem ser alocados no dep¢sito TNF.").
        END.
        IF  SUBSTRING(int-ped-venda.char-1, 11, 1) <> "S":U 
        AND p-cod-depos  = "tnf":U THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "O dep¢sito TNF s¢ pode ser usado para pedidos de troca de notas.").
        END.
    END.
    ELSE DO:
        IF p-cod-depos = "tnf":U THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "O dep¢sito TNF s¢ pode ser usado para pedidos de troca de notas.").
        END.
    END.

    /* N∆o permite reserva se o item estiver bloqueado ou reporvado por valor abaixo do minimo da tabela */
    FOR FIRST int-ped-item NO-LOCK
        WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
          AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
          AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
          AND int-ped-item.it-codigo    = ped-item.it-codigo
          AND int-ped-item.cod-refer    = ped-item.cod-refer
          AND (int-ped-item.ind-status-preco = 1 
            OR int-ped-item.ind-status-preco = 3) :

        IF  int-ped-item.ind-status-preco = 1 THEN DO:
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Item do pedido est† BLOQUEADO por valor.").
        END.

        IF  int-ped-item.ind-status-preco = 3 THEN DO:      
            RUN pi-cria-erro (INPUT 17091,
                              INPUT "Item do pedido est† REPROVADO por valor.").
        END.
    END. 

    IF  p-qtd-alocar <> ped-item.qt-pedida 
    AND ped-item.tipo-atend = 1 THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "N∆o foi poss°vel efetuar a reserva!~~Item do Pedido n∆o permite alocaá∆o parcial!").
    END.

    IF ped-item.qt-log-aloca > (ped-item.qt-pedida - ped-item.qt-atendida) THEN DO:
        RUN pi-cria-erro (INPUT 17091,
                          INPUT "N∆o foi poss°vel efetuar a reserva!~~A quatidade a alocar excede o saldo do pedido!").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-erro:
    DEFINE INPUT PARAM p-cd-erro  LIKE tt-erro.cd-erro.
    DEFINE INPUT PARAM p-mensagem LIKE tt-erro.mensagem.

    CREATE tt-erro.
    ASSIGN tt-erro.cd-erro  = p-cd-erro
           tt-erro.mensagem = p-mensagem.
        
    RETURN "OK".
END PROCEDURE.
