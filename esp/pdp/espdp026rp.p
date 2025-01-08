
/*******************************************************************************/
{include/i-prgvrs.i espdp026rp 2.00.00.001}  /*** 010001 ***/
/*******************************************************************************/
define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field nr-pedido-ini     like ped-venda.nr-pedido 
    field nr-pedido-fim     like ped-venda.nr-pedido 
    field dt-implant-ini    like ped-venda.dt-implant
    field dt-implant-fim    like ped-venda.dt-implant
    field dt-entrega-ini    like ped-venda.dt-entrega
    field dt-entrega-fim    like ped-venda.dt-entrega
    field tp-pedido-new     like ped-venda.tp-pedido
    field tp-pedido-old     like ped-venda.tp-pedido
    FIELD cod-emitente-ini  LIKE emitente.cod-emitente
    FIELD cod-emitente-fim  LIKE emitente.cod-emitente
    FIELD nr-repres-ini     LIKE emitente.cod-rep
    FIELD nr-repres-fim     LIKE emitente.cod-rep
    .

define temp-table tt-raw-digita
   field raw-digita as raw.

/*******************************/
/** Recebimento de Parƒmetros **/
/*******************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/****************************/
/** Defini‡Æo de Vari veis **/
/****************************/

{cdp/cdcfgdis.i}  /* Include para Pre-Processadores */
{include/i-rpvar.i}
{utp/ut-glob.i}
{method/dbotterr.i}
{include/tt-edit.i}
{include/pi-edit.i}

DEFINE VARIABLE h-acomp                 AS HANDLE    NO-UNDO.
DEFINE VARIABLE dt-implanta             AS DATE      NO-UNDO.

DEFINE VARIABLE h-bodi159com  AS HANDLE  NO-UNDO.

DEFINE TEMP-TABLE tt-erro-local NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

/************************/
/** Defini‡Æo de forms **/
/************************/

{include/i-rpout.i}
{include/i-rpcab.i}

/*********************/
/** Bloco Principal **/
/*********************/

for first mgcad.empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario no-lock:
    assign c-empresa = empresa.razao-social.
end.

{utp/ut-liter.i "Avalia‡Æo de Cr‚dito" * R}

assign c-programa     = "espdp026rp"
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

IF  NOT VALID-HANDLE(h-bodi159com) THEN
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.

/***************************************************/
PUT 'nome-abrev    ;  
     nr-pedcli     ;  
     Atendente_Old ;  
     Atendente_New ' SKIP.

IF AVAIL tt-param THEN DO:

    DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim:

        run pi-acompanhar in h-acomp (input 'Data ' + string(dt-implanta)).
        FOR EACH ped-venda
            WHERE  ped-venda.dt-implant  = dt-implanta 
              AND (ped-venda.cod-sit-ped = 1
               OR  ped-venda.cod-sit-ped = 2)
             AND ped-venda.cod-priori <> 44 EXCLUSIVE-LOCK.

            IF (ped-venda.nr-pedido  < tt-param.nr-pedido-ini 
            OR  ped-venda.nr-pedido  > tt-param.nr-pedido-fim)  THEN NEXT.

            IF (ped-venda.dt-entrega < tt-param.dt-entrega-ini 
            OR  ped-venda.dt-entrega > tt-param.dt-entrega-fim) THEN NEXT.
            
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
            IF AVAIL emitente THEN DO:
                IF (emitente.cod-emitente  < tt-param.cod-emitente-ini 
                OR  emitente.cod-emitente  > tt-param.cod-emitente-fim)  THEN NEXT.
            END.

            FIND FIRST repres NO-LOCK
                 WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
            IF AVAIL repres THEN DO:
                IF repres.cod-rep < tt-param.nr-repres-ini 
                OR repres.cod-rep > tt-param.nr-repres-fim THEN NEXT.
            END.

            run pi-acompanhar in h-acomp (input 'Geral Data ' + string(dt-implanta) + ' Pedido ' + ped-venda.nr-pedcli).

            IF ped-venda.tp-pedido = tt-param.tp-pedido-old THEN DO:

                FIND FIRST atendente NO-LOCK
                     WHERE atendente.cd-oper = int(tt-param.tp-pedido-new) NO-ERROR.

                IF  AVAIL atendente THEN DO:
                    ASSIGN ped-venda.tp-pedido = tt-param.tp-pedido-new.

                    PUT ped-venda.nome-abrev   ';'
                        ped-venda.nr-pedcli    ';'
                        tt-param.tp-pedido-old ';'
                        ped-venda.tp-pedido SKIP.

                    RUN pi-efetiva-pedido(INPUT ROWID(ped-venda)).
                    ASSIGN ped-venda.completo = YES .
                END.

            END.
    
        END. /* FOR EACH ped-venda */
        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        RELEASE ped-venda.

    END. /* DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim: */

END. /* IF AVAIL tt-param THEN DO: */

IF  VALID-HANDLE(h-bodi159com) THEN DO:
    RUN destroyBO IN h-bodi159com.
    ASSIGN h-bodi159com = ?.
END.

/*IF CAN-FIND(FIRST tt-erro-local) THEN DO:
    FOR EACH tt-erro-local:
        PUT tt-erro-local.mensagem FORMAT "x(150)" SKIP.
    END.
END. */
 
run pi-finalizar in h-acomp.

/*************************/
/** Procedures internas **/
/*************************/

PROCEDURE pi-efetiva-pedido:

    DEFINE INPUT PARAM pPedvenda AS ROWID NO-UNDO.


    RUN completeOrder IN h-bodi159com (INPUT pPedvenda , 
                                       OUTPUT TABLE RowErrors). 

    /*FOR EACH  rowErrors NO-LOCK
        WHERE rowErrors.errornumber <> 8259:  /* credito nÆo aprovado */
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = "Erro BO => " + RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli.
             
    END. */


END PROCEDURE.
