/*********************************************************************************
** Programa: esp/crm/escrm012.p
** Vers∆o..: 1.00
** Data....: 04/10/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para criar os Pedidos no EMS que est∆o sendo inseridos atravÇs do
**           Portal B2B
*********************************************************************************/


CREATE WIDGET-POOL.

/* Temp-tables do programa */
{esp/crm/escrm012.i}
{esp/es0018.i}

/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pPedVendaMessagem AS LONGCHAR    NO-UNDO.
DEFINE INPUT  PARAMETER pPedItemMessage   AS LONGCHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.



/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-ped-venda     NO-UNDO LIKE ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-item      NO-UNDO LIKE ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-ent       NO-UNDO LIKE ped-ent
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-repre     NO-UNDO LIKE ped-repre
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-venda NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda-aux NO-UNDO LIKE tt-ped-venda.

DEFINE TEMP-TABLE tt-ped-vendor    NO-UNDO
    FIELD data-base    AS DATE
    FIELD dias-base    AS INT  FORMAT ">>>9"
    FIELD cod-cond-pag AS INT  FORMAT ">9"
    FIELD taxa-cliente AS DEC  FORMAT ">>9.9999".

DEFINE TEMP-TABLE tt-preco-item    NO-UNDO
   FIELD nr-tabpre     LIKE preco-item.nr-tabpre
   FIELD it-codigo     LIKE preco-item.it-codigo
   FIELD cod-refer     LIKE preco-item.cod-refer
   FIELD dt-inival     LIKE preco-item.dt-inival
   FIELD quant-min     LIKE preco-item.quant-min
   FIELD preco-venda   LIKE preco-item.preco-venda
   FIELD situacao      LIKE preco-item.situacao
   FIELD desco-quant   LIKE preco-item.desco-quant
   INDEX ch-data       AS PRIMARY dt-inival it-codigo nr-tabpre cod-refer quant-min
   INDEX ch-itemtab    it-codigo cod-refer nr-tabpre dt-inival quant-min.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorSequence     AS INT
    FIELD errorNumber       AS INT
    FIELD errorDescription  AS CHAR FORMAT "x(150)"
    FIELD errorParameters   AS CHAR
    FIELD errorType         AS CHAR
    FIELD errorHelp         AS CHAR FORMAT "x(150)"
    FIELD errorSubtype      AS CHAR.


DEF TEMP-TABLE tt-ped-item-xml-copia LIKE tt-ped-item-xml.
DEF TEMP-TABLE tt-ped-item-xml-copia2 LIKE tt-ped-item-xml.
DEF BUFFER b-tt-ped-item-xml FOR tt-ped-item-xml.
DEF BUFFER b-tt-ped-item     FOR tt-ped-item.
DEF BUFFER b-tt-ped-venda    FOR tt-ped-venda.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE l-primeiro           AS LOGICAL   INITIAL YES       NO-UNDO.
DEFINE VARIABLE c-nr-pedido-retorno  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE l-qtd-max-ped        AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-return             AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-mantem-nat         AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-avalia             AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-abaixo-min         AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-erro               AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-unidade-permitida  AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-log                AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-subs-trib          AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE de-vl-pre-liq-pai    AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-vl-pre-liq-filho  AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-total-preco       AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-vl-ipi            AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-vl-liq-abe        AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-vl-liq            AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-vl-minimo         AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-valor-st          AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE d-perc               AS DECIMAL   INITIAL 0         NO-UNDO.
DEFINE VARIABLE d-valor-min          AS DECIMAL   INITIAL 0         NO-UNDO.
DEFINE VARIABLE de-tot-cipi          AS DEC FORMAT ">>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE de-tot-sipi          AS DEC FORMAT ">>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE de-vl-preori-aux     AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE i-qtd-max-ped        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-sequencia          AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-cont               AS INTEGER                     NO-UNDO.
DEFINE VARIABLE de-qtde              AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-seq-cartao         AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-nr-parcelas        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-cont-nat-igual     AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-cd-unid-comerc     AS INTEGER                     NO-UNDO.
DEFINE VARIABLE h-bodi149            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi154sdf         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi154            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi157            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159cal         AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159sus         AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boes505            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-escrm005           AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-desc-suspend       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-corporativo        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-prazo              AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-obs                AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-unid-neg           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-usuario            AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-senha              AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-estabel        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-it-codigo-aux      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cgc-rep            LIKE repres.cgc                NO-UNDO.
DEFINE VARIABLE c-nat-oper           LIKE natur-oper.nat-operacao   NO-UNDO.
DEFINE VARIABLE c-nat-oper-cabecalho LIKE natur-oper.nat-operacao   NO-UNDO.
DEFINE VARIABLE i-cliente            LIKE emitente.cod-emitente     NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe         LIKE tt-ped-item.vl-liq-abe    NO-UNDO.
DEFINE VARIABLE d-vl-liq-it          LIKE tt-ped-item.vl-liq-abe    NO-UNDO.
DEFINE VARIABLE c-transp             LIKE transporte.nome-abrev     NO-UNDO.
DEFINE VARIABLE c-cod-transp         LIKE transporte.cod-trans      NO-UNDO.
DEFINE VARIABLE c-sigla-transp       LIKE def-transportes.sigla-trans NO-UNDO.
DEFINE VARIABLE c-itens-filhos       AS CHARACTER FORMAT "x(100)"   NO-UNDO.
DEFINE VARIABLE i-nr-pedido          AS INTEGER                     NO-UNDO.
DEFINE VARIABLE c-supervisor         AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE l-consumidor-final   AS LOGICAL                     NO-UNDO.
/*--- Processamento Principal ---*/
ASSIGN l-log = YES.

FIND FIRST ponto-programa NO-LOCK
    WHERE  ponto-programa.nome-programa = "escrm004":U
    AND    ponto-programa.ponto         = 1 NO-ERROR.
IF  AVAIL  ponto-programa THEN DO:
    FOR EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF conteudo-programa.sequencia = 1 THEN DO:
            ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.

/* Login no EMS */
RUN bi/esbi002.p (INPUT c-usuario,
                  INPUT c-senha).

FIND FIRST para-ped     NO-LOCK NO-ERROR.
FIND FIRST para-fat     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa      NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.


IF  l-log THEN DO:
    MESSAGE "ESCRM012 Inicio API -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
END.


IF  NOT VALID-HANDLE(h-boes505) THEN
    RUN esbo/boes505.p PERSISTENT SET h-boes505.

IF  NOT VALID-HANDLE(h-escrm005) THEN
    RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.


/* Zera as temp-table e seta valores iniciais a cada arquivo */
RUN pi-zerar-temporarias.


