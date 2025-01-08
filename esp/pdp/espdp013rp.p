
/*******************************************************************************/
{include/i-prgvrs.i espdp013rp 2.00.00.001}  /*** 010001 ***/
/*******************************************************************************/
define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field nr-pedido-ini     like ped-venda.nr-pedido 
    field dt-implant-ini    like ped-venda.dt-implant
    field nr-pedido-fim     like ped-venda.nr-pedido 
    field dt-implant-fim    like ped-venda.dt-implant
    field dt-entrega-ini    like ped-item.dt-entrega
    field dt-entrega-fim    like ped-item.dt-entrega
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
DEFINE VARIABLE h-bodi159cal            AS HANDLE    NO-UNDO.
DEFINE VARIABLE bo-ped-item-can         AS HANDLE    NO-UNDO.
DEFINE VARIABLE dt-implanta             AS DATE      NO-UNDO.

DEFINE TEMP-TABLE tt-pedidosItens NO-UNDO  
    FIELD nome-abrev    LIKE ped-item.nome-abrev  
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli   
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD it-codigo     LIKE ped-item.it-codigo   
    FIELD cod-refer     LIKE ped-item.cod-refer   
    FIELD vl-preori     LIKE ped-item.vl-preori   
    FIELD c-Status      AS CHAR FORMAT 'X(150)'.

DEFINE TEMP-TABLE tt-itemCli
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-gui       LIKE int-emitente.cod-guid
    FIELD vl-preori     LIKE ped-item.vl-preori   .

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo     AS CHAR
    FIELD de-quantidade AS DEC.

DEFINE TEMP-TABLE tt-pedidos NO-UNDO  
    FIELD nome-abrev    LIKE ped-item.nome-abrev  
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli   .

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

assign c-programa     = "espdp013rp"
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
IF AVAIL tt-param THEN DO:

    DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim:

        FOR EACH ped-venda
            WHERE  ped-venda.dt-implant  = dt-implanta 
              AND (ped-venda.cod-sit-ped = 1
               OR  ped-venda.cod-sit-ped = 2) NO-LOCK.

            IF (ped-venda.nr-pedido  < tt-param.nr-pedido-ini 
            OR  ped-venda.nr-pedido  > tt-param.nr-pedido-fim)  THEN NEXT.

            run pi-acompanhar in h-acomp (input 'Geral Data ' + string(dt-implanta) + ' Pedido ' + ped-venda.nr-pedcli).

            DO TRANSACTION:

                RUN pi-carregaDados.

            END. /* TRANSACTION */
    
        END. /* FOR EACH ped-venda */

    END. /* DO dt-implanta = tt-param.dt-implant-ini TO tt-param.dt-implant-fim: */

END. /* IF AVAIL tt-param THEN DO: */
 
RUN pi-imprime.

run pi-finalizar in h-acomp.

/*************************/
/** Procedures internas **/
/*************************/

procedure pi-carregaDados: 

    FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

        IF  ped-item.cod-sit-it <> 1 THEN NEXT.

        IF (ped-item.dt-entrega < tt-param.dt-entrega-ini
        OR  ped-item.dt-entrega > tt-param.dt-entrega-fim) THEN NEXT.

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
                   tt-pedidosItens.vl-preori     = ped-item.vl-preori   
                   .  
        END. /* IF NOT AVAIL tt-pedidosItens THEN DO: */

        if  session:set-wait-state("general") then.
        if not valid-handle(bo-ped-item-can) or
           bo-ped-item-can:type <> "PROCEDURE":U or
           bo-ped-item-can:file-name <> "dibo/bodi154can.p" then
           run dibo/bodi154can.p persistent set bo-ped-item-can.

        run setUserLog in bo-ped-item-can (input c-seg-usuario).
        run validateCancelation in bo-ped-item-can (input rowid(ped-item),
                                                    input 'Cancelamento Customizado',
                                                    input-output table RowErrors).

        if  session:set-wait-state("") then.

        if  can-find(first RowErrors
                     where RowErrors.ErrorType <> "INTERNAL":U) then do:
            ASSIGN tt-pedidosItens.c-Status = 'Erro Completa Pedido ' + ped-item.nr-pedcli + ' - ' + rowerrors.errordescription.
        end.

        if  not can-find(first RowErrors
                         where RowErrors.ErrorSubType = "Error":U) then do:
                         
            if  ped-item.ind-componen = 2 then             
                run updateCancelationComposto in bo-ped-item-can (input  rowid(ped-item),
                                                                  input  'Cancelamento Customizado',
                                                                  input  TODAY,
                                                                  input  1).
            else
                run updateCancelation in bo-ped-item-can (input  rowid(ped-item),
                                                          input  'Cancelamento Customizado',
                                                          input  TODAY,
                                                          input  1).

        end.
        RUN DestroyBO IN bo-ped-item-can.
        delete procedure bo-ped-item-can.
        assign bo-ped-item-can = ?.

    END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */

END PROCEDURE.

PROCEDURE pi-imprime:

    PUT 'nome-abrev   ;  
         nr-pedcli    ;  
         nr-sequencia ;  
         it-codigo    ;  
         cod-refer    ;  
         vl-preori    ;  
         c-Status     ' SKIP.

    FOR EACH tt-pedidosItens:

        IF tt-pedidosItens.c-Status = '' THEN DO:

            FIND FIRST tt-pedidos
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
            tt-pedidosItens.vl-preori    ';'
            tt-pedidosItens.c-Status     SKIP.

    END.

    FOR EACH tt-pedidos:
        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = tt-pedidos.nome-abrev
              AND ped-venda.nr-pedcli  = tt-pedidos.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
             ASSIGN ped-venda.completo = NO.
            /************* CompleteOrder ******************/
            run dibo/bodi159com.p persistent set h-bodi159cal.
            run completeOrder in h-bodi159cal (INPUT ROWID(ped-venda),
                                               OUTPUT TABLE rowerrors).

            if can-find (first RowErrors
                        where RowErrors.ErrorType   <> "INTERNAL":U
                            and RowErrors.ErrorSubType = "Error") then do:
                FOR EACH rowerrors:
                    PUT 'Erro Completa Pedido ' + tt-pedidos.nr-pedcli + ' - ' + rowerrors.errordescription SKIP.
                END. /* FOR EACH rowerrors: */
            END.

            delete procedure h-bodi159cal.
            /********* Fim CompleteOrder ******************/
        END. /* IF AVAIL ped-venda THEN DO: */
        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        RELEASE ped-venda.
    END. /* FOR EACH tt-pedidos: */


END PROCEDURE.

