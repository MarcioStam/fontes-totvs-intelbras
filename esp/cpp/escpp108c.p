{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{method/dbotterr.i}
{ccp/ccapi202.i}  /*tt-ordem-compra tt-prazo-compra*/
{ccp/ccapi207.i}  /*tt-cotacao-item*/  
{cdp/cdapi300.i1} /*tt-erros-geral*/
{esp/es0018.i}

define temp-table tt-param-re1005
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.

DEFINE TEMP-TABLE tt-digita-re1005
    FIELD r-docum-est AS ROWID.

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita       AS RAW.

DEFINE TEMP-TABLE tt-param-rpb NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD serie             LIKE docum-est.serie
    FIELD nro-docto         AS INTEGER FORMAT "9999999":U
    FIELD nat-retorno       LIKE docum-est.nat-operacao
    FIELD nat-servico       LIKE docum-est.nat-operacao
    FIELD num-pedido        LIKE pedido-compr.num-pedido
    FIELD nr-ord-prod       LIKE ord-prod.nr-ord-prod
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD cod-depos-ret     LIKE saldo-terc.cod-depos
    FIELD cod-depos-serv    LIKE saldo-terc.cod-depos
    FIELD cod-fornec        LIKE emitente.cod-emitente
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD qtd               LIKE saldo-terc.quantidade
    FIELD cod-modalid-frete LIKE modalid-frete.cod-modalid-frete.

DEFINE TEMP-TABLE tt-docum-est-rpb NO-UNDO LIKE docum-est
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro-rpb NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
   FIELD r-rowid AS ROWID
   FIELD rownum  AS INT.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE TEMP-TABLE tt-serie-estab-nf NO-UNDO
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD serie-nf          AS INT.

DEFINE VARIABLE hboin274sd   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082sd   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin356ca   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082ca   AS HANDLE      NO-UNDO.

DEFINE VARIABLE v-row-ord-prod AS ROWID       NO-UNDO.

DEFINE INPUT PARAM p-nr-ord-prod LIKE ord-prod.nr-ord-prod.           
DEFINE OUTPUT PARAM TABLE FOR tt-erro.             

FIND FIRST ord-prod NO-LOCK
     WHERE ord-prod.nr-ord-prod = p-nr-ord-prod NO-ERROR.

/* FIND FIRST ord-prod NO-LOCK                          */
/*      WHERE ord-prod.nr-ord-produ = 2834506 NO-ERROR. */

ASSIGN v-row-ord-prod = ROWID(ord-prod).


blk_geral:
DO TRANSACTION
ON ERROR UNDO blk_geral, LEAVE blk_geral
ON STOP  UNDO blk_geral, LEAVE blk_geral: 
    
    RUN pi-gera-pedido-compr.
    IF RETURN-VALUE <> "OK" THEN
        UNDO blk_geral, LEAVE blk_geral.

    RUN pi-gera-nota. 
    IF RETURN-VALUE <> "OK" THEN
        UNDO blk_geral, LEAVE blk_geral.
    
    RUN pi-atualiza-nota. 
   
END.

PROCEDURE pi-gera-pedido-compr:
    DEFINE VARIABLE h-boin295    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-num-pedido AS INTEGER     NO-UNDO.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = v-row-ord-prod NO-ERROR.

    /*Busca parametros para gerar o pedido*/
    FIND FIRST int-param-ord-prod NO-LOCK
         WHERE int-param-ord-prod.cod-estabel = ord-prod.cod-estabel NO-ERROR.

    IF NOT AVAIL int-param-ord-prod THEN DO:
        RUN pi-erro (INPUT "NÆo encontrado parametro para gera‡Æo do pedido no estabelecimento " + ord-prod.cod-estabel).
        RETURN "NOK".
    END.



    EMPTY TEMP-TABLE tt-pedido-compr.

    /*Inicializa handles*/
    RUN inbo/boin295.p  PERSISTENT SET h-boin295.
    RUN openQueryStatic IN h-boin295 (INPUT "Main":U).

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-param-ord-prod.cod-emitente NO-ERROR.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    CREATE tt-pedido-compr.
    ASSIGN tt-pedido-compr.cod-emitente = int-param-ord-prod.cod-emitente
           tt-pedido-compr.natureza     = 3 /*Beneficiamento*/
           tt-pedido-compr.emergencial  = YES
           tt-pedido-compr.cod-estabel  = int-param-ord-prod.cod-estabel
           tt-pedido-compr.end-entrega  = int-param-ord-prod.cod-estabel
           tt-pedido-compr.end-cobranca = int-param-ord-prod.cod-estabel
           tt-pedido-compr.cod-cond-pag = emitente.cod-cond-pag
           tt-pedido-compr.responsavel  = c-seg-usuario
           tt-pedido-compr.cod-transp   = emitente.cod-transp
           tt-pedido-compr.cod-mensagem = param-compra.cod-mensagem.

    /*BO cria‡Æo do pedido*/
    RUN emptyRowErrors         IN h-boin295.
    RUN geraNumeroPedidoCompra IN h-boin295 (OUTPUT i-num-pedido).

    ASSIGN tt-pedido-compr.num-pedido = i-num-pedido.

    RUN setRecord    IN h-boin295 (INPUT TABLE tt-pedido-compr).
    RUN createRecord IN h-boin295.
    RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).

    IF CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK                                                                                                    
           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
             AND RowErrors.ErrorSubType = "Error":U:  
            RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
            RETURN "NOK".
        END. 
    END.

    /*finaliza handles*/
    IF VALID-HANDLE(h-boin295) THEN DO:
        DELETE PROCEDURE h-boin295.
                         h-boin295 = ?.
    END.

    /*Marca os pedido gerados como impresso*/
    FIND FIRST pedido-compr EXCLUSIVE-LOCK
         WHERE pedido-compr.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

