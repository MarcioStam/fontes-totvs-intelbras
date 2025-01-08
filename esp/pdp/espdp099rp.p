/*------------------------------------------------------------------------
    File        : espdp099rp.p
    Purpose     : Atualiza‡Æo de saldo - metas por canal
    Syntax      : <none>
    Description : <none>

------------------------------------------------------------------------*/
{include/i-prgvrs.i espdp099 2.00.00.000}  /*** 010000 ***/

{utp/ut-glob.i}
{include/i-rpvar.i}
{include/i-freeac.i}

{utp/utapi019.i}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim        AS DATE        NO-UNDO.
DEFINE VARIABLE qt-carteira   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE qt-fat        AS DECIMAL     NO-UNDO.        

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEF BUFFER b-int-pv-canal FOR int-pv-canal.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
/* Parameters Definitions ---                                           */

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.



/* ***************************  Main Block  *************************** */


FIND LAST param-global NO-LOCK NO-ERROR.


assign c-programa     = "GK0011"
       c-sistema      = "Atualiza Saldos Metas por Canal"
       c-titulo-relat = "Atualiza Saldos Metas por Canal"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
{include/i-rpcab.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

    
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

RUN pi-atualizar-metas IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-atualizar-metas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
 ASSIGN dt-ini = DATE(MONTH(TODAY),01,YEAR(TODAY))
        dt-fim = dt-ini + 33
        dt-fim = DATE(MONTH(dt-fim),01,YEAR(dt-fim)) - 1.
    
 FOR EACH INT-pv-canal NO-LOCK
     WHERE int-pv-canal.mes-meta = MONTH(TODAY)
       AND int-pv-canal.ano-meta = YEAR(TODAY) :

    ASSIGN qt-fat = 0
           qt-carteira = 0.

    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + int-pv-canal.it-codigo).

    DO dt-aux = dt-ini TO dt-fim:

        /*Totaliza Faturado*/
        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.it-codigo    = int-pv-canal.it-codigo
             AND it-nota-fisc.dt-emis-nota = dt-aux,
           FIRST nota-fiscal OF it-nota-fisc 
           WHERE nota-fiscal.idi-sit-nf-eletro = 3 NO-LOCK:

            IF nota-fiscal.emite-duplic = NO THEN 
                NEXT.
    
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli
                   AND ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.
            
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.
            
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
            
            IF AVAIL int-ped-venda2 THEN DO:
               ASSIGN qt-fat = qt-fat +  it-nota-fisc.qt-faturada[1].
            END.
        END.
       
       
        /*Totaliza Carteira*/
        FOR EACH ped-item NO-LOCK
           WHERE ped-item.it-codigo     = int-pv-canal.it-codigo
             AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) 
             AND ped-item.dt-entrega    = dt-aux,
           FIRST ped-venda OF ped-item NO-LOCK,
           FIRST int-ped-venda2 
           WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido 
             AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-LOCK:

            /*considerar somente os pedidos que geram titulo*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            IF NOT natur-oper.emite-duplic THEN
                NEXT.

            IF ped-venda.cod-priori = 44 /* or‡amento */ THEN 
                NEXT.
           
            ASSIGN qt-carteira = qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
           
        END.
    END.

    FIND FIRST b-int-pv-canal
         WHERE b-int-pv-canal.cod-canal = int-pv-canal.cod-canal
           AND b-int-pv-canal.it-codigo = int-pv-canal.it-codigo
           AND b-int-pv-canal.ano       = int-pv-canal.ano
           AND b-int-pv-canal.mes       = int-pv-canal.mes EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-int-pv-canal THEN
       ASSIGN b-int-pv-canal.qt-faturada = qt-fat
              b-int-pv-canal.qt-carteira = qt-carteira.
    
    DISP int-pv-canal.ano-meta
         int-pv-canal.mes
         int-pv-canal.cod-canal
         int-pv-canal.it-codigo
         int-pv-canal.qt-meta
         qt-fat LABEL "Faturado"
         qt-carteira LABEL "Carteira" WITH WIDTH 180 STREAM-IO.
 END.


  RETURN "OK":U.

END PROCEDURE.


