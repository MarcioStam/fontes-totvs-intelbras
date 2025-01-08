/****************************************************************************************************
** Autor: Isac Abrahao
**
** Objetivo: API Geracao de etiquetas
**
** Data: 01/06/2022
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piImpEtiq POST /~*}
{utp/ut-api-notfound.i} 

{esp/es0018.i}
{esapi/esapi016.i}

DEFINE VAR c-n-serie          AS CHAR NO-UNDO.
DEFINE VAR c-mac              AS CHAR NO-UNDO EXTENT 10.
DEFINE VAR c-erro             AS CHAR NO-UNDO.
DEFINE VAR i-cont             AS INTE NO-UNDO.
DEFINE VAR i-cont-mac         AS INT  NO-UNDO.

DEFINE VARIABLE codProd         AS CHARACTER NO-UNDO.
DEFINE VARIABLE codModelo       AS INTEGER   NO-UNDO.
DEFINE VARIABLE sigla           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cEstab          AS CHARACTER NO-UNDO.
DEFINE VARIABLE impressora      AS CHARACTER NO-UNDO. 
DEFINE VARIABLE num-serie       AS CHARACTER NO-UNDO.
DEFINE VARIABLE num-serie-duo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMac            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lReimp          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lValidaFirmware AS LOGICAL   NO-UNDO.

DEFINE BUFFER b-mac-address   FOR mac-address.
DEFINE BUFFER b-num-serie-duo FOR num-serie.

DEFINE BUFFER  b-tt-lista-ns FOR tt-lista-ns.

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHAR NO-UNDO.

/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem //NO-UNDO
    FIELD tip-msgs   AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD informacao AS CHARACTER FORMAT "x(250)"
    FIELD mensagem   AS CHARACTER FORMAT "x(250)":U
    FIELD arquivo    AS CHARACTER.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".


/* Inicio */
/****************************************************************************************************/

