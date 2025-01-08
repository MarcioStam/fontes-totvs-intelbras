/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESENP019RP 2.00.00.001}
/*------------------------------------------------------------------------
    File        : ESENP019RP.P
    Purpose     : Relat¢rio de Movimenta‡äes do Item, por Opera‡Æo, Grupo
                  de M quina, Centro de Custo, Ordem de produ‡Æo, etc.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/enp/esenp019.i}
{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-movto-item NO-UNDO
    FIELD cod-estabel       LIKE movto-ggf.cod-estabel
    FIELD it-codigo         LIKE movto-ggf.it-codigo
    FIELD desc-item         LIKE item.desc-item
    FIELD op-codigo         LIKE movto-ggf.op-codigo
    FIELD desc-oper         LIKE operacao.descricao
    FIELD gm-codigo         LIKE movto-ggf.gm-codigo
    FIELD cc-codigo         LIKE movto-ggf.cc-codigo
    FIELD horas-report      LIKE movto-ggf.horas-report     FORMAT "->>>,>>9.9999":U
    FIELD nr-ord-produ      LIKE movto-ggf.nr-ord-produ
    FIELD tipo              AS CHARACTER
    FIELD estado            AS CHARACTER
    FIELD un                LIKE ord-prod.un
    FIELD dt-trans          LIKE movto-ggf.dt-trans
    FIELD quantidade        LIKE movto-ggf.qt-reportada     FORMAT "->>>>>,>>9.9999":U
    FIELD valor-ggf-1-m     LIKE movto-ggf.valor-ggf-1-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-2-m     LIKE movto-ggf.valor-ggf-2-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-3-m     LIKE movto-ggf.valor-ggf-3-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-4-m     LIKE movto-ggf.valor-ggf-4-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-5-m     LIKE movto-ggf.valor-ggf-5-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-6-m     LIKE movto-ggf.valor-ggf-6-m[1] FORMAT "->>>>,>>>,>>9.9999":U
    FIELD valor-ggf-total-m AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U LABEL "Valor Total":U COLUMN-LABEL "Vlr Total":U
    INDEX id
        cod-estabel
        nr-ord-produ
        dt-trans
        it-codigo
        op-codigo.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO FORMAT "x(15)":U LABEL "Destino":U.

DEFINE VARIABLE c-arquivo LIKE tt-param.arquivo NO-UNDO.
DEFINE VARIABLE c-arq-csv LIKE tt-param.arq-csv NO-UNDO.

DEFINE VARIABLE de-valor-ggf-1-m AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ggf-2-m AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ggf-3-m AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ggf-4-m AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ggf-5-m AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ggf-6-m AS DECIMAL     NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-csv.

/* Form Definitions ---                                                 */

FORM tt-movto-item.cod-estabel  AT 01 LABEL "Estabelecimento":U
     tt-movto-item.nr-ord-produ FORMAT ">>>>>>>>9":U SKIP(1)
    WITH WIDTH 255 SIDE-LABELS FRAME f-movto-cab STREAM-IO.

FORM tt-movto-item.it-codigo               COLUMN-LABEL "Item":U
     tt-movto-item.desc-item
     tt-movto-item.op-codigo
     tt-movto-item.desc-oper
     tt-movto-item.gm-codigo
     tt-movto-item.cc-codigo               COLUMN-LABEL "C Custo":U
     tt-movto-item.horas-report
     tt-movto-item.tipo   FORMAT "x(18)":U COLUMN-LABEL "Tipo Ordem":U
     tt-movto-item.estado FORMAT "x(10)":U COLUMN-LABEL "Estado Ordem":U
     tt-movto-item.un                      COLUMN-LABEL "Unidade":U
     tt-movto-item.dt-trans
     tt-movto-item.quantidade
     tt-movto-item.valor-ggf-1-m
     tt-movto-item.valor-ggf-2-m
     tt-movto-item.valor-ggf-3-m
     tt-movto-item.valor-ggf-4-m
     tt-movto-item.valor-ggf-5-m
     tt-movto-item.valor-ggf-6-m
     tt-movto-item.valor-ggf-total-m
    WITH NO-BOX WIDTH 255 DOWN NO-ATTR-SPACE FRAME f-movto STREAM-IO.

