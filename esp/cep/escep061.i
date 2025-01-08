/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESCEP061.I
    Purpose     : Invent rio
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Novembro de 2011
    Notes       : <none>
----------------------------------------------------------------------*/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(60)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE      FORMAT "99/99/9999":U
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel-1     LIKE estabelec.cod-estabel
    FIELD cod-depos-1       LIKE deposito.cod-depos
    FIELD cod-estabel-2     LIKE estabelec.cod-estabel
    FIELD cod-depos-2       LIKE deposito.cod-depos
    FIELD it-codigo-ini     LIKE item.it-codigo
    FIELD it-codigo-fin     LIKE item.it-codigo
    FIELD cod-localiz-ini   LIKE mgcad.localizacao.cod-localiz
    FIELD cod-localiz-fin   LIKE mgcad.localizacao.cod-localiz
    FIELD cons-saldo-nfs    AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD dt-corte-nfs      AS DATE      FORMAT "99/99/9999":U
    FIELD cons-saldo-transf AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD cons-saldo-ae     AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD gerar-detalhes-ae AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD cons-saldo-cst    AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD listar-nfs        AS LOGICAL   FORMAT "Sim/NÆo":U
    FIELD arquivo-csv       AS CHARACTER FORMAT "x(60)":U
    FIELD arquivo-ae        AS CHARACTER FORMAT "x(60)":U.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX id
        it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

