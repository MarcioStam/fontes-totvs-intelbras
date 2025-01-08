/***********************************************************************
**  Programa..: ESP\CPP\ESCPP032RP.P
**  Autor.....: Andre Murilo Gomes 
**  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP032 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cpp/escpp032tt.i}
{include/i-rpvar.i}
{utp/ut-glob.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

DEF VAR h-acomp         AS HANDLE                                          NO-UNDO.
DEF VAR hr-engenharia   LIKE movto-ggf.horas-report FORMAT "->>>,>>9.9999" NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Acompanhamento de Horas Reportadas"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESCPP032"
       c-versao       = "2.04"
       c-revisao      = "001".

DEF VAR c-descricao         LIKE operacao.descricao    NO-UNDO.
DEF VAR c-op                LIKE operacao.op-codigo    NO-UNDO.
DEF VAR c-observ            AS CHAR FORMAT "x(10)"            NO-UNDO.
DEF VAR da-data-aux         AS DATE                           NO-UNDO.

DEF VAR de-tot-horas-report AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEF VAR de-tot-hr-eng       AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.

def temp-table tt-rep no-undo
	field dt-trans     like movto-ggf.dt-trans 
	field cc-codigo    like movto-ggf.cc-codigo
	field it-codigo    like movto-ggf.it-codigo
	field nr-ord-prod  like movto-ggf.nr-ord-prod
	field gm-codigo    like movto-ggf.gm-codigo
	field horas-report like movto-ggf.horas-report
	field desc-item    like item.desc-item
	field qt-reportada like movto-ggf.qt-reportada
	field qt-trans     like movto-ggf.dt-trans
	field c-descricao  like c-descricao
    index sintetico dt-trans cc-codigo
	/* coloque os campos no indice analitico na ordem em que vc 
quer que saia o relat¢rio */
	index analitico cc-codigo it-codigo gm-codigo nr-ord-prod dt-trans.    

DEF TEMP-TABLE tt-movto-ggf LIKE movto-ggf
    FIELD horas-report-aux AS DECIMAL FORMAT "->>>,>>9.9999".

DEF TEMP-TABLE tt-linha-prod 
    FIELD nr-linha AS INT
    INDEX idx nr-linha.

DEF BUFFER b-operacao FOR operacao.

/****************************  Forms  **********************************/
FORM    
    tt-movto-ggf.cc-codigo                                                    LABEL "C.Custo" 
    ITEM.it-codigo                                                            LABEL "Cod Item"  FORMAT "x(10)"
    ITEM.desc-item                                                            LABEL "Descricao" FORMAT "x(33)"
    tt-movto-ggf.nr-ord-prod                                                  LABEL "Ord. Prod" 
    tt-movto-ggf.qt-reportada                                                 LABEL "Qt Reporte"
    tt-movto-ggf.dt-trans                                                     LABEL "Data"
    tt-movto-ggf.gm-codigo                                                    LABEL "Grup Maq"  
    c-op                                                                      LABEL "OP"
    c-descricao                                                               LABEL "Descri‡Æo"   FORMAT "x(15)"
    tt-movto-ggf.horas-report-aux                                             LABEL "Hr Reporte"    
    hr-engenharia                                                             LABEL "Hr Engenharia"
    c-observ                                                                  LABEL "Observa‡Æo"
    WITH WIDTH 172 FRAME f-dados NO-LABELS STREAM-IO DOWN.

FORM "-------------"      AT 125 
     "-------------"      AT 139 
     "TOTAL"              AT 1
     de-tot-horas-report  AT 125 
     de-tot-hr-eng        AT 139
     SKIP(1)
    WITH WIDTH 172 FRAME f-tot NO-LABELS STREAM-IO.

/***********************************************************************/

FIND FIRST tt-param NO-ERROR.

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    IF NOT tt-param.saida-csv THEN DO:
        {include/i-rpout.i  &pagesize="0" }
        VIEW FRAME f-cabec.
        VIEW FRAME f-rodape.  
    END.
    ELSE DO:
        OUTPUT TO VALUE(tt-param.arq-csv) CONVERT TARGET SESSION:CHARSET.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Lendo movimentos...").
    RUN pi-cria-tt.
    RUN pi-imprime.

    RUN pi-finalizar IN h-acomp.

    IF NOT tt-param.saida-csv THEN DO:
        {include/i-rpclo.i}
    END.
    ELSE
        OUTPUT CLOSE.

    RETURN "OK".
END.

