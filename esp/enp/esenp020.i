/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESENP020.I
    Purpose     : Listagem de Opera‡äes da Estrutura do Item
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHARACTER FORMAT "x(100)":U
    FIELD usuario         AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD cod-estabel     LIKE gm-estab.cod-estabel
    FIELD cod-estabel-fin LIKE gm-estab.cod-estabel
    FIELD it-codigo-ini   LIKE estrutura.it-codigo
    FIELD it-codigo-fin   LIKE estrutura.it-codigo
    FIELD dt-corte        AS DATE FORMAT "99/99/9999":U
    FIELD classifica      AS INTEGER
    FIELD desc-classifica AS CHARACTER FORMAT "x(40)":U
    FIELD gerar-csv       AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD arq-csv         AS CHARACTER FORMAT "x(100)":U
    FIELD modelo          AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf   AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD param-impr      AS LOGICAL
    FIELD imprime-desc    AS LOGICAL
    FIELD lista-obsoletos AS LOGICAL
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    FIELD desc-item LIKE item.desc-item
    INDEX id
        it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

