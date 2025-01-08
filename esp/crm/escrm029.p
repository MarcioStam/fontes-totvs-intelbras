/*********************************************************************************
** Programa: esp/crm/escrm029.p
** VersÆo..: 1.00
** Data....: 25/11/2010
** Autor...: Cenci
** Obs.....: API para buscar as Tabelas de Pre‡os cadastradas para o cliente, e
**           retornar ao Portal B2B
*********************************************************************************/
{cdp/cd0666.i} /* Defini‡Æo temp-table "tt-erro" */

def new global shared var v_cod_usuar_corren    AS CHAR FORMAT "x(12)" NO-UNDO.

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-tb-preco NO-UNDO
    FIELD nr-tabpre        LIKE tb-preco.nr-tabpre
    FIELD ds-descricao     AS CHARACTER FORMAT "x(30)":U
    FIELD cod-rep          LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-categoria     LIKE crm-relacionamento-cliente.cd-categoria
    FIELD ds-categoria     LIKE crm-categoria.ds-categoria
    FIELD cd-unid-negoc    AS CHARACTER
    FIELD cod-cond-pag     LIKE cond-pagto.cod-cond-pag
    FIELD cod-gr-cli       LIKE emitente.cod-gr-cli
    FIELD ds-gr-cli        LIKE gr-cli.descricao
    FIELD lg-tb-especifica AS INTEGER.


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-cod-cliente             AS INTEGER     NO-UNDO FORMAT ">>>>>>>>9":U.
DEFINE OUTPUT PARAMETER TABLE FOR tt-tb-preco.
DEFINE OUTPUT PARAMETER p-val-lim-total-supcard   AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER p-val-lim-dispo-supcard   AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER p-val-lim-total-intelbras AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER p-val-lim-dispo-intelbras AS DECIMAL     NO-UNDO.


/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE l-log AS LOGICAL     NO-UNDO.

DEFINE VARIABLE h-esapi001            AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-vl-lim-tot-supcard AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-aloc-pedido    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-comp-nfs       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-usuario             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-vl-aberto               AS DECIMAL     NO-UNDO.

DEFINE BUFFER bf-emitente FOR emitente.
DEFINE BUFFER bmovto_tit_acr_perdas for movto_tit_acr.
/*--- Bloco Principal ---*/
ASSIGN l-log = NO.


/******************** Log de Execu‡Æo da API *********************/
IF l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP
                    "Inicio API BuscaTabelas -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:"
                    " - C¢d Cliente.: " p-cod-cliente SKIP
                    "Codigo Usuario : " v_cod_usuar_corren SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/


FIND FIRST ponto-programa NO-LOCK
    WHERE  ponto-programa.nome-programa = "escrm004":U
    AND    ponto-programa.ponto         = 1 NO-ERROR.
IF  AVAIL  ponto-programa THEN DO:
    FOR EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF conteudo-programa.sequencia = 1 THEN DO:
            ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.
IF v_cod_usuar_corren = "" OR
   v_cod_usuar_corren = c-usuario THEN
/* Login no EMS */
   RUN bi/esbi002.p (INPUT c-usuario,
                     INPUT c-senha).


FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = p-cod-cliente NO-ERROR.

IF  NOT AVAIL emitente THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Cliente (" + STRING(p-cod-cliente) + ") nÆo foi encontrado!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
END.

FIND FIRST gr-cli NO-LOCK
    WHERE  gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.
IF  NOT AVAIL gr-cli THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Grupo de Cliente (" + STRING(emitente.cod-gr-cli) + ") nÆo foi encontrado!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
END.

/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "API est  valida? " VALID-HANDLE(h-esapi001) SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/

IF  NOT VALID-HANDLE(h-esapi001) THEN
    RUN esp/esapi001.p PERSISTENT SET h-esapi001.

IF VALID-HANDLE(h-esapi001) THEN
    RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                          OUTPUT p-val-lim-total-supcard,
                                          OUTPUT de-vl-lim-tot-supcard,
                                          OUTPUT de-val-aloc-pedido,
                                          OUTPUT de-val-comp-nfs,
                                          OUTPUT p-val-lim-dispo-supcard).


/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "Retorno da API: " RETURN-VALUE SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/

