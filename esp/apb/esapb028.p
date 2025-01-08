/*------------------------------------------------------------------------
    File        : ESAPB028.P
    Purpose     : Buscar os Processos de Embarque no Web Service da Pinho,
                  fornecendo o N£mero da Remessa.
    Procedure   : getListaReferenciasPorRemessa

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
&GLOBAL-DEFINE OPERATION    getListaReferenciasPorRemessa

/* Includes Definitions ---                                             */

/* Defini‡Æo das Temp-Tables "tt_processo_embarque" e "tt_mensagem" */
{esp/apb/esapb028.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lg_xml AS LONGCHAR    NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p_remessa AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt_processo_embarque.
DEFINE OUTPUT PARAMETER TABLE FOR tt_mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt_processo_embarque.
EMPTY TEMP-TABLE tt_mensagem.

RUN pi_consumir_webservice IN THIS-PROCEDURE.

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RUN pi_ler_xml IN THIS-PROCEDURE.

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF NOT CAN-FIND(FIRST tt_processo_embarque) THEN DO:
    RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                            INPUT "A Remessa informada nÆo possui Processos de Embarque atrelados a ela":U,
                                            INPUT "":U).

    RETURN "NOK":U.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi_consumir_webservice PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Consumir o Web Service da Pinho.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_server    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_port_type AS HANDLE      NO-UNDO.

    DEFINE VARIABLE i_count_errors AS INTEGER     NO-UNDO.

    CREATE SERVER h_server.

    IF NOT VALID-HANDLE(h_server) THEN DO:
        RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                INPUT "Erro ao criar o Servidor do WebService!":U,
                                                INPUT "Erro ao criar o Servidor do WebService da Pinho.":U + CHR(10) + "Favor entrar em contato com a TIC da Intelbras.":U).

        ASSIGN h_server = ?.

        RETURN "NOK":U.
    END.

    h_server:CONNECT("-WSDL '{&WSDL}'":U) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        DO i_count_errors = 1 TO ERROR-STATUS:NUM-MESSAGES:
            RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
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

    RUN {&OPERATION} IN h_port_type (INPUT  p_remessa,
                                     OUTPUT lg_xml) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        IF VALID-HANDLE(ERROR-STATUS:ERROR-OBJECT-DETAIL) THEN DO:
            RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                    INPUT ERROR-STATUS:ERROR-OBJECT-DETAIL:SOAP-FAULT-STRING,
                                                    INPUT "":U).
        END.
        ELSE DO:
            DO i_count_errors = 1 TO ERROR-STATUS:NUM-MESSAGES:
                RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
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

PROCEDURE pi_ler_xml PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Realizar a leitura do XML retornado pelo Web Service da Pinho.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_doc      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_root     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_processo AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_child    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h_text     AS HANDLE      NO-UNDO.

    DEFINE VARIABLE i_count_root     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_count_processo AS INTEGER     NO-UNDO.

    IF lg_xml = "":U THEN DO:
        RUN pi_cria_mensagem IN THIS-PROCEDURE (INPUT 1, /* Erro */
                                                INPUT "XML de retorno do WebService est  vazio!":U,
                                                INPUT "XML de retorno do WebService da Pinho est  vazio.":U).

        RETURN "NOK":U.
    END.

    CREATE X-DOCUMENT h_doc.
    CREATE X-NODEREF h_root.
    CREATE X-NODEREF h_processo.
    CREATE X-NODEREF h_child.
    CREATE X-NODEREF h_text.

    h_doc:LOAD("LONGCHAR":U, lg_xml, FALSE).
    h_doc:GET-DOCUMENT-ELEMENT(h_root).

    REPEAT i_count_root = 1 TO h_root:NUM-CHILDREN:
        h_root:GET-CHILD(h_processo, i_count_root).

        IF h_processo:NAME = "processoCliente":U THEN DO:
            CREATE tt_processo_embarque.
            ASSIGN tt_processo_embarque.processo_embarque = ?.

            REPEAT i_count_processo = 1 TO h_processo:NUM-CHILDREN:
                h_processo:GET-CHILD(h_child, i_count_processo).

                IF h_child:NAME = "idProcesso":U THEN DO:
                    h_child:GET-CHILD(h_text, 1).

                    ASSIGN tt_processo_embarque.processo_embarque = h_text:NODE-VALUE.
                END.

                IF h_child:NAME = "valorProcesso":U THEN DO:
                    h_child:GET-CHILD(h_text, 1).

                    ASSIGN tt_processo_embarque.valor_embarque = DECIMAL(REPLACE(REPLACE(h_text:NODE-VALUE, ",":U, "":U), ".":U, ",":U)).
                END.
            END.

            IF tt_processo_embarque.processo_embarque = ? THEN
                DELETE tt_processo_embarque.

            RELEASE tt_processo_embarque.
        END.
    END.

    DELETE OBJECT h_text.
    DELETE OBJECT h_child.
    DELETE OBJECT h_processo.
    DELETE OBJECT h_root.
    DELETE OBJECT h_doc.

    ASSIGN h_text     = ?
           h_child    = ?
           h_processo = ?
           h_root     = ?
           h_doc      = ?.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_cria_mensagem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Criar o registro de mensagem na temp-table "tt_mensagem".
  Parameters:  p_tipo (Inteiro), p_descricao (Caract‚r) e p_ajuda (Caract‚r).
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_tipo      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p_descricao AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p_ajuda     AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i_sequencia LIKE tt_mensagem.sequencia NO-UNDO.

    FIND LAST tt_mensagem NO-ERROR.

    ASSIGN i_sequencia = IF AVAILABLE tt_mensagem THEN tt_mensagem.sequencia + 1 ELSE 1.

    CREATE tt_mensagem.
    ASSIGN tt_mensagem.sequencia = i_sequencia
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

