CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>988707-3</NumeroOperacao>                                   */
/*     <CodigoMensagem>MSG0223</CodigoMensagem>                                    */
/*     <LoginUsuario>gi041250</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0223>                                                                   */
/*       <NumeroOrdemCompra>988707</NumeroOrdemCompra>                             */
/*       <ParcelaManual>                                                           */
/*         <SequenciaParcela>3</SequenciaParcela>                                  */
/*         <DataParcela>2016-06-01</DataParcela>                                   */
/*         <QuantidadeParcela>920</QuantidadeParcela>                              */
/*       </ParcelaManual>                                                          */
/*     </MSG0223>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0223.i}

DEFINE VARIABLE de-indice AS DECIMAL.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0223, ParcelaManual
   DATA-RELATION FOR conteudo, MSG0223      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0223, ParcelaManual RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0223R1, ParcelaManualR, resultado
   DATA-RELATION FOR conteudor, MSG0223R1      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0223R1, ParcelaManualR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0223R1, resultado      RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0223R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0223 NO-ERROR.

CREATE conteudor.
CREATE MSG0223R1.
ASSIGN MSG0223R1.NumeroOrdemCompra = MSG0223.NumeroOrdemCompra.
CREATE resultado.

RUN cria-parcela.

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

PROCEDURE cria-parcela:
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = cabecalho.LoginUsuario NO-ERROR.

    IF AVAIL usuar_mestre THEN
        ASSIGN c-usuario-log = usuar_mestre.cod_usuario.
    ELSE 
        ASSIGN c-usuario-log = "Integra".

    /*Busca a ordem das parcelas*/
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = MSG0223.NumeroOrdemCompra NO-ERROR.

    IF NOT AVAIL ordem-compra THEN DO:
        RUN pi-erro (INPUT "N∆o encontrada ordem de compra " + STRING(MSG0223.NumeroOrdemCompra)).
        RETURN "NOK":U.
    END.

    /*Busca item da ordem*/
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

    CREATE tt-ordem-compra.
    BUFFER-COPY ordem-compra TO tt-ordem-compra.
    ASSIGN tt-ordem-compra.ind-tipo-movto = 2 /*Manda ordem com as mesmas informaá‰es como Alteraá∆o*/.

    parcela:
    DO TRANS ON ERROR UNDO parcela, 
    LEAVE parcela:

        ASSIGN parcela-aux = 0.
        FOR EACH ParcelaManual:
            IF ParcelaManual.QuantidadeParcela > 9999999.9999 THEN DO:
                RUN pi-erro (INPUT "Nao permitido parcelas com quantidade maior que 9.999.999,9999").
                RETURN "NOK".
            END.

            /*Alteraá∆o*/
            IF ParcelaManual.SequenciaParcela <> ? THEN DO:
                FIND FIRST prazo-compra NO-LOCK
                     WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       AND prazo-compra.parcela      = ParcelaManual.SequenciaParcela NO-ERROR.
    
                IF NOT AVAIL prazo-compra THEN DO:
                    RUN pi-erro (INPUT "N∆o encontrada parcela " + STRING(ParcelaManual.SequenciaParcela) + " da ordem " +  STRING(MSG0223.NumeroOrdemCompra)).
                    RETURN "NOK".
                END.

                CREATE tt-prazo-compra.
                BUFFER-COPY prazo-compra TO tt-prazo-compra.
                ASSIGN tt-prazo-compra.ind-tipo-movto = 2. /*Alteraá∆o*/

                /*se alterou quantidade ou data valida se est† vinculada a um embarque*/
                IF prazo-compra.data-entrega <> ParcelaManual.DataParcela
                OR prazo-compra.quantidade   <> ParcelaManual.QuantidadeParcela THEN DO:
                    IF CAN-FIND (FIRST ordens-embarque
                                 WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                                   AND ordens-embarque.parcela      = prazo-compra.parcela) THEN DO:
                        RUN pi-erro (INPUT "Parcela " + STRING(prazo-compra.parcela) + " da ordem " + STRING(prazo-compra.numero-ordem) + " possui embarque vinculado.").
                        RETURN "NOK".
                    END.
                END.
            END.
            /*Criaá∆o*/
            ELSE DO:  
                
                CREATE tt-prazo-compra.
                /*Busca pr¢xima sequencia*/
                FIND LAST b-prazo-compra NO-LOCK
                    WHERE b-prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-ERROR.
    
                ASSIGN tt-prazo-compra.parcela        = b-prazo-compra.parcela + 1 + parcela-aux 
                       tt-prazo-compra.ind-tipo-movto = 1 /*Criaá∆o*/
                       tt-prazo-compra.situacao       = 2
                       tt-prazo-compra.un             = ITEM.un.

                ASSIGN parcela-aux = parcela-aux + 1. /*Vari†vel para incrementar o n£mero da parcela quando tem mais de uma no XML*/

                /*Grava sequencia da parcela criada para depois gravar a int-prazo-compra*/
                ASSIGN ParcelaManual.SequenciaParcela = tt-prazo-compra.parcela.
            END.

            FIND FIRST item-fornec NO-LOCK 
                 WHERE item-fornec.it-codigo    = ordem-compra.it-codigo 
                   AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

            {cdp/cd9950.i item.un 
                          item-fornec.unid-med-for
                          ordem-compra.cod-emitente}

            assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
            
            ASSIGN tt-prazo-compra.numero-ordem   = ordem-compra.numero-ordem 
                   tt-prazo-compra.quantidade     = ParcelaManual.QuantidadeParcela
                   tt-prazo-compra.data-entrega   = ParcelaManual.DataParcela
                   tt-prazo-compra.data-alter     = TODAY
                   tt-prazo-compra.it-codigo      = ordem-compra.it-codigo
                   tt-prazo-compra.qtd-a-ped-forn = tt-prazo-compra.quantidade * de-indice  
                   tt-prazo-compra.qtd-do-forn    = tt-prazo-compra.quantidade * de-indice  
                   tt-prazo-compra.qtd-sal-forn   = tt-prazo-compra.quantidade * de-indice  
                   tt-prazo-compra.quant-saldo    = tt-prazo-compra.quantidade
                   tt-prazo-compra.quantid-orig   = tt-prazo-compra.quantidade
                   tt-prazo-compra.data-entrega   = ParcelaManual.DataParcela.
        END.

        /*Totaliza quantidade da ordem*/
        ASSIGN TotalOrdem = 0.
        /*Soma as que vieram no XML*/
        FOR EACH tt-prazo-compra NO-LOCK
           WHERE tt-prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            ASSIGN TotalOrdem = TotalOrdem + tt-prazo-compra.quantidade.
        END.
        /*Soma as demais parcelas*/
        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            /*Ignora as que j† somou do XML*/
            IF CAN-FIND (FIRST tt-prazo-compra
                         WHERE tt-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                           AND tt-prazo-compra.parcela      = prazo-compra.parcela) THEN 
                NEXT.

            ASSIGN TotalOrdem = TotalOrdem + prazo-compra.quantidade.
        END.
        
        /*Se a soma total das parcelas mudou altera na ordem*/
        IF ordem-compra.qt-solic <> TotalOrdem THEN DO:
            ASSIGN tt-ordem-compra.qt-solic     = TotalOrdem
                   tt-ordem-compra.usuario      = c-usuario-log
                   tt-ordem-compra.data-atualiz = TODAY
                   tt-ordem-compra.hora-atualiz = STRING(TIME, "hh:mm:ss":U).
        END.
    
        CREATE tt-versao-integr.
        ASSIGN tt-versao-integr.cod-versao-integracao = 1.    
    
        
        RUN ccp/ccapi302.p (INPUT  TABLE tt-versao-integr,
                            OUTPUT TABLE tt-erros-geral,
                            INPUT  TABLE tt-ordem-compra,
                            INPUT  TABLE tt-prazo-compra,        
                            INPUT  TABLE tt-cotacao-item,
                                 &if DEFINED(bf_mat_despesa_fase_II) &then
                                 INPUT TABLE tt-desp-cotacao-item,
                                 &endif
                                 &if '{&bf_mat_versao_ems}' >= '2.04' &then
                                 INPUT TABLE tt-matriz-rat-med,
                                &endif
                            INPUT "MAT038").

        FOR EACH tt-erros-geral:
            RUN pi-erro (INPUT tt-erros-geral.des-erro).
        END.

        IF CAN-FIND (FIRST tt-erro) THEN DO:
            UNDO parcela, LEAVE parcela.
        END.

        FOR EACH tt-prazo-compra:

            /*Grava indormaá‰es da int-prazo-compra, faz a leitura da ParcelaManual s¢ pela sequencia pois todas as parceas s∆o da mesma ordem*/
            FIND FIRST ParcelaManual NO-LOCK
                 WHERE ParcelaManual.SequenciaParcela = tt-prazo-compra.parcela NO-ERROR.

            FIND FIRST int-prazo-compra OF tt-prazo-compra EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAIL int-prazo-compra THEN DO:
                CREATE int-prazo-compra.
                ASSIGN int-prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                       int-prazo-compra.parcela      = tt-prazo-compra.parcela.
            END.

             ASSIGN int-prazo-compra.nro-docto   = ParcelaManual.NumeroNotaFiscalPrevista
                    int-prazo-compra.serie-docto = ParcelaManual.SerieNotaFiscalPrevista.

            RELEASE int-prazo-compra.

            /*Grava hist¢rico de alteraá∆o do pedido*/
            FIND LAST alt-ped EXCLUSIVE-LOCK
                WHERE alt-ped.num-pedido     = ordem-compra.num-pedido
                  AND alt-ped.numero-ordem   = tt-prazo-compra.numero-ordem
                  AND alt-ped.parcela        = tt-prazo-compra.parcela NO-ERROR.

            IF AVAIL alt-ped THEN DO:
                ASSIGN alt-ped.observacao = alt-ped.observacao + " | " + msg0223.Observacoes.
            END.

            RELEASE alt-ped.

            CREATE ParcelaManualR.
            ASSIGN ParcelaManualR.SequenciaParcela = tt-prazo-compra.parcela.

            RUN pi-analisa-parcela (INPUT tt-prazo-compra.numero-ordem,
                                    INPUT tt-prazo-compra.parcela).
        END.

    END.
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    RETURN "OK".
END.

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

        /*S¢ analisa se for uma criaá∆o*/
        ASSIGN int-analise-ordem-compra.log-analisada = YES.
    END.

    IF msg0223.MotivoAlteracao <> ? THEN                                             
         ASSIGN int-analise-ordem-compra.num-livre-2 = msg0223.MotivoAlteracao.       

    RELEASE int-analise-ordem-compra.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
