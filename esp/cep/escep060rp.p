/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP060RP 2.04.00.002}
/*------------------------------------------------------------------------
    File        : ESCEP060RP.P
    Purpose     : Importaá∆o da Pol°tica Item
    Syntax      : <none>
    Description : <none>

    Author(s)   : Gustavo Eduardo Tamanini (SQL Works / Exponencial TI)
    Created     : Julho de 2011
    Notes       : 001 - Desenvolvimento do Programa - Gustavo Eduardo
                  Tamanini (SQL Works / Exponencial TI).
                  002 - Inclus∆o da validaá∆o do arquivo e manutená∆o na
                  efetivaá∆o da importaá∆o - Fabiano Sakae Ribeiro (SQL
                  Works / Exponencial TI).
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/cep/escep060.i} /* Definiá∆o das temp-tables do programa */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD linha        AS INTEGER
    FIELD conteudo     AS CHARACTER
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD it-codigo    LIKE item.it-codigo
    FIELD classif-abc  LIKE item.classif-abc
    FIELD periodo-fixo LIKE item.periodo-fixo
    FIELD quant-segur  LIKE item.quant-segur
    FIELD qtd-pol      LIKE int-item.qtd-pol
    FIELD erro         AS LOGICAL INITIAL NO
    INDEX chLinha IS PRIMARY UNIQUE
        linha
    INDEX chNoErro
        erro
        linha.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD sequencia AS INTEGER   FORMAT ">>>,>>9":U
    FIELD linha     AS INTEGER   FORMAT ">>>,>>9":U
    FIELD conteudo  AS CHARACTER FORMAT "x(50)":U
    FIELD mensagem  AS CHARACTER FORMAT "x(50)":U
    INDEX chPrimario IS PRIMARY
        linha
        sequencia
    INDEX chSequencia IS UNIQUE
        sequencia.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEFINE VARIABLE v-cod-estabel  LIKE estabelec.cod-estabel   NO-UNDO.
DEFINE VARIABLE v-it-codigo    LIKE item.it-codigo          NO-UNDO.
DEFINE VARIABLE v-classif-abc  LIKE item.classif-abc        NO-UNDO.
DEFINE VARIABLE v-periodo-fixo LIKE item.periodo-fixo       NO-UNDO.
DEFINE VARIABLE v-quant-segur  LIKE item.quant-segur        NO-UNDO.
DEFINE VARIABLE v-qtd-pol      LIKE int-item.qtd-pol NO-UNDO.

DEFINE VARIABLE c-classif-abc AS CHARACTER   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-in.

FORM tt-erro.linha     COLUMN-LABEL "Nro Linha":U
     tt-erro.conteudo  COLUMN-LABEL "Conte£do da Linha":U
     tt-erro.mensagem  COLUMN-LABEL "Mensagem":U
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-erro.