IF  RETURN-VALUE = "NOK":U THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF l-log THEN DO:
        IF VALID-HANDLE(h-esapi001) THEN
            RUN pi-retorna-mensagem IN h-esapi001 (OUTPUT TABLE tt-erro).

        FOR EACH tt-erro:
            IF OPSYS = "WIN32":U THEN
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            ELSE
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.

            PUT UNFORMATTED tt-erro.mensagem SKIP.
            OUTPUT CLOSE.
        END.
    END.
    /*****************************************************************/
    DELETE PROCEDURE h-esapi001.
    ASSIGN h-esapi001 = ?.
END.

/* O limite de cr‚dito fica gravado na Matriz do cliente */
FIND FIRST bf-emitente NO-LOCK
    WHERE  bf-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.
ASSIGN p-val-lim-total-intelbras = IF AVAIL bf-emitente THEN bf-emitente.lim-credito ELSE emitente.lim-credito.

RUN pi-lim-disp-intelbras IN THIS-PROCEDURE (INPUT  p-cod-cliente,
                                             OUTPUT p-val-lim-dispo-intelbras).

ASSIGN p-val-lim-dispo-intelbras = p-val-lim-total-intelbras - p-val-lim-dispo-intelbras.
IF p-val-lim-dispo-intelbras < 0 THEN DO:
    ASSIGN p-val-lim-dispo-intelbras = 0.
END.

FOR EACH  crm-relacionamento-cliente NO-LOCK
    WHERE crm-relacionamento-cliente.cod-emitente = p-cod-cliente
    AND  (IF crm-relacionamento-cliente.dt-vigencia-fim <> ? THEN crm-relacionamento-cliente.dt-vigencia-fim > TODAY ELSE YES):

    FOR EACH  crm-un-cli-tb-preco NO-LOCK
        WHERE crm-un-cli-tb-preco.cd-unid-negoc    = crm-relacionamento-cliente.cd-unid-negoc
        AND   crm-un-cli-tb-preco.cod-emitente     = crm-relacionamento-cliente.cod-emitente
        AND   crm-un-cli-tb-preco.dt-vigencia-ini <= TODAY
        AND  (IF crm-un-cli-tb-preco.dt-vigencia-fim <> ? THEN crm-un-cli-tb-preco.dt-vigencia-fim > TODAY ELSE YES):

        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = crm-un-cli-tb-preco.cod-emitente NO-ERROR.

