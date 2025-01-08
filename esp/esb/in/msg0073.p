CREATE WIDGET-POOL.

/* DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.  */
/* DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.  */

DEFINE VARIABLE iXML  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE oXML  AS CHARACTER   NO-UNDO.

{esp/esb/in/msg0073.i}

DEFINE BUFFER b-emitente FOR emitente.

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0073
   DATA-RELATION FOR conteudo, msg0073 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, msg0073r, conteudor, resultado
   data-relation for conteudor, msg0073r  relation-fields (idm, idm) nested
   data-relation for msg0073r, resultado relation-fields (idm, idm) nested.

CREATE msg0073.
ASSIGN msg0073.CodigoConta = "195824".

FIND msg0073 NO-ERROR.

FIND FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = INT(msg0073.CodigoConta) NO-ERROR.

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:
    IF AVAIL emitente THEN DO:

        RUN pi-elimina-conta.
    
        IF CAN-FIND (FIRST tt-erro) THEN
            UNDO blk_principal, LEAVE blk_principal.
    END.
    ELSE DO:
        RUN pi-erro (INPUT "Cliente n∆o cadastrado").
    END.
END.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor to cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0073R'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006.
    FOR EACH tt-erro:
        ASSIGN resultado.Mensagem = resultado.Mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE pi-elimina-conta:
    FIND FIRST b-emitente USE-INDEX ch-matriz
         WHERE b-emitente.nome-matriz = emitente.nome-abrev
           AND b-emitente.nome-abrev <> emitente.nome-abrev
           AND b-emitente.identific  <> 2
           AND rowid(b-emitente) <> rowid(emitente) NO-LOCK NO-ERROR.
    IF AVAIL b-emitente THEN DO:
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 243,
                         INPUT "").   /* Cliente possui filiais */
      RUN pi-erro (INPUT RETURN-VALUE + " - 243").
    END.

    FIND FIRST b-emitente USE-INDEX ch-cobranca
         WHERE b-emitente.END-cobranca = emitente.cod-emitente
           AND b-emitente.nome-abrev  <> emitente.nome-abrev
           AND b-emitente.identific <> 2
           AND rowid(b-emitente) <> rowid(emitente) NO-LOCK NO-ERROR.
    IF AVAIL b-emitente THEN DO:  
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 244,
                         INPUT b-emitente.nome-abrev).   /* Cliente Cadastrado como ENDereco de Cobranca do cliente */
      RUN pi-erro (INPUT RETURN-VALUE + " - 244").
    END.

    FIND FIRST ped-vENDa USE-INDEX ch-pedido
         WHERE ped-vENDa.nome-abrev = emitente.nome-abrev
         NO-LOCK NO-ERROR.
    IF AVAIL ped-vENDa THEN DO:        
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 245,
                         INPUT "").   /* Cliente possui Pedido de VENDa ativo */
      RUN pi-erro (INPUT RETURN-VALUE + " - 245").
    END.

    FIND FIRST nota-fiscal USE-INDEX ch-pedido
         WHERE nota-fiscal.nome-ab-cli = emitente.nome-abrev
         NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 217,
                         INPUT "").   /* Cliente possui Nota Fiscal ativa */
      RUN pi-erro (INPUT RETURN-VALUE + " - 217").
    END.

    FIND FIRST doc-fiscal USE-INDEX ch-emitente
         WHERE doc-fiscal.cod-emitente = emitente.cod-emitente
         AND   doc-fiscal.tipo-nat     = 2
         NO-LOCK NO-ERROR.
    IF AVAIL doc-fiscal THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 219,
                         INPUT "").   /* Cliente possui Documento Fiscal ativo */
      RUN pi-erro (INPUT RETURN-VALUE + " - 219").
    END.

    FIND FIRST titulo USE-INDEX emitente
         WHERE titulo.cod-emitente = emitente.cod-emitente
         NO-LOCK NO-ERROR.
    IF AVAIL titulo THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 220,
                         INPUT "").   /* Cliente possui Titulo ativo */
      RUN pi-erro (INPUT RETURN-VALUE + " - 220").
    END.


    FIND FIRST info-cli USE-INDEX ch-cliinf
         WHERE info-cli.nome-abrev = emitente.nome-abrev 
         NO-LOCK NO-ERROR.
    IF  AVAIL info-cli THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 221,
                         INPUT "").   /* Cliente possui Informacoes Cadastradas */
      RUN pi-erro (INPUT RETURN-VALUE + " - 221").
    END.

    FIND FIRST item-cli USE-INDEX ch-cli-item
         WHERE item-cli.nome-abrev = emitente.nome-abrev 
         NO-LOCK NO-ERROR.
    IF AVAIL item-cli THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 222,
                         INPUT "").   /* Cliente possui Itens Cadastrados */
      RUN pi-erro (INPUT RETURN-VALUE + " - 222").
    END.

    FIND FIRST fam-equipto 
         WHERE fam-equipto.fornec-at = emitente.nome-abrev
         NO-LOCK NO-ERROR.
    IF AVAIL fam-equipto THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 223,
                         INPUT "").   /* Cliente possui familias de Equipamentos cadastradas */
      RUN pi-erro (INPUT RETURN-VALUE + " - 223").
    END.

    FIND FIRST equipto 
         WHERE equipto.fornec-at = emitente.nome-abrev
         NO-LOCK NO-ERROR.
    IF AVAIL equipto THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 226,
                         INPUT "").   /* Cliente possui Equipamentos cadastrados */
      RUN pi-erro (INPUT RETURN-VALUE + " - 226").
    END.

    FIND FIRST estab-cli USE-INDEX ch-cliest
         WHERE estab-cli.nome-abrev = emitente.nome-abrev 
         NO-LOCK NO-ERROR.
    IF AVAIL estab-cli THEN DO:              
      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 238,
                         INPUT "").  /* Cliente possui Estabelecimento ativo */  
      RUN pi-erro (INPUT RETURN-VALUE + " - 238").
    END.


    IF emitente.identific = 1 
    OR emitente.identific = 3 THEN DO:

        FIND FIRST item-cli 
             WHERE item-cli.cod-emitente = emitente.cod-emitente
             NO-LOCK NO-ERROR.
        IF  AVAIL item-cli THEN DO:              
            RUN utp/ut-msgs.p (INPUT "help":U,
                               INPUT 228,
                               INPUT "").   /* Cliente possui relacionamento item/cliente. */
            RUN pi-erro (INPUT RETURN-VALUE + " - 228").
        END.

        FIND FIRST devol-cli 
             WHERE devol-cli.cod-emitente = emitente.cod-emitente
             NO-LOCK NO-ERROR.
        IF AVAIL devol-cli THEN DO:              
           RUN utp/ut-msgs.p (INPUT "help":U,
                              INPUT 232,
                              INPUT "").   /* Cliente possui nota de devolucao de cliente. */
           RUN pi-erro (INPUT RETURN-VALUE + " - 232").
        END.

        FIND FIRST fat-estat 
             WHERE fat-estat.cod-emitente = emitente.cod-emitente
             NO-LOCK NO-ERROR.
        IF AVAIL fat-estat THEN DO:              
           RUN utp/ut-msgs.p (INPUT "help":U,
                              INPUT 233,
                              INPUT "").   /* Cliente consta nas Estatisticas do Faturamento. */
           RUN pi-erro (INPUT RETURN-VALUE + " - 233").
        END.

        FIND FIRST ped-pmp 
             WHERE ped-pmp.cod-emitente = emitente.cod-emitente
             NO-LOCK NO-ERROR.
        IF AVAIL ped-pmp THEN DO:              
           RUN utp/ut-msgs.p (INPUT "help":U,
                              INPUT 234,
                              INPUT "").   /* Cliente consta nas Estatisticas para o Plano Mestre. */
           RUN pi-erro (INPUT RETURN-VALUE + " - 234").
        END.

        FIND FIRST prog-cli 
             WHERE prog-cli.cod-emitente = emitente.cod-emitente
             NO-LOCK NO-ERROR.
        IF AVAIL prog-cli THEN DO:              
          RUN utp/ut-msgs.p (INPUT "help":U,
                             INPUT 235,
                             INPUT "").   /* Cliente possui programacao de entrega. */
          RUN pi-erro (INPUT RETURN-VALUE + " - 235").
        END.
    END.   

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    FOR EACH his-emit
       WHERE his-emit.cod-emitente = emitente.cod-emitente
       EXCLUSIVE-LOCk:
       DELETE his-emit.
    END.
    
    FOR EACH loc-entr EXCLUSIVE-LOCk
         WHERE loc-entr.nome-abrev = emitente.nome-abrev:  
        FIND FIRST emitente EXCLUSIVE-LOCk WHERE emitente.nome-abrev = emitente.nome-abrev.
       DELETE loc-entr.
       IF AVAIL emitente THEN ASSIGN emitente.cod-entrega = "". 
    END.

    FIND estatist
         WHERE estatist.cod-emitente = emitente.cod-emitente
         EXCLUSIVE-LOCk NO-ERROR.
    IF  AVAIL estatist THEN DO:
        DELETE estatist.
    END.

    FOR EACH emit-estat 
       WHERE emit-estat.cod-gr-emit  = emitente.cod-gr-cli 
         AND emit-estat.cod-emitente = emitente.cod-emitente
       EXCLUSIVE-LOCk:
       DELETE emit-estat.
    END.

    FOR EACH emit-estat 
       WHERE emit-estat.cod-gr-emit  = emitente.cod-gr-forn 
         AND emit-estat.cod-emitente = emitente.cod-emitente 
       EXCLUSIVE-LOCk:
       DELETE emit-estat.
    END.

    FOR EACH cont-emit 
        WHERE cont-emit.cod-emit = emitente.cod-emit 
        EXCLUSIVE-LOCk:
        DELETE cont-emit.
    END.

    IF CAN-FIND(FIRST his-doc-fiscal
        WHERE his-doc-fiscal.cod-emitente = emitente.cod-emitente) THEN DO:
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 5,
                           INPUT "Emitente" + "~~" + "Hist¢rico Documento Fiscal").
        RUN pi-erro (INPUT RETURN-VALUE).
     END. 

     IF CAN-FIND(FIRST item-fornec
        WHERE item-fornec.cod-emit = emitente.cod-emitente) THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 5,
                           INPUT "Emitente" + "~~" + "ITEM Fornecedor").
        RUN pi-erro (INPUT RETURN-VALUE).
     END. 

     IF CAN-FIND(FIRST ordem-compra use-index emitente
        WHERE ordem-compra.cod-emit = emitente.cod-emitente) THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 5,
                           INPUT "Emitente" + "~~" + "Ordem de compra").
        RUN pi-erro (INPUT RETURN-VALUE).
     END.    

     IF CAN-FIND(FIRST cotacao-item use-index emitente
        WHERE cotacao-item.cod-emit = emitente.cod-emitente) THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 5,
                           INPUT "Emitente" + "~~" + "Cotaá∆o ITEM").
        RUN pi-erro (INPUT RETURN-VALUE).
     END.          

     IF CAN-FIND(FIRST pedido-compr use-index emitente
        WHERE pedido-compr.cod-emit = emitente.cod-emitente) THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 5,
                           INPUT "Emitente" + "~~" + "Pedido Compra").
        RUN pi-erro (INPUT RETURN-VALUE).
     END. 

     IF CAN-FIND (FIRST tt-erro) THEN
         RETURN "NOK".

     IF CAN-FIND(funcao WHERE funcao.cd-funcao = "adm-cdc-ems-5.00"
     AND funcao.ativo = YES
     AND funcao.log-1 = YES) THEN 
         RUN cdp/cd1608.p (INPUT emitente.cod-emitente,
                           INPUT emitente.cod-emitente,
                           INPUT 1,
                           INPUT YES,
                           INPUT 2,
                           INPUT 0,
                           INPUT "",
                           INPUT "Arquivo":U,
                           INPUT "").

     FIND CURRENT emitente EXCLUSIVE-LOCK.
     DELETE emitente.
END PROCEDURE.
