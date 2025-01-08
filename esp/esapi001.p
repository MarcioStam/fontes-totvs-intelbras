/*------------------------------------------------------------------------
    File        : ESAPI001.P
    Purpose     : Retornar saldos, alocar e comprometer limites do cart∆o
                  Intelbras Clube (SupplierCard).
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Novembro de 2011
    Notes       : <none>
----------------------------------------------------------------------*/

/* Include Definitions ---                                              */

{cdp/cd0666.i} /* Temp-table tt-erro */


/* ************************  Function Prototypes ********************** */

FUNCTION fn-cond-pag-supcard RETURNS LOGICAL
  ( p-cod-cond-pag AS INTEGER )  FORWARD.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-saldo-raiz-cnpj:
/*------------------------------------------------------------------------------
  Purpose:     Retornar o saldo alocado e faturado (hoje) dos limites do cart∆o
               Intelbras Clube (SupplierCard) de acordo com a raiz do cnpj (8 
               primeiros d°gitos).
  Parameters:  INPUT  p-raiz-cnpj           (LIKE int-emitente-supcard.raiz-cnpj)
               OUTPUT p-val-lim-tot-supcard (LIKE int-emitente-supcard.val-limite)
               OUTPUT p-val-lim-supcard     (LIKE int-emitente-supcard.val-limite)
               OUTPUT p-saldo-alocado       (LIKE int-ped-aloc-supcard.val-item-alocado)
               OUTPUT p-saldo-faturado      (LIKE int-nfs-supcard.val-faturado)
               OUTPUT p-saldo-disp-supcard  (LIKE int-emitente-supcard.val-limite)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-raiz-cnpj           LIKE int-emitente-supcard.raiz-cnpj        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-lim-tot-supcard LIKE int-emitente-supcard.val-limite       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-lim-supcard     LIKE int-emitente-supcard.val-limite       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-alocado       LIKE int-ped-aloc-supcard.val-item-alocado NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-faturado      LIKE int-nfs-supcard.val-faturado          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-disp-supcard  LIKE int-emitente-supcard.val-limite       NO-UNDO.

    DEFINE VARIABLE i-aux         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-num-transac AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    IF LENGTH(p-raiz-cnpj) <> 8 THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Raiz CNPJ inv†lido.~~A Raiz do CNPJ deve conter 8 d°gitos numÇricos.":U).

        RETURN "NOK":U.
    END.

    ASSIGN i-aux = INTEGER(p-raiz-cnpj) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Raiz CNPJ inv†lido.~~A Raiz do CNPJ deve conter apenas n£meros.":U).

        RETURN "NOK":U.
    END.

    ASSIGN p-val-lim-supcard    = 0
           p-saldo-alocado      = 0
           p-saldo-faturado     = 0
           p-saldo-disp-supcard = 0.

    FIND FIRST int-emitente-supcard
        WHERE int-emitente-supcard.raiz-cnpj      = p-raiz-cnpj
          AND int-emitente-supcard.dat-avaliacao  = TODAY
          AND int-emitente-supcard.log-habilitado = YES NO-LOCK NO-ERROR.

    IF AVAILABLE int-emitente-supcard THEN
        ASSIGN p-val-lim-tot-supcard = int-emitente-supcard.val-limite + int-emitente-supcard.val-limite-utilizado
               p-val-lim-supcard     = int-emitente-supcard.val-limite.
    ELSE
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "N∆o existe limite do cart∆o Intelbras Clube habilitado para hoje.~~N∆o existe limite para a raiz do CNPJ ":U + p-raiz-cnpj + " do cart∆o Intelbras Clube habilitado para hoje.":U).

    FOR EACH int-ped-aloc-supcard NO-LOCK USE-INDEX idx-raiz-cnpj
        WHERE int-ped-aloc-supcard.raiz-cnpj        = p-raiz-cnpj
          AND int-ped-aloc-supcard.val-item-alocado > 0:
        ASSIGN p-saldo-alocado = p-saldo-alocado + int-ped-aloc-supcard.val-item-alocado.
    END.

    FOR EACH  int-nfs-supcard NO-LOCK USE-INDEX idx-raiz-cnpj
        WHERE int-nfs-supcard.raiz-cnpj  = p-raiz-cnpj
          AND int-nfs-supcard.dat-movto >= TODAY - 30:

        ASSIGN c-num-transac = STRING(INT(int-nfs-supcard.cod-estabel), "9999") + STRING(INT(int-nfs-supcard.serie), "999") + STRING(INT(int-nfs-supcard.nr-nota-fis), "9999999").

        /* Verifica se a nota j† foi enviada para a SupplierCard, e teve um retorno (8.3) */
        FOR FIRST int-emitente-supcard-ocor NO-LOCK                    
            WHERE int-emitente-supcard-ocor.num-transac = c-num-transac
              AND int-emitente-supcard-ocor.ind-ocor    = "8.3":
        END.

        IF  AVAIL int-emitente-supcard-ocor THEN
            NEXT.

