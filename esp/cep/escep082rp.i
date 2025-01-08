{cdp/cdcfgman.i}
{esp/ccp/esccp032.i22}
{include/i-epc000.i}
{include/i-epc200.i1}
{utp/ut-glob.i}
{esp/es0018.i}
{esp/ccp/esccp032.i25}

DEF TEMP-TABLE tt-estoq NO-UNDO
    FIELD tipo         AS CHAR    FORMAT "x(08)"
    FIELD referencia   AS CHAR    FORMAT "x(85)"
    FIELD quantidade   AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD dt-inicio    AS DATE    FORMAT "99/99/9999"
    FIELD dt-termino   AS DATE    FORMAT "99/99/9999"
    FIELD saldo        AS DECIMAL FORMAT "->>>>>>,>>9.9999"
    FIELD observ       AS CHAR    FORMAT "x(18)" 
    FIELD item-pai     AS CHAR 
    FIELD unid-negoc   AS CHAR    FORMAT "x(3)"
    INDEX codigo IS PRIMARY dt-termino tipo.

DEF TEMP-TABLE tt-depositos
    FIELD cod-estabel LIKE estabelec.cod-estabel 
    FIELD cod-depos   LIKE deposito.cod-depos.

DEFINE BUFFER b-ped-item           FOR ped-item.
DEFINE BUFFER b-tt-estoq           FOR tt-estoq.
DEFINE BUFFER b-periodo            FOR periodo.
DEFINE BUFFER b-ped-ent            FOR ped-ent.
DEFINE BUFFER b-item               FOR ITEM.
DEFINE BUFFER b1-item              FOR ITEM.
DEFINE BUFFER b3-item              FOR ITEM.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.

DEFINE VARIABLE c-liter            AS CHARACTER FORMAT "x(18)" EXTENT 15    NO-UNDO.
DEFINE VARIABLE c-clientes-oem     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cod-estabel      AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE de-saldo-item      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo-aloc      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo           AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-inic-teor AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-quantidade      AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-terc-teor AS DECIMAL   FORMAT "->>>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-saldo-fat       AS DECIMAL   FORMAT "->>>>,>>>,>>9.9999" NO-UNDO INITIAL 0.
DEFINE VARIABLE de-saldo-inic      AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-quant-segur     AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-saldo-terc      AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-min          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-dlt          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-ped-saldo       AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-qt-seg          AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE de-vezes           AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE da-termino         AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-inicio          AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-dat             AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-dat-in          AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-termino-f       AS DATE      FORMAT "99/99/9999"         NO-UNDO.
DEFINE VARIABLE da-op-corte        AS DATE                                  NO-UNDO INITIAL ?.
DEFINE VARIABLE da-dt-corte        AS DATE                                  NO-UNDO.
DEFINE VARIABLE da-dt-plan         AS DATE                                  NO-UNDO.
DEFINE VARIABLE da-data-aux        AS DATE                                  NO-UNDO.
DEFINE VARIABLE l-apenas-oem       AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-ord-comp         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-res-comp         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-pedidos          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-oem              AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-cons-ordens-compra               AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-cons-reservas-comprometidas      AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-cons-pedidos-carteira            AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-saldo-estoque          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-remessa-beneficiamento AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-entrada-beneficiamento AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-transferencia          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-remessa-consignacao    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-entrada-consignacao    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-saldo-terceiros        AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-ordens-producao        AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-ordens-compra-beneficiamento     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-apenas-pedidos-credito-aprovado  AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-ordens-planejadas      AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-considera-reservas-planejadas    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i-tam-per          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-nr-dias          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-ressup           AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-ind              AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-dias-dlt         AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-res-var          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE i-cod-plano        AS INTEGER                               NO-UNDO.
DEFINE VARIABLE c-cod-refer        LIKE ITEM.cod-refer                      NO-UNDO. 
DEFINE VARIABLE gr-item            AS ROWID                                 NO-UNDO.

{utp/ut-liter.i O_P * r}
ASSIGN c-liter[1] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_C* * r}
ASSIGN c-liter[2] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_C * r}
ASSIGN c-liter[3] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O.S. * r}
ASSIGN c-liter[4] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Res * r}
ASSIGN c-liter[5] = TRIM (RETURN-VALUE).
{utp/ut-liter.i P_V * r}
ASSIGN c-liter[6] = TRIM (RETURN-VALUE).
{utp/ut-liter.i O_Pl * r}
ASSIGN c-liter[7] = TRIM (RETURN-VALUE).
{utp/ut-liter.i R_Pl * r}
ASSIGN c-liter[8] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Negativo * r}
ASSIGN c-liter[9] = TRIM (RETURN-VALUE).
{utp/ut-liter.i Abaixo_Qt_Segur * r}
ASSIGN c-liter[10] = TRIM (RETURN-VALUE).