PROCEDURE piImpEtiq:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.

    DEFINE VARIABLE objImpEtiq          AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayImpEtiq        AS jsonArray    NO-UNDO.

    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE c-data    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.

    DEFINE VARIABLE lValida AS LOGICAL     NO-UNDO.
   
    ASSIGN lReimp  = NO
           lValida = ?
           lValidaFirmware = YES.

    IF jsonInput:has("payload") THEN DO:
       ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
         
       ASSIGN sigla           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "initials")
              num-serie       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "serialNumber")
              num-serie-duo   = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "serialNumberDUO")
              cMac            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "Mac")
              cEstab          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "establishment")
              lReimp          = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "Reimp"))
              lValida         = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "firmware")).
    END.

    ASSIGN v_cod_estab_usuar = cEstab.

    IF lValida <> ? THEN
       ASSIGN lValidaFirmware = lValida.

    ASSIGN c-arquivo-log1 = '/usr/wrk/totvs/LOG-ETIQUETAS.txt'.

    RUN pi-gerar-dados-extrato (chr(13) + chr(13) + 'Inicio - SN: ' + num-serie + " - " + STRING(TODAY) + ' ; ' + string(TIME,'HH:MM:SS') ). 
    RUN pi-gerar-dados-extrato ('Estab: ' + v_cod_estab_usuar).

     RUN pi-gerar-dados-extrato ('MACCCCC: ' + STRING(cMac)).

    
    IF num-serie-duo <> '' THEN DO:
       FIND FIRST b-num-serie-duo WHERE b-num-serie-duo.n-serie = num-serie-duo EXCLUSIVE-LOCK NO-ERROR.
    
       IF NOT AVAIL b-num-serie-duo THEN DO:
           RUN pi-cria-mensagem (INPUT 412,
                                 INPUT '',
                                 INPUT "ERRO_DE_VALIDACAO",
                                 INPUT 'Numero de serie DUO nao encontrado.').
       END.                        
    END.

    FIND FIRST num-serie WHERE num-serie.n-serie = num-serie NO-LOCK NO-ERROR.

    IF NOT AVAIL num-serie THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT '',
                              INPUT "ERRO_DE_VALIDACAO",
                              INPUT 'Numero de serie nao encontrado.').
    END.
    ELSE DO:

        ASSIGN l-erro = NO.

        IF lValidaFirmware THEN DO:
            FIND FIRST num-serie-firmware 
                 WHERE num-serie-firmware.n-serie = num-serie.n-serie
            NO-LOCK NO-ERROR.
    
            IF NOT AVAIL num-serie-firmware THEN DO:
               RUN pi-cria-mensagem (INPUT 412,
                                     INPUT '',
                                     INPUT "ERRO_DE_VALIDACAO",
                                     INPUT "Teste de Firmware nao foi realizado. numSerie :" + STRING(Num-Serie)).
    
               ASSIGN l-erro = YES.
            END.
            ELSE DO:
               IF NOT num-serie-firmware.log-1 THEN DO:
    
                  RUN pi-cria-mensagem (INPUT 412,
                                        INPUT '',
                                        INPUT "ERRO_DE_VALIDACAO",
                                        INPUT "Firmware nao foi gravado. numSerie :" + STRING(Num-Serie)).
    
                  ASSIGN l-erro = YES.
               END.                   
            END.
        END.

        FIND FIRST item-ean WHERE item-ean.it-codigo = num-serie.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL item-ean THEN DO:
           IF LENGTH(item-ean.nc) > 3 THEN DO:
              IF trim(substring(num-serie.char-1,50)) = '' THEN DO:

                 RUN pi-cria-mensagem (INPUT 412,
                                       INPUT '',
                                       INPUT "ERRO_DE_VALIDACAO",
                                       INPUT "SN necessita a importacao do PID/DSK - " + STRING(Num-Serie)).

                 ASSIGN l-erro = YES.
              END.
           END.   
        END.                                                    

        IF NOT lReimp THEN DO:
           IF cMac <> '' THEN DO:
    
              RUN pi-gerar-dados-extrato ('ENTROU MACCCCC 1 ').
    
              DO i-cont-mac = 1 TO NUM-ENTRIES(cMac):
                 FIND FIRST mac-address EXCLUSIVE-LOCK 
                      WHERE mac-address.mac = ENTRY(i-cont-mac,cMac)
                 NO-ERROR.
    
                 RUN pi-gerar-dados-extrato ('AVAIL MACCCCC : ' + STRING(AVAIL MAC-ADDRESS)).
    
                 IF NOT AVAIL mac-address THEN DO:
                    RUN pi-cria-mensagem (INPUT 412,
                                          INPUT '',
                                          INPUT "ERRO_DE_VALIDACAO",
                                          INPUT "MAC nao localizado. MAC : " + STRING(ENTRY(i-cont-mac,cMac)) ).
    
                    ASSIGN l-erro = YES.  
                 END.
                 ELSE DO:
                     EMPTY TEMP-TABLE tt-prog-ponto.
                     RUN esp/es0018p.p (INPUT "ESCPP106":U, /* Nome do programa */
                                        INPUT 1,            /* Ponto do programa */
                                        INPUT 0,
                                        INPUT "":U,
                                        OUTPUT TABLE tt-prog-ponto).
                     
                     /*IF NOT CAN-FIND(FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = num-serie.it-codigo) THEN*/ 
                     DO:
                        IF mac-address.n-serie <> "" THEN DO:
                           RUN pi-cria-mensagem (INPUT 412,
                                                 INPUT '',
                                                 INPUT "ERRO_DE_VALIDACAO",
                                                 INPUT "Mac Address j  vinculado a outro Numero de serie. MAC:" + STRING(ENTRY(i-cont-mac,cMac)) + " | SN: " + mac-address.n-serie ).
    
                           ASSIGN l-erro = YES.  
                        END.
                        ELSE DO:
                           ASSIGN mac-address.n-serie = num-serie.n-serie.
    
                           RUN pi-gerar-dados-extrato ('GRAVOU SN MACCCCC : ' + STRING(mac-address.n-serie)).

                           RELEASE mac-address.
                        END.
                     END.
                 END.    
              END.
           END.    
        END.

        RUN pi-gerar-dados-extrato ('Possui ERRO ???: ' + STRING(l-erro)).

        RUN pi-gerar-dados-extrato ('ANTES GERAR ARQUIVO - ' + string(TIME,'HH:MM:SS')).

        IF NOT l-erro THEN DO:
           ASSIGN codProd = num-serie.it-codigo.
    
           FOR FIRST item-mod-etiq NO-LOCK
               WHERE item-mod-etiq.it-codigo = codProd 
                 AND item-mod-etiq.padrao:
               ASSIGN codModelo  = item-mod-etiq.cod-modelo.
           END.   

           RUN pi-gerar-dados-extrato ('Etiqueta Impressa ???: ' + STRING( num-serie.log-2)).
           RUN pi-gerar-dados-extrato ('teste 123 ').
           RUN pi-gerar-dados-extrato (STRING(lReimp)).

           RUN pi-gerar-dados-extrato ('Vai reimprimir ???: ' + STRING(lReimp)).
            
           /*  Comentado para teste 09/06/2022 */
           
           IF num-serie.log-2 = YES THEN DO:
              IF NOT lReimp THEN DO:
              
                 RUN pi-cria-mensagem (INPUT 412,
                                       INPUT '',
                                       INPUT "ERRO_DE_VALIDACAO",
                                       INPUT "Numero de Serie ja impresso. numSerie :" + STRING(Num-Serie)).

                 ASSIGN l-erro = YES.
              END.
              ELSE
                RUN piImpressao.
           END.
           ELSE
             RUN piImpressao.

           RUN pi-gerar-dados-extrato ('DEPOIS ARQUIVO GERADO - ' + string(TIME,'HH:MM:SS')).
          

           IF NOT l-erro THEN DO:

              FIND FIRST num-serie WHERE num-serie.n-serie = num-serie NO-LOCK NO-ERROR.

              IF AVAIL num-serie THEN DO:

                 FIND FIRST num-serie-firmware 
                       WHERE num-serie-firmware.n-serie = num-serie
                  EXCLUSIVE-LOCK NO-ERROR.
    
                 RUN pi-gerar-dados-extrato ('AVAIl NUM-SERIE-FIRMWARE: ' + STRING(AVAIL num-serie-firmware )).

                 IF NOT AVAIL num-serie-firmware THEN DO:
                     CREATE num-serie-firmware.
                     ASSIGN num-serie-firmware.n-serie = num-serie
                            num-serie-firmware.log-1   = NO
                            num-serie-firmware.char-1  = STRING(TODAY,'99/99/9999') + " " + STRING(TIME,'HH:MM:SS').

                     RUN pi-gerar-dados-extrato ('Cria NUM-SERIE-FIRMWARE: ' + STRING(AVAIL num-serie-firmware )).
                 END.                     

                 RUN pi-gerar-dados-extrato (' lReimp: ' + STRING( lReimp )).
                 /* Reimpressao */
                 IF num-serie.log-2 = YES AND lReimp THEN
                    ASSIGN num-serie-firmware.data-reimp = TODAY
                           num-serie-firmware.hora-reimp = STRING(TIME,'HH:MM:SS')
                           num-serie-firmware.int-1      =  num-serie-firmware.int-1 + 1. /* Numero reimpressoes */
                 ELSE
                    ASSIGN num-serie-firmware.data-imp = TODAY
                           num-serie-firmware.hora-imp = STRING(TIME,'HH:MM:SS').
        
                 RELEASE num-serie-firmware.
              END.
           END.

        END.
    END.
     
    RUN pi-gerar-dados-extrato ('ANTES FOR EACH tt-mensagem: ').
    
    ASSIGN arrayImpEtiq  = NEW JsonArray().

    FOR EACH tt-mensagem:

        RUN pi-gerar-dados-extrato ('FOR EACH tt-mensagem: ' + STRING(tt-mensagem.tip-msgs) + ' - '  + tt-mensagem.mensagem).

        ASSIGN objImpEtiq = NEW JsonObject(). 
        
        objImpEtiq:ADD("code", STRING(tt-mensagem.tip-msgs)).
        objImpEtiq:ADD("message",tt-mensagem.mensagem).

        ASSIGN c-data = ''.

        /* Arquivo de impressao gerado corretamente */
        /*IF tt-mensagem.tip-msgs = 200 THEN DO:*/
           FIND FIRST num-serie-firmware WHERE num-serie-firmware.n-serie = num-serie NO-LOCK NO-ERROR.

           IF AVAIL num-serie-firmware THEN 
              ASSIGN c-data = num-serie-firmware.char-1.
        /*END.*/

        objImpEtiq:ADD("dateTime", c-data).
        objImpEtiq:ADD("file", tt-mensagem.arquivo ).

        arrayImpEtiq:ADD(objImpEtiq).                
    END.      

    RUN pi-gerar-dados-extrato ('DEPOIS FOR EACH tt-mensagem: ').
    
    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("return", arrayImpEtiq ).

    RUN pi-gerar-dados-extrato ('FINAL DE TUDO ').
    
    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


              
