/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESSDCV003RP 2.06.00.000}
/*------------------------------------------------------------------------
    File        : ESSDCV003RP.P
    Purpose     : Exportar informaá∆o para o OutBuyCenter (SDCV).
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Julho de 2013
    Notes       : <none>
----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

/* Preprocessador para definir impress∆o dos parÉmetros */
&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Definiá∆o da temp-table ttRawTabela */
{esp/sdcv/essdcv001api.i}

/* Definiá∆o das temp-tables tt-param, tt-digita e tt-raw-digita */
{esp/sdcv/essdcv003.i}

/* Definiá∆o das procedure internas pi-cria-mensagem e
   pi-cria-mensagem-pela-RowErrors */
{esp/sdcv/essdcv003rp.i}

/* Definiá∆o das vari†veis de relat¢rio */
{include/i-rpvar.i}

/* Local Variable Definitions ---                                       */
{upc/btb910za-upc.i}
{esp/sdcv/essdcv001api.i2}

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

FORM tt-mensagem.registro
     tt-mensagem.tipo-mensagem
     tt-mensagem.mensagem
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-mensagem.

FORM "SELEÄ«O":U               AT 10 SKIP(1)
     tt-param.l-centro-custo         COLON 35 LABEL "Centro de Custo":U                                     SKIP
     tt-param.l-conta-contabil       COLON 35 LABEL "Conta Cont†bil":U                                      SKIP
     tt-param.l-plano-contas         COLON 35 LABEL "Plano de Contas":U                                     SKIP
     tt-param.l-fornecedores         COLON 35 LABEL "Fornecedores":U                                        SKIP
     tt-param.l-classificacao-fiscal COLON 35 LABEL "Classificaá∆o Fiscal":U                                SKIP
     tt-param.l-condicao-pagamento   COLON 35 LABEL "Condiá∆o de Pagamento":U                               SKIP
     tt-param.l-mensagem             COLON 35 LABEL "Mensagem":U                                            SKIP
     tt-param.l-cotacao-moeda        COLON 35 LABEL "Cotaá∆o de Moeda":U                                    SKIP
     tt-param.c-cotacao-inicial      COLON 40 LABEL "Per°odo":U
     "|< >|":U                          AT 50
     tt-param.c-cotacao-final           AT 56 NO-LABEL                                                      SKIP
     tt-param.l-feriado              COLON 35 LABEL "Feriado":U                                             SKIP
     tt-param.i-feriado-inicial      COLON 40 LABEL "Per°odo":U
     "|< >|":U                          AT 50
     tt-param.i-feriado-final           AT 56 NO-LABEL                                                      SKIP(2)
     "IMPRESS«O":U             AT 10 SKIP(1)
     c-destino              COLON 20 LABEL "Destino":U "-":U tt-param.arquivo NO-LABEL SKIP
     tt-param.usuario       COLON 20 LABEL "Usu†rio":U
    WITH WIDTH 132 SIDE-LABELS FRAME f-param STREAM-IO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

DEF TEMP-TABLE tt-emitente-raw NO-UNDO LIKE emitente.
DEF TEMP-TABLE tt-cotacao-raw  NO-UNDO LIKE cotacao.
/* ************************  Function Prototypes ********************** */

