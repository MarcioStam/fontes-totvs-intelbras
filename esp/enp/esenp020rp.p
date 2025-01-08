/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESENP020RP 2.00.00.001}
/*------------------------------------------------------------------------
    File        : ESENP020RP.P
    Purpose     : Listagem de Opera‡äes da Estrutura do Item
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/enp/esenp020.i}
{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-op-estrutura NO-UNDO
    FIELD item-principal LIKE operacao.it-codigo
    FIELD desc-it-princ  LIKE item.desc-item
    FIELD it-codigo      LIKE operacao.it-codigo
    FIELD desc-item      LIKE item.desc-item
    FIELD op-codigo      LIKE operacao.op-codigo
    FIELD descricao      LIKE operacao.descricao
    FIELD gm-codigo      LIKE operacao.gm-codigo
    FIELD cc-codigo      LIKE gm-estab.cc-codigo
    FIELD cod-estabel    LIKE gm-estab.cod-estabel
    FIELD tempo          LIKE operacao.tempo-homem LABEL "Tempo":U COLUMN-LABEL "Tempo":U
    FIELD un-tempo       AS CHAR LABEL "Un Tempo" COLUMN-LABEL "Un Tempo"
    FIELD quantidade     LIKE estrutura.qtd-item
    FIELD tempo-tot      LIKE operacao.tempo-homem LABEL "Tempo Tot":U COLUMN-LABEL "Tempo Tot":U
    FIELD desc-linha     AS CHAR FORMAT "x(47)" COLUMN-LABEL "Narrativa"
    INDEX chPrimario IS PRIMARY
        item-principal
        it-codigo
        op-codigo.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE i-num-ped-exec-rpw      AS INTEGER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-dir-spool-servid-exec AS CHARACTER   NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino     AS CHARACTER   NO-UNDO FORMAT "x(15)":U LABEL "Destino":U.
DEFINE VARIABLE c-cc-codigo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-arquivo LIKE tt-param.arquivo NO-UNDO.
DEFINE VARIABLE c-arq-csv LIKE tt-param.arq-csv NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-csv.

/* Buffer Definitions ---                                               */

DEFINE BUFFER b-item FOR item.
DEFINE BUFFER b2-item FOR item.

/* Form Definitions ---                                                 */

FORM tt-op-estrutura.item-principal AT 05 LABEL "Item Principal":U
     " - ":U
     tt-op-estrutura.desc-it-princ  NO-LABEL SKIP(1)
    WITH WIDTH 255 SIDE-LABELS FRAME f-estrut-cab STREAM-IO.

FORM tt-op-estrutura.it-codigo AT 10
     tt-op-estrutura.desc-item
     tt-op-estrutura.op-codigo
     tt-op-estrutura.descricao
     tt-op-estrutura.gm-codigo
     tt-op-estrutura.cc-codigo
     tt-op-estrutura.cod-estabel
     tt-op-estrutura.tempo
     tt-op-estrutura.un-tempo
     tt-op-estrutura.quantidade
     tt-op-estrutura.tempo-tot
     tt-op-estrutura.desc-linha
    WITH NO-BOX WIDTH 255 DOWN FRAME f-estrut STREAM-IO.

FORM "PAR¶METROS":U              AT 05 SKIP(2)
     "SELE€ÇO":U                 AT 10 SKIP(1)
     tt-param.cod-estabel     COLON 25 LABEL "Estabelecimento":U
     "|< >|":U                   AT 44
     tt-param.cod-estabel-fin COLON 50 NO-LABEL SKIP
     tt-param.it-codigo-ini   COLON 25
     "|< >|":U                   AT 44
     tt-param.it-codigo-fin      AT 50 NO-LABEL
     tt-param.dt-corte        COLON 25 LABEL "Data Corte":U SKIP(1)
     "PAR¶METRO":U               AT 10 SKIP(1)
     tt-param.gerar-csv       COLON 25 LABEL "Gerar CSV":U
     c-arq-csv                COLON 25 LABEL "Arquivo CSV":U SKIP(1)
     "IMPRESSÇO":U               AT 10 SKIP(1)
     c-destino                COLON 25 SKIP
     c-arquivo                COLON 25 FORMAT "x(95)":U LABEL "Arquivo":U SKIP
     tt-param.usuario         COLON 25 LABEL "Usu rio":U SKIP
    WITH WIDTH 255 SIDE-LABELS FRAME f-param STREAM-IO.

