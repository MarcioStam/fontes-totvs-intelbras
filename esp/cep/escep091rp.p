/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP091RP 2.04.00.003}
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
    FIELD qtd-min-comp     LIKE int-item-uni-estab.qtd-min-comp   
    FIELD qtd-min-fab      LIKE int-item-uni-estab.qtd-min-fab   
    FIELD qtd-max-comp     LIKE int-item-uni-estab.qtd-max-comp   
    FIELD qtd-max-fab      LIKE int-item-uni-estab.qtd-max-fab    
    FIELD num-dias-min     LIKE int-item-uni-estab.num-dias-min   
    FIELD num-dias-alvo    LIKE int-item-uni-estab.num-dias-alvo 
    FIELD num-dias-cob-mp  LIKE int-item-uni-estab.num-dias-cob-mp   
    FIELD num-dias-alvo-mp LIKE int-item-uni-estab.num-dias-alvo-mp
    FIELD num-dias-antec   LIKE int-item-uni-estab.num-dias-antec 
    FIELD log-item-rest    LIKE int-item-uni-estab.log-item-rest
    field log-bloq-prod    like int-item-uni-estab.log-bloq-prod
    field log-requer-aval  like int-item-uni-estab.log-requer-aval
    FIELD log-aviso        AS LOGICAL EXTENT 30
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

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo  AS CHAR
    field cod-modelo as char
    field linha      as inte.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEFINE VARIABLE v-cod-estabel        LIKE estabelec.cod-estabel                 NO-UNDO.