DO TRANSACTION:
    CREATE tt-ped-venda-xml.
    /* Carrega as informaá‰es do Pedido com base no XML recebido como parÉmetro */


    IF  VALID-HANDLE(h-escrm005) THEN DO:
        RUN readXML IN h-escrm005 (INPUT  BUFFER tt-ped-venda-xml:HANDLE,
                                   INPUT  pPedVendaMessagem,
                                   OUTPUT TABLE tt-atributo-entrada).
    END.

    FIND FIRST tt-ped-venda-xml NO-LOCK NO-ERROR.

    IF  l-log THEN DO:
        MESSAGE "Antes leitura escrm005 -2->>>>>>>> " tt-ped-venda-xml.cod-cliente SKIP.
    END.

    /* Carrega as informaá‰es dos Itens do Pedido com base no XML recebido */
    IF  VALID-HANDLE(h-escrm005) THEN DO:
        RUN readXMLSon IN h-escrm005 (INPUT BUFFER tt-ped-item-xml:HANDLE,
                                      INPUT pPedItemMessage).
    END.
    IF  l-log THEN DO:
        MESSAGE "apos leitura do XML tt-ped-venda-xml >>>>>> "  SKIP.
    END.

    /*************** PEDIDO *******************/

    IF  l-log THEN DO:
        MESSAGE "apos leitura tt-ped-venda-xml - " AVAIL tt-ped-venda-xml  SKIP.
    END.

    IF NOT AVAIL tt-ped-venda-xml THEN DO:
                    /* Retorna o n£mero do pedido gerado para o Portal B2B */
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido Nao Criado no E.M.S, XML em branco " 
                   l-erro           = YES.

        IF  l-log THEN DO:
            MESSAGE "Pedido Nao Criado no E.M.S, XML em branco  " AVAIL tt-ped-venda-xml  SKIP.
        END.
            RETURN "NOK":U.
    END.
    IF  tt-ped-venda-xml.cod-cliente = 0 THEN DO:
                    /* Retorna o n£mero do pedido gerado para o Portal B2B */
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido Nao Criado no E.M.S, Codigo do Cliente Zerado " 
                   l-erro           = YES.
            IF  l-log THEN DO:
                MESSAGE "Pedido Nao Criado no E.M.S, Codigo do Cliente Zerado "  AVAIL tt-ped-venda-xml " " tt-ped-venda-xml.cod-cliente SKIP.
            END.

            RETURN "NOK":U.
    END.

    IF  AVAIL  tt-ped-venda-xml THEN DO:

        FIND FIRST int-ped-venda NO-LOCK 
             WHERE int-ped-venda.vl-guid = tt-ped-venda-xml.guid-crm NO-ERROR.
        IF  AVAIL  int-ped-venda THEN DO:
            FIND FIRST ped-venda NO-LOCK
                WHERE  ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido com o Guid Repetido: " + STRING(tt-ped-venda-xml.guid-crm) + " Nr Pedido Ja Existente no EMS " + STRING(ped-venda.nr-pedcli). /* Siginifica que ja houve integraá∆o do mesmo pedido no EMS*/
            
            IF  l-log THEN DO:
                MESSAGE "Pedido com o Guid Repetido: " + STRING(tt-ped-venda-xml.guid-crm) + " Nr Pedido Ja Existente no EMS " + STRING(ped-venda.nr-pedcli) SKIP.
            END.
            RETURN "NOK":U.        
        END.
        
        /* Busca o c¢digo da Unidade de Neg¢cio */
        FIND FIRST unid-comerc NO-LOCK
            WHERE  unid-comerc.ds-unid-comerc = tt-ped-venda-xml.cod-unid-negoc NO-ERROR.
        IF  NOT AVAIL unid-comerc THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Unidade Comercial inv†lida (" + tt-ped-venda-xml.cod-unid-negoc + ").".
                   l-erro           = YES.
            RETURN "NOK":U.
        END.

        ASSIGN i-cd-unid-comerc = unid-comerc.cd-unid-comerc.

        IF  l-log THEN
            MESSAGE "Estabelecimento: " tt-ped-venda-xml.cod-estabel SKIP
                    "Unidade Comercial: " tt-ped-venda-xml.cod-unid-negoc " - " unid-comerc.cd-unid-comerc 
                    "Cliente          : " tt-ped-venda-xml.cod-cliente SKIP.

        ASSIGN c-cod-estabel = IF tt-ped-venda-xml.cod-estabel = "101" AND unid-comerc.cd-unid-comerc <> 90 /* ASTEC */ THEN "104" ELSE tt-ped-venda-xml.cod-estabel.

        FIND FIRST estabelec NO-LOCK
            WHERE  estabelec.ep-codigo   = mgcad.empresa.ep-codigo
            AND    estabelec.cod-estabel = c-cod-estabel NO-ERROR.
        IF  NOT AVAIL estabelec THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Estabelecimento " + tt-ped-venda-xml.cod-estabel + " n∆o cadastrado para a Empresa " + STRING(mgcad.empresa.ep-codigo) + "."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        
        FIND FIRST repres NO-LOCK
            WHERE  repres.cod-rep = tt-ped-venda-xml.cod-repres NO-ERROR.
        IF  NOT AVAIL repres THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Representante " + STRING(tt-ped-venda-xml.cod-repres) + " n∆o cadastrado."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.


        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-ped-venda-xml.cod-cliente NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Cliente " + STRING(tt-ped-venda-xml.cod-cliente) + " n∆o cadastrado."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        


        FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
            WHERE  loc-entr.cod-entrega = "padrao"
            AND    loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
        IF  NOT AVAIL loc-entr THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Local de entrega do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.


        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = loc-entr.nome-transp NO-ERROR.
        IF  NOT AVAIL transporte THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Transportador do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado no local de entrega."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.
        ASSIGN c-transp = transporte.nome-abrev.


        FIND FIRST cond-pagto NO-LOCK
            WHERE  cond-pagto.cod-cond-pag = tt-ped-venda-xml.cod-cond-pag NO-ERROR.
        IF  NOT AVAIL cond-pagto THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Condiá∆o de Pagamento " + STRING(tt-ped-venda-xml.cod-cond-pag) + " n∆o cadastrada."
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        /*********************************************************************************
        **  Prop¢sito:  Validar os pedidos com os limites do SupplierCard
        **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
        **  Criaá∆o:    Novembro de 2011
        **********************************************************************************/
        /****************************************
        **  Validaá∆o do SupplierCard - In°cio
        *****************************************/
        /* Verificar se na Condiá∆o de Pagamento (CD0404) est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
        FIND FIRST int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = tt-ped-venda-xml.cod-cond-pag NO-LOCK NO-ERROR.

        IF AVAILABLE int-cond-pagto                       AND
           SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:

            FIND LAST int-param-supcard NO-LOCK NO-ERROR.

            FIND FIRST cond-pagto
                WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.

            IF (tt-ped-venda-xml.vl-tot-ped / cond-pagto.num-parcelas) < int-param-supcard.val-min-parc THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "A parcela de R$ ":U + TRIM(STRING((tt-ped-venda-xml.vl-tot-ped / cond-pagto.num-parcelas), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube Ç menor que o valor m°nimo permitido. (Parcela m°nima permitida do cart∆o Intelbras Clube: R$ ":U + TRIM(STRING(int-param-supcard.val-min-parc, "->>>,>>>,>>9.99":U)) + ").":U.
                       l-erro           = YES.

                IF l-log THEN
                    MESSAGE tt-erro.mensagem SKIP.

                RETURN "NOK":U.
            END.

        END.
        /****************************************
        **  Validaá∆o do SupplierCard - Final
        ****************************************/

        ASSIGN l-consumidor-final = NO.
        IF  NOT emitente.contrib-icm THEN
            ASSIGN l-consumidor-final = YES.
        RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                            INPUT  emitente.cod-emitente,
                                            INPUT  "padrao",
                                            INPUT  "",
                                            INPUT  l-consumidor-final,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).
        IF  NOT l-return THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Natureza de operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        FIND FIRST natur-oper NO-LOCK
            WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
        IF  NOT AVAIL natur-oper THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Natureza de Operaá∆o " + emitente.nat-operacao + " inv†lida no cadastro do Cliente " + STRING(emitente.cod-emitente)
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.


        FIND FIRST int-emitente NO-LOCK
            WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF  AVAIL  int-emitente           AND
            int-emitente.id-ativo   = NO  AND
            natur-oper.emite-duplic = YES THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Cliente n∆o esta ativo, n∆o Ç possivel integrar pedidos. Cliente " + STRING(tt-ped-venda-xml.cod-cliente) + " - " + emitente.nome-emit
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE "escrm012 - >>> " int-emitente.cod-emitente int-emitente.id-ativo natur-oper.emite-duplic SKIP.
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        IF  AVAIL int-emitente
        AND int-emitente.ind-participa-canais = 993520001 THEN DO: /*Participa canais*/

            ASSIGN l-unidade-permitida = NO.
            FOR EACH tt-ped-item-xml:
                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo   = tt-ped-item-xml.it-codigo
                       AND item-uni-estab.cod-estabel = estabelec.cod-estabel NO-ERROR.
            
                IF AVAIL item-uni-estab THEN DO:
                    RUN esp/es0018p.p (INPUT "PD4000",
                                       INPUT 4,
                                       INPUT 0,
                                       INPUT "", 
                                       OUTPUT TABLE tt-prog-ponto).
                   /*Unidade de negocios n∆o faz parte do programa de canais*/
                        IF CAN-FIND (FIRST tt-prog-ponto
                                     WHERE tt-prog-ponto.conteudo = item-uni-estab.cod-unid) THEN DO:
                            IF  l-log THEN DO:
                                MESSAGE "achou unidade "  tt-ped-item-xml.it-codigo    " " item-uni-estab.cod-unid " " 
                                                              estabelec.cod-estabel SKIP.
                            END. 
                            ASSIGN l-unidade-permitida = YES.
                        END.
                           
                END.
            END.

            IF l-unidade-permitida = YES               OR
               tt-ped-venda-xml.nr-tabpre = "lai02"    OR
               tt-ped-venda-xml.nr-tabpre = "ASTEC 02" THEN .
            ELSE DO:
                /* 71434  */
                FIND FIRST ponto-programa NO-LOCK
                    WHERE  ponto-programa.nome-programa = "escrm012":U
                    AND    ponto-programa.ponto         = 2 NO-ERROR.
                IF  AVAIL  ponto-programa THEN DO:
                    FOR EACH  conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
                        IF AVAIL emitente AND emitente.cod-gr-cli = integer(conteudo-programa.conteudo) THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = "Cliente participante do programa de canais, utilize a extranet Intelbras para entrada de pedidos. " 
                                   l-erro           = YES.
                            IF  l-log THEN DO:
                                MESSAGE "Cliente participante do programa de canais, utilize a extranet Intelbras para entrada de pedidos. " tt-ped-venda-xml.nr-tabpre " " l-unidade-permitida SKIP.

                            END.
                        END. /* IF AVAIL emitente AND emitente.cod-gr-cli = conteudo-programa.conteudo THEN DO: */
                    END. /* FOR EACH  conteudo-programa NO-LOCK */
                END. /* IF  AVAIL  ponto-programa THEN DO: */
 