/*         IF  AVAIL int-emitente                                                                                                                          */
/* /*         AND int-emitente.ind-participa-canais = 993520001 /*Participa canais*/  */                                                                   */
/*         AND crm-un-cli-tb-preco.nr-tabpre <> "lai02"                                                                                                    */
/*         AND crm-un-cli-tb-preco.nr-tabpre <> "astec02" THEN DO:                                                                                         */
/*             IF l-log THEN DO:                                                                                                                           */
/*                 IF OPSYS = "WIN32":U THEN                                                                                                               */
/*                     OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.                                                    */
/*                 ELSE                                                                                                                                    */
/*                     OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.                                                    */
/*                                                                                                                                                         */
/*                 PUT UNFORMATTED "Cliente (" + STRING(p-cod-cliente) + ") participante do programa de canais, utilize as tabelas astec02 ou lai02" SKIP. */
/*                 OUTPUT CLOSE.                                                                                                                           */
/*             END.                                                                                                                                        */
/*                                                                                                                                                         */
/*             NEXT.                                                                                                                                       */
/*         END.                                                                                                                                            */

        FIND FIRST unid-comerc NO-LOCK
            WHERE  unid-comerc.cd-unid-comerc = INT(crm-relacionamento-cliente.cd-unid-negoc) NO-ERROR.

        FIND tt-tb-preco NO-LOCK
            WHERE tt-tb-preco.nr-tabpre     = crm-un-cli-tb-preco.nr-tabpre
            AND   tt-tb-preco.cd-unid-negoc = unid-comerc.ds-unid-comerc
            AND   tt-tb-preco.cod-rep       = crm-relacionamento-cliente.cod-rep NO-ERROR.
        IF  NOT AVAIL tt-tb-preco THEN DO:
            FIND tb-preco NO-LOCK
                WHERE tb-preco.nr-tabpre = crm-un-cli-tb-preco.nr-tabpre NO-ERROR.

            FIND FIRST crm-categoria NO-LOCK
                WHERE  crm-categoria.cd-categoria = crm-relacionamento-cliente.cd-categoria NO-ERROR.

            /******************** Log de Execu‡Æo da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Tabela de Pre‡o por Cliente (espec¡fica): " + STRING(crm-un-cli-tb-preco.nr-tabpre) + " - " + tb-preco.descricao SKIP
                                " - C¢d Categoria: " + STRING(crm-relacionamento-cliente.cd-categoria) SKIP
                                " - Des Categoria: " IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "inv lida" SKIP
                                " - Unid Neg¢cio: " unid-comerc.ds-unid-comerc SKIP
                                " - Representante: " + STRING(crm-relacionamento-cliente.cod-rep) SKIP
                                " - Cond Pagto: " + STRING(crm-un-cli-tb-preco.cod-cond-pag) SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/

            CREATE tt-tb-preco.
            ASSIGN tt-tb-preco.nr-tabpre        = crm-un-cli-tb-preco.nr-tabpre
                   tt-tb-preco.ds-descricao     = tb-preco.descricao
                   tt-tb-preco.cd-categoria     = crm-relacionamento-cliente.cd-categoria
                   tt-tb-preco.ds-categoria     = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE ""
                   tt-tb-preco.cd-unid-negoc    = unid-comerc.ds-unid-comerc
                   tt-tb-preco.cod-rep          = crm-relacionamento-cliente.cod-rep
                   tt-tb-preco.cod-cond-pag     = crm-un-cli-tb-preco.cod-cond-pag
                   tt-tb-preco.cod-gr-cli       = emitente.cod-gr-cli
                   tt-tb-preco.ds-gr-cli        = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                   tt-tb-preco.lg-tb-especifica = 1.
        END.
    END.
    
    FOR EACH  crm-un-tb-preco NO-LOCK
        WHERE crm-un-tb-preco.cd-unid-negoc    = crm-relacionamento-cliente.cd-unid-negoc
        AND   crm-un-tb-preco.dt-vigencia-ini <= TODAY
        AND  (IF crm-un-tb-preco.dt-vigencia-fim <> ? THEN crm-un-tb-preco.dt-vigencia-fim > TODAY ELSE YES):

        FIND FIRST unid-comerc NO-LOCK
            WHERE  unid-comerc.cd-unid-comerc = INT(crm-relacionamento-cliente.cd-unid-negoc) NO-ERROR.

        FIND tt-tb-preco NO-LOCK
            WHERE tt-tb-preco.nr-tabpre     = crm-un-tb-preco.nr-tabpre
            AND   tt-tb-preco.cd-unid-negoc = unid-comerc.ds-unid-comerc
            AND   tt-tb-preco.cod-rep       = crm-relacionamento-cliente.cod-rep NO-ERROR.
        IF  NOT AVAIL tt-tb-preco THEN DO:
            FIND tb-preco NO-LOCK
                WHERE tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre NO-ERROR.

            FIND FIRST crm-categoria NO-LOCK
                WHERE  crm-categoria.cd-categoria = crm-relacionamento-cliente.cd-categoria NO-ERROR.

            /******************** Log de Execu‡Æo da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Tabela de Pre‡o por Unidade de Neg¢cio (gen‚rica): " + STRING(crm-un-tb-preco.nr-tabpre) + " - " + tb-preco.descricao SKIP
                                " - C¢d Categoria: " + STRING(crm-relacionamento-cliente.cd-categoria) SKIP
                                " - Des Categoria: " IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "inv lida" SKIP
                                " - Unid Neg¢cio: " unid-comerc.ds-unid-comerc SKIP
                                " - Representante: " + STRING(crm-relacionamento-cliente.cod-rep) SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/

            CREATE tt-tb-preco.
            ASSIGN tt-tb-preco.nr-tabpre        = crm-un-tb-preco.nr-tabpre
                   tt-tb-preco.ds-descricao     = tb-preco.descricao
                   tt-tb-preco.cd-categoria     = crm-relacionamento-cliente.cd-categoria
                   tt-tb-preco.ds-categoria     = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE ""
                   tt-tb-preco.cd-unid-negoc    = unid-comerc.ds-unid-comerc
                   tt-tb-preco.cod-rep          = crm-relacionamento-cliente.cod-rep
                   tt-tb-preco.cod-cond-pag     = 0
                   tt-tb-preco.cod-gr-cli       = emitente.cod-gr-cli
                   tt-tb-preco.ds-gr-cli        = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                   tt-tb-preco.lg-tb-especifica = 0.
        END.
    END.
END.


/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "Parƒmetros retornados:" SKIP
                    " - p-val-lim-total-supcard:   " p-val-lim-total-supcard   SKIP
                    " - p-val-lim-dispo-supcard:   " p-val-lim-dispo-supcard   SKIP
                    " - p-val-lim-total-intelbras: " p-val-lim-total-intelbras SKIP
                    " - p-val-lim-dispo-intelbras: " p-val-lim-dispo-intelbras SKIP.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
    OUTPUT CLOSE.
END.
/*****************************************************************/

    
DELETE WIDGET-POOL.
RETURN "OK":U.


