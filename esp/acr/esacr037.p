/*****************************************************************************
** Programa: esp/acr/esacr037.p
** Vers∆o..: 1.00
** Data....: 13/09/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para Ler os arquivos de Retorno das transaá‰es com o SupplierCard,
**           de acordo com o layout enviado (Layout 8.5 ou 8.6).
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pLayout  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pArquivo AS CHARACTER   NO-UNDO.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-linha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-raiz-cnpj  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-layout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-arquivo   AS DATE        NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq        AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048   AS HANDLE      NO-UNDO.

DEFINE BUFFER bf-int-emitente-supcard FOR int-emitente-supcard.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD raiz-cnpj AS CHARACTER FORMAT "99.999.999" COLUMN-LABEL "Raiz CNPJ"
    FIELD desc-erro AS CHARACTER FORMAT "X(121)" COLUMN-LABEL "Descriá∆o"
    INDEX id raiz-cnpj.

/* ************************  Function Prototypes ********************** */

FUNCTION fnMotivo RETURNS INTEGER
  ( pCdnMotivo AS CHARACTER )  FORWARD.

FUNCTION fnDesMotivo RETURN CHARACTER
    (pCdnMotivo AS CHARACTER ) FORWARD.

/*--- Bloco Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados":U).

CASE pLayout:
    WHEN "8.5" THEN
        ASSIGN c-layout = "Outras Transaá‰es (Layout 8.5)".
    WHEN "8.6" THEN DO:
        ASSIGN c-layout = "Atualizaá∆o de Clientes (Layout 8.6)".
    END.
END.


INPUT FROM VALUE(pArquivo) NO-ECHO CONVERT SOURCE "iso8859-1":U.
REPEAT:
    ASSIGN i-cont = i-cont + 1.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Linha " + STRING(i-cont)).

    IMPORT UNFORMATTED c-linha.


    /* HEADER */
    IF  SUBSTRING(c-linha,1,1) = "0" THEN DO:
        CASE pLayout:
            WHEN "8.5" THEN
                ASSIGN dt-arquivo = DATE(SUBSTRING(c-linha,12,8)).
            WHEN "8.6" THEN DO:
                ASSIGN dt-arquivo = DATE(SUBSTRING(c-linha,17,8)).
            END.
        END.
    END.

    
    /* DETALHE */
    IF  SUBSTRING(c-linha,1,1) = "1" THEN DO:
        CASE pLayout:
            WHEN "8.5" THEN DO:
                RUN pi-retorno-resultado-analise IN THIS-PROCEDURE.
            END.
            WHEN "8.6" THEN DO:
                RUN pi-retorno-lim-credito IN THIS-PROCEDURE.
            END.
        END.
    END.
END.

INPUT CLOSE.


/* Replica o limite dos clientes para a data de hoje, pois no arquivo de atualizaá∆o s¢ s∆o enviados 
   os clientes que tiveram movimentaá∆o. E todos os clientes devem ficar com data atualizada */
IF  pLayout = "8.6":U THEN DO:
    IF  CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                 WHERE int-emitente-supcard-ocor.dat-avaliacao = dt-arquivo
                 AND   int-emitente-supcard-ocor.ind-ocor      = "8.6") THEN
        RUN pi-replica-limites IN THIS-PROCEDURE.
END.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.


/* Copia o arquivo para a pasta de Antigos */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-mover-arquivo IN h-esacr048 (INPUT pArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.


/* Verifica se tiveram rejeiá‰es para as transaá‰es enviadas, e exporta para um arquivo. */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "ErrosSupplierCard.txt".
    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

    PUT UNFORMATTED FILL("-", 124) SKIP
                    FILL(" ", 44) + "CNPJs Bloqueados pela SupplierCard" SKIP
                    FILL("-", 124) SKIP(2).

    FOR EACH tt-erro NO-LOCK:
        DISPLAY tt-erro WITH STREAM-IO WIDTH 132.
    END.
    OUTPUT CLOSE.

    IF  OPSYS = "WIN32":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Clientes Bloqueados pela SupplierCard.~~":U + 
                                 "O processo de importaá∆o " + c-layout + " foi finalizado, mas contÇm erros.":U).
    
        RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo,
                     INPUT 1).
    END.
END.
ELSE DO:
    IF  OPSYS = "WIN32":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Processo de importaá∆o " + c-layout + " finalizado!":U).
    END.
END.



