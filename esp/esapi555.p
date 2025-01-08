&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esp/esapi505.i}

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi555 AS l NO-UNDO.

DEF VAR cJson        AS c        NO-UNDO.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi555 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.

DEF TEMP-TABLE ttCI NO-UNDO
   FIELD NumeroEmbarque      AS c   
   FIELD NumeroInvoice       AS c   
   FIELD MoedaJson           AS i   
   FIELD Valor               AS de.

DEFINE TEMP-TABLE PrevisaoFatura NO-UNDO XML-NODE-NAME 'PrevisaoFatura'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque         LIKE invoice-emb-imp.embarque   
   FIELD CodigoEstabelecimento  LIKE invoice-emb-imp.cod-estabel
   FIELD DataCommercialInvoice  LIKE invoice-emb-imp.dt-vencim
   FIELD ValorCommercialInvoice LIKE invoice-emb-imp.vl-invoice
   FIELD CodigoMoedaEMS         LIKE invoice-emb-imp.mo-codigo
   FIELD NomeMoeda              LIKE moeda.descricao.

DEFINE TEMP-TABLE CommercialInvoice NO-UNDO XML-NODE-NAME 'CommercialInvoice'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroCommercialInvoice  LIKE invoice-emb-imp.nr-invoice
   FIELD ParcelaCommercialInvoice LIKE invoice-emb-imp.parcela
   FIELD DataCommercialInvoice    LIKE invoice-emb-imp.dt-vencim
   FIELD ValorCommercialInvoice   LIKE invoice-emb-imp.vl-invoice
   FIELD CodigoMoedaEMS           LIKE invoice-emb-imp.mo-codigo.

DEF TEMP-TABLE tt-invoice-emb-imp NO-UNDO LIKE invoice-emb-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE MSG0254 NO-UNDO XML-NODE-NAME 'MSG0254'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento INITIAL ?
   FIELD DataEmissao                 LIKE pagamento.data-ci
   FIELD PrevFechaCambio             LIKE pagamento.dt-prev-fecha-cam
   FIELD Urgente                     LIKE pagamento.log-urgente
   FIELD CodigoFornecedorEMS         LIKE pagamento.cod-emitente
   FIELD CodigoEstabelecimento       LIKE pagamento.cod-estabel
   FIELD ValorSolicitacaoInterna     LIKE pagamento.valor-pag
   FIELD CodigoMoedaEMS              LIKE pagamento.cod-moeda
   FIELD TipoSolicitacaoInterna      LIKE pagamento.tipo-ci   
   FIELD StatusSolicitacaoInterna    LIKE pagamento.ind-status-solicitacao
   FIELD CodigoCondicaoPagamento     LIKE pagamento.cod-cond-pag
   FIELD CodigoTipoDespesa           LIKE pagamento.tipo-despesa
   FIELD MatriculaResponsavel        LIKE pagamento.usuario
   FIELD MatriculaComprador          LIKE pagamento.cod-comprador
   FIELD PossuiAnexos                AS LOG
   FIELD Observacoes                 LIKE pagamento.txt-observacao
   FIELD PagamentoAntecipado         LIKE pagamento.log-pag-antecipado
   FIELD HistoricoSolicitacaoInterna LIKE pagamento.historico
   FIELD CodigoDespachante           LIKE pagamento.cod-despachante
   .

DEFINE TEMP-TABLE MSG0255 NO-UNDO XML-NODE-NAME 'MSG0255'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento
   .

DEFINE TEMP-TABLE Fatura NO-UNDO XML-NODE-NAME 'Fatura'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE pagamento-invoice.embarque
   FIELD CodigoEstabelecimento LIKE embarque-imp.cod-estabel
   FIELD NumeroInvoice         LIKE pagamento-invoice.nr-invoice
   FIELD ParcelaInvoice        LIKE pagamento-invoice.parcela.
   .

DEFINE TEMP-TABLE HistoricoSolicitacaoInterna NO-UNDO XML-NODE-NAME 'HistoricoSolicitacaoInterna'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaUsuario    LIKE int-hist-pagamento.cod-usuario  
   FIELD DataHistorico       LIKE int-hist-pagamento.dat-hist     
   FIELD HoraHistorico       LIKE int-hist-pagamento.hor-hist     
   FIELD AcaoHistorico       LIKE int-hist-pagamento.ind-acao     
   FIELD ObservacaoHistorico LIKE int-hist-pagamento.txt-historico
   .


DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".


DEF VAR h-bocx295            AS HANDLE      NO-UNDO.
DEF VAR h-boes138            AS HANDLE      NO-UNDO.    

DEF VAR de-valor-invoice     AS DECIMAL     NO-UNDO.
DEF VAR d-dat-fft            AS DATE        NO-UNDO.
DEF VAR d-dt-prev-fecha-cam  AS DATE        NO-UNDO.
DEF VAR l-antecipado         AS LOGICAL     NO-UNDO.
DEF VAR da-base              AS DATE        NO-UNDO.

DEF VAR i-mo-codigo         LIKE moeda.mo-codigo         NO-UNDO.

DEF TEMP-TABLE auxRowErrors NO-UNDO
    LIKE RowErrors.


{esbo/boes138.i tt-pagamento}

DEF VAR v_cdn_empres_usuar AS c NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR lcInput    AS LONGCHAR         NO-UNDO.