FORM "PAR¶METROS":U              AT 05 SKIP(2)
     "SELE€ÇO":U                 AT 10 SKIP(1)
     tt-param.cod-estabel-ini COLON 30 LABEL "Estabelecimento":U
     "|< >|":U                   AT 49
     tt-param.cod-estabel-fin    AT 55 NO-LABEL SKIP
     tt-param.cod-ccusto-ini  COLON 30
     "|< >|":U                   AT 49
     tt-param.cod-ccusto-fin     AT 55 NO-LABEL SKIP
     tt-param.it-codigo-ini   COLON 30
     "|< >|":U                   AT 49
     tt-param.it-codigo-fin      AT 55 NO-LABEL
     tt-param.periodo-ini     COLON 30 LABEL "Per¡odo":U
     "|< >|":U                   AT 49
     tt-param.periodo-fin        AT 55 NO-LABEL SKIP(1)
     "PAR¶METRO":U               AT 10 SKIP(1)
     tt-param.gerar-csv       COLON 30 LABEL "Gerar CSV":U
     c-arq-csv                COLON 30 LABEL "Arquivo CSV":U SKIP(1)
     "IMPRESSÇO":U               AT 10 SKIP(1)
     c-destino                COLON 30 SKIP
     c-arquivo                COLON 30 FORMAT "x(95)":U LABEL "Arquivo":U SKIP
     tt-param.usuario         COLON 30 LABEL "Usu rio":U SKIP
    WITH WIDTH 255 SIDE-LABELS FRAME f-param STREAM-IO.

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Relat¢rio de Movimenta‡äes do Item":U
       c-sistema      = "Espec¡ficos Intelbras":U.

