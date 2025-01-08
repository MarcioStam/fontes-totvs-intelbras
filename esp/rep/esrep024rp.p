{include/i-prgvrs.i esrep024 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\esrep024RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: NF de Entrada
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
compile \\tsclient\c\fontes\esp\rep\esrep024rp.p save into c:\temp\esp\rep.

************************************************************************/

/****************************  Definitions  ****************************/
{esp/rep/esrep024tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
DEF VAR c-aux AS CHAR NO-UNDO.
DEF VAR i-aux AS INTE NO-UNDO.
DEF VAR de-qtde-ent AS DEC NO-UNDO.
DEF VAR de-qtde-sai AS DEC NO-UNDO.
DEF VAR de-qtde-saldo AS DEC NO-UNDO.
DEF VAR de-val-unit-mat-m LIKE item-estab.val-unit-mat-m[1] NO-UNDO.
DEF VAR de-vlr-total AS DEC NO-UNDO.

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-nota NO-UNDO
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    FIELD dt-data   LIKE nota-fiscal.dt-emis-nota
    FIELD nro-docto LIKE docum-est.nro-docto
    FIELD nat-operacao-ent LIKE nota-fiscal.nat-operacao
    FIELD it-codigo LIKE item-doc-est.it-codigo
    FIELD qt-saida AS DEC
    FIELD qt-entrada AS DEC
    FIELD tipo AS INTE.

DEF TEMP-TABLE tt-nat-oper-saida
    FIELD nat-operacao LIKE natur-oper.nat-operacao.

DEF TEMP-TABLE tt-nat-oper-ent
    FIELD nat-operacao LIKE natur-oper.nat-operacao.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      as handle no-undo.
FIND FIRST param-global NO-LOCK NO-ERROR.

FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "NF remessa conserto"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "esrep024"
       c-versao       = "2.04"
       c-revisao      = "002".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
/*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
*/  
    IF tt-param.nat-oper-saida <> "" THEN DO:
        ASSIGN c-aux = tt-param.nat-oper-saida.
        DO i-aux = 1 TO NUM-ENTRIES(c-aux).
            FIND natur-oper WHERE
                 natur-oper.nat-operacao = ENTRY(i-aux,c-aux) NO-LOCK NO-ERROR.
            IF AVAIL natur-oper
                 AND natur-oper.tipo = 2 THEN DO:
                CREATE tt-nat-oper-saida.
                ASSIGN tt-nat-oper-saida.nat-operacao = ENTRY(i-aux,c-aux).
            END.
        END.

        ASSIGN c-aux = tt-param.nat-oper-ent.
        DO i-aux = 1 TO NUM-ENTRIES(c-aux).
            FIND natur-oper WHERE
                 natur-oper.nat-operacao = ENTRY(i-aux,c-aux) NO-LOCK NO-ERROR.
            IF AVAIL natur-oper
                 AND natur-oper.tipo = 1 THEN DO:
                CREATE tt-nat-oper-ent.
                ASSIGN tt-nat-oper-ent.nat-operacao = ENTRY(i-aux,c-aux).
            END.
        END.
    END.
    ELSE DO:
        FOR EACH natur-oper NO-LOCK:
            IF natur-oper.tipo = 1 THEN DO:
                CREATE tt-nat-oper-ent.
                ASSIGN tt-nat-oper-ent.nat-operacao = natur-oper.nat-operacao.
            END.
            ELSE IF natur-oper.tipo = 2 THEN DO:
                CREATE tt-nat-oper-saida.
                ASSIGN tt-nat-oper-saida.nat-operacao = natur-oper.nat-operacao.
            END.
        END.
    END.

    RUN piMontaRelat-1.
    RUN piImprime.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.


PROCEDURE piMontaRelat-1:
    RUN pi-inicializar IN h-acomp (INPUT "Executando...").

    FOR EACH tt-nat-oper-saida:
        for each nota-fiscal 
           WHERE nota-fiscal.cod-emitente = tt-param.cod-emitente
             AND nota-fiscal.nat-operacao = tt-nat-oper-saida.nat-operacao NO-LOCK:

            IF nota-fiscal.dt-emis-nota < tt-param.dt-corte THEN NEXT.
            IF nota-fiscal.cod-estabel <> tt-param.cod-estabel THEN NEXT.
            IF nota-fiscal.dt-confirma = ? THEN NEXT.

            RUN pi-acompanhar IN h-acomp (INPUT "Lendo NF saida " + nota-fiscal.nr-nota-fis).

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                CREATE tt-nota.
                ASSIGN tt-nota.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       tt-nota.nat-operacao = nota-fiscal.nat-operacao
                       tt-nota.dt-data      = nota-fiscal.dt-emis-nota
                       tt-nota.cod-emitente = nota-fiscal.cod-emitente
                       tt-nota.it-codigo    = it-nota-fisc.it-codigo
                       tt-nota.qt-saida     = it-nota-fisc.qt-faturada[1]
                       tt-nota.tipo         = 1.
            END.
        END.
    END.

    /*
    FOR EACH tt-nat-oper-ent:
        FOR EACH docum-est
           WHERE docum-est.cod-emitente = tt-param.cod-emitente
             AND docum-est.nat-operacao = tt-nat-oper-ent.nat-operacao NO-LOCK:

            IF docum-est.dt-trans < tt-param.dt-corte THEN NEXT.

            IF docum-est.ce-atual = NO THEN NEXT.

            IF docum-est.cod-estabel <> tt-param.cod-estabel THEN NEXT.

            RUN pi-acompanhar IN h-acomp (INPUT "Lendo NF entrada " + docum-est.nro-docto).

            FOR EACH item-doc-est OF docum-est NO-LOCK:
                CREATE tt-nota.
                ASSIGN tt-nota.nro-docto    = docum-est.nro-docto
                       tt-nota.nat-operacao-ent = docum-est.nat-operacao
                       tt-nota.dt-data      = docum-est.dt-trans
                       tt-nota.cod-emitente = docum-est.cod-emitente
                       tt-nota.it-codigo    = item-doc-est.it-codigo
                       tt-nota.qt-entrada   = item-doc-est.quantidade
                       tt-nota.tipo         = 2.
            END.
        END.
    END.
    */
    FOR EACH tt-nat-oper-ent:
       FOR EACH item-doc-est NO-LOCK
           WHERE item-doc-est.cod-emitente = tt-param.cod-emitente        
             AND item-doc-est.nat-of       = tt-nat-oper-ent.nat-operacao 
           , FIRST docum-est OF item-doc-est:

            IF docum-est.dt-trans < tt-param.dt-corte THEN NEXT.

            IF docum-est.ce-atual = NO THEN NEXT.

            IF docum-est.cod-estabel <> tt-param.cod-estabel THEN NEXT.

            RUN pi-acompanhar IN h-acomp (INPUT "Lendo NF entrada " + docum-est.nro-docto).

            CREATE tt-nota.
            ASSIGN tt-nota.nro-docto        = docum-est.nro-docto
                   tt-nota.nat-operacao-ent = item-doc-est.nat-of
                   tt-nota.dt-data          = docum-est.dt-trans
                   tt-nota.cod-emitente     = docum-est.cod-emitente
                   tt-nota.it-codigo        = item-doc-est.it-codigo
                   tt-nota.qt-entrada       = item-doc-est.quantidade
                   tt-nota.tipo             = 2.
        END.
    END.

END.

PROCEDURE piImprime:

    IF tt-param.tipo = 1 THEN DO: /* Anal¡tico */
        PUT "NF Saida        ;" AT 1
            "NOP Sai"  ";"
            "NF Entrada      ;"  
            "NOP Ent. ;"
            "Data      ;" 
            "Item            ;" 
            "Descricao                                                   ;" 
            "Qt Saida  ;" 
            "Qt Entrada"  SKIP(1).

        FOR EACH tt-nota BREAK BY dt-data:
            RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo " + string(tt-nota.dt-data)).

            FIND ITEM WHERE
                 ITEM.it-codigo = tt-nota.it-codigo NO-LOCK NO-ERROR.
            PUT tt-nota.nr-nota-fis ";"
                tt-nota.nat-operacao ";"
                tt-nota.nro-docto ";"
                tt-nota.nat-operacao-ent ";"
                tt-nota.dt-data ";"
                tt-nota.it-codigo ";"
                ITEM.desc-item ";"
                tt-nota.qt-saida ";"
                tt-nota.qt-entrada SKIP.
        END.
    END.
    ELSE DO: /* Sint‚tico */
        PUT "Emitente ;" AT 1
            "Descricao                               ;"  AT 11
            "Item            ;" AT 52
            "Desc Item                                                   ;" AT 69
            "Qt Saida;" AT 132
            "Qt Entrada;" AT 141
            "Qt Saldo;" AT 154 
            "Pr Medio;" AT 172
            "Vlr Total" AT 181 SKIP(1).

        FOR EACH tt-nota BREAK BY tt-nota.it-codigo:

            IF FIRST-OF(tt-nota.it-codigo) THEN DO:
                ASSIGN de-val-unit-mat-m = 0.

                FIND item-estab WHERE
                     item-estab.cod-estabel = tt-param.cod-estabel AND
                     item-estab.it-codigo   = tt-nota.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL item-estab THEN
                    ASSIGN de-val-unit-mat-m = item-estab.val-unit-mat-m[1].

                ASSIGN de-qtde-ent = 0
                       de-qtde-sai = 0.

                FIND ITEM WHERE
                     ITEM.it-codigo = tt-nota.it-codigo NO-LOCK NO-ERROR.
                FIND emitente WHERE
                     emitente.cod-emitente = tt-nota.cod-emitente NO-LOCK NO-ERROR.

                PUT emitente.cod-emitente ";"
                    emitente.nome-emit ";"
                    tt-nota.it-codigo ";"
                    ITEM.desc-item ";".
            END.
            RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo " + string(tt-nota.dt-data)).

            IF tt-nota.tipo = 1 THEN
                ASSIGN de-qtde-sai = de-qtde-sai + tt-nota.qt-saida.
            ELSE
                ASSIGN de-qtde-ent = de-qtde-ent + tt-nota.qt-entrada.

            IF LAST-OF(tt-nota.it-codigo) THEN DO:
                ASSIGN de-qtde-saldo = de-qtde-sai - de-qtde-ent.
                       de-vlr-total  = de-qtde-saldo * de-val-unit-mat-m.

                PUT de-qtde-sai ";"
                    de-qtde-ent ";"
                    de-qtde-saldo ";"
                    de-val-unit-mat-m ";" 
                    de-vlr-total SKIP.
            END.
        END.
    END.
END PROCEDURE.