DEF VAR jsonParser AS ObjectModelParser NO-UNDO.
DEF VAR jsonInput  AS JsonObject        NO-UNDO.

FOR FIRST es-api-log
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:

    ASSIGN
       es-api-log.dh-envio = NOW.

    COPY-LOB es-api-log.cl-envio TO lcInput.
    ASSIGN 
       jsonParser = NEW ObjectModelParser()
       jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Ponto de Controle").

    RUN pi-input-api-headers (jsonInput).
    RUN piProcessa.

    ASSIGN
       es-api-log.retorno-content-type = "application/json".

    IF TEMP-TABLE RowErrors:HAS-RECORDS = NO
    THEN ASSIGN
       es-api-log.cod-retorno = "200"
       es-api-log.aux         = "Integrado com sucesso".
    ELSE ASSIGN
       es-api-log.cod-retorno = "500".

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".


/*
{
  "numeroEmbarque": "478946f",
  "numeroInvoice": "1234rer46f",
  "moeda": 1058,
  "valor": 1582.66
}
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-erro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro Procedure 
PROCEDURE pi-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM c-erro AS CHAR.
    
   CREATE tt-erro.
   ASSIGN tt-erro.mensagem = c-erro.

   RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCalculaCampos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaCampos Procedure 
PROCEDURE piCalculaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAM p-nr-pagamento      LIKE pagamento.nr-pagamento.
   DEFINE OUTPUT PARAM p-dat-prev-fech-cam LIKE pagamento.dt-prev-fecha-cam INITIAL ?.
   DEFINE OUTPUT PARAM p-dat-fft           LIKE pagamento.dat-fft           INITIAL ?.
   DEFINE OUTPUT PARAM p-antecipado        AS LOGICAL                       INITIAL NO.

   DEF VAR i-dias AS INT NO-UNDO.
   FIND FIRST pagamento NO-LOCK 
        WHERE pagamento.nr-pagamento = p-nr-pagamento NO-ERROR.

   FIND FIRST pagamento-invoice NO-LOCK 
        WHERE pagamento-invoice.nr-pagamento = p-nr-pagamento NO-ERROR.

   IF AVAIL pagamento-invoice THEN DO:
       /*Busca dat-prev-fech-cam*/
       FIND FIRST invoice-emb-imp NO-LOCK 
            WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
              AND invoice-emb-imp.embarque    = pagamento-invoice.embarque
              AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
              AND invoice-emb-imp.parcela     = pagamento-invoice.parcela NO-ERROR.


       FIND FIRST int-cond-pagto NO-LOCK
            WHERE int-cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

       IF AVAIL invoice-emb-imp THEN DO:
           ASSIGN p-dat-prev-fech-cam = invoice-emb-imp.dt-vencim.

           /*Desconta 2 dias £teis*/
           IF  AVAIL int-cond-pagto AND int-cond-pagto.log-controla-fft THEN DO:
               ASSIGN i-dias = 0.
               REPEAT:
                   IF  i-dias = 2 THEN
                       LEAVE.
                   FIND FIRST calen-coml
                        WHERE calen-coml.cod-estabel = pagamento.cod-estabel
                          AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                          AND calen-coml.data        = p-dat-prev-fech-cam NO-LOCK NO-ERROR.
   
                   ASSIGN p-dat-prev-fech-cam = p-dat-prev-fech-cam - 1.
   
                   IF  (AVAIL calen-coml AND calen-coml.tipo-dia <> 1)
                   OR  (WEEKDAY(p-dat-prev-fech-cam) = 7 OR WEEKDAY(p-dat-prev-fech-cam) = 1) THEN
                       NEXT.
   
                   ASSIGN i-dias = i-dias + 1 .
               END.
           END.
           ELSE DO:
               REPEAT:
                   FIND FIRST calen-coml
                        WHERE calen-coml.cod-estabel = pagamento.cod-estabel
                          AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                          AND calen-coml.data        = p-dat-prev-fech-cam NO-LOCK NO-ERROR.
   
                   IF (AVAIL calen-coml AND calen-coml.tipo-dia = 1) THEN DO:
                       LEAVE.
                   END.
                   ELSE
                       IF  NOT AVAIL calen-coml AND (WEEKDAY(p-dat-prev-fech-cam) <> 7 AND WEEKDAY(p-dat-prev-fech-cam) <> 1) THEN
                           LEAVE.
                   ASSIGN p-dat-prev-fech-cam = p-dat-prev-fech-cam + 1.
               END.

           END.
       END.

       IF  AVAIL int-cond-pagto
       AND int-cond-pagto.log-controla-fft THEN DO:
           /*Busca dat-fft*/
           FIND FIRST ordens-embarque NO-LOCK
                WHERE ordens-embarque.cod-estabel = pagamento.cod-estabel
                  AND ordens-embarque.embarque    = invoice-emb-imp.embarque NO-ERROR.
   
           FIND FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
   
           FIND FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.
   
           FIND FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                  AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
   
           FIND FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                  AND historico-embarque.embarque    = ordens-embarque.embarque NO-ERROR.
   
           /*Ponto base da ordem*/
           FIND FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                  AND historico-embarque.embarque      = ordens-embarque.embarque
                  AND historico-embarque.cod-itiner    = historico-embarque.cod-itiner
                  AND historico-embarque.cod-pto-contr = int(SUBSTRING(cotacao-item.char-1,41,5)) NO-ERROR.
   
           IF  AVAIL historico-embarque THEN DO:
           
               IF historico-embarque.dt-efetiva <> ? THEN DO:
       
                   FIND FIRST tb-pr-cc NO-LOCK 
                        WHERE /*tb-pr-cc.cod-estabel  = pedido-compr.cod-estabel
                          AND*/ tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                          AND tb-pr-cc.cod-cond-pag = pagamento.cod-cond-pag
                          AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                          /*AND tb-pr-cc.dt-inicio   <= TODAY
                          AND tb-pr-cc.situacao     = 1*/ NO-ERROR.
       
                   IF NOT AVAIL tb-pr-cc THEN
                       FIND FIRST tb-pr-cc NO-LOCK 
                            WHERE tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                              AND tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag
                              AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                              /*AND tb-pr-cc.dt-inicio   <= TODAY 
                              AND tb-pr-cc.situacao     = 1*/ NO-ERROR.
                   
                   IF AVAIL tb-pr-cc THEN DO:
                       FIND FIRST int-tb-pr-cc OF tb-pr-cc NO-LOCK NO-ERROR.

                       ASSIGN p-dat-fft = (historico-embarque.dt-efetiva +  int-tb-pr-cc.num-dias-libera-fft). /*- 2*/
       
                       FOR FIRST cond-pagto NO-LOCK
                           WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag
                              AND cond-pagto.cod-vencto = 6 /*Fora Quinzena*/:
                               
                             IF  int-cond-pagto.log-controla-fft THEN DO:
                                 ASSIGN da-base = p-dat-fft 
                                        da-base = DATE(MONTH(da-base), 28, YEAR(da-base)) + 5
                                        da-base = DATE(MONTH(da-base), cond-pagto.dia-mes-venc, YEAR(da-base)).
                                 
                             END.
                             ELSE
                                 ASSIGN da-base = p-dat-fft.
                              
                       END.
                       IF  NOT AVAIL cond-pagto THEN
                           ASSIGN da-base = p-dat-fft.

                       /*Desconta 2 dias £teis*/
                       ASSIGN i-dias = 0.
                       REPEAT:
                           IF  i-dias = 2 THEN
                               LEAVE.

                           FIND FIRST calen-coml
                                WHERE calen-coml.cod-estabel = pedido-compr.cod-estabel
                                  AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                                  AND calen-coml.data        = da-base NO-LOCK NO-ERROR.

                           ASSIGN da-base = da-base - 1.

                           IF  (AVAIL calen-coml AND calen-coml.tipo-dia <> 1)
                           OR  (WEEKDAY(da-base) = 7 OR WEEKDAY(da-base) = 1) THEN
                               NEXT.
                           ASSIGN i-dias = i-dias + 1.

                       END.
                       
                       ASSIGN p-dat-fft = da-base.

                   END.
                   ELSE DO:
                       RUN pi-erro ("N∆o encontrado tabela de preáos para o c†lculo da data FFT").
                   END.
               END. /*historico-embarque.dt-efetiva <> ?*/
           END. /*AVAIL historico-embarque*/
       END.
   END.

   /*Pagamento antecipado*/
   ASSIGN p-antecipado = NO.
   
   blk_antecipado:
   FOR EACH pagamento-invoice NO-LOCK 
      WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

       FIND FIRST historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel = pagamento.cod-estabel
              AND historico-embarque.embarque    = pagamento-invoice.embarque NO-ERROR.
   
       FIND FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
   
       /*Verifica se o ponto de embarque est† efetivado*/
       FIND FIRST historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel   = pagamento.cod-estabel
              AND historico-embarque.embarque      = pagamento-invoice.embarque
              AND historico-embarque.cod-pto-contr = itinerario.pto-embarque 
              AND historico-embarque.dt-efetiva    <> ? NO-ERROR.
   
       IF AVAIL historico-embarque THEN DO:
           FIND FIRST invoice-emb-imp NO-LOCK
                WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
                  AND invoice-emb-imp.embarque    = pagamento-invoice.embarque       
                  AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
                  AND invoice-emb-imp.parcela     = pagamento-invoice.parcela    NO-ERROR.
   
           IF historico-embarque.dt-efetiva > invoice-emb-imp.dt-vencim THEN DO:
               ASSIGN p-antecipado = YES.
               LEAVE blk_antecipado.
           END.
       END.
       ELSE DO:
           ASSIGN p-antecipado = YES.
           LEAVE blk_antecipado.
       END.
   END.

   IF CAN-FIND (tt-erro) THEN
       RETURN "NOK".

   RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraFaturaEmbarque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraFaturaEmbarque Procedure 
