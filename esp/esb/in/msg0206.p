CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* def var iXML as LONGCHAR .                                                      */
/* def var oXML as LONGCHAR .                                                      */
/*                                                                                 */
/* ASSIGN iXML = '<?xml version="1.0" encoding="UTF-8"?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>499810-104-ma053972</NumeroOperacao>                        */
/*     <CodigoMensagem>MSG0206</CodigoMensagem>                                    */
/*     <LoginUsuario>ma053972</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0206>                                                                   */
/*       <NumeroEmbarque>499810</NumeroEmbarque>                                   */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*       <MatriculaUsuario>ma053972</MatriculaUsuario>                             */
/*       <I18N>false</I18N>                                                        */
/*     </MSG0206>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>'.                                                                   */

{esp/esb/in/msg0206.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}

DEFINE TEMP-TABLE tt-li-recarrega NO-UNDO LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.

DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.
DEFINE BUFFER b2-ordem-compra   FOR ordem-compra.
DEFINE BUFFER b-cotacao-item    FOR cotacao-item.
DEFINE VARIABLE v-cod-cond-pag LIKE cond-pagto.cod-cond-pag.


DEFINE VARIABLE de-unit AS DECIMAL DECIMALS 4    NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0206
   DATA-RELATION FOR conteudo, msg0206 RELATION-FIELDS (idm, idm)         NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0206R1, Embarque, FinanceiroFiscal, PontoControle, ParcelaEmbarque, Despesa, CommercialInvoice, LI, resultado
   DATA-RELATION FOR conteudor, msg0206R1           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0206R1, Embarque            RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  FinanceiroFiscal    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  PontoControle       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  ParcelaEmbarque     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  Despesa             RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  CommercialInvoice   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Embarque,  LI                  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0206R1, resultado           RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0206R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0206 NO-ERROR.

CREATE conteudor.
CREATE msg0206R1.
CREATE resultado.

