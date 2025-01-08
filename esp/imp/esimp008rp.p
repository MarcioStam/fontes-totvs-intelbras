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
**  Programa.: esp/imp/esimp008rp.p
**  Objetivo.: Gerar Relat¢rios CSV dos embarques.
**  Cria‡Æo..: 27/05/2010
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESIMP008RP 2.00.00.000}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD arquivo-csv      AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD estab-ini        LIKE ordens-embarque.cod-estabel
    FIELD estab-fim        LIKE ordens-embarque.cod-estabel
    FIELD periodo-ini      AS DATE
    FIELD periodo-fim      AS DATE
    FIELD fornec-ini       LIKE ordem-compra.cod-emitente
    FIELD fornec-fim       LIKE ordem-compra.cod-emitente
    FIELD transp-ini       LIKE embarque-imp.cod-transportador
    FIELD transp-fim       LIKE embarque-imp.cod-transportador
    FIELD itiner-ini       LIKE historico-embarque.cod-itiner                               
    FIELD itiner-fim       LIKE historico-embarque.cod-itiner
    FIELD i-via-transp     AS INTEGER
    FIELD i-ponto          AS INTEGER
    FIELD l-cotacao        AS LOGICAL.

DEFINE TEMP-TABLE tt-importacao
    FIELD cod-itiner        LIKE historico-embarque.cod-itiner
    FIELD cod-estabel       LIKE ordens-embarque.cod-estabel
    FIELD embarque          LIKE ordens-embarque.embarque
    FIELD declaracao-import LIKE embarque-imp.declaracao-import
    FIELD cod-emitente      LIKE ordem-compra.cod-emitente
    FIELD nome-emit-for     LIKE emitente.nome-emit
    FIELD cod-transportador LIKE embarque-imp.cod-transportador
    FIELD nome-emit-transp  LIKE emitente.nome-emit
    FIELD cod-conhecto-master   LIKE embarque-imp.cod-conhecto-master
    FIELD c-via-transp      AS CHARACTER
    FIELD id-meio-transp    LIKE embarque-imp.id-meio-transp
    FIELD pto-embarque      AS DATE
    FIELD pto-chegada       AS DATE
    FIELD pto-eadi          AS DATE
    FIELD pto-reg-di        AS DATE
    FIELD pto-lib           AS DATE
    FIELD pto-eadi-saida    AS DATE
    FIELD pto-entrada       AS DATE
    FIELD pto-emis-nf       AS DATE
    FIELD de-cotacao-emb    AS DECIMAL
    FIELD de-cotacao-nf     AS DECIMAL
    FIELD de-valor-emb      AS DECIMAL
    INDEX chave cod-itiner  
                cod-estabel 
                embarque.

{utp/ut-glob.i}
{include/i-rpvar.i}

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF VAR h-acomp      AS HANDLE        NO-UNDO.
DEF VAR c-via-transp AS CHAR          NO-UNDO.
DEF VAR c-ponto      AS CHAR EXTENT 2 INITIAL ["Embarque","Nacionaliza‡Æo"] NO-UNDO.

DEFINE VARIABLE i-moeda AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-historico-embarque FOR historico-embarque.
DEFINE BUFFER bf-emitente FOR emitente.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST empresa NO-LOCK
     WHERE empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESIMP008":U
       c-versao       = "2.04":U
       c-revisao      = "000":U.