PROCEDURE pi-cria-tt:

   DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.

   /*      
    FOR EACH movto-ggf /* FIELDS(cc-codigo it-codigo nr-ord-pro qt-reportada op-codigo
                                    nr-reporte gm-codigo horas-report dt-trans)*/ NO-LOCK
      WHERE movto-ggf.cod-estabel = tt-param.cod-estabel
        and movto-ggf.dt-trans   >= tt-param.data-ini
        AND movto-ggf.dt-trans   <= tt-param.data-fi 
        AND movto-ggf.cc-codigo  >= tt-param.cc-codigo-ini
        AND movto-ggf.cc-codigo  <= tt-param.cc-codigo-fim: */

    FOR EACH tt-linha-prod: DELETE tt-linha-prod. END.

    ASSIGN tt-param.linha-prod = REPLACE(tt-param.linha-prod,";",",").

    IF tt-param.linha-prod <> '' THEN DO:
       IF SUBSTRING(tt-param.linha-prod,LENGTH(tt-param.linha-prod),1) <> ',' THEN
          ASSIGN tt-param.linha-prod = tt-param.linha-prod + ','.

       DO i-aux = 1 TO NUM-ENTRIES(tt-param.linha-prod,',') - 1:
           FIND FIRST lin-prod NO-LOCK 
                WHERE lin-prod.nr-linha = INT(ENTRY(i-aux,tt-param.linha-prod,','))
           NO-ERROR.

           IF AVAIL lin-prod THEN DO:
              CREATE tt-linha-prod.
              ASSIGN tt-linha-prod.nr-linha = INT(ENTRY(i-aux,tt-param.linha-prod,',')).
           END.
       END.                                                                     
    END.

    
    FOR EACH movto-ggf USE-INDEX movtoggf-14 NO-LOCK
       WHERE movto-ggf.cc-codigo   >= tt-param.cc-codigo-ini
         AND movto-ggf.cc-codigo   <= tt-param.cc-codigo-fim
         AND movto-ggf.dt-trans    >= tt-param.data-ini
         AND movto-ggf.dt-trans    <= tt-param.data-fi:
  
        RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(movto-ggf.dt-trans)).

        IF movto-ggf.cod-estabel < tt-param.estab-ini OR
           movto-ggf.cod-estabel > tt-param.estab-fim THEN NEXT.
  
        FIND FIRST ord-prod WHERE
                   ord-prod.nr-ord-prod = movto-ggf.nr-ord-produ NO-LOCK NO-ERROR.
        IF NOT AVAIL ord-prod THEN NEXT.

        IF tt-param.linha-prod <> '' THEN DO:
           FIND FIRST tt-linha-prod
                WHERE tt-linha-prod.nr-linha = ord-prod.nr-linha 
           NO-ERROR.

           IF NOT AVAIL tt-linha-prod THEN NEXT.
        END.

        IF tt-param.tipo-oper <> 10 AND ord-prod.tipo <> tt-param.tipo-oper THEN NEXT.

        IF movto-ggf.tipo-trans = 2 THEN DO:
            ASSIGN da-data-aux = movto-ggf.dt-retorno.
            IF da-data-aux < tt-param.data-ini OR da-data-aux > tt-param.data-fi THEN
                NEXT.
        END.

        /*IF tt-param.saida-csv THEN DO:*/
            FIND FIRST tt-rep USE-INDEX sintetico
                 WHERE tt-rep.dt-trans  = movto-ggf.dt-trans
                   AND tt-rep.cc-codigo = movto-ggf.cc-codigo NO-ERROR.
            IF NOT AVAIL tt-rep THEN DO:
                CREATE tt-rep.
                ASSIGN tt-rep.dt-trans  = movto-ggf.dt-trans
                       tt-rep.cc-codigo = movto-ggf.cc-codigo.
            END.
            ASSIGN tt-rep.horas-report = tt-rep.horas-report + 
	                   (IF movto-ggf.tipo-trans = 1 THEN 
                            (movto-ggf.horas-report) 
	                    ELSE 
                            (movto-ggf.horas-report * - 1)). 
        /*END.*/

        CREATE tt-movto-ggf.
        BUFFER-COPY movto-ggf TO tt-movto-ggf.
        ASSIGN tt-movto-ggf.horas-report-aux = tt-movto-ggf.horas-report * (IF movto-ggf.tipo-trans = 1 THEN 1 ELSE - 1).
    END.

END PROCEDURE.

