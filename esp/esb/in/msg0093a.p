{method/dbotterr.i}
{esp/esb/in/msg0093.i}
{utp/ut-glob.i}
{esp/es0018.i}

DEFINE TEMP-TABLE item-pedido-copia NO-UNDO LIKE item-pedido.

DEFINE TEMP-TABLE tt-ped-repre      NO-UNDO LIKE ped-repre
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

def temp-table tt-erro-aloc no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE TEMP-TABLE tt-ped-venda      NO-UNDO LIKE ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-venda  NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-item       NO-UNDO LIKE ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item   NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item-rebate   NO-UNDO LIKE int-ped-item-rebate
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda-aux  NO-UNDO LIKE tt-ped-venda.

DEFINE TEMP-TABLE tt-ped-vendor     NO-UNDO
    FIELD data-base    AS DATE
    FIELD dias-base    AS INT  FORMAT ">>>9"
    FIELD cod-cond-pag AS INT  FORMAT ">9"
    FIELD taxa-cliente AS DEC  FORMAT ">>9.9999".


DEFINE INPUT  PARAM TABLE FOR msg0093.
DEFINE INPUT  PARAM TABLE FOR item-pedido.
DEFINE INPUT  PARAM TABLE FOR cabecalho.
DEFINE INPUT  PARAM TABLE FOR parcela.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.
DEFINE OUTPUT PARAM TABLE FOR msg0093r.
DEFINE OUTPUT PARAM TABLE FOR pedidor.
DEFINE OUTPUT PARAM TABLE FOR Itensr.
DEFINE OUTPUT PARAM TABLE FOR item-pedidor.


DEFINE BUFFER b-item-pedido  FOR item-pedido.
DEFINE BUFFER b-tt-ped-venda FOR tt-ped-venda.
DEFINE BUFFER b-tt-ped-item  FOR tt-ped-item.

DEFINE BUFFER b-item-solar FOR ITEM.
DEFINE VAR i-cont-solar AS INT NO-UNDO.
DEFINE VAR l-seq-disp   AS LOG NO-UNDO.


DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd     AS INTEGER.

DEFINE VARIABLE l-off-grid           AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE l-abriu-ped          AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE de-perc-icms         AS DECIMAL                       NO-UNDO.
DEFINE VARIABLE c-cod-estabel        AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE de-valor-st          AS DECIMAL                       NO-UNDO.
DEFINE VARIABLE h-bodi159sus         AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi159cal         AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi154            AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi154cal         AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi317im1br       AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi157            AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi159            AS HANDLE                        NO-UNDO.
DEFINE VARIABLE h-bodi154sdf         AS HANDLE                        NO-UNDO.          
DEFINE VARIABLE l-error              AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE c-desc-suspend       AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe         LIKE tt-ped-item.vl-liq-abe      NO-UNDO.
DEFINE VARIABLE d-vl-liq-it          LIKE tt-ped-item.vl-liq-abe      NO-UNDO.
DEFINE VARIABLE i-cont-nat-igual     AS INTEGER                       NO-UNDO.
DEFINE VARIABLE i-nr-pedido          AS INTEGER                       NO-UNDO.
DEFINE VARIABLE c-obs                AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE c-prazo              AS CHARACTER                     NO-UNDO.                                                                   
DEFINE VARIABLE i-cd-unid-comerc     AS INTEGER                       NO-UNDO.
DEFINE VARIABLE c-transp             LIKE transporte.nome-abrev       NO-UNDO.
DEFINE VARIABLE c-nat-oper           LIKE natur-oper.nat-operacao     NO-UNDO.
DEFINE VARIABLE l-return             AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE c-nat-oper-cabecalho LIKE natur-oper.nat-operacao     NO-UNDO.
DEFINE VARIABLE i-sequencia          AS INTEGER                       NO-UNDO.
DEFINE VARIABLE c-nr-pedido-retorno  AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE c-sigla-transp       LIKE def-transportes.sigla-trans NO-UNDO.
DEFINE VARIABLE c-cod-transp         LIKE transporte.cod-trans        NO-UNDO.
DEFINE VARIABLE i-cont               AS INTEGER                       NO-UNDO.
DEFINE VARIABLE h-boes505            AS HANDLE                        NO-UNDO.
DEFINE VARIABLE l-consumo            AS LOG INIT NO                   NO-UNDO.
DEFINE VARIABLE lsuspendeped         AS LOGICAL                       NO-UNDO.
DEF VAR i-canal-venda-benef AS INTEGER NO-UNDO.
DEF VAR i-cond-pagto-benef  AS INTEGER NO-UNDO.
DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nat-oper-dentro-estado-contrib     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-dentro-estado-nao-contrib AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-contrib       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-nao-contrib   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-icms                              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-ok                                 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-deposito-solar                     AS CHAR        NO-UNDO.

DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

/* FIND FIRST ponto-programa NO-LOCK                                          */
/*      WHERE ponto-programa.nome-programa = "escrm004":U                     */
/*        AND ponto-programa.ponto         = 1 NO-ERROR.                      */
/*                                                                            */
/* IF AVAIL ponto-programa THEN DO:                                           */
/*     FOR FIRST conteudo-programa NO-LOCK                                    */
/*         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa */
/*           AND conteudo-programa.sequencia    = 1:                          */
/*                                                                            */
/*         ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")         */
/*                c-senha   = ENTRY(2,conteudo-programa.conteudo,",").        */
/*     END.                                                                   */
/* END.                                                                       */
/*                                                                            */
/* if v_cod_usuar_corren = "" or                                              */
/*    v_cod_usuar_corren = c-usuario then do:                                 */
/*                                                                            */
/*    /* Login no EMS */                                                      */
/*    run bi/esbi002.p (input c-usuario,                                      */
/*                      input c-senha).                                       */
/* end.                                                                       */

FIND FIRST para-ped     NO-LOCK NO-ERROR.
FIND FIRST para-fat     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

FIND FIRST cabecalho NO-LOCK NO-ERROR.

RUN pi-log (INPUT "Inicio API: " + STRING(TODAY,"99/99/9999") + " - " + STRING(TIME,"HH:MM:SS")).

IF  NOT VALID-HANDLE(h-boes505) THEN
    RUN esbo/boes505.p PERSISTENT SET h-boes505.

