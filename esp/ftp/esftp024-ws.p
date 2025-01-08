/*----------------------------------------------------------------------
**  Programa..: esp/pdp/esftp024-ws.p
**  Autor.....: Rubia Ayabe de Oliveira
**  Data......: Setembro/2015 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Correios
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/ftp/esftp024-tt.i}

/* define new global shared variable cXMLDirTestFiles as character no-undo. */

/* variaveis conexao WebService */
DEFINE VARIABLE hWebService     AS HANDLE   NO-UNDO.
DEFINE VARIABLE hSigepWeb       AS HANDLE   NO-UNDO.
DEFINE VARIABLE lcSoapResult    AS LONGCHAR NO-UNDO.
DEFINE VARIABLE lcSoapResult2   AS LONGCHAR NO-UNDO.

/* variaveis de Teste/Status */
DEFINE VARIABLE iStatusOut  as integer     no-undo.
DEFINE VARIABLE cStatusOut  as character   no-undo.
DEFINE VARIABLE numeracaoEtiquetasOut  AS CHARACTER FORMAT 'x(100)' NO-UNDO. 
DEFINE VARIABLE c-InfoTratada AS CHARACTER   NO-UNDO.

/* Variaveis le retorno XML */
define variable hSoapResult         as handle   no-undo.
define variable cont1               as integer  no-undo.
define variable hAux                as handle   no-undo.
define variable hRetorno            as handle   no-undo.
define variable hValor              as handle   no-undo.

RUN conecta(output iStatusOut,
            output cStatusOut).

MESSAGE iStatusOut SKIP
        cStatusOut 
     VIEW-AS ALERT-BOX INFO BUTTONS OK.

IF iStatusOut = 1 THEN
RUN solicitaEtiquetasParam (INPUT  '82901000001441',
                            INPUT  '10',
                            OUTPUT iStatusOut,
                            OUTPUT cStatusOut,
                            OUTPUT numeracaoEtiquetasOut).

MESSAGE numeracaoEtiquetasOut
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* conecta */
procedure conecta:
    define output parameter iStatus  as integer     no-undo.
    define output parameter cStatus  as character   no-undo.

    create server hWebService.

    FIND FIRST param-sigep-web NO-LOCK NO-ERROR.
    FIND FIRST estabelec WHERE estabelec.cod-estabel = '101' NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN DO:
        IF estabelec.idi-tip-emis-nf-eletro = 3 THEN
            hWebService:connect("-WSDL '" + param-sigep-web.url-webservices + "'") no-error.
        ELSE
            hWebService:connect("-WSDL '" + param-sigep-web.url-webservices-tst + "'") no-error.
    END. /* IF AVAIL estabelec THEN DO: */
    
    if (hWebService:connected()) then do:
    
       run AtendeCliente set hSigepWeb on hWebService no-error.
       if (error-status:error) then
          assign iStatus = 98
                 cStatus = "Erro ao carregar o PortType ClienteSoap no Web Service SIGEP WEB: " + error-status:get-message(1).
       else
          assign iStatus = 1
                 cStatus = "Web Service SIGEP WEB conectado.".
    
    end. /* if (hWebService:connected()) then do: */
    else
       if (error-status:error) then
          assign iStatus = 99
                 cStatus = "Web Service SIGEP WEB nao disponivel para conexao: " + error-status:get-message(1).
       else
          assign iStatus = 97
                 cStatus = "Web Service SIGEP WEB nao disponivel para conexao, sem retornar erro".
    
end procedure.

