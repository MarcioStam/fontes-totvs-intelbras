/*------------------------------------------------------------------------
    File        : GK0006RP.P
    Purpose     : Importaá∆o Fatura GKO
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Abril/Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/
{include/i-prgvrs.i GK0006 2.00.00.002}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/gko/gkapi001.i} /* Definiá∆o temp-table "tt-log-gko" */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nom-arquivo      AS CHARACTER
    FIELD nom-completo     AS CHARACTER
    FIELD ind-tipo-arquivo AS CHARACTER.

DEFINE TEMP-TABLE tt-linha-arquivo NO-UNDO
    FIELD nome-arquivo   AS CHARACTER
    FIELD numero-linha   AS INTEGER
    FIELD conteudo-linha AS CHARACTER
    INDEX chNomeArqLinha AS PRIMARY UNIQUE
        nome-arquivo
        numero-linha.

DEFINE TEMP-TABLE tt-registro-070 NO-UNDO
    FIELD IDDOC            AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U
    FIELD TPLANCAMENTO     AS CHARACTER FORMAT "x(20)":U
    FIELD CDTRANSPORTADORA AS CHARACTER FORMAT "x(21)":U
    FIELD CDREFERENCIA     AS CHARACTER FORMAT "x(35)":U
    FIELD CDCOMPANHIA      AS CHARACTER FORMAT "x(51)":U
    FIELD DTLANCAMENTO     AS DATE      FORMAT "99/99/9999":U
    FIELD DTVENCIMENTO     AS DATE      FORMAT "99/99/9999":U
    FIELD DTEMISSAO        AS DATE      FORMAT "99/99/9999":U
    FIELD VRFRETECOBRADO   AS DECIMAL   FORMAT ">>,>>>,>>>,>>>,>>9.99":U
    FIELD VRISS            AS DECIMAL   FORMAT ">>,>>>,>>>,>>>,>>9.99":U
    FIELD VRBASECALCULOISS AS DECIMAL   FORMAT ">>,>>>,>>>,>>>,>>9.99":U
    FIELD CDCONTACONTABIL  AS CHARACTER FORMAT "x(8)":U
    FIELD VRDESCONTOFATURA AS DECIMAL   FORMAT ">>,>>>,>>>,>>>,>>9.99":U.

DEFINE TEMP-TABLE tt-registro-073 NO-UNDO
     FIELD IDDOC                  AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U
     FIELD CNPJTRANSP             AS CHARACTER FORMAT "x(15)":U  
     FIELD CGCCPFCOMPANHIA        AS CHARACTER FORMAT "x(15)":U  
     FIELD CDNC                   AS CHARACTER FORMAT "x(12)":U  
     FIELD CDSERIENC              AS CHARACTER FORMAT "x(05)":U
     FIELD DTREGISTRONC           AS CHARACTER FORMAT "x(10)":U 
     FIELD DTEMISSAONC            AS CHARACTER FORMAT "x(10)":U. 

DEFINE TEMP-TABLE tt-custo-frete NO-UNDO
    FIELD cod-transp      AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD serie           AS CHARACTER FORMAT "x(5)":U
    FIELD nr-fatura       AS CHARACTER FORMAT "x(16)":U
    FIELD dt-emissao      AS DATE      FORMAT "99/99/9999":U     INITIAL 01/01/1800
    FIELD dt-vencimento   AS DATE      FORMAT "99/99/9999":U     INITIAL 01/01/1800
    FIELD cod-estabel     AS CHARACTER FORMAT "x(3)":U
    FIELD cta-ctbl        AS CHARACTER FORMAT "x(17)":U          INITIAL "":U
    FIELD val-custo-frete AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD val-iss         AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD base-iss        AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD idDocto         AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U

    INDEX ch-codigo IS PRIMARY UNIQUE
        cod-transp
        serie
        nr-fatura
        dt-emissao.

