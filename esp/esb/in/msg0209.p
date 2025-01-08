{method/dbotterr.i}
{cdp/cdcfgmat.i} 
{utp/ut-glob.i}
{esp/esb/in/msg0209.i}
{esp/esapi505b.i}  

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>567612/1</NumeroOperacao>                                   */
/*     <CodigoMensagem>MSG0209</CodigoMensagem>                                    */
/*     <LoginUsuario>gi041250</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0209>                                                                   */
/*       <ParcelaAlterada>                                                         */
/*         <NumeroOrdemCompra>567612</NumeroOrdemCompra>                           */
/*         <SequenciaParcela>1</SequenciaParcela>                                  */
/*         <DataParcela>2016-12-15</DataParcela>                                   */
/*         <QuantidadeParcela>30000</QuantidadeParcela>                            */
/*         <NumeroEmbarque>300063</NumeroEmbarque>                                 */
/*         <ParcelaAnalisada>true</ParcelaAnalisada>                               */
/*         <EmbarcarParcela>true</EmbarcarParcela>                                 */
/*         <SituacaoMovimentoParcela>1</SituacaoMovimentoParcela>                  */
/*       </ParcelaAlterada>                                                        */
/*     </MSG0209>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

DEFINE VARIABLE h-bocx225     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin356aa   AS HANDLE      NO-UNDO.
DEFINE VARIABLE p-mensagem    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE r-rowid       AS ROWID       NO-UNDO.
DEFINE VARIABLE l-integra-di  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-indice     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-embarque    LIKE embarque-imp.embarque.
DEFINE VARIABLE c-usuario-log LIKE usuar_mestre.cod_usuario NO-UNDO.

DEFINE BUFFER b-prazo-compra              FOR prazo-compra.
DEFINE BUFFER b-prazo-compra-aux          FOR prazo-compra.
DEFINE BUFFER b-eq-embarq-praz-compra     FOR eq-embarq-praz-compra. 
DEFINE BUFFER b-eq-embarq-praz-compra-aux FOR eq-embarq-praz-compra. 

DEF BUFFER bfx-pedido-compr FOR pedido-compr.
DEF BUFFER bfx-ordem-compra FOR ordem-compra.

DEF VAR c-old-embarque AS c NO-UNDO.
DEF VAR l-n-ped        AS l NO-UNDO.
DEF VAR l-d-ped        AS l NO-UNDO.
DEF VAR c-call         AS c NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0209, MSG_Parcela
   DATA-RELATION FOR conteudo, MSG0209    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0209, MSG_Parcela RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0209R1, ParcelaAlteradaResultado_R1, resultado
   DATA-RELATION FOR conteudor, MSG0209R1                   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0209R1, ParcelaAlteradaResultado_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0209R1, resultado                   RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0209R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0209 NO-ERROR.

CREATE conteudor.
CREATE MSG0209R1.
CREATE resultado.

blk: DO ON STOP UNDO, LEAVE TRANSACTION:

   RUN pi-gera-dados.
   
   
   IF  RETURN-VALUE <> "OK" THEN DO:
       ASSIGN resultado.sucesso    = no
              resultado.CodigoErro = 17006
              resultado.Mensagem   = "".
   
       FOR EACH tt-erro
           BREAK BY tt-erro.Mensagem:
           ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
       END.
       MESSAGE ">>> MSG0209 - STOP ".
       ASSIGN
          lgRollback = YES.
       STOP.
   END.
END.
RUN pi-output-grava-rollback.


IF VALID-HANDLE (h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

IF VALID-HANDLE (h-bocx404) THEN DO:
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
END.

IF VALID-HANDLE (h-boin356aa) THEN DO:
    DELETE PROCEDURE h-boin356aa.
    ASSIGN h-boin356aa = ?.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

PROCEDURE pi-gera-dados:
    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = cabecalho.LoginUsuario NO-ERROR.


    IF AVAIL usuar_mestre THEN
        ASSIGN c-usuario-log = usuar_mestre.cod_usuario.
    ELSE 
        ASSIGN c-usuario-log = "Integra".

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
    
        FOR EACH MSG_Parcela:
            MESSAGE ">>> MSG_Parcela.NumeroOrdemCompra       " MSG_Parcela.NumeroOrdemCompra       . 
            MESSAGE ">>> MSG_Parcela.SequenciaParcela        " MSG_Parcela.SequenciaParcela        . 
            MESSAGE ">>> MSG_Parcela.DataParcela             " MSG_Parcela.DataParcela             . 
            MESSAGE ">>> MSG_Parcela.QuantidadeParcela       " MSG_Parcela.QuantidadeParcela       . 
            MESSAGE ">>> MSG_Parcela.SequenciaParcelaOriginal" MSG_Parcela.SequenciaParcelaOriginal. 
            MESSAGE ">>> MSG_Parcela.NumeroEmbarque          " MSG_Parcela.NumeroEmbarque          . 
            MESSAGE ">>> MSG_Parcela.MotivoAlteracao         " MSG_Parcela.MotivoAlteracao         . 
            MESSAGE ">>> MSG_Parcela.ParcelaAnalisada        " MSG_Parcela.ParcelaAnalisada        . 
            MESSAGE ">>> MSG_Parcela.EmbarcarParcela         " MSG_Parcela.EmbarcarParcela         . 
            MESSAGE ">>> MSG_Parcela.SituacaoMovimentoParcela" MSG_Parcela.SituacaoMovimentoParcela. 
            MESSAGE ">>> MSG_Parcela.Observacoes             " MSG_Parcela.Observacoes             . 

            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = MSG_Parcela.NumeroOrdemCompra NO-ERROR.
    
            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "Ordem de compra " + STRING(MSG_Parcela.NumeroOrdemCompra) + " n∆o encontrada.").
                UNDO blk_principal, LEAVE blk_principal.
            END.


            MESSAGE ">>> x1".
    
            /*Cria nova parcela com base na parcela original quando vier sem a sequencia*/
            IF MSG_Parcela.SequenciaParcela = ? THEN DO:
                MESSAGE ">>> x2".
                /*Valida se enviou a parcela para copiar as informaá‰es para a nova*/
                IF NOT CAN-FIND (FIRST prazo-compra 
                                 WHERE prazo-compra.numero-ordem = MSG_Parcela.NumeroOrdemCompra
                                   AND prazo-compra.parcela      = MSG_Parcela.SequenciaParcelaOriginal) THEN DO:
    
                    RUN pi-erro (INPUT "Parcela original" + STRING(MSG_Parcela.SequenciaParcelaOriginal) + " da ordem " + STRING(MSG_Parcela.NumeroOrdemCompra) + " n∆o encontrada!").
                    UNDO blk_principal, LEAVE blk_principal.
                END.
                
                RUN cria-parcela (INPUT MSG_Parcela.NumeroOrdemCompra,       
                                  INPUT MSG_Parcela.SequenciaParcelaOriginal,   
                                  INPUT MSG_Parcela.QuantidadeParcela, 
                                  INPUT MSG_Parcela.DataParcela).      
    
                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_principal, LEAVE blk_principal.
            END.
            ELSE DO:
                MESSAGE ">>> x3".


                FIND FIRST ordens-embarque NO-LOCK
                     WHERE ordens-embarque.numero-ordem = MSG_Parcela.NumeroOrdemCompra
                       AND ordens-embarque.parcela      = MSG_Parcela.SequenciaParcela
                     NO-ERROR.
                IF AVAIL ordens-embarque
                THEN DO:
                   MESSAGE ">>> x3 MSG_Parcela.NumeroOrdemCompra " MSG_Parcela.NumeroOrdemCompra.
                   MESSAGE ">>> x3 MSG_Parcela.SequenciaParcela  " MSG_Parcela.SequenciaParcela .
                   MESSAGE ">>> x3 ordens-embarque.embarque      " ordens-embarque.embarque     .
                   ASSIGN
                      c-old-embarque = ordens-embarque.embarque.
                END.


                /*Verifica se a parcela existe*/
                IF NOT CAN-FIND (FIRST prazo-compra 
                                 WHERE prazo-compra.numero-ordem = MSG_Parcela.NumeroOrdemCompra
                                   AND prazo-compra.parcela      = MSG_Parcela.SequenciaParcela) THEN DO:
    
                    RUN pi-erro (INPUT "Parcela " + STRING(MSG_Parcela.SequenciaParcela) + " da ordem " + STRING(MSG_Parcela.NumeroOrdemCompra) + " n∆o encontrada!").
                    UNDO blk_principal, LEAVE blk_principal.
                END.     
    
                /*IF MSG_Parcela.EmbarcarParcela THEN DO:*/
                RUN desembarca-parcela (INPUT MSG_Parcela.NumeroOrdemCompra,
                                        INPUT MSG_Parcela.SequenciaParcela).      
    
                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_principal, LEAVE blk_principal.
                /*END.*/

                RUN pi-altera-parcela (INPUT MSG_Parcela.NumeroOrdemCompra,
                                       INPUT MSG_Parcela.SequenciaParcela,
                                       INPUT MSG_Parcela.DataParcela,
                                       INPUT MSG_Parcela.QuantidadeParcela).
    
                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_principal, LEAVE blk_principal.
            END.

            MESSAGE ">>> x4".
    
            ASSIGN v-embarque = ?.

            IF MSG_Parcela.EmbarcarParcela THEN DO:

                MESSAGE ">>> x5".

                
                MESSAGE ">>> MSG_Parcela.EmbarcarParcela " MSG_Parcela.EmbarcarParcela.

                /*Cria novo Embarque / grava o codigo do embarque para embarcar a parcela*/
                IF MSG_Parcela.NumeroEmbarque = ? THEN DO:
                    RUN pi-cria-embarque (INPUT  MSG_Parcela.NumeroOrdemCompra,
                                          INPUT  MSG_Parcela.SequenciaParcela,
                                          OUTPUT v-embarque).      
        
                    IF RETURN-VALUE <> "OK" THEN
                        UNDO blk_principal, LEAVE blk_principal.
                END.
                ELSE DO:
                    IF NOT CAN-FIND (FIRST embarque-imp
                                     WHERE embarque-imp.cod-estabel = ordem-compra.cod-estabel
                                       AND embarque-imp.embarque    = MSG_Parcela.NumeroEmbarque) THEN DO:

                        RUN pi-erro (INPUT "N∆o encontrado embarque " + STRING(MSG_Parcela.NumeroEmbarque) + " para o estabelecimento " + STRING(ordem-compra.cod-estabel)).
                        UNDO blk_principal, LEAVE blk_principal.
                    END.
        
                    ASSIGN v-embarque = MSG_Parcela.NumeroEmbarque.
                END.

                RUN embarca-parcela (INPUT v-embarque,
                                     INPUT MSG_Parcela.NumeroOrdemCompra, 
                                     INPUT MSG_Parcela.SequenciaParcela).       

                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_principal, LEAVE blk_principal.
            END.

            /*
            
            FOR FIRST ext-embarque-imp 
                WHERE ext-embarque-imp.embarque        = v-embarque
                  AND ext-embarque-imp.log-envio-comex = YES:
               RUN pi-output-api-request  ("CEX",
                                          "1",
                                          "ProcessoEX-NEW",
                                          "MSG0209",
                                          ext-embarque-imp.cod-estabel + "," + ext-embarque-imp.embarque,
                                          lcRequest
                                         ).
               FOR EACH apiRowErrors:
                  RUN pi-erro (apiRowErrors.ErrorDescription).
               END.
               IF TEMP-TABLE apiRowErrors:HAS-RECORDS
               THEN UNDO blk_principal, LEAVE blk_principal.
            END.
            */

            MESSAGE ">>> x6".
            RUN pi-cria-retorno.

            /*
            FIND FIRST es-api-empresa
                 WHERE es-api-empresa.id-codigo = "1"
                 NO-ERROR.
            IF AVAIL es-api-empresa
            THEN  ASSIGN 
               es-api-empresa.api_key = SEARCH("esp/esb/IN/msg0209.r")
               es-api-empresa.API_SECRET =  v-embarque.
            RELEASE es-api-empresa.
            FIND FIRST es-api-empresa NO-LOCK NO-ERROR.

            */

            /*
            IF AVAIL ParcelaAlteradaResultado_R1
            THEN DO:
               MESSAGE ">>> x7".
               
               FOR FIRST ext-embarque-imp NO-LOCK
                   WHERE ext-embarque-imp.embarque = v-embarque:
                  
                  IF ext-embarque-imp.log-envio-comex = YES
                  THEN DO:
                     IF MSG_Parcela.SequenciaParcela <> ? 
                     THEN DO:
                        MESSAGE ">>> x8.1 MSG_Parcela.SequenciaParcela" MSG_Parcela.SequenciaParcela .
                        MESSAGE ">>> x8.2 MSG_Parcela.NumeroEmbarque  " MSG_Parcela.NumeroEmbarque   .
                        MESSAGE ">>> x8.2 v-embarque                  " v-embarque                    .

                        IF c-old-embarque = v-embarque
                        THEN DO:
                           MESSAGE ">>> x8.2 ".
                           RUN pi-output-api-request  ("CEX",
                                                       "1",
                                                       "ItPedidoCEX-ALT",
                                                       "MSG0209",
                                                       ext-embarque-imp.cod-estabel          + "," + 
                                                       ext-embarque-imp.embarque             + "," + 
                                                       STRING(MSG_Parcela.NumeroOrdemCompra) + "," + 
                                                       STRING(MSG_Parcela.SequenciaParcela ),
                                                       lcRequest
                                                      ).
                        END.
                        ELSE DO:
                           MESSAGE ">>> x8.3 verifica embarque".
                           RUN pi-pedido-item (ext-embarque-imp.cod-estabel         ,
                                               ext-embarque-imp.embarque            ,
                                               STRING(MSG_Parcela.NumeroOrdemCompra),
                                               STRING(MSG_Parcela.SequenciaParcela )
                                              ).
                           MESSAGE ">>> x8.3 l-n-ped" l-n-ped.
                           IF l-n-ped = YES
                           THEN DO:
                               RUN pi-output-api-request  ("CEX",
                                                           "1",
                                                           "PedidoCEX-NEW",
                                                           "MSG0209",
                                                           ext-embarque-imp.cod-estabel          + "," + 
                                                           ext-embarque-imp.embarque             + "," + 
                                                           STRING(MSG_Parcela.NumeroOrdemCompra) + "," + 
                                                           STRING(MSG_Parcela.SequenciaParcela ),
                                                           lcRequest
                                                          ).
                           END.
                           ELSE DO:
                               RUN pi-output-api-request  ("CEX",
                                                           "1",
                                                           "ItPedidoCEX-NEW",
                                                           "MSG0209",
                                                           ext-embarque-imp.cod-estabel          + "," + 
                                                           ext-embarque-imp.embarque             + "," + 
                                                           STRING(MSG_Parcela.NumeroOrdemCompra) + "," + 
                                                           STRING(MSG_Parcela.SequenciaParcela ),
                                                           lcRequest
                                                          ).
                           END.
                        END.
                     END.
                  END.

               END.
            END.
            */
        END.
    
        /*Là ordens alteradas e totaliza*/
        FOR EACH tt-ordens-pedido:
            RUN totaliza-ordem (INPUT tt-ordens-pedido.numero-ordem).
    
            IF RETURN-VALUE <> "OK" THEN
                UNDO blk_principal, LEAVE blk_principal.
        END.
    END.

    FOR EACH apiRowErrors:
       RUN pi-erro ("DATI - " + apiRowErrors.ErrorDescription).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".
