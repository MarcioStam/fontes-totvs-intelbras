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
DEFINE VARIABLE i-seq                       AS INTEGER      NO-UNDO INITIAL 0.
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
DEFINE VARIABLE c-nat-operacao  AS CHAR        NO-UNDO.
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

    DEFINE VARIABLE i-seq-contato     AS INT         NO-UNDO.
    DEFINE VARIABLE l-item-mibo       AS LOG         NO-UNDO.
    DEFINE VARIABLE c-rua             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nro             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-comp            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-cdapi704        AS HANDLE      NO-UNDO.

    IF c-evento = "aposInicio" THEN DO:

        FOR EACH ttItem:
            ASSIGN ttItem.estabelecimento = "101".
        END.

        FIND FIRST ttPedido NO-ERROR.
        IF ttPedido.dataCriacao > TODAY THEN
            ASSIGN ttPedido.dataCriacao = TODAY.

        FIND FIRST ttDocumento
             WHERE ttDocumento.tipoDocumento = "CNPJ" NO-ERROR.
        IF NOT AVAIL ttDocumento THEN NEXT.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = ttDocumento.numeroDocumento NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.

        FIND FIRST ttPessoaJuridica NO-LOCK NO-ERROR.

        ASSIGN ttPessoaJuridica.nomeFantasia = emitente.nome-emit
               ttPessoaJuridica.nomeFantasia = emitente.nome-emit.

        FOR EACH ttEmail:
            ASSIGN ttEmail.endereco = emitente.e-mail.
        END.

        FOR EACH ttTelefone:
            ASSIGN ttTelefone.ddd      = ""
                   ttTelefone.telefone = emitente.telefone[1].
        END.

        /** Valida»’o do endere»o **/
        run cdp/cdapi704.p persistent set h-cdapi704.
        run pi-trata-endereco in h-cdapi704 (input emitente.endereco, output c-rua, output c-nro, output c-comp).
        delete procedure h-cdapi704.

        FOR EACH ttEndereco:
            ASSIGN ttEndereco.logradouro  = c-rua
                   ttEndereco.cep         = emitente.cep
                   ttEndereco.bairro      = emitente.bairro
                   ttEndereco.municipio   = emitente.cidade
                   ttEndereco.siglaEstado = emitente.estado
                   ttEndereco.complemento = c-comp
                   ttEndereco.numero      = c-nro
                   ttEndereco.siglaPais   = emitente.pais
                   ttEndereco.tipo        = "principal".
        END.
    
        FIND FIRST int-pedido-param NO-LOCK
             WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
               AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
        IF AVAIL int-pedido-param THEN DO:
            FOR EACH ttItem:
                 FIND FIRST transporte NO-LOCK 
                      WHERE transporte.cod-trans = int(ttItem.codigoTransportadora) NO-ERROR.
                 IF NOT AVAIL transporte THEN
                     ASSIGN ttItem.codigoTransportadora = STRING(int-pedido-param.cod-transp).

                 FIND FIRST estabelec NO-LOCK 
                      WHERE estabelec.cod-estabel = ttItem.estabelecimento NO-ERROR.
                 IF NOT AVAIL estabelec THEN
                     ASSIGN ttItem.estabelecimento = int-pedido-param.cod-estab-pad.
            END.
        END.        

        /* Valor assumido pelo afiliado Skyhub - intelbras(BWW) */
        FOR EACH ttCondicaoPagamento
           WHERE ttCondicaoPagamento.formaPagamento BEGINS "Valor":
            ASSIGN ttCondicaoPagamento.formaPagamento = "0".
        END.
    END.

    IF c-evento = "aposCriaTTEmitente" THEN DO:

        FIND FIRST tt-emitente NO-ERROR.

        IF AVAIL tt-emitente THEN DO:
            ASSIGN tt-emitente.ind-cre-cli     = 1
                   tt-emitente.ind-lib-estoque = YES.
        END.        

        IF CAN-FIND(FIRST emitente
                    WHERE emitente.cod-emitente = tt-emitente.cod-emitente) THEN NEXT.
        
        FIND FIRST int-emitente 
             WHERE int-emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL int-emitente THEN DO:
            CREATE int-emitente.
            ASSIGN int-emitente.cod-emitente = tt-emitente.cod-emitente
                   int-emitente.cod-gr-cob   = 9.
        END.
        FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN int-emitente.guid-subclass = "5D56C688-6EED-E311-9407-00155D013D38".
        FIND CURRENT int-emitente NO-LOCK NO-ERROR.
        RELEASE int-emitente.

        FIND FIRST int-emitente-canal 
             WHERE int-emitente-canal.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL int-emitente-canal THEN DO:

            CREATE int-emitente-canal.
            ASSIGN int-emitente-canal.cod-emitente        = tt-emitente.cod-emitente
                   int-emitente-canal.cod-emitente-matriz = tt-emitente.cod-emitente
                   int-emitente-canal.guid-filial         = STRING(tt-emitente.cod-emitente).
        END.

        FIND CURRENT int-emitente-canal EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN int-emitente-canal.PossuiEstruturaCompleta = 993520001
               int-emitente-canal.TipoRelacao             = 993520001
               int-emitente-canal.PossuiFiliais           = 993520001
               int-emitente-canal.OrigemConta             = 993520005
               int-emitente-canal.StatusIntegracaoSefaz   = 993520000
               int-emitente-canal.TipoEndereco            = 3
               int-emitente-canal.categoria               = "e0aeb351-6eed-e311-9407-00155d013d38".
        FIND CURRENT int-emitente-canal NO-LOCK NO-ERROR.
        RELEASE int-emitente-canal.
        
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

        FIND FIRST emitente 
             WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.

        IF AVAIL emitente THEN DO:
            IF emitente.ind-cre-cli <> 1 OR emitente.ind-lib-estoque <> YES THEN DO:
    
                FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente.ind-cre-cli     = 1
                       emitente.ind-lib-estoque = YES.
                FIND CURRENT emitente NO-LOCK NO-ERROR.
                RELEASE emitente.
    
            END.
        END.
    END.

    IF c-evento = "aposCriaTTPedVenda" THEN DO:
        FIND FIRST tt-ped-venda NO-ERROR.
        ASSIGN tt-ped-venda.cod-cond-pag = 544.
    END.

    IF c-evento = "atualizaFinal" THEN DO:

        FIND FIRST tt-ped-venda NO-ERROR.

        FOR FIRST ped-venda EXCLUSIVE-LOCK
            WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
              AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev:
            FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
                ASSIGN ped-item.nat-operacao = "500001"
                       ped-item.dt-min-fat   = ped-item.dt-min-fat - 30
                       ped-item.qt-log-aloca = ped-item.qt-pedida.
            END.
            ASSIGN ped-venda.nat-operacao = "500001"
                   ped-venda.completo     = NO.
        END.

        /************************/
        /* COMPLETANDO O PEDIDO */
        /************************/
        RUN pi-completa-pedido.

        IF AVAIL tt-ped-venda THEN DO:
            RUN aprovaPedido.        
            RUN pi-esftp016rp(INPUT tt-ped-venda.nr-pedcli).
        END.

        RUN pi-gerar-dados-extrato ("> DEPOIS atualizaFinal").

    END.
    
    FIND CURRENT ped-venda NO-LOCK NO-ERROR.
    RELEASE ped-venda.
    
    RETURN "OK".

