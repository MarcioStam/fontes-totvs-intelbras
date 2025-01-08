/*------------------------------------------------------------------------
    File        : ESAPB029.P
    Purpose     : Informar o pagamento … Pinho do Processo de Embarque,
                  fornecendo o N£mero da Remessa e o Processo de Embarque.
    Procedure   : informarPagamentoPorEmbarque

    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Mar‡o de 2013
    Notes       : Consumer: Intelbras, Provider: Pinho
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE WSDL         http://gfo.pinho.com.br:8383/GFOService/remessaFacade?wsdl
&GLOBAL-DEFINE PORTTYPE     RemessaFacade
&GLOBAL-DEFINE OPERATION    informarPagamentoPorEmbarque

/* Includes Definitions ---                                             */

/* Defini‡Æo da Temp-Table "tt_mensagem" */
{esp/apb/esapb029.i}

/* Defini‡Æo da Temp-Table "tt-prog-ponto" */
{esp/es0018.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p_remessa           AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p_processo_embarque AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt_mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt_mensagem.

RUN pi_valida_base_erp IN THIS-PROCEDURE.

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RUN pi_consumir_webservice IN THIS-PROCEDURE.

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi_valida_base_erp PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Validar se a base do Datasul EMS ‚ de Produ‡Æo. Caso seja de
               testes, o programa ser  abortado.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-teste AS LOGICAL     NO-UNDO INITIAL YES.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "ambiente":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAILABLE tt-prog-ponto AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
        ASSIGN l-teste = NO.
    ELSE
        ASSIGN l-teste = YES.

    IF l-teste THEN DO:
        RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                INPUT "Sistema":U,
                                                INPUT "Integra‡Æo nÆo permitida!":U,
                                                INPUT "NÆo ‚ permitida a integra‡Æo com a Pinho em ambiente de Teste/Homologa‡Æo.":U).

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_consumir_webservice PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Consumir o Web Service da Pinho.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_server    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_port_type AS HANDLE      NO-UNDO.

    DEFINE VARIABLE i_count_errors AS INTEGER     NO-UNDO.

    CREATE SERVER h_server.

    IF NOT VALID-HANDLE(h_server) THEN DO:
        RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                INPUT "Sistema":U,
                                                INPUT "Erro ao criar o Servidor do WebService!":U,
                                                INPUT "Erro ao criar o Servidor do WebService da Pinho.":U + CHR(10) + "Favor entrar em contato com a TIC da Intelbras.":U).

        ASSIGN h_server = ?.

        RETURN "NOK":U.
    END.

    h_server:CONNECT("-WSDL '{&WSDL}'":U) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        DO i_count_errors = 1 TO ERROR-STATUS:NUM-MESSAGES:
            RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                    INPUT "Sistema":U,
                                                    INPUT "Erro ao conectar com o WSDL!":U,
                                                    INPUT ERROR-STATUS:GET-MESSAGE(i_count_errors) + CHR(10) + "Favor entrar em contato com a TIC da Intelbras.":U).
        END.

        IF VALID-HANDLE(h_server) THEN
            DELETE OBJECT h_server.

        ASSIGN h_server = ?.

        RETURN "NOK":U.
    END.

    RUN {&PORTTYPE} SET h_port_type ON SERVER h_server NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        DO i_count_errors = 1 TO ERROR-STATUS:NUM-MESSAGES:
            RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                    INPUT "Sistema":U,
                                                    INPUT "Erro ao conectar ao PortType ~"{&PORTTYPE}~" do WebService!":U,
                                                    INPUT ERROR-STATUS:GET-MESSAGE(i_count_errors) + CHR(10) + "Favor entrar em contato com a TIC da Intelbras.":U).
        END.

        IF VALID-HANDLE(h_port_type) THEN
            DELETE OBJECT h_port_type.

        ASSIGN h_port_type = ?.

        IF VALID-HANDLE(h_server) THEN
            h_server:DISCONNECT().

        IF VALID-HANDLE(h_server) THEN
            DELETE OBJECT h_server.

        ASSIGN h_server = ?.

        RETURN "NOK":U.
    END.

    RUN {&OPERATION} IN h_port_type (INPUT p_remessa,
                                     INPUT p_processo_embarque) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        IF VALID-HANDLE(ERROR-STATUS:ERROR-OBJECT-DETAIL) THEN DO:
            RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                    INPUT "Negocio":U,
                                                    INPUT ERROR-STATUS:ERROR-OBJECT-DETAIL:SOAP-FAULT-STRING,
                                                    INPUT "Remessa: ":U + p_remessa + " / Processo Embarque: ":U + p_processo_embarque + ".":U).
        END.
        ELSE DO:
            DO i_count_errors = 1 TO ERROR-STATUS:NUM-MESSAGES:
                RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                        INPUT "Sistema":U,
                                                        INPUT "Erro ao executar Opera‡Æo ~"{&OPERATION}~" do WebService!":U,
                                                        INPUT ERROR-STATUS:GET-MESSAGE(i_count_errors) + CHR(10) + "Favor entrar em contato com a TIC da Intelbras.":U).
            END.
        END.

        IF VALID-HANDLE(h_port_type) THEN
            DELETE OBJECT h_port_type.

        ASSIGN h_port_type = ?.

        IF VALID-HANDLE(h_server) THEN
            h_server:DISCONNECT().

        IF VALID-HANDLE(h_server) THEN
            DELETE OBJECT h_server.

        ASSIGN h_server = ?.

        RETURN "NOK":U.
    END.
    ELSE
        RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 4, /* Informa‡Æo */
                                                INPUT "Negocio":U,
                                                INPUT "Confirma‡Æo de pagamento realizada com sucesso!":U,
                                                INPUT "Confirma‡Æo de pagamento com a Pinho realizada com sucesso!" + CHR(10) + "Remessa: ":U + p_remessa + " / Processo Embarque: ":U + p_processo_embarque + ".":U).

    IF VALID-HANDLE(h_port_type) THEN
        DELETE OBJECT h_port_type.

    ASSIGN h_port_type = ?.

    IF VALID-HANDLE(h_server) THEN
        h_server:DISCONNECT().

    IF VALID-HANDLE(h_server) THEN
        DELETE OBJECT h_server.

    ASSIGN h_server = ?.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_cria_mensagem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Criar o registro de mensagem na temp-table "tt_mensagem".
  Parameters:  p_tipo (Inteiro), p_subtipo (Caract‚r), p_descricao (Caract‚r) e
               p_ajuda (Caract‚r).
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_tipo      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p_subtipo   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p_descricao AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p_ajuda     AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i_sequencia LIKE tt_mensagem.sequencia NO-UNDO.

    FIND LAST tt_mensagem NO-ERROR.

    ASSIGN i_sequencia = IF AVAILABLE tt_mensagem THEN tt_mensagem.sequencia + 1 ELSE 1.

    CREATE tt_mensagem.
    ASSIGN tt_mensagem.sequencia = i_sequencia
           tt_mensagem.subtipo   = p_subtipo
           tt_mensagem.descricao = p_descricao
           tt_mensagem.ajuda     = p_ajuda.

    CASE p_tipo :
        WHEN 2 THEN
            ASSIGN tt_mensagem.tipo = "Aviso":U.
        WHEN 3 THEN
            ASSIGN tt_mensagem.tipo = "Pergunta":U.
        WHEN 4 THEN
            ASSIGN tt_mensagem.tipo = "Informacao":U.
        OTHERWISE
            ASSIGN tt_mensagem.tipo = "Erro":U.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