/*--- Procedures Internas ---*/
PROCEDURE pi-retorno-resultado-analise:
    DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.

    ASSIGN i-seq               = 1
           i-dias-atraso-intel = 0
           i-cod-classe        = 0.

    ASSIGN c-raiz-cnpj = SUBSTRING(c-linha,6,8).

    /* Busca a £ltima informaá∆o dos Dias de Atraso Intelbras, para o cliente */
    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = c-raiz-cnpj NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN
        ASSIGN i-dias-atraso-intel = int-emitente-supcard.qtd-dias-atraso-int
               i-cod-classe        = int-emitente-supcard.cod-classe
               de-val-limite       = int-emitente-supcard.val-limite.

    FIND FIRST int-emitente-supcard EXCLUSIVE-LOCK
        WHERE  int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
        AND    int-emitente-supcard.dat-avaliacao = dt-arquivo NO-ERROR.
    IF  NOT AVAIL int-emitente-supcard THEN DO:
        CREATE int-emitente-supcard.
        ASSIGN int-emitente-supcard.raiz-cnpj           = c-raiz-cnpj
               int-emitente-supcard.dat-avaliacao       = dt-arquivo
               int-emitente-supcard.qtd-dias-atraso-int = i-dias-atraso-intel
               int-emitente-supcard.cod-classe          = i-cod-classe.
    END.
    ELSE
        ASSIGN de-val-limite = int-emitente-supcard.val-limite.

    ASSIGN int-emitente-supcard.log-habilitado       = int-emitente-supcard.log-habilitado
           int-emitente-supcard.val-limite           = de-val-limite
           int-emitente-supcard.val-limite-utilizado = int-emitente-supcard.val-limite-utilizado
           int-emitente-supcard.qtd-dias-atraso-sc   = int-emitente-supcard.qtd-dias-atraso-sc.


    /* Tratamento para o arquivo com o final 010, onde Ç enviado o aceite da transaá∆o */
    FIND FIRST int-emitente-supcard-ocor EXCLUSIVE-LOCK
        WHERE  int-emitente-supcard-ocor.raiz-cnpj   = c-raiz-cnpj
        AND    int-emitente-supcard-ocor.ind-ocor    = "8.5"
        AND    int-emitente-supcard-ocor.num-transac = SUBSTRING(c-linha,85,14) NO-ERROR.
    IF  NOT AVAIL int-emitente-supcard-ocor THEN DO:
        FIND LAST int-emitente-supcard-ocor NO-LOCK
            WHERE int-emitente-supcard-ocor.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL int-emitente-supcard-ocor THEN
            ASSIGN i-seq = int-emitente-supcard-ocor.seq-avaliacao + 1.

        /* Se n∆o encontro a ocorrància, cria. Pois o arquivo Ç com o final 005. */
        CREATE int-emitente-supcard-ocor.
        ASSIGN int-emitente-supcard-ocor.raiz-cnpj            = c-raiz-cnpj
               int-emitente-supcard-ocor.seq-avaliacao        = i-seq
               int-emitente-supcard-ocor.ind-env-ret          = 2 /* Retorno */
               int-emitente-supcard-ocor.ind-ocor             = "8.5"
               int-emitente-supcard-ocor.num-transac          = SUBSTRING(c-linha,85,14)
               int-emitente-supcard-ocor.num-parcela          = SUBSTRING(c-linha,305,2)
               int-emitente-supcard-ocor.log-emergencial      = NO
               int-emitente-supcard-ocor.qtd-dias-atraso      = 0
               int-emitente-supcard-ocor.val-limite           = 0
               int-emitente-supcard-ocor.val-limite-sugerido  = 0
               int-emitente-supcard-ocor.val-limite-utilizado = 0.
    END.

    ASSIGN int-emitente-supcard-ocor.cod-usuar      = c-seg-usuario
           int-emitente-supcard-ocor.dat-avaliacao  = dt-arquivo
           int-emitente-supcard-ocor.log-habilitado = IF SUBSTRING(c-linha,448,2) = "01" THEN YES ELSE NO
           int-emitente-supcard-ocor.cod-motivo     = fnMotivo(SUBSTRING(c-linha, 450, 3))
           int-emitente-supcard-ocor.nom-arquivo    = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/").


    /* Grava o tipo de requisiá∆o */
    CASE SUBSTRING(c-linha,4,2) /* Requisiá∆o */:
        WHEN "02" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Prorrogaá∆o de Vencimento".
        WHEN "03" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Cancelamento Total de Compra".
        WHEN "04" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Retorno de Cadastro de Cliente ou Alteraá∆o de Limite".
        WHEN "06" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Alteraá∆o de Dados Cadastrais".
        WHEN "10" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Cancelamento Parcial de Compra".
        WHEN "11" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Bonificaá∆o".
        WHEN "19" THEN
            ASSIGN int-emitente-supcard-ocor.obs = "Bloqueio de Cliente".
    END CASE.

    /* Grava o status da transaá∆o */
    CASE SUBSTRING(c-linha,448,2) /* Status */:
        WHEN "01" THEN
            ASSIGN int-emitente-supcard-ocor.obs = int-emitente-supcard-ocor.obs + " -- " + "Atendida".
        WHEN "02" THEN
            ASSIGN int-emitente-supcard-ocor.obs = int-emitente-supcard-ocor.obs + " -- " + "Encaminhada".
        WHEN "03" THEN DO:
            ASSIGN int-emitente-supcard-ocor.obs = int-emitente-supcard-ocor.obs + " -- " + "Rejeitada".
            CREATE tt-erro.
            ASSIGN tt-erro.raiz-cnpj = c-raiz-cnpj
                   tt-erro.desc-erro = fnDesMotivo(SUBSTRING(c-linha,450,3)). 
        END.
    END CASE.

    /* Observaá∆o s¢ tem valor para as requisiá‰es 04 e 06 */
    IF  TRIM(SUBSTRING(c-linha,307,100)) <> "" THEN
        ASSIGN int-emitente-supcard-ocor.obs = int-emitente-supcard-ocor.obs + " -- " + SUBSTRING(c-linha,307,100).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-retorno-lim-credito:
    DEFINE VARIABLE de-lim-disp         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-lim-tot          AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.

    ASSIGN i-seq       = 1
           de-lim-disp = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,76,14),"999999999999,99")),2)
           de-lim-tot  = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,62,14),"999999999999,99")),2).

    ASSIGN c-raiz-cnpj = SUBSTRING(c-linha,8,8).

    /* Busca a £ltima informaá∆o dos Dias de Atraso Intelbras, para o cliente */
    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = c-raiz-cnpj NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN
        ASSIGN i-dias-atraso-intel = int-emitente-supcard.qtd-dias-atraso-int
               i-cod-classe        = int-emitente-supcard.cod-classe.
    ELSE
        ASSIGN i-dias-atraso-intel = 0
               i-cod-classe        = 0.

    FIND FIRST int-emitente-supcard EXCLUSIVE-LOCK
        WHERE  int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
        AND    int-emitente-supcard.dat-avaliacao = dt-arquivo NO-ERROR.
    IF  NOT AVAIL int-emitente-supcard THEN DO:
        CREATE int-emitente-supcard.
        ASSIGN int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
               int-emitente-supcard.dat-avaliacao = dt-arquivo.
    END.

    ASSIGN int-emitente-supcard.log-habilitado       = IF SUBSTRING(c-linha,165,1) = "0" THEN YES ELSE NO
           int-emitente-supcard.val-limite           = de-lim-disp
           int-emitente-supcard.val-limite-utilizado = de-lim-tot - de-lim-disp
           int-emitente-supcard.qtd-dias-atraso-sc   = INT(SUBSTRING(c-linha,160,5))
           int-emitente-supcard.qtd-dias-atraso-int  = i-dias-atraso-intel
           int-emitente-supcard.cod-classe           = i-cod-classe.


    /* Verifica em qual faixa de Classe que o cliente est† inserido */
    FIND LAST int-classe-cli-supcard NO-LOCK
        WHERE  int-classe-cli-supcard.val-limite-ini <= de-lim-tot
        AND    int-classe-cli-supcard.val-limite-fin >= de-lim-tot NO-ERROR.
    IF  AVAIL  int-classe-cli-supcard THEN DO:
        ASSIGN int-emitente-supcard.cod-classe = int-classe-cli-supcard.cod-classe.

        /* Se o cliente mudou de classe, desde a £ltima atualizaá∆o, cria um registro de pendància */
        IF  i-cod-classe <> int-classe-cli-supcard.cod-classe THEN DO:
            /* ** Cria pendància para todos os clientes da raiz do CNPJ ***/
            FOR EACH emitente NO-LOCK
               WHERE emitente.cgc BEGINS c-raiz-cnpj
                 AND emitente.identific <> 2:
               CREATE int-pendencias-supcard.
               ASSIGN int-pendencias-supcard.cnpj-cliente = emitente.cgc
                      int-pendencias-supcard.dat-criacao  = TODAY
                      int-pendencias-supcard.cod-usuar    = c-seg-usuario
                      int-pendencias-supcard.identific    = 06 /* Alteraá∆o de Dados Cadastrais */.
            END.
        END.

    END.
    ELSE
        ASSIGN int-emitente-supcard.cod-classe = 0.


    FIND LAST int-emitente-supcard-ocor NO-LOCK
        WHERE int-emitente-supcard-ocor.raiz-cnpj = c-raiz-cnpj NO-ERROR.
    IF  AVAIL int-emitente-supcard-ocor THEN
        ASSIGN i-seq = int-emitente-supcard-ocor.seq-avaliacao + 1.

    CREATE int-emitente-supcard-ocor.
    ASSIGN int-emitente-supcard-ocor.raiz-cnpj            = c-raiz-cnpj
           int-emitente-supcard-ocor.seq-avaliacao        = i-seq
           int-emitente-supcard-ocor.cod-usuar            = c-seg-usuario
           int-emitente-supcard-ocor.dat-avaliacao        = dt-arquivo
           int-emitente-supcard-ocor.cod-motivo           = 0
           int-emitente-supcard-ocor.ind-env-ret          = 2 /* Retorno */
           int-emitente-supcard-ocor.ind-ocor             = "8.6"
           int-emitente-supcard-ocor.log-emergencial      = NO
           int-emitente-supcard-ocor.log-habilitado       = IF SUBSTRING(c-linha,165,1) = "0" THEN YES ELSE NO
           int-emitente-supcard-ocor.qtd-dias-atraso      = INT(SUBSTRING(c-linha,160,5))
           int-emitente-supcard-ocor.val-limite           = de-lim-disp
           int-emitente-supcard-ocor.val-limite-sugerido  = 0
           int-emitente-supcard-ocor.val-limite-utilizado = de-lim-tot - de-lim-disp
           int-emitente-supcard-ocor.nom-arquivo          = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/").

    IF  NOT int-emitente-supcard-ocor.log-habilitado THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.raiz-cnpj = int-emitente-supcard-ocor.raiz-cnpj
               tt-erro.desc-erro = "CNPJ Bloqueados pela SupplierCard".
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-replica-limites:
    /* PROCEDURE PARA REPLICAR OS LIMITES DOS CLIENTES PARA HOJE E ATê O PR‡XIMO DIA ÈTIL */

    DEFINE VARIABLE dt-prox-data AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-data-aux  AS DATE        NO-UNDO.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Replicando Limite").
    
    ASSIGN dt-prox-data = dt-arquivo.

    /* Funá∆o para buscar o pr¢ximo dia £til */
    REPEAT:
        ASSIGN dt-prox-data = dt-prox-data + 1.

        FIND FIRST dia_calend_glob
            WHERE dia_calend_glob.cod_calend = "Fiscal":U
              AND dia_calend_glob.dat_calend = dt-prox-data NO-LOCK NO-ERROR.

        IF dia_calend_glob.log_dia_util THEN /* Veirifica se Ç dia £til */
            LEAVE.
    