DO TRANSACTION
ON ERROR UNDO,LEAVE
ON STOP UNDO, LEAVE:
    FIND FIRST msg0093 NO-LOCK NO-ERROR.

   IF OPSYS = "UNIX" THEN log-manager:write-message('Eckel123').


    IF NOT AVAIL msg0093 THEN DO:
        RUN pi-erro (INPUT "Pedido Nao Criado no EMS, XML em branco").
    END.
    IF msg0093.CodigoClienteCRM = "" THEN DO:
        RUN pi-erro (INPUT "Pedido N∆o Criado no EMS, C¢digo do Cliente em Branco no CRM").
    END.

    FIND FIRST repres NO-LOCK
         WHERE repres.cod-rep = msg0093.Representante NO-ERROR.
    IF  NOT AVAIL repres THEN DO:
        RUN pi-erro (INPUT "Representante " + STRING(msg0093.Representante) + " n∆o cadastrado.").
    END.
    
    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = msg0093.CodigoClienteCRM NO-ERROR.

    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "Pedido N∆o Criado no EMS, C¢digo do Cliente N∆o Encontrado no CRM").
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    IF  NOT AVAIL emitente THEN DO:
        RUN pi-erro (INPUT "Cliente " + STRING(msg0093.CodigoClienteCRM) + " n∆o cadastrado.").
    END.

    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
         WHERE loc-entr.cod-entrega = "padrao"
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
    IF  NOT AVAIL loc-entr THEN DO:
        RUN pi-erro (INPUT "Local de entrega do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado.").
    END.

    FIND FIRST transporte NO-LOCK
         WHERE transporte.nome-abrev = loc-entr.nome-transp NO-ERROR.
    IF  NOT AVAIL transporte THEN DO:
        RUN pi-erro (INPUT "Transportador do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado no local de entrega.").
    END.

    ASSIGN c-transp = transporte.nome-abrev.

    /*N∆o tem condiá∆o de pagamento quando pedido vier a partir de benef°cio do canal*/
    IF  msg0093.origem    <> 9 
    AND msg0093.atendente <> 18 THEN DO:

        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = msg0093.CondicaoPagamento NO-ERROR.

        IF  NOT AVAIL cond-pagto
        AND msg0093.TipoNaturezaOperacao <> 2 
        AND msg0093.CondicaoPagamento <> 0 THEN DO:
            RUN pi-erro (INPUT "Condiá∆o de Pagamento " + STRING(msg0093.CondicaoPagamento) + " n∆o cadastrada.").
        END.
    END.
    
    /*/* Verificar se na Condiá∆o de Pagamento (CD0404) est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
    FIND FIRST int-cond-pagto NO-LOCK 
         WHERE int-cond-pagto.cod-cond-pag = msg0093.CondicaoPagamento NO-ERROR.

    IF AVAILABLE int-cond-pagto                       AND
       SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:

        FIND LAST int-param-supcard NO-LOCK NO-ERROR.

        FIND FIRST cond-pagto NO-LOCK 
             WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-ERROR.

        IF (tt-ped-venda-xml.vl-tot-ped / cond-pagto.num-parcelas) < int-param-supcard.val-min-parc THEN DO:
            RUN pi-erro (INPUT "A parcela de R$ ":U + TRIM(STRING((tt-ped-venda-xml.vl-tot-ped / cond-pagto.num-parcelas), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube Ç menor que o valor m°nimo permitido. (Parcela m°nima permitida do cart∆o Intelbras Clube: R$ ":U + TRIM(STRING(int-param-supcard.val-min-parc, "->>>,>>>,>>9.99":U)) + ").").
            RETURN "NOK":U.
        END.
        ASSIGN tt-ped-venda-xml.ds-observacao = tt-ped-venda-xml.ds-observacao + "Pedido suspenso, Pedido via Intelbras Clube, verificar juros de acordo com a condiá∆o de pagto".
    END.*/

    ASSIGN c-cod-estabel = msg0093.Estabelecimento.

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR.

    IF NOT AVAIL estabelec THEN
        RUN pi-erro (INPUT "Estabelecimento n∆o cadastrado!").

    IF msg0093.DataEntrega > TODAY + 730 THEN
        RUN pi-erro (INPUT "Data de entrega superior a 2 anos!").

    IF cabecalho.IdentidadeEmissor = "8F4E5DB0-466C-4ED5-9B67-257D5620E67E" THEN DO: //plataforma solar

        ASSIGN l-seq-disp = NO.
        RUN esp/es0018p.p (INPUT  "solar":U, // deposito padrao da solar
                           INPUT  9,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
          
        FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:

            do i-cont-solar = int(entry(1,tt-prog-ponto.conteudo,";")) TO int(entry(2,tt-prog-ponto.conteudo,";")):
               find first b-item-solar 
                    WHERE b-item-solar.it-codigo = string(i-cont-solar) no-lock no-error.
               //assign i-item = i-cont-solar.
               if not avail b-item-solar then DO:
                   ASSIGN l-seq-disp = YES.
                   LEAVE.
               END.
            END.
            IF NOT l-seq-disp THEN
               RUN pi-erro (INPUT "Faixa de itens ja utilizada. Favor solicitar uma nova faixa de itens a central de cadastro.").
        END.

        FOR EACH int-ped-venda NO-LOCK
           WHERE int-ped-venda.cod-projeto =  entry(1,msg0093.dadosSolar,";"):
        
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
            IF AVAIL ped-venda THEN DO:
                IF (ped-venda.cod-sit-ped = 1 OR
                    ped-venda.cod-sit-ped = 2 OR
                    ped-venda.cod-sit-ped = 3) THEN DO:

                    RUN pi-erro (INPUT "Projeto " + entry(1,msg0093.dadosSolar,";") + " ja implantado no pedido " + string(int-ped-venda.nr-pedido)).
                    LEAVE.
                END.
            END.
        END.
       
    END.

    IF cabecalho.IdentidadeEmissor = "FD95494F-95B8-48ED-8831-D280C53CBCA1" THEN DO: //assist

        IF msg0093.NumeroPedidoCliente BEGINS "EXP" THEN DO:

            FOR EACH int-ped-venda NO-LOCK
               WHERE SUBSTRING(int-ped-venda.char-1,53,12) = msg0093.NumeroPedidoCliente:
          
                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
                IF AVAIL ped-venda THEN DO:
                    IF (ped-venda.cod-sit-ped = 1 OR
                        ped-venda.cod-sit-ped = 2 OR
                        ped-venda.cod-sit-ped = 3) THEN DO:
          
                        RUN pi-erro (INPUT "Pedido " + string(msg0093.NumeroPedidoCliente) + " ja implantado no pedido " + string(int-ped-venda.nr-pedido)).
                        LEAVE.
                    END.
                END.
            END.    
        END.        
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".


    IF OPSYS = "UNIX" THEN log-manager:write-message('msg0093.origem: ' + string(msg0093.origem)).
    IF  msg0093.origem <> 9 THEN DO:

        /* Para Show Room e StockBackup tem que gerar como consumo */
        ASSIGN l-consumo = IF (msg0093.tp-beneficio = 15 OR msg0093.tp-beneficio = 04) THEN YES /*Consumo*/ ELSE NO.
        
        /*Campo vem com valor quando proveniente da esesbapi007-solicita.p, a° deve utilizar esse valor*/
        ASSIGN i-cond-pagto-benef = msg0093.canal-venda.

        IF msg0093.TipoNaturezaOperacao = 2 THEN DO:
            FOR FIRST ponto-programa
                WHERE ponto-programa.nome-programa = "escrm034",
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(c-cod-estabel):
               
                ASSIGN c-nat-oper-dentro-estado-contrib     = ENTRY(1,conteudo-programa.conteudo)
                       c-nat-oper-dentro-estado-nao-contrib = ENTRY(2,conteudo-programa.conteudo)
                       c-nat-oper-fora-estado-contrib       = ENTRY(3,conteudo-programa.conteudo)
                       c-nat-oper-fora-estado-nao-contrib   = ENTRY(4,conteudo-programa.conteudo).
    
                FIND FIRST natur-oper NO-LOCK 
                     WHERE natur-oper.nat-operacao = IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-dentro-estado-contrib
                                                ELSE IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-dentro-estado-nao-contrib
                                                ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-fora-estado-contrib         
                                                ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-fora-estado-nao-contrib
                                                ELSE "" NO-ERROR.
    
                IF NOT AVAIL natur-oper THEN
                    RUN pi-erro (INPUT "Natureza de operaá∆o parametrizada n∆o cadastrada. - " + " Cod Cliente: " + string(emitente.cod-emitente)).
                ELSE 
                    ASSIGN c-nat-oper = natur-oper.nat-operacao.
            END.
        END.
        ELSE DO:
            IF emitente.contrib-icms = YES THEN 
                ASSIGN l-consumidor-final = NO.
            ELSE 
                ASSIGN l-consumidor-final = YES.
        
            RUN defineNatOperacao IN h-boes505 (INPUT  c-cod-estabel,
                                                INPUT  emitente.cod-emitente,
                                                INPUT  "padrao",
                                                INPUT  "",
                                                INPUT  l-consumidor-final,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
        
    
            IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel1 ' + c-cod-estabel).
            IF OPSYS = "UNIX" THEN log-manager:write-message('l-consumo: ' + string(l-consumo)).
            IF OPSYS = "UNIX" THEN log-manager:write-message('c-nat-oper: ' + c-nat-oper).
        
            IF  NOT l-return THEN DO:
                RUN pi-erro (INPUT "Natureza de operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + c-cod-estabel).
            END.
        END.
    END.
    ELSE DO: /*Bonificaá∆o - Pedidos gerados via Solicitaá∆o de Benef°cios na Extranet */

        RUN pi-retorna-dados-beneficios  (INPUT estabelec.estado,
                                          INPUT IF AVAIL loc-entr THEN loc-entr.cidade ELSE emitente.cidade,
                                          INPUT IF AVAIL loc-entr THEN loc-entr.estado ELSE emitente.estado,       
                                          INPUT msg0093.cod-unid-neg,         
                                          INPUT msg0093.tp-beneficio,     
                                          OUTPUT c-nat-oper,
                                          OUTPUT i-canal-venda-benef).

    END.

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    IF  NOT AVAIL natur-oper THEN DO:
        RUN pi-erro (INPUT "Natureza de Operaá∆o " + c-nat-oper + " inv†lida no cadastro do Cliente " + STRING(emitente.cod-emitente)).
    END.

    FIND FIRST int-emitente NO-LOCK
        WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    IF  AVAIL  int-emitente           AND
        int-emitente.id-ativo   = NO  AND
        natur-oper.emite-duplic = YES THEN DO:
        RUN pi-erro (INPUT "Cliente n∆o esta ativo, n∆o Ç possivel integrar pedidos. Cliente " + STRING(emitente.cod-emitente ) + " - " + emitente.nome-emit).
    END.
    
    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    ASSIGN c-nat-oper-cabecalho = natur-oper.nat-operacao.

    CREATE tt-ped-venda.
    ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
           tt-ped-venda.nr-pedcli  = STRING(tt-ped-venda.nr-pedido)
           tt-ped-venda.nome-abrev = emitente.nome-abrev
           i-sequencia             = 0.
    ASSIGN c-nr-pedido-retorno     = tt-ped-venda.nr-pedcli.
    
    RUN pi-log (INPUT "c-nr-pedido-retorno " + c-nr-pedido-retorno).
    RUN pi-log (INPUT "msg0093.CondicaoEspecial " + msg0093.CondicaoEspecial).
    
    IF  msg0093.Observacao = ? THEN
        ASSIGN msg0093.Observacao = "".

    ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
           tt-ped-venda.dt-emissao              = msg0093.DataEmissao
           tt-ped-venda.no-ab-reppri            = repres.nome-abrev
           tt-ped-venda.dt-implant              = TODAY
           tt-ped-venda.cod-emitente            = emitente.cod-emitente
           tt-ped-venda.nat-operacao            = natur-oper.nat-operacao
           tt-ped-venda.cod-mensagem            = natur-oper.cod-mensagem
           tt-ped-venda.cod-cond-pag            = msg0093.CondicaoPagamento
           tt-ped-venda.nr-tab-fin              = IF msg0093.origem <> 9 AND msg0093.atendente <> 18 AND msg0093.TipoNaturezaOperacao <> 2 AND msg0093.CondicaoPagamento <> 0 THEN cond-pagto.nr-tab-finan ELSE 1 /* fixo canais, AndrÇ Andersen*/
           tt-ped-venda.nr-ind-finan            = IF msg0093.origem <> 9 AND msg0093.atendente <> 18 AND msg0093.TipoNaturezaOperacao <> 2 AND msg0093.CondicaoPagamento <> 0 THEN cond-pagto.nr-ind-finan ELSE 1 /* fixo canais, conforme orientaá∆o do AndrÇ Andersen */
           tt-ped-venda.tp-pedido               = STRING(msg0093.Atendente) /*IF AVAIL crm-atendente THEN STRING(crm-atendente.cd-atend, "99") ELSE*/ 
           tt-ped-venda.e-mail                  = emitente.e-mail
           tt-ped-venda.cod-sit-aval            = 1 /* Credito N∆o Avaliado */
           tt-ped-venda.mo-codigo               = 0
           tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
           tt-ped-venda.tp-faturam              = 1
           /*tt-ped-venda.origem                  = 6*/
           tt-ped-venda.atendido                = NO
           tt-ped-venda.cd-origem               = 2
           tt-ped-venda.user-impl               = "adm"
           tt-ped-venda.dt-userimp              = TODAY
           tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
           tt-ped-venda.observacoes             = msg0093.Observacao
           tt-ped-venda.cond-espec              = IF msg0093.NumeroPedidoCliente <> "" AND msg0093.NumeroPedidoCliente <> "0" THEN "OC: " + msg0093.NumeroPedidoCliente + " " + msg0093.CondicaoEspecial ELSE msg0093.CondicaoEspecial
           tt-ped-venda.esp-ped                 = 1
           tt-ped-venda.cod-priori              = IF  msg0093.origem = 9 THEN 
                                                      01
                                                  ELSE IF msg0093.Situacao = 1 THEN 
                                                          44 
                                                       ELSE 
                                                           01
           tt-ped-venda.cod-rota                = loc-entr.cod-rota
           tt-ped-venda.cod-canal-venda         = IF  i-canal-venda-benef > 0 THEN 
                                                      i-canal-venda-benef
                                                  ELSE IF natur-oper.cod-canal-venda <> 0 THEN 
                                                          natur-oper.cod-canal-venda 
                                                       ELSE 
                                                           emitente.cod-canal-venda
           tt-ped-venda.ind-ent-completa        = YES
           tt-ped-venda.dsp-pre-fat             = YES
           tt-ped-venda.log-usa-tabela-desconto = NO
           tt-ped-venda.cod-des-merc            = 1 
           tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota WHEN AVAIL para-ped
           OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

           IF msg0093.OrigemPedido = "" 
           OR msg0093.OrigemPedido = ? THEN DO:
               ASSIGN tt-ped-venda.origem = 12.
           END.
           ELSE DO:
               IF msg0093.OrigemPedido = "993520010" THEN
                   ASSIGN tt-ped-venda.origem = 1. /*Normal*/                                
               ELSE IF msg0093.OrigemPedido = "993520011"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 2. /*Tele Pedido*/                           
               ELSE IF msg0093.OrigemPedido = "993520012"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 3. /*Configurado*/                           
               ELSE IF msg0093.OrigemPedido = "993520013"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 4. /*Batch*/                                 
               ELSE IF msg0093.OrigemPedido = "993520014"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 5. /*Exportaá∆o*/                            
               ELSE IF msg0093.OrigemPedido = "993520015"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 6. /*EDI*/                                   
               ELSE IF msg0093.OrigemPedido = "993520000"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 7. /*Multiplanta*/                           
               ELSE IF msg0093.OrigemPedido = "993520001"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 8. /*Cotaá∆o*/                               
               ELSE IF msg0093.OrigemPedido = "993520002"  THEN                                                     
                   ASSIGN tt-ped-venda.origem = 9. /*Bonificaá∆o*/                           
               ELSE IF msg0093.OrigemPedido = "993520003" THEN                                                     
                   ASSIGN tt-ped-venda.origem = 10. /*Portal Datasul*/
               ELSE IF msg0093.OrigemPedido = "993520004" THEN
                   ASSIGN tt-ped-venda.origem = 11. /*SFA*/
               ELSE IF msg0093.OrigemPedido = "993520005" THEN
                   ASSIGN tt-ped-venda.origem = 12. /*WEB*/
               ELSE IF msg0093.OrigemPedido = "993520006" THEN
                   ASSIGN tt-ped-venda.origem = 13. /*B2B*/
               ELSE IF msg0093.OrigemPedido = "993520007" THEN
                   ASSIGN tt-ped-venda.origem = 14. /*CRM*/
               ELSE IF msg0093.OrigemPedido = "993520008" THEN
                   ASSIGN tt-ped-venda.origem = 15. /*CRM modificado no ERP*/
               ELSE IF msg0093.OrigemPedido = "993520009" THEN
                   ASSIGN tt-ped-venda.origem = 16. /*EAI*/
               ELSE IF msg0093.OrigemPedido = "993520016" THEN
                   ASSIGN tt-ped-venda.origem = 17. /*ASSIST*/
           END.

     FIND FIRST atendente
          WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR. 
     IF AVAIL atendente AND atendente.cod-gr-canais = 3 THEN DO: // codigo 3  verticais

         EMPTY TEMP-TABLE tt-prog-ponto.

         RUN esp/es0018p.p (INPUT  "pd4000":U,
                            INPUT  12,
                            INPUT  0,
                            INPUT  "":U,
                            OUTPUT TABLE tt-prog-ponto).

         FIND FIRST tt-prog-ponto NO-ERROR.

         ASSIGN tt-ped-venda.cod-priori = INT(tt-prog-ponto.conteudo).
     END.
         

    CREATE tt-int-ped-venda.
    ASSIGN tt-int-ped-venda.cod-estabel             = tt-ped-venda.cod-estabel
           tt-int-ped-venda.nr-pedido               = tt-ped-venda.nr-pedido
           /*tt-int-ped-venda.dt-negociacao           = msg0093.DataNegociacao
           tt-int-ped-venda.dias-negociacao         = msg0093.DiasNegociacao*/
           tt-int-ped-venda.vl-guid                 = /*tt-ped-venda-xml.guid-crm*/ ""
           OVERLAY(tt-int-ped-venda.char-1,12,3)    = "" /*STRING(tt-ped-venda-xml.cod-categoria)*/
           overlay(tt-int-ped-venda.char-1,1,8)     = STRING(TIME,"HH:MM:SS")
           OVERLAY(tt-int-ped-venda.char-1, 53, 12) = msg0093.NumeroPedidoCliente
           OVERLAY(tt-int-ped-venda.char-1,68,8)    = msg0093.CodigoSupervisorEMS
           tt-int-ped-venda.vl-serv-inst            = msg0093.ValorServicoInstalacao
           tt-int-ped-venda.reference-number        = msg0093.NumeroReferencia
           tt-int-ped-venda.tid                     = msg0093.tid.

    RUN pi-log (INPUT "tt-int-ped-venda.cod-estabel.: "     + string(tt-int-ped-venda.cod-estabel    )  + CHR(10) +
                      "tt-int-ped-venda.nr-pedido.: "       + string(tt-int-ped-venda.nr-pedido      )  + CHR(10) +
                      "tt-int-ped-venda.dt-negociacao.: "   + string(tt-int-ped-venda.dt-negociacao  )  + CHR(10) +
                      "tt-int-ped-venda.dias-negociacao.: " + string(tt-int-ped-venda.dias-negociacao) + CHR(10) +
                      "tt-int-ped-venda.vl-guid.: "         + string(tt-int-ped-venda.vl-guid        )  + CHR(10) +
                      "OVERLAY(tt-int-ped-venda.char-1,12,3) " + substring(tt-int-ped-venda.char-1,12,3) + CHR(10) +
                      "overlay(tt-int-ped-venda.char-1,1,8)"   + SUBSTRING(tt-int-ped-venda.char-1,1,8)  + CHR(10)).

/*     FIND FIRST int-emitente-pocli                                                                                                              */
/*         WHERE  int-emitente-pocli.cod-emitente = emitente.cod-emitente                                                                         */
/*           AND  int-emitente-pocli.po-cliente   = msg0093.NumeroPedidoCliente NO-LOCK NO-ERROR.                                                 */
/*     IF AVAIL int-emitente-pocli THEN DO:                                                                                                       */
/*         RUN pi-erro (INPUT "PO Cliente " + msg0093.NumeroPedidoCliente + " existente para o cliente " + STRING(emitente.cod-emitente) + ".").  */
/*         RETURN "NOK".                                                                                                                          */
/*     END. /* IF AVAIL int-emitente-pocli THEN DO: */                                                                                            */
/*     ELSE DO:                                                                                                                                   */
/*         CREATE int-emitente-pocli.                                                                                                             */
/*         ASSIGN int-emitente-pocli.cod-emitente = emitente.cod-emitente                                                                         */
/*                int-emitente-pocli.po-cliente   = msg0093.NumeroPedidoCliente.                                                                  */
/*     END. /* IF NOT AVAIL int-emitente-pocli THEN DO: */                                                                                        */
    

    IF  (msg0093.tp-beneficio = 15 OR msg0093.tp-beneficio = 04) THEN DO:
         ASSIGN tt-ped-venda.cod-des-merc = 2. /* Para ShowRoom e Stock Backup, sempre levar como Consumo Pr¢prio/Ativo conforme conversado com RogÇrio - da †rea fiscal */
    END.
    ELSE DO:
        IF  natur-oper.consum-final THEN
            ASSIGN tt-ped-venda.cod-des-merc = 2.
        ELSE
            ASSIGN tt-ped-venda.cod-des-merc = 1.
    END.


    IF  TODAY <= msg0093.DataEntrega THEN
        ASSIGN tt-ped-venda.dt-entrega = msg0093.DataEntrega 
               tt-ped-venda.dt-entorig = msg0093.DataEntrega.
    ELSE
        ASSIGN tt-ped-venda.dt-entrega = TODAY
               tt-ped-venda.dt-entorig = TODAY.

    IF  emitente.nome-tr-red <> "" THEN DO:
        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = emitente.nome-tr-red NO-ERROR.
        IF  NOT AVAIL transporte THEN DO:
            RETURN "NOK":U.
        END.
        ELSE
            ASSIGN tt-ped-venda.nome-tr-red = emitente.nome-tr-red.
    END.

    IF  AVAIL loc-entr THEN
        ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
               tt-ped-venda.bairro       = loc-entr.bairro
               tt-ped-venda.cidade       = loc-entr.cidade
               tt-ped-venda.pais         = loc-entr.pais
               tt-ped-venda.estado       = loc-entr.estado
               tt-ped-venda.cep          = loc-entr.cep
               tt-ped-venda.caixa-postal = loc-entr.caixa-postal
               tt-ped-venda.cgc          = loc-entr.cgc
               tt-ped-venda.ins-estadual = loc-entr.ins-estadual
               tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
               tt-ped-venda.cidade-cif   = loc-entr.nom-cidad-cif.
    ELSE DO:
        IF  AVAIL emitente THEN
            ASSIGN tt-ped-venda.local-entreg = emitente.endereco
                   tt-ped-venda.bairro       = emitente.bairro
                   tt-ped-venda.cidade       = emitente.cidade
                   tt-ped-venda.pais         = emitente.pais
                   tt-ped-venda.estado       = emitente.estado
                   tt-ped-venda.cep          = emitente.cep
                   tt-ped-venda.caixa-postal = emitente.caixa-postal
                   tt-ped-venda.cgc          = emitente.cgc
                   tt-ped-venda.ins-estadual = emitente.ins-estadual
                   tt-ped-venda.cidade-cif   = emitente.cidade.
    END.

    ASSIGN c-transp         = "":U
           c-sigla-transp   = "":U.

    /* Retorna Transportadora : Incidente - 26357 */
    RUN esp/crm/escrm107.p (INPUT tt-ped-venda.cod-estabel,
                            INPUT STRING(tt-ped-venda.cod-emitente),
                            INPUT tt-ped-venda.cidade,
                            INPUT tt-ped-venda.estado,
                            INPUT INT(SUBSTRING(tt-int-ped-venda.char-1,16,3)),
                            INPUT tt-ped-venda.cep,
                            OUTPUT c-cod-transp,
                            OUTPUT c-sigla-transp). 
    
    IF c-cod-transp = ? THEN DO:
        RUN pi-erro (INPUT "N∆o encontrada transportadora para relacionamento UF x Cidade x Cliente.").
        ASSIGN tt-ped-venda.nome-transp = "".
    END.
    ELSE DO:
        FOR FIRST transporte 
            WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
            ASSIGN c-transp = transporte.nome-abrev.
        END.

        ASSIGN tt-ped-venda.nome-transp              = c-transp /* transporte.nome-abrev Incidente - 26357 */
               OVERLAY(tt-int-ped-venda.char-1,20,5) = c-sigla-transp.  
    END.

    ASSIGN tt-ped-venda.ind-fat-par = msg0093.FaturamentoParcial.

    /* Criaá∆o do ped-vendor */
    IF msg0093.Vendor THEN DO:
        IF NOT CAN-FIND(FIRST tt-ped-vendor) THEN
            CREATE tt-ped-vendor.

        ASSIGN tt-ped-vendor.cod-cond-pag = tt-ped-venda.cod-cond-pag
               tt-ped-vendor.dias-base    = msg0093.DiasBase
               tt-ped-vendor.taxa-cliente = msg0093.TaxaCliente
               tt-ped-vendor.data-base    = ?
               tt-ped-venda.cod-cond-pag  = 502
               tt-ped-venda.cod-portador  = 999
               tt-ped-venda.modalidade    = 7.

        RUN pi-log (INPUT "Vendor "  + string(tt-ped-vendor.cod-cond-pag) + " = " + string(tt-ped-venda.cod-cond-pag)).

        ASSIGN c-prazo = ""
               i-cont  = 1.

        IF AVAIL cond-pagto THEN DO:
            DO WHILE cond-pagto.prazos[i-cont] <> 0:
                IF i-cont = 1 THEN
                    ASSIGN c-prazo = STRING(cond-pagto.prazos[1]).
                ELSE
                    ASSIGN c-prazo = c-prazo + "/" + STRING(cond-pagto.prazos[i-cont]).
    
                ASSIGN i-cont = i-cont + 1.
            END.
        END.

        ASSIGN c-obs = "VENDOR " + c-prazo + "  TX " + STRING(tt-ped-vendor.taxa-cliente ,">>9.99") + "%am".

        IF tt-ped-vendor.dias-base > 0 THEN
            ASSIGN c-obs = c-obs + " FECHAR APOS " + STRING(tt-ped-vendor.dias-base)  + " DIAS".

        ASSIGN tt-ped-venda.cond-espec   = TRIM(tt-ped-venda.cond-espec) + c-obs
               tt-ped-venda.dt-prev-vend = TODAY.
    END.
    ELSE DO:
          /* Atribuir Portador conforme o cadastro do cliente */
          IF emitente.portador <> 0 THEN
              ASSIGN tt-ped-venda.cod-portador = emitente.portador
                     tt-ped-venda.modalidade   = emitente.modalidade.
          ELSE
              ASSIGN tt-ped-venda.cod-portador = 999
                     tt-ped-venda.modalidade   = 6.
    END.

    FIND FIRST tt-ped-repre NO-LOCK
        WHERE  tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
        AND    tt-ped-repre.nome-ab-rep = repres.nome-abrev NO-ERROR.
    IF  NOT AVAIL tt-ped-repre THEN DO:
        CREATE tt-ped-repre.
        ASSIGN tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
               tt-ped-repre.ind-repbase = YES
               tt-ped-repre.perc-comis  = 0 /* O % de comiss∆o Ç calculado por relat¢rio */
               tt-ped-repre.nome-ab-rep = repres.nome-abrev.
    END.
    
    FOR EACH item-pedido:
        RUN pi-log (INPUT "Escrm012 = " + item-pedido.Produto).
        RUN CriaItem.
        IF RETURN-VALUE = "NOK" THEN
            RETURN "NOK".
        ELSE DO:
        END.
    END. /*FOR EACH item-pedido:*/

    RELEASE tt-ped-item.
    
    FOR EACH tt-ped-venda NO-LOCK:

        RUN pi-log (INPUT ">>>>>>>>>>>>>> escrm012 - dentro avail tt-ped-venda " + tt-ped-venda.nr-pedcli).
        
        FIND FIRST tt-ped-item NO-LOCK 
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli NO-ERROR.

        IF NOT AVAIL tt-ped-item THEN DO:
            
            FOR EACH tt-ped-repre NO-LOCK
               WHERE tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido:
                DELETE tt-ped-repre.
            END.

            RUN pi-erro (INPUT "Pedido sem itens favor reavaliar o pedido").
            RETURN "NOK".
        END.

        ASSIGN c-nat-oper-cabecalho = tt-ped-venda.nat-operacao
               i-cont-nat-igual     = 0.

        ASSIGN l-off-grid = NO.
        FOR EACH tt-ped-item 
           WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-ped-item.it-codigo:

            /*Suspens∆o produto composto*/
            IF tt-ped-item.it-codigo = "4990533" OR
               tt-ped-item.it-codigo = "4990523" or
               tt-ped-item.it-codigo = "4991040" or
               tt-ped-item.it-codigo = "4990186" or
               tt-ped-item.it-codigo = "4990709" or
               tt-ped-item.it-codigo = "4991039" or
               tt-ped-item.it-codigo = "4990805" or
               tt-ped-item.it-codigo = "4990709" or
               tt-ped-item.it-codigo = "4990324" or
               tt-ped-item.it-codigo = "4990239" or
               tt-ped-item.it-codigo = "4990709" THEN DO: 
                IF c-desc-suspend = ? THEN DO:
                    ASSIGN c-desc-suspend = "Atená∆o! Pedido com produto composto! " + tt-ped-item.it-codigo.
                END.
                ELSE DO:
                    IF NOT c-desc-suspend MATCHES "*" + STRING("Atená∆o! Pedido com produto composto! " + tt-ped-item.it-codigo) + "*" THEN
                        ASSIGN c-desc-suspend = c-desc-suspend + CHR(10) + "Atená∆o! Pedido com produto composto! " + tt-ped-item.it-codigo.
                END.
            END.

            /*************************/
            /*
            IF NOT lsuspendeped AND tt-ped-venda.completo THEN DO:
                FOR FIRST int-campanha-item
                    WHERE int-campanha-item.it-codigo = tt-ped-item.it-codigo NO-LOCK,
                    FIRST int-campanha
                    WHERE int-campanha.cod-campanha = int-campanha-item.cod-campanha
                    AND   (int-campanha.cod-gr-cli  = tt-ped-venda.cod-gr-cli
                        OR int-campanha.cod-gr-cli  = 0) NO-LOCK:
                
                    ASSIGN lsuspendeped   = YES
                           c-desc-suspend = c-desc-suspend + CHR(10) + int-campanha.cobs.
                END.
            END.
            */
            FIND FIRST item-uni-estab NO-LOCK
                 WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
                   AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.

            IF AVAIL item-uni-estab THEN
                ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
            ELSE
                ASSIGN tt-ped-item.cod-unid-negoc = ITEM.cod-unid-negoc.
                
            /* conta aplicacao */
            IF item.tipo-contr = 4 AND SUBSTR(tt-ped-item.char-2,09,02) = "  " THEN
                ASSIGN SUBSTR(tt-ped-item.char-2,09,02) = item.un.
        
            IF  item.tipo-contr <> 4 THEN
                ASSIGN SUBSTR(tt-ped-item.char-2,09,02) = "  ":U.
        
            FOR FIRST natur-oper
                WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK USE-INDEX natureza:
            END.
        
            IF  ((item.tipo-contr = 4 OR (item.aliquota-iss > 0 AND item.tipo-contr <> 2)) 
           AND   (item.baixa-estoq AND natur-oper.baixa-estoq)) 
            OR  ((item.tipo-contr = 1 OR item.tipo-contr = 4) 
           AND   (natur-oper.terceiros OR natur-oper.transf)) 
            OR   (item.tipo-contr = 2 OR item.tipo-contr = 3) 
           AND    natur-oper.terceiros 
           AND   (NOT item.baixa-estoq OR not natur-oper.baixa-estoq) THEN DO:
        
                IF item.ct-codigo = "":U THEN DO:
                    FIND FIRST para-fat NO-LOCK NO-ERROR.
                    ASSIGN tt-ped-item.ct-codigo = para-fat.ct-cuscon.
                END.   
                ELSE 
                    ASSIGN tt-ped-item.ct-codigo = item.ct-codigo.
            END. 
            ELSE 
                 ASSIGN tt-ped-item.ct-codigo = "".
         /* Fim Conta Aplicacao */

            FIND FIRST classif-fisc NO-LOCK
                 WHERE classif-fisc.class-fiscal = item.class-fisc NO-ERROR.
            IF  NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
                RUN pi-erro (INPUT "Item " + tt-ped-item.it-codigo + " sem classificaá∆o fiscal cadastrada.").
                RETURN "NOK":U.
            END.
            IF  c-nat-oper-cabecalho = tt-ped-item.nat-operacao THEN
                ASSIGN i-cont-nat-igual = i-cont-nat-igual + 1.


            /*regra n∆o vale para pedidos provenientes de canais*/
            IF  msg0093.origem <> 9 THEN
                ASSIGN c-nat-oper = tt-ped-item.nat-operacao.

            RUN esp/es0018p.p (INPUT  "pd4000":U,
                           INPUT  10,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = tt-ped-item.it-codigo) THEN
                ASSIGN l-off-grid = YES.
        END.

        RUN pi-log (INPUT "Escrm012 1226 - " + string(tt-ped-venda.nr-pedcli)).
        
        /* Significa que todos os itens do pedido tem a natureza diferente do cabecalho portanto a nat. do cab deve ser igual dos itens */
        IF  i-cont-nat-igual = 0 THEN
            ASSIGN tt-ped-venda.nat-operacao = c-nat-oper.

        ASSIGN tt-ped-venda.vl-tot-ped = d-vl-liq-abe
               tt-ped-venda.vl-liq-abe = d-vl-liq-abe
               tt-ped-venda.vl-mer-abe = d-vl-liq-it
               tt-ped-venda.vl-liq-ped = d-vl-liq-it.
        
        /* Regra Nova */
        IF (emitente.estado = "AL"  OR
            emitente.estado = "AM"  OR
            emitente.estado = "AP"  OR
            emitente.estado = "BA"  OR
            emitente.estado = "CE"  OR
            emitente.estado = "PE"  OR
            emitente.estado = "SE"  OR
            emitente.estado = "PI"  OR
            emitente.estado = "MA"  OR
            emitente.estado = "RN"  OR
            emitente.estado = "PB"  OR
            emitente.estado = "RR"  OR
            emitente.estado = "PA") THEN DO:
            IF  emitente.cod-gr-cli = 24 THEN DO:
                IF tt-ped-venda.vl-tot-ped > 7000 THEN
                    ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                ELSE
                    ASSIGN tt-ped-venda.cidade-cif = "".
            END.
            ELSE DO:
                IF (emitente.cod-gr-cli = 22  OR
                    emitente.cod-gr-cli = 23  OR
                    emitente.cod-gr-cli = 26  OR
                    emitente.cod-gr-cli = 34  OR
                    emitente.cod-gr-cli = 36  OR
                    emitente.cod-gr-cli = 37  OR
                    emitente.cod-gr-cli = 38) THEN DO:

                    IF  tt-ped-venda.vl-tot-ped > 3000 THEN
                        ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                    ELSE
                        ASSIGN tt-ped-venda.cidade-cif = "".
                END.
            END.
        END.
        ELSE DO:
            /* Regra antiga */
            IF  emitente.cod-gr-cli = 24 THEN DO:
                IF tt-ped-venda.vl-tot-ped > 10000 THEN
                    ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                ELSE
                    ASSIGN tt-ped-venda.cidade-cif = "".
            END.
            ELSE DO:
                IF (emitente.cod-gr-cli = 22  OR
                    emitente.cod-gr-cli = 23  OR
                    emitente.cod-gr-cli = 26  OR
                    emitente.cod-gr-cli = 34  OR
                    emitente.cod-gr-cli = 36  OR
                    emitente.cod-gr-cli = 37  OR
                    emitente.cod-gr-cli = 38) THEN DO:
                    IF  tt-ped-venda.vl-tot-ped > 3000 THEN
                        ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                    ELSE
                        ASSIGN tt-ped-venda.cidade-cif = "".
                END.
            END.
        END.
        RUN pi-log (INPUT "Escrm012 1302 - " + STRING(tt-ped-venda.nr-pedcli)).
        
        IF  tt-ped-venda.observacoes <> "" THEN
            ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.observacoes.

        IF  tt-ped-venda.cond-espec <> "" THEN
            ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.cond-espec.

        /* Estabelecimento = 105 e Unid Negoc = ISEC -> Solicitado por Francine, em 10/02/2011 */
        IF  tt-ped-venda.cod-estabel = "105" AND (i-cd-unid-comerc = 41 OR i-cd-unid-comerc = 42) THEN
            ASSIGN c-desc-suspend = c-desc-suspend + "Favor verificar Transportadora!".
        
        /* Se tiver data ou dias de negociaá∆o, o pedido dever† ser Suspenso */
        FIND FIRST tt-int-ped-venda NO-LOCK
             WHERE tt-int-ped-venda.cod-estabel = tt-ped-venda.cod-estabel
               AND tt-int-ped-venda.nr-pedido   = tt-ped-venda.nr-pedido NO-ERROR.
        IF  AVAIL  tt-int-ped-venda THEN DO:
            IF  tt-int-ped-venda.dt-negociacao   <> ? THEN
                ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao)
                       c-desc-suspend           = c-desc-suspend + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao).

            IF  tt-int-ped-venda.dias-negociacao <> 0 THEN
                ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao)
                       c-desc-suspend           = c-desc-suspend + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao).
        END.

        /*Eckell*/
        IF l-off-grid THEN
            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Atená∆o! Esse gerador off grid possui baterias em sua estrutura. Faturamento somente nas quartas-feiras.".

        RUN esp/es0018p.p (INPUT  "pd4000":U,
                           INPUT  11,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

        IF CAN-FIND (FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = STRING(tt-ped-venda.cod-cond-pag)) THEN
            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Atená∆o! Pedido com  condiá∆o Santander.".

        RUN pi-log (INPUT "escrm012 ------- desc. suspend : " + c-desc-suspend + CHR(10) +
                          " tt-ped-venda.cond-espec       : " + tt-ped-venda.cond-espec  + CHR(10) +
                          " tt-ped-venda.observacoes      : " + tt-ped-venda.observacoes).

        ASSIGN l-error = NO.

        RUN pi-executar-bos (INPUT  c-desc-suspend,
                             OUTPUT l-error).

        RUN pi-log (INPUT "escrm012 - apos executar bos").

        RUN pi-log (INPUT "Escrm012 Finale - " + tt-ped-venda.nr-pedcli).

        IF  l-error THEN DO:
            RETURN "NOK":U.
        END.
    END.
END.

IF  VALID-HANDLE(h-boes505) THEN
    DELETE PROCEDURE h-boes505.

DELETE WIDGET-POOL.
RETURN "OK":U.


PROCEDURE CriaItem:

    DEF VAR l-consumo-item AS LOG INIT NO NO-UNDO.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = item-pedido.Produto NO-ERROR.

    IF  NOT AVAIL ITEM THEN DO:
        RUN pi-erro (INPUT "Item n∆o encontrado - " + item-pedido.Produto).
    END.

    RUN pi-log (INPUT "apos criar o pedido e antes de criar o item " + tt-ped-venda.cod-estabel + tt-ped-venda.nr-pedcli + " " + tt-ped-venda.nat-operacao).
    
    IF AVAIL int-emitente AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */ THEN DO:
        FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
             WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
               AND int-calculo-canal-item.cod-estabel = estabelec.cod-estabel
               AND int-calculo-canal-item.it-codigo   = item-pedido.Produto NO-ERROR.
        IF AVAIL int-calculo-canal-item THEN DO:
            IF int-calculo-canal-item.data-calculo <> TODAY THEN
                ASSIGN int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                       int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                       int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                       int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                       int-calculo-canal-item.data-calculo           = TODAY.
        END.
        ELSE DO:
            CREATE int-calculo-canal-item.
            ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                   int-calculo-canal-item.cod-estabel            = estabelec.cod-estabel
                   int-calculo-canal-item.it-codigo              = item-pedido.Produto
                   int-calculo-canal-item.preco-base             = item-pedido.PrecoOriginal
                   int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                   int-calculo-canal-item.tipo-portifolio        = 993520005
                   int-calculo-canal-item.bloqueado              = NO
                   int-calculo-canal-item.qtd-range              = 0
                   int-calculo-canal-item.log-calcrebate         = NO   
                   int-calculo-canal-item.log-preco-alterado     = NO
                   int-calculo-canal-item.log-rebate-antec       = NO
                   int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                   int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                   int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                   int-calculo-canal-item.data-calculo           = TODAY.
        END.
        RELEASE int-calculo-canal-item.
        FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
    END.

    /* Manter a natureza do pedido quando este for proveniente de canais */
    IF  msg0093.origem <> 9 THEN DO:

        /* Para Show Room e StockBackup tem que gerar como consumo */
        ASSIGN l-consumo-item = IF (msg0093.tp-beneficio = 15 OR msg0093.tp-beneficio = 04) THEN YES /*Consumo*/ ELSE NO.

        IF msg0093.TipoNaturezaOperacao = 2 THEN DO:
            FOR FIRST ponto-programa
                WHERE ponto-programa.nome-programa = "escrm034",
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(estabelec.cod-estabel):
               
                ASSIGN c-nat-oper-dentro-estado-contrib     = ENTRY(1,conteudo-programa.conteudo)
                       c-nat-oper-dentro-estado-nao-contrib = ENTRY(2,conteudo-programa.conteudo)
                       c-nat-oper-fora-estado-contrib       = ENTRY(3,conteudo-programa.conteudo)
                       c-nat-oper-fora-estado-nao-contrib   = ENTRY(4,conteudo-programa.conteudo).
    
                FIND FIRST natur-oper NO-LOCK 
                     WHERE natur-oper.nat-operacao = IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-dentro-estado-contrib
                                                ELSE IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-dentro-estado-nao-contrib
                                                ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-fora-estado-contrib         
                                                ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-fora-estado-nao-contrib
                                                ELSE "" NO-ERROR.
    
                IF NOT AVAIL natur-oper THEN
                    RUN pi-erro (INPUT "Natureza de operaá∆o parametrizada n∆o cadastrada. - " + " Cod Cliente: " + string(emitente.cod-emitente)).
                ELSE 
                    ASSIGN c-nat-oper = natur-oper.nat-operacao.
            END.
        END.
        ELSE DO:
            IF emitente.contrib-icms = YES THEN 
                ASSIGN l-consumidor-final = NO.
            ELSE 
                ASSIGN l-consumidor-final = YES.
    
            RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                INPUT  emitente.cod-emitente,
                                                INPUT  "padrao", 
                                                INPUT  item.it-codigo,
                                                INPUT  l-consumidor-final,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
    
            IF  l-return = NO THEN DO:
                RUN pi-erro (INPUT "Natureza de Operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo).
            END.
        END.
    
        RUN pi-log (INPUT "Natureza de operacao encontrada Para o item PEDIDO ------->> " + tt-ped-venda.cod-estabel + " nro pedido " + tt-ped-venda.nr-pedcli + " " + item.it-codigo + " " + c-nat-oper).
            
        RUN pi-log (INPUT "l-consumo-item:  " + STRING(l-consumo-item)).

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    
        IF  NOT AVAIL natur-oper THEN DO:
            RUN pi-erro (INPUT "Natureza de operaá∆o " + c-nat-oper + " inv†lido ou n∆o cadastrada, Cliente: " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo).
        END.

    END.

    IF item-pedido.QuantidadePedida = 0 THEN DO:
        RUN pi-erro (INPUT "Item com quantidade zerada  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RUN pi-log (INPUT "**** Criaá∆o do Item ****" + CHR(10) +
                      "tt-ped-venda.nr-pedcli.:  " + tt-ped-venda.nr-pedcli + CHR(10) +
                      "tt-ped-venda.nome-abrev.:  " + tt-ped-venda.nome-abrev + CHR(10) +
                      "item.it-codigo.: " + item.it-codigo).

    FIND LAST tt-ped-item NO-LOCK 
        WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli NO-ERROR.

    IF AVAIL tt-ped-item THEN 
        ASSIGN i-sequencia = tt-ped-item.nr-sequencia.
    ELSE
        ASSIGN i-sequencia = 0.

    CREATE tt-ped-item.
    ASSIGN tt-ped-item.nr-pedcli           = tt-ped-venda.nr-pedcli
           tt-ped-item.nome-abrev          = tt-ped-venda.nome-abrev
           tt-ped-item.it-codigo           = item.it-codigo
           tt-ped-item.aliquota-ipi        = item.aliquota-ipi
           tt-ped-item.des-un-medida       = ITEM.un
           tt-ped-item.cod-entrega         = tt-ped-venda.cod-entrega
           OVERLAY(tt-ped-item.char-2,1,8) = item.class-fiscal.

    IF item.cod-servico <> 0 THEN
        OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico).
                        
/*     /* Verifica data de entrega do item */                                                   */
/*     FIND LAST item-dt-entrega NO-LOCK                                                        */
/*         WHERE item-dt-entrega.it-codigo = ITEM.it-codigo NO-ERROR.                           */
/*                                                                                              */
/*     IF AVAIL item-dt-entrega                                                                 */
/*          AND item-dt-entrega.dt-entrega-futura > TODAY                                       */
/*          AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:  */
/*         ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura.                   */
/*     END.                                                                                     */
/*     ELSE                                                                                     */
       
    /* Verifica data de entrega do item */
    FIND int-ped-venda2 NO-LOCK
        WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    
    FIND LAST item-dt-entrega NO-LOCK
        WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
          AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

    IF NOT AVAIL item-dt-entrega THEN DO:

        ASSIGN i-cod-gr-canais = 0.
    
        FIND FIRST atendente
             WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
        IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
            ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
        END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
        ELSE DO:
            FIND FIRST emitente
                 WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
            IF  AVAIL emitente THEN DO:
                FIND FIRST grupo-canais-clientes
                     WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                IF AVAIL grupo-canais-clientes THEN DO:
                    ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                END.
            END.
        END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
    
        FIND LAST item-dt-entrega NO-LOCK
            WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
              AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
    END.

    IF AVAIL item-dt-entrega
        AND item-dt-entrega.dt-entrega-futura > TODAY 
        AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
        ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura
               tt-ped-item.dt-entorig = item-dt-entrega.dt-entrega-futura.            
    END.
    ELSE
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

    IF tt-ped-item.dt-entrega > TODAY + 730 THEN DO:
        RUN pi-erro (INPUT "Data de entrega do item " + tt-ped-item.it-codigo +  " superior a 2 anos!").
    END.

    /* Fim Verifica data de entrega do item */

    /* Atribuir Sequància do Item */
    ASSIGN i-sequencia              = i-sequencia + 10
           tt-ped-item.nr-sequencia = i-sequencia.

    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    ASSIGN de-perc-icms = 0.
    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            ASSIGN de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  c-nat-oper,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).
    END.
    RUN Destroy in h-bodi317im1br.
    ASSIGN h-bodi317im1br = ?.

    ASSIGN g-cod-emitente-bodi317im1br = 0.
    ASSIGN g-codigo-orig-bodi317sd     = 0.

    IF  ITEM.cd-trib-icm        = 4
    AND natur-oper.cd-trib-icm  = 4
    AND natur-oper.perc-red-icm > 0 THEN DO:
        ASSIGN de-perc-icms = de-perc-icms * (1 - natur-oper.perc-red-icm / 100).
    END.

