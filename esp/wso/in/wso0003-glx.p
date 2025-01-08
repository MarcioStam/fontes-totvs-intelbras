{esp/wso/in/wso0003.i}
{utp/ut-glob.i}
{esp/pdp/espdp006.i}
{btb/btb912zb.i}
{esp/esb/esesb000.i}
def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.

DEFINE TEMP-TABLE ttWt-docto NO-UNDO LIKE wt-docto
        FIELD r-rowid AS ROWID.
    
DEFINE TEMP-TABLE ttWt-it-docto NO-UNDO LIKE wt-it-docto
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS   ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

DEFINE TEMP-TABLE tt-erro NO-UNDO
        FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE l-erro                      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE h-acomp                     AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-seq                       AS INTEGER      NO-UNDO INITIAL 1.
DEFINE VARIABLE h-bodi317                   AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317in                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317pr                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317sd                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra             AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317va                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi321                   AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317ef                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE l-procedimento-ok           AS LOGICAL       NO-UNDO.
DEFINE VARIABLE ultprocesso                 AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux               AS LOGICAL       NO-UNDO.
DEFINE VARIABLE l-fifo                      AS LOG INIT NO   NO-UNDO.
DEFINE VARIABLE c-modelo                    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cSerie                      LIKE serie.serie                NO-UNDO VIEW-AS FILL-IN SIZE 08 BY 0.88.
DEFINE VARIABLE cNatOper                    LIKE natur-oper.nat-operacao    NO-UNDO VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE c-char-aux                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto              AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSeqWtDocto                 AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSeqWtItDocto               AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-nr-pedcli-venda           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-nome-abrev-venda          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-natur AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-nf-man-dev-terc-dif AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-recal-apenas-totais AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-transp-branco AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-natureza AS CHAR INITIAL "500001" NO-UNDO.
DEFINE VARIABLE l-log                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-producao   AS LOG NO-UNDO.
DEFINE VARIABLE c-arquivo-log1             AS CHAR NO-UNDO.

DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.

define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field nome-abrev    LIKE ped-venda.nome-abrev
    field nr-pedcli     LIKE ped-venda.nr-pedcli    
    field Cod-depos     LIKE deposito.cod-depos
    field Localizacao   LIKE saldo-estoq.cod-localiz 
    .

define temp-table tt-digita NO-UNDO
    field nome-abrev     LIKE ped-venda.nome-abrev
    field nr-pedcli      LIKE ped-venda.nr-pedcli 
    field c-it-codigo    LIKE ped-item.it-codigo
    field c-cod-refer    LIKE ped-item.cod-refer
    field i-nr-sequencia LIKE ped-item.nr-sequencia
    .

define temp-table tt-raw-digita
    field raw-digita    as raw.

DEFINE TEMP-TABLE ttItemSplit NO-UNDO LIKE ttItem
    FIELD cod-servico AS INT.

DEFINE BUFFER bttItemSplit FOR ttItemSplit.

DEFINE VARIABLE iXML AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE c-numeroPedido AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-prog-ponto-glx NO-UNDO LIKE tt-prog-ponto.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'wso0003' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.

// ABERTURA DO LOG 
IF l-log = YES THEN DO:
    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_wso0003'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_wso0003'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
END.                                                        