/* Faz as leituras e monta o XML de retorno */
RUN pi-embarque.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-embarque:

    DEFINE VARIABLE h-bocx220         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE de-valor-embarque AS DECIMAL DECIMALS 4    NO-UNDO.
    DEFINE VARIABLE i-mo-codigo       LIKE moeda.mo-codigo.
    DEFINE VARIABLE l-recebimento     AS LOGICAL     NO-UNDO.

    DEFINE BUFFER b-historico-embarque  FOR historico-embarque. /*Primeiro ponto de controle do embarque*/
    DEFINE BUFFER b2-historico-embarque FOR historico-embarque. /*Ponto de Entrega (Despacho)*/
    DEFINE BUFFER b3-historico-embarque FOR historico-embarque. /*Ponto de Chegada*/
    DEFINE BUFFER b4-historico-embarque FOR historico-embarque. /*Primeiro ponto de controle n∆o efetivado*/
    DEFINE BUFFER b5-historico-embarque FOR historico-embarque. /*Ponto de Embarque*/
    DEFINE BUFFER b-emitente            FOR emitente. /*cod-despachante       */
    DEFINE BUFFER b1-emitente           FOR emitente. /*cdn-despa-exter-import*/
    DEFINE BUFFER b2-emitente           FOR emitente. /*cdn-segurad-import    */
    DEFINE BUFFER b3-emitente           FOR emitente. /*cdn-corretor-import   */

    ASSIGN MSG0206R1.ExibePrecos = fnExibePrecos(MSG0206.MatriculaUsuario).

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = msg0206.CodigoEstabelecimento
           AND embarque-imp.embarque    = msg0206.NumeroEmbarque NO-ERROR.

    IF AVAIL embarque-imp THEN DO:

        /*Primeiro ponto de controle do embarque*/
        FIND FIRST b-historico-embarque NO-LOCK
             WHERE b-historico-embarque.cod-estabel = embarque-imp.cod-estabel
               AND b-historico-embarque.embarque    = embarque-imp.embarque NO-ERROR.

        /*Itinerario do embarque*/
        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = b-historico-embarque.cod-itiner NO-ERROR.

        FIND FIRST int-itinerario NO-LOCK
             WHERE int-itinerario.cod-itiner = itinerario.cod-itiner NO-ERROR.

        /*Ultimo Ponto de controle efetivado*/
        FOR LAST historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
             AND historico-embarque.embarque    = embarque-imp.embarque
             AND historico-embarque.dt-efetiva <> ?
           BREAK BY historico-embarque.dt-efetiva:
        END.

        /*Ultimo Ponto de controle efetivado*/
        FIND FIRST pto-contr NO-LOCK
             WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

        /*Ponto de Chegada*/ 
        FIND FIRST b3-historico-embarque NO-LOCK
             WHERE b3-historico-embarque.cod-estabel   = embarque-imp.cod-estabel
               AND b3-historico-embarque.embarque      = embarque-imp.embarque
               AND b3-historico-embarque.cod-itiner    = itinerario.cod-itiner
               AND b3-historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.

        /*Ponto de Entrega (Despacho)*/
        FIND FIRST b2-historico-embarque NO-LOCK
             WHERE b2-historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
               AND b2-historico-embarque.embarque      = embarque-imp.embarque    
               AND b2-historico-embarque.cod-itiner    = itinerario.cod-itiner    
               AND b2-historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.

        /*Primeiro ponto de controle n∆o efetivado*/
        FIND FIRST b4-historico-embarque NO-LOCK
             WHERE b4-historico-embarque.cod-estabel   = embarque-imp.cod-estabel
               AND b4-historico-embarque.embarque      = embarque-imp.embarque   
               AND b4-historico-embarque.cod-itiner    = itinerario.cod-itiner   
               AND b4-historico-embarque.dt-efetiva    = ?  NO-ERROR.

        FIND FIRST b5-historico-embarque NO-LOCK
             WHERE b5-historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
               AND b5-historico-embarque.embarque      = embarque-imp.embarque
               AND b5-historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

        /*Calcula Valor Embarque*/
        IF NOT VALID-HANDLE(h-bocx220) THEN
            RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

        RUN retornaMoedaValor IN h-bocx220 (INPUT  embarque-imp.embarque,
                                            INPUT  embarque-imp.cod-estabel,
                                            OUTPUT de-valor-embarque,
                                            OUTPUT i-mo-codigo).

        /*Desconta valor das parcelas FOC*/
        FOR EACH b-ordens-embarque OF embarque-imp NO-LOCK,
           FIRST b2-ordem-compra OF b-ordens-embarque 
           WHERE b2-ordem-compra.cod-cond-pag = 63 NO-LOCK:
            FIND FIRST b-cotacao-item
                 WHERE b-cotacao-item.numero-ordem = b2-ordem-compra.numero-ordem
                   AND b-cotacao-item.it-codigo    = b2-ordem-compra.it-codigo
                   AND b-cotacao-item.cod-emitente = b2-ordem-compra.cod-emitente
                   AND b-cotacao-item.cot-aprovada = yes no-lock no-error.

            ASSIGN de-unit = 0.
            IF AVAIL b-cotacao-item THEN
                ASSIGN de-unit = (b-cotacao-item.pre-unit-for * 100) / (100 + b-cotacao-item.aliquota-ipi).

            ASSIGN de-valor-embarque = de-valor-embarque - (b-ordens-embarque.qt-do-forn * de-unit).
        END.

        DELETE PROCEDURE h-bocx220.

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = i-mo-codigo NO-ERROR.

        FIND FIRST transporte NO-LOCK
             WHERE transporte.cod-transp = embarque-imp.cod-transportador NO-ERROR.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = embarque-imp.cdn-corretor-cambio-import NO-ERROR.

        FIND FIRST b-emitente NO-LOCK
             WHERE b-emitente.cod-emitente = embarque-imp.cod-despachante NO-ERROR.

        FIND FIRST b1-emitente NO-LOCK
             WHERE b1-emitente.cod-emitente = embarque-imp.cdn-despa-exter-import NO-ERROR.

        FIND FIRST b2-emitente NO-LOCK
             WHERE b2-emitente.cod-emitente = embarque-imp.cdn-segurad-import NO-ERROR.

        FIND FIRST b3-emitente NO-LOCK
             WHERE b3-emitente.cod-emitente = embarque-imp.cdn-corretor-import NO-ERROR.

        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.

        FIND FIRST b-moeda NO-LOCK 
             WHERE b-moeda.mo-codigo = ext-embarque-imp.CodigoMoedaEMS NO-ERROR.

        FIND FIRST mgcad.banco NO-LOCK
             WHERE mgcad.banco.cod-banco = embarque-imp.cod-banco NO-ERROR.

        /*Respons†vel, comprador da primeira parcela do embarque*/
        FIND FIRST ordens-embarque OF embarque-imp    NO-LOCK NO-ERROR.
        FIND FIRST ordem-compra    OF ordens-embarque NO-LOCK NO-ERROR.

        /*Retorno*/
        CREATE Embarque.
        ASSIGN Embarque.CodigoEstabelecimento        = embarque-imp.cod-estabel
               Embarque.NumeroEmbarque               = embarque-imp.embarque
               Embarque.EmbarqueContabilizado        = embarque-imp.contabilizado
               Embarque.CodigoUltimoPontoControle    = IF AVAIL pto-contr THEN pto-contr.cod-pto-contr ELSE ?
               Embarque.DescricaoUltimoPontoControle = IF AVAIL pto-contr THEN pto-contr.descricao     ELSE ?
               Embarque.DataUltimoPontoControle      = IF AVAIL historico-embarque THEN historico-embarque.dt-efetiva ELSE ?
               Embarque.CodigoItinerario             = IF AVAIL itinerario THEN itinerario.cod-itiner ELSE ?
               Embarque.DescricaoItinerario          = IF AVAIL itinerario THEN itinerario.descricao  ELSE ?
               Embarque.ValorEmbarque                = de-valor-embarque
               Embarque.Narrativa                    = embarque-imp.narrativa
               Embarque.Atrasado                     = IF AVAIL b4-historico-embarque THEN
                                                           IF b4-historico-embarque.dt-ult-prev >= TODAY THEN NO ELSE YES
                                                       ELSE
                                                           NO
               Embarque.CodigoViaTransporte          = embarque-imp.cod-via-transp
               Embarque.CodigoIncoterm               = embarque-imp.cod-incoterm
               Embarque.DataNecessidadeFabrica       = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.DataNecessidadeFabrica ELSE ?
               Embarque.Master                       = embarque-imp.cod-conhecto-master
               Embarque.House                        = embarque-imp.cod-conhecto-house
               Embarque.CodigoTransportadora         = embarque-imp.cod-transportador
               Embarque.NomeTransportadora           = IF AVAIL transporte THEN transporte.nome-abrev   ELSE ""
               Embarque.CodigoCorretorCambio         = embarque-imp.cdn-corretor-cambio-import
               Embarque.NomeCorretorCambio           = IF AVAIL emitente THEN emitente.nome-abrev       ELSE ""
               Embarque.CodigoDespachante            = embarque-imp.cod-despachante
               Embarque.NomeDespachante              = IF AVAIL b-emitente THEN b-emitente.nome-abrev   ELSE ""
               Embarque.CodigoDespachanteExterior    = embarque-imp.cdn-despa-exter-import
               Embarque.NomeDespachanteExterior      = IF AVAIL b1-emitente THEN b1-emitente.nome-abrev ELSE ""
               Embarque.CodigoSeguradora             = embarque-imp.cdn-segurad-import
               Embarque.NomeSeguradora               = IF AVAIL b2-emitente THEN b2-emitente.nome-abrev ELSE ""
               Embarque.CodigoCorretorSeguro         = embarque-imp.cdn-corretor-import
               Embarque.NomeCorretorSeguro           = IF AVAIL b3-emitente THEN b3-emitente.nome-abrev ELSE ""
               Embarque.TipoContainer                = IF AVAIL ext-embarque-imp AND ext-embarque-imp.conteiner <> 0 THEN ext-embarque-imp.conteiner ELSE ?
               Embarque.Quantidade1Container         = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd-conteiner  ELSE ?
               Embarque.Quantidade2Container         = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd2-conteiner ELSE ?
               Embarque.PossuiAnexos                 = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.PossuiAnexos   ELSE ?
               Embarque.StatusEmbarque               = embarque-imp.situacao
               Embarque.LogItinerarioIntegraComex    = IF AVAIL int-itinerario   THEN int-itinerario.log-integra-comex      ELSE NO
               Embarque.LogEnvioComex                = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.log-envio-comex      ELSE NO
               Embarque.LogLiberaAlteracaoComex      = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.log-libera-alteracao ELSE YES 
               Embarque.LogLiberaModalComex          = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.log-libera-modal     ELSE YES
               Embarque.FinalidadeCourier            = ext-embarque-imp.finalidade-currier
               /*Embarque.DataEmbarque                 = IF AVAIL b5-historico-embarque 
                                                       AND b5-historico-embarque.dt-efetiva <> ? THEN 
                                                           b5-historico-embarque.dt-efetiva 
                                                       ELSE IF AVAIL b5-historico-embarque THEN
                                                           b5-historico-embarque.dt-ult-prev
                                                       ELSE 
                                                           ?*/.


        

        RUN esp/es0018p.p (INPUT "CondPagEmbar":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN v-cod-cond-pag = ?.
        blk_cond_pag:
        FOR EACH b-ordens-embarque OF embarque-imp NO-LOCK,
            EACH b2-ordem-compra OF b-ordens-embarque 
           WHERE b2-ordem-compra.cod-cond-pag <> 63 NO-LOCK:
            /*N∆o considera as condiá‰es de pagamento deste ponto*/
            IF NOT CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(b2-ordem-compra.cod-cond-pag)) THEN DO:
                ASSIGN v-cod-cond-pag = b2-ordem-compra.cod-cond-pag.
                LEAVE blk_cond_pag.
            END.
        END.

        IF v-cod-cond-pag = ? AND AVAIL ordem-compra THEN
            ASSIGN v-cod-cond-pag = ordem-compra.cod-cond-pag.

        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = v-cod-cond-pag NO-ERROR.

        ASSIGN Embarque.CodigoCondicaoPagamento = IF AVAIL cond-pagto  THEN cond-pagto.cod-cond-pag ELSE ?
               Embarque.NomeCondicaoPagamento   = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".

        IF  AVAIL ext-embarque-imp 
        AND ext-embarque-imp.MatriculaResponsavel <> "" THEN DO:
            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = ext-embarque-imp.MatriculaResponsavel NO-ERROR.

            ASSIGN Embarque.MatriculaResponsavel = ext-embarque-imp.MatriculaResponsavel
                   Embarque.NomeResponsavel      = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".
        END.
        ELSE DO:
            IF AVAIL ordem-compra THEN DO:
               FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = ordem-compra.cod-comprado NO-ERROR.
               
               ASSIGN Embarque.MatriculaResponsavel = IF AVAIL ordem-compra THEN ordem-compra.cod-comprado ELSE ?
                      Embarque.NomeResponsavel      = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario  ELSE "".
            END.
            
        END.

        RUN pi-situacao.
        ASSIGN Embarque.SituacaoEmbarque = IF AVAIL tt-emb THEN tt-emb.situacao      ELSE 1.
        
        /*Ponto de Chegada*/ 
        IF AVAIL b2-historico-embarque THEN DO:
            IF b2-historico-embarque.dt-efetiva <> ? THEN
                ASSIGN Embarque.DataPrevisaoEntrega = b2-historico-embarque.dt-efetiva.
            ELSE 
                ASSIGN Embarque.DataPrevisaoEntrega = b2-historico-embarque.dt-ult-previsao.
        END.
        ELSE 
            ASSIGN Embarque.DataPrevisaoEntrega = ?.

        /*Ponto de Chegada*/ 
        IF AVAIL b3-historico-embarque THEN DO:
            IF b3-historico-embarque.dt-efetiva <> ? THEN
                ASSIGN Embarque.DataPrevisaoChegada = b3-historico-embarque.dt-efetiva.
            ELSE 
                ASSIGN Embarque.DataPrevisaoChegada = b3-historico-embarque.dt-ult-previsao.
        END.
        ELSE 
            ASSIGN Embarque.DataPrevisaoChegada = ?.

        CREATE FinanceiroFiscal.
        ASSIGN FinanceiroFiscal.ROF                         = embarque-imp.nr-rof
               FinanceiroFiscal.DISiscomex                  = embarque-imp.declaracao-import  
               FinanceiroFiscal.DIEMS                       = embarque-imp.int-2
               FinanceiroFiscal.DataDI                      = embarque-imp.data-di
               FinanceiroFiscal.NaturezaCambial             = embarque-imp.int-1
               FinanceiroFiscal.CodigoBanco                 = embarque-imp.cod-banco
               FinanceiroFiscal.NomeBanco                   = IF AVAIL banco THEN banco.nome-banco ELSE ""
               FinanceiroFiscal.NumeroCartaCredito          = embarque-imp.carta-credito
               FinanceiroFiscal.DataSolicitacaoCartaCredito = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.DataSolicitacaoCartaCredito ELSE ?
               FinanceiroFiscal.DataAprovacaoCartaCredito   = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.DataAprovacaoCartaCredito   ELSE ?
               FinanceiroFiscal.DataValidadeCartaCredito    = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.DataValidadeCartaCredito    ELSE ?
               FinanceiroFiscal.DeadlineCartaCredito        = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.DeadlineCartaCredito        ELSE ?
               FinanceiroFiscal.ValorCartaCredito           = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.ValorCartaCredito           ELSE ?
               FinanceiroFiscal.CodigoMoedaEMS              = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.CodigoMoedaEMS              ELSE ?
               FinanceiroFiscal.NomeMoeda                   = IF AVAIL b-moeda THEN b-moeda.descricao ELSE ?.

        IF NOT VALID-HANDLE(h-bocx384) THEN
            RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.

        IF NOT VALID-HANDLE(h-bocx120) THEN
            RUN cxbo/bocx120.p PERSISTENT SET h-bocx120.                             

        FOR EACH historico-embarque 
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque   
              AND historico-embarque.cod-itiner    = itinerario.cod-itiner NO-LOCK:

            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

            RUN validaIntegraPtoDi IN h-bocx384 (INPUT historico-embarque.embarque,
                                                 INPUT historico-embarque.cod-estabel,
                                                 INPUT historico-embarque.cod-pto-contr,
                                                 OUTPUT l-integra-di).

            ASSIGN clocal = "".


            FOR FIRST pto-itiner NO-LOCK
                WHERE pto-itiner.cod-itiner    = historico-embarque.cod-itiner
                AND   pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr:

                /*
                RUN setalocais in h-bocx120 (input ROWID(pto-itiner),
                                             output l-eadi,
                                             OUTPUT l-recebimento,
                                             output clocal).
                */

                if embarque-imp.cdn-pto-chegad = pto-itiner.cod-pto-contr
                THEN assign 
                   cLocal = "Entrada". //6
                
                if  itinerario.pto-despacho = pto-itiner.cod-pto-contr 
                then assign 
                  cLocal = "Despacho". //1
                
                if  itinerario.pto-embarque = pto-itiner.cod-pto-contr 
                OR  int-itinerario.cdn-pto-embarque2 = pto-itiner.cod-pto-contr 
                then assign 
                   cLocal = "Embarque". //3

                
                /*
                if itinerario.pto-chegada     = pto-itiner.cod-pto-contr 
                then assign 
                   cLocal = "Chegada". //7
                */
                
                if itinerario.pto-desembarque  = pto-itiner.cod-pto-contr 
                then assign 
                   cLocal = "Narcionalizacao". //5
                
                
                IF itinerario.cdn-pto-solic-licenciam-import = pto-itiner.cod-pto-contr 
                THEN ASSIGN
                   cLocal = "invoice". //5
                
                if itinerario.int-1 = pto-itiner.cod-pto-contr 
                then assign 
                   l-eadi = yes. //4


                FIND FIRST int-itinerario NO-LOCK
                     WHERE int-itinerario.cod-itiner = historico-embarque.cod-itiner
                     NO-ERROR.
                IF AVAIL int-itinerario
                THEN DO:
                    IF int-itinerario.cdn-pto-liberacao = pto-itiner.cod-pto-contr            
                    then assign 
                       cLocal = "Liberacao". //8
                    IF int-itinerario.cdn-pto-instrucao = pto-itiner.cod-pto-contr            
                    then assign 
                       cLocal = "Instrucao". //9

                    IF pto-itiner.cod-pto-contr         = int-itinerario.cdn-pto-chegada1 
                    OR pto-itiner.cod-pto-contr         = int-itinerario.cdn-pto-chegada2 
                    THEN ASSIGN
                       cLocal = "Chegada". //7

                END.

            END.            

            CREATE PontoControle.
            ASSIGN PontoControle.CodigoPontoControle             = historico-embarque.cod-pto-contr
                   PontoControle.SequenciaPontoControle          = historico-embarque.sequencia
                   PontoControle.DescricaoPontoControle          = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
                   PontoControle.DataPrevOriginalPontoControle   = historico-embarque.dt-previsao
                   PontoControle.DataUltimaPrevisaoPontoControle = historico-embarque.dt-ult-previsao
                   PontoControle.DataEfetivaPontoControle        = historico-embarque.dt-efetiva
                   PontoControle.VeiculoTransporte               = historico-embarque.id-meio-transp
                   PontoControle.ObservacoesPontoControle        = historico-embarque.observacao
                   PontoControle.IntegrouDI                      = l-integra-di.


            IF l-eadi THEN
                ASSIGN PontoControle.CodigoTipoPontoControle = 4. /* EADI */
            ELSE DO:
