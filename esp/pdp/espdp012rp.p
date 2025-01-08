
/*******************************************************************************/
{include/i-prgvrs.i espdp012rp 2.00.00.001}  /*** 010001 ***/
/*******************************************************************************/
define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field cod-emitente-ini  like ped-venda.cod-emitente 
    field nr-pedido-ini     like ped-venda.nr-pedido 
    field nr-pedcli-ini     like ped-venda.nr-pedcli 
    field dt-implant-ini    like ped-venda.dt-implant
    field cod-gr-cli-ini    like emitente.cod-gr-cli
    field tp-pedido-ini     like ped-venda.tp-pedido
    field cod-emitente-fim  like ped-venda.cod-emitente 
    field nr-pedido-fim     like ped-venda.nr-pedido 
    field nr-pedcli-fim     like ped-venda.nr-pedcli 
    field dt-implant-fim    like ped-venda.dt-implant
    field cod-gr-cli-fim    like emitente.cod-gr-cli
    field tp-pedido-fim     like ped-venda.tp-pedido
    .

define temp-table tt-digita no-undo
    field nr-pedido        LIKE ped-venda.nr-pedcli
    field it-codigo        LIKE ped-item.it-codigo
    index id nr-pedido it-codigo.

define temp-table tt-raw-digita
   field raw-digita as raw.

DEFINE TEMP-TABLE tt-int-ped-item-pci LIKE int-ped-item-pci.

/*******************************/
/** Recebimento de Par³metros **/
/*******************************/
DEF VAR de-perc-desc AS DECIMAL.


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/****************************/
/** Defini»’o de Variÿveis **/
/****************************/
{esp/esb/esesb000.i}
{cdp/cdcfgdis.i}  /* Include para Pre-Processadores */
{include/i-rpvar.i}
{utp/ut-glob.i}
{method/dbotterr.i}
{include/tt-edit.i}
{include/pi-edit.i}


DEFINE VARIABLE h-acomp                 AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi159cal            AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-msg138a               AS HANDLE    NO-UNDO.
DEFINE VARIABLE p-indice-financiamento  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-perc-icms            AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dt-implanta             AS DATE      NO-UNDO.
DEFINE VARIABLE de-ValorComDesconto     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-vl-perc-reduc         AS DECIMAL   NO-UNDO.


DEF VAR de-indice-finan AS DECIMAL DECIMALS 5.
DEF VAR de-fator-cli    AS DECIMAL.
DEF VAR d-fator         AS DECIMAL.
DEF VAR de-preco-venda  AS DECIMAL.
DEF VAR de-desc-preco   AS DECIMAL.
DEF VAR de-desco-qt     AS DECIMAL.

DEFINE VARIABLE i-num-itens AS INT NO-UNDO.

DEFINE TEMP-TABLE tt-pedidosItens NO-UNDO  
    FIELD nome-abrev    LIKE ped-item.nome-abrev  
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli   
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD it-codigo     LIKE ped-item.it-codigo   
    FIELD cod-refer     LIKE ped-item.cod-refer   
    FIELD vl-preoriOld  LIKE ped-item.vl-preori   
    FIELD vl-preoriNew  LIKE ped-item.vl-preori
    FIELD c-Status      AS CHAR FORMAT 'X(150)'.

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD PrecoBase                AS DEC
    FIELD ValorProduto             AS DEC
    FIELD NomePoliticaComercial    AS CHAR
    FIELD TemCache                 AS LOGICAL
    FIELD DataValidade             AS DATE
    FIELD QuantidadeMaxima         AS DEC
    FIELD RebateAntecipado         AS LOGICAL
    FIELD CalcularRebate             AS LOGICAL
    FIELD PrecoAlterado              AS LOGICAL
    FIELD ValorComDesconto           AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Solu»’o */

DEFINE TEMP-TABLE ProdutoItem_backup NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD cod-guid AS CHAR
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Solu»’o */

DEFINE TEMP-TABLE tt-itemCli NO-UNDO
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-gui       LIKE int-emitente.cod-guid
    FIELD vl-preori     LIKE ped-item.vl-preori   
    index idx_pri is primary unique it-codigo cod-gui.


DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo     AS CHAR
    FIELD de-quantidade AS DEC
    FIELD TipoPortfolio AS INTEGER
    FIELD CodigoUnidadeNegocio AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.
                                         
DEFINE TEMP-TABLE tt-pedidos NO-UNDO  
    FIELD nome-abrev    LIKE ped-item.nome-abrev  
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli   
    index idx_pri is primary unique nome-abrev nr-pedcli.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
DEFINE VARIABLE l-log-ativo AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-hora AS INTEGER     NO-UNDO.
ASSIGN l-log-ativo = NO.


/************************/
/** Defini»’o de forms **/
/************************/

{include/i-rpout.i}
{include/i-rpcab.i}

/*********************/
/** Bloco Principal **/
/*********************/

for first mgcad.empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario no-lock:
    assign c-empresa = empresa.razao-social.
end.

{utp/ut-liter.i "Atualiza»’o de Pre»os na carteira de pedidos" * R}

assign c-programa     = "ESPDP012rp"
       c-versao       = "1.00"
       c-revisao      = ".00.000"
       c-sistema      = "MPD"
       c-titulo-relat = trim(return-value).

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}.
run pi-inicializar in h-acomp (input return-value).

{utp/ut-liter.i "Processando Pedidos Cliente:" * R}

find first param-global no-lock no-error.
find first para-ped     no-lock no-error.

