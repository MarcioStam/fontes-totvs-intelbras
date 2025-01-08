/*****************************************************************************
** Programa: esp/acr/esacr035.p
** Vers∆o..: 1.00
** Data....: 08/09/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para Exportaá∆o de dados do cliente, de acordo com o 
**           layout enviado (Layout 8.1 ou 8.10).
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
{esp/acr/esacr035.i}

DEFINE INPUT  PARAMETER pLayout     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pGrCobranca AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-emitente-supcard.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE cArquivo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodEmp          AS CHARACTER   NO-UNDO. /* C¢digo da Empresa no sistema da SupplierCard */
DEFINE VARIABLE cNomeBanco       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCGCEmpresa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRua             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNro             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cComp            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDescClasse      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLinha           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTotRegistros    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iAux             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTipoSolicitacao AS INTEGER     NO-UNDO. /* 0 - Normal  --  1 - Emergencial */
DEFINE VARIABLE iLoja            AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFilial          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iDtVencto        AS INTEGER     NO-UNDO.
DEFINE VARIABLE deTotValTitulo   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deTotValVencto   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deLimCredito     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE hCdapi704        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048       AS HANDLE      NO-UNDO.
DEFINE VARIABLE dtIni            AS DATE        NO-UNDO.
DEFINE VARIABLE dtFim            AS DATE        NO-UNDO.
DEFINE VARIABLE lCriou           AS LOGICAL     NO-UNDO.


DEFINE TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD registro                  AS INTEGER
    FIELD cgc_empresa               AS CHARACTER
    FIELD cod_estab                 LIKE tit_acr.cod_estab
    FIELD num_id_tit_acr            LIKE tit_acr.num_id_tit_acr
    FIELD dat_emis_docto            LIKE tit_acr.dat_emis_docto
    FIELD dat_vencto_origin_tit_acr LIKE tit_acr.dat_vencto_origin_tit_acr
    FIELD dat_vencto_tit_acr        LIKE tit_acr.dat_vencto_tit_acr
    FIELD dat_liquidac_tit_acr      AS CHARACTER
    FIELD val_origin_tit_acr        AS CHARACTER
    FIELD val_pagamento             AS CHARACTER
    FIELD val_sdo_tit_acr           LIKE tit_acr.val_sdo_tit_acr
    FIELD tot_val_titulo            AS DECIMAL
    FIELD tot_val_vencto            AS DECIMAL
    INDEX idx-reg3                  registro cod_estab num_id_tit_acr
    INDEX idx-reg4                  registro dat_emis_docto.

DEFINE BUFFER b_tit_acr       FOR tit_acr.
DEFINE BUFFER b_movto_tit_acr FOR movto_tit_acr.
DEFINE BUFFER bf-emitente     FOR emitente.
DEFINE BUFFER b_tit_acr_vd    FOR tit_acr.

DEFINE TEMP-TABLE tt-emitente-aux NO-UNDO LIKE emitente
    FIELD raiz-cnpj LIKE tt-emitente-supcard.raiz-cnpj
    FIELD r-rowid   AS ROWID.



/*--- Bloco Principal ---*/
ASSIGN cCodEmp       = "G7"
       iLoja         = 0038
       iFilial       = 0000
       iDtVencto     = 01
       iLinha        = 1
       iTotRegistros = 0
       iAux          = 0.


