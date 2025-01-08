/******************************************************************************************
******* Programa: docto-entrada-wms                                                 *******
******* Objetivo: Integrar documento de entrada protheus x totvs                    *******
******* Autor   : SCM Concept / Visus                                               *******
******* Data    : 17/10/2022                                                        *******
******************************************************************************************/
//{wmp/wm9000.i}


/*****************************************************************
** Include: wm9000.i
** Funcao.: Definicao temp-tables WM9000.p
*****************************************************************/
{cdp/cdcfgwms.i}
{esp/es0018.i}

DEF TEMP-TABLE ttWm-docto NO-UNDO
    FIELD cod-estabel                   AS CHAR FORMAT 'x(5)'
    FIELD cod-local                     AS CHAR FORMAT 'x(3)'
    FIELD num-docto                     AS CHAR FORMAT 'x(16)'
    FIELD serie                         AS CHAR FORMAT 'x(5)'
    FIELD id-docto                      AS DEC  FORMAT '>>>>>>>>>9'
    FIELD num-docto-origem              AS CHAR FORMAT 'X(100)' 
    FIELD ind-tipo-trans                AS INTEGER FORMAT '>9'
    FIELD ind-origem-docto              AS INTEGER FORMAT '>9'
    FIELD id-carga                      AS DEC  FORMAT '>>>>>>>>>>>>>9'
    FIELD alteracao                     AS LOG
    FIELD cod-depos                     AS CHAR FORMAT 'X(3)'
    FIELD cdd-embarq                    AS DEC   
    FIELD nr-resumo                     AS int  
    FIELD nr-pedcli                     AS CHAR 
    FIELD nome-abrev                    AS CHAR 
    field dt-implan-docto               as date
    field ind-sit-docto                 as int format '>9'
    field RowNum                        as integer
    FIELD cod-motiv-movto               AS CHAR
    FIELD log-obrig-movto-modul-estoq   AS LOG
    FIELD log-fatur-ant-wms             AS LOG
    field log-dat-atualiz-movto-estoq   as LOG
    field r-Rowid                       as rowid
    INDEX codigo  cod-estabel cod-local id-docto
    //INDEX codigo1 cod-estabel cod-local num-docto
    .
 

DEF TEMP-TABLE ttWm-docto-itens NO-UNDO
    FIELD cod-estabel           AS CHAR FORMAT 'x(5)'
    FIELD cod-local             AS CHAR FORMAT 'x(3)'
    FIELD num-docto             AS CHAR FORMAT 'x(16)'
    FIELD id-docto              AS DEC  FORMAT '>>>>>>>>>9'
    FIELD num-seq-item          AS INTEGER FORMAT '>>>>>9'
    FIELD cod-cliente           AS INTEGER FORMAT '>>>>>>>>9' 
    FIELD cod-item              AS CHAR    FORMAT 'x(16)'
    FIELD cod-refer             AS CHAR    FORMAT 'x(8)'
    FIELD cod-lote              AS CHAR    FORMAT 'x(40)'
    FIELD dt-validade-lote      AS DATE
    FIELD cod-doca              AS INTEGER FORMAT '>>9'
    FIELD qtd-item              AS DEC     FORMAT '>>>,>>>,>>9.9999'
    FIELD num-seq-item-ped      AS INTEGER FORMAT '>>>>>9'
    FIELD nr-pedcli             AS CHAR    FORMAT 'x(12)'   
    FIELD nome-abrev            AS CHAR    FORMAT 'x(12)'
    FIELD cdd-embarq            AS DECIMAL FORMAT '>>>>>>>>>>>>>>>9'
    FIELD nr-resumo             AS INTEGER FORMAT '>>>>,>>9'
    FIELD nr-pedido             AS INTEGER FORMAT '>>>,>>>,>>9' 
    FIELD qtd-peso-pedida       AS DEC     FORMAT '>>>,>>>,>>9.9999'
    FIELD log-ped-sob-encomenda AS LOG
    FIELD log-lifo-ped-exp      AS LOG
    FIELD log-pedido-exp        AS LOG
    FIELD alteracao             AS LOG
    FIELD gera-sugestao         AS LOG
    FIELD cdn-emitente          AS INTEGER format '>>>>>>>>9'
    FIELD num-seq-orig          AS INTEGER FORMAT '>>>>>9'
    FIELD rw-it-dep-fat         AS CHAR     
    FIELD cdd-embarq-devol      AS DECIMAL FORMAT '>>>>>>>>>>>>>>>9'
    FIELD nr-resumo-devol       AS INTEGER FORMAT '>>>>,>>9'
    FIELD nr-pedcli-devol       AS CHAR    FORMAT "X(12)"
    FIELD nome-abrev-devol      AS CHAR    FORMAT "X(12)"
    FIELD log-item-sob-enc-rec  AS LOG  
    FIELD dt-atualizacao        AS DATE
    field ind-sit-movto         AS INTEGER FORMAT '>9'
    FIELD cod-depos-rej         AS CHAR    FORMAT "X(3)"
    field RowNum                as integer
    field r-Rowid               as rowid
    FIELD dsl-narrat            AS CHARACTER FORMAT "x(2000)"
    INDEX codigo  cod-estabel cod-local id-docto num-seq-item
    //INDEX codigo1 cod-estabel cod-local num-docto num-seq-item
    //INDEX codigo2 rw-it-dep-fat
    .

