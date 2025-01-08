/********************************************************************************
 ** UPC........: ddi154.p - UPC DELETE ped-item
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes de itens do pedido de venda 
 **              para a Base do CRM
 ********************************************************************************/

DEF PARAM BUFFER b-ped-item    FOR ped-item.

DEFINE BUFFER b-crm-ped-item FOR crm-ped-item.

DEFINE VARIABLE h-esapi001          AS HANDLE      NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE de-ped-aloc-supcard AS DECIMAL     NO-UNDO. /** SupplierCard - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Novembro de 2011 **/
DEFINE VARIABLE i-sequencia         AS INTEGER     NO-UNDO.

{utp/ut-glob.i}
{esp/wso/out/wso0004.i} /*Include Vtex*/

/**Canais - grava tabela para saber que o item foi removido na hora da integra‡Æo*/
CREATE int-ped-item-canais.
ASSIGN int-ped-item-canais.nr-sequencia = b-ped-item.nr-sequencia
       int-ped-item-canais.nr-pedcli    = b-ped-item.nr-pedcli   
       int-ped-item-canais.nome-abrev   = b-ped-item.nome-abrev  
       int-ped-item-canais.it-codigo    = b-ped-item.it-codigo   
       int-ped-item-canais.cod-refer    = b-ped-item.cod-refer.   
    
/*********************************************************************************/

/*********************************************************************************
**  Prop¢sito:  Validar os pedidos com os limites do SupplierCard
**  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
**  Cria‡Æo:    Setembro de 2011
**********************************************************************************/

/****************************************
**  Valida‡Æo do SupplierCard - In¡cio
*****************************************/
FIND FIRST ped-venda
     WHERE ped-venda.nome-abrev = b-ped-item.nome-abrev
       AND ped-venda.nr-pedcli  = b-ped-item.nr-pedcli NO-LOCK NO-ERROR.

FIND FIRST int-ped-venda2 NO-LOCK
     WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

/*considerar somente os pedidos que geram titulo*/
FIND FIRST natur-oper NO-LOCK
     WHERE natur-oper.nat-operacao = b-ped-item.nat-operacao NO-ERROR.

 /*
/*Deduz carteira no cancelamento do item*/
IF  ped-venda.cod-priori <> 44 
AND natur-oper.emite-duplic
AND (b-ped-item.cod-sit-item <= 2 OR b-ped-item.cod-sit-item = 5)  THEN DO:
    FIND FIRST int-pv-canal EXCLUSIVE-LOCK
         WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
           AND int-pv-canal.it-codigo = b-ped-item.it-codigo
           AND int-pv-canal.mes-meta  = MONTH(b-ped-item.dt-entrega)
           AND int-pv-canal.ano-meta  = YEAR(b-ped-item.dt-entrega) NO-ERROR.

    IF AVAIL int-pv-canal THEN DO:
        ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira - (b-ped-item.qt-pedida - b-ped-item.qt-atendida).
    END.
END.
 */
/* Verificar se na Condi‡Æo de Pagamento (CD0404) est  marcado o "CartÆo Intelbras Clube", se "Sim", validar o limite do SupplierCard */
FIND FIRST int-cond-pagto
    WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

IF AVAILABLE int-cond-pagto                       AND
   SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:

    IF NOT VALID-HANDLE(h-esapi001) THEN
        RUN esp/esapi001.p PERSISTENT SET h-esapi001.

    IF VALID-HANDLE(h-esapi001) THEN
        RUN pi-saldo-ped-item IN h-esapi001 (INPUT  b-ped-item.nome-abrev,
                                             INPUT  b-ped-item.nr-pedcli,
                                             INPUT  b-ped-item.it-codigo,
                                             OUTPUT de-ped-aloc-supcard).

    IF VALID-HANDLE(h-esapi001) THEN
        RUN pi-desaloca-saldo-pedido IN h-esapi001 (INPUT b-ped-item.nome-abrev,
                                                    INPUT b-ped-item.nr-pedcli,
                                                    INPUT b-ped-item.it-codigo,
                                                    INPUT de-ped-aloc-supcard).

