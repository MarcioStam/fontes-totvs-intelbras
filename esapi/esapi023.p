&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esapi/esapi023.i}
{cdp/cd0666.i}
{upc/btb910za-upc.i} /* Estabelecimento do usu†rio corrente - v_cod_estab_usuar */

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "X(12)" NO-UNDO.
DEFINE            SHARED VARIABLE h-acomp       AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-conv-dec-to-hex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-dec-to-hex Procedure 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-conv-hex-to-dec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-hex-to-dec Procedure 
FUNCTION conv-hex-to-dec RETURNS DECIMAL
  ( INPUT p-val-hexadecimal AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fator Procedure 
FUNCTION fator RETURNS DECIMAL
  ( INPUT p-fator AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnGeraLoteMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGeraLoteMac Procedure 
FUNCTION fnGeraLoteMac RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAtualizaItemFornec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaItemFornec Procedure 
PROCEDURE piAtualizaItemFornec :
/*------------------------------------------------------------------------------
  Purpose: Atualiza percentual buffer
  Notes:   Carlos Daniel - 23/09/2015     
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-int-item-fornec.

FOR EACH tt-int-item-fornec:
    FOR FIRST int-item-fornec OF tt-int-item-fornec EXCLUSIVE-LOCK:
        ASSIGN int-item-fornec.buffer-mac = tt-int-item-fornec.buffer-mac.
    END.

    IF AVAIL int-item-fornec THEN DO:
        VALIDATE int-item-fornec.
        RELEASE int-item-fornec.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCarregaItemFornec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaItemFornec Procedure 
PROCEDURE piCarregaItemFornec :
/*------------------------------------------------------------------------------
  Purpose:    Retorna registros de itens fornecedores de acordo com item em tela 
  Parameters: <C¢digo do item e temp-table da tabela int-item-fornec>
  Notes:      Carlos Daniel - 23/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-item AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-int-item-fornec.

FOR EACH int-item-fornec
    WHERE int-item-fornec.it-codigo = c-item NO-LOCK:

    CREATE tt-int-item-fornec.
    BUFFER-COPY int-item-fornec TO tt-int-item-fornec.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCarrega_ttItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarrega_ttItem Procedure 
PROCEDURE piCarrega_ttItem :
/*------------------------------------------------------------------------------
  Purpose: Carrega ttItens de acordo com pedido de commpra informado e busca
           mac address j† cadastrados caso o mesmo tenha
    Notes: Carlos Daniel - 21/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER i-nr-pedido AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttItem.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mac-address.
DEFINE OUTPUT PARAMETER TABLE FOR ttarq.

DEFINE VARIABLE i-cont         AS INTEGER NO-UNDO.
DEFINE VARIABLE vqtd-it-pedido AS INTEGER NO-UNDO.


FOR FIRST pedido-comp
    WHERE pedido-comp.num-pedido = i-nr-pedido NO-LOCK:

    FOR EACH  ordem-compra
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
        AND   (ordem-compra.situacao   = 2 OR ordem-compra.situacao   = 6) NO-LOCK
        BREAK BY ordem-compra.num-pedido
              BY ordem-compra.it-codigo:

        IF ordem-compra.it-codigo <> "" THEN DO:

            FIND FIRST item WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF  FIRST-OF(ordem-compra.it-codigo) THEN DO:

                ASSIGN vqtd-it-pedido = 0.
                
                CREATE ttitem.
                ASSIGN ttitem.it-codigo = ordem-compra.it-codigo
                       ttitem.desc-item = item.desc-item.

                FOR FIRST int-item-fornec FIELDS(buffer-mac)
                    WHERE int-item-fornec.it-codigo    = ordem-compra.it-codigo
                    AND   int-item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
                
                    ASSIGN ttItem.buffer-mac = int-item-fornec.buffer-mac.
                END.
                           
            END. /* IF  FIRST-OF(ordem-compra.it-codigo) */
             
            ASSIGN vqtd-it-pedido = vqtd-it-pedido + INTEGER(ordem-compra.qt-solic).
    
            IF  LAST-OF(ordem-compra.it-codigo) THEN DO:

                ASSIGN ttitem.qt-pedido = vqtd-it-pedido
                       i-cont = 0.

                FOR EACH num-serie NO-LOCK
                    WHERE num-serie.num-pedido = pedido-compr.num-pedido
                    AND   num-serie.it-codigo  = ordem-compra.it-codigo:

                    ASSIGN i-cont = i-cont + 1.

                    CREATE ttarq.
                    ASSIGN ttarq.it-codigo  = ttitem.it-codigo
                           ttarq.num-serie  = num-serie.n-serie.
                END.

                ASSIGN ttitem.gerado-ns = i-cont
                       i-cont           = 0.

                FIND FIRST item-ean 
                     WHERE item-ean.it-codigo = ordem-compra.it-codigo
                NO-LOCK NO-ERROR.

                FOR EACH mac-address NO-LOCK
                    WHERE mac-address.num-pedido = pedido-compr.num-pedido
                    AND   mac-address.it-codigo  = ordem-compra.it-codigo
                    AND   mac-address.impresso   = TRUE:

                    ASSIGN i-cont = i-cont + 1.

                    CREATE tt-mac-address.
                    ASSIGN tt-mac-address.it-codigo  = ttitem.it-codigo
                           tt-mac-address.mac        = mac-address.mac
                           tt-mac-address.impresso   = mac-address.impresso
                           tt-mac-address.senha-wifi = mac-address.char-1
                           tt-mac-address.senha-adm  = mac-address.char-2.

                END.

                ASSIGN ttitem.gerado-mac = i-cont.
    
            END. /* IF  LAST-OF(ordem-compra.it-codigo) */
        END. /* IF c-it-codigo <> "" THEN DO: */
    END. /* FOR EACH  ordem-compra NO-LOCK */
END. /* FOR FIRST pedido-comp NO-LOCK */

RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piExecGeraMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecGeraMac Procedure 
PROCEDURE piExecGeraMac :
/*------------------------------------------------------------------------------
  Purpose: Chama rotinas de geraá∆o e efetivaá∆o de mac address
  Notes:   Carlos Daniel - 25/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER lgeratxt  AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER i-formata AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttItem.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mac-address.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE c-caminho AS CHARACTER NO-UNDO.

RUN piPreMac(INPUT  TABLE ttItem,
             OUTPUT TABLE tt-mac-address,
             OUTPUT TABLE tt-erro).

IF RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

RUN piGeraMac(INPUT 0,
              INPUT-OUTPUT TABLE tt-mac-address,
              INPUT-OUTPUT TABLE tt-erro).

IF RETURN-VALUE = "OK" AND lgeratxt THEN DO:
    ASSIGN c-caminho = REPLACE(STRING(NOW,"99/99/9999 HH:MM:SS"),"/","")
           c-caminho = REPLACE(c-caminho,":","")
           c-caminho = REPLACE(c-caminho," ","")
           c-caminho = SESSION:TEMP-DIRECTORY + "Mac Address_" + c-caminho + ".txt".

    OUTPUT TO VALUE(c-caminho).
        FOR EACH tt-mac-address
            WHERE tt-mac-address.impresso = YES:
            IF i-formata = 1 THEN
                PUT UNFORMAT SUBSTRING (tt-mac-address.mac,1,2)  + ":" +
                             SUBSTRING (tt-mac-address.mac,3,2)  + ":" +  
                             SUBSTRING (tt-mac-address.mac,5,2)  + ":" + 
                             SUBSTRING (tt-mac-address.mac,7,2)  + ":" +  
                             SUBSTRING (tt-mac-address.mac,9,2)  + ":" +  
                             SUBSTRING (tt-mac-address.mac,11,2) + ";" SKIP.
            ELSE
                PUT UNFORMAT tt-mac-address.mac + ";" SKIP.
        END.
    OUTPUT CLOSE.
    OS-COMMAND NO-WAIT notepad VALUE(c-caminho).
END.

RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraAlerta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraAlerta Procedure 
PROCEDURE piGeraAlerta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-api022 AS HANDLE NO-UNDO.

RUN esapi/esapi022.p PERSISTENT SET h-api022.
RUN piTrataEmail IN h-api022 (INPUT mac-address-param.email,
                              INPUT "ATENÄ«O! Alerta de Mac Address",
                              INPUT "ATENÄ«O!" + '~r~n' +
                                    "O Mac Address atingiu a faixa de alerta: " + mac-address-param.alerta + "." + '~r~n' +
                                    "- Sequància: " + STRING(mac-address-param.sequencia) + ", Faixa: " + mac-address-param.faixa +
                                    ", Faixa Inicial: " + mac-address-param.faixa-ini + ", Faixa Final: " + mac-address-param.faixa-fim + "." + '~r~n' +
                                    "Providenciar a parametrizaá∆o de uma nova faixa, caso necess†rio.",
                              INPUT "",
                              INPUT "").
IF VALID-HANDLE(h-api022) THEN
    DELETE PROCEDURE h-api022.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraErro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraErro Procedure 
PROCEDURE piGeraErro PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:    Armazena erro na tt-erro 
  Parameters: C¢digo e mensagem do erro
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pCdErro AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pmsg AS CHARACTER   NO-UNDO.

CREATE tt-erro.
ASSIGN tt-erro.cd-erro = pCdErro
       tt-erro.mensagem = pMsg.
       
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraMac Procedure 
PROCEDURE piGeraMac :
/*------------------------------------------------------------------------------
  Purpose:    Gera registros na tabela mac-address 
  Parameters: <Nr.Pedido e tabela tempor†ria de mac>
  Notes:      Carlos Daniel - 22/09/2015    
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER i-nr-pedido AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-mac-address.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE qtd-por-item AS DECIMAL NO-UNDO.
DEFINE VARIABLE qtd-mac      AS INTEGER NO-UNDO.
DEFINE VARIABLE i-lote       AS INTEGER NO-UNDO. 
DEFINE VARIABLE l-todos-imp  AS LOGICAL NO-UNDO INIT NO.

DEFINE VARIABLE c-senha-wifi AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha-adm  AS CHARACTER   NO-UNDO.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando criaá∆o dos Mac Address").

ASSIGN i-lote = fnGeraLoteMac().

Grava:
DO TRANSACTION ON ERROR  UNDO Grava, LEAVE Grava
               ON QUIT   UNDO Grava, LEAVE Grava
               ON ENDKEY UNDO Grava, LEAVE Grava
               ON STOP   UNDO Grava, LEAVE Grava:

    FOR EACH tt-mac-address
        BREAK BY tt-mac-address.it-codigo
              BY tt-mac-address.mac:

        IF FIRST-OF(tt-mac-address.it-codigo) THEN DO:
            ASSIGN qtd-por-item = 0.

            FOR FIRST item-ean
                WHERE item-ean.it-codigo = tt-mac-address.it-codigo NO-LOCK: END.

            FOR FIRST pedido-compr
                WHERE pedido-compr.num-pedido = i-nr-pedido NO-LOCK:

                ASSIGN l-todos-imp = NO.

                FIND FIRST ponto-programa USE-INDEX ponto 
                     WHERE ponto-programa.nome-programa = "esapi023"
                       AND ponto-programa.ponto         = 1
                           NO-LOCK NO-ERROR.
                
                IF AVAIL ponto-programa 
                THEN DO:

                     FOR EACH conteudo-programa 
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                              NO-LOCK.

                         IF INT(conteudo-programa.conteudo) = pedido-compr.cod-emitente 
                         THEN ASSIGN l-todos-imp = YES.
                
                     END.
                END.

                FOR FIRST int-item-fornec FIELDS(buffer-mac)
                    WHERE int-item-fornec.it-codigo    = tt-mac-address.it-codigo
                    AND   int-item-fornec.cod-emitente = pedido-compr.cod-emitente NO-LOCK: END.
            END.

            IF tt-mac-address.projeto THEN
                ASSIGN qtd-mac = tt-mac-address.qtd-mac.
            ELSE
                ASSIGN qtd-mac = item-ean.qtd-mac.
        END.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: " + tt-mac-address.mac).

        ASSIGN qtd-por-item = qtd-por-item + 1.

        IF qtd-por-item > qtd-mac THEN
            ASSIGN qtd-por-item = 1.
        IF qtd-por-item = 1 THEN
            ASSIGN tt-mac-address.impresso = YES.
        ELSE DO:
            ASSIGN tt-mac-address.impresso = NO.

            IF l-todos-imp = YES 
            THEN ASSIGN tt-mac-address.impresso = YES.
        END.
            

        CREATE mac-address.
        ASSIGN mac-address.mac            = tt-mac-address.mac
               mac-address.mac-dec        = tt-mac-address.mac-dec
               mac-address.it-codigo      = tt-mac-address.it-codigo
               mac-address.cod-estabel    = IF AVAIL pedido-compr THEN pedido-compr.cod-estabel ELSE v_cod_estab_usuar
               mac-address.cod-unid-negoc = tt-mac-address.cod-unid-negoc
               mac-address.sequencia      = tt-mac-address.sequencia
               mac-address.usuario        = tt-mac-address.usuario
               mac-address.data           = tt-mac-address.data
               mac-address.impresso       = tt-mac-address.impresso
               mac-address.num-pedido     = i-nr-pedido
               mac-address.qtd-mac        = tt-mac-address.qtd-mac
               mac-address.projeto        = tt-mac-address.projeto
               mac-address.just-proj      = tt-mac-address.just-proj
               mac-address.lote           = i-lote
               mac-address.buffer-mac     = IF AVAIL int-item-fornec THEN int-item-fornec.buffer-mac ELSE 0 NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            RUN piGeraErro(INPUT 17006,
                           INPUT "Erro ao gravar Mac Address: " + ERROR-STATUS:GET-MESSAGE(1)).
            UNDO Grava, LEAVE Grava.
        END.

        RELEASE mac-address.
    END.

    FOR EACH tt-mac-address BY tt-mac-address.mac-dec:
        /*grava £ltimo mac gerado*/
        FOR FIRST mac-address-param
            WHERE mac-address-param.sequencia = tt-mac-address.sequencia EXCLUSIVE-LOCK:

            ASSIGN mac-address-param.mac-ult = SUBSTRING(tt-mac-address.mac,7,6).

            IF mac-address-param.alerta = mac-address-param.mac-ult THEN
                RUN piGeraAlerta.
        END.

        RELEASE mac-address-param.

        /* Gerar Senhas MAC produtos 5G */
        RUN piGeraSenhasMac (INPUT tt-mac-address.mac,
                             OUTPUT c-senha-wifi,
                             OUTPUT c-senha-adm ).

        ASSIGN tt-mac-address.senha-wifi = c-senha-wifi
               tt-mac-address.senha-adm  = c-senha-adm. 

    END.
    RETURN "OK".
END. /*Grava*/

RETURN "NOK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraSenhasMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraSenhasMac Procedure 
PROCEDURE piGeraSenhasMac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p-mac        AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-senha-wifi AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-senha-adm  AS CHAR NO-UNDO.

DEFINE VARIABLE cFormataSenha AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSenhaWIFI    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSenhaADM     AS CHARACTER NO-UNDO.

FIND FIRST mac-address WHERE mac-address.mac = p-mac EXCLUSIVE-LOCK NO-ERROR.

IF AVAIL mac-address THEN DO:

   FIND FIRST item-ean WHERE item-ean.it-codigo = mac-address.it-codigo NO-LOCK NO-ERROR.

   IF AVAIL item-ean THEN DO:
      ASSIGN cSenhaWIFI = ""
             cSenhaADM  = "".
   
      /* MAC + GPON codigo de barras / QR CODE com senha ADMIN+ Senha WIFI */
      IF item-ean.modelo-mac-address = 6 OR item-ean.modelo-mac-address = 9 THEN DO:
         ASSIGN cFormataSenha = TRIM(item-ean.texto[5]) + '||' + mac-address.mac. 
   
         ASSIGN cFormataSenha = LOWER(REPLACE(cFormataSenha,' ','')).
         
         RUN esapi/esapi016x.p (INPUT cFormataSenha,
                                OUTPUT cSenhaWIFI ,
                                OUTPUT cSenhaADM ).
   
         ASSIGN mac-address.char-1 = cSenhaWIFI
                mac-address.char-2 = cSenhaADM.

         ASSIGN p-senha-wifi = cSenhaWIFI 
                p-senha-adm  = cSenhaADM. 

      END.
   END. /* AVAIL item-ean */

   RELEASE mac-address.

END. /* FOR EACH mac-address */






END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPreMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPreMac Procedure 
PROCEDURE piPreMac :
/*------------------------------------------------------------------------------
  Purpose:    Repassado rotina de prÇ criaá∆o do MAC para a API 
  Parameters:  <percentual buffer e temp-table dos itens de pedidos de compra>
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER TABLE FOR ttItem.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mac-address.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE d-qtd-item      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-faixa-ini  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-sequencia-aux AS INTEGER     NO-UNDO.

bl-item: FOR EACH ttItem
    /*WHERE ttitem.marcado = YES*/ BREAK BY ttItem.it-codigo:

    IF  FIRST-OF(ttItem.it-codigo) THEN DO:
        
        ASSIGN d-qtd-item = 0.

        FIND FIRST item-ean
            WHERE item-ean.it-codigo = ttItem.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAIL item-ean THEN DO:
            CREATE item-ean.
            ASSIGN item-ean.it-codigo = ttItem.it-codigo.
        END.

        IF item-ean.qtd-mac = 0 AND ttItem.projeto = NO THEN DO:
            RUN piGeraErro(INPUT 27979,
                           INPUT "N∆o foi poss°vel gerar Mac Address.~~" +
                                 "O item " + item-ean.it-codigo + " n∆o utiliza Mac Address. Caso necess†rio, solicitar a parametrizaá∆o para o departamento de Engenharia Industrial.").
        END.
    END.

    ASSIGN d-qtd-item = (ttItem.qt-pedido + (ttItem.qt-pedido * ttItem.buffer-mac / 100) - ttItem.gerado-mac) * (IF ttItem.projeto THEN ttItem.qtd-mac ELSE item-ean.qtd-mac).

    IF LAST-OF(ttItem.it-codigo) THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC Address - ITEM:":U + ttItem.it-codigo).

        IF (NOT (item-ean.qtd-mac = 0 AND ttItem.qtd-mac = 0)) AND d-qtd-item > 0 THEN DO:
            ASSIGN v-faixa-ini  = "".

            FOR LAST tt-mac-address NO-LOCK BY tt-mac-address.mac-dec: END.

            IF AVAIL tt-mac-address THEN DO:
                FOR EACH mac-address-param
                    WHERE mac-address-param.sequencia >= i-sequencia-aux NO-LOCK BY mac-address-param.sequencia:

                    IF NOT(mac-address-param.faixa-fim = SUBSTRING(tt-mac-address.mac,7,6)) AND v-faixa-ini = "" THEN DO:
                        IF mac-address-param.sequencia = i-sequencia-aux THEN DO:
                            IF conv-hex-to-dec(SUBSTRING(tt-mac-address.mac,7,6)) + d-qtd-item <= conv-hex-to-dec(mac-address-param.faixa-fim)  THEN
                                ASSIGN v-faixa-ini     = conv-dec-to-hex(conv-hex-to-dec(SUBSTRING(tt-mac-address.mac,7,6)) + 1).
                        END.
                        ELSE DO:
                            IF mac-address-param.mac-ult <> "" THEN DO:
                                IF conv-hex-to-dec(mac-address-param.mac-ult) + d-qtd-item <= conv-hex-to-dec(mac-address-param.faixa-fim)  THEN
                                    ASSIGN v-faixa-ini     = conv-dec-to-hex(conv-hex-to-dec(mac-address-param.mac-ult) + 1)
                                           i-sequencia-aux = mac-address-param.sequencia.
                            END.
                            ELSE DO:
                                IF conv-hex-to-dec(mac-address-param.faixa-ini) + d-qtd-item - 1 <= conv-hex-to-dec(mac-address-param.faixa-fim)  THEN
                                    ASSIGN v-faixa-ini     = mac-address-param.faixa-ini
                                           i-sequencia-aux = mac-address-param.sequencia.
                            END.
                        END.                        
                    END.
                END.

            END.
            ELSE DO:
                FOR EACH mac-address-param NO-LOCK BY mac-address-param.sequencia:
                    IF NOT(mac-address-param.faixa-fim = mac-address-param.mac-ult) AND v-faixa-ini = ""  THEN DO:

                        IF mac-address-param.mac-ult <> "" THEN DO:
                            IF conv-hex-to-dec(mac-address-param.mac-ult) + d-qtd-item <= conv-hex-to-dec(mac-address-param.faixa-fim)  THEN
                                ASSIGN v-faixa-ini     = conv-dec-to-hex(conv-hex-to-dec(mac-address-param.mac-ult) + 1)
                                       i-sequencia-aux = mac-address-param.sequencia.
                        END.
                        ELSE DO:
                            IF conv-hex-to-dec(mac-address-param.faixa-ini) + d-qtd-item - 1 <= conv-hex-to-dec(mac-address-param.faixa-fim)  THEN
                                ASSIGN v-faixa-ini     = mac-address-param.faixa-ini
                                       i-sequencia-aux = mac-address-param.sequencia.
                        END.
                    END.
                END.
            END.

            IF v-faixa-ini = "" THEN DO:
                RUN piGeraErro(INPUT 17006,
                               INPUT "N∆o foi encontrado faixa que permita geraá∆o de " + TRIM(STRING(d-qtd-item)) + " endereáo(s) Mac em sequància. Solicitar cadastro de nova faixa ao P&D Homologaá∆o.").
                RETURN "NOK".
            END.

            ASSIGN i-cont = 0.

            FIND FIRST mac-address-param WHERE mac-address-param.sequencia = i-sequencia-aux NO-LOCK NO-ERROR.

            IF NOT AVAIL mac-address-param THEN DO:
                RUN piGeraErro(INPUT 17006,
                               INPUT "ParÉmetros Mac Address n∆o encontrado.~~~~N∆o foi encontrado Mac Address ParÉmetros. Favor verificar").
                RETURN "NOK".
            END.

            REPEAT:
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + STRING(mac-address-param.faixa, "x(6)":U) + STRING(v-faixa-ini, "x(6)":U)).

                CREATE tt-mac-address.
                ASSIGN tt-mac-address.mac            = STRING(mac-address-param.faixa, "x(6)":U) + STRING(v-faixa-ini, "x(6)":U)
                       tt-mac-address.mac-dec        = conv-hex-to-dec(v-faixa-ini)
                       tt-mac-address.it-codigo      = item-ean.it-codigo
                       tt-mac-address.sequencia      = mac-address-param.sequencia
                       tt-mac-address.usuario        = c-seg-usuario
                       tt-mac-address.qtd-mac        = (IF ttItem.projeto THEN ttItem.qtd-mac ELSE item-ean.qtd-mac)
                       tt-mac-address.data           = NOW
                       tt-mac-address.projeto        = ttItem.projeto
                       tt-mac-address.just-proj      = ttItem.just-proj.

                ASSIGN i-cont = i-cont + 1.

                IF i-cont >= d-qtd-item THEN
                    LEAVE.

                ASSIGN v-faixa-ini = conv-dec-to-hex(conv-hex-to-dec(v-faixa-ini) + 1).

                IF conv-hex-to-dec(v-faixa-ini) > conv-hex-to-dec(mac-address-param.faixa-fim) THEN DO:
                    FIND NEXT mac-address-param NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE mac-address-param THEN
                        LEAVE.

                    ASSIGN v-faixa-ini = mac-address-param.faixa-ini.
                END.
            END.
        END. /* se quantidade mac for informada */
    END.
END. /*bl-item*/

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidaPedidoComp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaPedidoComp Procedure 
PROCEDURE piValidaPedidoComp :
/*------------------------------------------------------------------------------
  Purpose:    Verifica se pedido informado Ç valido e retorna informaá‰es do 
              emitente 
  Parameters:  <Nr.Pedido, Cod.Emitente,Nome, Email e tt-erro>
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER i-nr-pedido AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER i-emitente  AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER c-nome      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-email     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

EMPTY TEMP-TABLE tt-erro.

FIND FIRST pedido-compr
    WHERE pedido-compr.num-pedido = i-nr-pedido NO-LOCK NO-ERROR.

IF  NOT AVAIL pedido-compr THEN DO:
    RUN piGeraErro(17006,"Pedido n∆o cadastrado").
    RETURN "NOK".
END. /* IF  NOT AVAIL pedido-compr */
    
FIND FIRST emitente WHERE 
           emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

IF NOT AVAIL emitente THEN DO:
    RUN piGeraErro(17006,"Fornecedor do pedido n∆o cadastrado").
    RETURN "NOK".
END. /* IF NOT AVAIL emitente */

ASSIGN i-emitente = pedido-compr.cod-emitente
       c-nome     = emitente.nome-abrev.

IF c-email = "" THEN DO:
    FOR FIRST cont-emit
        WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK:

        ASSIGN c-email = cont-emit.e-mail.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-conv-dec-to-hex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-dec-to-hex Procedure 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Converte decimal para hexadecimal
    Notes:  Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-simbolos AS CHARACTER NO-UNDO FORMAT "X(1)" EXTENT 16
    INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

DEFINE VARIABLE c-val-hexadecimal AS CHARACTER NO-UNDO INITIAL "":U.
DEFINE VARIABLE i-quociente       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE i-resto           AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE c-aux             AS CHARACTER NO-UNDO.

ASSIGN i-quociente = p-num-decimal.

REPEAT:
    ASSIGN i-resto           = i-quociente MODULO 16
           i-quociente       = TRUNCATE((i-quociente / 16), 0)
           c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

    IF i-quociente <= 0 THEN
        LEAVE.
END.

IF LENGTH(c-val-hexadecimal) < 6 THEN
    ASSIGN c-aux             = FILL("0",6 - LENGTH(c-val-hexadecimal))
           c-val-hexadecimal = c-aux + c-val-hexadecimal.

RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-conv-hex-to-dec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-hex-to-dec Procedure 
FUNCTION conv-hex-to-dec RETURNS DECIMAL
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS DECIMAL     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).

    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fator Procedure 
FUNCTION fator RETURNS DECIMAL
  ( INPUT p-fator AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS DECIMAL     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnGeraLoteMac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGeraLoteMac Procedure 
FUNCTION fnGeraLoteMac RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Gera n£mero sequencia para o lote Mac 
    Notes: Carlos Daniel - 23/09/2015
------------------------------------------------------------------------------*/
DEFINE BUFFER bf-mac-address FOR mac-address.

FOR LAST bf-mac-address NO-LOCK USE-INDEX lote:
    RETURN bf-mac-address.lote + 1.
END.

RETURN 1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

