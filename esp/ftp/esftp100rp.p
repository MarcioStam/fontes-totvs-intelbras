/*********************************************************************************
** Programa: esp/ftp/esftp100rp.p
** Vers∆o..: 1.00
** Data....: 03/12/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Programa para c†lculo do sal†rio vari†vel
*********************************************************************************/
{include/i-prgvrs.i ESFTP100RP 2.00.00.001}  /*** 010001 ***/


/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-exec   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodo-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-colab  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-inicio     AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-data       AS DATE        NO-UNDO.
DEFINE VARIABLE de-valor      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-consumido  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-estouro    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.

DEFINE STREAM s-email.

{include/i-rpvar.i}
{utp/utapi019.i}



/*--- Definiá∆o de Temp-Tables e Buffers ---*/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD cod-estabel-ini  AS CHARACTER
    FIELD cod-estabel-fim  AS CHARACTER
    FIELD cod-rep-ini      AS INTEGER
    FIELD cod-rep-fim      AS INTEGER
    FIELD cod-colab-ini    AS CHARACTER
    FIELD cod-colab-fim    AS CHARACTER
    FIELD periodo          AS CHARACTER
    FIELD rs-tipo          AS INTEGER
    FIELD tg-email         AS LOGICAL.

DEFINE TEMP-TABLE tt-salario-var NO-UNDO
    FIELD cod-colab        LIKE colab-salario-var.cod-colab
    FIELD cod-rep          LIKE repres.cod-rep
    FIELD fm-cod-com       LIKE item.fm-cod-com
    FIELD vl-faturamento   AS DECIMAL
    FIELD vl-devolucao     AS DECIMAL
    FIELD vl-inadimp       AS DECIMAL
    FIELD vl-deb-base      AS DECIMAL
    FIELD vl-cred-base     AS DECIMAL
    INDEX idx-salario      IS PRIMARY UNIQUE cod-colab cod-rep fm-cod-com.

DEFINE TEMP-TABLE tt-tot-colab NO-UNDO
    FIELD cod-colab        LIKE colab-salario-var.cod-colab
    FIELD vl-faturamento   AS DECIMAL
    FIELD vl-devolucao     AS DECIMAL
    FIELD vl-inadimp       AS DECIMAL
    FIELD vl-cred-base     AS DECIMAL
    FIELD vl-deb-base      AS DECIMAL
    FIELD pc-variavel      AS DECIMAL
    FIELD vl-teto          AS DECIMAL
    FIELD vl-fixo          AS DECIMAL
    FIELD vl-deb-final     AS DECIMAL
    FIELD vl-cred-final    AS DECIMAL
    FIELD vl-tot-var       AS DECIMAL /* Sal†rio vari†vel total           */
    FIELD vl-max-var       AS DECIMAL /* Valor m†ximo de sal†rio vari†vel */
    INDEX idx-tot-rep      IS PRIMARY UNIQUE cod-colab.

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD nome-transp LIKE nota-fiscal.nome-transp
    FIELD cod-estabel LIKE canhoto-nf.cod-estabel
    FIELD serie       LIKE canhoto-nf.serie
    FIELD nr-nota-fis LIKE canhoto-nf.nr-nota-fis
    FIELD nm-dest     LIKE emitente.nome-emit
    FIELD dt-emissao  LIKE nota-fiscal.dt-emis-nota
    INDEX transp      nome-transp.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE BUFFER b-colab-conta-cor FOR colab-conta-cor.




/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Definiá∆o das Frames ---*/
DEFINE FRAME fColaborador
    tt-tot-colab.cod-colab        COLUMN-LABEL "Matricula"
    c-nome-colab                  COLUMN-LABEL "Nome Colaborador"   FORMAT "x(26)"
    tt-tot-colab.vl-faturamento   COLUMN-LABEL "Valor Faturamento"
    tt-tot-colab.vl-devolucao     COLUMN-LABEL "Valor Devoluá∆o"
    tt-tot-colab.vl-deb-base      COLUMN-LABEL "Valor DÇbito Base"
    tt-tot-colab.vl-cred-base     COLUMN-LABEL "Valor CrÇdito Base"
    tt-tot-colab.vl-tot-var       COLUMN-LABEL "Sal†rio Vari†vel Total"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fColaborador.

