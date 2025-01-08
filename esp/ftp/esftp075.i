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
**  Programa.: esp/ftp/esftp075.i
**  Objetivo.: Defini‡Æo das temp-tables do programa de combina‡Æo dos programas
**             FT0910 e ESFTP069.
**  Cria‡Æo..: 02/06/2010
**
*******************************************************************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli-ini   LIKE nota-fiscal.nome-ab-cli
    FIELD nome-ab-cli-fim   LIKE nota-fiscal.nome-ab-cli
    FIELD dt-emis-nota-ini  LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim  LIKE nota-fiscal.dt-emis-nota
    FIELD gera-nfe-n-gerada AS LOGICAL
    FIELD gera-nfe-gerada   AS LOGICAL
    FIELD exporta-est-txt   AS LOGICAL
    FIELD gera-nfe-cancel   AS LOGICAL
    FIELD gera-nfe-inut     AS LOGICAL
    FIELD c-motivo          AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.