DEF TEMP-TABLE ttwm-etiqueta NO-UNDO 
    FIELD id-etiqueta            AS deci FORMAT '>>>>>>>>>>>>>9'
    FIELD cod-estabel            AS char FORMAT 'X(5)'
    FIELD cod-item               AS char FORMAT 'X(16)'
    FIELD cod-refer              AS char FORMAT 'X(8)'
    FIELD cod-lote               AS char FORMAT 'X(40)'
    FIELD dt-validade-lote       AS date 
    FIELD ind-leitura-etiqueta   AS inte FORMAT '>9'
    FIELD qtd-item               AS DECI FORMAT '>>>,>>>,>>9.999'
    FIELD qtd-peso               AS DECI FORMAT '>,>>>,>>9.9999'
    FIELD cod-cliente            AS inte FORMAT '>>>>>>>>9'
    FIELD cod-embalagem          AS char FORMAT 'X(10)'
    FIELD nr-pedido              AS inte FORMAT '>>>,>>>,>>9'
    FIELD cod-estabel-pedido     AS char FORMAT 'X(5)'
    FIELD nr-pedcli              AS char FORMAT 'X(12)'
    FIELD nome-abrev             AS char FORMAT 'X(12)'
    FIELD nr-ord-prod            AS inte FORMAT '>>>,>>>,>>9'
    FIELD cod-estabel-ord        AS char FORMAT 'X(5)'
    FIELD dt-geracao             AS date FORMAT '99/99/9999'
    FIELD hr-geracao             AS inte FORMAT '>>>>9'
    FIELD dt-leitura             AS date FORMAT '99/99/9999'
    FIELD cod-usuario            AS char FORMAT 'X(12)'
    FIELD id-agrupador           AS DECI FORMAT '>>>>>>>>>>>>>9'
    FIELD ind-sit-agrupador      AS inte FORMAT '>9'
    FIELD id-carga               AS DECI FORMAT '>>>>>>>>>>>>>9'
    FIELD log-impressa           AS log   
    FIELD log-reportada          AS log   
    FIELD ind-sit-estorno        AS inte FORMAT '>9'
    FIELD log-rel-movto-etiqueta AS log  
    FIELD qtd-item-retirado      AS DEC  FORMAT '>>>,>>>,>>9.999'
    FIELD cod-usuario-ult-acesso AS char FORMAT 'X(12)'
    FIELD dt-ult-acesso          AS date 
    FIELD hr-ult-acesso          AS inte FORMAT '>>>>9'
    FIELD cod-lote-orig          AS CHAR FORMAT 'x(10)'
    field RowNum                 AS integer
    field r-Rowid                AS rowid
    INDEX codigo  id-etiqueta
    //INDEX codigo1 cod-item cod-refer cod-lote dt-validade-lote
    //INDEX codigo2 cod-cliente cod-item cod-refer cod-lote dt-validade-lote
    .

{method/dbotterr.i}

DEFINE TEMP-TABLE tt-erro  NO-UNDO
   FIELD codigo     AS INT
   FIELD informacao AS CHAR
   FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD numeroItem     AS INT
    FIELD codigoProduto  AS CHAR FORMAT "x(16)"
    FIELD quantidade     AS DEC
    FIELD lote           AS CHAR FORMAT "x(20)"
    FIELD dataDeValidade AS DATE FORMAT "99/99/9999"
    FIELD loteSerial     AS CHAR.

DEF TEMP-TABLE tt-item-aux LIKE tt-item.
DEFINE INPUT PARAM parmazem                      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM pFilialNotaFiscal             AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM pnumeroNotaFiscal             AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM pserieNotaFiscal              AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM pCodigoFornecedor             AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-item.
DEFINE       OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE cCodEstabel         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodEstabelOrigem   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodLocal           AS CHARACTER   NO-UNDO.

def var i-seq-erro  as   integer    no-undo.
def var c-num-docto as   CHAR       no-undo.
def var i-id-docto  as   integer    no-undo.

