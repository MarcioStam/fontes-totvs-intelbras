/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESENP019.I
    Purpose     : Relat¢rio de Movimenta‡äes do Item, por Opera‡Æo, Grupo
                  de M quina, Centro de Custo, Ordem de produ‡Æo, etc.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD cod-estabel-ini LIKE estabelec.cod-estabel
    FIELD cod-estabel-fin LIKE estabelec.cod-estabel
    FIELD cod-ccusto-ini  LIKE mgcad.ccusto.cod-ccusto
    FIELD cod-ccusto-fin  LIKE mgcad.ccusto.cod-ccusto
    FIELD it-codigo-ini   LIKE item.it-codigo
    FIELD it-codigo-fin   LIKE item.it-codigo
    FIELD periodo-ini     AS CHARACTER FORMAT "9999/99":U
    FIELD periodo-fin     AS CHARACTER FORMAT "9999/99":U
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHARACTER FORMAT "x(35)":U
    FIELD usuario         AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD classifica      AS INTEGER
    FIELD desc-classifica AS CHARACTER FORMAT "x(40)":U
    FIELD gerar-csv       AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD arq-csv         AS CHARACTER FORMAT "x(95)":U
    FIELD modelo          AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf   AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD param-impr      AS LOGICAL
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