/*         IF  WEEKDAY(dt-prox-data) <> 1 /* Domingo */ AND  */
/*             WEEKDAY(dt-prox-data) <> 7 /* S†bado  */ THEN */
/*             LEAVE.                                        */
    END.

    /* Busca o registro atualizado da data do arquivo, pois se o cliente 
       teve atualizaá∆o, esta deve permanecer para todas as datas seguintes */
    FOR EACH  bf-int-emitente-supcard NO-LOCK
        WHERE bf-int-emitente-supcard.dat-avaliacao = dt-arquivo:
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Raiz CNPJ - " + bf-int-emitente-supcard.raiz-cnpj).

        DO dt-data-aux = (dt-arquivo + 1) TO dt-prox-data:
            /* Gera um segundo registro para o pr¢ximo dia £til */
            FIND FIRST int-emitente-supcard EXCLUSIVE-LOCK
                WHERE  int-emitente-supcard.raiz-cnpj     = bf-int-emitente-supcard.raiz-cnpj
                AND    int-emitente-supcard.dat-avaliacao = dt-data-aux NO-ERROR.
            IF  NOT AVAIL int-emitente-supcard THEN DO:
                CREATE int-emitente-supcard.
                ASSIGN int-emitente-supcard.raiz-cnpj     = bf-int-emitente-supcard.raiz-cnpj
                       int-emitente-supcard.dat-avaliacao = dt-data-aux.
            END.
            BUFFER-COPY bf-int-emitente-supcard EXCEPT raiz-cnpj dat-avaliacao TO int-emitente-supcard.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name   AS CHARACTER.
    DEF INPUT  PARAM prg_style  AS SHORT.
END PROCEDURE.

/* ************************  Function Implementations ***************** */

FUNCTION fnMotivo RETURNS INTEGER
  ( pCdnMotivo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST int-motivo-supcard
        WHERE int-motivo-supcard.cdn-motivo = pCdnMotivo NO-LOCK NO-ERROR.

    IF AVAILABLE int-motivo-supcard THEN
        RETURN int-motivo-supcard.cod-motivo.
    ELSE
        RETURN 0.

END FUNCTION.

FUNCTION fnDesMotivo RETURNS CHARACTER 
    ( pCdnMotivo AS CHARACTER ) :

    FIND FIRST int-motivo-supcard
        WHERE int-motivo-supcard.cdn-motivo = pCdnMotivo NO-LOCK NO-ERROR.

    IF AVAIL int-motivo-supcard THEN
        RETURN int-motivo-supcard.des-motivo.
    ELSE
        RETURN "".

END FUNCTION.
