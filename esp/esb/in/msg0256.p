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
/*     <NumeroOperacao>CADASTRAR_CI_DO_FINANCEIRO</NumeroOperacao>                 */
/*     <CodigoMensagem>MSG0256</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0256>                                                                   */
/*       <CodigoSolicitacaoInterna>42135</CodigoSolicitacaoInterna>                */
/*       <Recebida>true</Recebida>                                                 */
/*       <MatriculaUsuarioRecebimento>ja050910</MatriculaUsuarioRecebimento>       */
/*       <DataRecebimento>2016-10-26</DataRecebimento>                             */
/*       <ValorContratoME>999999999.99</ValorContratoME>                           */
/*       <NaturezaCambial>1</NaturezaCambial>                                      */
/*       <ContratoCambio>2</ContratoCambio>                                        */
/*       <DataContratoCambio>2016-10-26</DataContratoCambio>                       */
/*       <CodigoSwift>lfkglrkorkrrrrrr</CodigoSwift>                               */
/*       <DataSwift>2016-10-26</DataSwift>                                         */
/*       <InstituicaoCambio>7895</InstituicaoCambio>                               */
/*       <PracaCambio>7892</PracaCambio>                                           */
/*       <TaxaCambioPagamento>99</TaxaCambioPagamento>                             */
/*       <TaxaCambio>99</TaxaCambio>                                               */
/*       <ValorContrato>999999.99</ValorContrato>                                  */
/*       <ValorOrdem>999999.99</ValorOrdem>                                        */
/*       <CodigoMoedaEMS>1</CodigoMoedaEMS>                                        */
/*       <ValorFechamento>999999.99</ValorFechamento>                              */
/*       <DataFechamentoCambio>2016-10-26</DataFechamentoCambio>                   */
/*     </MSG0256>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0256.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0256, HistoricoSolicitacaoInterna
   DATA-RELATION FOR conteudo, msg0256                    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0256, HistoricoSolicitacaoInterna RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0256R1, resultado
   DATA-RELATION FOR conteudor, msg0256R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0256R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0256R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0256 NO-ERROR.

CREATE conteudor.
CREATE msg0256R1.
CREATE resultado.

RUN pi-grava-pagamento.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

IF VALID-HANDLE(h-boes138)   THEN DO:
    DELETE PROCEDURE h-boes138.
                     h-boes138 = ?.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-grava-pagamento:
    blk_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_pagamento, LEAVE blk_pagamento
    ON STOP  UNDO blk_pagamento, LEAVE blk_pagamento: 

        RUN esbo/boes138.p  PERSISTENT SET h-boes138.
        RUN openQueryStatic IN h-boes138 (INPUT "Main":U).      
    
        RUN emptyRowErrors IN h-boes138.
        RUN goToKey        IN h-boes138 (INPUT msg0256.CodigoSolicitacaoInterna).

        IF RETURN-VALUE = "OK" THEN DO:
            RUN getRecord      IN h-boes138 (OUTPUT TABLE tt-pagamento).

            FIND FIRST tt-pagamento.

            RUN pi-popula-tt.

            RUN setRecord    IN h-boes138 (INPUT TABLE tt-pagamento).
            RUN updateRecord IN h-boes138.
            RUN getRowErrors IN h-boes138 (OUTPUT TABLE RowErrors).

            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription + " " + RowErrors.errorHelp).
                    UNDO blk_pagamento, LEAVE blk_pagamento.
                END. 
            END.
        END.
        ELSE DO:
            RUN pi-erro (INPUT "NÆo encontrado a SIP informada").       
        END.

        FOR EACH HistoricoSolicitacaoInterna:
            RUN pi-gera-historico (INPUT tt-pagamento.nr-pagamento,
                                   INPUT HistoricoSolicitacaoInterna.MatriculaUsuario,
                                   INPUT HistoricoSolicitacaoInterna.DataHistorico,
                                   INPUT HistoricoSolicitacaoInterna.HoraHistorico,
                                   INPUT HistoricoSolicitacaoInterna.AcaoHistorico,
                                   INPUT HistoricoSolicitacaoInterna.ObservacaoHistorico).
        END.

        IF CAN-FIND (tt-erro) THEN
            UNDO blk_pagamento, LEAVE blk_pagamento.
    END.

    IF CAN-FIND (tt-erro) THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-popula-tt:
    
    ASSIGN tt-pagamento.nr-pagamento         = msg0256.CodigoSolicitacaoInterna               
           tt-pagamento.recebido-ap          = msg0256.Recebida                               
           tt-pagamento.usuar-receb          = msg0256.MatriculaUsuarioRecebimento
           tt-pagamento.dat-receb-financ     = msg0256.DataRecebimento             
           tt-pagamento.valor-contrato-me    = msg0256.ValorContratoME             
           tt-pagamento.tipo-contr-cambio    = msg0256.NaturezaCambial             
           tt-pagamento.nr-cont-cambio       = msg0256.ContratoCambio              
           tt-pagamento.data-emissao         = msg0256.DataContratoCambio          
           tt-pagamento.instit-cambio        = msg0256.InstituicaoCambio           
           tt-pagamento.praca-cambio         = msg0256.PracaCambio                 
           tt-pagamento.taxa-cambio-pag      = msg0256.TaxaCambioPagamento         
           tt-pagamento.taxa-cambio          = msg0256.TaxaCambio                  
           tt-pagamento.valor-contrato       = msg0256.ValorContrato               
           tt-pagamento.valor-ord-pag        = msg0256.ValorOrdem                  
           tt-pagamento.cod-moeda            = msg0256.CodigoMoedaEMS              
           tt-pagamento.valor-fechamento     = msg0256.ValorFechamento             
           tt-pagamento.dt-fecha-cam         = msg0256.DataFechamentoCambio
           tt-pagamento.ind-natureza         = msg0256.NaturezaFinanceira            
           tt-pagamento.val-credit-note      = msg0256.CreditNote                    
           tt-pagamento.val-taxa-ptax        = msg0256.Ptax                          
           tt-pagamento.val-custo-fft-lc-usd = msg0256.CustoFftLcUsd                 
           tt-pagamento.val-custo-fft-lc-rs  = msg0256.CustoFftLcRs                  
           tt-pagamento.dat-custo-fft-lc     = msg0256.DataDebitoCustoFftLc.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-gera-historico:
    DEFINE INPUT PARAM p-nr-pagamento  AS INT.
    DEFINE INPUT PARAM p-cod-usuario   AS CHAR.
    DEFINE INPUT PARAM p-dat-hist      AS DATE.
    DEFINE INPUT PARAM p-hor-hist      AS CHAR.
    DEFINE INPUT PARAM p-ind-acao      AS INT.
    DEFINE INPUT PARAM p-txt-historico AS CHAR.

    DEFINE VARIABLE i-num-seq-hist AS INTEGER     NO-UNDO.

    FIND LAST int-hist-pagamento NO-LOCK
        WHERE int-hist-pagamento.nr-pagamento = p-nr-pagamento NO-ERROR.

    IF AVAIL int-hist-pagamento THEN
        ASSIGN i-num-seq-hist = int-hist-pagamento.num-seq-hist + 1.
    ELSE 
        ASSIGN i-num-seq-hist = 1.

   IF NOT CAN-FIND (FIRST pagamento 
                    WHERE pagamento.nr-pagamento = p-nr-pagamento) THEN DO:

       RUN pi-erro (INPUT "NÆo encontrado a SIP " + STRING(p-nr-pagamento)).
       RETURN "NOK".
   END.

   CREATE int-hist-pagamento.
   ASSIGN int-hist-pagamento.nr-pagamento  = p-nr-pagamento
          int-hist-pagamento.num-seq-hist  = i-num-seq-hist
          int-hist-pagamento.cod-usuario   = p-cod-usuario  
          int-hist-pagamento.dat-hist      = p-dat-hist     
          int-hist-pagamento.hor-hist      = p-hor-hist     
          int-hist-pagamento.ind-acao      = p-ind-acao     
          int-hist-pagamento.txt-historico = p-txt-historico.

   RELEASE int-hist-pagamento.

   RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
