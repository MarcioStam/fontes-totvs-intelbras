/***********************************************************************
**  Programa..: upc\im0100-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa 
************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-executar-im0100        AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-im0100              AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-docto-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-emitente-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0100        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-decl-imp-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-rs-tp-nacionaliz-im0100aa  AS INTEGER          NO-UNDO.

DEF VAR c-serie         LIKE dupli-apagar-cex.serie-docto.
DEF VAR c-nr-docto      LIKE dupli-apagar-cex.nro-docto.
DEF VAR c-cod-emitente  LIKE dupli-apagar-cex.cod-emitente.
DEF VAR c-cod-estab     LIKE dupli-apagar-cex.cod-estab.
DEF VAR c-natureza      LIKE dupli-apagar-cex.nat-operacao.
DEF VAR i-parcela       AS INT.
DEF VAR l-erro AS LOGICAL INITIAL NO.
DEFINE VARIABLE c-embarque AS CHARACTER   NO-UNDO.

DEF VAR de-icm          AS DEC.
DEF VAR de-ipi          AS DEC.
DEF VAR de-pis          AS DEC.
DEF VAR de-cofins       AS DEC.

DEFINE VARIABLE c-decl-imp AS CHARACTER   NO-UNDO.

/*---[ Regra para ignorar estes fornecedores e naturezas - Chamado 670(Claudia)]----------------------------*/
DEFINE TEMP-TABLE tt-excessao NO-UNDO
     FIELD cod-fornecedoras AS INTEGER
     FIELD cod-natur        AS CHARACTER.

DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.
{esp/es0018.i}

EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
RUN esp/es0018p.p (INPUT "im0100":U,
                  INPUT 1, 
                  INPUT 0,
                  INPUT "", 
                  OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    DO  i-cont = 2 TO NUM-ENTRIES(tt-prog-ponto.conteudo, ";"):
        CREATE tt-excessao.
        ASSIGN tt-excessao.cod-fornecedor = int(ENTRY(1, tt-prog-ponto.conteudo, ";"))
               tt-excessao.cod-natur      = string(entry(i-cont, tt-prog-ponto.conteudo, ";")).
    END. /* DO  i-cont = 2 ... */
END. /* FOR EACH tt-prog-ponto: */

/*---[ Regra para ignorar estes fornecedores e naturezas - Chamado 670(Claudia)]----------------------------*/


/*IF i-rs-tp-nacionaliz-im0100aa = 0 THEN DO:*/
    ASSIGN c-serie        = wh-serie-im0100:SCREEN-VALUE
           c-nr-docto     = wh-nr-docto-im0100:SCREEN-VALUE
           c-cod-emitente = INT(wh-cod-emitente-im0100:SCREEN-VALUE)
           c-cod-estab    = wh-cod-estabel-im0100:SCREEN-VALUE
           c-natureza     = wh-natureza-im0100:SCREEN-VALUE
           c-decl-imp     = wh-decl-imp-im0100:SCREEN-VALUE
           c-decl-imp     = REPLACE(REPLACE(c-decl-imp,"/",""),"-","").

    IF LENGTH(c-decl-imp) > 10 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Declaraá∆o de Importaá∆o n∆o pode execeder 10 caracteres!" + "~~" + "Declaraá∆o de Importaá∆o n∆o pode ser maior que 10 caracteres, retirando '/' e '-'.").
        RETURN "NOK".
    END.

    IF wh-embarque-im0100:SCREEN-VALUE <> "" AND c-decl-imp <> "" THEN DO:
        ASSIGN c-embarque = "".

        FOR EACH embarque-imp
           WHERE embarque-imp.declaracao-import = wh-decl-imp-im0100:SCREEN-VALUE NO-LOCK:
            IF embarque-imp.embarque <> wh-embarque-im0100:SCREEN-VALUE THEN DO:
                ASSIGN c-embarque = embarque-imp.embarque.

                IF substring(wh-embarque-im0100:SCREEN-VALUE,1,6) <> substring(embarque-imp.embarque,1,6) THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Existe outro embarque com mesmo numero de DI~~":U + 
                                             substitute("Existe outro embarque com mesmo numero de DI: Embarque &1. VERIFIQUE!", trim(c-embarque))).
                    RETURN "NOK".
                END.
            END.
        END.
    END.
/*END.*/

APPLY "choose" TO wh-bt-executar-im0100.

/*IF i-rs-tp-nacionaliz-im0100aa = 0 THEN DO:*/
    IF c-cod-estab = "105" THEN RETURN "OK".

    IF wh-embarque-im0100:SCREEN-VALUE = "" THEN DO:

        FOR EACH docum-est NO-LOCK
            WHERE docum-est.serie-docto  = c-serie
            AND   docum-est.nro-docto    = c-nr-docto
            AND   docum-est.nat-operacao = c-natureza:

            /* Verificar o valor do ICMS que n∆o est† gravando nos seguintes campos
            ** - docum-est.icm-complem 
            ** - docum-est.icm-deb-cre 
            ** - docum-est.icm-fonte 
            ** - docum-est.icm-nao-trib 
            ** - docum-est.icm-outras
            *************************************************************************/ 

            ASSIGN de-ipi = docum-est.ipi-deb-cre
                   de-icm = docum-est.icm-deb-cre.

            FOR EACH item-doc-est OF docum-est NO-LOCK:
                ASSIGN de-pis    = de-pis    + item-doc-est.valor-pis
                       de-cofins = de-cofins + item-doc-est.val-cofins. 
