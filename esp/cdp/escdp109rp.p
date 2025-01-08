/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCDP109RP 2.04.00.002}
/*------------------------------------------------------------------------
    File        : ESCDP109RP.P
    Purpose     : Cria/Elimina Relacionamento Item x Estabelecimento
    Syntax      : <none>
    Description : <none>

    Author(s)   : Graziely Lima (iDBA)
    Created     : Maráo 2022
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/cdp/escdp109.i} /* Definiá∆o das temp-tables do programa */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD linha            AS INTEGER
    FIELD conteudo         AS CHARACTER
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD it-codigo        LIKE item.it-codigo
    FIELD erro             AS LOGICAL INITIAL NO
    INDEX chLinha IS PRIMARY UNIQUE
        linha
    INDEX chNoErro
        erro
        linha.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD sequencia AS INTEGER   FORMAT ">>>,>>9":U
    FIELD linha     AS INTEGER   FORMAT ">>>,>>9":U
    FIELD conteudo  AS CHARACTER FORMAT "x(50)":U
    FIELD mensagem  AS CHARACTER FORMAT "x(100)":U
    INDEX chPrimario IS PRIMARY
        linha
        sequencia
    INDEX chSequencia IS UNIQUE
        sequencia.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEFINE VARIABLE v-cod-estabel     LIKE estabelec.cod-estabel              NO-UNDO.
DEFINE VARIABLE v-it-codigo       LIKE item.it-codigo                     NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-in.

FORM tt-erro.linha     COLUMN-LABEL "Nro Linha":U
     tt-erro.conteudo  COLUMN-LABEL "Conte£do da Linha":U
     tt-erro.mensagem  COLUMN-LABEL "Mensagem":U FORMAT "x(70)"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-erro.

FORM tt-dados.cod-estabel        COLUMN-LABEL "Estab":U
     tt-dados.it-codigo          COLUMN-LABEL "Item":U
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-dados.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF item.
DISABLE TRIGGERS FOR LOAD OF int-item.
DISABLE TRIGGERS FOR LOAD OF item-uni-estab.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-titulo-relat = "Cria/Elimina Relacionamento Item x Estabelecimento":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-sistema      = "Espec°ficos Intelbras":U.

{include/i-rpcab.i &STREAM="str-rp"}
{include/i-rpout.i &STREAM="STREAM str-rp" &TOFILE=tt-param.arq-destino}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