DEFINE TEMP-TABLE tt-conh-frete NO-UNDO
    FIELD IDDOC            AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U
    FIELD cod-transp       AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD serie            AS CHARACTER FORMAT "x(5)":U
    FIELD nr-fatura        AS CHARACTER FORMAT "x(16)":U
    FIELD cod-estabel      AS CHARACTER FORMAT "x(3)":U
    FIELD chave-cte        AS CHARACTER FORMAT "x(50)":U.

DEFINE TEMP-TABLE tt-log-erros NO-UNDO
    FIELD cod-transp    AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD serie         AS CHARACTER FORMAT "x(5)":U
    FIELD nr-fatura     AS CHARACTER FORMAT "x(16)":U
    FIELD dt-emissao    AS DATE      FORMAT "99/99/9999":U
    FIELD num-mensagem  AS INTEGER   FORMAT ">>>>,>>9":U
    FIELD des-msg-erro  AS CHARACTER FORMAT "x(60)":U
    FIELD des-msg-ajuda AS CHARACTER FORMAT "x(40)":U.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE    NO-UNDO.
DEFINE VARIABLE v-dir-destino AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-cod-serie   AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-nr-fatura   AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-chave-cte   AS CHARACTER NO-UNDO.

/* Local Stream Definitions ---                                         */

DEFINE STREAM str-in.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ************************  Function Prototypes ********************** */

FUNCTION fn-conv-deci RETURNS DECIMAL
  ( p-num AS CHARACTER, p-decimals AS INTEGER )  FORWARD.

FUNCTION fn-conv-data RETURNS DATE
  ( p-data AS CHARACTER )  FORWARD.

FUNCTION fn-conv-logi RETURNS LOGICAL
  ( p-logical AS CHARACTER )  FORWARD.

FUNCTION fn-conv-inte RETURNS INTEGER
  ( p-num AS CHARACTER )  FORWARD.


/* ***************************  Main Block  *************************** */

FIND LAST param-global NO-LOCK NO-ERROR.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