/*         IF  CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK                     */
/*                      WHERE int-emitente-supcard-ocor.num-transac = c-num-transac */
/*                      AND   int-emitente-supcard-ocor.ind-ocor    = "8.3") THEN   */
/*             NEXT.                                                                */

        ASSIGN p-saldo-faturado = p-saldo-faturado + int-nfs-supcard.val-faturado.
    END.

    ASSIGN p-saldo-disp-supcard = p-val-lim-supcard - (p-saldo-alocado + p-saldo-faturado).

    IF p-saldo-disp-supcard < 0 THEN
        ASSIGN p-saldo-disp-supcard = 0.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-saldo-ped-item:
/*------------------------------------------------------------------------------
  Purpose:     Retornar o saldo alocado por um determinado item do pedido do
               cart∆o Intelbras Clube (SupplierCard).
  Parameters:  INPUT p-nome-abrev     (LIKE int-ped-aloc-supcard.nome-abrev)
               INPUT p-nr-pedcli      (LIKE int-ped-aloc-supcard.nr-pedcli)
               INPUT p-it-codigo      (LIKE int-ped-aloc-supcard.it-codigo)
               OUTPUT p-saldo-alocado (LIKE int-ped-aloc-supcard.val-item-alocado)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev     LIKE int-ped-aloc-supcard.nome-abrev       NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli      LIKE int-ped-aloc-supcard.nr-pedcli        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo      LIKE int-ped-aloc-supcard.it-codigo        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-alocado  LIKE int-ped-aloc-supcard.val-item-alocado NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST int-ped-aloc-supcard
        WHERE int-ped-aloc-supcard.nome-abrev = p-nome-abrev
          AND int-ped-aloc-supcard.nr-pedcli  = p-nr-pedcli
          AND int-ped-aloc-supcard.it-codigo  = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE int-ped-aloc-supcard THEN
        ASSIGN p-saldo-alocado = int-ped-aloc-supcard.val-item-alocado.
    ELSE
        ASSIGN p-saldo-alocado = 0.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-saldo-nota-fisc:
/*------------------------------------------------------------------------------
  Purpose:     Retornar o saldo comprometido por um determinado item da nota
               fiscal do cart∆o Intelbras Clube (SupplierCard).
  Parameters:  INPUT  p-cod-estabel    (LIKE int-nfs-supcard.cod-estabel)
               INPUT  p-serie          (LIKE int-nfs-supcard.serie)
               INPUT  p-nr-nota-fis    (LIKE int-nfs-supcard.nr-nota-fis)
               INPUT  p-it-codigo      (LIKE int-nfs-supcard.it-codigo)
               OUTPUT p-saldo-faturado (LIKE int-nfs-supcard.val-faturado)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel    LIKE int-nfs-supcard.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie          LIKE int-nfs-supcard.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fis    LIKE int-nfs-supcard.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo      LIKE int-nfs-supcard.it-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-faturado LIKE int-nfs-supcard.val-faturado NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST int-nfs-supcard
        WHERE int-nfs-supcard.cod-estabel = p-cod-estabel
          AND int-nfs-supcard.serie       = p-serie
          AND int-nfs-supcard.nr-nota-fis = p-nr-nota-fis
          AND int-nfs-supcard.it-codigo   = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE int-nfs-supcard THEN
        ASSIGN p-saldo-faturado = p-saldo-faturado + int-nfs-supcard.val-faturado.
    ELSE
        ASSIGN p-saldo-faturado = 0.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-aloca-saldo-pedido:
/*------------------------------------------------------------------------------
  Purpose:     Alocar valor do item do pedido que foi alocado no cart∆o Intelbras
               Clube (SupplierCard).
  Parameters:  INPUT p-nome-abrev       (LIKE int-ped-aloc-supcard.nome-abrev)
               INPUT p-nr-pedcli        (LIKE int-ped-aloc-supcard.nr-pedcli)
               INPUT p-it-codigo        (LIKE int-ped-aloc-supcard.it-codigo)
               INPUT p-val-item-alocado (INPUT int-ped-aloc-supcard.val-item-alocado)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev       LIKE int-ped-aloc-supcard.nome-abrev       NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli        LIKE int-ped-aloc-supcard.nr-pedcli        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo        LIKE int-ped-aloc-supcard.it-codigo        NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-item-alocado LIKE int-ped-aloc-supcard.val-item-alocado NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST emitente
        WHERE emitente.nome-abrev = p-nome-abrev NO-LOCK NO-ERROR.

    IF NOT AVAILABLE emitente THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Emitente~~":U + "Nome abrev.: ":U + TRIM(STRING(p-nome-abrev))).

        RETURN "NOK":U.
    END.

    FIND FIRST ped-venda
        WHERE ped-venda.nome-abrev = emitente.nome-abrev
          AND ped-venda.nr-pedcli  = p-nr-pedcli NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ped-venda THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Pedido Venda~~":U + "Nome abrev.: ":U + TRIM(STRING(emitente.nome-abrev)) + ", Pedido Cliente: ":U + TRIM(STRING(p-nr-pedcli))).

        RETURN "NOK":U.
    END.

    FIND FIRST item
        WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Item~~":U + "Item: ":U + TRIM(STRING(p-it-codigo))).

        RETURN "NOK":U.
    END.

    FIND FIRST ped-item USE-INDEX ch-item-ped
        WHERE ped-item.nome-abrev = ped-venda.nome-abrev
          AND ped-item.nr-pedcli  = ped-venda.nr-pedcli
          AND ped-item.it-codigo  = item.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ped-item THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Item Pedido Venda~~":U + "Nome abrev.: ":U + TRIM(STRING(ped-venda.nome-abrev)) + ", Pedido Cliente: ":U + TRIM(STRING(ped-venda.nr-pedcli)) + ", Item: ":U + TRIM(STRING(item.it-codigo))).

        RETURN "NOK":U.
    END.

    FIND FIRST int-ped-aloc-supcard
        WHERE int-ped-aloc-supcard.raiz-cnpj  = SUBSTRING(emitente.cgc, 1, 8)
          AND int-ped-aloc-supcard.nome-abrev = emitente.nome-abrev
          AND int-ped-aloc-supcard.nr-pedcli  = ped-venda.nr-pedcli
          AND int-ped-aloc-supcard.it-codigo  = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE int-ped-aloc-supcard THEN DO:
        CREATE int-ped-aloc-supcard.
        ASSIGN int-ped-aloc-supcard.raiz-cnpj        = SUBSTRING(emitente.cgc, 1, 8)
               int-ped-aloc-supcard.nome-abrev       = emitente.nome-abrev
               int-ped-aloc-supcard.nr-pedcli        = ped-venda.nr-pedcli
               int-ped-aloc-supcard.it-codigo        = item.it-codigo
               int-ped-aloc-supcard.dat-movto        = TODAY
               int-ped-aloc-supcard.val-item-alocado = 0.
    END.

    ASSIGN int-ped-aloc-supcard.val-item-alocado = ROUND((int-ped-aloc-supcard.val-item-alocado + p-val-item-alocado), 2).

    FIND CURRENT int-ped-aloc-supcard NO-LOCK NO-ERROR.

    RELEASE int-ped-aloc-supcard NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-desaloca-saldo-pedido:
/*------------------------------------------------------------------------------
  Purpose:     Desalocar valor do item do pedido que foi alocado no cart∆o
               Intelbras Clube (SupplierCard).
  Parameters:  INPUT p-nome-abrev       (LIKE int-ped-aloc-supcard.nome-abrev)
               INPUT p-nr-pedcli        (LIKE int-ped-aloc-supcard.nr-pedcli)
               INPUT p-it-codigo        (LIKE int-ped-aloc-supcard.it-codigo)
               INPUT p-val-item-alocado (INPUT int-ped-aloc-supcard.val-item-alocado)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev       LIKE int-ped-aloc-supcard.nome-abrev       NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli        LIKE int-ped-aloc-supcard.nr-pedcli        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo        LIKE int-ped-aloc-supcard.it-codigo        NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-item-alocado LIKE int-ped-aloc-supcard.val-item-alocado NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST emitente
        WHERE emitente.nome-abrev = p-nome-abrev NO-LOCK NO-ERROR.

    IF NOT AVAILABLE emitente THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Emitente~~":U + "Nome abrev.: ":U + TRIM(STRING(p-nome-abrev))).

        RETURN "NOK":U.
    END.

    FIND FIRST int-ped-aloc-supcard
        WHERE int-ped-aloc-supcard.raiz-cnpj  = SUBSTRING(emitente.cgc, 1, 8)
          AND int-ped-aloc-supcard.nome-abrev = p-nome-abrev
          AND int-ped-aloc-supcard.nr-pedcli  = p-nr-pedcli
          AND int-ped-aloc-supcard.it-codigo  = p-it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE int-ped-aloc-supcard THEN DO:
        IF int-ped-aloc-supcard.val-item-alocado > p-val-item-alocado THEN
            ASSIGN int-ped-aloc-supcard.val-item-alocado = ROUND((int-ped-aloc-supcard.val-item-alocado - p-val-item-alocado), 2).
        ELSE DO:
            FIND FIRST nota-fiscal
                WHERE nota-fiscal.nome-ab-cli = p-nome-abrev
                  AND nota-fiscal.nr-pedcli   = p-nr-pedcli NO-LOCK NO-ERROR.

            IF AVAILABLE nota-fiscal THEN DO:
                FIND FIRST int-nfs-supcard
                    WHERE int-nfs-supcard.raiz-cnpj   = int-ped-aloc-supcard.raiz-cnpj
                      AND int-nfs-supcard.cod-estabel = nota-fiscal.cod-estabel
                      AND int-nfs-supcard.serie       = nota-fiscal.serie
                      AND int-nfs-supcard.nr-nota-fis = nota-fiscal.nr-nota-fis
                      AND int-nfs-supcard.it-codigo   = int-ped-aloc-supcard.it-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE int-nfs-supcard THEN
                    ASSIGN int-ped-aloc-supcard.val-item-alocado = 0.
                ELSE
                    DELETE int-ped-aloc-supcard.
            END.
            ELSE
                DELETE int-ped-aloc-supcard.
        END.
    END.

    FIND CURRENT int-ped-aloc-supcard NO-LOCK NO-ERROR.

    RELEASE int-ped-aloc-supcard NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-compromete-saldo-nfs:
/*------------------------------------------------------------------------------
  Purpose:     Comprometer o valor do item da nota fiscal e desalocar o valor do
               item do pedido que foi alocado no cart∆o Intelbras Clube
               (SupplierCard).
  Parameters:  INPUT p-cod-estabel (LIKE int-nfs-supcard.cod-estabel)
               INPUT p-serie       (LIKE int-nfs-supcard.serie)
               INPUT p-nr-nota-fis (LIKE int-nfs-supcard.nr-nota-fis)
               INPUT p-it-codigo   (LIKE int-nfs-supcard.it-codigo)
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel  LIKE int-nfs-supcard.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie        LIKE int-nfs-supcard.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fis  LIKE int-nfs-supcard.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    LIKE int-nfs-supcard.it-codigo    NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 777,
                                                INPUT TRIM(STRING(p-cod-estabel))).

        RETURN "NOK":U.
    END.

    FIND FIRST nota-fiscal
        WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel
          AND nota-fiscal.serie       = p-serie
          AND nota-fiscal.nr-nota-fis = p-nr-nota-fis NO-LOCK NO-ERROR.

    IF NOT AVAILABLE nota-fiscal THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Nota Fiscal~~":U + "Estab.: ":U + TRIM(STRING(p-cod-estabel)) + ", SÇrie: ":U + TRIM(STRING(p-serie)) + ", Nro. NF: ":U + TRIM(STRING(p-nr-nota-fis))).

        RETURN "NOK":U.
    END.

    FIND FIRST item
        WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Item~~":U + "Item: ":U + TRIM(STRING(p-it-codigo))).

        RETURN "NOK":U.
    END.

    FIND FIRST it-nota-fisc USE-INDEX ch-nota-item
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
          AND it-nota-fisc.serie       = nota-fiscal.serie
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
          AND it-nota-fisc.it-codigo   = item.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE it-nota-fisc THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Item da Nota Fiscal~~":U + "Estab.: ":U + TRIM(STRING(nota-fiscal.cod-estabel)) + ", SÇrie: ":U + TRIM(STRING(nota-fiscal.serie)) + ", Nro. NF: ":U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ", Item: ":U + TRIM(STRING(item.it-codigo))).

        RETURN "NOK":U.
    END.

    FIND FIRST emitente
        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.

    IF NOT AVAILABLE emitente THEN DO:
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 2,
                                                INPUT "Emitente~~":U + "Nome abrev.: ":U + TRIM(STRING(nota-fiscal.nome-ab-cli))).

        RETURN "NOK":U.
    END.

    FIND FIRST int-nfs-supcard
        WHERE int-nfs-supcard.raiz-cnpj   = SUBSTRING(emitente.cgc, 1, 8)
          AND int-nfs-supcard.cod-estabel = nota-fiscal.cod-estabel
          AND int-nfs-supcard.serie       = nota-fiscal.serie
          AND int-nfs-supcard.nr-nota-fis = nota-fiscal.nr-nota-fis
          AND int-nfs-supcard.it-codigo   = it-nota-fisc.it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE int-nfs-supcard THEN DO:
        CREATE int-nfs-supcard.
        ASSIGN int-nfs-supcard.raiz-cnpj    = SUBSTRING(emitente.cgc, 1, 8)
               int-nfs-supcard.cod-estabel  = nota-fiscal.cod-estabel
               int-nfs-supcard.serie        = nota-fiscal.serie
               int-nfs-supcard.nr-nota-fis  = nota-fiscal.nr-nota-fis
               int-nfs-supcard.it-codigo    = it-nota-fisc.it-codigo
               int-nfs-supcard.dat-movto    = TODAY
               int-nfs-supcard.val-faturado = ROUND(it-nota-fisc.vl-tot-item, 2).

        RUN pi-desaloca-saldo-pedido IN THIS-PROCEDURE (INPUT nota-fiscal.nome-ab-cli,
                                                        INPUT nota-fiscal.nr-pedcli,
                                                        INPUT it-nota-fisc.it-codigo,
                                                        INPUT ROUND(it-nota-fisc.vl-tot-item, 2)).
    END.
    ELSE DO:
        IF int-nfs-supcard.val-faturado <> it-nota-fisc.vl-tot-item THEN DO:
            RUN pi-desaloca-saldo-pedido IN THIS-PROCEDURE (INPUT nota-fiscal.nome-ab-cli,
                                                            INPUT nota-fiscal.nr-pedcli,
                                                            INPUT it-nota-fisc.it-codigo,
                                                            INPUT ROUND((it-nota-fisc.vl-tot-item - int-nfs-supcard.val-faturado), 2)).

            ASSIGN int-nfs-supcard.val-faturado = ROUND(it-nota-fisc.vl-tot-item, 2).
        END.
    END.

    FIND CURRENT int-nfs-supcard NO-LOCK NO-ERROR.

    RELEASE int-nfs-supcard NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-mensagem PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem na temp-table "tt-erro", de acordo com os padr‰es.
  Parameters:  INPUT p-cd-erro  (LIKE tt-erro.cd-erro)
               INPUT p-mensagem (LIKE tt-erro.mensagem)
  Notes:       Uso interno da API.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cd-erro  LIKE tt-erro.cd-erro  NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem LIKE tt-erro.mensagem NO-UNDO.

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    FIND LAST tt-erro NO-LOCK NO-ERROR.

    ASSIGN i-seq = IF AVAILABLE tt-erro THEN tt-erro.i-sequen ELSE 0.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq + 1
           tt-erro.cd-erro  = p-cd-erro.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT p-cd-erro,
                       INPUT p-mensagem).

    IF RETURN-VALUE <> "":U THEN
        ASSIGN tt-erro.mensagem = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-cd-erro,
                       INPUT p-mensagem).

    IF RETURN-VALUE <> "":U THEN DO:
        IF tt-erro.mensagem <> "":U THEN
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + " ":U + RETURN-VALUE.
        ELSE
            ASSIGN tt-erro.mensagem = RETURN-VALUE.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-retorna-mensagem:
/*------------------------------------------------------------------------------
  Purpose:     Retornas as mensagens da temp-table "tt-erro".
  Parameters:  OUTPUT tt-erro (TABLE)
  Notes:       Recomendado o uso ap¢s verificar o RETURN-VALUE = "NOK" ou
               RETURN-VALUE <> "OK":U.
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION fn-cond-pag-supcard RETURNS LOGICAL
  ( p-cod-cond-pag AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar se a condiá∆o de pagamento Ç Intelbras Clube (SupplierCard).
    Notes:  <none>
------------------------------------------------------------------------------*/
    FIND FIRST int-cond-pagto
        WHERE int-cond-pagto.cod-cond-pag = p-cod-cond-pag NO-LOCK NO-ERROR.

    IF AVAILABLE int-cond-pagto                       AND
       SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN
        RETURN YES.
    ELSE
        RETURN NO.

END FUNCTION.