/* FUNCTION fn-function RETURNS CHARACTER */
/*   (  )  FORWARD.                       */


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "Espec°fico Intelbras":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i &STREAM="str-rp"}
    {include/i-rpout.i &STREAM="STREAM str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-exportacao IN THIS-PROCEDURE.

    &IF DEFINED(PRINT-PARAM) <> 0 AND "{&PRINT-PARAM}":U = "YES":U &THEN
    RUN pi-parametro IN THIS-PROCEDURE.
    &ENDIF

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-exportacao :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF tt-param.l-centro-custo         THEN RUN pi-exp-centro-custo       IN THIS-PROCEDURE.
    IF tt-param.l-conta-contabil       THEN RUN pi-exp-conta-contabil     IN THIS-PROCEDURE.
    IF tt-param.l-plano-contas         THEN RUN pi-exp-plano-contas       IN THIS-PROCEDURE.
    IF tt-param.l-fornecedores         THEN RUN pi-exp-fornecedores       IN THIS-PROCEDURE.
    IF tt-param.l-classificacao-fiscal THEN RUN pi-exp-classif-fiscal     IN THIS-PROCEDURE.
    IF tt-param.l-condicao-pagamento   THEN RUN pi-exp-condicao-pagamento IN THIS-PROCEDURE.
    IF tt-param.l-mensagem             THEN RUN pi-exp-mensagem           IN THIS-PROCEDURE.
    IF tt-param.l-cotacao-moeda        THEN RUN pi-exp-cotacao-moeda      IN THIS-PROCEDURE.
    IF tt-param.l-feriado              THEN RUN pi-exp-feriado            IN THIS-PROCEDURE.

    IF  CAN-FIND(FIRST tt-mensagem) THEN DO:
        PAGE STREAM str-rp.

        FOR EACH tt-mensagem:
            DISPLAY STREAM str-rp
                    tt-mensagem.registro
                    tt-mensagem.tipo-mensagem
                    tt-mensagem.mensagem
                WITH FRAME f-mensagem.
            DOWN STREAM str-rp WITH FRAME f-mensagem.
        END. /* FOR EACH tt-mensagem: */
    END. /* IF  CAN-FIND(FIRST tt-mensagem) THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-centro-custo :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de centros de custo cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
   ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Centro Custo...":U).

    FOR EACH emscad.ccusto_unid_negoc NO-LOCK:
        EMPTY TEMP-TABLE ttRawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + TRIM(emscad.ccusto_unid_negoc.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).

        CREATE ttRawTabela.
        RAW-TRANSFER emscad.ccusto_unid_negoc TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integ. Centro Custo: ":U + TRIM(emscad.ccusto_unid_negoc.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).

        RUN esp/sdcv/essdcv001api.p (INPUT  "centro-custo":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Centro Custo":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Centro Custo":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-centro-custo */

PROCEDURE pi-exp-classif-fiscal :
/*------------------------------------------------------------------------------
  Purpose:     Exportar Classificaá∆o Fiscal (NCM).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Classif. Fiscal...":U).

    FOR EACH classif-fisc NO-LOCK:
        EMPTY TEMP-TABLE ttRawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Classif. Fiscal: ":U + TRIM(STRING(classif-fisc.class-fiscal, "9999.99.99":U))).

        CREATE ttRawTabela.
        RAW-TRANSFER classif-fisc TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integrando Clas. Fisc.: ":U + TRIM(STRING(classif-fisc.class-fiscal, "9999.99.99":U))).

        RUN esp/sdcv/essdcv001api.p (INPUT  "classif-fisc":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Classificaá∆o Fiscal":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Classificaá∆o Fiscal":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-condicao-pagamento :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Condiá∆o Pagamento...":U).

    FOR EACH cond-pagto NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Condiá∆o Pagamento: ":U + TRIM(STRING(cond-pagto.cod-cond-pag, ">>>9":U))).

        CREATE ttRawTabela.
        RAW-TRANSFER cond-pagto TO ttRawTabela.rawTabela.

    END. /* FOR EACH cond-pagto NO-LOCK: */

    RUN esp/sdcv/essdcv001api.p (INPUT  "cond-pagto":U,
                                 INPUT  "I":U,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Condiá∆o Pagamento":U).

    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Condiá∆o Pagamento":U,
                                            INPUT "Informaá∆o":U,
                                            INPUT "Foram exportados os registros com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-conta-contabil :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de contas cont†beis cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Conta Cont†bil...":U).

    FOR EACH cta_ctbl NO-LOCK:
        EMPTY TEMP-TABLE ttRawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont†bil: ":U + TRIM(cta_ctbl.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        CREATE ttRawTabela.
        RAW-TRANSFER cta_ctbl TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integ. Conta Cont†bil: ":U + TRIM(cta_ctbl.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        RUN esp/sdcv/essdcv001api.p (INPUT  "conta-contab":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Conta Cont†bil":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Conta Cont†bil":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-conta-contabil */

PROCEDURE pi-exp-cotacao-moeda :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.
    
    /************************************* ATENÄ«O **********************************
    Conforme chamado: 45035, foi criado um novo programa (essdcv008) para integrar as cotaá‰es 
    de acordo com a data informada e nao mais pelo per°odo. 
    *********************************************************************************/

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Cotaá∆o Moeda...":U).

    FOR EACH cotacao NO-LOCK
        WHERE cotacao.ano-periodo >= tt-param.c-cotacao-inicial
          AND cotacao.ano-periodo <= tt-param.c-cotacao-final:
        EMPTY TEMP-TABLE ttRawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Cotaá∆o Moeda: ":U + TRIM(STRING(cotacao.mo-codigo, ">9":U)) + " - ":U + TRIM(STRING(cotacao.ano-periodo, "9999/99":U))).

        EMPTY TEMP-TABLE tt-cotacao-raw.
        CREATE tt-cotacao-raw.
        BUFFER-COPY cotacao TO tt-cotacao-raw.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-cotacao-raw TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integ. Cotaá∆o Moeda: ":U + TRIM(STRING(cotacao.mo-codigo, ">9":U)) + " - ":U + TRIM(STRING(cotacao.ano-periodo, "9999/99":U))).

        RUN esp/sdcv/essdcv001api.p (INPUT  "cotacao":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Cotaá∆o Moeda":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Cotaá∆o Moeda":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-feriado :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de feriados cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Feriado...":U).

    FOR EACH dia_calend_glob NO-LOCK
        WHERE dia_calend_glob.dat_calend >= DATE(01, 01, tt-param.i-feriado-inicial)
          AND dia_calend_glob.dat_calend <= DATE(12, 31, tt-param.i-feriado-final):
        EMPTY TEMP-TABLE ttRawTabela.

        FIND FIRST clas_dia_calend
            WHERE clas_dia_calend.cod_clas_dia_calend = dia_calend_glob.cod_clas_dia_calend NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE clas_dia_calend                      OR
           (AVAILABLE clas_dia_calend                          AND
            clas_dia_calend.ind_tip_dia_calend <> "Feriado":U) THEN
            NEXT.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Feriado: ":U + TRIM(STRING(dia_calend_glob.dat_calend, "99/99/9999":U)) + " - ":U + TRIM(dia_calend_glob.des_dia_calend)).

        CREATE ttRawTabela.
        RAW-TRANSFER dia_calend_glob TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integrando Feriado: ":U + TRIM(STRING(dia_calend_glob.dat_calend, "99/99/9999":U)) + " - ":U + TRIM(dia_calend_glob.des_dia_calend)).

        RUN esp/sdcv/essdcv001api.p (INPUT  "dia_calend_glob":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Feriado":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Feriado":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-feriado */

PROCEDURE pi-exp-fornecedores :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Fornecedores...":U).

    FOR EACH  emitente NO-LOCK
        WHERE emitente.identific > 1:
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Fornecedores: ":U + TRIM(STRING(emitente.cod-emitente, ">>>>>>>>9":U)) + " - ":U + TRIM(emitente.nome-abrev)).

        //apenas para n∆o dar erro de raw-transfer apos vers∆o 12.1.25
        empty temp-table tt-emitente-raw.
        CREATE tt-emitente-raw.
        BUFFER-COPY emitente TO tt-emitente-raw.
        //

        CREATE ttRawTabela.
        //RAW-TRANSFER emitente TO ttRawTabela.rawTabela.
        RAW-TRANSFER tt-emitente-raw TO ttRawTabela.rawTabela.
    END. /* FOR EACH  emitente NO-LOCK */

    RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                 INPUT  "I":U,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Fornecedores":U).

    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Fornecedores":U,
                                            INPUT "Informaá∆o":U,
                                            INPUT "Foram exportados os registros com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Mensagens...":U).

    FOR EACH mensagem NO-LOCK:
        EMPTY TEMP-TABLE ttRawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mensagem: ":U + TRIM(STRING(mensagem.cod-mensagem, ">>9":U)) + " - ":U + TRIM(mensagem.descricao)).

        CREATE ttRawTabela.
        RAW-TRANSFER mensagem TO ttRawTabela.rawTabela.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Integ. Mensagens: ":U + TRIM(STRING(mensagem.cod-mensagem, ">>9":U)) + " - ":U + TRIM(mensagem.descricao)).

        RUN esp/sdcv/essdcv001api.p (INPUT  "mensagem":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
            RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Mensagens":U).
        ELSE
            ASSIGN i-cont-exportado = i-cont-exportado + 1.
    END.

    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Mensagens":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-plano-contas :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de planos de conta cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    EMPTY TEMP-TABLE tt-plano-aux NO-ERROR.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Plano Contas...":U).

    FOR FIRST plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl,
        EACH  cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl,
        FIRST criter_distrib_cta_ctbl NO-LOCK
        WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
        AND   criter_distrib_cta_ctbl.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
        AND   criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_usuar:

        IF   criter_distrib_cta_ctbl.dat_inic_valid > TODAY
        OR   criter_distrib_cta_ctbl.dat_fim_valid  < TODAY THEN NEXT.

        IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Plano: " + string(plano_cta_ctbl.cod_plano_cta_ctbl) + 
                                                                           " Ct.Ctbl: " + string(cta_ctbl.cod_cta_ctbl)).

        CASE criter_distrib_cta_ctbl.ind_criter_distrib_ccusto:
            WHEN "N∆o Utiliza":U THEN DO:
                CREATE tt-plano-aux.
                ASSIGN tt-plano-aux.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                       tt-plano-aux.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                       tt-plano-aux.cod_unid_negoc     = ""
                       tt-plano-aux.cod_ccusto         = "".
            END.
            WHEN "Utiliza Todos":U THEN DO:
                FOR EACH  emscad.ccusto_unid_negoc NO-LOCK
                    WHERE emscad.ccusto_unid_negoc.cod_empresa      = v_cod_empres_usuar
                    AND   emscad.ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto:
                    CREATE tt-plano-aux.
                    ASSIGN tt-plano-aux.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                           tt-plano-aux.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                           tt-plano-aux.cod_unid_negoc     = emscad.ccusto_unid_negoc.cod_unid_negoc
                           tt-plano-aux.cod_ccusto         = emscad.ccusto_unid_negoc.cod_ccusto.
                END.
            END.
            WHEN "Definidos":U THEN DO:
                FOR EACH  mapa_distrib_ccusto NO-LOCK
                    WHERE mapa_distrib_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab
                    AND   mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto,
                    EACH  emscad.ccusto_unid_negoc NO-LOCK
                    WHERE emscad.ccusto_unid_negoc.cod_empresa      = mapa_distrib_ccusto.cod_empresa
                    AND   emscad.ccusto_unid_negoc.cod_plano_ccusto = mapa_distrib_ccusto.cod_plano_ccusto:
                    CREATE tt-plano-aux.
                    ASSIGN tt-plano-aux.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                           tt-plano-aux.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                           tt-plano-aux.cod_unid_negoc     = emscad.ccusto_unid_negoc.cod_unid_negoc
                           tt-plano-aux.cod_ccusto         = emscad.ccusto_unid_negoc.cod_ccusto.
                END.
            END.
        END CASE.
    END. /* FOR EACH  plano_cta_ctbl NO-LOCK */

    release plano_cta_ctbl.
    release cta_ctbl.
    release criter_distrib_cta_ctbl.
    release emscad.ccusto_unid_negoc.
    release mapa_distrib_ccusto.

    FOR EACH tt-plano-aux:
        
        EMPTY TEMP-TABLE ttRawTabela.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-plano-aux TO ttRawTabela.rawTabela.

        IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Pl. " + string(tt-plano-aux.cod_plano_cta_ctbl) + " Ct.Ctbl: " + string(tt-plano-aux.cod_cta_ctbl) + " CC:" + string(tt-plano-aux.cod_unid_negoc) + string(tt-plano-aux.cod_ccusto)).

        RUN esp/sdcv/essdcv001api.p (INPUT  "plano-conta-conta-contabil":U,
                                     INPUT  "I":U,
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).

        IF  CAN-FIND(FIRST RowErrors) 
        THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Plano Contas":U).
        ELSE ASSIGN i-cont-exportado = i-cont-exportado + 1.

        DELETE tt-plano-aux.

    END. /* FOR EACH tt-plano-aux: */

    IF  i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Plano Contas":U,
                                                INPUT "Informaá∆o":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-plano-contas */

PROCEDURE pi-parametro :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo ParÉmetro...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando...":U).

    PAGE STREAM str-rp.

    DISPLAY STREAM str-rp
            tt-param.l-centro-custo
            tt-param.l-conta-contabil
            tt-param.l-plano-contas
            tt-param.l-fornecedores
            tt-param.l-classificacao-fiscal
            tt-param.l-condicao-pagamento
            tt-param.l-mensagem
            tt-param.l-cotacao-moeda
            tt-param.c-cotacao-inicial
            tt-param.c-cotacao-final
            tt-param.l-feriado
            tt-param.i-feriado-inicial
            tt-param.i-feriado-final
            c-destino
            tt-param.arquivo
            tt-param.usuario
        WITH FRAME f-param.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

/* FUNCTION fn-function RETURNS CHARACTER                                           */
/*   (  ) :                                                                         */
/* /*------------------------------------------------------------------------------ */
/*   Purpose:  <none>                                                               */
/*     Notes:  <none>                                                               */
/* ------------------------------------------------------------------------------*/ */
/*     RETURN "":U.                                                                 */
/*                                                                                  */
/* END FUNCTION.                                                                    */