DEFINE FRAME fParametros
    "Seleá∆o"                 COLON 50 SKIP(1)
    tt-param.cod-estabel-ini  COLON 39 LABEL "Estabelecimento"
    "|< >|":U                 COLON 51
    tt-param.cod-estabel-fim  NO-LABEL
    tt-param.cod-rep-ini      COLON 39 LABEL "Representante"
    "|< >|":U                 COLON 51
    tt-param.cod-rep-fim      NO-LABEL
    tt-param.cod-colab-ini    COLON 39 LABEL "Matr°cula Colab"
    "|< >|":U                 COLON 51
    tt-param.cod-colab-fim    NO-LABEL
    tt-param.periodo          COLON 39 LABEL "Per°odo"
    c-tipo-exec               COLON 39 LABEL "Tipo Execuá∆o" FORMAT "x(30)"
    tt-param.tg-email         COLON 39 LABEL "Envia e-mail para Colaborador?" FORMAT "Sim/N∆o"
    SKIP(1)
    "Impress∆o"               COLON 50 SKIP(1)
    c-destino                 COLON 39 LABEL "Destino"
    " - ":U
    tt-param.arquivo          FORMAT "x(40)":U NO-LABEL SKIP
    tt-param.usuario          COLON 39 LABEL "Usu†rio" SKIP(1)
    WITH WIDTH 132 SIDE-LABELS STREAM-IO.


FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa NO-LOCK
    WHERE  empresa.ep-codigo = param-global.empresa-prin NO-ERROR.

ASSIGN c-programa     = "ESFTP100RP":U
       c-versao       = "2.00":U
       c-revisao      = ".00.001":U
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ""
       c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "C†lculo Sal†rio Vari†vel".

/* Include com a definiá∆o da frame de cabeáalho e rodapÇ */
/*{include/i-rpcab.i}*/




/*--- Inicializaá∆o das Informaá‰es ---*/
{include/i-rpout.i}

/*VIEW FRAME f-cabec.
VIEW FRAME f-rodape.*/

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.




/*--- Processamento Principal ---*/
IF  tt-param.rs-tipo = 2 /* Oficial */ THEN DO:
    /* Verificar se o c†lculo de inadimplància foi feito */

    /*PUT UNFORMATTED SKIP(1)
                    "Inadimplància n∆o calculada para o per°odo".

    RETURN "NOK":U.*/
END.

RUN pi-inicializar IN h-acomp (INPUT "C†lculando sal†rios").

ASSIGN dt-inicio = DATE(INT(SUBSTRING(tt-param.periodo,5,2)), 01, INT(SUBSTRING(tt-param.periodo,1,4)))
       dt-fim    = ADD-INTERVAL(dt-inicio, 1, "month")
       dt-fim    = dt-fim - 1.

