/******************************************************************************
**
**  Programa......: ESACR043.P
**  Objetivo......: Retornar os dias de atraso dos t¡tulos de clientes, baseado
**                  na raiz do CNPJ.
**
**  Autor(es).....: Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
**  Cria‡Æo.......: 05 de Outubro de 2011
**
*******************************************************************************/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-raiz-cnpj       AS CHARACTER                   NO-UNDO.
DEFINE INPUT  PARAMETER p-nome-matriz     AS CHARACTER                   NO-UNDO.
DEFINE INPUT  PARAMETER p-lim-dias-atraso AS INTEGER                     NO-UNDO.
DEFINE OUTPUT PARAMETER p-dias-atraso-tit AS INTEGER                     NO-UNDO INITIAL 0.
DEFINE OUTPUT PARAMETER p-tit-atrasado    AS LOGICAL                     NO-UNDO INITIAL NO.
DEFINE OUTPUT PARAMETER p-lista-clientes  AS CHARACTER FORMAT 'x(100)':U NO-UNDO.

/* Includes Definitions ---                                             */

{esinc/es0000.i} /* Vari veis Globais - Buscar a empresa corrente */

DEFINE TEMP-TABLE ttClientesAtraso NO-UNDO
    FIELD cod-cliente LIKE tit_acr.cdn_cliente.

/* ***************************  Main Block  *************************** */

FIND FIRST int-emitente-supcard NO-LOCK
    WHERE  int-emitente-supcard.raiz-cnpj      = p-raiz-cnpj
    AND    int-emitente-supcard.dat-avaliacao  = TODAY
    AND    int-emitente-supcard.log-habilitado = YES NO-ERROR.
IF  NOT AVAIL int-emitente-supcard THEN DO:
    ASSIGN p-tit-atrasado = NO.

    RETURN "OK":U.
END.

EMPTY TEMP-TABLE ttClientesAtraso NO-ERROR.

bk-estab-emitente:
FOR EACH estabelecimento NO-LOCK
    WHERE estabelecimento.cod_empresa = v_cod_empres_usuar,
    EACH emitente USE-INDEX ch-matriz NO-LOCK
    WHERE emitente.nome-matriz = p-nome-matriz:

    IF SUBSTRING(emitente.cgc, 1, 8) <> SUBSTRING(p-raiz-cnpj, 1, 8) THEN NEXT bk-estab-emitente.

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
               tit_acr.cod_cart_bcia <> "99":U THEN NEXT bk-titulo.
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

            /*RETURN "OK":U.*/

            IF  NOT CAN-FIND(FIRST ttClientesAtraso
                             WHERE ttClientesAtraso.cod-cliente = tit_acr.cdn_cliente) THEN DO:
                CREATE ttClientesAtraso.
                ASSIGN ttClientesAtraso.cod-cliente = tit_acr.cdn_cliente.
            END. /* IF  NOT CAN-FIND(FIRST ttClientesAtraso */
        END.
    END.
END.

IF  CAN-FIND(FIRST ttClientesAtraso) THEN
    FOR EACH ttClientesAtraso:
        IF  p-lista-clientes = "" 
        THEN ASSIGN p-lista-clientes = STRING(ttClientesAtraso.cod-cliente).
        ELSE ASSIGN p-lista-clientes = p-lista-clientes + STRING(ttClientesAtraso.cod-cliente) + CHR(13).
    END. /* FOR EACH ttClientesAtraso: */

RETURN "OK":U.