/***************************************************
 * Pre-processador de Usuario e Moeda de Credito   *
 ***************************************************/
IF CAN-FIND (FIRST tt-digita) THEN DO:

    FOR EACH tt-digita:
        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedcli = tt-digita.nr-pedido
              AND (ped-venda.cod-sit-ped = 1   /*aberto*/
               OR  ped-venda.cod-sit-ped = 2  /*atendido parcial*/
               OR  ped-venda.cod-sit-ped = 5) /*suspenso*/ 
              AND  ped-venda.origem <> 9:

            ASSIGN dt-implanta = ped-venda.dt-implant.
    
            run pi-acompanhar in h-acomp (input 'Geral Data ' + string(dt-implanta,"99/99/9999") + ' Pedido ' + ped-venda.nr-pedcli).
            
            DO TRANSACTION:
                FIND FIRST int-emitente NO-LOCK
                     WHERE int-emitente.cod-emitente         = ped-venda.cod-emitente 
                       AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.
    
                IF AVAIL int-emitente AND int-emitente.log-salesforce = NO THEN DO:
                    RUN pi-carregaDados.
                END.

                IF AVAIL int-emitente AND int-emitente.log-salesforce = YES THEN DO:
                   
                   FOR EACH ped-item OF ped-venda
                      WHERE ped-item.it-codigo = tt-digita.it-codigo :
                                          
                      IF  ped-item.cod-sit-it <> 1 
                      AND ped-item.cod-sit-it <> 2 THEN NEXT.    
                         
                      RUN pi-atualiza-valor-item.
                      //ASSIGN ped-item.vl-preuni = de-preco-venda.
                      {esp/pdp/espdp012.i}  /* busca descontos pci */ 

                      ASSIGN tt-pedidosItens.vl-preoriNew = ped-item.vl-preuni.
                      FIND CURRENT ped-item NO-LOCK NO-ERROR.

                      FIND FIRST tt-pedidos USE-INDEX idx_pri
                           WHERE tt-pedidos.nome-abrev = ped-venda.nome-abrev 
                             AND tt-pedidos.nr-pedcli  = ped-venda.nr-pedcli  NO-LOCK NO-ERROR.
                      IF NOT AVAIL tt-pedidos THEN DO:
                         CREATE tt-pedidos.          
                         ASSIGN tt-pedidos.nome-abrev = ped-venda.nome-abrev
                                tt-pedidos.nr-pedcli  = ped-venda.nr-pedcli .
                      END.
                   END.
                   if valid-handle(h-bodi159cal)then do:
                      delete procedure h-bodi159cal.
                      assign h-bodi159cal = ?.
                   END.
                END.
            END.
        END.
    END.
END. 
ELSE IF AVAIL tt-param THEN DO:

    DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim:

        ASSIGN i-hora = TIME.
        IF l-log-ativo THEN DO:
            PUT "Antes Leitura Pedido " string(dt-implanta,"99/99/9999") " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.

        FOR EACH ped-venda
            WHERE  ped-venda.dt-implant  = dt-implanta 
              AND (ped-venda.cod-sit-ped = 1
               OR  ped-venda.cod-sit-ped = 2
               OR  ped-venda.cod-sit-ped = 5) 
              AND  ped-venda.tp-pedido >= tt-param.tp-pedido-ini  
              AND  ped-venda.tp-pedido <= tt-param.tp-pedido-fim
              AND  ped-venda.origem <> 9  NO-LOCK:

            IF l-log-ativo THEN DO:
                PUT "Lendo Pedido " ped-venda.cod-emitente " " ped-venda.nome-abrev " " ped-venda.nr-pedcli " "  string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                ASSIGN i-hora = TIME.
            END.

/*             IF ped-venda.origem = 9 THEN NEXT. */