PROCEDURE piGeraFaturaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN openQuery IN h-bocx295 (INPUT 1).
   
   FOR EACH CommercialInvoice:
      FIND FIRST invoice-emb-imp NO-LOCK
           WHERE invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
             AND invoice-emb-imp.embarque    = embarque-imp.embarque       
             AND invoice-emb-imp.nr-invoice  = CommercialInvoice.NumeroCommercialInvoice
             AND invoice-emb-imp.parcela     = "1"
           NO-ERROR.
      /*Criaá∆o*/

      MESSAGE ">> avail invoice-emb-imp                      " AVAIL invoice-emb-imp                    .
      MESSAGE ">> embarque-imp.cod-estabel                   " embarque-imp.cod-estabel                 . 
      MESSAGE ">> embarque-imp.embarque                      " embarque-imp.embarque                    . 
      MESSAGE ">> CommercialInvoice.NumeroCommercialInvoice  " CommercialInvoice.NumeroCommercialInvoice. 

      IF NOT AVAIL invoice-emb-imp 
      THEN DO:
         CREATE tt-invoice-emb-imp.                        
         ASSIGN tt-invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
                tt-invoice-emb-imp.embarque    = embarque-imp.embarque   
                tt-invoice-emb-imp.nr-invoice  = CommercialInvoice.NumeroCommercialInvoice      
                tt-invoice-emb-imp.parcela     = "1"                     
                tt-invoice-emb-imp.dt-vencim   = CommercialInvoice.DataCommercialInvoice     
                tt-invoice-emb-imp.vl-invoice  = CommercialInvoice.ValorCommercialInvoice    
                tt-invoice-emb-imp.mo-codigo   = CommercialInvoice.CodigoMoedaEMS.

         RUN validateCreate IN h-bocx295 ( INPUT TABLE tt-invoice-emb-imp,
                                          OUTPUT TABLE auxRowErrors,
                                          OUTPUT tt-invoice-emb-imp.r-rowid
                                          ).        
   
         IF CAN-FIND(FIRST auxRowErrors) 
         THEN DO:
            FOR EACH auxRowErrors:  
               CREATE RowErrors.
               BUFFER-COPY auxRowErrors TO RowErrors.
               MESSAGE ">>> Cria Fatura" RowErrors.ErrorDescription.
            END. 
            RETURN "NOK".
         END.    
      END.
      /*Alteraá∆o*/
      ELSE DO:
         CREATE tt-invoice-emb-imp.
         BUFFER-COPY invoice-emb-imp TO tt-invoice-emb-imp.

         ASSIGN 
            tt-invoice-emb-imp.dt-vencim   = CommercialInvoice.DataCommercialInvoice     
            tt-invoice-emb-imp.vl-invoice  = CommercialInvoice.ValorCommercialInvoice    
            tt-invoice-emb-imp.mo-codigo   = CommercialInvoice.CodigoMoedaEMS.

         RUN validateUpdate IN h-bocx295 (INPUT  TABLE tt-invoice-emb-imp,
                                          INPUT  ROWID(invoice-emb-imp),
                                          OUTPUT TABLE auxRowErrors
                                          ). 
   
         IF CAN-FIND(FIRST auxRowErrors) 
         THEN DO:
            FOR EACH auxRowErrors:  
               CREATE RowErrors.
               BUFFER-COPY auxRowErrors TO RowErrors.
               MESSAGE ">>> Altera Fatura" RowErrors.ErrorDescription.
            END. 
            RETURN "NOK".
         END.    
      END.
      IF AVAIL tt-invoice-emb-imp
      THEN DO:
         MESSAGE ">> tt-invoice-emb-imp.cod-estabel" tt-invoice-emb-imp.cod-estabel.
         MESSAGE ">> tt-invoice-emb-imp.embarque   " tt-invoice-emb-imp.embarque   .
         MESSAGE ">> tt-invoice-emb-imp.nr-invoice " tt-invoice-emb-imp.nr-invoice .
         MESSAGE ">> tt-invoice-emb-imp.parcela    " tt-invoice-emb-imp.parcela    .
         MESSAGE ">> tt-invoice-emb-imp.dt-vencim  " tt-invoice-emb-imp.dt-vencim  .
         MESSAGE ">> tt-invoice-emb-imp.vl-invoice " tt-invoice-emb-imp.vl-invoice .
         MESSAGE ">> tt-invoice-emb-imp.mo-codigo  " tt-invoice-emb-imp.mo-codigo  .
      END.
   END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraHistorico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraHistorico Procedure 