/*     ASSIGN g-cod-emitente-bodi317im1br = 0. */
/*     ASSIGN g-codigo-orig-bodi317sd     = 0. */
/*     DELETE PROCEDURE h-bodi317im1br.        */
   
    ASSIGN tt-ped-item.qt-pedida               = item-pedido.QuantidadePedida
           tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
           tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
           tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
           tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
           tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
           tt-ped-item.esp-ped                 = 1
           tt-ped-item.nat-operacao            = natur-oper.nat-operacao
           tt-ped-item.per-des-icms            = natur-oper.per-des-icms
           tt-ped-item.tp-adm-lote             = 1
           tt-ped-item.tp-preco                = 0
           tt-ped-item.user-impl               = tt-ped-venda.user-impl
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.observacao              = tt-ped-venda.observacoes
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF item.baixa-estoq = NO OR tt-ped-venda.ind-fat-par THEN 2 ELSE 1.

    CREATE tt-int-ped-item.
    ASSIGN tt-int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
           tt-int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
           tt-int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
           tt-int-ped-item.it-codigo     = tt-ped-item.it-codigo
           tt-int-ped-item.vl-guid       = ""  /*tt-ped-item-xml.guid-crm*/
        /***
           tt-int-ped-item.it-codigo-pai = IF AVAIL item-pedido THEN item-pedido.ProdutoPai ELSE ""
        ***/.

    RUN pi-log (INPUT "**** Criaá∆o da Tabela de Rebate ****").
    CREATE tt-int-ped-item-rebate.
    ASSIGN tt-int-ped-item-rebate.nome-abrev        = tt-ped-item.nome-abrev
           tt-int-ped-item-rebate.nr-pedcli         = tt-ped-item.nr-pedcli
           tt-int-ped-item-rebate.nr-sequencia      = tt-ped-item.nr-sequencia
           tt-int-ped-item-rebate.it-codigo         = tt-ped-item.it-codigo
           tt-int-ped-item-rebate.cod-refer         = tt-ped-item.cod-refer
           tt-int-ped-item-rebate.log-calcrebate    = item-pedido.CalcularRebate
           tt-int-ped-item-rebate.perc-descto-verde      = item-pedido.PercentualDescontoVerde
           tt-int-ped-item-rebate.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
           tt-int-ped-item-rebate.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado.
    
    RUN pi-log (INPUT "**** Criaá∆o da Tabela de Extens∆o para o Item ****" + CHR(10) +
                      "tt-int-ped-item.nome-abrev.: "   + string(tt-int-ped-item.nome-abrev )  + CHR(10) +
                      "tt-int-ped-item.nr-pedcli.: "    + string(tt-int-ped-item.nr-pedcli  )  + CHR(10) +
                      "tt-int-ped-item.nr-sequencia.: " + string(tt-int-ped-item.nr-sequencia) + CHR(10) +
                      "tt-int-ped-item.it-codigo.: "    + string(tt-int-ped-item.it-codigo  )  + CHR(10) +
                      "tt-int-ped-item.vl-guid.: "      + string(tt-int-ped-item.vl-guid    )  + CHR(10) +
                      "QUANDIDADE DO ITEM DO PEDIDO "   + string(item-pedido.QuantidadePedida)).
    
    IF NOT VALID-HANDLE(h-bodi154sdf) 
    OR h-bodi154sdf:TYPE      <> "PROCEDURE":U 
    OR h-bodi154sdf:FILE-NAME <> "dibo/bodi154sdf.p":U THEN
        RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.

    IF AVAIL emitente 
   AND AVAIL natur-oper THEN DO:    
        RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                          INPUT  tt-ped-item.cod-entrega,
                                          INPUT  tt-ped-item.it-codigo,
                                          INPUT  tt-ped-venda.cod-estabel,
                                          INPUT  emitente.insc-subs-trib,
                                          INPUT  natur-oper.subs-trib,
                                          OUTPUT tt-ped-item.ind-icm-ret).   
    END.
    DELETE PROCEDURE h-bodi154sdf.
    /* Fim Busca Indicador ICMS Ret */
    RUN pi-log (INPUT "**** Calculo substituiá∆o tributaria ****" + CHR(10) +
                      "tt-ped-item.nome-abrev "   + string(tt-ped-item.nome-abrev )  + CHR(10) +   
                      "tt-ped-item.cod-entrega "  + string(tt-ped-item.cod-entrega)  + CHR(10) +  
                      "tt-ped-item.it-codigo "    + string(tt-ped-item.it-codigo  )  + CHR(10) +    
                      "tt-ped-venda.cod-estabel " + string(tt-ped-venda.cod-estabel) + CHR(10) + 
                      "emitente.insc-subs-trib "  + string(emitente.insc-subs-trib)  + CHR(10) +  
                      "natur-oper.subs-trib "     + string(natur-oper.subs-trib   )  + CHR(10) +
                      "tt-ped-item.ind-icm-ret "  + string(tt-ped-item.ind-icm-ret)).
    
    IF msg0093.TabelaPrecoEMS = ""
    OR msg0093.TabelaPrecoEMS = ? THEN DO:
        ASSIGN tt-ped-item.vl-pretab = round(item-pedido.PrecoOriginal,4)
               tt-ped-item.vl-preori = round(item-pedido.PrecoOriginal,4).
    
        IF de-perc-icms > 0 THEN
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (de-perc-icms / 100)).
        ELSE 
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
    END.
    ELSE DO:
        FIND FIRST preco-item NO-LOCK
             WHERE preco-item.it-codigo  = tt-ped-item.it-codigo 
               AND preco-item.cod-refer  = ""
               AND preco-item.nr-tabpre  = msg0093.TabelaPrecoEMS
               AND preco-item.dt-inival <= TODAY
               AND preco-item.situacao   = 1 NO-ERROR.
       
       IF NOT AVAIL preco-item THEN DO:
           RUN pi-erro (INPUT "O item " + tt-ped-item.it-codigo + " n∆o possui preáo ativo cadastrado na tabela " + msg0093.TabelaPrecoEMS + " - " + " Cod Cliente: " + string(emitente.cod-emitente)).
           RETURN "NOK".
       END.
       
       FIND FIRST unid-feder NO-LOCK
            WHERE unid-feder.pais   = estabelec.pais
              AND unid-feder.estado = estabelec.estado NO-ERROR.
       
       ASSIGN de-icms = 1
              l-ok    = NO.

       ASSIGN tt-ped-item.vl-pretab = round((preco-item.preco-venda / (100 - de-perc-icms) * 100),4) .
              tt-ped-item.vl-preori = tt-ped-item.vl-pretab .


       
       /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
       IF natur-oper.per-des-icm > 0 
          THEN ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)).
          ELSE ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
    END.
    
    ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.

    /* Tratamento IPI */
    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
    ELSE
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

    ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.

    /* Atribuir Valores Totais do Pedido */
    ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
           d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