/*             IF (ped-venda.tp-pedido < tt-param.tp-pedido-ini              */
/*             OR  ped-venda.tp-pedido > tt-param.tp-pedido-fim)  THEN NEXT. */

            run pi-acompanhar in h-acomp (input 'Geral Data ' + string(dt-implanta,"99/99/9999") + ' Pedido ' + ped-venda.nr-pedcli).

            DO TRANSACTION:
    
                FIND FIRST int-emitente NO-LOCK
                     WHERE int-emitente.cod-emitente            = ped-venda.cod-emitente 
                       AND int-emitente.ind-participa-canais    = 993520001 NO-ERROR.
                IF AVAIL int-emitente AND 
                   int-emitente.log-salesforce = NO THEN DO:
    
                    IF (ped-venda.cod-emitente   < tt-param.cod-emitente-ini 
                    OR  ped-venda.cod-emitente   > tt-param.cod-emitente-fim) THEN NEXT.
                            
                    FOR EACH emitente 
                        WHERE emitente.cod-emitente  = ped-venda.cod-emitente NO-LOCK:
        
                        IF (emitente.cod-gr-cli < tt-param.cod-gr-cli-ini
                        OR  emitente.cod-gr-cli > tt-param.cod-gr-cli-fim) THEN NEXT.
        
                        IF (ped-venda.nr-pedcli  < tt-param.nr-pedcli-ini
                        OR  ped-venda.nr-pedcli  > tt-param.nr-pedcli-fim)  THEN NEXT.
        
                        IF (ped-venda.nr-pedido  < tt-param.nr-pedido-ini 
                        OR  ped-venda.nr-pedido  > tt-param.nr-pedido-fim)  THEN NEXT.
   
                        RUN pi-carregaDados.
        
                    END. /* FOR EACH emitente */
                 
                END. /* IF AVAIL int-emitente THEN DO: */

                IF AVAIL int-emitente AND 
                   int-emitente.log-salesforce = YES THEN DO:
                    
                    FIND FIRST emitente NO-LOCK 
                         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR. 

                     IF (emitente.cod-gr-cli < tt-param.cod-gr-cli-ini
                     OR  emitente.cod-gr-cli > tt-param.cod-gr-cli-fim) THEN NEXT.
        
                    IF (ped-venda.nr-pedcli  < tt-param.nr-pedcli-ini
                    OR  ped-venda.nr-pedcli  > tt-param.nr-pedcli-fim)  THEN NEXT.
        
                    IF (ped-venda.nr-pedido  < tt-param.nr-pedido-ini 
                    OR  ped-venda.nr-pedido  > tt-param.nr-pedido-fim)  THEN NEXT.

                    IF (ped-venda.cod-emitente   < tt-param.cod-emitente-ini 
                    OR  ped-venda.cod-emitente   > tt-param.cod-emitente-fim) THEN NEXT.

                    FOR EACH ped-item OF ped-venda:
                       //WHERE ped-item.it-codigo = tt-digita.it-codigo :

                       IF  ped-item.cod-sit-it <> 1 
                       AND ped-item.cod-sit-it <> 2 THEN NEXT.    

                       RUN pi-atualiza-valor-item.
                      // ASSIGN ped-item.vl-preuni = de-preco-venda.
                       {esp/pdp/espdp012.i}  /* busca descontos pci */ 

                       ASSIGN tt-pedidosItens.vl-preoriNew = ped-item.vl-preuni.   
                       FIND CURRENT ped-item NO-LOCK NO-ERROR.

                       FIND FIRST tt-pedidos USE-INDEX idx_pri
                            WHERE tt-pedidos.nome-abrev = ped-venda.nome-abrev 
                              AND tt-pedidos.nr-pedcli  = ped-venda.nr-pedcli  NO-LOCK NO-ERROR.
                       IF NOT AVAIL tt-pedidos THEN DO:
                          CREATE tt-pedidos.          
                          ASSIGN tt-pedidos.nome-abrev = ped-venda.nome-abrev
                                 tt-pedidos.nr-pedcli  = ped-venda.nr-pedcli .
                       END.
                    END.
                    if valid-handle(h-bodi159cal)then do:
                      delete procedure h-bodi159cal.
                      assign h-bodi159cal = ?.
                    END.
                END.


            END. /* TRANSACTION */
    
        END. /* FOR EACH ped-venda */

    END. /* DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim: */

END. /* IF AVAIL tt-param THEN DO: */
 
/*IF  NOT VALID-HANDLE(h-bodi159cal) THEN
    run dibo/bodi159com.p persistent set h-bodi159cal. */

RUN pi-imprime.

/*IF  VALID-HANDLE(h-bodi159cal) THEN
    delete procedure h-bodi159cal.

ASSIGN h-bodi159cal = ?. */

run pi-finalizar in h-acomp.

/*************************/
/** Procedures internas **/
/*************************/
PROCEDURE pi-desconto:

   CASE int-beneficio-conta.nome-beneficio: 
       WHEN 'Top Milhao'                THEN ASSIGN tt-int-ped-item-pci.desc-topmilhao  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Mais Verde  '              THEN ASSIGN tt-int-ped-item-pci.desc-maisverde  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Foco na Unidade'           THEN ASSIGN tt-int-ped-item-pci.desc-focounid   = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Distribuidor 2.0'          THEN ASSIGN tt-int-ped-item-pci.desc-distrib    = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Wide Cloud'                THEN ASSIGN tt-int-ped-item-pci.desc-widecloud  = int-beneficio-conta.perc-desconto / 100.
   END.
END PROCEDURE.


