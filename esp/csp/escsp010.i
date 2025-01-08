/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*:T*******************************************************************************
**
**  Programa.: esp/csp/escsp010.i
**  Objetivo.: Definir as temp-tables utilizadas por este programa.
**  Cria‡Æo..: 07/06/2010
**  VersÆo...: 000 - Criar o programa baseado no produto padrÆo 'Comparativo
**             Real / PadrÆo' (CS0501) - Fabiano Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHARACTER FORMAT "x(35)":U
    FIELD usuario         AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD cod-estabel     AS CHARACTER FORMAT "x(3)":U
    FIELD dt-emissao-ini  AS DATE
    FIELD dt-emissao-fin  AS DATE
    FIELD dt-movto-ini    AS DATE
    FIELD dt-movto-fin    AS DATE
    FIELD ind-estado      AS INTEGER
    FIELD variacao-ini    AS DECIMAL FORMAT "-999.99":U
    FIELD variacao-fin    AS DECIMAL FORMAT "-999.99":U
    FIELD lista-zero      AS LOGICAL
    FIELD dt-corte-estrut AS DATE
    FIELD dt-corte-operac AS DATE
    FIELD l-imp-param     AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem      AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo    AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
