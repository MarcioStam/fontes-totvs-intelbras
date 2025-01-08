/******************************************************************************
**
**  Programa......: ESACR061.P
**  Objetivo......: Retornar os dias de atraso dos t¡tulos de clientes, baseado
**                  na matriz.
**
**  Autor(es).....: Fabiano Sakae Ribeiro (Exponencial TI)
**  Cria‡Æo.......: 05 de Junho de 2013
**
*******************************************************************************/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-nome-matriz     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-lim-dias-atraso AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER p-dias-atraso-tit AS INTEGER     NO-UNDO INITIAL 0.
DEFINE OUTPUT PARAMETER p-tit-atrasado    AS LOGICAL     NO-UNDO INITIAL NO.

/* Includes Definitions ---                                             */

{esinc/es0000.i} /* Vari veis Globais - Buscar a empresa corrente */


/* ***************************  Main Block  *************************** */

bk-estab-emitente:
FOR EACH estabelecimento NO-LOCK
    WHERE estabelecimento.cod_empresa = v_cod_empres_usuar,
    EACH emitente USE-INDEX ch-matriz NO-LOCK
    WHERE emitente.nome-matriz = p-nome-matriz:

    bk-titulo:
    FOR EACH tit_acr USE-INDEX titacr_cliente NO-LOCK
        WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
          AND tit_acr.cdn_cliente         = emitente.cod-emitente
          AND tit_acr.log_sdo_tit_acr     = YES
          AND tit_acr.log_tit_acr_estordo = NO:

        IF tit_acr.cod_espec_docto <> "DM":U AND
           tit_acr.cod_espec_docto <> "VD":U AND
           tit_acr.cod_espec_docto <> "VE":U THEN NEXT bk-titulo.

        FIND FIRST emscad.portador
            WHERE emscad.portador.cod_portador = tit_acr.cod_portador NO-LOCK NO-ERROR.

        IF NOT AVAILABLE emscad.portador THEN NEXT bk-titulo.

        IF emscad.portador.ind_tip_portad <> "Banco":U AND
           emscad.portador.ind_tip_portad <> "Caixa":U THEN NEXT bk-titulo.

        IF emscad.portador.ind_tip_portad = "Caixa":U THEN DO:
            IF tit_acr.cod_portador <> "999":U THEN NEXT bk-titulo.

            IF tit_acr.cod_cart_bcia <> "00":U AND
               tit_acr.cod_cart_bcia <> "90":U THEN NEXT bk-titulo.
        END.

        IF tit_acr.cod_portador = "9996":U THEN NEXT bk-titulo.

        IF tit_acr.dat_vencto_tit_acr = tit_acr.dat_emis_docto THEN NEXT bk-titulo.

        IF tit_acr.cod_cart_bcia = "70":U OR
           tit_acr.cod_cart_bcia = "71":U OR 
           tit_acr.cod_cart_bcia = "01":U THEN NEXT bk-titulo.

        IF tit_acr.dat_indcao_perda_dedut <> 12/31/9999 THEN NEXT bk-titulo.

        IF p-lim-dias-atraso < (TODAY - tit_acr.dat_vencto_tit_acr) THEN DO:
            ASSIGN p-dias-atraso-tit = TODAY - tit_acr.dat_vencto_tit_acr
                   p-tit-atrasado    = YES.

            RETURN "OK":U.
        END.
    END.
END.

RETURN "OK":U.