procedure pi-carregaDados: 

    
    IF l-log-ativo THEN DO:
        PUT "Antes Carga Portfolio " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
        ASSIGN i-hora = TIME.
    END.

    FIND FIRST ProdutoItem_backup
        WHERE ProdutoItem_backup.cod-guid = int-emitente.cod-guid NO-LOCK NO-ERROR.
    IF NOT AVAIL ProdutoItem_backup THEN DO:
        RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                   OUTPUT TABLE ProdutoItem,                    
                                   OUTPUT TABLE Resultado). 
        FOR EACH ProdutoItem:
            CREATE ProdutoItem_backup.
            ASSIGN ProdutoItem_backup.cod-guid      = int-emitente.cod-guid
                   ProdutoItem_backup.idm           = ProdutoItem.idm              
                   ProdutoItem_backup.CodigoProduto = ProdutoItem.CodigoProduto     
                   ProdutoItem_backup.Bloqueado     = ProdutoItem.Bloqueado        
                   ProdutoItem_backup.Cached        = ProdutoItem.Cached           
                   ProdutoItem_backup.TipoPortfolio = ProdutoItem.TipoPortfolio.
        END.
        IF l-log-ativo THEN DO:
            PUT "CARREGOU Portfolio " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.

    END.    
    ELSE DO:
        IF l-log-ativo THEN DO:
            PUT "N€O CARREGOU Portfolio " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.

    END. 
    CREATE tt-pedidosItens.
    ASSIGN tt-pedidosItens.nome-abrev    = ped-venda.nome-abrev  
           tt-pedidosItens.nr-pedcli     = ped-venda.nr-pedcli.

    FIND FIRST repres NO-LOCK 
            WHERE  repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
    IF NOT AVAIL repres THEN DO:
        ASSIGN  tt-pedidosItens.c-status      = "Representante Nao encontrado durante a busca DO Portfolio".
        RETURN.
    END.

    ASSIGN i-num-itens = 0.
    EMPTY TEMP-TABLE tt-itens.  
    EMPTY TEMP-TABLE Resultado. 
    IF l-log-ativo THEN DO:
        PUT "Buscando Precos " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
        ASSIGN i-hora = TIME.
    END.
    
    blk_item:
    FOR EACH ped-item OF ped-venda NO-LOCK:
        FIND FIRST int-calculo-canal-item NO-LOCK
             WHERE int-calculo-canal-item.cod-guid     = int-emitente.cod-guid
               AND int-calculo-canal-item.cod-estabel  = ped-venda.cod-estabel
               AND int-calculo-canal-item.it-codigo    = ped-item.it-codigo
               AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
        IF NOT AVAIL int-calculo-canal-item THEN DO:

            FIND FIRST ITEM
                 WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
            FIND FIRST item-uni-estab
                 WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                   AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAIL ITEM THEN NEXT.
            IF NOT AVAIL item-uni-estab THEN NEXT.
            /*EMPTY TEMP-TABLE tt-itens.*/
            FIND FIRST tt-itens NO-LOCK
                 WHERE tt-itens.it-codigo = ped-item.it-codigo NO-ERROR.
            IF NOT AVAIL tt-itens THEN DO:
               ASSIGN i-num-itens = i-num-itens + 1.
               CREATE tt-itens.
               ASSIGN tt-itens.it-codigo              = ped-item.it-codigo
                      tt-itens.de-quantidade          = ped-item.qt-pedida
                      tt-itens.TipoPortfolio          = 993520005
                      tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                      tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                      tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
            END.

            IF i-num-itens = 100 THEN DO:
                RUN pi-msg-0101(INPUT int-emitente.cod-guid,
                                INPUT TABLE tt-itens).

                EMPTY TEMP-TABLE tt-itens.
                ASSIGN i-num-itens = 0.
            END.
        END.
    END.
           
    FIND FIRST tt-itens NO-LOCK NO-ERROR.
    IF AVAIL tt-itens THEN DO:
        RUN pi-msg-0101(INPUT int-emitente.cod-guid,
                        INPUT TABLE tt-itens).
    END. /*find tt-itens*/

    FOR EACH ped-item OF ped-venda NO-LOCK:

        IF AVAIL tt-digita THEN DO:
            IF tt-digita.it-codigo <> ped-item.it-codigo THEN DO:
                IF AVAIL tt-pedidosItens THEN
                    DELETE tt-pedidosItens.

                NEXT.
            END.
        END.

        FIND ITEM
            WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
        FIND item-uni-estab
            WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
              AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.
        
        IF  ped-item.cod-sit-it <> 1 
        AND ped-item.cod-sit-it <> 2 THEN NEXT.

        FIND FIRST ProdutoItem_backup
             WHERE ProdutoItem_backup.cod-guid      = int-emitente.cod-guid
               AND ProdutoItem_backup.CodigoProduto = ped-item.it-codigo 
               AND ProdutoItem_backup.bloqueado     = FALSE NO-LOCK NO-ERROR.
        IF NOT AVAIL produtoitem_backup THEN DO:

            ASSIGN tt-pedidosItens.c-status      = "ITEM Nao encontrado NO portfolio".
            NEXT.
        END. 
        FIND FIRST tt-itemCli USE-INDEX idx_pri
             WHERE tt-itemCli.it-codigo = ped-item.it-codigo   
               AND tt-itemCli.cod-gui   = int-emitente.cod-guid NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-itemCli THEN DO:
            CREATE tt-itens.
            ASSIGN tt-itens.it-codigo              = ped-item.it-codigo
                   tt-itens.de-quantidade          = ped-item.qt-pedida
                   tt-itens.TipoPortfolio          = ProdutoItem_backup.TipoPortfolio
                   tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                   tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                   tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
            IF l-log-ativo THEN DO:
                PUT "Item a buscar pre»o " ped-item.it-codigo " "  string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                ASSIGN i-hora = TIME.
            END.
        END.
    END.
    IF CAN-FIND(FIRST tt-itens) THEN DO:
        IF l-log-ativo THEN DO:
            PUT "Antes Buscar Precos " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.
        RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                   INPUT TABLE tt-itens,
                                   OUTPUT TABLE ProdutoItemR,
                                   OUTPUT TABLE Resultado).

        IF l-log-ativo THEN DO:
            PUT "Apos Buscar Precos " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.
        FOR EACH ProdutoItemR:
            IF l-log-ativo THEN DO:
                PUT "Pre»os localizados  " ProdutoItemR.CodigoProduto " " ProdutoItemR.ValorComDesconto " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                ASSIGN i-hora = TIME.
            END.
        END.
    END.
    ELSE DO:
        IF l-log-ativo THEN DO:
            PUT "Todos os itens ja tem na tabela temporaria " SKIP.
            ASSIGN i-hora = TIME.
        END.
  
    END. 
    
    FOR EACH ped-item OF ped-venda NO-LOCK:

        IF  ped-item.cod-sit-it <> 1 
        AND ped-item.cod-sit-it <> 2 THEN NEXT.

        IF AVAIL tt-digita THEN DO:
            IF tt-digita.it-codigo <> ped-item.it-codigo THEN DO:
                NEXT.
            END.
        END.

        FIND FIRST tt-pedidosItens
             WHERE tt-pedidosItens.nome-abrev    = ped-item.nome-abrev  
               AND tt-pedidosItens.nr-pedcli     = ped-item.nr-pedcli   
               AND tt-pedidosItens.nr-sequencia  = ped-item.nr-sequencia
               AND tt-pedidosItens.it-codigo     = ped-item.it-codigo   
               AND tt-pedidosItens.cod-refer     = ped-item.cod-refer   EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL tt-pedidosItens THEN DO:
            CREATE tt-pedidosItens.
            ASSIGN tt-pedidosItens.nome-abrev    = ped-item.nome-abrev  
                   tt-pedidosItens.nr-pedcli     = ped-item.nr-pedcli   
                   tt-pedidosItens.nr-sequencia  = ped-item.nr-sequencia
                   tt-pedidosItens.it-codigo     = ped-item.it-codigo   
                   tt-pedidosItens.cod-refer     = ped-item.cod-refer   
                   tt-pedidosItens.vl-preoriOld  = ped-item.vl-preori.  
        END.

        /***************** PRE°O CRM ******************/