/*         IF  AVAIL pedido-compr                           */
/*         AND pedido-compr.situacao <> 1 /*Impresso*/ THEN */
/*             ASSIGN pedido-compr.situacao = 1.            */

    ASSIGN pedido-compr.cod-estabel = int-param-ord-prod.cod-estabel.

    FIND CURRENT pedido-compr NO-LOCK NO-ERROR.

    RUN pi-gera-ordem. 

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    /**Grava pedido gerado**/
    FIND FIRST int-ord-prod-monitor NO-LOCK
         WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.

    IF NOT AVAIL int-ord-prod-monitor THEN DO:
        CREATE int-ord-prod-monitor.
        ASSIGN int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ
               int-ord-prod-monitor.num-pedido   = pedido-compr.num-pedido.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-gera-ordem:
    DEFINE VARIABLE i-num-ordem  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-discard    AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-cod-comprado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-discard      AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE de-indice   AS DECIMAL     NO-UNDO. 

    /*Inicializa handles*/
    IF NOT VALID-HANDLE(hboin274sd) THEN DO:
        RUN inbo/boin274sd.p PERSISTENT SET hboin274sd.
        RUN openQueryStatic IN hboin274sd ( INPUT "Main":U ).
    END. 

    IF NOT VALID-HANDLE(hboin082sd) THEN DO:
        RUN inbo/boin082sd.p PERSISTENT SET hboin082sd.
        RUN openQueryStatic IN hboin082sd (INPUT "Main":U).
    END. 

    IF NOT VALID-HANDLE(hboin356ca) THEN DO:
        RUN inbo/boin356ca.p PERSISTENT SET hboin356ca.
        RUN openQueryStatic IN hboin356ca ( INPUT "Main":U ).
    END. 

    IF NOT VALID-HANDLE(hboin082ca) THEN DO:
        RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
    END. 

    
    EMPTY TEMP-TABLE tt-ordem-compra.
    EMPTY TEMP-TABLE tt-prazo-compra.  
    EMPTY TEMP-TABLE tt-cotacao-item.
    EMPTY TEMP-TABLE ttcotacao-item.
    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE tt-versao-integr.

    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 1.    

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ord-prod.it-codigo NO-ERROR.

    FIND FIRST item-fornec NO-LOCK
         WHERE item-fornec.it-codigo    = ord-prod.it-codigo
           AND item-fornec.cod-emitente = pedido-compr.cod-emitente NO-ERROR.

    RUN geraNumeroOrdemPedEmerg IN hboin274sd (OUTPUT i-num-ordem,
                                               OUTPUT TABLE RowErrors).
    
    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    
    IF CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK                                                                                                    
           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
             AND RowErrors.ErrorSubType = "Error":U:  
            RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
            RETURN "NOK".
        END. 
    END.

    CREATE tt-ordem-compra.
    ASSIGN tt-ordem-compra.ind-tipo-movto = 1 /*InclusÆo*/
           tt-ordem-compra.numero-ordem   = i-num-ordem
           tt-ordem-compra.num-pedido     = pedido-compr.num-pedido
           tt-ordem-compra.cod-emitente   = pedido-compr.cod-emitente
           tt-ordem-compra.cod-estabel    = pedido-compr.cod-estabel
           tt-ordem-compra.cod-cond-pag   = pedido-compr.cod-cond-pag
           tt-ordem-compra.cod-transp     = pedido-compr.cod-transp
           tt-ordem-compra.data-pedido    = pedido-compr.data-pedido
           tt-ordem-compra.ep-codigo      = i-ep-codigo-usuario
           tt-ordem-compra.qt-solic       = ord-prod.qt-ordem
           tt-ordem-compra.data-emissao   = TODAY
           tt-ordem-compra.data-cotacao   = TODAY
           tt-ordem-compra.impr-ficha     = NO
           tt-ordem-compra.l-split        = NO
           tt-ordem-compra.situacao       = 2
           tt-ordem-compra.natureza       = 3.
    
    ASSIGN tt-ordem-compra.mo-codigo      = 0
           tt-ordem-compra.it-codigo      = ord-prod.it-codigo
           tt-ordem-compra.requisitante   = c-seg-usuario
           tt-ordem-compra.tp-despesa     = 1
           tt-ordem-compra.cod-unid-negoc = int-param-ord-prod-monitor.cod-unid-negoc
           tt-ordem-compra.ct-codigo      = int-param-ord-prod-monitor.ct-codigo
           tt-ordem-compra.sc-codigo      = int-param-ord-prod-monitor.sc-codigo
           tt-ordem-compra.dep-almoxar    = int-param-ord-prod-monitor.cod-depos-ordem-compra
           tt-ordem-compra.ordem-servic   = 0
           tt-ordem-compra.narrativa      = "".

    RUN buscaInfOrdemLeaveItem IN hboin274sd (INPUT tt-ordem-compra.it-codigo,
                                              INPUT tt-ordem-compra.cod-estabel,
                                              INPUT tt-ordem-compra.num-pedido,
                                              OUTPUT c-cod-comprado,
                                              OUTPUT c-discard,
                                              OUTPUT c-discard,
                                              OUTPUT c-discard,
                                              OUTPUT i-discard).

    ASSIGN tt-ordem-compra.cod-comprado   = c-cod-comprado.

    /*S¢ gera parcela para cria‡Æo da ordem*/
    IF tt-ordem-compra.ind-tipo-movto = 1 THEN DO:

        {cdp/cd9950.i item.un 
                      item-fornec.unid-med-for
                      pedido-compr.cod-emitente}

        assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
    
        CREATE tt-prazo-compra.
        ASSIGN tt-prazo-compra.ind-tipo-movto = tt-ordem-compra.ind-tipo-movto
               tt-prazo-compra.numero-ordem   = tt-ordem-compra.numero-ordem 
               tt-prazo-compra.parcela        = 1
               tt-prazo-compra.quantidade     = tt-ordem-compra.qt-solic
               tt-prazo-compra.un             = item.un
               tt-prazo-compra.data-entrega   = TODAY
               tt-prazo-compra.situacao       = tt-ordem-compra.situacao
               tt-prazo-compra.data-alter     = TODAY
               tt-prazo-compra.it-codigo      = tt-ordem-compra.it-codigo
               tt-prazo-compra.qtd-a-ped-forn = tt-prazo-compra.quantidade * de-indice
               tt-prazo-compra.qtd-do-forn    = tt-prazo-compra.quantidade * de-indice
               tt-prazo-compra.qtd-sal-forn   = tt-prazo-compra.quantidade * de-indice
               tt-prazo-compra.quant-saldo    = tt-prazo-compra.quantidade
               tt-prazo-compra.quantid-orig   = tt-prazo-compra.quantidade.

        RUN calculaProximaParcelaPrazoCompra IN hboin356ca (INPUT  tt-ordem-compra.numero-ordem,
                                                            INPUT  tt-ordem-compra.it-codigo,
                                                            INPUT  tt-ordem-compra.cod-estabel,
                                                            INPUT  pedido-compr.cod-emitente,
                                                            OUTPUT tt-prazo-compra.parcela,
                                                            OUTPUT tt-prazo-compra.un,
                                                            OUTPUT tt-prazo-compra.data-entrega).
        
    END.
    
    CREATE tt-cotacao-item.
    ASSIGN tt-cotacao-item.ind-tipo-movto = tt-ordem-compra.ind-tipo-movto.

    /*Na inclusÆo seta defaults*/
    IF tt-ordem-compra.ind-tipo-movto = 1 THEN DO:
        RUN setDefaultsCotacao.
    END.
    /*Na altera‡Æo copia o registro atual*/
    ELSE DO:
        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.cot-aprovada = YES
               AND cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.

        IF AVAIL cotacao-item THEN
            BUFFER-COPY cotacao-item TO ttcotacao-item.
        ELSE 
            RUN setDefaultsCotacao.
    END.
    
    FIND FIRST ttcotacao-item NO-ERROR.
    
    ASSIGN ttcotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
           ttcotacao-item.it-codigo    = tt-ordem-compra.it-codigo
           ttcotacao-item.cod-emitente = pedido-compr.cod-emitente
           ttcotacao-item.cod-comprado = tt-ordem-compra.cod-comprado
           ttcotacao-item.cod-transp   = tt-ordem-compra.cod-transp
           ttcotacao-item.hora-atualiz = STRING(time, "hh:mm:ss")
           ttcotacao-item.cot-aprovada = YES
           ttcotacao-item.usuario      = c-seg-usuario.

    ASSIGN de-indice = 1.

    RUN calculaPrecoUnitFornecedorCotacao IN hboin082ca (INPUT NO,                            
                                                         INPUT tt-ordem-compra.numero-ordem,  
                                                         INPUT-OUTPUT TABLE ttcotacao-item). 
    
    FIND FIRST ttcotacao-item NO-ERROR.                                                       

    {cdp/cd9950.i item.un
                  ttcotacao-item.un
                  ttcotacao-item.cod-emitente}

    ASSIGN de-indice = 1 WHEN (de-indice = 0 OR de-indice = ?). 
    
    BUFFER-COPY ttcotacao-item TO tt-cotacao-item.
    
    ASSIGN tt-cotacao-item.preco-unit = ttcotacao-item.pre-unit-for * de-indice.

    IF ttcotacao-item.pre-unit-for = ? THEN DO:
        RUN pi-erro (INPUT "NÆo foi poss¡vel encontrar tabela").
        RETURN "NOK".
    END.
    
    EMPTY TEMP-TABLE tt-erros-geral.
    EMPTY TEMP-TABLE RowErrors.
    
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
        RUN pi-erro (INPUT tt-erros-geral.des-erro + " " + STRING(tt-erros-geral.cod-erro)).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.
    ELSE DO:
        FOR FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.cot-aprovada = YES
              AND cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
    
            FIND FIRST ordem-compra EXCLUSIVE-LOCK
                 WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
    
            IF AVAIL ordem-compra THEN
                ASSIGN ordem-compra.pre-unit-for = cotacao-item.pre-unit-for
                       ordem-compra.preco-orig   = cotacao-item.pre-unit-for
                       ordem-compra.preco-unit   = cotacao-item.preco-unit.
         END.  
    
         FIND FIRST emitente NO-LOCK
              WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-ERROR.
         
    END.

    /*finaliza handles*/
    IF VALID-HANDLE(hboin274sd) THEN DO:
        DELETE PROCEDURE hboin274sd.
                         hboin274sd = ?.
    END.
    
    IF VALID-HANDLE(hboin082sd) THEN DO:
        DELETE PROCEDURE hboin082sd.
                         hboin082sd = ?.
    END.
    
    IF VALID-HANDLE(hboin356ca) THEN DO:
        DELETE PROCEDURE hboin356ca.
                         hboin356ca = ?.
    END.
    
    IF VALID-HANDLE(hboin082ca) THEN DO:
        DELETE PROCEDURE hboin082ca.
                         hboin082ca = ?.
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-busca-serie-nf-estabel:
    //C2305-0814 --> IDBA Bruno Joaquim
    //Estava "chumbado" no fonte s‚rie 2, foi definido usar o es0018 para definir a s‚rie por estabelecimento

    DEFINE INPUT  PARAM p-cod-estabel AS CHAR.
    DEFINE OUTPUT PARAM p-serie-nf   AS INT.

    EMPTY TEMP-TABLE tt-prog-ponto.
    EMPTY TEMP-TABLE tt-serie-estab-nf.

    RUN esp/es0018p.p (INPUT "escpp108",
                   INPUT 4,
                   INPUT 0,
                   INPUT "", 
                   OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto WHERE tt-prog-ponto.sequencia = INT(p-cod-estabel) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN p-serie-nf = int(tt-prog-ponto.conteudo).
    END.


END.


PROCEDURE pi-gera-nota:

    DEFINE VAR serie-nf AS INT.

    EMPTY TEMP-TABLE tt-param-rpb.
    EMPTY TEMP-TABLE tt-raw-digita.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = v-row-ord-prod NO-ERROR.

    FIND FIRST int-param-ord-prod NO-LOCK
         WHERE int-param-ord-prod.cod-estabel = ord-prod.cod-estabel NO-ERROR.

    /*Documento*/            
    FIND FIRST docum-est NO-LOCK 
         WHERE docum-est.cod-estabel  = ord-prod.cod-estabel 
           AND docum-est.serie-docto  = ""
           AND docum-est.nro-docto    = STRING(ord-prod.nr-ord-produ)
           AND docum-est.cod-emitente = int-param-ord-prod.cod-emitente
           AND docum-est.nat-operacao = int-param-ord-prod.nat-operacao-retorno NO-ERROR.
    IF AVAIL docum-est THEN DO:
        RUN pi-erro (INPUT "Nota Fiscal de Retorno j  existe! J  existe ocorrˆncia de Nota Fiscal de Retorno com a chave informada.").
        RETURN "NOK".
    END.

    FIND FIRST docum-est NO-LOCK 
         WHERE docum-est.cod-estabel  = ord-prod.cod-estabel
           AND docum-est.serie-docto  = ""
           AND docum-est.nro-docto    = STRING(ord-prod.nr-ord-produ)
           AND docum-est.cod-emitente = int-param-ord-prod.cod-emitente
           AND docum-est.nat-operacao = int-param-ord-prod.nat-operacao-servico NO-ERROR.

    IF AVAIL docum-est THEN DO:
        RUN pi-erro (INPUT "Nota Fiscal de Servi‡o j  existe! J  existe ocorrˆncia de Nota Fiscal de Servi‡o com a chave informada.").
        RETURN "NOK".
    END.    

    IF ord-prod.estado > 6 THEN DO:
        RUN pi-erro (INPUT "Ordem de Produ‡Æo nÆo pode estar 'Terminada' ou 'Finalizada'.").
        RETURN "NOK".
    END.

    FIND FIRST lin-prod NO-LOCK 
         WHERE lin-prod.cod-estabel = ord-prod.cod-estabel 
           AND lin-prod.nr-linha    = ord-prod.nr-linha NO-ERROR.

    IF  AVAIL lin-prod 
    AND lin-prod.sum-requis <> 2 THEN DO:
        RUN pi-erro (INPUT "Linha de Produ‡Æo da Ordem de Produ‡Æo").
        RETURN "NOK".
    END.

     //C2305-0814 --> IDBA Bruno Joaquim
    //Estava "chumbado" no fonte s‚rie 2, foi definido usar o es0018 para definir a s‚rie por estabelecimento
    RUN pi-busca-serie-nf-estabel(INPUT int-param-ord-prod.cod-estabel,
                                  OUTPUT serie-nf ) .

    IF serie-nf = 0 THEN DO:
        RUN pi-erro(INPUT "Serie da Nota fiscal invalida. NÆo encontrado o ponto no ES0018 que define a serie da NF por estabelecimento").
    END.
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.
    
    CREATE tt-param-rpb.
    ASSIGN tt-param-rpb.usuario           = c-seg-usuario
           tt-param-rpb.destino           = 3
           tt-param-rpb.data-exec         = TODAY
           tt-param-rpb.hora-exec         = TIME
           tt-param-rpb.cod-estabel       = int-param-ord-prod.cod-estabel
           tt-param-rpb.serie             = string(serie-nf)
           tt-param-rpb.nro-docto         = ord-prod.nr-ord-produ
           tt-param-rpb.nat-retorno       = int-param-ord-prod.nat-operacao-retorno
           tt-param-rpb.nat-servico       = int-param-ord-prod.nat-operacao-servico
           tt-param-rpb.num-pedido        = pedido-compr.num-pedido
           tt-param-rpb.nr-ord-prod       = ord-prod.nr-ord-produ
           tt-param-rpb.dt-trans          = TODAY
           tt-param-rpb.cod-depos-ret     = int-param-ord-prod.cod-depos-nf-retorno
           tt-param-rpb.cod-depos-serv    = int-param-ord-prod.cod-depos-nf-servico
           tt-param-rpb.cod-fornec        = int-param-ord-prod.cod-emitente
           tt-param-rpb.it-codigo         = ord-prod.it-codigo
           tt-param-rpb.qtd               = ord-prod.qt-ordem
           tt-param-rpb.cod-modalid-frete = "1"
           tt-param-rpb.arquivo           = SESSION:TEMP-DIRECTORY + "notas_escpp108_" + STRING(TIME) + ".txt".

    ASSIGN raw-param = ?.
    RAW-TRANSFER tt-param-rpb TO raw-param.

    RUN esp/cpp/escpp108rpb.p (INPUT raw-param, 
                               INPUT TABLE tt-raw-digita,
                               OUTPUT TABLE tt-erro-rpb,
                               OUTPUT TABLE tt-docum-est-rpb).

    FOR EACH tt-erro-rpb:
        RUN pi-erro(INPUT tt-erro-rpb.mensagem).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

PROCEDURE setDefaultsCotacao:
    DEF VAR l-discard      AS LOG  NO-UNDO.
    DEF VAR c-cod-comprado AS CHAR NO-UNDO.
    
    RUN emptyRowObject IN hboin082sd.
    ASSIGN c-cod-comprado = tt-ordem-compra.cod-comprado.

    RUN preparaCotacaoOrdemCompraPedEmerg IN hboin082sd (INPUT tt-ordem-compra.numero-ordem,  
                                                         INPUT pedido-compr.num-pedido, 
                                                         INPUT tt-ordem-compra.cod-emitente,  
                                                         INPUT tt-ordem-compra.it-codigo,
                                                         INPUT tt-ordem-compra.cod-estabel,
                                                         INPUT tt-ordem-compra.qt-solic,
                                                         INPUT tt-prazo-compra.data-entrega,  
                                                         INPUT-OUTPUT c-cod-comprado,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,  
                                                         OUTPUT TABLE ttcotacao-item).

    FIND FIRST ttcotacao-item NO-LOCK NO-ERROR.

    ASSIGN tt-ordem-compra.preco-fornec   = ttcotacao-item.preco-fornec
           tt-ordem-compra.preco-unit     = ttcotacao-item.preco-fornec.
    
       
END PROCEDURE.

PROCEDURE pi-atualiza-nota:

    EMPTY TEMP-TABLE tt-param-re1005.
    EMPTY TEMP-TABLE tt-digita-re1005.
    EMPTY TEMP-TABLE tt-raw-digita.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = v-row-ord-prod NO-ERROR.
             
    CREATE tt-param-re1005.
    ASSIGN tt-param-re1005.destino            = 2 /* Arquivo */                                                                               
           tt-param-re1005.arquivo            = SESSION:TEMP-DIRECTORY + "/" + 'escpp093-gera-nf-' + c-seg-usuario + "-" + string(TIME) + '.lst'
           tt-param-re1005.usuario            = c-seg-usuario                                                                                 
           tt-param-re1005.data-exec          = TODAY                                                                                         
           tt-param-re1005.hora-exec          = TIME                                                                                          
           tt-param-re1005.c-cod-estabel-ini  = ord-prod.cod-estabel
           tt-param-re1005.c-cod-estabel-fim  = ord-prod.cod-estabel
           tt-param-re1005.i-cod-emitente-ini = 0
           tt-param-re1005.i-cod-emitente-fim = 999999999
           tt-param-re1005.c-nro-docto-ini    = ""                
           tt-param-re1005.c-nro-docto-fim    = "9999999999999999"
           tt-param-re1005.c-serie-docto-ini  = ""      
           tt-param-re1005.c-serie-docto-fim  = "ZZZZZ" 
           tt-param-re1005.c-nat-operacao-ini = ""       
           tt-param-re1005.c-nat-operacao-fim = "ZZZZZZ" 
           tt-param-re1005.da-dt-trans-ini    = TODAY
           tt-param-re1005.da-dt-trans-fim    = TODAY.

    RAW-TRANSFER tt-param-re1005 TO raw-param.

    FIND FIRST int-ord-prod-monitor NO-LOCK
         WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.

    FIND FIRST docum-est NO-LOCK
         WHERE rowid(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.

    CREATE tt-digita-re1005.
    ASSIGN tt-digita-re1005.r-docum-est = rowid(docum-est).

    FIND FIRST docum-est NO-LOCK
         WHERE rowid(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.

    CREATE tt-digita-re1005.
    ASSIGN tt-digita-re1005.r-docum-est = rowid(docum-est).

    FOR EACH tt-digita-re1005:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita-re1005 TO tt-raw-digita.raw-digita.
    END.

    RUN rep/re1005rp.p (INPUT raw-param,  
                        INPUT TABLE tt-raw-digita).    

    RETURN "OK".
    
END PROCEDURE.