PROCEDURE pi-evento:

    DEFINE INPUT        PARAMETER c-evento AS CHAR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPessoaFisica.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPessoaJuridica.    
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttTelefone.          
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttEmail.             
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttEndereco.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDocumento.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPedido.           
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttCondicaoPagamento. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttItem.             
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-emitente.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ped-venda.        
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ped-item.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttErro.

    DEFINE VARIABLE i-seq-contato          AS INT    NO-UNDO.
    DEFINE VARIABLE c-codigoItem           AS CHAR   NO-UNDO.
    DEFINE VARIABLE c-item                 AS CHAR   NO-UNDO.
    DEFINE VARIABLE c-estabelecimento      AS CHAR   NO-UNDO.
    DEFINE VARIABLE c-codigoTransportadora AS CHAR   NO-UNDO.
    DEFINE VARIABLE i                      AS INTEGER NO-UNDO.
    DEFINE VARIABLE d-precoItem-tot        AS DEC    NO-UNDO.
    DEFINE VARIABLE c-servicos             AS CHAR   NO-UNDO.
    
    FIND FIRST tt-ped-venda NO-ERROR.
    FIND FIRST ttPedido NO-ERROR.

    FIND FIRST int-pedido-param NO-LOCK
         WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
           AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.

    IF c-evento = "atualizaInicial" THEN DO:

        FIND FIRST ttItem NO-ERROR.
        IF AVAIL ttItem THEN DO:
            
            ASSIGN c-codigoItem = ttItem.codigoItem.
            ASSIGN c-codigoItem = REPLACE(c-codigoItem,CHR(10),"|").
            ASSIGN c-codigoItem = REPLACE(c-codigoItem,CHR(13),"").

            ASSIGN c-estabelecimento      = ttItem.estabelecimento
                   c-codigoTransportadora = ttItem.codigoTransportadora.

            IF NUM-ENTRIES(c-codigoItem,";") > 1
            OR NUM-ENTRIES(c-codigoItem,"|") > 1 THEN DO:

                DELETE ttItem.

                DO  i = 1 TO NUM-ENTRIES(c-codigoItem,"|"):
        
                    ASSIGN c-item = TRIM(ENTRY(i,c-codigoItem,"|")).
        
                    IF c-item = "" THEN NEXT.

                    FIND FIRST ITEM WHERE ITEM.it-codigo = ENTRY(1,c-item,";") NO-LOCK NO-ERROR.
                    IF NOT AVAIL ITEM THEN NEXT.
                    
                    CREATE ttItemSplit.
                    ASSIGN ttItemSplit.codigoItem           = ENTRY(1,c-item,";")      
                           ttItemSplit.quantidade           = INT(ENTRY(3,c-item,";")) 
                           ttItemSplit.precoItem            = DEC(REPLACE(ENTRY(4,c-item,";"),".",","))
                           ttItemSplit.valorDesconto        = 0
                           ttItemSplit.precoFinal           = DEC(REPLACE(ENTRY(4,c-item,";"),".",","))
                           ttItemSplit.estabelecimento      = c-estabelecimento     
                           ttItemSplit.codigoTransportadora = c-codigoTransportadora
                           ttItemSplit.cod-servico          = ITEM.cod-servico.

                    ASSIGN d-precoItem-tot = d-precoItem-tot + (ttItemSplit.precoItem * ttItemSplit.quantidade).
                    
                    IF NUM-ENTRIES(c-servicos,STRING(ttItemSplit.cod-servico)) <= 1 THEN DO:
                        IF c-servicos = "" THEN
                            ASSIGN c-servicos = STRING(ttItemSplit.cod-servico).
                        ELSE
                            ASSIGN c-servicos = c-servicos + ";" + STRING(ttItemSplit.cod-servico).

                    END.
                END.

                FIND FIRST ttPedido NO-ERROR.
                IF d-precoItem-tot <> ttPedido.totalItens THEN DO:
                    FOR EACH ttItemSplit:
                        ASSIGN ttItemSplit.precoItem  = ttItemSplit.precoItem * ttPedido.totalItens / d-precoItem-tot
                               ttItemSplit.precoFinal = ttItemSplit.precoItem.
            
                    END.
                END.

                DO  i = 1 TO NUM-ENTRIES(c-servicos,";"):

                    EMPTY TEMP-TABLE ttItem.

                    FOR EACH ttItemSplit
                       WHERE ttItemSplit.cod-servico = INT(ENTRY(i,c-servicos,";")):

                        CREATE ttItem.
                        ASSIGN ttItem.codigoItem           = ttItemSplit.codigoItem          
                               ttItem.quantidade           = ttItemSplit.quantidade          
                               ttItem.precoItem            = ttItemSplit.precoItem           
                               ttItem.valorDesconto        = ttItemSplit.valorDesconto       
                               ttItem.precoFinal           = ttItemSplit.precoFinal          
                               ttItem.estabelecimento      = ttItemSplit.estabelecimento     
                               ttItem.codigoTransportadora = ttItemSplit.codigoTransportadora.
                              
                        DELETE ttItemSplit.

                    END.

                    FIND FIRST ttPedido NO-ERROR.

                    ASSIGN c-numeroPedido = ttPedido.numeroPedido.

                    ASSIGN ttPedido.numeroPedido = ttPedido.numeroPedido + "-" + ENTRY(i,c-servicos,";").

                    FIND FIRST ttpessoaJuridica NO-ERROR.
                    IF AVAIL ttpessoaJuridica THEN DO:

                        EMPTY TEMP-TABLE ttPedidoPJ.           
                        EMPTY TEMP-TABLE ttItemPJ.             
                        EMPTY TEMP-TABLE ttCondicaoPagamentoPJ.
                        EMPTY TEMP-TABLE ttpessoaJuridicaPJ.   
                        EMPTY TEMP-TABLE ttDocumentoPJ.        
                        EMPTY TEMP-TABLE ttTelefonePJ.         
                        EMPTY TEMP-TABLE ttEmailPJ.            
                        EMPTY TEMP-TABLE ttEnderecoPJ. 

                        FOR EACH ttPedido:            CREATE ttPedidoPJ.            BUFFER-COPY ttPedido            TO ttPedidoPJ.            END.
                        FOR EACH ttItem:              CREATE ttItemPJ.              BUFFER-COPY ttItem              TO ttItemPJ.              END.
                        FOR EACH ttCondicaoPagamento: CREATE ttCondicaoPagamentoPJ. BUFFER-COPY ttCondicaoPagamento TO ttCondicaoPagamentoPJ. END.
                        FOR EACH ttpessoaJuridica:    CREATE ttpessoaJuridicaPJ.    BUFFER-COPY ttpessoaJuridica    TO ttpessoaJuridicaPJ.    END.
                        FOR EACH ttDocumento:         CREATE ttDocumentoPJ.         BUFFER-COPY ttDocumento         TO ttDocumentoPJ.         END.
                        FOR EACH ttTelefone:          CREATE ttTelefonePJ.          BUFFER-COPY ttTelefone          TO ttTelefonePJ.          END.
                        FOR EACH ttEmail:             CREATE ttEmailPJ.             BUFFER-COPY ttEmail             TO ttEmailPJ.             END.
                        FOR EACH ttEndereco:          CREATE ttEnderecoPJ.          BUFFER-COPY ttEndereco          TO ttEnderecoPJ.          END.
                
                        DATASET mensagemPJ:WRITE-XML('longchar', iXML, YES). 
                    END.
                    ELSE
                        DATASET mensagem:WRITE-XML('longchar', iXML, YES).

                    RUN esp/wso/IN/wso0003.p (INPUT iXML,
                                              OUTPUT oXML).

                    FIND FIRST ttPedido NO-ERROR.
                    ASSIGN ttPedido.numeroPedido = c-numeroPedido.

                END.

                CREATE ttErro.
                ASSIGN ttErro.SeqErro       = 1000
                       ttErro.detalhe       = "Pedido"
                       ttErro.codigoErro    = 17006
                       ttErro.mensagem      = "SPLIT DE PEDIDO".
                 
                RETURN "NOK".
    
                
            END.
        END.

        FIND FIRST ttPedido NO-ERROR.
        FOR FIRST ttCondicaoPagamento:
            IF ttCondicaoPagamento.Nsu = "" THEN
                ASSIGN ttCondicaoPagamento.Nsu = ttPedido.numeroPedido
                       ttCondicaoPagamento.tid = ttPedido.numeroPedido
                       ttCondicaoPagamento.numeroReferencia = SUBSTRING(ttPedido.numeroPedido,1,16).

            IF ttCondicaoPagamento.formaPagamento = "" THEN
                ASSIGN ttCondicaoPagamento.formaPagamento = "BOLETO".

        END.

        FIND FIRST ttPedido NO-ERROR.
        IF ttPedido.dataCriacao > TODAY THEN
            ASSIGN ttPedido.dataCriacao = TODAY.
    
        IF CAN-FIND(FIRST ttItem
                    WHERE ttItem.estabelecimento = "0"
                       OR ttItem.estabelecimento = "") THEN DO:
            FOR EACH ttItem:
                IF AVAIL int-pedido-param THEN 
                    ASSIGN ttItem.estabelecimento = int-pedido-param.cod-estab-pad.
            END.
        END.
    END.

    IF c-evento = "aposAtualizaPessoa" THEN DO:

        FIND FIRST tt-emitente NO-ERROR.
        IF AVAIL tt-emitente THEN DO:
            IF NOT CAN-FIND(FIRST cont-emit NO-LOCK
                            WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente
                              AND cont-emit.int-1        = 3
                              AND cont-emit.nome         = "NFE"
                              AND cont-emit.e-mail       = tt-emitente.e-mail) THEN DO:
            
                FIND FIRST cont-emit NO-LOCK
                     WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente
                       AND cont-emit.int-1        = 3 NO-ERROR.
                IF NOT AVAIL cont-emit THEN DO:
                    ASSIGN i-seq-contato = 10.
                    FOR LAST cont-emit NO-LOCK 
                       WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente 
                          BY cont-emit.sequencia:
                        ASSIGN i-seq-contato = cont-emit.sequencia + 10.
                    END.
                    
                    CREATE cont-emit.
                    ASSIGN cont-emit.cod-emitente = tt-emitente.cod-emitente
                           cont-emit.sequencia    = i-seq-contato
                           cont-emit.identific    = 1
                           cont-emit.int-1        = 3.
                END.
                FIND CURRENT cont-emit EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN cont-emit.nome   = "NFE"
                       cont-emit.e-mail = tt-emitente.e-mail.
                FIND CURRENT cont-emit NO-LOCK NO-ERROR.
                RELEASE cont-emit.
            END.
        END.
    END.

    IF c-evento = "aposCriaTTPedVenda" THEN DO:
        FOR FIRST tt-ped-venda:
            FOR EACH tt-ped-item OF tt-ped-venda:
				FIND FIRST item NO-LOCK WHERE item.it-codigo = tt-ped-item.it-codigo NO-ERROR.
                ASSIGN tt-ped-item.ct-codigo = item.ct-codigo			
				       tt-ped-item.dec-2     = item.aliquota-iss.
            END.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
            IF AVAIL emitente THEN DO:
                FIND FIRST repres NO-LOCK                               
                     WHERE repres.cod-rep =  repres-atend.cod-rep NO-ERROR.
                IF AVAIL repres THEN
                    ASSIGN tt-ped-venda.no-ab-reppri = repres.nome-abrev.
            END.

            EMPTY TEMP-TABLE tt-prog-ponto-glx.
            RUN esp/es0018p.p (INPUT "wso0003-glx":U, 
                               INPUT 1, 
                               INPUT 0, 
                               INPUT "":U, 
                               OUTPUT TABLE tt-prog-ponto-glx).

            FOR EACH tt-prog-ponto-glx:
                IF index(tt-prog-ponto-glx.conteudo,string(tt-ped-venda.cod-emitente)) > 0 THEN DO: 
                    ASSIGN tt-ped-venda.tp-pedido = string(tt-prog-ponto-glx.sequencia). //clientes especificos entrar no atendente 66, demais no 68
                END.
            END.
        END.
    END.

    IF c-evento = "atualizaFinal" THEN DO:

        FIND FIRST tt-ped-venda NO-ERROR.
        IF NOT AVAIL tt-ped-venda THEN NEXT.

        RUN pi-gerar-dados-extrato ("> ANTES atualizaFinal1 " + STRING(AVAIL tt-ped-venda)).

        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
              AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev:
            FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
                IF TRIM(SUBSTR(ped-item.char-2,56,5)) = "2" THEN
                    ASSIGN c-natureza = "800112".
                ELSE
                    ASSIGN c-natureza = "500012".

                ASSIGN ped-item.nat-operacao = c-natureza
                       ped-item.dt-min-fat   = ped-item.dt-min-fat - 30
                       ped-item.qt-log-aloca = ped-item.qt-pedida.
            END.
            FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ped-venda.nat-operacao = c-natureza
                   ped-venda.completo     = NO.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        END.

        IF AVAIL tt-ped-venda THEN
            RUN pi-gerar-dados-extrato ("> ANTES atualizaFinal2 " + STRING(AVAIL tt-ped-venda)).

        RUN pi-completa-pedido.

        IF AVAIL tt-ped-venda THEN
            RUN pi-gerar-dados-extrato ("> ANTES atualizaFinal3 " + STRING(AVAIL tt-ped-venda)).

        FIND FIRST tt-ped-venda NO-ERROR.
        IF AVAIL tt-ped-venda THEN DO:

            RUN pi-aprova-pedido.

            RUN pi-gerar-dados-extrato ("> ANTES atualizaFinal4 " + STRING(AVAIL int-pedido-param) + STRING(int-pedido-param.ind-fat-aut)).

            /* FATURA PEDIDO */
            IF AVAIL int-pedido-param AND int-pedido-param.ind-fat-aut THEN
                RUN pi-fatura-pedido(INPUT tt-ped-venda.nr-pedcli).
            
        END.

        FIND LAST  int-recorrencia-historico NO-LOCK
             WHERE int-recorrencia-historico.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")
               AND int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") 
               AND int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")
               AND int-recorrencia-historico.nr-transacao   = "1" NO-ERROR.
        IF AVAIL int-recorrencia-historico THEN
            ASSIGN i-seq = int-recorrencia-historico.nr-sequencia + 1.