END.

PROCEDURE pi-completa-pedido:

    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

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


PROCEDURE aprovaPedido:

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

PROCEDURE pi-esftp016rp:

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

                IF ped-item.qt-log-aloc <> 0 
                OR ITEM.baixa-estoq = NO THEN DO:

                    FOR FIRST tt-prog-ponto
                        WHERE entry(1,tt-prog-ponto.conteudo,";") = ped-item.it-codigo:
                        CREATE tt-digita.
                        ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                               tt-digita.nr-pedcli      = ped-venda.nr-pedcli 
                               tt-digita.c-it-codigo    = ped-item.it-codigo    
                               tt-digita.c-cod-refer    = ped-item.cod-refer    
                               tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                    END.
                END.
                ELSE DO:

                    FIND FIRST prod-composto WHERE prod-composto.it-codigo-filho = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL prod-composto THEN DO:

                        FIND FIRST ITEM WHERE ITEM.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                        IF AVAIL ITEM THEN DO:

                            IF item.baixa-estoq = NO THEN DO:

                                FOR FIRST tt-prog-ponto
                                    WHERE entry(1,tt-prog-ponto.conteudo,";") = ped-item.it-codigo:
                                    CREATE tt-digita.
                                    ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                                           tt-digita.nr-pedcli      = ped-venda.nr-pedcli   
                                           tt-digita.c-it-codigo    = ped-item.it-codigo    
                                           tt-digita.c-cod-refer    = ped-item.cod-refer    
                                           tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                                END.
                            END. /* IF item.baixa-estoq = NO THEN DO: */
                        END. /* IF AVAIL ITEM THEN DO: */
                    END. /* IF AVAIL prod-composto THEN DO: */
                END.
            END.

            FIND FIRST ttPedido NO-ERROR.
            FIND FIRST int-pedido-param NO-LOCK
                 WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
                   AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
            IF NOT AVAIL int-pedido-param THEN
                RETURN 'NOK'.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "wso0003":U, INPUT 11, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto NO-ERROR.

            create tt-param.
            assign tt-param.usuario     = IF AVAIL tt-prog-ponto THEN tt-prog-ponto.conteudo ELSE "integra" /* c-seg-usuario */
                   tt-param.destino     = 2
                   tt-param.data-exec   = today
                   tt-param.hora-exec   = time

                   tt-param.nome-abrev  = ped-venda.nome-abrev 
                   tt-param.nr-pedcli   = ped-venda.nr-pedcli 
                   tt-param.Cod-depos   = int-pedido-param.deposito-pad
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


