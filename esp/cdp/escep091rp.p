/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP091RP 2.04.00.002}
/*------------------------------------------------------------------------
    File        : ESCEP091RP.P
    Purpose     : Importaá∆o Dados APS
    Syntax      : <none>
    Description : <none>

    Author(s)   : Graziely Lima (iDBA)
    Created     : Fevereir 2022
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/cep/escep091.i} /* Definiá∆o das temp-tables do programa */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD linha            AS INTEGER
    FIELD conteudo         AS CHARACTER
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD it-codigo        LIKE item.it-codigo
    FIELD log-comp-spot    LIKE int-item-uni-estab.log-comp-spot  
    FIELD log-mod-aereo    LIKE int-item-uni-estab.log-mod-aereo  
    FIELD log-phase-in     LIKE int-item-uni-estab.log-phase-in   
    FIELD log-phase-out    LIKE int-item-uni-estab.log-phase-out  
    FIELD num-dias-transf  LIKE int-item-uni-estab.num-dias-transf
    FIELD cod-modelo       LIKE int-item-uni-estab.cod-modelo     
    FIELD qtd-max-comp     LIKE int-item-uni-estab.qtd-max-comp   
    FIELD qtd-max-fab      LIKE int-item-uni-estab.qtd-max-fab    
    FIELD num-dias-min     LIKE int-item-uni-estab.num-dias-min   
    FIELD num-dias-alvo    LIKE int-item-uni-estab.num-dias-alvo  
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

DEFINE TEMP-TABLE tt-alerta NO-UNDO
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

DEFINE VARIABLE v-cod-estabel     LIKE estabelec.cod-estabel              NO-UNDO.
DEFINE VARIABLE v-it-codigo       LIKE item.it-codigo                     NO-UNDO.
DEFINE VARIABLE v-log-comp-spot   LIKE int-item-uni-estab.log-comp-spot   NO-UNDO.
DEFINE VARIABLE v-log-mod-aereo   LIKE int-item-uni-estab.log-mod-aereo   NO-UNDO.
DEFINE VARIABLE v-log-phase-in    LIKE int-item-uni-estab.log-phase-in    NO-UNDO.
DEFINE VARIABLE v-log-phase-out   LIKE int-item-uni-estab.log-phase-out   NO-UNDO.
DEFINE VARIABLE v-num-dias-transf LIKE int-item-uni-estab.num-dias-transf NO-UNDO.
DEFINE VARIABLE v-cod-modelo      LIKE int-item-uni-estab.cod-modelo      NO-UNDO.
DEFINE VARIABLE v-qtd-max-comp    LIKE int-item-uni-estab.qtd-max-comp    NO-UNDO.
DEFINE VARIABLE v-qtd-max-fab     LIKE int-item-uni-estab.qtd-max-fab     NO-UNDO.
DEFINE VARIABLE v-num-dias-min    LIKE int-item-uni-estab.num-dias-min    NO-UNDO.
DEFINE VARIABLE v-num-dias-alvo   LIKE int-item-uni-estab.num-dias-alvo   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-in.

FORM tt-erro.linha     COLUMN-LABEL "Nro Linha":U
     tt-erro.conteudo  COLUMN-LABEL "Conte£do da Linha":U
     tt-erro.mensagem  COLUMN-LABEL "Mensagem":U FORMAT "x(70)"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-erro.

FORM tt-alerta.linha     COLUMN-LABEL "Nro Linha":U
     tt-alerta.conteudo  COLUMN-LABEL "Conte£do da Linha":U
     tt-alerta.mensagem  COLUMN-LABEL "Mensagem":U FORMAT "x(70)"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-alerta.

FORM tt-dados.cod-estabel        COLUMN-LABEL "Estab":U
     tt-dados.it-codigo          COLUMN-LABEL "Item":U
     tt-dados.log-comp-spot      COLUMN-LABEL "Permite Compra Spot":U
     tt-dados.log-mod-aereo      COLUMN-LABEL "Permite Modal AÇreo":U
     tt-dados.log-phase-in       COLUMN-LABEL "Item Phase-in":U 
     tt-dados.log-phase-out      COLUMN-LABEL "Item Phase-out":U
     tt-dados.num-dias-transf    COLUMN-LABEL "Tempo Transf. Estab":U
     tt-dados.cod-modelo         COLUMN-LABEL "Modelo"
     tt-dados.qtd-max-comp       COLUMN-LABEL "Lote M†ximo Compras":U
     tt-dados.qtd-max-fab        COLUMN-LABEL "Lote M†ximo Fabricaá∆o":U
     tt-dados.num-dias-min       COLUMN-LABEL "Qtd Dias M°nimo":U
     tt-dados.num-dias-alvo      COLUMN-LABEL "Qtd Dias Alvo":U
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-dados.

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