EMPTY TEMP-TABLE RowErrors.

FOR EACH tt-prog-ponto:
    DELETE tt-prog-ponto.
END.

// Estabelecimento
ASSIGN cCodEstabel = ""
       cCodEstabelOrigem = "".
RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                    INPUT 1,
                    INPUT 0,
                    INPUT "":U,
                    OUTPUT TABLE tt-prog-ponto).
IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = pFilialNotaFiscal NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
        FIND FIRST wm-estabel NO-LOCK
             WHERE wm-estabel.cod-estabel = ENTRY(2,tt-prog-ponto.conteudo,";") NO-ERROR.
        IF AVAIL wm-estabel THEN
            ASSIGN cCodEstabel       = wm-estabel.cod-estabel
                   cCodEstabelOrigem = ENTRY(1,tt-prog-ponto.conteudo,";").
    END.
END.

// Local
ASSIGN cCodLocal = "".
/*
IF pcodigoDeposito <> "" THEN DO:
    ASSIGN cCodLocal = pcodigoDeposito.
END.
ELSE DO:
    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel = cCodEstabel 
           AND wm-local.log-local-padrao NO-ERROR.
    IF AVAIL wm-local THEN
        ASSIGN cCodLocal       = wm-local.cod-local.
END.
*/
EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                    INPUT 2,
                    INPUT 0,
                    INPUT "":U,
                    OUTPUT TABLE tt-prog-ponto).

ASSIGN cCodLocal = "".
IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = parmazem NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN cCodLocal = ENTRY(2,tt-prog-ponto.conteudo,";").
    END.
END.

FIND FIRST wm-local NO-LOCK
     WHERE wm-local.cod-estabel = cCodEstabel 
       AND wm-local.cod-local   = cCodLocal   NO-ERROR.
IF NOT AVAIL wm-local THEN DO:
    RUN piCreateError (INPUT 17006,                                                                        /* ErrorNumber     */
                       INPUT "N∆o encontrado cadastro Estabelecimento x Local. Verifique programa WM0240", /* ErrorParameters */  
                       INPUT "ERROR").                                                                     /* ErrorSubType    */
    RETURN 'NOK'.
END.

IF pnumeroNotaFiscal = "" THEN DO:
    RUN piCreateError (INPUT 17006,                            /* ErrorNumber     */
                       INPUT "Documento deve ser informado.",  /* ErrorParameters */  
                       INPUT "ERROR").                         /* ErrorSubType    */
    RETURN 'NOK'.
END.

/* sumariza itens  */
FOR EACH tt-item:
    FIND FIRST tt-item-aux
         WHERE tt-item-aux.codigoProduto = tt-item.codigoProduto 
           AND tt-item-aux.lote          = tt-item.lote  NO-ERROR.
    IF NOT AVAIL tt-item-aux THEN DO:
        CREATE tt-item-aux.
        ASSIGN tt-item-aux.codigoProduto = tt-item.codigoProduto
               tt-item-aux.lote          = tt-item.lote.
    END.
    ASSIGN tt-item-aux.quantidade     = tt-item-aux.quantidade + tt-item.quantidade
           tt-item-aux.dataDeValidade = tt-item.dataDeValidade
           tt-item-aux.loteSerial     = tt-item.loteSerial.
END.

FOR EACH tt-item-aux:
    IF tt-item-aux.quantidade = 0 THEN DO:
        RUN piCreateError (INPUT 17006,                           /* ErrorNumber     */
                           INPUT "Item " + STRING(tt-item-aux.codigoProduto) + " sem quantidade informada",      /* ErrorParameters */  
                           INPUT "ERROR").                        /* ErrorSubType    */
        RETURN 'NOK'.
    END.

    FIND FIRST wm-item NO-LOCK
         WHERE wm-item.cod-item = tt-item-aux.codigoProduto NO-ERROR.
    IF NOT AVAIL wm-item THEN DO:
        RUN piCreateError (INPUT 17006,                           /* ErrorNumber     */
                           INPUT "Item n∆o cadastrado no WMS.",      /* ErrorParameters */  
                           INPUT "ERROR").                        /* ErrorSubType    */
        RETURN 'NOK'.
    END.
END.

ASSIGN c-num-docto = cCodEstabelOrigem + "-" + pnumeroNotaFiscal + "-" + pserieNotaFiscal + "-" + STRING(pCodigoFornecedor).

FIND FIRST wm-docto 
     WHERE wm-docto.cod-estabel      = wm-local.cod-estabel
       AND wm-docto.cod-local        = wm-local.cod-local
       AND wm-docto.ind-origem-docto = 1
       AND wm-docto.num-docto-origem = c-num-docto NO-LOCK NO-ERROR.