END. /* IF AVAILABLE int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */

/*--------------------------------------------------------------------------------------------*/
/*                                   ENVIA MENSAGEM VTEX                                      */
/*--------------------------------------------------------------------------------------------*/
FIND FIRST int-ped-venda NO-LOCK
     WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
       AND int-ped-venda.cod-estabel = ped-venda.cod-estabel  NO-ERROR.

    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

/*
IF  int-ped-venda.LojaCodigo <> 0 THEN DO:

    CREATE ttPedidoAlteracao.
    ASSIGN ttPedidoAlteracao.numeroPedido    = IF AVAIL int-ped-venda2 THEN int-ped-venda2.PedidoeCommerce ELSE ped-venda.nr-pedcli + "-01"
           ttPedidoAlteracao.codigoLoja      = 1
           ttPedidoAlteracao.status-ped      = "Alterado"
           ttPedidoAlteracao.motivoAlteracao = "DelItem"
           ttPedidoAlteracao.totalDesconto   = 0
           ttPedidoAlteracao.totalAcrescimo  = 0.

    CREATE ttItemPedido.
    ASSIGN ttItemPedido.codigoItem = b-ped-item.it-codigo
           ttItemPedido.quantidade = b-ped-item.qt-un-fat /*Nova Quantidade*/
           ttItemPedido.precoItem  = b-ped-item.vl-preori.
           ttItemPedido.tipoAlteracao = "Remover".

        RUN esp/wso/out/wso0004.p (INPUT  "v1/pedido",
                                   INPUT TABLE ttPedidoAlteracao,
                                   INPUT TABLE ttItemPedido).

END.
*/



/****************************************
**  Valida‡Æo do SupplierCard - Final
****************************************/

FIND FIRST crm-ped-item NO-LOCK WHERE
           crm-ped-item.action       = "W" /* Write */         AND
           crm-ped-item.sit-crm      = 2  /* Efetivado */      AND
           crm-ped-item.nr-pedcli    = b-ped-item.nr-pedcli    AND
           crm-ped-item.nome-abrev   = b-ped-item.nome-abrev   AND
           crm-ped-item.it-codigo    = b-ped-item.it-codigo    AND
           crm-ped-item.nr-sequencia = b-ped-item.nr-sequencia NO-ERROR.
IF AVAIL crm-ped-item   /* Ja foi efetivado no crm e foi eliminado no ems */
THEN DO:                  
  FIND FIRST b-crm-ped-item NO-LOCK WHERE
             b-crm-ped-item.action       = "D"                        AND
             b-crm-ped-item.sit-crm      = 1 /* Aberto */             AND
             b-crm-ped-item.nr-pedcli    = b-ped-item.nr-pedcli       AND
             b-crm-ped-item.nome-abrev   = b-ped-item.nome-abrev      AND
             b-crm-ped-item.it-codigo    = b-ped-item.it-codigo       AND
             b-crm-ped-item.nr-sequencia = b-ped-item.nr-sequencia NO-ERROR. 
  IF NOT AVAIL b-crm-ped-item 
  THEN DO:
     CREATE crm-ped-item.
     ASSIGN crm-ped-item.action       = "D"  
            crm-ped-item.sit-crm      = 1 /* Aberto */
            crm-ped-item.nr-pedcli    = b-ped-item.nr-pedcli   
            crm-ped-item.nome-abrev   = b-ped-item.nome-abrev  
            crm-ped-item.it-codigo    = b-ped-item.it-codigo   
            crm-ped-item.nr-sequencia = b-ped-item.nr-sequencia.
  END.
END.