END PROCEDURE.

PROCEDURE pi-executar-bos:
    DEFINE INPUT  PARAMETER p-desc-suspend AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro         AS LOGICAL     NO-UNDO.

    DEF VAR         l-deve-suspender    AS LOG      INIT YES NO-UNDO.
    DEFINE VARIABLE l-altera-priori-ped AS LOGICAL           NO-UNDO.

    DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.

    IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel1').

    EMPTY TEMP-TABLE tt-ped-venda-aux.

    CREATE tt-ped-venda-aux.
    BUFFER-COPY tt-ped-venda TO tt-ped-venda-aux.
   
    RUN pi-log (INPUT "INICIO PI-EXECUTAR-BOS  " + string(tt-ped-venda-aux.nr-pedido) + " Natureza de Operacao " + tt-ped-venda-aux.nat-operacao).
        
    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:
        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel2').

        IF  NOT VALID-HANDLE(h-bodi159) THEN
            RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

        RUN openQueryStatic IN h-bodi159(INPUT "Main":U).
        RUN setRecord       IN h-bodi159(INPUT TABLE tt-ped-venda-aux).
        RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
        RUN emptyRowErrors  IN h-bodi159.
        RUN createMPLog     IN h-bodi159(INPUT NO).
        RUN createRecord    IN h-bodi159.
        RUN getRowErrors    IN h-bodi159(OUTPUT TABLE RowErrors).

        IF VALID-HANDLE(h-bodi159) THEN
            DELETE PROCEDURE h-bodi159.


        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel3').
        FOR EACH rowErrors NO-LOCK:
        
            IF rowErrors.errornumber  = 26468 THEN DO:  
                FIND ITEM 
                     WHERE ITEM.it-codigo = substring(rowErrors.errorDescription,6,7)
                     NO-LOCK NO-ERROR.

                ASSIGN rowErrors.errorDescription = "O produto " + 
                                                    (IF AVAIL ITEM THEN ITEM.it-codigo + " " + ITEM.desc-item ELSE "") + 
                                                    " est† temporariamente bloqueado para faturamento. Favor remover o item do pedido e entrar em contato com a †rea comercial".
            END.
        END.


        FOR EACH  RowErrors NO-LOCK
            WHERE RowErrors.ErrorType   <> "INTERNAL":U
            AND   RowErrors.ErrorSubType = "Error":U:
            RUN pi-erro (INPUT RowErrors.errorDescription  + " Cliente: " + tt-ped-venda-aux.nome-abrev).
            ASSIGN l-erro = YES.
        END.

        IF l-erro THEN
            UNDO bloco, LEAVE bloco.

        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel4').
        
        IF  NOT VALID-HANDLE(h-bodi157) THEN
            RUN dibo/bodi157.p PERSISTENT SET h-bodi157.
        RUN openQueryStatic IN h-bodi157(INPUT "Default":U).

        RUN pi-log (INPUT "Antes de criar tt-ped-repre  " + string(tt-ped-venda-aux.nr-pedido) + " Natureza de Operacao " + tt-ped-venda-aux.nat-operacao).
        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel5').
        FOR EACH tt-ped-repre
            WHERE tt-ped-repre.nr-pedido = tt-ped-venda-aux.nr-pedido:

            RUN pi-log (INPUT "Dentro do for each tt-ped-repre  " + string(tt-ped-venda-aux.nr-pedido)).

            RUN emptyRowErrors  IN h-bodi157.
            RUN setRecord       IN h-bodi157(INPUT TABLE tt-ped-repre).
            RUN createMPLog     IN h-bodi157(INPUT NO).
            RUN createRecord    IN h-bodi157.
            RUN getRowErrors    IN h-bodi157(OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                RUN pi-erro (INPUT RowErrors.errorDescription + " Repres: " + tt-ped-repre.nome-ab-rep).
                ASSIGN l-erro = YES.
            END.
            DELETE tt-ped-repre.
        END.

        IF VALID-HANDLE(h-bodi157) THEN
            DELETE PROCEDURE h-bodi157.

        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel6').

        IF l-erro THEN
            UNDO bloco, LEAVE bloco.

        IF  NOT VALID-HANDLE(h-bodi154) THEN
            RUN dibo/bodi154.p PERSISTENT SET h-bodi154.
        RUN openQueryStatic IN h-bodi154(INPUT "Default":U).

        FOR EACH  tt-ped-item NO-LOCK
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda-aux.nr-pedcli:

            RUN pi-log (INPUT "CHAMANDO BO DO ITEM DO PEDIDO " + tt-ped-item.nr-pedcli  + tt-ped-item.it-codigo + " SEQUENCIA " + string(tt-ped-item.nr-sequencia) + string(tt-ped-item.qt-pedida) + " Natureza " + tt-ped-item.nat-operacao + " " + tt-ped-venda-aux.nat-operacao).

            /* Verifica data de entrega do item */
            FIND int-ped-venda2 NO-LOCK
                WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
            
            FIND LAST item-dt-entrega NO-LOCK
                WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                  AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

            IF NOT AVAIL item-dt-entrega THEN DO:

                ASSIGN i-cod-gr-canais = 0.
        
                FIND FIRST atendente
                     WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
                IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
                    ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
                END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
                ELSE DO:
                    FIND FIRST emitente
                         WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
                    IF  AVAIL emitente THEN DO:
                        FIND FIRST grupo-canais-clientes
                             WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                        IF AVAIL grupo-canais-clientes THEN DO:
                            ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                        END.
                    END.
                END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
        
                FIND LAST item-dt-entrega NO-LOCK
                    WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                      AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
            END.

            IF AVAIL item-dt-entrega
                 AND item-dt-entrega.dt-entrega-futura > TODAY 
                 AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
                ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura
                       tt-ped-item.dt-entorig = item-dt-entrega.dt-entrega-futura.
            END.
            ELSE
                ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

            RUN emptyRowErrors  IN h-bodi154.
            RUN setRecord       IN h-bodi154(INPUT TABLE tt-ped-item).
            RUN createMPLog     IN h-bodi154(INPUT NO).
            RUN createRecord    IN h-bodi154.
            RUN getRowErrors    IN h-bodi154(OUTPUT TABLE RowErrors).


            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                IF rowErrors.errornumber  = 26468 THEN DO:  
                    FIND ITEM 
                         WHERE ITEM.it-codigo = substring(rowErrors.errorDescription,6,7)
                         NO-LOCK NO-ERROR.
    
                    ASSIGN rowErrors.errorDescription = "O produto " + 
                                                        (IF AVAIL ITEM THEN ITEM.it-codigo + " " + ITEM.desc-item ELSE "") + 
                                                        " est† temporariamente bloqueado para faturamento. Favor remover o item do pedido e entrar em contato com a †rea comercial".
                    RUN pi-erro (INPUT RowErrors.errorDescription).
                END.
                ELSE
                    RUN pi-erro (INPUT RowErrors.errorDescription + " Item: " + tt-ped-item.it-codigo).
                ASSIGN l-erro = YES.
            END.

            DELETE tt-ped-item.
        END.

        IF VALID-HANDLE(h-bodi154) THEN
            DELETE PROCEDURE h-bodi154.

        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel7').
        
        IF l-erro  THEN
            UNDO bloco, LEAVE bloco.

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli  = tt-ped-venda-aux.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda-aux.nome-abrev NO-ERROR.

        RUN pi-log (INPUT "Pedido Gerado? " + STRING(AVAIL ped-venda) + CHR(10) +
                          "Nr Pedido " + tt-ped-venda-aux.nr-pedcli + CHR(10) +
                          "Cliente   " + tt-ped-venda-aux.nome-abrev + CHR(10) +
        

                  "Situacao DO pedido " + STRING(ped-venda.cod-sit-ped)).
        
        /**** Efetiva as Tabelas Espec°ficas ****/
        /* Pedido */
        FIND FIRST tt-int-ped-venda NO-LOCK
            WHERE  tt-int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        IF  AVAIL  tt-int-ped-venda THEN DO:
            
            RUN pi-log (INPUT "Efetivando a tabela de extens∆o (int-ped-venda)>>*****>>>:" + CHR(10) +
                              "ped-venda.nome-abrev.: " + ped-venda.nome-abrev + CHR(10) +
                              "ped-venda.nr-pedcli.: " + ped-venda.nr-pedcli).

            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE  int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido NO-ERROR.
            IF  NOT AVAIL int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido.
            END.

            ASSIGN /*int-ped-venda.dt-negociacao   = tt-int-ped-venda.dt-negociacao
                   int-ped-venda.dias-negociacao = tt-int-ped-venda.dias-negociacao*/
                   int-ped-venda.cod-estabel     = tt-int-ped-venda.cod-estabel
                   int-ped-venda.vl-guid         = tt-int-ped-venda.vl-guid
                   int-ped-venda.char-1          = tt-int-ped-venda.char-1
                   int-ped-venda.reference-number = tt-int-ped-venda.reference-number    
                   int-ped-venda.tid              = tt-int-ped-venda.tid                 
                   int-ped-venda.pedido-original = int(msg0093.PedidoOriginal)
                   int-ped-venda.vl-serv-inst    = tt-int-ped-venda.vl-serv-inst
                   OVERLAY(int-ped-venda.char-1, 53, 12) = msg0093.NumeroPedidoCliente
                   int-ped-venda.carTID          = msg0093.IdentificacaoCartao.

            IF msg0093.dadosSolar <> "" THEN
                   ASSIGN int-ped-venda.cod-projeto     = entry(1,msg0093.dadosSolar,";")
                          int-ped-venda.perc-comissao   = dec(entry(2,msg0093.dadosSolar,";")) / 100
                          int-ped-venda.vlr-comissao    = dec(entry(3,msg0093.dadosSolar,";")) / 100.

            FIND FIRST natur-oper NO-LOCK 
                 WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.

            IF  int-ped-venda.cartid = ''
            AND natur-oper.tipo    = 3  /* serviáo */ THEN
               ASSIGN int-ped-venda.cartID = '9999'.
                
            RELEASE int-ped-venda.
        END.
        IF OPSYS = "UNIX" THEN log-manager:write-message('pi-executar-bos Eckel10').
        CREATE msg0093r.
        CREATE pedidor.
        ASSIGN pedidor.NumeroPedido       = ped-venda.nr-pedcli
               pedidor.Representante      = msg0093.Representante
               pedidor.CodigoClienteCRM   = int-emitente.cod-guid
               pedidor.Atendente          = INT(ped-venda.tp-pedido)
               pedidor.CodigoSupervisorEMS = msg0093.CodigoSupervisorEMS
               pedidor.Estabelecimento    = ped-venda.cod-estabel
               pedidor.CondicaoPagamento  = ped-venda.cod-cond-pag
               pedidor.CondicaoEspecial   = ped-venda.cond-espec
               pedidor.Observacao         = ped-venda.observacoes
               pedidor.FaturamentoParcial = ped-venda.ind-fat-par
               pedidor.Vendor             = msg0093.Vendor
               pedidor.DiasBaseVendor     = msg0093.DiasBase
               pedidor.TaxaClienteVendor  = msg0093.TaxaCliente
               pedidor.DataEmissao        = ped-venda.dt-emissao
               pedidor.DataEntrega        = ped-venda.dt-entrega
               pedidor.DataNegociacao     = ?
               pedidor.DiasNegociacao     = ?
               pedidor.TipoObjetoCliente  = msg0093.TipoObjetoCliente
               pedidor.Situacao           = msg0093.Situacao.

        IF  NOT VALID-HANDLE(h-bodi159cal) THEN
            RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.

/*         IF  p-desc-suspend <> ""                                       */
/*         OR  ped-venda.observacoes <> "" THEN DO:                       */
/*                                                                        */
/*                                                                        */
/*             FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.            */
/*             for each ped-item of ped-venda                             */
/*                     where ped-item.cod-sit-item <= 2 exclusive-lock:   */
/*                                                                        */
/*                     for each ped-ent of ped-item                       */
/*                         where ped-ent.cod-sit-ent <= 2 exclusive-lock: */
/*                                                                        */
/*                         assign ped-ent.cod-sit-ent  = 5                */
/*                                ped-ent.dt-suspensao = today            */
/*                                ped-ent.user-susp    = "Integra"        */
/*                                ped-ent.dt-usersusp  = today.           */
/*                                                                        */
/*                     end.                                               */
/*                                                                        */
/*                     assign ped-item.dt-suspensao = today               */
/*                            ped-item.user-susp    = "Integra"           */
/*                            ped-item.dt-usersusp  = today               */
/*                            ped-item.cod-sit-item = 5.                  */
/*                                                                        */
/*             end.                                                       */
/*                                                                        */
/*             assign ped-venda.dt-suspensao = today                      */
/*                    ped-venda.user-susp    = "Integra"                  */
/*                    ped-venda.dt-usersusp  = today                      */
/*                    ped-venda.desc-suspend = p-desc-suspend             */
/*                    ped-venda.dt-useralt   = TODAY                      */
/*                    ped-venda.user-alt     = "Integra"                  */
/*                    ped-venda.cod-sit-ped  = 5.                         */
/*                                                                        */
/*                                                                        */
/*         END.                                                           */
        RELEASE ped-venda.
        DELETE PROCEDURE h-bodi159cal.
        RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
        FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = tt-ped-venda-aux.nr-pedcli
                   AND ped-venda.nome-abrev = tt-ped-venda-aux.nome-abrev NO-ERROR.

        RUN pi-log (INPUT "Situacao DO pedido : " + ped-venda.nr-pedcli + " " + STRING(ped-venda.cod-sit-ped) + " " + p-desc-suspend) .

        
        DEFINE VARIABLE d-sum AS DECIMAL     NO-UNDO.
        ASSIGN i-sequencia = 10.
        FOR EACH parcela:
            CREATE cond-ped.
            ASSIGN cond-ped.nr-pedido    = ped-venda.nr-pedido
                   cond-ped.nr-sequencia = i-sequencia
                   cond-ped.data-pagto   = parcela.DataVencimento
                   cond-ped.vl-pagto     = parcela.ValorParcela
                   cond-ped.observacoes  = parcela.ObservacaoVencimento.

            ASSIGN d-sum = d-sum + cond-ped.vl-pagto.
            
            ASSIGN i-sequencia = i-sequencia + 10.
        END.

        RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                           OUTPUT TABLE rowErrors).
        DELETE PROCEDURE h-bodi159cal.

        IF OPSYS = "UNIX" THEN log-manager:write-message("Antes DO UpdateSuspension, ped-venda.origem:  " + STRING(ped-venda.origem)).
        
        
        IF  ped-venda.origem = 9 THEN
            ASSIGN l-deve-suspender = NO.
        IF  ped-venda.origem = 12 THEN
            ASSIGN l-deve-suspender = NO.
        /*128171 - nao suspender quando TipoNaturezaOperacao = 2 */
        IF msg0093.TipoNaturezaOperacao = 2 THEN 
            ASSIGN l-deve-suspender = NO.

        IF  l-deve-suspender THEN /* Nunca suspender quando pedido for proveniente de Solicitaá∆o de Beneficio Canais. */
            RUN UpdateSuspension.

        CREATE Itensr.
        ASSIGN l-altera-priori-ped = YES.
        FOR EACH ped-item OF ped-venda NO-LOCK:
            IF ped-item.cod-sit-item = 6 THEN NEXT.
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

            /*Calcula ICMS para mensagem de retorno*/
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
        
            FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
                 WHERE loc-entr.cod-entrega = "padrao"
                   AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
        
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.
        
            ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
            ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
            RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
            ASSIGN de-perc-icms = 0.
            IF emitente.contrib-icm = YES THEN DO:
                FOR FIRST inf-compl  /* conteudo do cd0908 */
                    WHERE inf-compl.cdn-identif = 5
                    AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
                    ASSIGN de-perc-icms = inf-compl.val-campo.
                END.
            END.
            IF de-perc-icms = 0 THEN DO:
                RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                          INPUT  emitente.natureza,
                                                          INPUT  estabelec.estado,
                                                          INPUT  estabelec.pais,
                                                          INPUT  loc-entr.estado,
                                                          INPUT  item.it-codigo,
                                                          INPUT  c-nat-oper,
                                                          OUTPUT de-perc-icms, 
                                                          OUTPUT l-return).
            END.

            IF  ITEM.cd-trib-icm        = 4
            AND natur-oper.cd-trib-icm  = 4
            AND natur-oper.perc-red-icm > 0 THEN DO:
                ASSIGN de-perc-icms = de-perc-icms * (1 - natur-oper.perc-red-icm / 100).
            END.
        
            RUN Destroy in h-bodi317im1br.
            ASSIGN h-bodi317im1br = ?.
        
            ASSIGN g-cod-emitente-bodi317im1br = 0.
            ASSIGN g-codigo-orig-bodi317sd     = 0.
            /*****/


            ASSIGN de-valor-st = 0.
            /* C†lculo da Substituiá∆o Tribut†ria */
            FIND FIRST natur-oper NO-LOCK
                WHERE  natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            RUN pi-log (INPUT "**** Substituiá∆o Tribut†ria ****" + CHR(10) +
                    "Item: " + ped-item.it-codigo + CHR(10) +
                    "Natureza de Operaá∆o: " + ped-item.nat-operacao + CHR(10) +
                    "Calcula Substituiá∆o Tribut†ria? " + string(IF AVAIL natur-oper THEN natur-oper.subs-trib ELSE NO)).

            IF  AVAIL  natur-oper AND natur-oper.subs-trib THEN DO:
                ASSIGN de-valor-st = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).

                RUN pi-log (INPUT "Valor Subs Trib: " + string(de-valor-st)).
            END.

            CREATE item-pedidor.
            ASSIGN item-pedidor.ChaveIntegracao             = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + item.cod-refer
                   item-pedidor.Produto                     = ped-item.it-codigo
                   item-pedidor.Sequencia                   = ped-item.nr-sequencia
                   item-pedidor.QuantidadePedida            = ped-item.qt-pedida
                   item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
                   item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
                   item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
                   item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
                   item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
                   item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
                   item-pedidor.AliquotaICMS                = round(de-perc-icms,2)
                   item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,4)
                   item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).

            RUN pi-log (INPUT "Totais Valores ITEM Pedido: "  + CHR(10) + 
                              "item-pedidor.Produto                    "   + string(item-pedidor.Produto)                     + CHR(10) + 
                              "item-pedidor.Sequencia                  "   + string(item-pedidor.Sequencia)                   + CHR(10) +
                              "item-pedidor.QuantidadePedida           "   + string(item-pedidor.QuantidadePedida)            + CHR(10) + 
                              "item-pedidor.PrecoOriginal              "   + string(item-pedidor.PrecoOriginal)               + CHR(10) +
                              "item-pedidor.ValorLiquido               "   + string(item-pedidor.ValorLiquido)                + CHR(10) + 
                              "item-pedidor.ValorLiquidoAberto         "   + string(item-pedidor.ValorLiquidoAberto)          + CHR(10) +
                              "item-pedidor.ValorSubstituicaoTributaria "  + string(item-pedidor.ValorSubstituicaoTributaria) + CHR(10) +
                              "item-pedidor.ValorIPI                    "  + string(item-pedidor.ValorIPI)                    + CHR(10) +
                              "item-pedidor.AliquotaIPI                 "  + string(item-pedidor.AliquotaIPI)                 + CHR(10) +
                              "item-pedidor.AliquotaICMS                "  + string(item-pedidor.AliquotaICMS)                + CHR(10) +
                              "item-pedidor.ValorICMS                   "  + string(item-pedidor.ValorICMS)                   + CHR(10) +
                              "item-pedidor.ValorTotal                  "  + string(item-pedidor.ValorTotal)).                 

           /* Efetivaá∆o da Tabela de Extens∆o */
           RUN pi-log (INPUT "Efetivando a tabela de extens∆o (int-ped-item):"                + CHR(10) +
                             "ped-item.nome-abrev.: "         + string(ped-item.nome-abrev )  + CHR(10) +
                             "ped-item.nr-pedcli.: "          + string(ped-item.nr-pedcli  )  + CHR(10) +
                             "ped-item.nr-sequencia.: "       + string(ped-item.nr-sequencia) + CHR(10) +
                             "ped-item.it-codigo.: "          + string(ped-item.it-codigo  )  + CHR(10) +
                             "QUANDIDADE DO ITEM DO PEDIDO "  + string(ped-item.qt-pedida)).

           FIND FIRST tt-int-ped-item NO-LOCK
               WHERE  tt-int-ped-item.nome-abrev   = ped-item.nome-abrev
               AND    tt-int-ped-item.nr-pedcli    = ped-item.nr-pedcli
               AND    tt-int-ped-item.nr-sequencia = ped-item.nr-sequencia
               AND    tt-int-ped-item.it-codigo    = ped-item.it-codigo NO-ERROR.
           IF  AVAIL  tt-int-ped-item THEN DO:
               FIND FIRST int-ped-item EXCLUSIVE-LOCK
                   WHERE  int-ped-item.nome-abrev   = ped-item.nome-abrev
                   AND    int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                   AND    int-ped-item.nr-sequencia = ped-item.nr-sequencia
                   AND    int-ped-item.it-codigo    = ped-item.it-codigo
                   AND    int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.
               IF  NOT AVAIL int-ped-item THEN DO:
                   CREATE int-ped-item.
                   ASSIGN int-ped-item.nome-abrev   = ped-item.nome-abrev
                          int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                          int-ped-item.nr-sequencia = ped-item.nr-sequencia
                          int-ped-item.it-codigo    = ped-item.it-codigo
                          int-ped-item.cod-refer    = ped-item.cod-refer.
               END.

               ASSIGN int-ped-item.vl-guid       = tt-int-ped-item.vl-guid
                      int-ped-item.it-codigo-pai = tt-int-ped-item.it-codigo-pai.


               RUN pi-log (INPUT "achou ITEM DO pedido  (int-ped-item):"                + CHR(10) +
                                 "int-ped-item.nome-abrev.: "   + string(int-ped-item.nome-abrev  ) + CHR(10) +
                                 "int-ped-item.nr-pedcli.: "    + string(int-ped-item.nr-pedcli   ) + CHR(10) +
                                 "int-ped-item.nr-sequencia.: " + string(int-ped-item.nr-sequencia) + CHR(10) +
                                 "int-ped-item.it-codigo.: "    + string(int-ped-item.it-codigo   ) + CHR(10) +
                                 "int-ped-item.cod-refer.: "    + string(int-ped-item.cod-refer   ) + CHR(10) +
                                 "int-ped-item.vl-guid.: "      + string(int-ped-item.vl-guid     ) + CHR(10) +
                                 "int-ped-item.it-codigo-pai "  + string(int-ped-item.it-codigo-pai)).

               FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
               RELEASE int-ped-item.
           END.

           RUN pi-log (INPUT "**** Criaá∆o da Tabela Real de Rebate ****").
           FIND FIRST tt-int-ped-item-rebate
               WHERE tt-int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev
                 AND tt-int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli
                 AND tt-int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                 AND tt-int-ped-item-rebate.it-codigo    = ped-item.it-codigo
                 AND tt-int-ped-item-rebate.cod-refer    = ped-item.cod-refer NO-LOCK NO-ERROR.
           IF AVAIL tt-int-ped-item-rebate THEN DO:
               RUN pi-log (INPUT "**** Achou TTabel Rebate ****").

               FIND FIRST int-ped-item-rebate
                   WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev
                     AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli
                     AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                     AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo
                     AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer NO-ERROR.
               IF NOT AVAIL int-ped-item-rebate THEN DO:
                   RUN pi-log (INPUT "**** Se nao encontrar, cria Rebate ****").

                   CREATE int-ped-item-rebate.
                   ASSIGN int-ped-item-rebate.nome-abrev        = ped-item.nome-abrev  
                          int-ped-item-rebate.nr-pedcli         = ped-item.nr-pedcli   
                          int-ped-item-rebate.nr-sequencia      = ped-item.nr-sequencia
                          int-ped-item-rebate.it-codigo         = ped-item.it-codigo   
                          int-ped-item-rebate.cod-refer         = ped-item.cod-refer 
                          int-ped-item-rebate.log-calcrebate    = tt-int-ped-item-rebate.log-calcrebate
                          int-ped-item-rebate.perc-descto-verde      = tt-int-ped-item-rebate.perc-descto-verde     
                          int-ped-item-rebate.perc-descto-top-milhao = tt-int-ped-item-rebate.perc-descto-top-milhao
                          int-ped-item-rebate.perc-rebate-antec      = tt-int-ped-item-rebate.perc-rebate-antec.     

               END. /* IF NOT AVAIL tt-int-ped-item-rebate THEN DO: */
               RUN pi-log (INPUT "**** Atualiza Log Rebate ****" + string(tt-int-ped-item-rebate.log-calcrebate)).

               ASSIGN int-ped-item-rebate.log-calcrebate    = tt-int-ped-item-rebate.log-calcrebate
                      int-ped-item-rebate.perc-descto-verde      = tt-int-ped-item-rebate.perc-descto-verde
                      int-ped-item-rebate.perc-descto-top-milhao = tt-int-ped-item-rebate.perc-descto-top-milhao
                      int-ped-item-rebate.perc-rebate-antec      = tt-int-ped-item-rebate.perc-rebate-antec. 

               IF  l-altera-priori-ped                   = YES AND
                   int-ped-item-rebate.perc-descto-verde = 0
               THEN
                   ASSIGN l-altera-priori-ped = NO.

               FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.

           END. /* IF AVAIL tt-int-ped-item-rebate THEN DO: */
           ELSE
               ASSIGN l-altera-priori-ped = NO.

           /*Chamado 127679 alocar o pedido quando vier da plataforma solar*/
            
           /* IF cabecalho.IdentidadeEmissor = "8F4E5DB0-466C-4ED5-9B67-257D5620E67E" THEN DO:

                RUN esp/es0018p.p (INPUT  "MSG0093A":U, // deposito padrao da solar
                                   INPUT  1,
                                   INPUT  0,
                                   INPUT  "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                  
                FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.
                IF AVAIL tt-prog-ponto THEN
                   ASSIGN c-deposito-solar = tt-prog-ponto.conteudo.
                
                RUN esp/pdp/espdp006f.p (INPUT c-seg-usuario,
                                         INPUT ROWID(ped-venda),
                                         INPUT ROWID(ped-item),
                                         INPUT c-deposito-solar,
                                         INPUT "",
                                         INPUT ped-item.qt-pedida,
                                         INPUT ped-item.cod-unid-negoc,
                                         OUTPUT TABLE tt-erro-aloc).

                FOR EACH tt-erro-aloc:
                    RUN pi-erro (INPUT tt-erro-aloc.mensagem).
                END.
            END. */
        END.

        /*Altera prioridade pedido solar*/
        IF  cabecalho.IdentidadeEmissor = "8F4E5DB0-466C-4ED5-9B67-257D5620E67E" 
        AND ped-venda.cod-priori = 44 THEN DO:
            FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ped-venda.cod-priori = 1.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            /* Chamado 63819, alterar prioridade do pedido para 3 quando todos os itens tem desconto verde */
            IF  l-altera-priori-ped = YES
            AND msg0093.Situacao    = 2 THEN DO:
                FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                IF msg0093.PedidoProgramado THEN
                    ASSIGN ped-venda.cod-priori = 4.
                ELSE
                    ASSIGN ped-venda.cod-priori = 3.
    
                FIND CURRENT ped-venda NO-LOCK NO-ERROR.
    			
    	        FIND FIRST int-ped-venda EXCLUSIVE-LOCK
    		         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    
    	        IF AVAIL int-ped-venda AND int-ped-venda.cod-priori-orig = 44 THEN
    		        ASSIGN int-ped-venda.cod-priori-orig = ped-venda.cod-priori.
    
    	        FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.    
            END.
        END.
        

        FOR EACH rowErrors NO-LOCK:
            IF rowErrors.errornumber  = 26468 THEN DO:  
                FIND ITEM 
                     WHERE ITEM.it-codigo = substring(rowErrors.errorDescription,6,7)
                     NO-LOCK NO-ERROR.

                ASSIGN rowErrors.errorDescription = "O produto " + 
                                                    (IF AVAIL ITEM THEN ITEM.it-codigo + " " + ITEM.desc-item ELSE "") + 
                                                    " est† temporariamente bloqueado para faturamento. Favor remover o item do pedido e entrar em contato com a †rea comercial".
            END.

            IF rowErrors.errornumber = 17308 THEN DO:
                DELETE rowErrors.
            END.
        END.

        FOR EACH rowErrors NO-LOCK
           WHERE rowErrors.errornumber  <> 8259
             AND RowErrors.ErrorType    <> "INTERNAL":U
             AND RowErrors.ErrorSubType = "Error":U:  /* credito n∆o aprovado */
            
            RUN pi-erro (INPUT RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli).
            ASSIGN l-erro = YES.
        END.
        
        IF l-erro THEN
            UNDO bloco, LEAVE bloco.

        IF cabecalho.IdentidadeEmissor = "8F4E5DB0-466C-4ED5-9B67-257D5620E67E" THEN DO:
            RUN esp/cdp/escdp058.p (INPUT ped-venda.nr-pedcli,
                                    INPUT ped-venda.nome-abrev,
                                    INPUT msg0093.nomeItemPai,
                                    INPUT msg0093.ncmItemPai,
                                    INPUT msg0093.Observacao).
        END.
    END.