IF AVAIL wm-docto THEN DO:
    /* Documento J† existe  */
    RUN piCreateError (INPUT 17006,                             /* ErrorNumber     */
                       INPUT "Documento j† integrado no WMS.",  /* ErrorParameters */  
                       INPUT "ERROR").                          /* ErrorSubType    */
    RETURN 'NOK'.
END.

FOR EACH ttWm-docto:
    DELETE ttWm-docto.
END.

CREATE ttWm-docto.
ASSIGN ttWm-docto.cod-estabel           = wm-local.cod-estabel
       ttWm-docto.cod-local             = wm-local.cod-local  
       ttWm-docto.num-docto             = pnumeroNotaFiscal
       ttWm-docto.id-docto              = IF AVAIL wm-docto THEN wm-docto.id-docto ELSE 0
       ttWm-docto.num-docto-origem      = cCodEstabelOrigem + "-" + pnumeroNotaFiscal + "-" + pserieNotaFiscal + "-" + STRING(pCodigoFornecedor)
       ttWm-docto.ind-tipo-trans        = 1
       ttWm-docto.ind-origem-docto      = 1
       ttWm-docto.alteracao             = IF AVAIL wm-docto THEN YES ELSE NO
       ttWm-docto.cod-depos             = ""
       ttWm-docto.dt-implan-docto       = TODAY.

FOR EACH ttWm-docto-itens:
    DELETE ttWm-docto-itens.
END.

FOR EACH tt-item-aux:

    CREATE ttWm-docto-itens.
    ASSIGN ttWm-docto-itens.cod-estabel           = wm-local.cod-estabel 
           ttWm-docto-itens.cod-local             = wm-local.cod-local  
           ttWm-docto-itens.num-docto             = pnumeroNotaFiscal
           ttWm-docto-itens.id-docto              = ttWm-docto.id-docto
           ttWm-docto-itens.num-seq-item          = 0
           ttWm-docto-itens.cod-cliente           = 0
           ttWm-docto-itens.cod-item              = tt-item-aux.codigoProduto
           ttWm-docto-itens.cod-refer             = ""
           ttWm-docto-itens.cod-lote              = tt-item-aux.lote
           ttWm-docto-itens.dt-validade-lote      = tt-item-aux.dataDeValidade
           ttWm-docto-itens.cod-doca              = 0
           ttWm-docto-itens.qtd-item              = tt-item-aux.quantidade
           ttWm-docto-itens.num-seq-item-ped      = 0
           ttWm-docto-itens.nr-pedcli             = ""
           ttWm-docto-itens.nome-abrev            = ""
           ttWm-docto-itens.cdd-embarq            = 0
           ttWm-docto-itens.nr-resumo             = 0
           ttWm-docto-itens.nr-pedido             = 0
           ttWm-docto-itens.qtd-peso-pedida       = 0
           ttWm-docto-itens.log-ped-sob-encomenda = NO
           ttWm-docto-itens.log-lifo-ped-exp      = NO
           ttWm-docto-itens.log-pedido-exp        = NO
           ttWm-docto-itens.alteracao             = NO
           ttWm-docto-itens.gera-sugestao         = NO
           ttWm-docto-itens.cdn-emitente          = 0
           ttWm-docto-itens.num-seq-orig          = 0
           ttWm-docto-itens.rw-it-dep-fat         = ?.
END.

bloco:
DO TRANS:

    RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                      INPUT-OUTPUT TABLE ttWm-docto-itens,
                      INPUT-OUTPUT TABLE ttwm-etiqueta,
                      OUTPUT       TABLE RowErrors).
    IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
        FOR EACH RowErrors:
            RUN piCreateError (INPUT RowErrors.errornumber,         /* ErrorNumber     */
                               INPUT RowErrors.errordescription,    /* ErrorParameters */  
                               INPUT "ERROR").                      /* ErrorSubType    */
        END.
    
        UNDO bloco, RETURN "NOK":U.
    END.
END.

RETURN "OK".

/************************************************************************************************************
**                                             PROCEDURE PICREATEERROR
************************************************************************************************************/
PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pCodigo          AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pMensagem        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pTipoErro        AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    /*
    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pCodigo,
                       INPUT pMensagem).  
    */

    FIND FIRST tt-erro 
         WHERE tt-erro.mensagem = pMensagem NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-erro THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.codigo      = pCodigo
               tt-erro.informacao  = pTipoErro
               tt-erro.mensagem    = pMensagem.
    END.

    RETURN "OK":U.    

END PROCEDURE.