FOR EACH  repres NO-LOCK
    WHERE repres.cod-rep >= tt-param.cod-rep-ini
    AND   repres.cod-rep <= tt-param.cod-rep-fim:

    /* Para cada representante percorre o per°odo */
    DO  dt-data = dt-inicio TO dt-fim:

        /*-- Notas Fiscais --*/
        FOR EACH  nota-fiscal NO-LOCK
            WHERE nota-fiscal.dt-emis-nota = dt-data
            AND   nota-fiscal.dt-cancela   = ?
            AND   nota-fiscal.no-ab-reppri = repres.nome-abrev:
    
            IF  NOT CAN-FIND(FIRST fat-duplic  NO-LOCK
                             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                             AND   fat-duplic.serie       = nota-fiscal.serie
                             AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura) THEN
                NEXT.
    
            RUN pi-acompanhar  IN h-acomp (INPUT "Nota de sa°da: " + STRING(nota-fiscal.nr-nota-fis)).
    
            FOR EACH  it-nota-fisc NO-LOCK
                WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                AND   it-nota-fisc.serie       = nota-fiscal.serie
                AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis,
                FIRST item NO-LOCK
                WHERE item.it-codigo           = it-nota-fisc.it-codigo:
    
                FOR EACH  colab-salario-var NO-LOCK
                    WHERE colab-salario-var.cod-rep          = repres.cod-rep
                    AND   colab-salario-var.cod-colab       >= tt-param.cod-colab-ini
                    AND   colab-salario-var.cod-colab       <= tt-param.cod-colab-fim
                    AND   colab-salario-var.fm-cod-com-ini  <= item.fm-cod-com
                    AND   colab-salario-var.fm-cod-com-fim  >= item.fm-cod-com
                    AND   colab-salario-var.dt-vigencia-ini <= nota-fiscal.dt-emis-nota
                    AND   colab-salario-var.dt-vigencia-fim >= nota-fiscal.dt-emis-nota:
    
                    FIND FIRST tt-salario-var EXCLUSIVE-LOCK
                        WHERE  tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                        AND    tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                        AND    tt-salario-var.fm-cod-com = item.fm-cod-com NO-ERROR.
                    IF  NOT AVAIL tt-salario-var THEN DO:
                        CREATE tt-salario-var.
                        ASSIGN tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                               tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                               tt-salario-var.fm-cod-com = item.fm-cod-com.
                    END.

                    ASSIGN tt-salario-var.vl-faturamento = tt-salario-var.vl-faturamento + (it-nota-fisc.vl-merc-liq * (colab-salario-var.pc-variavel / 100)).
                END.
            END.
        END.


        /*-- Documentos de Devoluá∆o --*/
        FOR EACH  docum-est NO-LOCK
            WHERE docum-est.dt-trans  = dt-data
            AND   docum-est.esp-docto = 20 /* Devoluá∆o */:

            FOR EACH  item-doc-est NO-LOCK
                WHERE item-doc-est.serie-docto  = docum-est.serie
                AND   item-doc-est.nro-docto    = docum-est.nro-docto
                AND   item-doc-est.cod-emitente = docum-est.cod-emitente
                AND   item-doc-est.nat-operacao = docum-est.nat-operacao,
                FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel   = docum-est.cod-estabel
                AND   nota-fiscal.serie         = item-doc-est.serie-comp
                AND   nota-fiscal.nr-nota-fis   = item-doc-est.nro-comp
                AND   nota-fiscal.no-ab-reppri  = repres.nome-abrev,
                FIRST item NO-LOCK
                WHERE item.it-codigo            = item-doc-est.it-codigo:

                RUN pi-acompanhar  IN h-acomp (INPUT "Nota de devoluá∆o: " + STRING(nota-fiscal.nr-nota-fis)).

                IF  NOT CAN-FIND(FIRST fat-duplic  NO-LOCK
                                 WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                                 AND   fat-duplic.serie       = nota-fiscal.serie
                                 AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura) THEN
                    NEXT.

                FOR EACH  colab-salario-var NO-LOCK
                    WHERE colab-salario-var.cod-rep          = repres.cod-rep
                    AND   colab-salario-var.cod-colab       >= tt-param.cod-colab-ini
                    AND   colab-salario-var.cod-colab       <= tt-param.cod-colab-fim
                    AND   colab-salario-var.fm-cod-com-ini  <= item.fm-cod-com
                    AND   colab-salario-var.fm-cod-com-fim  >= item.fm-cod-com
                    AND   colab-salario-var.dt-vigencia-ini <= nota-fiscal.dt-emis-nota
                    AND   colab-salario-var.dt-vigencia-fim >= nota-fiscal.dt-emis-nota:
    
                    FIND FIRST tt-salario-var EXCLUSIVE-LOCK
                        WHERE  tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                        AND    tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                        AND    tt-salario-var.fm-cod-com = item.fm-cod-com NO-ERROR.
                    IF  NOT AVAIL tt-salario-var THEN DO:
                        CREATE tt-salario-var.
                        ASSIGN tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                               tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                               tt-salario-var.fm-cod-com = item.fm-cod-com.
                    END.

                    ASSIGN tt-salario-var.vl-devolucao = tt-salario-var.vl-devolucao + (((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * (colab-salario-var.pc-variavel / 100)) * -1).
                END.
            END.
        END.


        /*-- DÇbito/CrÇdito Base --*/
        FOR EACH  colab-deb-cred-base NO-LOCK
            WHERE colab-deb-cred-base.cod-rep  = repres.cod-rep
            AND   colab-deb-cred-base.dt-movto = dt-data:

            RUN pi-acompanhar  IN h-acomp (INPUT "DÇbito/CrÇdito Base: " + STRING(colab-deb-cred-base.cod-rep)).

            FOR EACH  colab-salario-var NO-LOCK
                WHERE colab-salario-var.cod-rep          = colab-deb-cred-base.cod-rep
                AND   colab-salario-var.cod-colab       >= tt-param.cod-colab-ini
                AND   colab-salario-var.cod-colab       <= tt-param.cod-colab-fim
                AND   colab-salario-var.fm-cod-com-ini  <= colab-deb-cred-base.fm-cod-com
                AND   colab-salario-var.fm-cod-com-fim  >= colab-deb-cred-base.fm-cod-com
                AND   colab-salario-var.dt-vigencia-ini <= colab-deb-cred-base.dt-movto
                AND   colab-salario-var.dt-vigencia-fim >= colab-deb-cred-base.dt-movto:

                FIND FIRST tt-salario-var EXCLUSIVE-LOCK
                    WHERE  tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                    AND    tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                    AND    tt-salario-var.fm-cod-com = colab-deb-cred-base.fm-cod-com NO-ERROR.
                IF  NOT AVAIL tt-salario-var THEN DO:
                    CREATE tt-salario-var.
                    ASSIGN tt-salario-var.cod-colab  = colab-salario-var.cod-colab
                           tt-salario-var.cod-rep    = colab-salario-var.cod-rep
                           tt-salario-var.fm-cod-com = colab-deb-cred-base.fm-cod-com.
                END.

                ASSIGN de-valor = colab-deb-cred-base.valor * (colab-salario-var.pc-variavel / 100).

                IF  colab-deb-cred-base.deb-cred /* DÇbito */ THEN
                    ASSIGN tt-salario-var.vl-deb-base  = tt-salario-var.vl-deb-base  -  de-valor.
                ELSE
                    ASSIGN tt-salario-var.vl-cred-base = tt-salario-var.vl-cred-base +  de-valor.
            END.
        END.

    END. /*DO  dt-data = dt-inicio TO dt-fim:*/
END. /*FOR EACH  repres NO-LOCK*/



/*-- C†lculo Valor Estouro --*/
EMPTY TEMP-TABLE tt-tot-colab.
FOR EACH tt-salario-var NO-LOCK:
    FIND FIRST tt-tot-colab EXCLUSIVE-LOCK
        WHERE  tt-tot-colab.cod-colab = tt-salario-var.cod-colab NO-ERROR.
    IF  NOT AVAIL tt-tot-colab THEN DO:
        CREATE tt-tot-colab.
        ASSIGN tt-tot-colab.cod-colab = tt-salario-var.cod-colab.
    END.
    
    ASSIGN tt-tot-colab.vl-faturamento = tt-tot-colab.vl-faturamento + ROUND(tt-salario-var.vl-faturamento, 2)
           tt-tot-colab.vl-devolucao   = tt-tot-colab.vl-devolucao   + ROUND(tt-salario-var.vl-devolucao, 2)
           tt-tot-colab.vl-cred-base   = tt-tot-colab.vl-cred-base   + ROUND(tt-salario-var.vl-cred-base, 2)
           tt-tot-colab.vl-deb-base    = tt-tot-colab.vl-deb-base    + ROUND(tt-salario-var.vl-deb-base, 2)
           tt-tot-colab.vl-tot-var     = tt-tot-colab.vl-tot-var     + ROUND((tt-salario-var.vl-faturamento + tt-salario-var.vl-devolucao +
                                                                              tt-salario-var.vl-cred-base   + tt-salario-var.vl-deb-base), 2).
END.

/* Monta a string contendo o per°odo de 4 meses atr†s */
ASSIGN c-periodo-aux = STRING(YEAR(ADD-INTERVAL(dt-inicio,-4,"month")), "9999") + STRING(MONTH(ADD-INTERVAL(dt-inicio,-4,"month")), "99").

FOR EACH tt-tot-colab EXCLUSIVE-LOCK:
    FIND FIRST colab-salario-var NO-LOCK
        WHERE  colab-salario-var.cod-colab        = tt-tot-colab.cod-colab
        AND    colab-salario-var.dt-vigencia-ini <= dt-inicio
        AND    colab-salario-var.dt-vigencia-fim >= dt-inicio NO-ERROR.
    IF  NOT AVAIL colab-salario-var THEN
        NEXT.

    RUN pi-acompanhar  IN h-acomp (INPUT "C†lculando Conta Corrente: " + tt-tot-colab.cod-colab).

    ASSIGN tt-tot-colab.pc-variavel = colab-salario-var.pc-variavel
           tt-tot-colab.vl-teto     = colab-salario-var.vl-teto
           tt-tot-colab.vl-fixo     = colab-salario-var.vl-fixo.

    /*-- C†lculo da Conta Corrente --*/
    IF  (tt-tot-colab.vl-tot-var + colab-salario-var.vl-fixo) > colab-salario-var.vl-teto THEN DO:
        FIND LAST colab-conta-cor NO-LOCK
            WHERE colab-conta-cor.cod-colab = colab-salario-var.cod-colab
            AND   colab-conta-cor.periodo   = STRING(YEAR(dt-inicio)) + STRING(MONTH(dt-inicio), "99") NO-ERROR.
        ASSIGN i-seq = IF AVAIL colab-conta-cor THEN colab-conta-cor.seq + 1 ELSE 1.

        CREATE colab-conta-cor.
        ASSIGN colab-conta-cor.cod-colab  = colab-salario-var.cod-colab
               colab-conta-cor.periodo    = STRING(YEAR(dt-inicio)) + STRING(MONTH(dt-inicio), "99")
               colab-conta-cor.seq        = i-seq
               colab-conta-cor.vl-estouro = (tt-tot-colab.vl-tot-var + colab-salario-var.vl-fixo) - colab-salario-var.vl-teto
               tt-tot-colab.vl-max-var    = colab-salario-var.vl-teto - colab-salario-var.vl-fixo.
    END.
    ELSE DO:
        IF  tt-param.rs-tipo = 2 /* Oficial */ THEN DO:
            /* Atualiza os per°odos anteriores a 4 meses para Prazo Vencido (vl-consumido = 999999.99) */
            FOR EACH  colab-conta-cor EXCLUSIVE-LOCK
                WHERE colab-conta-cor.cod-colab = colab-salario-var.cod-colab
                AND   colab-conta-cor.periodo   < c-periodo-aux:
                ASSIGN colab-conta-cor.periodo-consumo = STRING(YEAR(dt-inicio)) + STRING(MONTH(dt-inicio), "99")
                       colab-conta-cor.vl-consumido    = 999999.99.
            END.

            ASSIGN de-consumido = tt-tot-colab.vl-tot-var + colab-salario-var.vl-fixo.
    
            blk_conta:
            FOR EACH  b-colab-conta-cor EXCLUSIVE-LOCK
                WHERE b-colab-conta-cor.cod-colab        = colab-salario-var.cod-colab
                AND   b-colab-conta-cor.periodo         >= c-periodo-aux
                AND   b-colab-conta-cor.periodo-consumo  = ""
                AND   b-colab-conta-cor.vl-consumido     = 0:
            
                ASSIGN de-consumido = de-consumido + b-colab-conta-cor.vl-estouro
                       de-valor     = b-colab-conta-cor.vl-estouro.
            
                IF  de-consumido > colab-salario-var.vl-teto THEN DO:
                    ASSIGN de-estouro = de-consumido - colab-salario-var.vl-teto
                           de-valor   = b-colab-conta-cor.vl-estouro - de-estouro.
            
                    FIND LAST colab-conta-cor NO-LOCK
                        WHERE colab-conta-cor.cod-colab = colab-salario-var.cod-colab
                        AND   colab-conta-cor.periodo   = b-colab-conta-cor.periodo NO-ERROR.
                    ASSIGN i-seq = IF AVAIL colab-conta-cor THEN colab-conta-cor.seq + 1 ELSE 1.
            
                    CREATE colab-conta-cor.
                    ASSIGN colab-conta-cor.cod-colab       = colab-salario-var.cod-colab
                           colab-conta-cor.periodo         = b-colab-conta-cor.periodo
                           colab-conta-cor.seq             = i-seq
                           colab-conta-cor.vl-estouro      = de-estouro.
                END.
                
                ASSIGN b-colab-conta-cor.periodo-consumo = STRING(YEAR(dt-inicio)) + STRING(MONTH(dt-inicio), "99")
                       b-colab-conta-cor.vl-consumido    = de-valor.
            
                IF  de-consumido = colab-salario-var.vl-teto THEN
                    LEAVE blk_conta.
            END.
        END.
    END.

    /*-- DÇbito/CrÇdito Final --*/
    FOR EACH  colab-deb-cred-final NO-LOCK
        WHERE colab-deb-cred-final.cod-colab  = tt-tot-colab.cod-colab
        AND   colab-deb-cred-final.dt-movto  >= dt-inicio
        AND   colab-deb-cred-final.dt-movto  <= dt-fim:

        IF  colab-deb-cred-final.deb-cred /* DÇbito */ THEN
            ASSIGN tt-tot-colab.vl-deb-final = tt-tot-colab.vl-deb-final + colab-deb-cred-final.valor
                   tt-tot-colab.vl-tot-var   = tt-tot-colab.vl-tot-var   - colab-deb-cred-final.valor.
        ELSE /* CrÇdito */
            ASSIGN tt-tot-colab.vl-cred-final = tt-tot-colab.vl-cred-final + colab-deb-cred-final.valor
                   tt-tot-colab.vl-tot-var    = tt-tot-colab.vl-tot-var    + colab-deb-cred-final.valor.
    END.
END.



/*-- Impress∆o dos dados --*/
IF  CAN-FIND(FIRST tt-tot-colab) THEN
    PUT UNFORMATTED "Matr°cula;Colaborador;Valor Faturamento;Valor Devoluá∆o;Valor Inadimplància;Valor DÇbito Base; Valor CrÇdito Base;" +
                    "Sal†rio Vari†vel;Valor Teto;Valor Fixo; Valor Estouro Màs Anterior;Valor DÇbito Final;Valor CrÇdito Final;Valor Sal†rio Vari†vel;" SKIP.

FOR EACH tt-tot-colab NO-LOCK:
    RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo dados: " + tt-tot-colab.cod-colab).

    FIND FIRST usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = tt-tot-colab.cod-colab NO-ERROR.
    ASSIGN c-nome-colab = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

    PUT UNFORMATTED tt-tot-colab.cod-colab      ";"
                    c-nome-colab                ";"
                    tt-tot-colab.vl-faturamento ";"
                    tt-tot-colab.vl-devolucao   ";"
                    tt-tot-colab.vl-inadimp     ";"
                    tt-tot-colab.vl-deb-base    ";"
                    tt-tot-colab.vl-cred-base   ";"
                    tt-tot-colab.pc-variavel    ";"
                    tt-tot-colab.vl-teto        ";"
                    tt-tot-colab.vl-fixo        ";"
                    "0;" /*valor estouro màs anterior*/
                    tt-tot-colab.vl-deb-final   ";"
                    tt-tot-colab.vl-cred-final  ";"
                    tt-tot-colab.vl-tot-var     ";" SKIP.
END.




/*--- Impress∆o da P†gina de ParÉmetros ---*/
/*IF  PAGE-NUMBER > 0 THEN
    PAGE.

ASSIGN c-tipo-exec = IF tt-param.rs-tipo = 1 THEN "PrÇvia" ELSE "Oficial"
       c-destino   = {varinc/var00002.i 04 tt-param.destino}.

DISPLAY SKIP(1)
        tt-param.cod-estabel-ini
        tt-param.cod-estabel-fim
        tt-param.cod-rep-ini
        tt-param.cod-rep-fim
        tt-param.cod-colab-ini
        tt-param.cod-colab-fim
        tt-param.periodo
        c-tipo-exec
        tt-param.tg-email
        c-destino
        tt-param.arquivo
        tt-param.usuario
    WITH FRAME fParametros.*/




/*--- Finalizaá∆o das Informaá‰es ---*/
/*{include/i-rpclo.i}*/

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.




/*--- Procedures Internas ---*/
PROCEDURE pi-envia-email:
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo  AS CHARACTER   NO-UNDO.

    RUN pi-inicializar IN h-acomp (INPUT "Enviando E-mail").

    IF  NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    
    /*FOR EACH tt-dados NO-LOCK
        BREAK BY tt-dados.nome-transp:

        RUN pi-acompanhar IN h-acomp (INPUT tt-dados.nome-transp + " - " + tt-dados.cod-estabel + "/" + tt-dados.serie + "/" + tt-dados.nr-nota-fis).

        /* Cria o arquivo que ser† anexado ao e-mail */
        IF  FIRST-OF(tt-dados.nome-transp) THEN DO:
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "canhotos.txt".
            OUTPUT STREAM s-email TO VALUE(c-arquivo).

            FIND FIRST transporte NO-LOCK
                WHERE  transporte.nome-abrev = tt-dados.nome-transp NO-ERROR.
            IF  NOT AVAIL transporte THEN
                NEXT.

            EMPTY TEMP-TABLE tt-envio2.
            EMPTY TEMP-TABLE tt-mensagem.

            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail
                   tt-envio2.porta             = param-global.porta-mail
                   tt-envio2.remetente         = "intelbras@intelbras.com.br"
                   tt-envio2.destino           = transporte.e-mail
                   tt-envio2.assunto           = "Canhotos N∆o Recebidos"
                   tt-envio2.arq-anexo         = c-arquivo
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Segue arquivo anexo contendo a listagem das Notas Fiscais que "      + 
                                              "ainda n∆o tiveram o canhoto recebido." + CHR(13) + CHR(13) + CHR(13) +
                                              "<E-mail autom†tico. N∆o responda>".
        END.


        DISPLAY STREAM s-email
                tt-dados.cod-estabel
                tt-dados.serie
                tt-dados.nr-nota-fis
                tt-dados.dt-emissao
                tt-dados.nm-dest
            WITH FRAME fNaoRecebidosEmail.
        DOWN WITH FRAME fNaoRecebidosEmail.


        /* Envia o e-mail para a transportadora */
        IF  LAST-OF(tt-dados.nome-transp) THEN DO:
            OUTPUT STREAM s-email CLOSE.

            IF  VALID-HANDLE(h-utapi019) THEN
                RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                               INPUT  TABLE tt-mensagem,
                                               OUTPUT TABLE tt-erros).
        END.
    END.*/


    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.


    IF  CAN-FIND(FIRST tt-dados) THEN DO:
        PUT UNFORMATTED SKIP(4) "-> Os e-mail foram enviados com sucesso para os colaboradores!".
    END.

    RETURN "OK":U.
END PROCEDURE.