END PROCEDURE.

PROCEDURE pi-cria-retorno:

    CREATE ParcelaAlteradaResultado_R1.
    ASSIGN ParcelaAlteradaResultado_R1.NumeroOrdemCompra = MSG_Parcela.NumeroOrdemCompra     
           ParcelaAlteradaResultado_R1.SequenciaParcela  = MSG_Parcela.SequenciaParcela          
           ParcelaAlteradaResultado_R1.NumeroEmbarque    = v-embarque.

END PROCEDURE.

PROCEDURE pi-altera-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.
    DEFINE INPUT PARAM p-data-entrega LIKE prazo-compra.data-entrega.
    DEFINE INPUT PARAM p-quantidade   LIKE prazo-compra.quantidade.

    IF p-quantidade > 9999999.9999 THEN DO:
       RUN pi-erro (INPUT "Nao permitido parcelas com quantidade maior que 9.999.999,9999").
       RETURN "NOK":U.
    END.

    /*Busca a ordem das parcelas*/
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.
    
    FIND FIRST prazo-compra EXCLUSIVE-LOCK USE-INDEX ordem
         WHERE prazo-compra.numero-ordem = p-numero-ordem
           AND prazo-compra.parcela      = p-parcela NO-ERROR.

    IF  AVAIL prazo-compra 
    AND (prazo-compra.data-entrega <> p-data-entrega
     OR  prazo-compra.quantidade   <> p-quantidade) THEN DO:

        IF CAN-FIND (FIRST ordens-embarque
                     WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                       AND ordens-embarque.parcela      = prazo-compra.parcela) THEN DO:
            RUN pi-erro (INPUT "Parcela " + STRING(prazo-compra.parcela) + " da ordem " + STRING(prazo-compra.numero-ordem) + " possui embarque vinculado.").
            RETURN "NOK".
        END.
        
        IF prazo-compra.data-entrega <> p-data-entrega THEN DO:
            ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                   prazo-compra.data-entrega     = p-data-entrega.
        END.
        
        IF prazo-compra.quantidade <> p-quantidade  THEN DO:
            /*Busca indice de converá∆o de quantidade do fornecedor*/
            RUN calcula-indice (INPUT  p-numero-ordem,
                                INPUT  p-parcela,     
                                INPUT  ordem-compra.it-codigo,   
                                INPUT  ordem-compra.cod-emitente,
                                OUTPUT de-indice).

            ASSIGN prazo-compra.quantidade   = p-quantidade
                   prazo-compra.quant-saldo  = prazo-compra.quantidade
                   prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                   prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn.
        END.

        /*Cria temp-table com ordens que precisam ser totalizadas*/
        FIND FIRST tt-ordens-pedido
             WHERE tt-ordens-pedido.numero-ordem = p-numero-ordem NO-ERROR.

        IF NOT AVAIL tt-ordens-pedido THEN DO:
            CREATE tt-ordens-pedido.
            ASSIGN tt-ordens-pedido.numero-ordem = p-numero-ordem.
        END.
        CREATE alt-ped.
        ASSIGN alt-ped.num-pedido   = ordem-compra.num-pedido
               alt-ped.numero-ordem = ordem-compra.numero-ordem
               alt-ped.parcela      = prazo-compra.parcela
               alt-ped.data         = TODAY
               alt-ped.hora         = STRING(time,"hh:mm:ss")
               alt-ped.usuario      = c-usuario-log
               alt-ped.data-entrega = prazo-compra.data-entrega
               alt-ped.observacao   = c-usuario-log + ": " + MSG_Parcela.Observacoes 
               alt-ped.quantidade   = prazo-compra.quantidade
               alt-ped.cod-cond-pag = ?. 
    END.

    FIND CURRENT prazo-compra NO-LOCK NO-ERROR.

    RUN pi-analisa-parcela (INPUT p-numero-ordem,
                            INPUT p-parcela).

    RETURN "OK".