/*         EMPTY TEMP-TABLE tt-itens.  */
/*         EMPTY TEMP-TABLE Resultado. */

        FIND ITEM
            WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
        FIND item-uni-estab
            WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
              AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.
        
        FIND FIRST ProdutoItem_backup
             WHERE ProdutoItem_backup.cod-guid      =          int-emitente.cod-guid
               AND ProdutoItem_backup.CodigoProduto = ped-item.it-codigo 
               AND ProdutoItem_backup.bloqueado     = FALSE NO-LOCK NO-ERROR.
        IF NOT AVAIL produtoitem_backup THEN DO:

            ASSIGN tt-pedidosItens.c-status      = "ITEM Nao encontrado NO portfolio".
            NEXT.
        END. 

        IF ProdutoItem_backup.TipoPortfolio <> 993520003 AND /* Cross-Selling */
           ProdutoItem_backup.TipoPortfolio <> 993520004     /* Solucoes */  THEN DO: 
            FIND FIRST int-portfolio-repres-canal
                 WHERE int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                   AND int-portfolio-repres-canal.cod-unid-neg       = item-uni-estab.cod-unid-neg
                   AND int-portfolio-repres-canal.cod-segmento       = SUBSTRING(ITEM.fm-cod-com,1,4)
                   AND int-portfolio-repres-canal.ind-situacao       = 0 NO-LOCK NO-ERROR.
            IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                FIND FIRST int-portfolio-repres-canal
                     WHERE int-portfolio-repres-canal.cod-representante  = repres.cod-rep
                       AND int-portfolio-repres-canal.cod-unid-neg       = item-uni-estab.cod-unid-neg
                       AND int-portfolio-repres-canal.cod-segmento       = ?
                       AND int-portfolio-repres-canal.ind-situacao       = 0 NO-LOCK NO-ERROR.

                IF NOT AVAIL int-portfolio-repres-canal THEN DO:
                   ASSIGN tt-pedidosItens.c-status      = "Produto n’o pertence ao portif½lio do cliente".
                   NEXT.
                END.
            END.
        END.

/*         CREATE tt-itens.                                                          */
/*         ASSIGN tt-itens.it-codigo              = ped-item.it-codigo               */
/*                tt-itens.de-quantidade          = ped-item.qt-pedida               */
/*                tt-itens.TipoPortfolio          = ProdutoItem_backup.TipoPortfolio */
/*                tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg      */
/*                tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com                  */
/*                tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.           */


        IF int-emitente.cod-guid = "" THEN
            ASSIGN tt-pedidosItens.c-status = "Cliente n’o possui c½digo CRM".

        ELSE DO:

            FIND FIRST tt-itemCli
                 WHERE tt-itemCli.it-codigo = ped-item.it-codigo   
                   AND tt-itemCli.cod-gui   = int-emitente.cod-guid NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-itemCli THEN DO:
                FIND FIRST ProdutoItemR
                     WHERE ProdutoItemR.CodigoProduto = ped-item.it-codigo NO-LOCK NO-ERROR.
                
                IF AVAIL ProdutoItemR THEN DO:
                    CREATE tt-itemCli.
                    ASSIGN tt-itemCli.it-codigo = ped-item.it-codigo
                           tt-itemCli.cod-gui   = int-emitente.cod-guid
                           tt-itemCli.vl-preori = ProdutoItemR.ValorComDesconto
                           de-ValorComDesconto  = ProdutoItemR.ValorComDesconto.
                    IF l-log-ativo THEN DO:
                            PUT "Pre»o encontrado e gravado em tabela temporaria " ped-item.it-codigo " Pre»o Utilizado " tt-itemCli.vl-preori " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                            ASSIGN i-hora = TIME.
                    END.
                END.
                ELSE DO:
                    ASSIGN tt-pedidosItens.c-status = "Nao encontrado Pre»o no Portfolio ".
                    IF l-log-ativo THEN DO:
                         PUT "Nao encontrado Pre»o no Portfolio " ped-item.it-codigo  " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                         ASSIGN i-hora = TIME.
                     END.
                     NEXT.
                END.
            END.
            ELSE DO:
                IF tt-itemCli.vl-preori <> 0 THEN DO:
                    ASSIGN tt-pedidosItens.vl-preoriNew = tt-itemCli.vl-preori
                           de-ValorComDesconto          = tt-itemCli.vl-preori.
                    IF l-log-ativo THEN DO:
                        PUT "Utilizando pre»o ja calculado " ped-item.it-codigo " Pre»o Utilizado " tt-itemCli.vl-preori " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                        ASSIGN i-hora = TIME.
                    END.
                END.
                ELSE DO:
                     ASSIGN tt-pedidosItens.c-status = "Valor CRM 0. Pre»o n’o alterado itemcli.".
                     IF l-log-ativo THEN DO:
                         PUT "Valor CRM 0. Pre»o n’o alterado itemcli." ped-item.it-codigo  " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                         ASSIGN i-hora = TIME.
                     END.
                     NEXT.
                END.
            END.
                    
            RUN pi-atualiza-valor-item.

            IF l-log-ativo THEN DO:
                PUT "Calculando Precos " ped-item.it-codigo " Pre»o Calculado " tt-pedidosItens.vl-preoriNew " " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
                ASSIGN i-hora = TIME.
            END.
        END.
        /************* FIM PRE°O CRM ******************/

    END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */
    IF l-log-ativo THEN DO:
        PUT "Fim Ler Itens " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
        ASSIGN i-hora = TIME.
    END.

