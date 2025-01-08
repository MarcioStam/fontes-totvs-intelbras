  {cdp/cd0666.i} 
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE INPUT PARAM r-row-ped-item AS ROWID.
DEFINE INPUT PARAM p-cod-depos    AS CHAR.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE vQtAlocar              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vQtAlocar-aux          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vQtAlocar-param        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desaloca-item-astec AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-alocacao             AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esapi018             AS HANDLE      NO-UNDO.

FIND FIRST ped-item NO-LOCK
     WHERE ROWID(ped-item) = r-row-ped-item NO-ERROR.

IF NOT AVAIL ped-item THEN
    RETURN "NOK".

FIND FIRST ped-venda OF ped-item NO-LOCK NO-ERROR.

BLOCO:
DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp091"
          AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia = int(ped-venda.tp-pedido):

        IF INDEX(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo.
        END.
    END.

    FIND FIRST permissao-alocacao NO-LOCK
         WHERE permissao-alocacao.it-codigo = ped-item.it-codigo NO-ERROR.

    IF  AVAIL permissao-alocacao 
    AND permissao-alocacao.usuario <> c-seg-usuario THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Usu†rio sem permiss∆o para alocaá∆o deste item. Este item esta bloqueado pelo usuario : " + permissao-alocacao.usuario.
    END.
    
    FIND FIRST ped-ent NO-LOCK
         WHERE ped-ent.nome-abrev   = ped-item.nome-abrev  
           AND ped-ent.nr-pedcli    = ped-item.nr-pedcli   
           AND ped-ent.nr-sequencia = ped-item.nr-sequencia
           AND ped-ent.it-codigo    = ped-item.it-codigo   
           AND ped-ent.cod-refer    = ped-item.cod-refer  NO-ERROR.

    IF NOT AVAIL ped-ent THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Ped Ent n∆o encontrada".
    END.    

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".  

    ASSIGN vQtAlocar     = ped-item.qt-log-aloca
           vQtAlocar-aux = vQtAlocar.
 
    blk_saldo:
    FOR EACH ped-saldo NO-LOCK
       WHERE ped-saldo.cod-depos   = p-cod-depos  
         AND ped-saldo.cod-estabel = ped-venda.cod-estabel 
         AND ped-saldo.nome-abrev  = ped-ent.nome-abrev      
         AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       
         AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia    
         AND ped-saldo.it-codigo   = ped-ent.it-codigo       
         AND ped-saldo.cod-refer   = ped-ent.cod-refer       
         AND ped-saldo.nr-entrega  = ped-ent.nr-entrega:

        FIND FIRST saldo-estoq OF ped-saldo NO-LOCK NO-ERROR.

        IF NOT AVAIL saldo-estoq THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Saldo estoque n∆o encontrado".
            RETURN "NOK".
        END.

        IF ped-saldo.qt-aloc-ped >= vQtAlocar-aux THEN
            ASSIGN vQtAlocar-param = vQtAlocar-aux
                   vQtAlocar-aux   = 0.
        ELSE 
            ASSIGN vQtAlocar-param = ped-saldo.qt-aloc-ped
                   vQtAlocar-aux   = vQtAlocar-aux - ped-saldo.qt-aloc-ped.
        
        RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.    
        RUN pi-desaloca-fisica-man in h-alocacao(INPUT ROWID(ped-ent),
                                                 INPUT-OUTPUT vQtAlocar-param, 
                                                 INPUT ROWID(saldo-estoq)).

        IF VALID-HANDLE(h-alocacao) THEN
            DELETE PROCEDURE h-alocacao.
        
        IF RETURN-VALUE = "NOK" THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "N∆o foi possivel efetuar a desalocaá∆o f°sica do material!".
            
            UNDO bloco, LEAVE bloco.
        END.

        IF vQtAlocar-aux = 0 THEN
            LEAVE blk_saldo.
    END.
    
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
           AND item-uni-estab.it-codigo   = ped-item.it-codigo
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.

    IF AVAIL item-uni-estab THEN DO:
        RUN esapi/esapi009.p (input ped-venda.cod-estabel,
                              INPUT ped-item.it-codigo,
                              INPUT p-cod-depos,  
                              INPUT "",
                              INPUT vQtAlocar,
                              OUTPUT TABLE tt-erro).

        
        /*Conforme Anderson Cenci deve ignorar este erro*/
        FOR EACH tt-erro
           WHERE tt-erro.cd-erro = 27607:
            DELETE tt-erro.
        END.

        IF CAN-FIND(FIRST tt-erro) THEN 
            UNDO bloco, LEAVE bloco.
    END.

    IF CAN-FIND(FIRST int-ped-item-astec
                WHERE int-ped-item-astec.nome-abrev   = ped-item.nome-abrev
                  AND int-ped-item-astec.nr-pedcli    = ped-item.nr-pedcli
                  AND int-ped-item-astec.nr-sequencia = ped-item.nr-sequencia
                  AND int-ped-item-astec.it-codigo    = ped-item.it-codigo) THEN DO:

        EMPTY TEMP-TABLE RowErrors.

        IF  NOT VALID-HANDLE(h-esapi018) THEN
            RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN DO:
            RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ped-item.nome-abrev,
                                                           INPUT ped-item.nr-pedcli,
                                                           INPUT ped-item.nr-sequencia,
                                                           INPUT ped-item.it-codigo,
                                                           INPUT 2,
                                                           INPUT de-desaloca-item-astec).

            IF RETURN-VALUE = "NOK":U THEN
                RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
        END.

        IF VALID-HANDLE(h-esapi018) THEN
            RUN destroy IN h-esapi018.

        IF VALID-HANDLE(h-esapi018) THEN
            DELETE PROCEDURE h-esapi018.

        ASSIGN h-esapi018 = ?.

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = RowErrors.ErrorDescription.
            END.
            UNDO bloco, LEAVE bloco.
        END.
    END.
END. /* DO TRANSACTION */




RETURN "OK":U.
