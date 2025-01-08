/*****************************************************************************
** Programa.: epc/acr715zb_epc.p
** Vers∆o...: 1.00
** Data.....: 17/01/2012
** Autor....: Estevan KrÅger - Exponencial TI
** Obs......: EPC para conectar os bancos externos e chamar a EPC original
*****************************************************************************/

{esp/es0018.i}
{esp/esb/esesb000.i}

/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt_epc_estrategico NO-UNDO
    FIELD ttv_cod_epc_event        AS CHARACTER FORMAT "x(12)"
    FIELD ttv_cod_epc_parameters   AS CHARACTER FORMAT "x(32)"
    FIELD ttv_cod_epc_msg          AS CHARACTER FORMAT "x(54)"
    INDEX tt_id_epc                IS PRIMARY
          ttv_cod_epc_parameters   ASCENDING
          ttv_cod_epc_event        ASCENDING.

DEFINE TEMP-TABLE tt_erros_conexao NO-UNDO
    FIELD ttv_cdn_erro             AS INTEGER   FORMAT ">>>,>>9"
    FIELD ttv_des_erro             AS CHARACTER FORMAT "x(50)" LABEL "Inconsistància" COLUMN-LABEL "Inconsistància".

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

/*--- Definiá∆o dos ParÉmetros ---*/
DEF INPUT PARAM p_cod_evento AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt_epc_estrategico.


/*--- Definiá∆o de Vari†veis ---*/
DEF VAR v_hdl_btb_connect AS HANDLE                   NO-UNDO.
DEF VAR v_log_sucesso     AS LOGICAL                  NO-UNDO.
DEF VAR v_cod_estab       LIKE tit_acr.cod_estab      NO-UNDO.
DEF VAR v_num_id_tit_acr  LIKE tit_acr.num_id_tit_acr NO-UNDO.
DEF VAR raw-tit-acr       AS RAW                      NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_produt_corren AS CHAR FORMAT 'x(50)'                                         NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar  AS CHAR FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

/*--- Bloco Principal ---*/
IF  p_cod_evento = "Cancelamento" THEN DO:

    EMPTY TEMP-TABLE tt_tit_acr.

    FIND FIRST tt_epc_estrategico NO-LOCK
        WHERE  tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
        AND    tt_epc_estrategico.ttv_cod_epc_parameters = "C¢digo do Estabelecimento" NO-ERROR.
    
    IF  AVAIL tt_epc_estrategico THEN
        ASSIGN v_cod_estab = tt_epc_estrategico.ttv_cod_epc_msg.
    
    FIND FIRST tt_epc_estrategico NO-LOCK
        WHERE  tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
        AND    tt_epc_estrategico.ttv_cod_epc_parameters = "Num Id Titulo" NO-ERROR.
    
    IF  AVAIL tt_epc_estrategico THEN
        ASSIGN v_num_id_tit_acr = int(tt_epc_estrategico.ttv_cod_epc_msg) NO-ERROR.

    FIND FIRST tit_acr NO-LOCK
        WHERE  tit_acr.cod_estab      = v_cod_estab
        AND    tit_acr.num_id_tit_acr = v_num_id_tit_acr NO-ERROR.
    
    IF  AVAIL tit_acr THEN DO:
        
        FOR FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = tit_acr.cdn_cliente:

            RUN esp/es0018p.p (INPUT "dps-canal-cr",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

                CREATE tt_tit_acr.
                ASSIGN tt_tit_acr.cod_estab      = tit_acr.cod_estab
                       tt_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.

                RAW-TRANSFER tt_tit_acr TO raw-tit-acr.

                IF  tit_acr.ind_tip_espec_docto = "Normal" THEN DO:
                    RUN esp/esb/esesb003.p (INPUT        "msg0097",
                                            INPUT        raw-tit-acr,
                                            OUTPUT TABLE resultado) NO-ERROR.
                END.

                IF  tit_acr.ind_tip_espec_docto = "Antecipaá∆o" THEN DO:
                    RUN esp/esb/esesb003.p (INPUT        "msg0311",
                                            INPUT        raw-tit-acr,
                                            OUTPUT TABLE resultado) NO-ERROR.
                END.
            END.
        END.
    END.
    ELSE DO:
        CREATE tt_epc_estrategico.
        ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
               tt_epc_estrategico.ttv_cod_epc_parameters = "Erro"
               tt_epc_estrategico.ttv_cod_epc_msg        = "17006;T°tulo n∆o localizado !;T°tulo n∆o foi localizado !".
    
        RETURN "NOK":U.
    END.

    RETURN "OK".
END.

IF  p_cod_evento <> "Valida - Cancelamento Titulo" THEN
    RETURN.

/* Chama EPC original */
RUN epc/acr715zb2_epc.p (INPUT p_cod_evento,
                         INPUT-OUTPUT TABLE tt_epc_estrategico).


RETURN "OK".