END PROCEDURE.

PROCEDURE pi-atualiza-valor-item.

    IF int-emitente.LOG-salesforce = NO THEN DO:
           IF NOT VALID-HANDLE (h-msg138a) THEN
              RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
           
           RUN pi-calc-juros IN h-msg138a (INPUT  ped-venda.cod-cond-pag,
                                           OUTPUT p-indice-financiamento,
                                           OUTPUT TABLE tt-erro).
                 
           RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                             INPUT  ped-venda.cod-estabel,
                                             INPUT  ped-item.it-codigo,
                                             OUTPUT de-perc-icms,
                                             OUTPUT de-perc-desc-icms,
                                             OUTPUT TABLE tt-erro).
           
           DELETE PROCEDURE h-msg138a.

           FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = ped-venda.cod-emit NO-LOCK NO-ERROR.

           IF  de-perc-desc-icms > 0 THEN
               ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                      de-ValorComDesconto  = round(de-ValorComDesconto / de-perc-desc-icms,4).

       
           FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.
    
           ASSIGN d-vl-perc-reduc = 0.
           RUN pi-config-tributo(OUTPUT d-vl-perc-reduc).
    
           IF d-vl-perc-reduc > 0  THEN DO: /*tem base de reducao no configurador de tributos */
              IF p-indice-financiamento = 0 THEN
                  ASSIGN ped-item.vl-preori           = de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100)))))
                         ped-item.vl-preori-un-fat    = de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100)))))
                         tt-pedidosItens.vl-preoriNew = de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100))))).
               ELSE
                   IF (de-ValorComDesconto / ((100 - de-perc-icms) / 100)) * p-indice-financiamento <> 0 THEN
                       ASSIGN ped-item.vl-preori           = (de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100))))) * p-indice-financiamento)
                              ped-item.vl-preori-un-fat    = (de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100))))) * p-indice-financiamento)
                              tt-pedidosItens.vl-preoriNew = (de-ValorComDesconto / (1 - (1 * ((de-perc-icms / 100) *  (1 - (d-vl-perc-reduc / 100))))) * p-indice-financiamento).
                   ELSE
                       ASSIGN tt-pedidosItens.c-status = "Valor CRM 0. Pre»o n’o alterado - preco calculado zerado.".
           END.
           ELSE DO:
                IF p-indice-financiamento = 0 THEN
                   ASSIGN ped-item.vl-preori           = (de-ValorComDesconto / ((100 - de-perc-icms) / 100))
                          ped-item.vl-preori-un-fat    = (de-ValorComDesconto / ((100 - de-perc-icms) / 100))
                          tt-pedidosItens.vl-preoriNew = (de-ValorComDesconto / ((100 - de-perc-icms) / 100)).
                ELSE
                    IF (de-ValorComDesconto / ((100 - de-perc-icms) / 100)) * p-indice-financiamento <> 0 THEN
                        ASSIGN ped-item.vl-preori           = (de-ValorComDesconto / ((100 - de-perc-icms) / 100)) * p-indice-financiamento
                               ped-item.vl-preori-un-fat    = (de-ValorComDesconto / ((100 - de-perc-icms) / 100)) * p-indice-financiamento
                               tt-pedidosItens.vl-preoriNew = (de-ValorComDesconto / ((100 - de-perc-icms) / 100)) * p-indice-financiamento.
                    ELSE
                        ASSIGN tt-pedidosItens.c-status = "Valor CRM 0. Pre»o n’o alterado - preco calculado zerado.". 
           END.
           
           FIND CURRENT ped-item NO-LOCK NO-ERROR.
           RELEASE ped-item.
    END.
    ELSE DO:

       FIND FIRST mgesp.int-ped-item-pci
            WHERE int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev 
              AND int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
              AND int-ped-item-pci.it-codigo    = ped-item.it-codigo 
              AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia  NO-ERROR.
       IF AVAIL int-ped-item-pci THEN DO:
           FIND LAST preco-item 
               WHERE preco-item.it-codigo  = int-ped-item-pci.it-codigo
                 AND preco-item.nr-tabpre  = int-ped-item-pci.nr-tabpre  //c-tab-preco 
                 AND preco-item.cod-refer  = ped-venda.cod-estabel
                 and preco-item.dt-inival <= today    
                 and preco-item.situacao   = 1 
                 AND preco-item.quant-min  <= ped-item.qt-pedida NO-LOCK NO-ERROR.
    
           IF AVAIL preco-item THEN DO:
              ASSIGN de-preco-venda                = preco-item.preco-venda
                     de-desco-qt                   = preco-item.desco-quant.
           END.
           ELSE DO:
              FIND LAST preco-item 
                  WHERE preco-item.it-codigo  = int-ped-item-pci.it-codigo
                    AND preco-item.nr-tabpre  = int-ped-item-pci.nr-tabpre  //c-tab-preco 
                    AND preco-item.cod-refer  = ped-venda.cod-estabel
                    and preco-item.dt-inival <= today    
                    and preco-item.situacao   = 1  NO-LOCK NO-ERROR.
              IF AVAIL preco-item THEN DO:
                 ASSIGN de-preco-venda                = preco-item.preco-venda
                        de-desco-qt                   = preco-item.desco-quant.
              END.
              ELSE 
                  ASSIGN de-preco-venda         = ped-item.vl-preori  
                         de-desco-qt            = 0.
           END.
       END.


       FIND FIRST cond-pagto 
            WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
       FIND FIRST tab-finan-indice NO-LOCK
            WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
              AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.
       IF AVAIL tab-finan-indice THEN 
          ASSIGN  de-indice-finan = tab-finan-indice.tab-ind-fin.
      // APLICA INDICE DE FINANCIAMENTO NO PRECO 
        IF de-indice-finan <> 1 THEN DO:
           ASSIGN de-preco-venda = de-preco-venda * de-indice-finan.
        END.
        
        // APLICA NO PRECO O FATOR DE DESCONTO ACRESCIMO DO CLIENTE 
        ASSIGN de-fator-cli = 0.
        FIND FIRST mgesp.int-ped-item-pci
             WHERE int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
               AND int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev
               AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
               AND int-ped-item-pci.it-codigo    = ped-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL int-ped-item-pci THEN
        RUN pi-busca-desconto-cliente (INPUT int-emitente.cod-emitente,
                                       INPUT int-ped-item-pci.nr-tabpre,
                                       INPUT ped-item.it-codigo,
                                       OUTPUT de-fator-cli).
        
        IF de-fator-cli <> 0 THEN DO:
           ASSIGN de-preco-venda = de-preco-venda * de-fator-cli.
        END.

        FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN ped-item.vl-preori           = de-preco-venda
               ped-item.vl-preori-un-fat    = de-preco-venda
               ped-item.vl-pretab           = de-preco-venda
               ped-item.vl-preuni           = de-preco-venda.

        //FIND CURRENT ped-item NO-LOCK NO-ERROR.
    END.