/*                 CREATE tt-erro.                                                                                                                                                           */
/*                 ASSIGN tt-erro.mensagem = "Cliente participante do programa de canais, utilize a extranet Intelbras para entrada de pedidos. "                                            */
/*                        l-erro           = YES.                                                                                                                                            */
/*                IF  l-log THEN DO:                                                                                                                                                         */
/*                     MESSAGE "Cliente participante do programa de canais, utilize a extranet Intelbras para entrada de pedidos. " tt-ped-venda-xml.nr-tabpre " " l-unidade-permitida SKIP. */
/*                                                                                                                                                                                           */
/*                 END.                                                                                                                                                                      */

            END.

        END.

        /* Valida a Categoria Recebida */
        IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                         WHERE crm-categoria.cd-categoria = tt-ped-venda-xml.cod-categoria) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Categoria inv†lida (" + STRING(tt-ped-venda-xml.cod-categoria) + ").".
                   l-erro           = YES.
        END.

        /* Busca o Atendente, com base no Representante, UN e Categoria */
        FIND FIRST crm-atendente NO-LOCK
            WHERE  crm-atendente.cod-estabel   = estabelec.cod-estabel
            AND    crm-atendente.cod-rep       = tt-ped-venda-xml.cod-repres
            AND    crm-atendente.cd-unid-negoc = STRING(unid-comerc.cd-unid-comerc)
            AND    crm-atendente.cd-categoria  = tt-ped-venda-xml.cod-categoria
            AND    crm-atendente.cod-gr-cli    = emitente.cod-gr-cli NO-ERROR.
        IF  NOT  AVAIL crm-atendente THEN DO:
            FIND FIRST crm-atendente NO-LOCK
                WHERE  crm-atendente.cod-estabel   = estabelec.cod-estabel
                AND    crm-atendente.cod-rep       = tt-ped-venda-xml.cod-repres 
                AND    crm-atendente.cd-unid-negoc = STRING(unid-comerc.cd-unid-comerc)
                AND    crm-atendente.cod-gr-cli    = emitente.cod-gr-cli
                AND    crm-atendente.cd-categoria  = ? NO-ERROR.
            IF  NOT AVAIL crm-atendente THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Atendente n∆o encontrado para o Estabelecimento (" + estabelec.cod-estabel + "), Representante (" + STRING(tt-ped-venda-xml.cod-repres) + ") " +
                                          "Unidade de Neg¢cio (" + STRING(unid-comerc.cd-unid-comerc) + " - " + unid-comerc.ds-unid-comerc + ") e Categoria (" + STRING(tt-ped-venda-xml.cod-categoria) + ")".
                       l-erro           = YES.
            END.
        END.

        IF  l-log THEN DO:
            MESSAGE "Encontrou atendente do CRM: " AVAIL crm-atendente SKIP
                    "Unidade de Neg¢cio: " tt-ped-venda-xml.cod-unid-negoc SKIP
                    "Categoria: " tt-ped-venda-xml.cod-categoria SKIP
                    "Representante: " tt-ped-venda-xml.cod-repres SKIP
                    "Grupo Cliente: " emitente.cod-gr-cli SKIP
                    "Atendente: " IF AVAIL crm-atendente THEN crm-atendente.cd-atend ELSE 0 SKIP.
        END.


        /* Valida o Preáo M°nimo do Pedido */
        RUN esp/crm/escrm011.p (INPUT  tt-ped-venda-xml.cod-cliente,
                                INPUT  unid-comerc.ds-unid-comerc,
                                INPUT  tt-ped-venda-xml.cod-categoria,
                                OUTPUT de-vl-minimo).
        IF  tt-ped-venda-xml.vl-tot-ped < de-vl-minimo THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido est† com o valor abaixo do M°nimo permitido para este Cliente/Unidade de Neg¢cio/Categoria".
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.


        ASSIGN c-nat-oper-cabecalho = natur-oper.nat-operacao
               l-mantem-nat         = NO.

        CREATE tt-ped-venda.
        ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
               tt-ped-venda.nr-pedcli  = STRING(tt-ped-venda.nr-pedido)
               tt-ped-venda.nome-abrev = emitente.nome-abrev
               i-sequencia             = 0.
        ASSIGN c-nr-pedido-retorno     = tt-ped-venda.nr-pedcli.
        IF l-log = YES THEN do:
            MESSAGE " c-nr-pedido-retorno " c-nr-pedido-retorno SKIP.
        END.

        ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
               tt-ped-venda.dt-emissao              = tt-ped-venda-xml.dt-emissao
               tt-ped-venda.no-ab-reppri            = repres.nome-abrev
               tt-ped-venda.dt-implant              = TODAY
               tt-ped-venda.cod-emitente            = emitente.cod-emitente
               tt-ped-venda.nat-operacao            = natur-oper.nat-operacao
               tt-ped-venda.cod-mensagem            = natur-oper.cod-mensagem
               tt-ped-venda.cod-cond-pag            = tt-ped-venda-xml.cod-cond-pag
               tt-ped-venda.nr-tab-fin              = cond-pagto.nr-tab-finan
               tt-ped-venda.nr-ind-finan            = cond-pagto.nr-ind-finan
               tt-ped-venda.tp-pedido               = IF AVAIL crm-atendente THEN STRING(crm-atendente.cd-atend, "99") ELSE ""
               tt-ped-venda.e-mail                  = emitente.e-mail
               tt-ped-venda.cod-sit-aval            = 1 /* Credito N∆o Avaliado */
               tt-ped-venda.mo-codigo               = tt-ped-venda-xml.cod-moeda
               tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
               tt-ped-venda.tp-faturam              = 1
               tt-ped-venda.origem                  = 6
               tt-ped-venda.atendido                = NO
               tt-ped-venda.cd-origem               = 2
               tt-ped-venda.user-impl               = "adm"
               tt-ped-venda.dt-userimp              = TODAY
               tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
               tt-ped-venda.observacoes             = tt-ped-venda-xml.ds-observacao
               tt-ped-venda.cond-espec              = IF tt-ped-venda-xml.cond-especial <> "" THEN "OC: " + tt-ped-venda-xml.cond-especial ELSE ""
               tt-ped-venda.esp-ped                 = 1
               tt-ped-venda.cod-priori              = 01
               tt-ped-venda.cod-rota                = loc-entr.cod-rota
               tt-ped-venda.cod-canal-venda         = IF natur-oper.cod-canal-venda <> 0 THEN natur-oper.cod-canal-venda ELSE emitente.cod-canal-venda
               tt-ped-venda.ind-ent-completa        = YES
               tt-ped-venda.dsp-pre-fat             = YES
               tt-ped-venda.log-usa-tabela-desconto = NO
               tt-ped-venda.cod-des-merc            = 1
               tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota WHEN AVAIL para-ped
               OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

        FIND FIRST atendente
             WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
        IF AVAIL atendente AND atendente.cod-gr-canais = 3 THEN DO: // atendente de verticais entrar como 5

            EMPTY TEMP-TABLE tt-prog-ponto.

            RUN esp/es0018p.p (INPUT  "pd4000":U,
                               INPUT  12,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).

            FIND FIRST tt-prog-ponto NO-ERROR.

            ASSIGN tt-ped-venda.cod-priori = INT(tt-prog-ponto.conteudo).
        END.                                   

        IF tt-ped-venda-xml.cod-categoria = 9 THEN
           ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " Cliente com desconto de P¢s-Venda ".

        IF emitente.contrib-icms = NO THEN 
            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " CARO ATENDENTE, CLIENTE N«O CONTRIBUINTE DE ICMS, FAVOR VERIFICAR OS PREÄOS DO PEDIDO E AJUSTAR DE ACORDO COM A TABELA DE PREÄOS. ".

        IF emitente.estado = "SC" AND int-emitente.ind-forma-tributo = 3 THEN /*Chamado 128930 - Cliente sc e do simples*/
            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " CARO ATENDENTE, Cliente do Simples, favor ajustar os preáos de acordo com a tabela. ".


        
        CREATE tt-int-ped-venda.
        ASSIGN tt-int-ped-venda.cod-estabel             = tt-ped-venda.cod-estabel
               tt-int-ped-venda.nr-pedido               = tt-ped-venda.nr-pedido
               tt-int-ped-venda.dt-negociacao           = tt-ped-venda-xml.dt-negociacao
               tt-int-ped-venda.dias-negociacao         = tt-ped-venda-xml.dias-negociacao
               tt-int-ped-venda.vl-guid                 = tt-ped-venda-xml.guid-crm
               OVERLAY(tt-int-ped-venda.char-1,12,3)    = STRING(tt-ped-venda-xml.cod-categoria)
               OVERLAY(tt-int-ped-venda.char-1,16,3)    = STRING(i-cd-unid-comerc)
               OVERLAY(tt-int-ped-venda.char-1,1,8)     = STRING(TIME,"HH:MM:SS")
               OVERLAY(tt-int-ped-venda.char-1,53,12)   = STRING(tt-ped-venda-xml.cond-especial).

        IF AVAIL repres THEN DO:
            FIND FIRST crm-relacionamento-cliente NO-LOCK                                         
                WHERE  crm-relacionamento-cliente.cd-unid-negoc    = substring(tt-int-ped-venda.char-1, 16, 3)
                  AND  crm-relacionamento-cliente.cod-rep          = repres.cod-rep
                  AND  crm-relacionamento-cliente.cod-emitente     = emitente.cod-emitente 
                  AND (crm-relacionamento-cliente.dt-vigencia-fim  = ? 
                   OR  crm-relacionamento-cliente.dt-vigencia-fim >= TODAY)  NO-ERROR.
            IF AVAIL crm-relacionamento-cliente THEN DO:

                IF crm-relacionamento-cliente.dt-vigencia-fim <> ? THEN DO:
                    IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY
                    AND crm-relacionamento-cliente.dt-vigencia-fim >= TODAY THEN DO:


                        FIND FIRST gerente NO-LOCK
                            WHERE gerente.cod-gerente = crm-relacionamento.cod-gerente NO-ERROR.

                        IF AVAIL gerente THEN DO:
                            ASSIGN OVERLAY(tt-int-ped-venda.char-1,68,8) = gerente.matricula.
                        END. /*if avail gerente*/
                        ELSE DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = "Nao encontrado supervisor relacionado ao Pedido".
                                   l-erro           = YES.
                            RETURN "NOK":U.
                        END.

                    END.
                    ELSE DO:
                        CREATE tt-erro.
                        ASSIGN tt-erro.mensagem = "Nao encontrado supervisor com data de validade relacionado ao Pedido".
                               l-erro           = YES.
                        RETURN "NOK":U.
                    END.
                END. /* IF crm-relacionamento-cliente.dt-vigencia-fim <> ? THEN DO: */
                ELSE DO:
                    IF  crm-relacionamento-cliente.dt-vigencia-ini <= TODAY THEN DO:


                        FIND FIRST gerente NO-LOCK
                            WHERE gerente.cod-gerente = crm-relacionamento.cod-gerente NO-ERROR.

                        IF AVAIL gerente THEN DO:
                            ASSIGN OVERLAY(tt-int-ped-venda.char-1,68,8) = gerente.matricula.
                        END. /*if avail gerente*/
                        ELSE DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = "Nao encontrado supervisor relacionado ao Pedido".
                                   l-erro           = YES.
                            RETURN "NOK":U.
                        END.

                    END.
                    ELSE DO:
                        CREATE tt-erro.
                        ASSIGN tt-erro.mensagem = "Nao encontrado supervisor com data de validade relacionado ao Pedido".
                               l-erro           = YES.
                        RETURN "NOK":U.
                    END.
                END.

            END. /*if avail relacionamento-cliente*/ 
            ELSE DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Nao encontrado supervisor relacionado ao Pedido".
                       l-erro           = YES.
                RETURN "NOK":U.
            END.
        END. /*if avail repres*/
        ELSE DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Nao encontrado supervisor relacionado ao Pedido".
                   l-erro           = YES.
            RETURN "NOK":U.
        END.
            
            
        IF  l-log THEN DO:
            MESSAGE "tt-int-ped-venda.cod-estabel.: " tt-int-ped-venda.cod-estabel SKIP
                    "tt-int-ped-venda.nr-pedido.: " tt-int-ped-venda.nr-pedido SKIP
                    "tt-int-ped-venda.dt-negociacao.: " tt-int-ped-venda.dt-negociacao SKIP
                    "tt-int-ped-venda.dias-negociacao.: " tt-int-ped-venda.dias-negociacao SKIP
                    "tt-int-ped-venda.vl-guid.: " tt-int-ped-venda.vl-guid SKIP
                    "OVERLAY(tt-int-ped-venda.char-1,12,3) " substring(tt-int-ped-venda.char-1,12,3)      SKIP
                    "OVERLAY(tt-int-ped-venda.char-1,16,3) "  substring(tt-int-ped-venda.char-1,16,3)
                    "overlay(tt-int-ped-venda.char-1,1,8)" SUBSTRING(tt-int-ped-venda.char-1,1,8) SKIP    .
        END.

        IF  natur-oper.consum-final THEN
            ASSIGN tt-ped-venda.cod-des-merc = 2.
        ELSE
            ASSIGN tt-ped-venda.cod-des-merc = 1.


        IF  TODAY <= tt-ped-venda-xml.dt-entrega THEN
            ASSIGN tt-ped-venda.dt-entrega = tt-ped-venda-xml.dt-entrega
                   tt-ped-venda.dt-entorig = tt-ped-venda-xml.dt-entrega.
        ELSE
            ASSIGN tt-ped-venda.dt-entrega = TODAY
                   tt-ped-venda.dt-entorig = TODAY.

        IF  emitente.nome-tr-red <> "" THEN DO:
            FIND FIRST transporte NO-LOCK
                WHERE  transporte.nome-abrev = emitente.nome-tr-red NO-ERROR.
            IF  NOT AVAIL transporte THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Transportador Redespacho " + emitente.nome-tr-red + " do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado."
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
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
            
             CREATE tt-erro.
             ASSIGN tt-erro.mensagem = "N∆o encontrada transportadora para relacionamento UF x Cidade x Cliente."
                    l-erro           = YES.
            
             ASSIGN tt-ped-venda.nome-transp = "".

        END.
        ELSE DO:
        
            FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                ASSIGN c-transp = transporte.nome-abrev.
            END.
    
            ASSIGN tt-ped-venda.nome-transp              = c-transp /* transporte.nome-abrev Incidente - 26357 */
                   OVERLAY(tt-int-ped-venda.char-1,20,5) = c-sigla-transp.  
        END.

        ASSIGN tt-ped-venda.ind-fat-par = tt-ped-venda-xml.ind-fat-parc.



        /* Criaá∆o do ped-vendor */
        IF  tt-ped-venda-xml.ind-vendor THEN DO: /******* Vendor *******/
            IF  NOT CAN-FIND(FIRST tt-ped-vendor) THEN
                CREATE tt-ped-vendor.
            ASSIGN tt-ped-venda-xml.taxa-cliente = 1.15.

            ASSIGN tt-ped-vendor.cod-cond-pag = tt-ped-venda.cod-cond-pag
                   tt-ped-vendor.dias-base    = tt-ped-venda-xml.dias-base
                   tt-ped-vendor.taxa-cliente = tt-ped-venda-xml.taxa-cliente
                   tt-ped-vendor.data-base    = ?
                   tt-ped-venda.cod-cond-pag  = 502
                   tt-ped-venda.cod-portador  = 999
                   tt-ped-venda.modalidade    = 7.

            IF  l-log THEN DO:
                MESSAGE "Vendor "  tt-ped-vendor.cod-cond-pag " = "
                                   tt-ped-venda.cod-cond-pag SKIP.

            END.

            ASSIGN c-prazo = ""
                   i-cont  = 1.

            DO WHILE cond-pagto.prazos[i-cont] <> 0:
                IF  i-cont = 1 THEN
                    ASSIGN c-prazo = STRING(cond-pagto.prazos[1]).
                ELSE
                    ASSIGN c-prazo = c-prazo + "/" + STRING(cond-pagto.prazos[i-cont]).

                ASSIGN i-cont = i-cont + 1.
            END.

            ASSIGN c-obs = "VENDOR " + c-prazo + "  TX " + STRING(tt-ped-vendor.taxa-cliente ,">>9.99") + "%am".

            IF  tt-ped-vendor.dias-base > 0 THEN
                ASSIGN c-obs = c-obs + " FECHAR APOS " + STRING(tt-ped-vendor.dias-base)  + " DIAS".

            ASSIGN tt-ped-venda.cond-espec   = TRIM(tt-ped-venda.cond-espec) + c-obs
                   tt-ped-venda.dt-prev-vend = TODAY.
        END.
        ELSE DO:
              /* Atribuir Portador conforme o cadastro do cliente */
              IF  emitente.portador <> 0 THEN
                  ASSIGN tt-ped-venda.cod-portador = emitente.portador
                         tt-ped-venda.modalidade   = emitente.modalidade.
              ELSE
                  ASSIGN tt-ped-venda.cod-portador = 999
                         tt-ped-venda.modalidade   = 6.
        END.

        /* Criaá∆o do ped-repre */
        ASSIGN c-cgc-rep = repres.cgc.

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
        /*************** ITENS DO PEDIDO   ****************** */
        FOR EACH tt-ped-item-xml:
            CREATE tt-ped-item-xml-copia2.
            BUFFER-COPY tt-ped-item-xml TO tt-ped-item-xml-copia2.
        END.
        FOR EACH tt-ped-item-xml:

            IF  l-log THEN DO:
                MESSAGE "Escrm012 = " tt-ped-item-xml.it-codigo SKIP.
            END.


            /* Venda Casada - Incidente 29487 */
            IF CAN-FIND(FIRST item-composto
                        WHERE item-composto.it-codigo-pai = tt-ped-item-xml.it-codigo NO-LOCK) THEN DO:
                IF  l-log THEN DO:
                    MESSAGE "Escrm012 = Item Composto- Abaixo os Itens:  " tt-ped-item-xml.it-codigo SKIP.
                    FOR EACH tt-ped-item-xml-copia2:
                        MESSAGE tt-ped-item-xml-copia2.it-codigo SKIP.
                    END.
                    MESSAGE "Fim listagem Itens" SKIP.

                END.


                ASSIGN c-itens-filhos = "":U.
                FOR EACH item-composto
                   WHERE item-composto.it-codigo-pai = tt-ped-item-xml.it-codigo NO-LOCK:

                    IF  l-log THEN DO:
                        MESSAGE "Escrm012 = Dentro For each " tt-ped-item-xml.it-codigo SKIP.
                    END.

                    IF NOT CAN-FIND(FIRST tt-ped-item-xml-copia2
                                    WHERE tt-ped-item-xml-copia2.it-codigo = trim(item-composto.it-codigo-filho)) THEN DO:

                        ASSIGN c-itens-filhos = c-itens-filhos + item-composto.it-codigo-filho + ";".
                    END.
                    IF  l-log THEN DO:
                        MESSAGE "Escrm012 = apos montar c-itens-filhos " c-itens-filhos SKIP.
                    END.
                END.

                IF c-itens-filhos <> "":U THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.mensagem = "Venda Casada, n∆o foi informado todos os itens relacionados: " + c-itens-filhos
                           l-erro           = YES.
                    
                    IF  l-log THEN DO:
                        MESSAGE tt-erro.mensagem SKIP.
                    END.
                    
                    RETURN "NOK":U.
                END.
            END.
            IF CAN-FIND(FIRST item-composto
                        WHERE item-composto.it-codigo-filho = tt-ped-item-xml.it-codigo NO-LOCK) THEN DO:
                IF  l-log THEN DO:
                    MESSAGE "Escrm012 = Item Composto - ITENS ABAIXO " tt-ped-item-xml.it-codigo SKIP.
                    FOR EACH tt-ped-item-xml-copia2:
                        MESSAGE tt-ped-item-xml-copia2.it-codigo SKIP.
                    END.
                END.


                ASSIGN c-itens-filhos = "":U.
                FOR EACH item-composto
                   WHERE item-composto.it-codigo-filho = tt-ped-item-xml.it-codigo NO-LOCK:

                    IF  l-log THEN DO:
                        MESSAGE "Escrm012 = Dentro For each " tt-ped-item-xml.it-codigo SKIP.
                    END.

                    IF NOT CAN-FIND(FIRST tt-ped-item-xml-copia2
                                    WHERE tt-ped-item-xml-copia2.it-codigo = trim(item-composto.it-codigo-pai)) THEN DO:

                        ASSIGN c-itens-filhos = c-itens-filhos + item-composto.it-codigo-pai + ";".
                    END.
                    IF  l-log THEN DO:
                        MESSAGE "Escrm012 = apos montar c-itens-filhos " c-itens-filhos SKIP.
                    END.
                END.

                IF c-itens-filhos <> "":U THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.mensagem = "Venda Casada, n∆o foi informado Nenhum item relacionado: " + c-itens-filhos
                           l-erro           = YES.
                    
                    IF  l-log THEN DO:
                        MESSAGE tt-erro.mensagem SKIP.
                    END.
                    
                    RETURN "NOK":U.
                END.
            END.
            /**/

            FIND FIRST item NO-LOCK
                WHERE  item.it-codigo = tt-ped-item-xml.it-codigo NO-ERROR.

            IF  l-log THEN DO:
                MESSAGE "**** FOR EACH tt-ped-item-xml ****" SKIP
                        "tt-ped-item-xml.it-codigo: " tt-ped-item-xml.it-codigo SKIP
                        "Unidade Comercial: " i-cd-unid-comerc SKIP
                        "Tabela de Preáo: " tt-ped-venda-xml.nr-tabpre SKIP
                        "Produto Composto? " CAN-FIND(FIRST prod-composto NO-LOCK
                                                      WHERE prod-composto.it-codigo-pai = item.it-codigo) SKIP.
            END.
            
            FIND FIRST prod-composto NO-LOCK
                         WHERE prod-composto.it-codigo-pai = item.it-codigo NO-ERROR.
            IF AVAIL prod-composto THEN DO:

                IF  i-cd-unid-comerc <> 70 /* ICOMP */ THEN DO:
                    ASSIGN de-total-preco = 0.
                    FOR EACH  prod-composto NO-LOCK
                        WHERE prod-composto.it-codigo-pai = item.it-codigo:
                        FIND LAST preco-item NO-LOCK
                            WHERE preco-item.it-codigo  = prod-composto.it-codigo-filho
                            AND   preco-item.nr-tabpre  = tt-ped-venda-xml.nr-tabpre
                            AND   preco-item.situacao   = 1
                            AND   preco-item.dt-inival <= TODAY NO-ERROR.
                        IF  NOT AVAIL preco-item THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = "Produto composto, componente sem preáo na tabela " + tt-ped-venda-xml.nr-tabpre + " - Item Pai " + item.it-codigo + " Item Filho " + prod-composto.it-codigo-filho
                                   l-erro           = YES.

                            NEXT.
                        END.
                            

                        ASSIGN de-total-preco = de-total-preco + preco-item.preco-venda * prod-composto.qt-filho.

                        IF  l-log THEN DO:
                            MESSAGE "Preco Item Filho : " prod-composto.it-codigo-filho "  preco-item.preco-venda * prod-composto.qt-filho " preco-item.preco-venda  " * "  prod-composto.qt-filho " de-total-preco " de-total-preco skip.
                        END.
                    END.

                    FOR EACH  prod-composto NO-LOCK
                        WHERE prod-composto.it-codigo-pai = item.it-codigo:
                        FIND LAST preco-item NO-LOCK
                            WHERE preco-item.it-codigo  = prod-composto.it-codigo-filho
                            AND   preco-item.nr-tabpre  = tt-ped-venda-xml.nr-tabpre
                            AND   preco-item.situacao   = 1
                            AND   preco-item.dt-inival <= TODAY NO-ERROR.
                        IF  NOT AVAIL preco-item THEN
                            NEXT.


                        IF  l-log THEN DO:
                            MESSAGE "Calculo Preco unitario Filho = " tt-ped-item-xml.vl-preori " * " preco-item.preco-venda " * " prod-composto.qt-filho " / " de-total-preco SKIP.
                        END.

                        EMPTY TEMP-TABLE tt-ped-item-xml-copia.


                        IF  l-log THEN DO:
                                MESSAGE "Antes Buffer-copy "  tt-ped-item-xml.it-codigo
                                " tt-ped-item-xml.de-qtd -> " tt-ped-item-xml.de-qtd 
                                " prod-composto.qt-filho -> " prod-composto.qt-filho 
                                " de-qtde " de-qtde SKIP.
                        END.
                      
                        BUFFER-COPY tt-ped-item-xml TO tt-ped-item-xml-copia.

                        FIND FIRST b-tt-ped-item-xml NO-LOCK
                            WHERE  b-tt-ped-item-xml.nr-pedcli  = tt-ped-item-xml.nr-pedcli
                            AND    b-tt-ped-item-xml.nome-abrev = tt-ped-item-xml.nome-abrev 
                            AND    b-tt-ped-item-xml.it-codigo  = prod-composto.it-codigo-filho NO-ERROR.

                        IF l-log  THEN DO:
                            MESSAGE "existe b-tt-ped-item-xml " AVAIL b-tt-ped-item-xml SKIP
                                     tt-ped-venda.nr-pedcli    SKIP
                                     tt-ped-venda.nome-abrev       SKIP
                                     prod-composto.it-codigo-filho         SKIP.

                        END.

                        /* Vincula pai filho */
                        IF  l-log THEN DO:
                            MESSAGE "antes prod-composto.it-codigo-filho " prod-composto.it-codigo-filho " item.it-codigo " item.it-codigo  skip.
                        END.
                        /*IF  prod-composto.it-codigo-filho = '4990709' THEN DO:*/

                            IF  l-log THEN 
                                MESSAGE "ITEM COMPOSTO " 
                                        " tt-ped-venda-xml.nome-abrev   "   tt-ped-venda.nome-abrev     skip
                                        " tt-ped-venda-xml.nr-pedcli    "   tt-ped-venda.nr-pedcli      skip
                                        " 10                            "                                   skip
                                        " prod-composto.it-codigo-filho "   prod-composto.it-codigo-filho   skip
                                        " tt-ped-item-xml.cod-refer     "   tt-ped-item-xml.cod-refer       skip
                                        " item.it-codigo                "   prod-composto.it-codigo-pai  
                                         skip.
                            
                            FIND FIRST int-ped-item-pai
                                WHERE int-ped-item-pai.nome-abrev    = tt-ped-venda.nome-abrev  
                                  AND int-ped-item-pai.nr-pedcli     = tt-ped-venda.nr-pedcli
                                  AND int-ped-item-pai.nr-sequencia  = 10
                                  AND int-ped-item-pai.it-codigo     = prod-composto.it-codigo-filho   
                                  AND int-ped-item-pai.cod-refer     = tt-ped-item-xml.cod-refer 
                                  AND int-ped-item-pai.it-codigo-pai = prod-composto.it-codigo-pai  NO-LOCK NO-ERROR.
                            IF NOT AVAIL int-ped-item-pai THEN DO:

                                IF  l-log THEN 
                                    MESSAGE "CRIANDO item-pai ITEM COMPOSTO 4990709 " tt-ped-item-xml.nr-pedcli  skip.

                                CREATE int-ped-item-pai.
                                ASSIGN int-ped-item-pai.nome-abrev    = tt-ped-venda.nome-abrev  
                                       int-ped-item-pai.nr-pedcli     = tt-ped-venda.nr-pedcli
                                       int-ped-item-pai.nr-sequencia  = 10
                                       int-ped-item-pai.it-codigo     = prod-composto.it-codigo-filho   
                                       int-ped-item-pai.cod-refer     = tt-ped-item-xml.cod-refer   
                                       int-ped-item-pai.it-codigo-pai = prod-composto.it-codigo-pai 
                                       int-ped-item-pai.qt-pedida     = tt-ped-item-xml.qt-pedida.
                            END. /* IF NOT AVAIL int-ped-item-pai THEN DO: */
                            ELSE DO:

                                IF  l-log THEN 
                                    MESSAGE "JA EXISTE item-pai ITEM COMPOSTO 4990709 " tt-ped-item-xml.nr-pedcli  skip.

                            END.
                        /* END. IF  prod-composto.it-codigo-filho = '4990709' THEN DO: */
                        /* Termina - Vincula pai filho */
                        
                        IF  AVAIL  b-tt-ped-item-xml THEN DO:
                            FIND LAST b-tt-ped-item-xml NO-LOCK
                                WHERE  b-tt-ped-item-xml.nr-pedcli  = tt-ped-item-xml.nr-pedcli     
                                AND    b-tt-ped-item-xml.nome-abrev = tt-ped-item-xml.nome-abrev    
                                NO-ERROR.
                            IF AVAIL b-tt-ped-item-xml THEN
                               ASSIGN tt-ped-item-xml.nr-sequencia = b-tt-ped-item-xml.nr-sequencia + 10.
              
                        END.

                        ASSIGN tt-ped-item-xml.it-codigo  = prod-composto.it-codigo-filho
                               tt-ped-item-xml.vl-preori  = (tt-ped-item-xml.vl-preori * preco-item.preco-venda) / de-total-preco
                               tt-ped-item-xml.vl-preori  = tt-ped-item-xml.vl-preori 
                               de-qtde                    = tt-ped-item-xml.de-qtd * prod-composto.qt-filho
                               tt-ped-item-xml.de-qtd-aux = de-qtde.


                        IF  l-log THEN DO:
                                MESSAGE "Apos o Calculo " tt-ped-item-xml.vl-preori 
                                " tt-ped-item-xml.de-qtd -> " tt-ped-item-xml.de-qtd 
                                " prod-composto.qt-filho -> " prod-composto.qt-filho 
                                " de-qtde " de-qtde SKIP.
                        END.
                      

                        FIND FIRST tt-ped-item NO-LOCK
                            WHERE  tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                            AND    tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                            AND    tt-ped-item.it-codigo  = tt-ped-item-xml.it-codigo NO-ERROR.
                        IF  AVAIL  tt-ped-item THEN DO:
                            ASSIGN tt-ped-item.qt-pedida     = tt-ped-item.qt-pedida + tt-ped-item-xml.de-qtd-aux
                                   tt-ped-item.qt-un-fat     = tt-ped-item.qt-pedida.
                            PUT "Ja existe item " tt-ped-item.it-codigo " Qtdade "  tt-ped-item.qt-pedida SKIP.
                        END.
                        ELSE
                            RUN CriaItem.

                        BUFFER-COPY tt-ped-item-xml-copia EXCEPT nr-pedcli nome-abrev it-codigo cod-refer nr-sequencia TO tt-ped-item-xml.
                    END.
                    DELETE tt-ped-item-xml. /* Eliminado porque ja criou os itens acima e estava relendo o mesmo registro s¢ que com o ultimo item filho, consequentemente somando a quantidade no ultimo item */
                END.
                ELSE DO:  /* Produtos compostos para Icomp */
                    ASSIGN de-vl-pre-liq-pai  = DEC(tt-ped-item-xml.vl-preori).

                    /* Aplica IPI no pai */
                    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
                       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
                        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
                        ASSIGN de-vl-pre-liq-pai = de-vl-pre-liq-pai * (1 + (item.aliquota-ipi / 100)).
                    ELSE
                        ASSIGN de-vl-pre-liq-pai = de-vl-pre-liq-pai.

                    FOR EACH  prod-composto NO-LOCK
                        WHERE prod-composto.it-codigo-pai = item.it-codigo:

                        IF  l-log THEN DO:
                            MESSAGE "Produto composto: " prod-composto.it-codigo-filho SKIP.
                        END.

                        EMPTY TEMP-TABLE tt-preco-item.
                        FOR EACH  preco-item NO-LOCK
                            WHERE preco-item.it-codigo = prod-composto.it-codigo-filho
                            AND   preco-item.nr-tabpre = tt-ped-venda-xml.nr-tabpre:
                            CREATE tt-preco-item.
                            BUFFER-COPY preco-item TO tt-preco-item.
                        END.

                        FIND LAST tt-preco-item NO-LOCK
                            WHERE tt-preco-item.situacao   = 1
                            AND   tt-preco-item.dt-inival <= TODAY NO-ERROR.
                        IF  NOT AVAIL tt-preco-item THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = "Item composto " + prod-composto.it-codigo-filho + " sem preáo ativo cadastrado. Cliente " + STRING(emitente.cod-emitente)
                                   l-erro           = YES.

                            IF  l-log THEN DO:
                                MESSAGE tt-erro.mensagem SKIP.
                            END.
                            RETURN "NOK":U.
                        END.

                        /* Grava as informaá‰es originais em uma vari†vel auxiliar
                           para poder desfazer a alteraá∆o depois do processo */
                        ASSIGN c-it-codigo-aux  = tt-ped-item-xml.it-codigo
                               de-vl-preori-aux = tt-ped-item-xml.vl-preori.

                        ASSIGN tt-ped-item-xml.it-codigo  = prod-composto.it-codigo-filho
                               tt-ped-item-xml.vl-preori  = tt-preco-item.preco-venda
                               de-qtde                    = tt-ped-item-xml.de-qtd * prod-composto.qt-filho
                               tt-ped-item-xml.de-qtd-aux = de-qtde.


                        RUN CriaItem.


                        FIND FIRST item NO-LOCK
                            WHERE  item.it-codigo = prod-composto.it-codigo-filho NO-ERROR.

                        /* Aplica IPI no filho */
                        IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
                           (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
                            natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
                            ASSIGN de-vl-pre-liq-filho = tt-preco-item.preco-venda * (1 + (item.aliquota-ipi / 100)).
                        ELSE
                            ASSIGN de-vl-pre-liq-filho = tt-preco-item.preco-venda.

                        /* Retira o preáo do componente */
                        ASSIGN de-vl-pre-liq-pai = de-vl-pre-liq-pai - de-vl-pre-liq-filho.

                        /* Retorna os valores ao original (recebido no XML) */
                        ASSIGN tt-ped-item-xml.it-codigo = c-it-codigo-aux
                               tt-ped-item-xml.vl-preori = de-vl-preori-aux.
                    END.

                    FIND FIRST item NO-LOCK
                        WHERE  item.it-codigo = tt-ped-item-xml.it-codigo NO-ERROR.

                    /* Retira o IPI do Pai */
                    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
                       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
                        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
                        ASSIGN de-vl-pre-liq-pai = de-vl-pre-liq-pai / (1 + (item.aliquota-ipi / 100)).
                    ELSE
                        ASSIGN de-vl-pre-liq-pai = de-vl-pre-liq-pai.

                    ASSIGN tt-ped-item-xml.vl-preori = de-vl-pre-liq-pai.

                    RUN CriaItem. /* Quando n∆o tem proporá∆o significa que Ç icomp e devera manter o item original */
                END.
            END.
            ELSE DO:
                FIND FIRST tt-ped-item NO-LOCK
                    WHERE  tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                    AND    tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                    AND    tt-ped-item.it-codigo  = tt-ped-item-xml.it-codigo NO-ERROR.
                IF  AVAIL  tt-ped-item THEN DO:
                    ASSIGN de-vl-pre-liq-filho       = ROUND((tt-ped-item-xml.vl-preori * tt-ped-item-xml.de-qtd-aux) + (tt-ped-item.vl-preori * tt-ped-item.qt-pedida),2)
                           tt-ped-item.vl-preori     = ROUND(de-vl-pre-liq-filho / (tt-ped-item.qt-pedida + tt-ped-item-xml.de-qtd-aux),2)
                           tt-ped-item.vl-pretab     = tt-ped-item.vl-preori 
                           tt-ped-item-xml.vl-preori = tt-ped-item.vl-preori
                           tt-ped-item.qt-pedida     = tt-ped-item.qt-pedida + tt-ped-item-xml.de-qtd
                           tt-ped-item.qt-un-fat     = tt-ped-item.qt-pedida.

                    IF  l-log THEN DO:
                        MESSAGE "Ja existia item do pedido : " tt-ped-item.it-codigo " Qtde " tt-ped-item.qt-pedida SKIP.
                    END.
                END.
                ELSE DO:
                    ASSIGN tt-ped-item-xml.de-qtd-aux = tt-ped-item-xml.de-qtd.

                    IF  l-log THEN DO:
                        MESSAGE "Nao existia item do pedido : " tt-ped-item-xml.it-codigo " Qtde " tt-ped-item-xml.de-qtd-aux SKIP.
                    END.

                    RUN CriaItem.
                END.
            END. 
        END.
    END. /**** FIND FIRST tt-ped-venda-xml ****/

    IF  l-log THEN DO:
        MESSAGE "escrm012 - Final Criacao Pedido -> " l-erro AVAIL tt-ped-venda-xml SKIP.
    END.

    /* Caso encontre algum erro, retorna os erros */
    IF  l-erro THEN
        RETURN "NOK":U.
/*     FOR EACH tt-ped-item  NO-LOCK:                                    */
/*         MESSAGE tt-ped-item.nr-pedcli " " tt-ped-item.it-codigo SKIP. */
/*                                                                       */
/*     END.                                                              */

    RELEASE tt-ped-item.
    /* Separar pedidos Caso tenha itens de serviáo */
    FOR EACH tt-ped-venda NO-LOCK,
        EACH tt-ped-item  NO-LOCK
        WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli,
        FIRST ITEM
        WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK
        BREAK BY ITEM.cod-servico:

        IF  l-log THEN DO:
            MESSAGE "escrm012 - Servico INICIO "  tt-ped-item.nr-pedcli " " tt-ped-item.it-codigo " " tt-ped-item.nr-sequencia SKIP.
        END.

        IF FIRST-OF(ITEM.cod-servico) AND
           ITEM.cod-servico <> 0 THEN DO:
            CREATE b-tt-ped-venda.
            BUFFER-COPY tt-ped-venda EXCEPT nr-pedcli nr-pedido TO b-tt-ped-venda.
            ASSIGN b-tt-ped-venda.nr-pedido    = NEXT-VALUE(seq-nr-pedido)
                   b-tt-ped-venda.nr-pedcli    = STRING(b-tt-ped-venda.nr-pedido)
                   b-tt-ped-venda.cod-estabel  = "101" 
                   b-tt-ped-venda.nat-operacao = "800001" 
                   i-sequencia                 = 0
                   i-nr-pedido                 = b-tt-ped-venda.nr-pedido
                   b-tt-ped-venda.observacoes = tt-ped-venda.observacoes + " PEDIDO DE SERVICO ".
                   

            CREATE tt-ped-repre.
            ASSIGN tt-ped-repre.nr-pedido   = b-tt-ped-venda.nr-pedido
                   tt-ped-repre.ind-repbase = YES
                   tt-ped-repre.perc-comis  = 0 /* O % de comiss∆o Ç calculado por relat¢rio */
                   tt-ped-repre.nome-ab-rep = b-tt-ped-venda.no-ab-reppri.              
        END.
        ELSE IF FIRST-OF(ITEM.cod-servico) AND
                ITEM.cod-servico = 0 THEN DO:
                ASSIGN i-nr-pedido           = tt-ped-venda.nr-pedido
                       i-sequencia           = 0.
             END.

        FIND b-tt-ped-item
             WHERE rowid(b-tt-ped-item) = ROWID(tt-ped-item) EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN b-tt-ped-item.nr-pedcli    = string(i-nr-pedido)
               i-sequencia              = i-sequencia + 10
               b-tt-ped-item.nr-sequencia = i-sequencia.

        IF ITEM.cod-servico <> 0 THEN DO:
           ASSIGN b-tt-ped-item.nat-operacao = "800001".
        END.

        IF  l-log THEN DO:
            MESSAGE "escrm012 - Servico "  tt-ped-item.nr-pedcli " " tt-ped-item.it-codigo " " tt-ped-item.nr-sequencia " " b-tt-ped-item.nr-pedcli " " b-tt-ped-item.nr-sequencia SKIP.
        END.
    END.


    FOR EACH tt-ped-venda NO-LOCK:
        IF  l-log THEN DO:
            MESSAGE ">>>>>>>>>>>>>> escrm012 - dentro avail tt-ped-venda " l-erro AVAIL tt-ped-venda-xml " " tt-ped-venda.nr-pedcli SKIP.
        END.
        FIND FIRST tt-ped-item 
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli 
            NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-ped-item THEN DO:
            
            FOR EACH tt-ped-repre NO-LOCK
                WHERE  tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido:
                DELETE tt-ped-repre.
            END.
            IF  l-log THEN DO:
                MESSAGE "Nao achou item " tt-ped-venda.nr-pedido SKIP.
            END.
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido sem itens favor reavaliar o pedido"
                   l-erro           = YES.

            NEXT.
        END.

        ASSIGN c-nat-oper-cabecalho = tt-ped-venda.nat-operacao
               i-cont-nat-igual     = 0.

        FOR EACH tt-ped-item 
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-ped-item.it-codigo:

/*             ASSIGN c-unid-neg = "".                                                                                     */
/*             FIND FIRST unid-neg-item NO-LOCK                                                                            */
/*                 WHERE  unid-neg-item.it-codigo = item.it-codigo NO-ERROR.                                               */
/*             IF  AVAIL  unid-neg-item THEN                                                                               */
/*                 ASSIGN c-unid-neg = unid-neg-item.cod_unid_negoc.                                                       */
/*             ELSE DO:                                                                                                    */
/*                 FIND FIRST unid-neg-fam-com NO-LOCK                                                                     */
/*                     WHERE  unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR.                                       */
/*                 IF  AVAIL  unid-neg-fam-com THEN                                                                        */
/*                     ASSIGN c-unid-neg = unid-neg-fam-com.cod_unid_negoc.                                                */
/*                 ELSE DO:                                                                                                */
/*                     CREATE tt-erro.                                                                                     */
/*                     ASSIGN tt-erro.mensagem = "Unidade de Negocios nao encontrada para o item " + tt-ped-item.it-codigo */
/*                            l-erro           = YES.                                                                      */
/*                                                                                                                         */
/*                     IF  l-log THEN DO:                                                                                  */
/*                         MESSAGE tt-erro.mensagem SKIP.                                                                  */
/*                     END.                                                                                                */
/*                     RETURN "NOK":U.                                                                                     */
/*                 END.                                                                                                    */
/*             END.                                                                                                        */
            FIND FIRST item-uni-estab
                WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
                  AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo 
                NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN
                ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
            ELSE
                ASSIGN tt-ped-item.cod-unid-negoc = ITEM.cod-unid-negoc.
                
                /* conta aplicacao */

            if  item.tipo-contr = 4 and SUBSTR(tt-ped-item.char-2,09,02) = "  " then
                assign substr(tt-ped-item.char-2,09,02) = item.un.
        
            if  item.tipo-contr <> 4 then
                assign substr(tt-ped-item.char-2,09,02) = "  ":U.
        
            FOR FIRST natur-oper
                WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK USE-INDEX natureza:
            END.
        
            if  ((item.tipo-contr = 4 or (item.aliquota-iss > 0 and item.tipo-contr <> 2)) and
                 (item.baixa-estoq and natur-oper.baixa-estoq)) 
               or
                ((item.tipo-contr = 1 or item.tipo-contr = 4) and
                 (natur-oper.terceiros or natur-oper.transf)) 
        
               or
                 (item.tipo-contr = 2 or item.tipo-contr = 3) and
                  natur-oper.terceiros and
                 (not item.baixa-estoq or not natur-oper.baixa-estoq) then do:
        
                 if item.ct-codigo = "":U then do:
                    find first para-fat no-lock no-error.
                    assign tt-ped-item.ct-codigo = para-fat.ct-cuscon.
                 end.   
                 else 
                    assign tt-ped-item.ct-codigo = item.ct-codigo.
        
            end. 
            else 
                 assign tt-ped-item.ct-codigo = "".
         /* Fim Conta Aplicacao */


            FIND FIRST cliente-astec NO-LOCK
                WHERE  cliente-astec.cod-emitente   = tt-ped-venda.cod-emitente
                AND    cliente-astec.cod_unid_negoc = item.cod-unid-negoc NO-ERROR.
            IF  AVAIL  cliente-astec THEN DO:
                IF  cliente-astec.ind-assistencia THEN DO:
                    FIND FIRST ponto-programa NO-LOCK
                        WHERE  ponto-programa.nome-programa = "ES0573":U
                        AND    ponto-programa.ponto         = 3 NO-ERROR.
                    IF  AVAIL  ponto-programa THEN DO:
                        FIND FIRST conteudo-programa NO-LOCK
                            WHERE  conteudo-programa.cod-programa = ponto-programa.cod-programa
                            AND    conteudo-programa.sequencia    = 1 NO-ERROR.
                        IF  AVAIL  conteudo-programa THEN DO:
                            IF  INDEX(tt-ped-venda.observacoes,TRIM(conteudo-programa.conteudo)) = 0  THEN DO:
                                ASSIGN tt-ped-venda.observacoes = TRIM(tt-ped-venda.observacoes) + " " + TRIM(conteudo-programa.conteudo).
                            END.
                        END.
                    END.
                END.

                IF  cliente-astec.ind-suporte THEN DO:
                    FIND FIRST ponto-programa NO-LOCK
                        WHERE  ponto-programa.nome-programa = "ES0573":U
                        AND    ponto-programa.ponto         = 3 NO-ERROR.
                    IF  AVAIL  ponto-programa THEN DO:
                        FIND FIRST conteudo-programa NO-LOCK
                            WHERE  conteudo-programa.cod-programa = ponto-programa.cod-programa
                            AND    conteudo-programa.sequencia    = 2 NO-ERROR.
                        IF  AVAIL  conteudo-programa THEN DO:
                            IF  INDEX(tt-ped-venda.observacoes,TRIM(conteudo-programa.conteudo)) = 0  THEN DO:
                                ASSIGN tt-ped-venda.observacoes = TRIM(tt-ped-venda.observacoes) + " " + TRIM(conteudo-programa.conteudo).
                            END.
                        END.
                    END.
                END.
            END.
            /*
            IF NOT lsuspendeped AND tt-ped-venda.completo THEN DO:
                FOR FIRST int-campanha-item
                    WHERE int-campanha-item.it-codigo = tt-ped-item.it-codigo NO-LOCK,
                    FIRST int-campanha
                    WHERE int-campanha.cod-campanha = int-campanha-item.cod-campanha
                    AND   (int-campanha.cod-gr-cli   = tt-ped-venda.cod-gr-cli
                        OR int-campanha.cod-gr-cli   = 0) NO-LOCK:
                
                    ASSIGN lsuspendeped   = YES
                           c-desc-suspend = c-desc-suspend + CHR(10) + int-campanha.cobs.
                END.
            END.
            */
            FIND FIRST classif-fisc NO-LOCK
                WHERE  classif-fisc.class-fiscal = item.class-fisc NO-ERROR.
            IF  NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Item " + tt-ped-item.it-codigo + " sem classificaá∆o fiscal cadastrada."
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
                RETURN "NOK":U.
            END.
            IF  c-nat-oper-cabecalho = tt-ped-item.nat-operacao THEN
                ASSIGN i-cont-nat-igual = i-cont-nat-igual + 1.
            ASSIGN c-nat-oper = tt-ped-item.nat-operacao.
        END.

        IF  l-log THEN DO:
            MESSAGE "Escrm012 1226 - " tt-ped-venda.nr-pedcli SKIP.
        END.


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
        IF  l-log THEN DO:
            MESSAGE "Escrm012 1302 - " tt-ped-venda.nr-pedcli SKIP.
        END.
        IF  l-abaixo-min THEN
            ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes +  " CONTEM ITENS ABAIXO DO MINIMO. ".

        IF  tt-ped-venda.observacoes <> "" THEN
            ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.observacoes.

/*         IF  tt-ped-venda.cond-espec <> "" THEN                                 */
/*             ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.cond-espec.  */

        /* Estabelecimento = 105 e Unid Negoc = ISEC -> Solicitado por Francine, em 10/02/2011 */
        IF  tt-ped-venda.cod-estabel = "105" AND (i-cd-unid-comerc = 41 OR i-cd-unid-comerc = 42) THEN
            ASSIGN c-desc-suspend = c-desc-suspend + "Favor verificar Transportadora!".

        
        /* Se tiver data ou dias de negociaá∆o, o pedido dever† ser Suspenso */
        FIND FIRST tt-int-ped-venda NO-LOCK
            WHERE  tt-int-ped-venda.cod-estabel = tt-ped-venda.cod-estabel
            AND    tt-int-ped-venda.nr-pedido   = tt-ped-venda.nr-pedido NO-ERROR.
        IF  AVAIL  tt-int-ped-venda THEN DO:
            IF  tt-int-ped-venda.dt-negociacao   <> ? THEN
                ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao)
                       c-desc-suspend           = c-desc-suspend + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao).

            IF  tt-int-ped-venda.dias-negociacao <> 0 THEN
                ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao)
                       c-desc-suspend           = c-desc-suspend + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao).
        END.


        IF  c-desc-suspend <> "" THEN
            ASSIGN tt-ped-venda.cod-priori = 99.

        

        IF l-log THEN DO:
            MESSAGE  "escrm012 ------- desc. suspend : " c-desc-suspend SKIP
                     " tt-ped-venda.cond-espec       : " tt-ped-venda.cond-espec  SKIP
                     " tt-ped-venda.observacoes      : " tt-ped-venda.observacoes SKIP.

        END.

        ASSIGN l-erro = NO.

        RUN pi-executar-bos (INPUT  c-desc-suspend,
                             OUTPUT l-erro).
        IF l-log THEN DO:
            MESSAGE  "escrm012 - apos executar bos" SKIP.

        END.
        RUN pi-destroi-bos.

        IF  l-log THEN DO:
            MESSAGE "Escrm012 Finale - " tt-ped-venda.nr-pedcli SKIP.
        END.


        IF  l-erro THEN DO:
            FOR EACH TT-ERRO:
                ASSIGN tt-erro.mensagem = REPLACE(tt-erro.mensagem,"Pedido:","").
            END.
            ASSIGN c-nr-pedido-retorno = "".
            RETURN "NOK":U.
        END.
    END.