PROCEDURE piImpressao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE i-capacidade  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-qtd-embalag AS INTEGER NO-UNDO.
    DEFINE VARIABLE h-esapi016    AS HANDLE  NO-UNDO.

    DEFINE VARIABLE cDiretorio    AS CHARACTER NO-UNDO.

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('piValidate 1')).
    
    RUN piValidate.

    IF RETURN-VALUE <> "OK":U THEN
        RETURN "NOK":U.

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('piValidate 2')).

    FIND FIRST modelo-etiq NO-LOCK
         WHERE modelo-etiq.cod-modelo = codModelo
    NO-ERROR.

    IF modelo-etiq.tipo = 8 THEN DO:
        RUN piCapacidade(OUTPUT i-capacidade).
        IF i-capacidade = 0 THEN DO:
            RUN pi-cria-mensagem (INPUT 412,
                                  INPUT '',
                                  INPUT "ERRO_DE_VALIDACAO",
                                  INPUT "Etiqueta nao gerada.").
            RETURN "NOK".
        END.
        ASSIGN i-qtd-embalag = i-capacidade.
    END.

    RUN esapi/esapi016z.p PERSISTENT SET h-esapi016.

    EMPTY TEMP-TABLE tt-lista-ns.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = num-serie.n-serie.
       
    /*Cria Num Serie DUO*/
    IF num-serie-duo <> '' THEN DO:
       CREATE tt-lista-ns.
       ASSIGN tt-lista-ns.num-serie = b-num-serie-duo.n-serie.
    
       FOR EACH tt-lista-ns:
           FIND FIRST b-tt-lista-ns 
                WHERE b-tt-lista-ns.num-serie <> tt-lista-ns.num-serie
           NO-ERROR.
    
           IF AVAIL b-tt-lista-ns THEN DO:
               FIND FIRST num-serie 
                    WHERE num-serie.n-serie = b-tt-lista-ns.num-serie
               EXCLUSIVE-LOCK NO-ERROR.
    
               IF AVAIL num-serie THEN DO: 
                  ASSIGN num-serie.char-2 = tt-lista-ns.num-serie.
                  RELEASE num-serie.
               END.
           END.                 
       END.
    END.
     
    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('ImpEtiq 1')).
    
    RUN esp/es0018p.p (INPUT  'ImpEtiq',
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH tt-prog-ponto:
        ASSIGN cDiretorio = tt-prog-ponto.conteudo.
    END.

    //ASSIGN cDiretorio = '/mnt/spool/is055792/'.  /*Teste impressao */

    ASSIGN FILE-INFO:FILE-NAME = cDiretorio.

    IF FILE-INFO:PATHNAME = ? THEN
       OS-CREATE-DIR VALUE(cDiretorio).

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('ImpEtiq 2')).

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('piImpressao 1')).
    
    RUN piImpressao IN h-esapi016 (INPUT 0, /* Num PO */
                                   INPUT codProd,
                                   INPUT codModelo,
                                   INPUT sigla,
                                   INPUT 1, // INPUT FRAME fPage0 i-qtd
                                   INPUT i-qtd-embalag,
                                   INPUT 0,  /* Motivo Reimpress’o */
                                   INPUT 0,  /* Pedido de Compra */
                                   INPUT cDiretorio + STRING(num-serie) + '.txt',
                                   INPUT 4,  /* N’o valida nada, pois jÿ foi validado na gera»’o. */
                                   INPUT NO, //ASTEC
                                   INPUT i-capacidade,
                                   INPUT TABLE tt-lista-ns).

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('piImpressao 2')).

    IF RETURN-VALUE <> "OK":U THEN DO:

        EMPTY TEMP-TABLE tt-erro.

        RUN pi-gerar-dados-extrato ('COM ERRO').

        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).

        //RUN cdp/cd0666.w (INPUT TABLE tt-erro).
          
         FOR EACH tt-erro:

             RUN pi-gerar-dados-extrato ('Retorno ESAPI016: ' + string(tt-erro.cd-erro) + '-' + tt-erro.mensagem).

             RUN pi-cria-mensagem (INPUT 412,
                                   INPUT '',
                                   INPUT "ERRO_DE_VALIDACAO",
                                   INPUT string(tt-erro.cd-erro) + '-' + tt-erro.mensagem).
         END.


        DELETE PROCEDURE h-esapi016.

        RETURN "NOK":U.

    END.
    ELSE
       RUN pi-gerar-dados-extrato ('SEM ERRO ESAPI016').

    RUN pi-gerar-dados-extrato ('piImpressao: ' + STRING('piImpressao 3')).
    

    RUN esp/es0018p.p (INPUT  'ImpEtiq',
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH tt-prog-ponto:
        ASSIGN cDiretorio = tt-prog-ponto.conteudo.
    END.
    
     //ASSIGN cDiretorio = '/mnt/spool/ra053410/' + codProd + '/'. 
     /*ASSIGN cDiretorio = '/mnt/spool/is055792/' + codProd + '/'. //Teste impressao */

     RUN pi-gerar-dados-extrato ('CAMINHO ETOQUETA: ' + cDiretorio + STRING(num-serie) + '.txt').
     RUN pi-gerar-dados-extrato ("SEARCH: " + STRING(SEARCH(cDiretorio + STRING(num-serie) + '.txt')) ).



     IF SEARCH(cDiretorio + STRING(num-serie) + '.txt') = ? THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT '',
                              INPUT "ERRO_DE_VALIDACAO",
                              INPUT cDiretorio + STRING(num-serie) + '.txt' + 'Arquivo de impressao nao foi gerado').

        RETURN "NOK":U.
     END.

     RUN pi-gerar-dados-extrato ("ANTES CRIA MENSAGEM OK - "  + cDiretorio + STRING(num-serie) + '.txt').

     /* Arquivo gerado */ 
     RUN pi-cria-mensagem (INPUT 200,
                           INPUT cDiretorio + STRING(num-serie) + '.txt',
                           INPUT STRING(num-serie),
                           INPUT "Etiqueta impressa com Sucesso").

    RUN pi-gerar-dados-extrato ("DEPOIS CRIA MENSAGEM OKKKKKKKKKKKKKKKKKK - "  + cDiretorio + STRING(num-serie) + '.txt').
    
    
    DELETE PROCEDURE h-esapi016.

    FIND FIRST num-serie WHERE num-serie.n-serie = num-serie EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL num-serie THEN DO:
       ASSIGN num-serie.log-2 = YES.

       RELEASE num-serie.
    END.

    RUN pi-gerar-dados-extrato ("FINAL piImpressao").
    
    RETURN "OK":U.


