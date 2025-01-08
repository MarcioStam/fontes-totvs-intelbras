/*****************************************************************************
** Programa: esp/acr/esacr040.p
** VersÆo..: 1.00
** Data....: 19/09/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa para Exporta‡Æo de dados conforme layout enviado (Layout 8.2).
*****************************************************************************/


/*--- Defini‡Æo das Vari veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE cArquivo            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-transacao      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cond-financ       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cgc-cli           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-classe        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodEmp             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048          AS HANDLE      NO-UNDO.
DEFINE VARIABLE iSequencia          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTotRegistros       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLinha              AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qtd-prestacoes    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-vendedor      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qtd-dias          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dias-vencto       AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-financ        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-log-habilitado    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE dt-inicial          AS DATE        NO-UNDO.
DEFINE VARIABLE dt-vencto-parc      AS DATE        NO-UNDO.
DEFINE VARIABLE i-segunda-parcela   AS INTEGER     NO-UNDO.
DEFINE VARIABLE dt-segunda-parc     AS CHAR FORMAT "X(8)" NO-UNDO.



/*--- Bloco Principal ---*/
/* Busca o arquivo do Layout */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-retornar-arquivo-remessa IN h-esacr048 (INPUT  "8.2",
                                               OUTPUT cArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.


ASSIGN cCodEmp        = "G7"
       i-cod-vendedor = 0
       iTotRegistros  = 0
       iLinha         = 1.


ASSIGN i-qtd-dias = 1
       dt-inicial = TODAY - 5.

/* Fun‡Æo para buscar o dia anterior. Se for final de semana, pega a data de sexta. */
DO WHILE i-qtd-dias > 0:
    ASSIGN dt-inicial = dt-inicial - 1.

    FIND FIRST dia_calend_glob
        WHERE dia_calend_glob.cod_calend = "Fiscal":U
          AND dia_calend_glob.dat_calend = dt-inicial NO-LOCK NO-ERROR.

    IF dia_calend_glob.log_dia_util THEN /* Veirifica se ‚ dia £til */
        ASSIGN i-qtd-dias = i-qtd-dias - 1.

/*     IF  WEEKDAY(dt-inicial) <> 1 /* Domingo */ AND  */
/*         WEEKDAY(dt-inicial) <> 7 /* S bado  */ THEN */
/*         ASSIGN i-qtd-dias = i-qtd-dias - 1.         */
END.


OUTPUT TO VALUE(cArquivo) CONVERT TARGET "iso8859-1".

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados":U).



/**** HEADER ****/
PUT UNFORMATTED "0"                                           + /* FIXO - Registro */
                STRING("UPLOAD", "x(10)")                     +
                REPLACE(STRING(TODAY, "99/99/9999"), "/", "") +
                REPLACE(STRING(TIME, "HH:MM:SS"), ":", "")    +
                FILL(" ", 489)                                + /* FIXO - Filler */
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.

DO TRANS:
    FOR EACH  nota-fiscal NO-LOCK
        WHERE nota-fiscal.dt-emis-nota >= dt-inicial:
                                                    
        /* Busca informa‡äes baseada na Nota */
        RUN pi-busca-informacoes.
        IF  RETURN-VALUE = "NEXT":U THEN
            NEXT.

        IF  RETURN-VALUE = "NOK":U THEN
            UNDO, LEAVE.
    
        /* Vencimento Segunda Parcela */
        FIND FIRST int-cond-pagto NO-LOCK
            WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
        ASSIGN i-segunda-parcela = 0.
        FOR EACH  fat-duplic NO-LOCK
            WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
              AND fat-duplic.serie       = nota-fiscal.serie
              AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                       
            ASSIGN i-segunda-parcela = i-segunda-parcela + 1.
            IF  i-segunda-parcela = 2 THEN DO:
                ASSIGN dt-segunda-parc = REPLACE(ISO-DATE(fat-duplic.dt-venciment), "-", "").
                LEAVE.
            END.
        END. /* FOR EACH fat-duplic no-LOCK */

        IF  i-segunda-parcela < 2 
        OR  NOT (SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S" AND SUBSTRING(int-cond-pagto.char-1,8,1) = "S") THEN
            ASSIGN dt-segunda-parc = "        ".
        /*Fim busca Segunda parcela*/

        /* Exporta a Nota */
        RUN pi-exporta-nota.
    END.


    /* Exporta as notas que sÆo de Reenvio (j  foram enviadas, mas foram negadas) */
    FOR EACH  int-pendencias-supcard EXCLUSIVE-LOCK
        WHERE int-pendencias-supcard.identific = 97 /* Reenvio de Notas */
        AND   int-pendencias-supcard.dat-envio = ?:

        /* A chave da nota ‚ gravada nos campos do t¡tulo, pois nÆo sÆo utilizados neste registro de identifica‡Æo */
        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = int-pendencias-supcard.cod-estab
            AND    nota-fiscal.serie       = int-pendencias-supcard.cod-ser-docto
            AND    nota-fiscal.nr-nota-fis = int-pendencias-supcard.cod-tit-acr NO-ERROR.
        IF  NOT AVAIL nota-fiscal THEN
            NEXT.
    
        /* Busca informa‡äes baseada na Nota */
        RUN pi-busca-informacoes.
        IF  RETURN-VALUE = "NEXT":U THEN
            NEXT.

        IF  RETURN-VALUE = "NOK":U THEN
            UNDO, LEAVE.
    
        /* Exporta a Nota */
        RUN pi-exporta-nota.
    
        ASSIGN int-pendencias-supcard.dat-envio = TODAY.
    END.
END.



/**** TRAILLER ****/
PUT UNFORMATTED "9"                             + /* FIXO - Registro */
                STRING(iTotRegistros, "999999") + /* Total de Registros - Menos Header e Trailler */
                FILL(" ", 507)                  +
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

OUTPUT CLOSE.


/*/* Copia o arquivo para a pasta de Antigos */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-mover-arquivo IN h-esacr048 (INPUT cArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.*/


IF  OPSYS = "WIN32":U THEN
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Processo de exporta‡Æo Upload de Compras (Layout 8.2) finalizado!":U).




/*--- Procedures Internas ---*/
PROCEDURE pi-busca-informacoes:

    IF  nota-fiscal.dt-cancela <> ? THEN
        RETURN "NEXT":U.

    FIND FIRST tit_acr
        WHERE tit_acr.cod_estab       = nota-fiscal.cod-estabel
          AND tit_acr.cod_espec_docto = "DM":U
          AND tit_acr.cod_ser_docto   = nota-fiscal.serie
          AND tit_acr.cod_tit_acr     = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tit_acr THEN
        RETURN "NEXT":U.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal - " + nota-fiscal.cod-estabel + " - " + nota-fiscal.nr-nota-fis).

    /* S¢ NFs com a Condi‡Æo de Pagto para a SupplierCard */
    FIND FIRST int-cond-pagto NO-LOCK
        WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
    IF  NOT AVAIL int-cond-pagto OR
        SUBSTRING(int-cond-pagto.char-1,4,1) <> "S" THEN
        RETURN "NEXT":U.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    IF  NOT AVAIL emitente OR emitente.natureza <> 2 /* Pessoa Jur¡dica */ THEN
        RETURN "NEXT":U.

    ASSIGN c-cgc-cli = emitente.cgc.

    /* Busca as Parcelas da nota fiscal */
    ASSIGN i-qtd-prestacoes = 0
           dt-vencto-parc   = ?.

    FOR EACH  fat-duplic NO-LOCK
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
        AND   fat-duplic.serie       = nota-fiscal.serie
        AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura
        BY    fat-duplic.parcela:

        /* Pega o vencimento da primeira parcela */
        IF  dt-vencto-parc = ? THEN
            ASSIGN dt-vencto-parc = fat-duplic.dt-venciment.

        ASSIGN i-qtd-prestacoes = i-qtd-prestacoes + 1.
    END.

    /* Se nÆo tiver Parcelas, vai para a pr¢xima Nota Fiscal */
    IF  i-qtd-prestacoes = 0 THEN
        RETURN "NEXT":U.

    /* Busca a £ltima informa‡Æo dos Dias de Atraso Intelbras, para o cliente */
    ASSIGN i-dias-atraso-intel = 0
           i-cod-classe        = 0
           de-val-limite       = 0
           l-log-habilitado    = NO.

    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(c-cgc-cli,1,8) NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN
        ASSIGN i-dias-atraso-intel = int-emitente-supcard.qtd-dias-atraso-int
               i-cod-classe        = int-emitente-supcard.cod-classe
               de-val-limite       = int-emitente-supcard.val-limite
               l-log-habilitado    = int-emitente-supcard.log-habilitado.

    FIND LAST int-classe-cli-supcard NO-LOCK
        WHERE  int-classe-cli-supcard.cod-classe = i-cod-classe NO-ERROR.
    ASSIGN c-des-classe = IF AVAIL int-classe-cli-supcard THEN int-classe-cli-supcard.des-classe ELSE "0000".

    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
    ASSIGN i-dias-vencto = IF AVAIL cond-pagto THEN cond-pagto.prazos[1] ELSE 0.


    /* O n£mero da transa‡Æo ‚ a jun‡Æo do Estabelecimento + S‚rie + Nr Nota Fiscal */
    ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999").

    /* Se a nota j  teve um envio, ‚ necess rio incluir uma pendˆncia de Reenvio para que ela seja enviada novamente */
    IF  CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                 WHERE int-emitente-supcard-ocor.raiz-cnpj   = SUBSTRING(c-cgc-cli,1,8)
                 AND   int-emitente-supcard-ocor.num-transac = c-nr-transacao
                 AND   int-emitente-supcard-ocor.ind-ocor    = "8.2") THEN
        RETURN "NEXT":U.

/*     MESSAGE "nota-fiscal.dt-emis-nota: " nota-fiscal.dt-emis-nota SKIP               */
/*             "i-qtd-prestacoes........: " i-qtd-prestacoes SKIP                       */
/*             "c-des-classe............: " c-des-classe SKIP                           */
/*             "i-dias-vencto...........: " i-dias-vencto SKIP                          */
/*             "cond-pagto.prazos[2]....: " cond-pagto.prazos[2] SKIP                   */
/*             "cond-pagto.prazos[2]....: " cond-pagto.prazos[1] SKIP                   */
/*             "DIAS FLEX CALCULADO.....: " cond-pagto.prazos[2] - cond-pagto.prazos[1] */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                           */
/*                                                                                      */
    FIND LAST int-param-compra-supcard NO-LOCK
         WHERE int-param-compra-supcard.dat-fatur   = nota-fiscal.dt-emis-nota
         AND   int-param-compra-supcard.plano       = i-qtd-prestacoes
         AND   int-param-compra-supcard.tp-cliente  = c-des-classe
         AND   int-param-compra-supcard.dias-pagto  = 1
         AND   int-param-compra-supcard.dias-vencto = i-dias-vencto 
         AND   (IF SUBSTRING(int-cond-pagto.char-1,8,1) = "S" THEN 
                   int-param-compra-supcard.dias-flex   = cond-pagto.prazos[2] - cond-pagto.prazos[1] 
                ELSE
                   YES) NO-ERROR.
    IF  NOT AVAIL int-param-compra-supcard THEN DO:
        IF  OPSYS = "WIN32":U THEN
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Parƒmetros de Compra - Est/Ser/NF/Emis/Prest/Class/Dias Vencto: ":U + nota-fiscal.cod-estabel + "/":U + nota-fiscal.serie + "/":U + nota-fiscal.nr-nota-fis + "/":U + STRING(nota-fiscal.dt-emis-nota, "99/99/9999":U) + "/":U + TRIM(STRING(i-qtd-prestacoes)) + "/":U + c-des-classe + "/":U + TRIM(STRING(i-dias-vencto))).
        RETURN "NEXT":U.
    END.

    ASSIGN c-cond-financ = int-param-compra-supcard.cond-financ.

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-exporta-nota:

    /**** DETALHE ****/
    ASSIGN iTotRegistros = iTotRegistros + 1.
    PUT UNFORMATTED "1"                                                                 + /* FIXO - Registro */
                    STRING(cCodEmp, "x(02)")                                            +
                    "01"                                                                + /* FIXO - Tipo de Requisi‡Æo */
                    STRING(c-cgc-cli, "x(14)")                                          +
                    FILL(" ", 65)                                                       +
                    STRING(c-nr-transacao, "99999999999999")                            +
                    REPLACE(ISO-DATE(nota-fiscal.dt-emis-nota), "-", "")                + /* Data da Compra */
                    STRING(c-cond-financ, "999999999")                                  +
                    REPLACE(STRING(nota-fiscal.vl-tot-nota, "99999999999.99"), ",", "") +
                    STRING(i-qtd-prestacoes, "99")                                      +
                    FILL(" ", 4)                                                        +
                    REPLACE(ISO-DATE(dt-vencto-parc), "-", "")                          + /* Data de Vencimento da Parcela */
                    FILL(" ", 291)                                                      +
                    dt-segunda-parc                                                     +
                    FILL(" ", 73)                                                       +
                    STRING(iLinha, "999999").
    
    PUT UNFORMATTED SKIP.
    ASSIGN iLinha = iLinha + 1.

    RUN pi-cria-registro-supcard IN THIS-PROCEDURE.


    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-cria-registro-supcard:
    DEFINE VARIABLE c-raiz-cnpj         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq               AS INTEGER     NO-UNDO.
    

    ASSIGN c-raiz-cnpj = SUBSTRING(c-cgc-cli,1,8).

    IF  NOT CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                     WHERE int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
                     AND   int-emitente-supcard.dat-avaliacao = TODAY) THEN DO:
        CREATE int-emitente-supcard.
        ASSIGN int-emitente-supcard.raiz-cnpj            = c-raiz-cnpj
               int-emitente-supcard.dat-avaliacao        = TODAY
               int-emitente-supcard.log-habilitado       = l-log-habilitado
               int-emitente-supcard.val-limite           = de-val-limite
               int-emitente-supcard.val-limite-utilizado = 0
               int-emitente-supcard.qtd-dias-atraso-sc   = 0
               int-emitente-supcard.qtd-dias-atraso-int  = i-dias-atraso-intel
               int-emitente-supcard.cod-classe           = i-cod-classe.
    END.

    FIND LAST int-emitente-supcard-ocor NO-LOCK
        WHERE int-emitente-supcard-ocor.raiz-cnpj = c-raiz-cnpj NO-ERROR.
    IF  AVAIL int-emitente-supcard-ocor THEN
        ASSIGN i-seq = int-emitente-supcard-ocor.seq-avaliacao + 1.
    ELSE
        ASSIGN i-seq = 1.

    CREATE int-emitente-supcard-ocor.
    ASSIGN int-emitente-supcard-ocor.raiz-cnpj            = c-raiz-cnpj
           int-emitente-supcard-ocor.dat-avaliacao        = TODAY
           int-emitente-supcard-ocor.seq-avaliacao        = i-seq
           int-emitente-supcard-ocor.ind-env-ret          = 1 /* Envio */
           int-emitente-supcard-ocor.ind-ocor             = "8.2"
           int-emitente-supcard-ocor.num-transac          = c-nr-transacao
           int-emitente-supcard-ocor.num-parcela          = STRING(i-qtd-prestacoes, "99")
           int-emitente-supcard-ocor.log-habilitado       = NO
           int-emitente-supcard-ocor.val-limite           = 0
           int-emitente-supcard-ocor.val-limite-utilizado = 0
           int-emitente-supcard-ocor.val-limite-sugerido  = 0
           int-emitente-supcard-ocor.cod-usuar            = c-seg-usuario
           int-emitente-supcard-ocor.log-emergencial      = NO
           int-emitente-supcard-ocor.qtd-dias-atraso      = 0
           int-emitente-supcard-ocor.cod-motivo           = 0
           int-emitente-supcard-ocor.nom-arquivo          = ENTRY(NUM-ENTRIES(cArquivo,"/"),cArquivo,"/").

    RETURN "OK":U.
END PROCEDURE.
