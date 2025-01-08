{include/i-prgvrs.i esacr067RP 2.00.00.000}  

define temp-table tt-param no-undo
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR format "x(35)"
    FIELD usuario      AS CHAR format "x(12)"
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD dt-emis-ini  AS DATE
    FIELD dt-emis-fim  AS DATE
    FIELD arquivo-imp  AS CHAR.

define temp-table tt-digita 
    FIELD canal-central AS INTEGER .

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp AS HANDLE NO-UNDO.

{include/i-rpvar.i}
{utp/ut-glob.i}
{include/i-rpout.i}

ASSIGN c-programa     = "ESACR073RP"
       c-versao       = "2.00"
       c-revisao      = ".00.001"
       c-empresa      = "Intelbras"
       c-sistema      = "Contas a Receber"
       c-titulo-relat = "Relat¢rio de Pedidos Faturados".

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gerando relat¢rio ...").

RUN pi-relat-pedidos.

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             


PROCEDURE pi-relat-pedidos:

    PUT "Estab;Serie;Nr Nota;Dt Emissao;Cliente;Nome Abrev;Vl Nota;Atendente;Usu†rio Impl;Usu†rio Ult Alt;Usu†rio Fat" SKIP.
    
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis >= tt-param.dt-emis-ini
       AND   nota-fiscal.dt-emis <= tt-param.dt-emis-fim:
         
       IF nota-fiscal.dt-cancela <> ? THEN NEXT. /* retira notas canceladas */
    
       IF nota-fiscal.emite-duplic = NO THEN NEXT. /* retira notas que n∆o geram duplicatas */
    
       RUN pi-acompanhar IN h-acomp ("Nota: " + nota-fiscal.nr-nota-fis).

       FIND FIRST ped-venda 
            WHERE ped-venda.nr-pedido  = int(nota-fiscal.nr-pedcli) NO-LOCK NO-ERROR.
    
       IF  AVAIL ped-venda THEN
           FIND FIRST atendente 
                WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
    
       FIND FIRST emitente
           WHERE emitente.cod-emit = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
    
       PUT nota-fiscal.cod-estabel                                   ';'
           nota-fiscal.serie                                         ';'
           nota-fiscal.nr-nota-fis                                   ';'
           nota-fiscal.dt-emis-nota                                  ';'
           nota-fiscal.cod-emitente                                  ';'
           emitente.nome-abrev                                       ';'
           nota-fiscal.vl-tot-nota                                   ';'                       
           IF AVAIL atendente THEN string(atendente.nm-oper) ELSE '' ';'
           IF AVAIL ped-venda THEN ped-venda.user-impl       ELSE '' ';'
           IF AVAIL ped-venda THEN ped-venda.user-alte       ELSE '' ';'           
           nota-fiscal.user-calc SKIP.
    END.

END PROCEDURE.
