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
**  Programa.: esp/ccp/esccp025.i
**  Objetivo.: Definiá∆o das Temp-Tables do programa "ESCCP025".
**  Criaá∆o..: 24/05/2010
**  Vers∆o...: 000 - Importaá∆o de Parametrizaá∆o do Item (ESCCP025). - Fabiano
**             Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario     AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD arq-entrada AS CHARACTER FORMAT "x(35)":U
    FIELD todos       AS INTEGER
    FIELD destino     AS INTEGER
    FIELD arq-destino AS CHARACTER FORMAT "x(35)":U.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.