{include/i-rpc255.i &STREAM="str-rp"}
{include/i-rpout.i &STREAM="STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec-255.
VIEW STREAM str-rp FRAME f-rodape-255.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Iniciando...":U) NO-ERROR.

RUN pi-movtos-item IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Finalizando...":U).

IF tt-param.param-impr THEN
    RUN pi-imprime-param IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

{include/i-rpclo.i &STREAM="STREAM str-rp"}

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-movtos-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-aux-ini AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-aux-fin AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-aux     AS DATE        NO-UNDO.

    DEFINE VARIABLE v-quantidade LIKE movto-estoq.quantidade NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Reunindo informa‡äes...":U).

    EMPTY TEMP-TABLE tt-movto-item.

    ASSIGN dt-aux-ini = DATE(INTEGER(SUBSTRING(tt-param.periodo-ini, 5, 2)), 01, INTEGER(SUBSTRING(tt-param.periodo-ini, 1, 4)))
           dt-aux-fin = DATE(INTEGER(SUBSTRING(tt-param.periodo-fin, 5, 2)), 25, INTEGER(SUBSTRING(tt-param.periodo-fin, 1, 4)))
           dt-aux-fin = dt-aux-fin + 15
           dt-aux-fin = dt-aux-fin - DAY(dt-aux-fin).

    DO dt-aux = dt-aux-ini TO dt-aux-fin:
        FOR EACH movto-ggf FIELDS(cod-estabel it-codigo op-codigo gm-codigo cc-codigo horas-report nr-ord-produ dt-trans tipo-trans valor-ggf-1-m valor-ggf-2-m valor-ggf-3-m valor-ggf-4-m valor-ggf-5-m valor-ggf-6-m) USE-INDEX data NO-LOCK
            WHERE movto-ggf.cod-estabel >= tt-param.cod-estabel-ini
              AND movto-ggf.cod-estabel <= tt-param.cod-estabel-fin
              AND movto-ggf.cc-codigo   >= tt-param.cod-ccusto-ini
              AND movto-ggf.cc-codigo   <= tt-param.cod-ccusto-fin
              AND movto-ggf.it-codigo   >= tt-param.it-codigo-ini
              AND movto-ggf.it-codigo   <= tt-param.it-codigo-fin
              AND movto-ggf.dt-trans     = dt-aux:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Est/Ord Prod: ":U + movto-ggf.cod-estabel + "/":U + TRIM(STRING(movto-ggf.nr-ord-produ, ">>>,>>>,>>9":U)) + " - Item: ":U + movto-ggf.it-codigo).

            FIND FIRST item
                WHERE item.it-codigo = movto-ggf.it-codigo NO-LOCK NO-ERROR.
            
            
            FIND FIRST ord-prod
                WHERE ord-prod.nr-ord-produ = movto-ggf.nr-ord-produ NO-LOCK NO-ERROR.

            FIND FIRST oper-ord WHERE oper-ord.nr-ord-produ = movto-ggf.nr-ord-produ    AND
                                      oper-ord.it-codigo    = movto-ggf.it-codigo       AND 
                                      oper-ord.cod-roteiro  = movto-ggf.cod-roteiro     AND
                                      oper-ord.op-codigo    = movto-ggf.op-codigo NO-LOCK NO-ERROR.

            ASSIGN v-quantidade = 0.

            FOR EACH movto-estoq NO-LOCK
                WHERE movto-estoq.nr-ord-produ = movto-ggf.nr-ord-produ:
                IF movto-estoq.esp-docto = 1 THEN /* ACA */
                    ASSIGN v-quantidade = v-quantidade + movto-estoq.quantidade.

                IF movto-estoq.esp-docto = 8 THEN /* EAC */
                    ASSIGN v-quantidade = v-quantidade - movto-estoq.quantidade.
            END.

            CREATE tt-movto-item.
            ASSIGN tt-movto-item.cod-estabel       = movto-ggf.cod-estabel
                   tt-movto-item.it-codigo         = movto-ggf.it-codigo
                   tt-movto-item.desc-item         = IF AVAILABLE item THEN item.desc-item ELSE "":U
                   tt-movto-item.op-codigo         = movto-ggf.op-codigo
                   tt-movto-item.desc-oper         = IF AVAILABLE oper-ord THEN oper-ord.descricao ELSE "":U
                   tt-movto-item.gm-codigo         = movto-ggf.gm-codigo
                   tt-movto-item.cc-codigo         = movto-ggf.cc-codigo
                   tt-movto-item.horas-report      = movto-ggf.horas-report
                   tt-movto-item.nr-ord-produ      = movto-ggf.nr-ord-produ
                   tt-movto-item.tipo              = IF AVAILABLE ord-prod THEN ({ininc/i10in271.i 04 ord-prod.tipo})   ELSE "":U
                   tt-movto-item.estado            = IF AVAILABLE ord-prod THEN ({ininc/i01in271.i 04 ord-prod.estado}) ELSE "":U
                   tt-movto-item.un                = IF AVAILABLE ord-prod THEN ord-prod.un ELSE "":U
                   tt-movto-item.dt-trans          = movto-ggf.dt-trans
                   tt-movto-item.quantidade        = v-quantidade 
                   tt-movto-item.valor-ggf-1-m     = movto-ggf.valor-ggf-1-m[1]
                   tt-movto-item.valor-ggf-2-m     = movto-ggf.valor-ggf-2-m[1]
                   tt-movto-item.valor-ggf-3-m     = movto-ggf.valor-ggf-3-m[1]
                   tt-movto-item.valor-ggf-4-m     = movto-ggf.valor-ggf-4-m[1]
                   tt-movto-item.valor-ggf-5-m     = movto-ggf.valor-ggf-5-m[1]
                   tt-movto-item.valor-ggf-6-m     = movto-ggf.valor-ggf-6-m[1]
                   tt-movto-item.valor-ggf-total-m = movto-ggf.valor-ggf-1-m[1] + movto-ggf.valor-ggf-2-m[1] + movto-ggf.valor-ggf-3-m[1] + movto-ggf.valor-ggf-4-m[1] + movto-ggf.valor-ggf-5-m[1] + movto-ggf.valor-ggf-6-m[1].
            
            IF movto-ggf.tipo-trans = 2 THEN
                ASSIGN tt-movto-item.horas-report      = tt-movto-item.horas-report      * -1
                       tt-movto-item.valor-ggf-1-m     = tt-movto-item.valor-ggf-1-m     * -1
                       tt-movto-item.valor-ggf-2-m     = tt-movto-item.valor-ggf-2-m     * -1
                       tt-movto-item.valor-ggf-3-m     = tt-movto-item.valor-ggf-3-m     * -1
                       tt-movto-item.valor-ggf-4-m     = tt-movto-item.valor-ggf-4-m     * -1
                       tt-movto-item.valor-ggf-5-m     = tt-movto-item.valor-ggf-5-m     * -1
                       tt-movto-item.valor-ggf-6-m     = tt-movto-item.valor-ggf-6-m     * -1
                       tt-movto-item.valor-ggf-total-m = tt-movto-item.valor-ggf-total-m * -1.
        END.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Gerando relat¢rio...":U).

    IF CAN-FIND(FIRST tt-movto-item) THEN DO:
        FIND FIRST param-cs NO-LOCK NO-ERROR.

        IF AVAILABLE param-cs THEN
            ASSIGN tt-movto-item.valor-ggf-1-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[1])
                   tt-movto-item.valor-ggf-2-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[2])
                   tt-movto-item.valor-ggf-3-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[3])
                   tt-movto-item.valor-ggf-4-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[4])
                   tt-movto-item.valor-ggf-5-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[5])
                   tt-movto-item.valor-ggf-6-m:LABEL IN FRAME f-movto = TRIM(param-cs.ocorrencia[6]).
        ELSE
            ASSIGN tt-movto-item.valor-ggf-1-m:LABEL IN FRAME f-movto = "MOB Dir":U
                   tt-movto-item.valor-ggf-2-m:LABEL IN FRAME f-movto = "Gastos Dir":U
                   tt-movto-item.valor-ggf-3-m:LABEL IN FRAME f-movto = "Depr Dir":U
                   tt-movto-item.valor-ggf-4-m:LABEL IN FRAME f-movto = "Mob Ind":U
                   tt-movto-item.valor-ggf-5-m:LABEL IN FRAME f-movto = "Gastos Ind":U
                   tt-movto-item.valor-ggf-6-m:LABEL IN FRAME f-movto = "Depr Ind":U.

        IF tt-param.gerar-csv THEN DO:
            IF i-num-ped-exec-rpw <> 0 THEN
                OUTPUT STREAM str-csv TO VALUE(c-dir-spool-servid-exec + "/":U + tt-param.arq-csv) CONVERT TARGET "iso8859-1":U.
            ELSE
                OUTPUT STREAM str-csv TO VALUE(tt-param.arq-csv) CONVERT TARGET "iso8859-1":U.

            PUT STREAM str-csv UNFORMATTED "Estabelecimento;Ordem Produ‡Æo;Item;Descri‡Æo Item;Opera‡Æo;Descri‡Æo Opera‡Æo;Grupo M quina;Centro Custo;Horas Reportadas;Tipo Ordem;Estado Ordem;Unidade Medida;Data Transa‡Æo;Quantidade Reportada":U.
             
            IF AVAILABLE param-cs THEN
                PUT STREAM str-csv UNFORMATTED ";":U + param-cs.ocorrencia[1] + ";":U + param-cs.ocorrencia[2] + ";":U + param-cs.ocorrencia[3] + ";":U + param-cs.ocorrencia[4] + ";":U + param-cs.ocorrencia[5] + ";":U + param-cs.ocorrencia[6].
            ELSE
                PUT STREAM str-csv UNFORMATTED ";MOB Dir;Gastos Dir;Depr Dir;Mob Ind;Gastos Ind;Depr Ind":U.

            PUT STREAM str-csv UNFORMATTED ";Valor Total":U SKIP.
        END.

        FOR EACH tt-movto-item
            BREAK BY tt-movto-item.cod-estabel
                  BY tt-movto-item.nr-ord-produ:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Est/Ord Prod: ":U + tt-movto-item.cod-estabel + "/":U + TRIM(STRING(tt-movto-item.nr-ord-produ, ">>>,>>>,>>9":U)) + " - Item: ":U + tt-movto-item.it-codigo).

            IF FIRST-OF(tt-movto-item.nr-ord-produ) THEN
                DISPLAY STREAM str-rp
                        tt-movto-item.cod-estabel
                        tt-movto-item.nr-ord-produ
                    WITH FRAME f-movto-cab.

            DISPLAY STREAM str-rp
                    tt-movto-item.it-codigo
                    tt-movto-item.desc-item
                    tt-movto-item.op-codigo
                    tt-movto-item.desc-oper
                    tt-movto-item.gm-codigo
                    tt-movto-item.cc-codigo
                    tt-movto-item.horas-report
                    tt-movto-item.tipo
                    tt-movto-item.estado
                    tt-movto-item.un
                    tt-movto-item.dt-trans
                    tt-movto-item.quantidade
                    tt-movto-item.valor-ggf-1-m
                    tt-movto-item.valor-ggf-2-m
                    tt-movto-item.valor-ggf-3-m
                    tt-movto-item.valor-ggf-4-m
                    tt-movto-item.valor-ggf-5-m
                    tt-movto-item.valor-ggf-6-m
                    tt-movto-item.valor-ggf-total-m
                WITH FRAME f-movto.
            DOWN WITH FRAME f-movto.

            IF LAST-OF(tt-movto-item.nr-ord-produ) THEN
                PUT STREAM str-rp SKIP(2).

            IF tt-param.gerar-csv THEN
                PUT STREAM str-csv UNFORMATTED TRIM(tt-movto-item.cod-estabel)                                        ";":U
                                               TRIM(STRING(tt-movto-item.nr-ord-produ, ">>>>>>>>9":U))                ";":U
                                               TRIM(tt-movto-item.it-codigo)                                          ";":U
                                               TRIM(tt-movto-item.desc-item)                                          ";":U
                                               TRIM(STRING(tt-movto-item.op-codigo, ">>>>9":U))                       ";":U
                                               TRIM(tt-movto-item.desc-oper)                                          ";":U
                                               TRIM(tt-movto-item.gm-codigo)                                          ";":U
                                               TRIM(tt-movto-item.cc-codigo)                                          ";":U
                                               TRIM(STRING(tt-movto-item.horas-report, "->>>,>>9.9999":U))            ";":U
                                               TRIM(tt-movto-item.tipo)                                               ";":U
                                               TRIM(tt-movto-item.estado)                                             ";":U
                                               TRIM(tt-movto-item.un)                                                 ";":U
                                               TRIM(STRING(tt-movto-item.dt-trans, "99/99/9999":U))                   ";":U
                                               TRIM(STRING(tt-movto-item.quantidade, "->>>>>,>>9.9999":U))            ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-1-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-2-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-3-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-4-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-5-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-6-m, "->>>,>>>,>>9.9999":U))       ";":U
                                               TRIM(STRING(tt-movto-item.valor-ggf-total-m, "->,>>>,>>>,>>9.9999":U)) SKIP.
        END.

        IF tt-param.gerar-csv THEN
            OUTPUT STREAM str-csv CLOSE.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN DO:
        RUN pi-seta-titulo IN h-acomp (INPUT "Finalizando Relat¢rio...":U).
        RUN pi-acompanhar IN h-acomp (INPUT "Finalizando":U).
    END.

    CASE tt-param.destino:
        WHEN 1 THEN
            ASSIGN c-destino = "Impressora":U.
        WHEN 2 THEN
            ASSIGN c-destino = "Arquivo":U.
        WHEN 3 THEN
            ASSIGN c-destino = "Terminal":U.
        OTHERWISE
            ASSIGN c-destino = "":U.
    END CASE.

    ASSIGN c-arquivo = TRIM(CAPS(REPLACE(tt-param.arquivo, "/":U, "~\":U)))
           c-arq-csv = TRIM(CAPS(REPLACE(tt-param.arq-csv, "/":U, "~\":U))).

    IF NOT tt-param.gerar-csv THEN
        ASSIGN c-arq-csv = "-- NÆo h  --":U.

    PAGE STREAM str-rp.

    DISPLAY STREAM str-rp
            tt-param.cod-estabel-ini
            tt-param.cod-estabel-fin
            tt-param.cod-ccusto-ini
            tt-param.cod-ccusto-fin
            tt-param.it-codigo-ini
            tt-param.it-codigo-fin
            tt-param.periodo-ini
            tt-param.periodo-fin
            tt-param.gerar-csv
            c-arq-csv
            c-destino
            c-arquivo
            tt-param.usuario
        WITH FRAME f-param.

    RETURN "OK":U.

END PROCEDURE.