PROCEDURE pi-lim-disp-intelbras:
    DEFINE INPUT  PARAMETER p-cod-cliente        AS INTEGER     NO-UNDO FORMAT ">>>>>>>>9":U.
    DEFINE OUTPUT PARAMETER p-lim-disp-intelbras AS DEC NO-UNDO INITIAL 0.

    DEFINE VARIABLE de-fator AS DECIMAL     NO-UNDO FORMAT "999999,9999":U INITIAL 1.

    ASSIGN p-lim-disp-intelbras = 0.

   
    FOR EACH  bf-emitente NO-LOCK
        WHERE bf-emitente.nome-matriz = emitente.nome-matriz:
        for each estabelecimento no-lock:
          /** Ignora t¡tulos da Nova e da Maxcom **/
          if (estabelecimento.cod_estab = '201') or (estabelecimento.cod_estab = '301') then
             next.
            FOR EACH tit_acr USE-INDEX titacr_cliente NO-LOCK
                where tit_acr.cod_estab           = estabelecimento.cod_estab
                  and tit_acr.cdn_cliente         = bf-emitente.cod-emitente
                  AND tit_acr.val_sdo_tit_acr     > 0
                  AND tit_acr.log_tit_acr_estordo = NO:
                if can-find (first bmovto_tit_acr_perdas
                                where bmovto_tit_acr_perdas.cod_estab           = tit_acr.cod_estab
                                  and bmovto_tit_acr_perdas.num_id_tit_acr      = tit_acr.num_id_tit_acr
                                  and bmovto_tit_acr_perdas.ind_trans_acr_abrev = "LQPD"
                                  and bmovto_tit_acr_perdas.log_movto_estordo   = no) then
                   next.
    
                /******************** Log de Execu‡Æo da API *********************/
                IF  l-log THEN DO:
                    IF  OPSYS = "WIN32":U THEN DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    ELSE DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    PUT UNFORMATTED "Leitura titulos 1-> " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP
                                    "Parƒmetros retornados:" SKIP
                                    " emitente.nome-matriz:   " emitente.nome-matriz  SKIP
                                    " - bf-emitente.cod-emitente:   " bf-emitente.cod-emitente   SKIP
                                    " p-lim-disp-intelbras " p-lim-disp-intelbras SKIP
                                    "tit_acr.cod_tit_acr " tit_acr.cod_tit_acr SKIP.
                    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
                    OUTPUT CLOSE.
                END.
                /*****************************************************************/
        
                /* T¡tulos transferidos para o 102 e 103 */
                IF tit_acr.cod_estab = "201":U OR
                   tit_acr.cod_estab = "301":U THEN NEXT.
        
                IF tit_acr.ind_tip_espec_docto      = "Normal":U OR
                   tit_acr.ind_tip_espec_docto BEGINS "Vendor":U THEN DO:
        
                    IF  tit_acr.cod_portador <> "9905"
                    AND tit_acr.cod_portador <> "9930"
                    AND tit_acr.cod_portador <> "9915"
                    AND tit_acr.cod_portador <> "9943"
                    AND tit_acr.cod_cart_bcia <> "CSR" THEN DO: 

                        IF tit_acr.cod_espec_docto = "VE":U THEN DO:
            
                            /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                            FIND FIRST parc_vendor
                                WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                  AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.
            
                            IF AVAILABLE parc_vendor THEN
                                ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + parc_vendor.val_parc_vendor_clien.
                        END.
            
                        IF tit_acr.cod_espec_docto = "VEM":U THEN DO:
                            ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
            
                            FIND FIRST movto_tit_acr OF tit_acr
                                WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-LOCK NO-ERROR.
            
                            IF AVAILABLE movto_tit_acr THEN DO:
                                FIND FIRST histor_movto_tit_acr
                                    WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                      AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                      AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-LOCK NO-ERROR.
            
                                IF AVAILABLE histor_movto_tit_acr THEN
                                    ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
                            END.
                        END.
            
                        IF tit_acr.cod_espec_docto <> "VE":U  AND
                           tit_acr.cod_espec_docto <> "VEM":U THEN
                            ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.

                    END.
                END.
                /******************** Log de Execu‡Æo da API *********************/
                IF  l-log THEN DO:
                    IF  OPSYS = "WIN32":U THEN DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    ELSE DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    PUT UNFORMATTED STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP
                                    "Parƒmetros retornados:" SKIP
                                    " emitente.nome-matriz:   " emitente.nome-matriz  SKIP
                                    " - bf-emitente.cod-emitente:   " bf-emitente.cod-emitente   SKIP
                                    " p-lim-disp-intelbras " p-lim-disp-intelbras SKIP
                                    "tit_acr.cod_tit_acr " tit_acr.cod_tit_acr SKIP.
                    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
                    OUTPUT CLOSE.
                END.
                /*****************************************************************/
    
            END.
        END.
        FOR EACH   ped-venda NO-LOCK
            WHERE  ped-venda.nome-abrev   = bf-emitente.nome-abrev
              AND (ped-venda.cod-sit-ped  = 1  /* Aberto */
               OR  ped-venda.cod-sit-ped  = 2) /* Atendido Parcial */
              AND  ped-venda.completo     = YES
              AND  ped-venda.cod-sit-aval = 3  /* Aprovado */
              AND  ped-venda.cod-priori  <> 44,
             EACH natur-oper  /** CONSISTENCIA SE GERA OU NAO FATURAMENTO **/
                WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
                  AND natur-oper.emite-duplic = YES NO-LOCK:    
            FIND cond-pagto NO-LOCK
                WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
    
            IF AVAILABLE cond-pagto           AND
               cond-pagto.cod-cond-pag <> 502 AND
               cond-pagto.cod-vencto    = 2   THEN NEXT.
    
            FIND int-cond-pagto OF cond-pagto NO-LOCK NO-ERROR.
            IF  AVAIL int-cond-pagto
            AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U  
                THEN NEXT.

            RUN pi-converte-moeda (OUTPUT d-vl-aberto).

            ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + d-vl-aberto.

            /******************** Log de Execu‡Æo da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Parƒmetros retornados:" SKIP
                                " emitente.nome-matriz:   " emitente.nome-matriz  SKIP
                                " - bf-emitente.cod-emitente:   " bf-emitente.cod-emitente   SKIP
                                " p-lim-disp-intelbras " p-lim-disp-intelbras SKIP
                                "  ped-venda.vl-liq-abe "  ped-venda.vl-liq-abe
                    
                    .
                PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-converte-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param de-valor-aberto like ped-venda.vl-liq-abe.

def var i-moeda          as integer no-undo.
def var de-fator-1       as decimal format "999999,9999" init 1 no-undo.
def var de-fator-2       like de-fator-1 init 1 no-undo.

    ASSIGN i-moeda = 0.
    
    if  avail ped-venda then do:
        if  ped-venda.mo-codigo = 0 then 
            assign de-fator-1 = 1.
        else do:
             
            find first cotacao
                where cotacao.mo-codigo   = ped-venda.mo-codigo
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-1 = cotacao.cotacao[int(day(TODAY))].
    
        end.
    
        if  i-moeda <> 0 then do:
            
            find first cotacao
                where cotacao.mo-codigo   = i-moeda
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-2 = cotacao.cotacao[int(day(TODAY))].
    
        end.
        else assign de-fator-2 = 1.
    
        assign de-valor-aberto = ped-venda.vl-liq-abe * de-fator-1 / de-fator-2.
        
    end.                          

END PROCEDURE.