/*

DEFINE VARIABLE h-escrm001api AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.

{esp/crm/escrm001a.i1}
{esp/crm/escrm001.i}

IF OPSYS = "win32" 
THEN DO:

    RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.
    
    empty temp-table tt-param-mov.
    create tt-param-mov.
    assign tt-param-mov.prog-orig       = "wdi154"
           tt-param-mov.action          = "D"  
           tt-param-mov.tabela-pai      = "salesorder"   
           tt-param-mov.tabela-filho    = "salesorderdetail"
           tt-param-mov.rw-tabela-filho = rowid(b-ped-item).
    
    FIND FIRST ped-venda NO-LOCK WHERE
               ped-venda.nr-pedcli  = b-ped-item.nr-pedcli AND
               ped-venda.nome-abrev = b-ped-item.nome-abrev NO-ERROR.
    IF AVAIL ped-venda THEN
       ASSIGN tt-param-mov.rw-tabela-pai   = rowid(ped-venda).
    
    create tt-ped-item-atu.
    buffer-copy b-ped-item to tt-ped-item-atu.
    create tt-raw-transfer.
  
    raw-transfer tt-ped-item-atu to tt-raw-transfer.record.

    RUN piCarregaPedido IN h-escrm001api (input-output TABLE tt-param-mov,
                                          INPUT  TABLE tt-raw-transfer,    
                                          output TABLE RowErrors).
    
    IF VALID-HANDLE(h-escrm001api) THEN
            DELETE OBJECT h-escrm001api.

END.

*/

FIND FIRST int-ped-item
    WHERE int-ped-item.nome-abrev   = b-ped-item.nome-abrev
      AND int-ped-item.nr-pedcli    = b-ped-item.nr-pedcli
      AND int-ped-item.nr-sequencia = b-ped-item.nr-sequencia
      AND int-ped-item.it-codigo    = b-ped-item.it-codigo
      AND int-ped-item.cod-refer    = b-ped-item.cod-refer EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE int-ped-item THEN
    DELETE int-ped-item.

/** SupplierCard - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Novembro de 2011 - In¡cio **/
IF VALID-HANDLE(h-esapi001) THEN
    DELETE PROCEDURE h-esapi001.
/** SupplierCard - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Novembro de 2011 - Final **/


/* Projeto Moderniza‡Æo Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos */
FIND int-evento-monitorado NO-LOCK
    WHERE int-evento-monitorado.cod-evento = 7 /* Elimina‡Æo do item do pedido de venda */
      AND int-evento-monitorado.log-ativo  = YES NO-ERROR.

IF AVAIL int-evento-monitorado
THEN DO:
    FIND ped-venda OF b-ped-item NO-LOCK NO-ERROR.

    IF  AVAIL ped-venda
    THEN DO:
        ASSIGN i-sequencia = 1.
        FIND LAST int-historico-evento NO-LOCK NO-ERROR.
        IF  AVAIL int-historico-evento
        THEN
            ASSIGN i-sequencia = int-historico-evento.num-seq-historico + 1.

        RELEASE int-historico-evento.

        FIND FIRST int-historico-evento NO-LOCK
             WHERE int-historico-evento.num-seq-historico = i-sequencia NO-ERROR.
        IF NOT AVAIL int-historico-evento THEN DO:
           CREATE int-historico-evento.
           ASSIGN int-historico-evento.num-seq-historico  = i-sequencia
                  int-historico-evento.cod-emitente       = ped-venda.cod-emitente
                  int-historico-evento.nr-pedcli          = ped-venda.nr-pedcli
                  int-historico-evento.cod-estabel        = ped-venda.cod-estabel
                  int-historico-evento.cod-sit-item       = b-ped-item.cod-sit-item
                  int-historico-evento.it-codigo          = b-ped-item.it-codigo
                  int-historico-evento.nr-sequencia       = b-ped-item.nr-sequencia
                  int-historico-evento.qtd-alocada-pedido = b-ped-item.qt-log-aloca
                  int-historico-evento.qtd-pedida         = b-ped-item.qt-pedida
                  int-historico-evento.cod-evento         = int-evento-monitorado.cod-evento
                  int-historico-evento.cod-usuario        = c-seg-usuario
                  int-historico-evento.dat-historico      = NOW.
        END.
        RELEASE int-historico-evento.
    END.
END.


RETURN "ok".