END.  /****** DO TRANSACTION **********/



IF  VALID-HANDLE(h-boes505) THEN
    DELETE PROCEDURE h-boes505.

IF  VALID-HANDLE(h-escrm005) THEN
    DELETE PROCEDURE h-escrm005.


DELETE WIDGET-POOL.
RETURN "OK":U.




/*--- Procedures Internas ---*/
PROCEDURE pi-zerar-temporarias:
    ASSIGN d-vl-liq-abe     = 0
           d-vl-liq-it      = 0
           i-sequencia      = 0
           l-abaixo-min     = NO
           c-desc-suspend   = ""
           l-erro           = NO
           i-cont-nat-igual = 0.

    EMPTY TEMP-TABLE tt-ped-venda-xml.
    EMPTY TEMP-TABLE tt-ped-item-xml.
    EMPTY TEMP-TABLE tt-ped-venda.
    EMPTY TEMP-TABLE tt-ped-item.
    EMPTY TEMP-TABLE tt-ped-ent.
    EMPTY TEMP-TABLE tt-ped-repre.
    EMPTY TEMP-TABLE tt-ped-vendor.
    EMPTY TEMP-TABLE tt-int-ped-venda.
    EMPTY TEMP-TABLE tt-erro.
END PROCEDURE.



PROCEDURE CriaItem:

    DEF VAR i-cod-gr-canais AS INT NO-UNDO.

    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = tt-ped-item-xml.it-codigo NO-ERROR.
    IF  NOT AVAIL ITEM THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Item n∆o encontrado - " + tt-ped-item-xml.it-codigo.
               l-erro           = YES.

        IF  l-log THEN DO:
            MESSAGE tt-erro.mensagem SKIP.
        END.
        RETURN "NOK":U.
    END.

    ASSIGN c-cod-estabel = IF tt-ped-venda-xml.cod-estabel = "101" AND unid-comerc.cd-unid-comerc <> 90 /* ASTEC */ THEN "104" ELSE tt-ped-venda-xml.cod-estabel.

    FIND FIRST ponto-programa NO-LOCK
        WHERE  ponto-programa.nome-programa = "escrm012":U
        AND    ponto-programa.ponto         = 1 NO-ERROR.
    IF  AVAIL  ponto-programa THEN DO:
        FOR EACH  conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND ENTRY(2,conteudo-programa.conteudo,",") = ITEM.it-codigo:
            ASSIGN c-cod-estabel = ENTRY(1,conteudo-programa.conteudo,",").
        END.
    END.

    EMPTY TEMP-TABLE tt-ped-venda-aux.

    CREATE tt-ped-venda-aux.
    BUFFER-COPY tt-ped-venda TO tt-ped-venda-aux.

    FIND FIRST tt-ped-venda
         WHERE tt-ped-venda.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.

    FIND estabelec
         WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-ped-venda THEN DO:

        IF  l-log THEN DO:
             MESSAGE "escrm012 - 1   ->>>>>>>>> criando novo b-tt-ped-venda - codigo estab novo " c-cod-estabel " estab antigo " tt-ped-venda-aux.cod-estabel " nro pedido " tt-ped-venda-aux.nr-pedcli .
        END.

        CREATE b-tt-ped-venda.
        BUFFER-COPY tt-ped-venda-aux EXCEPT nr-pedido nr-pedcli cod-estabel TO b-tt-ped-venda.
        ASSIGN b-tt-ped-venda.nr-pedido               = NEXT-VALUE(seq-nr-pedido)
               b-tt-ped-venda.nr-pedcli               = STRING(b-tt-ped-venda.nr-pedido)
               b-tt-ped-venda.cod-estabel             = estabelec.cod-estabel.
        ASSIGN c-nr-pedido-retorno = c-nr-pedido-retorno + "," + b-tt-ped-venda.nr-pedcli.
               
        ASSIGN l-consumidor-final = NO.
        IF  NOT emitente.contrib-icm THEN
            ASSIGN l-consumidor-final = YES.
        RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                            INPUT  emitente.cod-emitente,
                                            INPUT  "padrao", 
                                            INPUT  "",
                                            INPUT  l-consumidor-final,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).

        IF  NOT l-return THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Natureza de operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.

        FIND FIRST natur-oper NO-LOCK
            WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
        IF  NOT AVAIL natur-oper THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Natureza de Operaá∆o " + emitente.nat-operacao + " inv†lida no cadastro do Cliente " + STRING(emitente.cod-emitente)
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
            RETURN "NOK":U.
        END.
        IF  l-log THEN DO:
             MESSAGE "Natureza de operacao encontrada Para o PEDIDO ------->> " b-tt-ped-venda.cod-estabel " nro pedido " b-tt-ped-venda.nr-pedcli " " c-nat-oper " c-nr-pedido-retorno " c-nr-pedido-retorno.
        END.
        ASSIGN b-tt-ped-venda.nat-operacao = c-nat-oper.
        CREATE tt-int-ped-venda.
        ASSIGN tt-int-ped-venda.cod-estabel             = b-tt-ped-venda.cod-estabel
               tt-int-ped-venda.nr-pedido               = b-tt-ped-venda.nr-pedido
               tt-int-ped-venda.dt-negociacao           = tt-ped-venda-xml.dt-negociacao
               tt-int-ped-venda.dias-negociacao         = tt-ped-venda-xml.dias-negociacao
               tt-int-ped-venda.vl-guid                 = tt-ped-venda-xml.guid-crm
               OVERLAY(tt-int-ped-venda.char-1,12,3)    = STRING(tt-ped-venda-xml.cod-categoria)
               OVERLAY(tt-int-ped-venda.char-1,16,3)    = STRING(i-cd-unid-comerc)
               OVERLAY(tt-int-ped-venda.char-1,1,8)     = STRING(TIME,"HH:MM:SS")
               OVERLAY(tt-int-ped-venda.char-1,53,12)   = STRING(tt-ped-venda-xml.cond-especial).

        ASSIGN c-transp         = "":U
               c-sigla-transp   = "":U.

        /* Retorna Transportadora : Incidente - 26357 */
        RUN esp/crm/escrm107.p (INPUT b-tt-ped-venda.cod-estabel,
                                INPUT STRING(b-tt-ped-venda.cod-emitente),
                                INPUT b-tt-ped-venda.cidade,
                                INPUT b-tt-ped-venda.estado,
                                INPUT INT(SUBSTRING(tt-int-ped-venda.char-1,16,3)),
                                INPUT b-tt-ped-venda.cep,
                                OUTPUT c-cod-transp,
                                OUTPUT c-sigla-transp). 

        IF c-cod-transp = ? THEN DO:
            
             CREATE tt-erro.
             ASSIGN tt-erro.mensagem = "N∆o encontrada transportadora para relacionamento UF x Cidade x Cliente."
                    l-erro           = YES.
            
             ASSIGN b-tt-ped-venda.nome-transp = "".

        END.
        ELSE DO:
        
            FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                ASSIGN c-transp = transporte.nome-abrev.
            END.
    
            ASSIGN b-tt-ped-venda.nome-transp              = c-transp /* transporte.nome-abrev Incidente - 26357 */
                   OVERLAY(tt-int-ped-venda.char-1,20,5) = c-sigla-transp.  
        END.


        /* Criaá∆o do ped-repre */
        ASSIGN c-cgc-rep = repres.cgc.

        FIND FIRST tt-ped-repre NO-LOCK
            WHERE  tt-ped-repre.nr-pedido   = b-tt-ped-venda.nr-pedido
            AND    tt-ped-repre.nome-ab-rep = repres.nome-abrev NO-ERROR.
        IF  NOT AVAIL tt-ped-repre THEN DO:
            CREATE tt-ped-repre.
            ASSIGN tt-ped-repre.nr-pedido   = b-tt-ped-venda.nr-pedido
                   tt-ped-repre.ind-repbase = YES
                   tt-ped-repre.perc-comis  = 0 /* O % de comiss∆o Ç calculado por relat¢rio */
                   tt-ped-repre.nome-ab-rep = repres.nome-abrev.
        END.


    END.
    FIND FIRST tt-ped-venda
         WHERE tt-ped-venda.cod-estabel = c-cod-estabel EXCLUSIVE-LOCK NO-ERROR.

    IF  l-log THEN DO:
        MESSAGE " apos criar o pedido e antes de criar o item " tt-ped-venda.cod-estabel tt-ped-venda.nr-pedcli " " tt-ped-venda.nat-operacao.
    END.

    ASSIGN l-consumidor-final = NO.
    IF  NOT emitente.contrib-icm THEN
        ASSIGN l-consumidor-final = YES.
    RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                        INPUT  emitente.cod-emitente,
                                        INPUT  "padrao", 
                                        INPUT  item.it-codigo,
                                        INPUT  l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).
    IF  l-return = NO THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Natureza de Operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo
               l-erro           = YES.

        IF  l-log THEN DO:
            MESSAGE tt-erro.mensagem SKIP.
        END.
        RETURN "NOK":U.
    END.
    IF  l-log THEN DO:
         MESSAGE "Natureza de operacao encontrada Para o item PEDIDO ------->> " tt-ped-venda.cod-estabel " nro pedido " tt-ped-venda.nr-pedcli " " item.it-codigo " " c-nat-oper.
    END.
    
    FIND FIRST int-familia NO-LOCK
        WHERE  int-familia.fm-codigo = item.fm-codigo NO-ERROR.
    IF  AVAIL  int-familia    AND
        int-familia.oem = YES THEN DO:
        ASSIGN l-mantem-nat = NO.
    END.

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.

    IF  NOT AVAIL natur-oper THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Natureza de operaá∆o " + c-nat-oper + " inv†lido ou n∆o cadastrada, Cliente: " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo
               l-erro           = YES.

        IF  l-log THEN DO:
            MESSAGE tt-erro.mensagem SKIP.
        END.
        UNDO, LEAVE.
    END.

    IF  tt-ped-item-xml.de-qtd-aux = 0 THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Item com quantidade zerada  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
               l-erro           = YES.

        IF  l-log THEN DO:
            MESSAGE tt-erro.mensagem SKIP.
        END.
        UNDO, LEAVE.
    END.


    IF  l-log THEN DO:
        MESSAGE "**** Criaá∆o do Item ****" SKIP
                "tt-ped-venda.nr-pedcli.: " tt-ped-venda.nr-pedcli SKIP
                "tt-ped-venda.nome-abrev.: " tt-ped-venda.nome-abrev SKIP
                "item.it-codigo.: " item.it-codigo.
    END.

    FIND LAST tt-ped-item
         WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli
         NO-LOCK NO-ERROR.
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

    /* Atribuir Sequància do Item */
    ASSIGN i-sequencia              = i-sequencia + 10
           tt-ped-item.nr-sequencia = i-sequencia.


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
        ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura.
    END.
    ELSE
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

    /* Fim Verifica data de entrega do item */
    

    ASSIGN tt-ped-item.qt-pedida               = tt-ped-item-xml.de-qtd-aux
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
           tt-ped-item.vl-pretab               = tt-ped-item-xml.vl-pretab
           tt-ped-item.vl-preori               = tt-ped-item-xml.vl-preori
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.observacao              = tt-ped-item-xml.observacao
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF item.baixa-estoq = NO OR tt-ped-venda.ind-fat-par THEN 2 ELSE 1.

        if  can-find(first iss-cidad-item
                     where iss-cidad-item.cod-pais   = tt-ped-venda.pais
                     and   iss-cidad-item.cod-estado = tt-ped-venda.estado
                     and   iss-cidad-item.nom-cidade = tt-ped-venda.cidade
                     and   iss-cidad-item.cod-item   = tt-ped-item.it-codigo)  then       
                     
             for first iss-cidad-item
                 where iss-cidad-item.cod-pais   = tt-ped-venda.pais    
                 and   iss-cidad-item.cod-estado = tt-ped-venda.estado  
                 and   iss-cidad-item.nom-cidade = tt-ped-venda.cidade  
                 and   iss-cidad-item.cod-item   = tt-ped-item.it-codigo no-lock:
                 
                 assign overlay(tt-ped-item.char-2,56,5) = string(iss-cidad-item.cdn-servico).
                 
             end.
        else do:  /* pelo item cd0903 */
           
               for first item
                   where item.it-codigo = tt-ped-item.it-codigo no-lock:  end.
                    
               assign overlay(tt-ped-item.char-2,56,5) = string(item.cod-servico).
        
        end.

    CREATE tt-int-ped-item.
    ASSIGN tt-int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
           tt-int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
           tt-int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
           tt-int-ped-item.it-codigo     = tt-ped-item.it-codigo
           tt-int-ped-item.vl-guid       = tt-ped-item-xml.guid-crm
           tt-int-ped-item.it-codigo-pai = IF AVAIL prod-composto THEN prod-composto.it-codigo-pai ELSE "".

    IF  l-log THEN DO:
        MESSAGE "**** Criaá∆o da Tabela de Extens∆o para o Item ****" SKIP
                "tt-int-ped-item.nome-abrev.: " tt-int-ped-item.nome-abrev SKIP
                "tt-int-ped-item.nr-pedcli.: " tt-int-ped-item.nr-pedcli SKIP
                "tt-int-ped-item.nr-sequencia.: " tt-int-ped-item.nr-sequencia SKIP
                "tt-int-ped-item.it-codigo.: " tt-int-ped-item.it-codigo SKIP
                "tt-int-ped-item.vl-guid.: " tt-int-ped-item.vl-guid SKIP
                "QUANDIDADE DO ITEM DO PEDIDO " tt-ped-item.qt-pedida " tt-ped-item-xml.de-qtd-aux " tt-ped-item-xml.de-qtd-aux SKIP.
    END.

    if  not valid-handle(h-bodi154sdf) or
        h-bodi154sdf:type      <> "PROCEDURE":U or
        h-bodi154sdf:file-name <> "dibo/bodi154sdf.p":U then
        run dibo/bodi154sdf.p persistent set h-bodi154sdf.

    if  avail emitente and
        avail natur-oper then do:    
        run setICMRetido in h-bodi154sdf (input  tt-ped-item.nome-abrev,
                                          input  tt-ped-item.cod-entrega,
                                          input  tt-ped-item.it-codigo,
                                          input  tt-ped-venda.cod-estabel,
                                          input  emitente.insc-subs-trib,
                                          input  natur-oper.subs-trib,
                                          output tt-ped-item.ind-icm-ret).   
    end.    
    DELETE PROCEDURE h-bodi154sdf.
    /* Fim Busca Indicador ICMS Ret */
    IF  l-log THEN DO:
        MESSAGE "**** Calculo substituiá∆o tributaria ****" SKIP
                "tt-ped-item.nome-abrev "   tt-ped-item.nome-abrev   SKIP   
                "tt-ped-item.cod-entrega "  tt-ped-item.cod-entrega  SKIP  
                "tt-ped-item.it-codigo "    tt-ped-item.it-codigo    SKIP    
                "tt-ped-venda.cod-estabel " tt-ped-venda.cod-estabel SKIP 
                "emitente.insc-subs-trib "  emitente.insc-subs-trib  SKIP  
                "natur-oper.subs-trib "     natur-oper.subs-trib     SKIP
                "tt-ped-item.ind-icm-ret "  tt-ped-item.ind-icm-ret  SKIP.
    END.

    IF  tt-ped-item-xml.baixo-min THEN
        ASSIGN l-abaixo-min = YES.


    /* Definiá∆o do Valor Unit†rio com Desconto ZFM */
    IF  natur-oper.per-des-icm > 0 THEN
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)) WHEN AVAIL natur-oper.
    ELSE
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.

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


    CREATE tt-ped-ent.
    ASSIGN tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
           tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
           tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
           tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
           tt-ped-ent.dt-entrega   = tt-ped-item.dt-entrega
           tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
           tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
           tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
           tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
           tt-ped-ent.user-impl    = tt-ped-item.user-impl
           tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
           tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
           tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.

    /* Atribuir Valores Totais do Pedido */
    ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
           d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