FORM tt-dados.cod-estabel                            COLUMN-LABEL "Estab":U
     tt-dados.it-codigo                              COLUMN-LABEL "Item":U
     c-classif-abc         FORMAT "x(1)":U           COLUMN-LABEL "Classif. ABC":U
     tt-dados.periodo-fixo                           COLUMN-LABEL "Per°odo Fixo":U
     tt-dados.quant-segur                            COLUMN-LABEL "Quant. Seguranáa":U
     tt-dados.qtd-pol      FORMAT ">>>,>>>,>>9.99":U COLUMN-LABEL "Quant. Pol°tica":U
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-dados.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF item.
DISABLE TRIGGERS FOR LOAD OF int-item.
DISABLE TRIGGERS FOR LOAD OF item-uni-estab.
DISABLE TRIGGERS FOR LOAD OF int-item-uni-estab.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-titulo-relat = "Importaá∆o da Pol°tica Item":U
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
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linha   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-erro    AS LOGICAL     NO-UNDO.

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
        ELSE IF AVAILABLE estabelec THEN DO:
            FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo   = item.it-codigo
                  AND item-uni-estab.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item-uni-estab THEN DO:
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                         INPUT c-linha,
                                                         INPUT "Item X Estabelecimento n∆o encontrado.":U).

                ASSIGN l-erro = YES.
            END.
        END.

        CASE TRIM(ENTRY(3, c-linha, ";":U)):
            WHEN "A":U THEN
                ASSIGN v-classif-abc = 1.
            WHEN "B":U THEN
                ASSIGN v-classif-abc = 2.
            WHEN "C":U THEN
                ASSIGN v-classif-abc = 3.
            OTHERWISE DO:
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                         INPUT c-linha,
                                                         INPUT "Classif. ABC inv†lida.":U).

                ASSIGN v-classif-abc = 0
                       l-erro        = YES.
            END.
        END CASE.

        ASSIGN v-periodo-fixo = INTEGER(TRIM(ENTRY(4, c-linha, ";":U))) NO-ERROR.

        IF v-periodo-fixo > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Per°odo Fixo n∆o pode ser maior que 999.":U).

            ASSIGN l-erro = YES.
        END.

        IF ERROR-STATUS:ERROR THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Per°odo Fixo inv†lida.":U).

            ASSIGN l-erro = YES.
        END.

        ASSIGN v-quant-segur = DECIMAL(TRIM(ENTRY(5, c-linha, ";":U))) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Quant. Seguranáa inv†lida.":U).

            ASSIGN l-erro = YES.
        END.

        IF v-quant-segur > 9999999.9999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Quant. Seguranáa n∆o pode ser maior que 999999,9999.":U).

            ASSIGN l-erro = YES.
        END.

        ASSIGN v-qtd-pol = DECIMAL(TRIM(ENTRY(6, c-linha, ";":U))) NO-ERROR.

        IF v-qtd-pol > 999999999.99 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Quant. Pol°tica n∆o pode ser maior que 999999999,99!":U).

            ASSIGN l-erro = YES.
        END.

        IF ERROR-STATUS:ERROR THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Quant. Pol°tica inv†lida.":U).

            ASSIGN l-erro = YES.
        END.

        IF l-erro THEN
            NEXT.

        CREATE tt-dados.
        ASSIGN tt-dados.linha        = i-linha
               tt-dados.conteudo     = c-linha
               tt-dados.cod-estabel  = v-cod-estabel
               tt-dados.it-codigo    = v-it-codigo
               tt-dados.classif-abc  = v-classif-abc
               tt-dados.periodo-fixo = v-periodo-fixo
               tt-dados.quant-segur  = v-quant-segur
               tt-dados.qtd-pol      = v-qtd-pol.
    END.
    INPUT STREAM str-in CLOSE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando importaá∆o...":U).

    bk-dados:
    FOR EACH tt-dados:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + TRIM(STRING(tt-dados.linha)) + " - ":U + TRIM(tt-dados.conteudo)).

        FIND FIRST item
            WHERE item.it-codigo = tt-dados.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item THEN
            ASSIGN item.classif-abc  = tt-dados.classif-abc
                   item.periodo-fixo = tt-dados.periodo-fixo
                   item.quant-segur  = tt-dados.quant-segur.
        ELSE DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT tt-dados.linha,
                                                     INPUT tt-dados.conteudo,
                                                     INPUT "Item n∆o encontrado.":U).

            ASSIGN tt-dados.erro = YES.

            UNDO bk-dados, NEXT bk-dados.
        END.

        FIND FIRST int-item
            WHERE int-item.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-item THEN DO:
            CREATE int-item.
            ASSIGN int-item.it-codigo = item.it-codigo.
        END.

        ASSIGN int-item.qtd-pol = tt-dados.qtd-pol.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = tt-dados.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            ASSIGN item-uni-estab.classif-abc  = tt-dados.classif-abc
                   item-uni-estab.periodo-fixo = tt-dados.periodo-fixo
                   item-uni-estab.quant-segur  = tt-dados.quant-segur.
            IF ITEM.ge-codigo = 45 THEN DO: /* OEM */
               FIND FIRST item-man
                    WHERE item-man.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

               IF AVAILABLE item-man THEN
                   ASSIGN item-man.quant-segur  = item-uni-estab.quant-segur.
            END.
        END.
        ELSE DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT tt-dados.linha,
                                                     INPUT tt-dados.conteudo,
                                                     INPUT "Item X Estabelecimento n∆o encontrado.":U).

            ASSIGN tt-dados.erro = YES.

            UNDO bk-dados, NEXT bk-dados.
        END.

        FIND FIRST int-item-uni-estab
            WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
              AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-item-uni-estab THEN DO:
            CREATE int-item-uni-estab.
            ASSIGN int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                   int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo.
        END.

        ASSIGN int-item-uni-estab.qtd-pol = tt-dados.qtd-pol.
    END.

    PAGE STREAM str-rp.

    IF NOT CAN-FIND(FIRST tt-erro) THEN
        PUT STREAM str-rp UNFORMATTED "Arquivo importado com sucesso!":U SKIP(2).
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
        PUT STREAM str-rp UNFORMATTED "Itens Importados":U SKIP(1).

        FOR EACH tt-dados
            WHERE tt-dados.erro = NO:
            CASE tt-dados.classif-abc:
                WHEN 1 THEN
                    ASSIGN c-classif-abc = "A":U.
                WHEN 2 THEN
                    ASSIGN c-classif-abc = "B":U.
                WHEN 3 THEN
                    ASSIGN c-classif-abc = "C":U.
                OTHERWISE
                    ASSIGN c-classif-abc = "":U.
            END CASE.
            DISPLAY STREAM str-rp
                    tt-dados.cod-estabel
                    tt-dados.it-codigo
                    c-classif-abc
                    tt-dados.periodo-fixo
                    tt-dados.quant-segur
                    tt-dados.qtd-pol
                WITH FRAME f-dados.
            DOWN STREAM str-rp WITH FRAME f-dados.
        END.
    END.

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

