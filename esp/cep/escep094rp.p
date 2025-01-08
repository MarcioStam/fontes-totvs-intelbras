/*********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP094RP 1.00.00.001}
/*------------------------------------------------------------------------
    File        : ESCEP094RP.P
    Purpose     : Importaá∆o Dados APS
    Syntax      : <none>
    Description : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/cep/escep091.i} /* Definiá∆o das temp-tables do programa */
{esp/es0018.i}

{method/dbotterr.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD linha            AS INTEGER
    FIELD conteudo         AS CHARACTER
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD it-codigo        LIKE item.it-codigo
    FIELD lote-multpl      LIKE item-uni-estab.lote-multipl   
    FIELD lote-minimo      LIKE item-uni-estab.lote-minimo 
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
    FIELD mensagem  AS CHARACTER FORMAT "x(50)":U
    INDEX chPrimario IS PRIMARY
        linha
        sequencia
    INDEX chSequencia IS UNIQUE
        sequencia.

// boin684.i
DEFINE TEMP-TABLE tt-item-uni-estab NO-UNDO LIKE item-uni-estab
    FIELD r-Rowid AS ROWID.

define temp-table tt-erros-geral no-undo
  field identif-msg           as char    format "x(60)"
  field num-sequencia-erro    as integer format "999"
  field cod-erro              as integer format "99999"   
  field des-erro              as char    format "x(60)"
  field cod-maq-origem        as integer format "999"
  field num-processo          as integer format "999999999".


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEFINE VARIABLE v-cod-estabel        LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE v-it-codigo          LIKE item.it-codigo        NO-UNDO.
DEFINE VARIABLE v-lote-mult          AS DEC                     NO-UNDO.
DEFINE VARIABLE v-lote-minimo        AS DEC                     NO-UNDO.

DEFINE VARIABLE h-boin684        AS HANDLE NO-UNDO.

/* Stream Definitions --- */

DEFINE STREAM str-rp.
DEFINE STREAM str-in.

FORM tt-erro.linha     COLUMN-LABEL "Nro Linha":U
     tt-erro.conteudo  COLUMN-LABEL "Conte£do da Linha":U
     tt-erro.mensagem  COLUMN-LABEL "Mensagem":U FORMAT "x(70)"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-erro.

FORM tt-dados.cod-estabel       COLUMN-LABEL "Estab":U
     tt-dados.it-codigo         COLUMN-LABEL "Item":U
     tt-dados.lote-minimo       COLUMN-LABEL "Lote Minimo":U
     tt-dados.lote-multpl       COLUMN-LABEL "Lote Multiplo":U
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 300 FRAME f-dados.
                                                                            
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

ASSIGN c-titulo-relat = "Importaá∆o Lote Reposiá∆o para APS":U
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


    RUN esp/es0018p.p (INPUT "escep094":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN i-linha = 0.

    INPUT STREAM str-in FROM VALUE(c-arquivo) NO-CONVERT.
    REPEAT:
        IMPORT STREAM str-in UNFORMATTED c-linha.

        ASSIGN i-linha    = i-linha + 1
               l-erro     = NO.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + TRIM(STRING(i-linha)) + " - ":U + TRIM(c-linha)).

        IF i-linha = 1 THEN
            NEXT.

        RELEASE int-item-uni-estab.

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
        ELSE DO:
             
            FIND FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = string(ITEM.ge-codigo) 
            NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-prog-ponto THEN DO:
               RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                        INPUT c-linha,
                                                        INPUT "Nao permitida a alteracao para o Grupo de Estoque " + string(ITEM.ge-codigo)).

               ASSIGN l-erro = YES.
            END.

            FIND FIRST item-uni-estab
                 WHERE item-uni-estab.it-codigo   = item.it-codigo
                   AND item-uni-estab.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item-uni-estab THEN DO:
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                         INPUT c-linha,
                                                         INPUT "Item X Estabelecimento n∆o encontrado.":U).

                ASSIGN l-erro = YES.
            END.

            FOR FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo
                      NO-LOCK: END.
        END.


        IF TRIM(ENTRY(3, c-linha, ";":U)) <> "" THEN 
           ASSIGN v-lote-minimo = DEC(TRIM(ENTRY(3, c-linha, ";":U))) no-error.

        if error-status:error
        or v-lote-mult = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo Compras possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-lote-minimo > 9999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        IF TRIM(ENTRY(4, c-linha, ";":U)) <> "" THEN 
           ASSIGN v-lote-mult = DEC(TRIM(ENTRY(4, c-linha, ";":U))) no-error.
        

        if error-status:error
        or v-lote-mult = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote Multiplo possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-lote-mult > 9999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote Multiplo n∆o pode ser maior que 9999999!":U).
    
            ASSIGN l-erro = YES.
        END.


        IF l-erro THEN NEXT.

        CREATE tt-dados.
        ASSIGN tt-dados.linha             = i-linha
               tt-dados.conteudo          = c-linha
               tt-dados.cod-estabel       = v-cod-estabel
               tt-dados.it-codigo         = v-it-codigo
               tt-dados.lote-minimo       = v-lote-minimo
               tt-dados.lote-multpl       = v-lote-mult.

    END.
    INPUT STREAM str-in CLOSE.

    /* Atualiza item-uni-estab */
    IF NOT VALID-HANDLE(h-boin684) THEN
       RUN inbo/boin684.p PERSISTENT SET h-boin684.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando importaá∆o...":U).

    bk-dados:
    FOR EACH tt-dados:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + TRIM(STRING(tt-dados.linha)) + " - ":U + TRIM(tt-dados.conteudo)).

        FIND FIRST item-uni-estab
             WHERE item-uni-estab.it-codigo   = tt-dados.it-codigo
               AND item-uni-estab.cod-estabel = tt-dados.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE item-uni-estab THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT tt-dados.linha,
                                                     INPUT tt-dados.conteudo,
                                                     INPUT "Item X Estabelecimento n∆o encontrado.":U).

            ASSIGN tt-dados.erro = YES.

            UNDO bk-dados, NEXT bk-dados.
        END.

        FOR EACH tt-item-uni-estab: DELETE tt-item-uni-estab. END.

        CREATE tt-item-uni-estab.
        BUFFER-COPY item-uni-estab TO tt-item-uni-estab.

        ASSIGN tt-item-uni-estab.r-Rowid      = ROWID (item-uni-estab)
               tt-item-uni-estab.lote-multipl = tt-dados.lote-multpl
               tt-item-uni-estab.lote-minimo  = tt-dados.lote-minimo.

        run openQueryStatic in h-boin684 ("Main").
        RUN emptyRowErrors IN h-boin684.
        
        RUN goToKey IN h-boin684 (INPUT tt-item-uni-estab.it-codigo, INPUT tt-item-uni-estab.cod-estabel).

        IF RETURN-VALUE = "OK":U THEN do:                
            RUN setRecord IN h-boin684 (INPUT TABLE tt-item-uni-estab).   
            RUN updateRecord IN h-boin684.
            RUN validateRecord in h-boin684 (input "Update").
            run getRowErrors   in h-boin684 (output table RowErrors).

            if temp-table RowErrors:has-records then do: 
                for each RowErrors:

                    RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT tt-dados.linha,
                                                             INPUT tt-dados.conteudo,
                                                             INPUT STRING(RowErrors.ErrorNumber) + ' - ' + RowErrors.ErrorDescription).
                 end.
                 run emptyRowErrors  in h-boin684.
                 
                 UNDO bk-dados, NEXT bk-dados.
            end.                
        end.   

        FIND FIRST int-item-uni-estab
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-item-uni-estab THEN DO:
            CREATE int-item-uni-estab.
            ASSIGN int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                   int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo.
        END.                                                         

        
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
            DISPLAY STREAM str-rp
                    tt-dados.cod-estabel
                    tt-dados.it-codigo
                    tt-dados.lote-minimo 
                    tt-dados.lote-multpl
                WITH FRAME f-dados.
            DOWN STREAM str-rp WITH FRAME f-dados.
        END.
    END.

    delete procedure h-boin684 no-error.


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