/* conectaLogReversa */
procedure conectaLogReversa:
    define output parameter iStatus  as integer     no-undo.
    define output parameter cStatus  as character   no-undo.

    create server hWebService.

    FIND FIRST param-log-reversa NO-LOCK NO-ERROR.
    FIND FIRST estabelec WHERE estabelec.cod-estabel = '101' NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN DO:
        IF estabelec.idi-tip-emis-nf-eletro = 3 THEN
            hWebService:connect("-WSDL '" + param-log-reversa.url-webservices + "'") no-error.
        ELSE
            hWebService:connect("-WSDL '" + param-log-reversa.url-webservices-tst + "'") no-error.
    END. /* IF AVAIL estabelec THEN DO: */
    
    if (hWebService:connected()) then do:
    
       run AtendeCliente set hSigepWeb on hWebService no-error.
       if (error-status:error) then
          assign iStatus = 98
                 cStatus = "Erro ao carregar o PortType ClienteSoap no Web Service SIGEP WEB (LogReversa): " + error-status:get-message(1).
       else
          assign iStatus = 1
                 cStatus = "Web Service SIGEP WEB (LogReversa) conectado.".
    
    end. /* if (hWebService:connected()) then do: */
    else
       if (error-status:error) then
          assign iStatus = 99
                 cStatus = "Web Service SIGEP WEB (LogReversa) nao disponivel para conexao: " + error-status:get-message(1).
       else
          assign iStatus = 97
                 cStatus = "Web Service SIGEP WEB (LogReversa) nao disponivel para conexao, sem retornar erro".
    
end procedure.

/* solicitaEtiquetasParam */
PROCEDURE solicitaEtiquetasParam:

    DEFINE INPUT  PARAMETER identificador       AS CHARACTER FORMAT 'x(14)'  NO-UNDO. /*CNPJ empresa*/
    DEFINE INPUT  PARAMETER qtdEtiquetas        AS INTEGER   FORMAT '>>>>9'  NO-UNDO. 
    DEFINE OUTPUT PARAMETER iStatus             AS INTEGER                   NO-UNDO. 
    DEFINE OUTPUT PARAMETER cStatus             AS CHARACTER                 NO-UNDO. 
    DEFINE OUTPUT PARAMETER numeracaoEtiquetas  AS CHARACTER FORMAT 'x(100)' NO-UNDO. 

    DEFINE VARIABLE idServico            AS CHARACTER   NO-UNDO.

    ASSIGN idServico = ''
           cont1     = 0.

    if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do:

        FIND FIRST param-sigep-web NO-LOCK NO-ERROR.
        FIND FIRST estabelec WHERE estabelec.cod-estabel = '101' NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:

            /* Use the operation name here, and invoke it in the proxy handle */
            RUN buscaCliente IN hSigepWeb(INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.idContrato       ELSE param-sigep-web.idContrato-tst      , 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.idCartaoPostagem ELSE param-sigep-web.idCartaoPostagem-tst, 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.usuario          ELSE param-sigep-web.usuario-tst         , 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.senha            ELSE param-sigep-web.senha-tst           ,  
                                          OUTPUT lcSoapResult).

            if (error-status:error) then
               assign iStatus = 96
                      cStatus = "Erro ao carregar o Metodo buscaCliente no Web Service SIGEP WEB.".
            else do:

                create x-document hRetorno.
                create x-noderef  hSoapResult.
                create x-noderef  hValor.
                create x-noderef  hAux.

                hRetorno:load("LONGCHAR",lcSoapResult,no).
                hRetorno:get-document-element(hSoapResult).

                repeat cont1 = 1 to hSoapResult:num-children:

/*                         MESSAGE hSoapResult:num-children       */
/*                             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                    hSoapResult:get-child(hAux,cont1).

                   if (hAux:name = "id") then do:
                      hAux:get-child(hValor,1).
                      idServico = hValor:node-value no-error.
                   end. /* if (hAux:name = "id") then do: */ 

/*                        DISP hAux:NAME FORMAT 'x(20)'               */
/*                             hValor:node-value no-error.            */

                end. /* repeat cont1 = 1 to hSoapResult:num-children: */

                MESSAGE 'Solicita Etiquetas ' idServico
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                RUN solicitaEtiquetas IN hSigepWeb(INPUT  'C', 
                                                   INPUT  identificador,
                                                   INPUT  idServico,
                                                   INPUT  qtdEtiquetas,
                                                   INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.usuario ELSE param-sigep-web.usuario-tst,
                                                   INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.senha   ELSE param-sigep-web.senha-tst  ,
                                                   OUTPUT numeracaoEtiquetas).

                MESSAGE 'numeracaoEtiquetas ' numeracaoEtiquetas
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                assign iStatus = 2
                       cStatus = "Integracao efetuada com sucesso.".

            END. /* if NOT (error-status:error) then */

        END. /* IF AVAIL estabelec THEN DO: */

    END. /* if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do: */

