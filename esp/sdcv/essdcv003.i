/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESSDCV003.I
    Purpose     : Exportar informa‡Æo para o OutBuyCenter (SDCV).
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Julho de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                   AS INTEGER
    FIELD arquivo                   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec                 AS DATE
    FIELD hora-exec                 AS INTEGER
    FIELD classifica                AS INTEGER
    FIELD desc-classifica           AS CHARACTER FORMAT "x(40)":U
    FIELD modelo                    AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar
      se o RTF foi habilitado*/
    FIELD l-habilitaRtf          AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD l-centro-custo         AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-conta-contabil       AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-plano-contas         AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-fornecedores         AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-classificacao-fiscal AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-condicao-pagamento   AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-mensagem             AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD l-cotacao-moeda        AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD c-cotacao-inicial      AS CHARACTER FORMAT "9999/99":U
    FIELD c-cotacao-final        AS CHARACTER FORMAT "9999/99":U
    FIELD l-feriado              AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD i-feriado-inicial      AS INTEGER   FORMAT "9999":U
    FIELD i-feriado-final        AS INTEGER   FORMAT "9999":U
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem
    .

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW
    .