END PROCEDURE.

PROCEDURE pi-log:
    DEFINE INPUT PARAM c-log AS CHAR.
    IF OPSYS = "UNIX" THEN log-manager:write-message(c-log).
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE UpdateSuspension:
    

    IF OPSYS = "UNIX" THEN log-manager:write-message(' ped-venda.observacoes: ' +  ped-venda.observacoes).
    IF OPSYS = "UNIX" THEN log-manager:write-message(' ped-venda.cod-priori: ' + STRING( ped-venda.cod-priori)).

    IF  ped-venda.observacoes <> "" AND
        ped-venda.cod-priori <> 44  AND 
        ped-venda.cod-priori <> 3 THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.

         IF OPSYS = "UNIX" THEN log-manager:write-message(' suspendeu ').
        for each ped-item of ped-venda
                where ped-item.cod-sit-item <= 2 exclusive-lock:
    
                for each ped-ent of ped-item
                    where ped-ent.cod-sit-ent <= 2 exclusive-lock:
    
                    assign ped-ent.cod-sit-ent  = 5
                           ped-ent.dt-suspensao = today
                           ped-ent.user-susp    = "Integra"
                           ped-ent.dt-usersusp  = today.
                end.

                assign ped-item.dt-suspensao = today
                       ped-item.user-susp    = "Integra"
                       ped-item.dt-usersusp  = today
                       ped-item.cod-sit-item = 5.
        end.
    
        assign ped-venda.dt-suspensao = today
               ped-venda.user-susp    = "Integra"
               ped-venda.dt-usersusp  = today
               ped-venda.desc-suspend = ped-venda.observacoes
               ped-venda.dt-useralt   = TODAY 
               ped-venda.user-alt     = "Integra"
               ped-venda.cod-sit-ped  = 5.
        
        IF NOT ped-venda.observacoes MATCHES "*composto*" THEN
            ASSIGN ped-venda.cod-priori = 99.
    END.