RUN pi-importar-fatura IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importar-fatura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE conteudo      AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-log-gko.

    /* Buscar arquivo(s) para importaá∆o das faturas GKO */
    RUN pi-carrega-linha-arq IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Carregando campos registros...":U).

    /*bk-arquivo:*/
    FOR EACH tt-arquivo:

        EMPTY TEMP-TABLE tt-registro-070.
        EMPTY TEMP-TABLE tt-registro-073.
        EMPTY TEMP-TABLE tt-custo-frete.
        EMPTY TEMP-TABLE tt-log-erros.

        bk-linha-arquivo:
        FOR EACH tt-linha-arquivo
            WHERE tt-linha-arquivo.nome-arquivo = tt-arquivo.nom-completo:

            ASSIGN conteudo = tt-linha-arquivo.conteudo-linha.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo) + " - Registro: ":U + TRIM(SUBSTRING(conteudo, 1, 3))).

            CASE SUBSTRING(conteudo, 1, 3):
                /*/* Registro 000 - Identificaá∆o do Arquivo */
                WHEN "000":U THEN DO:
                    /* Nminterface */
                    IF TRIM(SUBSTRING(conteudo, 4, 10)) <> "intpfap":U THEN DO:
                        CREATE tt-log-gko.
                        ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                               tt-log-gko.log-imp-erro           = YES
                               tt-log-gko.ind-tipo-integracao    = 2
                               tt-log-gko.des-erro-imp           = "Nome da interface inv†lido! (Valor: ":U + TRIM(SUBSTRING(conteudo, 4, 10)) + ")":U.

                        NEXT bk-arquivo.
                    END.

                    /* Vers∆o */
                    IF TRIM(SUBSTRING(conteudo, 14, 6)) <> "5.80a":U THEN DO:
                        CREATE tt-log-gko.
                        ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                               tt-log-gko.log-imp-erro           = YES
                               tt-log-gko.ind-tipo-integracao    = 2
                               tt-log-gko.des-erro-imp           = "Vers∆o da interface inv†lido! (Valor: ":U + TRIM(SUBSTRING(conteudo, 14, 6)) + ")":U.

                        NEXT bk-arquivo.
                    END.
                END. /* WHEN "000":U THEN DO: */*/

                /* Registro 070 - Lanáamento Cont†bil (Cabeáalho) */
                WHEN "070":U THEN DO:
                    CREATE tt-registro-070.
                    ASSIGN tt-registro-070.IDDOC            = fn-conv-inte(TRIM(SUBSTRING(conteudo,   4, 16)))
                           tt-registro-070.TPLANCAMENTO     =              TRIM(SUBSTRING(conteudo,  20,  1))
                           tt-registro-070.CDTRANSPORTADORA =              TRIM(SUBSTRING(conteudo,  21, 14))
                           tt-registro-070.CDREFERENCIA     =              TRIM(SUBSTRING(conteudo,  35, 16))
                           tt-registro-070.CDCOMPANHIA      =              TRIM(SUBSTRING(conteudo,  51, 15))
                           tt-registro-070.DTLANCAMENTO     = fn-conv-data(TRIM(SUBSTRING(conteudo,  66, 10)))
                           tt-registro-070.DTVENCIMENTO     = fn-conv-data(TRIM(SUBSTRING(conteudo,  76, 10)))
                           tt-registro-070.DTEMISSAO        = fn-conv-data(TRIM(SUBSTRING(conteudo,  86, 10)))
                           tt-registro-070.VRFRETECOBRADO   = fn-conv-deci(TRIM(SUBSTRING(conteudo,  96, 16)), 2)
                           tt-registro-070.VRISS            = fn-conv-deci(TRIM(SUBSTRING(conteudo,  112, 16)), 2)
                           tt-registro-070.VRBASECALCULOISS = fn-conv-deci(TRIM(SUBSTRING(conteudo,  128, 16)), 2)
                           tt-registro-070.VRDESCONTOFATURA = fn-conv-deci(TRIM(SUBSTRING(conteudo,  144, 16)), 2) /* Chamado: C2108-1255 */
                           tt-registro-070.CDCONTACONTABIL  = "21210075". /* TRIM(SUBSTRING(conteudo, 112,  8)). */ /* Parametrizar no ES0018 */
                        if (tt-registro-070.VRFRETECOBRADO + tt-registro-070.VRISS ) = tt-registro-070.VRBASECALCULOISS then 
                         assign tt-registro-070.VRFRETECOBRADO = (tt-registro-070.VRFRETECOBRADO + tt-registro-070.VRISS ).

                    IF tt-registro-070.TPLANCAMENTO = "2":U THEN DO:
                        FIND FIRST estabelec
                            WHERE estabelec.cod-emitente = INTEGER(tt-registro-070.CDCOMPANHIA) NO-LOCK NO-ERROR.

                        IF NOT AVAILABLE estabelec THEN DO:
                            CREATE tt-log-gko.
                            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                                   tt-log-gko.log-imp-erro           = YES
                                   tt-log-gko.ind-tipo-integracao    = 2
                                   tt-log-gko.des-erro-imp           = "Companhia n∆o encontrada com o c¢digo informado!":U + CHR(10) + "C¢digo: ":U + tt-registro-070.CDCOMPANHIA + CHR(10) + CHR(10) + "Linha: ":U + TRIM(STRING(tt-linha-arquivo.numero-linha)).

                            NEXT bk-linha-arquivo.
                        END.

                        IF  NUM-ENTRIES(tt-registro-070.CDREFERENCIA, "-") > 1
                        THEN
                            ASSIGN v-cod-serie = TRIM(ENTRY(2, tt-registro-070.CDREFERENCIA, "-"))
                                   v-nr-fatura = TRIM(ENTRY(1, tt-registro-070.CDREFERENCIA, "-")).
                        ELSE
                            ASSIGN v-cod-serie = ""
                                   v-nr-fatura = TRIM(tt-registro-070.CDREFERENCIA).

                        IF CAN-FIND(FIRST tt-custo-frete
                                    WHERE tt-custo-frete.cod-transp = INTEGER(tt-registro-070.CDTRANSPORTADORA)
                                      AND tt-custo-frete.serie      = v-cod-serie
                                      AND tt-custo-frete.nr-fatura  = v-nr-fatura
                                      AND tt-custo-frete.dt-emissao = tt-registro-070.DTEMISSAO) THEN DO:
                            CREATE tt-log-gko.
                            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                                   tt-log-gko.log-imp-erro           = YES
                                   tt-log-gko.ind-tipo-integracao    = 2
                                   tt-log-gko.des-erro-imp           = "Fatura em duplicidade neste arquivo!":U + CHR(10) + CHR(10) + "Linha: ":U + TRIM(STRING(tt-linha-arquivo.numero-linha)).

                            NEXT bk-linha-arquivo.
                        END.
    
                        CREATE tt-custo-frete.
                        ASSIGN tt-custo-frete.cod-estabel     = estabelec.cod-estabel
                               tt-custo-frete.cod-transp      = INTEGER(tt-registro-070.CDTRANSPORTADORA)
                               tt-custo-frete.serie           = v-cod-serie
                               tt-custo-frete.nr-fatura       = v-nr-fatura
                               tt-custo-frete.dt-emissao      = tt-registro-070.DTEMISSAO
                               tt-custo-frete.dt-vencimento   = tt-registro-070.DTVENCIMENTO
                               tt-custo-frete.cta-ctbl        = tt-registro-070.CDCONTACONTABIL
                               tt-custo-frete.val-custo-frete = tt-registro-070.VRFRETECOBRADO - tt-registro-070.VRDESCONTOFATURA /* Chamado: C2108-1255 - valor l°quido */
                               tt-custo-frete.val-iss         = tt-registro-070.VRISS
                               tt-custo-frete.base-iss        = tt-registro-070.VRBASECALCULOISS
                               tt-custo-frete.idDocto         = tt-registro-070.IDDOC.
                    END. /* IF tt-registro-070.TPLANCAMENTO = "2":U THEN DO: */
                END. /* WHEN "070":U THEN DO: */
                WHEN "073":U THEN DO:
                    /* 20.09.2023 - Valida se o registro pertence a uma CTe. Para isso valida a chave de acesso */
                    ASSIGN v-chave-cte = TRIM(SUBSTRING(conteudo, 181, 44)).    
                
                    IF (LENGTH(v-chave-cte) = 44) THEN DO:
                        FIND CURRENT tt-registro-070 NO-ERROR.
    
                        CREATE tt-registro-073.
                        ASSIGN tt-registro-073.CNPJTRANSP      = TRIM(SUBSTRING(conteudo,   5, 14))
                               tt-registro-073.CGCCPFCOMPANHIA = TRIM(SUBSTRING(conteudo,  20, 15))
                               tt-registro-073.CDNC            = TRIM(SUBSTRING(conteudo,  38,  7)) /* Daniel 24/06/2023 - Anterior 34, 12 */
                               tt-registro-073.CDSERIENC       = TRIM(SUBSTRING(conteudo,  46,  5))
                               tt-registro-073.DTREGISTRONC    = TRIM(SUBSTRING(conteudo,  52, 10))
                               tt-registro-073.DTEMISSAONC     = TRIM(SUBSTRING(conteudo,  62, 10))
                               tt-registro-073.IDDOC           = tt-registro-070.IDDOC.
    
                        FIND FIRST emitente NO-LOCK WHERE emitente.cgc = tt-registro-073.CNPJTRANSP NO-ERROR.
    
                        IF (NOT AVAIL emitente) THEN DO:
                            CREATE tt-log-gko.
                            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                                   tt-log-gko.log-imp-erro           = YES
                                   tt-log-gko.ind-tipo-integracao    = 2
                                   tt-log-gko.des-erro-imp           = "Emitente nao localizado !":U + CHR(10) + " CGC: " + tt-registro-073.CNPJTRANSP + CHR(10) + "Linha: ":U + TRIM(STRING(tt-linha-arquivo.numero-linha)).
        			  
                            NEXT bk-linha-arquivo.
                       END.
    
                       CREATE tt-conh-frete.
                       ASSIGN tt-conh-frete.cod-estabel = estabelec.cod-estabel                     
                              tt-conh-frete.cod-transp  = emitente.cod-emitente 
                              tt-conh-frete.serie       = tt-registro-073.CDSERIENC                             
                              tt-conh-frete.nr-fatura   = tt-registro-073.CDNC  
                              tt-conh-frete.IDDOC       = tt-registro-070.IDDOC
                              tt-conh-frete.chave-cte   = v-chave-cte.
                    END.           
                END.
            END CASE.
        END. /* FOR EACH tt-linha-arquivo */

        /* Implanta custo do frete no contas Ö pagar */
        RUN esp/gko/gk0006rp1.p (INPUT  TABLE tt-custo-frete,
                                 INPUT  TABLE tt-conh-frete,
                                 OUTPUT TABLE tt-log-erros).

        IF CAN-FIND(FIRST tt-log-erros) THEN DO:
            FOR EACH tt-log-erros:
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.ind-tipo-integracao    = 2
                       tt-log-gko.des-erro-imp           = "Erro integraá∆o EMS 5: Transp/Ser/Fat/Emis: ":U + STRING(tt-log-erros.cod-transp) + "/":U + tt-log-erros.serie + "/":U + tt-log-erros.nr-fatura + "/":U + STRING(tt-log-erros.dt-emissao, "99/99/99":U) + " - ":U + tt-log-erros.des-msg-erro + " (":U + STRING(tt-log-erros.num-mensagem) + ")":U + CHR(10) + CHR(10) + tt-log-erros.des-msg-ajuda.
            END.
        END.
        ELSE DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                   tt-log-gko.log-imp-erro           = NO
                   tt-log-gko.ind-tipo-integracao    = 2
                   tt-log-gko.des-erro-imp           = "":U.

            OS-COPY   VALUE(tt-arquivo.nom-completo) VALUE(v-dir-destino + tt-arquivo.nom-arquivo).
            OS-DELETE VALUE(tt-arquivo.nom-completo) NO-ERROR.
        END.
    END. /* FOR EACH tt-arquivo: */

    RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-carrega-linha-arq :