/*
        MESSAGE ENTRY(2,ttPedido.numeroPedido,"-")                       SKIP
                STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") SKIP
                STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")     SKIP
                AVAIL int-recorrencia-historico
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            */


        IF NOT CAN-FIND(FIRST ttErro) THEN DO:
            FIND FIRST tt-ped-venda NO-ERROR.
            IF AVAIL tt-ped-venda THEN DO:
                
                CREATE int-recorrencia-historico.                                                                                                                               
                ASSIGN int-recorrencia-historico.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")                      
                       int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") 
                       int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")     
                       int-recorrencia-historico.nr-transacao   = "1"                             
                       int-recorrencia-historico.nr-sequencia   = i-seq
                       int-recorrencia-historico.dt-evento      = TODAY                                                                                                          .
                       int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                          .
                       int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                  .
                       int-recorrencia-historico.desc-evento    = "Pedido gerado: " + tt-ped-venda.nr-pedcli.
        
                FIND FIRST tt-emitente NO-ERROR.
                FOR FIRST int-recorrencia-contratos EXCLUSIVE-LOCK
                    WHERE int-recorrencia-contratos.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")                       
                      AND int-recorrencia-contratos.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999")  
                      AND int-recorrencia-contratos.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")      
                      AND int-recorrencia-contratos.nr-transacao   = "1":
        
                    IF int-recorrencia-contratos.cod-emitente = 0 THEN
                        ASSIGN int-recorrencia-contratos.cod-emitente = tt-emitente.cod-emitente.
        
                    ASSIGN int-recorrencia-contratos.cod-sit-trans = "Pedido gerado".  
                END.
        
                FIND FIRST int-recorrencia-notas NO-LOCK
                     WHERE int-recorrencia-notas.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")
                       AND int-recorrencia-notas.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") 
                       AND int-recorrencia-notas.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")
                       AND int-recorrencia-notas.nr-transacao   = "1"
                       AND int-recorrencia-notas.nr-pedido      = tt-ped-venda.nr-pedido NO-ERROR.
                IF NOT AVAIL int-recorrencia-notas THEN DO:
                    CREATE int-recorrencia-notas.                                                                                                                               
                    ASSIGN int-recorrencia-notas.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")                      
                           int-recorrencia-notas.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") 
                           int-recorrencia-notas.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")
                           int-recorrencia-notas.nr-transacao   = "1"
                           int-recorrencia-notas.nr-pedido      = tt-ped-venda.nr-pedido                        
                           int-recorrencia-notas.cod-estabel    = tt-ped-venda.cod-estabel.
                END.
            END.
        END.

        RUN pi-gerar-dados-extrato ("> DEPOIS atualizaFinal").

        FOR EACH ttErro:

            ASSIGN i-seq = i-seq + 1.

            CREATE int-recorrencia-historico.                                                                                                                               
            ASSIGN int-recorrencia-historico.id-recorrencia = ENTRY(2,ttPedido.numeroPedido,"-")                      
                   int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,ttPedido.numeroPedido,"-")),"999999") 
                   int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,ttPedido.numeroPedido,"-")),"99")     
                   int-recorrencia-historico.nr-transacao   = "1"                             
                   int-recorrencia-historico.nr-sequencia   = i-seq
                   int-recorrencia-historico.dt-evento      = TODAY                                                                                                          .
                   int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                          .
                   int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                  .
                   int-recorrencia-historico.desc-evento    = STRING(ttErro.codigoErro) + " - " + ttErro.mensagem.

        END.


    END.

    RETURN "OK".