FORM "PAR¶METROS":U              AT 05 SKIP(2)
     "SELE€ÇO":U                 AT 10 SKIP(1)
     tt-param.cod-estabel     COLON 25 LABEL "Estabelecimento":U
     tt-param.dt-corte        COLON 25 LABEL "Data Corte":U SKIP(1)
     "PAR¶METRO":U               AT 10 SKIP(1)
     tt-param.gerar-csv       COLON 25 LABEL "Gerar CSV":U
     c-arq-csv                COLON 25 LABEL "Arquivo CSV":U SKIP(1)
     "DIGITA€ÇO":U               AT 10 SKIP(1)
    WITH WIDTH 255 SIDE-LABELS FRAME f-param-dig-1 STREAM-IO.

FORM tt-digita.it-codigo AT 14 LABEL "Item":U
     tt-digita.desc-item AT 31 LABEL "Descri‡Æo":U
    WITH NO-BOX WIDTH 255 DOWN FRAME f-param-dig-2 STREAM-IO.

FORM "IMPRESSÇO":U               AT 10 SKIP(1)
     c-destino                COLON 25 SKIP
     c-arquivo                COLON 25 FORMAT "x(95)":U LABEL "Arquivo":U SKIP
     tt-param.usuario         COLON 25 LABEL "Usu rio":U SKIP
    WITH WIDTH 255 SIDE-LABELS FRAME f-param-dig-3 STREAM-IO.

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Listagem de Opera‡äes da Estrutura do Item":U
       c-sistema      = "Espec¡ficos Intelbras":U.