/*                
                ASSIGN de-pis    = de-pis    + (DEC(SUBSTRING(item-doc-est.char-2,23,5)) * DEC(SUBSTRING(item-doc-est.char-2,30,14)) / 100)
                       de-cofins = de-cofins + (item-doc-est.val-aliq-cofins * DEC(SUBSTRING(item-doc-est.char-2,90,14)) / 100). */
            END.
        END.

        FIND FIRST dupli-apagar-cex
            WHERE dupli-apagar-cex.serie-docto       = c-serie
            AND   dupli-apagar-cex.nro-docto         = c-nr-docto
            AND   dupli-apagar-cex.cod-emitente      = c-cod-emitente
            AND   dupli-apagar-cex.nat-operacao      = c-natureza
            AND   dupli-apagar-cex.cod-emitente-desp = 5216
            AND   dupli-apagar-cex.parcela           = "1" EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL dupli-apagar-cex THEN DO:
            ASSIGN dupli-apagar-cex.dt-trans      = TODAY
                   dupli-apagar-cex.dt-vencim     = TODAY
                   dupli-apagar-cex.vl-a-pagar    = dupli-apagar-cex.vl-a-pagar    + de-ipi + de-pis + de-cofins
                   dupli-apagar-cex.vl-a-pagar-mo = dupli-apagar-cex.vl-a-pagar-mo + de-ipi + de-pis + de-cofins.
        END.
        ELSE DO:

            /* Se ele n∆o encontrar o registro nas excess‰es, segue normalmente e cria a duplicata */
            IF  NOT CAN-FIND(FIRST tt-excessao
                             WHERE tt-excessao.cod-fornecedor = 5216
                             AND   tt-excessao.cod-natur      = c-natureza) THEN DO:
                CREATE dupli-apagar-cex.
                ASSIGN dupli-apagar-cex.cod-emitente       = c-cod-emitente
                       dupli-apagar-cex.cod-emitente-desp  = 5216
                       dupli-apagar-cex.cod-esp            = "DI"
                       dupli-apagar-cex.dt-emissao         = TODAY
                       dupli-apagar-cex.dt-trans           = TODAY
                       dupli-apagar-cex.dt-vencim          = TODAY
                       dupli-apagar-cex.esp-movto          = 1
                       dupli-apagar-cex.estado-cq          = 1
                       dupli-apagar-cex.nat-operacao       = c-natureza
                       dupli-apagar-cex.nr-duplic          = c-nr-docto
                       dupli-apagar-cex.nro-docto          = c-nr-docto
                       dupli-apagar-cex.parcela            = "1"
                       dupli-apagar-cex.serie-docto        = c-serie
                       dupli-apagar-cex.tp-despesa         = 2
                       dupli-apagar-cex.vl-a-pagar         = de-ipi + de-pis + de-cofins
                       dupli-apagar-cex.vl-a-pagar-mo      = de-ipi + de-pis + de-cofins.
            END. /* IF  NOT CAN-FIND(FIRST tt-excessao */
        END. /* ELSE DO: */

        IF de-icm > 0 THEN DO:
            FIND LAST dupli-apagar-cex
                WHERE dupli-apagar-cex.serie-docto       = c-serie
                AND   dupli-apagar-cex.nro-docto         = c-nr-docto
                AND   dupli-apagar-cex.cod-emitente      = c-cod-emitente
                AND   dupli-apagar-cex.nat-operacao      = c-natureza
                AND   dupli-apagar-cex.cod-emitente-desp = 235170 EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL dupli-apagar-cex THEN
                ASSIGN i-parcela = INT(dupli-apagar-cex.parcela) + 1.
            ELSE
                ASSIGN i-parcela = 1.

            /* Se ele n∆o encontrar o registro nas excess‰es, segue normalmente e cria a duplicata */
            IF  NOT CAN-FIND(FIRST tt-excessao
                             WHERE tt-excessao.cod-fornecedor = 235170
                             AND   tt-excessao.cod-natur      = c-natureza) THEN DO:
                CREATE dupli-apagar-cex.
                ASSIGN dupli-apagar-cex.cod-emitente       = c-cod-emitente
                       dupli-apagar-cex.cod-emitente-desp  = 235170
                       dupli-apagar-cex.cod-esp            = "DI"
                       dupli-apagar-cex.dt-emissao         = TODAY
                       dupli-apagar-cex.dt-trans           = TODAY
                       dupli-apagar-cex.dt-vencim          = TODAY
                       dupli-apagar-cex.esp-movto          = 1
                       dupli-apagar-cex.estado-cq          = 1
                       dupli-apagar-cex.nat-operacao       = c-natureza
                       dupli-apagar-cex.nr-duplic          = c-nr-docto
                       dupli-apagar-cex.nro-docto          = c-nr-docto
                       dupli-apagar-cex.parcela            = STRING(i-parcela)
                       dupli-apagar-cex.serie-docto        = c-serie
                       dupli-apagar-cex.tp-despesa         = 2
                       dupli-apagar-cex.vl-a-pagar         = de-icm
                       dupli-apagar-cex.vl-a-pagar-mo      = de-icm.
            END. /* IF  NOT CAN-FIND(FIRST tt-excessao */
        END. /* IF de-icm > 0 THEN DO: */
    END.
/*END.*/