RUN pi-importar-arquivo IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &STREAM="STREAM str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importar-arquivo :
/*------------------------------------------------------------------------------
  Purpose:     Importar o arquivo solicitado.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-erro      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-relac     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-existe    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE h-mov-estab AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-mov-estab) THEN
        RUN cdp/cd7010.p PERSISTENT SET h-mov-estab.

    EMPTY TEMP-TABLE tt-dados.
    EMPTY TEMP-TABLE tt-erro.

    ASSIGN c-arquivo = REPLACE(tt-param.arq-csv, "~\":U, "/":U).

    FILE-INFO:FILE-NAME = c-arquivo.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "F":U) = 0    THEN DO:
        PUT STREAM str-rp UNFORMATTED "Arquivo inv†lido!":U SKIP(1).

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Importaá∆o arquivo...":U).

    ASSIGN i-linha = 0.

    INPUT STREAM str-in FROM VALUE(c-arquivo) NO-CONVERT.
    REPEAT:
        IMPORT STREAM str-in UNFORMATTED c-linha.

        ASSIGN i-linha = i-linha + 1
               l-erro  = NO.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + TRIM(STRING(i-linha)) + " - ":U + TRIM(c-linha)).

        IF i-linha = 1 THEN
            NEXT.

        ASSIGN v-cod-estabel = TRIM(ENTRY(1, c-linha, ";":U)).

        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = v-cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Estabelecimento n∆o encontrado.":U).

            ASSIGN l-erro = YES.
        END.

        ASSIGN v-it-codigo = TRIM(ENTRY(2, c-linha, ";":U)).

        FIND FIRST item
             WHERE item.it-codigo = v-it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Item n∆o encontrado.":U).

            ASSIGN l-erro = YES.
        END.
        
        IF l-erro THEN NEXT.

        CREATE tt-dados.
        ASSIGN tt-dados.linha           = i-linha
               tt-dados.conteudo        = c-linha
               tt-dados.cod-estabel     = v-cod-estabel
               tt-dados.it-codigo       = v-it-codigo.
        
    END.
    INPUT STREAM str-in CLOSE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando importaá∆o...":U).

    bk-dados:
    FOR EACH tt-dados:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + TRIM(STRING(tt-dados.linha)) + " - ":U + TRIM(tt-dados.conteudo)).

        // Cria relacionamento
        IF tt-param.nr-opcao = 1 THEN DO: 

            FIND FIRST ITEM WHERE ITEM.it-codigo = tt-dados.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:
                FIND FIRST item-uni-estab 
                     WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
                       AND item-uni-estab.cod-estabel = tt-dados.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            
                IF AVAIL item-uni-estab THEN DO:

                    ASSIGN l-relac = YES.
            
                    /*ASSIGN item-uni-estab.preco-base   = ITEM.preco-base
                           item-uni-estab.data-base    = ITEM.data-base
                           item-uni-estab.preco-repos  = ITEM.preco-repos
                           item-uni-estab.data-ult-rep = ITEM.data-ult-rep
                           item-uni-estab.preco-ul-ent = ITEM.preco-ul-ent
                           item-uni-estab.data-ult-ent = ITEM.data-ult-ent.*/
                END.
            END. 
        END.
        // Elimina relacionamento
        ELSE IF tt-param.nr-opcao = 2 THEN DO:
            
            RUN pi-mov-estab IN h-mov-estab(INPUT tt-dados.it-codigo,
                                            INPUT tt-dados.cod-estabel,
                                            OUTPUT l-existe).
            
            IF l-existe THEN DO: 
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT tt-dados.linha,
                                                         INPUT tt-dados.conteudo,
                                                         INPUT "26475 - Existe relacionamento deste Item x Estab com outras entidades.":U).
                
            END.
            ELSE DO: 
                FIND item-uni-estab WHERE 
                     item-uni-estab.it-codigo   = tt-dados.it-codigo AND
                     item-uni-estab.cod-estabel = tt-dados.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE item-uni-estab THEN 
                    DELETE item-uni-estab.
            END.
            
        END.
    END.

    PAGE STREAM str-rp.

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
        IF l-relac THEN
            PUT STREAM str-rp UNFORMATTED "N∆o ocorreu criaá∆o de relacionamento!":U SKIP(2).
        ELSE
            PUT STREAM str-rp UNFORMATTED "Arquivo importado com sucesso!":U SKIP(2).
    END.
    ELSE DO:
        PUT STREAM str-rp UNFORMATTED "Mensagem de Erro":U SKIP(1).

        FOR EACH tt-erro:
            DISPLAY STREAM str-rp
                    tt-erro.linha
                    tt-erro.conteudo
                    tt-erro.mensagem
                WITH FRAME f-erro.
            DOWN STREAM str-rp WITH FRAME f-erro.
        END.

        PAGE STREAM str-rp.
    END.

    IF tt-param.todos = 1 THEN DO:
        IF l-relac = NO THEN
            PUT STREAM str-rp UNFORMATTED "Itens Importados":U SKIP(1).
        ELSE
            PUT STREAM str-rp UNFORMATTED "J† existe relacionamento para estes Itens e Estab":U SKIP(1).

        FOR EACH tt-dados
            WHERE tt-dados.erro = NO:
            DISPLAY STREAM str-rp
                    tt-dados.cod-estabel
                    tt-dados.it-codigo
                WITH FRAME f-dados.
            DOWN STREAM str-rp WITH FRAME f-dados.
        END.
    END.

    IF VALID-HANDLE(h-mov-estab) THEN
        DELETE PROCEDURE h-mov-estab NO-ERROR.

    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-cria-mens-erro :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem de erro.
  Parameters:  INPUT p-linha    (INTEIRO),
               INPUT p-conteudo (CARACTER),
               INPUT p-mensagem (CARACTER).
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-linha    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-conteudo AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    FIND LAST tt-erro NO-ERROR.

    ASSIGN i-seq = IF AVAILABLE tt-erro THEN tt-erro.sequencia + 1 ELSE 1.

    CREATE tt-erro.
    ASSIGN tt-erro.sequencia = i-seq
           tt-erro.linha     = p-linha
           tt-erro.conteudo  = p-conteudo
           tt-erro.mensagem  = p-mensagem.

    RETURN "OK":U.

END PROCEDURE.