{include/i-rpc255.i &STREAM="str-rp"}
{include/i-rpout.i  &STREAM="STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec-255.
VIEW STREAM str-rp FRAME f-rodape-255.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Iniciando...":U) NO-ERROR.

RUN pi-execute IN THIS-PROCEDURE.

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

PROCEDURE pi-execute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Reunindo informa‡äes...":U).

    EMPTY TEMP-TABLE tt-op-estrutura.

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FOR EACH operacao NO-LOCK
                WHERE operacao.it-codigo = tt-digita.it-codigo AND
                      operacao.data-inicio <= tt-param.dt-corte AND
                      operacao.data-termino > tt-param.dt-corte:

                FIND FIRST b-item
                    WHERE b-item.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.

                IF AVAIL b-item THEN DO:
                   IF NOT tt-param.lista-obsoletos  THEN
                      IF b-item.cod-obsoleto <> 1 THEN
                         NEXT.
                END.

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + operacao.it-codigo + " - Oper: ":U + TRIM(STRING(operacao.op-codigo, ">>>>9":U))).

                /* Conforme chamado 122631
                FIND FIRST gm-estab
                    WHERE gm-estab.gm-codigo   = operacao.gm-codigo
                      AND gm-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.*/

                ASSIGN c-cc-codigo   = ""
                       c-cod-estabel = "".

                FOR FIRST gm-estab WHERE
                          gm-estab.gm-codigo    = operacao.gm-codigo AND
                          gm-estab.cod-estabel >= tt-param.cod-estabel      AND
                          gm-estab.cod-estabel <= tt-param.cod-estabel-fin
                          NO-LOCK.

                    ASSIGN c-cc-codigo   = gm-estab.cc-codigo
                           c-cod-estabel = gm-estab.cod-estabel.
                END.

                FIND FIRST ficha-oper NO-LOCK
                     WHERE ficha-oper.num-id-operacao = operacao.num-id-operacao 
                       AND ficha-oper.op-altern       = 0 NO-ERROR.

                CREATE tt-op-estrutura.
                ASSIGN tt-op-estrutura.item-principal = operacao.it-codigo
                       tt-op-estrutura.desc-it-princ  = IF AVAILABLE b-item THEN b-item.desc-item ELSE "":U
                       tt-op-estrutura.it-codigo      = operacao.it-codigo
                       tt-op-estrutura.desc-item      = IF AVAILABLE b-item THEN b-item.desc-item ELSE "":U
                       tt-op-estrutura.op-codigo      = operacao.op-codigo
                       tt-op-estrutura.descricao      = operacao.descricao
                       tt-op-estrutura.gm-codigo      = operacao.gm-codigo
                     /*  tt-op-estrutura.cc-codigo      = IF AVAILABLE gm-estab THEN gm-estab.cc-codigo ELSE "":U
                       tt-op-estrutura.cod-estabel    = IF AVAILABLE gm-estab THEN gm-estab.cod-estabel ELSE "":U */
                       tt-op-estrutura.cc-codigo      = c-cc-codigo
                       tt-op-estrutura.cod-estabel    = c-cod-estabel
                       tt-op-estrutura.tempo          = operacao.tempo-homem / operacao.nr-unidades
                       tt-op-estrutura.un-tempo       = {ininc/i02in261.i 4 operacao.un-med-tempo}
                       tt-op-estrutura.quantidade     = 1
                       tt-op-estrutura.tempo-tot      = tt-op-estrutura.quantidade * tt-op-estrutura.tempo
                       tt-op-estrutura.desc-linha     = IF AVAIL ficha-oper THEN ficha-oper.desc-linha ELSE "".
            END.

            RUN pi-op-estrutura IN THIS-PROCEDURE (INPUT tt-digita.it-codigo,
                                                   INPUT tt-digita.it-codigo,
                                                   INPUT 1).
        END.
    END.
    ELSE DO:
        FOR EACH ITEM NO-LOCK
            WHERE item.it-codigo >= tt-param.it-codigo-ini
              AND item.it-codigo <= tt-param.it-codigo-fin:
            FOR EACH operacao NO-LOCK
                WHERE operacao.it-codigo = item.it-codigo AND
                      operacao.data-inicio <= tt-param.dt-corte AND
                      operacao.data-termino > tt-param.dt-corte:

                FIND FIRST b-item
                    WHERE b-item.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.


                IF AVAIL b-item THEN DO:
                   IF NOT tt-param.lista-obsoletos  THEN
                      IF b-item.cod-obsoleto <> 1 THEN
                         NEXT.
                END.


                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + operacao.it-codigo + " - Oper: ":U + TRIM(STRING(operacao.op-codigo, ">>>>9":U))).

                /* Conforme chamado 122631
                FIND FIRST gm-estab
                    WHERE gm-estab.gm-codigo   = operacao.gm-codigo
                      AND gm-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.*/

                ASSIGN c-cc-codigo   = ""
                       c-cod-estabel = "".

                FOR FIRST gm-estab WHERE
                          gm-estab.gm-codigo    = operacao.gm-codigo AND
                          gm-estab.cod-estabel >= tt-param.cod-estabel      AND
                          gm-estab.cod-estabel <= tt-param.cod-estabel-fin
                          NO-LOCK.

                    ASSIGN c-cc-codigo   = gm-estab.cc-codigo
                           c-cod-estabel = gm-estab.cod-estabel.
                END.

                FIND FIRST ficha-oper NO-LOCK
                     WHERE ficha-oper.num-id-operacao = operacao.num-id-operacao 
                       AND ficha-oper.op-altern       = 0 NO-ERROR.

                CREATE tt-op-estrutura.
                ASSIGN tt-op-estrutura.item-principal = operacao.it-codigo
                       tt-op-estrutura.desc-it-princ  = IF AVAILABLE b-item THEN b-item.desc-item ELSE "":U
                       tt-op-estrutura.it-codigo      = operacao.it-codigo
                       tt-op-estrutura.desc-item      = IF AVAILABLE b-item THEN b-item.desc-item ELSE "":U
                       tt-op-estrutura.op-codigo      = operacao.op-codigo
                       tt-op-estrutura.descricao      = operacao.descricao
                       tt-op-estrutura.gm-codigo      = operacao.gm-codigo
                     /*  tt-op-estrutura.cc-codigo      = IF AVAILABLE gm-estab THEN gm-estab.cc-codigo ELSE "":U
                       tt-op-estrutura.cod-estabel    = IF AVAILABLE gm-estab THEN gm-estab.cod-estabel ELSE "":U */
                       tt-op-estrutura.cc-codigo      = c-cc-codigo
                       tt-op-estrutura.cod-estabel    = c-cod-estabel
                       tt-op-estrutura.tempo          = operacao.tempo-homem / operacao.nr-unidades
                       tt-op-estrutura.un-tempo       = {ininc/i02in261.i 4 operacao.un-med-tempo}
                       tt-op-estrutura.quantidade     = 1
                       tt-op-estrutura.tempo-tot      = tt-op-estrutura.quantidade * tt-op-estrutura.tempo
                       tt-op-estrutura.desc-linha     = IF AVAIL ficha-oper THEN ficha-oper.desc-linha ELSE "".
            END.

            RUN pi-op-estrutura IN THIS-PROCEDURE (INPUT item.it-codigo,
                                                   INPUT item.it-codigo,
                                                   INPUT 1).
        END.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Gerando relat¢rio...":U).

    IF CAN-FIND(FIRST tt-op-estrutura) THEN DO:
        IF tt-param.gerar-csv THEN DO:
            IF i-num-ped-exec-rpw <> 0 THEN
                OUTPUT STREAM str-csv TO VALUE(c-dir-spool-servid-exec + "/":U + tt-param.arq-csv) CONVERT TARGET "iso8859-1":U.
            ELSE
                OUTPUT STREAM str-csv TO VALUE(tt-param.arq-csv) CONVERT TARGET "iso8859-1":U.

            PUT STREAM str-csv UNFORMATTED "Item Principal;Descri‡Æo Item Principal;Item;Descri‡Æo Item;Opera‡Æo;Descri‡Æo Opera‡Æo;Grupo M quina;Centro Custo;Estab;Tempo;Un Tempo;Qtd;Tempo Tot;":U.

            IF tt-param.imprime-desc THEN
                PUT STREAM str-csv UNFORMATTED "Narrativa".

            PUT STREAM str-csv UNFORMATTED SKIP.

        END.

        FOR EACH tt-op-estrutura
            BREAK BY tt-op-estrutura.item-principal:

            ASSIGN tt-op-estrutura.desc-linha = REPLACE(tt-op-estrutura.desc-linha, ";":U, ",":U)
                   tt-op-estrutura.desc-linha = REPLACE(tt-op-estrutura.desc-linha, CHR(10), " ")
                   tt-op-estrutura.desc-linha = REPLACE(tt-op-estrutura.desc-linha, CHR(11), " ")
                   tt-op-estrutura.desc-linha = REPLACE(tt-op-estrutura.desc-linha, CHR(12), " ")
                   tt-op-estrutura.desc-linha = REPLACE(tt-op-estrutura.desc-linha, CHR(13), " ").

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + tt-op-estrutura.item-principal + " - Oper: ":U + TRIM(STRING(tt-op-estrutura.op-codigo, ">>>>9":U))).

            IF FIRST-OF(tt-op-estrutura.item-principal) THEN
                DISPLAY STREAM str-rp
                        tt-op-estrutura.item-principal
                        tt-op-estrutura.desc-it-princ
                    WITH FRAME f-estrut-cab.

            DISPLAY STREAM str-rp
                    tt-op-estrutura.it-codigo
                    tt-op-estrutura.desc-item
                    tt-op-estrutura.op-codigo
                    tt-op-estrutura.descricao
                    tt-op-estrutura.gm-codigo
                    tt-op-estrutura.cc-codigo
                    tt-op-estrutura.cod-estabel
                    tt-op-estrutura.tempo
                    tt-op-estrutura.un-tempo
                    tt-op-estrutura.quantidade
                    tt-op-estrutura.tempo-tot
                    tt-op-estrutura.desc-linha
                WITH FRAME f-estrut.
            DOWN WITH FRAME f-estrut.

            IF LAST-OF(tt-op-estrutura.item-principal) THEN
                PUT STREAM str-rp SKIP(2).

            IF tt-param.gerar-csv THEN DO:
                PUT STREAM str-csv UNFORMATTED TRIM(tt-op-estrutura.item-principal)                         ";":U
                                               TRIM(tt-op-estrutura.desc-it-princ)                          ";":U
                                               TRIM(tt-op-estrutura.it-codigo)                              ";":U
                                               TRIM(tt-op-estrutura.desc-item)                              ";":U
                                               TRIM(STRING(tt-op-estrutura.op-codigo, ">>>>9":U))           ";":U
                                               TRIM(tt-op-estrutura.descricao)                              ";":U
                                               TRIM(tt-op-estrutura.gm-codigo)                              ";":U
                                               TRIM(tt-op-estrutura.cc-codigo)                              ";":U
                                               TRIM(tt-op-estrutura.cod-estabel)                            ";":U
                                               TRIM(STRING(tt-op-estrutura.tempo, ">>>9.999":U))            ";":U
                                               TRIM(tt-op-estrutura.un-tempo)                               ";":U
                                               TRIM(string(tt-op-estrutura.quantidade, ">>>>>9.999999":U))  ";":U
                                               TRIM(string(tt-op-estrutura.tempo-tot, ">>>>9.999":U))       ";".   

                IF tt-param.imprime-desc THEN
                    PUT STREAM str-csv UNFORMATTED tt-op-estrutura.desc-linha.
                    
                    
                PUT STREAM str-csv SKIP.
            END.
        END.

        IF tt-param.gerar-csv THEN
            OUTPUT STREAM str-csv CLOSE.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-op-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-item-principal LIKE item.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo      LIKE item.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER p-qtd-pai        AS   DECIMAL NO-UNDO.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo     = p-it-codigo
          AND estrutura.data-inicio  <= tt-param.dt-corte
          AND estrutura.data-termino >  tt-param.dt-corte:

        FOR EACH operacao NO-LOCK
            WHERE operacao.it-codigo = estrutura.es-codigo AND
                  operacao.data-inicio  <= tt-param.dt-corte AND
                  operacao.data-termino > tt-param.dt-corte:

            FIND FIRST b-item
                WHERE b-item.it-codigo = p-item-principal NO-LOCK NO-ERROR.

            FIND FIRST b2-item
                WHERE b2-item.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.


            IF AVAIL b2-item THEN DO:
               IF NOT tt-param.lista-obsoletos  THEN
                  IF b2-item.cod-obsoleto <> 1 THEN
                     NEXT.
            END.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + p-it-codigo + " - Oper: ":U + TRIM(STRING(operacao.op-codigo, ">>>>9":U))).

            /* Conforme chamado 122631
            FIND FIRST gm-estab
                WHERE gm-estab.gm-codigo   = operacao.gm-codigo
                  AND gm-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.*/

            ASSIGN c-cc-codigo   = ""
                   c-cod-estabel = "".

            FOR FIRST gm-estab WHERE
                      gm-estab.gm-codigo    = operacao.gm-codigo AND
                      gm-estab.cod-estabel >= tt-param.cod-estabel      AND
                      gm-estab.cod-estabel <= tt-param.cod-estabel-fin
                      NO-LOCK.

                ASSIGN c-cc-codigo   = gm-estab.cc-codigo
                       c-cod-estabel = gm-estab.cod-estabel.
            END.

            CREATE tt-op-estrutura.
            ASSIGN tt-op-estrutura.item-principal = p-item-principal
                   tt-op-estrutura.desc-it-princ  = IF AVAILABLE b-item THEN b-item.desc-item ELSE "":U
                   tt-op-estrutura.it-codigo      = operacao.it-codigo
                   tt-op-estrutura.desc-item      = IF AVAILABLE b2-item THEN b2-item.desc-item ELSE "":U
                   tt-op-estrutura.op-codigo      = operacao.op-codigo
                   tt-op-estrutura.descricao      = operacao.descricao
                   tt-op-estrutura.gm-codigo      = operacao.gm-codigo
               /*    tt-op-estrutura.cc-codigo      = IF AVAILABLE gm-estab THEN gm-estab.cc-codigo ELSE "":U
                   tt-op-estrutura.cod-estabel    = IF AVAILABLE gm-estab THEN gm-estab.cod-estabel ELSE "":U */
                   tt-op-estrutura.cc-codigo      = c-cc-codigo
                   tt-op-estrutura.cod-estabel    = c-cod-estabel
                   tt-op-estrutura.tempo          = operacao.tempo-homem / operacao.nr-unidades
                   tt-op-estrutura.un-tempo       = {ininc/i02in261.i 4 operacao.un-med-tempo}
                   tt-op-estrutura.quantidade     = (estrutura.qtd-compon / estrutura.qtd-item) * p-qtd-pai
                   tt-op-estrutura.tempo-tot      = tt-op-estrutura.quantidade * tt-op-estrutura.tempo.
        END.

        RUN pi-op-estrutura IN THIS-PROCEDURE (INPUT p-item-principal,
                                               INPUT estrutura.es-codigo,
                                               INPUT (estrutura.qtd-compon / estrutura.qtd-item) * p-qtd-pai).
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

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        DISPLAY STREAM str-rp
                tt-param.cod-estabel
                tt-param.cod-estabel-fin
                tt-param.dt-corte
                tt-param.gerar-csv
                c-arq-csv
            WITH FRAME f-param-dig-1.

        FOR EACH tt-digita:
            DISPLAY STREAM str-rp
                    tt-digita.it-codigo
                    tt-digita.desc-item
                WITH FRAME f-param-dig-2.
            DOWN WITH FRAME f-param-dig-2.
        END.

        DISPLAY STREAM str-rp
                c-destino
                c-arquivo
                tt-param.usuario
            WITH FRAME f-param-dig-3.
    END.
    ELSE DO:
        DISPLAY STREAM str-rp
                tt-param.cod-estabel
                tt-param.cod-estabel-fin
                tt-param.it-codigo-ini
                tt-param.it-codigo-fin
                tt-param.dt-corte
                tt-param.gerar-csv
                c-arq-csv
                c-destino
                c-arquivo
                tt-param.usuario
            WITH FRAME f-param.
    END.

    RETURN "OK":U.

END PROCEDURE.

