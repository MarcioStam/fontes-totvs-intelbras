/******************************************************************************
**  Programa.: ESCRM001RP.P
**  Objetivo.: Execu‡Æo do processamento de integra‡Æo do Datasul EMS 2 com o
**             Microsoft CRM Dynamics.
**  Autor....: Gustavo Eduardo Tamanini - Exponencial TI - 27.07.2010
**             Fabiano Sakae Ribeiro    - Exponencial TI - 02.08.2010
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCRM001RP 2.04.00.000}


&GLOBAL-DEFINE programa ESCRM001

{include/i-rpvar.i}

{utp/ut-glob.i}

{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
    
DEFINE VARIABLE l-ponto-encerramento AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont               AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id IS PRIMARY UNIQUE
        ordem.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-trace NO-UNDO
    FIELD tabela    AS CHARACTER FORMAT "x(25)":U        COLUMN-LABEL "Tabela":U
    FIELD acao      AS CHARACTER FORMAT "x(10)":U        COLUMN-LABEL "A‡Æo":U
    FIELD hora-ini  AS CHARACTER FORMAT "x(09)":U        COLUMN-LABEL "In¡cio":U
    FIELD hora-fim  AS CHARACTER FORMAT "x(09)":U        COLUMN-LABEL "Final":U
    FIELD registros AS INTEGER   FORMAT "->>>,>>>,>>9":U COLUMN-LABEL "Qtd Registros":U.
    
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD tabela   AS CHARACTER FORMAT "x(20)"  LABEL "Tabela":U
    FIELD mensagem AS CHARACTER FORMAT "x(220)" LABEL "Mensagem":U VIEW-AS EDITOR SIZE 110 BY 2.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.

DEFINE VARIABLE c-destino               AS CHARACTER FORMAT "x(15)":U   NO-UNDO.
DEFINE VARIABLE cFromCRM                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFromERP                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iContaLinhasTrace       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContaLinhasTracePai    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContaLinhasTraceFilho  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContalinhasTraceOcor   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContalinhasTraceDuplic AS INTEGER     NO-UNDO.
DEFINE VARIABLE cEntidade               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iHoraInicioProcEMS      AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-escrm001api           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-escrm001api5          AS HANDLE      NO-UNDO.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-titulo-relat = "Integra‡Æo com EMS com Microsoft CRM Dynamics":U.

ASSIGN c-empresa      = param-global.grupo
       c-programa     = "{&programa}":U
       c-sistema      = "ESP":U
       c-versao       = "2.04":U
       c-revisao      = "000":U
       c-destino      = {varinc/var00002.i 04 tt-param.destino}.

ASSIGN cFromCRM = "fromCRM":U
       cFromERP = "fromERP":U.


{include/i-rpout.i}
{include/i-rpcab.i}

DO ON STOP UNDO, LEAVE:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    ASSIGN iHoraInicioProcEMS = TIME.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CANAL-VENDA
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-canal-venda THEN DO:
      
        RUN piCarregaBos.
                  
        ASSIGN cEntidade = "new_canal_venda":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaCanalVenda IN h-escrm001api (INPUT  cEntidade,
                                                  OUTPUT iContaLinhasTrace,
                                                  OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        
        

    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CONDICAO PAGAMENTO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-cond-pagto THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_condicao_pagamento":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaCondPagto IN h-escrm001api (INPUT  cEntidade,
                                                 OUTPUT iContaLinhasTrace,
                                                 OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA GRUPO CLIENTE
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-grp-cli THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_grupo_cliente":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaGrupoCliente IN h-escrm001api (INPUT  cEntidade,
                                                    OUTPUT iContaLinhasTrace,
                                                    OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA PORTADOR
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-portador THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_portador":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaPortador IN h-escrm001api (INPUT  cEntidade,
                                                OUTPUT iContaLinhasTrace,
                                                OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA RECEITA PADRAO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-receita-padrao THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_receita_padrao":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaReceitaPadrao IN h-escrm001api (INPUT  cEntidade,
                                                     OUTPUT iContaLinhasTrace,
                                                     OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA REPRESENTANTE
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-representante THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_representante":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaRepresentante IN h-escrm001api (INPUT  cEntidade,
                                                     OUTPUT iContaLinhasTrace,
                                                     OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA TRANSPORTE            
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-transportadora THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_transportadora":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaTransportadora IN h-escrm001api (INPUT  cEntidade,
                                                      OUTPUT iContaLinhasTrace,
                                                      OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA FAMÖLIA MATERIAL
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-familia-estoq THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_familia_material":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaFamiliaMaterial IN h-escrm001api (INPUT  cEntidade,
                                                       OUTPUT iContaLinhasTrace,
                                                       OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA FAMÖLIA COMERCIAL
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-familia-comercial THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_familiacomercial":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaFamiliaComercial IN h-escrm001api (INPUT  cEntidade,
                                                        OUTPUT iContaLinhasTrace,
                                                        OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA GRUPO ESTOQUE
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-grupo-estoque THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_grupo_estoque":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaGrupoEstoque IN h-escrm001api (INPUT  cEntidade,
                                                    OUTPUT iContaLinhasTrace,
                                                    OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA PRODUTO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-produto THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "product":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaProduto IN h-escrm001api (INPUT  cEntidade,
                                               OUTPUT iContaLinhasTrace,
                                               OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA ESTRUTURA PRODUTO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-estrut-prod THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_estrutura_produto":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaEstruturaProduto IN h-escrm001api (INPUT  cEntidade,
                                                        OUTPUT iContaLinhasTrace,
                                                        OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA PRE€O
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-tb-preco THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_tabela_preco":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaTabelaPreco IN h-escrm001api (INPUT  cEntidade,
                                                   OUTPUT iContaLinhasTrace,
                                                   OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).

        ASSIGN cEntidade = "new_item_tabela":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaPrecoItem IN h-escrm001api (INPUT  cEntidade,
                                                 OUTPUT iContaLinhasTrace,
                                                 OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA ROTA
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-rota THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_rota":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaRota IN h-escrm001api (INPUT  cEntidade,
                                            OUTPUT iContaLinhasTrace,
                                            OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA ESTABELECIMENTO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-estabelec THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_estabelecimento":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaEstabelecimento IN h-escrm001api (INPUT  cEntidade,
                                                       OUTPUT iContaLinhasTrace,
                                                       OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA FINANCIAMENTO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-tb-finan THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_tabela_financiamento":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaTabelaFinancimento IN h-escrm001api (INPUT  cEntidade,
                                                          OUTPUT iContaLinhasTrace,
                                                          OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).

        ASSIGN cEntidade = "new_indice":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaIndiceTabelaFinancimento IN h-escrm001api (INPUT  cEntidade,
                                                                OUTPUT iContaLinhasTrace,
                                                                OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA NATUREZA DE OPERA€ÇO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-nat-oper THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_natureza_operacao":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaNaturOper IN h-escrm001api (INPUT  cEntidade,
                                                 OUTPUT iContaLinhasTrace,
                                                 OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA MENSAGEM
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-mensagem THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_mensagem":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaMensagem IN h-escrm001api (INPUT  cEntidade,
                                                OUTPUT iContaLinhasTrace,
                                                OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CLIENTE
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-emitente THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "account":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaCliente IN h-escrm001api (INPUT  cEntidade,
                                               OUTPUT iContaLinhasTrace,
                                               OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CONTATO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-contato THEN DO:
        PUT UNFORMATTED "Op‡Æo ~"Contato~" foi desativada!":U SKIP.
/*         RUN piCarregaBos.                                                 */
/*                                                                           */
/*         ASSIGN cEntidade = "contact":U.                                   */
/*                                                                           */
/*         RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).     */
/*         RUN piCarregaContato IN  h-escrm001api (INPUT  cEntidade,         */
/*                                                 OUTPUT iContaLinhasTrace, */
/*                                                 OUTPUT TABLE RowErrors).  */
/*         RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).     */
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA LOCAL ENTREGA
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-local-entrega THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "customeraddress":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaLocalEntrega IN  h-escrm001api (INPUT  cEntidade,
                                                     OUTPUT iContaLinhasTrace,
                                                     OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA RELACIONAMENTO CLIENTE
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-relac-cliente THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_relacionamento":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaRelacionamentoCliente IN h-escrm001api (INPUT  cEntidade,
                                                             OUTPUT iContaLinhasTrace,
                                                             OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA PEDIDO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-pedido OR tt-param.automatico THEN DO:
        RUN piCarregaBos.

        RUN piTrace("salesorder":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piTrace("salesorderdetail":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        
        empty temp-table tt-param-mov.
        create tt-param-mov.
        assign tt-param-mov.prog-orig       = "escrm001rp"
               tt-param-mov.action          = "W"   
               tt-param-mov.tabela-pai      = "salesorder"   
               tt-param-mov.rw-tabela-pai   = ?
               tt-param-mov.tabela-filho    = "salesorderdetail"
               tt-param-mov.rw-tabela-filho = ?
               tt-param-mov.dt-ini-pedido   = tt-param.dt-ini-pedido
               tt-param-mov.dt-fim-pedido   = tt-param.dt-fim-pedido
               tt-param-mov.dt-ini-nota     = tt-param.dt-ini-nota
               tt-param-mov.dt-fim-nota     = tt-param.dt-fim-nota
               tt-param-mov.automatico      = tt-param.automatico.

        RUN piCarregaPedido IN h-escrm001api (INPUT-OUTPUT TABLE tt-param-mov ,
                                              INPUT  TABLE tt-raw-transfer, 
                                              OUTPUT TABLE RowErrors).

        FIND FIRST tt-param-mov NO-ERROR.
        
        ASSIGN iContaLinhasTrace = tt-param-mov.iContaLinhasTraceFilho.
        RUN piTrace(tt-param-mov.tabela-filho, cFromERP, STRING(TIME, "hh:mm:ss":U)).

        ASSIGN iContaLinhasTrace = tt-param-mov.iContaLinhasTracePai.
        RUN piTrace(tt-param-mov.tabela-pai, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA NOTA FISCAL
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-nf OR tt-param.automatico THEN DO:
        RUN piCarregaBos.

        RUN piTrace("invoice":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piTrace("invoicedetail":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
            

        empty temp-table tt-param-mov.
        create tt-param-mov.
        assign tt-param-mov.dt-ini-pedido   = tt-param.dt-ini-pedido
               tt-param-mov.dt-fim-pedido   = tt-param.dt-fim-pedido
               tt-param-mov.dt-ini-nota     = tt-param.dt-ini-nota
               tt-param-mov.dt-fim-nota     = tt-param.dt-fim-nota
               tt-param-mov.automatico      = tt-param.automatico.

        RUN piCarregaNotaFiscal IN h-escrm001api (INPUT TABLE tt-param-mov, 
                                                  INPUT  "invoice":U,
                                                  INPUT  "invoicedetail":U,
                                                  OUTPUT iContaLinhasTracePai,
                                                  OUTPUT iContaLinhasTraceFilho,
                                                  OUTPUT iContalinhasTraceOcor,
                                                  OUTPUT iContalinhasTraceDuplic,
                                                  OUTPUT TABLE RowErrors).

        ASSIGN iContaLinhasTrace = iContaLinhasTracePai.
        RUN piTrace("invoice":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).

        ASSIGN iContaLinhasTrace = iContaLinhasTraceFilho.
        RUN piTrace("invoicedetail":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        
        ASSIGN iContaLinhasTrace = iContalinhasTraceOcor.
        RUN piTrace("new_nota_ocrrncia":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).

        ASSIGN iContaLinhasTrace = iContalinhasTraceDuplic.
        RUN piTrace("new_duplicata":U, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA TÖTULO
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-titulo THEN DO:
        IF VALID-HANDLE(h-escrm001api5) THEN
            DELETE OBJECT h-escrm001api5.

        RUN esp/crm/escrm001api5.p PERSISTENT SET h-escrm001api5.
 
        ASSIGN cEntidade = "new_titulo":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaTitulo IN h-escrm001api5 (INPUT  cEntidade,
                                              OUTPUT iContaLinhasTrace,
                                              OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    
    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CEP
    **------------------------------------------------------------------------------------------------------------------------------*/
    IF tt-param.l-cep THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_cep":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaCep IN h-escrm001api (INPUT  cEntidade,
                                           OUTPUT iContaLinhasTrace,
                                           OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

     /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CIDADE
    **------------------------------------------------------------------------------------------------------------------------------*/

    IF tt-param.l-cidade THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_cidade":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaCidade IN h-escrm001api (INPUT  cEntidade,
                                              OUTPUT iContaLinhasTrace,
                                              OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

     /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA UNIDADE FEDERA€ÇO
    **------------------------------------------------------------------------------------------------------------------------------*/

    IF tt-param.l-unid-feder THEN DO:
        RUN piCarregaBos.

        ASSIGN cEntidade = "new_uf":U.

        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
        RUN piCarregaUnidFeder IN h-escrm001api (INPUT  cEntidade,
                                                 OUTPUT iContaLinhasTrace,
                                                 OUTPUT TABLE RowErrors).
        RUN piTrace(cEntidade, cFromERP, STRING(TIME, "hh:mm:ss":U)).
    END.

    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA EMITENTE (fromCRM)
    **------------------------------------------------------------------------------------------------------------------------------*/
    REPEAT TRANSACTION:
        
        RUN ExecucaoCRMxEMS.
        
        FIND FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "escrm001":U
              AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

        ASSIGN l-ponto-encerramento = NO.

       
        IF AVAILABLE ponto-programa THEN DO:
            FIND FIRST conteudo-programa
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = 1 NO-LOCK NO-ERROR.

            IF AVAILABLE conteudo-programa THEN DO:
                IF conteudo-programa.conteudo = "Sim"  THEN DO:
                    ASSIGN l-ponto-encerramento = YES.
                END.
            END.
        END.

       IF tt-param.l-encerrar-programa = YES or
           l-ponto-encerramento = YES THEN LEAVE.
    END.     
    IF VALID-HANDLE(h-escrm001api) THEN
        RUN piCloseConnection IN h-escrm001api.

    IF VALID-HANDLE(h-escrm001api) THEN
        DELETE OBJECT h-escrm001api.

    PUT UNFORMATTED "In¡cio Processamento: ":U + STRING(iHoraInicioProcEMS, "hh:mm:ss":U) SKIP
                    " Final Processamento: ":U + STRING(TIME, "hh:mm:ss":U) SKIP(2).

    IF NOT CAN-FIND(FIRST RowErrors) AND
           CAN-FIND(FIRST tt-trace)  THEN
        PUT UNFORMATTED "Integra‡Æo realizada com 100% de sucesso!":U SKIP(2).

    IF NOT CAN-FIND(FIRST tt-trace) THEN
        PUT UNFORMATTED "Nenhuma informa‡Æo selecionada.":U.

    FOR EACH RowErrors:
        DISPLAY RowErrors WITH STREAM-IO WIDTH 300.
    END.

    FOR EACH tt-erro:
        DISPLAY tt-erro WITH STREAM-IO WIDTH 300.
    END.

    FOR EACH tt-trace:
        DISPLAY tt-trace WITH STREAM-IO.
    END.

    {include/i-rpclo.i}
    
    IF VALID-HANDLE(h-escrm001api) THEN
        DELETE OBJECT h-escrm001api.

    IF VALID-HANDLE(h-escrm001api5) THEN
        DELETE OBJECT h-escrm001api5.

END.

PROCEDURE ExecucaoCRMxEMS:
    ASSIGN i-cont = i-cont + 1.
   

    DO TRANS:

        IF tt-param.l-crm-emitente THEN DO:

            RUN piCarregaBos.

            ASSIGN cEntidade = "account":U.

            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).

            RUN piRetornaCliente IN h-escrm001api (INPUT  cEntidade,
                                                   OUTPUT iContaLinhasTrace,
                                                   OUTPUT TABLE RowErrors).

            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
        END.
    END.
    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA CONTATO (fromCRM)
    **------------------------------------------------------------------------------------------------------------------------------*/
    DO TRANS:
        IF tt-param.l-crm-contato THEN DO:
            RUN piCarregaBos.

            ASSIGN cEntidade = "contact":U.

            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
            RUN piRetornaContato IN h-escrm001api (INPUT  cEntidade,
                                                   OUTPUT iContaLinhasTrace,
                                                   OUTPUT TABLE RowErrors).
            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
        END.
    END.    
    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA LOCAL ENTREGA (fromCRM)
    **------------------------------------------------------------------------------------------------------------------------------*/
     
         
    DO TRANS:
        IF tt-param.l-crm-local-entrega THEN DO:
            RUN piCarregaBos.

            ASSIGN cEntidade = "customeraddress":U.

            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
            RUN piRetornaLocalEntrega IN h-escrm001api (INPUT  cEntidade,
                                                        OUTPUT iContaLinhasTrace,
                                                        OUTPUT TABLE RowErrors).
            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
        END.    
    END.    
    /* -------------------------------------------------------------------------------------------------------------------------------
    **  INTEGRACAO DA TABELA RELACIONAMENTO CLIENTE (fromCRM)
    2**------------------------------------------------------------------------------------------------------------------------------*/

    DO TRANS:
        IF tt-param.l-crm-relac-cliente THEN DO:

            RUN piCarregaBos.

            ASSIGN cEntidade = "new_relacionamento":U.

            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
            RUN piRetornaRelacionamentoCliente IN h-escrm001api (INPUT  cEntidade,
                                                                 OUTPUT iContaLinhasTrace,
                                                                 OUTPUT TABLE RowErrors).
            RUN piTrace(cEntidade, cFromCRM, STRING(TIME, "hh:mm:ss":U)).
        END.
    END.

END PROCEDURE.

PROCEDURE piCriaErro:
    DEFINE INPUT  PARAMETER pTable   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pMessage AS CHARACTER   NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.tabela   = STRING(pTable)
           tt-erro.mensagem = pMessage.
END PROCEDURE.

PROCEDURE piTrace:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pAcao     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pHora     AS CHARACTER   NO-UNDO.

    FIND FIRST tt-trace 
         WHERE tt-trace.tabela = pEntidade
           AND tt-trace.acao   = pAcao NO-ERROR.
    
    IF NOT AVAIL tt-trace THEN DO:
        CREATE  tt-trace.
        ASSIGN  tt-trace.hora-ini = pHora
                tt-trace.tabela   = pEntidade
                tt-trace.acao     = pAcao.
    END.
    
    ASSIGN tt-trace.hora-fim  = pHora
           tt-trace.registros = iContaLinhasTrace.
END PROCEDURE.

PROCEDURE piCarregaBos:
    IF VALID-HANDLE(h-escrm001api) THEN
        DELETE OBJECT h-escrm001api.

    RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.
END PROCEDURE.
