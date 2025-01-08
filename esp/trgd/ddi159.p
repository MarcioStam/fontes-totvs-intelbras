/********************************************************************************
 ** UPC........: ddi159.p - UPC DELETE ped-venda
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de pedidos de venda para a Base Oracle
 ********************************************************************************/

CREATE WIDGET-POOL.

DEF PARAM BUFFER b-ped-venda      FOR ped-venda.

DEFINE VARIABLE h-escrm001api AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-sequencia   AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.
DEFINE VARIABLE raw-param      AS RAW.
{esp/esb/esesb000.i}

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
{utp/ut-glob.i}

FIND int-ped-venda
    WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido
    EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL int-ped-venda THEN DO:
    DELETE int-ped-venda.
END.

find emitente no-lock where
     emitente.nome-abrev = b-ped-venda.nome-abrev no-error.

if not avail emitente then  next.


FIND FIRST int-emitente NO-LOCK
     WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

IF  AVAIL int-emitente
AND int-emitente.ind-participa-canais = 993520001 THEN DO:
    IF PROGRAM-NAME(1) MATCHES '*pd4000*'  /* S¢ enviar a mensagem se o pedido foi excluido pelo PD4000, se veio da extranet a exclus∆o ent∆o n∆o deve enviar */
    OR PROGRAM-NAME(2) MATCHES '*pd4000*'
    OR PROGRAM-NAME(3) MATCHES '*pd4000*'
    OR PROGRAM-NAME(4) MATCHES '*pd4000*'
    OR PROGRAM-NAME(5) MATCHES '*pd4000*'
    OR PROGRAM-NAME(6) MATCHES '*pd4000*'
    OR PROGRAM-NAME(7) MATCHES '*pd4000*'
    OR PROGRAM-NAME(8) MATCHES '*pd4000*'
    OR PROGRAM-NAME(9) MATCHES '*pd4000*' THEN DO:
        RAW-TRANSFER b-ped-venda TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0092", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.            
    END.
END.
/*
run esp/es0669.p (input "no", 
                  "ped-venda", 
                  b-ped-venda.nr-pedcli,
                  string(emitente.cod-emitente,"999999"),
                  "", "", "", "", "", "", "").


/************** INTEGRACAO COM CRM ***********************/
RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.

empty temp-table tt-param-mov.
create tt-param-mov.
assign tt-param-mov.prog-orig       = "wdi159"
       tt-param-mov.action          = "D"  
       tt-param-mov.tabela-pai      = "salesorder"   
       tt-param-mov.rw-tabela-pai   = rowid(b-ped-venda)
       tt-param-mov.tabela-filho    = "salesorderdetail"
       tt-param-mov.rw-tabela-filho = ?.        
      
create tt-ped-venda-atu.
buffer-copy b-ped-venda to tt-ped-venda-atu.
create tt-raw-transfer.

raw-transfer tt-ped-venda-atu to tt-raw-transfer.record.

RUN piCarregaPedido IN h-escrm001api (input-output TABLE tt-param-mov,
                                      INPUT  TABLE tt-raw-transfer,
                                      output TABLE RowErrors).  

IF  VALID-HANDLE(h-escrm001api) THEN
    DELETE OBJECT h-escrm001api.

*/
DELETE WIDGET-POOL.


/* Projeto Modernizaá∆o Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos */
FIND int-evento-monitorado NO-LOCK
    WHERE int-evento-monitorado.cod-evento = 6 /* Eliminaá∆o do pedido de venda */
      AND int-evento-monitorado.log-ativo  = YES NO-ERROR.

IF AVAIL int-evento-monitorado
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
        ASSIGN int-historico-evento.num-seq-historico = i-sequencia
               int-historico-evento.cod-emitente      = b-ped-venda.cod-emitente
               int-historico-evento.nr-pedcli         = b-ped-venda.nr-pedcli
               int-historico-evento.cod-estabel       = b-ped-venda.cod-estabel
               int-historico-evento.cod-sit-aval      = b-ped-venda.cod-sit-aval
               int-historico-evento.cod-sit-ped       = b-ped-venda.cod-sit-ped
               int-historico-evento.cod-evento        = int-evento-monitorado.cod-evento
               int-historico-evento.cod-usuario       = c-seg-usuario
               int-historico-evento.dat-historico     = NOW.
    END.
    RELEASE int-historico-evento.
END.

RETURN "ok".