END PROCEDURE.




PROCEDURE pi-cria-mensagem:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-codigo   AS INT  NO-UNDO.
    DEF INPUT PARAM p-arquivo  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-inform   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-mensagem AS CHAR NO-UNDO.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tip-msgs   = p-codigo
           tt-mensagem.arquivo    = p-arquivo
           tt-mensagem.informacao = p-inform
           tt-mensagem.mensagem   = p-mensagem.

    RUN pi-gerar-dados-extrato ("CRIA MENSAGEM - "  + string(tt-mensagem.tip-msgs) + '- ' + tt-mensagem.mensagem + ' - ' + tt-mensagem.arquivo + ' - ' + tt-mensagem.informacao).

END PROCEDURE.


PROCEDURE piValidate:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.

    ASSIGN c-cod-estabel = v_cod_estab_usuar.

    IF  c-cod-estabel = "" OR  c-cod-estabel = ? THEN
        ASSIGN c-cod-estabel = "101".

    /* Se a C‚lula foi informada, deve ser v lida. */
    IF sigla <> "" THEN DO:
        IF NOT CAN-FIND(FIRST ns-sigla
                        WHERE ns-sigla.sigla = sigla) THEN DO:

             RUN pi-cria-mensagem (INPUT 412,
                                   INPUT '',
                                   INPUT "ATRIBUTO_REQUERIDO",
                                   INPUT 'Atributo requerido Celula:').
            RETURN "NOK":U.
        END.
    END.


    FOR FIRST modelo-etiq NO-LOCK
            WHERE modelo-etiq.cod-modelo = codModelo:

        IF  modelo-etiq.tipo = 1 /* N£mero de S‚rie */ THEN DO:

            EMPTY TEMP-TABLE tt-prog-ponto.

            RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                               INPUT 1,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            FOR FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo = codProd
                AND   item-uni-estab.cod-estabel = c-cod-estabel:

                FOR FIRST tt-prog-ponto
                    WHERE entry(1, tt-prog-ponto.conteudo, ";") = c-cod-estabel
                    AND   int(ENTRY(2, tt-prog-ponto.conteudo, ";")) = item-uni-estab.nr-linha:

                    IF sigla = "" THEN DO:
                        RUN pi-cria-mensagem (INPUT 412,
                                              INPUT '',
                                              INPUT "ATRIBUTO_REQUERIDO",
                                              INPUT 'Atributo requerido Celula:').

                        RETURN "NOK":U.
                    END.
                END.
            END.

            /*
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                               INPUT 2,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto NO-ERROR.

            FOR EACH usuar_grp_usuar
                WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-LOCK:

                IF LOOKUP(usuar_grp_usuar.cod_grp_usuar,tt-prog-ponto.conteudo) > 0 THEN DO:
                    ASSIGN l-acesso = YES.
                    LEAVE.
                END.
            END.*/

            
        END.

        IF  modelo-etiq.tipo = 5 OR modelo-etiq.tipo = 7 /* DUN14 */ THEN DO:
            IF  NOT CAN-FIND(FIRST item-dun
                             WHERE item-dun.it-codigo = codProd) THEN DO:

                RUN pi-cria-mensagem (INPUT 412,
                                      INPUT '',
                                      INPUT "ERRO_DE_VALIDACAO",
                                      INPUT 'Item nÆo possui DUN14 cadastrado.').
                RETURN "NOK":U.
            END.
        END.
    END.

END.





PROCEDURE pi-gerar-dados-extrato:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT UNFORMATTED  p-string  " - " string(TIME,'HH:MM:SS') SKIP.
       OUTPUT CLOSE. 
    END.

END PROCEDURE.