END PROCEDURE.

PROCEDURE  pi-retorna-dados-beneficios:
     
    DEF INPUT  PARAM p-uf-origem         AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-cidade-destino    AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-uf-destino        AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-unid-neg          AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-tp-beneficio      AS INT     NO-UNDO.
    DEF OUTPUT PARAM p-nat-oper          AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-canal-venda-benef AS INTEGER NO-UNDO.
    
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-uf-origem: ' + p-uf-origem).
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-cidade-destino: ' + p-cidade-destino).
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-uf-destino: ' + p-uf-destino).
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-unid-neg: ' + p-unid-neg).
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-tp-beneficio: ' + STRING(p-tp-beneficio)).
    

    /* CANAL DE VENDA ESESB016 */
    IF  p-tp-beneficio <> 04 AND p-tp-beneficio <> 15 THEN DO:
        FIND FIRST int-param-canal-benef NO-LOCK
            WHERE int-param-canal-benef.cod-unid-negoc  = p-unid-neg
              AND int-param-canal-benef.tp-beneficio    = p-tp-beneficio NO-ERROR.
    
        IF  NOT AVAIL int-param-canal-benef THEN DO:
            RUN pi-erro (INPUT "ParÉmetro Benef°cio X Canal de Venda inexistente. Para corrigir, cadastre uma regra no programa esesb016 para a Unidade " + p-unid-neg + " e Benef°cio " 
                                + fn-retorna-nome-beneficio(p-tp-beneficio) ).
        END.
    END.

    /* NATUREZA DE OPERACAO ESESB015 */
    FIND FIRST int-param-nat-oper-benef NO-LOCK
        WHERE int-param-nat-oper-benef.estado-origem   = p-uf-origem
          AND int-param-nat-oper-benef.estado-destino  = p-uf-destino
          AND int-param-nat-oper-benef.cidade-destino  = p-cidade-destino
          AND int-param-nat-oper-benef.tp-beneficio    = p-tp-beneficio NO-ERROR.

    IF  NOT AVAIL int-param-nat-oper-benef THEN DO:
        
        FIND FIRST int-param-nat-oper-benef NO-LOCK
            WHERE int-param-nat-oper-benef.estado-origem   = p-uf-origem
              AND int-param-nat-oper-benef.estado-destino  = p-uf-destino
              AND int-param-nat-oper-benef.cidade-destino  = ""
              AND int-param-nat-oper-benef.tp-beneficio    = p-tp-beneficio NO-ERROR.

        IF  NOT AVAIL int-param-nat-oper-benef THEN DO:

            FIND FIRST int-param-nat-oper-benef NO-LOCK
                WHERE int-param-nat-oper-benef.estado-origem   = p-uf-origem
                  AND int-param-nat-oper-benef.estado-destino  = ""
                  AND int-param-nat-oper-benef.cidade-destino  = ""
                  AND int-param-nat-oper-benef.tp-beneficio    = p-tp-beneficio NO-ERROR.


            IF  NOT AVAIL int-param-nat-oper-benef THEN DO:
                RUN pi-erro (INPUT "ParÉmetro Natureza de Operaá∆o X Benef°cio Canal inexistente. Para corrigir, cadastre uma regra no programa esesb015 para: " + chr(10) +
                                    "Estado Origem.: " + p-uf-origem + chr(10) +
                                    "Cidade Destino: " + p-cidade-destino + chr(10) +
                                    "Estado Destino: " + p-uf-destino + chr(10) +
                                    "Benef°cio.....: "  + fn-retorna-nome-beneficio(p-tp-beneficio) ).

                RETURN "NOK".

            END.

        END.

    END.

    ASSIGN p-nat-oper          = IF  AVAIL int-param-nat-oper-benef THEN int-param-nat-oper-benef.nat-operacao ELSE "".

    IF  p-tp-beneficio <> 04 AND p-tp-beneficio <> 15 THEN
        ASSIGN p-canal-venda-benef = IF  AVAIL int-param-canal-benef    THEN int-param-canal-benef.cod-canal-venda ELSE 0.

    IF OPSYS = "UNIX" THEN log-manager:write-message('p-nat-oper: ' + p-nat-oper).
    IF OPSYS = "UNIX" THEN log-manager:write-message('p-canal-venda-benef: ' + STRING(p-canal-venda-benef)).

END.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 04 THEN RETURN "BACKUP".
        WHEN 08 THEN RETURN "PRICE PROTECTION".
        WHEN 15 THEN RETURN "SHOW ROOM".
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.
