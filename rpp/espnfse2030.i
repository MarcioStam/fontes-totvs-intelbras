/**************************************************************************************************
** PROGRAMA...: espnfse2030.i - Definicao de TEMP-TABLEs para importacao de RPS do CW NFSe
** AUTOR......: Ivonei Vock - CW
** DATA.......: 08/04/2013
**************************************************************************************************/

/** TEMP-TABLE: Parametros **/
DEF TEMP-TABLE tt-nfse
    FIELD sequencia          AS INT
    FIELD cod-estabel        LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis        LIKE nota-fiscal.nr-nota-fis
    FIELD serie              LIKE nota-fiscal.serie
    FIELD dt-emis-rps        LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nfse       LIKE nota-fiscal.dt-emis-nota
    FIELD nr-rps             LIKE nota-fiscal.nr-nota-fis
    FIELD c-cnpj-estab       AS CHAR FORMAT "x(14)"
    FIELD c-cod-verificacao  AS CHAR FORMAT "x(30)"
    FIELD c-arquivo          AS CHAR FORMAT "x(30)"
    FIELD c-dir-arq-completo AS CHAR FORMAT "x(200)"
    FIELD i-status-rps       AS INT
    FIELD l-situacao-imp     AS LOG
    FIELD c-sistema          AS CHAR /*1 - CW NFSe, 2 - Mastersaf V3*/
    FIELD c-url-consulta     AS CHAR FORMAT "x(256)"
    INDEX ch-unico AS UNIQUE  sequencia.

DEF TEMP-TABLE tt-erro-nfse
    FIELD sequencia          AS INT
    FIELD cod-estabel        LIKE nota-fiscal.cod-estabel
    FIELD nr-rps             LIKE nota-fiscal.nr-nota-fis
    FIELD serie              LIKE nota-fiscal.serie
    FIELD tipo-erro          LIKE esp-ext-nota-fiscal-erro.tipo-erro
    FIELD nr-lote            LIKE esp-ext-nota-fiscal-erro.nr-lote
    FIELD cod-erro           LIKE esp-ext-nota-fiscal-erro.cod-erro
    FIELD des-erro           LIKE esp-ext-nota-fiscal-erro.des-erro
    FIELD des-correcao       LIKE esp-ext-nota-fiscal-erro.des-correcao
    FIELD nome-arquivo       LIKE esp-ext-nota-fiscal-erro.nome-arquivo
    FIELD dt-importacao      LIKE esp-ext-nota-fiscal-erro.data-importacao
    FIELD hr-importacao      LIKE esp-ext-nota-fiscal-erro.hora-importacao
    FIELD linha-registro     LIKE esp-ext-nota-fiscal-erro.linha-registro
    FIELD tipo-registro      LIKE esp-ext-nota-fiscal-erro.tipo-registro
    FIELD c-arquivo          AS CHAR FORMAT "x(30)"
    FIELD c-dir-arq-completo AS CHAR FORMAT "x(200)"
    FIELD c-registro-arquivo AS CHAR FORMAT "x(200)"
    FIELD l-situacao-imp     AS LOG
    FIELD c-sistema          AS CHAR /*1 - CW NFSe, 2 - Mastersaf V3*/
    INDEX ch-unico AS UNIQUE AS PRIMARY
          sequencia
          cod-estabel
          nr-rps
          serie.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD cod-erro           AS INT
    FIELD desc-erro          AS CHAR FORMAT "x(80)"
    FIELD ajuda-erro         AS CHAR FORMAT "x(4000)" COLUMN-LABEL "Mensagem" VIEW-AS EDITOR SIZE 90 BY 1
    FIELD cod-estabel        LIKE nota-fiscal.cod-estabel
    FIELD serie              LIKE nota-fiscal.serie
    FIELD nr-nota-fis        LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-el         LIKE nota-fiscal.nr-nota-fis
    FIELD c-arquivo          AS CHAR FORMAT "x(40)".