ASSIGN c-titulo-relat = "Importaá∆o Dados para APS":U
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
    DEFINE VARIABLE l-aviso-3   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-4   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-5   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-6   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-7   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-8   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-9   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-10  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-11  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-12  AS LOGICAL     NO-UNDO.

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

        ASSIGN i-linha    = i-linha + 1
               l-erro     = NO
               l-aviso-3  = NO
               l-aviso-4  = NO
               l-aviso-5  = NO
               l-aviso-6  = NO
               l-aviso-7  = NO
               l-aviso-8  = NO
               l-aviso-9  = NO
               l-aviso-10 = NO
               l-aviso-11 = NO
               l-aviso-12 = NO.

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

        IF TRIM(ENTRY(3, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Compra Spot n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-3 = YES.
        END.

        IF TRIM(ENTRY(4, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Modal AÇreo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-4 = YES.
        END.

        IF TRIM(ENTRY(7, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Tempo Transf.Estab. n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-7 = YES.
        END.

        IF TRIM(ENTRY(8, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Modelo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-8 = YES.
        END.

        IF TRIM(ENTRY(9, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Lote M†x.Compras n∆o foi alterado. Campo estava vazio na planilha.":U).
     
            ASSIGN l-aviso-9 = YES.
        END.

        IF TRIM(ENTRY(10, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Lote M†x.Fabricaá∆o n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-10 = YES.
        END.

        IF TRIM(ENTRY(11, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Qtd Dias M°nimo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-11 = YES.
        END.

        IF TRIM(ENTRY(12, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Qtd Dias Alvo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-12 = YES.
        END.

        

        IF TRIM(ENTRY(3, c-linha, ";":U)) = "" THEN
                ASSIGN v-log-comp-spot = NO.
        ELSE 
            ASSIGN v-log-comp-spot = LOGICAL(TRIM(ENTRY(3, c-linha, ";":U)),"Sim/N∆o").
    
        IF TRIM(ENTRY(4, c-linha, ";":U)) = "" THEN
            ASSIGN v-log-mod-aereo = NO.
        ELSE 
            ASSIGN v-log-mod-aereo = LOGICAL(TRIM(ENTRY(4, c-linha, ";":U)),"Sim/N∆o").
    
        IF TRIM(ENTRY(5, c-linha, ";":U)) = "" THEN
            ASSIGN v-log-phase-in = NO.
        ELSE 
            ASSIGN v-log-phase-in = LOGICAL(TRIM(ENTRY(5, c-linha, ";":U)),"Sim/N∆o").
    
        IF TRIM(ENTRY(6, c-linha, ";":U)) = "" THEN
            ASSIGN v-log-phase-out = NO.
        ELSE 
            ASSIGN v-log-phase-out = LOGICAL(TRIM(ENTRY(6, c-linha, ";":U)),"Sim/N∆o").
    
        IF v-log-phase-in = YES AND v-log-phase-out = YES THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Item n∆o pode ser Phase-in e Phase-out!":U).
    
            ASSIGN l-erro = YES.
        END.

        ASSIGN v-num-dias-transf = INT(TRIM(ENTRY(7, c-linha, ";":U))).
        IF v-num-dias-transf > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Tempo Transf. Estab n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        ASSIGN v-cod-modelo = TRIM(ENTRY(8, c-linha, ";":U)).

        IF v-cod-modelo <> "" THEN DO:
            IF NOT CAN-FIND(FIRST int-modelo
                            WHERE int-modelo.cod-modelo = v-cod-modelo) THEN DO:
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                         INPUT c-linha,
                                                         INPUT "Modelo n∆o cadastrado!":U).
            
                ASSIGN l-erro = YES.
            END.
        END.

        ASSIGN v-qtd-max-comp = INT(TRIM(ENTRY(9, c-linha, ";":U))).
        IF v-qtd-max-comp > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Compras n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        ASSIGN v-qtd-max-fab = INT(TRIM(ENTRY(10, c-linha, ";":U))).
        IF v-qtd-max-fab > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Fabricaá∆o n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        ASSIGN v-num-dias-min = INT(TRIM(ENTRY(11, c-linha, ";":U))).
        IF v-num-dias-min > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Minimo n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        ASSIGN v-num-dias-alvo = INT(TRIM(ENTRY(12, c-linha, ";":U))).
        IF v-num-dias-alvo > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Alvo n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        IF l-erro THEN NEXT.

        CREATE tt-dados.
        ASSIGN tt-dados.linha           = i-linha
               tt-dados.conteudo        = c-linha
               tt-dados.cod-estabel     = v-cod-estabel
               tt-dados.it-codigo       = v-it-codigo
               tt-dados.log-comp-spot   = v-log-comp-spot
               tt-dados.log-mod-aereo   = v-log-mod-aereo
               tt-dados.log-phase-in    = v-log-phase-in
               tt-dados.log-phase-out   = v-log-phase-out
               tt-dados.num-dias-transf = v-num-dias-transf
               tt-dados.cod-modelo      = v-cod-modelo
               tt-dados.qtd-max-comp    = v-qtd-max-comp
               tt-dados.qtd-max-fab     = v-qtd-max-fab
               tt-dados.num-dias-min    = v-num-dias-min
               tt-dados.num-dias-alvo   = v-num-dias-alvo.

    END.
    INPUT STREAM str-in CLOSE.

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

        FIND FIRST int-item-uni-estab
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-item-uni-estab THEN DO:
            CREATE int-item-uni-estab.
            ASSIGN int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                   int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo.
        END.

        IF int-item-uni-estab.log-phase-in AND tt-dados.log-phase-out THEN
            ASSIGN tt-dados.log-phase-in = NO.

        IF int-item-uni-estab.log-phase-out AND tt-dados.log-phase-in THEN
            ASSIGN tt-dados.log-phase-out = NO.

        IF tt-param.log-alerta = NO THEN
            ASSIGN l-aviso-3  = NO
                   l-aviso-4  = NO
                   l-aviso-5  = NO
                   l-aviso-6  = NO
                   l-aviso-7  = NO
                   l-aviso-8  = NO
                   l-aviso-9  = NO
                   l-aviso-10 = NO
                   l-aviso-11 = NO
                   l-aviso-12 = NO.

        IF l-aviso-3 = NO THEN
            ASSIGN int-item-uni-estab.log-comp-spot = tt-dados.log-comp-spot.
        IF l-aviso-4 = NO THEN
            ASSIGN int-item-uni-estab.log-mod-aereo = tt-dados.log-mod-aereo. 
        IF l-aviso-5 = NO THEN 
            ASSIGN int-item-uni-estab.log-phase-in = tt-dados.log-phase-in.
        IF l-aviso-6 = NO THEN 
            ASSIGN int-item-uni-estab.log-phase-out = tt-dados.log-phase-out.  
        IF l-aviso-7 = NO THEN
            ASSIGN int-item-uni-estab.num-dias-transf = tt-dados.num-dias-transf.
        IF l-aviso-8 = NO THEN
            ASSIGN int-item-uni-estab.cod-modelo = tt-dados.cod-modelo.     
        IF l-aviso-9 = NO THEN
            ASSIGN int-item-uni-estab.qtd-max-comp = tt-dados.qtd-max-comp.   
        IF l-aviso-10 = NO THEN
            ASSIGN int-item-uni-estab.qtd-max-fab = tt-dados.qtd-max-fab.    
        IF l-aviso-11 = NO THEN
            ASSIGN int-item-uni-estab.num-dias-min = tt-dados.num-dias-min.   
        IF l-aviso-12 = NO THEN    
            ASSIGN int-item-uni-estab.num-dias-alvo = tt-dados.num-dias-alvo.

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

    IF tt-param.log-alerta THEN DO:
        IF CAN-FIND(FIRST tt-alerta) THEN DO:

            PUT STREAM str-rp UNFORMATTED "Mensagem de Aviso":U SKIP(1).
            
            FOR EACH tt-alerta:
                DISPLAY STREAM str-rp
                        tt-alerta.linha
                        tt-alerta.conteudo
                        tt-alerta.mensagem
                    WITH FRAME f-alerta.
                DOWN STREAM str-rp WITH FRAME f-alerta.
            END.

            PAGE STREAM str-rp.
        END.
    END.

    IF tt-param.todos = 1 THEN DO:
        PUT STREAM str-rp UNFORMATTED "Itens Importados":U SKIP(1).

        FOR EACH tt-dados
            WHERE tt-dados.erro = NO:
            DISPLAY STREAM str-rp
                    tt-dados.cod-estabel
                    tt-dados.it-codigo
                    tt-dados.log-comp-spot      
                    tt-dados.log-mod-aereo  
                    tt-dados.log-phase-in   
                    tt-dados.log-phase-out  
                    tt-dados.num-dias-transf
                    tt-dados.cod-modelo     
                    tt-dados.qtd-max-comp   
                    tt-dados.qtd-max-fab    
                    tt-dados.num-dias-min   
                    tt-dados.num-dias-alvo 
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

PROCEDURE pi-cria-mens-alerta :
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

    FIND LAST tt-alerta NO-ERROR.

    ASSIGN i-seq = IF AVAILABLE tt-alerta THEN tt-alerta.sequencia + 1 ELSE 1.

    CREATE tt-alerta.
    ASSIGN tt-alerta.sequencia = i-seq
           tt-alerta.linha     = p-linha
           tt-alerta.conteudo  = p-conteudo
           tt-alerta.mensagem  = p-mensagem.

    RETURN "OK":U.

END PROCEDURE.

