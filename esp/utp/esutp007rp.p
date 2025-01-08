/***********************************************************************
**  Programa..: ESP\REP\ESUTP007RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Comunica‡äes Integrado Contabilidade
**  VersÆo....: 001 01/07/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESUTP007 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/utp/esutp007tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-faturas NO-UNDO LIKE fatura-equipamentos
    FIELD tipo        AS INTEGER
    FIELD descricao   AS CHARACTER
    FIELD responsavel AS CHARACTER
    FIELD c-fornecedor AS CHARACTER
    INDEX primario mes-ref fornecedor tipo equipamento.

DEFINE TEMP-TABLE tt-geral NO-UNDO
    FIELD ct-codigo AS CHARACTER
    FIELD cc-codigo AS CHARACTER
    FIELD mes-ref   AS CHARACTER
    FIELD valor     AS DECIMAL.

DEFINE TEMP-TABLE tt-rateios NO-UNDO LIKE rateio-equipamentos.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE BUFFER b-tt-rateios FOR tt-rateios.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEFINE VARIABLE c-responsavel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-tipo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodos    AS CHARACTER   NO-UNDO.

DEF VAR h-acomp      as handle no-undo.
def var c-separador  as char format "x(01)".
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Comunica‡äes"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESUTP007"
       c-versao       = "2.04"
       c-revisao      = "001".

if tt-param.excel = yes then
   assign c-separador = ";".
else
   assign c-separador = " ".

FOR EACH tt-faturas:
    DELETE tt-faturas.
END.

FOR EACH tt-rateios:
    DELETE tt-rateios.
END.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}

    IF tt-param.excel THEN DO:
        {include/i-rpout.i &pagesize="0"}
    END.
    ELSE DO:
        {include/i-rpout.i}
    END.

    IF tt-param.periodo-ini > tt-param.periodo-fim THEN DO:
        PUT UNFORMATTED "Periodo inicial maior que final" SKIP.
    END.
    ELSE DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        if tt-param.excel = no then do:
            VIEW FRAME f-cabec.
            VIEW FRAME f-rodape.
        end.

        RUN pi-carrega-dados.
        IF NOT tt-param.excel THEN
            RUN pi-gera-relat.
        ELSE 
            RUN pi-gera-excel.
    END.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    DEFINE VARIABLE i-tipo AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-equip  AS CHARACTER   NO-UNDO.

    IF tt-param.i-exec = 1 THEN DO:
        FOR EACH fatura-equipamentos NO-LOCK
           WHERE fatura-equipamentos.cod-estabel >= tt-param.cod-estabel-ini
             AND fatura-equipamentos.cod-estabel <= tt-param.cod-estabel-fim
             AND fatura-equipamentos.mes-ref     >= tt-param.periodo-ini
             AND fatura-equipamentos.mes-ref     <= tt-param.periodo-fim
             AND fatura-equipamentos.fornecedor  >= tt-param.fornecedor-ini
             AND fatura-equipamentos.fornecedor  <= tt-param.fornecedor-fim
             AND fatura-equipamentos.equipamento >= tt-param.equipamento-ini
             AND fatura-equipamentos.equipamento <= tt-param.equipamento-fim
              BY fatura-equipamentos.equipamento:

            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento  = fatura-equipamentos.equipamento NO-ERROR.
            IF NOT AVAIL equipamentos THEN DO:
                ASSIGN i-tipo = 5 
                       c-desc-equip  = ""
                       c-responsavel = "".
            END.
            ELSE DO:
                IF equipamentos.tipo < tt-param.tipo-ini OR equipamentos.tipo > tt-param.tipo-fim THEN NEXT.

                ASSIGN i-tipo        = equipamentos.tipo
                       c-desc-equip = equipamentos.descricao.

                ASSIGN c-responsavel = "".
                FOR FIRST cc-equipamentos OF equipamentos NO-LOCK,
                    FIRST int-centro-custo NO-LOCK
                    WHERE int-centro-custo.cc-codigo = cc-equipamentos.cc-codigo
                      AND int-centro-custo.cod-unid-negoc = cc-equipamentos.cod-unid-negoc,
                    FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario:

                    ASSIGN c-responsavel = usuar_mestre.nom_usuario.
                END.

                FIND FIRST fornec-equipamentos NO-LOCK
                     WHERE fornec-equipamentos.fornecedor = fatura-equipamentos.fornecedor NO-ERROR.
            END.

            FIND FIRST tt-faturas NO-LOCK
                 WHERE tt-faturas.mes-ref     = fatura-equipamentos.mes-ref 
                   AND tt-faturas.fornecedor  = fatura-equipamentos.fornecedor
                   AND tt-faturas.tipo        = i-tipo
                   AND tt-faturas.equipamento = fatura-equipamentos.equipamento NO-ERROR.
            IF NOT AVAIL tt-faturas THEN DO:

                CREATE tt-faturas.
                BUFFER-COPY fatura-equipamentos TO tt-faturas.
                ASSIGN tt-faturas.tipo        = i-tipo
                       tt-faturas.descricao   = c-desc-equip
                       tt-faturas.responsavel = c-responsavel
                       tt-faturas.c-fornecedor = STRING(fatura-equipamentos.fornecedor) + (IF AVAIL fornec-equipamentos THEN "-" + fornec-equipamentos.nome ELSE "")
                       tt-faturas.val-fatura   = fatura-equipamentos.val-fatura. 
            END.
            ELSE ASSIGN tt-faturas.val-fatura = tt-faturas.val-fatura + fatura-equipamentos.val-fatura.
        END.
    END.
    ELSE DO:
        FOR EACH rateio-equipamentos NO-LOCK
           WHERE rateio-equipamentos.tipo         = 0 /*telecomunicacao*/
             AND rateio-equipamentos.cod-estabel >= tt-param.cod-estabel-ini
             AND rateio-equipamentos.cod-estabel <= tt-param.cod-estabel-fim
             AND rateio-equipamentos.mes-ref     >= tt-param.periodo-ini
             AND rateio-equipamentos.mes-ref     <= tt-param.periodo-fim
             AND rateio-equipamentos.ct-codigo   >= tt-param.conta-ini
             AND rateio-equipamentos.ct-codigo   <= tt-param.conta-fim
             AND rateio-equipamentos.cc-codigo   >= tt-param.cc-ini
             AND rateio-equipamentos.cc-codigo   <= tt-param.cc-fim
             AND rateio-equipamentos.equipamento >= tt-param.equipamento-ini
             AND rateio-equipamentos.equipamento <= tt-param.equipamento-fim: 
    
            IF tt-param.sintetico THEN DO:
                FIND FIRST tt-rateios NO-LOCK
                     WHERE tt-rateios.ct-codigo  = rateio-equipamentos.ct-codigo
                       AND tt-rateios.cc-codigo  = rateio-equipamentos.cc-codigo
                       AND tt-rateios.mes-ref    = rateio-equipamentos.mes-ref NO-ERROR.
                IF NOT AVAIL tt-rateios THEN DO:
                    CREATE tt-rateios.
                    ASSIGN tt-rateios.ct-codigo  = rateio-equipamentos.ct-codigo
                           tt-rateios.cc-codigo  = rateio-equipamentos.cc-codigo
                           tt-rateios.mes-ref    = rateio-equipamentos.mes-ref.
                END.
                ASSIGN tt-rateios.val-rateio = tt-rateios.val-rateio + rateio-equipamentos.val-rateio.
            END.
            ELSE DO:
                CREATE tt-rateios.
                BUFFER-COPY rateio-equipamentos TO tt-rateios.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-gera-relat:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    IF tt-param.i-exec = 1 THEN DO:
        PUT "Periodo Fornecedor        Tipo            Equipamento                               Responsavel                          Valor" SKIP
            "------- ----------------- --------------- ---------------------------------------- -------------------------- ---------------" SKIP.

        FOR EACH tt-faturas NO-LOCK
            BREAK BY tt-faturas.mes-ref
                  BY tt-faturas.fornecedor
                  BY tt-faturas.tipo
                  BY tt-faturas.equipamento:

            ASSIGN c-desc-tipo = "".
            FIND FIRST tipo-equipamentos NO-LOCK
                 WHERE tipo-equipamentos.codigo = tt-faturas.tipo NO-ERROR.
            IF AVAIL tipo-equipamentos THEN
                ASSIGN c-desc-tipo = STRING(tipo-equipamentos.codigo) + "-" + tipo-equipamentos.descricao.

            PUT UNFORMATTED 
                tt-faturas.mes-ref                                                                AT 01
                tt-faturas.c-fornecedor                                      FORMAT "x(17)"       AT 09
                c-desc-tipo                                                  FORMAT "x(15)"       AT 27
                STRING(tt-faturas.equipamento) + "-" + tt-faturas.descricao  FORMAT "x(40)"       AT 43
                tt-faturas.responsavel                                       FORMAT "x(27)"       AT 84 
                tt-faturas.val-fatura                                                             TO 125 SKIP.
        END.
    END.
    ELSE DO:
        IF tt-param.sintetico THEN DO:
            PUT "Periodo C. Custo           Valor" SKIP
                "------- -------- ---------------" SKIP.

            FOR EACH tt-rateios NO-LOCK
                BREAK BY tt-rateios.mes-ref
                      BY tt-rateios.cc-codigo:
                ACCUMULATE tt-rateios.val-rateio (TOTAL BY tt-rateios.mes-ref)
                           tt-rateios.val-rateio (TOTAL BY tt-rateios.cc-codigo).

                IF FIRST-OF(tt-rateios.mes-ref) OR
                   FIRST-OF(tt-rateios.cc-codigo) THEN
                    PUT tt-rateios.mes-ref      AT 01
                        tt-rateios.cc-codigo    AT 09.

                IF LAST-OF(tt-rateios.cc-codigo) THEN
                    PUT UNFORMATTED 
                        STRING(ACCUM TOTAL BY tt-rateios.cc-codigo tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 33 SKIP.
            END.
        END.
        ELSE DO:
            PUT "Periodo Conta    C. Custo Equipamento          Est           Valor" SKIP
                "------- -------- -------- -------------------- --- ---------------" SKIP.

            FOR EACH tt-rateios NO-LOCK
                BREAK BY tt-rateios.mes-ref
                      BY tt-rateios.ct-codigo
                      BY tt-rateios.cc-codigo
                      BY tt-rateios.equipamento
                      BY tt-rateios.cod-estabel:
                ACCUMULATE tt-rateios.val-rateio (TOTAL BY tt-rateios.mes-ref)
                           /*tt-rateios.val-rateio (TOTAL BY tt-rateios.cod-estabel)*/
                           tt-rateios.val-rateio (TOTAL BY tt-rateios.ct-codigo)
                           tt-rateios.val-rateio (TOTAL BY tt-rateios.cc-codigo).

                IF FIRST-OF(tt-rateios.mes-ref) OR
                   FIRST-OF(tt-rateios.ct-codigo) OR
                   FIRST-OF(tt-rateios.cc-codigo) THEN
                    PUT tt-rateios.mes-ref      AT 01
                        tt-rateios.ct-codigo    AT 09
                        tt-rateios.cc-codigo    AT 18.

                PUT tt-rateios.equipamento  AT 27
                    tt-rateios.cod-estab    AT 48
                    tt-rateios.val-rateio   TO 66 SKIP.

                IF LAST-OF(tt-rateios.cc-codigo) THEN
                    PUT UNFORMATTED 
                        "Total Centro Custo" AT 27
                        STRING(ACCUM TOTAL BY tt-rateios.cc-codigo tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 66 SKIP.
                IF LAST-OF(tt-rateios.ct-codigo) THEN
                    PUT UNFORMATTED 
                        "Total Conta" AT 27
                        STRING(ACCUM TOTAL BY tt-rateios.ct-codigo tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 66 SKIP(1).
                /*IF LAST-OF(tt-rateios.cod-estabel) THEN
                    PUT UNFORMATTED 
                        "Total Estabelecimento" AT 27
                        STRING(ACCUM TOTAL BY tt-rateios.cod-estabel tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 66 SKIP.*/
                IF LAST-OF(tt-rateios.mes-ref) THEN
                    PUT UNFORMATTED 
                        "Total Periodo" AT 27
                        STRING(ACCUM TOTAL BY tt-rateios.mes-ref tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 66 SKIP(2).
            END.
        END.
    END.
                                                    
END PROCEDURE.

PROCEDURE pi-gera-excel:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Excel...").

    IF tt-param.i-exec = 1 THEN DO:
        PUT "Periodo;Fornecedor;Tipo;Equipamento;Responsavel;Valor" SKIP.

        FOR EACH tt-faturas NO-LOCK
            BREAK BY tt-faturas.mes-ref
                  BY tt-faturas.fornecedor
                  BY tt-faturas.tipo
                  BY tt-faturas.equipamento:
            ASSIGN c-desc-tipo = "".
            FIND FIRST tipo-equipamentos NO-LOCK
                 WHERE tipo-equipamentos.codigo = tt-faturas.tipo NO-ERROR.
            IF AVAIL tipo-equipamentos THEN
                ASSIGN c-desc-tipo = STRING(tipo-equipamentos.codigo) + "-" + tipo-equipamentos.descricao.

            PUT UNFORMATTED tt-faturas.mes-ref      ";"
                tt-faturas.c-fornecedor ";"
                c-desc-tipo ";"
                STRING(tt-faturas.equipamento) + "-" + tt-faturas.descricao    ";"
                tt-faturas.responsavel  ";"
                tt-faturas.val-fatura SKIP.
        END.
    END.
    ELSE DO:
        IF tt-param.sintetico THEN DO:

            IF tt-param.periodo-ini > tt-param.periodo-fim  THEN
                NEXT.

            IF INT(SUBSTRING(tt-param.periodo-fim,1,4)) - INT(SUBSTRING(tt-param.periodo-ini,1,4)) > 1 THEN DO:
                PUT UNFORMATTED 
                    "Periodo m ximo de 12 meses, favor informar periodo com diferen‡a entre 0 ou 12 meses" SKIP.
                NEXT.
            END.

            
            RUN pi-calcula-periodo.
            IF NUM-ENTRIES(c-periodos,";") <= 12 THEN DO:
                PUT UNFORMATTED "Conta;C.Custo;" c-periodos SKIP.
                FOR EACH tt-rateios NO-LOCK
                    BREAK BY tt-rateios.ct-codigo
                          BY tt-rateios.cc-codigo:
                    IF FIRST-OF(tt-rateios.ct-codigo) OR FIRST-OF(tt-rateios.cc-codigo) THEN DO:
                        PUT tt-rateios.ct-codigo ";" tt-rateios.cc-codigo       ";" .

                        DO i = 1 TO NUM-ENTRIES(c-periodos,";"):
                            FIND FIRST b-tt-rateios NO-LOCK
                                 WHERE b-tt-rateios.ct-codigo = tt-rateios.ct-codigo
                                   AND b-tt-rateios.cc-codigo = tt-rateios.cc-codigo
                                   AND b-tt-rateios.mes-ref   = ENTRY(i,c-periodos,";") NO-ERROR.
                            IF NOT AVAIL b-tt-rateios THEN
                                PUT UNFORMATTED ";".
                            ELSE
                                PUT UNFORMATTED
                                    b-tt-rateios.val-rateio ";".
                        END.
                        PUT UNFORMATTED SKIP.
                    END.
                END.
            END.
            ELSE DO:
                PUT UNFORMATTED 
                    "Periodo m ximo de 12 meses, favor informar periodo com diferen‡a entre 0 ou 12 meses" SKIP.
            END.
        END.
        ELSE DO:
            PUT "Periodo;Conta;C. Custo;Equipamento;Est;Valor" SKIP.

            FOR EACH tt-rateios NO-LOCK
                BREAK BY tt-rateios.mes-ref
                      BY tt-rateios.ct-codigo
                      BY tt-rateios.cc-codigo
                      BY tt-rateios.equipamento
                      BY tt-rateios.cod-estabel:
                PUT tt-rateios.mes-ref      ";"
                    tt-rateios.ct-codigo    ";"
                    tt-rateios.cc-codigo    ";"
                    tt-rateios.equipamento  ";"
                    tt-rateios.cod-estab    ";"
                    tt-rateios.val-rateio SKIP.
            END.
        END.
    END.

END PROCEDURE.


PROCEDURE pi-calcula-periodo:
    DEFINE VARIABLE i-ano-ini  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ano-fim  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-mes-ini  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-mes-fim  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j AS INTEGER     NO-UNDO.

    ASSIGN i-ano-ini = INT(SUBSTRING(tt-param.periodo-ini,1,4))
           i-ano-fim = INT(SUBSTRING(tt-param.periodo-fim,1,4))
           i-mes-ini = INT(SUBSTRING(tt-param.periodo-ini,5,2))
           i-mes-fim = INT(SUBSTRING(tt-param.periodo-fim,5,2)). 

    IF SUBSTRING(tt-param.periodo-ini,1,4) = SUBSTRING(tt-param.periodo-fim,1,4) THEN DO:
        DO i = i-mes-ini TO i-mes-fim:
            IF c-periodos = "" THEN
                ASSIGN c-periodos = STRING(i-ano-ini,"9999") + STRING(i,"99").
            ELSE 
                ASSIGN c-periodos = c-periodos + ";" + STRING(i-ano-ini,"9999") + STRING(i,"99").
        END.
    END.
    ELSE DO:
        DO j = i-ano-ini TO i-ano-fim:
            DO i = 1 TO 12:
                IF j <> i-ano-fim THEN DO:
                    IF i < i-mes-ini THEN NEXT.
                    IF c-periodos = "" THEN
                        ASSIGN c-periodos = STRING(j,"9999") + STRING(i,"99").
                    ELSE 
                        ASSIGN c-periodos = c-periodos + ";" + STRING(j,"9999") + STRING(i,"99").
                END.
                ELSE DO:
                    IF i > i-mes-fim THEN NEXT.
                    IF c-periodos = "" THEN
                        ASSIGN c-periodos = STRING(j,"9999") + STRING(i,"99").
                    ELSE 
                        ASSIGN c-periodos = c-periodos + ";" + STRING(j,"9999") + STRING(i,"99").
                END.
            END.
        END.
    END.

END PROCEDURE.