END PROCEDURE.
  
PROCEDURE pi-completa-pedido:

    DEFINE VARIABLE h-bodi159cal           AS HANDLE NO-UNDO.
    
    /************************/
    /* COMPLETANDO O PEDIDO */
    /************************/
    EMPTY TEMP-TABLE RowErrors.
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
    RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda), OUTPUT TABLE RowErrors).
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** cr‚dito nÆo aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
       ASSIGN l-erro = YES.
    END.
     
    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
        RUN destroyBO IN  h-bodi159cal.
    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.

END PROCEDURE.


PROCEDURE pi-aprova-pedido:

   FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
          AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.
   IF AVAIL ped-venda AND ped-venda.cod-sit-aval = 3 THEN
       RETURN "OK".

   IF NOT AVAILABLE (ped-venda) THEN 
       RETURN 'NOK'.

   FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
          ped-venda.desc-bloq-cr       = ''
          ped-venda.dsp-pre-fat        = YES 
          ped-venda.cod-message-alerta = 0
          ped-venda.dt-mensagem        = ?
          ped-venda.nome-prog          = ''
          ped-venda.dt-apr-cred        = TODAY.
   FIND CURRENT ped-venda NO-LOCK NO-ERROR.
   RELEASE ped-venda.

   RETURN 'OK'.