DEFINE VARIABLE v-it-codigo          LIKE item.it-codigo                        NO-UNDO.
DEFINE VARIABLE v-log-comp-spot      LIKE int-item-uni-estab.log-comp-spot      NO-UNDO.
DEFINE VARIABLE v-log-mod-aereo      LIKE int-item-uni-estab.log-mod-aereo      NO-UNDO.
DEFINE VARIABLE v-log-phase-in       LIKE int-item-uni-estab.log-phase-in       NO-UNDO.
DEFINE VARIABLE v-log-phase-out      LIKE int-item-uni-estab.log-phase-out      NO-UNDO.
DEFINE VARIABLE v-num-dias-transf    LIKE int-item-uni-estab.num-dias-transf    NO-UNDO.
DEFINE VARIABLE v-cod-modelo         LIKE int-item-uni-estab.cod-modelo         NO-UNDO.
DEFINE VARIABLE v-qtd-min-comp       LIKE int-item-uni-estab.qtd-min-comp       NO-UNDO.
DEFINE VARIABLE v-qtd-min-fab        LIKE int-item-uni-estab.qtd-min-fab        NO-UNDO.
DEFINE VARIABLE v-qtd-max-comp       LIKE int-item-uni-estab.qtd-max-comp       NO-UNDO.
DEFINE VARIABLE v-qtd-max-fab        LIKE int-item-uni-estab.qtd-max-fab        NO-UNDO.
DEFINE VARIABLE v-num-dias-min       LIKE int-item-uni-estab.num-dias-min       NO-UNDO.
DEFINE VARIABLE v-num-dias-alvo      LIKE int-item-uni-estab.num-dias-alvo      NO-UNDO.
DEFINE VARIABLE v-num-dias-cob-mp    LIKE int-item-uni-estab.num-dias-cob-mp    NO-UNDO.
DEFINE VARIABLE v-num-dias-alvo-mp   LIKE int-item-uni-estab.num-dias-alvo-mp   NO-UNDO.
DEFINE VARIABLE v-num-dias-antec     LIKE int-item-uni-estab.num-dias-antec     NO-UNDO.
DEFINE VARIABLE v-log-item-rest      LIKE int-item-uni-estab.log-item-rest      NO-UNDO.
DEFINE VARIABLE v-log-bloq-prod      LIKE int-item-uni-estab.log-bloq-prod      NO-UNDO.
define variable v-log-requer-aval    like int-item-uni-estab.log-requer-aval    no-undo.
DEFINE VARIABLE lg-ckd               AS logi                                    NO-UNDO.

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
     tt-dados.qtd-min-comp       COLUMN-LABEL "Lote M°nimo Compras":U
     tt-dados.qtd-min-fab        COLUMN-LABEL "Lote M°nimo Fabricaá∆o":U
     tt-dados.qtd-max-comp       COLUMN-LABEL "Lote M†ximo Compras":U
     tt-dados.qtd-max-fab        COLUMN-LABEL "Lote M†ximo Fabricaá∆o":U
     tt-dados.num-dias-min       COLUMN-LABEL "Qtd Dias M°nimo":U
     tt-dados.num-dias-alvo      COLUMN-LABEL "Qtd Dias Alvo":U
     tt-dados.num-dias-cob-mp    COLUMN-LABEL "Qtd Dias Cob. MP Kit CKD/SKD":U
     tt-dados.num-dias-alvo-mp   COLUMN-LABEL "Qtd Dias Alvo MP Kit CKD/SKD":U
     tt-dados.num-dias-antec     COLUMN-LABEL "Qtd Dias Antec":U
     tt-dados.log-item-rest      COLUMN-LABEL "Item Restritivo":U
     tt-dados.log-bloq-prod      column-label "Bloqueado Produá∆o":U format "Sim/Nao"
     tt-dados.log-requer-aval    column-label "Requer Avaliaá∆o":U   format "Sim/Nao"
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
    DEFINE VARIABLE l-aviso-13  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-14  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-15  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-16  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-17  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-18  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-19  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-20  AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-dados.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-item.

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
               l-aviso-12 = NO
               l-aviso-13 = NO
               l-aviso-14 = NO
               l-aviso-15 = NO
               l-aviso-16 = NO
               l-aviso-17 = NO
               l-aviso-18 = NO
               l-aviso-19 = no
               l-aviso-20 = no.

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
                                                       INPUT "Lote Min.Compras n∆o foi alterado. Campo estava vazio na planilha.":U).
     
            ASSIGN l-aviso-9 = YES.
        END.

        IF TRIM(ENTRY(10, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Lote Min.Fabricaá∆o n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-10 = YES.
        END.

        IF TRIM(ENTRY(11, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Lote M†x.Compras n∆o foi alterado. Campo estava vazio na planilha.":U).
     
            ASSIGN l-aviso-11 = YES.
        END.

        IF TRIM(ENTRY(12, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Lote M†x.Fabricaá∆o n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-12 = YES.
        END.

        IF TRIM(ENTRY(13, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Qtd Dias M°nimo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-13 = YES.
        END.

        IF TRIM(ENTRY(14, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Qtd Dias Alvo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-14 = YES.
        END.

        IF TRIM(ENTRY(15, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Dias Alvo MP n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-15 = YES.
        END.

        IF TRIM(ENTRY(16, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Dias Cobertura MP n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-16 = YES.
        END.

        IF TRIM(ENTRY(17, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Qtd Dias Antec n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-17 = YES.
        END.

        IF TRIM(ENTRY(18, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Item Restritivo n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-18 = YES.
        END.

        IF TRIM(ENTRY(19, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Bloqueado Produá∆o n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-19 = YES.
        END.

        IF TRIM(ENTRY(20, c-linha, ";":U)) = "" THEN DO:
            RUN pi-cria-mens-alerta IN THIS-PROCEDURE (INPUT i-linha,
                                                       INPUT c-linha,
                                                       INPUT "Requer Avaliaá∆o n∆o foi alterado. Campo estava vazio na planilha.":U).
    
            ASSIGN l-aviso-20 = YES.
        END.

        

        IF TRIM(ENTRY(3, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-comp-spot = int-item-uni-estab.log-comp-spot.
            ELSE ASSIGN v-log-comp-spot = NO.
        ELSE do:
            ASSIGN v-log-comp-spot = LOGICAL(replace(TRIM(ENTRY(3, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

            if error-status:error
            OR v-log-comp-spot = ?
            then do:
                 RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                          INPUT c-linha,
                                                          INPUT "Campo Permite Compra Spot possui formato incorreto!":U).
            
                 ASSIGN l-erro = YES.
            end.
        end.
    
        IF TRIM(ENTRY(4, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-mod-aereo = int-item-uni-estab.log-mod-aereo.
            ELSE ASSIGN v-log-mod-aereo = NO.
        ELSE do:
            ASSIGN v-log-mod-aereo = LOGICAL(replace(TRIM(ENTRY(4, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

            if error-status:error
            OR v-log-mod-aereo = ?
            then do:
                 RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                          INPUT c-linha,
                                                          INPUT "Campo Permite Modal AÇreo possui formato incorreto!":U).
            
                 ASSIGN l-erro = YES.
            end.
        end.
    
        IF TRIM(ENTRY(5, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-phase-in = int-item-uni-estab.log-phase-in.
            ELSE ASSIGN v-log-phase-in = NO.
        ELSE do:
            ASSIGN v-log-phase-in = LOGICAL(replace(TRIM(ENTRY(5, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

            if error-status:error
            OR v-log-phase-in = ?
            then do:
                 RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                          INPUT c-linha,
                                                          INPUT "Campo Item Phase-in possui formato incorreto!":U).
            
                 ASSIGN l-erro = YES.
            end.
        end.
    
        IF TRIM(ENTRY(6, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-phase-out = int-item-uni-estab.log-phase-out.
            ELSE ASSIGN v-log-phase-out = NO.
        ELSE do:
            ASSIGN v-log-phase-out = LOGICAL(replace(TRIM(ENTRY(6, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

            if error-status:error
            OR v-log-phase-out = ?
            then do:
                 RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                          INPUT c-linha,
                                                          INPUT "Campo Item Phase-out possui formato incorreto!":U).
            
                 ASSIGN l-erro = YES.
            end.

        end.
    
        IF v-log-phase-in = YES AND v-log-phase-out = YES THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Item n∆o pode ser Phase-in e Phase-out!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(7, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-transf = INT(TRIM(ENTRY(7, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-transf = int-item-uni-estab.num-dias-transf.

        if error-status:error
        or v-num-dias-transf = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Tempo Transf. Estab possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-transf > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Tempo Transf. Estab n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        IF TRIM(ENTRY(8, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-cod-modelo = TRIM(ENTRY(8, c-linha, ";":U)).
        ELSE ASSIGN v-cod-modelo = int-item-uni-estab.cod-modelo.

        IF v-cod-modelo <> "" THEN DO:
            IF NOT CAN-FIND(FIRST int-modelo
                            WHERE int-modelo.cod-modelo = v-cod-modelo) THEN DO:
                RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                         INPUT c-linha,
                                                         INPUT "Modelo n∆o cadastrado!":U).
            
                ASSIGN l-erro = YES.
            END.
        END.

        IF TRIM(ENTRY(9, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-qtd-min-comp = DEC(TRIM(ENTRY(9, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-qtd-min-comp = int-item-uni-estab.qtd-min-comp.

        if error-status:error
        or v-qtd-min-comp = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo Compras possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-qtd-min-comp > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo Compras n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        IF TRIM(ENTRY(10, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-qtd-min-fab = DEC(TRIM(ENTRY(10, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-qtd-min-fab = int-item-uni-estab.qtd-min-fab.

        if error-status:error
        or v-qtd-min-fab = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo Fabricaá∆o possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-qtd-min-fab > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M°nimo Fabricaá∆o n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(11, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-qtd-max-comp = DEC(TRIM(ENTRY(11, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-qtd-max-comp = int-item-uni-estab.qtd-max-comp.

        if error-status:error
        or v-qtd-max-comp = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Compras possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-qtd-max-comp > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Compras n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.
    
        IF TRIM(ENTRY(12, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-qtd-max-fab = DEC(TRIM(ENTRY(12, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-qtd-max-fab = int-item-uni-estab.qtd-max-fab.

        if error-status:error
        or v-qtd-max-fab = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Fabricaá∆o possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-qtd-max-fab > 999999999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Lote M†ximo Fabricaá∆o n∆o pode ser maior que 999999999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(13, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-min = INT(TRIM(ENTRY(13, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-min = int-item-uni-estab.num-dias-min.

        if error-status:error
        or v-num-dias-min = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Minimo possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-min > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Minimo n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(14, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-alvo = INT(TRIM(ENTRY(14, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-alvo = int-item-uni-estab.num-dias-alvo.

        if error-status:error
        or v-num-dias-alvo = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Alvo possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-alvo > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Qtd Dias Alvo n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(15, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-cob-mp = INT(TRIM(ENTRY(15, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-cob-mp = int-item-uni-estab.num-dias-cob-mp.

        if error-status:error
        or v-num-dias-cob-mp = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Cobertura MP possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-min > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Cobertura MP n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(16, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-alvo-mp = INT(TRIM(ENTRY(16, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-alvo-mp = int-item-uni-estab.num-dias-alvo-mp.

        if error-status:error
        or v-num-dias-alvo-mp = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Alvo MP possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-alvo > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Alvo MP n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(17, c-linha, ";":U)) <> ""
        OR NOT AVAIL int-item-uni-estab
        THEN ASSIGN v-num-dias-antec = INT(TRIM(ENTRY(17, c-linha, ";":U))) no-error.
        ELSE ASSIGN v-num-dias-antec = int-item-uni-estab.num-dias-antec.

        if error-status:error
        or v-num-dias-antec = ?
        then do:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Antec possui formato incorreto!":U).
    
            ASSIGN l-erro = YES.
        end.

        IF v-num-dias-antec > 999 THEN DO:
            RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                     INPUT c-linha,
                                                     INPUT "Dias Antec n∆o pode ser maior que 999!":U).
    
            ASSIGN l-erro = YES.
        END.

        IF TRIM(ENTRY(18, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-item-rest = int-item-uni-estab.log-item-rest.
            ELSE ASSIGN v-log-item-rest = NO.
        else do: 
            ASSIGN v-log-item-rest = LOGICAL(replace(TRIM(ENTRY(18, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

             if error-status:error
             OR v-log-item-rest = ?
             then do:
                  RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                           INPUT c-linha,
                                                           INPUT "Campo Item Restritivo possui formato incorreto!":U).
            
                  ASSIGN l-erro = YES.
             end.
        end.

        IF TRIM(ENTRY(19, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-bloq-prod = int-item-uni-estab.log-bloq-prod.
            ELSE ASSIGN v-log-bloq-prod = NO.
        ELSE do:
             ASSIGN v-log-bloq-prod = LOGICAL(replace(TRIM(ENTRY(19, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

             if error-status:error
             OR v-log-bloq-prod = ?
             then do:
                  RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                           INPUT c-linha,
                                                           INPUT "Campo Bloqueado Produá∆o possui formato incorreto!":U).
            
                  ASSIGN l-erro = YES.
             end.
        end.

        IF TRIM(ENTRY(20, c-linha, ";":U)) = "" THEN
            IF AVAIL int-item-uni-estab
            THEN ASSIGN v-log-requer-aval = int-item-uni-estab.log-requer-aval.
            ELSE ASSIGN v-log-requer-aval = NO.
        ELSE do:
            ASSIGN v-log-requer-aval = LOGICAL(replace(TRIM(ENTRY(20, c-linha, ";":U)),"∆","a"),"Sim/Nao") no-error.

            if error-status:error
            OR v-log-requer-aval = ?
            then do:
                 RUN pi-cria-mens-erro IN THIS-PROCEDURE (INPUT i-linha,
                                                          INPUT c-linha,
                                                          INPUT "Campo Requer Avaliaá∆o possui formato incorreto!":U).
            
                 ASSIGN l-erro = YES.
            end.
        end.

        ASSIGN lg-ckd = NOT (v-cod-modelo <> "CKD" AND
                             v-cod-modelo <> "SKD").

        IF NOT lg-ckd THEN DO:
            ASSIGN v-qtd-min-comp      = 0
                   v-qtd-min-fab       = 0
                   v-num-dias-cob-mp   = 0
                   v-num-dias-alvo-mp  = 0.
            CREATE tt-item.
            ASSIGN tt-item.it-codigo  = v-it-codigo
                   tt-item.cod-modelo = v-cod-modelo
                   tt-item.linha      = i-linha.
            find current tt-item no-error.
        END.

        IF l-erro THEN NEXT.

        CREATE tt-dados.
        ASSIGN tt-dados.linha             = i-linha
               tt-dados.conteudo          = c-linha
               tt-dados.cod-estabel       = v-cod-estabel
               tt-dados.it-codigo         = v-it-codigo
               tt-dados.log-comp-spot     = v-log-comp-spot
               tt-dados.log-mod-aereo     = v-log-mod-aereo
               tt-dados.log-phase-in      = v-log-phase-in
               tt-dados.log-phase-out     = v-log-phase-out
               tt-dados.num-dias-transf   = v-num-dias-transf
               tt-dados.cod-modelo        = v-cod-modelo
               tt-dados.qtd-min-comp      = v-qtd-min-comp
               tt-dados.qtd-min-fab       = v-qtd-min-fab
               tt-dados.qtd-max-comp      = v-qtd-max-comp
               tt-dados.qtd-max-fab       = v-qtd-max-fab
               tt-dados.num-dias-min      = v-num-dias-min
               tt-dados.num-dias-alvo     = v-num-dias-alvo
               tt-dados.num-dias-cob-mp   = v-num-dias-cob-mp
               tt-dados.num-dias-alvo-mp  = v-num-dias-alvo-mp
               tt-dados.num-dias-antec    = v-num-dias-antec
               tt-dados.log-item-rest     = v-log-item-rest
               tt-dados.log-bloq-prod     = v-log-bloq-prod
               tt-dados.log-requer-aval   = v-log-requer-aval.

        ASSIGN tt-dados.log-aviso[3]  = l-aviso-3
               tt-dados.log-aviso[4]  = l-aviso-4
               tt-dados.log-aviso[5]  = l-aviso-5
               tt-dados.log-aviso[6]  = l-aviso-6
               tt-dados.log-aviso[7]  = l-aviso-7
               tt-dados.log-aviso[8]  = l-aviso-8
               tt-dados.log-aviso[11] = l-aviso-11
               tt-dados.log-aviso[12] = l-aviso-12
               tt-dados.log-aviso[13] = l-aviso-13
               tt-dados.log-aviso[14] = l-aviso-14
               tt-dados.log-aviso[17] = l-aviso-17
               tt-dados.log-aviso[18] = l-aviso-18
               tt-dados.log-aviso[19] = l-aviso-19
               tt-dados.log-aviso[20] = l-aviso-20.

        IF NOT lg-ckd
        THEN ASSIGN tt-dados.log-aviso[9]  = NO
                    tt-dados.log-aviso[10] = NO
                    tt-dados.log-aviso[15] = NO
                    tt-dados.log-aviso[16] = NO.
        else ASSIGN tt-dados.log-aviso[9]  = l-aviso-9 
                    tt-dados.log-aviso[10] = l-aviso-10
                    tt-dados.log-aviso[15] = l-aviso-15
                    tt-dados.log-aviso[16] = l-aviso-16.
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

        IF tt-param.log-alerta = NO AND NOT CAN-FIND(FIRST tt-alerta)THEN
            ASSIGN l-aviso-3  = NO
                   l-aviso-4  = NO
                   l-aviso-5  = NO
                   l-aviso-6  = NO
                   l-aviso-7  = NO
                   l-aviso-8  = NO
                   l-aviso-9  = NO
                   l-aviso-10 = NO
                   l-aviso-11 = NO
                   l-aviso-12 = NO
                   l-aviso-13 = NO
                   l-aviso-14 = NO
                   l-aviso-15 = NO
                   l-aviso-16 = NO
                   l-aviso-17 = NO
                   l-aviso-18 = NO
                   l-aviso-19 = no
                   l-aviso-20 = no.

        IF tt-dados.log-aviso[3] = NO THEN
            ASSIGN int-item-uni-estab.log-comp-spot = tt-dados.log-comp-spot.
        IF tt-dados.log-aviso[4] = NO THEN
            ASSIGN int-item-uni-estab.log-mod-aereo = tt-dados.log-mod-aereo. 
        IF tt-dados.log-aviso[5] = NO THEN 
            ASSIGN int-item-uni-estab.log-phase-in = tt-dados.log-phase-in.
        IF tt-dados.log-aviso[6] = NO THEN 
            ASSIGN int-item-uni-estab.log-phase-out = tt-dados.log-phase-out.  
        IF tt-dados.log-aviso[7] = NO THEN
            ASSIGN int-item-uni-estab.num-dias-transf = tt-dados.num-dias-transf.
        IF tt-dados.log-aviso[8] = NO THEN
            ASSIGN int-item-uni-estab.cod-modelo = tt-dados.cod-modelo.     
        IF tt-dados.log-aviso[9] = NO THEN
            ASSIGN int-item-uni-estab.qtd-min-comp = tt-dados.qtd-min-comp.   
        IF tt-dados.log-aviso[10] = NO THEN
            ASSIGN int-item-uni-estab.qtd-min-fab = tt-dados.qtd-min-fab.    
        IF tt-dados.log-aviso[11] = NO THEN
            ASSIGN int-item-uni-estab.qtd-max-comp = tt-dados.qtd-max-comp.   
        IF tt-dados.log-aviso[12] = NO THEN
            ASSIGN int-item-uni-estab.qtd-max-fab = tt-dados.qtd-max-fab. 
        IF tt-dados.log-aviso[13] = NO THEN
            ASSIGN int-item-uni-estab.num-dias-min = tt-dados.num-dias-min.   
        IF tt-dados.log-aviso[14] = NO THEN    
            ASSIGN int-item-uni-estab.num-dias-alvo = tt-dados.num-dias-alvo.
        IF tt-dados.log-aviso[15] = NO THEN
            ASSIGN int-item-uni-estab.num-dias-cob-mp = tt-dados.num-dias-cob-mp.   
        IF tt-dados.log-aviso[16] = NO THEN    
            ASSIGN int-item-uni-estab.num-dias-alvo-mp = tt-dados.num-dias-alvo-mp.
        IF tt-dados.log-aviso[17] = NO THEN    
            ASSIGN int-item-uni-estab.num-dias-antec = tt-dados.num-dias-antec.
        IF tt-dados.log-aviso[18] = NO THEN
            ASSIGN int-item-uni-estab.log-item-rest = tt-dados.log-item-rest.
        IF tt-dados.log-aviso[19] = NO THEN
            ASSIGN int-item-uni-estab.log-bloq-prod = tt-dados.log-bloq-prod.
        IF tt-dados.log-aviso[20] = NO THEN
            ASSIGN int-item-uni-estab.log-requer-aval = tt-dados.log-requer-aval.
    END.

    PAGE STREAM str-rp.

    FOR EACH tt-item:
        PUT STREAM str-rp UNFORMATTED
            "Aviso:" SKIP(1)
            "Item: " tt-item.it-codigo " (linha " string(tt-item.linha) ")" SKIP(1)
            "Modelo n∆o Ç CKD/SKD. Os campos " SKIP(1) 
            " - Qtd Minima Compras CKD/SKD " SKIP
            " - Qtd Minima Fabricaá∆o CKD/SKD " SKIP
            " - Dias Cobertura Minima MP Kit CKD/SKD " SKIP
            " - Dias Cobertura MP Kit CKD/SKD " SKIP(1)
            "foram zerados." SKIP(1).
    END.

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
                    tt-dados.qtd-min-comp   
                    tt-dados.qtd-min-fab 
                    tt-dados.qtd-max-comp   
                    tt-dados.qtd-max-fab    
                    tt-dados.num-dias-min   
                    tt-dados.num-dias-alvo 
                    tt-dados.num-dias-cob-mp   
                    tt-dados.num-dias-alvo-mp
                    tt-dados.num-dias-antec
                    tt-dados.log-item-rest      
                    tt-dados.log-bloq-prod
                    tt-dados.log-requer-aval
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