END PROCEDURE.

    
PROCEDURE desembarca-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.

    DEF VAR c-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF VAR c-embarque    LIKE embarque-imp.embarque    NO-UNDO.


    EMPTY TEMP-TABLE RowErrors.

    FIND FIRST ordens-embarque NO-LOCK
         WHERE ordens-embarque.numero-ordem = p-numero-ordem
           AND ordens-embarque.parcela      = p-parcela NO-ERROR.

    MESSAGE ">>> " 1.

    IF AVAIL ordens-embarque 
    THEN DO:

        ASSIGN
           c-cod-estabel = ordens-embarque.cod-estabel
           c-embarque    = ordens-embarque.embarque
           .

        IF NOT VALID-HANDLE(h-bocx225) THEN
           RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
        
        IF NOT VALID-HANDLE(h-bocx404) THEN DO:
           RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.
           RUN openQueryStatic IN h-bocx404(INPUT "Main":U).
        END.


        ASSIGN r-rowid = ROWID(ordens-embarque).
        
        RUN validateDelete IN h-bocx225 (INPUT-OUTPUT r-rowid, 
                                         OUTPUT TABLE RowErrors).
    
        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                RUN pi-erro (INPUT "Ordem: " + STRING(p-numero-ordem) + " Parcela: " + STRING(p-parcela) + " Erro: " + RowErrors.errorDescription).
            END.
        END. 
        ELSE DO:
            RUN verificaIntegraDI IN h-bocx404 (INPUT p-numero-ordem, 
                                                INPUT p-parcela, 
                                                OUTPUT l-integra-di).
    
            MESSAGE ">>> 1.1 " l-integra-di.
            IF l-integra-di THEN DO:
                RUN desvinculaOrdem IN h-bocx404 (INPUT p-numero-ordem, 
                                                  INPUT p-parcela).
            END.
        END.

        DELETE PROCEDURE h-bocx225.
        DELETE PROCEDURE h-bocx404.

        IF CAN-FIND (FIRST tt-erro) THEN
            RETURN "NOK".

        
        MESSAGE ">>> " 2.
 /**/   /*  
        FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
             WHERE ext-embarque-imp.cod-estabel = c-cod-estabel
               AND ext-embarque-imp.embarque    = c-embarque
             NO-ERROR.

        MESSAGE ">>> " 2.0 AVAIL ext-embarque-imp.

        IF AVAIL ext-embarque-imp
        THEN DO:

           MESSAGE ">>> " 2.1 ext-embarque-imp.log-envio-comex.
           
           IF ext-embarque-imp.log-envio-comex = YES
           THEN /**/ DO:
           
              FIND FIRST prazo-compra NO-LOCK
                   WHERE prazo-compra.numero-ordem = p-numero-ordem
                     AND prazo-compra.parcela      = p-parcela 
                   NO-ERROR.
              
              /*
              IF  AVAIL prazo-compra 
              AND (prazo-compra.data-entrega <> p-data-entrega
              OR  prazo-compra.quantidade   <> p-quantidade) THEN DO:
              */
              
              MESSAGE ">>> prazo-compra.quantidade " prazo-compra.quantidade.
              
              
              /**/
              /*IF MSG_Parcela.SequenciaParcela = ? // MSG_Parcela.EmbarcarParcela = NO
              THEN*/

              IF MSG_Parcela.QuantidadeParcela = prazo-compra.quantidade
              THEN DO:
                 FIND FIRST ordens-embarque NO-LOCK
                      WHERE ordens-embarque.cod-estabel  = c-cod-estabel
                        AND ordens-embarque.embarque     = c-embarque   
                      NO-ERROR.
                 IF NOT AVAIL ordens-embarque
                 THEN DO:
                    RUN pi-output-api-request  ("CEX",
                                                "1",
                                                "ProcessoCEX-DEL",
                                                "MSG0209",
                                                c-embarque,
                                                lcRequest
                                               ).
                    ASSIGN ext-embarque-imp.log-envio-comex = NO
                           ext-embarque-imp.log-enviado-comex = NO.
                 END.
                 ELSE DO:
                    ASSIGN
                       l-d-ped = NO.
                    RUN pi-pedido-item (c-cod-estabel,
                                        c-embarque,
                                        p-numero-ordem,
                                        p-parcela
                                        ).
                    IF l-d-ped
                    THEN ASSIGN
                       c-call = "PedidoCEX-DEL".
                    ELSE ASSIGN
                       c-call = "ItPedidoCEX-DEL".
                    
                    FIND FIRST bfx-ordem-compra NO-LOCK
                         WHERE bfx-ordem-compra.numero-ordem  = p-numero-ordem
                         NO-ERROR.
                    FIND FIRST bfx-pedido-compr 
                            OF bfx-ordem-compra
                         NO-ERROR.
                    
                    MESSAGE ">>> " 3 l-d-ped.
                    IF c-call = "PedidoCEX-DEL"
                    THEN ASSIGN
                       cID = c-embarque
                           + "-"
                           + STRING(bfx-ordem-compra.num-pedido).
                    ELSE ASSIGN
                       cID = c-embarque
                           + "-"
                           + STRING(bfx-ordem-compra.num-pedido)
                           + "-"
                           + STRING(p-numero-ordem)
                           + "-"
                           + STRING(p-parcela)
                           + "-"
                           + bfx-ordem-compra.it-codigo
                           + "-"
                           + STRING(bfx-pedido-compr.cod-emitente).
                    
                    MESSAGE ">>> " 4.
                    /**/
                    RUN pi-output-api-request  ("CEX",
                                                "1",
                                                c-call,
                                                "MSG0209",
                                                cID,
                                                lcRequest
                                               ).
                    MESSAGE ">>> " 5.
                    /**/
                 END.
              END.
           END.
        END.
        ELSE DO:
           RUN pi-erro (INPUT "Tabela ext-embarque-imp nao criada para o embarque " + c-embarque).
        END.
        RELEASE ext-embarque-imp.
        */

    END.
    
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE embarca-parcela:
    DEFINE INPUT PARAM p-embarque     LIKE embarque-imp.embarque.
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.
   
    DEFINE VARIABLE i-moeda LIKE moeda.mo-codigo.

    EMPTY TEMP-TABLE RowErrors.

    IF NOT VALID-HANDLE(h-bocx225) THEN 
        RUN cxbo/bocx225.p persistent set h-bocx225.

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ordem-compra.cod-estabel
          AND embarque-imp.embarque    = p-embarque:

        /*Valida se embarque possui outra moeda*/
        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

        /*Moeda da parcela que ser† embarcada*/
        ASSIGN i-moeda = ordem-compra.mo-codigo.

        /*Là moedas ja ambarcadas*/
        FOR EACH ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
             AND ordens-embarque.embarque    = embarque-imp.embarque:
             FOR FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:

                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.cot-aprovada = YES NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    IF cotacao-item.mo-codigo <> i-moeda THEN
                        RUN pi-erro (INPUT "Moeda " + STRING(i-moeda) + " diferente da moeda " + STRING(cotacao-item.mo-codigo) + " ja embarcada no embarque " + STRING(embarque-imp.embarque)).
                END.
             END.
        END.
        

        FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem
             WHERE prazo-compra.numero-ordem = p-numero-ordem
               AND prazo-compra.parcela      = p-parcela NO-ERROR.

        IF NOT AVAIL prazo-compra THEN DO:
            RUN pi-erro (INPUT "Parcela " + STRING(p-parcela) + " da ordem " + STRING(p-numero-ordem) + " n∆o encontrada!").

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                DELETE PROCEDURE h-bocx225.
                RETURN "NOK".
            END.
        END.

        RUN setCreatehist IN h-bocx225.

        RUN validavinculacaoordens IN h-bocx225 (INPUT embarque-imp.embarque,    
                                                 INPUT embarque-imp.cod-estabel, 
                                                 INPUT p-numero-ordem,
                                                 INPUT p-parcela, 
                                                 OUTPUT TABLE RowErrors).

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
            /*Atualiza situaá∆o do precesso de importaá∆o, se foi alterada as quantidades das parcelas pode estar como embarcado total e dar erro no createOrdensEmbarquebyparcela*/
            RUN pi-atualizaSitProc IN h-bocx225 (INPUT ordem-compra.num-pedido).
            RUN createOrdensEmbarquebyparcela IN h-bocx225 (INPUT ROWID(embarque-imp),
                                                            INPUT p-numero-ordem,
                                                            INPUT p-parcela,
                                                            INPUT prazo-compra.quantidade,
                                                            OUTPUT TABLE RowErrors).
                
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                FOR EACH RowErrors:
                    RUN pi-erro (INPUT "Ordem: " + STRING(p-numero-ordem) + " Parcela: " + STRING(p-parcela) + " Erro: " + RowErrors.errorDescription).
                END.
                IF CAN-FIND (FIRST tt-erro) THEN DO:
                    DELETE PROCEDURE h-bocx225.
                    RETURN "NOK".
                END.
            END.
    
            
           IF (SEARCH("imp/im0045x.p") <> ? OR SEARCH("imp/im0045x.r") <> ?) THEN DO:
               IF AVAIL prazo-compra THEN 
                  RUN imp/im0045x.p (1, ROWID(prazo-compra)).

               IF RETURN-VALUE = "NOK":U THEN DO:
                   DELETE PROCEDURE h-bocx225.
                   RETURN "NOK".
               END.
           END.
        END.
        ELSE DO:
            FOR EACH RowErrors:
                RUN pi-erro (INPUT "Ordem: " + STRING(p-numero-ordem) + " Parcela: " + STRING(p-parcela) + " Erro: " + RowErrors.errorDescription).
            END.

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                DELETE PROCEDURE h-bocx225.
                RETURN "NOK".
            END.
        END.
    END.

    DELETE PROCEDURE h-bocx225.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE cria-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem. /*Ordem da Parcela que ser† usada como base na criaá∆o da nova*/
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.      /*Parcela que ser† usada como base na criaá∆o da nova*/
    DEFINE INPUT PARAM p-quantidade   LIKE prazo-compra.quantidade.      /*Quantidade da nova parcela*/
    DEFINE INPUT PARAM p-data-entrega LIKE prazo-compra.data-entrega.    /*Data entrega da nova parcela*/
    
    DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.

    IF p-quantidade > 9999999.9999 THEN DO:
       RUN pi-erro (INPUT "Nao permitido parcelas com quantidade maior que 9.999.999,9999").
       RETURN "NOK":U.
    END.
    
    /*Pega Sequencia da Ultima parcela*/
    ASSIGN i-cont = 1.
    FIND LAST b-prazo-compra NO-LOCK
        WHERE b-prazo-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF AVAIL b-prazo-compra THEN                
        ASSIGN i-cont = b-prazo-compra.parcela + 1.

    /*Grava o n£mero da parcela criada para embarcar e gerar retorno*/
    ASSIGN MSG_Parcela.SequenciaParcela = i-cont.

    /*Busca a ordem das parcelas*/
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF NOT AVAIL ordem-compra THEN DO:
        RUN pi-erro (INPUT "N∆o encontrada ordem de compra " + STRING(p-numero-ordem)).
        RETURN "NOK":U.
    END.
        
    /*Busca a parcela de origem*/
    FIND FIRST b-prazo-compra EXCLUSIVE-LOCK 
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    IF AVAIL b-prazo-compra THEN DO:

        /*Busca indice de converá∆o de quantidade do fornecedor*/
        RUN calcula-indice (INPUT  p-numero-ordem,
                            INPUT  p-parcela,     
                            INPUT  ordem-compra.it-codigo,   
                            INPUT  ordem-compra.cod-emitente,
                            OUTPUT de-indice).

        /*Cria nova parcela*/
        CREATE prazo-compra.
        ASSIGN prazo-compra.numero-ordem = b-prazo-compra.numero-ordem
               prazo-compra.parcela      = i-cont 
               prazo-compra.data-entrega = p-data-entrega
               prazo-compra.quantidade   = p-quantidade
               prazo-compra.data-orig    = b-prazo-compra.data-orig
               prazo-compra.it-codigo    = b-prazo-compra.it-codigo
               prazo-compra.un           = b-prazo-compra.un   
               prazo-compra.quantid-orig = p-quantidade
               prazo-compra.quant-saldo  = p-quantidade
               prazo-compra.quant-rejeit = 0
               prazo-compra.quant-receb  = 0
               prazo-compra.qtd-do-forn  = p-quantidade * de-indice 
               prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn 
               prazo-compra.qtd-rej-forn = 0
               prazo-compra.qtd-rec-forn = 0
               prazo-compra.pedido-clien = b-prazo-compra.pedido-clien
               prazo-compra.nome-abrev   = b-prazo-compra.nome-abrev
               prazo-compra.nr-alt-data  = b-prazo-compra.nr-alt-data
               prazo-compra.nr-alt-quant = b-prazo-compra.nr-alt-quant 
               prazo-compra.situacao     = b-prazo-compra.situacao
               prazo-compra.natureza     = b-prazo-compra.natureza
               prazo-compra.cod-refer    = b-prazo-compra.cod-refer 
               prazo-compra.concentracao = b-prazo-compra.concentracao 
               prazo-compra.rendimento   = b-prazo-compra.rendimento 
               prazo-compra.nr-sequencia = b-prazo-compra.nr-sequencia 
               prazo-compra.cc-codigo    = b-prazo-compra.cc-codigo
               prazo-compra.data-alter   = TODAY
               prazo-compra.usuario-alt  = c-usuario-log
               prazo-compra.nr-contrato  = b-prazo-compra.nr-contrato.

        /*Gera hist¢rico da alteraá∆o*/
        CREATE alt-ped.
        ASSIGN alt-ped.data         = TODAY
               alt-ped.hora         = STRING(TIME + 1,"HH:MM:SS")
               alt-ped.usuario      = c-usuario-log
               alt-ped.num-pedido   = ordem-compra.num-pedido
               alt-ped.numero-ordem = ordem-compra.numero-ordem
               alt-ped.parcela      = prazo-compra.parcela
               alt-ped.observacao   = c-usuario-log + ": " + MSG_Parcela.Observacoes 
               alt-ped.data-entrega = p-data-entrega
               alt-ped.quantidade   = p-quantidade
               alt-ped.cod-cond-pag = ?.
    
        ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + "?".
        
        IF  p-data-entrega <> prazo-compra.data-entrega THEN
            ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + STRING(prazo-compra.data-entrega,"99/99/9999").
        ELSE
            ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + "".
    
        FOR FIRST b-prazo-compra-aux NO-LOCK USE-INDEX ordem 
            WHERE b-prazo-compra-aux.numero-ordem = p-numero-ordem 
              AND b-prazo-compra-aux.parcela      = p-parcela:

             FIND FIRST eq-embarq-praz-compra NO-LOCK
                  WHERE eq-embarq-praz-compra.numero-ordem = b-prazo-compra-aux.numero-ordem
                    AND eq-embarq-praz-compra.parcela      = b-prazo-compra-aux.parcela NO-ERROR.

             IF AVAIL eq-embarq-praz-compra THEN DO:
                 
                 FOR LAST b-eq-embarq-praz-compra-aux NO-LOCK USE-INDEX eqmbrqpr-id
                    WHERE b-eq-embarq-praz-compra-aux.cod-estabel = eq-embarq-praz-compra.cod-estabel
                      AND b-eq-embarq-praz-compra-aux.cod-placa   = eq-embarq-praz-compra.cod-placa
                      AND b-eq-embarq-praz-compra-aux.dat-entr    = eq-embarq-praz-compra.dat-entr
                      AND b-eq-embarq-praz-compra-aux.hra-entr    = eq-embarq-praz-compra.hra-entr: 
                 END.

                 CREATE b-eq-embarq-praz-compra.
                 BUFFER-COPY eq-embarq-praz-compra EXCEPT parcela num-seq TO b-eq-embarq-praz-compra NO-ERROR.
                 ASSIGN b-eq-embarq-praz-compra.num-seq = IF AVAIL b-eq-embarq-praz-compra-aux THEN b-eq-embarq-praz-compra-aux.num-seq + 1 ELSE 1. 
                        b-eq-embarq-praz-compra.parcela = i-cont.
             END.
        END.
        
        /*Cria temp-table com ordens que precisam ser totalizadas*/
        FIND FIRST tt-ordens-pedido
             WHERE tt-ordens-pedido.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

        IF NOT AVAIL tt-ordens-pedido THEN DO:
            CREATE tt-ordens-pedido.
            ASSIGN tt-ordens-pedido.numero-ordem = ordem-compra.numero-ordem.
        END.
 