END PROCEDURE.

PROCEDURE pi-fatura-pedido:

    DEFINE INPUT        PARAMETER c-nr-pedcli AS CHAR NO-UNDO.

    RUN pi-gerar-dados-extrato ("> INICIO pi-esftp016rp").

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.

    DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli = c-nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        RUN pi-gerar-dados-extrato ("> INICIO2 pi-esftp016rp").

        IF ped-venda.cod-priori <> 7 THEN DO:


            FOR EACH mgesp.ponto-programa NO-LOCK
               WHERE ponto-programa.nome-programa = "espdp006"
                 AND ponto-programa.ponto         = 11,  
                EACH mgesp.conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
               ASSIGN c-servidor = entry(1,conteudo-programa.conteudo, ";").
        
            END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

            /* Presa pelo faturamento comercial */
            DO TRANS:
                FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN ped-venda.cod-priori = 07 . 
            END.

            FIND CURRENT ped-venda NO-LOCK NO-ERROR.

            FOR EACH ped-item NO-LOCK
               WHERE ped-item.nome-abrev = ped-venda.nome-abrev
                 AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                IF ped-item.qt-log-aloc <> 0 or
                   ITEM.baixa-estoq = NO THEN DO:

                    CREATE tt-digita.
                    ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                           tt-digita.nr-pedcli      = ped-venda.nr-pedcli 
                           tt-digita.c-it-codigo    = ped-item.it-codigo    
                           tt-digita.c-cod-refer    = ped-item.cod-refer    
                           tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                END.
                ELSE DO:

                    FIND FIRST prod-composto WHERE prod-composto.it-codigo-filho = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL prod-composto THEN DO:

                        FIND FIRST ITEM WHERE ITEM.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                        IF AVAIL ITEM THEN DO:

                            IF item.baixa-estoq = NO THEN DO:
                                CREATE tt-digita.
                                ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                                       tt-digita.nr-pedcli      = ped-venda.nr-pedcli   
                                       tt-digita.c-it-codigo    = ped-item.it-codigo    
                                       tt-digita.c-cod-refer    = ped-item.cod-refer    
                                       tt-digita.i-nr-sequencia = ped-item.nr-sequencia 
                                       .
                            END. /* IF item.baixa-estoq = NO THEN DO: */
                        END. /* IF AVAIL ITEM THEN DO: */
                    END. /* IF AVAIL prod-composto THEN DO: */
                END.
            END.

            RUN pi-gerar-dados-extrato ("> INICIO3 pi-esftp016rp").

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "wso0003":U, INPUT 14, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto NO-ERROR.

            create tt-param.
            assign tt-param.usuario     = IF AVAIL tt-prog-ponto THEN tt-prog-ponto.conteudo ELSE "integra-glx"
                   tt-param.destino     = 2
                   tt-param.data-exec   = today
                   tt-param.hora-exec   = time

                   tt-param.nome-abrev  = ped-venda.nome-abrev 
                   tt-param.nr-pedcli   = ped-venda.nr-pedcli 
                   tt-param.Cod-depos   = "wex"
                   tt-param.Localizacao = "".

            ASSIGN tt-param.arquivo = "esftp016rpFatCom_UNIX.tmp".

            RAW-TRANSFER tt-param TO raw-param.
            FOR each tt-digita NO-LOCK:
                create tt-raw-digita.
                raw-transfer tt-digita to tt-raw-digita.raw-digita.
            END.

            ASSIGN p_cod_prog_dtsul_w    = "esftp016rp"           
                   p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rp.p"
                   p_cod_release         = '2.00.00.000'                    
                   p_cdn_estil_dwb       = 97                   
                   p_arquivo             = "esftp016rpFatCom.tmp" 
                   p_destino             = 2                    
                   p_raw_param           = raw-param.  

            create tt_param_segur.
            assign tt_param_segur.tta_num_vers_integr_api      = 3
                   tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
                   tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)
                   tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
                   tt_param_segur.tta_cod_idiom_usuar          = "POR":U
                   tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
                   tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
                   tt_param_segur.tta_cod_usuar_corren         = tt-param.usuario
                   tt_param_segur.tta_cod_usuar_corren_criptog = ENCODE(tt-param.usuario).

            create tt_ped_exec.
            assign tt_ped_exec.tta_num_seq                = 1
                   tt_ped_exec.tta_cod_usuario            = tt-param.usuario
                   tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
                   tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
                   tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
                   tt_ped_exec.tta_dat_exec_ped_exec      = today
                   tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")
                   tt_ped_exec.tta_cod_servid_exec        = c-servidor
                   tt_ped_exec.tta_cdn_estil_dwb          = 97.

            create tt_ped_exec_param.
            assign tt_ped_exec_param.tta_num_seq              = 1
                   tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"
                   tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
                   tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

            raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.

            ASSIGN i-cont-aux = 0.
            FOR EACH tt-raw-digita NO-LOCK: 
                 ASSIGN i-cont-aux = i-cont-aux + 1.
                 CREATE tt_ped_exec_param_aux.
                 ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux
                        tt_ped_exec_param_aux.tta_num_seq            = 1
                        tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
            END.

            run btb/btb912zb.p (input-output table tt_param_segur,
                                input-output table tt_ped_exec,
                                input table tt_ped_exec_param,
                                input table tt_ped_exec_param_aux,
                                input table tt_ped_exec_sel).

            FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.
            IF AVAIL tt_ped_exec THEN DO TRANS:

                ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.

                FIND FIRST fat-comercial EXCLUSIVE-LOCK
                     WHERE fat-comercial.num-ped-exec = tt_ped_exec.tta_num_ped_exec
                       AND fat-comercial.nr-pedcli    = c-nr-pedcli  NO-ERROR.

                IF NOT AVAIL fat-comercial THEN DO:
                    CREATE fat-comercial.                          
                    ASSIGN fat-comercial.nr-sequencia    = 10 
                           fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME 
                           fat-comercial.nome-abrev      = ped-venda.nome-abrev
                           fat-comercial.nr-pedcli       = ped-venda.nr-pedcli 
                           fat-comercial.num-ped-exec    = tt_ped_exec.tta_num_ped_exec
                           fat-comercial.tipo            = 1.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    ASSIGN fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME.
                END.
                FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

            END. /* IF AVAIL tt_ped_exec THEN DO: */

            RUN pi-gerar-dados-extrato ("> INICIO4 pi-esftp016rp").

        END. /* IF ped-venda.cod-priori = 10 THEN DO: */

    END. /* IF AVAIL ped-venda THEN DO: */

END PROCEDURE.
   
PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put UNFORMATTED "     " + c-lbl-liter-ponto-executado + ": " p-string " - " + STRING(DATETIME(TODAY, MTIME)) skip.
        output close. 
    
    end.
END.

RETURN "OK".