/*
                run getParameterLI in h-bocx120 (output l-solicita-li).

                IF l-solicita-li THEN
                    ASSIGN PontoControle.CodigoTipoPontoControle = 2. /* Solicitaá∆o de LI */
                ELSE DO:
*/                
                   CASE clocal:
                        WHEN "despacho" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 1. /* Despacho * */
                        WHEN "embarque" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 3. /* Embarque * */
                        WHEN "Narcionalizacao" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 5. /* Nacionalizacao * */
                        WHEN "entrada" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 6. /* Ponto de Entrada */
                        WHEN "chegada" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 7. /* Ponto de Chegada * */
                        WHEN "liberacao" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 8. /* Ponto de Liberaá∆o */
                        WHEN "instrucao" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 9. /* Ponto de Instruá∆o */
                        WHEN "invoice" THEN
                             ASSIGN PontoControle.CodigoTipoPontoControle = 10. /* Ponto Invoice */
                        OTHERWISE
                             ASSIGN PontoControle.CodigoTipoPontoControle = ?.
                   END CASE.
//                END.


            END.
            
            FOR EACH desp-embarque OF historico-embarque NO-LOCK:

                FIND FIRST moeda OF desp-embarque NO-LOCK NO-ERROR.

                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = desp-embarque.cod-emitente-desp NO-ERROR.

                FIND FIRST cond-pagto NO-LOCK
                     WHERE cond-pagto.cod-cond-pag = desp-embarque.cod-cond-pag NO-ERROR.

                FIND FIRST desp-imp NO-LOCK
                     WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-ERROR.

                CREATE Despesa.
                ASSIGN Despesa.CodigoDespesa           = desp-embarque.cod-desp
                       Despesa.DescricaoDespesa        = IF AVAIL desp-imp THEN desp-imp.descricao     ELSE ""
                       Despesa.CodigoPontoControle     = desp-embarque.cod-pto-contr
                       Despesa.DescricaoPontoControle  = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
                       Despesa.CodigoFornecedorEMS     = desp-embarque.cod-emitente-desp
                       Despesa.NomeAbreviadoFornecedor = IF AVAIL emitente THEN emitente.nome-abrev    ELSE ""
                       Despesa.CodigoCondicaoPagamento = desp-embarque.cod-cond-pag
                       Despesa.NomeCondicaoPagamento   = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                       Despesa.CodigoMoedaEMS          = desp-embarque.mo-codigo
                       Despesa.NomeMoeda               = IF AVAIL moeda THEN moeda.descricao ELSE ""
                       Despesa.ValorDespesa            = desp-embarque.val-desp.
            END.
        END.

        DELETE PROCEDURE h-bocx384.
        ASSIGN h-bocx384 = ?.
        DELETE PROCEDURE h-bocx120.
        ASSIGN h-bocx120 = ?.

        /*Busca LI's do embarque*/
        run cxbo/bocx351.p persistent set h-bocx351.

        EMPTY TEMP-TABLE tt-li-recarrega.
        RUN piRetornaLi IN h-bocx351 (INPUT 2,  /*Embarque Importacao*/
                                      INPUT YES,
                                      INPUT ?,  /*Processo Importacao*/
                                      INPUT embarque-imp.cod-estabel,
                                      INPUT embarque-imp.embarque,
                                      INPUT ?,   /*Parcela*/
                                      INPUT NO,  /*Considera Parcelas Eliminadas*/
                                      INPUT YES, /*Considera Parcelas Recebidas*/
                                      INPUT 0,                  /*Ordem ini*/
                                      INPUT 99999999,           /*Ordem fim*/
                                      INPUT "",                 /*it-codigo ini*/
                                      INPUT "ZZZZZZZZZZZZZZZZ", /*it-codigo fim*/
                                      INPUT "",                 /*class fisal ini*/
                                      INPUT "999999999",        /*class fisal ini*/
                                      INPUT "", /*LI ini*/
                                      INPUT "ZZZZZZZZZZZZZZZZZZZZ", /*LI fim*/
                                      OUTPUT TABLE tt-li-recarrega).
                                                               

        IF  VALID-HANDLE (h-bocx351) THEN DO:
            DELETE PROCEDURE h-bocx351.
            ASSIGN h-bocx351 = ?.
        END.

       FOR EACH tt-li-recarrega:
            FIND FIRST prazo-compra NO-LOCK
                 WHERE prazo-compra.numero-ordem = tt-li-recarrega.numero-ordem  
                   AND prazo-compra.parcela      = tt-li-recarrega.parcela NO-ERROR.

            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = tt-li-recarrega.numero-ordem  NO-ERROR.

            FIND FIRST int-licenciam-import-oc NO-LOCK
                 WHERE int-licenciam-import-oc.numero-ordem = prazo-compra.numero-ordem 
                   AND int-licenciam-import-oc.parcela      = prazo-compra.parcela NO-ERROR.

            CREATE LI.
            ASSIGN LI.NumeroOrdemCompra        = tt-li-recarrega.numero-ordem
                   LI.SequenciaParcela         = tt-li-recarrega.parcela
                   LI.QuantidadeParcela        = prazo-compra.quantidade
                   LI.CodigoProduto            = tt-li-recarrega.cod-livre-1
                   LI.NumeroProcessoImportacao = IF AVAIL ordem-compra THEN ordem-compra.num-pedido ELSE 0 /*Numero do pedido ou do processo de importaá∆o*/
                   LI.NCM                      = trim(tt-li-recarrega.cod-livre-2)
                   LI.NumeroLI                 = tt-li-recarrega.licenca-import
                   LI.ValidadeLI               = IF AVAIL int-licenciam-import-oc THEN int-licenciam-import-oc.validade-li ELSE ?.
        END.

        FOR EACH ordens-embarque OF embarque-imp NO-LOCK:
            FIND FIRST prazo-compra OF ordens-embarque   NO-LOCK NO-ERROR.
            FIND FIRST ordem-compra OF prazo-compra      NO-LOCK NO-ERROR.
            FIND FIRST pedido-compr OF ordem-compra      NO-LOCK NO-ERROR.
            FIND FIRST cond-pagto   OF pedido-compr      NO-LOCK NO-ERROR.
            FIND FIRST cotacao-item OF ordem-compra      NO-LOCK NO-ERROR.
            FIND FIRST moeda        OF cotacao-item      NO-LOCK NO-ERROR.
            FIND FIRST ITEM         OF ordem-compra      NO-LOCK NO-ERROR.
            FIND FIRST emitente     OF ordem-compra      NO-LOCK NO-ERROR.
            FIND FIRST item-fornec-estab OF ordem-compra NO-LOCK NO-ERROR.

            FIND FIRST tt-li-recarrega NO-LOCK
                 WHERE tt-li-recarrega.numero-ordem = prazo-compra.numero-ordem 
                   AND tt-li-recarrega.parcela      = prazo-compra.parcela NO-ERROR.

            FIND FIRST moeda NO-LOCK
                 WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.

            /*Informaá‰es de ordens que devem estar junto com embarque no XML*/
            ASSIGN Embarque.CodigoMoedaEMS          = cotacao-item.mo-codigo
                   Embarque.NomeMoeda               = moeda.descricao
                   Embarque.CodigoFornecedorEMS     = pedido-compr.cod-emitente
                   Embarque.NomeAbreviadoFornecedor = emitente.nome-abrev.

            /*IF Embarque.CodigoCondicaoPagamento = 0
            OR Embarque.CodigoCondicaoPagamento = 63 THEN DO:
                ASSIGN Embarque.CodigoCondicaoPagamento = pedido-compr.cod-cond-pag
                       Embarque.NomeCondicaoPagamento   = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".
            END.*/

            RUN pi-busca-criticidade.

            CREATE ParcelaEmbarque.
            ASSIGN ParcelaEmbarque.NumeroPedidoCompra            = IF AVAIL ordem-compra THEN ordem-compra.num-pedido ELSE 0
                   ParcelaEmbarque.NumeroOrdemCompra             = prazo-compra.numero-ordem
                   ParcelaEmbarque.SequenciaParcela              = prazo-compra.parcela
                   ParcelaEmbarque.CodigoProduto                 = prazo-compra.it-codigo
                   ParcelaEmbarque.QuantidadeParcela             = prazo-compra.quantidade
                   ParcelaEmbarque.DataParcela                   = prazo-compra.data-entrega
                   ParcelaEmbarque.CodigoUnidadeMedida           = prazo-compra.un
                   ParcelaEmbarque.QuantidadeFornecedor          = prazo-compra.qtd-do-forn
                   ParcelaEmbarque.CodigoUnidadeMedidaFornecedor = IF AVAIL cotacao-item THEN cotacao-item.un ELSE ""
                   ParcelaEmbarque.NecessitaLI                   = item.log-necessita-li
                   ParcelaEmbarque.CodigoCondicaoPagamento       = pedido-compr.cod-cond-pag
                   ParcelaEmbarque.NomeCondicaoPagamento         = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                   ParcelaEmbarque.NCM                           = /*cotacao-item.class-fiscal*/ trim(SUBSTRING(cotacao-item.char-1, 81, 10))
                   ParcelaEmbarque.NivelCriticidade              = IF AVAIL int-criticidade-item THEN int-criticidade-item.nivel-criticidade ELSE ?
                   ParcelaEmbarque.PrecoFornecedor               = IF AVAIL ordem-compra THEN ordem-compra.preco-fornec ELSE 0 
                   ParcelaEmbarque.ValorParcela                  = IF AVAIL ordem-compra THEN ordem-compra.preco-fornec * prazo-compra.qtd-do-forn ELSE 0
                   ParcelaEmbarque.CodigoMoedaEMS                = IF AVAIL ordem-compra THEN ordem-compra.mo-codigo ELSE 0
                   ParcelaEmbarque.NomeMoeda                     = IF AVAIL moeda THEN moeda.descricao ELSE ""
                   ParcelaEmbarque.NumeroLI                      = IF AVAIL tt-li-recarrega THEN tt-li-recarrega.licenca-import ELSE ?.

              IF msg0206.I18N AND ITEM.desc-inter <> "" THEN
                  ASSIGN ParcelaEmbarque.NomeProduto = ITEM.desc-inter.
              ELSE 
                  IF AVAIL ordem-compra THEN
                     ASSIGN ParcelaEmbarque.NomeProduto = IF ordem-compra.narrativa = "" THEN (IF AVAIL ITEM THEN ITEM.desc-item ELSE ?) ELSE STRING(ordem-compra.narrativa,"X(60)").


              FIND FIRST int-item-uni-estab NO-LOCK
                    WHERE int-item-uni-estab.it-codigo    = ITEM.it-codigo
                      AND int-item-uni-estab.cod-estabel  = embarque-imp.cod-estabel NO-ERROR.
              IF  AVAIL int-item-uni-estab THEN
                  ASSIGN ParcelaEmbarque.ObservacaoLogistica = int-item-uni-estab.observacao.   
            
        END.

        FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
        
            FIND FIRST pagamento-invoice NO-LOCK
                 WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                   AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                   AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.

            RELEASE pagamento.

            IF AVAIL pagamento-invoice THEN 
                FIND FIRST pagamento NO-LOCK 
                     WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-ERROR.

            CREATE CommercialInvoice.
            ASSIGN CommercialInvoice.NumeroCommercialInvoice  = invoice-emb-imp.nr-invoice 
                   CommercialInvoice.ParcelaCommercialInvoice = invoice-emb-imp.parcela
                   CommercialInvoice.DataCommercialInvoice    = invoice-emb-imp.dt-vencim
                   CommercialInvoice.ValorCommercialInvoice   = invoice-emb-imp.vl-invoice
                   CommercialInvoice.CodigoMoedaEMS           = invoice-emb-imp.mo-codigo
                   CommercialInvoice.NomeMoeda                = moeda.descricao
                   CommercialInvoice.DataFFT                  = IF AVAIL pagamento THEN pagamento.dat-fft        ELSE ?
                   CommercialInvoice.NumeroContratoCambio     = IF AVAIL pagamento THEN pagamento.nr-cont-cambio ELSE ""
                   CommercialInvoice.DataFechamentoCambio     = IF AVAIL pagamento THEN pagamento.dt-fecha-cam   ELSE ?
                   CommercialInvoice.Recebida                 = IF AVAIL pagamento THEN pagamento.recebido-ap    ELSE NO
                   CommercialInvoice.NumeroCIPagamento        = IF AVAIL pagamento-invoice THEN pagamento-invoice.nr-pagamento ELSE ?.

        END.

    END.
    ELSE DO:
        RUN pi-erro (INPUT "N∆o foi encontrado o embarque solicitado.").
    END.

END PROCEDURE.

                               
PROCEDURE pi-busca-criticidade:
           
    DEFINE VARIABLE i-cd-plano AS INTEGER   NO-UNDO.

    CASE pedido-compr.cod-estabel:
        WHEN "101" THEN
            ASSIGN i-cd-plano = 1.
        WHEN "104" THEN DO:
            IF ITEM.it-codigo >= "4000000" 
                AND ITEM.it-codigo <= "4999999" THEN
                ASSIGN i-cd-plano = 4.
            ELSE
                ASSIGN i-cd-plano = 41.
        END.
        WHEN "105" THEN
            ASSIGN i-cd-plano = 5.
        WHEN "106" THEN
            ASSIGN i-cd-plano = 6.
        WHEN "107" THEN
            ASSIGN i-cd-plano = 7.
    END CASE.


    FIND LAST int-criticidade-item NO-LOCK 
        WHERE int-criticidade-item.cod-estabel = pedido-compr.cod-estabel
          AND int-criticidade-item.cd-plano    = i-cd-plano
          AND int-criticidade-item.it-codigo   = ITEM.it-codigo NO-ERROR.
            
END PROCEDURE.                   


PROCEDURE pi-situacao :

    {esp/imp/esimp000.i}
    
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