/* Busca o arquivo do Layout */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-retornar-arquivo-remessa IN h-esacr048 (INPUT  pLayout,
                                               OUTPUT cArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.



/* API para tratar o Endereáo */
IF  NOT VALID-HANDLE(hCdapi704) THEN
    RUN cdp/cdapi704.p PERSISTENT SET hCdapi704.


OUTPUT TO VALUE(cArquivo) CONVERT TARGET "iso8859-1".

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Exportando dados":U).


/**** HEADER ****/
PUT UNFORMATTED "0"                              + /* FIXO - Registro */
                STRING("SUPPLIERCARD", "x(20)")  +
                REPLACE(ISO-DATE(TODAY),"-", "") +
                REPLACE(STRING(TIME, "HH:MM:SS"), ":", "").

CASE pLayout:
    WHEN "8.1" THEN DO:
        PUT UNFORMATTED "2" /* FIXO - Retorno */.
    END.
    WHEN "8.10" THEN DO:
        PUT UNFORMATTED "3" /* FIXO - Retorno */.
    END.
END.

PUT UNFORMATTED "001"                    +
                STRING(cCodEmp, "x(02)") + /* Empresa - c¢digo no sistema SupplierCard */
                FILL(" ", 1153)          + /* FIXO - Filler */
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.


FOR EACH  tt-emitente-supcard NO-LOCK:
    EMPTY TEMP-TABLE tt_tit_acr.

    IF  CAN-FIND(FIRST tt-emitente-aux NO-LOCK
                 WHERE tt-emitente-aux.raiz-cnpj = tt-emitente-supcard.raiz-cnpj) THEN
        NEXT.

    /* Busca todas as empresas relacionadas a esta empresa (Matriz e filiais) */
    FOR EACH  emitente NO-LOCK
        WHERE emitente.nome-matriz = tt-emitente-supcard.nome-matriz:

        /**** VALIDAÄÂES ****/
        /* Valida se a Empresa Ç da mesma raiz de CNPJ */
        IF  SUBSTRING(emitente.cgc,1,8) <> tt-emitente-supcard.raiz-cnpj OR
            CAN-FIND(FIRST tt-emitente-aux NO-LOCK
                     WHERE tt-emitente-aux.cod-emitente = emitente.cod-emitente) THEN
            NEXT.

        /* Deve ser Pessoa Jur°fica e Cliente (ou ambos). N∆o pode ser fornecedor */
        IF  emitente.natureza <> 2 /* Pessoa Jur°dica */ OR
            emitente.identific = 2 /* Fornecedor */      THEN
            NEXT.

        /* S¢ busca os clientes ativos */
        FIND FIRST int-emitente NO-LOCK
            WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF  NOT AVAIL int-emitente OR
            NOT int-emitente.id-ativo THEN
            NEXT.

/*         IF  LOOKUP(STRING(int-emitente.cod-gr-cob, "99"), pGrCobranca) = 0 THEN */
/*             NEXT.                                                               */
        IF pGrCobranca                                                 <> "":U AND
           LOOKUP(STRING(int-emitente.cod-gr-cob, "99":U), pGrCobranca) = 0    THEN
            NEXT.
        /**** FIM - VALIDAÄÂES ****/


        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando cliente: " + STRING(emitente.cod-emitente) + " - " + emitente.nome-abrev).

        CREATE tt-emitente-aux.
        BUFFER-COPY emitente TO tt-emitente-aux.
        ASSIGN tt-emitente-aux.raiz-cnpj = tt-emitente-supcard.raiz-cnpj
               tt-emitente-aux.r-rowid   = ROWID(emitente).

        /* Busca as Informaá‰es dos T°tulos */
        ASSIGN dtIni = TODAY.

        ASSIGN dtFim = ADD-INTERVAL(dtIni, -1, "YEAR").
        FOR EACH  estabelec NO-LOCK,
            EACH  tit_acr NO-LOCK
            WHERE tit_acr.cod_empresa         = "1"
            AND   tit_acr.cod_estab           = estabelec.cod-estabel
            AND   tit_acr.cdn_cliente         = emitente.cod-emitente
            AND   tit_acr.dat_vencto_tit_acr <= dtIni
            AND   tit_acr.dat_vencto_tit_acr >= dtFim
            AND   tit_acr.ind_tip_espec_docto = "Normal"
            AND   tit_acr.log_tit_acr_estordo = NO
            BREAK BY tit_acr.dat_emis_docto:

            /* ** VD ser† tratada na leitura das VEs que foram debitadas, considerando o vencimento da VE e liquidaá∆o da VD ***/
            IF  tit_acr.cod_espec_docto = "VD" THEN
                NEXT.

            IF  tit_acr.cod_portador = "9905" /* Devoluá∆o       */ OR
                tit_acr.cod_portador = "9943" /* Verbas          */ OR
                tit_acr.cod_portador = "9996" /* Vendor Ö fechar */ THEN
                NEXT.

            ASSIGN lCriou = NO.
            FOR EACH  movto_tit_acr NO-LOCK
                WHERE movto_tit_acr.cod_estab      = tit_acr.cod_estab
                AND   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:

                FOR EACH  relacto_tit_acr NO-LOCK
                    WHERE relacto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
                    AND   relacto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr:

                    FIND FIRST b_tit_acr NO-LOCK
                        WHERE  b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                        AND    b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr NO-ERROR.
                    IF  AVAIL  b_tit_acr                     AND 
                        b_tit_acr.cod_espec_docto     = 've' AND
                        b_tit_acr.log_tit_acr_estordo = NO   THEN DO:

                         FIND parc_vendor OF b_tit_acr NO-LOCK NO-ERROR.
                         IF  parc_vendor.ind_sit_parc_vendor = "Debitada" THEN DO:
                             FIND b_tit_acr_vd NO-LOCK
                                 WHERE b_tit_acr_vd.cod_estab        = b_tit_acr.cod_estab
                                   AND b_tit_acr_vd.cod_espec        = "VD"
                                   AND b_tit_acr_vd.cod_ser          = b_tit_acr.cod_ser
                                   AND b_tit_acr_vd.cod_tit_acr      = b_tit_acr.cod_tit_acr
                                   AND b_tit_acr_vd.cod_parcela      = b_tit_acr.cod_parcela
                                   AND b_tit_acr.log_tit_acr_estordo = NO NO-ERROR.
                             IF  AVAIL b_tit_acr_vd THEN
                                 RUN pi-grava-tt-tit-acr IN THIS-PROCEDURE (BUFFER b_tit_acr_vd).
                         END.
                         ELSE 
                            RUN pi-grava-tt-tit-acr IN THIS-PROCEDURE (BUFFER b_tit_acr).

                         ASSIGN lCriou = YES.

                    END.
                END. 
            END.

            IF CAN-FIND (FIRST movto_tit_acr NO-LOCK
                         WHERE movto_tit_acr.cod_estab           = tit_acr.cod_estab
                         AND   movto_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr
                         AND  (movto_tit_acr.ind_trans_acr_abrev = "LQRN" OR
                               movto_tit_acr.ind_trans_acr_abrev = "LQTE" OR
                               movto_tit_acr.ind_trans_acr_abrev = "AVCR")
                         AND   movto_tit_acr.log_movto_estordo   = NO) THEN
                NEXT.

            IF CAN-FIND (FIRST movto_tit_acr NO-LOCK
                         WHERE movto_tit_acr.cod_estab           = tit_acr.cod_estab
                         AND   movto_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr
                         AND   movto_tit_acr.ind_trans_acr_abrev = "TRES"
                         AND   movto_tit_acr.log_movto_estordo   = NO
                         AND   movto_tit_acr.cod_cart_bcia       = "60") THEN
                NEXT.

            IF  NOT lCriou THEN DO:
                RUN pi-grava-tt-tit-acr IN THIS-PROCEDURE (BUFFER tit_acr).
            END.
        END.
    END.



    /* Exporta os dados das empresas para o arquivo */
    FOR EACH  tt-emitente-aux NO-LOCK
        WHERE tt-emitente-aux.raiz-cnpj = tt-emitente-supcard.raiz-cnpj:

        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Exportando cliente: " + STRING(tt-emitente-aux.cod-emitente) + " - " + tt-emitente-aux.nome-abrev).

        IF  VALID-HANDLE(hCdapi704) THEN
            RUN pi-trata-endereco IN hCdapi704 (INPUT  tt-emitente-aux.endereco-cob,
                                                OUTPUT cRua,
                                                OUTPUT cNro,
                                                OUTPUT cComp).
        ELSE
            ASSIGN cRua  = ""
                   cNro  = ""
                   cComp = "".

        /**** DETALHE 1 (Dados PJ - Empresa) ****/
        ASSIGN iTotRegistros = iTotRegistros + 1.
        PUT UNFORMATTED "1"                                                        + /* FIXO - Registro */
                        STRING(tt-emitente-aux.cgc, "x(14)")                       +
                        STRING(iLoja, "9999")                                      + /* Loja  - C¢digo da Loja, ser† fornecido ap¢s cadastro do Estabelecimento na SupplierCard */
                        STRING(iFilial, "9999")                                    + /* Filia - C¢digo da Filial, ser† fornecido ap¢s cadastro do Estabelecimento na SupplierCard */
                        STRING(iDtVencto, "99")                                    + /* Dia Vencimento - Dia de Vencimento, ser† fornecido ap¢s cadastro do Estabelecimento na SupplierCard */
                        "5"                                                        +
                        STRING(tt-emitente-aux.nome-emit, "x(40)")                 +
                        STRING(tt-emitente-aux.nome-emit, "x(40)")                 +
                        STRING(tt-emitente-aux.ins-municipal, "x(20)")             +
                        STRING(tt-emitente-aux.ins-estadual , "x(20)")             +
                        "00000"                                                    +
                        "19000101"                                                 +
                        "420" /*420 - Industria*/                                  + /* Atividade Juridica - Conforme tabela de dom°nio "Atividade Jur°dica" */
                        "06"  /*06  - Sociedade Anonima*/                          + /* Tipo de Sociedade  - Conforme tabela de dom°nio "Tipo de Sociedade" */
                        "1"                                                        +
                        STRING(cRua, "x(40)")                                      +
                        STRING(cNro, "x(5)")                                       +
                        STRING(cComp, "x(15)")                                     +
                        STRING(tt-emitente-aux.bairro-cob, "x(20)")                +
                        STRING(tt-emitente-aux.cep-cob, "x(8)")                    +
                        STRING(tt-emitente-aux.cidade-cob, "x(20)")                +
                        STRING(tt-emitente-aux.estado-cob, "x(2)")                 +
                        "0100"                                                     +
                        STRING(tt-emitente-aux.contato[1], "x(40)")                +
                        STRING(SUBSTRING(tt-emitente-aux.telefone[1],1,2), "9999") +
                        STRING(tt-emitente-aux.telefone[1], "x(15)")               +
                        STRING(tt-emitente-aux.ramal[1], "x(5)")                   +
                        "0"                                                        +
                        FILL(" ", 40)                                              +
                        STRING(cRua, "x(40)")                                      +
                        STRING(cNro, "x(5)")                                       +
                        STRING(cComp, "x(15)")                                     +
                        STRING(tt-emitente-aux.bairro-cob, "x(20)")                +
                        STRING(tt-emitente-aux.cep-cob, "x(8)")                    +
                        STRING(tt-emitente-aux.cidade-cob, "x(20)")                +
                        STRING(tt-emitente-aux.estado-cob, "x(2)")                 +
                        "0"                                                        + /* FIXO - Tipo Endereáo */
                        "00000010000"                                              + /* 11pos - Faturamento Mensal */
                        FILL(" ", 40)                                              + /* 40pos - Nome Contador */
                        FILL(" ", 4)                                               + /* 4pos  - DDD Contador */
                        FILL(" ", 15)                                              + /* 15pos - Telefone contador */
                        STRING(REPLACE(REPLACE(tt-emitente-aux.e-mail, CHR(10), ""), CHR(13), ""), "x(40)").

        /* Referàncias Banc†rias - Ser∆o informadas duas referàncias */
        FIND FIRST mgcad.banco NO-LOCK
            WHERE  banco.cod-banco = tt-emitente-aux.cod-banco NO-ERROR.
        ASSIGN cNomeBanco = IF AVAIL banco THEN banco.nome-banco ELSE "".

        PUT UNFORMATTED STRING(cNomeBanco, "x(40)")                    +
                        STRING(tt-emitente-aux.agencia, "x(10)")       +
                        STRING(tt-emitente-aux.conta-corren, "x(14)")  +
                        FILL(" ", 24)                                  + /* DDD + Telefone + Ramal */
                        STRING(cNomeBanco, "x(40)")                    +
                        STRING(tt-emitente-aux.agencia, "x(10)")       +
                        STRING(tt-emitente-aux.conta-corren, "x(14)")  +
                        FILL(" ", 24).                                   /* DDD + Telefone + Ramal */

        /* Referàncias Comerciais - N∆o ser† enviado */
        PUT UNFORMATTED FILL(" ", 208).

        /* O Limite de CrÇdito do Cliente Ç o Limite de CrÇdito da sua Matriz
        FIND FIRST bf-emitente NO-LOCK
            WHERE  bf-emitente.nome-abrev = tt-emitente-aux.nome-matriz NO-ERROR.
        ASSIGN deLimCredito = IF AVAIL bf-emitente THEN bf-emitente.lim-credito ELSE tt-emitente-aux.lim-credito. */

        /* Passa a enviar novos clientes com o limite sugerido - chamado 122795 */
        ASSIGN deLimCredito = tt-emitente-supcard.val-limite-sugerido.

        PUT UNFORMATTED "0"                                                                                                           + /* FIXO - Negativa Avalista */
                        STRING(MONTH(tt-emitente-aux.data-implant), "99") + SUBSTRING(STRING(YEAR(tt-emitente-aux.data-implant)),3,2) + /* Cliente desde */
                        "03"                                                                                                          +
                        REPLACE(STRING(deLimCredito, "999999999.99"), ",", "").                                                         /* Limite Praticado */

        CASE pLayout:
            WHEN "8.1" THEN DO:
                PUT UNFORMATTED FILL(" ", 15). /* FIXO - Filler */

                ASSIGN cDescClasse = "0000".
                FIND LAST int-emitente-supcard NO-LOCK
                    WHERE int-emitente-supcard.raiz-cnpj = tt-emitente-aux.raiz-cnpj NO-ERROR.
                IF  AVAIL int-emitente-supcard THEN DO:
                    FIND LAST int-classe-cli-supcard NO-LOCK
                        WHERE  int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-ERROR.
                    IF  AVAIL  int-classe-cli-supcard THEN
                        ASSIGN cDescClasse = int-classe-cli-supcard.des-classe.
                END.
                
                PUT UNFORMATTED STRING(cDescClasse, "x(04)")                                                              + /* Tipo de Cliente */
                                STRING(REPLACE(REPLACE(tt-emitente-aux.observacoes, CHR(10), ""), CHR(13), ""), "x(100)") + 
                                FILL(" ", 15)                                                                             + /* C¢digo do Vendedor */
                                STRING("fabiano.henke@intelbras.com.br", "x(50)").                                           /* E-mail para Resposta */
            END.
            WHEN "8.10" THEN DO:
                PUT UNFORMATTED REPLACE(STRING(tt-emitente-supcard.val-limite-sugerido, "999999999.99"), ",","")   + /* Limite Sugerido */
                                FILL(" ",100)                                                                      + /* Observaá∆o */
                                FILL(" ", 15)                                                                      + /* C¢digo do Vendedor */
                                STRING("fabiano.henke@intelbras.com.br", "x(50)")                                  + /* E-mail para Resposta */
                                FILL(" ", 08).
            END.
        END.

        PUT UNFORMATTED STRING(tt-emitente-supcard.tipo-solicitacao, "9") +
                        FILL(" ", 2)                                      + /* FIXO - Filler */
                        STRING(iLinha, "999999").


        PUT UNFORMATTED SKIP.
        ASSIGN iLinha = iLinha + 1.



        /**** DETALHE 2 (Dados Avalista/Socios) - Os dados ser∆o replicados da Empresa, pois n∆o tem s¢cios ****/
        ASSIGN iTotRegistros = iTotRegistros + 1.
        PUT UNFORMATTED "2"                                                         + /* FIXO - Registro */
                        STRING(tt-emitente-aux.cgc, "x(14)")                        +
                        "6"                                                         + /* FIXO - Tipo de Pessoa */
                        STRING(tt-emitente-aux.cgc, "x(14)")                        +
                        STRING(tt-emitente-aux.nome-emit, "x(40)")                  +
                        STRING(tt-emitente-aux.nome-emit, "x(40)")                  +
                        "19000101"                                                  +
                        "M"                                                         +
                        STRING(tt-emitente-aux.ins-municipal, "x(20)")              +
                        STRING(tt-emitente-aux.ins-estadual , "x(20)")              +
                        FILL(" ", 17)                                               +
                        "19000101"                                                  +
                        FILL(" ", 42)                                               +
                        STRING(SUBSTRING(tt-emitente-aux.telefone[1],1,2), "9999")  +
                        STRING(SUBSTRING(tt-emitente-aux.telefone[1],3,8), "x(15)") +
                        STRING(cRua, "x(40)")                                       +
                        STRING(cNro, "x(5)")                                        +
                        STRING(cComp, "x(15)")                                      +
                        STRING(tt-emitente-aux.bairro-cob, "x(20)")                 +
                        STRING(tt-emitente-aux.cep-cob, "x(8)")                     +
                        STRING(tt-emitente-aux.cidade-cob, "x(20)")                 +
                        STRING(tt-emitente-aux.estado-cob, "x(2)")                  +
                        "0100"                                                      +
                        FILL(" ", 835)                                              +
                        STRING(iLinha, "999999").


        PUT UNFORMATTED SKIP.
        ASSIGN iLinha = iLinha + 1.



        FOR EACH tt_tit_acr USE-INDEX idx-reg4 NO-LOCK:
            /**** DETALHE 3 (Dados de Hist¢rico de Cliente) ****/
            IF  tt_tit_acr.registro = 3 THEN DO:
                ASSIGN iTotRegistros = iTotRegistros + 1.
                PUT UNFORMATTED "3"                                                                          + /* FIXO - Registro */
                                STRING(tt-emitente-aux.cgc, "x(14)")                                         +
                                REPLACE(ISO-DATE(tt_tit_acr.dat_vencto_origin_tit_acr), "-", "")             +
                                REPLACE(STRING(DEC(tt_tit_acr.val_origin_tit_acr), "999999999.99"), ",", "") +
                                REPLACE(tt_tit_acr.dat_liquidac_tit_acr, "-", "")                            +
                                REPLACE(STRING(DEC(tt_tit_acr.val_pagamento), "999999999.99"), ",", "")      +
                                "1"                                                                          + /* FIXO - Tipo de Liquidaá∆o */
                                REPLACE(ISO-DATE(tt_tit_acr.dat_emis_docto), "-", "")                        +
                                FILL(" ", 1132)                                                              +
                                STRING(iLinha, "999999").
        
                PUT UNFORMATTED SKIP.
                ASSIGN iLinha = iLinha + 1.
            END.
            /**** DETALHE 4 (Fluxo de Caixa Cliente) ****/
            ELSE DO:
                ASSIGN iTotRegistros = iTotRegistros + 1.
                PUT UNFORMATTED "4"                                                                 + /* FIXO - Registro */
                                STRING(tt-emitente-aux.cgc, "x(14)")                                +
                                REPLACE(ISO-DATE(tt_tit_acr.dat_emis_docto), "-", "")               +
                                REPLACE(STRING(tt_tit_acr.tot_val_titulo, "999999999.99"), ",", "") +
                                REPLACE(ISO-DATE(tt_tit_acr.dat_vencto_tit_acr), "-", "")           +
                                REPLACE(STRING(tt_tit_acr.tot_val_vencto, "999999999.99"), ",", "") +
                                FILL(" ", 1141)                                                     +
                                STRING(iLinha, "999999").
        
                PUT UNFORMATTED SKIP.
                ASSIGN iLinha = iLinha + 1.
            END.
        END.


        /*/* Cria a temp-table de auxilio, para n∆o exportar mais de uma vez o mesmo cliente */
        CREATE tt-emitente-aux.
        ASSIGN tt-emitente-aux.cod-emitente = tt-emitente-aux.cod-tt-emitente-aux.*/

        /* Cria os registros dentro das Tabelas de Controle */
        RUN pi-cria-registro-supcard IN THIS-PROCEDURE.
    END.

END.


/**** TRAILLER ****/
PUT UNFORMATTED "9"                             + /* FIXO - Registro */
                STRING(iTotRegistros, "999999") + /* Total de Registros - Menos Header e Trailler */
                FILL(" ", 1187)                 +
                STRING(iLinha, "999999").

PUT UNFORMATTED SKIP.
ASSIGN iLinha = iLinha + 1.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

OUTPUT CLOSE.

IF  VALID-HANDLE(hCdapi704) THEN DO:
    DELETE PROCEDURE hCdapi704.
    ASSIGN hCdapi704 = ?.
END.


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

RETURN "OK":U.



/*--- Procedures Internas ---*/
PROCEDURE pi-grava-tt-tit-acr:
    DEFINE PARAMETER BUFFER bf FOR tit_acr.

    FIND FIRST mgcad.empresa NO-LOCK
        WHERE  empresa.ep-codigo = bf.cod_empresa NO-ERROR.
    ASSIGN cCGCEmpresa = IF AVAIL empresa THEN empresa.cgc ELSE "".

    /* Informaá‰es para o DETALHE 3 */
    IF  NOT CAN-FIND(FIRST tt_tit_acr NO-LOCK
                     WHERE tt_tit_acr.cod_estab      = bf.cod_estab
                     AND   tt_tit_acr.num_id_tit_acr = bf.num_id_tit_acr) THEN DO:
        CREATE tt_tit_acr.
        ASSIGN tt_tit_acr.registro                  = 3
               tt_tit_acr.cod_estab                 = bf.cod_estab
               tt_tit_acr.num_id_tit_acr            = bf.num_id_tit_acr
               tt_tit_acr.dat_emis_docto            = bf.dat_emis_docto
               tt_tit_acr.cgc_empresa               = cCGCEmpresa
               tt_tit_acr.dat_vencto_origin_tit_acr = bf.dat_vencto_tit_acr
               tt_tit_acr.val_origin_tit_acr        = STRING(bf.val_origin_tit_acr + bf.val_transf_estab).

        IF  bf.dat_liquidac_tit_acr     <> 12/31/9999                  
        AND bf.dat_ult_liquidac_tit_acr <> 12/31/9999                  
        AND bf.dat_liquidac_tit_acr     <> bf.dat_ult_liquidac_tit_acr 
        AND bf.val_sdo_tit_acr           = 0                            
            THEN ASSIGN tt_tit_acr.dat_liquidac_tit_acr = STRING(ISO-DATE(bf.dat_ult_liquidac_tit_acr)).
            ELSE ASSIGN tt_tit_acr.dat_liquidac_tit_acr = STRING(ISO-DATE(bf.dat_liquidac_tit_acr)).

        IF  bf.log_sdo_tit_acr              = NO
        AND tt_tit_acr.dat_liquidac_tit_acr = "9999-12-31" 
            THEN ASSIGN tt_tit_acr.dat_liquidac_tit_acr = STRING(ISO-DATE(bf.dat_vencto_tit_acr)).

        /* Se pagou com atraso, calcula Juros e Multa. Sen∆o calcula o valor pago */
        IF  bf.dat_liquidac_tit_acr > bf.dat_vencto_tit_acr THEN
            ASSIGN tt_tit_acr.val_pagamento = STRING(((bf.val_origin_tit_acr + bf.val_transf_estab) - bf.val_sdo_tit_acr) + (bf.val_juros + bf.val_multa_tit_acr)).
        ELSE
            ASSIGN tt_tit_acr.val_pagamento = STRING((bf.val_origin_tit_acr + bf.val_transf_estab) - bf.val_sdo_tit_acr).

        IF  tt_tit_acr.dat_liquidac_tit_acr = "9999-12-31" THEN
            ASSIGN tt_tit_acr.dat_liquidac_tit_acr = FILL(" ", 8)
                   tt_tit_acr.val_pagamento        = "0".
    END.

    /* Informaá‰es para o DETALHE 4 */
    FIND FIRST tt_tit_acr EXCLUSIVE-LOCK
        WHERE  tt_tit_acr.registro = 4
        AND    tt_tit_acr.dat_emis_docto = bf.dat_emis_docto NO-ERROR.
    IF  NOT AVAIL tt_tit_acr THEN DO:
        CREATE tt_tit_acr.
        ASSIGN tt_tit_acr.registro           = 4
               tt_tit_acr.dat_emis_docto     = bf.dat_emis_docto
               tt_tit_acr.cgc_empresa        = cCGCEmpresa
               tt_tit_acr.dat_vencto_tit_acr = bf.dat_emis_docto.
    END.
    
    ASSIGN tt_tit_acr.tot_val_titulo = tt_tit_acr.tot_val_titulo + (bf.val_origin_tit_acr + bf.val_transf_estab)
           tt_tit_acr.tot_val_vencto = tt_tit_acr.tot_val_vencto + 0.


    FIND FIRST tt_tit_acr EXCLUSIVE-LOCK
        WHERE  tt_tit_acr.registro = 4
        AND    tt_tit_acr.dat_vencto_tit_acr = bf.dat_vencto_tit_acr NO-ERROR.
    IF  NOT AVAIL tt_tit_acr THEN DO:
        CREATE tt_tit_acr.
        ASSIGN tt_tit_acr.registro           = 4
               tt_tit_acr.dat_emis_docto     = bf.dat_vencto_tit_acr
               tt_tit_acr.cgc_empresa        = cCGCEmpresa
               tt_tit_acr.dat_vencto_tit_acr = bf.dat_vencto_tit_acr.
    END.
    
    ASSIGN tt_tit_acr.tot_val_titulo = tt_tit_acr.tot_val_titulo + 0
           tt_tit_acr.tot_val_vencto = tt_tit_acr.tot_val_vencto + (bf.val_origin_tit_acr + bf.val_transf_estab).

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-cria-registro-supcard:
    DEFINE VARIABLE c-raiz-cnpj         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq               AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.

    ASSIGN c-raiz-cnpj = tt-emitente-supcard.raiz-cnpj.

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

    IF  NOT CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                     WHERE int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
                     AND   int-emitente-supcard.dat-avaliacao = TODAY) THEN DO:
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
           int-emitente-supcard-ocor.ind-ocor             = pLayout
           int-emitente-supcard-ocor.log-habilitado       = NO
           int-emitente-supcard-ocor.val-limite           = 0
           int-emitente-supcard-ocor.val-limite-utilizado = 0
           int-emitente-supcard-ocor.val-limite-sugerido  = tt-emitente-supcard.val-limite-sugerido
           int-emitente-supcard-ocor.cod-usuar            = c-seg-usuario
           int-emitente-supcard-ocor.log-emergencial      = IF tt-emitente-supcard.tipo-solicitacao = 1 THEN YES ELSE NO
           int-emitente-supcard-ocor.qtd-dias-atraso      = 0
           int-emitente-supcard-ocor.cod-motivo           = 0
           int-emitente-supcard-ocor.nom-arquivo          = ENTRY(NUM-ENTRIES(cArquivo,"/"),cArquivo,"/").

    RETURN "OK":U.
END PROCEDURE.