END PROCEDURE.

/* fechaPlpParam*/
PROCEDURE fechaPlpParam:

    DEFINE INPUT  PARAMETER cXMLPLP             AS LONGCHAR     NO-UNDO.
    DEFINE INPUT  PARAMETER faixaEtiquetasPLP   AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER iStatus             AS INTEGER      NO-UNDO. 
    DEFINE OUTPUT PARAMETER cStatus             AS CHARACTER    NO-UNDO. 

    DEFINE VARIABLE idServico                   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE idPlpMaster                 AS INTEGER      NO-UNDO.

    DEFINE VARIABLE hSoapResult2                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cont12                      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE hAux2                       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hRetorno2                   AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hValor2                     AS HANDLE       NO-UNDO.
    

    ASSIGN idServico = ''
           cont1     = 0.

    if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do:

        FIND FIRST param-sigep-web NO-LOCK NO-ERROR.
        FIND FIRST estabelec WHERE estabelec.cod-estabel = '101' NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:

            /* Use the operation name here, and invoke it in the proxy handle */
            RUN buscaCliente IN hSigepWeb(INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.idContrato       ELSE param-sigep-web.idContrato-tst      , 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.idCartaoPostagem ELSE param-sigep-web.idCartaoPostagem-tst, 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.usuario          ELSE param-sigep-web.usuario-tst         , 
                                          INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.senha            ELSE param-sigep-web.senha-tst           ,  
                                          OUTPUT lcSoapResult).

            if (error-status:error) then
               assign iStatus = 96
                      cStatus = "Erro ao carregar o Metodo buscaCliente no Web Service SIGEP WEB.".
            else do:

                create x-document hRetorno.
                create x-noderef  hSoapResult.
                create x-noderef  hValor.
                create x-noderef  hAux.

                hRetorno:load("LONGCHAR",lcSoapResult,no).
                hRetorno:get-document-element(hSoapResult).

                repeat cont1 = 1 to hSoapResult:num-children:

                    hSoapResult:get-child(hAux,cont1).

                   if (hAux:name = "id") then do:
                      hAux:get-child(hValor,1).
                      idServico = hValor:node-value no-error.
                   end. /* if (hAux:name = "id") then do: */ 

                end. /* repeat cont1 = 1 to hSoapResult:num-children: */

                MESSAGE 'Solicita Etiquetas ' idServico
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                RUN fechaPlp IN hSigepWeb(INPUT  cXMLPLP,
                                          INPUT  idServico,
                                          INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.idCartaoPostagem ELSE param-sigep-web.idCartaoPostagem-tst,
                                          INPUT  faixaEtiquetasPLP, 
                                          INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.usuario ELSE param-sigep-web.usuario-tst,
                                          INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.senha   ELSE param-sigep-web.senha-tst  ,
                                          OUTPUT idPlpMaster).

                MESSAGE 'idPlpMaster ' idPlpMaster
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                if (error-status:error) then
                   assign iStatus = 96
                          cStatus = "Erro ao carregar o Metodo fechaPlp no Web Service SIGEP WEB.".
                else do:
                    ASSIGN cont1 = 0.

                    RUN SolicitaXmlPlp IN hSigepWeb(INPUT  idPlpMaster,
                                                    INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.usuario ELSE param-sigep-web.usuario-tst,
                                                    INPUT  IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-sigep-web.senha   ELSE param-sigep-web.senha-tst  ,
                                                    OUTPUT lcSoapResult2).

                    MESSAGE 'lcSoapResult2 ' string(lcSoapResult2)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    if (error-status:error) then
                       assign iStatus = 96
                              cStatus = "Erro ao carregar o Metodo buscaCliente no Web Service SIGEP WEB.".
                    else do:

                        create x-document hRetorno2.
                        create x-noderef  hSoapResult2.
                        create x-noderef  hValor2.
                        create x-noderef  hAux2.

                        hRetorno:load("LONGCHAR",lcSoapResult2,no).
                        hRetorno:get-document-element(hSoapResult2).

                        CREATE objeto-sigep-web.
                        repeat cont1 = 1 to hSoapResult2:num-children:

                            if (hAux2:name = "valor_global") then do:
                                hAux2:get-child(hValor2,1).           
                                ASSIGN objeto-sigep-web.valor-global            = DECIMAL(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "valor_cobrado") then do:
                                hAux2:get-child(hValor2,1).          
                                ASSIGN objeto-sigep-web.valor-cobrado           = DECIMAL(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "status_processamento") then do:
                                hAux2:get-child(hValor2,1).   
                                ASSIGN objeto-sigep-web.status-processamento    = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "serie") then do:
                                hAux2:get-child(hValor2,1).                  
                                ASSIGN objeto-sigep-web.serie                   = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "peso") then do:
                                hAux2:get-child(hValor2,1).                   
                                ASSIGN objeto-sigep-web.peso                    = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "numero_etiqueta") then do:
                                hAux2:get-child(hValor2,1).        
                                ASSIGN objeto-sigep-web.numero-etiqueta         = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "numero_comprovante_postagem") then do:
                                hAux2:get-child(hValor2,1).
                                ASSIGN objeto-sigep-web.numero-comprovante-post = INTEGER(hValor2:node-value) no-error.
                            END.
                            
                            ELSE IF (hAux2:name = "nr_nota_fis") then do:
                                hAux2:get-child(hValor2,1).            
                                ASSIGN objeto-sigep-web.nr-nota-fis             = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "nome_unidade_postagem") then do:
                                hAux2:get-child(hValor2,1).  
                                ASSIGN objeto-sigep-web.nome-unidade-postagem   = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "mcu_unidade_postagem") then do:
                                hAux2:get-child(hValor2,1).   
                                ASSIGN objeto-sigep-web.mcu-unidade-postagem    = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "dimensao_largura") then do:
                                hAux2:get-child(hValor2,1).       
                                ASSIGN objeto-sigep-web.dimensao-largura        = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "dimensao_diametro") then do:
                                hAux2:get-child(hValor2,1).      
                                ASSIGN objeto-sigep-web.dimensao-diametro       = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "dimensao_comprimento") then do:
                                hAux2:get-child(hValor2,1).    
                                ASSIGN objeto-sigep-web.dimensao-comprimento    = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "dimensao_altura") then do:
                                hAux2:get-child(hValor2,1).        
                                ASSIGN objeto-sigep-web.dimensao-altura         = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "data_postagem_sara") then do:
                                hAux2:get-child(hValor2,1).     
                                ASSIGN objeto-sigep-web.data-postagem-sara      = DATE(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "cubagem") then do:
                                hAux2:get-child(hValor2,1).                
                                ASSIGN objeto-sigep-web.cubagem                 = INTEGER(hValor2:node-value) no-error.
                            END.

                            ELSE IF (hAux2:name = "cod_servico_postagem") then do:
                                hAux2:get-child(hValor2,1).   
                                ASSIGN objeto-sigep-web.cod-servico-postagem    = hValor2:node-value no-error.
                            END.

                            ELSE IF (hAux2:name = "cod_estabel") then do:
                                hAux2:get-child(hValor2,1).
                                ASSIGN objeto-sigep-web.cod-estabel             = hValor2:node-value no-error.
                            END.

        /*                         MESSAGE hSoapResult:num-children       */
        /*                             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                            hSoapResult2:get-child(hAux2,cont1).

                            MESSAGE hSoapResult:num-children
                                    hAux2:NAME 
                                    hValor2:node-value
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            assign iStatus = 2
                                   cStatus = "Integracao efetuada com sucesso.".

                        end. /* repeat cont1 = 1 to hSoapResult:num-children: */

                    END. /* if NOT (error-status:error) then */

                END. /* if (error-status:error) then */

            END. /* if NOT (error-status:error) then */

        END. /* IF AVAIL estabelec THEN DO: */

    END. /* if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do: */