PROCEDURE piGeraHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

       RUN pi-erro (INPUT "N∆o encontrado a SIP " + STRING(p-nr-pagamento)).
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGravaInvoicePagamento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaInvoicePagamento Procedure 
PROCEDURE piGravaInvoicePagamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    blk_invoice_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento
    ON STOP  UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento: 
       FOR EACH Fatura:
           FIND FIRST invoice-emb-imp NO-LOCK 
                WHERE invoice-emb-imp.cod-estabel = Fatura.CodigoEstabelecimento
                  AND invoice-emb-imp.embarque    = Fatura.NumeroEmbarque
                  AND invoice-emb-imp.nr-invoice  = Fatura.NumeroInvoice
                  AND invoice-emb-imp.parcela     = Fatura.ParcelaInvoice 
                NO-ERROR.
           IF AVAIL invoice-emb-imp 
           THEN DO:
               FIND FIRST pagamento NO-LOCK
                    WHERE pagamento.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                      AND pagamento.cod-estabel  = Fatura.CodigoEstabelecimento 
                    NO-ERROR.

               IF NOT AVAIL pagamento 
               THEN DO:
                  RUN pi-erro (INPUT "N∆o encontrado SIP " + string(msg0255.CodigoSolicitacaoInterna) + " com estabelecimento " + Fatura.CodigoEstabelecimento).
                  NEXT.
               END.

               IF CAN-FIND (FIRST pagamento-invoice
                            WHERE pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                              AND pagamento-invoice.embarque     = invoice-emb-imp.embarque
                              AND pagamento-invoice.nr-invoice   = invoice-emb-imp.nr-invoice
                              AND pagamento-invoice.parcela      = invoice-emb-imp.parcela) 
               THEN DO:
                  RUN pi-erro (INPUT "SIP ja cadastrada com estabelecimento  " + string(Fatura.CodigoEstabelecimento) + " embarque " + STRING(Fatura.NumeroEmbarque) + " parcela " + STRING(Fatura.ParcelaInvoice)).
                  NEXT.   
               END.

               /*Se j† tem invoice vinculada, valida a moeda*/
               IF CAN-FIND (FIRST pagamento-invoice
                            WHERE pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna) 
               THEN DO:
                   IF pagamento.cod-moeda <> invoice-emb-imp.mo-codigo 
                   THEN DO:
                       RUN pi-erro (INPUT "Moeda da invoice n∆o pode ser diferente da moeda da SIP").
                       NEXT.   
                   END.
               END.
               /*Se Ç a primeira fatura vinculada preenche a moeda*/
               ELSE DO:
                   FIND CURRENT pagamento EXCLUSIVE-LOCK.
                   ASSIGN pagamento.cod-moeda = invoice-emb-imp.mo-codigo.
                   FIND CURRENT pagamento NO-LOCK.
               END.
               
               CREATE pagamento-invoice.
               ASSIGN 
                  pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                  pagamento-invoice.embarque     = invoice-emb-imp.embarque
                  pagamento-invoice.nr-invoice   = invoice-emb-imp.nr-invoice
                  pagamento-invoice.parcela      = invoice-emb-imp.parcela
                  pagamento-invoice.valor        = invoice-emb-imp.vl-invoice.
           END.
           ELSE RUN pi-erro (INPUT "N∆o encontrada invoice com estabelecimento " + string(Fatura.CodigoEstabelecimento) + " embarque " + STRING(Fatura.NumeroEmbarque) + " parcela " + STRING(Fatura.ParcelaInvoice)).
       END.

       FIND FIRST pagamento NO-LOCK
            WHERE pagamento.nr-pagamento = msg0255.CodigoSolicitacaoInterna 
            NO-ERROR.

       FOR EACH pagamento-invoice NO-LOCK
          WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:
          ASSIGN 
             de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
       END.

       FIND FIRST int-cond-pagto NO-LOCK
            WHERE int-cond-pagto.cod-cond-pag = pagamento.cod-cond-pag 
            NO-ERROR.
       
       RUN piCalculaCampos   (INPUT  pagamento.nr-pagamento,
                              OUTPUT d-dt-prev-fecha-cam,
                              OUTPUT d-dat-fft,
                              OUTPUT l-antecipado).

       IF CAN-FIND (tt-erro) THEN
           UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento.

       FIND CURRENT pagamento EXCLUSIVE-LOCK NO-ERROR.

       IF AVAIL pagamento 
       THEN DO:
          ASSIGN 
             pagamento.valor-pag          = de-valor-invoice
             pagamento.dt-prev-fecha-cam  = d-dt-prev-fecha-cam
             pagamento.dat-fft            = d-dat-fft
             pagamento.log-pag-antecipado = l-antecipado.
          RELEASE pagamento.
       END.

       IF CAN-FIND (tt-erro) 
       THEN UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento.
    END.

    FOR EACH tt-erro:
       RUN piErro (tt-erro.mensagem,"").
    END.

    IF CAN-FIND (tt-erro) 
    THEN RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGravaPagamento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaPagamento Procedure 