PROCEDURE pi-imprime:

    IF NOT tt-param.saida-csv THEN
        ASSIGN de-tot-horas-report = 0
               de-tot-hr-eng       = 0.
    ELSE    
        PUT "C.Custo;Cod Item;Descricao;Ord. Prod;Qt Reporte;Data;Grup Maq;Op;Descri‡Æo;Hr Reporte;Hr Engenharia" SKIP.

    FOR EACH tt-movto-ggf
          BY tt-movto-ggf.cc-codigo
          BY tt-movto-ggf.dt-trans
          BY tt-movto-ggf.it-codigo
          BY tt-movto-ggf.nr-ord-prod
          BY tt-movto-ggf.nr-reporte:

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Centro Custo: " + tt-movto-ggf.cc-codigo).

        FIND FIRST ITEM WHERE 
                   ITEM.it-codigo = tt-movto-ggf.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            IF NOT tt-param.saida-csv THEN
                DISP tt-movto-ggf.cc-codigo
                     ITEM.it-codigo  FORMAT "x(10)"
                     ITEM.desc-item  FORMAT "x(33)"
                     tt-movto-ggf.nr-ord-prod
                WITH FRAME f-dados.
            ELSE
                PUT tt-movto-ggf.cc-codigo         ";"
                    ITEM.it-codigo  FORMAT "x(10)" ";"
                    ITEM.desc-item  FORMAT "x(33)" ";"
                    tt-movto-ggf.nr-ord-prod       ";".
        END.
        /* Descri‡Æo da opera‡Æo deve vir da Ordem de produ‡Æo, pois ‚ oque vale no reporte */
        FIND FIRST oper-ord WHERE oper-ord.nr-ord-produ = tt-movto-ggf.nr-ord-produ AND
                                  oper-ord.it-codigo    = tt-movto-ggf.it-codigo    AND
                                  oper-ord.cod-roteiro  = tt-movto-ggf.cod-roteiro  AND
                                  oper-ord.op-codigo    = tt-movto-ggf.op-codigo NO-LOCK NO-ERROR.
        IF AVAIL oper-ord THEN
            ASSIGN c-op        = oper-ord.op-codigo
                   c-descricao = oper-ord.descricao.
        ELSE
            ASSIGN c-op = 0
                   c-descricao = "".
        /* fim descri‡Æo */

        FIND FIRST operacao NO-LOCK 
             WHERE operacao.op-codigo = tt-movto-ggf.op-codigo
               AND operacao.it-codigo = tt-movto-ggf.it-codigo NO-ERROR.
        IF NOT AVAIL operacao THEN DO:
           /* FIND FIRST b-operacao
                 WHERE b-operacao.cod-roteiro = tt-movto-ggf.cod-roteiro
                   AND b-operacao.op-codigo   = tt-movto-ggf.op-codigo NO-LOCK NO-ERROR.
            IF AVAIL b-operacao THEN DO:
                ASSIGN hr-engenharia = ((b-operacao.tempo-homem * tt-movto-ggf.qt-reportada / b-operacao.nr-unidades) / 60) * (IF tt-movto-ggf.tipo-trans = 1 THEN 1 ELSE - 1).
                IF TRIM(c-descricao) <> trim(b-operacao.descricao) THEN
                    ASSIGN c-observ = "Aten‡Æo".
                ELSE
                    ASSIGN c-observ = "".
            END.
            ELSE */
                ASSIGN hr-engenharia = 0
                       c-observ = "".
        END.
        ELSE DO:
            ASSIGN hr-engenharia = ((operacao.tempo-homem * tt-movto-ggf.qt-reportada / operacao.nr-unidades) / 60) * (IF tt-movto-ggf.tipo-trans = 1 THEN 1 ELSE - 1).
            IF TRIM(c-descricao) <> trim(operacao.descricao) THEN
                ASSIGN c-observ = "Oper.Diferente".
            ELSE
                ASSIGN c-observ = "".

        END.

        IF NOT tt-param.saida-csv THEN
            ASSIGN de-tot-horas-report = de-tot-horas-report + tt-movto-ggf.horas-report-aux
                   de-tot-hr-eng       = de-tot-hr-eng       + hr-engenharia.

        IF NOT tt-param.saida-csv THEN DO:
            DISP tt-movto-ggf.qt-reportada 
                 tt-movto-ggf.dt-trans
                 tt-movto-ggf.gm-codigo  
                 c-op
                 c-descricao FORMAT "x(15)" 
                 tt-movto-ggf.horas-report-aux
                 hr-engenharia
                 c-observ
                WITH FRAME f-dados.
            DOWN WITH FRAME f-dados.
        END.
        ELSE DO:
            PUT tt-movto-ggf.qt-reportada     ";"
                tt-movto-ggf.dt-trans         ";"
                tt-movto-ggf.gm-codigo        ";"
                c-op                          ";"
                c-descricao                   ";" 
                tt-movto-ggf.horas-report-aux ";"
                hr-engenharia                 ";"
                c-observ                      ";"
                SKIP.
        END.
    END.

    IF NOT tt-param.saida-csv AND CAN-FIND(FIRST tt-movto-ggf) THEN
        DISP de-tot-horas-report
             de-tot-hr-eng WITH FRAME f-tot.

    IF tt-param.saida-csv THEN DO:
        PUT SKIP(2)
            "C.Custo;Data;Total Hr Reporte"
            SKIP.

        FOR EACH tt-rep USE-INDEX sintetico
              BY tt-rep.cc-codigo 
              BY tt-rep.dt-trans:

            PUT tt-rep.cc-codigo ";"
                tt-rep.dt-trans ";"
                tt-rep.horas-report SKIP.
        END.    
    END.

END PROCEDURE.
