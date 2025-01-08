/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/ccp/esccp025.w
**  Objetivo.: Importa‡Æo de Parametriza‡Æo do Item.
**  Cria‡Æo..: 24/05/2010
**  VersÆo...: 000 - Importa‡Æo de Parametriza‡Æo do Item (ESCCP025). - Fabiano
**             Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
{include/i-prgvrs.i ESCCP025RP 2.04.00.000}

/* Includes Definitions ---                                             */
{esp/ccp/esccp025.i} /* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */
{include/i-rpvar.i}

/* Local Variables Definitions ---                                      */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Local Temp-Tables Definitions ---                                    */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-imprime-todos AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-entrada   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-destino   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-tipo          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-msgs          AS CHARACTER   NO-UNDO.

/* Local Temp-Tables Definitions ---                                    */
DEFINE TEMP-TABLE tt-item-import NO-UNDO
    FIELD i-linha        AS INTEGER LABEL "Linha":U
    FIELD cod-fornec     LIKE emitente.cod-emitente
    FIELD it-codigo      LIKE item.it-codigo
    FIELD pr-item        LIKE item-tab.pr-item
    FIELD nr-tab         LIKE item-tab.nr-tab
    FIELD mo-codigo      LIKE moeda.mo-codigo
    FIELD ativo          LIKE item-fornec.ativo
    FIELD cot-aut        LIKE item-fornec.cot-aut
    FIELD horiz-fixo     LIKE item-uni-estab.horiz-fixo
    FIELD tp-ressup      LIKE item-uni-estab.tp-ressup
    FIELD res-int-comp   LIKE item-uni-estab.res-int-comp
    FIELD res-cq-comp    LIKE item-uni-estab.res-cq-comp
    FIELD perc-compra    LIKE item-fornec.perc-compra
    FIELD lote-minimo    LIKE item-uni-estab.lote-minimo
    FIELD lote-multipl   LIKE item-uni-estab.lote-multipl
    FIELD cod-cond-pag   LIKE item-fornec.cod-cond-pag
    FIELD cod-estabel    LIKE item-uni-estab.cod-estabel
    FIELD deposito-pad   LIKE item-uni-estab.deposito-pad
    FIELD tp-desp-padrao LIKE item-uni-estab.tp-desp-padrao
    FIELD nat-despesa    LIKE item-uni-estab.nat-despesa
    FIELD cod-comprado   LIKE item-uni-estab.cod-comprado
    FIELD cd-planejado   LIKE item-uni-estab.cd-planejado
    FIELD l-demanda-item AS LOGICAL FORMAT "Sim/NÆo":U LABEL "Repressa Demanda":U.

DEFINE TEMP-TABLE tt-msgs NO-UNDO
    FIELD i-seq   AS INTEGER
    FIELD cd-msg  AS INTEGER
    FIELD c-param AS CHARACTER.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras":U
       c-titulo-relat = "Importa‡Æo Parametriza‡Æo Item":U
       c-empresa      = IF AVAILABLE mgcad.empresa THEN mgcad.empresa.razao-social ELSE "":U
       c-programa     = "ESCCP025RP":U
       c-versao       = "2.04":U
       c-revisao      = "000":U.

FORM c-tipo         FORMAT "x(11)":U COLUMN-LABEL "Tipo":U     AT 01
     tt-msgs.cd-msg FORMAT ">>>>9":U COLUMN-LABEL "C¢digo":U   AT 13
     c-msgs         FORMAT "x(80)":U COLUMN-LABEL "Mensagem":U AT 20
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-msgs.

FORM SKIP(1)
    "PAR¶METRO":U                                                     AT 12 SKIP(1)
    c-arq-entrada    FORMAT "x(80)":U LABEL "Arquivo de Entrada":U COLON 37 SKIP(1)
    "LOG":U                                                           AT 12 SKIP(1)
    c-imprime-todos  FORMAT "x(12)":U LABEL "Imprime":U            COLON 37 SKIP
    c-arq-destino    FORMAT "x(80)":U LABEL "Destino":U            COLON 37 SKIP
    tt-param.usuario FORMAT "x(12)":U LABEL "Usu rio":U            COLON 37 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