PROCEDURE piGravaPagamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN esbo/boes138.p  PERSISTENT SET h-boes138.
   RUN openQueryStatic IN h-boes138 (INPUT "Main":U).       

   EMPTY TEMP-TABLE tt-pagamento.

   /*Criaá∆o*/
   IF msg0254.CodigoSolicitacaoInterna = ? 
   THEN DO:

      CREATE tt-pagamento.

      RUN piPopulaTT.

      RUN emptyRowErrors IN h-boes138.
      RUN setRecord      IN h-boes138 (INPUT TABLE tt-pagamento).
      RUN createRecord   IN h-boes138.
      RUN getRowErrors   IN h-boes138 (OUTPUT TABLE auxRowErrors).

      IF CAN-FIND (FIRST auxRowErrors) 
      THEN DO:
         FOR EACH auxRowErrors NO-LOCK                                                                                                    
            WHERE auxRowErrors.ErrorType   <> "INTERNAL":U                                                                                
              AND auxRowErrors.ErrorSubType = "Error":U:  
            CREATE RowErrors.
            BUFFER-COPY auxRowErrors TO RowErrors.
         END. 
         STOP.
      END.
      RUN getRecord IN h-boes138 (OUTPUT TABLE tt-pagamento).
      FIND FIRST tt-pagamento.
      ASSIGN 
         msg0254.CodigoSolicitacaoInterna = tt-pagamento.nr-pagamento.
   END.
   /*Alteraá∆o*/
   ELSE DO:
      RUN emptyRowErrors IN h-boes138.
      RUN goToKey        IN h-boes138 (INPUT msg0254.CodigoSolicitacaoInterna).
   
      IF RETURN-VALUE = "OK" 
      THEN DO:
         RUN getRecord      IN h-boes138 (OUTPUT TABLE tt-pagamento).
         FIND FIRST tt-pagamento.

         RUN pi-popula-tt.

         RUN setRecord    IN h-boes138 (INPUT TABLE tt-pagamento).
         RUN updateRecord IN h-boes138.
         RUN getRowErrors IN h-boes138 (OUTPUT TABLE RowErrors).

         IF CAN-FIND (FIRST RowErrors) 
         THEN DO:
            FOR EACH RowErrors NO-LOCK                                                                                                    
               WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                 AND RowErrors.ErrorSubType = "Error":U:  
                RUN pi-erro (INPUT RowErrors.errorDescription + " " + RowErrors.errorHelp).
            END. 
            STOP.
         END.
      END.
      ELSE RUN piErro ("N∆o encontrado a SIP informada","").       
   END.

   IF CAN-FIND (RowErrors) 
   THEN RETURN "NOK".
   
   RUN piGeraHistorico (tt-pagamento.nr-pagamento,
                        "Comex",
                        TODAY,
                        STRING(TIME,"hh:mm:ss"),
                        1,
                        "Solicitaá∆o gerada a partir do embarque " + embarque-imp.embarque + " - " + embarque-imp.cod-estabel).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPopulaTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPopulaTT Procedure 