/*N∆o pode copiar LI, a li pertence somente a um embarque (Gizelle)*/

/*Verifica se tem LI e copia caso positivo*/                      
/*         IF  AVAIL b-prazo-compra                                          */
/*         AND AVAIL prazo-compra THEN                                       */
/*             RUN criaLicenciamImportOC (INPUT b-prazo-compra.numero-ordem, */
/*                                        INPUT b-prazo-compra.parcela).     */

        RELEASE b-prazo-compra.
        RELEASE prazo-compra.

    END.
    ELSE DO:
        RUN pi-erro (INPUT "Parcela " + STRING(p-parcela) + " da ordem " + STRING(p-numero-ordem) + " n∆o encontrada!").
        RETURN "NOK".
    END.

    RUN pi-analisa-parcela (INPUT p-numero-ordem,
                            INPUT i-cont).

    RETURN "OK".

END PROCEDURE.

PROCEDURE totaliza-ordem:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.

    DEFINE VARIABLE TotalOrdem AS DECIMAL     NO-UNDO.

    DEFINE BUFFER b-ordem-compra FOR ordem-compra.

    FIND FIRST b-ordem-compra NO-LOCK
         WHERE b-ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF NOT AVAIL b-ordem-compra THEN DO:
        RUN pi-erro (INPUT "N∆o encontrada ordem de compra " + STRING(p-numero-ordem)).
            RETURN "NOK":U.
    END.

    /*Totaliza quantidade da ordem*/
    ASSIGN TotalOrdem = 0.
    FOR EACH prazo-compra NO-LOCK
        WHERE prazo-compra.numero-ordem = b-ordem-compra.numero-ordem:
        ASSIGN TotalOrdem = TotalOrdem + prazo-compra.quantidade.
    END.
    
    /*Se a soma total das parcelas mudou altera na ordem*/
    IF b-ordem-compra.qt-solic <> TotalOrdem THEN DO:
        FIND CURRENT b-ordem-compra EXCLUSIVE-LOCK.
        ASSIGN b-ordem-compra.qt-solic     = TotalOrdem
               b-ordem-compra.usuario      = c-usuario-log
               b-ordem-compra.data-atualiz = TODAY
               b-ordem-compra.hora-atualiz = STRING(TIME, "hh:mm:ss":U).
        FIND CURRENT b-ordem-compra NO-LOCK.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE criaLicenciamImportOC :
    /* Licenciamento Importacao */
    DEFINE INPUT PARAMETER iNumeroOrdem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER iParcela     LIKE prazo-compra.parcela      NO-UNDO.
    
    DEFINE VARIABLE hBocx351 AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cReturn  AS CHARACTER NO-UNDO.
    
    EMPTY TEMP-TABLE tt-licenciam-import-oc-aux.
    
    IF NOT VALID-HANDLE(hBocx351) THEN
       RUN cxbo/bocx351.p PERSISTENT SET hBocx351.
    
    RUN openQueryStatic IN hBocx351 (INPUT "Main":U).
    
    RUN piRetornaLI IN hBocx351 (INPUT 3,
                                 INPUT NO,
                                 INPUT ?,
                                 INPUT ?,
                                 INPUT ?,
                                 INPUT iParcela,
                                 INPUT YES,
                                 INPUT YES,
                                 INPUT iNumeroOrdem,
                                 INPUT iNumeroOrdem,
                                 INPUT " ":U,
                                 INPUT " ":U,
                                 INPUT " ":U,
                                 INPUT " ":U,
                                 INPUT " ":U,
                                 INPUT " ":U,
                                 OUTPUT TABLE tt-licenciam-import-oc).
    
    FOR FIRST tt-licenciam-import-oc NO-LOCK: 
    END.

    IF AVAIL tt-licenciam-import-oc THEN DO:
        CREATE tt-licenciam-import-oc-aux.
        ASSIGN tt-licenciam-import-oc-aux.numero-ordem   = prazo-compra.numero-ordem
               tt-licenciam-import-oc-aux.parcela        = prazo-compra.parcela
               tt-licenciam-import-oc-aux.licenca-import = tt-licenciam-import-oc.licenca-import.
    END.
    
    IF AVAIL tt-licenciam-import-oc-aux THEN DO:
    
        Records:
        DO TRANSACTION ON ERROR UNDO, LEAVE:
    
            RUN emptyRowErrors IN hBocx351.
            RUN emptyRowObject IN hBocx351.
    
            RUN setRecord IN hBocx351 (INPUT TABLE tt-licenciam-import-oc-aux).
            
            RUN createRecord IN hBocx351.
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN hBocx351 (OUTPUT TABLE RowErrors).
    
                FOR EACH  RowErrors 
                   WHERE RowErrors.errorType = "INTERNAL":U:
                    DELETE RowErrors.
                END.

                IF CAN-FIND (FIRST RowErrors) THEN
                    UNDO Records, LEAVE Records.
            END.
        END.
    END.
    
    IF VALID-HANDLE (hBocx351) THEN DO:
        DELETE PROCEDURE hBocx351.
        ASSIGN hBocx351 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-embarque:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE OUTPUT PARAM p-embarque     LIKE embarque-imp.embarque.

    DEFINE VARIABLE v-num-seq-emb  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-cod-seq-emb  AS CHARACTER   NO-UNDO.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF NOT AVAIL ordem-compra THEN DO:
        RUN pi-erro (INPUT "N∆o encontrada ordem de compra " + STRING(p-numero-ordem)).
        RETURN "NOK":U.
    END.

    FIND FIRST pedido-compr NO-LOCK 
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

    IF NOT AVAIL pedido-compr THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado pedido vinculado a ordem de compra " + STRING(p-numero-ordem)).
        RETURN "NOK":U.
    END. 

    FIND FIRST processo-imp NO-LOCK
         WHERE processo-imp.cod-estabel = pedido-compr.cod-estabel
           AND processo-imp.num-pedido  = pedido-compr.num-pedido NO-ERROR.

    IF NOT AVAIL processo-imp THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado processo de importaá∆o para o pedido" + STRING(pedido-compr.num-pedido)).
        RETURN "NOK":U.
    END.
    
    ASSIGN v-cod-seq-emb = "a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az;ba;bb;bc;bd;be;bf;bg;bh;bi;bj;bk;bl;bm;bn;bo;bp;bq;br;bs;bt;bu;bv;bw;bx;by;bz;ca;cb;cc;cd;ce;cf;cg;ch;ci;cj;ck;cl;cm;cn;co;cp;cq;cr;cs;ct;cu;cv;cw;cx;cy;cz;da;db;dc;dd;de;df;dg;dh;di;dj;dk;dl;dm;dn;do;dp;dq;dr;ds;dt;du;dv;dw;dx;dy;dz;"
           v-num-seq-emb = 0.
   
    /*Busca sequencia do embarque para definir a letra*/
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.cod-estabel = pedido-compr.cod-estabel 
         AND embarque-imp.embarque BEGINS STRING(pedido-compr.num-pedido):
        IF embarque-imp.embarque <> STRING(pedido-compr.num-pedido) THEN DO:
            IF v-num-seq-emb < LOOKUP(SUBSTRING(embarque-imp.embarque,LENGTH(STRING(pedido-compr.num-pedido)) + 1,LENGTH(embarque-imp.embarque) - LENGTH(STRING(pedido-compr.num-pedido))),v-cod-seq-emb,";") + 1 THEN
                ASSIGN v-num-seq-emb  = LOOKUP(SUBSTRING(embarque-imp.embarque,LENGTH(STRING(pedido-compr.num-pedido)) + 1,LENGTH(embarque-imp.embarque) - LENGTH(STRING(pedido-compr.num-pedido))),v-cod-seq-emb,";") + 1.
        END.
        ELSE 
            ASSIGN v-num-seq-emb = 1.
    END.

    IF v-num-seq-emb > 0 THEN
        ASSIGN p-embarque = STRING(pedido-compr.num-pedido) + ENTRY(v-num-seq-emb,v-cod-seq-emb,";").
    ELSE 
        ASSIGN p-embarque = STRING(pedido-compr.num-pedido).

    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem  
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente  
           AND cotacao-item.it-codigo    = ordem-compra.it-codigo
           AND cotacao-item.cot-aprov    = YES NO-ERROR.

    CREATE embarque-imp.
    ASSIGN embarque-imp.cod-estabel       = pedido-compr.cod-estabel
           embarque-imp.embarque          = p-embarque
           embarque-imp.situacao          = 1
           embarque-imp.cod-transportador = processo-imp.cod-transportador
           embarque-imp.cod-via-transp    = pedido-compr.via-transp
           embarque-imp.narrativa         = pedido-compr.comentarios
           embarque-imp.cod-incoterm      = SUBSTR(cotacao-item.char-1,21,3)
           embarque-imp.contabiliza       = NO.

    RETURN "OK".