RUN pi-importa-arquivo.
RUN pi-validacao.
RUN pi-armazena-informacao.

{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
{include/i-rpcab.i &STREAM="str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo log...":U).

FOR EACH tt-msgs:
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Seq.: ":U + STRING(tt-msgs.i-seq) + " - Msg.: ":U + STRING(tt-msgs.cd-msg)).

    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT tt-msgs.cd-msg,
                       INPUT tt-msgs.c-param).

    ASSIGN c-tipo = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT tt-msgs.cd-msg,
                       INPUT tt-msgs.c-param).

    ASSIGN c-msgs = REPLACE(RETURN-VALUE, CHR(10), " ":U)
           c-msgs = REPLACE(c-msgs, "  ":U, " ":U).

    DISPLAY STREAM str-rp
        c-tipo
        tt-msgs.cd-msg
        c-msgs
        WITH FRAME f-msgs.
    DOWN WITH FRAME f-msgs.
END.

IF CAN-FIND(FIRST tt-msgs) THEN
    PAGE STREAM str-rp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo parƒmetros...":U).

ASSIGN c-imprime-todos = ENTRY(tt-param.todos, "Todos,Rejeitados":U, ",":U).

IF  OPSYS = "UNIX":U 
THEN ASSIGN c-arq-entrada = REPLACE(tt-param.arq-entrada, "\":U, "/":U)
            c-arq-destino = REPLACE(tt-param.arq-destino, "\":U, "/":U).
ELSE ASSIGN c-arq-entrada = REPLACE(tt-param.arq-entrada, "/":U, "\":U)
            c-arq-destino = REPLACE(tt-param.arq-destino, "/":U, "\":U).


DISPLAY STREAM str-rp
    c-arq-entrada
    c-imprime-todos
    c-arq-destino
    tt-param.usuario
    WITH FRAME f-impressao.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &STREAM="stream str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importa-arquivo:
/*------------------------------------------------------------------------------
  Purpose:     Importar arquivos para o sistema.
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-lin AS INTEGER INITIAL 0  NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Importando dados...":U).

    FOR EACH tt-item-import:
        DELETE tt-item-import.
    END.

    INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).
    REPEAT ON STOP UNDO, LEAVE:
        IMPORT STREAM s-imp UNFORMATTED c-linha.

        ASSIGN i-lin = i-lin + 1.

        IF i-lin = 1 THEN
            NEXT.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT c-linha).

        CREATE tt-item-import.
        ASSIGN tt-item-import.i-linha        = i-lin
               tt-item-import.cod-fornec     = INTEGER(TRIM(ENTRY( 1, c-linha, ";":U)))
               tt-item-import.it-codigo      =         TRIM(ENTRY( 2, c-linha, ";":U))
               tt-item-import.pr-item        = DECIMAL(TRIM(ENTRY( 3, c-linha, ";":U)))
               tt-item-import.nr-tab         =         TRIM(ENTRY( 4, c-linha, ";":U))
               tt-item-import.mo-codigo      = INTEGER(TRIM(ENTRY( 5, c-linha, ";":U)))
               tt-item-import.ativo          =      IF TRIM(ENTRY( 6, c-linha, ";":U)) = "Sim":U THEN YES ELSE NO
               tt-item-import.cot-aut        =      IF TRIM(ENTRY( 7, c-linha, ";":U)) = "Sim":U THEN YES ELSE NO
               tt-item-import.horiz-fixo     = INTEGER(TRIM(ENTRY( 8, c-linha, ";":U)))
               tt-item-import.tp-ressup      = INTEGER(TRIM(ENTRY( 9, c-linha, ";":U)))
               tt-item-import.res-int-comp   = INTEGER(TRIM(ENTRY(10, c-linha, ";":U)))
               tt-item-import.res-cq-comp    = INTEGER(TRIM(ENTRY(11, c-linha, ";":U)))
               tt-item-import.perc-compra    = INTEGER(TRIM(ENTRY(12, c-linha, ";":U)))
               tt-item-import.lote-minimo    = DECIMAL(TRIM(ENTRY(13, c-linha, ";":U)))
               tt-item-import.lote-multipl   = DECIMAL(TRIM(ENTRY(14, c-linha, ";":U)))
               tt-item-import.cod-cond-pag   = INTEGER(TRIM(ENTRY(15, c-linha, ";":U)))
               tt-item-import.cod-estabel    =         TRIM(ENTRY(16, c-linha, ";":U))
               tt-item-import.deposito-pad   =         TRIM(ENTRY(17, c-linha, ";":U))
               tt-item-import.tp-desp-padrao = INTEGER(TRIM(ENTRY(18, c-linha, ";":U)))
               tt-item-import.nat-despesa    = INTEGER(TRIM(ENTRY(19, c-linha, ";":U)))
               tt-item-import.cod-comprado   =         TRIM(ENTRY(20, c-linha, ";":U))
               tt-item-import.cd-planejado   =         TRIM(ENTRY(21, c-linha, ";":U))
               tt-item-import.l-demanda-item =      IF TRIM(ENTRY(22, c-linha, ";":U)) = "Sim":U THEN YES ELSE NO.    
    END.
    INPUT STREAM s-imp CLOSE.
END PROCEDURE.

PROCEDURE pi-validacao:
/*------------------------------------------------------------------------------
  Purpose:     Validar informa‡äes importadas
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia AS INTEGER INITIAL 0    NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Validando dados importados...":U).

    FOR EACH tt-msgs:
        DELETE tt-msgs.
    END.

    FOR EACH tt-item-import:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Fornec.: ":U + STRING(tt-item-import.cod-fornec, ">>>>>>>>9":U) + " - Item: ":U + tt-item-import.it-codigo).

        FIND FIRST item
            WHERE item.it-codigo = tt-item-import.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            CREATE tt-msgs.
            ASSIGN i-sequencia    = i-sequencia + 1
                   tt-msgs.i-seq  = i-sequencia
                   tt-msgs.cd-msg = 2
                   tt-msgs.c-param = "'Item'~~(Linha ":U + STRING(tt-item-import.i-linha) + ")":U.
            DELETE tt-item-import.
            NEXT.
        END.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-item-import.cod-fornec NO-LOCK NO-ERROR.

        IF NOT AVAILABLE emitente THEN DO:
            CREATE tt-msgs.
            ASSIGN i-sequencia    = i-sequencia + 1
                   tt-msgs.i-seq  = i-sequencia
                   tt-msgs.cd-msg = 2
                   tt-msgs.c-param = "'Fornecedor'~~(Linha ":U + STRING(tt-item-import.i-linha) + ")":U.
            DELETE tt-item-import.
            NEXT.
        END.

        FIND FIRST tb-pr-cc
            WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente
              AND tb-pr-cc.cod-cond-pag = tt-item-import.cod-cond-pag
              AND tb-pr-cc.nr-tab       = tt-item-import.nr-tab
              AND tb-pr-cc.dt-inicio   <= TODAY
              AND tb-pr-cc.dt-termino  >= TODAY
              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE tb-pr-cc THEN DO:
            CREATE tt-msgs.
            ASSIGN i-sequencia    = i-sequencia + 1
                   tt-msgs.i-seq  = i-sequencia
                   tt-msgs.cd-msg = 2
                   tt-msgs.c-param = "'Pre‡o M¢dulo Controle Compras'~~(Linha ":U + STRING(tt-item-import.i-linha) + ")":U.
            DELETE tt-item-import.
            NEXT.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-armazena-informacao:
/*------------------------------------------------------------------------------
  Purpose:     Armazena informa‡äes importadas
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia AS INTEGER INITIAL 0    NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Salvando dados importados...":U).

    FIND LAST tt-msgs NO-LOCK NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-msgs THEN tt-msgs.i-seq ELSE 0.

    FOR EACH tt-item-import:

        FIND FIRST item
            WHERE item.it-codigo = tt-item-import.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            CREATE tt-msgs.
            ASSIGN i-sequencia    = i-sequencia + 1
                   tt-msgs.i-seq  = i-sequencia
                   tt-msgs.cd-msg = 2
                   tt-msgs.c-param = "'Item'~~Linha ":U + STRING(tt-item-import.i-linha).
            NEXT.
        END.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Fornec.: ":U + STRING(tt-item-import.cod-fornec, ">>>>>>>>9":U) + " - Item: ":U + tt-item-import.it-codigo).

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = tt-item-import.it-codigo
              AND item-uni-estab.cod-estabel = tt-item-import.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE item-uni-estab THEN DO:
            CREATE item-uni-estab.
            ASSIGN item-uni-estab.it-codigo   = tt-item-import.it-codigo
                   item-uni-estab.cod-estabel = tt-item-import.cod-estabel.
        END.

        ASSIGN item-uni-estab.horiz-fixo              = tt-item-import.horiz-fixo
               item-uni-estab.tp-desp-padrao          = tt-item-import.tp-desp-padrao
               item-uni-estab.deposito-pad            = tt-item-import.deposito-pad
               item-uni-estab.tp-ressup               = tt-item-import.tp-ressup
               item-uni-estab.res-int-comp            = tt-item-import.res-int-comp
               item-uni-estab.res-cq-comp             = tt-item-import.res-cq-comp
               item-uni-estab.nat-despesa             = tt-item-import.nat-despesa
               item-uni-estab.lote-multipl            = tt-item-import.lote-multipl
               item-uni-estab.lote-minimo             = tt-item-import.lote-minimo
               item-uni-estab.cd-planejado            = tt-item-import.cd-planejado
               OVERLAY(item-uni-estab.char-1, 132, 1) = IF l-demanda-item THEN "1":U ELSE "0":U
               item-uni-estab.classe-repro            = 4 /* NÆo Reprograma */
               item-uni-estab.cod-comprado            = tt-item-import.cod-comprado
               OVERLAY(item-uni-estab.char-1, 129, 3) = TRIM(STRING(item-uni-estab.horiz-fixo)).

        FIND FIRST item-fornec
            WHERE item-fornec.it-codigo    = item-uni-estab.it-codigo
              AND item-fornec.cod-emitente = tt-item-import.cod-fornec EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE item-fornec THEN DO:
            CREATE item-fornec.
            ASSIGN item-fornec.cod-emitente = tt-item-import.cod-fornec
                   item-fornec.it-codigo    = item-uni-estab.it-codigo.
        END.
        
        ASSIGN item-fornec.item-do-forn = item-fornec.it-codigo
               item-fornec.unid-med-for = item.un
               item-fornec.fator-conver = item.fator-conver
               item-fornec.num-casa-dec = 0
               item-fornec.tempo-ressup = item-uni-estab.tp-ressup
               item-fornec.ativo        = NO
               item-fornec.lote-minimo  = item-uni-estab.lote-minimo
               item-fornec.lote-mul-for = item-uni-estab.lote-multipl
               item-fornec.perc-compra  = tt-item-import.perc-compra
               item-fornec.cot-aut      = tt-item-import.cot-aut
               item-fornec.cod-cond-pag = tt-item-import.cod-cond-pag
               item-fornec.classe-repro = 4 /* NÆo Reprograma */
               item-fornec.horiz-fixo   = item-uni-estab.horiz-fixo.

        FIND FIRST item-fornec-estab
            WHERE item-fornec-estab.it-codigo    = item-fornec.it-codigo
              AND item-fornec-estab.cod-emitente = item-fornec.cod-emitente
              AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE item-fornec-estab THEN DO:
            CREATE item-fornec-estab.
            ASSIGN item-fornec-estab.it-codigo    = item-fornec.it-codigo
                   item-fornec-estab.cod-emitente = item-fornec.cod-emitente
                   item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel.
        END.

        ASSIGN item-fornec-estab.item-do-forn = item-fornec.item-do-forn
               item-fornec-estab.unid-med-for = item-fornec.unid-med-for
               item-fornec-estab.fator-conver = item-fornec.fator-conver
               item-fornec-estab.num-casa-dec = item-fornec.num-casa-dec
               item-fornec-estab.tempo-ressup = item-fornec.tempo-ressup
               item-fornec-estab.ativo        = YES
               item-fornec-estab.lote-minimo  = item-fornec.lote-minimo
               item-fornec-estab.lote-mul-for = item-fornec.lote-mul-for
               item-fornec-estab.perc-compra  = item-fornec.perc-compra
               item-fornec-estab.cot-aut      = item-fornec.cot-aut
               item-fornec-estab.cod-cond-pag = item-fornec.cod-cond-pag
               item-fornec-estab.horiz-fixo   = item-fornec.horiz-fixo.

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = tt-item-import.cod-fornec  
              AND int-item-for-PN.it-codigo    = item-uni-estab.it-codigo NO-ERROR.
        IF  NOT AVAIL int-item-for-PN THEN DO:
            CREATE int-item-for-PN.
            ASSIGN int-item-for-PN.cod-emitente = tt-item-import.cod-fornec
                   int-item-for-PN.it-codigo    = item-uni-estab.it-codigo 
                   int-item-for-PN.item-do-forn = item-uni-estab.it-codigo.
         END.

        FIND FIRST tb-pr-cc
            WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
              AND tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag
              AND tb-pr-cc.nr-tab       = tt-item-import.nr-tab
              AND tb-pr-cc.dt-inicio   <= TODAY
              AND tb-pr-cc.dt-termino  >= TODAY
              AND tb-pr-cc.situacao     = 1 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE tb-pr-cc THEN
            ASSIGN tb-pr-cc.mo-codigo = tt-item-import.mo-codigo.

        FIND LAST item-tab
            WHERE item-tab.it-codigo    = item-fornec-estab.it-codigo
              AND item-tab.cod-emitente = item-fornec-estab.cod-emitente
              AND item-tab.cod-cond-pag = item-fornec-estab.cod-cond-pag
              AND item-tab.nr-tab       = tt-item-import.nr-tab EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE item-tab THEN DO:
            CREATE item-tab.
            ASSIGN item-tab.cod-emitente = item-fornec-estab.cod-emitente
                   item-tab.cod-cond-pag = item-fornec-estab.cod-cond-pag
                   item-tab.nr-tab       = tt-item-import.nr-tab
                   item-tab.dt-inicio    = 01/01/1900
                   item-tab.it-codigo    = item-fornec-estab.it-codigo
                   item-tab.quant-min    = 0.
        END.

        ASSIGN item-tab.pr-item = tt-item-import.pr-item.

        IF tt-param.todos = 1 THEN DO:
            CREATE tt-msgs.
            ASSIGN i-sequencia     = i-sequencia + 1
                   tt-msgs.i-seq   = i-sequencia
                   tt-msgs.cd-msg  = 3377
                   tt-msgs.c-param = "Fornec. ":U + TRIM(STRING(tt-item-import.cod-fornec)) + "/Item ":U + TRIM(tt-item-import.it-codigo) + " (Linha ":U + TRIM(STRING(tt-item-import.i-linha)) + ") ":U.
        END.

    END.
END PROCEDURE.
