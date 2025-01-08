/*****************************************************************************
** Programa: esp/acr/esacr042.p
** Vers∆o..: 1.00
** Data....: 30/09/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para Exportaá∆o de dados conforme layout enviado (Layout 8.4).
*****************************************************************************/


/*--- Definiá∆o das Vari†veis ---*/
{esp/acr/esacr035.i}
{include/i-freeac.i}

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE cArquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodEmp        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-transacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-parcela   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cdapi704     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048     AS HANDLE      NO-UNDO.
DEFINE VARIABLE iSequencia     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTotRegistros  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLinha         AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-gerou-arq    AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt-emitente-supcard-novo-cli NO-UNDO
    LIKE tt-emitente-supcard.

DEFINE TEMP-TABLE tt-emitente-supcard-lim-cli NO-UNDO
    LIKE tt-emitente-supcard.



/*--- Bloco Principal ---*/
/* Busca o arquivo do Layout */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-retornar-arquivo-remessa IN h-esacr048 (INPUT  "8.4",
                                               OUTPUT cArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.


ASSIGN l-gerou-arq    = NO
       cCodEmp        = "G7"
       iTotRegistros  = 0
       iLinha         = 1.


/* API para tratar o Endereáo */
IF  NOT VALID-HANDLE(h-cdapi704) THEN
    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados":U).


OUTPUT TO VALUE(cArquivo) CONVERT TARGET "iso8859-1".

/**** HEADER ****/
PUT UNFORMATTED "0"                                           + /* FIXO - Registro */
                STRING("UPLOAD", "x(10)")                     +
                REPLACE(STRING(TODAY, "99/99/9999"), "/", "") +
                REPLACE(STRING(TIME, "HH:MM:SS"), ":", "")    +
                FILL(" ", 489)                                + /* FIXO - Filler */
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.


FOR EACH  int-pendencias-supcard EXCLUSIVE-LOCK
    WHERE int-pendencias-supcard.dat-envio = ?
    BY    int-pendencias-supcard.identific:

    IF int-pendencias-supcard.identific = 97 THEN /* Reenvio de Nota Fiscal deve ser feita pelo parÉmetro "Upload de Compras (Layout 8.2)" */
        NEXT.

    ASSIGN c-nr-transacao = ""
           c-nr-parcela   = "".

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Exportando").

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cgc = int-pendencias-supcard.cnpj-cliente NO-ERROR.
    IF  NOT AVAIL emitente THEN
        NEXT.

    /* Deve ser Pessoa Jur°fica e Cliente (ou ambos). N∆o pode ser fornecedor */
    IF  emitente.natureza <> 2 /* Pessoa Jur°dica */ OR
        emitente.identific = 2 /* Fornecedor */      THEN
        NEXT.

    /* S¢ busca os clientes ativos */
    FIND FIRST int-emitente NO-LOCK
        WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    IF  NOT AVAIL int-emitente THEN NEXT.
    /* Alteraá∆o cadastral, reclassificaá∆o envia mesmo o cliente estando inativo, demais ocorràncias n∆o envia */
    IF  int-pendencias-supcard.identific <> 6 THEN
        IF NOT int-emitente.id-ativo THEN NEXT.
    
    /* Quando Ç Limite de CrÇdito n∆o precisa exportar a informaá∆o. ê feito em um passo seguinte. */
    IF  int-pendencias-supcard.identific = 99 /* Solicitaá∆o de Limite de CrÇdito */ OR
        int-pendencias-supcard.identific = 98 /* Solicitaá∆o de Novo Cliente      */ THEN DO:
        RUN pi-trata-cliente IN THIS-PROCEDURE.
    END.
    ELSE DO:
        ASSIGN l-gerou-arq = YES.

        /**** DETALHE ****/
        ASSIGN iTotRegistros = iTotRegistros + 1.
        PUT UNFORMATTED "1"                                            + /* FIXO - Registro */
                        STRING(cCodEmp, "x(02)")                       +
                        STRING(int-pendencias-supcard.identific, "99") +
                        STRING(emitente.cgc, "x(14)").
        
    
        /* De acordo com o  Tipo de Requisiá∆o, ser† exportada uma informaá∆o diferente */
        CASE int-pendencias-supcard.identific:
            WHEN 02 /* Prorrogaá∆o de Vencimento      */ OR
            WHEN 03 /* Cancelamento Total de Compra   */ OR
            WHEN 10 /* Cancelamento Parcial de Compra */ THEN DO:
                RUN pi-prorrog-cancel-titulo IN THIS-PROCEDURE.
            END.
            WHEN 06 /* Alteraá∆o de Dados Cadastrais */ THEN DO:
                RUN pi-alteracao-dados-cadastrais IN THIS-PROCEDURE.
            END.
            WHEN 11 /* Bonificaá∆o */ THEN DO:
                RUN pi-bonificacao IN THIS-PROCEDURE.
            END.
            WHEN 19 /* Bloqueio de Cliente */ THEN DO:
                RUN pi-bloqueio-cliente IN THIS-PROCEDURE.
            END.
        END CASE.
    
    
        PUT UNFORMATTED FILL(" ", 14)  +
                        "01"           +
                        "000"          +
                        FILL(" ", 62)  +
                        STRING(iLinha, "999999") SKIP.
        ASSIGN iLinha = iLinha + 1.

        RUN pi-cria-registro-supcard IN THIS-PROCEDURE.
    END.

    ASSIGN int-pendencias-supcard.dat-envio = TODAY.
END.


/**** TRAILLER ****/
PUT UNFORMATTED "9"                             + /* FIXO - Registro */
                STRING(iTotRegistros, "999999") + /* Total de Registros - Menos Header e Trailler */
                FILL(" ", 507)                  +
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.

OUTPUT CLOSE.


/* Se n∆o gerou informaá‰es no arquivo (est† em branco), elimina o arquivo */
IF  NOT l-gerou-arq THEN
    OS-DELETE VALUE(cArquivo).
ELSE DO:
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
END.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF  VALID-HANDLE(h-cdapi704) THEN DO:
    DELETE PROCEDURE h-cdapi704.
    ASSIGN h-cdapi704 = ?.
END.


/* Se teve uma solicitaá∆o de alteraá∆o de limite de crÇdito,chama o programa para exportaá∆o do dados do cliente */
IF  CAN-FIND(FIRST tt-emitente-supcard-lim-cli) THEN DO:
    RUN esp/acr/esacr035.p (INPUT "8.10", /* Layout */
                            INPUT c-lista,
                            INPUT TABLE tt-emitente-supcard-lim-cli).
END.

/* Se teve uma solicitaá∆o de novo cliente, chama o programa para exportaá∆o do dados do cliente */
IF  CAN-FIND(FIRST tt-emitente-supcard-novo-cli) THEN DO:
    RUN esp/acr/esacr035.p (INPUT "8.1", /* Layout */
                            INPUT c-lista,
                            INPUT TABLE tt-emitente-supcard-novo-cli).
END.



IF  OPSYS = "WIN32":U THEN
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Processo de exportaá∆o Upload Outras Transaá‰es (Layout 8.4) finalizado!":U).



/*--- Procedures Internas ---*/
PROCEDURE pi-prorrog-cancel-titulo:
    DEFINE VARIABLE i-qtd-prestacoes AS INTEGER     NO-UNDO.

    ASSIGN c-nr-parcela = int-pendencias-supcard.cod-parcela.

    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = int-pendencias-supcard.cod-estab
        AND    nota-fiscal.serie       = int-pendencias-supcard.cod-ser-docto
        AND    nota-fiscal.nr-nota-fis = int-pendencias-supcard.cod-tit-acr NO-ERROR.
    IF  NOT AVAIL  nota-fiscal THEN
        RETURN "NOK":U.

    /* O n£mero da transaá∆o Ç a juná∆o do Estabelecimento + SÇrie + Nr Nota Fiscal */
    ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999").

    FOR EACH  fat-duplic NO-LOCK
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
        AND   fat-duplic.serie       = nota-fiscal.serie
        AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura
        BY    fat-duplic.parcela:
        ASSIGN i-qtd-prestacoes = i-qtd-prestacoes + 1.
    END.


    PUT UNFORMATTED FILL(" ", 65)                                                       +
                    STRING(c-nr-transacao, "99999999999999")                            +
                    REPLACE(ISO-DATE(nota-fiscal.dt-emis-nota), "-", "")                +
                    FILL(" ", 09)                                                       +
                    REPLACE(STRING(nota-fiscal.vl-tot-nota, "99999999999.99"), ",", "") +
                    STRING(i-qtd-prestacoes, "99")                                      +
                    FILL(" ", 04)                                                       +
                    REPLACE(ISO-DATE(TODAY), "-", "").
    
    IF  int-pendencias-supcard.identific = 02 THEN
        PUT UNFORMATTED STRING(int-pendencias-supcard.dias-prorrog, "999").
    ELSE
        PUT UNFORMATTED FILL("0", 03).

    PUT UNFORMATTED "1" +
                    FILL(" ", 40) +
                    FILL("0", 05) +
                    FILL(" ", 15) +
                    FILL("0", 08) +
                    FILL(" ", 90).

    IF  int-pendencias-supcard.identific = 02 THEN
        PUT UNFORMATTED STRING(int-pendencias-supcard.cod-parcela, "99").
    ELSE
        PUT UNFORMATTED FILL("0", 02).

    PUT UNFORMATTED FILL(" ", 100) +
                    FILL("0", 14).

    IF  int-pendencias-supcard.identific = 10 THEN
        PUT UNFORMATTED REPLACE(STRING(int-pendencias-supcard.val-lancamento, "99999999999.99"), ",","").
    ELSE
        PUT UNFORMATTED FILL("0", 13).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-alteracao-dados-cadastrais:
    DEFINE VARIABLE c-classe    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-rua       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nro       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-comp      AS CHARACTER   NO-UNDO. 
    DEFINE VARIABLE c-nome-emit AS CHARACTER   NO-UNDO.

    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
    IF  NOT AVAIL int-emitente-supcard THEN
        NEXT.

    FIND LAST int-classe-cli-supcard NO-LOCK
        WHERE  int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-ERROR.
    ASSIGN c-classe = IF AVAIL int-classe-cli-supcard THEN int-classe-cli-supcard.des-classe ELSE "".

    IF  VALID-HANDLE(h-cdapi704) THEN
        RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco-cob,
                                             OUTPUT c-rua,
                                             OUTPUT c-nro,
                                             OUTPUT c-comp).
    ELSE
        ASSIGN c-rua  = ""
               c-nro  = ""
               c-comp = "".

    ASSIGN c-nome-emit = fn-free-accent(upper(trim(emitente.nome-emit))).

    PUT UNFORMATTED STRING(c-nome-emit, "x(40)")                  +
                    STRING(c-nome-emit, "x(25)")                  +
                    FILL(" ", 22)                                        +
                    STRING(c-classe, "x(09)")                            +
                    FILL(" ", 31)                                        +
                    STRING(c-rua, "x(40)")                               +
                    STRING(c-nro, "x(5)")                                +
                    STRING(c-comp, "x(15)")                              +
                    STRING(emitente.cep-cob, "x(8)")                     +
                    STRING(emitente.cidade-cob, "x(20)")                 +
                    STRING(emitente.estado-cob, "x(2)")                  +
                    STRING(SUBSTRING(emitente.telefone[1],1,2), "999")   +
                    STRING(SUBSTRING(emitente.telefone[1],3,8), "x(15)") +
                    STRING(emitente.e-mail, "x(50)")                     +
                    FILL(" ", 2)                                         +
                    STRING(emitente.bairro-cob, "x(100)")                +
                    FILL("0", 27).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-bonificacao:

    FIND FIRST tit_acr NO-LOCK
        WHERE  tit_acr.cod_estab       = int-pendencias-supcard.cod-estab
        AND    tit_acr.cod_espec_docto = int-pendencias-supcard.cod-espec-docto
        AND    tit_acr.cod_ser_docto   = int-pendencias-supcard.cod-ser-docto
        AND    tit_acr.cod_tit_acr     = int-pendencias-supcard.cod-tit-acr
        AND    tit_acr.cod_parcela     = int-pendencias-supcard.cod-parcela NO-ERROR.
    IF  NOT AVAIL tit_acr THEN
        RETURN "NOK":U.

    ASSIGN c-nr-parcela = tit_acr.cod_parcela.

    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = tit_acr.cod_estab
        AND    nota-fiscal.serie       = tit_acr.cod_ser_docto
        AND    nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
    IF  NOT AVAIL  nota-fiscal THEN
        RETURN "NOK":U.

    /* O n£mero da transaá∆o Ç a juná∆o do Estabelecimento + SÇrie + Nr Nota Fiscal */
    ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999").

    PUT UNFORMATTED FILL(" ", 65)                                        +
                    STRING(c-nr-transacao, "99999999999999")             +
                    FILL(" ", 17)                                        +
                    FILL("0", 15)                                        +
                    FILL(" ", 04)                                        +
                    REPLACE(ISO-DATE(nota-fiscal.dt-emis-nota), "-", "") +
                    FILL("0", 03)                                        +
                    FILL(" ", 41)                                        +
                    FILL("0", 05)                                        +
                    FILL(" ", 15)                                        +
                    FILL("0", 08)                                        +
                    FILL(" ", 90)                                        +
                    FILL("0", 02)                                        +
                    FILL(" ", 100)                                       +
                    FILL("0", 14)                                        +
                    REPLACE(STRING(int-pendencias-supcard.val-lancamento, "99999999999.99"), ",","").

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-bloqueio-cliente:

    PUT UNFORMATTED FILL(" ", 65)                                                   +
                    FILL("0", 14)                                                   +
                    REPLACE(ISO-DATE(int-pendencias-supcard.dat-bloqueio), "-", "") +
                    FILL(" ", 09)                                                   +
                    FILL("0", 15)                                                   +
                    FILL(" ", 12)                                                   +
                    FILL("0", 03)                                                   +
                    STRING(int-pendencias-supcard.tipo-bloqueio, "9")               +
                    FILL(" ", 40)                                                   +
                    FILL("0", 05)                                                   +
                    FILL(" ", 15)                                                   +
                    FILL("0", 08)                                                   +
                    FILL(" ", 90)                                                   +
                    FILL("0", 02)                                                   +
                    FILL(" ", 100)                                                  +
                    FILL("0", 27).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-trata-cliente:
    
    /* Como para novos clientes n∆o precisa validar essa informaá∆o, envia o grupo dos clientes
       que ser∆o exportados, para que n∆o parem na validaá∆o dentro do esacr035 */
    ASSIGN c-lista = c-lista + STRING(int-emitente.cod-gr-cob, "99") + ",".

    IF  int-pendencias-supcard.identific = 99 /* Solicitaá∆o de Limite de CrÇdito */ THEN DO:
        CREATE tt-emitente-supcard-lim-cli.
        ASSIGN tt-emitente-supcard-lim-cli.raiz-cnpj           = SUBSTRING(emitente.cgc,1,8)
               tt-emitente-supcard-lim-cli.nome-matriz         = emitente.nome-matriz
               tt-emitente-supcard-lim-cli.tipo-solicitacao    = IF int-pendencias-supcard.log-emergencial THEN 1 ELSE 0
               tt-emitente-supcard-lim-cli.val-limite-sugerido = int-pendencias-supcard.val-limite-sugerido.
    END.
    ELSE DO:
        /* Solicitaá∆o de Novo Cliente */
        CREATE tt-emitente-supcard-novo-cli.
        ASSIGN tt-emitente-supcard-novo-cli.raiz-cnpj           = SUBSTRING(emitente.cgc,1,8)
               tt-emitente-supcard-novo-cli.nome-matriz         = emitente.nome-matriz
               tt-emitente-supcard-novo-cli.tipo-solicitacao    = IF int-pendencias-supcard.log-emergencial THEN 1 ELSE 0
               tt-emitente-supcard-novo-cli.val-limite-sugerido = int-pendencias-supcard.val-limite-sugerido.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-cria-registro-supcard:
    DEFINE VARIABLE c-raiz-cnpj         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq               AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.

    ASSIGN c-raiz-cnpj = SUBSTRING(emitente.cgc,1,8).

    IF  NOT CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                     WHERE int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
                     AND   int-emitente-supcard.dat-avaliacao = TODAY) THEN DO:
        /* Busca a £ltima informaá∆o dos Dias de Atraso Intelbras, para o cliente */
        FIND LAST int-emitente-supcard NO-LOCK
            WHERE int-emitente-supcard.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL int-emitente-supcard THEN
            ASSIGN i-dias-atraso-intel = int-emitente-supcard.qtd-dias-atraso-int
                   i-cod-classe        = int-emitente-supcard.cod-classe
                   de-val-limite       = int-emitente-supcard.val-limite.
        ELSE
            ASSIGN i-dias-atraso-intel = 0
                   i-cod-classe        = 0
                   de-val-limite       = 0.

        CREATE int-emitente-supcard.
        ASSIGN int-emitente-supcard.raiz-cnpj            = c-raiz-cnpj
               int-emitente-supcard.dat-avaliacao        = TODAY
               int-emitente-supcard.log-habilitado       = NO
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
           int-emitente-supcard-ocor.ind-ocor             = "8.4"
           int-emitente-supcard-ocor.num-transac          = c-nr-transacao
           int-emitente-supcard-ocor.num-parcela          = c-nr-parcela
           int-emitente-supcard-ocor.log-habilitado       = NO
           int-emitente-supcard-ocor.val-limite           = 0
           int-emitente-supcard-ocor.val-limite-utilizado = 0
           int-emitente-supcard-ocor.val-limite-sugerido  = 0
           int-emitente-supcard-ocor.cod-usuar            = c-seg-usuario
           int-emitente-supcard-ocor.log-emergencial      = NO
           int-emitente-supcard-ocor.qtd-dias-atraso      = 0
           int-emitente-supcard-ocor.cod-motivo           = 0
           int-emitente-supcard-ocor.obs                  = int-pendencias-supcard.obs
           int-emitente-supcard-ocor.nom-arquivo          = ENTRY(NUM-ENTRIES(cArquivo,"/"),cArquivo,"/").

    RETURN "OK":U.
END PROCEDURE.
