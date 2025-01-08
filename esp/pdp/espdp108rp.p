/************************************************************************************************************
*      Programa .....: ESPDP108RP                                                                           *
*      Data .........: 03 de Junho de 2024                                                                  *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Atauliza‡Æo status pedidos                                                           *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
{include/i-prgvrs.i ESPDP108RP 2.00.00.000} 

//{esp/acr/esacr086.i} //Include com definicao das temp-tables usadas nas API's do ACR 

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
 
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)"
    FIELD usuario                AS CHARACTER FORMAT "x(12)"
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD tp-execucao            AS INTEGER
    FIELD nr-pedido-ini          LIKE ped-venda.nr-pedido
    FIELD nr-pedido-fim          LIKE ped-venda.nr-pedido
    FIELD data-emissao-ini       AS DATE
    FIELD data-emissao-fim       AS DATE 
    FIELD atendente-ini          LIKE ped-venda.tp-pedido
    FIELD atendente-fim          LIKE ped-venda.tp-pedido
    FIELD prioridade-ini         LIKE ped-venda.cod-priori
    FIELD prioridade-fim         LIKE ped-venda.cod-priori 
    FIELD l-reprocessa           AS LOG.

DEFINE TEMP-TABLE tt-msg NO-UNDO 
    FIELD msg AS CHAR FORMAT "x(256)" .

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda.
DEFINE TEMP-TABLE tt-ped-item  NO-UNDO LIKE ped-item.
                                            
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.


/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.

/********************************************************************************************/
/*************************** INCLUDES  *****************************************************/
/********************************************************************************************/
/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{btb/btb912zb.i}


/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Atualiza‡Æo de Status de Pedidos Sales Force"
       c-empresa      = IF AVAILABLE empresa THEN mgcad.empresa.razao-social ELSE ''
       c-programa     = "ESPDP108"
       c-versao       = "1.0"
       c-revisao      = "001".

RUN pi-inicializar IN h-acomp (INPUT "Executando atualiza‡Æo").

FOR EACH ped-venda NO-LOCK USE-INDEX ch-implant
   WHERE ped-venda.nr-pedido  >= tt-param.nr-pedido-ini 
     AND ped-venda.nr-pedido  <= tt-param.nr-pedido-fim 
     AND ped-venda.dt-implant >= tt-param.data-emissao-ini 
     AND ped-venda.dt-implant <= tt-param.data-emissao-fim
     AND ped-venda.tp-pedido  >= tt-param.atendente-ini 
     AND ped-venda.tp-pedido  <= tt-param.atendente-fim
     AND ped-venda.cod-priori >= tt-param.prioridade-ini
     AND ped-venda.cod-priori <= tt-param.prioridade-fim  : 

    IF ped-venda.cod-estab = "101" THEN NEXT. //nao ler estab de notas de servico

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido  
           AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    
    IF tt-param.l-reprocessa = NO THEN DO:
        CREATE tt-msg.
        ASSIGN tt-msg.msg = "Pedido j  estava processado. Pedido: " + string(ped-venda.nr-pedido) + " Cliente : " + ped-venda.nome-abrev .

        IF SUBSTRING(int-ped-venda.char-1,76,1) = "0"  THEN NEXT.
    END.
    
    ASSIGN OVERLAY(int-ped-venda.char-1,76,1) = "0". 

    RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + string(ped-venda.nr-pedido) + "Cliente : " + ped-venda.nome-abrev).

    RUN pi-integra-salesforce.

    CREATE tt-msg.
    ASSIGN tt-msg.msg = "Pedido processado. Pedido: " + string(ped-venda.nr-pedido) + " Cliente : " + ped-venda.nome-abrev .
    
END.


FOR EACH tt-msg:
    PUT tt-msg.msg SKIP.
END.

RUN pi-finalizar in h-acomp.


procedure pi-integra-salesforce:
  empty temp-table tt-ped-venda.
  empty temp-table tt-ped-item.
  create tt-ped-venda.
  buffer-copy ped-venda to tt-ped-venda.
  for each ped-item of ped-venda no-lock:
    create tt-ped-item.
    buffer-copy ped-item to tt-ped-item.
  end.

  run esp/wso/eswso0011.p(input table tt-ped-venda,
                          input table tt-ped-item).
end procedure.

RETURN "OK":U. //Return Final 