END PROCEDURE.



PROCEDURE pi-executar-bos:
    DEFINE INPUT  PARAMETER p-desc-suspend AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro         AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-ped-venda-aux.

    CREATE tt-ped-venda-aux.
    BUFFER-COPY tt-ped-venda TO tt-ped-venda-aux.

   IF  l-log THEN DO:
            MESSAGE "INICIO PI-EXECUTAR-BOX  " tt-ped-venda-aux.nr-pedido " Natureza de Operacao " tt-ped-venda-aux.nat-operacao SKIP.
        END.

    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:

        IF  NOT VALID-HANDLE(h-bodi159) THEN
            RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

        RUN openQueryStatic IN h-bodi159(INPUT "Main":U).
        RUN setRecord       IN h-bodi159(INPUT TABLE tt-ped-venda-aux).
        RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
        RUN emptyRowErrors  IN h-bodi159.
        RUN createMPLog     IN h-bodi159(INPUT NO).
        RUN createRecord    IN h-bodi159.
        RUN getRowErrors    IN h-bodi159(OUTPUT TABLE RowErrors).

        FOR EACH  RowErrors NO-LOCK
            WHERE RowErrors.ErrorType   <> "INTERNAL":U
            AND   RowErrors.ErrorSubType = "Error":U:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = RowErrors.errorDescription  + " Cliente: " + tt-ped-venda-aux.nome-abrev
                   l-erro           = YES.

            IF  l-log THEN DO:
                MESSAGE tt-erro.mensagem SKIP.
            END.
        END.

        IF  l-erro  THEN
            UNDO bloco, LEAVE bloco.

        
        IF  NOT VALID-HANDLE(h-bodi157) THEN
            RUN dibo/bodi157.p PERSISTENT SET h-bodi157.
        RUN openQueryStatic IN h-bodi157(INPUT "Default":U).

        
        IF  l-log THEN DO:
            MESSAGE "Antes de criar tt-ped-repre  " tt-ped-venda-aux.nr-pedido " Natureza de Operacao " tt-ped-venda-aux.nat-operacao SKIP.
        END.

        FOR EACH tt-ped-repre
            WHERE tt-ped-repre.nr-pedido = tt-ped-venda-aux.nr-pedido:


            IF  l-log THEN DO:
                MESSAGE "Dentro do for each tt-ped-repre  " tt-ped-venda-aux.nr-pedido SKIP.
            END.

            RUN emptyRowErrors  IN h-bodi157.
            RUN setRecord       IN h-bodi157(INPUT TABLE tt-ped-repre).
            RUN createMPLog     IN h-bodi157(INPUT NO).
            RUN createRecord    IN h-bodi157.
            RUN getRowErrors    IN h-bodi157(OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = RowErrors.errorDescription + " Repres: " + tt-ped-repre.nome-ab-rep
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
            END.
            DELETE tt-ped-repre.
        END.

        IF  l-erro THEN
            UNDO bloco, LEAVE bloco.



        IF  NOT VALID-HANDLE(h-bodi154) THEN
            RUN dibo/bodi154.p PERSISTENT SET h-bodi154.
        RUN openQueryStatic IN h-bodi154(INPUT "Default":U).

        FOR EACH  tt-ped-item NO-LOCK
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda-aux.nr-pedcli:
            IF  l-log THEN DO:
                MESSAGE "CHAMANDO BO DO ITEM DO PEDIDO " tt-ped-item.nr-pedcli  tt-ped-item.it-codigo " SEQUENCIA " tt-ped-item.nr-sequencia  tt-ped-item.qt-pedida " Natureza " tt-ped-item.nat-operacao " " tt-ped-venda-aux.nat-operacao SKIP.
            END.
            RUN emptyRowErrors  IN h-bodi154.
            RUN setRecord       IN h-bodi154(INPUT TABLE tt-ped-item).
            RUN createMPLog     IN h-bodi154(INPUT NO).
            RUN createRecord    IN h-bodi154.
            RUN getRowErrors    IN h-bodi154(OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = RowErrors.errorDescription + " Item: " + tt-ped-item.it-codigo
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
            END.

            DELETE tt-ped-item.
        END.

        IF  l-erro  THEN
            UNDO bloco, LEAVE bloco.


        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli  = tt-ped-venda-aux.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda-aux.nome-abrev NO-ERROR.

        IF  l-log THEN DO:
            MESSAGE "Pedido Gerado? " AVAIL ped-venda SKIP
                    "Nr Pedido " tt-ped-venda-aux.nr-pedcli SKIP
                    "Cliente   " tt-ped-venda-aux.nome-abrev.
        END.

        
        IF  NOT VALID-HANDLE(h-bodi159cal) THEN
            RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.

        RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                           OUTPUT TABLE rowErrors).

        FOR EACH  rowErrors NO-LOCK
            WHERE rowErrors.errornumber <> 8259:  /* credito n∆o aprovado */
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli.

            IF  rowErrors.errorSubType <> "Warning":U THEN
                ASSIGN l-erro = YES.

            IF  l-log THEN DO:
                MESSAGE rowErrors.errorNumber " - " rowErrors.errorSubtype " - " tt-erro.mensagem SKIP.
            END.
        END.

        IF  l-erro THEN
            UNDO bloco, LEAVE bloco.

        

        IF  p-desc-suspend <> "" or
            ped-venda.observacoes <> "" THEN DO:
            IF l-log THEN DO:
                MESSAGE "escrm012 - Vai Suspender : " c-desc-suspend SKIP.

            END.

            IF  NOT VALID-HANDLE(h-bodi159sus) THEN
                RUN dibo/bodi159sus.p PERSISTENT SET h-bodi159sus.

            EMPTY TEMP-TABLE RowErrors.

            RUN ValidateSuspension IN h-bodi159sus (INPUT  ROWID(ped-venda),
                                                    OUTPUT TABLE RowErrors).
            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
            END.

            IF  l-erro THEN
                UNDO bloco, LEAVE bloco.


            RUN UpdateSuspension IN h-bodi159sus(INPUT ROWID(ped-venda),
                                                 INPUT 2,
                                                 INPUT p-desc-suspend).
            IF  RETURN-VALUE <> "NO":U AND
                RETURN-VALUE <> "OK":U THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Problema de integraá∆o entre B2B e EMS(CONFIRMA-SUSPENSAO)" + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
                       l-erro           = YES.

                IF  l-log THEN DO:
                    MESSAGE tt-erro.mensagem SKIP.
                END.
                UNDO bloco, LEAVE bloco.
            END.
            IF l-log THEN DO:
                MESSAGE "escrm012 - Apos Suspender : " c-desc-suspend SKIP.

            END.

        END.


        /**** Efetiva as Tabelas Espec°ficas ****/
        /* Pedido */
        FIND FIRST tt-int-ped-venda NO-LOCK
            WHERE  tt-int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        IF  AVAIL  tt-int-ped-venda THEN DO:
            IF  l-log THEN DO:
                MESSAGE "Efetivando a tabela de extens∆o (int-ped-venda)>>*****>>>:" SKIP
                        "ped-venda.nome-abrev.: " ped-venda.nome-abrev SKIP
                        "ped-venda.nr-pedcli.: " ped-venda.nr-pedcli SKIP.
            END.

            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido NO-ERROR.
            IF  NOT AVAIL int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido.
            END.

            ASSIGN int-ped-venda.cod-estabel          = tt-int-ped-venda.cod-estabel
                   int-ped-venda.dt-negociacao        = tt-int-ped-venda.dt-negociacao
                   int-ped-venda.dias-negociacao      = tt-int-ped-venda.dias-negociacao
                   int-ped-venda.vl-guid              = tt-int-ped-venda.vl-guid
                   int-ped-venda.char-1               = tt-int-ped-venda.char-1.

            IF  l-log THEN DO:
                MESSAGE "int-ped-venda.cod-estabel.: " int-ped-venda.cod-estabel SKIP
                        "int-ped-venda.nr-pedido.: " int-ped-venda.nr-pedido SKIP
                        "int-ped-venda.dt-negociacao.: " int-ped-venda.dt-negociacao SKIP
                        "int-ped-venda.dias-negociacao.: " int-ped-venda.dias-negociacao SKIP
                        "int-ped-venda.vl-guid.: " int-ped-venda.vl-guid SKIP.
            END.
            RELEASE int-ped-venda.
        END.

        /* Itens Pedido */
        ASSIGN de-valor-st = 0.
        FOR EACH  ped-item NO-LOCK
            WHERE ped-item.nome-abrev = ped-venda.nome-abrev
            AND   ped-item.nr-pedcli  = ped-venda.nr-pedcli:

            /* C†lculo da Substituiá∆o Tribut†ria */
            FIND FIRST natur-oper NO-LOCK
                WHERE  natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
            IF  l-log THEN DO:
                MESSAGE "**** Substituiá∆o Tribut†ria ****" SKIP
                        "Item: " ped-item.it-codigo SKIP
                        "Natureza de Operaá∆o: " ped-item.nat-operacao SKIP
                        "Calcula Substituiá∆o Tribut†ria? " IF AVAIL natur-oper THEN natur-oper.subs-trib ELSE NO SKIP.
            END.
            IF  AVAIL  natur-oper AND natur-oper.subs-trib THEN DO:
                ASSIGN de-valor-st = de-valor-st + ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).

                IF  l-log THEN DO:
                    MESSAGE "Valor Subs Trib: " de-valor-st SKIP.
                END.
            END.


            /* Efetivaá∆o da Tabela de Extens∆o */
            IF  l-log THEN DO:
                MESSAGE "Efetivando a tabela de extens∆o (int-ped-item):" SKIP
                        "ped-item.nome-abrev.: " ped-item.nome-abrev SKIP
                        "ped-item.nr-pedcli.: " ped-item.nr-pedcli SKIP
                        "ped-item.nr-sequencia.: " ped-item.nr-sequencia SKIP
                        "ped-item.it-codigo.: " ped-item.it-codigo SKIP
                        "QUANDIDADE DO ITEM DO PEDIDO "  ped-item.qt-pedida skip.
            END.

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

                IF  l-log THEN DO:
                    MESSAGE "int-ped-item.nome-abrev.: " int-ped-item.nome-abrev SKIP
                            "int-ped-item.nr-pedcli.: " int-ped-item.nr-pedcli SKIP
                            "int-ped-item.nr-sequencia.: " int-ped-item.nr-sequencia SKIP
                            "int-ped-item.it-codigo.: " int-ped-item.it-codigo SKIP
                            "int-ped-item.cod-refer.: " int-ped-item.cod-refer SKIP
                            "int-ped-item.vl-guid.: " int-ped-item.vl-guid SKIP
                            "int-ped-item.it-codigo-pai " int-ped-item.it-codigo-pai SKIP.
                END.
                FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
                RELEASE int-ped-item.
            END.
        END.
        IF  l-erro  = NO THEN DO:
            /* Retorna o n£mero do pedido gerado para o Portal B2B */
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Pedido: " + c-nr-pedido-retorno.
        END.

        /* Retorna o Valor da Substituiá∆o Tribut†ria para o Portal B2B */
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "@@SUB. TRIBUTARIA: R$ " + STRING(de-valor-st) + "@@".
    END.