END PROCEDURE.

PROCEDURE calcula-indice:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE INPUT  PARAM p-it-codigo    LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-cod-emitente LIKE ordem-compra.cod-emitente.
    DEFINE OUTPUT PARAM p-indice       AS DEC.

    FIND FIRST b-prazo-compra NO-LOCK USE-INDEX ordem
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    ASSIGN p-indice = 1.

    IF AVAILABLE ITEM THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = ITEM.it-codigo
               AND item-fornec.cod-emitente = p-cod-emitente NO-ERROR.

        IF  (ITEM.tipo-contr = 4 
        AND NOT AVAILABLE item-fornec 
        OR  ITEM.it-codigo = "":U) THEN DO:

            IF  AVAILABLE cotacao-item            
            AND cotacao-item.un <> b-prazo-compra.un THEN DO:

                FIND FIRST tab-conv-un NO-LOCK
                     WHERE tab-conv-un.un           = b-prazo-compra.un
                       AND tab-conv-un.unid-med-for = cotacao-item.un NO-ERROR.

                IF AVAILABLE tab-conv-un THEN
                    ASSIGN p-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
            END.
        END.
        ELSE IF AVAILABLE item-fornec THEN
            ASSIGN p-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
    END.
END PROCEDURE.

PROCEDURE pi-analisa-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE prazo-compra.parcela.

    FIND FIRST int-analise-ordem-compra EXCLUSIVE-LOCK
         WHERE int-analise-ordem-compra.numero-ordem = p-numero-ordem
           AND int-analise-ordem-compra.parcela      = p-parcela NO-ERROR.

    IF NOT AVAILABLE int-analise-ordem-compra THEN DO:
        CREATE int-analise-ordem-compra.
        ASSIGN int-analise-ordem-compra.numero-ordem = p-numero-ordem  
               int-analise-ordem-compra.parcela      = p-parcela.
    END.

    ASSIGN int-analise-ordem-compra.log-analisada = MSG_Parcela.ParcelaAnalisada.

    IF MSG_Parcela.SituacaoMovimentoParcela <> ? THEN
        ASSIGN int-analise-ordem-compra.num-livre-1 = MSG_Parcela.SituacaoMovimentoParcela.

    IF MSG_Parcela.MotivoAlteracao <> ? THEN
        ASSIGN int-analise-ordem-compra.num-livre-2 = MSG_Parcela.MotivoAlteracao.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.



