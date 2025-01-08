/*****************************************************************************
** Programa: esp/mssp/esmssp012.p
** Vers∆o..: 1.00
** Data....: 15/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa respons†vel pela integraá∆o do item (Inclus∆o e Alteraá∆o)
*****************************************************************************/
DEFINE TEMP-TABLE tt-item-fabric NO-UNDO
    FIELD cod-fabric as inte
    FIELD it-fabric  as char
    FIELD referencia as char.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tip-msgs AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD mensagem AS CHARACTER FORMAT "x(250)":U.

DEFINE INPUT  PARAMETER pTipoRequisicao    AS INTEGER     NO-UNDO. /* 1- Inclus∆o  2- Alteraá∆o */
DEFINE INPUT  PARAMETER pItemMessage       AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-item-fabric.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.

DEFINE VARIABLE c-usuario AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-senha   AS CHARACTER NO-UNDO.

run esp/mssp/esmssp012a.p(output c-usuario, 
                          output c-senha).

RUN bi/esbi002.p (INPUT c-usuario,
                  INPUT c-senha).

run esp/mssp/esmssp012b.p(input pTipoRequisicao,
                          input pItemMessage,   
                          input table tt-item-fabric,
                         output table tt-mensagem).