END PROCEDURE.



PROCEDURE pi-destroi-bos:
    IF  VALID-HANDLE(h-bodi159) AND h-bodi159:FILE-NAME = "dibo/bodi159.p" AND h-bodi159:TYPE = "procedure" THEN
        RUN destroyBO in h-bodi159.

    IF  VALID-HANDLE(h-bodi159) THEN DO:
        DELETE PROCEDURE h-bodi159.
        ASSIGN h-bodi159 = ?.
    END.

    IF  VALID-HANDLE(h-bodi157) THEN DO:
        DELETE PROCEDURE h-bodi157.
        ASSIGN h-bodi157 = ?.
    END.

    IF  VALID-HANDLE(h-bodi154) AND h-bodi154:FILE-NAME = "dibo/bodi154.p" AND h-bodi154:TYPE = "procedure" THEN
        RUN destroyBO IN h-bodi154.

    IF  VALID-HANDLE(h-bodi154) THEN DO:
        DELETE PROCEDURE h-bodi154.
        ASSIGN h-bodi154 = ?.
    END.

    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:FILE-NAME = "dibo/bodi159com.p" AND h-bodi159cal:TYPE = "procedure" THEN
        RUN destroyBO in h-bodi159cal.

    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.

    IF  VALID-HANDLE(h-bodi159sus) AND h-bodi159sus:FILE-NAME = "dibo/bodi159sus.p" AND h-bodi159sus:TYPE = "procedure" THEN
        RUN destroyBO in h-bodi159sus.

    IF  VALID-HANDLE(h-bodi159sus) THEN DO:
        DELETE PROCEDURE h-bodi159sus.
        ASSIGN h-bodi159sus = ?.
    END.
END PROCEDURE.
