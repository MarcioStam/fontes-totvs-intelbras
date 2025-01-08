/*********************************************************************************
** Programa: esp/ftp/esftp078.i
** Vers∆o..: 1.00
** Data....: 28/10/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o da Temp-Table de ParÉmetros
*********************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD cod-transp-ini   LIKE canhoto-nf.cod-transp
    FIELD cod-transp-fim   LIKE canhoto-nf.cod-transp
    FIELD cod-caixa-ini    LIKE canhoto-nf.cod-caixa
    FIELD cod-caixa-fim    LIKE canhoto-nf.cod-caixa
    FIELD cod-envelope-ini LIKE canhoto-nf.cod-envelope
    FIELD cod-envelope-fim LIKE canhoto-nf.cod-envelope
    FIELD cod-estabel-ini  LIKE canhoto-nf.cod-estabel
    FIELD cod-estabel-fim  LIKE canhoto-nf.cod-estabel
    FIELD serie-ini        LIKE canhoto-nf.serie
    FIELD serie-fim        LIKE canhoto-nf.serie
    FIELD nr-nota-fis-ini  LIKE canhoto-nf.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE canhoto-nf.nr-nota-fis
    FIELD tipo-canhotos    AS INTEGER
    FIELD email-transp     AS LOGICAL.