END PROCEDURE.

PROCEDURE pi-busca-desconto-cliente.
  {esp/wso/eswso0010.i1}
END.

PROCEDURE pi-imprime:

    PUT 'nome-abrev   ;  
         nr-pedcli    ;  
         nr-sequencia ;  
         it-codigo    ;  
         cod-refer    ;  
         vl-preoriOld ;  
         vl-preoriNew ;  
         c-Status     ' SKIP.

    FOR EACH tt-pedidosItens:

        IF tt-pedidosItens.c-Status = '' THEN DO:

            FIND FIRST tt-pedidos USE-INDEX idx_pri
                 WHERE tt-pedidos.nome-abrev = tt-pedidosItens.nome-abrev 
                   AND tt-pedidos.nr-pedcli  = tt-pedidosItens.nr-pedcli  NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-pedidos THEN DO:
                CREATE tt-pedidos.          
                ASSIGN tt-pedidos.nome-abrev = tt-pedidosItens.nome-abrev
                       tt-pedidos.nr-pedcli  = tt-pedidosItens.nr-pedcli .
            END. /* IF NOT AVAIL tt-pedidos THEN DO: */

        END. /* IF tt-pedidosItens.c-Status = '' THEN DO: */

        PUT tt-pedidosItens.nome-abrev   ';'
            tt-pedidosItens.nr-pedcli    ';'
            tt-pedidosItens.nr-sequencia ';'
            tt-pedidosItens.it-codigo    ';'
            tt-pedidosItens.cod-refer    ';'
            tt-pedidosItens.vl-preoriOld ';'
            tt-pedidosItens.vl-preoriNew ';'
            tt-pedidosItens.c-Status     SKIP.

    END.
    IF l-log-ativo THEN DO:
        PUT "Come»ando recalculo  " string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
        ASSIGN i-hora = TIME.
    END.
    

    IF  NOT VALID-HANDLE(h-bodi159cal) THEN
        run dibo/bodi159com.p persistent set h-bodi159cal.
    
    FOR EACH tt-pedidos:
        FIND FIRST ped-venda USE-INDEX ch-nr-pedcli
             WHERE ped-venda.nr-pedcli  = tt-pedidos.nr-pedcli
               AND ped-venda.nome-abrev = tt-pedidos.nome-abrev NO-LOCK NO-ERROR.
        IF l-log-ativo THEN DO:
            PUT "Pedido Recalculo  " ped-venda.nr-pedcli string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.
        
        IF AVAIL ped-venda THEN DO:
            FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ped-venda.completo = NO.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.  


            IF  NOT VALID-HANDLE(h-bodi159cal) THEN
                run dibo/bodi159com.p persistent set h-bodi159cal.
            /************* CompleteOrder ******************/
            run completeOrder in h-bodi159cal (INPUT ROWID(ped-venda),
                                               OUTPUT TABLE rowerrors).

            if can-find (first RowErrors
                         where RowErrors.ErrorType   <> "INTERNAL":U
                           and RowErrors.ErrorSubType = "Error") then do:
                FOR EACH rowerrors:
                    PUT UNFORMATTED 'Erro Completa Pedido ' + tt-pedidos.nr-pedcli + ' - ' + rowerrors.errordescription SKIP.
                END. /* FOR EACH rowerrors: */
            END.

            EMPTY TEMP-TABLE rowerrors.
            /********* Fim CompleteOrder ******************/
        END. /* IF AVAIL ped-venda THEN DO: */

        IF  VALID-HANDLE(h-bodi159cal) THEN
            delete procedure h-bodi159cal.

        ASSIGN h-bodi159cal = ?.

        IF l-log-ativo THEN DO:
            PUT "Apos Recalculo  " ped-venda.nr-pedcli string(i-hora, "HH:MM:SS") " " string(TIME, "HH:MM:SS") " " string(TIME - i-hora, "HH:MM:SS") SKIP.
            ASSIGN i-hora = TIME.
        END.

        RELEASE ped-venda.
    END. /* FOR EACH tt-pedidos: */
   