PROCEDURE piPopulaTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN tt-pagamento.nr-pagamento           = msg0254.CodigoSolicitacaoInterna     
          tt-pagamento.data-ci                = msg0254.DataEmissao                  
          tt-pagamento.dt-prev-fecha-cam      = IF msg0254.TipoSolicitacaoInterna <> 1 THEN msg0254.PrevFechaCambio ELSE tt-pagamento.dt-prev-fecha-cam /*Para Tipo Importaá∆o Ç calculado no momento da inclus∆o da fatura*/
          tt-pagamento.log-urgente            = msg0254.Urgente                      
          tt-pagamento.cod-emitente           = msg0254.CodigoFornecedorEMS          
          tt-pagamento.cod-estabel            = msg0254.CodigoEstabelecimento        
          tt-pagamento.valor-pag              = msg0254.ValorSolicitacaoInterna      
          tt-pagamento.cod-moeda              = msg0254.CodigoMoedaEMS               
          tt-pagamento.tipo-ci                = msg0254.TipoSolicitacaoInterna       
          tt-pagamento.ind-status-solicitacao = msg0254.StatusSolicitacaoInterna     
          tt-pagamento.cod-cond-pag           = msg0254.CodigoCondicaoPagamento      
          tt-pagamento.tipo-despesa           = msg0254.CodigoTipoDespesa            
          tt-pagamento.usuario                = msg0254.MatriculaResponsavel         
          tt-pagamento.cod-comprador          = msg0254.MatriculaComprador                                                   
          tt-pagamento.log-possui-anexos      = msg0254.PossuiAnexos
          tt-pagamento.txt-observacao         = msg0254.Observacoes                  
          tt-pagamento.log-pag-antecipado     = IF msg0254.TipoSolicitacaoInterna <> 1 THEN msg0254.PagamentoAntecipado ELSE tt-pagamento.log-pag-antecipado /*Para Tipo Importaá∆o Ç calculado no momento da inclus∆o da fatura*/
          tt-pagamento.historico              = msg0254.HistoricoSolicitacaoInterna
          tt-pagamento.cod-despachante        = msg0254.CodigoDespachante.

   IF   msg0254.StatusSolicitacaoInterna = 2
   AND  tt-pagamento.data-aprovacao      = ? 
   THEN ASSIGN 
      tt-pagamento.data-aprovacao = TODAY.

   RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrevisaoFatura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrevisaoFatura Procedure 
PROCEDURE piPrevisaoFatura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR v-data    AS da     NO-UNDO.
    DEF VAR de-unit   AS de     NO-UNDO.

    DEF BUFFER b-ordens-embarque FOR ordens-embarque.
    DEF BUFFER b2-ordem-compra   FOR ordem-compra.
    DEF BUFFER b-cotacao-item    FOR cotacao-item.


    EMPTY TEMP-TABLE PrevisaoFatura.
    CREATE PrevisaoFatura.
    ASSIGN 
       PrevisaoFatura.NumeroEmbarque         = embarque-imp.embarque
       PrevisaoFatura.CodigoEstabelecimento  = embarque-imp.cod-estabel.

    RUN inicializarFaturaordem IN h-bocx295 (INPUT  embarque-imp.cod-estabel,
                                             INPUT  embarque-imp.embarque,
                                             OUTPUT PrevisaoFatura.ValorCommercialInvoice,
                                             OUTPUT PrevisaoFatura.DataCommercialInvoice,
                                             OUTPUT PrevisaoFatura.CodigoMoedaEMS).

    /*Alterar DataCommercialInvoice para proximo dia util*/
    FIND FIRST estabelecimento NO-LOCK
         WHERE estabelecimento.cod_estab = embarque-imp.cod-estabel 
         NO-ERROR.

    FIND FIRST calend_glob NO-LOCK
         WHERE calend_glob.cod_calend = estabelecimento.cod_calend_mater 
         NO-ERROR.

    ASSIGN 
       v-data = PrevisaoFatura.DataCommercialInvoice.

    acha_dia_util:
    REPEAT:
       FIND FIRST dia_calend_glob NO-LOCK
            WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
              AND dia_calend_glob.dat_calend = v-data 
            NO-ERROR.

       IF NOT AVAIL dia_calend_glob 
       THEN LEAVE.

       IF dia_calend_glob.log_dia_util = NO 
       THEN ASSIGN 
          v-data = v-data + 1.
       ELSE LEAVE.
    END.

    ASSIGN 
       PrevisaoFatura.DataCommercialInvoice  = v-data
       PrevisaoFatura.ValorCommercialInvoice = ttCI.Valor
       PrevisaoFatura.CodigoMoedaEMS         = i-mo-codigo.

    /*
    IF ValorCommercialInvoice > 0 
    THEN DO:
       /*Desconta valor das parcelas FOC*/
       FOR EACH b-ordens-embarque NO-LOCK
             OF embarque-imp,
          FIRST b2-ordem-compra NO-LOCK
             OF b-ordens-embarque 
          WHERE b2-ordem-compra.cod-cond-pag = 63 :
           FIND FIRST b-cotacao-item NO-LOCK 
                WHERE b-cotacao-item.numero-ordem = b2-ordem-compra.numero-ordem
                  AND b-cotacao-item.it-codigo    = b2-ordem-compra.it-codigo
                  AND b-cotacao-item.cod-emitente = b2-ordem-compra.cod-emitente
                  AND b-cotacao-item.cot-aprovada = yes 
                NO-ERROR.
    
           ASSIGN 
              de-unit = 0.
           IF AVAIL b-cotacao-item 
           THEN ASSIGN 
              de-unit = (b-cotacao-item.pre-unit-for * 100) / (100 + b-cotacao-item.aliquota-ipi).
           ASSIGN 
              PrevisaoFatura.ValorCommercialInvoice = PrevisaoFatura.ValorCommercialInvoice - (b-ordens-embarque.qt-do-forn * de-unit).
       END.
    END.
    */
    

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = i-mo-codigo //PrevisaoFatura.CodigoMoedaEMS 
         NO-ERROR.

    IF AVAIL moeda 
    THEN ASSIGN 
       PrevisaoFatura.NomeMoeda = moeda.descricao.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessa Procedure 