IF OPSYS = "UNIX":U THEN
    ASSIGN tt-param.arquivo-csv = c-seg-usuario + "/":U + REPLACE(tt-param.arquivo, ENTRY(NUM-ENTRIES(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).

FORM SKIP(1)
     "SELE€ÇO":U  AT 13 SKIP(1)
     tt-param.estab-ini   FORMAT "x(3)":U        LABEL "Estabel":U       COLON 40
     " |< >| ":U  AT 54
     tt-param.estab-fim   FORMAT "x(3)":U        NO-LABEL SKIP
     tt-param.periodo-ini FORMAT "99/99/9999":U  LABEL "Periodo":U       COLON 40
     " |< >| ":U  AT 54
     tt-param.periodo-fim FORMAT "99/99/9999":U  NO-LABEL SKIP
     tt-param.fornec-ini  FORMAT ">>>>>>>>9":U   LABEL "Fornecedor":U    COLON 40
     " |< >| ":U  AT 54
     tt-param.fornec-fim  FORMAT ">>>>>>>>9":U   NO-LABEL SKIP
     tt-param.transp-ini  FORMAT ">>>,>>>,>>9":U LABEL "Transportador":U COLON 40
     " |< >| ":U  AT 54
     tt-param.transp-fim  FORMAT ">>>,>>>,>>9":U NO-LABEL SKIP
     tt-param.itiner-ini  FORMAT ">>,>>9":U      LABEL "Itinerario":U    COLON 40
     " |< >| ":U  AT 54
     tt-param.itiner-fim  FORMAT ">>,>>9":U      NO-LABEL SKIP
     c-via-transp         FORMAT "x(30)"         LABEL "Via Transporte"    COLON 40 
     c-ponto[tt-param.i-ponto] FORMAT "x(20)"    LABEL "Periodo por Ponto" COLON 40 SKIP(1)
     tt-param.l-cotacao   FORMAT "Sim/NÆo"       LABEL "Listar Cota‡Æo Embarque e EmissÆo NF" COLON 40 SKIP(1)
     SKIP(1)
     "IMPRESSÇO":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U   LABEL "Destino":U     COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U   LABEL "Usu rio":U     COLON 40 SKIP
     tt-param.arquivo-csv   FORMAT "x(80)":U   LABEL "Arquivo CSV":U COLON 40 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

DO ON STOP UNDO, LEAVE:
    RUN pi-leitura-embarques.
END.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

ASSIGN c-via-transp = {adinc/i01ad268.i 03} + ",Todos":U.

DISPLAY tt-param.estab-ini   
        tt-param.estab-fim   
        tt-param.periodo-ini 
        tt-param.periodo-fim     
        tt-param.fornec-ini  
        tt-param.fornec-fim  
        tt-param.transp-ini  
        tt-param.transp-fim  
        tt-param.itiner-ini  
        tt-param.itiner-fim  
        ENTRY(tt-param.i-via-transp,c-via-transp) @ c-via-transp
        c-ponto[tt-param.i-ponto]
        tt-param.l-cotacao  FORMAT "Sim/NÆo"
        tt-param.arquivo     
        tt-param.usuario     
        tt-param.arquivo-csv
    WITH FRAME f-impressao.

{include/i-rpclo.i}

RETURN "OK":U.

PROCEDURE pi-leitura-embarques:

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Gerando arquivo..":U).

    EMPTY TEMP-TABLE tt-importacao.

    FOR EACH  itinerario
        WHERE itinerario.cod-itiner >= tt-param.itiner-ini
          AND itinerario.cod-itiner <= tt-param.itiner-fim NO-LOCK:

        FOR EACH  historico-embarque NO-LOCK
            WHERE historico-embarque.cod-itiner    = itinerario.cod-itiner
              AND (IF tt-param.i-ponto = 1 THEN historico-embarque.cod-pto-contr = itinerario.pto-embarque ELSE
                                                historico-embarque.cod-pto-contr = itinerario.pto-desembarque)
              AND historico-embarque.dt-efetiva   >= tt-param.periodo-ini
              AND historico-embarque.dt-efetiva   <= tt-param.periodo-fim
              AND historico-embarque.cod-estabel  >= tt-param.estab-ini
              AND historico-embarque.cod-estabel  <= tt-param.estab-fim,

            FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel        = historico-embarque.cod-estabel
              AND embarque-imp.embarque           = historico-embarque.embarque
              AND embarque-imp.cod-transportador >= tt-param.transp-ini
              AND embarque-imp.cod-transportador <= tt-param.transp-fim,

            FIRST ordens-embarque 
            WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
              AND ordens-embarque.embarque    = embarque-imp.embarque,

            FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem  = ordens-embarque.numero-ordem
              AND ordem-compra.cod-emitente >= tt-param.fornec-ini
              AND ordem-compra.cod-emitente <= tt-param.fornec-fim:

            IF tt-param.i-via-transp < 9 THEN
                IF NOT(embarque-imp.cod-via-transp = tt-param.i-via-transp) THEN NEXT.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Embarque: " + embarque-imp.embarque).

            FIND FIRST tt-importacao NO-LOCK
                 WHERE tt-importacao.cod-itiner  = historico-embarque.cod-itiner
                   AND tt-importacao.cod-estabel = embarque-imp.cod-estabel  
                   AND tt-importacao.embarque    = embarque-imp.embarque NO-ERROR.
            IF NOT AVAIL tt-importacao THEN DO:
                CREATE tt-importacao.
                ASSIGN tt-importacao.cod-itiner          = historico-embarque.cod-itiner
                       tt-importacao.cod-estabel         = embarque-imp.cod-estabel  
                       tt-importacao.embarque            = embarque-imp.embarque
                       tt-importacao.declaracao-import   = embarque-imp.declaracao-import
                       tt-importacao.cod-emitente        = ordem-compra.cod-emitente
                       tt-importacao.cod-transportador   = embarque-imp.cod-transportador
                       tt-importacao.cod-conhecto-master     = embarque-imp.cod-conhecto-master
                       tt-importacao.c-via-transp        = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
                       tt-importacao.de-cotacao-emb      = 1
                       tt-importacao.de-cotacao-nf       = 1.

            END.            
        END.
    END.

    FOR EACH tt-importacao:

        ASSIGN i-moeda = 0.
        IF tt-param.l-cotacao THEN DO:
            FOR EACH ordens-embarque NO-LOCK
               WHERE ordens-embarque.embarque    = tt-importacao.embarque
                 AND ordens-embarque.cod-estabel = tt-importacao.cod-estabel,
               FIRST ordem-compra NO-LOCK
               WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:

                ASSIGN tt-importacao.de-valor-emb = tt-importacao.de-valor-emb + ordens-embarque.qt-do-forn * ordem-compra.pre-unit-for
                       i-moeda  = ordem-compra.mo-codigo.
            END.
        END.

        FIND FIRST itinerario WHERE
                   itinerario.cod-itiner = tt-importacao.cod-itiner NO-LOCK NO-ERROR.

        FOR EACH  historico-embarque
            WHERE historico-embarque.cod-estabel = tt-importacao.cod-estabel 
              AND historico-embarque.embarque    = tt-importacao.embarque NO-LOCK:   

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Embarque: " + tt-importacao.embarque).

            IF itinerario.pto-embarque = historico-embarque.cod-pto-contr THEN DO:
                ASSIGN tt-importacao.id-meio-transp = REPLACE(REPLACE(historico-embarque.id-meio-transp,CHR(10),""),CHR(13),"")
                       tt-importacao.pto-embarque   = historico-embarque.dt-efetiva.

                IF tt-param.l-cotacao AND i-moeda > 0 THEN DO:
                    FIND FIRST cotacao NO-LOCK
                       WHERE cotacao.mo-codigo   = i-moeda
                         AND cotacao.ano-periodo = STRING(YEAR(tt-importacao.pto-embarque)) + STRING(MONTH(tt-importacao.pto-embarque), "99") NO-ERROR.
                    IF AVAILABLE (cotacao) THEN
                       ASSIGN tt-importacao.de-cotacao-emb = cotacao.cotacao[DAY(tt-importacao.pto-embarque)].
                END.
            END.


            IF itinerario.pto-eadi = historico-embarque.cod-pto-contr THEN DO:
                FIND LAST  bf-historico-embarque WHERE
                           bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel   AND
                           bf-historico-embarque.embarque    = historico-embarque.embarque      AND
                           bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner    AND
                           bf-historico-embarque.sequencia   < historico-embarque.sequencia     NO-LOCK NO-ERROR.
                IF AVAIL bf-historico-embarque THEN
                    ASSIGN tt-importacao.pto-chegada = bf-historico-embarque.dt-efetiva.

                ASSIGN tt-importacao.pto-eadi = historico-embarque.dt-efetiva.
            END.

            IF historico-embarque.cod-pto-contr = 34 THEN
                ASSIGN tt-importacao.pto-reg-di = historico-embarque.dt-efetiva.

            IF historico-embarque.cod-pto-contr = 35 THEN
                ASSIGN tt-importacao.pto-lib = historico-embarque.dt-efetiva.

            IF historico-embarque.cod-pto-contr = 33 THEN
                ASSIGN tt-importacao.pto-eadi-saida = historico-embarque.dt-efetiva.

            IF historico-embarque.cod-pto-contr = 36 THEN
                ASSIGN tt-importacao.pto-entrada = historico-embarque.dt-efetiva.

            IF historico-embarque.cod-pto-contr = 44 THEN DO:
                ASSIGN tt-importacao.pto-emis-nf = historico-embarque.dt-efetiva.

                IF tt-param.l-cotacao AND i-moeda > 0 THEN DO:
                    FIND FIRST cotacao NO-LOCK
                       WHERE cotacao.mo-codigo   = i-moeda
                         AND cotacao.ano-periodo = STRING(YEAR(tt-importacao.pto-emis-nf)) + STRING(MONTH(tt-importacao.pto-emis-nf), "99") NO-ERROR.
                    IF AVAILABLE (cotacao) THEN
                       ASSIGN tt-importacao.de-cotacao-nf = cotacao.cotacao[DAY(tt-importacao.pto-emis-nf)].
                END.
            END.
                

            FIND FIRST bf-emitente WHERE 
                       bf-emitente.cod-emitente = tt-importacao.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL bf-emitente THEN 
                ASSIGN tt-importacao.nome-emit-for = bf-emitente.nome-emit.

            FIND FIRST transporte WHERE 
                       transporte.cod-transp = tt-importacao.cod-transportador NO-LOCK NO-ERROR.
            IF AVAIL transporte THEN
                ASSIGN tt-importacao.nome-emit-transp = transporte.nome.
        END.
    END.

    IF CAN-FIND(FIRST tt-importacao) THEN DO:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo arquivo..":U).

        OUTPUT TO VALUE(tt-param.arquivo-csv) CONVERT TARGET SESSION:CHARSET.

        IF tt-param.l-cotacao THEN
            PUT UNFORMATTED "Estabel;Embarque;DI;Fornecedor;Transportador;Conhec. Transporte;Via Transporte;Veiculo Transporte;Embarque;Chegada;EADI Entrada;Registro DI;Liberacao;EADI Saida;Entrada;Emissao NF;Cotacao Emb.;Cotacao NF;Valor Emb.":U.
        ELSE
            PUT UNFORMATTED "Estabel;Embarque;DI;Fornecedor;Transportador;Conhec. Transporte;Via Transporte;Veiculo Transporte;Embarque;Chegada;EADI Entrada;Registro DI;Liberacao;EADI Saida;Entrada;Emissao NF":U.

        PUT UNFORMATTED SKIP.

        FOR EACH tt-importacao 
            BREAK BY tt-importacao.cod-itiner 
                  BY tt-importacao.cod-estabel 
                  BY tt-importacao.embarque:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Embarque: " + tt-importacao.embarque).

            PUT UNFORMATTED                
                tt-importacao.cod-estabel       ";"
                tt-importacao.embarque          ";"
                tt-importacao.declaracao-import ";"
                tt-importacao.cod-emitente      " - " tt-importacao.nome-emit-for    ";"
                tt-importacao.cod-transportador " - " tt-importacao.nome-emit-transp ";"
                tt-importacao.cod-conhecto-master   ";"
                tt-importacao.c-via-transp      ";"
                tt-importacao.id-meio-transp    ";"
                STRING(tt-importacao.pto-embarque,"99/99/9999")      ";"
                IF tt-importacao.pto-chegada    = ? THEN "-" ELSE STRING(tt-importacao.pto-chegada,"99/99/9999")    ";"
                IF tt-importacao.pto-eadi       = ? THEN "-" ELSE STRING(tt-importacao.pto-eadi,"99/99/9999")       ";" 
                IF tt-importacao.pto-reg-di     = ? THEN "-" ELSE STRING(tt-importacao.pto-reg-di,"99/99/9999")     ";" 
                IF tt-importacao.pto-lib        = ? THEN "-" ELSE STRING(tt-importacao.pto-lib,"99/99/9999")        ";" 
                IF tt-importacao.pto-eadi-saida = ? THEN "-" ELSE STRING(tt-importacao.pto-eadi-saida,"99/99/9999") ";" 
                IF tt-importacao.pto-entrada    = ? THEN "-" ELSE STRING(tt-importacao.pto-entrada,"99/99/9999")    ";" 
                IF tt-importacao.pto-emis-nf    = ? THEN "-" ELSE STRING(tt-importacao.pto-emis-nf,"99/99/9999")    ";".

            IF tt-param.l-cotacao THEN
                PUT UNFORMATTED
                    tt-importacao.de-cotacao-emb ";"
                    tt-importacao.de-cotacao-nf  ";"
                    tt-importacao.de-valor-emb   ";".

            PUT UNFORMATTED SKIP.
        END.

        OUTPUT CLOSE.
    END.
    ELSE
        ASSIGN tt-param.arquivo-csv = "NÆo foram encontradas informa‡äes para exporta‡Æo.":U.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE OBJECT h-acomp.

END PROCEDURE.