END PROCEDURE.

PROCEDURE pi-msg-0101:
    
    DEFINE INPUT PARAM pGuidEmitente AS CHAR .
    DEFINE INPUT PARAM TABLE FOR tt-itens.

    RUN esp/esb/out/msg0101.p (INPUT pGuidEmitente,
                               INPUT  TABLE tt-itens,
                               OUTPUT TABLE ProdutoItemR,
                               OUTPUT TABLE Resultado).
        
    FOR EACH  ProdutoItemR:
       FIND FIRST Resultado NO-ERROR.
       
       IF  AVAIL Resultado THEN DO:
       
           IF Resultado.Sucesso THEN DO:
               FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                    WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                      AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                      AND int-calculo-canal-item.it-codigo   = ProdutoItemR.CodigoProduto NO-ERROR.
               IF AVAIL int-calculo-canal-item THEN DO:
                   ASSIGN int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                          int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                          int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                          int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                          int-calculo-canal-item.data-calculo           = TODAY.
               END.
               ELSE DO:
                   CREATE int-calculo-canal-item.
                   ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                          int-calculo-canal-item.cod-estabel            = ped-venda.cod-estabel   
                          int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                          int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                          int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                          int-calculo-canal-item.tipo-portifolio        = 993520005
                          int-calculo-canal-item.bloqueado              = NO
                          int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                          int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                          int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                          int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                          int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                          int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                          int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                          int-calculo-canal-item.data-calculo           = TODAY.
               END.
               RELEASE int-calculo-canal-item.
           END. /*resultado sucesso = yes*/
       END. /*avail resultado*/
    END. /*for each produtositensR*/

END PROCEDURE.


PROCEDURE pi-config-tributo:

    DEFINE OUTPUT PARAM pPercReduc  AS DEC  NO-UNDO.

    DEFINE VAR dPercReduc AS DEC NO-UNDO.

    ASSIGN dPercReduc = 0.
    find first emitente 
         where emitente.cod-emitente = int-emitente.cod-emitente no-lock no-error.
    
    /*ESTADOS que devem ser desconsideradas*/
    FIND first ponto-programa
         WHERE ponto-programa.nome-programa = "msg0138":U
           AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    IF AVAIL ponto-programa THEN DO:
       FIND FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
              and ENTRY(1,conteudo-programa.conteudo) = ped-venda.cod-estabel
              and ENTRY(2,conteudo-programa.conteudo) = emitente.estado NO-ERROR.
       IF AVAIL conteudo-programa THEN DO:
          FIND FIRST ct-clas-item
               WHERE ct-clas-item.cod-item = ped-item.it-codigo
                 AND ct-clas-item.cod-clas-fis BEGINS "PE -"   no-lock NO-ERROR.
          if avail ct-clas-item then DO:
             FIND FIRST ct-clas-fis
                  WHERE ct-clas-fis.cod-clas-fis = ct-clas-item.cod-clas-fis
                    and ct-clas-fis.idi-tip-clas = 1 no-error.
             if avail ct-clas-fis then 
                find first ct-trib-clas-fisc
                     where ct-trib-clas-fisc.cod-clas-fis = ct-clas-fis.cod-clas-fis no-error.
             if avail ct-trib-clas-fisc then 
                find first ct-configur-trib
                     where ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib no-error.
                if avail ct-configur-trib then 
                   find first ct-formul
                        where ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc.
         
             if AVAIL ct-configur-trib AND ct-configur-trib.cod-tip-trib = 'ICMS' and avail ct-formul and ct-formul.val-perc-reduc > 0 then DO:
                   
                   /*assign pPreco = round(pPrecoUnit / (1 - (1 * ((pPercIcms / 100) *  (1 - (ct-formul.val-perc-reduc / 100))))) * pIndice,4).*/
                 ASSIGN dPercReduc = ct-formul.val-perc-reduc.
             END.
             ELSE
                 ASSIGN dPercReduc = 0.
          END.
       END.
       ELSE
           ASSIGN dPercReduc = 0.
    END. 

    ASSIGN pPercReduc = dPercReduc.
END PROCEDURE.