PROCEDURE piProcessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR jsonObjectPayload AS JsonObject NO-UNDO.
   DEF VAR jsonArrayCI       AS JsonArray  NO-UNDO.
      
   DEF VAR lErr              AS l          NO-UNDO.
       
   DEF VAR lRetOK            AS l          NO-UNDO.
   DEF VAR httpInput         AS HANDLE     NO-UNDO.
   DEF VAR hQuery            AS HANDLE     NO-UNDO.
   DEF VAR hBuffer           AS HANDLE     NO-UNDO.
   DEF VAR iNumFields        AS i          NO-UNDO.
   DEF VAR iLoop             AS i          NO-UNDO.
   
   DEF VAR deTotValor        AS de         NO-UNDO.

   ASSIGN 
      jsonObjectPayload = jsonInput       :GetJsonObject("payload")
      jsonArrayCI      = jsonObjectPayload:GetJsonArray("CI").

   RUN cxbo/bocx295.p PERSISTENT SET h-bocx295.

   blk: DO ON STOP UNDO, LEAVE TRANSACTION:
      CREATE TEMP-TABLE httpInput.

      lRetOK = httpInput:READ-JSON("JsonArray", jsonArrayCI, "empty").

      ASSIGN 
         hBuffer    = httpInput:DEFAULT-BUFFER-HANDLE
         iNumFields = hBuffer:NUM-FIELDS.

      CREATE QUERY hQuery.

      hQuery:SET-BUFFERS(httpInput:DEFAULT-BUFFER-HANDLE).
      hQuery:QUERY-PREPARE("FOR EACH " + httpInput:NAME).

      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().
      
      MESSAGE ">> " httpInput:NAME.
      
      DO WHILE hQuery:QUERY-OFF-END = FALSE:

         CREATE ttCI.

         REPEAT iLoop = 1 TO iNumFields:
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NumeroEmbarque"
            THEN ASSIGN
               ttCI.NumeroEmbarque = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NumeroInvoice"
            THEN ASSIGN
               ttCI.NumeroInvoice  = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "Moeda"
            THEN ASSIGN
               ttCI.MoedaJson      = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "Valor"
            THEN ASSIGN
               ttCI.Valor          = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         END.

         ASSIGN
            deTotValor = deTotValor 
                       + ttCI.Valor.

         hQuery:GET-NEXT().
      END.
      
      hQuery:QUERY-CLOSE().

      FOR EACH ttCI
         BREAK BY ttCI.NumeroEmbarque:
         MESSAGE ">> ttCI.NumeroEmbarque" ttCI.NumeroEmbarque.
         MESSAGE ">> ttCI.NumeroInvoice " ttCI.NumeroInvoice .
         MESSAGE ">> ttCI.Valor         " ttCI.Valor         .
         MESSAGE ">> ttCI.MoedaJson     " ttCI.MoedaJson     .

         IF FIRST-OF(ttCI.NumeroEmbarque) 
         THEN DO:
            EMPTY TEMP-TABLE MSG0254           .
            EMPTY TEMP-TABLE MSG0255           .
            EMPTY TEMP-TABLE tt-pagamento      .
         END.

         EMPTY TEMP-TABLE tt-invoice-emb-imp. 
         EMPTY TEMP-TABLE PrevisaoFatura    .
         EMPTY TEMP-TABLE CommercialInvoice .

         FIND FIRST moeda NO-LOCK
              WHERE moeda.cod-decex = ttCI.MoedaJson
              NO-ERROR.
         
         IF NOT AVAIL moeda
         THEN DO:
            RUN piErro ("Moeda " + STRING(ttCI.MoedaJson) + " nao encontrada.","").
            STOP.
         END.
         ASSIGN
            i-mo-codigo = moeda.mo-codigo.

         FIND FIRST embarque-imp NO-LOCK
              WHERE embarque-imp.embarque = ttCI.NumeroEmbarque
              NO-ERROR.
         IF NOT AVAIL embarque-imp
         THEN RUN piErro ("”mbarque " + embarque-imp.embarque + " nao cadastrado." ,"").
         ELSE DO:
            RUN piPrevisaoFatura.
            MESSAGE ">> piPrevisaoFatura " RETURN-VALUE.
            IF RETURN-VALUE = "NOK" 
            THEN STOP.
            FOR EACH PrevisaoFatura:
               CREATE CommercialInvoice.
               ASSIGN
                  CommercialInvoice.NumeroCommercialInvoice  = ttCI.NumeroInvoice
                  CommercialInvoice.ParcelaCommercialInvoice = "1"
                  CommercialInvoice.DataCommercialInvoice    = PrevisaoFatura.DataCommercialInvoice
                  CommercialInvoice.ValorCommercialInvoice   = PrevisaoFatura.ValorCommercialInvoice
                  CommercialInvoice.CodigoMoedaEMS           = i-mo-codigo
                  .


               MESSAGE ">> CommercialInvoice.NumeroCommercialInvoice " CommercialInvoice.NumeroCommercialInvoice .
               MESSAGE ">> CommercialInvoice.ParcelaCommercialInvoice" CommercialInvoice.ParcelaCommercialInvoice.
               MESSAGE ">> CommercialInvoice.DataCommercialInvoice   " CommercialInvoice.DataCommercialInvoice   .
               MESSAGE ">> CommercialInvoice.ValorCommercialInvoice  " CommercialInvoice.ValorCommercialInvoice  .
               MESSAGE ">> CommercialInvoice.CodigoMoedaEMS          " CommercialInvoice.CodigoMoedaEMS          .

               CREATE msg0254.

               FIND FIRST ordens-embarque NO-LOCK
                       OF embarque-imp
                    NO-ERROR.
               FIND FIRST ordem-compra NO-LOCK
                    WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem
                    NO-ERROR.
               FIND FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                    NO-ERROR.

               
               ASSIGN
                  msg0254.CodigoSolicitacaoInterna    = ?
                  msg0254.DataEmissao                 = CommercialInvoice.DataCommercialInvoice
                  msg0254.Urgente                     = NO
                  msg0254.CodigoFornecedorEMS         = ordem-compra.cod-emitente
                  msg0254.CodigoEstabelecimento       = embarque-imp.cod-estabel
                  msg0254.ValorSolicitacaoInterna     = ttCI.Valor
                  msg0254.CodigoMoedaEMS              = i-mo-codigo
                  //msg0254.PrevFechaCambio            
                  msg0254.TipoSolicitacaoInterna      = 1
                  msg0254.StatusSolicitacaoInterna    = 1
                  msg0254.CodigoTipoDespesa           = 2
                  msg0254.CodigoCondicaoPagamento     = emitente.cod-cond-pag
                  msg0254.MatriculaResponsavel        = "comex"
                  msg0254.MatriculaComprador          = ordem-compra.cod-comprado
                  msg0254.PossuiAnexos                = NO
                  msg0254.Observacoes                 = ""
                  msg0254.PagamentoAntecipado         = NO
                  msg0254.HistoricoSolicitacaoInterna = ""
                  msg0254.CodigoDespachante           = embarque-imp.cod-despachante
                  .
            END.
            RUN piGeraFaturaEmbarque.
            MESSAGE ">> piGeraFaturaEmbarque " RETURN-VALUE.
            IF RETURN-VALUE = "NOK" 
            THEN STOP.
            RUN piGravaPagamento.
            IF RETURN-VALUE = "NOK" 
            THEN STOP.

            FIND FIRST Fatura NO-LOCK
                 WHERE Fatura.NumeroEmbarque        = ttCI.NumeroEmbarque         
                   AND Fatura.CodigoEstabelecimento = embarque-imp.cod-estabel
                   AND Fatura.NumeroInvoice         = ttCI.NumeroInvoice          
                   AND Fatura.ParcelaInvoice        = "1"
                 NO-ERROR.

            IF NOT AVAIL Fatura
            THEN CREATE Fatura.
            ASSIGN
               Fatura.NumeroEmbarque        = ttCI.NumeroEmbarque
               Fatura.CodigoEstabelecimento = embarque-imp.cod-estabel
               Fatura.NumeroInvoice         = ttCI.NumeroInvoice
               Fatura.ParcelaInvoice        = "1".

            FOR EACH msg0254:
               CREATE MSG0255.
               ASSIGN
                  MSG0255.CodigoSolicitacaoInterna = msg0254.CodigoSolicitacaoInterna.
            END.
         END.

         IF LAST-OF(ttCI.NumeroEmbarque) 
         THEN RUN piGravaInvoicePagamento.
         
         IF RETURN-VALUE = "NOK" 
         THEN STOP.
         
      END.

      IF TEMP-TABLE RowErrors:HAS-RECORDS
      THEN STOP.
   END.

   IF VALID-HANDLE(h-bocx295) 
   THEN DO:
      DELETE PROCEDURE h-bocx295 NO-ERROR.
      ASSIGN 
         h-bocx295 = ?.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