END PROCEDURE.

/* acompanharPedidoParam */
PROCEDURE acompanharPedidoParam:

    /*
    <usuario>60618043</usuario>
    <senha>8o8otn</senha>
    <codAdministrativo>5122864</codAdministrativo>
    <!-- H (Todos) - U (éltimo) -->
    <tipoBusca>H</tipoBusca>
    <!-- L (Domiciliar) - A (Autoriza‡Æo) C (Coleta) -->
    <tipoSolicitacao>C</tipoSolicitacao>
    <numeroPedido>010092315</numeroPedido>
    */


    DEFINE OUTPUT PARAMETER iStatus             AS INTEGER     NO-UNDO. 
    DEFINE OUTPUT PARAMETER cStatus             AS CHARACTER   NO-UNDO. 

    DEFINE VARIABLE numero_pedido               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE descricao_status            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE numero_etiqueta             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ultimo_status               AS CHARACTER   NO-UNDO.

    if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do:

        FIND FIRST param-log-reversa NO-LOCK NO-ERROR.
        FIND FIRST estabelec WHERE estabelec.cod-estabel = '101' NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:

            /* Use the operation name here, and invoke it in the proxy handle */
            RUN acompanharPedido IN hSigepWeb(INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-log-reversa.usuario           ELSE param-log-reversa.usuario-tst          , 
                                              INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-log-reversa.senha             ELSE param-log-reversa.senha-tst            ,  
                                              INPUT IF estabelec.idi-tip-emis-nf-eletro = 3 THEN param-log-reversa.codAdministrativo ELSE param-log-reversa.codAdministrativo-tst,  
                                              INPUT 'H'                                                                                                                          ,
                                              INPUT 'C'                                                                                                                          ,
                                              INPUT 'numeroPedido'                                                                                                               ,
                                              OUTPUT lcSoapResult).

            if (error-status:error) then
               assign iStatus = 96
                      cStatus = "Erro ao carregar o Metodo acompanharPedido no Web Service SIGEP WEB (LogReversa).".
            else do:

                create x-document hRetorno.
                create x-noderef  hSoapResult.
                create x-noderef  hValor.
                create x-noderef  hAux.

                hRetorno:load("LONGCHAR",lcSoapResult,no).
                hRetorno:get-document-element(hSoapResult).

                repeat cont1 = 1 to hSoapResult:num-children:

                    hSoapResult:get-child(hAux,cont1).

                    if (hAux:name = "numero_pedido") then do:
                       hAux:get-child(hValor,1).
                       numero_pedido = hValor:node-value no-error.
                    end. /* if (hAux:name = "id") then do: */ 
                    
                    
                    IF numero_pedido <> '' THEN DO:
                    
                        if (hAux:name = "descricao_status") then do:
                           hAux:get-child(hValor,1).
                           descricao_status = hValor:node-value no-error.
                        end. /* if (hAux:name = "id") then do: */ 
                    
                        if (hAux:name = "numero_etiqueta") then do:
                           hAux:get-child(hValor,1).
                           numero_etiqueta = hValor:node-value no-error.
                        end. /* if (hAux:name = "id") then do: */ 
                    
                        if (hAux:name = "ultimo_status") then do:
                           hAux:get-child(hValor,1).
                           ultimo_status = hValor:node-value no-error.
                        end. /* if (hAux:name = "id") then do: */ 
                        
                    END.
                    
                END. /* repeat cont1 = 1 to hSoapResult:num-children: */

                MESSAGE 'OK'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                assign iStatus = 2
                       cStatus = "Integracao efetuada com sucesso.".

                FIND FIRST objeto-sigep-web WHERE objeto-sigep-web.numero-etiqueta = numero_etiqueta EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL objeto-sigep-web THEN DO:

                    ASSIGN objeto-sigep-web.status-processamento = ultimo_status
                           objeto-sigep-web.char-1               = descricao_status.

                END.
                ELSE DO:
                END.

            END. /* if NOT (error-status:error) then */

        END. /* IF AVAIL estabelec THEN DO: */

    END. /* if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hSigepWeb) then do: */

END PROCEDURE.

/* cancelarPedidoParam */
PROCEDURE cancelarPedidoParam:

END PROCEDURE.

procedure desconecta:
   if (valid-handle(hWebService)) and (hWebService:connected()) then
      hWebService:disconnect() no-error.
   if (valid-handle(hWebService)) then
      delete object hWebService.
end procedure.