/*------------------------------------------------------------------------------
  Purpose:     Buscar arquivo(s) para importaá∆o da(s) fatura(s) GKO.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-dir-origem     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-conteudo-linha AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-numero-linha   AS INTEGER     NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Carregando linhas arquivo...":U).

    EMPTY TEMP-TABLE tt-arquivo.
    EMPTY TEMP-TABLE tt-linha-arquivo.

    /* Identificar o diret¢rio origem do(s) arquivo(s) */
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "gk0006":U
          AND ponto-programa.ponto         = 1,
        EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF conteudo-programa.conteudo                    <> "":U AND
           NUM-ENTRIES(conteudo-programa.conteudo, ";":U) > 1    THEN DO:

            /* Diret¢rio no sistema operacional WIN32 */
            IF OPSYS = "WIN32":U THEN DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAGKOWIN32":U THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPGKOWIN32":U THEN
                    ASSIGN v-dir-destino = ENTRY(2, conteudo-programa.conteudo, ";":U).
            END.
            /* Diret¢rio no sistema operacional UNIX */
            ELSE DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAGKOUNIX":U THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPGKOUNIX":U THEN
                    ASSIGN v-dir-destino = ENTRY(2, conteudo-programa.conteudo, ";":U).
            END.
        END.
    END.
    /****JULIANO PARA TESTE LOCAL
    ASSIGN c-dir-origem  = "C:\iDBA\julianoMichelon\M2305-146\origem\"
           v-dir-destino = "C:\iDBA\julianoMichelon\M2305-146\destino\".
    */

    ASSIGN c-dir-origem  = REPLACE(c-dir-origem,  "~\":U, "/":U)
           v-dir-destino = REPLACE(v-dir-destino, "~\":U, "/":U).

    IF SUBSTRING(v-dir-destino, LENGTH(v-dir-destino), 1) <> "/":U THEN
        ASSIGN v-dir-destino = v-dir-destino + "/":U.

    FILE-INFO:FILE-NAME = c-dir-origem.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
        RETURN "NOK":U.

    FILE-INFO:FILE-NAME = v-dir-destino.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
        RETURN "NOK":U.

    INPUT STREAM str-in FROM OS-DIR(c-dir-origem) NO-ECHO.
    REPEAT:
        CREATE tt-arquivo.
        IMPORT STREAM str-in tt-arquivo.nom-arquivo
                             tt-arquivo.nom-completo
                             tt-arquivo.ind-tipo-arquivo.
    END.
    INPUT STREAM str-in CLOSE.

    FOR EACH tt-arquivo:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo)).

        IF (NOT tt-arquivo.nom-arquivo BEGINS "frpgto":U AND 
            NOT tt-arquivo.nom-arquivo BEGINS "frpfap":U) OR
            tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN 
            DELETE tt-arquivo.
    END.

    IF NOT CAN-FIND(FIRST tt-arquivo) THEN
        RETURN "NOK":U.

    FOR EACH tt-arquivo:
        ASSIGN i-numero-linha = 0.

        INPUT STREAM str-in FROM VALUE(SEARCH(tt-arquivo.nom-completo)).
        REPEAT:
            IMPORT STREAM str-in UNFORMATTED c-conteudo-linha.

            ASSIGN i-numero-linha = i-numero-linha + 1.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo) + " - Linha: ":U + TRIM(STRING(i-numero-linha))).

            IF c-conteudo-linha <> "":U THEN DO:
                CREATE tt-linha-arquivo.
                ASSIGN tt-linha-arquivo.nome-arquivo   = tt-arquivo.nom-completo
                       tt-linha-arquivo.numero-linha   = i-numero-linha
                       tt-linha-arquivo.conteudo-linha = c-conteudo-linha.
            END.
        END.
        INPUT STREAM str-in CLOSE.
    END.

    IF NOT CAN-FIND(FIRST tt-linha-arquivo) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION fn-conv-deci RETURNS DECIMAL
  ( p-num AS CHARACTER, p-decimals AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.

    ASSIGN p-num  = TRIM(REPLACE(REPLACE(p-num, ".":U, "#":U), ",":U, "#":U))
           de-aux = DECIMAL(TRIM(p-num)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    IF LENGTH(p-num) > 0 THEN
       ASSIGN de-aux = DECIMAL(SUBSTRING(p-num, 1, LENGTH(p-num) - p-decimals))
              de-aux = de-aux + (DECIMAL(SUBSTRING(p-num, (LENGTH(p-num) - p-decimals) + 1, 2)) / EXP(10, p-decimals)).

    RETURN de-aux.

END FUNCTION.

FUNCTION fn-conv-data RETURNS DATE
  ( p-date AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-day   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-month AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-year  AS INTEGER     NO-UNDO.

    ASSIGN p-date = TRIM(p-date).

    IF NUM-ENTRIES(p-date, "/":U) < 3 THEN
        RETURN ?.

    ASSIGN i-day = INTEGER(TRIM(ENTRY(1, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-month = INTEGER(TRIM(ENTRY(2, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-year = INTEGER(TRIM(ENTRY(3, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN DATE(i-month, i-day, i-year).

END FUNCTION.

FUNCTION fn-conv-logi RETURNS LOGICAL
  ( p-logical AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    ASSIGN p-logical = TRIM(p-logical).

    CASE p-logical:
        WHEN "s":U    OR
        WHEN "sim":U  OR
        WHEN "y":U    OR
        WHEN "yes"    OR
        WHEN "t":U    OR
        WHEN "true":U THEN
            RETURN YES.
        WHEN "n":U     OR
        WHEN "nao":U   OR
        WHEN "n∆o":U   OR
        WHEN "no"      OR
        WHEN "f":U     OR
        WHEN "false":U THEN
            RETURN NO.
        OTHERWISE
            RETURN ?.
    END CASE.

END FUNCTION.

FUNCTION fn-conv-inte RETURNS INTEGER
  ( p-num AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.

    ASSIGN i-aux = INTEGER(TRIM(p-num)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN i-aux.

END FUNCTION.