PROCEDURE pi-pedido-item:
   DEF BUFFER bfd-ordem-compra    FOR ordem-compra.
   DEF BUFFER bfp-ordem-compra    FOR ordem-compra.
   //DEF BUFFER bff-ordens-embarque FOR ordens-embarque.
   DEF BUFFER bfd-ordens-embarque FOR ordens-embarque.
   DEF INPUT PARAM p-cod-estabel  LIKE ordens-embarque.cod-estabel  NO-UNDO.
   DEF INPUT PARAM p-embarque     LIKE ordens-embarque.embarque     NO-UNDO.
   DEF INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
   DEF INPUT PARAM p-parcela      LIKE ordens-embarque.parcela NO-UNDO.

   DEF VAR i AS i NO-UNDO.

   
   FIND FIRST bfp-ordem-compra NO-LOCK
        WHERE bfp-ordem-compra.numero-ordem  = p-numero-ordem
        NO-ERROR.
   
   MESSAGE ">>> pi-pedido-item - inicio".

   /**/
   /*
   FOR EACH bfd-ordens-embarque NO-LOCK
      WHERE bfd-ordens-embarque.cod-estabel  = p-cod-estabel
        AND bfd-ordens-embarque.embarque     = p-embarque
        AND bfd-ordens-embarque.numero-ordem = p-numero-ordem,
      FIRST bfd-ordem-compra NO-LOCK
      WHERE bfd-ordem-compra.numero-ordem    = p-numero-ordem
        AND bfd-ordem-compra.num-pedido      = bfp-ordem-compra.num-pedido
        :
   */
   FOR EACH bfd-ordem-compra NO-LOCK
      WHERE bfd-ordem-compra.num-pedido      = bfp-ordem-compra.num-pedido,
       EACH bfd-ordens-embarque NO-LOCK
      WHERE bfd-ordens-embarque.numero-ordem = bfd-ordem-compra.numero-ordem
        AND bfd-ordens-embarque.embarque     = p-embarque:

      ASSIGN
         i = i + 1.


      message ">>> pi-pedido-item ordens-embarque.embarque  " bfd-ordens-embarque.embarque.
      message ">>> pi-pedido-item ordem-compra.numero-ordem " bfd-ordem-compra.numero-ordem.
      message ">>> pi-pedido-item ordem-compra.num-pedido   " bfd-ordem-compra.num-pedido.
      message ">>> pi-pedido-item ordens-embarque.parcela.  " bfd-ordens-embarque.parcela.

   END.

   MESSAGE ">>> pi-pedido-item i              " i.
   MESSAGE ">>> pi-pedido-item p-embarque     " p-embarque.
   MESSAGE ">>> pi-pedido-item p-numero-ordem " p-numero-ordem.
   MESSAGE ">>> bfp-ordem-compra.num-pedido   " bfp-ordem-compra.num-pedido.


   IF i > 1
   THEN ASSIGN
      l-n-ped = NO.
   ELSE ASSIGN
      l-n-ped = YES.


   IF i > 0
   THEN ASSIGN
      l-d-ped = NO.
   ELSE ASSIGN
      l-d-ped = YES.
   
   MESSAGE ">>> pi-pedido-item l-d-ped " l-d-ped.
   MESSAGE ">>> pi-pedido-item l-n-ped " l-n-ped.
   
   MESSAGE ">>> pi-pedido-item - fim".

END.
